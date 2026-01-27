package com.ventetovo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.ventetovo.entity.FactureFournisseur;
import java.util.List;
import java.util.Optional;

@Repository
public interface FactureFournisseurRepository extends JpaRepository<FactureFournisseur, Integer> {

    Optional<FactureFournisseur> findByIdBonCommande(Integer idBonCommande);

    List<FactureFournisseur> findByStatut(String statut);

    Optional<FactureFournisseur> findByNumeroFacture(String numeroFacture);

    List<FactureFournisseur> findByDateEcheanceIsNotNull();
}