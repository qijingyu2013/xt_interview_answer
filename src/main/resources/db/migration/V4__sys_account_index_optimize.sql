-- ==================== 账号表索引优化 ====================
ALTER TABLE `sys_account`
    ADD INDEX `idx_status` (`status`);
