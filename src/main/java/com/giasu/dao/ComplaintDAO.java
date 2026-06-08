package com.giasu.dao;

import com.giasu.model.Complaint;
import com.giasu.model.Student;
import com.giasu.model.Booking;
import com.giasu.model.Tutor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    public boolean insert(Complaint c) {
        String sql = "INSERT INTO complaint (id, booking_id, student_id, title, description, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getId());
            ps.setString(2, c.getBookingId());
            ps.setString(3, c.getStudentId());
            ps.setString(4, c.getTitle());
            ps.setString(5, c.getDescription());
            ps.setString(6, c.getStatus());
            ps.setTimestamp(7, c.getCreatedAt() != null ? c.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(String id, String status) {
        String sql = "UPDATE complaint SET status = ?, resolved_at = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setString(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Complaint> findAll() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.name as st_name, b.tutor_id, t.name as t_name " +
                     "FROM complaint c " +
                     "LEFT JOIN student s ON c.student_id = s.id " +
                     "LEFT JOIN booking b ON c.booking_id = b.id " +
                     "LEFT JOIN tutor t ON b.tutor_id = t.id " +
                     "ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowFull(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Complaint findById(String id) {
        String sql = "SELECT c.*, s.name as st_name, b.tutor_id, t.name as t_name " +
                     "FROM complaint c " +
                     "LEFT JOIN student s ON c.student_id = s.id " +
                     "LEFT JOIN booking b ON c.booking_id = b.id " +
                     "LEFT JOIN tutor t ON b.tutor_id = t.id " +
                     "WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowFull(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Complaint> findByStudentId(String studentId) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.name as st_name, b.tutor_id, t.name as t_name " +
                     "FROM complaint c " +
                     "LEFT JOIN student s ON c.student_id = s.id " +
                     "LEFT JOIN booking b ON c.booking_id = b.id " +
                     "LEFT JOIN tutor t ON b.tutor_id = t.id " +
                     "WHERE c.student_id = ? " +
                     "ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRowFull(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String generateNextId() {
        String sql = "SELECT id FROM complaint ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("id");
                int num = Integer.parseInt(lastId.replace("comp", "")) + 1;
                return String.format("comp%03d", num);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "comp001";
    }

    private Complaint mapRowFull(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setId(rs.getString("id"));
        c.setBookingId(rs.getString("booking_id"));
        c.setStudentId(rs.getString("student_id"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setResolvedAt(rs.getTimestamp("resolved_at"));

        Student s = new Student();
        s.setId(rs.getString("student_id"));
        s.setName(rs.getString("st_name"));
        c.setStudent(s);

        Booking b = new Booking();
        b.setId(rs.getString("booking_id"));
        b.setTutorId(rs.getString("tutor_id"));
        
        Tutor t = new Tutor();
        t.setId(rs.getString("tutor_id"));
        t.setName(rs.getString("t_name"));
        b.setTutor(t);
        c.setBooking(b);

        return c;
    }
}
