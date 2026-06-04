package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();
    private TutorDAO tutorDAO = new TutorDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/dashboard";

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(req, resp);
                break;
            case "/users":
                showUsers(req, resp);
                break;
            case "/payments":
                showPayments(req, resp);
                break;
            case "/tutors":
                showTutorVerification(req, resp);
                break;
            default:
                showDashboard(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("toggleStatus".equals(action)) {
            String accountId = req.getParameter("accountId");
            String currentStatus = req.getParameter("currentStatus");
            String newStatus = "active".equals(currentStatus) ? "inactive" : "active";
            accountDAO.updateStatus(accountId, newStatus);
            resp.sendRedirect(req.getContextPath() + "/admin/users");

        } else if ("verifyTutor".equals(action)) {
            String tutorId = req.getParameter("tutorId");
            tutorDAO.verify(tutorId, true);
            resp.sendRedirect(req.getContextPath() + "/admin/tutors");

        } else if ("rejectTutor".equals(action)) {
            String tutorId = req.getParameter("tutorId");
            tutorDAO.verify(tutorId, false);
            // Also deactivate account
            Tutor tutor = tutorDAO.findById(tutorId);
            if (tutor != null) {
                accountDAO.updateStatus(tutor.getAccountId(), "inactive");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/tutors");

        } else if ("updatePayment".equals(action)) {
            String paymentId = req.getParameter("paymentId");
            String status = req.getParameter("status");
            paymentDAO.updateStatus(paymentId, status);
            resp.sendRedirect(req.getContextPath() + "/admin/payments");

        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int totalStudents = accountDAO.countByRole(1);
        int totalTutors = accountDAO.countByRole(2);
        long totalRevenue = paymentDAO.getTotalRevenue();
        List<Tutor> pendingTutors = tutorDAO.findPendingVerification();
        List<Booking> recentBookings = bookingDAO.findAll();

        req.setAttribute("totalStudents", totalStudents);
        req.setAttribute("totalTutors", totalTutors);
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("pendingTutors", pendingTutors);
        req.setAttribute("recentBookings", recentBookings);
        req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, resp);
    }

    private void showUsers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Account> accounts = accountDAO.findAll();
        req.setAttribute("accounts", accounts);
        req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
    }

    private void showPayments(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Payment> payments = paymentDAO.findAll();
        long totalRevenue = paymentDAO.getTotalRevenue();
        req.setAttribute("payments", payments);
        req.setAttribute("totalRevenue", totalRevenue);
        req.getRequestDispatcher("/jsp/admin/payments.jsp").forward(req, resp);
    }

    private void showTutorVerification(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Tutor> pendingTutors = tutorDAO.findPendingVerification();
        List<Tutor> allTutors = tutorDAO.findAll();
        req.setAttribute("pendingTutors", pendingTutors);
        req.setAttribute("allTutors", allTutors);
        req.getRequestDispatcher("/jsp/admin/tutors.jsp").forward(req, resp);
    }
}
