---
draft: true
exam_objectives:
  - Scheduling
---
# Section 030: Scheduling

This section covers the Scheduling objective of the Kubernetes and Cloud Native Associate (KCNA) exam. Each module has a reading, a Playground that you can use while you read, and a graded lab. A capstone lab combines the modules, and a knowledge check closes the section.

## What You Will Master

- Explain scheduler filtering and scoring.
- Compare required placement rules with preferences.
- Distinguish node affinity from Pod affinity.
- Predict the effect of taints and tolerations.
- Explain why a resource request can leave a Pod Pending.
- Distinguish replica changes from node capacity changes.
- Explain the Horizontal Pod Autoscaler feedback loop.
- Relate placement and disruption handling to application availability.

## The Learning Path

### 1. Scheduling Decisions
* **Module reader:** [Module 1: Scheduling Decisions](./module-01/course.md)
* **Playground:** `sections/section-030/module-01/playground`. A three-node kind cluster (one control plane node, two workers, Kubernetes 1.35) with the Starfleet workloads. The control plane node carries the default taint.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-01/playground
  ```
* **Graded lab:** Scheduling Decisions Lab, `sections/section-030/module-01/labs/lab-01`. A `dockyard` Deployment needs a node label that no node has, so its Pods stay Pending. The learner labels the right node, taints the second worker and creates a Deployment that tolerates the taint and runs only there.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-01/labs/lab-01
  astrona submit -c .
  ```

### 2. Placement And Scaling
* **Module reader:** [Module 2: Placement And Scaling](./module-02/course.md)
* **Playground:** `sections/section-030/module-02/playground`. A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads and an `engine` Deployment that requests 100 millicores of CPU. No metrics server is installed.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-02/playground
  ```
* **Graded lab:** Placement And Scaling Lab, `sections/section-030/module-02/labs/lab-01`. A `cargo` Deployment requests 64 cores of CPU, so its Pods stay Pending. The learner records the evidence in a ConfigMap, fixes and scales `cargo`, and creates a HorizontalPodAutoscaler for `engine`.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-02/labs/lab-01
  astrona submit -c .
  ```

### Section capstone
* **Capstone lab:** Scheduling Capstone, `sections/section-030/capstone/labs/lab-01`. Two Deployments stay Pending: `mess` needs a node label and `hauler` requests too much CPU. The learner labels a node, reserves another with a taint, runs a Deployment on it, records the pending reason, fixes `hauler` and adds an autoscaler.
  ```bash
  astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/capstone/labs/lab-01
  astrona submit -c .
  ```

---

## Ready For Assessment?

* Take the Section 030 knowledge check: `sections/section-030/quiz.yaml`. It has 12 single-choice questions and a pass score of 70 percent.
* The question bank `sections/section-030/questions.yaml` holds the original reading questions with explanations.

All labs are UNTESTED: they were built without running them. Run `astrona test -c <lab>` before publishing.
