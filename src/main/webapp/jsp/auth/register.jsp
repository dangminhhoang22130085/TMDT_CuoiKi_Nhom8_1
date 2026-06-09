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

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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

        <!-- ERROR -->

        <c:if test="${not empty requestScope.error}">

            <div class="alert alert-error">

                <i class="fas fa-exclamation-circle"></i>

                <span>${requestScope.error}</span>

            </div>

        </c:if>

        <!-- ROLE -->

        <div class="role-selector">

            <button
                    type="button"
                    class="role-btn active"
                    data-role="student"
            >

                <i class="fas fa-user-graduate"></i>

                <span>Học Sinh</span>

            </button>

            <button
                    type="button"
                    class="role-btn"
                    data-role="tutor"
            >

                <i class="fas fa-chalkboard-user"></i>

                <span>Gia Sư</span>

            </button>

        </div>

        <!-- FORM -->

        <form
                action="<c:url value='/register'/>"
                method="post"
                class="auth-form"
        >

            <!-- ROLE -->

            <input
                    type="hidden"
                    id="roleInput"
                    name="role"
                    value="1"
            >

            <!-- EMAIL -->

            <div class="form-group">

                <label for="email">

                    Email

                </label>

                <div class="input-wrapper">

                    <i class="fas fa-envelope"></i>

                    <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="example@email.com"
                            required
                    >

                </div>

            </div>

            <!-- PASSWORD -->

            <div class="form-group">

                <label for="password">

                    Mật Khẩu

                </label>

                <div class="input-wrapper">

                    <i class="fas fa-lock"></i>

                    <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Tối thiểu 6 ký tự"
                            required
                    >

                </div>

            </div>

            <!-- CONFIRM PASSWORD -->

            <div class="form-group">

                <label for="confirmPassword">

                    Xác Nhận Mật Khẩu

                </label>

                <div class="input-wrapper">

                    <i class="fas fa-lock"></i>

                    <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            placeholder="Xác nhận mật khẩu"
                            required
                    >

                </div>

            </div>

            <!-- NAME -->

            <div class="form-group">

                <label for="name">

                    Họ Và Tên

                </label>

                <div class="input-wrapper">

                    <i class="fas fa-user"></i>

                    <input
                            type="text"
                            id="name"
                            name="name"
                            placeholder="Nguyễn Văn A"
                            required
                    >

                </div>

            </div>

            <!-- PHONE -->

            <div class="form-group">

                <label for="phone">

                    Số Điện Thoại

                </label>

                <div class="input-wrapper">

                    <i class="fas fa-phone"></i>

                    <input
                            type="text"
                            id="phone"
                            name="phone"
                            placeholder="0123456789"
                            required
                    >

                </div>

            </div>

            <!-- ADDRESS -->

            <div class="form-group">

                <label for="address">

                    Địa Chỉ

                </label>

                <div class="input-wrapper">

                    <i class="fas fa-location-dot"></i>

                    <input
                            type="text"
                            id="address"
                            name="address"
                            placeholder="Nhập địa chỉ"
                    >

                </div>

            </div>

            <!-- TUTOR EXTRA -->

            <div id="tutorFields" style="display:none;">

                <!-- BIRTH -->

                <div class="form-group">

                    <label for="birth">

                        Ngày Sinh

                    </label>

                    <div class="input-wrapper">

                        <i class="fas fa-calendar"></i>

                        <input
                                type="date"
                                id="birth"
                                name="birth"
                        >

                    </div>

                </div>

                <!-- SPECIALIZATION -->

                <div class="form-group">

                    <label for="specialization">

                        Chuyên Môn

                    </label>

                    <div class="input-wrapper">

                        <i class="fas fa-book"></i>

                        <input
                                type="text"
                                id="specialization"
                                name="specialization"
                                placeholder="IELTS, Toán..."
                        >

                    </div>

                </div>

                <!-- CCCD -->

                <div class="form-group">

                    <label for="idCardNumber">

                        CCCD

                    </label>

                    <div class="input-wrapper">

                        <i class="fas fa-id-card"></i>

                        <input
                                type="text"
                                id="idCardNumber"
                                name="idCardNumber"
                                placeholder="Nhập CCCD"
                        >

                    </div>

                </div>

                <!-- BANK ACCOUNT -->

                <div class="form-group">

                    <label for="bankAccountNumber">

                        Số Tài Khoản

                    </label>

                    <div class="input-wrapper">

                        <i class="fas fa-credit-card"></i>

                        <input
                                type="text"
                                id="bankAccountNumber"
                                name="bankAccountNumber"
                                placeholder="Nhập số tài khoản"
                        >

                    </div>

                </div>

                <!-- BANK NAME -->

                <div class="form-group">

                    <label for="bankName">

                        Ngân Hàng

                    </label>

                    <div class="input-wrapper">

                        <i class="fas fa-building-columns"></i>

                        <input
                                type="text"
                                id="bankName"
                                name="bankName"
                                placeholder="Ví dụ: MB Bank"
                        >

                    </div>

                </div>

            </div>

            <!-- AGREE -->

            <div class="form-group">

                <label class="checkbox">

                    <input
                            type="checkbox"
                            name="agree"
                            required
                    >

                    <span>

                        Tôi đồng ý với

                        <a href="#">
                            Điều khoản dịch vụ
                        </a>

                        và

                        <a href="#">
                            Chính sách riêng tư
                        </a>

                    </span>

                </label>

            </div>

            <!-- BUTTON -->

            <button
                    type="submit"
                    class="btn btn-primary btn-block"
            >

                <i class="fas fa-user-plus"></i>

                Đăng Ký

            </button>

        </form>

        <!-- FOOTER -->

        <div class="auth-footer">

            <p>

                Đã có tài khoản?

                <a href="<c:url value='/login'/>">

                    Đăng nhập

                </a>

            </p>

        </div>

    </div>

    <!-- BACKGROUND -->

    <div class="auth-background">

        <div class="auth-shape auth-shape-1"></div>

        <div class="auth-shape auth-shape-2"></div>

        <div class="auth-shape auth-shape-3"></div>

    </div>

</div>

<!-- SCRIPT -->

<script>

    // ROLE SELECTOR

    const tutorFields =
        document.getElementById(
            "tutorFields"
        );

    document
        .querySelectorAll('.role-btn')
        .forEach(btn => {

            btn.addEventListener(
                'click',
                function() {

                    document
                        .querySelectorAll('.role-btn')
                        .forEach(
                            b => b.classList.remove('active')
                        );

                    this.classList.add('active');

                    const role =
                        this.dataset.role === 'student'
                            ? '1'
                            : '2';

                    document
                        .getElementById('roleInput')
                        .value = role;

                    if(role === '2'){

                        tutorFields.style.display =
                            'block';

                    }else{

                        tutorFields.style.display =
                            'none';
                    }
                }
            );
        });

    // CONFIRM PASSWORD

    document
        .querySelector('.auth-form')
        .addEventListener(
            'submit',
            function(e){

                const password =
                    document.getElementById(
                        'password'
                    ).value;

                const confirmPassword =
                    document.getElementById(
                        'confirmPassword'
                    ).value;

                if(password !== confirmPassword){

                    e.preventDefault();

                    alert(
                        'Mật khẩu xác nhận không khớp'
                    );
                }
            }
        );

</script>

<script src="<c:url value='/js/main.js'/>"></script>

</body>

</html>