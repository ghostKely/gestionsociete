<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Factures Validées</title>
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
           CONTENT WRAPPER
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

        /* Titre de la page */
        .page-title {
            margin-bottom: 30px;
            font-size: 28px;
            color: #2c3e50;
            border-bottom: 2px solid #e67e22;
            padding-bottom: 15px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* ============================================
           MESSAGES (SUCCESS / ERROR)
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
        .table-section {
            margin-top: 30px;
            margin-bottom: 30px;
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

        /* Styles pour les montants financiers */
        .montant-ttc {
            font-weight: 600;
            color: #d35400;
            font-size: 15px;
        }

        .montant-paye {
            font-weight: 600;
            color: #27ae60;
            font-size: 15px;
        }

        .solde-restant {
            font-weight: 600;
            color: #e74c3c;
            font-size: 15px;
        }

        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-validee {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-envoyee {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .status-payee {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-impayee {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .status-partielle {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        /* ============================================
           ACTION BUTTONS
           ============================================ */
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        .btn-view {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .btn-view:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
        }

        .btn-send {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
            color: white;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            padding: 10px 16px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .btn-send:hover {
            background: linear-gradient(135deg, #8e44ad, #7d3c98);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(155, 89, 182, 0.3);
        }

        /* Style spécifique pour les forms inline */
        .form-inline {
            display: inline;
        }

        /* ============================================
           NAVIGATION LINKS
           ============================================ */
        .navigation-links {
            display: flex;
            gap: 20px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .nav-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: linear-gradient(135deg, #ecf0f1, #d5dbdb);
            color: #5d4037;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .nav-link:hover {
            background: linear-gradient(135deg, #d5dbdb, #bdc3c7);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
            color: #2c3e50;
        }

        .nav-link-factures {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .nav-link-factures:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
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
        @media (max-width: 1024px) {
            .container {
                flex-direction: column;
            }
            
            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .content-wrapper {
                padding: 20px;
            }
            
            .page-title {
                font-size: 22px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-action,
            .btn-send {
                width: 100%;
                justify-content: center;
                padding: 8px 12px;
                font-size: 13px;
            }
            
            .navigation-links {
                flex-direction: column;
            }
            
            .nav-link {
                width: 100%;
                justify-content: center;
            }
            
            table thead th {
                padding: 12px 14px;
                font-size: 13px;
            }
            
            table td {
                padding: 12px 14px;
                font-size: 13px;
            }
        }

        @media (max-width: 480px) {
            .page-title {
                font-size: 20px;
            }
            
            .no-data {
                padding: 30px 20px;
            }
            
            .action-buttons {
                gap: 5px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1 class="page-title">📄 Factures Validées</h1>

            <c:if test="${not empty message}">
                <div class="success-message">${message}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty factures}">
                    <div class="table-section">
                        <table>
                            <thead>
                                <tr>
                                    <th>Numéro</th>
                                    <th>Client</th>
                                    <th>Commande</th>
                                    <th>Date</th>
                                    <th>Statut</th>
                                    <th>Total TTC</th>
                                    <th>Montant Payé</th>
                                    <th>Solde Restant</th>
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
                                            <c:choose>
                                                <c:when test="${not empty f.statut}">
                                                    <span class="status-badge status-${f.statut.toLowerCase().replace(' ', '-')}">
                                                        ${f.statut}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="montant-ttc">${f.montantTtc}</td>
                                        <td class="montant-paye">${f.montantPaye}</td>
                                        <td class="solde-restant">${f.soldeRestant}</td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/vente/factures/${f.idFacture}" 
                                                   class="btn-action btn-view">
                                                    👁 Voir
                                                </a>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/vente/factures/envoyer"
                                                      class="form-inline">
                                                    <input type="hidden" name="idFacture" value="${f.idFacture}" />
                                                    <button type="submit" class="btn-send">
                                                        📤 Envoyer
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        Aucune facture validée pour le moment.
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="navigation-links">
                <a href="${pageContext.request.contextPath}/vente/factures" 
                   class="nav-link nav-link-factures">
                    📄 Toutes les Factures
                </a>
                <a href="${pageContext.request.contextPath}/vente/accueil" 
                   class="nav-link">
                    ⬅ Retour à l'accueil
                </a>
            </div>
        </div>
    </div>
</body>
</html>