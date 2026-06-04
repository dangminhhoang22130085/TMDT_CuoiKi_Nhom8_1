<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/register.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-card auth-card-large">
            <div class="auth-header">
                <div class="auth-logo">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <h1>TutorHub</h1>
                <p>Tạo tài khoản mới</p>
            </div>

            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${requestScope.error}</span>
                </div>
            </c:if>

            <div class="role-selector">
                <button type="button" class="role-btn active" data-role="student">
                    <i class="fas fa-user-graduate"></i>
                    <span>Học Sinh</span>
                </button>
                <button type="button" class="role-btn" data-role="tutor">
                    <i class="fas fa-chalkboard-user"></i>
                    <span>Gia Sư</span>
                </button>
            </div>

            <form action="<c:url value='/register'/>" method="post" class="auth-form">
                <input type="hidden" id="roleInput" name="role" value="1">

                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            placeholder="example@email.com"
                            required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Mật Khẩu</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            placeholder="Tối thiểu 6 ký tự"
                            required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Xác Nhận Mật Khẩu</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input 
                            type="password" 
                            id="confirmPassword" 
                            name="confirmPassword" 
                            placeholder="Xác nhận mật khẩu"
                            required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" name="agree" required>
                        <span>
                            Tôi đồng ý với 
                            <a href="#">Điều khoản dịch vụ</a> và 
                            <a href="#">Chính sách riêng tư</a>
                        </span>
                    </label>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-user-plus"></i> Đăng Ký
                </button>
            </form>

            <div class="auth-footer">
                <p>
                    Đã có tài khoản?
                    <a href="<c:url value='/login'/>">Đăng nhập</a>
                </p>
            </div>
        </div>

        <div class="auth-background">
            <div class="auth-shape auth-shape-1"></div>
            <div class="auth-shape auth-shape-2"></div>
            <div class="auth-shape auth-shape-3"></div>
        </div>
    </div>

    <script>
        // Role selector
        document.querySelectorAll('.role-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.role-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                document.getElementById('roleInput').value = this.dataset.role === 'student' ? '1' : '2';
            });
        });
    </script>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>