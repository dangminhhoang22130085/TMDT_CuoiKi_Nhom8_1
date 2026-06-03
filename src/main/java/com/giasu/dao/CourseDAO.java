package com.giasu.dao;

import com.giasu.model.Course;
import com.giasu.model.Subject;
import com.giasu.model.Tutor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    public Course findById(String id) {
        String sql = "SELECT c.*, s.name as s_name, s.level as s_level, s.fee as s_fee, s.description as s_desc, " +
                "t.name as t_name, t.specialization as t_spec, t.evaluate as t_eval " +
                "FROM course c JOIN subject s ON c.subject_id = s.id JOIN tutor t ON c.tutor_id = t.id WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowFull(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Course> findByTutorId(String tutorId) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.*, s.name as s_name, s.level as s_level, s.fee as s_fee, s.description as s_desc, " +
                "t.name as t_name, t.specialization as t_spec, t.evaluate as t_eval " +
                "FROM course c JOIN subject s ON c.subject_id = s.id JOIN tutor t ON c.tutor_id = t.id WHERE c.tutor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tutorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Course> findAll() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.*, s.name as s_name, s.level as s_level, s.fee as s_fee, s.description as s_desc, " +
                "t.name as t_name, t.specialization as t_spec, t.evaluate as t_eval " +
                "FROM course c JOIN subject s ON c.subject_id = s.id JOIN tutor t ON c.tutor_id = t.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Course mapRowFull(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setId(rs.getString("id"));
        c.setSubjectId(rs.getString("subject_id"));
        c.setTutorId(rs.getString("tutor_id"));
        c.setTime(rs.getTimestamp("time"));

        Subject s = new Subject();
        s.setId(rs.getString("subject_id"));
        s.setName(rs.getString("s_name"));
        s.setLevel(rs.getString("s_level"));
        s.setFee(rs.getLong("s_fee"));
        s.setDescription(rs.getString("s_desc"));
        c.setSubject(s);

        Tutor t = new Tutor();
        t.setId(rs.getString("tutor_id"));
        t.setName(rs.getString("t_name"));
        t.setSpecialization(rs.getString("t_spec"));
        t.setEvaluate(rs.getInt("t_eval"));
        c.setTutor(t);

        return c;
    }
}
