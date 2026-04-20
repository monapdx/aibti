# CVLE · 技术导师 - 5 Cases

> 人格：**CVLE (Concrete + Verbose + Collaborative + Execute)** · 技术导师 🎓 · *"陪你一步步来"*
>
> 核心特征：贴完整代码 + 协作温和语气 + "我们/一起/一步步" + 要结果落地。

---

### Case 1: 日常工作（带新人的 mentor 模式）
**场景**：团队新同学第一次接手 Spring Boot 登录接口，导师边带边改。

**Prompt**:
```
嗨，你别急，我们一起把这个登录接口走通，我来带你一步步改，边改边讲，你跟着节奏走就行。

下面是新人写的当前版本（完整贴上来方便你看上下文）：

// AuthController.java
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private UserMapper userMapper;

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody LoginReq req) {
        User u = userMapper.selectByUsername(req.getUsername());
        Map<String, Object> r = new HashMap<>();
        if (u != null && u.getPassword().equals(req.getPassword())) {
            r.put("code", 0);
            r.put("token", UUID.randomUUID().toString());
        } else {
            r.put("code", 1);
            r.put("msg", "用户名或密码错误");
        }
        return r;
    }
}

// LoginReq.java
public class LoginReq {
    private String username;
    private String password;
    // getter/setter 省略
}

我们的目标是让它达到生产可用：
1. 密码 BCrypt 而不是明文比对
2. 返回统一 ApiResponse<T> 而不是裸 Map
3. Token 换成 JWT，有效期 2 小时
4. Controller 不直接操作 Mapper，抽出 AuthService

你先别一次改完，我们先从第 1 步开始——把 BCrypt 引进来，我来给你贴完整的 AuthServiceImpl 骨架，你在这个基础上补 register 方法，写完我们再一起跑一遍单测看结果，哈？
```

**四维判定**：
- A/C: **C**（直接贴完整 Controller + 4 条具体目标）
- M/V: **V**（Verbose，讲清楚每一步的 why + 铺垫上下文）
- D/L: **L**（Collaborative，"我们一起"、"我来带你"、征求"哈？"）
- X/E: **E**（Execute，目标明确：生产可用 + 跑单测验证）
- **最终代码**: **CVLE**

**为什么典型**：和 CVDE 甲方爸爸区别在语气——CVDE 会说"按这 4 条改，今天下班前给我"；和 AVLE 架构布道士区别在抽象度——AVLE 会讲"认证是横切关注点应当用责任链"而不贴代码；和 CMLE 结对搭子区别在篇幅——CMLE 只会来一句"先把 BCrypt 加上跑一下"，不会写 200 字带教。

---

### Case 2: 压力/紧迫（紧急 pair 但仍温和）
**场景**：生产发版前 30 分钟，Redis 连接池耗尽报警，和新同学 pair 着快速定位。

**Prompt**:
```
别慌别慌，我们还有 30 分钟，来，我陪你一起快速排查，你跟着我的节奏一步步来，我们肯定能按时发出去。

现在现象是这样的：线上 5 分钟前开始报 JedisConnectionException: Could not get a resource from the pool，QPS 没变化，但 /api/order/query 接口 P99 从 80ms 飙到 3000ms。

我先把关键配置贴给你看，你不用先读完，跟着我走：

# application.yml
spring:
  redis:
    host: prod-redis.internal
    port: 6379
    timeout: 2000ms
    lettuce:
      pool:
        max-active: 8     # <- 这里是重点，我们一会儿看
        max-idle: 8
        min-idle: 0
        max-wait: 1000ms

// OrderQueryService.java 关键片段
public OrderVO query(Long id) {
    String key = "order:" + id;
    String cached = stringRedisTemplate.opsForValue().get(key);
    if (cached != null) return JSON.parseObject(cached, OrderVO.class);
    OrderVO vo = orderMapper.selectDetail(id);
    stringRedisTemplate.opsForValue().set(key, JSON.toJSONString(vo), 5, TimeUnit.MINUTES);
    // ↑ 发现没？这里没给 vo==null 做任何处理，我们一会儿聊
    return vo;
}

我们分三步：
第一步（你来做，2 分钟）：arthas attach 到进程，dashboard 看当前 lettuce 线程池状态，截图发我；
第二步（我来）：我对照 grafana 看连接数曲线和慢查询；
第三步（一起）：确认是 max-active=8 太小还是有慢查询占着连接不释放，再决定改参数还是回滚。

走，先开 arthas，有任何报错立刻贴给我，我们一起看，别自己闷头搞。
```

**四维判定**：
- A/C: **C**（具体配置 + 具体代码片段 + 具体指标数值）
- M/V: **V**（铺设背景 + 讲清三步分工，200 字以上）
- D/L: **L**（"别慌"、"我陪你"、"我们肯定能"、分工而非命令）
- X/E: **E**（30 分钟硬 deadline + 改参数/回滚二选一的落地动作）
- **最终代码**: **CVLE**

**为什么典型**：CVDE 会说"立刻 arthas 看池子，2 分钟给我结果"；AVLE 会说"连接池是资源有界性问题，本质是 Little's Law"；CMLE 会一句"先 arthas dashboard"就完——CVLE 紧迫但仍铺上下文、仍"一起"、仍给心理支撑。

---

### Case 3: 开放讨论/创意（理论+实践边讨论边推进）
**场景**：和团队同学一起设计"抽奖系统去重键"，边聊边出方案。

**Prompt**:
```
来，我们一起琢磨一下抽奖系统的"用户每日只能抽一次"这个去重怎么做最稳，不急着下结论，我把几个思路的代码都给你写出来，我们对比着聊。

背景：日活 50w，活动高峰 QPS 8000，抽奖服务 6 个实例，用 Redis Cluster + MySQL。

方案 A：Redis SETNX + 过期到次日零点
public boolean tryDraw(Long userId) {
    String key = "draw:" + userId + ":" + LocalDate.now();
    long ttl = Duration.between(LocalDateTime.now(), LocalDate.now().plusDays(1).atStartOfDay()).getSeconds();
    Boolean ok = stringRedisTemplate.opsForValue().setIfAbsent(key, "1", ttl, TimeUnit.SECONDS);
    return Boolean.TRUE.equals(ok);
}
// 优点：原子、快；缺点：Redis 挂了会漏（或重）

方案 B：MySQL 唯一索引兜底
CREATE UNIQUE INDEX uk_user_day ON draw_record(user_id, draw_day);
// INSERT 冲突即重复，强一致；缺点：热点行，8000 QPS 下可能死锁

方案 C：A + B 组合——Redis 先挡，MySQL 唯一索引做最终一致
public DrawResult draw(Long userId) {
    if (!tryDrawRedis(userId)) return DrawResult.duplicate();
    try {
        drawRecordMapper.insert(new DrawRecord(userId, LocalDate.now()));
    } catch (DuplicateKeyException e) {
        return DrawResult.duplicate();
    }
    return doDraw(userId);
}

我个人倾向 C，但我想听你的——你觉得方案 A 那个"Redis 挂了漏掉"的风险，在我们这个业务里能不能接受？如果不能接受，我们是不是还要考虑 B 里死锁的退让？

我们不用现在就定，你先说你的第一反应，我们一起往下推。说错了也没事，边聊边改。
```

**四维判定**：
- A/C: **C**（三个方案全部贴可运行代码 + 具体 QPS/日活数字）
- M/V: **V**（背景 + 三方案优缺点 + 开放式追问，远超 200 字）
- D/L: **L**（"我们一起琢磨"、"我想听你的"、"说错也没事"）
- X/E: **E**（目标是"定一个方案"，最终要落地到 C 或其他）
- **最终代码**: **CVLE**

**为什么典型**：AVLE 只会抽象地讲"CAP 权衡 + 幂等性三层防御"不贴 SQL；CVDE 会直接"就用方案 C，明天给我 PR"；CMLE 会"A+B 组合吧，你搞"——CVLE 讨论、铺实现细节、还主动留空间给对方发声。

---

### Case 4: 失败/卡壳（耐心引导而不责备）
**场景**：新同学 Spring Cloud Gateway 改了三天路由一直 404，彻底卡住。

**Prompt**:
```
没事没事，先别着急，这类问题我刚上手那会儿也卡过整整一周，我们一起从头捋一遍，一步一步看到底是哪卡住了，你不用有压力。

你把现在的完整配置贴我看看先。根据你上面说的"/api/user/** 一直 404 但 /api/order/** 正常"，我猜几个可能方向，我们一个个排除：

1）先看路由是不是真的注册上了。你帮我跑一下：
curl http://localhost:8080/actuator/gateway/routes | jq '.[] | {id, uri, predicates}'
把输出贴我，我们看 user 那条路由在不在、uri 对不对。

2）如果路由在，我们看下游服务注册。你的 user-service 是 Nacos 还是 Eureka？贴一下：
curl http://localhost:8080/actuator/gateway/routes/user_route
以及
curl http://nacos:8848/nacos/v1/ns/instance/list?serviceName=user-service

3）如果服务注册也正常，那八成是 StripPrefix 配错了。我见过太多人栽在这上面了，不只是你一个，来看这个典型配置：

spring:
  cloud:
    gateway:
      routes:
        - id: user_route
          uri: lb://user-service
          predicates:
            - Path=/api/user/**
          filters:
            - StripPrefix=1     # <- 踩坑点：这里是 1 还是 2？取决于下游接口路径

比如你下游 UserController 写的是 @RequestMapping("/user")，那网关 /api/user/list 就要 StripPrefix=1 剥成 /user/list；如果下游是 @RequestMapping("/api/user") 那就 StripPrefix=0。

你现在下游那个 Controller 的 @RequestMapping 是什么？贴给我一行就行，我们对一下就知道了。慢慢来，不急。
```

**四维判定**：
- A/C: **C**（三条 curl + 完整 yaml + 具体 StripPrefix 数值讲解）
- M/V: **V**（长铺垫 + 分层排查 + 典型坑讲解）
- D/L: **L**（"没事没事"、"我也卡过"、"不只是你一个"、"慢慢来"）
- X/E: **E**（目标：把 404 修好，三步排查直到定位）
- **最终代码**: **CVLE**

**为什么典型**：CVDE 会说"贴 actuator 路由出来，3 分钟内"；AVLE 会谈"网关的路由匹配是一个前缀树语义"；CMLE 会"StripPrefix 看看"就完——CVLE 给情绪托底（"我也卡过"）、贴完整三层排查、不急着下结论。

---

### Case 5: 复杂多轮对话（step-by-step 推进）
**场景**：带新同学从零实现"幂等扣库存"，计划 4 轮对话逐步落地。

**Prompt**:
```
好嘞，我们今天开始做"幂等扣库存"这个任务，预计要聊 4 轮，你别急我也不赶，我们一步一步来，每一步我都把完整代码写给你，你跟着在本地跑，遇到任何报错立刻贴我们一起看。

整体路线图，你先心里有个数：
- 第 1 轮（今天）：搭骨架——建表 + Entity + Mapper + Service 接口 + 空实现
- 第 2 轮（明天）：核心逻辑——乐观锁扣减 + 失败重试 3 次
- 第 3 轮（后天）：幂等——requestId 防重 + Redis 分布式锁兜底
- 第 4 轮（周五）：压测 + 故障注入（Redis 挂、DB 主从切换），我们一起看指标

现在我们开第 1 轮，你不用担心后面复杂的，先把这一轮走完。我把完整代码都贴给你：

-- 1. 建表
CREATE TABLE `stock` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sku_id` varchar(64) NOT NULL,
  `available` int NOT NULL DEFAULT 0,
  `version` int NOT NULL DEFAULT 0,
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sku` (`sku_id`)
) ENGINE=InnoDB;

// 2. Entity
@Data
@TableName("stock")
public class Stock {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String skuId;
    private Integer available;
    private Integer version;
    private LocalDateTime updatedAt;
}

// 3. Mapper（先用 MyBatis-Plus）
public interface StockMapper extends BaseMapper<Stock> {
    @Update("UPDATE stock SET available = available - #{qty}, version = version + 1 " +
            "WHERE sku_id = #{skuId} AND version = #{version} AND available >= #{qty}")
    int deductWithVersion(@Param("skuId") String skuId,
                          @Param("qty") int qty,
                          @Param("version") int version);
}

// 4. Service 接口
public interface StockService {
    /** @return true 扣减成功，false 库存不足或并发冲突（第 2 轮我们处理重试） */
    boolean deduct(String skuId, int qty, String requestId);
}

// 5. 空实现（第 1 轮就到这，第 2 轮我们填肉）
@Service
public class StockServiceImpl implements StockService {
    @Autowired private StockMapper stockMapper;

    @Override
    public boolean deduct(String skuId, int qty, String requestId) {
        // TODO 第 2 轮：查 version -> 带 version 扣减 -> 失败重试 3 次
        throw new UnsupportedOperationException("第 2 轮实现");
    }
}

你现在做三件事，做完贴结果给我，我们再开第 2 轮：
1. 本地建表，insert 一条测试数据 (sku_id='SKU001', available=100)
2. 启动服务，IDEA 里跑一下 StockMapperTest（我下面再给你测试代码骨架）
3. 把 deductWithVersion 的 SQL 在 DataGrip 里手动执行一次看能不能生效

// StockMapperTest.java
@SpringBootTest
class StockMapperTest {
    @Autowired StockMapper stockMapper;

    @Test
    void deduct_should_succeed_when_version_matches() {
        int affected = stockMapper.deductWithVersion("SKU001", 10, 0);
        assertThat(affected).isEqualTo(1);
    }
}

走，我在这等你第 1 轮结果，有任何问题随时打断我，我们不赶进度，走稳比走快重要。
```

**四维判定**：
- A/C: **C**（建表 SQL + Entity + Mapper + Service + Test 五段完整代码）
- M/V: **V**（4 轮路线图 + 本轮详细铺陈，明显 Verbose）
- D/L: **L**（"我们一步一步"、"随时打断我"、"走稳比走快重要"）
- X/E: **E**（明确 4 轮交付物，本轮三个验证动作要结果）
- **最终代码**: **CVLE**

**为什么典型**：CVDE 会"4 轮任务拆完，周五压测给我结果"不讲过程；AVLE 会讲"库存扣减的本质是分布式计数器的 CRDT 建模"不贴 SQL；CMLE 一轮就搞定不需要排期——CVLE 的典型恰恰是**长程带教 + 每轮贴完整代码 + 协作式分工**。
