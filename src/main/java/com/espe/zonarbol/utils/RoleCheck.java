package com.espe.zonarbol.utils;

/*
    1: Administrador (hace todo)
    2: Observador (solo puede mirar)
    3: Editor (solo puede editar)
    4: Depurador (solo puede eliminar)
    5: Grabador (solo puede agregar)
*/

public class RoleCheck {
    public static boolean evaluteEdit(int roleId){
        return roleId == 1 || roleId == 3;
    }
    
    public static boolean evaluteAdd(int roleId){
        return roleId == 1 || roleId == 5;
    }
    
    public static boolean evaluteDelete(int roleId){
        return roleId == 1 || roleId == 4;
    }
}
