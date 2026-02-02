<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<div class="container">
    <!-- Left Navbar -->
    <nav class="navbar">
        <h2>Stock Menu</h2>

        <ul>
            <!-- Visible for all logged users -->
            <li>
                <a href="${pageContext.request.contextPath}/inventaire/pageInventaire">
                    📦 Inventaire
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/stock/articles">
                    🛍️ Liste des articles
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/stock/mouvements">
                    ⏳ Historique des mouvements
                </a>
            </li>

            <!-- Visible only if role.niveauValidation > 0 -->
            <c:if test="${not empty sessionScope.user
                        and not empty sessionScope.user.role
                        and sessionScope.user.role.niveauValidation > 0}">
                <li>
                    <a href="${pageContext.request.contextPath}/transfert/transfertpage">
                        🔄 Initialisation Transfert
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/methode-article/form">
                        🔄 Change the methode of an article
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>

    <!-- Right Content -->
    <div class="content-wrapper">

        <h2>Assign method to article</h2>

        <form action="${pageContext.request.contextPath}/methode-article/save" method="post">

            <!-- Article -->
            <label>Article</label>
            <select name="articleId" required>
                <option value="">-- Select article --</option>
                <c:forEach items="${articles}" var="a">
                    <option value="${a.idArticle}">
                        ${a.code} - ${a.designation}
                    </option>
                </c:forEach>
            </select>

            <br><br>

            <!-- Methode -->
            <label>Methode de calcul</label>
            <select name="methodeId" required>
                <option value="">-- Select methode --</option>
                <c:forEach items="${methodes}" var="m">
                    <option value="${m.id}">
                        ${m.nomMethode}
                    </option>
                </c:forEach>
            </select>

            <br><br>

            <button type="submit">Save</button>
        </form>

    </div>
</div>
</body>
</html>
