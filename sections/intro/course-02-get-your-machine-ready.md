# Get Your Machine Ready

Every Playground and lab in this course runs on your own machine, in a small Kubernetes cluster. A tool called `astrona` builds the cluster, sets it up, grades your work and removes it again. This page lists the tools you need, the `astrona` commands you use every day and what to do when a start goes wrong.

## What you need

Install these tools before you start:

- **A container engine:** Docker or Podman. The cluster nodes run inside it.
- **`kind`:** runs Kubernetes inside the container engine.
- **`kubectl`:** talks to the cluster. You use it on almost every page.
- **The `astrona` command-line tool.**
- **`jq`:** reads the JSON that `kubectl` prints, so you can pick out one field.

The Playgrounds and labs also need outbound internet access while they start, because they download container images. Without it, a start fails with network errors that have nothing to do with the topic.

You do not have to check the machine by hand. Let `astrona` look at it:

```sh
astrona setup
```

The command shows each step it would take and asks before it does anything. Later, you can check your machine at any time:

```sh
astrona check
```

## The commands you use every day

Each landing page and lab page shows the exact command to copy. You use these commands in this order. First, sign in, because labs from the catalog are tied to your account:

```sh
astrona login
```

Next, start a Playground or a lab. The command looks like this, with the path of the environment at the end:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-01/playground
```

When the cluster is ready, `kubectl` already points at it. To free memory without losing your work, pause an environment and start it again later:

```sh
astrona stop <name>
astrona start <name>
```

Inside a lab, send your work for grading with `astrona submit`. The grader reads the live cluster, so your change has to work and not only look right. You can submit as many times as you like. When you are done, remove the environment:

```sh
astrona destroy <name>
```

The name is the environment name that `astrona run` prints, for example `ats-037-playground-010-01`. It is not the folder path. To see what is on your machine, run `astrona list`.

> [!WARNING]
> **Run one environment at a time.** Each Playground and lab is a whole cluster. Two at once slow your machine down, and it is easy to send a command to the wrong one. Pause or destroy the Playground before you start a lab.

## When a start goes wrong

Ask `astrona` what is wrong before you try anything else:

```sh
astrona doctor
```

It checks your machine, the configuration of the environment and the running cluster, and it tells you how to fix what it finds. If a start fails while it downloads something, check your network first. With your machine ready, you can start the first module.
