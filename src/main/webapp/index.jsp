<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>铁路通 - 列车票务系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #1a2a6c, #2c3e50);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            display: flex;
            max-width: 900px;
            width: 100%;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            position: relative;
        }

        .banner {
            flex: 1;
            background: linear-gradient(135deg, #0a2463, #3e92cc);
            color: white;
            padding: 50px 30px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .banner::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="none"><path d="M0,0 L100,0 L100,100 Z" fill="rgba(255,255,255,0.1)"/></svg>');
            background-size: 100% 100%;
        }

        .banner-content {
            z-index: 2;
        }

        .logo {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .logo i {
            font-size: 2.5rem;
            margin-right: 15px;
            color: #FFA500;
        }

        .logo h1 {
            font-size: 2.2rem;
            font-weight: 700;
        }

        .banner h2 {
            font-size: 1.8rem;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .banner p {
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 25px;
            max-width: 350px;
        }

        .features {
            text-align: left;
            margin-top: 20px;
            width: 100%;
            max-width: 300px;
        }

        .feature {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .feature i {
            color: #FFA500;
            font-size: 1.2rem;
            margin-right: 10px;
            min-width: 20px;
        }

        .form-section {
            flex: 1;
            padding: 50px 40px;
            background-color: white;
            position: relative;
        }

        .form-container {
            max-width: 400px;
            margin: 0 auto;
        }

        .tabs {
            display: flex;
            margin-bottom: 30px;
            border-bottom: 2px solid #eee;
            position: relative;
        }

        .tab {
            padding: 12px 25px;
            cursor: pointer;
            font-size: 1.1rem;
            font-weight: 600;
            color: #777;
            position: relative;
            transition: all 0.3s ease;
        }

        .tab.active {
            color: #0a2463;
        }

        .tab-slider {
            position: absolute;
            bottom: -2px;
            height: 3px;
            background: #0a2463;
            border-radius: 3px;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.27, 1.55);
            z-index: 1;
        }

        .form {
            display: none;
            opacity: 0;
            transform: translateY(10px);
            transition: opacity 0.5s ease, transform 0.5s ease;
        }

        .form.active {
            display: block;
            opacity: 1;
            transform: translateY(0);
        }

        .form-title {
            font-size: 1.8rem;
            color: #0a2463;
            margin-bottom: 25px;
            font-weight: 700;
        }

        .input-group {
            margin-bottom: 20px;
            position: relative;
        }

        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #777;
        }

        .input-group input {
            width: 100%;
            padding: 14px 14px 14px 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .input-group input:focus {
            border-color: #0a2463;
            box-shadow: 0 0 0 2px rgba(10, 36, 99, 0.2);
            outline: none;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .checkbox-group input {
            margin-right: 10px;
        }

        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(to right, #0a2463, #3e92cc);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 15px;
        }

        .btn:hover {
            background: linear-gradient(to right, #091d52, #357bb8);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(10, 36, 99, 0.3);
        }

        .social-login {
            text-align: center;
            margin: 25px 0;
            position: relative;
        }

        .social-login::before,
        .social-login::after {
            content: "";
            position: absolute;
            top: 50%;
            width: 30%;
            height: 1px;
            background: #ddd;
        }

        .social-login::before {
            left: 0;
        }

        .social-login::after {
            right: 0;
        }

        .social-login p {
            color: #777;
            margin-bottom: 15px;
        }

        .social-icons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .social-icon {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .social-icon.facebook {
            background-color: #3b5998;
        }

        .social-icon.google {
            background-color: #dd4b39;
        }

        .social-icon.twitter {
            background-color: #1da1f2;
        }

        .social-icon:hover {
            transform: translateY(-3px);
        }

        .forgot-password {
            text-align: center;
            margin-top: 10px;
        }

        .forgot-password a {
            color: #0a2463;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .forgot-password a:hover {
            color: #3e92cc;
            text-decoration: underline;
        }

        .form-footer {
            text-align: center;
            margin-top: 20px;
            color: #777;
        }

        .form-footer a {
            color: #0a2463;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .form-footer a:hover {
            color: #3e92cc;
            text-decoration: underline;
        }

        .train-icon {
            margin-top: 25px;
            font-size: 3rem;
            color: #FFA500;
            animation: moveTrain 8s linear infinite;
        }

        @keyframes moveTrain {
            0% { transform: translateX(-100px); }
            50% { transform: translateX(100px); }
            100% { transform: translateX(-100px); }
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .banner {
                padding: 30px 20px;
            }

            .form-section {
                padding: 30px 20px;
            }

            .logo h1 {
                font-size: 1.8rem;
            }

            .banner h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="banner">
        <div class="banner-content">
            <div class="logo">
                <i class="fas fa-train"></i>
                <h1>头大列车票务系统</h1>
            </div>
            <h2>畅行中国，便捷出行</h2>
            <p>随时随地预订火车票，享受安全、舒适、便捷的旅程</p>

            <div class="features">
                <div class="feature">
                    <i class="fas fa-check-circle"></i>
                    <span>实时查询列车时刻与余票</span>
                </div>
                <div class="feature">
                    <i class="fas fa-check-circle"></i>
                    <span>在线选座，优先选择心仪位置</span>
                </div>
                <div class="feature">
                    <i class="fas fa-check-circle"></i>
                    <span>电子车票，扫码进站更便捷</span>
                </div>
                <div class="feature">
                    <i class="fas fa-check-circle"></i>
                    <span>会员积分，享受更多优惠</span>
                </div>
            </div>

            <div class="train-icon">
                <i class="fas fa-train"></i>
            </div>
        </div>
    </div>

    <div class="form-section">
        <div class="form-container">
            <div class="tabs">
                <div class="tab active" data-tab="login">登录</div>
                <div class="tab" data-tab="register">注册</div>
                <div class="tab-slider"></div>
            </div>

            <!-- 登录表单 -->
            <form class="form active" id="login-form" action="<%= request.getContextPath() %>/auth/login" method="post">
                <h2 class="form-title">欢迎回来</h2>

                <!-- 错误提示 -->
                <% if (request.getAttribute("error") != null) { %>
                    <div style="color: red; margin-bottom: 20px; text-align: center;">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" placeholder="用户名/手机号/邮箱" name="userIdentifier" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" placeholder="密码" name="password" required>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">记住我</label>
                </div>

                <button type="submit" class="btn">登录</button>

                <div class="forgot-password">
                    <a href="<%= request.getContextPath() %>/forgotPassword">忘记密码?</a>
                </div>

                <div class="social-login">
                    <p>或使用以下方式登录</p>
                    <div class="social-icons">
                        <div class="social-icon facebook">
                            <i class="fab fa-facebook-f"></i>
                        </div>
                        <div class="social-icon google">
                            <i class="fab fa-google"></i>
                        </div>
                        <div class="social-icon twitter">
                            <i class="fab fa-twitter"></i>
                        </div>
                    </div>
                </div>

                <div class="form-footer">
                    <p>还没有账号? <a href="#" class="switch-to-register">立即注册</a></p>
                </div>
            </form>

            <!-- 注册表单 -->
            <form class="form" id="register-form" action="<%= request.getContextPath() %>/auth/register" method="post">
                <h2 class="form-title">创建新账户</h2>

                <!-- 错误提示 -->
                <% if (request.getAttribute("error") != null) { %>
                    <div style="color: red; margin-bottom: 20px; text-align: center;">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" placeholder="用户名" name="username" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" placeholder="电子邮箱" name="email" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-phone"></i>
                    <input type="tel" placeholder="手机号码" name="phone" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" placeholder="设置密码" name="password" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" placeholder="确认密码" name="confirmPassword" required>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="terms" name="terms" required>
                    <label for="terms">我已阅读并同意<a href="<%= request.getContextPath() %>/terms">《用户协议》</a>和<a href="<%= request.getContextPath() %>/privacy">《隐私政策》</a></label>
                </div>

                <button type="submit" class="btn">注册账号</button>

                <div class="form-footer">
                    <p>已有账号? <a href="#" class="switch-to-login">立即登录</a></p>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 获取DOM元素
        const loginTab = document.querySelector('.tab[data-tab="login"]');
        const registerTab = document.querySelector('.tab[data-tab="register"]');
        const tabSlider = document.querySelector('.tab-slider');
        const loginForm = document.getElementById('login-form');
        const registerForm = document.getElementById('register-form');
        const switchToRegister = document.querySelector('.switch-to-register');
        const switchToLogin = document.querySelector('.switch-to-login');

        // 初始标签位置
        updateTabSlider(loginTab);

        // 标签切换功能
        function switchForm(tab) {
            // 更新标签状态
            loginTab.classList.remove('active');
            registerTab.classList.remove('active');
            tab.classList.add('active');

            // 更新标签滑块位置
            updateTabSlider(tab);

            // 更新表单状态
            if (tab === loginTab) {
                loginForm.classList.add('active');
                registerForm.classList.remove('active');
            } else {
                registerForm.classList.add('active');
                loginForm.classList.remove('active');
            }
        }

        function updateTabSlider(tab) {
            const tabRect = tab.getBoundingClientRect();
            const containerRect = tab.parentElement.getBoundingClientRect();

            tabSlider.style.width = `${tabRect.width}px`;
            tabSlider.style.left = `${tabRect.left - containerRect.left}px`;
        }

        // 标签点击事件
        loginTab.addEventListener('click', () => switchForm(loginTab));
        registerTab.addEventListener('click', () => switchForm(registerTab));

        // 链接点击事件
        switchToRegister.addEventListener('click', (e) => {
            e.preventDefault();
            switchForm(registerTab);
        });

        switchToLogin.addEventListener('click', (e) => {
            e.preventDefault();
            switchForm(loginTab);
        });
    });
</script>
</body>
</html>