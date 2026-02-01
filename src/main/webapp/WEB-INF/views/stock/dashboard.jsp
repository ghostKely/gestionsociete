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
            <li><a href="${pageContext.request.contextPath}/inventaire/pageInventaire">📦 Inventaire</a></li>
            <li><a href="${pageContext.request.contextPath}/stock/articles">Liste des articles</a></li>
            <li><a href="${pageContext.request.contextPath}/stock/mouvements">Historique des mouvements</a></li>
            <li><a href="${pageContext.request.contextPath}/transfert/transfertpage">🔄 Initialisation Transfert</a></li>
            <li><a href="#">Revue final Transfert</a></li>
            <li><a href="#">Comparaison stock théorique & stock actuel</a></li>
        </ul>
    </nav>

    <!-- Right Content -->
    <div class="content-wrapper">
        <h1>Mouvement Stock Calculé</h1>

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
