<%@page import="com.mycompany.muahang.model.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // KHỞI TẠO DỮ LIỆU TĨNH NGAY TẠI TRANG NÀY
    List<Product> list = new ArrayList<>();
    list.add(new Product("8601", "86 (the band) - True Life Songs and Pictures", 14.95));
    list.add(new Product("pfoot1", "Paddlefoot - The first CD", 12.95));
    list.add(new Product("pfoot2", "Paddlefoot - The second CD", 14.95));
    list.add(new Product("jrut", "Joe Rut - Genuine Wood Grained Finish", 14.95));

    // QUAN TRỌNG: Đẩy list này vào biến 'products' để thẻ JSTL bên dưới dùng được
    pageContext.setAttribute("products", list);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>CD Shop</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>CD List</h1>
    
    <table>
        <thead>
            <tr>
                <th>Description</th>
                <th>Price</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>${p.description}</td>
                    <td>
                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="$"/>
                    </td>
                    <td>
                        <form action="cart" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productCode" value="${p.code}">
                            <input type="submit" value="Add To Cart">
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>