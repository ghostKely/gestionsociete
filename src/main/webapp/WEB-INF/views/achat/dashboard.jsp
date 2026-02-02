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

            <!-- Power BI Dashboard -->
            <div class="powerbi-section" style="margin-top: 40px;">
                <h2 style="color: #764ba2;">📊 Analyse Power BI - Module Achat</h2>
                <div class="powerbi-container" style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-top: 20px;">
                    <iframe 
                        title="Dashboard Achat" 
                        width="100%" 
                        height="600" 
                        src="YOUR_POWERBI_EMBED_URL_ACHAT" 
                        frameborder="0" 
                        allowFullScreen="true">
                    </iframe>
                    <p style="color: #888; font-size: 12px; margin-top: 10px; text-align: center;">
                        <em>Remplacez YOUR_POWERBI_EMBED_URL_ACHAT par l'URL d'intégration de votre rapport Power BI</em>
                    </p>
                </div>
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
