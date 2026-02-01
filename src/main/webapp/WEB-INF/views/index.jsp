<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion d'Entreprise - Modules</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            text-align: center;
            padding: 30px 0;
            margin-bottom: 40px;
            background: linear-gradient(135deg, #2c3e50 0%, #4a6491 100%);
            color: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        header p {
            font-size: 1.1rem;
            opacity: 0.9;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .modules-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            margin-top: 40px;
        }
        
        .module-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            width: 320px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .module-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }
        
        .module-header {
            padding: 25px 20px;
            color: white;
            text-align: center;
        }
        
        .module-achat .module-header {
            background: linear-gradient(to right, #3498db, #2980b9);
        }
        
        .module-vente .module-header {
            background: linear-gradient(to right, #2ecc71, #27ae60);
        }
        
        .module-stock .module-header {
            background: linear-gradient(to right, #e74c3c, #c0392b);
        }
        
        .module-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        .module-title {
            font-size: 1.8rem;
            font-weight: 600;
        }
        
        .module-body {
            padding: 25px;
        }
        
        .module-description {
            font-size: 1rem;
            color: #555;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        
        .module-features {
            list-style-type: none;
            margin-bottom: 25px;
        }
        
        .module-features li {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }
        
        .module-features li:last-child {
            border-bottom: none;
        }
        
        .module-features i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .module-achat .module-features i {
            color: #3498db;
        }
        
        .module-vente .module-features i {
            color: #2ecc71;
        }
        
        .module-stock .module-features i {
            color: #e74c3c;
        }
        
        .btn-access {
            display: block;
            width: 100%;
            padding: 14px;
            text-align: center;
            background-color: #f8f9fa;
            color: #333;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .btn-access:hover {
            text-decoration: none;
        }
        
        .module-achat .btn-access:hover {
            background-color: #3498db;
            color: white;
        }
        
        .module-vente .btn-access:hover {
            background-color: #2ecc71;
            color: white;
        }
        
        .module-stock .btn-access:hover {
            background-color: #e74c3c;
            color: white;
        }
        
        footer {
            text-align: center;
            margin-top: 60px;
            padding: 20px;
            color: #777;
            font-size: 0.9rem;
            border-top: 1px solid #eee;
        }
        
        .selected-module {
            text-align: center;
            margin-top: 40px;
            padding: 20px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            min-height: 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .selected-module h3 {
            font-size: 1.4rem;
            margin-bottom: 10px;
            color: #2c3e50;
        }
        
        .selected-module p {
            font-size: 1.1rem;
            color: #3498db;
            font-weight: 600;
        }
        
        .module-link {
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        @media (max-width: 1100px) {
            .modules-container {
                gap: 20px;
            }
            
            .module-card {
                width: 300px;
            }
        }
        
        @media (max-width: 768px) {
            .modules-container {
                flex-direction: column;
                align-items: center;
            }
            
            .module-card {
                width: 100%;
                max-width: 400px;
            }
            
            header h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1><i class="fas fa-chart-line"></i> Système de Gestion d'Entreprise</h1>
            <p>Gérez efficacement vos achats, ventes et stocks avec notre plateforme intégrée</p>
        </header>
        
        <div class="modules-container">
            <!-- Module Achat -->
            <div class="module-card module-achat" onclick="selectModule('achat')">
                <div class="module-header">
                    <div class="module-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <h2 class="module-title">Module Achat</h2>
                </div>
                <div class="module-body">
                    <p class="module-description">
                        Gérez vos approvisionnements, commandes fournisseurs et suivez vos dépenses d'achat.
                    </p>
                    <ul class="module-features">
                        <li><i class="fas fa-check-circle"></i> Gestion des fournisseurs</li>
                        <li><i class="fas fa-check-circle"></i> Suivi des commandes</li>
                        <li><i class="fas fa-check-circle"></i> Facturation et règlements</li>
                        <li><i class="fas fa-check-circle"></i> Analyse des coûts d'achat</li>
                    </ul>
                    <!-- Lien de redirection vers le module achat -->
                    <a href="${pageContext.request.contextPath}/user/login?id=0" class="btn-access">Accéder au Module Achat</a>
                </div>
            </div>
            
            <!-- Module Vente -->
            <div class="module-card module-vente" onclick="selectModule('vente')">
                <div class="module-header">
                    <div class="module-icon">
                        <i class="fas fa-cash-register"></i>
                    </div>
                    <h2 class="module-title">Module Vente</h2>
                </div>
                <div class="module-body">
                    <p class="module-description">
                        Vendez vos produits, gérez vos clients et suivez votre chiffre d'affaires en temps réel.
                    </p>
                    <ul class="module-features">
                        <li><i class="fas fa-check-circle"></i> Gestion des clients</li>
                        <li><i class="fas fa-check-circle"></i> Devis et facturation</li>
                        <li><i class="fas fa-check-circle"></i> Suivi des paiements</li>
                        <li><i class="fas fa-check-circle"></i> Statistiques de vente</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/user/login?id=1" class="btn-access">Accéder au Module Vente</a>
                </div>
            </div>
            
            <!-- Module Stock -->
            <div class="module-card module-stock" onclick="selectModule('stock')">
                <div class="module-header">
                    <div class="module-icon">
                        <i class="fas fa-boxes"></i>
                    </div>
                    <h2 class="module-title">Module Stock</h2>
                </div>
                <div class="module-body">
                    <p class="module-description">
                        Contrôlez votre inventaire, suivez les mouvements de stock et gérez les alertes de réapprovisionnement.
                    </p>
                    <ul class="module-features">
                        <li><i class="fas fa-check-circle"></i> Inventaire en temps réel</li>
                        <li><i class="fas fa-check-circle"></i> Mouvements de stock</li>
                        <li><i class="fas fa-check-circle"></i> Alertes de réapprovisionnement</li>
                        <li><i class="fas fa-check-circle"></i> Gestion des emplacements</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/stock/login_stock" class="btn-access">Accéder au Module Stock</a>
                </div>
            </div>
        </div>
        
        <div class="selected-module" id="selected-module">
            <h3>Module sélectionné :</h3>
            <p id="module-text">Cliquez sur un module pour le sélectionner</p>
        </div>
        
        <footer>
            <p>Système de Gestion d'Entreprise &copy; 2023 - Tous droits réservés</p>
            <p>Version 2.1.0 | Dernière mise à jour : 15/10/2023</p>
        </footer>
    </div>

    <script>
        function selectModule(module) {
            const moduleNames = {
                'achat': 'Module Achat',
                'vente': 'Module Vente', 
                'stock': 'Module Stock'
            };
            
            const moduleDescriptions = {
                'achat': 'Gestion des fournisseurs, commandes et dépenses d\'achat',
                'vente': 'Gestion des clients, devis, factures et statistiques de vente',
                'stock': 'Gestion de l\'inventaire, mouvements et alertes de stock'
            };
            
            document.getElementById('module-text').textContent = `${moduleNames[module]} - ${moduleDescriptions[module]}`;
            
            // Animation de sélection
            const selectedElement = document.getElementById('selected-module');
            selectedElement.style.transform = 'scale(1.02)';
            setTimeout(() => {
                selectedElement.style.transform = 'scale(1)';
            }, 200);
        }
        
        function accessModule(module) {
            event.stopPropagation(); // Empêche le déclenchement de l'événement parent
            
            const moduleNames = {
                'achat': 'Achat',
                'vente': 'Vente', 
                'stock': 'Stock'
            };
            
            alert(`Accès au module ${moduleNames[module]} - Redirection en cours...\n\nDans une application réelle, vous seriez redirigé vers l'interface du module sélectionné.`);
            
            // Redirection pour les autres modules (exemples)
            // if (module === 'vente') {
            //     window.location.href = "${pageContext.request.contextPath}/user/login?id=1";
            // } else if (module === 'stock') {
            //     window.location.href = "${pageContext.request.contextPath}/user/login?id=2";
            // }
        }
        
        // Sélection par défaut du module Achat
        window.onload = function() {
            selectModule('achat');
        };
    </script>
</body>
</html>