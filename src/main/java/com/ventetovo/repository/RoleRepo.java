package com.ventetovo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ventetovo.entity.Role;

public interface RoleRepo extends JpaRepository<Role, Integer> {

}
