<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

    /* 侧边栏 */
    .sidebar {
        flex: 0 0 280px;
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 25px;
        height: fit-content;
    }

    .sidebar-title {
        font-size: 1.4rem;
        margin-bottom: 20px;
        color: #0a2463;
        padding-bottom: 10px;
        border-bottom: 2px solid #f0f4f8;
    }

    .sidebar-menu {
        list-style: none;
    }

    .sidebar-menu li {
        margin-bottom: 12px;
    }

    .sidebar-menu a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 15px;
        border-radius: 8px;
        color: #555;
        text-decoration: none;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .sidebar-menu a:hover, .sidebar-menu a.active {
        background-color: #f0f7ff;
        color: #0a2463;
    }

    .sidebar-menu i {
        width: 24px;
        text-align: center;
        font-size: 1.1rem;
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

    /* 订单筛选 */
    .order-filter {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 25px;
    }

    .filter-tabs {
        display: flex;
        gap: 20px;
        margin-bottom: 20px;
    }

    .filter-tab {
        padding: 10px 15px;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .filter-tab:hover, .filter-tab.active {
        background-color: #f0f7ff;
        color: #0a2463;
        font-weight: 500;
    }

    .search-box {
        display: flex;
        gap: 15px;
    }

    .search-input {
        flex: 1;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 1rem;
        transition: all 0.3s ease;
    }

    .search-input:focus {
        border-color: #3e92cc;
        outline: none;
        box-shadow: 0 0 0 3px rgba(62, 146, 204, 0.2);
    }

    .search-button {
        padding: 12px 25px;
        background: linear-gradient(to right, #0a2463, #3e92cc);
        color: white;
        border: none;
        border-radius: 8px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .search-button:hover {
        background: linear-gradient(to right, #091d52, #357bb8);
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(10, 36, 99, 0.3);
    }

    /* 订单列表 */
    .order-list {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 25px;
    }

    .order-card {
        border-radius: 12px;
        overflow: hidden;
        margin-bottom: 20px;
        border: 1px solid #eee;
        transition: all 0.3s ease;
    }

    .order-card:hover {
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
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

    .order-id {
        font-weight: 500;
        color: #0a2463;
    }

    .order-status {
        padding: 5px 12px;
        border-radius: 20px;
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

    .status-completed {
        background-color: #cce5ff;
        color: #004085;
    }

    .status-canceled {
        background-color: #f8d7da;
        color: #721c24;
    }

    .order-body {
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .order-route {
        display: flex;
        align-items: center;
        gap: 30px;
    }

    .departure, .arrival {
        display: flex;
        flex-direction: column;
    }

    .station-name {
        font-size: 1.2rem;
        font-weight: 600;
        margin-bottom: 5px;
    }

    .station-time {
        color: #666;
        font-size: 0.95rem;
    }

    .route-icon {
        color: #3e92cc;
        font-size: 1.5rem;
    }

    .order-train {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 5px;
    }

    .train-number {
        font-size: 1.2rem;
        font-weight: 600;
        color: #0a2463;
    }

    .train-type {
        color: #666;
        font-size: 0.9rem;
    }

    .order-details {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
    }

    .order-price {
        font-size: 1.2rem;
        font-weight: 700;
        color: #ff6b6b;
        margin-bottom: 10px;
    }

    .order-actions {
        display: flex;
        gap: 10px;
    }

    .action-btn {
        padding: 8px 15px;
        border-radius: 6px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
    }

    .view-btn {
        background-color: #f0f4f8;
        color: #555;
    }

    .view-btn:hover {
        background-color: #e6ebf2;
    }

    .pay-btn {
        background: linear-gradient(to right, #0a2463, #3e92cc);
        color: white;
    }

    .pay-btn:hover {
        background: linear-gradient(to right, #091d52, #357bb8);
    }

    .cancel-btn {
        background-color: #f8d7da;
        color: #721c24;
    }

    .cancel-btn:hover {
        background-color: #f5c6cb;
    }

    .refund-btn {
        background-color: #fff3cd;
        color: #856404;
    }

    .refund-btn:hover {
        background-color: #ffeeba;
    }

    /* 分页 */
    .pagination {
        display: flex;
        justify-content: center;
        gap: 5px;
        margin-top: 30px;
    }

    .page-item {
        width: 35px;
        height: 35px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .page-item:hover, .page-item.active {
        background-color: #f0f7ff;
        color: #0a2463;
        font-weight: 500;
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
        .main-container {
            flex-direction: column;
        }

        .sidebar {
            width: 100%;
        }

        .order-body {
            flex-direction: column;
            gap: 20px;
            align-items: flex-start;
        }

        .order-details {
            align-items: flex-start;
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

        .filter-tabs {
            flex-wrap: wrap;
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
      <a href="<%= request.getContextPath() %>/main.jsp">首页</a> &gt; <a href="#">订单管理</a>
    </div>

    <!-- 订单筛选 -->
    <div class="order-filter">
      <div class="filter-tabs">
        <div class="filter-tab ${param.status == null || param.status == 'all' ? 'active' : ''}" data-status="all">全部订单</div>
        <div class="filter-tab ${param.status == 'pending' ? 'active' : ''}" data-status="pending">待支付</div>
        <div class="filter-tab ${param.status == 'paid' ? 'active' : ''}" data-status="paid">已支付</div>
        <div class="filter-tab ${param.status == 'completed' ? 'active' : ''}" data-status="completed">已完成</div>
        <div class="filter-tab ${param.status == 'canceled' ? 'active' : ''}" data-status="canceled">已取消</div>
      </div>

      <form id="searchForm" action="<%= request.getContextPath() %>/orders" method="get">
        <input type="hidden" id="status" name="status" value="${param.status}">
        <div class="search-box">
          <input type="text" class="search-input" name="keyword" placeholder="请输入订单号、车次或车站名称" value="${param.keyword}">
          <button type="submit" class="search-button">
            <i class="fas fa-search"></i> 搜索
          </button>
        </div>
      </form>
    </div>

    <!-- 订单列表 -->
    <div class="order-list">
      <h2 class="section-title">我的订单</h2>

      <c:if test="${empty orderList}">
        <div class="alert alert-info">
          暂无订单信息。
        </div>
      </c:if>

      <c:forEach items="${orderList}" var="order">
        <div class="order-card">
          <div class="order-header">
            <div class="order-id">订单号：${order.orderId}</div>
            <div class="order-status ${order.statusClass}">${order.statusName}</div>
          </div>
          <div class="order-body">
            <div class="order-route">
              <div class="departure">
                <div class="station-name">${order.fromStation}</div>
                <div class="station-time">${order.departDate} ${order.departTime}</div>
              </div>
              <div class="route-icon">
                <i class="fas fa-arrow-right"></i>
              </div>
              <div class="arrival">
                <div class="station-name">${order.toStation}</div>
                <div class="station-time">${order.arriveDate} ${order.arriveTime}</div>
              </div>
            </div>

            <div class="order-train">
              <div class="train-number">${order.trainNumber}</div>
              <div class="train-type">${order.trainType}</div>
            </div>

            <div class="order-details">
              <div class="order-price">¥${order.totalPrice}</div>
              <div class="order-actions">
                <c:choose>
                  <c:when test="${order.status == 'pending'}">
                    <a href="<%= request.getContextPath() %>/payment.jsp?orderId=${order.orderId}" class="action-btn pay-btn">立即支付</a>
                    <a href="#" class="action-btn cancel-btn" onclick="cancelOrder('${order.orderId}')">取消订单</a>
                  </c:when>
                  <c:when test="${order.status == 'paid'}">
                    <a href="<%= request.getContextPath() %>/order_detail.jsp?orderId=${order.orderId}" class="action-btn view-btn">查看详情</a>
                    <a href="#" class="action-btn refund-btn" onclick="refundTicket('${order.orderId}')">申请退票</a>
                  </c:when>
                  <c:otherwise>
                    <a href="<%= request.getContextPath() %>/order_detail.jsp?orderId=${order.orderId}" class="action-btn view-btn">查看详情</a>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>

<div class="pagination">
  <!-- 上一页 -->
  <c:if test="${pageInfo.currentPage > 1}">
    <a href="${pageContext.request.contextPath}/orders?status=${param.status}&keyword=${param.keyword}&page=${pageInfo.currentPage - 1}" class="page-item">
      <i class="fas fa-angle-left"></i>
    </a>
  </c:if>

  <!-- 数字页码：迭代真正的 List<Integer> -->
  <c:forEach items="${pages}" var="pageNum">
    <a href="${pageContext.request.contextPath}/orders?status=${param.status}&keyword=${param.keyword}&page=${pageNum}"
       class="page-item ${pageNum == pageInfo.currentPage ? 'active' : ''}">
      ${pageNum}
    </a>
  </c:forEach>

  <!-- 下一页 -->
  <c:if test="${pageInfo.currentPage < pageInfo.totalPages}">
    <a href="${pageContext.request.contextPath}/orders?status=${param.status}&keyword=${param.keyword}&page=${pageInfo.currentPage + 1}" class="page-item">
      <i class="fas fa-angle-right"></i>
    </a>
  </c:if>
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
  document.addEventListener('DOMContentLoaded', function() {
      const filterTabs = document.querySelectorAll('.filter-tab');
      filterTabs.forEach(tab => {
          tab.addEventListener('click', function() {
              // 移除所有选中状态
              filterTabs.forEach(t => t.classList.remove('active'));
              // 添加当前选中状态
              this.classList.add('active');

              // 更新表单中的状态参数并提交
              document.getElementById('status').value = this.getAttribute('data-status');
              document.getElementById('searchForm').submit();
          });
      });

      // 订单操作
      window.cancelOrder = function(orderId) {
          if (confirm('确定要取消该订单吗？')) {
              const xhr = new XMLHttpRequest();
              xhr.open('POST', '<%= request.getContextPath() %>/order/cancel', true);
              xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
              xhr.onload = function() {
                  if (xhr.status === 200) {
                      alert('订单已取消');
                      location.reload();
                  } else {
                      alert('取消订单失败，请稍后再试');
                  }
              };
              xhr.send('orderId=' + encodeURIComponent(orderId));
          }
      };

      window.refundTicket = function(orderId) {
          if (confirm('确定要申请退票吗？退票将收取一定手续费')) {
              const xhr = new XMLHttpRequest();
              xhr.open('POST', '<%= request.getContextPath() %>/ticket/refund', true);
              xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
              xhr.onload = function() {
                  if (xhr.status === 200) {
                      alert('退票申请已提交，将在1-3个工作日内处理');
                      location.reload();
                  } else {
                      alert('退票申请失败，请稍后再试');
                  }
              };
              xhr.send('orderId=' + encodeURIComponent(orderId));
          }
      };
  });
</script>
</body>
</html>