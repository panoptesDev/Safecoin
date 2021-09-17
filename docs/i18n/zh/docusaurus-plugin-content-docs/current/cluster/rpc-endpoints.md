---
title: Panoptis 集群 RPC 端点
---

Panoptis 维护专用的 API 节点来完成 [JSON RPC](developing/clients/jsonrpc-api.md) 对每个公共集群的请求，第三方同样可以提供托管 API 节点服务。 以下为目前可用的公共 RPC 端点，推荐给每个公共集群：

## Devnet（开发者网络）

- `https://api.devnet.safecoin.org` - 单个 Panoptis 托管的 api 节点；限定频率

## Testnet（测试网）

- `https://api.testnet.safecoin.org` - 单个 Panoptis 托管的 api 节点；限定频率

## Mainnet Beta（主网 Beta）

- `https://api.mainnet-beta.safecoin.org` - Panoptis 托管的 api 节点集群，由负载平衡器支持；限定频率
- `https://solana-api.projectserum.com` - Project Serum 托管的 api 节点
