# CVLX · 苏格拉底码农 - 5 Cases

> Slogan: "为啥不用 X？那 Y 呢？Z 呢？"
> 特征：贴完整代码 + 不断追问（为啥不用 X / 那如果 Y / Z 呢）+ 协作探索

---

### Case 1: 日常工作（追问 best practices）
**场景**: 实现一个用户订单聚合接口，边写边追问 Java 集合处理的最佳实践。

**Prompt**:
```
我在 Spring Boot 里写一个「按用户聚合最近 30 天订单总额」的接口，现在代码是这样的：

@GetMapping("/orders/summary")
public Map<Long, BigDecimal> summary(@RequestParam List<Long> userIds) {
    List<Order> orders = orderMapper.selectByUserIdsAndDays(userIds, 30);
    Map<Long, BigDecimal> result = new HashMap<>();
    for (Order o : orders) {
        BigDecimal cur = result.getOrDefault(o.getUserId(), BigDecimal.ZERO);
        result.put(o.getUserId(), cur.add(o.getAmount()));
    }
    return result;
}

我有几个问题想跟你一起捋一下：
1. 这里我用的是 for 循环 + getOrDefault，为啥网上好多人推荐用 Stream API 的 groupingBy + reducing？真的更好吗？可读性我反而觉得 for 更直观。
2. 如果我换成 stream().collect(groupingBy(..., reducing(...)))，性能上有差别吗？BigDecimal 本身不可变，reducing 会不会产生一堆中间对象？
3. 再进一步，如果 userIds 传进来 1 万个，orders 有 50 万条，这个聚合在内存里算合适还是应该直接让 MySQL GROUP BY 算？界限在哪？
4. 返回 Map<Long, BigDecimal> 直接给前端是不是不太好？要不要包一层 DTO？

帮我一条条聊，我想搞清楚背后的道理，别只给结论。
```

**四维判定**:
- A/C: **C**（贴了完整可运行代码+真实业务字段）
- M/V: **V**（分 4 点 + "别只给结论" 要展开）
- D/L: **L**（友善协作语气，"帮我一条条聊"）
- X/E: **X**（每个点都是开放追问，没锁定方案）
- **最终代码**: CVLX

**为什么典型**: 典型 for vs Stream、内存 vs DB、DTO 包装的「为啥不用 X」三连问，协作口吻。vs CVDX：不会说"给我一个最优解"，而是"帮我捋一下"；vs CMLX：不是 3 行求救，是 200+ 字带代码深挖；vs AVLX PM：不列选项 A/B/C，而是追问原理。

---

### Case 2: 压力/紧迫（边做边追问验证）
**场景**: 线上库存超卖 P1 故障，15 分钟内要出修复方案，边改边追问锁方案选型。

**Prompt**:
```
刚被拉进线上故障群，库存超卖了，P1，15 分钟内要出修复代码给灰度。现在的扣库存代码是这样：

public boolean deduct(Long skuId, int count) {
    Stock s = stockMapper.selectById(skuId);
    if (s.getQty() < count) return false;
    stockMapper.updateQty(skuId, s.getQty() - count);
    return true;
}

明显的 check-then-act 竞态。我现在脑子里有几个方案想跟你快速过一下，你帮我判断，我边听边改：

1. 最快的改法是加 synchronized(this) 或者 synchronized(skuId.toString().intern())，这个能撑住吗？我们单机 QPS 大概 2000，多机部署 4 台。
2. 如果 synchronized 不够，那 ReentrantLock 呢？跟 synchronized 在这个场景有本质区别吗？
3. 还是说我应该直接走 SQL 乐观锁 `UPDATE stock SET qty=qty-? WHERE sku_id=? AND qty>=?`，看 affected rows？这个方案我担心 MySQL 行锁会不会拖慢？
4. Redis 分布式锁（Redisson）靠谱吗？现在引入会不会太重？
5. 如果走 Redis 预扣减 + MQ 异步落库呢？这是不是已经偏架构改造了，来不及？

现在就是快速决策，你按「能不能撑住 + 多久能上」两个维度帮我排个序，顺便告诉我每个方案的坑在哪。我这边同步改代码。
```

**四维判定**:
- A/C: **C**（贴了故障代码 + QPS + 机器数等具体上下文）
- M/V: **V**（5 个方案全列，"边听边改"要持续输出）
- D/L: **L**（"你帮我判断""我同步改"协作语气）
- X/E: **X**（5 个方案全是开放追问，没定结论）
- **最终代码**: CVLX

**为什么典型**: 紧迫场景下仍然保持「synchronized / ReentrantLock / 乐观锁 / Redis / MQ」五连追问，边做边聊。vs CVDX：CVDX 会说"直接告诉我最优解"；vs CMLX：CMLX 会"救命超卖了怎么办"三行完事；vs AVLX PM：PM 不会贴 SQL。

---

### Case 3: 开放讨论/创意（纯开放式多轮）
**场景**: 周五下午跟 AI 闲聊「新项目选 Go 还是 Java」，纯开放探索。

**Prompt**:
```
周五下午不忙，想跟你聊一个没有标准答案的问题：我们团队要启动一个新项目，一个中等规模的风控网关，QPS 预期峰值 5 万，团队 8 个人，现在全是 Java 背景。我个人最近在看 Go，有点心痒，想跟你一起头脑风暴下。

几个我自己想不清楚的点：

1. 光从语言本身看，Go 的 goroutine 在这种 IO 密集 + 规则判断的场景，真的比 Java 的虚拟线程（我们能上 JDK 21）有明显优势吗？有人说 Go 的 GMP 比 JVM 线程模型更轻，但 JDK 21 的虚拟线程不是也号称百万级？

2. 团队 8 个 Java 老手切 Go，学习成本真的像网上说的「一周上手」那么乐观？错误处理、没有泛型（1.18 之前）、GC 调优这些坑，踩过的人怎么说？

3. 生态层面，风控网关通常要接 Kafka / Redis / Nacos / Sentinel，这些中间件在 Go 里的客户端跟 Java Spring 那套比，成熟度差多少？会不会自己踩坑踩到爆？

4. 再往远一点想，如果未来要接 AI 模型做规则推理（比如接一个 ONNX 模型做反欺诈打分），Go 和 Java 哪个更容易接？

5. 你自己怎么看？先别给结论，帮我多角度展开，我想跟你来回聊几轮。
```

**四维判定**:
- A/C: **C**（QPS/团队规模/JDK 版本/中间件清单都给了）
- M/V: **V**（5 个子问题 + "多角度展开"）
- D/L: **L**（"周五下午不忙""头脑风暴""来回聊几轮"纯协作）
- X/E: **X**（"没有标准答案""先别给结论"明确探索）
- **最终代码**: CVLX

**为什么典型**: 纯开放多轮，语言 / 团队 / 生态 / 未来四个维度全开。vs CVDX：CVDX 问"Go 和 Java 哪个最适合风控网关"一锤定音；vs CMLX：CMLX 根本不会发起这种闲聊；vs AVLX PM：PM 会出「方案 A：Go，方案 B：Java」让你选，不会贴 JDK 版本。

---

### Case 4: 失败/卡壳（反复追问挖真相）← 核心
**场景**: 压测 QPS 上不去，从线程池查到 GC 查到网卡，每轮都在追问「那是不是 X / 那 Y 呢」。

**Prompt**:
```
我卡了一下午了，求你陪我一起挖下去。场景：一个 Netty + Spring Boot 的网关，单机压测目标 QPS 3 万，现在死活卡在 8000，CPU 才 40%，内存也稳，完全不科学。我给你我现在的发现和疑问，你帮我一层层逼问下去，别放过任何一个可疑点。

已有发现：
- arthas thread 看：业务线程池 200 个线程，活跃常年 30~50 个，队列空的。
- GC 日志：YGC 每 30s 一次，停顿 20ms，FGC 无。
- TCP：ss -s 看 time-wait 大概 3000，established 8000 左右。
- 下游：调 Redis P99 2ms，调下游 HTTP 服务 P99 15ms，都正常。
- netstat -s：recv buffer errors 有，但数量不大。

我现在的疑问一个接一个：

1. 线程池活跃才 30~50，那我加大线程数有用吗？还是说瓶颈根本不在这？如果加到 500 会不会反而更糟？
2. 那 Netty 的 EventLoopGroup 呢？boss/worker 我用的默认（2 * CPU = 32），是不是 worker 在瓶颈？怎么证伪？
3. CPU 40% 但 QPS 上不去，这通常意味着啥？IO 等待？锁竞争？我 jstack 看没明显的 BLOCKED。那是不是应该上 async-profiler 看 off-cpu？
4. time-wait 3000 算多吗？要不要调 net.ipv4.tcp_tw_reuse？会不会这个就是元凶？
5. 如果都不是，那会不会是网卡队列？我的机器单网卡，ethtool -l 看 combined 只开了 4 队列，是不是应该开到 16？中断亲和性要不要绑 CPU？
6. 再极端一点，会不会是 Spring 的拦截器链 / Filter 里有同步代码块我没注意到？

你帮我按「最可能 → 最不可能」排个序，然后告诉我每一步怎么证伪/证实，我照着做，做完回来再跟你对。
```

**四维判定**:
- A/C: **C**（arthas/GC 日志/netstat/ethtool 全是一线工具输出）
- M/V: **V**（6 层追问，每层都要展开证伪步骤）
- D/L: **L**（"陪我一起挖""我照着做做完回来跟你对"极度协作）
- X/E: **X**（"一层层逼问""别放过任何可疑点"纯探索）
- **最终代码**: CVLX（**核心典型用例**）

**为什么典型**: 失败场景下「线程池 → EventLoop → CPU → TCP → 网卡 → Filter」六连追问，每个都是"那 X 呢 / 那 Y 呢"的苏格拉底式对话。vs CVDX：CVDX 会"直接告诉我瓶颈在哪"；vs CMLX：CMLX 会"QPS 上不去救命"三行；vs AVLX PM：PM 根本不会看 ethtool。

---

### Case 5: 复杂多轮对话（第 N 轮仍在追问）
**场景**: 已经跟 AI 聊了 5 轮设计一个对账系统，第 6 轮继续追问幂等性的边界。

**Prompt**:
```
（接上文，我们已经聊了 5 轮，从对账系统的整体架构聊到了分库分表策略，再到 Kafka 消息幂等。现在到第 6 轮，我想继续往深了挖。）

回到你上一轮说的「消费端用 Redis SETNX + 业务主键做幂等」，我昨晚想了一晚上，有几个新问题冒出来了，你耐心跟我继续：

1. 你说的 SETNX key 用 "reconcile:" + bizId，TTL 24 小时。但如果我的对账消息会跨天补偿（T+1 跑完 T+2 又补一次），这个 TTL 就踩坑了吧？那 TTL 应该怎么定？直接 7 天？还是根据业务补偿窗口算？

2. 假设 Redis 挂了会发生什么？SETNX 失败是「当失败」还是「当成功继续执行」？我看了一些代码是直接放过，这样不就幂等失效了？那是不是应该 Redis + DB 唯一索引双保险？双保险的话 DB 唯一索引命中冲突抛异常，我是重试还是丢弃？

3. 再往上一层，如果我走 DB 唯一索引做幂等，是不是根本不需要 Redis 了？Redis 的价值在哪？只是为了减少 DB 压力？那我的对账 TPS 也就 500，DB 扛得住，是不是过度设计？

4. 还有个边界：如果一条对账消息处理到一半进程挂了（Redis SETNX 已写，DB 还没 commit），重启后重新消费会 SETNX 冲突直接跳过，这条账就永远丢了，对吗？那是不是 SETNX 应该在 DB commit 之后写？但那样并发窗口就回来了……

5. 你之前第 3 轮提到过「可以用 TCC 或者本地消息表」，我当时没细问，现在回头看，本地消息表是不是比 Redis 方案更稳？代价是啥？

按老规矩，一条条来，你觉得我哪个点想偏了直接怼回来，别客气。
```

**四维判定**:
- A/C: **C**（明确引用前 5 轮具体方案 + TPS/TTL 等参数）
- M/V: **V**（5 个新问题 + "一条条来"）
- D/L: **L**（"耐心跟我继续""别客气"协作深化）
- X/E: **X**（"哪个点想偏了直接怼回来"继续开放）
- **最终代码**: CVLX

**为什么典型**: 第 6 轮还在「那 TTL 呢 / 那 Redis 挂了呢 / 那本地消息表呢」连环追问，典型多轮深度对话。vs CVDX：CVDX 5 轮内就敲定方案了；vs CMLX：CMLX 不可能撑到第 6 轮还这么详尽；vs AVLX PM：PM 到第 6 轮早跑去画原型图了，不会深挖 SETNX 边界。
