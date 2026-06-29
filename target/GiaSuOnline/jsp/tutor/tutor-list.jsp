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
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<jsp:include page="/layout/header.jsp">
    <jsp:param name="activeMenu" value="tutors"/>
</jsp:include>

<main class="page-container">

    <section class="page-header">
        <h1>Danh Sách Gia Sư</h1>
        <p>Tìm gia sư phù hợp với nhu cầu của bạn</p>
    </section>

    <div class="tutors-container">

        <!-- FILTER -->
        <aside class="filters-sidebar">
            <h3>Bộ Lọc</h3>

            <form action="<c:url value='/tutors'/>" method="get" class="filter-form">

                <div class="filter-group">
                    <label>Tìm Kiếm</label>
                    <input type="text"
                           name="keyword"
                           placeholder="Tên, môn học..."
                           value="${requestScope.keyword}"
                           class="filter-input">
                </div>

                <div class="filter-group">
                    <label>Chuyên Ngành</label>
                    <select name="specialization" class="filter-select">
                        <option value="">Tất Cả</option>
                        <c:forEach var="spec" items="${requestScope.specializations}">
                            <option value="${spec}"
                                    <c:if test="${spec == requestScope.selectedSpec}">selected</c:if>>
                                    ${spec}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Đánh Giá</label>
                    <select name="rating" class="filter-select">
                        <option value="">Tất Cả</option>
                        <option value="5" <c:if test="${requestScope.selectedRating == '5'}">selected</c:if>>5+</option>
                        <option value="4" <c:if test="${requestScope.selectedRating == '4'}">selected</c:if>>4+</option>
                        <option value="3" <c:if test="${requestScope.selectedRating == '3'}">selected</c:if>>3+</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-filter"></i> Lọc
                </button>

                <a href="<c:url value='/tutors'/>" class="btn btn-outline btn-block">
                    Xóa bộ lọc
                </a>

            </form>
        </aside>

        <!-- LIST -->
        <section class="tutors-content">

            <div class="tutors-header">
                <p>
                    Tìm thấy
                    <strong>${empty requestScope.tutors ? 0 : requestScope.tutors.size()}</strong>
                    gia sư
                </p>
            </div>

            <c:choose>

                <c:when test="${not empty requestScope.tutors}">

                    <div class="tutors-list">

                        <c:forEach var="tutor" items="${requestScope.tutors}">

                            <div class="tutor-list-card">

                                <!-- IMAGE -->
                                <div class="tutor-list-image">

                                    <c:choose>
                                        <c:when test="${not empty tutor.avatar}">
                                            <img src="${pageContext.request.contextPath}/images/tutors/${tutor.avatar}"
                                                 alt="${tutor.name}">
                                        </c:when>

                                        <c:otherwise>
                                            <div class="avatar-placeholder-large">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:if test="${tutor.verified}">
                                        <span class="badge-verified-large">
                                            <i class="fas fa-check-circle"></i> Verified
                                        </span>
                                    </c:if>

                                </div>

                                <!-- INFO -->
                                <div class="tutor-list-details">

                                    <h3>${tutor.name}</h3>

                                    <div class="tutor-rating-large">

                                        <c:forEach begin="1" end="${tutor.evaluate}">
                                            <i class="fas fa-star"></i>
                                        </c:forEach>

                                        <span>
                                            ${tutor.evaluate} / 5
                                        </span>

                                    </div>

                                    <p><strong>Chuyên:</strong> ${tutor.specialization}</p>
                                    <p><strong>Địa chỉ:</strong> ${tutor.address}</p>
                                    <p><strong>SĐT:</strong> ${tutor.phone}</p>

                                    <p class="tutor-description-large">
                                            ${tutor.description}
                                    </p>

                                    <!-- ACTION -->
                                    <div class="tutor-actions">

                                        <a href="${pageContext.request.contextPath}/tutor-detail?id=${tutor.id}"
                                           class="btn btn-primary">
                                            Xem chi tiết
                                        </a>

                                        <!-- ✅ FIX QUAN TRỌNG NHẤT -->
                                        <a href="${pageContext.request.contextPath}/booking?tutorId=${tutor.id}"
                                           class="btn btn-success">
                                            Đặt lịch
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
                        <h3>Không tìm thấy gia sư</h3>
                        <a href="<c:url value='/tutors'/>" class="btn btn-primary">
                            Xem tất cả
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