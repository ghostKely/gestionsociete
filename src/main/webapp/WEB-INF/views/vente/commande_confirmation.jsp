<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Confirmation Commande</title>
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
           CONTENT WRAPPER (RIGHT SIDE)
           ============================================ */
        .content-wrapper {
            max-width: 800px;
            margin: 20px auto;
            background: linear-gradient(145deg, #ffffff, #fffaf5);
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(230, 126, 34, 0.1);
            border: 1px solid #ffe8d6;
            overflow: hidden;
        }

        .content-wrapper h1,
        .content-wrapper h2 {
            margin-bottom: 30px;
            font-size: 28px;
            color: #2c3e50;
            border-bottom: 2px solid #e67e22;
            padding-bottom: 15px;
            font-weight: 700;
        }

        .content-wrapper h2 {
            font-size: 24px;
            margin-bottom: 25px;
        }

        /* ============================================
           FORM CONTAINER & STYLES
           ============================================ */
        .form-container {
            background: linear-gradient(145deg, #fffaf5, #ffffff);
            padding: 25px;
            border-radius: 14px;
            margin-bottom: 30px;
            border: 1px solid #ffe8d6;
            box-shadow: 0 4px 15px rgba(230, 126, 34, 0.08);
        }

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #5d4037;
            font-size: 15px;
        }

        .form-group label span.required {
            color: #e74c3c;
            margin-left: 3px;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ffd5b3;
            border-radius: 10px;
            font-size: 15px;
            background-color: white;
            transition: border 0.3s, box-shadow 0.3s;
            color: #2c3e50;
        }

        .form-input:focus {
            outline: none;
            border-color: #e67e22;
            box-shadow: 0 0 0 3px rgba(230, 126, 34, 0.15);
        }

        /* ============================================
           DETAIL STYLES
           ============================================ */
        .detail-info {
            background: linear-gradient(145deg, #ffffff, #fffaf5);
            padding: 25px;
            border-radius: 14px;
            border: 1px solid #ffe8d6;
            box-shadow: 0 4px 15px rgba(230, 126, 34, 0.08);
            margin-bottom: 25px;
        }

        .detail-item {
            padding: 15px;
            background-color: #fffaf5;
            border-radius: 10px;
            border-left: 4px solid #e67e22;
            margin-bottom: 15px;
        }

        .detail-item label {
            display: block;
            font-weight: 600;
            color: #5d4037;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .detail-item .value {
            font-size: 16px;
            color: #2c3e50;
            font-weight: 500;
        }

        /* ============================================
           BUTTON STYLES
           ============================================ */
        .btn-submit,
        .btn-secondary {
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

        .btn-submit {
            background: linear-gradient(135deg, #e67e22, #d35400);
            color: white;
            margin-right: 15px;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #d35400, #ba4a00);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(230, 126, 34, 0.3);
        }

        .btn-secondary {
            background-color: #ecf0f1;
            color: #5d4037;
            border: 1px solid #d5dbdb;
        }

        .btn-secondary:hover {
            background-color: #d5dbdb;
            transform: translateY(-2px);
        }

        /* ============================================
           ACTION BAR
           ============================================ */
        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ffe8d6;
        }

        .back-link {
            color: #d35400;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #e67e22;
            text-decoration: underline;
        }

        /* ============================================
           MESSAGES (SUCCESS / ERROR / INFO / WARNING)
           ============================================ */
        .error-message {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #c62828;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 5px solid #f44336;
            box-shadow: 0 4px 12px rgba(244, 67, 54, 0.15);
            font-weight: 500;
            animation: slideInDown 0.4s ease;
        }

        .success-message {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 5px solid #4caf50;
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.15);
            font-weight: 500;
            animation: slideInDown 0.4s ease;
        }

        .info-message {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1565c0;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 5px solid #2196f3;
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.15);
            font-weight: 500;
            animation: slideInDown 0.4s ease;
        }

        .warning-message {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #e65100;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 5px solid #ff9800;
            box-shadow: 0 4px 12px rgba(255, 152, 0, 0.15);
            font-weight: 500;
            animation: slideInDown 0.4s ease;
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
           RESPONSIVE DESIGN
           ============================================ */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .content-wrapper {
                padding: 20px;
                margin: 10px auto;
            }
            
            .content-wrapper h1,
            .content-wrapper h2 {
                font-size: 22px;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .detail-info {
                padding: 20px;
            }
            
            .action-bar {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .btn-submit,
            .btn-secondary {
                width: 100%;
                margin-right: 0;
                margin-bottom: 10px;
            }
        }

        @media (max-width: 480px) {
            .content-wrapper h1,
            .content-wrapper h2 {
                font-size: 20px;
            }
            
            .detail-item .value {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<div class="content-wrapper">
    <h2>Confirmation de la commande</h2>
    
    <div class="detail-info">
        <div class="detail-item">
            <label>Numéro devis :</label>
            <div class="value">${empty devis.numeroDevis ? 'N/A' : devis.numeroDevis}</div>
        </div>
        
        <div class="detail-item">
            <label>Client :</label>
            <div class="value">${devis.idClient}</div>
        </div>
        
        <div class="detail-item">
            <label>Montant TTC :</label>
            <div class="value">${devis.montantTtc}</div>
        </div>
    </div>

    <div class="form-container">
        <form action="${pageContext.request.contextPath}/vente/commandes/creer" method="post">
            <input type="hidden" name="idDevis" value="${devis.idDevis}" />

            <div class="form-group">
                <label>Date de livraison souhaitée :</label>
                <input type="date" name="dateLivraison" class="form-input" required />
            </div>

            <div class="action-bar">
                <div>
                    <button type="submit" class="btn-submit">Confirmer la commande</button>
                </div>
                
                <div>
                    <a href="${pageContext.request.contextPath}/vente/commandes/a-valider" class="back-link">
                        ← Retour validation
                    </a>
                </div>
            </div>
        </form>
    </div>
</div>

</body>
</html>