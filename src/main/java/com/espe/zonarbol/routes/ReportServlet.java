package com.espe.zonarbol.routes;

import com.espe.zonarbol.dao.ConservationActivityDAO;
import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.dao.TreeSpeciesDAO;
import com.espe.zonarbol.model.ConservationActivity;
import com.espe.zonarbol.model.ForestZone;
import com.espe.zonarbol.model.TreeSpecies;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private ForestZoneDAO zoneDAO;
    private TreeSpeciesDAO speciesDAO;
    private ConservationActivityDAO activityDAO;
    
    @Override
    public void init() {
        zoneDAO = new ForestZoneDAO();
        speciesDAO = new TreeSpeciesDAO();
        activityDAO = new ConservationActivityDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String reportType = request.getParameter("reportType");
        String format = request.getParameter("format");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        // Validate parameters
        if (reportType == null || format == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }
        
        try {
            // Parse dates
            Date startDate = startDateStr != null && !startDateStr.isEmpty() ? 
                Date.valueOf(startDateStr) : null;
            Date endDate = endDateStr != null && !endDateStr.isEmpty() ? 
                Date.valueOf(endDateStr) : null;
            
            // Generate PDF report
            byte[] reportData = generatePdfReport(reportType, request, startDate, endDate);
            
            // Set response headers for download
            String fileName = generateFileName(reportType, format);
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength(reportData.length);
            
            // Write report to response
            try (OutputStream out = response.getOutputStream()) {
                out.write(reportData);
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating report");
        }
    }
    
    private byte[] generatePdfReport(String reportType, HttpServletRequest request, 
                                   Date startDate, Date endDate) throws DocumentException, IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, baos);
        
        document.open();
        
        // Add title
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Paragraph title = new Paragraph(getReportTitle(reportType), titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        // Add filters info
        Font filterFont = FontFactory.getFont(FontFactory.HELVETICA, 10);
        Paragraph filters = new Paragraph(getFiltersInfo(request, startDate, endDate), filterFont);
        filters.setSpacingAfter(20);
        document.add(filters);
        
        // Add content based on report type
        switch (reportType) {
            case "zones":
                addZonesToPdf(document, request, startDate, endDate);
                break;
            case "species":
                addSpeciesToPdf(document, request, startDate, endDate);
                break;
            case "activities":
                addActivitiesToPdf(document, request, startDate, endDate);
                break;
            case "protected":
//                addProtectedAreasToPdf(document, request, startDate, endDate);
                break;
            default:
                throw new IllegalArgumentException("Unsupported report type: " + reportType);
        }
        
        document.close();
        return baos.toByteArray();
    }
    
    private void addZonesToPdf(Document document, HttpServletRequest request, 
                             Date startDate, Date endDate) throws DocumentException {
        String province = request.getParameter("province");
        String forestType = request.getParameter("forestType");
        String state = request.getParameter("zoneState");
        
        List<ForestZone> zones = zoneDAO.getZonesForReport(province, forestType, state, startDate, endDate);
        
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);
        
        // Add table headers
        table.addCell("ID");
        table.addCell("Nombre");
        table.addCell("Ubicación");
        table.addCell("Área (ha)");
        table.addCell("Tipo de Bosque");
        
        // Add data
        for (ForestZone zone : zones) {
            table.addCell(String.valueOf(zone.getZoneId()));
            table.addCell(zone.getZoneName());
            table.addCell(zone.getProvince() + ", " + zone.getCanton());
            table.addCell(String.format("%,.2f", zone.getTotalAreaHectares()));
            table.addCell(zone.getForestType());
        }
        
        document.add(table);
    }
    
    private void addSpeciesToPdf(Document document, HttpServletRequest request, 
                               Date startDate, Date endDate) throws DocumentException {
        String family = request.getParameter("family");
        String conservationStatus = request.getParameter("conservationStatus");
        
        List<TreeSpecies> speciesList = speciesDAO.getSpeciesForReport(family, conservationStatus, startDate, endDate);
        
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);
        
        // Add table headers
        table.addCell("ID");
        table.addCell("Nombre Científico");
        table.addCell("Nombre Común");
        table.addCell("Familia");
        table.addCell("Estado Conservación");
        
        // Add data
        for (TreeSpecies species : speciesList) {
            table.addCell(String.valueOf(species.getSpeciesId()));
            table.addCell(species.getScientificName());
            table.addCell(species.getCommonName() != null ? species.getCommonName() : "");
            table.addCell(species.getFamily() != null ? species.getFamily() : "");
            table.addCell(species.getConservationStatus());
        }
        
        document.add(table);
    }
    
    private void addActivitiesToPdf(Document document, HttpServletRequest request, 
                                  Date startDate, Date endDate) throws DocumentException {
        String activityType = request.getParameter("activityType");
        String activityState = request.getParameter("activityState");
        String responsibleEntity = request.getParameter("responsibleEntity");
        
        List<ConservationActivity> activities = activityDAO.getActivitiesForReport(
            activityType, activityState, responsibleEntity, startDate, endDate);
        
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);
        
        // Add table headers
        table.addCell("ID");
        table.addCell("Tipo");
        table.addCell("Fechas");
        table.addCell("Descripción");
        table.addCell("Entidad");
        
        // Add data
        for (ConservationActivity activity : activities) {
            String dates = activity.getStartDate().toString();
            if (activity.getEndDate() != null) {
                dates += " - " + activity.getEndDate();
            }
            
            table.addCell(String.valueOf(activity.getActivityId()));
            table.addCell(activity.getActivityType());
            table.addCell(dates);
            table.addCell(activity.getDescription());
            table.addCell(activity.getResponsibleEntity() != null ? activity.getResponsibleEntity() : "");
        }
        
        document.add(table);
    }
    
    private void addProtectedAreasToPdf(Document document, 
                                      Date startDate, Date endDate) throws DocumentException {
        List<ForestZone> protectedAreas = zoneDAO.getZonesForReport(
            null, null, "ACTIVE", startDate, endDate); // Filter only active protected areas
        
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);
        
        // Add table headers
        table.addCell("ID");
        table.addCell("Nombre");
        table.addCell("Ubicación");
        table.addCell("Área (ha)");
        table.addCell("Tipo de Protección");
        
        // Add data
        for (ForestZone zone : protectedAreas) {
            table.addCell(String.valueOf(zone.getZoneId()));
            table.addCell(zone.getZoneName());
            table.addCell(zone.getProvince() + ", " + zone.getCanton());
            table.addCell(String.format("%,.2f", zone.getTotalAreaHectares()));
            table.addCell(zone.getForestType());
        }
        
        document.add(table);
    }
    
    private String generateFileName(String reportType, String format) {
        String prefix;
        switch (reportType) {
            case "zones": prefix = "Zonas_Forestales"; break;
            case "species": prefix = "Especies_Arboles"; break;
            case "activities": prefix = "Actividades_Conservacion"; break;
            case "protected": prefix = "Areas_Protegidas"; break;
            default: prefix = "Reporte";
        }
        
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return prefix + "_" + date + ".pdf";
    }
    
    private String getReportTitle(String reportType) {
        switch (reportType) {
            case "zones": return "Reporte de Zonas Forestales";
            case "species": return "Reporte de Especies de Árboles";
            case "activities": return "Reporte de Actividades de Conservación";
            case "protected": return "Reporte de Áreas Protegidas";
            default: return "Reporte";
        }
    }
    
    private String getFiltersInfo(HttpServletRequest request, Date startDate, Date endDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        StringBuilder filters = new StringBuilder("Filtros aplicados:\n");
        
        if (startDate != null) filters.append("Desde: ").append(sdf.format(startDate)).append("\n");
        if (endDate != null) filters.append("Hasta: ").append(sdf.format(endDate)).append("\n");
        
        String reportType = request.getParameter("reportType");
        switch (reportType) {
            case "zones":
                if (request.getParameter("province") != null && !request.getParameter("province").isEmpty())
                    filters.append("Provincia: ").append(request.getParameter("province")).append("\n");
                if (request.getParameter("forestType") != null && !request.getParameter("forestType").isEmpty())
                    filters.append("Tipo de Bosque: ").append(request.getParameter("forestType")).append("\n");
                if (request.getParameter("zoneState") != null && !request.getParameter("zoneState").isEmpty())
                    filters.append("Estado: ").append(request.getParameter("zoneState")).append("\n");
                break;
            case "species":
                if (request.getParameter("family") != null && !request.getParameter("family").isEmpty())
                    filters.append("Familia: ").append(request.getParameter("family")).append("\n");
                if (request.getParameter("conservationStatus") != null && !request.getParameter("conservationStatus").isEmpty())
                    filters.append("Estado de Conservación: ").append(request.getParameter("conservationStatus")).append("\n");
                break;
            case "activities":
                if (request.getParameter("activityType") != null && !request.getParameter("activityType").isEmpty())
                    filters.append("Tipo de Actividad: ").append(request.getParameter("activityType")).append("\n");
                if (request.getParameter("activityState") != null && !request.getParameter("activityState").isEmpty())
                    filters.append("Estado: ").append(request.getParameter("activityState")).append("\n");
                if (request.getParameter("responsibleEntity") != null && !request.getParameter("responsibleEntity").isEmpty())
                    filters.append("Entidad Responsable: ").append(request.getParameter("responsibleEntity")).append("\n");
                break;
        }
        
        return filters.toString();
    }
}