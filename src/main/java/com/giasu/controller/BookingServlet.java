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
        String courseId = req.getParameter("courseId");
        String tutorId = req.getParameter("tutorId");

        // --- XỬ LÝ ACTION: CONFIRM / CANCEL TỪ DASHBOARD ---
        if (action != null && (action.equals("confirm") || action.equals("cancel"))) {
            if (account == null) {
                resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp");
                return;
            }

            String bookingId = req.getParameter("id");
            Booking booking = bookingDAO.findById(bookingId);

            if (booking != null) {
                boolean authorized = false;

                if (account.getRole() == 3) { // Admin
                    authorized = true;
                } else if (account.getRole() == 2) { // Gia sư
                    Tutor tutor = (Tutor) session.getAttribute("userProfile");
                    if (tutor != null && booking.getTutorId().equals(tutor.getId())) {
                        authorized = true;
                    }
                } else if (account.getRole() == 1 && action.equals("cancel")) { // Học sinh hủy
                    Student student = (Student) session.getAttribute("userProfile");
                    if (student != null && booking.getStudentId().equals(student.getId())) {
                        authorized = true;
                    }
                }

                if (authorized) {
                    String status = action.equals("confirm") ? "confirmed" : "rejected";
                    bookingDAO.updateStatus(bookingId, status);

                    if ("confirmed".equals(status) && booking.getCourseId() != null) {
                        if (!courseDAO.isStudentRegistered(booking.getCourseId(), booking.getStudentId())) {
                            courseDAO.registerCourse(booking.getCourseId(), booking.getStudentId(), 10, "pending_payment");
                        }
                    }
                }
            }
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // --- XỬ LÝ HIỂN THỊ FORM ĐẶT LỊCH (VIEW FORM) ---
        // 1. Kiểm tra khóa học trước để đồng bộ hóa tutorId nếu bị thiếu trên URL
        if (courseId != null && !courseId.trim().isEmpty()) {
            Course course = courseDAO.findById(courseId);
            req.setAttribute("selectedCourse", course);
            if (course != null && (tutorId == null || tutorId.trim().isEmpty())) {
                tutorId = course.getTutorId();
            }
        }

        // 2. Nạp dữ liệu Gia sư và danh sách lớp để hiển thị lên form đặt lịch
        if (tutorId != null && !tutorId.trim().isEmpty()) {
            Tutor tutor = tutorDAO.findById(tutorId);
            List<Course> courses = courseDAO.findByTutorId(tutorId);
            req.setAttribute("tutor", tutor);
            req.setAttribute("courses", courses);
        }

        // ĐÃ SỬA: Chỉ gọi duy nhất 1 lần forward sang file giao diện
        req.getRequestDispatcher("/jsp/booking/booking.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Student student = (Student) session.getAttribute("userProfile");

        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        String courseId = req.getParameter("courseId");
        String tutorId = req.getParameter("tutorId");
        String bookingTimeStr = req.getParameter("bookingTime");
        String note = req.getParameter("note");

        if (tutorId == null || tutorId.trim().isEmpty()) {
            if (courseId != null && !courseId.trim().isEmpty()) {
                Course c = courseDAO.findById(courseId);
                if (c != null) {
                    tutorId = c.getTutorId();
                }
            }
        }

        Booking booking = new Booking();
        booking.setId(bookingDAO.generateNextId());
        booking.setCourseId(courseId);
        booking.setTutorId(tutorId);
        booking.setStudentId(student.getId());
        booking.setStatus("pending");
        booking.setNote(note);

        try {
            if (bookingTimeStr != null && !bookingTimeStr.trim().isEmpty()) {
                booking.setBookingTime(Timestamp.valueOf(bookingTimeStr.replace("T", " ") + ":00"));
            } else {
                booking.setBookingTime(new Timestamp(System.currentTimeMillis()));
            }
        } catch (Exception e) {
            booking.setBookingTime(new Timestamp(System.currentTimeMillis()));
        }

        if (bookingDAO.insert(booking)) {
            session.setAttribute("successMessage", "Đặt lịch thành công! Vui lòng chờ gia sư xác nhận.");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            req.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại!");
            if (tutorId != null) {
                req.setAttribute("tutor", tutorDAO.findById(tutorId));
                req.setAttribute("courses", courseDAO.findByTutorId(tutorId));
            }
            if (courseId != null) {
                req.setAttribute("selectedCourse", courseDAO.findById(courseId));
            }
            req.getRequestDispatcher("/jsp/booking/booking.jsp").forward(req, resp);
        }
    }
}