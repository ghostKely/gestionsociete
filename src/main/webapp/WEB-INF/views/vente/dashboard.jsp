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

            <!-- Power BI Dashboard (remplacé) -->
            <div class="powerbi-section" style="margin-top: 40px;">
                <h2 style="color: #d35400;">📊 Rapport Power BI - Ventes (Données)</h2>
                <div class="powerbi-container" style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-top: 20px;">
                    <iframe
                        id="powerbi-vente-iframe"
                        title="Rapport Ventes"
                        width="100%"
                        height="800"
                        src="POWERBI_EMBED_URL_VENTE_NEW"
                        frameborder="0"
                        allowFullScreen="true">
                    </iframe>
                    <p style="color:#888; font-size:12px; margin-top:10px; text-align:center;">
                        <em>Remplacez POWERBI_EMBED_URL_VENTE_NEW par l'URL d'intégration de votre rapport Power BI (embed)</em>
                    </p>
                </div>
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
