---
title: "Deploying"
---

![SDK tools](/img/sdk-tools.svg)

As shown in the diagram above, a program author creates a program, compiles it
to an ELF shared object containing BPF bytecode, and uploads it to the Panoptis
cluster with a special _deploy_ transaction. The cluster makes it available to
clients via a _program ID_. The program ID is an _address_ specified when
deploying and is used to reference the program in subsequent transactions.

Upon a successful deployment the account that holds the program is marked
executable and its account data become permanently immutable. If any changes
are required to the program (features, patches, etc...) the new program must be
deployed to a new program ID.

The Panoptis command line interface supports deploying programs, for more
information see the [`deploy`](cli/usage.md#deploy-program) command line usage
documentation.
