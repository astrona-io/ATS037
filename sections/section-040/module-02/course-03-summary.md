---
draft: true
exam_objectives:
  - Containerization
---
# Summary

An image is a stack of read-only layers plus a configuration that says how to run it. Layers are identified by content and shared between images, so a node downloads only the layers it lacks. A running container adds one writable layer on top. Files written there are lost when the container is replaced, so data that must survive belongs in a volume.

An image reference names a registry, a repository, a tag and optionally a digest. A tag is a label that the publisher can move to different content. A digest is a hash of the image manifest and always selects the same content. The Pod status shows the digest that the runtime resolved, while the specification shows what was asked for. A reference without a tag means `latest`. A multi-platform image is an index with one entry per architecture, and a pull fails when no entry matches the node.

An image goes through three separate stages. The build turns source and instructions into layers, and a multi-stage build keeps build tools out of the final image. The publish step uploads the image to a registry. The pull step runs on the node when the kubelet starts a container. The `imagePullPolicy` field decides whether the runtime contacts the registry: `IfNotPresent` uses a local copy, `Always` checks the registry every time and `Never` uses only a local copy. The default is `Always` for `latest` or no tag and `IfNotPresent` otherwise.

Pull failures show as `ErrImagePull` and then `ImagePullBackOff`, where the back-off is only the delay between retries. The event holds the cause: a missing repository or tag, rejected credentials, an unreachable registry or a certificate problem, or a platform mismatch. Private registry credentials go into a `dockerconfigjson` Secret that the Pod or its ServiceAccount references.

Key facts:

- Tags can move. Digests cannot.
- The writable layer is not durable storage.
- Build, publish and pull fail independently.
- `ImagePullBackOff` is a delay. Read the event for the cause.

<!-- astrona:playground:destroy -->
