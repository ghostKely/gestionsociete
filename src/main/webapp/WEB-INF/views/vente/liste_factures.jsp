<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Liste Factures</title>
</head>
<body>

<h2>📄 Gestion Factures</h2>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<table border="1" width="100%">
    <tr>
        <th>Numéro</th>
        <th>Client</th>
        <th>Commande</th>
        <th>Date</th>
        <th>Statut</th>
        <th>Total TTC</th>
        <th>Action</th>
    </tr>

    <c:forEach items="${factures}" var="f">
        <tr>
            <td>${f.numeroFacture}</td>
            <td>${f.idClient}</td>
            <td>${f.idCommande}</td>
            <td>${f.dateFacture}</td>
            <td>${f.statut}</td>
            <td>${f.montantTtc}</td>
            <td>
                <a href="${pageContext.request.contextPath}/vente/factures/${f.idFacture}">
                    👁 Voir
                </a>
                <c:if test="${f.statut == 'BROUILLON'}">
                <form action="${pageContext.request.contextPath}/vente/factures/valider"
                    method="post" style="display:inline;">
                    <input type="hidden" name="idFacture" value="${f.idFacture}" />
                    <button type="submit">✅ Valider</button>
                </form>
            </c:if>
            <c:if test="${f.statut == 'VALIDEE'}">
                <form action="${pageContext.request.contextPath}/vente/factures/envoyer"
                    method="post" style="display:inline;">
                    <input type="hidden" name="idFacture" value="${f.idFacture}" />
                    <button type="submit">📤 Envoyer</button>
                </form>
            </c:if>

            </td>
             
        </tr>
    </c:forEach>
</table>

<br>
<a href="${pageContext.request.contextPath}/vente/factures/livraisons-facturables">📄 Livraisons facturables</a>
<br>
<a href="${pageContext.request.contextPath}/vente/accueil">⬅ Retour</a>

</body>
</html>
