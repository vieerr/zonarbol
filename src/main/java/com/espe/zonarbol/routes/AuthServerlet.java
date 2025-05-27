package com.espe.zonarbol.routes;

import com.espe.zonarbol.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth")
public class AuthServerlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        if("login".equals(action)){
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            boolean isAuthenticated = authService.authenticate(username, password);
            
            if (isAuthenticated) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                response.sendRedirect("menu.jsp");
            } else {
                response.sendRedirect("index.jsp?error=1");
            }
        }
        
        if("logout".equals(action)){
            HttpSession session = request.getSession();
            session.setAttribute("username", null);
            response.sendRedirect("index.jsp");
        }
    }
}
