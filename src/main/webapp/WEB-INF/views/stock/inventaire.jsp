<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventaire - Gestion Stock</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/inventaire.css">
</head>
<body>
    <div class="container">
        <!-- LEFT PART — Navbar -->
        <div class="navbar">
            <h2>📊 Menu Inventaire</h2>
            <ul>
                <li><a href="${pageContext.request.contextPath}/inventaire/pageInventaire">📝 Nouvel Inventaire</a></li>
                <li><a href="${pageContext.request.contextPath}/inventaire/historique">📋 Historique</a></li>
                <li><a href="${pageContext.request.contextPath}/stock/dashboard">🏠 Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/transfert/transfertpage">🔄 Initialisation Transfert</a></li>
                <li><a href="${pageContext.request.contextPath}/stock/articles">🛍️ Liste des articles</a></li>
                <li><a href="${pageContext.request.contextPath}/stock/mouvements">⏳ Historique des mouvements</a></li>
            </ul>
        </div>

        <!-- RIGHT PART — Content -->
        <div class="content-wrapper">
            <h1>📦 Formulaire d'Inventaire</h1>
            
            <!-- Messages -->
            <c:if test="${not empty error}">
                <div class="error-message">⚠️ ${error}</div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="success-message">✅ ${message}</div>
                <c:remove var="message" scope="session"/>
            </c:if>
            
            <!-- Formulaire d'ajout -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/inventaire/ajouter" method="post">
                    <div class="form-group">
                        <label for="article">Article :</label>
                        <select id="article" name="idArticle" required class="form-select">
                            <option value="">-- Sélectionner un article --</option>
                            <c:forEach var="article" items="${articles}">
                                <option value="${article[0]}">${article[1]} - ${article[2]}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="nbreArticle">Nombre d'articles comptés :</label>
                        <input type="number" id="nbreArticle" name="nbreArticle" 
                            min="0" required class="form-input" placeholder="Ex: 10">
                    </div>

                    <div class="form-group">
                        <label for="commentaire">Commentaire :</label>
                        <textarea id="commentaire" name="commentaire" 
                                class="form-textarea" 
                                placeholder="Ex: Stock trouvé dans le rayon B..."></textarea>
                    </div>

                    <div class="form-buttons">
                        <button type="submit" class="btn-submit">💾 Enregistrer</button>
                    </div>
                </form>
            </div>

            <!-- Liste des inventaires récents -->
            <div class="recent-inventories">
                <h2>🕐 Inventaires Récents</h2>
                <c:choose>
                    <c:when test="${not empty inventaires}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Article</th>
                                    <th>Quantité</th>
                                    <th>Utilisateur</th>
                                    <th>Commentaire</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="inv" items="${inventaires}">
                                    <tr>
                                        <td>
                                            <fmt:formatDate value="${inv[1]}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <strong>${inv[4]}</strong><br>
                                            <small>${inv[5]}</small>
                                        </td>
                                        <td class="${inv[2] < 10 ? 'low-stock' : ''}">
                                            ${inv[2]}
                                        </td>
                                        <td>${inv[6]} ${inv[7]}</td>
                                        <td>
                                            <c:if test="${not empty inv[3]}">${inv[3]}</c:if>
                                            <c:if test="${empty inv[3]}"><span class="no-comment">-</span></c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p class="no-data">Aucun inventaire enregistré.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // Auto-focus sur le champ quantité
        document.getElementById('article').addEventListener('change', function() {
            if (this.value) {
                document.getElementById('nbreArticle').focus();
            }
        });
        
        // Validation du formulaire
        document.querySelector('form').addEventListener('submit', function(e) {
            const article = document.getElementById('article').value;
            const quantite = document.getElementById('nbreArticle').value;
            
            if (!article) {
                alert('Veuillez sélectionner un article');
                e.preventDefault();
                return false;
            }
            
            if (!quantite || quantite < 0) {
                alert('Veuillez saisir une quantité valide (≥ 0)');
                e.preventDefault();
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>