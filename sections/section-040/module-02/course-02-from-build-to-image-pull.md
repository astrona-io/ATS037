---
draft: true
exam_objectives:
  - Containerization
---
# From Build To Image Pull

A developer builds the `scout` image on a laptop, a pipeline publishes it and a node pulls it. Three different systems act, and each one can fail without the others noticing. This part follows an image through build, publication and pull, explains what the image pull policy decides, and shows how to read the common pull failures.

## Build

An image build turns source files and instructions into an image. A Dockerfile is the usual text format for those instructions. Each instruction that changes the filesystem creates a layer. The base image comes first, then the instructions that add libraries and application files, and last the default command.

A multi-stage build uses several stages in one file. An early stage has the compilers and tools and produces the application files. The last stage starts from a small base and copies in only the result. The final image then has no build tools. Save this as `Dockerfile` as an example, because the playground has no build tool:

```dockerfile
FROM golang:1.24 AS build
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /out/scout ./cmd/scout

FROM gcr.io/distroless/static:nonroot
COPY --from=build /out/scout /scout
USER nonroot
ENTRYPOINT ["/scout"]
```

The final stage copies only the binary. Smaller images transfer faster and contain fewer components, but size alone does not make an image secure. Dependencies still need patches, and the process should run as a non-root user. A secret used during a build, such as a token passed with `COPY` or `ARG`, can remain in a layer that anyone with access to the image can read.

## Publish

After a build, the image is uploaded to a registry, a service that stores and serves images. The upload names a repository and a tag, and the registry records the digest. A node cannot pull an image that exists only on a laptop. Build, publish and pull are separate steps, so a successful build says nothing about whether the node can get the image.

## Pull

When the kubelet starts a container, it asks the runtime to make the image available. The `imagePullPolicy` field of the container decides whether the runtime contacts the registry:

- `IfNotPresent` uses the image on the node when it is already there and pulls only when it is missing.
- `Always` asks the registry every time. It compares the digest and downloads only when the content changed.
- `Never` only uses an image already on the node and fails if it is missing.

When the field is not set, the default depends on the reference. A reference with the tag `latest`, or with no tag, defaults to `Always`. A reference with another tag or with a digest defaults to `IfNotPresent`.

## Observe a pull failure

Save this as `pod-courier.yaml`. The tag does not exist:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: courier
  namespace: starfleet
spec:
  containers:
    - name: courier
      image: ghcr.io/stefanprodan/podinfo:6.15.99
```

Apply it:

<!-- astrona:playground:renew -->

```sh
kubectl apply -f pod-courier.yaml
```

Then check the result after a short time:

```sh
kubectl -n starfleet get pod courier
kubectl -n starfleet describe pod courier
```

The Pod has a node, so scheduling worked. Its status moves between `ErrImagePull` and `ImagePullBackOff`. The events show the failed pull and give the reason from the registry, which says the tag was not found. The back-off is the kubelet waiting longer between retries after each failure. It is a response to the repeated error, not the cause of it.

Fix it by changing the image to a tag that exists. A Pod image can be updated in place:

```sh
kubectl -n starfleet set image pod/courier courier=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet wait --for=condition=Ready pod/courier --timeout=120s
```

The kubelet pulls the new reference, or finds it on the node, and the Pod becomes ready.

## The pull policy in action

Save this as `pod-cached.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cached
  namespace: starfleet
spec:
  containers:
    - name: cached
      image: busybox:1.37.0
      imagePullPolicy: Never
      command: ["sleep", "3600"]
```

```sh
kubectl apply -f pod-cached.yaml
kubectl -n starfleet wait --for=condition=Ready pod/cached --timeout=120s
```

The Pod runs because the image is already on the node, and `Never` forbids any download. With a reference that is not on the node, the same policy ends in the status `ErrImageNeverPull`.

## Failures to recognize

- Tag or repository not found: the registry has no such name. Check the spelling and the tag in the registry.
- Authentication failure, shown as `unauthorized` or `denied`: the registry needs credentials that the Pod did not supply.
- Registry unreachable or certificate error: the node cannot connect, or does not trust the registry certificate.
- No matching platform: the image index has no variant for the architecture of the node.

Credentials for a private registry belong in a Secret of type `kubernetes.io/dockerconfigjson`. The Pod names it in `imagePullSecrets`, or a ServiceAccount carries it for every Pod that uses the account. Credentials that the application uses inside the container do not help the kubelet pull the image. Scaling up the replicas only multiplies the failing pulls.

You now know where each stage of the path can break and which field or object fixes it.

```sh
kubectl -n starfleet delete pod courier cached
```

## Common pitfalls

> [!WARNING]
> - **Assuming a built image is available to the nodes.** An image must be published to a registry that the node can reach.
> - **Reading `ImagePullBackOff` as the cause.** It is the delay after repeated failures. The event holds the cause.
> - **Putting secrets in image layers.** Anyone who can pull the image can read every layer.
> - **Expecting `Never` to pull.** It uses only an image already on the node.
