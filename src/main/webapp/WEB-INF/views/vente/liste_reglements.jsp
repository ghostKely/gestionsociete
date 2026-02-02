<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des Règlements - Module Vente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vente.css">
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>Historique des Règlements</h1>

            <div class="table-section">
                <table>
                    <thead>
                        <tr>
                            <th>Numéro</th>
                            <th>Client</th>
                            <th>Date</th>
                            <th>Montant</th>
                            <th>Mode</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${reglements}" var="r">
                            <tr>
                                <td>${r.numeroReglement}</td>
                                <td>${r.idClient}</td>
                                <td>${r.dateReglement}</td>
                                <td>${r.montant} Ar</td>
                                <td>${r.modeReglement}</td>
                                <td>
                                    <span class="status-badge status-${r.statut == 'ENCAISSE' ? 'payee' : 'en-attente'}">
                                        ${r.statut}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty reglements}">
                    <div class="no-data">
                        Aucun règlement trouvé
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
