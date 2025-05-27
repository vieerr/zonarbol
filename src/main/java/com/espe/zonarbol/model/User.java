package com.espe.zonarbol.model;

public class User {
    private int userId;
    private String userName;
    private String userPassword;
    private int roleId;
    
    public User(){}

    public User(int userId, String userName, String userPassword, int roleId) {
        this.userId = userId;
        this.userName = userName;
        this.userPassword = userPassword;
        this.roleId = roleId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }
    
    
}
