<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Validation des Commandes - Module Vente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vente.css">
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>Commandes à Valider</h1>

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
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cmd" items="${commandes}">
                            <tr>
                                <td>${cmd.idCommande}</td>
                                <td>${cmd.numeroCommande}</td>
                                <td>${cmd.idClient}</td>
                                <td>
                                    <span class="status-badge status-en-attente">
                                        ${cmd.statut}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${cmd.statut == 'A_VALIDER'}">
                                        <div class="action-buttons">
                                            <form action="${pageContext.request.contextPath}/vente/commandes/valider" method="post" style="display:inline;">
                                                <input type="hidden" name="idCommande" value="${cmd.idCommande}">
                                                <button type="submit" class="btn-action btn-validate">Valider</button>
                                            </form>

                                            <form action="${pageContext.request.contextPath}/vente/commandes/refuser" method="post" style="display:inline;">
                                                <input type="hidden" name="idCommande" value="${cmd.idCommande}">
                                                <input type="text" name="motif" placeholder="Motif" class="form-input" style="display:inline; width:150px; padding:8px;" required>
                                                <button type="submit" class="btn-action btn-delete">Refuser</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty commandes}">
                    <div class="no-data">
                        Aucune commande à valider
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
