<%@page import="com.mycompany.muahang.model.Cart"%>
<%@page import="com.mycompany.muahang.model.LineItem"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Lấy giỏ hàng từ Session
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
    <style>
        /* CSS nội bộ nhỏ để căn chỉnh nút */
        .controls { margin-top: 20px; display: flex; gap: 10px; }
        .btn-update { background-color: #f0ad4e; color: white; }
        .btn-remove { background-color: #d9534f; color: white; }
        .btn-continue { background-color: #5bc0de; color: white; }
        .btn-checkout { background-color: #5cb85c; color: white; }
        input[type="number"] { padding: 5px; }
    </style>
</head>
<body>
    <h1>Your cart</h1>

    <%-- 2. Kiểm tra nếu giỏ hàng trống --%>
    <% if (items.isEmpty()) { %>
        <p>Your cart is currently empty.</p>
        
        <form action="cart" method="post">
            <input type="hidden" name="action" value="view_products">
            <input type="submit" value="Start Shopping" class="btn-continue">
        </form>
        
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Quantity</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Amount</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                
                <%-- Vòng lặp hiển thị từng sản phẩm --%>
                <% for (LineItem item : items) { %>
                <tr>
                    <td>
                        <form action="cart" method="post" style="display:flex; align-items:center; gap:5px;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="productCode" value="<%= item.getProduct().getCode() %>">
                            
                            <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" style="width: 50px;">
                            <input type="submit" value="Update" class="btn-update">
                        </form>
                    </td>
                    
                    <td><%= item.getProduct().getDescription() %></td>
                    
                    <td><%= String.format("$%.2f", item.getProduct().getPrice()) %></td>
                    
                    <td><%= String.format("$%.2f", item.getTotalAmount()) %></td>
                    
                    <td>
                        <form action="cart" method="post">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="productCode" value="<%= item.getProduct().getCode() %>">
                            <input type="submit" value="Remove" class="btn-remove">
                        </form>
                    </td>
                </tr>
                <% } %>
                
                <tr style="background-color: #e0f2f1; font-weight: bold;">
                    <td colspan="3" style="text-align: right;">Grand Total:</td>
                    <td colspan="2" style="font-size: 1.2em; color: teal;">
                        <%= String.format("$%.2f", cart.getGrandTotal()) %>
                    </td>
                </tr>
                
            </tbody>
        </table>
        
        <p>To change the quantity, enter the new quantity and click on the Update button.</p>

        <div class="controls">
            <form action="cart" method="post">
                <input type="hidden" name="action" value="view_products">
                <input type="submit" value="Continue Shopping" class="btn-continue">
            </form>
            
            <form action="cart" method="post">
                <input type="hidden" name="action" value="checkout">
                <input type="submit" value="Checkout" class="btn-checkout">
            </form>
        </div>
        
    <% } %>
</body>
</html>