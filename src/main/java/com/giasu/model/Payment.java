package com.giasu.model;

import java.sql.Timestamp;

public class Payment {
    private String id;
    private String courseId;
    private String tutorId;
    private String studentId;
    private long amount;
    private Timestamp paymentDate;
    private String paymentMethod;
    private String status;

    // Join fields
    private Tutor tutor;
    private Student student;
    private Course course;

    public Payment() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }

    public String getTutorId() { return tutorId; }
    public void setTutorId(String tutorId) { this.tutorId = tutorId; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Tutor getTutor() { return tutor; }
    public void setTutor(Tutor tutor) { this.tutor = tutor; }

    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }

    public String getFormattedAmount() {
        return String.format("%,d", amount) + " VNĐ";
    }

    public String getStatusDisplay() {
        switch (status) {
            case "completed": return "Đã thanh toán";
            case "pending": return "Chờ thanh toán";
            case "failed": return "Thất bại";
            default: return status;
        }
    }

    public String getMethodDisplay() {
        switch (paymentMethod) {
            case "bank_transfer": return "Chuyển khoản";
            case "cash": return "Tiền mặt";
            case "momo": return "MoMo";
            default: return paymentMethod;
        }
    }
}
