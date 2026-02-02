<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste Factures - Module Vente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vente.css">
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>Gestion Factures</h1>

            <c:if test="${not empty message}">
                <div class="success-message">${message}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>

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
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="facture" items="${factures}">
                            <tr>
                                <td>${facture.numeroFacture}</td>
                                <td>${facture.idClient}</td>
                                <td>${facture.idCommande}</td>
                                <td>${facture.dateFacture}</td>
                                <td>
                                    <span class="status-badge status-${facture.statut == 'PAYEE' ? 'payee' : (facture.statut == 'ENVOYEE' ? 'expediee' : 'en-attente')}">
                                        ${facture.statut}
                                    </span>
                                </td>
                                <td>${facture.montantTtc} Ar</td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/vente/factures/${facture.idFacture}" class="btn-action btn-view">Voir</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty factures}">
                    <div class="no-data">
                        Aucune facture trouvée
                    </div>
                </c:if>
            </div>

            <div class="form-buttons" style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/vente/accueil" class="btn-secondary">Retour</a>
            </div>
        </div>
    </div>
</body>
</html>
