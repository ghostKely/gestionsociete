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
            <h2 style="color: #2874A6;">📊 Répartition du Stock par Dépôt</h2>
            <div style="display:flex; justify-content: center; margin-top:16px;">
                <div style="width:500px; height:500px; background:#fff; padding:20px; border-radius:8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <canvas id="depotPie"></canvas>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                (function(){
                    fetch('${pageContext.request.contextPath}/api/dashboard/stock/pie')
                    .then(r => r.json())
                    .then(data => {
                        const depotCtx = document.getElementById('depotPie').getContext('2d');
                        
                        // Vérifier si des données existent
                        const hasData = data.depotLabels && data.depotLabels.length > 0 && 
                                       data.depotValues && data.depotValues.some(v => v > 0);
                        
                        new Chart(depotCtx, {
                            type: 'pie',
                            data: { 
                                labels: hasData ? data.depotLabels : ['Aucune donnée'], 
                                datasets: [{ 
                                    data: hasData ? data.depotValues : [1], 
                                    backgroundColor: hasData ? [
                                        '#36a2eb',
                                        '#ff6384',
                                        '#ffcd56',
                                        '#4bc0c0',
                                        '#9966ff',
                                        '#ff9f40',
                                        '#c9cbcf'
                                    ] : ['#e0e0e0'],
                                    borderWidth: 2,
                                    borderColor: '#fff'
                                }] 
                            },
                            options: { 
                                responsive: true, 
                                maintainAspectRatio: true,
                                plugins: {
                                    legend: {
                                        display: true,
                                        position: 'bottom',
                                        labels: {
                                            font: {
                                                size: 14
                                            },
                                            padding: 15
                                        }
                                    },
                                    tooltip: {
                                        enabled: hasData,
                                        callbacks: {
                                            label: function(context) {
                                                if (!hasData) return '';
                                                let label = context.label || '';
                                                if (label) {
                                                    label += ': ';
                                                }
                                                label += context.parsed.toFixed(2) + ' unités';
                                                return label;
                                            }
                                        }
                                    },
                                    title: {
                                        display: !hasData,
                                        text: 'Aucune donnée disponible',
                                        color: '#999',
                                        font: {
                                            size: 16
                                        }
                                    }
                                }
                            }
                        });
                    })
                    .catch(err => {
                        console.error('Erreur chargement camembert dépôt', err);
                        // Afficher un camembert vide en cas d'erreur
                        const depotCtx = document.getElementById('depotPie').getContext('2d');
                        new Chart(depotCtx, {
                            type: 'pie',
                            data: { 
                                labels: ['Aucune donnée'], 
                                datasets: [{ 
                                    data: [1], 
                                    backgroundColor: ['#e0e0e0'],
                                    borderWidth: 2,
                                    borderColor: '#fff'
                                }] 
                            },
                            options: { 
                                responsive: true, 
                                maintainAspectRatio: true,
                                plugins: {
                                    legend: { display: false },
                                    tooltip: { enabled: false },
                                    title: {
                                        display: true,
                                        text: 'Erreur de chargement des données',
                                        color: '#999',
                                        font: { size: 16 }
                                    }
                                }
                            }
                        });
                    });
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
