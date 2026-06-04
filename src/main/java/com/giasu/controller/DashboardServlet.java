package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account.getRole() == 2) {
            // Tutor dashboard
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            List<Booking> bookings = bookingDAO.findByTutorId(tutor.getId());
            List<Course> courses = courseDAO.findByTutorId(tutor.getId());
            List<Payment> payments = paymentDAO.findByTutorId(tutor.getId());
            List<Review> reviews = reviewDAO.findByTutorId(tutor.getId());

            req.setAttribute("bookings", bookings);
            req.setAttribute("courses", courses);
            req.setAttribute("payments", payments);
            req.setAttribute("reviews", reviews);
            req.getRequestDispatcher("/jsp/auth/dashboard.jsp").forward(req, resp);
        } else if (account.getRole() == 1) {
            // Student dashboard
            Student student = (Student) session.getAttribute("userProfile");
            List<Booking> bookings = bookingDAO.findByStudentId(student.getId());
            List<Payment> payments = paymentDAO.findByStudentId(student.getId());

            req.setAttribute("bookings", bookings);
            req.setAttribute("payments", payments);
            req.getRequestDispatcher("/jsp/auth/dashboard.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }
}
