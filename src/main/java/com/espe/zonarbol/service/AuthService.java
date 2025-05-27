package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.UserDAO;
import com.espe.zonarbol.model.User;
import com.espe.zonarbol.utils.Encryption;

public class AuthService {
    private UserDAO userDAO;
    
    public AuthService(){
        userDAO = new UserDAO();
    }

    public boolean authenticate(String username, String password) {
        User userFound = userDAO.getUserByName(username);
        
        if(userFound == null){
            return false;
        }
        
        String usrPwd = userDAO.getUserPassword(userFound.getUserId());
        
        return Encryption.comparePasswords(password, usrPwd);
    }
}
