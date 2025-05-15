package com.espe.zonarbol.service;

public class LoginService {

    // Hardcoded credentials for now. Later: check DB.
    private final String validUsername = "admin";
    private final String validPassword = "admin";

    public boolean authenticate(String username, String password) {
        return username != null && password != null &&
               username.equals(validUsername) &&
               password.equals(validPassword);
    }
}
