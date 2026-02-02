package com.ventetovo.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ventetovo.entity.*;
import com.ventetovo.repository.*;

@Service
@Transactional
public class MethodeArticleService {

    private final ArticleRepository articleRepository;
    private final MethodeCalculStockRepository methodeRepository;
    private final MethodeArticleRepository methodeArticleRepository;

    public MethodeArticleService(
            ArticleRepository articleRepository,
            MethodeCalculStockRepository methodeRepository,
            MethodeArticleRepository methodeArticleRepository) {

        this.articleRepository = articleRepository;
        this.methodeRepository = methodeRepository;
        this.methodeArticleRepository = methodeArticleRepository;
    }

    public void saveOrUpdate(Integer articleId, Integer methodeId) {

        Article article = articleRepository.findById(articleId)
                .orElseThrow(() -> new RuntimeException("Article not found"));

        MethodeCalculStock methode = methodeRepository.findById(methodeId)
                .orElseThrow(() -> new RuntimeException("Methode not found"));

        MethodeArticle methodeArticle =
                methodeArticleRepository.findByArticle(article)
                        .orElse(new MethodeArticle());

        methodeArticle.setArticle(article);
        methodeArticle.setMethode(methode);

        methodeArticleRepository.save(methodeArticle);
    }

    public List<Article> getAllArticles() {
        return articleRepository.findAll();
    }

    public List<MethodeCalculStock> getAllMethodes() {
        return methodeRepository.findAll();
    }
}

