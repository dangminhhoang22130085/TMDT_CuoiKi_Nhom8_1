<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gửi Khiếu Nại | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/booking.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .complaint-container {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        }
        .booking-details-box {
            background: #f8f9fa;
            border-left: 4px solid #f39c12;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
        }
        .booking-details-box p {
            margin: 0.3rem 0;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <main class="page-container">
        <section class="page-header">
            <h1><i class="fas fa-exclamation-triangle"></i> Gửi Khiếu Nại</h1>
            <p>Chúng tôi sẽ tiếp nhận và phản hồi khiếu nại của bạn trong thời gian sớm nhất.</p>
        </section>

        <div class="complaint-container">
            <c:if test="${not empty requestScope.success}">
                <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 1rem; border-radius: 6px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-check-circle"></i>
                    <span>${requestScope.success}</span>
                </div>
            </c:if>

            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-error" style="background-color: #f8d7da; color: #721c24; padding: 1rem; border-radius: 6px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${requestScope.error}</span>
                </div>
            </c:if>

            <c:if test="${not empty requestScope.booking}">
                <div class="booking-details-box">
                    <h4>Thông tin lớp học bị khiếu nại:</h4>
                    <p><strong>Gia sư:</strong> ${requestScope.booking.tutor.name}</p>
                    <p><strong>Chuyên ngành:</strong> ${requestScope.booking.tutor.specialization}</p>
                    <p><strong>Thời gian học:</strong> ${requestScope.booking.bookingTime}</p>
                </div>

                <form action="<c:url value='/complaint'/>" method="post" class="booking-form">
                    <input type="hidden" name="bookingId" value="${requestScope.booking.id}">

                    <div class="form-group">
                        <label for="title">Tiêu Đề Khiếu Nại</label>
                        <input 
                            type="text" 
                            id="title" 
                            name="title" 
                            class="form-input" 
                            placeholder="Nhập tiêu đề ngắn gọn (ví dụ: Gia sư vắng mặt không lý do...)"
                            required>
                    </div>

                    <div class="form-group">
                        <label for="description">Nội Dung Chi Tiết</label>
                        <textarea 
                            id="description" 
                            name="description" 
                            class="form-textarea"
                            placeholder="Mô tả chi tiết sự việc, thời gian và yêu cầu giải quyết..."
                            rows="6"
                            required></textarea>
                    </div>

                    <div style="margin-top: 2rem;">
                        <button type="submit" class="btn btn-warning btn-block btn-lg" style="background-color: #f39c12; color: white;">
                            <i class="fas fa-paper-plane"></i> Gửi Khiếu Nại
                        </button>
                        <a href="<c:url value='/dashboard'/>" class="btn btn-outline btn-block" style="text-align: center; display: block; margin-top: 0.5rem;">
                            Quay Lại Dashboard
                        </a>
                    </div>
                </form>
            </c:if>
        </div>
    </main>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>
