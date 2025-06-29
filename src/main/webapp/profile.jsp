<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>头大 - 个人中心</title>
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

    /* 用户信息卡片 */
    .user-info-card {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 30px;
        display: flex;
        gap: 30px;
    }

    .user-avatar-section {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 15px;
    }

    .user-big-avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: linear-gradient(135deg, #ff9a9e, #fad0c4);
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        color: #333;
        font-size: 2.5rem;
    }

    .change-avatar {
        color: #3e92cc;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .change-avatar:hover {
        color: #0a2463;
    }

    .user-details {
        flex: 1;
    }

    .user-name {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .user-id {
        color: #666;
        margin-bottom: 20px;
    }

    .user-stats {
        display: flex;
        gap: 30px;
        margin-bottom: 20px;
    }

    .stat-item {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .stat-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #0a2463;
    }

    .stat-label {
        color: #666;
        font-size: 0.9rem;
    }

    .user-contact {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
    }

    .contact-item {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .contact-icon {
        width: 35px;
        height: 35px;
        background-color: #f0f7ff;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #0a2463;
    }

    .contact-value {
        color: #666;
    }

    /* 个人信息表单 */
    .personal-info {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 30px;
    }

    .section-title {
        font-size: 1.5rem;
        color: #0a2463;
        margin-bottom: 25px;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
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

    .form-actions {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        margin-top: 30px;
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

    .save-btn {
        padding: 12px 30px;
        background: linear-gradient(to right, #0a2463, #3e92cc);
        color: white;
        border: none;
        border-radius: 8px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .save-btn:hover {
        background: linear-gradient(to right, #091d52, #357bb8);
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(10, 36, 99, 0.3);
    }

    /* 支付方式 */
    #payment {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 30px;
    }

    .payment-methods {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .payment-method {
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 20px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .payment-method:hover, .payment-method.selected {
        border-color: #3e92cc;
        background-color: #f0f7ff;
    }

    .payment-icon {
        font-size: 1.8rem;
    }

    .payment-details {
        flex: 1;
    }

    .payment-name {
        font-weight: 600;
    }

    .payment-desc {
        color: #666;
        font-size: 0.9rem;
    }

    .add-payment {
        border: 2px dashed #ddd;
        border-radius: 10px;
        padding: 20px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }

    .add-payment:hover {
        border-color: #3e92cc;
        color: #3e92cc;
    }

    /* 最近行程 */
    .recent-trips {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 30px;
    }

    .trip-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 0;
        border-bottom: 1px solid #eee;
    }

    .trip-item:last-child {
        border-bottom: none;
    }

    .trip-route {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .trip-station {
        display: flex;
        flex-direction: column;
    }

    .station-name {
        font-weight: 600;
        font-size: 1.1rem;
    }

    .station-date {
        color: #666;
        font-size: 0.9rem;
    }

    .trip-icon {
        color: #3e92cc;
        font-size: 1.2rem;
    }

    .trip-train {
        font-weight: 500;
    }

    .trip-actions {
        display: flex;
        gap: 10px;
    }

    .trip-action {
        color: #3e92cc;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .trip-action:hover {
        color: #0a2463;
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

        .user-info-card {
            flex-direction: column;
            align-items: center;
        }

        .user-contact {
            grid-template-columns: 1fr;
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

        .form-grid {
            grid-template-columns: 1fr;
        }

        .trip-item {
            flex-direction: column;
            gap: 15px;
            align-items: flex-start;
        }
    }

    /* 模态框样式 */
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      justify-content: center;
      align-items: center;
    }

    .modal-content {
      background-color: white;
      border-radius: 15px;
      box-shadow: 0 5px 25px rgba(0, 0, 0, 0.2);
      width: 400px;
      padding: 30px;
      position: relative;
    }

    .close {
      position: absolute;
      top: 15px;
      right: 20px;
      font-size: 24px;
      cursor: pointer;
      color: #666;
    }

    .modal h2 {
      margin-bottom: 20px;
      color: #0a2463;
    }

    .modal-form {
      display: flex;
      flex-direction: column;
      gap: 15px;
    }

    .modal-form input[type="file"] {
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 8px;
    }

    .modal-form button {
      padding: 12px;
      background: linear-gradient(to right, #0a2463, #3e92cc);
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
      transition: all 0.3s ease;
    }

    .modal-form button:hover {
      background: linear-gradient(to right, #091d52, #357bb8);
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
      <li><a href="<%= request.getContextPath() %>/order_management.jsp"><i class="fas fa-list"></i> 订单管理</a></li>
      <li><a href="#" class="active"><i class="fas fa-user"></i> 个人中心</a></li>
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
  <!-- 侧边栏 -->
  <aside class="sidebar">
    <h3 class="sidebar-title">个人中心</h3>
    <ul class="sidebar-menu">
      <li><a href="#" class="active"><i class="fas fa-user"></i> 个人信息</a></li>
      <li><a href="#"><i class="fas fa-list"></i> 订单管理</a></li>
      <li><a href="#"><i class="fas fa-credit-card"></i> 支付方式</a></li>
      <li><a href="#"><i class="fas fa-history"></i> 行程历史</a></li>
      <li><a href="#"><i class="fas fa-star"></i> 常用车站</a></li>
      <li><a href="#"><i class="fas fa-cog"></i> 账户设置</a></li>
      <li><a href="#"><i class="fas fa-sign-out-alt"></i> 退出登录</a></li>
    </ul>
  </aside>

  <!-- 主内容 -->
  <main class="content">
    <div class="breadcrumb">
      <a href="#">首页</a> &gt; <a href="#">个人中心</a>
    </div>

    <!-- 用户信息卡片 -->
    <div class="user-info-card">
      <div class="user-avatar-section">
        <div class="user-big-avatar">张</div>
        <div class="change-avatar" onclick="openAvatarUpload()">
          <i class="fas fa-camera"></i> 更改头像
        </div>
      </div>

      <div class="user-details">
        <div class="user-name">张三</div>
        <div class="user-id">会员ID: TD2023123456</div>

        <div class="user-stats">
          <div class="stat-item">
            <div class="stat-value">42</div>
            <div class="stat-label">已完成订单</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">2</div>
            <div class="stat-label">待支付</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">1860</div>
            <div class="stat-label">积分</div>
          </div>
        </div>

        <div class="user-contact">
          <div class="contact-item">
            <div class="contact-icon">
              <i class="fas fa-phone"></i>
            </div>
            <div class="contact-value">138****5678</div>
          </div>
          <div class="contact-item">
            <div class="contact-icon">
              <i class="fas fa-envelope"></i>
            </div>
            <div class="contact-value">zhangsan@example.com</div>
          </div>
          <div class="contact-item">
            <div class="contact-icon">
              <i class="fas fa-id-card"></i>
            </div>
            <div class="contact-value">3301**********1234</div>
          </div>
          <div class="contact-item">
            <div class="contact-icon">
              <i class="fas fa-train"></i>
            </div>
            <div class="contact-value">铂金会员</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 个人信息表单 -->
    <div class="personal-info">
      <h2 class="section-title">个人信息</h2>

      <form id="profileForm" class="form-grid">
        <div class="form-group">
          <label for="real-name">真实姓名</label>
          <input type="text" id="real-name" name="realName" value="张三" placeholder="请输入真实姓名">
        </div>

        <div class="form-group">
          <label for="id-number">身份证号</label>
          <input type="text" id="id-number" name="idNumber" value="330123199001011234" placeholder="请输入身份证号">
        </div>

        <div class="form-group">
          <label for="phone">手机号码</label>
          <input type="tel" id="phone" name="phone" value="13800135678" placeholder="请输入手机号码">
        </div>

        <div class="form-group">
          <label for="email">电子邮箱</label>
          <input type="email" id="email" name="email" value="zhangsan@example.com" placeholder="请输入电子邮箱">
        </div>

        <div class="form-group">
          <label for="gender">性别</label>
          <select id="gender" name="gender">
            <option value="male" selected>男</option>
            <option value="female">女</option>
            <option value="other">其他</option>
          </select>
        </div>

        <div class="form-group">
          <label for="birthday">出生日期</label>
          <input type="date" id="birthday" name="birthday" value="1990-01-01">
        </div>

        <div class="form-group">
          <label for="address">常用地址</label>
          <input type="text" id="address" name="address" value="浙江省杭州市西湖区文一西路969号" placeholder="请输入常用地址">
        </div>

        <div class="form-group">
          <label for="preference">乘车偏好</label>
          <select id="preference" name="preference">
            <option value="window">靠窗</option>
            <option value="aisle" selected>靠过道</option>
            <option value="none">无偏好</option>
          </select>
        </div>

        <div class="form-actions">
          <button type="button" class="cancel-btn" onclick="resetForm()">取消</button>
          <button type="button" class="save-btn" onclick="saveProfile()">保存修改</button>
        </div>
      </form>
    </div>

    <!-- 支付方式 -->
    <div id="payment">
      <h2 class="section-title">支付方式</h2>

      <div class="payment-methods">
        <div class="payment-method selected">
          <div class="payment-icon">
            <i class="fab fa-alipay"></i>
          </div>
          <div class="payment-details">
            <div class="payment-name">支付宝</div>
            <div class="payment-desc">账户尾号 5678</div>
          </div>
        </div>

        <div class="payment-method">
          <div class="payment-icon">
            <i class="fab fa-weixin"></i>
          </div>
          <div class="payment-details">
            <div class="payment-name">微信支付</div>
            <div class="payment-desc">账户尾号 1234</div>
          </div>
        </div>

        <div class="payment-method">
          <div class="payment-icon">
            <i class="fab fa-cc-visa"></i>
          </div>
          <div class="payment-details">
            <div class="payment-name">招商银行信用卡</div>
            <div class="payment-desc">账户尾号 9876</div>
          </div>
        </div>

        <div class="add-payment" onclick="addPaymentMethod()">
          <i class="fas fa-plus"></i>
          <span>添加支付方式</span>
        </div>
      </div>
    </div>

    <!-- 最近行程 -->
    <div class="recent-trips">
      <h2 class="section-title">最近行程</h2>

      <div class="trip-item">
        <div class="trip-route">
          <div class="trip-station">
            <div class="station-name">杭州东站</div>
            <div class="station-date">2023-12-15 08:30</div>
          </div>
          <div class="trip-icon">
            <i class="fas fa-long-arrow-alt-right"></i>
          </div>
          <div class="trip-station">
            <div class="station-name">上海虹桥站</div>
            <div class="station-date">2023-12-15 09:58</div>
          </div>
        </div>

        <div class="trip-train">G7368 高铁</div>

        <div class="trip-actions">
          <div class="trip-action">
            <i class="fas fa-eye"></i> 详情
          </div>
          <div class="trip-action">
            <i class="fas fa-star"></i> 收藏
          </div>
        </div>
      </div>

      <div class="trip-item">
        <div class="trip-route">
          <div class="trip-station">
            <div class="station-name">南京南站</div>
            <div class="station-date">2023-12-10 14:15</div>
          </div>
          <div class="trip-icon">
            <i class="fas fa-long-arrow-alt-right"></i>
          </div>
          <div class="trip-station">
            <div class="station-name">杭州东站</div>
            <div class="station-date">2023-12-10 15:45</div>
          </div>
        </div>

        <div class="trip-train">G7635 高铁</div>

        <div class="trip-actions">
          <div class="trip-action">
            <i class="fas fa-eye"></i> 详情
          </div>
          <div class="trip-action">
            <i class="fas fa-star"></i> 收藏
          </div>
        </div>
      </div>

      <div class="trip-item">
        <div class="trip-route">
          <div class="trip-station">
            <div class="station-name">北京南站</div>
            <div class="station-date">2023-12-05 07:45</div>
          </div>
          <div class="trip-icon">
            <i class="fas fa-long-arrow-alt-right"></i>
          </div>
          <div class="trip-station">
            <div class="station-name">南京南站</div>
            <div class="station-date">2023-12-05 12:10</div>
          </div>
        </div>

        <div class="trip-train">G101 高铁</div>

        <div class="trip-actions">
          <div class="trip-action">
            <i class="fas fa-eye"></i> 详情
          </div>
          <div class="trip-action">
            <i class="fas fa-star"></i> 收藏
          </div>
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
      <h3>帮助中心</h3>
      <ul class="footer-links">
        <li><a href="#">购票指南</a></li>
        <li><a href="#">退票改签</a></li>
        <li><a href="#">常见问题</a></li>
        <li><a href="#">联系客服</a></li>
      </ul>
    </div>

    <div class="footer-column">
      <h3>法律信息</h3>
      <ul class="footer-links">
        <li><a href="#">服务条款</a></li>
        <li><a href="#">隐私政策</a></li>
        <li><a href="#">退票政策</a></li>
        <li><a href="#">法律声明</a></li>
      </ul>
    </div>

    <div class="footer-column">
      <h3>联系我们</h3>
      <div class="contact-info">
        <div class="contact-item">
          <i class="fas fa-phone"></i>
          <span>客服热线：400-123-4567</span>
        </div>
        <div class="contact-item">
          <i class="fas fa-envelope"></i>
          <span>邮箱：service@touda-train.com</span>
        </div>
        <div class="contact-item">
          <i class="fas fa-map-marker-alt"></i>
          <span>地址：浙江省杭州市西湖区</span>
        </div>
      </div>
    </div>
  </div>

  <div class="copyright">
    © 2025 头大列车票务系统 版权所有 | 浙ICP备12345678号
  </div>
</footer>

<!-- 头像上传模态框 -->
<div id="avatarModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeAvatarUpload()">&times;</span>
    <h2>更改头像</h2>
    <form class="modal-form">
      <input type="file" id="avatarFile" name="avatar" accept="image/*">
      <button type="button" onclick="uploadAvatar()">上传头像</button>
    </form>
  </div>
</div>

<script>
  // 表单重置函数
  function resetForm() {
    document.getElementById('profileForm').reset();
    alert('表单已重置为原始值');
  }

  // 保存个人信息
  function saveProfile() {
    alert('个人信息已保存成功！');
    // 这里在实际应用中会有表单提交逻辑
  }

  // 打开头像上传模态框
  function openAvatarUpload() {
    document.getElementById('avatarModal').style.display = 'flex';
  }

  // 关闭头像上传模态框
  function closeAvatarUpload() {
    document.getElementById('avatarModal').style.display = 'none';
  }

  // 上传头像
  function uploadAvatar() {
    const fileInput = document.getElementById('avatarFile');
    if (fileInput.files.length === 0) {
      alert('请选择图片');
      return;
    }

    // 模拟上传过程
    alert('头像上传中...');
    setTimeout(() => {
      alert('头像上传成功！');
      closeAvatarUpload();
    }, 1500);
  }

  // 选择支付方式
  function selectPayment(methodId) {
    const paymentMethods = document.querySelectorAll('.payment-method');
    paymentMethods.forEach(method => {
      method.classList.remove('selected');
    });
    event.currentTarget.classList.add('selected');
    alert('默认支付方式已更新');
  }

  // 添加支付方式
  function addPaymentMethod() {
    alert('正在跳转到添加支付方式页面...');
  }

  // 查看行程详情
  function viewTripDetails(orderId) {
    alert('正在查看行程详情...');
  }

  // 收藏行程
  function addTripToFavorite(orderId) {
    alert('行程已添加到收藏！');
  }

  // 关闭模态框（点击模态框外部）
  window.onclick = function(event) {
    const modal = document.getElementById('avatarModal');
    if (event.target === modal) {
      closeAvatarUpload();
    }
  }
</script>
</body>
</html>