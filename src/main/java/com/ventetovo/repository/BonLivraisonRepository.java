package com.ventetovo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.ventetovo.entity.BonLivraison;
import java.util.List;
import java.util.Optional;

@Repository
public interface BonLivraisonRepository extends JpaRepository<BonLivraison, Integer> {

    List<BonLivraison> findByIdBonCommande(Integer idBonCommande);

    List<BonLivraison> findByStatut(String statut);

    Optional<BonLivraison> findByNumeroLivraison(String numeroLivraison);
}