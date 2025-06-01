package com.espe.zonarbol.model;

import jakarta.persistence.*;
import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlRootElement;

import java.sql.Timestamp;

@XmlRootElement(name = "treeSpecies")
@XmlAccessorType(XmlAccessType.FIELD)
@Entity
@Table(name = "tree_species")
public class TreeSpecies {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "species_id")
    private int speciesId;

    @Column(name = "scientific_name", nullable = false, unique = true)
    private String scientificName;

    @Column(name = "common_name")
    private String commonName;

    @Column(name = "family")
    private String family;

    @Column(name = "average_lifespan")
    private Integer averageLifespan;

    @Column(name = "conservation_status")
    private String conservationStatus;

    @Column(name = "first_registered", insertable = false, updatable = false)
    private Timestamp firstRegistered;

    public TreeSpecies() {}

    public TreeSpecies(String scientificName, String commonName, String family,
                       Integer averageLifespan, String conservationStatus) {
        this.scientificName = scientificName;
        this.commonName = commonName;
        this.family = family;
        this.averageLifespan = averageLifespan;
        this.conservationStatus = conservationStatus;
    }

    // Getters and setters

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
