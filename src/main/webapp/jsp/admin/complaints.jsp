<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giải Quyết Khiếu Nại | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <div class="admin-layout">
        <jsp:include page="/layout/admin-sidebar.jsp">
            <jsp:param name="activePage" value="complaints"/>
        </jsp:include>

        <main class="admin-content">
            <section class="admin-section">
                <h1><i class="fas fa-exclamation-triangle"></i> Giải Quyết Khiếu Nại</h1>
                <p>Tiếp nhận khiếu nại của học sinh về chất lượng dạy học hoặc hành vi của gia sư.</p>

                <div class="section-card" style="margin-top: 1.5rem;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã KN</th>
                                <th>Người Gửi</th>
                                <th>Gia Sư Bị Khiếu Nại</th>
                                <th>Tiêu Đề & Nội Dung</th>
                                <th>Ngày Gửi</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.complaints}">
                                    <c:forEach var="comp" items="${requestScope.complaints}">
                                        <tr>
                                            <td><code>${comp.id}</code></td>
                                            <td><strong>${comp.student.name}</strong></td>
                                            <td><strong>${comp.booking.tutor.name}</strong></td>
                                            <td>
                                                <div style="font-weight: 600; color: #d35400;">${comp.title}</div>
                                                <div style="font-size: 0.85rem; color: #555; max-width: 250px; max-height: 80px; overflow-y: auto; margin-top: 4px;">
                                                    ${comp.description}
                                                </div>
                                            </td>
                                            <td>${comp.createdAt}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${comp.status eq 'pending'}">
                                                        <span class="badge badge-warning" style="background-color: #f39c12; color: white; padding: 2px 6px; border-radius: 4px;">Đang chờ</span>
                                                    </c:when>
                                                    <c:when test="${comp.status eq 'resolved'}">
                                                        <span class="badge badge-success" style="background-color: #2ecc71; color: white; padding: 2px 6px; border-radius: 4px;">Đã giải quyết</span><br>
                                                        <small style="color: gray; font-size: 0.75rem;">vào: ${comp.resolvedAt}</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-danger" style="background-color: #e74c3c; color: white; padding: 2px 6px; border-radius: 4px;">Từ chối</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${comp.status eq 'pending'}">
                                                        <div style="display: flex; flex-direction: column; gap: 4px;">
                                                            <form action="<c:url value='/admin/complaints'/>" method="post" style="display:inline;" onsubmit="return confirm('Xác nhận đã giải quyết khiếu nại này?');">
                                                                <input type="hidden" name="action" value="resolveComplaint">
                                                                <input type="hidden" name="complaintId" value="${comp.id}">
                                                                <button type="submit" class="btn btn-sm btn-success" style="width:100%; padding: 4px 8px; border-radius:4px; border:none; background-color:#2ecc71; color:white; cursor:pointer;">
                                                                    <i class="fas fa-check-circle"></i> Giải quyết
                                                                </button>
                                                            </form>
                                                            <form action="<c:url value='/admin/complaints'/>" method="post" style="display:inline;" onsubmit="return confirm('Từ chối khiếu nại này?');">
                                                                <input type="hidden" name="action" value="rejectComplaint">
                                                                <input type="hidden" name="complaintId" value="${comp.id}">
                                                                <button type="submit" class="btn btn-sm btn-danger" style="width:100%; padding: 4px 8px; border-radius:4px; border:none; background-color:#e74c3c; color:white; cursor:pointer;">
                                                                    <i class="fas fa-times-circle"></i> Từ chối
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--gray-400); font-style: italic;">Đã đóng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center; color: var(--gray-500); padding: 1.5rem 0;">Chưa có khiếu nại nào gửi lên</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>
