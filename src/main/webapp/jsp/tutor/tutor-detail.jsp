<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Gia Sư | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/tutor-detail.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <main class="page-container">
        <!-- Tutor Detail Section -->
        <section class="tutor-detail">
            <div class="tutor-detail-header">
                <div class="tutor-detail-image">
                    <c:choose>
                        <c:when test="${not empty requestScope.tutor.avatar}">
                            <img src="${requestScope.tutor.avatar}" alt="${requestScope.tutor.name}">
                        </c:when>
                        <c:otherwise>
                            <div class="avatar-placeholder-xlarge">
                                <i class="fas fa-user"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${requestScope.tutor.verified}">
                        <span class="badge-verified-large">
                            <i class="fas fa-check-circle"></i> Đã Xác Minh
                        </span>
                    </c:if>
                </div>

                <div class="tutor-detail-info">
                    <div class="detail-header-top">
                        <div>
                            <h1>${requestScope.tutor.name}</h1>
                            <p class="detail-specialization">
                                <i class="fas fa-book"></i> ${requestScope.tutor.specialization}
                            </p>
                        </div>
                    </div>

                    <div class="detail-rating">
                        <div class="stars">
                            <c:forEach begin="1" end="${requestScope.tutor.evaluate}">
                                <i class="fas fa-star"></i>
                            </c:forEach>
                        </div>
                        <span>${requestScope.tutor.evaluate} / 5 (${requestScope.tutor.totalReviews} đánh giá)</span>
                    </div>

                    <div class="detail-stats">
                        <div class="stat">
                            <h4>${requestScope.tutor.totalStudents}</h4>
                            <p>Học Sinh</p>
                        </div>
                        <div class="stat">
                            <h4>${requestScope.tutor.totalCourses}</h4>
                            <p>Lớp Dạy</p>
                        </div>
                        <div class="stat">
                            <h4>${requestScope.tutor.totalReviews}</h4>
                            <p>Đánh Giá</p>
                        </div>
                    </div>

                    <div class="detail-contact">
                        <p><i class="fas fa-envelope"></i> <strong>Email:</strong> ${requestScope.tutor.email}</p>
                        <p><i class="fas fa-phone"></i> <strong>Điện Thoại:</strong> ${requestScope.tutor.phone}</p>
                        <p><i class="fas fa-map-marker-alt"></i> <strong>Địa Chỉ:</strong> ${requestScope.tutor.address}</p>
                    </div>

                    <c:if test="${not empty sessionScope.account && sessionScope.account.role == 1}">
                        <a href="<c:url value='/booking?tutorId=${requestScope.tutor.id}'/>" class="btn btn-success btn-lg">
                            <i class="fas fa-calendar-plus"></i> Đặt Lịch Học Ngay
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- About Section -->
            <div class="detail-content">
                <div class="content-section">
                    <h3><i class="fas fa-info-circle"></i> Giới Thiệu</h3>
                    <p>${requestScope.tutor.description}</p>
                </div>

                <!-- Courses Section -->
                <c:if test="${not empty requestScope.courses}">
                    <div class="content-section">
                        <h3><i class="fas fa-graduation-cap"></i> Các Lớp Học</h3>
                        <div class="courses-grid">
                            <c:forEach var="course" items="${requestScope.courses}">
                                <div class="course-card">
                                    <h4>${course.name}</h4>
                                    <p>${course.description}</p>
                                    <div class="course-footer">
                                        <span class="course-price">${course.price}đ/giờ</span>
                                        <a href="<c:url value='/booking?courseId=${course.id}&tutorId=${requestScope.tutor.id}'/>" class="btn btn-sm btn-primary">
                                            Chọn
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Reviews Section - Expected from backend -->
                <div class="content-section">
                    <h3><i class="fas fa-comments"></i> Đánh Giá Từ Học Sinh</h3>
                    <p style="color: #666; font-style: italic;">
                        <!-- Expected from backend: ${requestScope.reviews} -->
                        Các đánh giá sẽ được hiển thị từ cơ sở dữ liệu
                    </p>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>