package com.espe.zonarbol.model;

import java.sql.Timestamp;

public class TreeSpecies {
    private int speciesId;
    private String scientificName;
    private String commonName;
    private String family;
    private Integer averageLifespan;
    private String conservationStatus;
    private Timestamp firstRegistered;

    // Constructors
    public TreeSpecies() {}

    public TreeSpecies(int speciesId, String scientificName, String commonName, 
                      String family, Integer averageLifespan, 
                      String conservationStatus, Timestamp firstRegistered) {
        this.speciesId = speciesId;
        this.scientificName = scientificName;
        this.commonName = commonName;
        this.family = family;
        this.averageLifespan = averageLifespan;
        this.conservationStatus = conservationStatus;
        this.firstRegistered = firstRegistered;
    }

    // Getters and Setters
    public int getSpeciesId() {
        return speciesId;
    }

    public void setSpeciesId(int speciesId) {
        this.speciesId = speciesId;
    }

    public String getScientificName() {
        return scientificName;
    }

    public void setScientificName(String scientificName) {
        this.scientificName = scientificName;
    }

    public String getCommonName() {
        return commonName;
    }

    public void setCommonName(String commonName) {
        this.commonName = commonName;
    }

    public String getFamily() {
        return family;
    }

    public void setFamily(String family) {
        this.family = family;
    }

    public Integer getAverageLifespan() {
        return averageLifespan;
    }

    public void setAverageLifespan(Integer averageLifespan) {
        this.averageLifespan = averageLifespan;
    }

    public String getConservationStatus() {
        return conservationStatus;
    }

    public void setConservationStatus(String conservationStatus) {
        this.conservationStatus = conservationStatus;
    }

    public Timestamp getFirstRegistered() {
        return firstRegistered;
    }

    public void setFirstRegistered(Timestamp firstRegistered) {
        this.firstRegistered = firstRegistered;
    }
}