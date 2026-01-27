package com.ventetovo.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ventetovo.entity.BonLivraison;
import com.ventetovo.entity.FactureFournisseur;
import com.ventetovo.entity.Proforma;
import com.ventetovo.entity.Utilisateur;
import com.ventetovo.entity.VBonCommande;
import com.ventetovo.entity.VUtilisateurRole;

import jakarta.servlet.http.HttpSession;
import com.ventetovo.service.AchatFinanceService;
import com.ventetovo.service.ArticleService;
import com.ventetovo.service.BonCommandeService;
import com.ventetovo.service.BonLivraisonService;
import com.ventetovo.service.BonReceptionService;
import com.ventetovo.service.FactureFournisseurService;
import com.ventetovo.service.ProformaService;
import com.ventetovo.service.VBonCommandeService;

@Controller
public class AchatController {

    @Autowired
    private ArticleService articleService;

    @Autowired
    private ProformaService proformaService;

    @Autowired
    private AchatFinanceService achatFinanceService;

    @Autowired
    private BonCommandeService bonCommandeService;

    @Autowired
    private VBonCommandeService vBonCommandeService;

    @Autowired
    private FactureFournisseurService factureFournisseurService;

    @Autowired
    private BonLivraisonService bonLivraisonService;

    @Autowired
    private BonReceptionService bonReceptionService;

    @GetMapping("/achat/achat")
    public String achat(Model model) {
        model.addAttribute("articles", articleService.findAll());
        model.addAttribute("bob", "bob");
        return "achat/achat";
    }

    @GetMapping("/achat/quantite")
    public String commande(@RequestParam("idArticle") Integer idArticle, Model model) {
        model.addAttribute("idArticle", idArticle);
        // Récupérer l'article pour afficher ses informations
        articleService.findById(idArticle).ifPresent(article -> {
            model.addAttribute("article", article);
        });
        return "achat/quantite";
    }

    @PostMapping("/achat/quantite")
    public String quantite(@RequestParam("idArticle") Integer idArticle,
            @RequestParam("quantite") Integer quantite,
            Model model) {

        // Créer les proformas pour cette demande
        List<com.ventetovo.entity.Proforma> proformas = proformaService.creerProformasPourDemande(idArticle, quantite);

        if (!proformas.isEmpty()) {
            // Récupérer le token de la première proforma (toutes ont le même token)
            String tokenDemande = proformas.get(0).getTokenDemande();

            // Ajouter les informations au modèle
            model.addAttribute("proformas", proformas);
            model.addAttribute("tokenDemande", tokenDemande);
            model.addAttribute("idArticle", idArticle);
            model.addAttribute("quantite", quantite);

            // Récupérer l'article pour afficher ses informations
            articleService.findById(idArticle).ifPresent(article -> {
                model.addAttribute("article", article);
            });

            return "achat/proformas";
        } else {
            model.addAttribute("error", "Aucun prix disponible pour cet article.");
            return "achat/quantite";
        }
    }

    @GetMapping("/achat/proformas")
    public String listeProformas(@RequestParam("token") String tokenDemande, Model model) {
        List<com.ventetovo.entity.Proforma> proformas = proformaService.getProformasByToken(tokenDemande);
        model.addAttribute("proformas", proformas);
        model.addAttribute("tokenDemande", tokenDemande);

        if (!proformas.isEmpty()) {
            model.addAttribute("idArticle", proformas.get(0).getIdArticle());
            model.addAttribute("quantite", proformas.get(0).getQuantite());
        }

        return "achat/proformas";
    }

    @PostMapping("/achat/selectionner")
    public String selectionnerProforma(@RequestParam("idProforma") Integer idProforma,
            @RequestParam("tokenDemande") String tokenDemande,
            Model model) {

        // Récupérer la proforma sélectionnée
        Optional<Proforma> proformaOpt = proformaService.findById(idProforma);

        if (proformaOpt.isPresent()) {
            Proforma proforma = proformaOpt.get();

            // Récupérer le montant seuil actif
            Double montantSeuil = achatFinanceService.getMontantSeuilActif();
            Double montantProforma = proforma.getMontantTotal();

            // Déterminer le statut (validation requise ou non)
            boolean validationRequise = montantProforma > montantSeuil;

            // Ajouter les informations au modèle
            model.addAttribute("idProforma", idProforma);
            model.addAttribute("tokenDemande", tokenDemande);
            model.addAttribute("proforma", proforma);
            model.addAttribute("montantProforma", montantProforma);
            model.addAttribute("montantSeuil", montantSeuil);
            model.addAttribute("validationRequise", validationRequise);
            model.addAttribute("ecart", montantProforma - montantSeuil);

            return "achat/finance";
        } else {
            model.addAttribute("error", "Proforma introuvable.");
            return "redirect:/achat/proformas?token=" + tokenDemande;
        }
    }

    @PostMapping("/achat/validerProforma")
    public String validerProforma(@RequestParam("idProforma") Integer idProforma,
            @RequestParam("tokenDemande") String tokenDemande,
            @RequestParam(value = "confirmation", required = false) String confirmation,
            @RequestParam("emailAutorise") String emailAutorise,
            HttpSession session,
            Model model) {

        System.out.println("=== VALIDATION PROFORMA DÉBUT ===");
        System.out.println("idProforma: " + idProforma);
        System.out.println("tokenDemande: " + tokenDemande);
        System.out.println("confirmation: " + confirmation);
        System.out.println("emailAutorise: " + emailAutorise);

        // Vérifier si l'utilisateur est connecté
        Object sessionObj = session.getAttribute("utilisateur");
        System.out.println("Session object type: " + (sessionObj != null ? sessionObj.getClass().getName() : "null"));

        VUtilisateurRole utilisateurConnecte = (VUtilisateurRole) sessionObj;

        if (utilisateurConnecte == null) {
            System.out.println("ERREUR: Utilisateur non connecté");
            model.addAttribute("error", "Vous devez être connecté pour valider une proforma.");
            return "redirect:/user/login";
        }

        System.out.println("Utilisateur connecté: " + utilisateurConnecte.getEmail());

        // Vérifier la confirmation
        if (!"oui".equalsIgnoreCase(confirmation)) {
            System.out.println("ERREUR: Confirmation = '" + confirmation + "' (attendu: 'oui')");
            model.addAttribute("error", "Confirmation requise pour valider la proforma.");
            return selectionnerProforma(idProforma, tokenDemande, model);
        }

        // Vérifier si l'utilisateur a le droit de valider
        if (!utilisateurConnecte.getEmail().equals(emailAutorise)) {
            System.out.println("ERREUR: Email non autorisé");
            System.out.println("  Email connecté: " + utilisateurConnecte.getEmail());
            System.out.println("  Email requis: " + emailAutorise);
            model.addAttribute("error",
                    "Vous n'avez pas les droits nécessaires pour valider cette proforma. " +
                            "Email requis: " + emailAutorise);
            return selectionnerProforma(idProforma, tokenDemande, model);
        }

        System.out.println("VALIDATION AUTORISÉE - Procéder...");

        try {
            // Valider la proforma
            System.out.println("Mise à jour statut proforma...");
            proformaService.selectionnerProforma(idProforma);

            System.out.println("Création bon de commande...");
            bonCommandeService.creerBonCommandeFromProforma(idProforma);

            System.out.println("VALIDATION RÉUSSIE - Redirection");
            return "redirect:/achat/proformas?token=" + tokenDemande;

        } catch (Exception e) {
            System.out.println("ERREUR lors de la validation: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors de la validation: " + e.getMessage());
            return selectionnerProforma(idProforma, tokenDemande, model);
        }
    }

    @GetMapping("/achat/demandes")
    public String listeDemandes(Model model) {
        model.addAttribute("demandes", proformaService.getAllDemandes());
        return "achat/demandes";
    }

    @GetMapping("/bc/list")
    public String listeBonCommandes(Model model) {
        List<VBonCommande> bonsCommande = vBonCommandeService.findAll();
        model.addAttribute("bonsCommande", bonsCommande);
        return "achat/bc-liste";
    }

    // Détail d'un bon de commande
    @GetMapping("/bc/detail/{id}")
    public String detailBonCommande(@PathVariable("id") Integer idBonCommande, Model model) {
        VBonCommande bonCommande = vBonCommandeService.findById(idBonCommande);
        model.addAttribute("bonCommande", bonCommande);
        return "achat/bc-detail";
    }

    // Générer une facture pour un bon de commande
    @PostMapping("/achat/genererFactureFournisseur")
    public String genererFactureFournisseur(@RequestParam("idBonCommande") Integer idBonCommande,
            HttpSession session,
            Model model) {

        // Vérifier si l'utilisateur est connecté
        VUtilisateurRole utilisateurConnecte = (VUtilisateurRole) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }

        // Vérifier si une facture existe déjà
        Optional<FactureFournisseur> factureExistante = factureFournisseurService.findByIdBonCommande(idBonCommande);
        if (factureExistante.isPresent()) {
            model.addAttribute("info", "Une facture existe déjà pour ce bon de commande.");
            return "redirect:/factureFournisseur/list";
        }

        // Récupérer le montant du bon de commande
        VBonCommande bonCommande = vBonCommandeService.findById(idBonCommande);
        if (bonCommande == null) {
            model.addAttribute("error", "Bon de commande introuvable.");
            return "redirect:/bc/list";
        }

        // Créer la facture
        FactureFournisseur facture = factureFournisseurService.creerFactureFromBonCommande(
                idBonCommande,
                bonCommande.getMontantTotal());

        model.addAttribute("success", "Facture générée avec succès: " + facture.getNumeroFacture());
        return "redirect:/factureFournisseur/list";
    }

    // Liste des factures fournisseurs
    @GetMapping("/factureFournisseur/list")
    public String listeFacturesFournisseurs(Model model) {
        List<FactureFournisseur> factures = factureFournisseurService.findAll();
        model.addAttribute("factures", factures);
        return "achat/facturefournisseur-list";
    }

    // Détail d'une facture
    @GetMapping("/achat/factureFournisseur/detail/{id}")
    public String detailFacture(@PathVariable("id") Integer idFacture, Model model) {
        Optional<FactureFournisseur> factureOpt = factureFournisseurService.findById(idFacture);
        if (factureOpt.isPresent()) {
            model.addAttribute("facture", factureOpt.get());
            return "achat/facturefournisseur-detail";
        } else {
            model.addAttribute("error", "Facture introuvable.");
            return "redirect:/factureFournisseur/list";
        }
    }

    // Régler une facture et créer un bon de livraison
    @PostMapping("/achat/factureFournisseur/regler")
    public String reglerFactureEtCreerLivraison(@RequestParam("idFacture") Integer idFacture,
            HttpSession session,
            Model model) {

        VUtilisateurRole utilisateurConnecte = (VUtilisateurRole) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }

        // 1. Marquer la facture comme réglée
        factureFournisseurService.marquerCommeReglee(idFacture);

        // 2. Récupérer la facture pour obtenir l'ID du bon de commande
        Optional<FactureFournisseur> factureOpt = factureFournisseurService.findById(idFacture);
        if (factureOpt.isPresent()) {
            FactureFournisseur facture = factureOpt.get();

            // 3. Créer un bon de livraison pour ce bon de commande
            bonLivraisonService.creerBonLivraisonFromBonCommande(facture.getIdBonCommande());

            model.addAttribute("success", "Facture réglée et bon de livraison créé.");
        } else {
            model.addAttribute("error", "Facture introuvable.");
        }

        return "redirect:/bonLivraison/list";
    }

    // Liste des bons de livraison
    @GetMapping("/bonLivraison/list")
    public String listeBonLivraisons(Model model) {
        List<BonLivraison> bonLivraisons = bonLivraisonService.findAll();
        model.addAttribute("bonLivraisons", bonLivraisons);
        return "achat/bonlivraison-list";
    }

    // Détail d'un bon de livraison
    @GetMapping("/bonLivraison/detail/{id}")
    public String detailBonLivraison(@PathVariable("id") Integer idBonLivraison, Model model) {
        Optional<BonLivraison> bonLivraisonOpt = bonLivraisonService.findById(idBonLivraison);
        if (bonLivraisonOpt.isPresent()) {
            model.addAttribute("bonLivraison", bonLivraisonOpt.get());
            return "achat/bonlivraison-detail";
        } else {
            model.addAttribute("error", "Bon de livraison introuvable.");
            return "redirect:/bonLivraison/list";
        }
    }

    // Afficher le formulaire de création d'un bon de réception
    @GetMapping("/bonReception/form/{idBonLivraison}")
    public String formulaireBonReception(@PathVariable("idBonLivraison") Integer idBonLivraison,
            Model model) {
        Optional<BonLivraison> bonLivraisonOpt = bonLivraisonService.findById(idBonLivraison);
        if (bonLivraisonOpt.isPresent()) {
            BonLivraison bonLivraison = bonLivraisonOpt.get();
            model.addAttribute("bonLivraison", bonLivraison);

            // Vérifier si un bon de réception existe déjà
            List<com.ventetovo.entity.BonReception> receptionsExistantes = bonReceptionService
                    .findByIdBonLivraison(idBonLivraison);
            if (!receptionsExistantes.isEmpty()) {
                model.addAttribute("receptionExistante", receptionsExistantes.get(0));
                model.addAttribute("info", "Un bon de réception existe déjà pour cette livraison.");
            }

            return "achat/bonreception-form";
        } else {
            model.addAttribute("error", "Bon de livraison introuvable.");
            return "redirect:/bonLivraison/list";
        }
    }

    // Enregistrer un bon de réception
    @PostMapping("/achat/bonReception/enregistrer")
    public String enregistrerBonReception(@RequestParam("idBonLivraison") Integer idBonLivraison,
            @RequestParam("idArticle") Integer idArticle,
            @RequestParam("quantiteCommandee") Integer quantiteCommandee,
            @RequestParam("quantiteRecue") Integer quantiteRecue,
            @RequestParam(value = "quantiteNonConforme", defaultValue = "0") Integer quantiteNonConforme,
            @RequestParam(value = "commentaire", required = false) String commentaire,
            HttpSession session,
            Model model) {

        VUtilisateurRole utilisateurConnecte = (VUtilisateurRole) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }

        // Créer le bon de réception
        com.ventetovo.entity.BonReception bonReception = bonReceptionService.enregistrerReception(
                idBonLivraison, idArticle, quantiteCommandee, quantiteRecue,
                quantiteNonConforme, commentaire);

        bonReception.setIdReceptionnaire(utilisateurConnecte.getIdUtilisateur());
        bonReceptionService.save(bonReception);

        // Rediriger vers la page de comparaison
        return "redirect:/bonReception/comparaison/" + idBonLivraison;
    }

    // Page de comparaison BL et BR
    @GetMapping("/bonReception/comparaison/{idBonLivraison}")
    public String comparaisonBLBR(@PathVariable("idBonLivraison") Integer idBonLivraison, Model model) {
        Optional<BonLivraison> bonLivraisonOpt = bonLivraisonService.findById(idBonLivraison);
        List<com.ventetovo.entity.BonReception> bonReceptions = bonReceptionService
                .findByIdBonLivraison(idBonLivraison);

        if (bonLivraisonOpt.isPresent() && !bonReceptions.isEmpty()) {
            BonLivraison bonLivraison = bonLivraisonOpt.get();
            com.ventetovo.entity.BonReception bonReception = bonReceptions.get(0);

            model.addAttribute("bonLivraison", bonLivraison);
            model.addAttribute("bonReception", bonReception);

            // Calculer si les quantités correspondent
            boolean correspondanceParfaite = bonReception.getQuantiteRecue().equals(bonReception.getQuantiteCommandee())
                    && bonReception.getQuantiteNonConforme() == 0;
            model.addAttribute("correspondanceParfaite", correspondanceParfaite);

            return "achat/bonreception-comparaison";
        } else {
            model.addAttribute("error", "Bon de livraison ou réception introuvable.");
            return "redirect:/bonLivraison/list";
        }
    }

    // Valider la réception et gérer le mouvement de caisse
    @PostMapping("/bonReception/valider")
    public String validerReception(@RequestParam("idBonLivraison") Integer idBonLivraison,
            @RequestParam("idBonReception") Integer idBonReception,
            HttpSession session,
            Model model) {

        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }

        // Marquer le bon de livraison comme reçu
        bonLivraisonService.marquerCommeRecu(idBonLivraison);

        // TODO: Gérer le mouvement de caisse ici (enregistrer le paiement, etc.)
        // Ce serait typiquement une nouvelle table "mouvement_caisse" à créer

        model.addAttribute("success", "Réception validée avec succès. Le stock a été mis à jour.");

        return "redirect:/bonLivraison/list";
    }
}