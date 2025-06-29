package model;

import java.io.Serializable;

public class SeatType implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String typeName;      // 例如：一等座、二等座、商务座
    private String description;   // 座位类型描述
    private double priceMultiplier; // 票价乘数（基础票价 * 乘数 = 实际票价）

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPriceMultiplier() { return priceMultiplier; }
    public void setPriceMultiplier(double priceMultiplier) { this.priceMultiplier = priceMultiplier; }
}