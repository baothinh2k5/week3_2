package com.mycompany.muahang.controller;

import com.mycompany.muahang.model.Cart;
import com.mycompany.muahang.model.LineItem;
import com.mycompany.muahang.model.Product;

import java.io.IOException;
// IMPORT QUAN TRỌNG ĐỂ SỬA LỖI 404
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// DÒNG NÀY ĐỊNH NGHĨA ĐƯỜNG DẪN URL CHO SERVLET
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    // --- DỮ LIỆU TĨNH ---
    private Product getStaticProduct(String code) {
        if (code == null) return null;
        
        switch (code) {
            case "8601": return new Product("8601", "86 (the band) - True Life Songs and Pictures", 14.95);
            case "pfoot1": return new Product("pfoot1", "Paddlefoot - The first CD", 12.95);
            case "pfoot2": return new Product("pfoot2", "Paddlefoot - The second CD", 14.95);
            case "jrut": return new Product("jrut", "Joe Rut - Genuine Wood Grained Finish", 14.95);
            default: return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Lấy action an toàn
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "view_products";
        }
        
        // Lấy/Tạo giỏ hàng
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String url = "/index.jsp";

        // XỬ LÝ LOGIC
        if ("view_products".equals(action)) {
            url = "/index.jsp";
            
        } else if ("add".equals(action)) {
            String productCode = request.getParameter("productCode");
            Product product = getStaticProduct(productCode);
            
            if (product != null) {
                LineItem lineItem = new LineItem();
                lineItem.setProduct(product);
                lineItem.setQuantity(1);
                
                cart.addItem(lineItem);
                session.setAttribute("cart", cart);
                url = "/cart.jsp";
            } else {
                url = "/index.jsp";
            }
            
        } else if ("update".equals(action)) {
            String productCode = request.getParameter("productCode");
            String quantityString = request.getParameter("quantity");
            int quantity = 1;
            
            try {
                quantity = Integer.parseInt(quantityString);
            } catch (NumberFormatException e) {
                quantity = 1;
            }
            
            Product product = getStaticProduct(productCode);
            if (product != null) {
                LineItem lineItem = new LineItem();
                lineItem.setProduct(product);
                lineItem.setQuantity(quantity);
                
                cart.updateItem(lineItem);
                session.setAttribute("cart", cart);
            }
            url = "/cart.jsp";
            
        } else if ("remove".equals(action)) {
            String productCode = request.getParameter("productCode");
            Product product = getStaticProduct(productCode);
            
            if (product != null) {
                LineItem lineItem = new LineItem();
                lineItem.setProduct(product);
                cart.removeItem(lineItem);
                session.setAttribute("cart", cart);
            }
            url = "/cart.jsp";
            
        } else if ("view_cart".equals(action)) {
            url = "/cart.jsp";
            
        } else if ("checkout".equals(action)) {
            // 1. Xóa sạch giỏ hàng
            cart.emptyCart();
            session.setAttribute("cart", cart);
            
            // 2. Quay lại trang chủ (index.jsp) thay vì trang thông báo
            url = "/index.jsp"; 
        }
        
        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }
}