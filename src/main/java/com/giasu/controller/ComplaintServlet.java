package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO = new ComplaintDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        Student student = (Student) session.getAttribute("userProfile");

        if (account == null || student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String bookingId = req.getParameter("bookingId");
        if (bookingId == null || bookingId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null || !booking.getStudentId().equals(student.getId())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        req.setAttribute("booking", booking);
        req.getRequestDispatcher("/jsp/booking/complaint.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        Student student = (Student) session.getAttribute("userProfile");

        if (account == null || student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String bookingId = req.getParameter("bookingId");
        String title = req.getParameter("title");
        String description = req.getParameter("description");

        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null || !booking.getStudentId().equals(student.getId())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        Complaint c = new Complaint();
        c.setId(complaintDAO.generateNextId());
        c.setBookingId(bookingId);
        c.setStudentId(student.getId());
        c.setTitle(title);
        c.setDescription(description);
        c.setStatus("pending");
        c.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        if (complaintDAO.insert(c)) {
            req.setAttribute("success", "Gửi khiếu nại thành công! Ban quản trị sẽ sớm xem xét và xử lý.");
        } else {
            req.setAttribute("error", "Có lỗi xảy ra khi gửi khiếu nại, vui lòng thử lại.");
            req.setAttribute("booking", booking);
        }

        req.getRequestDispatcher("/jsp/booking/complaint.jsp").forward(req, resp);
    }
}
