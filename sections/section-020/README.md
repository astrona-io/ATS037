---
draft: true
exam_objectives:
  - Administration
---
# Section 020: Administration

This section covers the Administration objective of the Kubernetes and Cloud Native Associate (KCNA) exam. Each module has a reading, a Playground that you can use while you read, and a graded lab. A capstone lab combines the modules, and a knowledge check closes the section.

## What You Will Master

- Explain how a kubeconfig context selects a cluster and identity.
- Choose resource, event or log evidence for a diagnostic question.
- Compare declarative apply with imperative operations.
- Predict how deletion interacts with workload controllers.
- Choose ConfigMap or Secret for application configuration.
- Explain how configuration changes reach a running container.
- Distinguish resource requests from limits.
- Compare ResourceQuota with LimitRange.
- Compare managed and self-managed operating responsibilities.
- Explain control plane availability and datastore recovery.
- Distinguish application availability from control plane availability.
- Describe how custom resources and Operators extend Kubernetes.

## The Learning Path

### 1. Working With A Cluster
* **Module reader:** [Module 1: Working With A Cluster](./module-01/course.md)
* **Playground:** `sections/section-020/module-01/playground`. A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads and `broken-image`, a Deployment whose image tag does not exist.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-01/playground
  ```
* **Graded lab:** Working With A Cluster Lab, `sections/section-020/module-01/labs/lab-01`. A `console` Deployment cannot pull its image and a `leftover` Deployment must be deleted without deleting its Pods. The learner records the evidence in a ConfigMap, fixes the image and deletes with the orphan mode.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-01/labs/lab-01
  astrona submit -c .
  ```

### 2. Configuration And Resource Management
* **Module reader:** [Module 2: Configuration And Resource Management](./module-02/course.md)
* **Playground:** `sections/section-020/module-02/playground`. A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads, a ConfigMap `crew-settings` and a Secret `crew-key`.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-02/playground
  ```
* **Graded lab:** Configuration And Resource Management Lab, `sections/section-020/module-02/labs/lab-01`. A `ballast` Deployment has no resource settings. The learner creates a ConfigMap and a Secret, delivers them to a Pod as a variable and as files, sets requests and a limit on `ballast`, and creates a namespace quota.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-02/labs/lab-01
  astrona submit -c .
  ```

### 3. Operating Kubernetes
* **Module reader:** [Module 3: Operating Kubernetes](./module-03/course.md)
* **Playground:** `sections/section-020/module-03/playground`. A two-node kind cluster (one control plane node, one worker, Kubernetes 1.35) with the Starfleet workloads, the `convoy` Deployment and a `Mission` CustomResourceDefinition.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-03/playground
  ```
* **Graded lab:** Operating Kubernetes Lab, `sections/section-020/module-03/labs/lab-01`. The worker node needs maintenance. The learner protects the `convoy` Deployment with a PodDisruptionBudget, cordons the worker node and creates a custom resource from an installed CustomResourceDefinition.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-03/labs/lab-01
  astrona submit -c .
  ```

### Section capstone
* **Capstone lab:** Administration Capstone, `sections/section-020/capstone/labs/lab-01`. A Deployment `uplink` cannot pull its image. The learner repairs it, configures a Pod from a ConfigMap, sets resources, creates a quota and a PodDisruptionBudget, and cordons the worker node.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/capstone/labs/lab-01
  astrona submit -c .
  ```

---

## Ready For Assessment?

* Take the Section 020 knowledge check: `sections/section-020/quiz.yaml`. It has 12 single-choice questions and a pass score of 70 percent.
* The question bank `sections/section-020/questions.yaml` holds the original reading questions with explanations.

All labs are UNTESTED: they were built without running them. Run `astrona test -c <lab>` before publishing.
