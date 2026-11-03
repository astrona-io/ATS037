# Kubernetes Fundamentals (ATS037)

Kubernetes and Cloud Native Associate (KCNA) — Kubernetes Fundamentals, 44% of the published curriculum. This course is part of ATP008.

Each module has concept lessons with diagrams, a Playground (a small `kind` cluster on your machine) to run the commands while you read, and a graded lab. Each section ends with a capstone lab and a knowledge check, and a final knowledge check closes the course.

## Course Outline

| Section | Objective | Modules | Playgrounds | Labs | Capstone | Quiz |
| --- | --- | --- | --- | --- | --- | --- |
| 010 | Kubernetes Core Concepts | 4 | 4 | 4 | 1 | 12 questions |
| 020 | Administration | 3 | 3 | 3 | 1 | 12 questions |
| 030 | Scheduling | 2 | 2 | 2 | 1 | 12 questions |
| 040 | Containerization | 3 | 3 | 3 | 1 | 12 questions |

See [the curriculum map](CURRICULUM.md) for module outcomes. The manifest lists readings, labs and quizzes in teaching order.

## Running A Playground Or Lab

You need a container engine, `kind`, `kubectl`, `jq` and the `astrona` command-line tool. Start an environment from the repository root:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-01/playground
```

## Authoring Status

Content draft for review. The labs and Playgrounds are UNTESTED: they were built and checked with `astrona validate -c` and shell syntax checks only, without running a cluster. Run `astrona test -c <lab>` for each lab before publishing. Technical sections and the ATP008 registration remain draft until the maintainer approves publication.

## Sources And Contributions

Author references are recorded in [SOURCES.md](SOURCES.md). Report corrections through this repository’s issues. The material uses the repository license.
