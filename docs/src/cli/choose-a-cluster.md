---
title: Connecting to a Cluster
---

See [Panoptis Clusters](../clusters.md) for general information about the
available clusters.

## Configure the command-line tool

You can check what cluster the Panoptis command-line tool (CLI) is currently targeting by
running the following command:

```bash
panoptis config get
```

Use `panoptis config set` command to target a particular cluster. After setting
a cluster target, any future subcommands will send/receive information from that
cluster.

For example to target the Devnet cluster, run:

```bash
panoptis config set --url https://api.devnet.panoptis.org
```

## Ensure Versions Match

Though not strictly necessary, the CLI will generally work best when its version
matches the software version running on the cluster. To get the locally-installed
CLI version, run:

```bash
panoptis --version
```

To get the cluster version, run:

```bash
panoptis cluster-version
```

Ensure the local CLI version is greater than or equal to the cluster version.
