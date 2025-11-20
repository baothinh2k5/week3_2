<%@page import="com.mycompany.muahang.model.Product"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Tạo dữ liệu tĩnh trực tiếp tại View
    List<Product> products = new ArrayList<>();
    products.add(new Product("8601", "86 (the band) - True Life Songs and Pictures", 14.95));
    products.add(new Product("pfoot1", "Paddlefoot - The first CD", 12.95));
    products.add(new Product("pfoot2", "Paddlefoot - The second CD", 14.95));
    products.add(new Product("jrut", "Joe Rut - Genuine Wood Grained Finish", 14.95));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>CD List</title>
    <link rel="stylesheet" href="styles.css"> 
</head>
<body>
    <h1>CD list</h1>
    <table>
        <thead>
            <tr>
                <th>Description</th>
                <th>Price</th>
                <th></th> 
            </tr>
        </thead>
        <tbody>
            <% for (Product p : products) { %>
                <tr>
                    <td><%= p.getDescription() %></td>
                    <td class="right"><%= String.format("$%.2f", p.getPrice()) %></td>
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