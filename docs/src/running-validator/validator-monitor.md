---
title: Monitoring a Validator
---

## Check Gossip

Confirm the IP address and **identity pubkey** of your validator is visible in
the gossip network by running:

```bash
panoptis-gossip spy --entrypoint devnet.safecoin.org:10015
```

## Check Your Balance

Your account balance should decrease by the transaction fee amount as your
validator submits votes, and increase after serving as the leader. Pass the
`--lamports` are to observe in finer detail:

```bash
safecoin balance --lamports
```

## Check Vote Activity

The `safecoin vote-account` command displays the recent voting activity from
your validator:

```bash
safecoin vote-account ~/vote-account-keypair.json
```

## Get Cluster Info

There are several useful JSON-RPC endpoints for monitoring your validator on the
cluster, as well as the health of the cluster:

```bash
# Similar to panoptis-gossip, you should see your validator in the list of cluster nodes
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getClusterNodes"}' http://api.devnet.safecoin.org
# If your validator is properly voting, it should appear in the list of `current` vote accounts. If staked, `stake` should be > 0
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getVoteAccounts"}' http://api.devnet.safecoin.org
# Returns the current leader schedule
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getLeaderSchedule"}' http://api.devnet.safecoin.org
# Returns info about the current epoch. slotIndex should progress on subsequent calls.
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getEpochInfo"}' http://api.devnet.safecoin.org
```
