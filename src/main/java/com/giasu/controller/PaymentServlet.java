package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private TutorDAO tutorDAO = new TutorDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String courseId = req.getParameter("courseId");
        String tutorId  = req.getParameter("tutorId");

        if (account.getRole() == 1 && courseId != null && tutorId != null) {
            // --- Show Payment Confirmation Page ---
            Student student = (Student) session.getAttribute("userProfile");
            long balance = studentDAO.getBalance(student.getId());

            Course course = courseDAO.findById(courseId);
            Tutor tutor   = tutorDAO.findById(tutorId);

            // Load subject for fee/name info
            if (course != null && course.getSubjectId() != null) {
                try {
                    com.giasu.model.Subject subject = subjectDAO.findById(course.getSubjectId());
                    if (subject != null) {
                        course.setSubject(subject);
                    }
                } catch (Exception ignored) {}
            }

            long price = (course != null && course.getSubject() != null) ? course.getSubject().getFee() : 0;
            boolean insufficient = balance < price;

            req.setAttribute("course", course);
            req.setAttribute("tutor", tutor);
            req.setAttribute("balance", String.format("%,d", balance));
            req.setAttribute("insufficient", insufficient);
            req.getRequestDispatcher("/jsp/payment.jsp").forward(req, resp);
        } else {
            // --- Show payment history ---
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
            req.getRequestDispatcher("/jsp/payment.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRole() != 1) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("userProfile");
        String courseId = req.getParameter("courseId");
        String tutorId  = req.getParameter("tutorId");
        String amountStr = req.getParameter("amount");

        long amount;
        try {
            amount = Long.parseLong(amountStr);
        } catch (Exception e) {
            amount = 0;
        }

        // ---- Atomic transaction: check balance, deduct student, credit tutor, log payment, update course ----
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Re-read student balance from DB to prevent stale session data
            long studentBalance = studentDAO.getBalance(student.getId());
            if (studentBalance < amount) {
                conn.rollback();
                req.setAttribute("error", "So du khong du. Vui long nap them tien.");
                reloadAndForward(req, resp, student);
                return;
            }

            // 2. Deduct from student
            studentDAO.updateBalance(student.getId(), -amount, conn);

            // 3. Credit tutor
            tutorDAO.updateBalance(tutorId, amount, conn);

            // 4. Insert payment record
            Payment payment = new Payment();
            payment.setId(paymentDAO.generateNextId(conn));
            payment.setCourseId(courseId);
            payment.setTutorId(tutorId);
            payment.setStudentId(student.getId());
            payment.setAmount(amount);
            payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
            payment.setPaymentMethod("wallet");
            payment.setStatus("completed");
            payment.setPaymentType("PAYMENT");
            paymentDAO.insert(payment, conn);

            // 5. Update course status to PAID
            if (courseId != null && !courseId.isEmpty()) {
                courseDAO.updateStatus(courseId, "PAID", conn);
            }

            conn.commit();

            // 6. Refresh session balance
            Student refreshed = studentDAO.findById(student.getId());
            if (refreshed != null) session.setAttribute("userProfile", refreshed);

            req.setAttribute("success", "Thanh toan hoc phi thanh cong! So du con lai: " +
                    String.format("%,d", refreshed != null ? refreshed.getBalance() : (studentBalance - amount)) + " VND");

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            req.setAttribute("error", "Loi he thong khi xu ly thanh toan. Vui long thu lai.");
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }

        reloadAndForward(req, resp, student);
    }

    private void reloadAndForward(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        List<Payment> payments = paymentDAO.findByStudentId(student.getId());
        req.setAttribute("payments", payments);
        req.getRequestDispatcher("/jsp/payment.jsp").forward(req, resp);
    }
}
