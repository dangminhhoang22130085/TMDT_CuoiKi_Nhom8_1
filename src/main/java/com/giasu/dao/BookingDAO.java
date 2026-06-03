package com.giasu.dao;

import com.giasu.model.Booking;
import com.giasu.model.Tutor;
import com.giasu.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean insert(Booking b) {
        String sql = "INSERT INTO booking (id, course_id, tutor_id, student_id, booking_time, status, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getId());
            ps.setString(2, b.getCourseId());
            ps.setString(3, b.getTutorId());
            ps.setString(4, b.getStudentId());
            ps.setTimestamp(5, b.getBookingTime());
            ps.setString(6, b.getStatus());
            ps.setString(7, b.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(String id, String status) {
        String sql = "UPDATE booking SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Booking> findByStudentId(String studentId) {
        return findByField("b.student_id", studentId);
    }

    public List<Booking> findByTutorId(String tutorId) {
        return findByField("b.tutor_id", tutorId);
    }

    public List<Booking> findAll() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, t.name as t_name, t.specialization as t_spec, s.name as st_name " +
                "FROM booking b LEFT JOIN tutor t ON b.tutor_id = t.id LEFT JOIN student s ON b.student_id = s.id ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Booking findById(String id) {
        String sql = "SELECT b.*, t.name as t_name, t.specialization as t_spec, s.name as st_name " +
                "FROM booking b LEFT JOIN tutor t ON b.tutor_id = t.id LEFT JOIN student s ON b.student_id = s.id WHERE b.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowFull(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public String generateNextId() {
        String sql = "SELECT id FROM booking ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("id");
                int num = Integer.parseInt(lastId.replace("bk", "")) + 1;
                return String.format("bk%03d", num);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "bk001";
    }

    private List<Booking> findByField(String field, String value) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, t.name as t_name, t.specialization as t_spec, s.name as st_name " +
                "FROM booking b LEFT JOIN tutor t ON b.tutor_id = t.id LEFT JOIN student s ON b.student_id = s.id WHERE " + field + " = ? ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Booking mapRowFull(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getString("id"));
        b.setCourseId(rs.getString("course_id"));
        b.setTutorId(rs.getString("tutor_id"));
        b.setStudentId(rs.getString("student_id"));
        b.setBookingTime(rs.getTimestamp("booking_time"));
        b.setStatus(rs.getString("status"));
        b.setNote(rs.getString("note"));
        b.setCreatedAt(rs.getTimestamp("created_at"));

        Tutor t = new Tutor();
        t.setId(rs.getString("tutor_id"));
        t.setName(rs.getString("t_name"));
        t.setSpecialization(rs.getString("t_spec"));
        b.setTutor(t);

        Student s = new Student();
        s.setId(rs.getString("student_id"));
        s.setName(rs.getString("st_name"));
        b.setStudent(s);

        return b;
    }
}
