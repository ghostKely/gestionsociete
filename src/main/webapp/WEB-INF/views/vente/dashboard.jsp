<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Module Vente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vente.css">
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>Dashboard Module Vente</h1>
            
            <div class="info-message">
                <strong>${utilisateur.nom}</strong> | 
                <a href="${pageContext.request.contextPath}/user/logout" class="btn-danger" style="padding: 6px 12px; font-size: 13px;">Déconnexion</a>
            </div>

            <!-- Statistiques -->
            <div class="dashboard-cards">
                <div class="dashboard-card">
                    <h3>Clients</h3>
                    <div class="card-value">${nbClients}</div>
                    <div class="card-label">Total clients</div>
                </div>
                <div class="dashboard-card">
                    <h3>Devis</h3>
                    <div class="card-value">${nbDevis}</div>
                    <div class="card-label">Devis créés</div>
                </div>
                <div class="dashboard-card">
                    <h3>Commandes</h3>
                    <div class="card-value">${nbCommandes}</div>
                    <div class="card-label">Commandes clients</div>
                </div>
                <div class="dashboard-card">
                    <h3>Livraisons</h3>
                    <div class="card-value">${nbLivraisons}</div>
                    <div class="card-label">Livraisons effectuées</div>
                </div>
                <div class="dashboard-card">
                    <h3>Factures</h3>
                    <div class="card-value">${nbFactures}</div>
                    <div class="card-label">Factures émises</div>
                </div>
                <div class="dashboard-card">
                    <h3>Chiffre d'Affaires</h3>
                    <div class="card-value">${chiffreAffaires} Ar</div>
                    <div class="card-label">Total CA</div>
                </div>
            </div>

            <!-- Graphiques (Chart.js) -->
            <div class="charts-section" style="margin-top: 40px;">
                <h2 style="color: #d35400;">📊 Répartition des Factures par Statut</h2>
                <div style="display:flex; justify-content: center; margin-top:16px;">
                    <div style="width:500px; height:500px; background:#fff; padding:20px; border-radius:8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                        <canvas id="invoicesPie"></canvas>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    (function(){
                        fetch('${pageContext.request.contextPath}/api/dashboard/vente/pie')
                        .then(r => r.json())
                        .then(data => {
                            const pieCtx = document.getElementById('invoicesPie').getContext('2d');
                            
                            // Vérifier si des données existent
                            const hasData = data.invoiceStatusLabels && data.invoiceStatusLabels.length > 0 && 
                                           data.invoiceStatusValues && data.invoiceStatusValues.some(v => v > 0);
                            
                            new Chart(pieCtx, {
                                type: 'pie',
                                data: {
                                    labels: hasData ? data.invoiceStatusLabels : ['Aucune donnée'],
                                    datasets: [{
                                        data: hasData ? data.invoiceStatusValues : [1],
                                        backgroundColor: hasData ? ['#ff6384','#36a2eb','#ffcd56','#4bc0c0','#9966ff'] : ['#e0e0e0'],
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
                                                    label += context.parsed + ' facture(s)';
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
                            console.error('Erreur chargement factures par statut', err);
                            // Afficher un camembert vide en cas d'erreur
                            const pieCtx = document.getElementById('invoicesPie').getContext('2d');
                            new Chart(pieCtx, {
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

            <!-- Menu Fonctionnalités -->
            <h2 style="color: #d35400; margin-top: 40px;">Fonctionnalités du Module</h2>
            <div class="dashboard-cards">
                <a href="${pageContext.request.contextPath}/vente/articles" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>Catalogue Articles</h3>
                    <div class="card-label">Consulter les articles disponibles</div>
                </a>

                <a href="${pageContext.request.contextPath}/vente/devis" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>Gestion Devis</h3>
                    <div class="card-label">Créer et gérer les devis</div>
                </a>

                <a href="${pageContext.request.contextPath}/vente/commandes" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>Commandes Clients</h3>
                    <div class="card-label">Gérer les commandes</div>
                </a>

                <a href="${pageContext.request.contextPath}/vente/livraisons" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>Livraisons</h3>
                    <div class="card-label">Gérer les livraisons</div>
                </a>

                <a href="${pageContext.request.contextPath}/vente/factures" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>Factures Clients</h3>
                    <div class="card-label">Créer et gérer les factures</div>
                </a>

                <a href="${pageContext.request.contextPath}/vente/commandes/a-valider" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>Validation Commandes</h3>
                    <div class="card-label">Valider les commandes en attente</div>
                </a>
            </div>
            
            <div class="form-buttons" style="margin-top: 30px; justify-content: center;">
                <a href="${pageContext.request.contextPath}/vente/accueil" class="btn-secondary">Retour Accueil</a>
            </div>
        </div>
    </div>
</body>
</html>
