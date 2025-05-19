package com.espe.zonarbol.routes;

import com.espe.zonarbol.service.ReportService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Date;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private ReportService reportService;
    
    @Override
    public void init() {
        reportService = new ReportService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String reportType = request.getParameter("reportType");
        String format = request.getParameter("format");
        
        if (reportType == null || format == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }
        
        try {
            Date startDate = reportService.parseDateParameter(request.getParameter("startDate"));
            Date endDate = reportService.parseDateParameter(request.getParameter("endDate"));
            
            byte[] reportData = reportService.generatePdfReport(reportType, request, startDate, endDate);
            
            String fileName = reportService.generateFileName(reportType, format);
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength(reportData.length);
            
            try (OutputStream out = response.getOutputStream()) {
                out.write(reportData);
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating report");
        }
    }
}