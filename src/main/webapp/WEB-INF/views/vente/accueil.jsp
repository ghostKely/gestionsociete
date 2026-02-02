<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Module Vente</title>
    <style>
        /* ============================================
           RESET & GLOBAL STYLES - MODULE VENTE
           ============================================ */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #fff8f0;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            color: #2c3e50;
            line-height: 1.6;
        }

        /* ============================================
           MAIN CONTAINER
           ============================================ */
        .container {
            display: flex;
            width: 100%;
            min-height: 90vh;
            gap: 25px;
            margin: 0 auto;
            max-width: 1600px;
            background: transparent;
        }

        /* ============================================
           CONTENT WRAPPER (RIGHT SIDE)
           ============================================ */
        .content-wrapper {
            flex: 1;
            background: linear-gradient(145deg, #ffffff, #fffaf5);
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(230, 126, 34, 0.1);
            border: 1px solid #ffe8d6;
            overflow: hidden;
        }

        /* ============================================
           HEADER STYLES
           ============================================ */
        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 32px;
            border-bottom: 2px solid #e67e22;
            padding-bottom: 15px;
            font-weight: 700;
            text-align: center;
        }

        /* ============================================
           INFO MESSAGE
           ============================================ */
        .info-message {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1565c0;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border-left: 5px solid #2196f3;
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.15);
            font-weight: 500;
            text-align: center;
            font-size: 18px;
            animation: slideInDown 0.4s ease;
        }

        .info-message strong {
            color: #0d47a1;
        }

        @keyframes slideInDown {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* ============================================
           MENU GRID
           ============================================ */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }

        /* ============================================
           MENU CARDS
           ============================================ */
        .menu-card {
            display: block;
            text-decoration: none;
            background: linear-gradient(145deg, #ffffff, #fffaf5);
            padding: 30px 25px;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(230, 126, 34, 0.1);
            border: 2px solid #ffe8d6;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .menu-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            background: radial-gradient(circle, rgba(230, 126, 34, 0.1), transparent);
            border-radius: 50%;
            transform: translate(30%, -30%);
        }

        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(230, 126, 34, 0.2);
            border-color: #e67e22;
            background: linear-gradient(145deg, #fffaf5, #ffffff);
        }

        .menu-card:nth-child(1):hover { border-top-color: #3498db; }
        .menu-card:nth-child(2):hover { border-top-color: #27ae60; }
        .menu-card:nth-child(3):hover { border-top-color: #e67e22; }
        .menu-card:nth-child(4):hover { border-top-color: #9b59b6; }
        .menu-card:nth-child(5):hover { border-top-color: #34495e; }
        .menu-card:nth-child(6):hover { border-top-color: #f39c12; }
        .menu-card:nth-child(7):hover { border-top-color: #1abc9c; }
        .menu-card:nth-child(8):hover { border-top-color: #2ecc71; }
        .menu-card:nth-child(9):hover { border-top-color: #e74c3c; }
        .menu-card:nth-child(10):hover { border-top-color: #95a5a6; }
        .menu-card:nth-child(11):hover { border-top-color: #d35400; }

        .menu-card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #e67e22, #d35400);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }

        .menu-card:hover::after {
            transform: scaleX(1);
        }

        .menu-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .menu-card:hover .menu-title {
            color: #d35400;
        }

        /* ============================================
           BUTTON STYLES
           ============================================ */
        .btn-danger,
        .form-buttons {
            padding: 12px 28px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(231, 76, 60, 0.3);
        }

        .form-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
            justify-content: center;
        }

        /* ============================================
           RESPONSIVE DESIGN
           ============================================ */
        @media (max-width: 1200px) {
            .container {
                gap: 20px;
            }
            
            .menu-grid {
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 20px;
            }
        }

        @media (max-width: 1024px) {
            .container {
                flex-direction: column;
            }
            
            .content-wrapper {
                padding: 30px;
            }
            
            .menu-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .content-wrapper {
                padding: 20px;
            }
            
            h1 {
                font-size: 26px;
            }
            
            .info-message {
                padding: 15px;
                font-size: 16px;
            }
            
            .menu-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .menu-card {
                padding: 25px 20px;
            }
            
            .menu-title {
                font-size: 16px;
            }
            
            .btn-danger {
                width: 100%;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            h1 {
                font-size: 24px;
            }
            
            .info-message {
                font-size: 15px;
            }
            
            .menu-card {
                padding: 20px 15px;
            }
            
            .menu-title {
                font-size: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>Module Vente - Gestion Commerciale</h1>
            
            <div class="info-message">
                <c:choose>
                    <c:when test="${not empty utilisateur}">
                        Bienvenue, <strong>${empty utilisateur.nom ? '' : utilisateur.nom} ${empty utilisateur.prenom ? '' : utilisateur.prenom}</strong>
                    </c:when>
                    <c:otherwise>
                        Bienvenue dans le module Vente
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="menu-grid">
                <a href="${pageContext.request.contextPath}/vente/dashboard" class="menu-card">
                    <div class="menu-title">Dashboard</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/articles" class="menu-card">
                    <div class="menu-title">Catalogue Articles</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/devis" class="menu-card">
                    <div class="menu-title">Gestion Devis</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/commandes" class="menu-card">
                    <div class="menu-title">Gestion Commandes</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/livraisons" class="menu-card">
                    <div class="menu-title">Gestion Livraisons</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/commandes/a-valider" class="menu-card">
                    <div class="menu-title">Validation Commandes</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/factures" class="menu-card">
                    <div class="menu-title">Toutes les Factures</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/factures/validees" class="menu-card">
                    <div class="menu-title">Factures Validées</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/factures/a-encaisser" class="menu-card">
                    <div class="menu-title">Factures à Encaisser</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/factures/payees" class="menu-card">
                    <div class="menu-title">Factures Payées</div>
                </a>
                <a href="${pageContext.request.contextPath}/vente/reglements" class="menu-card">
                    <div class="menu-title">Historique Règlements</div>
                </a>
            </div>
            
            <div class="form-buttons">
                <a href="${pageContext.request.contextPath}/user/logout" class="btn-danger">Déconnexion</a>
            </div>
        </div>
    </div>
</body>
</html>