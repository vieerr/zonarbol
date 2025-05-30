package com.espe.zonarbol.routes;

import com.espe.zonarbol.service.ConservationActivityService;
import com.espe.zonarbol.service.ForestZoneService;
import com.espe.zonarbol.service.SummaryService;
import com.espe.zonarbol.service.TreeSpeciesService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SummaryServerlet")
public class SummaryServerlet extends HttpServlet {
    
    private ConservationActivityService activityService;
    private TreeSpeciesService treeSpeciesService;
    private ForestZoneService zoneService;
    private SummaryService summaryService;
    private Gson gson;
    
    @Override
    public void init() {
        activityService = new ConservationActivityService();
        treeSpeciesService = new TreeSpeciesService();
        zoneService = new ForestZoneService();
        summaryService = new SummaryService();
        gson = new GsonBuilder()
                .disableHtmlEscaping()
                .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("summary.jsp");
            return;
        }
        
        if ("getZoneData".equals(action)) {
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(zoneService.getZoneById(zoneId)));
            }
        }
        
        else if ("getZoneSpecies".equals(action)) {
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(treeSpeciesService.getSpeciesByZone(zoneId)));
            }
        } 
        
        else if("getZoneActivities".equals(action)) {
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                
                out.print(gson.toJson(activityService.getActivitiesByZone(zoneId)));
            }
        } 
        
        else if("getTreePopulation".equals(action)){
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            int specieId = Integer.parseInt(request.getParameter("specieId"));
            
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(summaryService.getTreePopulationFromZone(zoneId, specieId));
            }
        }else {
            response.sendRedirect("summary.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("summary.jsp");
            return;
        }
        
        if ("add_specie".equals(action)) {
            summaryService.handleAddTreeToZone(request);
        }
        
        if("update_specie".equals(action)) {
            summaryService.handleUpdateTreeToZone(request);
        }
        
        if("delete_specie".equals(action)) {
            summaryService.handleDeleteTreeToZone(request);
        }
        
        response.sendRedirect("summary.jsp");
    }

}
