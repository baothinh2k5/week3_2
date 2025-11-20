<%@page import="com.mycompany.muahang.model.Cart"%>
<%@page import="com.mycompany.muahang.model.LineItem"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) {
        cart = new Cart();
        session.setAttribute("cart", cart);
    }
    List<LineItem> items = cart.getItems();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <link rel="stylesheet" href="styles.css"> 
</head>
<body>
    <h1>Your cart</h1>

    <% if (items.isEmpty()) { %>
        <p>Your cart is currently empty.</p>
        <a href="cart?action=view_products"><button>Back to Shop</button></a>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Quantity</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Amount</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <% for (LineItem item : items) { %>
                    <form action="cart" method="post">
                        <input type="hidden" name="productCode" value="<%= item.getProduct().getCode() %>">
                        <tr>
                            <td>
                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" style="width:50px">
                                <input type="hidden" name="action" value="update">
                                <input type="submit" value="Update">
                            </td>
                            <td><%= item.getProduct().getDescription() %></td>
                            <td><%= String.format("$%.2f", item.getProduct().getPrice()) %></td>
                            <td><%= String.format("$%.2f", item.getTotalAmount()) %></td>
                            <td>
                                <input type="hidden" name="action" value="remove">
                                <input type="submit" value="Remove Item">
                            </td>
                        </tr>
                    </form>
                <% } %>
            </tbody>
        </table>
        
        <br>
        <div class="controls">
            <a href="cart?action=view_products">
                <button>Continue Shopping</button>
            </a>
            <button>Checkout</button>
        </div>
    <% } %>
</body>
</html>