package com.espe.zonarbol.routes;

import com.espe.zonarbol.service.ForestZoneService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/ForestZoneServlet")
public class ForestZoneServlet extends HttpServlet {
    private ForestZoneService zoneService;
    private Gson gson;

    @Override
    public void init() {
        zoneService = new ForestZoneService();
        gson = new GsonBuilder()
                .disableHtmlEscaping()
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("forest-zones.jsp");
            return;
        }

        if ("search".equals(action)) {
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(zoneService.getZoneById(zoneId)));
            }
        } else {
            response.sendRedirect("forest-zones.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("forest-zones.jsp");
            return;
        }

        switch (action) {
            case "add":
                zoneService.handleAddZone(request);
                break;
            case "update":
                zoneService.handleUpdateZone(request);
                break;
            case "delete":
                zoneService.handleDeleteZone(request);
                break;
        }
        
        response.sendRedirect("forest-zones.jsp");
    }
}