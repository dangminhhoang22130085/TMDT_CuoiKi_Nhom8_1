<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Gia Sư | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/tutor-list.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp">
        <jsp:param name="activeMenu" value="tutors"/>
    </jsp:include>

    <main class="page-container">
        <!-- Page Header -->
        <section class="page-header">
            <h1>Danh Sách Gia Sư</h1>
            <p>Tìm gia sư phù hợp với nhu cầu của bạn</p>
        </section>

        <div class="tutors-container">
            <!-- Sidebar Filters -->
            <aside class="filters-sidebar">
                <h3>Bộ Lọc</h3>

                <form action="<c:url value='/tutors'/>" method="get" class="filter-form">
                    <!-- Search -->
                    <div class="filter-group">
                        <label>Tìm Kiếm</label>
                        <div class="search-input-group">
                            <i class="fas fa-search"></i>
                            <input 
                                type="text" 
                                name="keyword" 
                                placeholder="Tên, môn học..."
                                value="${requestScope.keyword}"
                                class="filter-input">
                        </div>
                    </div>

                    <!-- Specialization -->
                    <div class="filter-group">
                        <label>Chuyên Ngành</label>
                        <select name="specialization" class="filter-select">
                            <option value="">Tất Cả</option>
                            <c:forEach var="spec" items="${requestScope.specializations}">
                                <option value="${spec}" ${spec == requestScope.selectedSpec ? 'selected' : ''}>
                                    ${spec}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Rating -->
                    <div class="filter-group">
                        <label>Đánh Giá Tối Thiểu</label>
                        <select name="rating" class="filter-select">
                            <option value="">Tất Cả</option>
                            <option value="5" ${requestScope.selectedRating == '5' ? 'selected' : ''}>
                                5 Sao
                            </option>
                            <option value="4" ${requestScope.selectedRating == '4' ? 'selected' : ''}>
                                4+ Sao
                            </option>
                            <option value="3" ${requestScope.selectedRating == '3' ? 'selected' : ''}>
                                3+ Sao
                            </option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-filter"></i> Áp Dụng Bộ Lọc
                    </button>

                    <a href="<c:url value='/tutors'/>" class="btn btn-outline btn-block">
                        <i class="fas fa-times"></i> Xóa Bộ Lọc
                    </a>
                </form>
            </aside>

            <!-- Tutors List -->
            <section class="tutors-content">
                <div class="tutors-header">
                    <p class="results-count">
                        Tìm thấy <strong>${not empty requestScope.tutors ? requestScope.tutors.size() : 0}</strong> gia sư
                    </p>
                </div>

                <c:choose>
                    <c:when test="${not empty requestScope.tutors}">
                        <div class="tutors-list">
                            <c:forEach var="tutor" items="${requestScope.tutors}">
                                <div class="tutor-list-card">
                                    <div class="tutor-list-image">
                                        <c:choose>
                                            <c:when test="${not empty tutor.avatar}">
                                                <img src="${tutor.avatar}" alt="${tutor.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="avatar-placeholder-large">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${tutor.verified}">
                                            <span class="badge-verified-large">
                                                <i class="fas fa-check-circle"></i> Đã Xác Minh
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="tutor-list-details">
                                        <div class="tutor-name-section">
                                            <h3>${tutor.name}</h3>
                                            <div class="tutor-rating-large">
                                                <c:forEach begin="1" end="${tutor.evaluate}">
                                                    <i class="fas fa-star"></i>
                                                </c:forEach>
                                                <span class="rating-text">
                                                    ${tutor.evaluate} / 5 (${tutor.totalReviews} đánh giá)
                                                </span>
                                            </div>
                                        </div>

                                        <div class="tutor-meta">
                                            <p class="meta-item">
                                                <i class="fas fa-book"></i>
                                                <strong>Chuyên Ngành:</strong> ${tutor.specialization}
                                            </p>
                                            <p class="meta-item">
                                                <i class="fas fa-map-marker-alt"></i>
                                                <strong>Địa Chỉ:</strong> ${tutor.address}
                                            </p>
                                            <p class="meta-item">
                                                <i class="fas fa-phone"></i>
                                                <strong>Điện Thoại:</strong> ${tutor.phone}
                                            </p>
                                        </div>

                                        <p class="tutor-description-large">${tutor.description}</p>

                                        <div class="tutor-stats-large">
                                            <span><i class="fas fa-users"></i> ${tutor.totalStudents} học sinh đã học</span>
                                            <span><i class="fas fa-graduation-cap"></i> ${tutor.totalCourses} lớp dạy</span>
                                        </div>

                                        <div class="tutor-actions">
                                            <a href="<c:url value='/tutor-detail?id=${tutor.id}'/>" class="btn btn-primary">
                                                <i class="fas fa-eye"></i> Xem Chi Tiết
                                            </a>
                                            <a href="<c:url value='/booking?tutorId=${tutor.id}'/>" class="btn btn-success">
                                                <i class="fas fa-calendar-plus"></i> Đặt Lịch
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state-large">
                            <i class="fas fa-search"></i>
                            <h3>Không Tìm Thấy Gia Sư</h3>
                            <p>Hãy thử thay đổi tiêu chí tìm kiếm của bạn</p>
                            <a href="<c:url value='/tutors'/>" class="btn btn-primary">
                                Xem Tất Cả Gia Sư
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>