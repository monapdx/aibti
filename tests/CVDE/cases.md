# CVDE · 甲方爸爸 - 5 Cases

> 完整代码/规格/需求文档 + 硬命令 + 要求结果，不商量。

---

### Case 1: 日常工作 — 贴完整代码要求重构

**场景**: 日常开发，甩一段完整业务代码过来，直接命令重构。

**Prompt**:
```
下面这段 OrderService 的代码是我们订单中心的核心类，现在职责太杂、嵌套太深、单测也不好写。按照以下硬性要求重构一版交给我，不要问我要不要，直接做：

1. 拆成 OrderValidator / OrderPriceCalculator / OrderRepository 三个类，OrderService 只负责编排；
2. 所有 if-else 超过两层的，改成早返回或策略模式；
3. BigDecimal 运算统一 setScale(2, RoundingMode.HALF_UP)；
4. 新增 Lombok @Slf4j，关键节点打 info 日志，异常打 error 带 orderId；
5. 不准改方法签名，外部调用方不能受影响。

\`\`\`java
@Service
public class OrderService {
    @Autowired private OrderMapper orderMapper;
    @Autowired private UserMapper userMapper;
    @Autowired private CouponMapper couponMapper;

    public BigDecimal createOrder(Long userId, List<Long> skuIds, Long couponId) {
        User user = userMapper.selectById(userId);
        if (user != null) {
            if (user.getStatus() == 1) {
                BigDecimal total = new BigDecimal("0");
                for (Long skuId : skuIds) {
                    Sku sku = orderMapper.selectSku(skuId);
                    if (sku != null && sku.getStock() > 0) {
                        total = total.add(sku.getPrice());
                    } else {
                        throw new RuntimeException("sku invalid");
                    }
                }
                if (couponId != null) {
                    Coupon c = couponMapper.selectById(couponId);
                    if (c != null && c.getUserId().equals(userId)) {
                        total = total.subtract(c.getAmount());
                    }
                }
                Order o = new Order();
                o.setUserId(userId);
                o.setAmount(total);
                orderMapper.insert(o);
                return total;
            }
        }
        return null;
    }
}
\`\`\`

重构完把三个类的完整代码贴回来，外加一份 5 行内的改动说明。做完给我。
```

**四维判定**:
- A/C: **C** — 贴了真实可运行的完整 Java 类，不是"一个订单服务"的抽象描述。
- M/V: **V** — 5 条硬性要求 + 完整代码块 + 结尾交付格式要求，信息密度高。
- D/L: **D** — "不要问我要不要""直接做""做完给我"，纯命令句式。
- X/E: **E** — 要的是"重构完的三个类代码 + 改动说明"，交付物明确。
- **最终代码**: CVDE

**为什么典型**:
- vs **AVDE PRD 暴君**：AVDE 会写"我要一个高内聚低耦合的订单中心架构"，不会贴这段 if-else 嵌套的真实代码；CVDE 贴的就是"这坨屎"本身。
- vs **CMDE 机枪手**：CMDE 会写"重构下面 OrderService，拆三个类，搞定"一句话完事；CVDE 会把 5 条硬性要求逐条列出来。
- vs **CVLE 导师**：CVLE 会说"我想把这段重构一下，你觉得拆三个类合理吗？我们一起看看边界在哪"；CVDE 根本不问，直接 "按这 5 条做"。

---

### Case 2: 压力/紧迫 — 上线倒计时贴完整 TODO

**场景**: 明早 10 点必须上线，把没做完的 TODO 全部甩过来。

**Prompt**:
```
明早 10 点上线支付渠道切换，现在 23:47，下面是剩下没做完的 TODO 清单和当前代码快照，你今晚全部搞定，我去眯一会儿，早上 6 点起来 code review。

必须全部完成，不要跟我说"建议先做 A 再做 B"这种废话：

[TODO-1] PaymentRouter 增加 Alipay / Wechat / UnionPay 三个分支路由，按 channelCode 分发；
[TODO-2] 所有外部调用包一层 try-catch，失败落 payment_fail_log 表（表已建好，字段见下）；
[TODO-3] 支付回调接口 /pay/callback/{channel} 加 HMAC-SHA256 验签，key 读 Nacos；
[TODO-4] 超时时间统一改 5s，当前写死 30s；
[TODO-5] 新增 PaymentMetrics 打点，Prometheus counter 名 payment_request_total{channel,status}。

当前 PaymentRouter：
\`\`\`java
@Component
public class PaymentRouter {
    @Autowired private AlipayClient alipayClient;

    public PayResult pay(PayRequest req) {
        // TODO 多渠道
        return alipayClient.pay(req);
    }
}
\`\`\`

payment_fail_log 表结构：
\`\`\`sql
CREATE TABLE payment_fail_log (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  channel VARCHAR(32) NOT NULL,
  biz_order_id VARCHAR(64) NOT NULL,
  error_code VARCHAR(64),
  error_msg VARCHAR(512),
  req_body TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_biz_order (biz_order_id)
);
\`\`\`

全部写完，给我 5 个完整类 + 1 个 mapper + 1 份变更清单。今晚搞定。
```

**四维判定**:
- A/C: **C** — 具体到 TODO 编号、表字段、Counter 名、Nacos key，全是可执行实体。
- M/V: **V** — 5 个 TODO + 代码快照 + 建表语句 + 交付清单，长且密。
- D/L: **D** — "不要跟我说建议""今晚搞定""我早上 code review"，命令 + 截止时间。
- X/E: **E** — 明确交付物"5 个完整类 + 1 个 mapper + 1 份变更清单"。
- **最终代码**: CVDE

**为什么典型**:
- vs **AVDE PRD 暴君**：AVDE 会说"我要一个支撑多渠道切换的支付网关架构，要高可用、可观测"；CVDE 直接把 5 个编号 TODO 和建表 DDL 砸过来。
- vs **CMDE 机枪手**：CMDE 只会打"多渠道支付明早上线，你搞定"；CVDE 会把每条 TODO 拆清楚、代码贴出来、交付物列死。
- vs **CVLE 导师**：CVLE 会说"时间紧，我们分下工，你先起 router 骨架我补子类？"；CVDE 是"我去眯一会儿，早上 code review"——你干，我验。

---

### Case 3: 开放讨论/创意 — 表面征求意见，实则命令

**场景**: 假装"想聊聊方案"，其实方案已经定死，要你按他说的写。

**Prompt**:
```
想跟你聊下我们用户积分系统怎么做，顺便把代码写了。

我的思路已经定了，你不用再提其他方案，按我说的实现就行：
- 表：user_point(user_id, balance, version)，乐观锁 version；
- 流水：user_point_log(id, user_id, delta, biz_type, biz_id, created_at)，insert-only；
- 服务：PointService.addPoint / deductPoint，必须在同一事务里先写流水再 update balance，乐观锁冲突重试 3 次，每次间隔 50ms；
- deductPoint 余额不足抛 InsufficientPointException，外部用 @ControllerAdvice 兜；
- 加 Redisson 分布式锁 key=point:lock:{userId}，waitTime=200ms，leaseTime=3s。

参考我这个初稿，补完就行，别改我的结构：
\`\`\`java
@Service
@RequiredArgsConstructor
public class PointService {
    private final UserPointMapper pointMapper;
    private final UserPointLogMapper logMapper;
    private final RedissonClient redisson;

    @Transactional(rollbackFor = Exception.class)
    public void addPoint(Long userId, int delta, String bizType, String bizId) {
        // TODO: 分布式锁 + 乐观锁重试 + 写流水 + update balance
    }

    @Transactional(rollbackFor = Exception.class)
    public void deductPoint(Long userId, int delta, String bizType, String bizId) {
        // TODO: 同上，余额不足抛异常
    }
}
\`\`\`

两个方法都补完，外加 InsufficientPointException 和 @ControllerAdvice 全局处理器。写完贴给我。
```

**四维判定**:
- A/C: **C** — 表结构、字段名、异常类名、锁 key、waitTime/leaseTime 全部钉死。
- M/V: **V** — 5 条规格 + 初稿代码 + 4 份交付物，展开完整。
- D/L: **D** — "你不用再提其他方案""按我说的实现""别改我的结构"，典型甲方。
- X/E: **E** — "两个方法都补完 + 异常类 + ControllerAdvice，写完贴给我"。
- **最终代码**: CVDE

**为什么典型**:
- vs **AVDE PRD 暴君**：AVDE 会开放抽象地说"我要一个稳定可靠的积分系统"；CVDE 嘴上说"聊下"，手上已经把表结构和类名都写死了。
- vs **CMDE 机枪手**：CMDE 会一句话"写个积分服务带乐观锁"完事；CVDE 非要把 5 条规格 + 初稿都贴全。
- vs **CVLE 导师**：CVLE 才是真讨论——"你觉得乐观锁 + 分布式锁是不是叠加了？有没有更简洁的方案？"；CVDE 是"别改我的结构"，这是伪讨论真命令。

---

### Case 4: 失败/卡壳 — 贴完整报错命令修好

**场景**: 代码跑报错，把完整 stacktrace + 相关代码砸过来，一句"修好"。

**Prompt**:
```
刚部署到 test33 环境，Kafka 消费者启动就炸，下面是完整堆栈 + 配置 + 消费者代码，你直接改好贴回来，不要跟我"建议排查方向"。

\`\`\`
2026-04-20 11:23:47.512 ERROR o.s.k.l.KafkaMessageListenerContainer - Consumer exception
org.apache.kafka.common.errors.SerializationException: Error deserializing key/value for partition order-paid-0 at offset 0
Caused by: com.fasterxml.jackson.databind.exc.MismatchedInputException:
  Cannot construct instance of `com.xxx.event.OrderPaidEvent` (no Creators, like default constructor, exist):
  cannot deserialize from Object value (no delegate- or property-based Creator)
  at [Source: (byte[])"{"orderId":"O202604200001","amount":99.50,"paidAt":"2026-04-20T11:23:45"}"; line: 1, column: 2]
  at com.fasterxml.jackson.databind.exc.MismatchedInputException.from(MismatchedInputException.java:59)
  at org.springframework.kafka.listener.DefaultErrorHandler.handleOtherException(DefaultErrorHandler.java:180)
\`\`\`

application.yml：
\`\`\`yaml
spring:
  kafka:
    bootstrap-servers: kafka-test33:9092
    consumer:
      group-id: order-paid-consumer
      auto-offset-reset: earliest
      key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      value-deserializer: org.springframework.kafka.support.serializer.JsonDeserializer
      properties:
        spring.json.trusted.packages: "com.xxx.event"
\`\`\`

事件类：
\`\`\`java
public class OrderPaidEvent {
    private final String orderId;
    private final BigDecimal amount;
    private final LocalDateTime paidAt;
    public OrderPaidEvent(String orderId, BigDecimal amount, LocalDateTime paidAt) {
        this.orderId = orderId; this.amount = amount; this.paidAt = paidAt;
    }
    // 只有 getter
}
\`\`\`

消费者：
\`\`\`java
@KafkaListener(topics = "order-paid", groupId = "order-paid-consumer")
public void onMessage(OrderPaidEvent evt) { log.info("paid: {}", evt.getOrderId()); }
\`\`\`

找到根因，改 OrderPaidEvent 让 Jackson 能反序列化（LocalDateTime 也要能吃 ISO 字符串），给我改完的完整类 + 必要的 config。修好。
```

**四维判定**:
- A/C: **C** — 完整 stacktrace、yml、事件类、消费者全贴，连 offset 和 topic 都有。
- M/V: **V** — 报错块 + 3 段代码 + 环境 + 修复要求，极长。
- D/L: **D** — "不要建议排查方向""改好贴回来""修好"——禁止讨论。
- X/E: **E** — 交付物钉死："改完的完整类 + 必要的 config"。
- **最终代码**: CVDE

**为什么典型**:
- vs **AVDE PRD 暴君**：AVDE 不会贴 stacktrace，只会说"我消息队列有问题，帮我看看架构哪里不对"；CVDE 连 Jackson 的行号都粘过来了。
- vs **CMDE 机枪手**：CMDE 就一句"kafka 反序列化报错，修"外加个截图；CVDE 把报错、配置、事件类、消费者都贴完整。
- vs **CVLE 导师**：CVLE 会说"我怀疑是没默认构造器导致的，你帮我验证下思路？"；CVDE 直接"找到根因，改完贴给我"——不要讨论，要结果。

---

### Case 5: 复杂多轮对话 — 不断补充细节 + 重下命令

**场景**: 需求一轮轮追加，每轮都是"那再加一条"+ 新代码片段 + 新命令。

**Prompt**:
```
[第 4 轮，前三轮你已经帮我写了 UserController + UserService + UserMapper，接着补]

现在基于你上一轮给我的 UserService，我要追加下面这些细节，全部按我说的改，不要重新设计：

追加需求：
1. registerUser 增加手机号 + 图形验证码双验证，图形验证码走 Redis key=captcha:{sessionId}，TTL 5 分钟；
2. 所有手机号字段 AES-256 加密落库，密钥从 KmsClient.getKey("user-phone-key") 拿，不要硬编码；
3. 新增 updateUserProfile(Long userId, UpdateProfileCmd cmd) 方法，cmd 字段见下；
4. 幂等：registerUser 用 phone + captchaId 做去重，5 分钟内同组合直接返回上次结果，Redis key=idem:register:{phone}:{captchaId}；
5. 所有 update 方法必须发 user-updated topic 到 Kafka，payload = {userId, updatedFields, updatedAt}。

UpdateProfileCmd：
\`\`\`java
@Data
public class UpdateProfileCmd {
    @Size(max = 32) private String nickname;
    @Pattern(regexp = "^1[3-9]\\\\d{9}$") private String phone;
    @Email private String email;
    private String avatarUrl;
    // 任意字段为 null 表示不更新
}
\`\`\`

另外，你上一轮写的这段我不满意，改掉：
\`\`\`java
public User registerUser(RegisterCmd cmd) {
    User u = new User();
    BeanUtils.copyProperties(cmd, u);
    userMapper.insert(u);
    return u;
}
\`\`\`
太裸奔了，按上面 5 条改。改完给我完整的 UserService（全部方法，不要省略号）+ 新的 UpdateProfileCmd 用法示例 + 一份变更 diff。做完给我。
```

**四维判定**:
- A/C: **C** — 具体 Redis key 格式、AES-256、KMS 调用、Kafka topic、正则全部给定。
- M/V: **V** — 5 条追加需求 + cmd 类 + 上轮代码片段 + 3 份交付物，典型长需求。
- D/L: **D** — "不要重新设计""按我说的改""太裸奔了，改掉""做完给我"。
- X/E: **E** — 交付物明确："完整 UserService + cmd 用法示例 + 变更 diff"。
- **最终代码**: CVDE

**为什么典型**:
- vs **AVDE PRD 暴君**：AVDE 每轮补的是"我还要 SLA 99.99%""要考虑未来十万 TPS"；CVDE 每轮补的是"Redis key 叫这个""正则是这个"。
- vs **CMDE 机枪手**：CMDE 多轮对话是一堆短句——"再加验证码""手机号加密""再加幂等"；CVDE 每轮都是段落级规格 + 代码块。
- vs **CVLE 导师**：CVLE 会说"我们第四轮了，要不回头看下前三轮有没有设计债？我想一起梳梳"；CVDE 只会"接着补，按我说的改，做完给我"——永远向前，永远命令。

---

> 五类场景收敛到同一指纹：**具体代码/规格 + 完整冗长 + 祈使命令 + 交付结果**。这就是甲方爸爸 CVDE。
