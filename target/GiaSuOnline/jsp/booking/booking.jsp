<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Học | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/booking.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <main class="page-container">
        <section class="page-header">
            <h1><i class="fas fa-calendar-plus"></i> Đặt Lịch Học</h1>
            <p>Chọn lịch và khóa học phù hợp với bạn</p>
        </section>

        <div class="booking-container">
            <c:if test="${not empty requestScope.success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${requestScope.success}</span>
                </div>
            </c:if>

            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${requestScope.error}</span>
                </div>
            </c:if>

            <div class="booking-content">
                <!-- Tutor Info Card -->
                <c:if test="${not empty requestScope.tutor}">
                    <div class="booking-tutor-card">
                        <h3>Thông Tin Gia Sư</h3>
                        <div class="tutor-booking-info">
                            <div class="tutor-booking-image">
                                <c:choose>
                                    <c:when test="${not empty requestScope.tutor.avatar}">
                                        <img src="${requestScope.tutor.avatar}" alt="${requestScope.tutor.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="avatar-placeholder">
                                            <i class="fas fa-user"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="tutor-booking-details">
                                <h4>${requestScope.tutor.name}</h4>
                                <p><strong>Chuyên Ngành:</strong> ${requestScope.tutor.specialization}</p>
                                <p><strong>Điểm:</strong> ${requestScope.tutor.evaluate} / 5</p>
                                <p><strong>Số Học Sinh:</strong> ${requestScope.tutor.totalStudents}</p>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Booking Form -->
                <form action="<c:url value='/booking'/>" method="post" class="booking-form">
                    <h3>Chi Tiết Đặt Lịch</h3>

                    <input type="hidden" name="tutorId" value="${requestScope.tutor.id}">

                    <!-- Course Selection -->
                    <c:if test="${not empty requestScope.courses}">
                        <div class="form-group">
                            <label for="courseId">Chọn Khóa Học</label>
                            <select id="courseId" name="courseId" class="form-select" required>
                                <option value="">-- Chọn khóa học --</option>
                                <c:forEach var="course" items="${requestScope.courses}">
                                    <option value="${course.id}" 
                                        ${requestScope.selectedCourse.id == course.id ? 'selected' : ''}>
                                        ${course.name} - ${course.price}đ/giờ
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:if>

                    <!-- Booking Time -->
                    <div class="form-group">
                        <label for="bookingTime">Chọn Thời Gian Học</label>
                        <input 
                            type="datetime-local" 
                            id="bookingTime" 
                            name="bookingTime" 
                            class="form-input"
                            required>
                    </div>

                    <!-- Note -->
                    <div class="form-group">
                        <label for="note">Ghi Chú (Tùy Chọn)</label>
                        <textarea 
                            id="note" 
                            name="note" 
                            class="form-textarea"
                            placeholder="Ghi chú thêm về nhu cầu học của bạn..."
                            rows="4"></textarea>
                    </div>

                    <!-- Terms -->
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" required>
                            <span>
                                Tôi đồng ý với 
                                <a href="#">Điều khoản đặt lịch</a> và 
                                <a href="#">Chính sách hủy</a>
                            </span>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-success btn-block btn-lg">
                        <i class="fas fa-check"></i> Xác Nhận Đặt Lịch
                    </button>

                    <a href="<c:url value='/tutors'/>" class="btn btn-outline btn-block">
                        Quay Lại Danh Sách
                    </a>
                </form>
            </div>
        </div>
    </main>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>