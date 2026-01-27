package com.ventetovo.repository;

import com.ventetovo.entity.LigneLivraisonClient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LigneLivraisonClientRepository
        extends JpaRepository<LigneLivraisonClient, Integer> {

    List<LigneLivraisonClient> findByIdLivraison(Integer idLivraison);
}
