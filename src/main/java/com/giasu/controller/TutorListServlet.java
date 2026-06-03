package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/tutors")
public class TutorListServlet extends HttpServlet {
    private TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String specialization = req.getParameter("specialization");
        String ratingStr = req.getParameter("rating");
        Integer minRating = null;
        if (ratingStr != null && !ratingStr.isEmpty()) {
            try { minRating = Integer.parseInt(ratingStr); } catch (Exception e) {}
        }

        List<Tutor> tutors;
        if ((keyword != null && !keyword.isEmpty()) || (specialization != null && !specialization.isEmpty()) || minRating != null) {
            tutors = tutorDAO.search(keyword, specialization, minRating);
        } else {
            tutors = tutorDAO.findVerified();
        }

        List<String> specializations = tutorDAO.getAllSpecializations();

        req.setAttribute("tutors", tutors);
        req.setAttribute("specializations", specializations);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedSpec", specialization);
        req.setAttribute("selectedRating", ratingStr);
        req.getRequestDispatcher("/tutor-list.jsp").forward(req, resp);
    }
}
