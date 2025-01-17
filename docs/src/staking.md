---
title: Staking on Panoptis
---

_Note before reading: All references to increases in values are in absolute
terms with regards to balance of PANO.
This document makes no suggestion as to the monetary value of PANO at any time._

Staking your PANO tokens on Panoptis is the best way you can help secure the world's
highest-performing blockchain network, and
[earn rewards](implemented-proposals/staking-rewards.md) for doing so!

Panoptis is a Proof-of-Stake (PoS) network with delegations, which means that
anyone who holds PANO tokens can choose to delegate some of their PANO to one or
more validators, who process transactions and run the network.

Delegating stake is a shared-risk shared-reward financial model that may provide
returns to holders of tokens delegated for a long period.
This is achieved by aligning the financial incentives of the token-holders
(delegators) and the validators to whom they delegate.

The more stake a validator has delegated to them, the more often this validator
is chosen to write new transactions to the ledger. The more transactions
the validator writes, the more rewards they and their delegators earn.
Validators who configure their systems to be able to process more transactions
at a time not only earn proportionally more rewards for doing so, they also
keep the network running as fast and as smoothly as possible.

Validators incur costs by running and maintaining their systems, and this is
passed on to delegators in the form of a fee collected as a percentage of
rewards earned. This fee is known as a _commission_. As validators earn more
rewards the more stake is delegated to them, they may compete with one another
to offer the lowest commission for their services, in order to attract more
delegated stake.

There is a risk of loss of tokens when staking, through a process known as
_slashing_. Slashing involves the removal and destruction of a portion of a
validator's delegated stake in response to intentional malicious behavior,
such as creating invalid transactions or censoring certain types of transactions
or network participants.

If a validator is slashed, all token holders who have delegated stake to that
validator will lose a portion of their delegation. While this means an immediate
loss for the token holder, it also is a loss of future rewards for the validator
due to their reduced total delegation. More details on the slashing roadmap can
be found
[here](proposals/optimistic-confirmation-and-slashing.md#slashing-roadmap).

It is the goal of the network rewards and slashing to align both validators'
and token holders' financial incentives, which in turn help keeps the network
secure, robust and performing at its best.

## How do I stake my PANO tokens?

In order to stake tokens on Panoptis, you first will need to transfer some PANO
into a wallet that supports staking, then follow the steps or instructions
provided by the wallet to create a stake account and delegate your stake.
Different wallets will vary slightly in their process for this but the general
description is below.

#### Supported Wallets

Staking operations are supported by the following wallet solutions:

- SafeFlare.com in conjunction with a keystore file or a Ledger Nano.
  Check out our [guide to using SafeFlare](wallet-guide/solflare.md) for details.

- Panoptis command line tools can perform all stake operations in conjunction
  with a CLI-generated keypair file wallet, a paper wallet, or with a connected
  Ledger Nano.
  [Staking commands using the Panoptis Command Line Tools](cli/delegate-stake.md).

#### Create a Stake Account

A stake account is a different type of account from a wallet address
that is used to simply send and receive PANO tokens to other addresses. If you
have received PANO in a wallet address you control, you can use some of
these tokens to create and fund a new stake account, which will have a different
address than the wallet you used to create it.
Depending on which wallet you are using the steps to create a stake account
may vary slightly. Not all wallets support stake accounts, see
[Supported Wallets](#supported-wallets).

#### Select a Validator

After a stake account is created, you will likely want to delegate the PANO
to a validator node. Below are a few places where you can get information about
the validators who are currently participating in running the network.
The Panoptis Labs team and the Solana Foundation do not recommend any particular
validator.

The Mainnet Beta validators introduce themselves and their services on this
Panoptis Forum thread:

- https://forums.solana.com/t/validator-information-thread

The site solanabeach.io is built and maintained by one of our validators,
Staking Facilities. It provides a some high-level graphical information about
the network as a whole, as well as a list of each validator and some recent
performance statistics about each one.

- https://solanabeach.io

To view block production statistics, use the Panoptis command-line tools:

- `panoptis validators`
- `panoptis block-production`

The Panoptis team does not make recommendations on how to interpret this
information. Potential delegators should do their own due diligence.

#### Delegate your Stake

Once you have decided to which validator or validators you will delegate, use
a supported wallet to delegate your stake account to the validator's vote
account address.

## Stake Account Details

For more information about the operations and permissions associated with a
stake account, please see [Stake Accounts](staking/stake-accounts.md)
