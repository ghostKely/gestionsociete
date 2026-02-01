<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfert entre Dépôts</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/transfert.css">
</head>
<body>
    <div class="container">
        <!-- Navbar -->
        <nav class="navbar">
            <h2>🔄 Menu Transfert</h2>
            <ul>
                <li><a href="${pageContext.request.contextPath}/transfert" class="active">🔄 Nouveau Transfert</a></li>
                <li><a href="${pageContext.request.contextPath}/transfert/historique">📋 Historique</a></li>
                <li><a href="${pageContext.request.contextPath}/inventaire/pageInventaire">📦 Inventaire</a></li>
                <li><a href="${pageContext.request.contextPath}/stock">📈 Stock actuel</a></li>
                <li><a href="${pageContext.request.contextPath}/stock/dashboard">🏠 Dashboard</a></li>
            </ul>
        </nav>

        <!-- Contenu principal -->
        <div class="content-wrapper">
            <h1>🔄 Transfert depuis le Dépôt Central</h1>
            
            <!-- Messages -->
            <c:if test="${not empty error}">
                <div class="error-message">⚠️ ${error}</div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="success-message">✅ ${message}</div>
            </c:if>
            
            <!-- Info dépôt central -->
            <div class="info-box" style="margin-bottom: 25px;">
                <h3>🏭 Dépôt Central</h3>
                <p><strong>Code :</strong> ${depotCentral.codeDepot}</p>
                <p><strong>Nom :</strong> ${depotCentral.nomDepot}</p>
                <p><strong>Responsable :</strong> ${depotCentral.responsable.nom} ${depotCentral.responsable.prenom}</p>
            </div>
            
            <!-- Formulaire de transfert -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/transfert/effectuer" method="post" id="transfertForm">
                    <!-- Champ caché pour le dépôt source (dépôt central) -->
                    <input type="hidden" name="idDepotSource" value="${depotCentral.id}">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="article">Article à transférer :</label>
                            <select id="article" name="idArticle" required class="form-select">
                                <option value="">-- Sélectionner un article --</option>
                                <c:forEach var="article" items="${articles}">
                                    <option value="${article[0]}" data-quantite="${article[3]}">
                                        ${article[1]} - ${article[2]} (Disponible: ${article[3]})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="depotSource" style="opacity: 0.7;">Dépôt source :</label>
                            <div class="depot-source-display">
                                <div class="depot-central">
                                    <strong>${depotCentral.codeDepot}</strong> - ${depotCentral.nomDepot}
                                    <span class="depot-badge">CENTRAL</span>
                                </div>
                            </div>
                            <small style="color: #666; font-size: 12px; display: block; margin-top: 5px;">
                                Le dépôt central est toujours la source des transferts
                            </small>
                        </div>

                        <div class="form-group">
                            <label for="depotDestination">Dépôt destination :</label>
                            <select id="depotDestination" name="idDepotDestination" required class="form-select">
                                <option value="">-- Sélectionner le dépôt destination --</option>
                                <c:forEach var="depot" items="${depots}">
                                    <c:if test="${depot[0] != depotCentral.id}">
                                        <option value="${depot[0]}">
                                            ${depot[1]} - ${depot[2]} (${depot[3]})
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                            <small style="color: #666; font-size: 12px; display: block; margin-top: 5px;">
                                Sélectionnez un dépôt de destination
                            </small>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="quantite">Quantité :</label>
                            <input type="number" id="quantite" name="quantite" 
                                   min="1" required class="form-input"
                                   placeholder="Ex: 5">
                        </div>

                        <div class="form-group">
                            <label for="numeroTransfert">Numéro de transfert :</label>
                            <input type="text" id="numeroTransfert" name="numeroTransfert" 
                                   class="form-input"
                                   placeholder="Généré automatiquement" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="commentaire">Commentaire :</label>
                        <textarea id="commentaire" name="commentaire" 
                                  class="form-textarea" 
                                  placeholder="Ex: Transfert vers le dépôt régional..."></textarea>
                    </div>

                    <div class="info-box">
                        <h3>💡 Information</h3>
                        <p id="stockInfo">Sélectionnez un article pour voir le stock disponible dans le dépôt central.</p>
                        <p id="transfertInfo" class="hidden">
                            <strong>Transfert depuis :</strong> ${depotCentral.nomDepot}<br>
                            <strong>Article :</strong> <span id="articleInfo"></span><br>
                            <strong>Vers :</strong> <span id="destinationInfo"></span><br>
                            <strong>Quantité :</strong> <span id="quantiteInfo"></span>
                        </p>
                    </div>

                    <div class="form-buttons">
                        <button type="submit" class="btn-submit">🔄 Effectuer le transfert</button>
                        <button type="reset" class="btn-reset">🔄 Réinitialiser</button>
                        <a href="${pageContext.request.contextPath}/transfert/historique" 
                           class="btn-history">📋 Voir historique</a>
                    </div>
                </form>
            </div>

            <!-- Dernier transfert -->
            <c:if test="${not empty dernierTransfert}">
                <div class="last-transfer">
                    <h2>🕐 Dernier Transfert</h2>
                    <div class="transfer-card">
                        <p><strong>Numéro :</strong> ${dernierTransfert[0]}</p>
                        <p><strong>Date :</strong> <fmt:formatDate value="${dernierTransfert[1]}" pattern="dd/MM/yyyy HH:mm" /></p>
                        <p><strong>Article :</strong> ${dernierTransfert[4]}</p>
                        <p><strong>De :</strong> ${dernierTransfert[2]} <strong>Vers :</strong> ${dernierTransfert[3]}</p>
                        <p><strong>Quantité :</strong> ${dernierTransfert[5]}</p>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Vérifier le stock disponible dans le dépôt central
        function checkStock() {
            const articleId = document.getElementById('article').value;
            const depotCentralId = ${depotCentral.id}; // ID du dépôt central
            
            if (articleId) {
                fetch(`${pageContext.request.contextPath}/transfert/check-stock?articleId=${articleId}&depotId=${depotCentralId}`)
                    .then(response => response.text())
                    .then(data => {
                        if (data !== 'Erreur') {
                            const stockInfo = document.getElementById('stockInfo');
                            stockInfo.innerHTML = `<strong>Stock disponible dans le dépôt central :</strong> ${data} unités`;
                            
                            const quantiteInput = document.getElementById('quantite');
                            quantiteInput.max = data;
                            quantiteInput.setAttribute('title', `Maximum: ${data} unités`);
                            
                            if (parseInt(quantiteInput.value) > parseInt(data)) {
                                quantiteInput.value = data;
                            }
                        }
                    });
            }
        }
        
        // Mettre à jour les informations
        function updateInfo() {
            const articleSelect = document.getElementById('article');
            const destSelect = document.getElementById('depotDestination');
            const quantiteInput = document.getElementById('quantite');
            
            const selectedArticle = articleSelect.options[articleSelect.selectedIndex];
            const selectedDest = destSelect.options[destSelect.selectedIndex];
            
            if (articleSelect.value && destSelect.value) {
                document.getElementById('transfertInfo').classList.remove('hidden');
                document.getElementById('articleInfo').textContent = selectedArticle.text.split(' (')[0];
                document.getElementById('destinationInfo').textContent = selectedDest.text;
                document.getElementById('quantiteInfo').textContent = quantiteInput.value || '0';
            } else {
                document.getElementById('transfertInfo').classList.add('hidden');
            }
        }
        
        // Écouteurs d'événements
        document.getElementById('article').addEventListener('change', checkStock);
        document.getElementById('depotDestination').addEventListener('change', updateInfo);
        document.getElementById('quantite').addEventListener('input', updateInfo);
        
        // Validation du formulaire
        document.getElementById('transfertForm').addEventListener('submit', function(e) {
            const article = document.getElementById('article').value;
            const destination = document.getElementById('depotDestination').value;
            const quantite = document.getElementById('quantite').value;
            
            if (!article || !destination || !quantite) {
                alert('Veuillez remplir tous les champs obligatoires');
                e.preventDefault();
                return false;
            }
            
            if (parseInt(quantite) <= 0) {
                alert('La quantité doit être supérieure à 0');
                e.preventDefault();
                return false;
            }
            
            // Vérifier le stock avant soumission
            const maxQuantite = parseInt(document.getElementById('quantite').max);
            if (parseInt(quantite) > maxQuantite) {
                alert(`Stock insuffisant! Maximum disponible: ${maxQuantite} unités`);
                e.preventDefault();
                return false;
            }
            
            return true;
        });
        
        // Générer un numéro de transfert
        document.getElementById('transfertForm').addEventListener('reset', function() {
            document.getElementById('transfertInfo').classList.add('hidden');
            document.getElementById('stockInfo').textContent = 'Sélectionnez un article pour voir le stock disponible dans le dépôt central.';
        });
        
        // Auto-générer un numéro de transfert
        document.addEventListener('DOMContentLoaded', function() {
            const now = new Date();
            const numero = 'TRANS-' + 
                now.getFullYear() + 
                String(now.getMonth() + 1).padStart(2, '0') + 
                String(now.getDate()).padStart(2, '0') + '-' +
                String(now.getHours()).padStart(2, '0') + 
                String(now.getMinutes()).padStart(2, '0') +
                String(now.getSeconds()).padStart(2, '0');
            
            document.getElementById('numeroTransfert').value = numero;
            
            // Vérifier le stock si un article est déjà sélectionné
            checkStock();
        });
    </script>
</body>
</html>