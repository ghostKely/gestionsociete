package com.ventetovo.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ventetovo.entity.Article;
import com.ventetovo.entity.MethodeArticle;

@Repository
public interface MethodeArticleRepository extends JpaRepository<MethodeArticle, Integer> {

   Optional<MethodeArticle> findByArticle(Article article);

}

