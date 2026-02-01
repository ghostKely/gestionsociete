package com.ventetovo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;

@Controller
@RequestMapping("/inventaire")
public class InventaireController {

    @PersistenceContext
    private EntityManager entityManager;

    // =================== PAGE PRINCIPALE ===================
    @GetMapping("/pageInventaire")
    @Transactional
    public String pageInventaire(Model model) {
        try {
            // Articles pour le dropdown
            List<Object[]> articles = entityManager.createNativeQuery(
                    "SELECT id_article, code, designation FROM article ORDER BY code")
                    .getResultList();

            // Derniers inventaires
            List<Object[]> inventaires = entityManager.createNativeQuery(
                    "SELECT i.id_inventaire, i.date_inventaire, i.nbre_article, i.commentaire, " +
                            "a.code, a.designation " +
                            "FROM inventaire i " +
                            "LEFT JOIN article a ON i.id_article = a.id_article " +
                            "ORDER BY i.date_inventaire DESC LIMIT 10")
                    .getResultList();

            model.addAttribute("articles", articles);
            model.addAttribute("inventaires", inventaires);

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur de base de données");
        }

        return "stock/inventaire";
    }

    // =================== AJOUTER UN INVENTAIRE (ULTRA SIMPLE) ===================
    @PostMapping("/ajouter")
    @Transactional
    public String ajouterInventaire(
            @RequestParam("idArticle") Integer idArticle,
            @RequestParam("nbreArticle") Integer nbreArticle,
            @RequestParam(value = "commentaire", required = false) String commentaire,
            RedirectAttributes redirectAttributes) {

        try {
            // Insertion ultra simple
            String sql = "INSERT INTO inventaire (date_inventaire, id_article, nbre_article, commentaire, id_utilisateur) "
                    +
                    "VALUES (NOW(), ?, ?, ?, 1)";

            entityManager.createNativeQuery(sql)
                    .setParameter(1, idArticle)
                    .setParameter(2, nbreArticle)
                    .setParameter(3, commentaire)
                    .executeUpdate();

            redirectAttributes.addFlashAttribute("message", "Inventaire ajouté avec succès !");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }

        return "redirect:/inventaire/pageInventaire";
    }
}