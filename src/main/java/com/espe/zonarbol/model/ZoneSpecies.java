package com.espe.zonarbol.model;

public class ZoneSpecies {
    private int zoneId;
    private int speciesId;
    private int populationEstimate;
    
    //Constructors
    public ZoneSpecies() {}

    public ZoneSpecies(int zoneId, int speciesId, int populationEstimate) {
        this.zoneId = zoneId;
        this.speciesId = speciesId;
        this.populationEstimate = populationEstimate;
    }
    
    // Getters and Setters
    public int getZoneId() {
        return zoneId;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public int getSpeciesId() {
        return speciesId;
    }

    public void setSpeciesId(int speciesId) {
        this.speciesId = speciesId;
    }

    public int getPopulationEstimate() {
        return populationEstimate;
    }

    public void setPopulationEstimate(int populationEstimate) {
        this.populationEstimate = populationEstimate;
    }
}
