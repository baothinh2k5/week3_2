<%@page import="com.mycompany.muahang.model.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // DỮ LIỆU TĨNH (KHỚP VỚI SERVLET)
    List<Product> products = new ArrayList<>();
    products.add(new Product("8601", "86 (the band) - True Life Songs and Pictures", 14.95));
    products.add(new Product("pfoot1", "Paddlefoot - The first CD", 12.95));
    products.add(new Product("pfoot2", "Paddlefoot - The second CD", 14.95));
    products.add(new Product("jrut", "Joe Rut - Genuine Wood Grained Finish", 14.95));
%>

<!DOCTYPE html>
<html>
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
            <% for (Product p : products) { %>
            <tr>
                <td><%= p.getDescription() %></td>
                <td><%= String.format("$%.2f", p.getPrice()) %></td>
                <td>
                    <form action="cart" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productCode" value="<%= p.getCode() %>">
                        <input type="submit" value="Add To Cart">
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>