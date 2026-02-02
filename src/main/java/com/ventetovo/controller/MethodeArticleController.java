package com.ventetovo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ventetovo.service.MethodeArticleService;

@Controller
@RequestMapping("/methode-article")
public class MethodeArticleController {

    private final MethodeArticleService methodeArticleService;

    public MethodeArticleController(MethodeArticleService methodeArticleService) {
        this.methodeArticleService = methodeArticleService;
    }

    @GetMapping("/form")
    public String showForm(Model model) {

        model.addAttribute("articles",
                methodeArticleService.getAllArticles());

        model.addAttribute("methodes",
                methodeArticleService.getAllMethodes());

        return "stock/methode-article-form";
    }

    @PostMapping("/save")
    public String save(
            @RequestParam("articleId") Integer articleId,
            @RequestParam("methodeId") Integer methodeId) {

        methodeArticleService.saveOrUpdate(articleId, methodeId);

        return "redirect:/methode-article/form";
    }
}

