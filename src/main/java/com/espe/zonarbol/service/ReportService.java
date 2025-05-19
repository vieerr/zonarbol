package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.ConservationActivityDAO;
import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.dao.TreeSpeciesDAO;
import com.espe.zonarbol.model.ConservationActivity;
import com.espe.zonarbol.model.ForestZone;
import com.espe.zonarbol.model.TreeSpecies;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class ReportService {

    private final ForestZoneDAO zoneDAO;
    private final TreeSpeciesDAO speciesDAO;
    private final ConservationActivityDAO activityDAO;

    public ReportService() {
        this.zoneDAO = new ForestZoneDAO();
        this.speciesDAO = new TreeSpeciesDAO();
        this.activityDAO = new ConservationActivityDAO();
    }

    public byte[] generatePdfReport(String reportType, HttpServletRequest request,
            Date startDate, Date endDate) throws DocumentException, IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, baos);

        document.open();
        addReportHeader(document, reportType, request, startDate, endDate);
        addReportContent(document, reportType, request, startDate, endDate);
        document.close();

        return baos.toByteArray();
    }

    private void addReportHeader(Document document, String reportType,
            HttpServletRequest request, Date startDate, Date endDate)
            throws DocumentException {
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Paragraph title = new Paragraph(getReportTitle(reportType), titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        Font filterFont = FontFactory.getFont(FontFactory.HELVETICA, 10);
        Paragraph filters = new Paragraph(getFiltersInfo(request, startDate, endDate), filterFont);
        filters.setSpacingAfter(20);
        document.add(filters);
    }

    private void addReportContent(Document document, String reportType,
            HttpServletRequest request, Date startDate, Date endDate)
            throws DocumentException {
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
                addProtectedAreasToPdf(document, startDate, endDate);
                break;
            default:
                throw new IllegalArgumentException("Unsupported report type: " + reportType);
        }
    }

    // Helper methods for date parsing
    public Date parseDateParameter(String dateStr) {
        return dateStr != null && !dateStr.isEmpty() ? Date.valueOf(dateStr) : null;
    }

    // File name generation
    public String generateFileName(String reportType, String format) {
        String prefix;
        switch (reportType) {
            case "zones":
                prefix = "Zonas_Forestales";
                break;
            case "species":
                prefix = "Especies_Arboles";
                break;
            case "activities":
                prefix = "Actividades_Conservacion";
                break;
            case "protected":
                prefix = "Areas_Protegidas";
                break;
            default:
                prefix = "Reporte";
                break;
        }

        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return prefix + "_" + date + ".pdf";
    }

    // Report title generation
    private String getReportTitle(String reportType) {
        String title;
        switch (reportType) {
            case "zones":
                title = "Reporte de Zonas Forestales";
                break;
            case "species":
                title = "Reporte de Especies de Árboles";
                break;
            case "activities":
                title = "Reporte de Actividades de Conservación";
                break;
            case "protected":
                title = "Reporte de Áreas Protegidas";
                break;
            default:
                title = "Reporte";
                break;
        }
        return title;

    }

    // Filter info generation
    private String getFiltersInfo(HttpServletRequest request, Date startDate, Date endDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        StringBuilder filters = new StringBuilder("Filtros aplicados:\n");

        if (startDate != null) {
            filters.append("Desde: ").append(sdf.format(startDate)).append("\n");
        }
        if (endDate != null) {
            filters.append("Hasta: ").append(sdf.format(endDate)).append("\n");
        }

        String reportType = request.getParameter("reportType");
        switch (reportType) {
            case "zones":
                addFilterIfPresent(filters, request, "province", "Provincia: ");
                addFilterIfPresent(filters, request, "forestType", "Tipo de Bosque: ");
                addFilterIfPresent(filters, request, "zoneState", "Estado: ");
                break;
            case "species":
                addFilterIfPresent(filters, request, "family", "Familia: ");
                addFilterIfPresent(filters, request, "conservationStatus", "Estado de Conservación: ");
                break;
            case "activities":
                addFilterIfPresent(filters, request, "activityType", "Tipo de Actividad: ");
                addFilterIfPresent(filters, request, "activityState", "Estado: ");
                addFilterIfPresent(filters, request, "responsibleEntity", "Entidad Responsable: ");
                break;
        }

        return filters.toString();
    }

    private void addFilterIfPresent(StringBuilder builder, HttpServletRequest request,
            String paramName, String label) {
        String value = request.getParameter(paramName);
        if (value != null && !value.isEmpty()) {
            builder.append(label).append(value).append("\n");
        }
    }

    // Report content generation methods
    private void addZonesToPdf(Document document, HttpServletRequest request,
            Date startDate, Date endDate) throws DocumentException {
        List<ForestZone> zones = zoneDAO.getZonesForReport(
                request.getParameter("province"),
                request.getParameter("forestType"),
                request.getParameter("zoneState"),
                startDate, endDate
        );

        PdfPTable table = createTable(5, "ID", "Nombre", "Ubicación", "Área (ha)", "Tipo de Bosque");

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
        List<TreeSpecies> speciesList = speciesDAO.getSpeciesForReport(
                request.getParameter("family"),
                request.getParameter("conservationStatus"),
                startDate, endDate
        );

        PdfPTable table = createTable(5, "ID", "Nombre Científico", "Nombre Común", "Familia", "Estado Conservación");

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
        List<ConservationActivity> activities = activityDAO.getActivitiesForReport(
                request.getParameter("activityType"),
                request.getParameter("activityState"),
                request.getParameter("responsibleEntity"),
                startDate, endDate
        );

        PdfPTable table = createTable(5, "ID", "Tipo", "Fechas", "Descripción", "Entidad");

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

    private void addProtectedAreasToPdf(Document document, Date startDate, Date endDate)
            throws DocumentException {
        List<ForestZone> protectedAreas = zoneDAO.getZonesForReport(
                null, null, "ACTIVE", startDate, endDate);

        PdfPTable table = createTable(5, "ID", "Nombre", "Ubicación", "Área (ha)", "Tipo de Protección");

        for (ForestZone zone : protectedAreas) {
            table.addCell(String.valueOf(zone.getZoneId()));
            table.addCell(zone.getZoneName());
            table.addCell(zone.getProvince() + ", " + zone.getCanton());
            table.addCell(String.format("%,.2f", zone.getTotalAreaHectares()));
            table.addCell(zone.getForestType());
        }

        document.add(table);
    }

    private PdfPTable createTable(int columns, String... headers) {
        PdfPTable table = new PdfPTable(columns);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        for (String header : headers) {
            table.addCell(header);
        }

        return table;
    }
}
