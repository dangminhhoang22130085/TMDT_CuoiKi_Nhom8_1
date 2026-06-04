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

    <div class="admin-layout">
        <jsp:include page="/layout/admin-sidebar.jsp"/>

        <main class="admin-content">
            <section class="dashboard-grid">
                <h1>Dashboard</h1>
                
                <c:if test="${sessionScope.account.role == 1}">
                    <!-- Student Dashboard -->
                    <div class="dashboard-cards">
                        <div class="dash-card">
                            <i class="fas fa-calendar-check"></i>
                            <h3>Lớp Sắp Tới</h3>
                            <p class="dash-value"><!-- ${studentBookings} --></p>
                            <a href="#">Xem Chi Tiết</a>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-star"></i>
                            <h3>Gia Sư Yêu Thích</h3>
                            <p class="dash-value"><!-- ${favoriteTutors} --></p>
                            <a href="#">Xem Danh Sách</a>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-wallet"></i>
                            <h3>Số Dư Tài Khoản</h3>
                            <p class="dash-value"><!-- ${balance} --></p>
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
                                <!-- Expected from backend: ${studentBookings} -->
                                <tr class="empty-row">
                                    <td colspan="5" style="text-align: center;">Chưa có lịch học</td>
                                </tr>
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
                            <p class="dash-value"><!-- ${totalStudents} --></p>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-graduation-cap"></i>
                            <h3>Số Lớp Dạy</h3>
                            <p class="dash-value"><!-- ${totalCourses} --></p>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-wallet"></i>
                            <h3>Thu Nhập Tháng Này</h3>
                            <p class="dash-value"><!-- ${monthlyIncome} --></p>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-star"></i>
                            <h3>Đánh Giá Trung Bình</h3>
                            <p class="dash-value"><!-- ${averageRating} -->/5</p>
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
                                <!-- Expected from backend: ${tutorBookings} -->
                                <tr class="empty-row">
                                    <td colspan="5" style="text-align: center;">Chưa có lịch dạy</td>
                                </tr>
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
