package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

/**
 * WalletServlet handles:
 *  GET  /wallet  -> show wallet page (balance + transaction history)
 *  POST /wallet?action=deposit   -> student top-up (simulated)
 *  POST /wallet?action=withdraw  -> tutor withdrawal
 */
@WebServlet("/wallet")
public class WalletServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private TutorDAO tutorDAO = new TutorDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Payment> transactions;
        long balance = 0;

        if (account.getRole() == 1) {
            Student student = (Student) session.getAttribute("userProfile");
            // Reload fresh balance
            Student fresh = studentDAO.findById(student.getId());
            if (fresh != null) { balance = fresh.getBalance(); session.setAttribute("userProfile", fresh); }
            transactions = paymentDAO.findByStudentId(student.getId());
        } else if (account.getRole() == 2) {
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            Tutor fresh = tutorDAO.findById(tutor.getId());
            if (fresh != null) { balance = fresh.getBalance(); session.setAttribute("userProfile", fresh); }
            transactions = paymentDAO.findByTutorId(tutor.getId());
        } else {
            transactions = paymentDAO.findAll();
        }

        req.setAttribute("balance", balance);
        req.setAttribute("transactions", transactions);
        req.getRequestDispatcher("/jsp/auth/wallet.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String amountStr = req.getParameter("amount");
        long amount;
        try {
            amount = Long.parseLong(amountStr);
            if (amount <= 0) throw new NumberFormatException("non-positive");
        } catch (Exception e) {
            req.setAttribute("error", "So tien khong hop le. Vui long nhap so duong.");
            doGet(req, resp);
            return;
        }

        if ("deposit".equals(action) && account.getRole() == 1) {
            // ---- DEPOSIT for student ----
            Student student = (Student) session.getAttribute("userProfile");
            studentDAO.updateBalance(student.getId(), amount);

            Payment p = new Payment();
            p.setId(paymentDAO.generateNextId());
            p.setStudentId(student.getId());
            p.setAmount(amount);
            p.setPaymentDate(new Timestamp(System.currentTimeMillis()));
            p.setPaymentMethod("bank_transfer");
            p.setStatus("completed");
            p.setPaymentType("DEPOSIT");
            paymentDAO.insert(p);

            // Refresh session
            Student fresh = studentDAO.findById(student.getId());
            if (fresh != null) session.setAttribute("userProfile", fresh);

            req.setAttribute("success", "Nap " + String.format("%,d", amount) + " VND thanh cong!");

        } else if ("withdraw".equals(action) && account.getRole() == 2) {
            // ---- WITHDRAW for tutor ----
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            long currentBalance = tutorDAO.getBalance(tutor.getId());
            if (currentBalance < amount) {
                req.setAttribute("error", "So du khong du de rut. So du hien tai: " + String.format("%,d", currentBalance) + " VND");
                doGet(req, resp);
                return;
            }

            tutorDAO.updateBalance(tutor.getId(), -amount);

            Payment p = new Payment();
            p.setId(paymentDAO.generateNextId());
            p.setTutorId(tutor.getId());
            p.setAmount(amount);
            p.setPaymentDate(new Timestamp(System.currentTimeMillis()));
            p.setPaymentMethod("bank_transfer");
            p.setStatus("completed");
            p.setPaymentType("WITHDRAW");
            paymentDAO.insert(p);

            // Refresh session
            Tutor fresh = tutorDAO.findById(tutor.getId());
            if (fresh != null) session.setAttribute("userProfile", fresh);

            req.setAttribute("success", "Rut " + String.format("%,d", amount) + " VND thanh cong! So du con lai: " +
                    String.format("%,d", currentBalance - amount) + " VND");
        } else {
            req.setAttribute("error", "Hanh dong khong hop le.");
        }

        doGet(req, resp);
    }
}
