package com.giasu.dao;

import com.giasu.model.Subject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    public Subject findById(String id) {
        String sql = "SELECT * FROM subject WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Subject> findAll() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject ORDER BY name, level";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Subject> findActive() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject WHERE status = 'active' ORDER BY name, level";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Subject> findByTutorId(String tutorId) {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT DISTINCT s.* FROM subject s JOIN course c ON s.id = c.subject_id WHERE c.tutor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tutorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Subject mapRow(ResultSet rs) throws SQLException {
        Subject s = new Subject();
        s.setId(rs.getString("id"));
        s.setName(rs.getString("name"));
        s.setLevel(rs.getString("level"));
        s.setDescription(rs.getString("description"));
        s.setFee(rs.getLong("fee"));
        s.setStatus(rs.getString("status"));
        return s;
    }
}
