<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>头大 - 列车票务系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 保留原有所有CSS样式 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: #333;
            min-height: 100vh;
        }

        /* 顶部导航 */
        .header {
            background: linear-gradient(135deg, #0a2463, #3e92cc);
            color: white;
            padding: 15px 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.8rem;
            font-weight: 700;
        }

        .logo i {
            color: #FFA500;
            font-size: 2.2rem;
        }

        .nav-links {
            display: flex;
            gap: 30px;
            list-style: none;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            font-size: 1.1rem;
            padding: 8px 12px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .nav-links a:hover, .nav-links a.active {
            background-color: rgba(255, 255, 255, 0.15);
        }

        .user-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .notification {
            position: relative;
            cursor: pointer;
        }

        .notification i {
            font-size: 1.3rem;
        }

        .notification-badge {
            position: absolute;
            top: -6px;
            right: -6px;
            background-color: #ff4757;
            color: white;
            font-size: 0.7rem;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            padding: 8px 12px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .user-profile:hover {
            background-color: rgba(255, 255, 255, 0.15);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #333;
        }

        /* 主内容区域 */
        .main-container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }

        /* 首页/车票查询页 */
        .search-section {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
        }

        .search-form {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }

        .search-form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .search-form-group label {
            font-weight: 500;
            color: #555;
        }

        .search-form-group input, .search-form-group select {
            padding: 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-form-group input:focus, .search-form-group select:focus {
            border-color: #3e92cc;
            outline: none;
            box-shadow: 0 0 0 3px rgba(62, 146, 204, 0.2);
        }

        .search-btn {
            padding: 14px;
            background: linear-gradient(to right, #0a2463, #3e92cc);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        .search-btn:hover {
            background: linear-gradient(to right, #091d52, #357bb8);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(10, 36, 99, 0.3);
        }

        .swap-stations {
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: #3e92cc;
            transition: all 0.3s ease;
        }

        .swap-stations:hover {
            color: #0a2463;
        }

        .search-results {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-top: 25px;
        }

        .result-item {
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 1px solid #eee;
            transition: all 0.3s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .result-item:hover {
            border-color: #3e92cc;
            background-color: #f0f7ff;
        }

        .result-time {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0a2463;
        }

        .result-duration {
            color: #666;
            text-align: center;
        }

        .result-stations {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .result-stations i {
            color: #3e92cc;
        }

        .result-train {
            font-weight: 600;
        }

        .result-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: #0a2463;
        }

        .book-btn {
            padding: 10px 20px;
            background-color: #3e92cc;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .book-btn:hover {
            background-color: #0a2463;
        }

        /* 页脚 */
        .footer {
            background: linear-gradient(135deg, #0a2463, #1c3b6a);
            color: white;
            padding: 40px 0 20px;
            margin-top: 50px;
        }

        .footer-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .footer-column h3 {
            font-size: 1.3rem;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }

        .footer-column h3::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background-color: #FFA500;
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 12px;
        }

        .footer-links a {
            color: #ccc;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .footer-links a:hover {
            color: white;
            padding-left: 5px;
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .contact-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .contact-item i {
            color: #FFA500;
            margin-top: 4px;
        }

        .copyright {
            text-align: center;
            padding-top: 30px;
            margin-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #aaa;
            font-size: 0.9rem;
        }

        /* 响应式设计 */
        @media (max-width: 1024px) {
            .search-form {
                grid-template-columns: 1fr;
            }

            .result-item {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }

        @media (max-width: 768px) {
            .nav-container {
                flex-wrap: wrap;
            }

            .nav-links {
                order: 3;
                width: 100%;
                justify-content: center;
                margin-top: 15px;
            }
        }

        /* 新增模态框样式 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: #fff;
            margin: 5% auto;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            width: 50%;
            max-width: 600px;
            position: relative;
        }

        .close-modal {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            color: #777;
        }

        .close-modal:hover {
            color: #000;
        }

        .modal-title {
            margin-bottom: 20px;
            color: #0a2463;
            font-size: 1.5rem;
        }

        .ticket-info {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f0f7ff;
            border-radius: 10px;
        }

        .ticket-info p {
            margin: 10px 0;
            display: flex;
        }

        .ticket-info strong {
            min-width: 80px;
            display: inline-block;
        }

        .booking-form .form-group {
            margin-bottom: 15px;
        }

        .booking-form label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #555;
        }

        .booking-form input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 20px;
        }

        .modal-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-cancel {
            background-color: #e0e0e0;
        }

        .btn-cancel:hover {
            background-color: #d0d0d0;
        }

        .btn-book {
            background-color: #3e92cc;
            color: white;
        }

        .btn-book:hover {
            background-color: #0a2463;
        }
    </style>
</head>
<body>
<!-- 顶部导航 -->
<header class="header">
    <div class="nav-container">
        <div class="logo">
            <i class="fas fa-train"></i>
            <span>头大列车票务系统</span>
        </div>

        <ul class="nav-links">
            <li><a href="#" class="active"><i class="fas fa-home"></i> 首页</a></li>
            <li><a href="<%= request.getContextPath() %>/ticket_booking.jsp"><i class="fas fa-ticket-alt"></i> 车票预订</a></li>
            <li><a href="<%= request.getContextPath() %>/order_management.jsp"><i class="fas fa-list"></i> 订单管理</a></li>
            <li><a href="<%= request.getContextPath() %>/profile.jsp"><i class="fas fa-user"></i> 个人中心</a></li>
            <li><a href="<%= request.getContextPath() %>/center.jsp"><i class="fas fa-question-circle"></i> 帮助中心</a></li>
        </ul>

        <div class="user-actions">
            <div class="notification">
                <i class="fas fa-bell"></i>
                <span class="notification-badge">${sessionScope.notificationCount}</span>
            </div>
            <div class="user-profile">
                <div class="user-avatar">${sessionScope.userInfo.username.substring(0, 1)}</div>
                <span>${sessionScope.userInfo.username}</span>
            </div>
        </div>
    </div>
</header>

<!-- 主内容区域 -->
<div class="main-container">
    <div class="search-section">
        <h2 class="section-title">车票查询</h2>

        <form id="searchForm" action="<%= request.getContextPath() %>/ticket/search" method="get">
            <div class="search-form">
                <div class="search-form-group">
                    <label for="from-station">出发站</label>
                    <input type="text" id="from-station" name="fromStation" placeholder="请输入出发站" value="${param.fromStation}">
                </div>

                <div class="search-form-group">
                    <label for="to-station">到达站</label>
                    <input type="text" id="to-station" name="toStation" placeholder="请输入到达站" value="${param.toStation}">
                </div>

                <div class="search-form-group">
                    <label for="depart-date">出发日期</label>
                    <input type="date" id="depart-date" name="departDate" value="${not empty param.departDate ? param.departDate : pageContext.request.getAttribute('defaultDate')}">
                </div>
            </div>

            <div class="swap-stations">
                <i class="fas fa-exchange-alt fa-lg"></i>
            </div>

            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i> 查询车票
            </button>
        </form>
    </div>

    <!-- 搜索结果展示区域 -->
    <div class="search-results">
        <h2 class="section-title">查询结果</h2>

        <c:choose>
            <c:when test="${empty trainList}">
                <div class="alert alert-info">
                    暂无符合条件的列车信息，请调整查询条件。
                </div>
            </c:when>
            <c:otherwise>
                <div>共找到 ${fn:length(trainList)} 条车次</div>
                <c:forEach var="ticket" items="${trainList}">
                    <div class="result-item">
                        <div class="result-time">
                            出发：<c:out value="${ticket.train.departureTime}"/>
                            到达：<c:out value="${ticket.train.arrivalTime}"/>
                        </div>
                        <div class="result-stations">
                            <span class="station-name">
                                <c:out value="${ticket.train.startStation.stationName}"/>
                            </span>
                            <i class="fas fa-long-arrow-alt-right"></i>
                            <span class="station-name">
                                <c:out value="${ticket.train.endStation.stationName}"/>
                            </span>
                        </div>
                        <div class="result-duration">
                            时长：<c:out value="${ticket.train.duration}"/>
                        </div>
                        <div class="result-train">
                            车次：<c:out value="${ticket.train.trainNumber}"/>
                        </div>
                        <div class="result-price">
                            票价：¥<c:out value="${ticket.basePrice * ticket.seatType.priceMultiplier}"/>
                        </div>
                        <button class="book-btn"
                                onclick="openBookingModal(
                                  '${fn:escapeXml(ticket.id)}',
                                  '${fn:escapeXml(ticket.train.trainNumber)}',
                                  '${fn:escapeXml(ticket.train.startStation.stationName)}',
                                  '${fn:escapeXml(ticket.train.endStation.stationName)}',
                                  '${fn:escapeXml(ticket.train.departureTime)}',
                                  '${fn:escapeXml(ticket.train.arrivalTime)}',
                                  '${fn:escapeXml(ticket.basePrice * ticket.seatType.priceMultiplier)}'
                                )">
                            预订
                        </button>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- 页脚 -->
<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>关于我们</h3>
            <ul class="footer-links">
                <li><a href="<%= request.getContextPath() %>/about/company">公司简介</a></li>
                <li><a href="<%= request.getContextPath() %>/about/history">发展历程</a></li>
                <li><a href="<%= request.getContextPath() %>/about/culture">企业文化</a></li>
                <li><a href="<%= request.getContextPath() %>/about/join">加入我们</a></li>
            </ul>
        </div>

        <div class="footer-column">
            <h3>客户服务</h3>
            <ul class="footer-links">
                <li><a href="<%= request.getContextPath() %>/service/ticket-guide">购票指南</a></li>
                <li><a href="<%= request.getContextPath() %>/service/refund">退票说明</a></li>
                <li><a href="<%= request.getContextPath() %>/service/change">改签规则</a></li>
                <li><a href="<%= request.getContextPath() %>/service/faq">常见问题</a></li>
            </ul>
        </div>

        <div class="footer-column">
            <h3>商务合作</h3>
            <ul class="footer-links">
                <li><a href="<%= request.getContextPath() %>/business/ad">广告投放</a></li>
                <li><a href="<%= request.getContextPath() %>/business/corp">企业服务</a></li>
                <li><a href="<%= request.getContextPath() %>/business/group">团体购票</a></li>
                <li><a href="<%= request.getContextPath() %>/business/cooperation">商务合作</a></li>
            </ul>
        </div>

        <div class="footer-column">
            <h3>联系我们</h3>
            <div class="contact-info">
                <div class="contact-item">
                    <i class="fas fa-phone-alt"></i>
                    <span>客服热线：12306</span>
                </div>
                <div class="contact-item">
                    <i class="fas fa-envelope"></i>
                    <span>邮箱：12345@stu.edu.cn</span>
                </div>
                <div class="contact-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>地址：汕头大学东海岸校区</span>
                </div>
            </div>
        </div>
    </div>

    <div class="copyright">
        © 2025 头大票务系统 版权所有 | 京ICP备12345678号
    </div>
</footer>

<!-- 预订模态框 -->
<div id="bookingModal" class="modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeBookingModal()">&times;</span>
        <h2 class="modal-title">预订车票</h2>

        <div class="ticket-info">
            <p><strong>车次：</strong><span id="modal-train-number"></span></p>
            <p><strong>出发站：</strong><span id="modal-from-station"></span></p>
            <p><strong>到达站：</strong><span id="modal-to-station"></span></p>
            <p><strong>出发时间：</strong><span id="modal-depart-time"></span></p>
            <p><strong>到达时间：</strong><span id="modal-arrive-time"></span></p>
            <p><strong>票价：</strong>¥<span id="modal-price"></span></p>
        </div>

        <div class="booking-form">
            <input type="hidden" id="modal-ticket-id">

            <div class="form-group">
                <label for="passenger-name">乘客姓名</label>
                <input type="text" id="passenger-name" placeholder="请输入乘客姓名" required>
            </div>

            <div class="form-group">
                <label for="passenger-id">证件号码</label>
                <input type="text" id="passenger-id" placeholder="请输入证件号码" required>
            </div>

            <div class="form-group">
                <label for="passenger-phone">手机号码</label>
                <input type="text" id="passenger-phone" placeholder="请输入手机号码" required>
            </div>

            <div class="form-group">
                <label for="seat-number">座位号</label>
                <input type="text" id="seat-number" placeholder="可选，留空将自动分配座位">
            </div>
        </div>

        <div class="modal-footer">
            <button type="button" class="modal-btn btn-cancel" onclick="closeBookingModal()">取消</button>
            <button type="button" class="modal-btn btn-book" onclick="submitBooking()">确认预订</button>
        </div>
    </div>
</div>

<script>
    // 交换出发站和到达站
    document.querySelector('.swap-stations').addEventListener('click', function() {
        const fromStation = document.getElementById('from-station');
        const toStation = document.getElementById('to-station');
        const temp = fromStation.value;
        fromStation.value = toStation.value;
        toStation.value = temp;
    });

    // 初始化日期为明天
    document.addEventListener('DOMContentLoaded', function() {
        const dateInput = document.getElementById('depart-date');
        if (!dateInput.value) {
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            const formattedDate = tomorrow.toISOString().split('T')[0];
            dateInput.value = formattedDate;
        }
    });

    // 打开预订模态框
    function openBookingModal(ticketId, trainNumber, fromStation, toStation, departTime, arriveTime, price) {
        // 填充车票信息到模态框
        document.getElementById('modal-ticket-id').value = ticketId;
        document.getElementById('modal-train-number').textContent = trainNumber;
        document.getElementById('modal-from-station').textContent = fromStation;
        document.getElementById('modal-to-station').textContent = toStation;
        document.getElementById('modal-depart-time').textContent = departTime;
        document.getElementById('modal-arrive-time').textContent = arriveTime;
        document.getElementById('modal-price').textContent = price;

        // 清空表单
        document.getElementById('passenger-name').value = '';
        document.getElementById('passenger-id').value = '';
        document.getElementById('passenger-phone').value = '';
        document.getElementById('seat-number').value = '';

        // 显示模态框
        document.getElementById('bookingModal').style.display = 'block';
    }

    // 关闭预订模态框
    function closeBookingModal() {
        document.getElementById('bookingModal').style.display = 'none';
    }

    // 提交预订表单
    function submitBooking() {
        // 获取表单数据
        const ticketId = document.getElementById('modal-ticket-id').value;
        const passengerName = document.getElementById('passenger-name').value;
        const passengerId = document.getElementById('passenger-id').value;
        const passengerPhone = document.getElementById('passenger-phone').value;
        const seatNumber = document.getElementById('seat-number').value;

        // 简单验证
        if (!passengerName || !passengerId || !passengerPhone) {
            alert('请填写乘客姓名、证件号码和手机号码');
            return;
        }

        // 发送预订请求
        const formData = new FormData();
        formData.append('ticketId', ticketId);
        formData.append('passengerName', passengerName);
        formData.append('passengerIdNumber', passengerId);
        formData.append('passengerPhone', passengerPhone);
        formData.append('seatNumber', seatNumber);

        fetch('<%= request.getContextPath() %>/order/create', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('预订成功！订单号：' + data.orderNumber);
                closeBookingModal();
            } else {
                alert('预订失败：' + (data.message || '请稍后再试'));
            }
        })
        .catch(error => {
            console.error('预订请求错误:', error);
            alert('预订请求失败，请检查网络连接');
        });
    }

    // 点击模态框外部关闭
    window.onclick = function(event) {
        const modal = document.getElementById('bookingModal');
        if (event.target === modal) {
            closeBookingModal();
        }
    }
</script>
</body>
</html>