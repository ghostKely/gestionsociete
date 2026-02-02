<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Devis - Module Vente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vente.css">
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>Liste des Devis</h1>

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
                            <th>ID</th>
                            <th>Numéro</th>
                            <th>Client</th>
                            <th>Statut</th>
                            <th>Total TTC</th>
                            <th>Validateur</th>
                            <th>Date validation</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="devis" items="${devisList}">
                            <tr>
                                <td>${devis.idDevis}</td>
                                <td>${devis.numeroDevis}</td>
                                <td>${devis.idClient}</td>
                                <td>
                                    <span class="status-badge status-${devis.statut == 'A_VALIDER' ? 'en-attente' : (devis.statut == 'ACCEPTE' ? 'accepte' : 'annule')}">
                                        ${devis.statut}
                                    </span>
                                </td>
                                <td>${devis.montantTtc} Ar</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty devis.idValidateur}">
                                            ${devis.idValidateur}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty devis.dateValidation}">
                                            ${devis.dateValidation}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <c:if test="${devis.statut == 'A_VALIDER'}">
                                            <c:if test="${utilisateur.nomRole == 'ADMIN' || utilisateur.nomRole == 'VALIDEUR_N1' || utilisateur.nomRole == 'VALIDEUR_N2'}">
                                                <form action="${pageContext.request.contextPath}/vente/devis/valider" method="post" style="display:inline;">
                                                    <input type="hidden" name="idDevis" value="${devis.idDevis}">
                                                    <button type="submit" class="btn-action btn-validate">Valider</button>
                                                </form>

                                                <form action="${pageContext.request.contextPath}/vente/devis/refuser" method="post" style="display:inline;">
                                                    <input type="hidden" name="idDevis" value="${devis.idDevis}">
                                                    <button type="submit" class="btn-action btn-delete">Refuser</button>
                                                </form>
                                            </c:if>
                                        </c:if>

                                        <c:if test="${devis.statut == 'ACCEPTE'}">
                                            <form action="${pageContext.request.contextPath}/vente/devis/transformer-en-commande" method="post" style="display:inline;">
                                                <input type="hidden" name="idDevis" value="${devis.idDevis}">
                                                <button type="submit" class="btn-action btn-primary">Transformer en commande</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty devisList}">
                    <div class="no-data">
                        Aucun devis trouvé
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
