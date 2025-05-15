<%-- 
    Document   : list
    Created on : May 7, 2025, 10:45:02 AM
    Author     : vier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuarios</title>
    </head>
    <body>
        <h1>Lista de usuarios </h1>
        <a href="User?option=new">Agregar nuevo</a>
        <table border="1">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Lastname</th>
                    <th>Edad</th>
                </tr>
            </thead>
            <tbody> 
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.name}</td>
                        <td>${user.last_name}</td>
                        <td>${user.age}</td>
                        <td>
                            <a href="User?option=update&id=${user.id}">Editar</a>                            
                            <a href="User?option=delete&id=${user.id}" onclick="return confirm("eliminar?")" >Eliminar</a>
                    </tr>
                </c:forEach>


            </tbody>
        </table>

    </body>
</html>
