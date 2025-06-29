package model;

import java.io.Serializable;

public class TrainType implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String typeName;
    private String description;
    private int speedLevel;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getSpeedLevel() { return speedLevel; }
    public void setSpeedLevel(int speedLevel) { this.speedLevel = speedLevel; }
}