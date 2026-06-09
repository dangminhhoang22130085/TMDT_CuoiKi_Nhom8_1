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

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

</head>

<body>

<jsp:include page="/layout/header.jsp"/>

<main class="page-container">

    <section class="page-header">

        <h1>
            <i class="fas fa-calendar-plus"></i>
            Đặt Lịch Học
        </h1>

        <p>Chọn lịch và khóa học phù hợp với bạn</p>

    </section>

    <div class="booking-container">

        <!-- SUCCESS -->
        <c:if test="${not empty requestScope.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${requestScope.success}</span>
            </div>
        </c:if>

        <!-- ERROR -->
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${requestScope.error}</span>
            </div>
        </c:if>

        <div class="booking-content">

            <!-- TUTOR -->
            <c:if test="${not empty requestScope.tutor}">
                <div class="booking-tutor-card">

                    <h3>Thông Tin Gia Sư</h3>

                    <div class="tutor-booking-info">

                        <div class="tutor-booking-image">

                            <c:choose>
                                <c:when test="${not empty requestScope.tutor.avatar}">
                                    <img src="<c:url value='/images/${requestScope.tutor.avatar}'/>"
                                         alt="${requestScope.tutor.name}">
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

                            <p>
                                <strong>Chuyên Ngành:</strong>
                                    ${requestScope.tutor.specialization}
                            </p>

                            <p>
                                <strong>Đánh Giá:</strong>
                                    ${requestScope.tutor.evaluate} / 5
                            </p>

                        </div>

                    </div>

                </div>
            </c:if>

            <!-- FORM -->
            <form action="<c:url value='/booking'/>"
                  method="post"
                  class="booking-form">

                <h3>Chi Tiết Đặt Lịch</h3>

                <!-- tutorId -->
                <input type="hidden"
                       name="tutorId"
                       value="${requestScope.tutor.id}">

                <!-- COURSE -->
                <div class="form-group">

                    <label for="courseId">Chọn Khóa Học</label>

                    <select id="courseId"
                            name="courseId"
                            class="form-select"
                            required>

                        <option value="">-- Chọn khóa học --</option>

                        <c:forEach var="course"
                                   items="${requestScope.courses}">

                            <option value="${course.id}">

                                <!-- 🔥 FIX CHÍNH Ở ĐÂY -->
                                    ${course.subject.name}
                                <c:if test="${not empty course.subject.level}">
                                    - ${course.subject.level}
                                </c:if>

                            </option>

                        </c:forEach>

                    </select>

                </div>

                <!-- BOOKING TIME -->
                <div class="form-group">

                    <label for="bookingTime">Chọn Thời Gian Học</label>

                    <input type="datetime-local"
                           id="bookingTime"
                           name="bookingTime"
                           class="form-input"
                           required>

                </div>

                <!-- NOTE -->
                <div class="form-group">

                    <label for="note">Ghi Chú</label>

                    <textarea id="note"
                              name="note"
                              class="form-textarea"
                              rows="4"
                              placeholder="Nhập ghi chú thêm..."></textarea>

                </div>

                <!-- TERMS -->
                <div class="form-group">

                    <label class="checkbox">

                        <input type="checkbox" required>

                        <span>Tôi đồng ý với điều khoản đặt lịch</span>

                    </label>

                </div>

                <!-- BUTTON -->
                <button type="submit"
                        class="btn btn-success btn-block btn-lg">

                    <i class="fas fa-check"></i>
                    Xác Nhận Đặt Lịch

                </button>

                <a href="<c:url value='/tutors'/>"
                   class="btn btn-outline btn-block">

                    Quay Lại Danh Sách

                </a>

            </form>

        </div>

    </div>

</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="<c:url value='/js/main.js'/>"></script>

<script>

    const bookingInput = document.getElementById("bookingTime");

    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());

    bookingInput.min = now.toISOString().slice(0, 16);

</script>

</body>
</html>