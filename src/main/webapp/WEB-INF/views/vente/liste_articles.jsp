<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste Articles - Module Vente</title>
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
            max-width: 1400px;
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
        h1 {
            color: #2c3e50;
            text-align: center;
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
           CART INFO SECTION
           ============================================ */
        .cart-info {
            background: linear-gradient(145deg, #fffaf5, #ffffff);
            padding: 25px;
            border-radius: 14px;
            margin-bottom: 30px;
            border: 1px solid #ffe8d6;
            box-shadow: 0 4px 15px rgba(230, 126, 34, 0.08);
            text-align: center;
        }

        .cart-info strong {
            color: #d35400;
            font-size: 18px;
        }

        .selected-count {
            display: inline-block;
            background: linear-gradient(135deg, #e67e22, #d35400);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 600;
            margin: 0 5px;
            min-width: 30px;
        }

        #selected-list {
            margin-top: 15px;
            padding: 15px;
            background-color: #fff5eb;
            border-radius: 10px;
            border: 1px dashed #e67e22;
            max-height: 200px;
            overflow-y: auto;
        }

        .selected-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 12px;
            margin-bottom: 8px;
            background-color: white;
            border-radius: 8px;
            border-left: 3px solid #e67e22;
        }

        /* ============================================
           ARTICLES GRID
           ============================================ */
        .articles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin: 30px 0;
        }

        .article-card {
            background: linear-gradient(145deg, #ffffff, #fffaf5);
            border: 1px solid #ffe8d6;
            border-radius: 12px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(230, 126, 34, 0.08);
            position: relative;
            overflow: hidden;
        }

        .article-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(230, 126, 34, 0.15);
            border-color: #e67e22;
        }

        .article-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 60px;
            height: 60px;
            background: radial-gradient(circle, rgba(230, 126, 34, 0.1), transparent);
            border-radius: 50%;
            transform: translate(20%, -20%);
        }

        .article-card h3 {
            margin: 0 0 15px 0;
            color: #2c3e50;
            font-size: 18px;
            font-weight: 600;
            min-height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .article-card p {
            margin: 8px 0;
            color: #5d4037;
            font-size: 14px;
        }

        .article-card p strong {
            color: #d35400;
            font-weight: 600;
        }

        /* ============================================
           BUTTON STYLES
           ============================================ */
        .add-btn,
        .btn-submit,
        .btn-danger,
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

        .add-btn {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
            margin-top: 15px;
            width: 100%;
        }

        .add-btn:hover {
            background: linear-gradient(135deg, #229954, #1e8449);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(39, 174, 96, 0.3);
        }

        .btn-submit {
            background: linear-gradient(135deg, #e67e22, #d35400);
            color: white;
            margin-top: 15px;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #d35400, #ba4a00);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(230, 126, 34, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            padding: 4px 10px;
            font-size: 12px;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(231, 76, 60, 0.3);
        }

        .back-link {
            background-color: #ecf0f1;
            color: #5d4037;
            border: 1px solid #d5dbdb;
            margin-top: 30px;
        }

        .back-link:hover {
            background-color: #d5dbdb;
            transform: translateY(-2px);
        }

        .btn-submit:disabled {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .btn-submit:disabled:hover {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            transform: none;
            box-shadow: none;
        }

        /* ============================================
           FORM STYLES
           ============================================ */
        form[style*="display: inline"] {
            display: inline-block;
            margin-top: 15px;
        }

        #selectedArticlesInput {
            display: none;
        }

        /* ============================================
           NOTIFICATION STYLES
           ============================================ */
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOutRight {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }

        /* ============================================
           RESPONSIVE DESIGN
           ============================================ */
        @media (max-width: 1200px) {
            .articles-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .container {
                padding: 20px;
                margin: 10px auto;
            }
            
            h1 {
                font-size: 24px;
            }
            
            .articles-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 15px;
            }
            
            .article-card {
                padding: 20px;
            }
            
            .cart-info {
                padding: 20px;
            }
            
            .add-btn,
            .btn-submit,
            .btn-danger,
            .back-link {
                padding: 10px 20px;
                font-size: 14px;
            }
        }

        @media (max-width: 480px) {
            .articles-grid {
                grid-template-columns: 1fr;
            }
            
            h1 {
                font-size: 22px;
            }
            
            .article-card h3 {
                font-size: 16px;
            }
            
            .selected-count {
                padding: 2px 8px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🛍️ Liste des articles - Sélection pour Devis</h1>
        
        <c:if test="${not empty message}">
            <div class="success-message">
                ${message}
            </div>
        </c:if>
        
        <div class="cart-info">
            <strong>Articles sélectionnés pour le devis:</strong> 
            <span class="selected-count" id="selected-count">0</span> article(s)
            
            <div id="selected-list" style="margin-top: 10px;"></div>
            
            <form action="${pageContext.request.contextPath}/vente/devis/nouveau" method="post">
                <input type="hidden" name="selectedArticles" id="selectedArticlesInput" value="">
                <button type="submit" id="create-devis-btn" class="btn-submit" disabled>
                    Créer Devis avec <span id="article-count">0</span> article(s)
                </button>
            </form>
        </div>
        
        <div class="articles-grid">
            <c:forEach var="article" items="${articles}">
                <div class="article-card">
                    <h3>${empty article.designation ? 'N/A' : article.designation}</h3>
                    <p><strong>Référence:</strong> ${empty article.code ? 'N/A' : article.code}</p>
                    <p><strong>ID:</strong> ${article.idArticle != null ? article.idArticle : 'N/A'}</p>
                    <button type="button" class="add-btn" 
                            onclick="ajouterArticle(${article.idArticle != null ? article.idArticle : 0}, '${empty article.designation ? 'N/A' : article.designation}')">
                        + Ajouter au devis
                    </button>
                </div>
            </c:forEach>
        </div>
        
        <a href="${pageContext.request.contextPath}/vente/accueil" class="back-link">← Retour à l'accueil</a>
    </div>

    <script>
        let selectedArticles = [];
        
        function ajouterArticle(idArticle, designation) {
            if (!selectedArticles.some(item => item.id === idArticle)) {
                selectedArticles.push({
                    id: idArticle,
                    name: designation || 'Article ' + idArticle
                });
                updateUI();
                // Notification visuelle
                showNotification('Article ajouté à la sélection');
            } else {
                showNotification('Article déjà sélectionné', 'warning');
            }
        }
        
        function retirerArticle(idArticle) {
            selectedArticles = selectedArticles.filter(item => item.id !== idArticle);
            updateUI();
            showNotification('Article retiré de la sélection');
        }
        
        function updateUI() {
            document.getElementById('selected-count').textContent = selectedArticles.length;
            document.getElementById('article-count').textContent = selectedArticles.length;
            document.getElementById('selectedArticlesInput').value = JSON.stringify(selectedArticles.map(item => item.id));
            document.getElementById('create-devis-btn').disabled = selectedArticles.length === 0;
            
            const listDiv = document.getElementById('selected-list');
            listDiv.innerHTML = '';
            
            if (selectedArticles.length === 0) {
                listDiv.innerHTML = '<p style="color: #7f8c8d; font-style: italic;">Aucun article sélectionné</p>';
                return;
            }
            
            selectedArticles.forEach(item => {
                const itemDiv = document.createElement('div');
                itemDiv.className = 'selected-item';
                
                const textSpan = document.createElement('span');
                textSpan.textContent = item.name + ' (ID: ' + item.id + ')';
                
                const removeBtn = document.createElement('button');
                removeBtn.textContent = 'Retirer';
                removeBtn.className = 'btn-danger';
                removeBtn.onclick = () => retirerArticle(item.id);
                
                itemDiv.appendChild(textSpan);
                itemDiv.appendChild(removeBtn);
                listDiv.appendChild(itemDiv);
            });
        }
        
        function showNotification(message, type = 'success') {
            // Créer une notification temporaire
            const notification = document.createElement('div');
            notification.textContent = message;
            
            // Définir le style en fonction du type
            let backgroundColor;
            if (type === 'success') {
                backgroundColor = 'linear-gradient(135deg, #27ae60, #229954)';
            } else if (type === 'warning') {
                backgroundColor = 'linear-gradient(135deg, #e67e22, #d35400)';
            } else {
                backgroundColor = 'linear-gradient(135deg, #3498db, #2980b9)';
            }
            
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: 600;
                z-index: 1000;
                animation: slideInRight 0.3s ease;
                background: ${backgroundColor};
                color: white;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            `;
            
            document.body.appendChild(notification);
            
            // Supprimer après 3 secondes
            setTimeout(() => {
                notification.style.animation = 'slideOutRight 0.3s ease';
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }
        
        // Initialiser l'UI
        updateUI();
    </script>
</body>
</html>