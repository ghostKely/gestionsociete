package com.ventetovo.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ventetovo.entity.*;
import com.ventetovo.service.*;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardApiController {

    private final FactureClientService factureClientService;
    private final LigneCommandeClientService ligneCommandeClientService;
    private final StockService stockService;
    private final MouvementStockService mouvementStockService;
    private final BonCommandeService bonCommandeService;
    private final FactureFournisseurService factureFournisseurService;

    @Autowired
    public DashboardApiController(FactureClientService factureClientService,
            LigneCommandeClientService ligneCommandeClientService,
            StockService stockService,
            MouvementStockService mouvementStockService,
            BonCommandeService bonCommandeService,
            FactureFournisseurService factureFournisseurService) {
        this.factureClientService = factureClientService;
        this.ligneCommandeClientService = ligneCommandeClientService;
        this.stockService = stockService;
        this.mouvementStockService = mouvementStockService;
        this.bonCommandeService = bonCommandeService;
        this.factureFournisseurService = factureFournisseurService;
    }

    @GetMapping("/vente")
    public Map<String, Object> venteSummary() {
        Map<String, Object> out = new HashMap<>();

        List<FactureClient> factures = factureClientService.findAll();

        // Sales by month
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM");
        Map<String, BigDecimal> salesByMonth = new TreeMap<>();
        for (FactureClient f : factures) {
            if (f.getDateFacture() == null || f.getMontantTtc() == null)
                continue;
            String m = f.getDateFacture().format(fmt);
            salesByMonth.putIfAbsent(m, BigDecimal.ZERO);
            salesByMonth.put(m, salesByMonth.get(m).add(f.getMontantTtc()));
        }

        out.put("salesLabels", new ArrayList<>(salesByMonth.keySet()));
        out.put("salesValues", salesByMonth.values().stream().map(BigDecimal::doubleValue).collect(Collectors.toList()));

        // Invoices by status
        Map<String, Long> byStatus = factures.stream()
                .filter(f -> f.getStatut() != null)
                .collect(Collectors.groupingBy(FactureClient::getStatut, Collectors.counting()));

        out.put("invoiceStatusLabels", new ArrayList<>(byStatus.keySet()));
        out.put("invoiceStatusValues", new ArrayList<>(byStatus.values()));

        // Top articles by quantity from lignes
        List<LigneCommandeClient> lignes = ligneCommandeClientService.findAll();
        Map<Integer, Integer> qtyByArticle = new HashMap<>();
        for (LigneCommandeClient l : lignes) {
            if (l.getIdArticle() == null)
                continue;
            qtyByArticle.put(l.getIdArticle(), qtyByArticle.getOrDefault(l.getIdArticle(), 0) + (l.getQuantiteCommandee() != null ? l.getQuantiteCommandee() : 0));
        }
        List<Map.Entry<Integer, Integer>> top = qtyByArticle.entrySet().stream()
                .sorted((a, b) -> Integer.compare(b.getValue(), a.getValue()))
                .limit(8)
                .collect(Collectors.toList());

        List<String> topArticleLabels = new ArrayList<>();
        List<Integer> topArticleValues = new ArrayList<>();
        // Lazy resolve names from top list via the Ligne objects' article relation where possible
        for (Map.Entry<Integer, Integer> e : top) {
            Integer aid = e.getKey();
            Integer qty = e.getValue();
            // try to get a representative name
            String name = lignes.stream()
                    .filter(l -> aid.equals(l.getIdArticle()))
                    .map(l -> {
                        try {
                            Article a = l.getArticle();
                            return a != null && a.getDesignation() != null ? a.getDesignation() : (a != null ? String.valueOf(a.getIdArticle()) : "#" + aid);
                        } catch (Exception ex) {
                            return "#" + aid;
                        }
                    }).findFirst().orElse("#" + aid);
            topArticleLabels.add(name);
            topArticleValues.add(qty);
        }

        out.put("topArticleLabels", topArticleLabels);
        out.put("topArticleValues", topArticleValues);

        return out;
    }

    @GetMapping("/stock")
    public Map<String, Object> stockSummary() {
        Map<String, Object> out = new HashMap<>();

        List<StockActuel> stocks = stockService.getAllCurrentStock();

        // Top articles by quantity
        Map<String, Double> qtyByArticle = new HashMap<>();
        Map<String, Double> qtyByDepot = new HashMap<>();
        for (StockActuel s : stocks) {
            String art = s.getArticle() != null && s.getArticle().getDesignation() != null ? s.getArticle().getDesignation() : "Article-" + (s.getArticle() != null ? s.getArticle().getIdArticle() : "?");
            double q = s.getQuantiteArticle() != null ? s.getQuantiteArticle().doubleValue() : 0.0;
            qtyByArticle.put(art, qtyByArticle.getOrDefault(art, 0.0) + q);

            String depot = s.getDepot() != null && s.getDepot().getNomDepot() != null ? s.getDepot().getNomDepot() : "Dépôt-?";
            qtyByDepot.put(depot, qtyByDepot.getOrDefault(depot, 0.0) + q);
        }

        List<Map.Entry<String, Double>> topArts = qtyByArticle.entrySet().stream().sorted((a, b) -> Double.compare(b.getValue(), a.getValue())).limit(8).collect(Collectors.toList());
        out.put("topArticleLabels", topArts.stream().map(Map.Entry::getKey).collect(Collectors.toList()));
        out.put("topArticleValues", topArts.stream().map(e -> e.getValue()).collect(Collectors.toList()));

        out.put("depotLabels", new ArrayList<>(qtyByDepot.keySet()));
        out.put("depotValues", new ArrayList<>(qtyByDepot.values()));

        return out;
    }

    @GetMapping("/achat")
    public Map<String, Object> achatSummary() {
        Map<String, Object> out = new HashMap<>();

        List<BonCommande> bcs = bonCommandeService.findAll();
        List<FactureFournisseur> factures = factureFournisseurService.findAll();

        out.put("nbBonCommandes", bcs.size());
        out.put("nbFacturesFournisseurs", factures.size());

        double totalMontant = factures.stream().filter(Objects::nonNull).mapToDouble(f -> f.getMontantTotal() != null ? f.getMontantTotal() : 0.0).sum();
        out.put("totalMontantAchats", totalMontant);

        // top fournisseurs by montant (if available)
        Map<String, Double> montantByFourn = new HashMap<>();
        for (FactureFournisseur f : factures) {
            String fournisseurName = "Inconnu";
            if (f.getBonCommande() != null && f.getBonCommande().getProforma() != null && f.getBonCommande().getProforma().getFournisseur() != null) {
                fournisseurName = f.getBonCommande().getProforma().getFournisseur().getNom();
            }
            montantByFourn.put(fournisseurName, montantByFourn.getOrDefault(fournisseurName, 0.0) + (f.getMontantTotal() != null ? f.getMontantTotal() : 0.0));
        }

        List<Map.Entry<String, Double>> topF = montantByFourn.entrySet().stream().sorted((a, b) -> Double.compare(b.getValue(), a.getValue())).limit(8).collect(Collectors.toList());
        out.put("topFournLabels", topF.stream().map(Map.Entry::getKey).collect(Collectors.toList()));
        out.put("topFournValues", topF.stream().map(Map.Entry::getValue).collect(Collectors.toList()));

        return out;
    }
}
