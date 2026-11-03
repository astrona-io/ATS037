---
draft: true
exam_objectives:
  - Containerization
---
# Section 040: Containerization

This section covers the Containerization objective of the Kubernetes and Cloud Native Associate (KCNA) exam. Each module has a reading, a Playground that you can use while you read, and a graded lab. A capstone lab combines the modules, and a knowledge check closes the section.

## What You Will Master

- Describe how namespaces and cgroups affect Linux processes.
- Compare container isolation with virtual machine isolation.
- Explain the container runtime's role.
- Distinguish the CRI from image and runtime standards.
- Explain image layers and the container writable layer.
- Distinguish a tag from a digest.
- Describe build, publication and image pull stages.
- Identify common causes of image pull failure.
- Explain command, arguments and environment settings at startup.
- Choose durable storage for application state.
- Distinguish init containers from sidecar patterns.
- Explain graceful termination and safe workload replacement.

## The Learning Path

### 1. Containers And Isolation
* **Module reader:** [Module 1: Containers And Isolation](./module-01/course.md)
* **Playground:** `sections/section-040/module-01/playground`. A single-node kind cluster (Kubernetes 1.35, containerd runtime) with the Starfleet workloads.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-01/playground
  ```
* **Graded lab:** Containers And Isolation Lab, `sections/section-040/module-01/labs/lab-01`. A `hog` Deployment is OOMKilled because its memory limit is too small. The learner fixes the limit, creates a Pod whose containers share a process namespace, and records the runtime and kernel facts of the node.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-01/labs/lab-01
  astrona submit -c .
  ```

### 2. Images And Registries
* **Module reader:** [Module 2: Images And Registries](./module-02/course.md)
* **Playground:** `sections/section-040/module-02/playground`. A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads. The workload images are preloaded on the node and no registry is installed.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-02/playground
  ```
* **Graded lab:** Images And Registries Lab, `sections/section-040/module-02/labs/lab-01`. A `courier` Deployment references an image tag that does not exist. The learner fixes the reference, creates a Pod with an explicit pull policy and records the digest of the running image.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-02/labs/lab-01
  astrona submit -c .
  ```

### 3. Container Application Design
* **Module reader:** [Module 3: Container Application Design](./module-03/course.md)
* **Playground:** `sections/section-040/module-03/playground`. A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads. The busybox and podinfo images are preloaded on the node.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-03/playground
  ```
* **Graded lab:** Container Application Design Lab, `sections/section-040/module-03/labs/lab-01`. A `broken-init` Deployment never starts because its init container fails. The learner repairs it, builds a Pod with an init container that hands a file to the application, and a Pod with a native sidecar.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-03/labs/lab-01
  astrona submit -c .
  ```

### Section capstone
* **Capstone lab:** Containerization Capstone, `sections/section-040/capstone/labs/lab-01`. Two Deployments fail: `leaky` is killed for exceeding its memory limit and `fetcher` cannot pull its image. The learner repairs both, builds a Pod with an init container, a native sidecar and an application, and records the live runtime and image digest.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/capstone/labs/lab-01
  astrona submit -c .
  ```

---

## Ready For Assessment?

* Take the Section 040 knowledge check: `sections/section-040/quiz.yaml`. It has 12 single-choice questions and a pass score of 70 percent.
* The question bank `sections/section-040/questions.yaml` holds the original reading questions with explanations.

All labs are UNTESTED: they were built without running them. Run `astrona test -c <lab>` before publishing.
