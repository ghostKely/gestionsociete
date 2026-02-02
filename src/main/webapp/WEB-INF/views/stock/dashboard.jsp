<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<div class="container">
    <!-- Left Navbar -->
    <nav class="navbar">
        <h2>Stock Menu</h2>

        <ul>
            <!-- Visible for all logged users -->
            <li>
                <a href="${pageContext.request.contextPath}/inventaire/pageInventaire">
                    📦 Inventaire
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/stock/articles">
                    🛍️ Liste des articles
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/stock/mouvements">
                    ⏳ Historique des mouvements
                </a>
            </li>

            <!-- Visible only if role.niveauValidation > 0 -->
            <c:if test="${not empty sessionScope.user
                        and not empty sessionScope.user.role
                        and sessionScope.user.role.niveauValidation > 0}">
                <li>
                    <a href="${pageContext.request.contextPath}/transfert/transfertpage">
                        🔄 Initialisation Transfert
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/methode-article/form">
                        🔄 Change the methode of an article
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>

    <!-- Right Content -->
    <div class="content-wrapper">
        <h1>Mouvement Stock Calculé</h1>

        <!-- Power BI Dashboard -->
        <div class="powerbi-section" style="margin-bottom: 40px;">
            <h2 style="color: #2874A6;">📊 Analyse Power BI - Module Stock</h2>
            <div class="powerbi-container" style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-top: 20px;">
                <iframe 
                    title="Dashboard Stock" 
                    width="100%" 
                    height="600" 
                    src="YOUR_POWERBI_EMBED_URL_STOCK" 
                    frameborder="0" 
                    allowFullScreen="true">
                </iframe>
                <p style="color: #888; font-size: 12px; margin-top: 10px; text-align: center;">
                    <em>Remplacez YOUR_POWERBI_EMBED_URL_STOCK par l'URL d'intégration de votre rapport Power BI</em>
                </p>
            </div>
        </div>

        <table>
            <thead>
            <tr>
                <th>Dépôt</th>
                <th>Méthode Article</th>
                <th>Article</th>
                <th>Quantité</th>
                <th>Prix Total</th>
                <th>Prix par Méthode</th>
                <th>Date Mouvement</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="stock" items="${stockList}">
                <tr>
                    <td>${stock.depot.nomDepot}</td>
                    <td>${stock.methodeArticle.methode.nomMethode}</td>
                    <td>${stock.article.designation}</td>
                    <td>${stock.quantiteArticle}</td>
                    <td>${stock.prixTotal}</td>
                    <td>${stock.prixParMethode}</td>
                    <td>${stock.dateMouvement}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
