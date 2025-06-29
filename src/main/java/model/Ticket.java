// com.toudatrain.model.Ticket.java
package model;

import java.io.Serializable;
import java.sql.Date;

public class Ticket implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Train train;
    private SeatType seatType;
    private String departureDate;
    private int availableSeats;
    private double price;
    private Checi checi;
    private int ticket_ID;
    private int check_ID;
    private SeatType seat;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Train getTrain() { return train; }
    public void setTrain(Train train) { this.train = train; }

    public SeatType getSeatType() { return seatType; }
    public void setSeatType(SeatType seatType) { this.seatType = seatType; }

    public String getDepartureDate() { return departureDate; }
    public void setDepartureDate(String departureDate) { this.departureDate = departureDate; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public Checi getCheci() {
        return checi;
    }
    public void setCheci(Checi checi) {
        this.checi=checi;
    }

    public int getTicket_ID() {
        return ticket_ID;
    }

    public void setTicket_ID(int ticket_ID) {
        this.ticket_ID = ticket_ID;
    }

    public int getCheck_ID() {
        return check_ID;
    }

    public void setCheck_ID(int check_ID) {
        this.check_ID = check_ID;
    }

    public SeatType getSeat() {
        return seat;
    }

    public void setSeat(SeatType seat) {
        this.seat = seat;
    }


}