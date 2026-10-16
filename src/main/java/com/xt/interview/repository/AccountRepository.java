package com.xt.interview.repository;

import com.xt.interview.entity.Account;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {
    List<Account> findByDeleted(Integer deleted);
    Optional<Account> findByIdAndDeleted(Long id, Integer deleted);
    Optional<Account> findByUsernameAndDeleted(String username, Integer deleted);
    Optional<Account> findByUsernameAndPasswordAndDeleted(String username, String password, Integer deleted);
    boolean existsByUsernameAndDeleted(String username, Integer deleted);

    /**
     * 分页查询账号，支持用户名模糊搜索、状态筛选、权限级别筛选（参数为 null 时忽略对应条件）
     */
    @Query("SELECT a FROM Account a WHERE a.deleted = 0 "
            + "AND (:username IS NULL OR a.username LIKE CONCAT('%', :username, '%')) "
            + "AND (:status IS NULL OR a.status = :status) "
            + "AND (:roleLevel IS NULL OR a.roleLevel = :roleLevel)")
    Page<Account> pageAccounts(@Param("username") String username,
                               @Param("status") Integer status,
                               @Param("roleLevel") Integer roleLevel,
                               Pageable pageable);
}
