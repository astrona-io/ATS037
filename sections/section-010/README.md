---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Section 010: Kubernetes Core Concepts

This section covers the Kubernetes Core Concepts objective of the Kubernetes and Cloud Native Associate (KCNA) exam. Each module has a reading, a Playground that you can use while you read, and a graded lab. A capstone lab combines the modules, and a knowledge check closes the section.

## What You Will Master

- Identify the control plane components and their responsibilities.
- Distinguish node agents from cluster controllers.
- Trace a workload request from storage to container execution.
- Explain how reconciliation restores a declared replica count.
- Read the purpose of an object's API version, kind, metadata and specification.
- Distinguish namespaced resources from cluster resources.
- Explain labels, selectors and annotations.
- Identify owner relationships and object identity.
- Explain which resources containers share inside a Pod.
- Distinguish Pod phases from container states and waiting reasons.
- Compare readiness, liveness and startup probes.
- Distinguish a container restart from Pod replacement.
- Choose Deployment, StatefulSet or DaemonSet for a workload.
- Explain the Deployment and ReplicaSet relationship.
- Compare a Job with a CronJob.
- Identify what controllers do and what application logic must still do.

## The Learning Path

### 1. Cluster Architecture
* **Module reader:** [Module 1: Cluster Architecture](./module-01/course.md)
* **Playground:** `sections/section-010/module-01/playground`. A kind cluster (Kubernetes 1.35) with one control plane node and one worker node, and the Starfleet workloads (`scout`, `probe`, `shuttle` in `starfleet`; `drifter` in `outpost`).
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-01/playground
  ```
* **Graded lab:** Cluster Architecture Lab, `sections/section-010/module-01/labs/lab-01`. The cluster starts with one control plane node, one worker node and the Starfleet workloads. The learner maps the control plane components to their Pods, scales a Deployment and records the node of a Pod.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-01/labs/lab-01
  astrona submit -c .
  ```

### 2. Kubernetes API And Resources
* **Module reader:** [Module 2: Kubernetes API And Resources](./module-02/course.md)
* **Playground:** `sections/section-010/module-02/playground`. A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads and a ConfigMap `crew-notes` that carries an annotation.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-02/playground
  ```
* **Graded lab:** Kubernetes API And Resources Lab, `sections/section-010/module-02/labs/lab-01`. A `bridge` Deployment runs in `starfleet` behind a Service whose selector does not match its Pods. The learner fixes the selector, adds a Pod label and an annotation, and records API facts.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-02/labs/lab-01
  astrona submit -c .
  ```

### 3. Pods And Their Lifecycle
* **Module reader:** [Module 3: Pods And Their Lifecycle](./module-03/course.md)
* **Playground:** `sections/section-010/module-03/playground`. A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads and three Pods: `relay` (two containers share an emptyDir), `crashy` (restarts in a loop) and `once` (runs to completion).
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-03/playground
  ```
* **Graded lab:** Pods And Their Lifecycle Lab, `sections/section-010/module-03/labs/lab-01`. A `beacon` Deployment has a wrong liveness path and a wrong readiness port. The learner fixes the probes, adds a startup probe and builds a two-container Pod that shares an emptyDir volume.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-03/labs/lab-01
  astrona submit -c .
  ```

### 4. Workload Controllers
* **Module reader:** [Module 4: Workload Controllers](./module-04/course.md)
* **Playground:** `sections/section-010/module-04/playground`. A two-node kind cluster (one control plane node, one worker, Kubernetes 1.35) with the Starfleet workloads, a Job `survey` and a CronJob `sweep` that runs every minute.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-04/playground
  ```
* **Graded lab:** Workload Controllers Lab, `sections/section-010/module-04/labs/lab-01`. A `hangar` Deployment uses the Recreate strategy. The learner switches it to a rolling update, then creates a DaemonSet that also runs on the control plane node, a CronJob that forbids overlap and a Job with two completions.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-04/labs/lab-01
  astrona submit -c .
  ```

### Section capstone
* **Capstone lab:** Core Concepts Capstone, `sections/section-010/capstone/labs/lab-01`. A Pod `stalled` never becomes ready. The learner creates a Deployment, records its owner chain, repairs the Pod, and adds a DaemonSet and a CronJob.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/capstone/labs/lab-01
  astrona submit -c .
  ```

---

## Ready For Assessment?

* Take the Section 010 knowledge check: `sections/section-010/quiz.yaml`. It has 12 single-choice questions and a pass score of 70 percent.
* The question bank `sections/section-010/questions.yaml` holds the original reading questions with explanations.

All labs are UNTESTED: they were built without running them. Run `astrona test -c <lab>` before publishing.
