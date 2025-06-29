// com.toudatrain.model.Train.java
package model;

import java.io.Serializable;
import java.sql.Time;

public class Train implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String trainNumber;
    private TrainType trainType;
    private Station startStation;
    private Station endStation;
    private Time departureTime;
    private Time arrivalTime;
    private String duration;
    private int distance;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTrainNumber() { return trainNumber; }
    public void setTrainNumber(String trainNumber) { this.trainNumber = trainNumber; }

    public TrainType getTrainType() { return trainType; }
    public void setTrainType(TrainType trainType) { this.trainType = trainType; }

    public Station getStartStation() { return startStation; }
    public void setStartStation(Station startStation) { this.startStation = startStation; }

    public Station getEndStation() { return endStation; }
    public void setEndStation(Station endStation) { this.endStation = endStation; }

    public Time getDepartureTime() { return departureTime; }
    public void setDepartureTime(Time departureTime) { this.departureTime = departureTime; }

    public Time getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(Time arrivalTime) { this.arrivalTime = arrivalTime; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public int getDistance() { return distance; }
    public void setDistance(int distance) { this.distance = distance; }
}