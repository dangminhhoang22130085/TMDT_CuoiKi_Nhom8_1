package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/tutor-detail")
public class TutorDetailServlet extends HttpServlet {
    private TutorDAO tutorDAO = new TutorDAO();
    private SubjectDAO subjectDAO = new SubjectDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tutorId = req.getParameter("id");
        if (tutorId == null || tutorId.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/tutors");
            return;
        }

        Tutor tutor = tutorDAO.findById(tutorId);
        if (tutor == null) {
            resp.sendRedirect(req.getContextPath() + "/tutors");
            return;
        }

        List<Subject> subjects = subjectDAO.findByTutorId(tutorId);
        List<Course> courses = courseDAO.findByTutorId(tutorId);
        List<Review> reviews = reviewDAO.findByTutorId(tutorId);
        double avgRating = reviewDAO.getAverageRating(tutorId);

        req.setAttribute("tutor", tutor);
        req.setAttribute("subjects", subjects);
        req.setAttribute("courses", courses);
        req.setAttribute("reviews", reviews);
        req.setAttribute("avgRating", avgRating);
        req.getRequestDispatcher("/tutor-detail.jsp").forward(req, resp);
    }
}
