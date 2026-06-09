<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
    >

    <title>Thanh Toán | TutorHub</title>

    <link
            rel="stylesheet"
            href="<c:url value='/css/main.css'/>"
    >

    <link
            rel="stylesheet"
            href="<c:url value='/css/booking.css'/>"
    >

    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    >

</head>

<body>

<jsp:include page="/layout/header.jsp"/>

<main class="page-container">

    <section class="page-header">

        <h1>

            <i class="fas fa-credit-card"></i>

            Thanh Toán

        </h1>

        <p>

            Hoàn tất thanh toán khóa học

        </p>

    </section>

    <div class="booking-container">

        <!-- SUCCESS -->

        <c:if test="${not empty requestScope.success}">

            <div class="alert alert-success">

                <i class="fas fa-check-circle"></i>

                <span>

                        ${requestScope.success}

                </span>

            </div>

        </c:if>

        <!-- ERROR -->

        <c:if test="${not empty requestScope.error}">

            <div class="alert alert-error">

                <i class="fas fa-exclamation-circle"></i>

                <span>

                        ${requestScope.error}

                </span>

            </div>

        </c:if>

        <div class="booking-content">

            <!-- COURSE INFO -->

            <div class="booking-tutor-card">

                <h3>Thông Tin Khóa Học</h3>

                <div class="tutor-booking-details">

                    <p>

                        <strong>Gia Sư:</strong>

                        ${requestScope.tutor.name}

                    </p>

                    <p>

                        <strong>Khóa Học:</strong>

                        ${requestScope.course.name}

                    </p>

                    <p>

                        <strong>Học Phí:</strong>

                        ${requestScope.course.price} VNĐ

                    </p>

                </div>

            </div>

            <!-- PAYMENT FORM -->

            <form
                    action="<c:url value='/payment'/>"
                    method="post"
                    class="booking-form"
            >

                <h3>Thông Tin Thanh Toán</h3>

                <!-- HIDDEN -->

                <input
                        type="hidden"
                        name="courseId"
                        value="${requestScope.course.id}"
                >

                <input
                        type="hidden"
                        name="tutorId"
                        value="${requestScope.tutor.id}"
                >

                <input
                        type="hidden"
                        name="studentId"
                        value="${sessionScope.userProfile.id}"
                >

                <!-- AMOUNT -->

                <div class="form-group">

                    <label>Số Tiền Thanh Toán</label>

                    <input
                            type="number"
                            name="amount"
                            class="form-input"
                            value="${requestScope.course.price}"
                            readonly
                    >

                </div>

                <!-- METHOD -->

                <div class="form-group">

                    <label>Phương Thức Thanh Toán</label>

                    <select
                            name="paymentMethod"
                            class="form-select"
                            required
                    >

                        <option value="bank_transfer">

                            Chuyển Khoản Ngân Hàng

                        </option>

                        <option value="vnpay">

                            VNPay

                        </option>

                    </select>

                </div>

                <!-- NOTE -->

                <div class="form-group">

                    <label>Ghi Chú</label>

                    <textarea
                            name="note"
                            rows="4"
                            class="form-textarea"
                            placeholder="Nhập ghi chú nếu có..."
                    ></textarea>

                </div>

                <!-- BUTTON -->

                <button
                        type="submit"
                        class="btn btn-success btn-block btn-lg"
                >

                    <i class="fas fa-money-check-alt"></i>

                    Xác Nhận Thanh Toán

                </button>

                <a
                        href="<c:url value='/tutors'/>"
                        class="btn btn-outline btn-block"
                >

                    Quay Lại

                </a>

            </form>

        </div>

    </div>

</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="<c:url value='/js/main.js'/>"></script>

</body>

</html>