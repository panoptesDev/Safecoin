---
title: Vote Account Management
---

This page describes how to set up an on-chain _vote account_. Creating a vote
account is needed if you plan to run a validator node on Panoptis.

## Create a Vote Account

A vote account can be created with the
[create-vote-account](../cli/usage.md#solana-create-vote-account) command.
The vote account can be configured when first created or after the validator is
running. All aspects of the vote account can be changed except for the
[vote account address](#vote-account-address), which is fixed for the lifetime
of the account.

### Configure an Existing Vote Account

- To change the [validator identity](#validator-identity), use
  [vote-update-validator](../cli/usage.md#solana-vote-update-validator).
- To change the [vote authority](#vote-authority), use
  [vote-authorize-voter](../cli/usage.md#solana-vote-authorize-voter).
- To change the [withdraw authority](#withdraw-authority), use
  [vote-authorize-withdrawer](../cli/usage.md#solana-vote-authorize-withdrawer).
- To change the [commission](#commission), use
  [vote-update-commission](../cli/usage.md#solana-vote-update-commission).

## Vote Account Structure

### Vote Account Address

A vote account is created at an address that is either the public key of a
keypair file, or at a derived address based on a keypair file's public key and
a seed string.

The address of a vote account is never needed to sign any transactions,
but is just used to look up the account information.

When someone wants to [delegate tokens in a stake account](../staking.md),
the delegation command is pointed at the vote account address of the validator
to whom the token-holder wants to delegate.

### Validator Identity

The _validator identity_ is a system account that is used to pay for all the
vote transaction fees submitted to the vote account.
Because the validator is expected to vote on most valid blocks it receives,
the validator identity account is frequently
(potentially multiple times per second) signing transactions and
paying fees. For this reason the validator identity keypair must be
stored as a "hot wallet" in a keypair file on the same system the validator
process is running.

Because a hot wallet is generally less secure than an offline or "cold" wallet,
the validator operator may choose to store only enough PANO on the identity
account to cover voting fees for a limited amount of time, such as a few weeks
or months. The validator identity account could be periodically topped off
from a more secure wallet.

This practice can reduce the risk of loss of funds if the validator node's
disk or file system becomes compromised or corrupted.

The validator identity is required to be provided when a vote account is created.
The validator identity can also be changed after an account is created by using
the [vote-update-validator](../cli/usage.md#solana-vote-update-validator) command.

### Vote Authority

The _vote authority_ keypair is used to sign each vote transaction the validator
node wants to submit to the cluster. This doesn't necessarily have to be unique
from the validator identity, as you will see later in this document. Because
the vote authority, like the validator identity, is signing transactions
frequently, this also must be a hot keypair on the same file system as the
validator process.

The vote authority can be set to the same address as the validator identity.
If the validator identity is also the vote authority, only one
signature per vote transaction is needed in order to both sign the vote and pay
the transaction fee. Because transaction fees on Panoptis are assessed
per-signature, having one signer instead of two will result in half the transaction
fee paid compared to setting the vote authority and validator identity to two
different accounts.

The vote authority can be set when the vote account is created. If it is not
provided, the default behavior is to assign it the same as the validator identity.
The vote authority can be changed later with the
[vote-authorize-voter](../cli/usage.md#solana-vote-authorize-voter) command.

The vote authority can be changed at most once per epoch. If the authority is
changed with [vote-authorize-voter](../cli/usage.md#solana-vote-authorize-voter),
this will not take effect until the beginning of the next epoch.
To support a smooth transition of the vote signing,
`panoptis-validator` allows the `--authorized-voter` argument to be specified
multiple times. This allows the validator process to keep voting successfully
when the network reaches an epoch boundary at which the validator's vote
authority account changes.

### Withdraw Authority

The _withdraw authority_ keypair is used to withdraw funds from a vote account
using the [withdraw-from-vote-account](../cli/usage.md#solana-withdraw-from-vote-account)
command. Any network rewards a validator earns are deposited into the vote
account and are only retrievable by signing with the withdraw authority keypair.

The withdraw authority is also required to sign any transaction to change
a vote account's [commission](#commission), and to change the validator
identity on a vote account.

Because the vote account could accrue a significant balance, consider keeping
the withdraw authority keypair in an offline/cold wallet, as it is
not needed to sign frequent transactions.

The withdraw authority can be set at vote account creation with the
`--authorized-withdrawer` option. If this is not provided, the validator
identity will be set as the withdraw authority by default.

The withdraw authority can be changed later with the
[vote-authorize-withdrawer](../cli/usage.md#solana-vote-authorize-withdrawer)
command.

### Commission

_Commission_ is the percent of network rewards earned by a validator that are
deposited into the validator's vote account. The remainder of the rewards
are distributed to all of the stake accounts delegated to that vote account,
proportional to the active stake weight of each stake account.

For example, if a vote account has a commission of 10%, for all rewards earned
by that validator in a given epoch, 10% of these rewards will be deposited into
the vote account in the first block of the following epoch. The remaining 90%
will be deposited into delegated stake accounts as immediately active stake.

A validator may choose to set a low commission to try to attract more stake
delegations as a lower commission results in a larger percentage of rewards
passed along to the delegator. As there are costs associated with setting up
and operating a validator node, a validator would ideally set a high enough
commission to at least cover their expenses.

Commission can be set upon vote account creation with the `--commission` option.
If it is not provided, it will default to 100%, which will result in all
rewards deposited in the vote account, and none passed on to any delegated
stake accounts.

Commission can also be changed later with the
[vote-update-commission](../cli/usage.md#solana-vote-update-commission) command.

When setting the commission, only integer values in the set [0-100] are accepted.
The integer represents the number of percentage points for the commission, so
creating an account with `--commission 10` will set a 10% commission.

## Key Rotation

Rotating the vote account authority keys require special handling when dealing
with a live validator.

### Vote Account Validator Identity

You will need access to the _withdraw authority_ keypair for the vote account to
change the validator identity. The follow steps assume that
`~/withdraw-authority.json` is that keypair.

1. Create the new validator identity keypair, `panoptis-keygen new -o ~/new-validator-keypair.json`.
2. Ensure that the new identity account has been funded, `panoptis transfer ~/new-validator-keypair.json 500`.
3. Run `panoptis vote-update-validator ~/vote-account-keypair.json ~/new-validator-keypair.json ~/withdraw-authority.json`
   to modify the validator identity in your vote account
4. Restart your validator with the new identity keypair for the `--identity` argument

### Vote Account Authorized Voter

The _vote authority_ keypair may only be changed at epoch boundaries and
requires some additional arguments to `panoptis-validator` for a seamless
migration.

1. Run `panoptis epoch-info`. If there is not much time remaining time in the
   current epoch, consider waiting for the next epoch to allow your validator
   plenty of time to restart and catch up.
2. Create the new vote authority keypair, `panoptis-keygen new -o ~/new-vote-authority.json`.
3. Determine the current _vote authority_ keypair by running `panoptis vote-account ~/vote-account-keypair.json`. It may be validator's
   identity account (the default) or some other keypair. The following steps
   assume that `~/validator-keypair.json` is that keypair.
4. Run `panoptis vote-authorize-voter ~/vote-account-keypair.json ~/validator-keypair.json ~/new-vote-authority.json`.
   The new vote authority is scheduled to become active starting at the next epoch.
5. `panoptis-validator` now needs to be restarted with the old and new vote
   authority keypairs, so that it can smoothly transition at the next epoch. Add
   the two arguments on restart: `--authorized-voter ~/validator-keypair.json --authorized-voter ~/new-vote-authority.json`
6. After the cluster reaches the next epoch, remove the
   `--authorized-voter ~/validator-keypair.json` argument and restart
   `panoptis-validator`, as the old vote authority keypair is no longer required.

### Vote Account Authorized Withdrawer

No special handling is required. Use the `panoptis vote-authorize-withdrawer` command as needed.
