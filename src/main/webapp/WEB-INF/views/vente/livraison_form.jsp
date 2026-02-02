<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Nouvelle Livraison</title>
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
           MESSAGES (ERROR)
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
           FORM STYLES
           ============================================ */
        .form-container {
            background: linear-gradient(145deg, #fffaf5, #ffffff);
            padding: 30px;
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
           INFO COMMANDE
           ============================================ */
        .commande-info {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 5px solid #27ae60;
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.15);
        }

        .commande-info p {
            margin-bottom: 10px;
            font-size: 15px;
        }

        .commande-info strong {
            color: #155724;
            min-width: 150px;
            display: inline-block;
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

        /* Input dans le tableau */
        .qty-input {
            width: 80px;
            padding: 8px 12px;
            border: 1px solid #ffd5b3;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
            background-color: white;
            transition: all 0.3s ease;
        }

        .qty-input:focus {
            outline: none;
            border-color: #e67e22;
            box-shadow: 0 0 0 2px rgba(230, 126, 34, 0.15);
        }

        /* Texte "Complet" */
        .complete-text {
            color: #27ae60;
            font-weight: 600;
            font-style: italic;
        }

        /* ============================================
           BOUTONS
           ============================================ */
        .form-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn-submit,
        .btn-retour {
            padding: 12px 28px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-submit {
            background: linear-gradient(135deg, #e67e22, #d35400);
            color: white;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #d35400, #ba4a00);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(230, 126, 34, 0.3);
        }

        .btn-retour {
            background: linear-gradient(135deg, #ecf0f1, #d5dbdb);
            color: #5d4037;
        }

        .btn-retour:hover {
            background: linear-gradient(135deg, #d5dbdb, #bdc3c7);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
            color: #2c3e50;
        }

        /* ============================================
           RESPONSIVE DESIGN
           ============================================ */
        @media (max-width: 1024px) {
            .container {
                flex-direction: column;
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
            
            .form-container {
                padding: 20px;
            }
            
            .commande-info p {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }
            
            .commande-info strong {
                min-width: auto;
            }
            
            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
            
            .form-buttons {
                flex-direction: column;
            }
            
            .btn-submit,
            .btn-retour {
                width: 100%;
                justify-content: center;
                padding: 10px 20px;
                font-size: 14px;
            }
            
            .qty-input {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .page-title {
                font-size: 20px;
            }
            
            table thead th {
                padding: 12px 14px;
                font-size: 13px;
            }
            
            table td {
                padding: 12px 14px;
                font-size: 13px;
            }
            
            .commande-info {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1 class="page-title">🚚 Préparer livraison</h1>

            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/vente/livraisons/creer">
                <div class="form-container">
                    <input type="hidden" name="idCommande" value="${commande.idCommande}" />

                    <div class="commande-info">
                        <p>
                            <strong>Commande :</strong> 
                            ${empty commande.numeroCommande ? 'N/A' : commande.numeroCommande}
                        </p>
                        <p>
                            <strong>Date commande :</strong> 
                            ${commande.dateCommande}
                        </p>
                    </div>

                    <div class="form-group">
                        <label for="transporteur">Transporteur : <span style="color: #e74c3c;">*</span></label>
                        <input type="text" 
                               id="transporteur"
                               name="transporteur" 
                               class="form-input" 
                               required 
                               placeholder="Nom du transporteur" />
                    </div>

                    <div class="form-group">
                        <label for="numeroSuivi">Numéro de suivi :</label>
                        <input type="text" 
                               id="numeroSuivi"
                               name="numeroSuivi" 
                               class="form-input" 
                               placeholder="Numéro de suivi (optionnel)" />
                    </div>

                    <!-- ✅ TABLE DOIT ÊTRE ICI -->
                    <div class="table-section">
                        <table>
                            <thead>
                                <tr>
                                    <th>Article</th>
                                    <th>Qté commandée</th>
                                    <th>Déjà livrée</th>
                                    <th>Reste</th>
                                    <th>À livrer</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${lignesCommande}" var="ligne">
                                    <c:set var="qtyLivree" value="${ligne.quantiteLivree != null ? ligne.quantiteLivree : 0}" />
                                    <c:set var="reste" value="${ligne.quantiteCommandee - qtyLivree}" />

                                    <tr>
                                        <td>${ligne.idArticle}</td>
                                        <td>${ligne.quantiteCommandee}</td>
                                        <td>${qtyLivree}</td>
                                        <td>${reste}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reste > 0}">
                                                    <input type="number"
                                                           name="qty_${ligne.idLigneCommande}"
                                                           min="0"
                                                           max="${reste}"
                                                           value="${reste}"
                                                           class="qty-input" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="complete-text">✓ Complet</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="form-buttons">
                        <button type="submit" class="btn-submit">
                            📦 Créer la livraison
                        </button>
                        <a href="${pageContext.request.contextPath}/vente/livraisons" 
                           class="btn-retour">
                            ⬅ Retour
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>