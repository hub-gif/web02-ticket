<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>头大 - 车票预订</title>
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

    /* 车票详情卡片 */
    .ticket-detail {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        overflow: hidden;
    }

    .ticket-header {
        background: linear-gradient(135deg, #0a2463, #3e92cc);
        color: white;
        padding: 25px 30px;
    }

    .ticket-header h2 {
        font-size: 1.8rem;
        margin-bottom: 5px;
    }

    .ticket-header p {
        opacity: 0.9;
    }

    .ticket-body {
        padding: 30px;
    }

    .train-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 30px;
        border-bottom: 1px solid #eee;
    }

    .train-number-type {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .train-number {
        font-size: 1.8rem;
        font-weight: 700;
        color: #0a2463;
    }

    .train-type {
        background-color: #FFA500;
        color: white;
        padding: 6px 15px;
        border-radius: 20px;
        font-size: 0.95rem;
        font-weight: 500;
    }

    .route-time {
        display: flex;
        justify-content: space-between;
        width: 100%;
        max-width: 700px;
    }

    .station {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .station-name {
        font-size: 1.5rem;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .station-time {
        font-size: 1.3rem;
        font-weight: 600;
        margin-bottom: 5px;
    }

    .station-date {
        color: #666;
        font-size: 0.95rem;
    }

    .duration {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }

    .duration-time {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 5px;
    }

    .duration-line {
        width: 200px;
        height: 4px;
        background-color: #ddd;
        border-radius: 2px;
        position: relative;
        margin: 15px 0;
    }

    .duration-line::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 70%;
        height: 100%;
        background-color: #3e92cc;
        border-radius: 2px;
    }

    .duration-line i {
        position: absolute;
        top: -8px;
        left: 68%;
        color: #3e92cc;
        font-size: 1.2rem;
    }

    /* 乘客信息表单 */
    .passenger-form {
        margin-bottom: 30px;
        padding-bottom: 30px;
        border-bottom: 1px solid #eee;
    }

    .form-title {
        font-size: 1.5rem;
        color: #0a2463;
        margin-bottom: 25px;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .form-group label {
        font-weight: 500;
        color: #555;
    }

    .form-group input, .form-group select {
        padding: 14px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 1rem;
        transition: all 0.3s ease;
    }

    .form-group input:focus, .form-group select:focus {
        border-color: #3e92cc;
        outline: none;
        box-shadow: 0 0 0 3px rgba(62, 146, 204, 0.2);
    }

    .add-passenger {
        margin-top: 20px;
        color: #3e92cc;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }

    .add-passenger:hover {
        color: #0a2463;
    }

    /* 座位选择 */
    .seat-selection {
        margin-bottom: 30px;
        padding-bottom: 30px;
        border-bottom: 1px solid #eee;
    }

    .seat-options {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
    }

    .seat-option {
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 15px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .seat-option:hover {
        border-color: #3e92cc;
    }

    .seat-option.selected {
        border-color: #3e92cc;
        background-color: #f0f7ff;
    }

    .seat-type {
        font-weight: 600;
        font-size: 1.1rem;
    }

    .seat-price {
        color: #ff6b6b;
        font-weight: 700;
        font-size: 1.2rem;
    }

    .seat-available {
        color: #666;
        font-size: 0.9rem;
    }

    /* 票价信息 */
    .fare-info {
        margin-bottom: 30px;
    }

    .fare-details {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .fare-item {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
    }

    .fare-total {
        display: flex;
        justify-content: space-between;
        padding: 15px 0;
        border-top: 1px solid #eee;
        font-weight: 700;
        font-size: 1.2rem;
    }

    .total-amount {
        color: #ff6b6b;
    }

    /* 操作按钮 */
    .ticket-actions {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
    }

    .cancel-btn {
        padding: 12px 30px;
        background-color: #f0f4f8;
        color: #555;
        border: none;
        border-radius: 8px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .cancel-btn:hover {
        background-color: #e6ebf2;
    }

    .confirm-btn {
        padding: 12px 30px;
        background: linear-gradient(to right, #0a2463, #3e92cc);
        color: white;
        border: none;
        border-radius: 8px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .confirm-btn:hover {
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

    /* 响应式设计 */
    @media (max-width: 1024px) {
        .main-container {
            flex-direction: column;
        }

        .sidebar {
            width: 100%;
        }

        .train-info {
            flex-direction: column;
            gap: 30px;
        }

        .duration-line {
            width: 150px;
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
            <li><a href="#" class="active"><i class="fas fa-ticket-alt"></i> 车票预订</a></li>
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

  <!-- 主内容 -->
  <main class="content">
    <div class="breadcrumb">
      <a href="main.jsp">首页</a> &gt; <a href="#">车票预订</a> &gt; G101次列车
    </div>

    <!-- 车票详情卡片 -->
    <div class="ticket-detail">
      <div class="ticket-header">
        <h2>G101次列车 - 北京南至上海虹桥</h2>
        <p>2024年06月15日 周五 | 二等座</p>
      </div>

      <div class="ticket-body">
        <!-- 列车信息 -->
        <div class="train-info">
          <div class="train-number-type">
            <span class="train-number">G101</span>
            <span class="train-type">高铁</span>
          </div>

          <div class="route-time">
            <div class="station">
              <div class="station-name">北京南</div>
              <div class="station-time">08:00</div>
              <div class="station-date">2024-06-15</div>
            </div>

            <div class="duration">
              <div class="duration-time">4小时48分钟</div>
              <div class="duration-line">
                <i class="fas fa-train"></i>
              </div>
              <div class="duration-stops">途经6站</div>
            </div>

            <div class="station">
              <div class="station-name">上海虹桥</div>
              <div class="station-time">12:48</div>
              <div class="station-date">2024-06-15</div>
            </div>
          </div>
        </div>

        <!-- 乘客信息表单 -->
        <div class="passenger-form">
          <h3 class="form-title">乘客信息</h3>
          <div class="form-grid">
            <div class="form-group">
              <label for="passenger-name">乘客姓名</label>
              <input type="text" id="passenger-name" placeholder="请输入乘客姓名" value="张三">
            </div>

            <div class="form-group">
              <label for="passenger-id">证件类型</label>
              <select id="passenger-id-type">
                <option>居民身份证</option>
                <option>港澳居民来往内地通行证</option>
                <option>台湾居民来往大陆通行证</option>
                <option>护照</option>
              </select>
            </div>

            <div class="form-group">
              <label for="passenger-id">证件号码</label>
              <input type="text" id="passenger-id" placeholder="请输入证件号码" value="110101********1234">
            </div>

            <div class="form-group">
              <label for="passenger-phone">手机号码</label>
              <input type="text" id="passenger-phone" placeholder="请输入手机号码" value="13800138000">
            </div>

            <div class="form-group">
              <label for="passenger-type">乘客类型</label>
              <select id="passenger-type">
                <option>成人</option>
                <option>学生</option>
                <option>儿童</option>
                <option>残疾军人</option>
              </select>
            </div>
          </div>

          <div class="add-passenger">
            <i class="fas fa-plus-circle"></i> 添加乘客
          </div>
        </div>

        <!-- 座位选择 -->
        <div class="seat-selection">
          <h3 class="form-title">座位选择</h3>
          <div class="seat-options">
            <div class="seat-option selected">
              <div class="seat-type">二等座</div>
              <div class="seat-price">¥553.00</div>
              <div class="seat-available">余票充足 (128张)</div>
            </div>

            <div class="seat-option">
              <div class="seat-type">一等座</div>
              <div class="seat-price">¥933.00</div>
              <div class="seat-available">余票充足 (86张)</div>
            </div>

            <div class="seat-option">
              <div class="seat-type">商务座</div>
              <div class="seat-price">¥1748.00</div>
              <div class="seat-available">少量余票 (12张)</div>
            </div>
          </div>
        </div>

        <!-- 票价信息 -->
        <div class="fare-info">
          <h3 class="form-title">票价信息</h3>
          <div class="fare-details">
            <div class="fare-item">
              <span>二等座票价</span>
              <span>¥553.00</span>
            </div>
            <div class="fare-item">
              <span>保险费</span>
              <span>¥20.00</span>
            </div>
            <div class="fare-item">
              <span>服务费</span>
              <span>¥0.00</span>
            </div>
            <div class="fare-total">
              <span>总价</span>
              <span class="total-amount">¥573.00</span>
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="ticket-actions">
          <button class="cancel-btn">取消</button>
          <button class="confirm-btn">确认订单</button>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- 页脚 -->
<footer class="footer">
  <div class="footer-container">
    <div class="footer-column">
      <h3>关于我们</h3>
      <ul class="footer-links">
        <li><a href="#">公司简介</a></li>
        <li><a href="#">发展历程</a></li>
        <li><a href="#">企业文化</a></li>
        <li><a href="#">加入我们</a></li>
      </ul>
    </div>

    <div class="footer-column">
      <h3>客户服务</h3>
      <ul class="footer-links">
        <li><a href="#">购票指南</a></li>
        <li><a href="#">退票说明</a></li>
        <li><a href="#">改签规则</a></li>
        <li><a href="#">常见问题</a></li>
      </ul>
    </div>

    <div class="footer-column">
      <h3>商务合作</h3>
      <ul class="footer-links">
        <li><a href="#">广告投放</a></li>
        <li><a href="#">企业服务</a></li>
        <li><a href="#">团体购票</a></li>
        <li><a href="#">商务合作</a></li>
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
  // 座位选择交互
  document.addEventListener('DOMContentLoaded', function() {
      const seatOptions = document.querySelectorAll('.seat-option');
      seatOptions.forEach(option => {
          option.addEventListener('click', function() {
              // 移除所有选中状态
              seatOptions.forEach(opt => opt.classList.remove('selected'));
              // 添加当前选中状态
              this.classList.add('selected');
          });
      });

      // 添加乘客按钮
      const addPassengerBtn = document.querySelector('.add-passenger');
      addPassengerBtn.addEventListener('click', function() {
          alert('添加乘客功能将在后续版本中实现');
      });

      // 确认订单按钮
      const confirmBtn = document.querySelector('.confirm-btn');
      confirmBtn.addEventListener('click', function() {
          alert('订单已提交，请前往支付页面完成支付');
          window.location.href = 'payment.html';
      });
  });
</script>
</body>
</html>