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
                        <c:forEach var="f" items="${factures}">
                            <tr>
                                <td>${f.numeroFacture}</td>
                                <td>${f.idClient}</td>
                                <td>${f.idCommande}</td>
                                <td>${f.dateFacture}</td>
                                <td>
                                    <span class="status-badge status-${f.statut == 'BROUILLON' ? 'brouillon' : 
                                                                       f.statut == 'VALIDEE' ? 'validee' : 
                                                                       f.statut == 'ENVOYEE' ? 'envoyee' : 'autre'}">
                                        ${f.statut}
                                    </span>
                                </td>
                                <td>${f.montantTtc}</td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/vente/factures/${f.idFacture}" 
                                           class="btn-action btn-view">
                                            👁 Voir
                                        </a>
                                        
                                        <c:if test="${f.statut == 'BROUILLON'}">
                                            <form action="${pageContext.request.contextPath}/vente/factures/valider"
                                                  method="post" class="inline-form">
                                                <input type="hidden" name="idFacture" value="${f.idFacture}" />
                                                <button type="submit" class="btn-action btn-validate">✅ Valider</button>
                                            </form>
                                        </c:if>
                                        
                                        <c:if test="${f.statut == 'VALIDEE'}">
                                            <form action="${pageContext.request.contextPath}/vente/factures/envoyer"
                                                  method="post" class="inline-form">
                                                <input type="hidden" name="idFacture" value="${f.idFacture}" />
                                                <button type="submit" class="btn-action btn-send">📤 Envoyer</button>
                                            </form>
                                        </c:if>
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
                <a href="${pageContext.request.contextPath}/vente/factures/livraisons-facturables" 
                   class="nav-link nav-link-factures">
                    📄 Livraisons facturables
                </a>
                <a href="${pageContext.request.contextPath}/vente/accueil" class="btn-secondary">⬅ Retour</a>
            </div>
        </div>
    </div>
</body>
</html>