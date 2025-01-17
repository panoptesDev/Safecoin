---
title: Panoptis Wallet Guide
---

This document describes the different wallet options that are available to users
of Panoptis who want to be able to send, receive and interact with
PANO tokens on the Panoptis blockchain.

## What is a Wallet?

A crypto wallet is a device or application that stores a collection of keys and
can be used to send, receive,
and track ownership of cryptocurrencies. Wallets can take many forms.
A wallet might be a directory or file in your computer's file system,
a piece of paper, or a specialized device called a _hardware wallet_.
There are also various smartphone apps and computer programs
that provide a user-friendly way to create and manage wallets.

A _keypair_ is a securely generated _private key_ and its
cryptographically-derived _public key_. A private key and its corresponding
public key are together known as a _keypair_.
A wallet contains a collection of one or more keypairs and provides some means
to interact with them.

The _public key_ (commonly shortened to _pubkey_) is known as the wallet's
_receiving address_ or simply its _address_. The wallet address **may be shared
and displayed freely**. When another party is going to send some amount of
cryptocurrency to a wallet, they need to know the wallet's receiving address.
Depending on a blockchain's implementation, the address can also be used to view
certain information about a wallet, such as viewing the balance,
but has no ability to change anything about the wallet or withdraw any tokens.

The _private key_ is required to digitally sign any transactions to send
cryptocurrencies to another address or to make any changes to the wallet.
The private key **must never be shared**. If someone gains access to the
private key to a wallet, they can withdraw all the tokens it contains.
If the private key for a wallet is lost, any tokens that have been sent
to that wallet's address are **permanently lost**.

Different wallet solutions offer different approaches to keypair security and
interacting with the keypair and sign transactions to use/spend the tokens.
Some are easier to use than others.
Some store and back up private keys more securely.
Panoptis supports multiple types of wallets so you can choose the right balance
of security and convenience.

**If you want to be able to receive PANO tokens on the Panoptis blockchain,
you first will need to create a wallet.**

## Supported Wallets

Panoptis supports several types of wallets in the Panoptis native
command-line app as well as wallets from third-parties.

For the majority of users, we recommend using one of the
[app wallets](wallet-guide/apps.md) or a browser-based
[web wallet](wallet-guide/web-wallets.md), which will provide a more familiar
user experience rather than needing to learn command line tools.

For advanced users or developers, the [command-line wallets](wallet-guide/cli.md)
may be more appropriate, as new features on the Panoptis blockchain will always be
supported on the command line first before being integrated into third-party
solutions.
