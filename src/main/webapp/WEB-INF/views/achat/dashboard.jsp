<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Module Achat</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .dashboard-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .dashboard-card h3 {
            margin: 0 0 10px 0;
            font-size: 18px;
        }
        .card-value {
            font-size: 36px;
            font-weight: bold;
            margin: 15px 0;
        }
        .card-label {
            font-size: 14px;
            opacity: 0.9;
        }
        .info-message {
            background: #e8f4f8;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>📊 Dashboard Module Achat</h1>
            
            <div class="info-message">
                <strong>Module Achat</strong> - Gestion des achats et approvisionnements
            </div>

            <!-- Statistiques -->
            <div class="dashboard-cards">
                <div class="dashboard-card">
                    <h3>📋 Bons de Commande</h3>
                    <div class="card-value">${nbBonCommandes != null ? nbBonCommandes : 0}</div>
                    <div class="card-label">Total BC émis</div>
                </div>
                <div class="dashboard-card">
                    <h3>📦 Bons de Réception</h3>
                    <div class="card-value">${nbBonReceptions != null ? nbBonReceptions : 0}</div>
                    <div class="card-label">Réceptions enregistrées</div>
                </div>
                <div class="dashboard-card">
                    <h3>📄 Factures Fournisseurs</h3>
                    <div class="card-value">${nbFacturesFournisseurs != null ? nbFacturesFournisseurs : 0}</div>
                    <div class="card-label">Factures reçues</div>
                </div>
                <div class="dashboard-card">
                    <h3>🏢 Fournisseurs</h3>
                    <div class="card-value">${nbFournisseurs != null ? nbFournisseurs : 0}</div>
                    <div class="card-label">Fournisseurs actifs</div>
                </div>
                <div class="dashboard-card">
                    <h3>💰 Montant Total</h3>
                    <div class="card-value">${montantTotalAchats != null ? montantTotalAchats : 0} Ar</div>
                    <div class="card-label">Total des achats</div>
                </div>
            </div>

            <!-- Graphiques (Chart.js) -->
            <div class="charts-section" style="margin-top: 40px;">
                <h2 style="color: #764ba2;">📊 Visualisations - Module Achat</h2>
                <div style="display:flex; gap:20px; flex-wrap:wrap; margin-top:16px;">
                    <div style="flex:1 1 400px; background:#fff; padding:12px; border-radius:8px;">
                        <h3 style="margin:6px 0 12px 0;">Top fournisseurs (montant)</h3>
                        <canvas id="topFournisseurs"></canvas>
                    </div>

                    <div style="flex:1 1 300px; background:#fff; padding:12px; border-radius:8px;">
                        <h3 style="margin:6px 0 12px 0;">Totaux</h3>
                        <div style="font-size:18px;">Bons de commande: <strong>${nbBonCommandes != null ? nbBonCommandes : 0}</strong></div>
                        <div style="font-size:18px;">Factures fournisseurs: <strong>${nbFacturesFournisseurs != null ? nbFacturesFournisseurs : 0}</strong></div>
                        <div style="font-size:18px;">Montant total achats: <strong>${montantTotalAchats != null ? montantTotalAchats : 0} Ar</strong></div>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    (function(){
                        fetch('${pageContext.request.contextPath}/api/dashboard/achat')
                        .then(r => r.json())
                        .then(data => {
                            const ctx = document.getElementById('topFournisseurs').getContext('2d');
                            new Chart(ctx, {
                                type: 'bar',
                                data: { labels: data.topFournLabels || [], datasets: [{ label: 'Montant', data: data.topFournValues || [], backgroundColor: 'rgba(153,102,255,0.6)' }] },
                                options: { indexAxis: 'y', responsive:true, maintainAspectRatio:false }
                            });
                        })
                        .catch(err => console.error('Erreur chargement données dashboard achat', err));
                    })();
                </script>
            </div>

            <!-- Menu Fonctionnalités -->
            <h2 style="color: #764ba2; margin-top: 40px;">Fonctionnalités du Module</h2>
            <div class="dashboard-cards">
                <a href="${pageContext.request.contextPath}/achat/demandes" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>📝 Demandes d'Achat</h3>
                    <div class="card-label">Gérer les demandes</div>
                </a>

                <a href="${pageContext.request.contextPath}/achat/proformas" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>📋 Proformas</h3>
                    <div class="card-label">Consulter les proformas</div>
                </a>

                <a href="${pageContext.request.contextPath}/achat/bc" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>📑 Bons de Commande</h3>
                    <div class="card-label">Gérer les BC</div>
                </a>

                <a href="${pageContext.request.contextPath}/achat/bon-livraison" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>🚚 Bons de Livraison</h3>
                    <div class="card-label">Suivi des livraisons</div>
                </a>

                <a href="${pageContext.request.contextPath}/achat/bon-reception" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>📦 Bons de Réception</h3>
                    <div class="card-label">Enregistrer les réceptions</div>
                </a>

                <a href="${pageContext.request.contextPath}/achat/factures-fournisseurs" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>💳 Factures Fournisseurs</h3>
                    <div class="card-label">Gérer les factures</div>
                </a>

                <a href="${pageContext.request.contextPath}/achat/finance" class="dashboard-card" style="text-decoration: none; cursor: pointer;">
                    <h3>💰 Finance</h3>
                    <div class="card-label">Gestion financière</div>
                </a>
            </div>
            
            <div class="form-buttons" style="margin-top: 30px; justify-content: center;">
                <a href="${pageContext.request.contextPath}/achat/accueil" class="btn-secondary">Retour Accueil</a>
            </div>
        </div>
    </div>
</body>
</html>
