package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.UserDAO;
import com.espe.zonarbol.model.User;

public class LoginService {
    private UserDAO userDAO; 
    
    public LoginService(){
        userDAO = new UserDAO();
    }

    public boolean authenticate(String username, String password) {
        User userFound = userDAO.getUserByName(username);
        
        if(userFound == null){
            return false;
        }
        
        if(userFound.getUserPassword().equals(password)){
            return true;
        }
        
        return false;
    }
}
