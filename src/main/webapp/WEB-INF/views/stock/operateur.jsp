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
            <li><a href="${pageContext.request.contextPath}/inventaire/pageInventaire">📦 Inventaire</a></li>
            <li><a href="${pageContext.request.contextPath}/stock/articles">🛍️ Liste des articles</a></li>
            <li><a href="${pageContext.request.contextPath}/transfert/transfertpage">🔄 Initialisation Transfert</a></li>
        </ul>
    </nav>

    <!-- Right Content -->
    <div class="content-wrapper">
        <h1>Welcome Opérateur</h1>
    </div>
</div>
</body>
</html>
