package com.espe.zonarbol.routes;

import com.espe.zonarbol.service.TreeSpeciesService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/TreeSpeciesServlet")
public class TreeSpeciesServlet extends HttpServlet {

    private TreeSpeciesService speciesService;
    private Gson gson;

    @Override
    public void init() {
        speciesService = new TreeSpeciesService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("tree-species.jsp");
            return;
        }

        switch (action) {
            case "add":
                speciesService.handleAddSpecies(request);
                break;
            case "update":
                speciesService.handleUpdateSpecies(request);
                break;
            case "delete":
                speciesService.handleDeleteSpecies(request);
                break;
        }
        
        response.sendRedirect("tree-species.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("tree-species.jsp");
            return;
        }

        if ("search".equals(action)) {
            handleSearchRequest(request, response);
        } else {
            response.sendRedirect("tree-species.jsp");
        }
    }

    private void handleSearchRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(speciesService.getSpeciesById(id)));
            return;
        }

        String query = request.getParameter("query");
        request.setAttribute("speciesList", speciesService.searchSpecies(query));
        request.getRequestDispatcher("tree-species.jsp").forward(request, response);
    }
}