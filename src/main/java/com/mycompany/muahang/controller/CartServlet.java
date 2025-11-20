package com.mycompany.muahang.controller;

import com.mycompany.muahang.model.Cart;
import com.mycompany.muahang.model.LineItem;
import com.mycompany.muahang.model.Product;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartServlet extends HttpServlet {

    // --- DỮ LIỆU TĨNH (Thay thế ProductDB) ---
    // Chú ý: Mã "8601", "pfoot1"... phải KHỚP với value trong index.jsp
    private Product getStaticProduct(String code) {
        if (code == null) return null;
        
        switch (code) {
            case "8601":
                return new Product("8601", "86 (the band) - True Life Songs and Pictures", 14.95);
            case "pfoot1":
                return new Product("pfoot1", "Paddlefoot - The first CD", 12.95);
            case "pfoot2":
                return new Product("pfoot2", "Paddlefoot - The second CD", 14.95);
            case "jrut":
                return new Product("jrut", "Joe Rut - Genuine Wood Grained Finish", 14.95);
            default:
                return null;
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
        
        // 1. Lấy Session và Action
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        // Xử lý trường hợp action bị null ngay từ đầu
        if (action == null || action.isEmpty()) {
            action = "view_products";
        }
        
        // 2. Lấy hoặc tạo Giỏ hàng
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String url = "/index.jsp"; // URL mặc định

        // 3. XỬ LÝ LOGIC (Sử dụng so sánh ngược để tránh NullPointerException)
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
                session.setAttribute("cart", cart); // Cập nhật session
                url = "/cart.jsp"; // Chuyển hướng sang giỏ hàng thành công
            } else {
                url = "/index.jsp"; // Lỗi sản phẩm -> về trang chủ
            }
            
        } else if ("update".equals(action)) {
            String productCode = request.getParameter("productCode");
            String quantityString = request.getParameter("quantity");
            int quantity = 0;
            
            try {
                quantity = Integer.parseInt(quantityString);
            } catch (NumberFormatException e) {
                quantity = 1; // Mặc định nếu nhập sai
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
            url = "/checkout.jsp"; 
        }
        
        // 4. Chuyển hướng
        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }
}