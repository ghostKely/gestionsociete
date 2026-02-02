<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Créer Commande Client</title>
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
           CONTENT WRAPPER
           ============================================ */
        .container {
            max-width: 1200px;
            margin: 20px auto;
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
        h2 {
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 28px;
            border-bottom: 2px solid #e67e22;
            padding-bottom: 15px;
            font-weight: 700;
            text-align: center;
        }

        /* ============================================
           MESSAGES STYLES
           ============================================ */
        .success-message {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 5px solid #4caf50;
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.15);
            font-weight: 500;
            text-align: center;
            animation: slideInDown 0.4s ease;
        }

        .error-message {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #c62828;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 5px solid #f44336;
            box-shadow: 0 4px 12px rgba(244, 67, 54, 0.15);
            font-weight: 500;
            text-align: center;
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
           TABLE STYLES
           ============================================ */
        .table-container {
            margin-top: 30px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background-color: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(230, 126, 34, 0.08);
            border: 1px solid #ffe8d6;
        }

        table thead {
            background: linear-gradient(135deg, #e67e22, #d35400);
        }

        table thead th {
            padding: 16px 18px;
            color: #ffffff;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            text-align: center;
            border-bottom: 3px solid #ba4a00;
        }

        table tbody tr {
            background-color: #fffaf5;
            transition: all 0.3s ease;
        }

        table tbody tr:nth-child(even) {
            background-color: #fff5eb;
        }

        table tbody tr:hover {
            background-color: #ffe8d6;
            transform: scale(1.01);
            box-shadow: 0 4px 12px rgba(230, 126, 34, 0.1);
        }

        table td {
            padding: 16px 18px;
            font-size: 14px;
            color: #2c3e50;
            border-bottom: 1px solid #ffe8d6;
            text-align: center;
            vertical-align: middle;
        }

        table tbody tr:last-child td {
            border-bottom: none;
        }

        /* ============================================
           BUTTON STYLES
           ============================================ */
        .btn-primary,
        .btn-create,
        .back-link {
            padding: 12px 24px;
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

        .btn-create {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            white-space: nowrap;
        }

        .btn-create:hover {
            background: linear-gradient(135deg, #229954, #1e8449);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(39, 174, 96, 0.3);
        }

        .back-link {
            background-color: #ecf0f1;
            color: #5d4037;
            border: 1px solid #d5dbdb;
            margin-top: 30px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-link:hover {
            background-color: #d5dbdb;
            transform: translateY(-2px);
        }

        /* ============================================
           ACTION CELL STYLING
           ============================================ */
        .action-cell {
            text-align: center;
        }

        /* ============================================
           NO DATA MESSAGE
           ============================================ */
        .no-data {
            text-align: center;
            padding: 50px;
            color: #7f8c8d;
            font-style: italic;
            background: linear-gradient(145deg, #fffaf5, #ffffff);
            border-radius: 12px;
            border: 2px dashed #ffe8d6;
            margin: 20px 0;
        }

        /* ============================================
           RESPONSIVE DESIGN
           ============================================ */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .container {
                padding: 20px;
                margin: 10px auto;
            }
            
            h2 {
                font-size: 24px;
            }
            
            .table-container {
                margin-top: 20px;
            }
            
            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
            
            table thead th,
            table td {
                padding: 12px 15px;
                font-size: 13px;
            }
            
            .btn-create {
                padding: 8px 16px;
                font-size: 13px;
            }
            
            .back-link {
                width: 100%;
                text-align: center;
                margin-top: 20px;
            }
        }

        @media (max-width: 480px) {
            h2 {
                font-size: 22px;
            }
            
            table thead th {
                font-size: 12px;
                padding: 10px 12px;
            }
            
            table td {
                font-size: 12px;
                padding: 10px 12px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Devis disponibles pour création de commande</h2>
        
        <c:if test="${not empty message}">
            <div class="success-message">
                ${message}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                ${error}
            </div>
        </c:if>
        
        <c:choose>
            <c:when test="${not empty devisList}">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Numéro</th>
                                <th>Client</th>
                                <th>Total TTC</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="devis" items="${devisList}">
                                <tr>
                                    <td>${devis.idDevis}</td>
                                    <td>${empty devis.numeroDevis ? 'N/A' : devis.numeroDevis}</td>
                                    <td>${devis.idClient}</td>
                                    <td>${devis.montantTtc}</td>
                                    <td class="action-cell">
                                        <a class="btn-create"
                                            href="${pageContext.request.contextPath}/vente/commandes/nouveau?idDevis=${devis.idDevis}">
                                            Créer commande
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    Aucun devis disponible pour la création de commande
                </div>
            </c:otherwise>
        </c:choose>
        
        <br>
        <a href="${pageContext.request.contextPath}/vente/accueil" class="back-link">← Retour accueil</a>
    </div>
</body>
</html>