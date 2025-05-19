package com.espe.zonarbol.routes;

import com.espe.zonarbol.service.ConservationActivityService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ConservationActivityServlet")
public class ConservationActivityServlet extends HttpServlet {

    private ConservationActivityService activityService;
    private Gson gson;

    @Override
    public void init() {
        activityService = new ConservationActivityService();
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd")
                .create();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("conservation-activities.jsp");
            return;
        }

        switch (action) {
            case "add":
                activityService.handleAddActivity(request);
                response.sendRedirect("conservation-activities.jsp");
                break;
            case "update":
                activityService.handleUpdateActivity(request);
                response.sendRedirect("conservation-activities.jsp");
                break;
            case "delete":
                activityService.handleDeleteActivity(request);
                response.sendRedirect("conservation-activities.jsp");
                break;
            default:
                response.sendRedirect("conservation-activities.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("conservation-activities.jsp");
            return;
        }

        if ("search".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(activityService.getActivityById(id)));
                return;
            }
        }
        response.sendRedirect("tree-species.jsp");
    }
}