package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        int roleType = Integer.parseInt(req.getParameter("role"));

        // Validation
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
            return;
        }

        if (accountDAO.findByEmail(email) != null) {
            req.setAttribute("error", "Email đã được sử dụng!");
            req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
            return;
        }

        // Create account
        Account account = new Account();
        account.setId(accountDAO.generateNextId());
        account.setEmail(email);
        account.setPassword(password);
        account.setRole(roleType);
        account.setStatus("active");

        if (accountDAO.insert(account)) {
            if (roleType == 1) {
                // Create student profile
                Student student = new Student();
                student.setId(studentDAO.generateNextId());
                student.setName(name);
                student.setPhone(phone);
                student.setAccountId(account.getId());
                studentDAO.insert(student);
            } else if (roleType == 2) {
                // Create tutor profile
                String address = req.getParameter("address") != null ? req.getParameter("address") : "";
                String specialization = req.getParameter("specialization") != null ? req.getParameter("specialization") : "";
                String birthStr = req.getParameter("birth");
                String idCardStr = req.getParameter("idCardNumber") != null ? req.getParameter("idCardNumber") : "0";
                String bankAccStr = req.getParameter("bankAccountNumber") != null ? req.getParameter("bankAccountNumber") : "0";
                String bankName = req.getParameter("bankName") != null ? req.getParameter("bankName") : "";

                Tutor tutor = new Tutor();
                tutor.setId(tutorDAO.generateNextId());
                tutor.setName(name);
                tutor.setEmail(email);
                tutor.setPhone(phone);
                tutor.setAddress(address);
                tutor.setSpecialization(specialization);
                tutor.setDescription("");
                tutor.setVerified(false);
                tutor.setEvaluate(0);
                tutor.setAccountId(account.getId());

                try {
                    tutor.setBirth(Date.valueOf(birthStr));
                } catch (Exception e) {
                    tutor.setBirth(Date.valueOf("2000-01-01"));
                }
                try {
                    tutor.setIdCardNumber(Long.parseLong(idCardStr));
                } catch (Exception e) {
                    tutor.setIdCardNumber(0);
                }
                try {
                    tutor.setBankAccountNumber(Long.parseLong(bankAccStr));
                } catch (Exception e) {
                    tutor.setBankAccountNumber(0);
                }
                tutor.setBankName(bankName);

                tutorDAO.insert(tutor);
            }

            req.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại!");
            req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
        }
    }
}
