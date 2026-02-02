<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Liste Factures</title>
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
            max-width: 1400px;
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
        }

        /* ============================================
           TABLE CONTAINER
           ============================================ */
        .table-section {
            margin-top: 30px;
            overflow-x: auto;
        }

        /* ============================================
           TABLE STYLES
           ============================================ */
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
            text-align: left;
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
        }

        table tbody tr:last-child td {
            border-bottom: none;
        }

        /* ============================================
           STATUS BADGES
           ============================================ */
        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-envoyee,
        .status-a_encaisser {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .status-partiellement_payee {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-payee {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-annulee {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* ============================================
           AMOUNT STYLING
           ============================================ */
        .amount-paid {
            color: #27ae60;
            font-weight: 600;
        }

        .amount-remaining {
            color: #e74c3c;
            font-weight: 600;
        }

        .amount-total {
            color: #2c3e50;
            font-weight: 600;
        }

        /* ============================================
           ACTION BUTTONS
           ============================================ */
        .btn-view {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.2);
        }

        .btn-view:hover {
            background: linear-gradient(135deg, #2980b9, #21618c);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }

        /* ============================================
           BACK LINK
           ============================================ */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background-color: #ecf0f1;
            color: #5d4037;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid #d5dbdb;
            margin-top: 30px;
        }

        .back-link:hover {
            background-color: #d5dbdb;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
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
        @media (max-width: 1200px) {
            .container {
                padding: 25px;
            }
            
            table thead th,
            table td {
                padding: 14px 16px;
                font-size: 13px;
            }
        }

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
            
            .table-section {
                margin-top: 20px;
            }
            
            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
            
            .btn-view {
                padding: 6px 12px;
                font-size: 13px;
            }
            
            .status-badge {
                padding: 4px 10px;
                font-size: 12px;
            }
            
            .back-link {
                width: 100%;
                text-align: center;
                justify-content: center;
                margin-top: 20px;
            }
        }

        @media (max-width: 480px) {
            h2 {
                font-size: 22px;
            }
            
            table thead th {
                font-size: 12px;
                padding: 12px 14px;
            }
            
            table td {
                font-size: 12px;
                padding: 12px 14px;
            }
            
            .btn-view {
                padding: 4px 10px;
                font-size: 12px;
            }
            
            .status-badge {
                padding: 3px 8px;
                font-size: 11px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>💰 Factures à encaisser</h2>
        
        <div class="table-section">
            <c:choose>
                <c:when test="${not empty factures}">
                    <table>
                        <thead>
                            <tr>
                                <th>Numéro</th>
                                <th>Client</th>
                                <th>Commande</th>
                                <th>Date</th>
                                <th>Statut</th>
                                <th>Total TTC</th>
                                <th>Montant payé</th>
                                <th>Solde restant</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${factures}" var="f">
                                <tr>
                                    <td>${f.numeroFacture}</td>
                                    <td>${f.idClient}</td>
                                    <td>${f.idCommande}</td>
                                    <td>${f.dateFacture}</td>
                                    <td>
                                        <span class="status-badge status-${f.statut.toLowerCase()}">
                                            ${f.statut}
                                        </span>
                                    </td>
                                    <td class="amount-total">${f.montantTtc}</td>
                                    <td class="amount-paid">${f.montantPaye}</td>
                                    <td class="amount-remaining">${f.soldeRestant}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/vente/factures/${f.idFacture}" 
                                           class="btn-view">
                                            👁 Voir
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        Aucune facture à encaisser
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <br>
        <a href="${pageContext.request.contextPath}/vente/accueil" class="back-link">
            ⬅ Retour à l'accueil
        </a>
    </div>
</body>
</html>