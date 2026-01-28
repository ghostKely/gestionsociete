package com.ventetovo.repository;

import com.ventetovo.entity.Inventaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InventaireRepository extends JpaRepository<Inventaire, Integer> {

    List<Inventaire> findAllByOrderByDateInventaireDesc();

    @Query(value = "SELECT * FROM inventaire ORDER BY date_inventaire DESC LIMIT :limit", nativeQuery = true)
    List<Inventaire> findTopNByOrderByDateInventaireDesc(@Param("limit") int limit);

    // SUPPRIMEZ CETTE LIGNE ou remplacez-la par une requête native
    // List<Inventaire> findByArticle_IdArticle(Integer idArticle);

    // Alternative : requête native pour chercher par id_article
    @Query(value = "SELECT * FROM inventaire WHERE id_article = :idArticle", nativeQuery = true)
    List<Inventaire> findByArticleId(@Param("idArticle") Integer idArticle);
}