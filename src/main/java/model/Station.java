// com.toudatrain.model.Station.java
package model;

import java.io.Serializable;

public class Station implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String stationName;
    private String city;
    private String province;
    private String stationCode;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public String getStationCode() { return stationCode; }
    public void setStationCode(String stationCode) { this.stationCode = stationCode; }
}