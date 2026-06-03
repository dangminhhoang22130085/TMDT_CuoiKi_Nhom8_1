package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private TutorDAO tutorDAO = new TutorDAO();
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        String action = req.getParameter("action");

        if ("confirm".equals(action) || "cancel".equals(action)) {
            // Tutor confirms or cancels booking
            String bookingId = req.getParameter("id");
            String status = "confirm".equals(action) ? "confirmed" : "cancelled";
            bookingDAO.updateStatus(bookingId, status);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Show booking form
        String courseId = req.getParameter("courseId");
        String tutorId = req.getParameter("tutorId");

        if (tutorId != null) {
            Tutor tutor = tutorDAO.findById(tutorId);
            List<Course> courses = courseDAO.findByTutorId(tutorId);
            req.setAttribute("tutor", tutor);
            req.setAttribute("courses", courses);
        }
        if (courseId != null) {
            Course course = courseDAO.findById(courseId);
            req.setAttribute("selectedCourse", course);
        }

        req.getRequestDispatcher("/booking.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        Student student = (Student) session.getAttribute("userProfile");

        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String courseId = req.getParameter("courseId");
        String tutorId = req.getParameter("tutorId");
        String bookingTimeStr = req.getParameter("bookingTime");
        String note = req.getParameter("note");

        Booking booking = new Booking();
        booking.setId(bookingDAO.generateNextId());
        booking.setCourseId(courseId);
        booking.setTutorId(tutorId);
        booking.setStudentId(student.getId());
        booking.setStatus("pending");
        booking.setNote(note);

        try {
            booking.setBookingTime(Timestamp.valueOf(bookingTimeStr.replace("T", " ") + ":00"));
        } catch (Exception e) {
            booking.setBookingTime(new Timestamp(System.currentTimeMillis()));
        }

        if (bookingDAO.insert(booking)) {
            req.setAttribute("success", "Đặt lịch thành công! Vui lòng chờ gia sư xác nhận.");
        } else {
            req.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại!");
        }

        req.getRequestDispatcher("/booking.jsp").forward(req, resp);
    }
}
