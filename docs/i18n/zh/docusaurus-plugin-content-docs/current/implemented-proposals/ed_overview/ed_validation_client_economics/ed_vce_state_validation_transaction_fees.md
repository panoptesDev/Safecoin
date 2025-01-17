---
title: 状态验证交易费
---

**规则有可能发生变化。**

网络发送的每一笔交易，如果要由当前的领导者验证客户端处理并确认为全球状态交易，必须包含一笔交易费。 交易费在Panoptis经济设计中提供了许多好处，例如：

- 为验证者网络提供处理状态交易所需的CPU/GPU资源的单位补偿。
- 通过引入真实的交易成本来减少网络垃圾信息。
- 为交易市场开辟渠道，以激励验证客户端在其作为领导者的职能中收集和处理提交的交易。
- 并通过协议捕获的每笔交易的最低费用金额为网络提供潜在的长期经济稳定性，如下所述。

当前许多区块链经济体(如比特币、以太坊)，在短期内依靠基于协议的奖励来支持经济，并假设通过交易费产生的收入将在长期内支持经济，当协议衍生的奖励到期时。 为了通过基于协议的奖励和交易费创造一个可持续发展的经济，每笔交易费中固定的部分被销毁，剩余的费用将归当前处理交易的领导者所有。 一个预定的全球通货膨胀率为通过上述过程分配给验证客户端的奖励提供了来源。

交易费由网络集群根据最近的历史吞吐量来设置，参见[拥堵驱动费用](../../transaction-fees.md#congestion-driven-fees)。 每个交易费的最低价格可以根据历史gas费动态调整。 通过这种方式，协议可以使用最低费用来锁定所需的硬件利用率。 通过监控协议指定的gas使用量与期望的、目标使用量之间的关系，可以提高/降低最低费用，这反过来应该降低/提高每个区块的实际gas使用量，直到它达到目标量。 这个调整过程可以被认为是类似于比特币协议中的难度调整算法，不过在这种情况下，它是在调整最低交易费用，以引导交易处理硬件使用量达到预期水平。

如前所述，每笔交易费中都有固定比例要被销毁。 这种设计的意图是保留领导激励，在领导槽时间内包含尽可能多的交易，同时提供一个限制通货膨胀的机制，以防止 "逃税 "攻击\(即侧通道费用支付)[1](../ed_references.md)。

此外，费用销毁也可以作为分叉选择的一个考虑因素。 在 PoH 分叉有一个恶意的、审查的领导者的情况下，由于审查所损失的费用，我们希望被破坏的总费用比可比的诚实分叉要少。 如果审查领导者要补偿这些损失的协议费，他们就必须自己替换掉自己分叉的费用销毁，从而有可能降低首先进行审查的动机。
