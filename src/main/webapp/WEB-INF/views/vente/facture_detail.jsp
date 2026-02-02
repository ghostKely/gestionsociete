<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Détail Facture</title>
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
        .content-wrapper {
            max-width: 1200px;
            margin: 20px auto;
            background: linear-gradient(145deg, #ffffff, #fffaf5);
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(230, 126, 34, 0.1);
            border: 1px solid #ffe8d6;
            overflow: hidden;
        }

        .content-wrapper h2,
        .content-wrapper h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .content-wrapper h2 {
            font-size: 28px;
            border-bottom: 2px solid #e67e22;
            padding-bottom: 15px;
        }

        .content-wrapper h3 {
            font-size: 22px;
            color: #d35400;
            margin-top: 30px;
            border-bottom: 1px solid #ffe8d6;
            padding-bottom: 10px;
        }

        /* ============================================
           DETAIL INFO STYLES
           ============================================ */
        .detail-header {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .detail-card {
            background: linear-gradient(145deg, #fffaf5, #ffffff);
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #e67e22;
            box-shadow: 0 4px 12px rgba(230, 126, 34, 0.08);
        }

        .detail-card label {
            display: block;
            font-weight: 600;
            color: #5d4037;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .detail-card .value {
            font-size: 16px;
            color: #2c3e50;
            font-weight: 500;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-left: 10px;
        }

        .status-envoyee {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .status-partiellement-payee {
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
           TABLE STYLES
           ============================================ */
        .table-section {
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
            margin-bottom: 30px;
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
           PAYMENT FORM STYLES
           ============================================ */
        .payment-form {
            background: linear-gradient(145deg, #fffaf5, #ffffff);
            padding: 25px;
            border-radius: 14px;
            margin: 25px 0;
            border: 1px solid #ffe8d6;
            box-shadow: 0 4px 15px rgba(230, 126, 34, 0.08);
        }

        .payment-form h4 {
            color: #d35400;
            margin-bottom: 20px;
            font-size: 18px;
            border-bottom: 2px solid #ffe8d6;
            padding-bottom: 10px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .form-group {
            flex: 1;
            min-width: 200px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #5d4037;
            font-size: 14px;
        }

        .form-select,
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

        .form-select:focus,
        .form-input:focus {
            outline: none;
            border-color: #e67e22;
            box-shadow: 0 0 0 3px rgba(230, 126, 34, 0.15);
        }

        /* ============================================
           TOTALS SECTION
           ============================================ */
        .totals-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #ffe8d6;
        }

        .total-card {
            background: linear-gradient(145deg, #fffaf5, #ffffff);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid #ffe8d6;
            box-shadow: 0 4px 12px rgba(230, 126, 34, 0.08);
        }

        .total-card label {
            display: block;
            font-weight: 600;
            color: #5d4037;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .total-card .amount {
            font-size: 24px;
            font-weight: 700;
            color: #d35400;
        }

        /* ============================================
           BUTTON STYLES
           ============================================ */
        .btn-submit,
        .btn-primary {
            padding: 12px 28px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }

        .btn-submit:hover,
        .btn-primary:hover {
            background: linear-gradient(135deg, #229954, #1e8449);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(39, 174, 96, 0.3);
        }

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
            margin-top: 20px;
        }

        .back-link:hover {
            background-color: #d5dbdb;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        /* ============================================
           SEPARATOR
           ============================================ */
        hr {
            border: none;
            height: 1px;
            background: linear-gradient(to right, transparent, #ffe8d6, transparent);
            margin: 30px 0;
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
            
            .content-wrapper h2 {
                font-size: 24px;
            }
            
            .content-wrapper h3 {
                font-size: 20px;
            }
            
            .detail-header {
                grid-template-columns: 1fr;
            }
            
            .form-row {
                flex-direction: column;
            }
            
            .form-group {
                min-width: 100%;
            }
            
            .totals-section {
                grid-template-columns: 1fr;
            }
            
            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }

        @media (max-width: 480px) {
            .content-wrapper h2 {
                font-size: 22px;
            }
            
            .content-wrapper h3 {
                font-size: 18px;
            }
            
            .total-card .amount {
                font-size: 20px;
            }
            
            .btn-submit,
            .btn-primary,
            .back-link {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<div class="content-wrapper">
    <h2>📄 Facture ${facture.numeroFacture}
        <span class="status-badge status-${facture.statut.toLowerCase()}">
            ${facture.statut}
        </span>
    </h2>

    <div class="detail-header">
        <div class="detail-card">
            <label>Client :</label>
            <div class="value">${facture.idClient}</div>
        </div>
        
        <div class="detail-card">
            <label>Commande :</label>
            <div class="value">${facture.idCommande}</div>
        </div>
        
        <div class="detail-card">
            <label>Livraison :</label>
            <div class="value">${facture.idLivraison}</div>
        </div>
        
        <div class="detail-card">
            <label>Date :</label>
            <div class="value">${facture.dateFacture}</div>
        </div>
    </div>

    <hr>

    <h3>Lignes de facture</h3>
    
    <div class="table-section">
        <table>
            <thead>
                <tr>
                    <th>Article</th>
                    <th>Qté</th>
                    <th>PU HT</th>
                    <th>Remise %</th>
                    <th>Montant HT</th>
                    <th>TVA</th>
                    <th>Total TTC</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${lignes}" var="l">
                    <tr>
                        <td>${l.idArticle}</td>
                        <td>${l.quantite}</td>
                        <td>${l.prixUnitaireHt}</td>
                        <td>${l.remise}</td>
                        <td>${l.montantHt}</td>
                        <td>${l.montantTva}</td>
                        <td>${l.montantTtc}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${facture.statut == 'ENVOYEE' || facture.statut == 'PARTIELLEMENT_PAYEE'}">
        <div class="payment-form">
            <h4>💰 Encaisser un paiement</h4>
            <form action="${pageContext.request.contextPath}/vente/factures/encaisser" method="post">
                <input type="hidden" name="idFacture" value="${facture.idFacture}" />
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Montant :</label>
                        <input type="number" name="montant" step="0.01" class="form-input" required />
                    </div>
                    
                    <div class="form-group">
                        <label>Mode de paiement :</label>
                        <select name="modePaiement" class="form-select" required>
                            <option value="VIREMENT">Virement</option>
                            <option value="CHEQUE">Chèque</option>
                            <option value="CARTE">Carte</option>
                            <option value="ESPECES">Espèces</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn-submit">Encaisser</button>
                    </div>
                </div>
            </form>
        </div>
    </c:if>

    <hr>

    <h3>Totaux</h3>
    
    <div class="totals-section">
        <div class="total-card">
            <label>Total HT</label>
            <div class="amount">${facture.montantTotalHt}</div>
        </div>
        
        <div class="total-card">
            <label>Total TVA</label>
            <div class="amount">${facture.montantTva}</div>
        </div>
        
        <div class="total-card">
            <label>Total TTC</label>
            <div class="amount">${facture.montantTtc}</div>
        </div>
    </div>

    <br>
    <a href="${pageContext.request.contextPath}/vente/factures" class="back-link">
        ⬅ Retour à la liste des factures
    </a>
</div>

</body>
</html>