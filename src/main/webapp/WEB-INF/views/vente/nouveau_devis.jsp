<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Devis - Module Vente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vente.css">
</head>
<body>
    <div class="container">
        <div class="content-wrapper">
            <h1>Nouveau Devis</h1>

            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/vente/devis/creer" method="post" class="form-container">

                <!-- Client -->
                <div class="form-group">
                    <label for="idClient">Client <span class="required">*</span></label>
                    <select name="idClient" id="idClient" class="form-select" required>
                        <option value="">Sélectionner un client</option>
                        <c:forEach var="client" items="${clients}">
                            <option value="${client.idClient}">
                                ${empty client.nom ? '' : client.nom} (${empty client.codeClient ? '' : client.codeClient})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Date -->
                <div class="form-group">
                    <label for="dateValidite">Date de validité <span class="required">*</span></label>
                    <input type="date" name="dateValidite" id="dateValidite" class="form-input" required>
                </div>

                <!-- Notes -->
                <div class="form-group">
                    <label for="notes">Notes</label>
                    <textarea name="notes" id="notes" class="form-textarea" rows="4"></textarea>
                </div>

                <!-- Si l'utilisateur n'est PAS commercial -->
                <c:if test="${!isCommercial}">
                    <div class="form-group">
                        <label for="idCommercial">Commercial <span class="required">*</span></label>
                        <select name="idCommercial" id="idCommercial" class="form-select" required>
                            <option value="">Sélectionner un commercial</option>
                            <c:forEach var="comm" items="${commerciaux}">
                                <option value="${comm.idUtilisateur}">
                                    ${empty comm.nom ? '' : comm.nom} ${empty comm.prenom ? '' : comm.prenom} (${empty comm.email ? '' : comm.email})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>

                <!-- Si l'utilisateur EST commercial -->
                <c:if test="${isCommercial and not empty utilisateur}">
                    <div class="info-message">
                        <strong>Commercial:</strong> ${empty utilisateur.nom ? '' : utilisateur.nom} ${empty utilisateur.prenom ? '' : utilisateur.prenom}
                    </div>
                </c:if>

                <!-- Articles -->
                <div class="form-group">
                    <label>Articles sélectionnés</label>

                    <c:choose>
                        <c:when test="${not empty selectedArticles}">
                            <div class="table-section">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Désignation</th>
                                            <th>Code</th>
                                            <th>Prix Unitaire</th>
                                            <th>Quantité</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="article" items="${selectedArticles}">
                                            <tr>
                                                <td><strong>${empty article.designation ? 'N/A' : article.designation}</strong></td>
                                                <td>${empty article.code ? '' : article.code}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty unitPrices[article.idArticle]}">
                                                            ${unitPrices[article.idArticle]} Ar
                                                        </c:when>
                                                        <c:otherwise>
                                                            N/A
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <input type="number"
                                                           name="qty_${article.idArticle}"
                                                           value="1"
                                                           min="1"
                                                           class="form-input"
                                                           style="width:100px;" />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="error-message">
                                Aucun article sélectionné. Veuillez retourner à la liste des articles.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Boutons -->
                <c:if test="${not empty selectedArticles}">
                    <div class="form-buttons">
                        <c:choose>
                            <c:when test="${isCommercial and not empty utilisateur}">
                                <input type="hidden" name="idCommercial" value="${utilisateur.idUtilisateur}"/>
                                <button type="submit" class="btn-submit">Créer Devis</button>
                            </c:when>

                            <c:otherwise>
                                <button type="submit" class="btn-submit">Créer Devis</button>
                            </c:otherwise>
                        </c:choose>
                        
                        <a href="${pageContext.request.contextPath}/vente/articles" class="btn-secondary">Annuler</a>
                    </div>
                </c:if>

            </form>

            <div class="form-buttons" style="margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/vente/accueil" class="btn-secondary">Retour à l'accueil</a>
            </div>
        </div>
    </div>
</body>
</html>
