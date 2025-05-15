package com.espe.zonarbol.routes;

import com.espe.zonarbol.dao.TreeSpeciesDAO;
import com.espe.zonarbol.model.TreeSpecies;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/TreeSpeciesServlet")
public class TreeSpeciesServlet extends HttpServlet {
    private TreeSpeciesDAO speciesDAO;

    @Override
    public void init() {
        speciesDAO = new TreeSpeciesDAO();
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
                addTreeSpecies(request, response);
                break;
            case "update":
                updateTreeSpecies(request, response);
                break;
            case "delete":
                deleteTreeSpecies(request, response);
                break;
            default:
                response.sendRedirect("tree-species.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("tree-species.jsp");
            return;
        }

        if ("search".equals(action)) {
            String query = request.getParameter("query");
            request.setAttribute("speciesList", speciesDAO.searchTreeSpecies(query));
            request.getRequestDispatcher("tree-species.jsp").forward(request, response);
        } else {
            response.sendRedirect("tree-species.jsp");
        }
    }

    private void addTreeSpecies(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        TreeSpecies species = new TreeSpecies();
        species.setScientificName(request.getParameter("scientificName"));
        species.setCommonName(request.getParameter("commonName"));
        species.setFamily(request.getParameter("family"));
        
        String lifespan = request.getParameter("averageLifespan");
        if (lifespan != null && !lifespan.isEmpty()) {
            species.setAverageLifespan(Integer.parseInt(lifespan));
        }
        
        species.setConservationStatus(request.getParameter("conservationStatus"));
        
        if (speciesDAO.addTreeSpecies(species)) {
            request.getSession().setAttribute("successMessage", "Especie añadida exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al añadir la especie");
        }
        
        response.sendRedirect("tree-species.jsp");
    }

    private void updateTreeSpecies(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        TreeSpecies species = new TreeSpecies();
        species.setSpeciesId(Integer.parseInt(request.getParameter("speciesId")));
        species.setScientificName(request.getParameter("scientificName"));
        species.setCommonName(request.getParameter("commonName"));
        species.setFamily(request.getParameter("family"));
        
        String lifespan = request.getParameter("averageLifespan");
        if (lifespan != null && !lifespan.isEmpty()) {
            species.setAverageLifespan(Integer.parseInt(lifespan));
        }
        
        species.setConservationStatus(request.getParameter("conservationStatus"));
        
        if (speciesDAO.updateTreeSpecies(species)) {
            request.getSession().setAttribute("successMessage", "Especie actualizada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al actualizar la especie");
        }
        
        response.sendRedirect("tree-species.jsp");
    }

    private void deleteTreeSpecies(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int speciesId = Integer.parseInt(request.getParameter("speciesId"));
        
        if (speciesDAO.deleteTreeSpecies(speciesId)) {
            request.getSession().setAttribute("successMessage", "Especie eliminada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al eliminar la especie");
        }
        
        response.sendRedirect("tree-species.jsp");
    }
}