<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .controls { margin-top: 20px; display: flex; gap: 10px; }
        .btn-update { background-color: #f0ad4e; color: white; }
        .btn-remove { background-color: #d9534f; color: white; }
        .btn-continue { background-color: #5bc0de; color: white; }
        .btn-checkout { background-color: #5cb85c; color: white; }
    </style>
</head>
<body>
    <h1>Your Cart</h1>

    <c:choose>
        <c:when test="${empty cart.items}">
            <p>Your cart is empty.</p>
            <form action="cart" method="post">
                <input type="hidden" name="action" value="view_products">
                <input type="submit" value="Start Shopping" class="btn-continue">
            </form>
        </c:when>
        
        <c:otherwise>
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
                    <c:forEach var="item" items="${cart.items}">
                        <tr>
                            <td>
                                <form action="cart" method="post" style="display:flex; gap:5px;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productCode" value="${item.product.code}">
                                    
                                    <input type="number" name="quantity" value="${item.quantity}" min="1" style="width:50px;">
                                    <input type="submit" value="Update" class="btn-update">
                                </form>
                            </td>
                            <td>${item.product.description}</td>
                            <td><fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="$"/></td>
                            <td><fmt:formatNumber value="${item.totalAmount}" type="currency" currencySymbol="$"/></td>
                            <td>
                                <form action="cart" method="post">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="productCode" value="${item.product.code}">
                                    <input type="submit" value="Remove" class="btn-remove">
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <tr style="background-color: #e0f2f1; font-weight: bold;">
                        <td colspan="3" style="text-align: right;">Grand Total:</td>
                        <td colspan="2" style="font-size: 1.2em; color: teal;">
                            <fmt:formatNumber value="${cart.grandTotal}" type="currency" currencySymbol="$"/>
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
        </c:otherwise>
    </c:choose>
</body>
</html>