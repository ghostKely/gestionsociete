<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

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
    }

    /* ============================================
       MESSAGES
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

    .status-livre {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .status-en_cours,
    .status-a_facturer {
        background-color: #fff3cd;
        color: #856404;
        border: 1px solid #ffeaa7;
    }

    .status-annule {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .status-facture {
        background-color: #d1ecf1;
        color: #0c5460;
        border: 1px solid #bee5eb;
    }

    /* ============================================
       ACTION BUTTONS
       ============================================ */
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
        border: none;
        padding: 10px 20px;
        border-radius: 8px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        width: 100%;
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
       FORM STYLING
       ============================================ */
    form {
        margin: 0;
        padding: 0;
    }

    input[type="hidden"] {
        display: none;
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
        
        .table-section {
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
            justify-content: center;
            margin-top: 20px;
        }
        
        .status-badge {
            padding: 4px 10px;
            font-size: 12px;
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
        
        .btn-create {
            padding: 6px 12px;
            font-size: 12px;
        }
        
        .status-badge {
            padding: 3px 8px;
            font-size: 11px;
        }
    }
</style>

<div class="container">
    <h2>📄 Livraisons facturables</h2>
    
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
    
    <div class="table-section">
        <c:choose>
            <c:when test="${not empty livraisons}">
                <table>
                    <thead>
                        <tr>
                            <th>Livraison</th>
                            <th>Commande</th>
                            <th>Date</th>
                            <th>Statut</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${livraisons}" var="liv">
                            <tr>
                                <td>${liv.numeroLivraison}</td>
                                <td>${liv.idCommande}</td>
                                <td>${liv.dateLivraison}</td>
                                <td>
                                    <span class="status-badge status-${liv.statut.toLowerCase()}">
                                        ${liv.statut}
                                    </span>
                                </td>
                                <td>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/vente/factures/creer">
                                        <input type="hidden" name="idLivraison" value="${liv.idLivraison}" />
                                        <button type="submit" class="btn-create">Créer facture</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    Aucune livraison facturable disponible
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <br>
    <a href="${pageContext.request.contextPath}/vente/accueil" class="back-link">
        ⬅ Retour à l'accueil
    </a>
</div>