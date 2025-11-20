package com.mycompany.muahang.model;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Cart implements Serializable {
    private List<LineItem> items;

    public Cart() {
        items = new ArrayList<>();
    }
    
    public List<LineItem> getItems() { return items; }
    public void setItems(List<LineItem> items) { this.items = items; }

    // Thêm sản phẩm: Nếu có rồi thì cộng dồn số lượng
    public void addItem(LineItem item) {
        String code = item.getProduct().getCode();
        int quantity = item.getQuantity();

        for (LineItem lineItem : items) {
            if (lineItem.getProduct().getCode().equals(code)) {
                lineItem.setQuantity(lineItem.getQuantity() + quantity);
                return;
            }
        }
        items.add(item);
    }

    // Cập nhật số lượng: Nếu số lượng <= 0 thì xóa
    public void updateItem(LineItem item) {
        String code = item.getProduct().getCode();
        int quantity = item.getQuantity();
        
        for (int i = 0; i < items.size(); i++) {
            LineItem lineItem = items.get(i);
            if (lineItem.getProduct().getCode().equals(code)) {
                if (quantity <= 0) {
                    items.remove(i);
                } else {
                    lineItem.setQuantity(quantity);
                }
                return;
            }
        }
    }

    public void removeItem(LineItem item) {
        String code = item.getProduct().getCode();
        for (int i = 0; i < items.size(); i++) {
            LineItem lineItem = items.get(i);
            if (lineItem.getProduct().getCode().equals(code)) {
                items.remove(i);
                return;
            }
        }
    }
    
    // *** TÍNH NĂNG MỚI: TỔNG TIỀN GIỎ HÀNG ***
    public double getGrandTotal() {
        double total = 0;
        for (LineItem item : items) {
            total += item.getTotalAmount();
        }
        return total;
    }
    public void emptyCart() {
        items.clear();
    }
}