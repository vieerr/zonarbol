package com.espe.zonarbol.controller;

import com.espe.zonarbol.dao.UserDAO;
import com.espe.zonarbol.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author vier
 */
@WebServlet(name = "UserController", urlPatterns = {"/User"})
public class UserController extends HttpServlet {

    private final UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String option = request.getParameter("option");

        if (option == null) {
            option = "findAll";
        }

        switch (option) {
            case "new":
                request.getRequestDispatcher("/formUser.jsp").forward(request, response);
                break;
            case "update":
                Long id = Long.parseLong(request.getParameter("id"));
                User user = userDao.findById(id);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/formUser.jsp").forward(request, response);
                break;

            case "delete":
                Long idDelete = Long.parseLong(request.getParameter("id"));
                userDao.delete(idDelete);
                response.sendRedirect("User");
                break;
            default:
                List<User> users = userDao.findAll();
                request.setAttribute("users", users);
                request.getRequestDispatcher("/list.jsp").forward(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        String lastname = request.getParameter("lastname");
        int age = Integer.parseInt(request.getParameter("age"));

        User user = new User(name, lastname, age);
        if (id == null) {
            userDao.save(user);
        } else {
            user.setId(id);
            userDao.update(user);
        }
        response.sendRedirect("User");
    }
}
