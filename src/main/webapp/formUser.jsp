<%-- 
    Document   : formUser
    Created on : May 9, 2025, 9:57:35 AM
    Author     : vier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Formulario usuario</title>
    </head>
    <body>
        <h1>${user != null ? "Editar": "Nuevo" }Usuario</h1>
        <form action="User" method="POST">
            <input type="hidden" name="id" value="${user != null ? user.id: null}"/>
            name:<input type="text" name="name" value="${user.name}" required/>
            lastname:<input type="text" name="lastname" value="${user.last_name}" required/>
            age:<input type="number" name="age" value="${user.age}" required/>
            <input type="submit" value="save"/>
            
        </form>
    </body>
</html>
