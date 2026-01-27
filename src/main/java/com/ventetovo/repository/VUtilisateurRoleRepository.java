package com.ventetovo.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ventetovo.entity.VUtilisateurRole;

@Repository
public interface VUtilisateurRoleRepository
        extends JpaRepository<VUtilisateurRole, Integer> {

    Optional<VUtilisateurRole> findByEmail(String email);
}
