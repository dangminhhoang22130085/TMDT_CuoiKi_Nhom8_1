<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Học Phí | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/booking.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Extra styles for payment page */
        .wallet-balance-box {
            margin-top: 1.2rem;
            padding: 1rem 1.2rem;
            background: linear-gradient(135deg, rgba(108,99,255,0.08), rgba(162,155,254,0.06));
            border: 1px solid rgba(108,99,255,0.25);
            border-radius: 12px;
        }
        .wallet-balance-box .label {
            font-size: 0.82rem;
            color: var(--color-muted, #94a3b8);
            margin-bottom: 0.3rem;
            display: flex; align-items: center; gap: 0.4rem;
        }
        .wallet-balance-box .amount {
            font-size: 1.35rem;
            font-weight: 700;
            color: #6c63ff;
        }
        .wallet-balance-box .insufficient-warn {
            margin-top: 0.5rem;
            font-size: 0.83rem;
            color: #e74c3c;
            display: flex; align-items: center; gap: 0.4rem;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.6rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            font-size: 0.9rem;
        }
        .summary-row:last-child { border-bottom: none; }
        .summary-row .key { color: var(--color-muted, #94a3b8); }
        .summary-row .val { font-weight: 600; }
        .price-big { font-size: 1.5rem; font-weight: 800; color: #e74c3c; }
        .history-section { margin-top: 2.5rem; }
        .history-section h3 {
            font-size: 1.05rem; font-weight: 600; margin-bottom: 1rem;
            display: flex; align-items: center; gap: 0.5rem;
        }
        .history-table { width: 100%; border-collapse: collapse; font-size: 0.87rem; }
        .history-table th {
            text-align: left; padding: 0.7rem 1rem;
            background: rgba(255,255,255,0.04);
            font-weight: 600; font-size: 0.78rem;
            text-transform: uppercase; letter-spacing: 0.05em;
            color: #94a3b8; border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .history-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .history-table tr:last-child td { border-bottom: none; }
        .history-table tr:hover td { background: rgba(255,255,255,0.02); }
        .badge-ok     { background: rgba(46,204,113,0.12); color: #2ecc71; padding: 0.25em 0.65em; border-radius: 6px; font-size: 0.75rem; font-weight: 600; }
        .badge-type   { background: rgba(108,99,255,0.12); color: #a29bfe; padding: 0.25em 0.65em; border-radius: 6px; font-size: 0.75rem; font-weight: 600; }
        .amt-out { color: #e74c3c; font-weight: 600; }
        .amt-in  { color: #2ecc71; font-weight: 600; }
    </style>
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