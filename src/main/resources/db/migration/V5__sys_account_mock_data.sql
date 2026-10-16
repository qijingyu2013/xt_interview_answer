-- ==================== 账号表模拟数据：100 个虚拟用户 ====================
INSERT IGNORE INTO `sys_account`
    (`username`, `name`, `gender`, `phone`, `password`, `role_level`, `department_id`, `status`, `is_super`, `deleted`)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 100
),
dept AS (
    SELECT id,
           ROW_NUMBER() OVER (ORDER BY id) AS rn,
           COUNT(*) OVER ()               AS cnt
    FROM `sys_department`
    WHERE `deleted` = 0
)
SELECT
    CONCAT('user', LPAD(s.n, 3, '0')),
    CONCAT(
        ELT(FLOOR(RAND() * 20) + 1,
            '赵','钱','孙','李','周','吴','郑','王','冯','陈','褚','卫','蒋','沈','韩','杨','朱','秦','尤','许'),
        ELT(FLOOR(RAND() * 20) + 1,
            '伟','芳','娜','敏','静','磊','强','军','洋','勇','艳','杰','娟','涛','明','超','秀','霞','平','丽')
    ),
    ELT(FLOOR(RAND() * 2) + 1, '男', '女'),
    CONCAT('13', LPAD(FLOOR(RAND() * 1000000000), 9, '0')),
    'e10adc3949ba59abbe56e057f20f883e',
    FLOOR(1 + RAND() * 3),
    d.id,
    IF(RAND() < 0.8, 1, 0),
    0,
    0
FROM seq s
JOIN dept d
    ON d.rn = 1 + MOD(CRC32(CONCAT('dept-', s.n)), d.cnt);
