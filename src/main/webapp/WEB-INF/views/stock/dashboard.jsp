<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Stock</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        /* Styles supplémentaires pour les graphiques */
        .charts-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 30px;
            margin: 30px 0;
        }
        
        .chart-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border: 1px solid #e0e0e0;
        }
        
        .chart-title {
            color: #2874A6;
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: 600;
            text-align: center;
        }
        
        .chart-wrapper {
            position: relative;
            height: 400px;
            width: 100%;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-left: 4px solid #2874A6;
        }
        
        .stat-title {
            color: #495057;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-value {
            color: #2874A6;
            font-size: 28px;
            font-weight: 700;
        }
        
        .stat-unit {
            color: #6c757d;
            font-size: 14px;
            margin-left: 5px;
        }
    </style>
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
        <h1>📊 Dashboard Stock - Vue d'ensemble</h1>

        <!-- Statistiques principales -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-title">Total Articles</div>
                <div class="stat-value">${stockList.size()}<span class="stat-unit">articles</span></div>
            </div>
            
            <div class="stat-card">
                <div class="stat-title">Quantité Totale</div>
                <div class="stat-value">
                    <c:set var="totalQuantite" value="0" />
                    <c:forEach var="stock" items="${stockList}">
                        <c:set var="totalQuantite" value="${totalQuantite + stock.quantiteArticle}" />
                    </c:forEach>
                    ${totalQuantite}<span class="stat-unit">unités</span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-title">Valeur Totale</div>
                <div class="stat-value">
                    <c:set var="totalValeur" value="0" />
                    <c:forEach var="stock" items="${stockList}">
                        <c:set var="totalValeur" value="${totalValeur + stock.prixTotal}" />
                    </c:forEach>
                    ${totalValeur}<span class="stat-unit">Ar</span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-title">Valeur Moyenne</div>
                <div class="stat-value">
                    <c:set var="moyenneValeur" value="${totalValeur / (stockList.size() > 0 ? stockList.size() : 1)}" />
                    <fmt:formatNumber value="${moyenneValeur}" pattern="#,##0.00" /><span class="stat-unit">Ar</span>
                </div>
            </div>
        </div>

        <!-- Graphiques -->
        <div class="charts-container">
            <!-- Graphique 1: Répartition par dépôt -->
            <div class="chart-card">
                <div class="chart-title">📦 Répartition du Stock par Dépôt</div>
                <div class="chart-wrapper">
                    <canvas id="depotChart"></canvas>
                </div>
            </div>

            <!-- Graphique 2: Top 10 des articles en quantité -->
            <div class="chart-card">
                <div class="chart-title">🏆 Top 10 Articles par Quantité</div>
                <div class="chart-wrapper">
                    <canvas id="topArticlesChart"></canvas>
                </div>
            </div>

            <!-- Graphique 3: Répartition par méthode -->
            <div class="chart-card">
                <div class="chart-title">📊 Répartition par Méthode de Stockage</div>
                <div class="chart-wrapper">
                    <canvas id="methodeChart"></canvas>
                </div>
            </div>

            <!-- Graphique 4: Valeur par dépôt -->
            <div class="chart-card">
                <div class="chart-title">💰 Valeur du Stock par Dépôt</div>
                <div class="chart-wrapper">
                    <canvas id="valeurDepotChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Tableau détaillé -->
        <div style="margin-top: 40px;">
            <h2 style="color: #2874A6; margin-bottom: 20px;">📋 Détail du Stock</h2>
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
                        <td>${stock.prixTotal} Ar</td>
                        <td>${stock.prixParMethode} Ar</td>
                        <td>${stock.dateMouvement}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty stockList}">
                <div style="text-align: center; padding: 50px; color: #6c757d; font-style: italic;">
                    Aucune donnée de stock disponible
                </div>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    (function(){
        // Préparer les données à partir de la liste des stocks
        const stockData = [
            <c:forEach var="stock" items="${stockList}" varStatus="status">
                {
                    depot: "${stock.depot.nomDepot}",
                    methode: "${stock.methodeArticle.methode.nomMethode}",
                    article: "${stock.article.designation}",
                    quantite: ${stock.quantiteArticle},
                    prixTotal: ${stock.prixTotal},
                    prixMethode: ${stock.prixParMethode}
                }<c:if test="${not status.last}">,</c:if>
            </c:forEach>
        ];
        
        // 1. Graphique par dépôt (camembert)
        const depotMap = {};
        stockData.forEach(item => {
            if (!depotMap[item.depot]) depotMap[item.depot] = 0;
            depotMap[item.depot] += item.quantite;
        });
        
        const depotLabels = Object.keys(depotMap);
        const depotValues = Object.values(depotMap);
        
        if (depotLabels.length > 0) {
            const depotCtx = document.getElementById('depotChart').getContext('2d');
            new Chart(depotCtx, {
                type: 'pie',
                data: { 
                    labels: depotLabels, 
                    datasets: [{ 
                        data: depotValues, 
                        backgroundColor: [
                            '#36a2eb', '#ff6384', '#ffcd56', '#4bc0c0', '#9966ff',
                            '#ff9f40', '#c9cbcf', '#8ac6d1', '#ffb6b9', '#bbded6'
                        ]
                    }] 
                },
                options: { 
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'right' },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = Math.round((context.parsed / total) * 100);
                                    return `${context.label}: ${context.parsed} unités (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });
        }
        
        // 2. Top 10 articles par quantité
        const articleMap = {};
        stockData.forEach(item => {
            if (!articleMap[item.article]) articleMap[item.article] = 0;
            articleMap[item.article] += item.quantite;
        });
        
        const topArticles = Object.entries(articleMap)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 10);
        
        const topArticleLabels = topArticles.map(item => {
            return item[0].length > 20 ? item[0].substring(0, 17) + '...' : item[0];
        });
        const topArticleValues = topArticles.map(item => item[1]);
        
        if (topArticles.length > 0) {
            const topArticlesCtx = document.getElementById('topArticlesChart').getContext('2d');
            new Chart(topArticlesCtx, {
                type: 'bar',
                data: { 
                    labels: topArticleLabels, 
                    datasets: [{ 
                        label: 'Quantité',
                        data: topArticleValues, 
                        backgroundColor: '#36a2eb',
                        borderColor: '#2874A6',
                        borderWidth: 1
                    }] 
                },
                options: { 
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Quantité' }
                        },
                        x: {
                            ticks: { maxRotation: 45 }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                title: function(tooltipItems) {
                                    const index = tooltipItems[0].dataIndex;
                                    return topArticles[index][0];
                                }
                            }
                        }
                    }
                }
            });
        }
        
        // 3. Graphique par méthode
        const methodeMap = {};
        stockData.forEach(item => {
            if (!methodeMap[item.methode]) methodeMap[item.methode] = 0;
            methodeMap[item.methode] += item.quantite;
        });
        
        const methodeLabels = Object.keys(methodeMap);
        const methodeValues = Object.values(methodeMap);
        
        if (methodeLabels.length > 0) {
            const methodeCtx = document.getElementById('methodeChart').getContext('2d');
            new Chart(methodeCtx, {
                type: 'doughnut',
                data: { 
                    labels: methodeLabels, 
                    datasets: [{ 
                        data: methodeValues, 
                        backgroundColor: [
                            '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF',
                            '#FF9F40', '#C9CBCF', '#8AC6D1', '#FFB6B9', '#BBDED6'
                        ]
                    }] 
                },
                options: { 
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'right' }
                    }
                }
            });
        }
        
        // 4. Valeur par dépôt
        const valeurDepotMap = {};
        stockData.forEach(item => {
            if (!valeurDepotMap[item.depot]) valeurDepotMap[item.depot] = 0;
            valeurDepotMap[item.depot] += item.prixTotal;
        });
        
        const valeurDepotLabels = Object.keys(valeurDepotMap);
        const valeurDepotValues = Object.values(valeurDepotMap);
        
        if (valeurDepotLabels.length > 0) {
            const valeurCtx = document.getElementById('valeurDepotChart').getContext('2d');
            new Chart(valeurCtx, {
                type: 'bar',
                data: { 
                    labels: valeurDepotLabels, 
                    datasets: [{ 
                        label: 'Valeur (Ar)',
                        data: valeurDepotValues, 
                        backgroundColor: '#4BC0C0',
                        borderColor: '#36A2EB',
                        borderWidth: 1
                    }] 
                },
                options: { 
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Valeur (Ar)' }
                        },
                        x: {
                            title: { display: true, text: 'Dépôts' }
                        }
                    }
                }
            });
        }
        
        // Afficher des messages si pas de données
        const charts = ['depotChart', 'topArticlesChart', 'methodeChart', 'valeurDepotChart'];
        charts.forEach(chartId => {
            const canvas = document.getElementById(chartId);
            if (canvas && !canvas.chart) {
                const ctx = canvas.getContext('2d');
                ctx.font = '16px Arial';
                ctx.fillStyle = '#6c757d';
                ctx.textAlign = 'center';
                ctx.fillText('Aucune donnée disponible', canvas.width/2, canvas.height/2);
            }
        });
        
    })();
</script>
</body>
</html>