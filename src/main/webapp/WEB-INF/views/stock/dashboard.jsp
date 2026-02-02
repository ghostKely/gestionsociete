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

        <!-- Graphiques (Chart.js) -->
        <div class="charts-section" style="margin-bottom: 40px;">
            <h2 style="color: #2874A6;">📊 Visualisations - Module Stock</h2>
            <div style="display:flex; gap:20px; flex-wrap:wrap; margin-top:16px;">
                <div style="flex:1 1 600px; background:#fff; padding:12px; border-radius:8px;">
                    <h3 style="margin:6px 0 12px 0;">Top articles en stock (quantité)</h3>
                    <canvas id="stockTopArticles"></canvas>
                </div>

                <div style="width:360px; background:#fff; padding:12px; border-radius:8px;">
                    <h3 style="margin:6px 0 12px 0;">Répartition par dépôt</h3>
                    <canvas id="depotPie"></canvas>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                (function(){
                    fetch('${pageContext.request.contextPath}/api/dashboard/stock')
                    .then(r => r.json())
                    .then(data => {
                        // Top articles
                        const topCtx = document.getElementById('stockTopArticles').getContext('2d');
                        new Chart(topCtx, {
                            type: 'bar',
                            data: {
                                labels: data.topArticleLabels || [],
                                datasets: [{ label: 'Quantité', data: data.topArticleValues || [], backgroundColor: 'rgba(75,192,192,0.6)' }]
                            },
                            options: { responsive:true, maintainAspectRatio:false }
                        });

                        // Depot pie
                        const depotCtx = document.getElementById('depotPie').getContext('2d');
                        new Chart(depotCtx, {
                            type: 'pie',
                            data: { labels: data.depotLabels || [], datasets: [{ data: data.depotValues || [], backgroundColor: ['#36a2eb','#ff6384','#ffcd56','#4bc0c0'] }] },
                            options: { responsive:true, maintainAspectRatio:false }
                        });
                    })
                    .catch(err => console.error('Erreur chargement données dashboard stock', err));
                })();
            </script>
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
