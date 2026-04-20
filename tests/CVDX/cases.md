# CVDX · 技术侦察兵 - 5 Cases

> 代码：CVDX (Concrete + Verbose + Directive + Explore)
> Slogan：讲清战场问最优解
> 特征：贴完整上下文 / 代码 / 架构 + 问"最优方案 / 最佳实践 / 对比演进"

---

### Case 1: 日常工作 — 贴代码问优化

**场景**：业务开发中遇到一段自己写的逻辑，跑通了但总觉得不够优雅，贴出来问有没有更好的写法。

**Prompt**:
```
我在做一个订单导出的接口，大概逻辑是从 MySQL 查当天所有订单（约 5w 条），然后逐条调用用户中心的 RPC 拿用户昵称，再组装成 Excel 返给前端。当前代码大致是这样：

@GetMapping("/export")
public void export(HttpServletResponse resp) {
    List<Order> orders = orderMapper.selectByDate(LocalDate.now());
    List<OrderVO> vos = new ArrayList<>();
    for (Order o : orders) {
        UserDTO u = userRpc.getById(o.getUserId());   // 单次 RPC 约 15ms
        OrderVO vo = new OrderVO();
        BeanUtils.copyProperties(o, vo);
        vo.setUserName(u.getName());
        vos.add(vo);
    }
    ExcelUtil.write(resp, vos);
}

现在线上导出一次要 12 分钟，接口直接 504。我初步想到：(1) 批量 RPC 一次传 200 个 userId；(2) 用 CompletableFuture 并发 10 路；(3) 改成流式写 Excel 避免内存爆。

想请你从"阻塞点 / 内存 / 容错 / 可观测"四个维度帮我对比这三条路线的优劣，给出最优落地方案，并且说清楚在曹操出行这种千万级订单量的项目里，业界一般是怎么做的（有没有参考过 SF/JD 的导出中心设计）？最好给一版改造后的代码骨架。
```

**四维判定**：
- **A/C: C** — 贴了具体代码、具体数据（5w 条、15ms、12 分钟、504）
- **M/V: V** — 完整业务背景 + 代码 + 三条自己的思路 + 四个维度要求，> 200 字
- **D/L: D**（稍带协作）— "最优落地方案 / 给一版代码骨架"是明确指令，但也邀请"对比业界做法"留出讨论空间
- **X/E: X** — 核心在"对比三条路线 / 有没有更好的 / 业界怎么做"，探索多方案
- **最终代码**：CVDX

**为什么典型**：
- vs **CVDE 甲方爸爸**：CVDE 会说"给我改成异步批量，2 小时内交代码"，只要结果；CVDX 明确要**对比优劣**，关心"为什么这样最优"。
- vs **CVLX 苏格拉底**：CVLX 会先问"我这样设计合理吗"，多轮追问；CVDX 直接把三条路线摆出来让你评。
- vs **AVDX 战略 PPT 家**：AVDX 会说"设计一个企业级导出中心架构"，不贴代码；CVDX 贴的是能跑的 Java 片段。

---

### Case 2: 压力 / 紧迫 — 性能优化救火

**场景**：线上接口 RT 突增，监控截图 + 代码 + JVM 参数全扔出来，要最快最准的解法。

**Prompt**:
```
紧急！线上支付回调接口 P99 从 80ms 飙到 2.8s，已经持续 20 分钟，客诉在涨。环境信息全给你：

- 接口：POST /pay/notify，QPS 峰值 1200
- 机器：8C16G × 12 台，JDK 1.8，-Xmx10g -Xmn4g -XX:+UseG1GC
- DB：MySQL 8.0 主从，回调里有一次 UPDATE order SET status=? WHERE order_no=? AND status=0
- Redis：用来做幂等 key，SETNX ex 600
- Arthas trace 看到 90% 时间卡在 updateOrderStatus，DB CPU 只有 30%，但 innodb_row_lock_time_avg 从 2ms 涨到 900ms
- 慢日志抓到：同一个 order_no 在 5s 内被 update 了 40+ 次（上游重试风暴）
- GC 正常，YGC 200ms 一次没有 FGC

我现在能想到的：(1) 回调入口加 Redis 分布式锁把同 order_no 串行化；(2) 改成 INSERT ... ON DUPLICATE KEY 用唯一索引挡重复；(3) 让上游降频。

帮我判断根因到底是行锁冲突还是重试风暴，并且在"30 分钟内能上线止血"这个约束下，给出最优方案排序（含回滚预案）。顺便对比一下如果用 Kafka 单分区串行消费这种异步化方案，在我这场景里是不是过度设计。
```

**四维判定**：
- **A/C: C** — QPS / RT / JVM / SQL / Arthas 数据全是具体值
- **M/V: V** — 环境 + 现象 + 自己的三条方案 + 约束条件，一口气铺开
- **D/L: D** — "判断根因 / 给出最优方案排序 / 含回滚预案"是硬指令
- **X/E: X** — "最优方案排序 + 对比 Kafka 异步化是否过度设计"，求解空间探索
- **最终代码**：CVDX

**为什么典型**：
- vs **CVDE 甲方爸爸**：CVDE 在救火时会说"立刻给我解决方案，5 分钟内"，不关心对比；CVDX 哪怕紧迫也要**排序 + 对比替代方案**。
- vs **CMDX 参谋长**：CMDX 会只说"行锁冲突，P99 飙高，30 分钟止血，给方案排序"，不会贴这么多日志；CVDX 把 Arthas trace 和慢日志原文都抄下来。
- vs **AVDX**：AVDX 救火会讨论"支付系统高可用架构演进"，CVDX 只关心这一个接口怎么止血。

---

### Case 3: 开放讨论 / 创意 — 贴架构问演进方向

**场景**：自己画的架构图已经跑了一年，现在想演进，贴出来问未来怎么走。

**Prompt**:
```
这是我们部门「智能派单」系统当前的架构（我已经把 16 个微服务画成一张图，文字版描述如下）：

入口层：
- gateway-dispatch（Spring Cloud Gateway，鉴权 + 限流）

业务层（派单核心，6 个）：
- dispatch-realtime（实时单，基于 Flink 流处理）
- dispatch-prebook（预约单，Quartz 定时扫描）
- dispatch-airport（接机单，独立匹配池）
- dispatch-carpool（拼车单，图算法匹配）
- dispatch-enterprise（企业单，白名单）
- dispatch-intercity（城际单，跨城库存）

中台层（4 个）：
- trip-core（行程聚合）
- driver-pool（司机池，Redis GEO）
- pricing-engine（计价）
- match-algo（匹配算法，Python + Java 双栈）

支撑层（5 个）：
- config-center / log-center / monitor / mq-hub / feature-flag

现状痛点：(1) 6 个派单服务各自维护一套状态机，新增业务类型要 copy 一套；(2) match-algo 的 Python 和 Java 跨语言调用走 HTTP，链路长；(3) trip-core 聚合了太多职责，已经变成事实上的单体。

我最近在看 Uber 和滴滴的技术博客，在想下一步该往哪演进，有三个方向候选：
A. 把 6 个派单服务抽象成 dispatch-core + 6 个策略插件（SPI 风格）
B. 引入 DDD 重新划分限界上下文，trip-core 拆成 4-5 个
C. match-algo 全面云原生化，用 Ray 替掉现在的跨语言 HTTP

帮我基于业界头部公司的真实实践，对这三条路线做取舍分析，最好能给出一张演进路线图（1 年、2 年、3 年），并指出哪些是"必做"、哪些是"锦上添花"。
```

**四维判定**：
- **A/C: C** — 16 个服务名、技术栈、痛点都具体
- **M/V: V** — 完整架构描述 + 痛点 + 三个候选，铺满
- **D/L: D**（带协作意味）— "取舍分析 / 演进路线图"是指令，但开放讨论氛围
- **X/E: X** — 三条路线 + 业界对标 + 必做/锦上添花，典型多选探索
- **最终代码**：CVDX

**为什么典型**：
- vs **AVDX 战略 PPT 家**：AVDX 会说"我想做出行业务的智能调度平台，未来怎么演进"，不贴服务名；CVDX 把 16 个服务一一列出来。
- vs **CVLX 苏格拉底**：CVLX 会问"我为什么会变成单体？根因是什么？"先反省；CVDX 直接摆候选方案让你评。
- vs **CVDE 甲方**：CVDE 会说"给我一份 3 年演进 PPT，下周评审"，只要交付物；CVDX 要的是"取舍分析"。

---

### Case 4: 失败 / 卡壳 — 贴完整现场问对策

**场景**：调 Flink 作业调了两天没搞定，完整现场全扔出来求对策。

**Prompt**:
```
我 Flink 作业卡了两天了，完整现场给你：

作业逻辑：从 Kafka topic「order-events」消费订单事件（约 8000 QPS），经过 KeyBy(userId).window(TumblingEvent 10s).aggregate() 做用户维度聚合，sink 到 Doris。

环境：Flink 1.17，YARN per-job，TM = 4C8G × 8 个，parallelism = 32，checkpoint interval = 60s，状态后端 RocksDB + HDFS。

故障现象：
- 前 30 分钟一切正常，backpressure = 0
- 第 31 分钟开始，某一个 subtask（固定是第 17 个）的 input buffer 打满，backpressure = HIGH
- checkpoint 开始失败，align time 从 200ms 涨到 58s，最终超时
- 重启作业后正常运行 30 分钟，又复现
- Grafana 看到第 17 个 TM 的 CPU 只有 20%，但 network in 是其他 TM 的 5 倍

我试过：
1. 把 parallelism 从 32 提到 64 — 依然是某一个 subtask 被打爆，只是换了编号
2. 加了 RocksDB 调优（-Dstate.backend.rocksdb.block.cache-size=512MB）— 无效
3. 把窗口从 10s 改成 1min — 复现时间从 30 分钟变成 90 分钟，但还是复现
4. 查了业务方，确认没有刷单，userId 分布的 top10 占比也只有 8%

我的判断：大概率是 KeyBy 之后数据倾斜 + checkpoint 反压连锁，但数据 top10 才 8% 也不算很倾斜，想不通为什么固定打爆一个 subtask。

请你基于这个现场，给出根因排查清单（按概率排序），并对每个可能根因给出验证方法和止血方案。顺便对比一下，如果直接换成 Flink 1.19 的 Adaptive Scheduler + local recovery，能不能根治这类问题，还是只是缓解。
```

**四维判定**：
- **A/C: C** — QPS / parallelism / 第 17 个 subtask / 58s / top10 8% 全是实测数
- **M/V: V** — 环境 + 现象 + 四次尝试 + 自己的判断，超详细
- **D/L: D** — "根因排查清单 / 验证方法 / 止血方案"全是指令
- **X/E: X** — "按概率排序 + 对比 1.19 Adaptive Scheduler 能否根治"，探索空间
- **最终代码**：CVDX

**为什么典型**：
- vs **CVDE 甲方**：CVDE 卡壳时会说"帮我解决，今天搞定"，不解释现场；CVDX 恨不得把每一次尝试都复盘给你看，再问方案。
- vs **CMLX 老中医**：CMLX 会只说"Flink KeyBy 倾斜，重启后还是固定一个 subtask 被打爆，排查思路？"，极简；CVDX 是 verbose 现场流。
- vs **AVLX**：AVLX 卡壳会问"流式计算选型要不要重新评估"，抽象；CVDX 只想修好这一个作业。

---

### Case 5: 复杂多轮对话 — 层层深入调研（最真实的一面）

**场景**：跨项目大规模调研，像曹操出行那种要搞清楚十几个代码库职责定位的典型场景，一次性把所有素材扔出来，明确要求分层输出。

**Prompt**:
```
我在整理我们公司出行中台的代码资产，需要你深度阅读并理解以下 14 个项目的代码结构、职责边界、对外接口，并最终产出一份可以给新人入职培训用的「架构地图」。

项目清单（都已经 clone 到本地 /workspace 下）：

【需求入口层】
1. demand-center — 需求接入统一门面，对接 C 端 APP / 小程序 / 开放平台
2. poseidon — 运营后台入口，对接 B 端商户和内部运营

【业务线层】
3. cp-order — 快车订单全生命周期（下单、改派、取消、结算）
4. aggrcall — 聚合打车（对接高德、美团等第三方运力）
5. autopilot — Robotaxi 无人车订单专线
6. intercity-biz — 城际专车业务线
7. airport-biz — 接送机业务线

【中台能力层】
8. trip-core — 行程主数据、状态机、事件总线
9. boc — 业务订单中心（BOC = Business Order Center）
10. bps — 业务流程服务（BPS = Business Process Service，基于 Activiti）
11. trip-spec — 行程规格配置中心（车型、时段、区域策略）

【支撑层】
12. support-pay — 支付通用能力
13. support-invoice — 发票通用能力
14. support-receipt — 回单通用能力

具体诉求，按以下阶段串行产出，每一阶段我会反馈后再进下一阶段：

阶段 1：请先把 14 个项目的「对外暴露 RPC / HTTP 接口清单 + 依赖的 MQ topic + 依赖的 DB 表」扫一遍，以表格形式输出，并指出哪些是重复造轮子的嫌疑点。

阶段 2：基于阶段 1 的输出，给我画出「需求层 → 业务线 → 中台 → 支撑」的调用关系图，并标注出循环依赖、反向调用（中台调业务线）这种架构坏味道。

阶段 3：对比业界头部出行公司（Uber / Didi / Grab）的中台分层实践，告诉我我们当前的分层哪些是合理的、哪些是歪的，最优目标架构应该长什么样。

阶段 4：针对歪的部分，给出最小代价重构路径，分 Q1/Q2/Q3 交付，并评估每一步的风险和回滚方案。

注意：我不要抽象讨论，每一个结论都要能指到具体的类名、方法名或 topic 名，说清楚"就是因为 trip-core.OrderStateMachine 这个类被 cp-order 和 aggrcall 各 fork 了一份，所以要收敛"这种粒度。
```

**四维判定**：
- **A/C: C** — 14 个项目名、层级、甚至示例结论（OrderStateMachine）都具体到类
- **M/V: V** — 项目清单 + 四阶段任务 + 粒度要求，典型长 prompt
- **D/L: D** — 阶段 1/2/3/4 串行产出是强指令节奏
- **X/E: X** — 阶段 3 要求对标 Uber/Didi/Grab 给"最优目标架构"，阶段 4 要"最小代价路径"，探索求最优
- **最终代码**：CVDX

**为什么典型（也是 AIBTI 用户本人最真实的一面）**：
- vs **CVDE 甲方爸爸**：CVDE 会说"帮我整理 14 个项目的架构图，周五交"，不会给分阶段节奏，也不关心对标业界；CVDX 要**边做边探、对齐业界最优**。
- vs **CVLX 苏格拉底**：CVLX 会反问"你为什么需要这份地图？新人真的看架构图吗？"；CVDX 需求已经想清楚，直接**要方案**。
- vs **AVDX 战略 PPT 家**：AVDX 会停在阶段 3（画目标架构），不 care 具体类名；CVDX 强调"指到 OrderStateMachine 这种粒度"，绝不抽象。
- vs **CMDX 参谋长**：CMDX 会极简 —「14 个项目，分 4 层，输出接口清单 → 调用图 → 对标业界 → 重构路径」一行命令；CVDX 必须把每个项目职责都写全。

这一例最能代表 CVDX 人格：**大量具体上下文 + 明确多阶段指令 + 探索业界最优解 + 拒绝抽象**。
