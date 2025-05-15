package com.espe.zonarbol.model;



import java.sql.Timestamp;

public class ForestZone {
    private int zoneId;
    private String zoneName;
    private String province;
    private String canton;
    private double totalAreaHectares;
    private String forestType;
    private Timestamp createdAt;
    private String state;

    // Constructors, getters, and setters
    public ForestZone() {}

    public ForestZone(int zoneId, String zoneName, String province, String canton, 
                     double totalAreaHectares, String forestType, 
                     Timestamp createdAt, String state) {
        this.zoneId = zoneId;
        this.zoneName = zoneName;
        this.province = province;
        this.canton = canton;
        this.totalAreaHectares = totalAreaHectares;
        this.forestType = forestType;
        this.createdAt = createdAt;
        this.state = state;
    }

    public int getZoneId() {
        return zoneId;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCanton() {
        return canton;
    }

    public void setCanton(String canton) {
        this.canton = canton;
    }

    public double getTotalAreaHectares() {
        return totalAreaHectares;
    }

    public void setTotalAreaHectares(double totalAreaHectares) {
        this.totalAreaHectares = totalAreaHectares;
    }

    public String getForestType() {
        return forestType;
    }

    public void setForestType(String forestType) {
        this.forestType = forestType;
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