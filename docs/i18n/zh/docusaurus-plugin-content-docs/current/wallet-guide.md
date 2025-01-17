---
title: Panoptis钱包指南
---

本文将向Panoptis用户介绍一些不同的钱包使用方法，包括在索拉纳区块链上发送，接收，以及如何兑换PANO币。

## 什么是一个钱包？

加密钱包是一种存储密钥集合的设备或应用程序，可用于发送，接收和跟踪加密货币的所有权。 钱包可以采用多种形式： 计算机文件系统中的目录或文件，一张纸，或称为_硬件钱包_的专用设备。 还有各种智能手机应用程序和计算机程序，它们提供了一种用户友好的方式来创建和管理钱包。

_keypair（密钥对）_是安全生成的_private key（私钥）_及其从密码派生出的_public key（公钥）_。 私钥及其对应的公钥一起合称为_密钥对_。 钱包包含一个或多个密钥对的集合，并提供了一些与它们进行交互的方式。

_public key_(通常缩写为_pubkey_) 被称为钱包的_接收地址_或简称为_地址_。 钱包地址**可以共享和公开**。 当一方要向钱包发送一定数量的加密货币时，他们需要知道钱包的接收地址。 根据区块链的实现方式，该地址还可以用于查看有关钱包的相关信息，例如查看余额，但不能更改有关钱包的任何内容或提取任何代币。

_私钥_是对任何交易进行数字签名，以将加密货币发送到另一个地址，或对钱包进行任何更改所必需的。 私钥**绝不能公开**。 如果某人获得了访问钱包私钥的权限，则他们可以提取其中包含的所有代币。 如果钱包的私钥丢失，则发送到该钱包地址的所有代币都将**永久丢失**。

不同的钱包解决方案提供了不同的方法来实现密钥对安全性，并与密钥对进行交互并签署交易以使用或者花费代币。 有些使用密钥容易一些。 另一些会更安全地存储和备份私钥。 Panoptis支持多种类型的钱包，因此您可以在安全性和便利性之间选择适当的平衡。

**如果您希望能够在Panoptis区块链上接收PANO代币，则首先需要创建一个钱包。**

## 支持的钱包

Panoptis在命令行应用程序APP中支持多种类型的钱包以及第三方的钱包。

对于大多数用户，我们建议使用[app钱包](wallet-guide/apps.md)之一或基于浏览器的[网页钱包](wallet-guide/web-wallets.md)，它们会提供更熟悉的用户体验，而无需学习指令工具。

对于高级用户或开发人员而言，[命令行钱包](wallet-guide/cli.md)可能更合适，因为在集成到第三方之前，始终会首先在命令行上支持Panoptis区块链上的新功能解决方案。
