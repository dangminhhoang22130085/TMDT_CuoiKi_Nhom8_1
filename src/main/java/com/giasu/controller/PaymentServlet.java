package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        List<Payment> payments;
        if (account.getRole() == 1) {
            Student student = (Student) session.getAttribute("userProfile");
            payments = paymentDAO.findByStudentId(student.getId());
        } else if (account.getRole() == 2) {
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            payments = paymentDAO.findByTutorId(tutor.getId());
        } else {
            payments = paymentDAO.findAll();
        }

        req.setAttribute("payments", payments);
        req.getRequestDispatcher("/payment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        Student student = (Student) session.getAttribute("userProfile");

        String courseId = req.getParameter("courseId");
        String tutorId = req.getParameter("tutorId");
        String amountStr = req.getParameter("amount");
        String paymentMethod = req.getParameter("paymentMethod");

        Payment payment = new Payment();
        payment.setId(paymentDAO.generateNextId());
        payment.setCourseId(courseId);
        payment.setTutorId(tutorId);
        payment.setStudentId(student.getId());
        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
        payment.setPaymentMethod(paymentMethod);
        payment.setStatus("completed");

        try {
            payment.setAmount(Long.parseLong(amountStr));
        } catch (Exception e) {
            payment.setAmount(0);
        }

        if (paymentDAO.insert(payment)) {
            req.setAttribute("success", "Thanh toán thành công!");
        } else {
            req.setAttribute("error", "Thanh toán thất bại!");
        }

        // Reload payments
        List<Payment> payments = paymentDAO.findByStudentId(student.getId());
        req.setAttribute("payments", payments);
        req.getRequestDispatcher("/payment.jsp").forward(req, resp);
    }
}
