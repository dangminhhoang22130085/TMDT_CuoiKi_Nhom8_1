<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vi Dien Tu - TutorHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6c63ff;
            --primary-light: #a29bfe;
            --success: #00b894;
            --danger: #e17055;
            --warning: #fdcb6e;
            --info: #74b9ff;
            --dark: #0d0d1a;
            --card-bg: #1a1a2e;
            --surface: #16213e;
            --text: #e2e8f0;
            --muted: #94a3b8;
            --border: rgba(255,255,255,0.08);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark);
            color: var(--text);
            min-height: 100vh;
        }
        .navbar {
            background: rgba(26,26,46,0.95);
            backdrop-filter: blur(20px);
            padding: 1rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .brand { font-size: 1.4rem; font-weight: 800; color: var(--primary-light); text-decoration: none; }
        .nav-links { display: flex; gap: 1.5rem; align-items: center; }
        .nav-links a { color: var(--muted); text-decoration: none; font-size: 0.9rem; transition: color 0.2s; }
        .nav-links a:hover { color: var(--text); }
        .nav-links a.active { color: var(--primary-light); }
        .container { max-width: 1100px; margin: 0 auto; padding: 2rem; }
        .page-header {
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .page-header h1 { font-size: 1.8rem; font-weight: 700; }
        .page-header .icon { font-size: 2rem; }
        /* Balance Card */
        .balance-card {
            background: linear-gradient(135deg, #6c63ff 0%, #a29bfe 50%, #74b9ff 100%);
            border-radius: 20px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        .balance-card::before {
            content: '';
            position: absolute;
            top: -60px; right: -60px;
            width: 200px; height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        .balance-label { font-size: 0.9rem; opacity: 0.85; margin-bottom: 0.5rem; letter-spacing: 0.05em; text-transform: uppercase; }
        .balance-amount { font-size: 2.8rem; font-weight: 800; letter-spacing: -1px; }
        .balance-actions { margin-top: 1.8rem; display: flex; gap: 1rem; }
        /* Form Panel */
        .panels { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 2rem; }
        @media (max-width: 700px) { .panels { grid-template-columns: 1fr; } }
        .panel {
            background: var(--card-bg);
            border-radius: 16px;
            border: 1px solid var(--border);
            padding: 1.8rem;
        }
        .panel h3 { font-size: 1.05rem; font-weight: 600; margin-bottom: 1.2rem; display: flex; align-items: center; gap: 0.6rem; }
        .panel h3 .icon { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1rem; }
        .deposit-icon { background: rgba(0,184,148,0.15); color: var(--success); }
        .withdraw-icon { background: rgba(253,203,110,0.15); color: var(--warning); }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; font-size: 0.85rem; color: var(--muted); margin-bottom: 0.4rem; }
        .form-group input {
            width: 100%;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            color: var(--text);
            font-size: 1rem;
            font-family: inherit;
            transition: border-color 0.2s;
        }
        .form-group input:focus { outline: none; border-color: var(--primary); }
        .btn {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.75rem 1.5rem; border-radius: 10px;
            border: none; cursor: pointer; font-size: 0.9rem; font-weight: 600;
            font-family: inherit; transition: all 0.2s;
        }
        .btn-success { background: var(--success); color: #fff; }
        .btn-success:hover { background: #00a381; transform: translateY(-1px); }
        .btn-warning { background: var(--warning); color: #1a1a2e; }
        .btn-warning:hover { filter: brightness(0.9); transform: translateY(-1px); }
        .btn-outline { background: transparent; color: var(--primary-light); border: 1px solid var(--primary); }
        .btn-outline:hover { background: var(--primary); color: #fff; }
        /* Alert */
        .alert {
            padding: 1rem 1.2rem; border-radius: 10px; margin-bottom: 1.5rem;
            font-size: 0.9rem; display: flex; align-items: center; gap: 0.6rem;
        }
        .alert-success { background: rgba(0,184,148,0.12); border: 1px solid rgba(0,184,148,0.3); color: var(--success); }
        .alert-error   { background: rgba(225,112,85,0.12);  border: 1px solid rgba(225,112,85,0.3);  color: var(--danger);  }
        /* Transactions Table */
        .section-title { font-size: 1.1rem; font-weight: 600; margin-bottom: 1rem; color: var(--text); }
        .tx-table-wrap { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); overflow: hidden; }
        .tx-table { width: 100%; border-collapse: collapse; }
        .tx-table thead th { background: var(--surface); padding: 0.9rem 1.2rem; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: var(--muted); text-align: left; }
        .tx-table tbody td { padding: 0.9rem 1.2rem; border-bottom: 1px solid var(--border); font-size: 0.88rem; }
        .tx-table tbody tr:last-child td { border-bottom: none; }
        .tx-table tbody tr:hover { background: rgba(255,255,255,0.03); }
        .badge {
            display: inline-block; padding: 0.25em 0.65em; border-radius: 6px;
            font-size: 0.75rem; font-weight: 600; letter-spacing: 0.02em;
        }
        .badge-deposit  { background: rgba(0,184,148,0.15);  color: var(--success); }
        .badge-withdraw { background: rgba(253,203,110,0.15); color: var(--warning); }
        .badge-payment  { background: rgba(108,99,255,0.15); color: var(--primary-light); }
        .amount-positive { color: var(--success); font-weight: 600; }
        .amount-negative { color: var(--danger);  font-weight: 600; }
        .empty-state { text-align: center; padding: 3rem; color: var(--muted); }
        .empty-state i { font-size: 2.5rem; margin-bottom: 1rem; opacity: 0.4; }
    </style>
</head>
<body>
<nav class="navbar">
    <a class="brand" href="${pageContext.request.contextPath}/">TutorHub</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/wallet" class="active">Vi Tien</a>
        <a href="${pageContext.request.contextPath}/logout">Dang Xuat</a>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <span class="icon">💳</span>
        <h1>Vi Dien Tu</h1>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>

    <!-- Balance Card -->
    <div class="balance-card">
        <div class="balance-label">So Du Hien Tai</div>
        <div class="balance-amount">${balance} VND</div>
        <div class="balance-actions">
            <c:if test="${sessionScope.account.role == 1}">
                <a href="${pageContext.request.contextPath}/wallet" class="btn btn-outline" style="background:rgba(255,255,255,0.15);color:#fff;border-color:rgba(255,255,255,0.3)">
                    <i class="fas fa-plus"></i> Nap Tien
                </a>
            </c:if>
            <c:if test="${sessionScope.account.role == 2}">
                <a href="${pageContext.request.contextPath}/wallet" class="btn btn-outline" style="background:rgba(255,255,255,0.15);color:#fff;border-color:rgba(255,255,255,0.3)">
                    <i class="fas fa-arrow-down"></i> Rut Tien
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline" style="background:rgba(255,255,255,0.1);color:#fff;border-color:rgba(255,255,255,0.2)">
                <i class="fas fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Action Panels -->
    <div class="panels">
        <!-- Deposit (Student only) -->
        <c:if test="${sessionScope.account.role == 1}">
            <div class="panel">
                <h3>
                    <span class="icon deposit-icon"><i class="fas fa-plus"></i></span>
                    Nap Tien Vao Vi
                </h3>
                <p style="font-size:0.85rem;color:var(--muted);margin-bottom:1.2rem">
                    Nap tien vao vi de thanh toan hoc phi cho gia su.
                </p>
                <form action="${pageContext.request.contextPath}/wallet" method="post" id="depositForm">
                    <input type="hidden" name="action" value="deposit">
                    <div class="form-group">
                        <label for="depositAmount">So Tien Nap (VND)</label>
                        <input type="number" id="depositAmount" name="amount" min="10000" step="10000"
                               placeholder="Vi du: 500000" required>
                    </div>
                    <div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-bottom:1rem">
                        <button type="button" class="btn btn-outline" style="padding:0.4rem 0.8rem;font-size:0.8rem" onclick="document.getElementById('depositAmount').value='100000'">100K</button>
                        <button type="button" class="btn btn-outline" style="padding:0.4rem 0.8rem;font-size:0.8rem" onclick="document.getElementById('depositAmount').value='500000'">500K</button>
                        <button type="button" class="btn btn-outline" style="padding:0.4rem 0.8rem;font-size:0.8rem" onclick="document.getElementById('depositAmount').value='1000000'">1TR</button>
                        <button type="button" class="btn btn-outline" style="padding:0.4rem 0.8rem;font-size:0.8rem" onclick="document.getElementById('depositAmount').value='2000000'">2TR</button>
                    </div>
                    <button type="submit" class="btn btn-success" id="depositBtn">
                        <i class="fas fa-check"></i> Xac Nhan Nap Tien
                    </button>
                </form>
            </div>
        </c:if>

        <!-- Withdraw (Tutor only) -->
        <c:if test="${sessionScope.account.role == 2}">
            <div class="panel">
                <h3>
                    <span class="icon withdraw-icon"><i class="fas fa-arrow-down"></i></span>
                    Rut Tien Ve Ngan Hang
                </h3>
                <p style="font-size:0.85rem;color:var(--muted);margin-bottom:1.2rem">
                    Rut so du tu viec day hoc ve tai khoan ngan hang.
                </p>
                <form action="${pageContext.request.contextPath}/wallet" method="post" id="withdrawForm">
                    <input type="hidden" name="action" value="withdraw">
                    <div class="form-group">
                        <label for="withdrawAmount">So Tien Rut (VND)</label>
                        <input type="number" id="withdrawAmount" name="amount" min="50000" step="10000"
                               placeholder="Vi du: 500000" required>
                    </div>
                    <div style="font-size:0.82rem;color:var(--muted);margin-bottom:1rem;padding:0.8rem;background:var(--surface);border-radius:8px">
                        <i class="fas fa-info-circle" style="color:var(--info)"></i>
                        Toi thieu rut: 50,000 VND. So du con lai phai >= 0.
                    </div>
                    <button type="submit" class="btn btn-warning" id="withdrawBtn">
                        <i class="fas fa-arrow-down"></i> Xac Nhan Rut Tien
                    </button>
                </form>
            </div>
        </c:if>

        <!-- Info card -->
        <div class="panel">
            <h3><span class="icon" style="background:rgba(116,185,255,0.15);color:var(--info)"><i class="fas fa-info"></i></span> Huong Dan</h3>
            <ul style="font-size:0.85rem;color:var(--muted);line-height:2;padding-left:1.2rem">
                <c:if test="${sessionScope.account.role == 1}">
                    <li>Nap tien truoc, sau do thanh toan hoc phi tu Dashboard</li>
                    <li>So du duoc bao mat va ma hoa an toan</li>
                    <li>Moi giao dich deu duoc ghi lai lich su</li>
                </c:if>
                <c:if test="${sessionScope.account.role == 2}">
                    <li>Nhan tien khi hoc sinh thanh toan hoc phi</li>
                    <li>Co the rut tien bat cu luc nao ve ngan hang</li>
                    <li>So du hien thi la so du kha dung</li>
                </c:if>
            </ul>
        </div>
    </div>

    <!-- Transaction History -->
    <div class="section-title"><i class="fas fa-history" style="color:var(--primary-light);margin-right:0.5rem"></i> Lich Su Giao Dich</div>
    <div class="tx-table-wrap">
        <c:choose>
            <c:when test="${not empty transactions}">
                <table class="tx-table">
                    <thead>
                        <tr>
                            <th>Ma GD</th>
                            <th>Loai</th>
                            <th>So Tien</th>
                            <th>Phuong Thuc</th>
                            <th>Trang Thai</th>
                            <th>Thoi Gian</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tx" items="${transactions}">
                            <tr>
                                <td><code style="color:var(--primary-light)">${tx.id}</code></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tx.paymentType == 'DEPOSIT'}">
                                            <span class="badge badge-deposit">Nap Tien</span>
                                        </c:when>
                                        <c:when test="${tx.paymentType == 'WITHDRAW'}">
                                            <span class="badge badge-withdraw">Rut Tien</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-payment">Thanh Toan HP</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tx.paymentType == 'DEPOSIT'}">
                                            <span class="amount-positive">+<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/> VND</span>
                                        </c:when>
                                        <c:when test="${tx.paymentType == 'WITHDRAW'}">
                                            <span class="amount-negative">-<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/> VND</span>
                                        </c:when>
                                        <c:when test="${sessionScope.account.role == 2}">
                                            <span class="amount-positive">+<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/> VND</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="amount-negative">-<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/> VND</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="color:var(--muted)">${not empty tx.paymentMethod ? tx.paymentMethod : '-'}</td>
                                <td>
                                    <span class="badge ${tx.status == 'completed' ? 'badge-deposit' : 'badge-withdraw'}">
                                        ${tx.status == 'completed' ? 'Hoan Thanh' : tx.status}
                                    </span>
                                </td>
                                <td style="color:var(--muted);font-size:0.82rem">
                                    <fmt:formatDate value="${tx.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-receipt"></i>
                    <p>Chua co giao dich nao.</p>
                    <c:if test="${sessionScope.account.role == 1}">
                        <p style="margin-top:0.5rem;font-size:0.85rem">Hay nap tien de bat dau!</p>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // Prevent double submission
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function() {
            const btn = this.querySelector('button[type="submit"]');
            if (btn) { btn.disabled = true; btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Dang xu ly...'; }
        });
    });
</script>
</body>
</html>
