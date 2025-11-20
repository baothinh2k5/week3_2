package com.mycompany.muahang.model;
import java.io.Serializable;

public class LineItem implements Serializable {
    private Product product;
    private int quantity;

    public LineItem() {}
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public double getTotalAmount() {
        if (product == null) return 0.0;
        return product.getPrice() * quantity;
    }
}