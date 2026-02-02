<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Module Vente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vente.css">
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>Module Vente - Gestion Commerciale</h1>
            
            <div class="info-message">
                <c:choose>
                    <c:when test="${not empty utilisateur}">
                        Bienvenue, <strong>${empty utilisateur.nom ? '' : utilisateur.nom} ${empty utilisateur.prenom ? '' : utilisateur.prenom}</strong>
                    </c:when>
                    <c:otherwise>
                        Bienvenue dans le module Vente
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="menu-grid">
                <a href="${pageContext.request.contextPath}/vente/dashboard" class="menu-card">
                    <div class="menu-title">Dashboard</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/articles" class="menu-card">
                    <div class="menu-title">Catalogue Articles</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/devis" class="menu-card">
                    <div class="menu-title">Gestion Devis</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/commandes" class="menu-card">
                    <div class="menu-title">Gestion Commandes</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/livraisons" class="menu-card">
                    <div class="menu-title">Gestion Livraisons</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/commandes/a-valider" class="menu-card">
                    <div class="menu-title">Validation Commandes</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/factures" class="menu-card">
                    <div class="menu-title">Toutes les Factures</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/factures/validees" class="menu-card">
                    <div class="menu-title">Factures Validées</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/factures/a-encaisser" class="menu-card">
                    <div class="menu-title">Factures à Encaisser</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/factures/payees" class="menu-card">
                    <div class="menu-title">Factures Payées</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/reglements" class="menu-card">
                    <div class="menu-title">Historique Règlements</div>
                </a>
            </div>
            
            <div class="form-buttons" style="margin-top: 30px; justify-content: center;">
                <a href="${pageContext.request.contextPath}/user/logout" class="btn-danger">Déconnexion</a>
            </div>
        </div>
    </div>
</body>
</html>