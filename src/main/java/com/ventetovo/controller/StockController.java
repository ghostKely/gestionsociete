package com.ventetovo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ventetovo.entity.MouvementStock;
import com.ventetovo.entity.StockActuel;
import com.ventetovo.entity.Utilisateur;
import com.ventetovo.service.MouvementStockService;
import com.ventetovo.service.StockService;

import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Controller
@RequestMapping("/stock")
public class StockController {

    private final StockService stockService;
    private final MouvementStockService mouvementStockService;

    public StockController(MouvementStockService mouvementStockService, StockService stockService) {
        this.stockService = stockService;
        this.mouvementStockService = mouvementStockService;
    }

    @GetMapping("/mouvements")
    public String listAllMovements(Model model) {
        List<MouvementStock> mouvements = mouvementStockService.getAllMovements();
        model.addAttribute("mouvements", mouvements);
        return "stock/historique";
    }

    // =================== PAGE PRINCIPALE ===================
    @GetMapping("/dashboard")
    @Transactional
    public String pageInventaire(Model model) {
        List<StockActuel> stockList = stockService.getAllCurrentStock();
        model.addAttribute("stockList", stockList);

        return "stock/dashboard";
    }

    @GetMapping("/articles")
    public String listArticles(HttpSession session, Model model) {
        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return "redirect:/stock/login_stock"; // redirect to login if not logged in
        }

        // Fetch stock list
        List<StockActuel> stockList = stockService.getAllCurrentStock();
        model.addAttribute("stockList", stockList);

        return "stock/dashboard";
    }
}
