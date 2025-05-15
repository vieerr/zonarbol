package com.espe.zonarbol.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ConservationActivity {
    private int activityId;
    private int zoneId;
    private String activityType;
    private Date startDate;
    private Date endDate;
    private String description;
    private String responsibleEntity;
    private Double estimatedBudget;
    private Timestamp createdAt;
    private String state;

    // Constructors
    public ConservationActivity() {}

    public ConservationActivity(int activityId, int zoneId, String activityType, 
                               Date startDate, Date endDate, String description, 
                               String responsibleEntity, Double estimatedBudget, 
                               Timestamp createdAt, String state) {
        this.activityId = activityId;
        this.zoneId = zoneId;
        this.activityType = activityType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
        this.responsibleEntity = responsibleEntity;
        this.estimatedBudget = estimatedBudget;
        this.createdAt = createdAt;
        this.state = state;
    }

    // Getters and Setters
    public int getActivityId() {
        return activityId;
    }

    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }

    public int getZoneId() {
        return zoneId;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getResponsibleEntity() {
        return responsibleEntity;
    }

    public void setResponsibleEntity(String responsibleEntity) {
        this.responsibleEntity = responsibleEntity;
    }

    public Double getEstimatedBudget() {
        return estimatedBudget;
    }

    public void setEstimatedBudget(Double estimatedBudget) {
        this.estimatedBudget = estimatedBudget;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }
}