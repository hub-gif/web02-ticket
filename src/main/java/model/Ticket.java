// com.toudatrain.model.Ticket.java
package model;

import java.io.Serializable;
import java.sql.Date;

public class Ticket implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Train train;
    private SeatType seatType;
    private Date departureDate;
    private int availableSeats;
    private double basePrice;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Train getTrain() { return train; }
    public void setTrain(Train train) { this.train = train; }

    public SeatType getSeatType() { return seatType; }
    public void setSeatType(SeatType seatType) { this.seatType = seatType; }

    public Date getDepartureDate() { return departureDate; }
    public void setDepartureDate(Date departureDate) { this.departureDate = departureDate; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }

    public double getBasePrice() { return basePrice; }
    public void setBasePrice(double basePrice) { this.basePrice = basePrice; }

    // 计算实际票价
    public double getActualPrice() {
        return basePrice * seatType.getPriceMultiplier();
    }
}