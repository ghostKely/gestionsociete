package com.ventetovo.controller;

import com.ventetovo.entity.Depot;
import com.ventetovo.entity.Utilisateur;
import com.ventetovo.entity.VUtilisateurRole;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/transfert")
public class TransfertController {

        @PersistenceContext
        private EntityManager entityManager;

        // =================== PAGE TRANSFERT ENTRE DEPOTS ===================
        @GetMapping("/transfertpage")
        @Transactional
        public String pageTransfert(Model model, HttpSession session) {
                try {
                        // 1. Récupérer le dépôt central (code DEP-ANT-01)
                        List<Object[]> depotCentralData = entityManager.createNativeQuery(
                                        "SELECT d.id_depot, d.code_depot, d.nom_depot, " +
                                                        "u.nom, u.prenom, u.email " +
                                                        "FROM depot d " +
                                                        "LEFT JOIN utilisateur u ON d.responsable_id = u.id_utilisateur "
                                                        +
                                                        "WHERE d.code_depot = 'DEP-ANT-01'")
                                        .getResultList();

                        // Créer l'objet Depot
                        Depot depotCentral = null;
                        if (!depotCentralData.isEmpty()) {
                                Object[] data = depotCentralData.get(0);
                                depotCentral = new Depot();
                                depotCentral.setId(((Number) data[0]).intValue());
                                depotCentral.setCodeDepot((String) data[1]);
                                depotCentral.setNomDepot((String) data[2]);

                                // Créer l'utilisateur responsable
                                Utilisateur responsable = new Utilisateur();
                                responsable.setNom((String) data[3]);
                                responsable.setPrenom((String) data[4]);
                                responsable.setEmail((String) data[5]);
                                depotCentral.setResponsable(responsable);
                        }

                        // 2. Récupérer tous les articles disponibles dans le dépôt central
                        List<Object[]> articles = entityManager.createNativeQuery(
                                        "SELECT DISTINCT a.id_article, a.code, a.designation, " +
                                                        "COALESCE(vs.quantite_article, 0) as quantite_disponible " +
                                                        "FROM article a " +
                                                        "LEFT JOIN vue_stock_actuel vs ON vs.id_article = a.id_article "
                                                        +
                                                        "AND vs.id_depot = :depotId " +
                                                        "WHERE COALESCE(vs.quantite_article, 0) > 0 " +
                                                        "ORDER BY a.code")
                                        .setParameter("depotId", depotCentral != null ? depotCentral.getId() : 1)
                                        .getResultList();

                        // 3. Récupérer tous les autres dépôts (sauf le central)
                        List<Object[]> depots = entityManager.createNativeQuery(
                                        "SELECT d.id_depot, d.code_depot, d.nom_depot, s.nom_site " +
                                                        "FROM depot d " +
                                                        "LEFT JOIN site s ON d.id_site = s.id_site " +
                                                        "WHERE d.code_depot != 'DEP-ANT-01' " +
                                                        "ORDER BY d.nom_depot")
                                        .getResultList();

                        // 4. Récupérer le dernier transfert
                        List<Object[]> dernierTransfert = entityManager.createNativeQuery(
                                        "SELECT t.numero_transfert, t.date_transfert, d1.nom_depot as source, " +
                                                        "d2.nom_depot as destination, a.designation, t.quantite " +
                                                        "FROM transfert_depot t " +
                                                        "JOIN depot d1 ON t.id_depot_source = d1.id_depot " +
                                                        "JOIN depot d2 ON t.id_depot_destination = d2.id_depot " +
                                                        "JOIN article a ON t.id_article = a.id_article " +
                                                        "ORDER BY t.date_transfert DESC LIMIT 1")
                                        .getResultList();

                        model.addAttribute("depotCentral", depotCentral);
                        model.addAttribute("articles", articles);
                        model.addAttribute("depots", depots);
                        model.addAttribute("dernierTransfert",
                                        !dernierTransfert.isEmpty() ? dernierTransfert.get(0) : null);

                } catch (Exception e) {
                        e.printStackTrace();
                        model.addAttribute("error", "Erreur de chargement des données: " + e.getMessage());
                }

                return "stock/transfert";
        }

        // =================== VERIFIER STOCK DANS UN DEPOT ===================
        @GetMapping("/check-stock")
        @ResponseBody
        @Transactional
        public String checkStock(
                        @RequestParam("articleId") Integer articleId,
                        @RequestParam("depotId") Integer depotId) {

                try {
                        // Vérifier la quantité disponible dans le dépôt source
                        List<Object[]> stock = entityManager.createNativeQuery(
                                        "SELECT COALESCE(SUM(quantite_article), 0) " +
                                                        "FROM vue_stock_actuel " +
                                                        "WHERE id_article = :articleId AND id_depot = :depotId")
                                        .setParameter("articleId", articleId)
                                        .setParameter("depotId", depotId)
                                        .getResultList();

                        if (!stock.isEmpty()) {
                                Number quantite = (Number) stock.get(0)[0];
                                return quantite.toString();
                        }

                        return "0";

                } catch (Exception e) {
                        e.printStackTrace();
                        return "Erreur";
                }
        }

        @PostMapping("/effectuer")
        @Transactional
        public String effectuerTransfert(
                        @RequestParam("idArticle") Integer idArticle,
                        @RequestParam("idDepotSource") Integer idDepotSource,
                        @RequestParam("idDepotDestination") Integer idDepotDestination,
                        @RequestParam("quantite") Integer quantite,
                        @RequestParam("numeroTransfert") String numeroTransfert,
                        @RequestParam(value = "commentaire", required = false) String commentaire,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {

                // CORRECTION: Récupérer l'utilisateur en tant que Utilisateur
                Utilisateur user = (Utilisateur) session.getAttribute("user");
                if (user == null) {
                        return "redirect:/user/login?id=1";
                }

                try {
                        // 4. Enregistrer le transfert
                        String insertTransfertSql = "INSERT INTO transfert_depot (numero_transfert, id_article, " +
                                        "id_depot_source, id_depot_destination, quantite, commentaire, " +
                                        "id_utilisateur, date_transfert, statut) " +
                                        "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), 'EN_COURS')";

                        entityManager.createNativeQuery(insertTransfertSql)
                                        .setParameter(1, numeroTransfert)
                                        .setParameter(2, idArticle)
                                        .setParameter(3, idDepotSource)
                                        .setParameter(4, idDepotDestination)
                                        .setParameter(5, quantite)
                                        .setParameter(6, commentaire)
                                        .setParameter(7, user.getIdUtilisateur())
                                        .executeUpdate();

                        redirectAttributes.addFlashAttribute("message",
                                        "Transfert " + numeroTransfert + " effectué avec succès !");

                } catch (Exception e) {
                        e.printStackTrace();
                        redirectAttributes.addFlashAttribute("error",
                                        "Erreur lors du transfert: " + e.getMessage());
                }

                return "redirect:/transfert/transfertpage";
        }

        // =================== HISTORIQUE DES TRANSFERTS ===================
        @GetMapping("/historique")
        @Transactional
        public String historiqueTransfert(
                        Model model,
                        @RequestParam(value = "numero", required = false) String numero,
                        @RequestParam(value = "articleId", required = false) Integer articleId,
                        @RequestParam(value = "depotSource", required = false) Integer depotSource,
                        @RequestParam(value = "depotDestination", required = false) Integer depotDestination,
                        @RequestParam(value = "dateDebut", required = false) String dateDebut,
                        @RequestParam(value = "dateFin", required = false) String dateFin) {

                try {
                        // Construire la requête dynamique
                        StringBuilder sql = new StringBuilder(
                                        "SELECT t.id_transfert, t.numero_transfert, t.date_transfert, t.quantite, " +
                                                        "t.commentaire, t.statut, " +
                                                        "a.code, a.designation, " +
                                                        "d1.nom_depot as source, d2.nom_depot as destination, " +
                                                        "u.nom, u.prenom " +
                                                        "FROM transfert_depot t " +
                                                        "JOIN article a ON t.id_article = a.id_article " +
                                                        "JOIN depot d1 ON t.id_depot_source = d1.id_depot " +
                                                        "JOIN depot d2 ON t.id_depot_destination = d2.id_depot " +
                                                        "JOIN utilisateur u ON t.id_utilisateur = u.id_utilisateur " +
                                                        "WHERE 1=1");

                        // Appliquer les filtres
                        if (numero != null && !numero.isEmpty()) {
                                sql.append(" AND t.numero_transfert LIKE '%").append(numero).append("%'");
                                model.addAttribute("numero", numero);
                        }

                        if (articleId != null && articleId > 0) {
                                sql.append(" AND t.id_article = ").append(articleId);
                                model.addAttribute("selectedArticleId", articleId);
                        }

                        if (depotSource != null && depotSource > 0) {
                                sql.append(" AND t.id_depot_source = ").append(depotSource);
                                model.addAttribute("selectedDepotSource", depotSource);
                        }

                        if (depotDestination != null && depotDestination > 0) {
                                sql.append(" AND t.id_depot_destination = ").append(depotDestination);
                                model.addAttribute("selectedDepotDestination", depotDestination);
                        }

                        if (dateDebut != null && !dateDebut.isEmpty()) {
                                sql.append(" AND DATE(t.date_transfert) >= '").append(dateDebut).append("'");
                                model.addAttribute("dateDebut", dateDebut);
                        }

                        if (dateFin != null && !dateFin.isEmpty()) {
                                sql.append(" AND DATE(t.date_transfert) <= '").append(dateFin).append("'");
                                model.addAttribute("dateFin", dateFin);
                        }

                        sql.append(" ORDER BY t.date_transfert DESC");

                        List<Object[]> transferts = entityManager.createNativeQuery(sql.toString())
                                        .getResultList();

                        // Récupérer les listes pour les filtres
                        List<Object[]> articles = entityManager.createNativeQuery(
                                        "SELECT id_article, code, designation FROM article ORDER BY code")
                                        .getResultList();

                        List<Object[]> depots = entityManager.createNativeQuery(
                                        "SELECT id_depot, code_depot, nom_depot FROM depot ORDER BY nom_depot")
                                        .getResultList();

                        model.addAttribute("transferts", transferts);
                        model.addAttribute("articles", articles);
                        model.addAttribute("depots", depots);

                } catch (Exception e) {
                        e.printStackTrace();
                        model.addAttribute("error", "Erreur de chargement de l'historique");
                }

                return "stock/transfert-historique";
        }

        // =================== ANNULER UN TRANSFERT ===================
        @GetMapping("/annuler/{id}")
        @Transactional
        public String annulerTransfert(
                        @PathVariable("id") Integer id,
                        RedirectAttributes redirectAttributes) {

                try {
                        // Récupérer les infos du transfert
                        List<Object[]> transfertInfo = entityManager.createNativeQuery(
                                        "SELECT t.numero_transfert, t.id_article, t.id_depot_source, " +
                                                        "t.id_depot_destination, t.quantite " +
                                                        "FROM transfert_depot t " +
                                                        "WHERE t.id_transfert = ? AND t.statut = 'EN_COURS'")
                                        .setParameter(1, id)
                                        .getResultList();

                        if (transfertInfo.isEmpty()) {
                                redirectAttributes.addFlashAttribute("error",
                                                "Transfert non trouvé ou déjà terminé");
                                return "redirect:/stock/transfert/historique";
                        }

                        Object[] infos = transfertInfo.get(0);
                        String numero = (String) infos[0];
                        Integer articleId = (Integer) infos[1];
                        Integer depotSource = (Integer) infos[2];
                        Integer depotDestination = (Integer) infos[3];
                        Integer quantite = (Integer) infos[4];

                        // Annuler le transfert (créer un transfert inverse)
                        String sqlInsert = "INSERT INTO transfert_depot (" +
                                        "numero_transfert, id_article, id_depot_source, id_depot_destination, " +
                                        "quantite, commentaire, id_utilisateur, date_transfert, statut) " +
                                        "VALUES (?, ?, ?, ?, ?, ?, 1, NOW(), 'ANNULE')";

                        entityManager.createNativeQuery(sqlInsert)
                                        .setParameter(1, "ANNUL-" + numero)
                                        .setParameter(2, articleId)
                                        .setParameter(3, depotDestination) // Inverse : destination devient source
                                        .setParameter(4, depotSource) // Inverse : source devient destination
                                        .setParameter(5, quantite)
                                        .setParameter(6, "Annulation du transfert " + numero)
                                        .executeUpdate();

                        // Mettre à jour le statut du transfert original
                        entityManager.createNativeQuery(
                                        "UPDATE transfert_depot SET statut = 'ANNULE' WHERE id_transfert = ?")
                                        .setParameter(1, id)
                                        .executeUpdate();

                        // Créer les mouvements de stock pour l'annulation
                        // Retour au dépôt source
                        entityManager.createNativeQuery(
                                        "INSERT INTO mouvement_stock (" +
                                                        "id_article, quantite_stock, id_methode_article, prix_article, "
                                                        +
                                                        "id_depot, date_entree_stock, mouvement_type, reference) " +
                                                        "SELECT " +
                                                        "?, ?, ma.id_methode_article, vs.prix_par_methode, " +
                                                        "?, NOW(), 'ENTREE', ? " +
                                                        "FROM vue_stock_actuel vs " +
                                                        "JOIN methode_article ma ON vs.id_methode_article = ma.id_methode_article "
                                                        +
                                                        "WHERE vs.id_article = ? AND vs.id_depot = ? " +
                                                        "LIMIT 1")
                                        .setParameter(1, articleId)
                                        .setParameter(2, quantite)
                                        .setParameter(3, depotSource)
                                        .setParameter(4, "ANNUL-" + numero)
                                        .setParameter(5, articleId)
                                        .setParameter(6, depotDestination)
                                        .executeUpdate();

                        // Sortie du dépôt destination
                        entityManager.createNativeQuery(
                                        "INSERT INTO mouvement_stock (" +
                                                        "id_article, quantite_stock, id_methode_article, prix_article, "
                                                        +
                                                        "id_depot, date_entree_stock, mouvement_type, reference) " +
                                                        "SELECT " +
                                                        "?, ?, ma.id_methode_article, vs.prix_par_methode, " +
                                                        "?, NOW(), 'SORTIE', ? " +
                                                        "FROM vue_stock_actuel vs " +
                                                        "JOIN methode_article ma ON vs.id_methode_article = ma.id_methode_article "
                                                        +
                                                        "WHERE vs.id_article = ? AND vs.id_depot = ? " +
                                                        "LIMIT 1")
                                        .setParameter(1, articleId)
                                        .setParameter(2, quantite * -1)
                                        .setParameter(3, depotDestination)
                                        .setParameter(4, "ANNUL-" + numero)
                                        .setParameter(5, articleId)
                                        .setParameter(6, depotSource)
                                        .executeUpdate();

                        redirectAttributes.addFlashAttribute("message",
                                        "Transfert " + numero + " annulé avec succès !");

                } catch (Exception e) {
                        e.printStackTrace();
                        redirectAttributes.addFlashAttribute("error",
                                        "Erreur lors de l'annulation: " + e.getMessage());
                }

                return "redirect:/stock/transfert/historique";
        }
}