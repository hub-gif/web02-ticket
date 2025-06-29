<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>头大 - 订单管理</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
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
        display: flex;
        max-width: 1400px;
        margin: 30px auto;
        padding: 0 20px;
        gap: 25px;
    }



    /* 主内容 */
    .content {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 25px;
    }

    .breadcrumb {
        color: #666;
        font-size: 0.9rem;
        margin-bottom: 15px;
    }

    .breadcrumb a {
        color: #3e92cc;
        text-decoration: none;
    }

    .breadcrumb a:hover {
        text-decoration: underline;
    }

    .section-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: #0a2463;
        margin-bottom: 20px;
    }

    /* 订单筛选 */
    .order-filter {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 25px;
    }

    .filter-tabs {
        display: flex;
        margin-bottom: 25px;
        border-bottom: 1px solid #eee;
    }

    .filter-tab {
        padding: 12px 20px;
        cursor: pointer;
        font-weight: 500;
        transition: all 0.3s ease;
        border-bottom: 2px solid transparent;
    }

    .filter-tab:hover, .filter-tab.active {
        color: #3e92cc;
        border-bottom-color: #3e92cc;
    }

    .search-form {
        display: flex;
        gap: 15px;
    }

    .search-input {
        flex: 1;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        outline: none;
        transition: all 0.3s ease;
    }

    .search-input:focus {
        border-color: #3e92cc;
    }

    .search-button {
        padding: 12px 25px;
        background: linear-gradient(to right, #0a2463, #3e92cc);
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .search-button:hover {
        background: linear-gradient(to right, #091d52, #357bb8);
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(10, 36, 99, 0.3);
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


    /* 订单列表 */
    .order-list {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 25px;
    }

    .order-item {
        border: 1px solid #eee;
        border-radius: 10px;
        margin-bottom: 20px;
        overflow: hidden;
        transition: all 0.3s ease;
    }

    .order-item:hover {
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        transform: translateY(-2px);
    }

    .order-header {
        background-color: #f9fbfd;
        padding: 15px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #eee;
    }

    .order-number {
        font-weight: 600;
        color: #0a2463;
    }

    .order-date {
        color: #666;
        font-size: 0.9rem;
    }

    .order-status {
        padding: 5px 12px;
        border-radius: 5px;
        font-weight: 500;
        font-size: 0.9rem;
    }

    .status-pending {
        background-color: #fff3cd;
        color: #856404;
    }

    .status-paid {
        background-color: #d4edda;
        color: #155724;
    }

    .status-canceled {
        background-color: #f8d7da;
        color: #721c24;
    }

    .status-completed {
        background-color: #cce5ff;
        color: #004085;
    }

    .order-content {
        padding: 20px;
        display: flex;
        gap: 20px;
    }

    .order-train-info {
        flex: 2;
        display: flex;
        gap: 20px;
        align-items: center;
    }

    .train-time {
        font-size: 1.5rem;
        font-weight: 700;
        color: #0a2463;
    }

    .train-stations {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }

    .train-station {
        font-weight: 600;
    }

    .train-line {
        position: relative;
        height: 2px;
        background-color: #ddd;
        margin: 10px 0;
        width: 100%;
    }

    .train-line::before {
        content: "";
        position: absolute;
        left: 0;
        top: -4px;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: #3e92cc;
    }

    .train-line::after {
        content: "";
        position: absolute;
        right: 0;
        top: -4px;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: #3e92cc;
    }

    .train-duration {
        font-size: 0.9rem;
        color: #666;
    }

    .train-number {
        font-weight: 600;
        color: #0a2463;
    }

    .order-ticket-info {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
        gap: 10px;
    }

    .ticket-type {
        font-weight: 600;
    }

    .ticket-price {
        font-size: 1.2rem;
        font-weight: 700;
        color: #ff6b6b;
    }

    .order-actions {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: flex-end;
        gap: 10px;
    }

    .action-button {
        padding: 8px 15px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.3s ease;
        text-align: center;
        width: 120px;
    }

    .btn-view {
        border: 1px solid #3e92cc;
        color: #3e92cc;
    }

    .btn-view:hover {
        background-color: #3e92cc;
        color: white;
    }

    .btn-pay {
        background: linear-gradient(to right, #0a2463, #3e92cc);
        color: white;
    }

    .btn-pay:hover {
        background: linear-gradient(to right, #091d52, #357bb8);
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(10, 36, 99, 0.3);
    }

    .btn-cancel {
        border: 1px solid #ff6b6b;
        color: #ff6b6b;
    }

    .btn-cancel:hover {
        background-color: #ff6b6b;
        color: white;
    }

    /* 分页样式 */
    .pagination-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 30px;
        padding: 15px 0;
        border-top: 1px solid #eee;
    }

    .pagination-info {
        color: #666;
        font-size: 0.9rem;
    }

    .pagination {
        display: flex;
        gap: 5px;
    }

    .page-item {
        list-style: none;
    }

    .page-link {
        display: inline-block;
        width: 36px;
        height: 36px;
        line-height: 36px;
        text-align: center;
        border-radius: 50%;
        text-decoration: none;
        color: #333;
        transition: all 0.3s ease;
        border: 1px solid #eee;
    }

    .page-link:hover, .page-link.active {
        background-color: #3e92cc;
        color: white;
        border-color: #3e92cc;
    }

    .page-link i {
        font-size: 0.9rem;
    }

    /* 空结果提示 */
    .empty-result {
        text-align: center;
        padding: 60px 0;
        color: #666;
    }

    .empty-result i {
        font-size: 3rem;
        margin-bottom: 20px;
        color: #ccc;
    }

    .reset-button {
        display: inline-block;
        margin-top: 20px;
        padding: 10px 20px;
        border: 1px solid #3e92cc;
        color: #3e92cc;
        border-radius: 6px;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .reset-button:hover {
        background-color: #3e92cc;
        color: white;
    }

    /* 加载状态 */
    .loading-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(255, 255, 255, 0.8);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .spinner {
        width: 50px;
        height: 50px;
        font-size: 2rem;
        color: #3e92cc;
    }

    /* 响应式设计 */
    @media (max-width: 1024px) {
        .main-container {
            flex-direction: column;
        }

        .sidebar {
            width: 100%;
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

        .order-content {
            flex-direction: column;
        }

        .order-actions {
            align-items: flex-start;
        }
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
      <li><a href="<%= request.getContextPath() %>/main.jsp"><i class="fas fa-home"></i> 首页</a></li>
      <li><a href="<%= request.getContextPath() %>/ticket_booking.jsp"><i class="fas fa-ticket-alt"></i> 车票预订</a></li>
      <li><a href="#" class="active"><i class="fas fa-list"></i> 订单管理</a></li>
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

  <!-- 主内容 -->
  <main class="content">
    <div class="breadcrumb">
      <a href="<%= request.getContextPath() %>/main.jsp">首页</a> &gt;
      <span>订单管理</span>
    </div>

    <h2 class="section-title">我的订单</h2>

    <!-- 订单筛选 -->
    <div class="order-filter">
      <div class="filter-tabs">
        <div class="filter-tab ${empty param.status || param.status == 'all' ? 'active' : ''}" data-status="all">全部订单</div>
        <div class="filter-tab ${param.status == '未支付' ? 'active' : ''}" data-status="未支付">待支付</div>
        <div class="filter-tab ${param.status == '已支付' ? 'active' : ''}" data-status="已支付">已支付</div>
        <div class="filter-tab ${param.status == '已完成' ? 'active' : ''}" data-status="已完成">已完成</div>
        <div class="filter-tab ${param.status == '已取消' ? 'active' : ''}" data-status="已取消">已取消</div>
      </div>

      <form class="search-form">
        <input type="text" class="search-input" placeholder="请输入订单号、车次或日期"
               name="keyword" value="${param.keyword}">
        <input type="hidden" name="status" value="${param.status}">
        <button type="submit" class="search-button">
          <i class="fas fa-search"></i> 搜索
        </button>
      </form>
    </div>

    <!-- 订单列表 -->
    <div class="order-list">
      <c:choose>
        <c:when test="${empty orderList}">
          <div class="empty-result">
            <i class="fas fa-search"></i>
            <p>没有找到符合条件的订单</p>
            <a href="?status=all&keyword=" class="reset-button">重置筛选</a>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach items="${orderList}" var="order">
            <div class="order-item">
              <div class="order-header">
                <div class="order-info">
                  <span class="order-number">订单号：${order.orderNumber}</span>
                  <span class="order-date">${order.orderTime}</span>
                </div>
                <c:choose>
                  <c:when test="${order.status == '未支付'}">
                    <span class="order-status status-pending">待支付</span>
                  </c:when>
                  <c:when test="${order.status == '已支付'}">
                    <span class="order-status status-paid">已支付</span>
                  </c:when>
                  <c:when test="${order.status == '已完成'}">
                    <span class="order-status status-completed">已完成</span>
                  </c:when>
                  <c:when test="${order.status == '已取消'}">
                    <span class="order-status status-canceled">已取消</span>
                  </c:when>
                </c:choose>
              </div>

              <div class="order-content">
                <div class="order-train-info">
                  <div class="train-time">
                    <div>${order.ticket.train.departureTime}</div>
                    <div>${order.ticket.train.arrivalTime}</div>
                  </div>
                  <div class="train-stations">
                    <div class="train-station">${order.ticket.train.startStation.stationName}</div>
                    <div class="train-line"></div>
                    <div class="train-station">${order.ticket.train.endStation.stationName}</div>
                  </div>
                  <div class="train-number">
                    ${order.ticket.train.trainNumber}
                  </div>
                </div>

                <div class="order-ticket-info">
                  <div class="ticket-type">${order.ticket.seatType.typeName} - ${order.seatNumber}</div>
                  <div class="ticket-passenger">${order.passengerName}</div>
                  <div class="ticket-price">¥${order.totalPrice}</div>
                </div>

                <div class="order-actions">
                  <a href="<%= request.getContextPath() %>/order/detail?orderNumber=${order.orderNumber}" class="action-button btn-view">
                    查看详情
                  </a>
                  <c:if test="${order.status == '未支付'}">
                    <a href="<%= request.getContextPath() %>/order/payment?orderNumber=${order.orderNumber}" class="action-button btn-pay">
                      立即支付
                    </a>
                    <a href="javascript:void(0)" class="action-button btn-cancel" onclick="cancelOrder('${order.orderNumber}')">
                      取消订单
                    </a>
                  </c:if>
                </div>
              </div>
            </div>
          </c:forEach>

          <!-- 分页 -->
          <div class="pagination-container">
            <div class="pagination-info">
              共 ${totalPages} 页，${fn:length(orderList)} 条记录
            </div>
            <div class="pagination">
              <c:if test="${currentPage > 1}">
                <li class="page-item">
                  <a href="?status=${param.status}&keyword=${param.keyword}&page=${currentPage - 1}" class="page-link">
                    <i class="fas fa-angle-left"></i>
                  </a>
                </li>
              </c:if>

              <!-- 只显示当前页附近的页码 -->
              <c:forEach begin="1" end="${totalPages}" var="pageNum">
                <c:if test="${pageNum >= currentPage - 2 && pageNum <= currentPage + 2}">
                  <li class="page-item">
                    <a href="?status=${param.status}&keyword=${param.keyword}&page=${pageNum}"
                       class="page-link ${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
                  </li>
                </c:if>
              </c:forEach>

              <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                  <a href="?status=${param.status}&keyword=${param.keyword}&page=${currentPage + 1}" class="page-link">
                    <i class="fas fa-angle-right"></i>
                  </a>
                </li>
              </c:if>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
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


<script>
  // 筛选标签切换
  document.querySelectorAll('.filter-tab').forEach(tab => {
    tab.addEventListener('click', () => {
      // 移除所有选中状态
      document.querySelectorAll('.filter-tab').forEach(t => {
        t.classList.remove('active');
      });

      // 添加当前选中状态
      tab.classList.add('active');

      const status = tab.getAttribute('data-status');
      const keyword = document.querySelector('input[name="keyword"]').value;

      // 构建查询参数并跳转
      const queryParams = new URLSearchParams({
        status: status,
        keyword: keyword,
        page: 1 // 重置到第一页
      });

      // 显示加载状态
      const loadingOverlay = document.createElement('div');
      loadingOverlay.className = 'loading-overlay';
      loadingOverlay.innerHTML = '<div class="spinner"><i class="fas fa-circle-notch fa-spin"></i></div>';
      document.body.appendChild(loadingOverlay);

      // 跳转页面
      window.location.href = `?${queryParams.toString()}`;
    });
  });

  // 搜索功能
  document.getElementById('searchForm').addEventListener('submit', function(e) {
    e.preventDefault(); // 阻止表单默认提交

    const keyword = document.querySelector('input[name="keyword"]').value;
    const status = document.querySelector('.filter-tab.active').getAttribute('data-status');

    // 构建查询参数
    const queryParams = new URLSearchParams({
      status: status,
      keyword: keyword,
      page: 1 // 搜索时重置到第一页
    });

    // 显示加载状态
    const loadingOverlay = document.createElement('div');
    loadingOverlay.className = 'loading-overlay';
    loadingOverlay.innerHTML = '<div class="spinner"><i class="fas fa-circle-notch fa-spin"></i></div>';
    document.body.appendChild(loadingOverlay);

    // 更新URL并加载数据
    window.location.href = `?${queryParams.toString()}`;
  });

  // 取消订单确认
  function cancelOrder(orderNumber) {
    if (confirm("确定要取消该订单吗？取消后将无法恢复。")) {
      // 实际项目中应该通过AJAX请求取消订单
      window.location.href = "<%= request.getContextPath() %>/order/cancel?orderNumber=" + orderNumber;
    }
  }
</script>
</body>
</html>