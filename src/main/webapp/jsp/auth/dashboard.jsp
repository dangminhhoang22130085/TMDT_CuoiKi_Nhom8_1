<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <c:choose>
        <c:when test="${sessionScope.account.role == 3}">
            <div class="admin-layout">
                <jsp:include page="/layout/admin-sidebar.jsp"/>
                <main class="admin-content">
        </c:when>
        <c:otherwise>
            <div class="dashboard-wrapper" style="max-width: 1400px; margin: 0 auto; padding: 2rem;">
                <main>
        </c:otherwise>
    </c:choose>
            <section class="dashboard-grid">
                <h1>Dashboard</h1>
                
                <c:if test="${sessionScope.account.role == 1}">
                    <!-- Student Dashboard -->
                    <div class="dashboard-cards">
                        <div class="dash-card">
                            <i class="fas fa-calendar-check"></i>
                            <h3>Lớp Sắp Tới</h3>
                            <p class="dash-value">${requestScope.upcomingCount}</p>
                            <a href="#">Xem Chi Tiết</a>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-star"></i>
                            <h3>Gia Sư Yêu Thích</h3>
                            <p class="dash-value">${requestScope.favoriteTutors}</p>
                            <a href="#">Xem Danh Sách</a>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-wallet"></i>
                            <h3>Số Dư Tài Khoản</h3>
                            <p class="dash-value">${requestScope.balance}</p>
                            <a href="#">Nạp Tiền</a>
                        </div>
                    </div>

                    <div class="section-card">
                        <h2>Lịch Học Gần Đây</h2>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Gia Sư</th>
                                    <th>Khóa Học</th>
                                    <th>Thời Gian</th>
                                    <th>Trạng Thái</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.studentBookings}">
                                        <c:forEach var="b" items="${requestScope.studentBookings}">
                                            <tr>
                                                <td><strong>${b.tutor.name}</strong></td>
                                                <td>${b.tutor.specialization}</td>
                                                <td>${b.bookingTime}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'pending'}">
                                                            <span class="badge badge-warning" style="background-color: #f39c12; color: white; padding: 4px 8px; border-radius: 4px;">Đang chờ duyệt</span>
                                                        </c:when>
                                                        <c:when test="${b.status eq 'confirmed'}">
                                                            <span class="badge badge-success" style="background-color: #2ecc71; color: white; padding: 4px 8px; border-radius: 4px;">Đã xác nhận</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger" style="background-color: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px;">Đã hủy</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'pending'}">
                                                            <a href="<c:url value='/booking?action=cancel&amp;id=${b.id}'/>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn hủy đặt lịch này?');">
                                                                <i class="fas fa-times"></i> Hủy
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${b.status eq 'confirmed'}">
                                                            <a href="<c:url value='/payment?courseId=${b.courseId}&amp;tutorId=${b.tutorId}&amp;amount=2000000'/>" class="btn btn-sm btn-success" style="margin-right: 5px;">
                                                                <i class="fas fa-credit-card"></i> Thanh Toán
                                                            </a>
                                                            <a href="<c:url value='/complaint?bookingId=${b.id}'/>" class="btn btn-sm btn-warning">
                                                                <i class="fas fa-exclamation-triangle"></i> Khiếu Nại
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--gray-400);">Không có hành động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="empty-row">
                                            <td colspan="5" style="text-align: center;">Chưa có lịch học</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${sessionScope.account.role == 2}">
                    <!-- Tutor Dashboard -->
                    <div class="dashboard-cards">
                        <div class="dash-card">
                            <i class="fas fa-users"></i>
                            <h3>Số Học Sinh</h3>
                            <p class="dash-value">${requestScope.totalStudents}</p>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-graduation-cap"></i>
                            <h3>Số Lớp Dạy</h3>
                            <p class="dash-value">${requestScope.totalCourses}</p>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-wallet"></i>
                            <h3>Thu Nhập Tháng Này</h3>
                            <p class="dash-value">${requestScope.monthlyIncome}</p>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-star"></i>
                            <h3>Đánh Giá Trung Bình</h3>
                            <p class="dash-value">${requestScope.averageRating} / 5</p>
                        </div>
                    </div>

                    <div class="section-card">
                        <h2>Lịch Dạy</h2>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Học Sinh</th>
                                    <th>Lớp Học</th>
                                    <th>Thời Gian</th>
                                    <th>Trạng Thái</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.tutorBookings}">
                                        <c:forEach var="b" items="${requestScope.tutorBookings}">
                                            <tr>
                                                <td><strong>${b.student.name}</strong></td>
                                                <td>${b.tutor.specialization}</td>
                                                <td>${b.bookingTime}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'pending'}">
                                                            <span class="badge badge-warning" style="background-color: #f39c12; color: white; padding: 4px 8px; border-radius: 4px;">Chờ phê duyệt</span>
                                                        </c:when>
                                                        <c:when test="${b.status eq 'confirmed'}">
                                                            <span class="badge badge-success" style="background-color: #2ecc71; color: white; padding: 4px 8px; border-radius: 4px;">Đã xác nhận</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger" style="background-color: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px;">Đã từ chối</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'pending'}">
                                                            <a href="<c:url value='/booking?action=confirm&amp;id=${b.id}'/>" class="btn btn-sm btn-success" style="margin-right: 5px;">
                                                                <i class="fas fa-check"></i> Chấp Nhận
                                                            </a>
                                                            <a href="<c:url value='/booking?action=cancel&amp;id=${b.id}'/>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn từ chối lịch học này?');">
                                                                <i class="fas fa-times"></i> Từ Chối
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--gray-400);">Không có hành động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="empty-row">
                                            <td colspan="5" style="text-align: center;">Chưa có lịch dạy</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </section>
        </main>
    </div>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>
