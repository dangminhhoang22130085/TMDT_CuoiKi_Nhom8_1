package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();

    private TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (account.getRole() == 2) {
            // Tutor dashboard
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            List<Booking> bookings = bookingDAO.findByTutorId(tutor.getId());
            List<Course> courses = courseDAO.findByTutorId(tutor.getId());
            List<Payment> payments = paymentDAO.findByTutorId(tutor.getId());
            List<Review> reviews = reviewDAO.findByTutorId(tutor.getId());

            // Compute statistics
            long monthlyIncome = 0;
            for (Payment p : payments) {
                if ("completed".equals(p.getStatus())) {
                    monthlyIncome += p.getAmount();
                }
            }

            double avgRating = 0;
            if (!reviews.isEmpty()) {
                double sum = 0;
                for (Review r : reviews)
                    sum += r.getRating();
                avgRating = sum / reviews.size();
            } else {
                avgRating = tutor.getEvaluate();
            }

            // Count unique students
            java.util.Set<String> uniqueStudents = new java.util.HashSet<>();
            for (Booking b : bookings) {
                if ("confirmed".equals(b.getStatus())) {
                    uniqueStudents.add(b.getStudentId());
                }
            }
            int studentCount = uniqueStudents.size();
            if (studentCount == 0 && tutor.getTotalStudents() > 0) {
                studentCount = tutor.getTotalStudents();
            }

            req.setAttribute("bookings", bookings);
            req.setAttribute("tutorBookings", bookings);
            req.setAttribute("courses", courses);
            req.setAttribute("payments", payments);
            req.setAttribute("reviews", reviews);

            req.setAttribute("totalStudents", studentCount);
            req.setAttribute("totalCourses", courses.size());
            req.setAttribute("monthlyIncome", String.format("%,d VNĐ", monthlyIncome));
            req.setAttribute("averageRating", String.format("%.1f", avgRating));

            req.getRequestDispatcher("/jsp/auth/dashboard.jsp").forward(req, resp);
        } else if (account.getRole() == 1) {
            // Student dashboard
            Student student = (Student) session.getAttribute("userProfile");
            List<Booking> bookings = bookingDAO.findByStudentId(student.getId());
            List<Payment> payments = paymentDAO.findByStudentId(student.getId());

            // Find favorite tutors count
            int favoriteCount = 0;
            String sqlFav = "SELECT COUNT(*) FROM interest WHERE id_st = ?";
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sqlFav)) {
                ps.setString(1, student.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next())
                        favoriteCount = rs.getInt(1);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Future/Active bookings count
            int upcomingCount = 0;
            for (Booking b : bookings) {
                if ("pending".equals(b.getStatus()) || "confirmed".equals(b.getStatus())) {
                    upcomingCount++;
                }
            }

            req.setAttribute("bookings", bookings);
            req.setAttribute("studentBookings", bookings);
            req.setAttribute("payments", payments);

            req.setAttribute("upcomingCount", upcomingCount);
            req.setAttribute("favoriteTutors", favoriteCount);
            req.setAttribute("balance", "5,000,000 VNĐ"); // Mock balance for demonstration

            req.getRequestDispatcher("/jsp/auth/dashboard.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }
}
