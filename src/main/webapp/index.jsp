<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>铁路通 - 列车票务系统</title>
    <!-- 引入Font Awesome图标库 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 全局样式重置 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* 页面主体样式 */
        body {
            background: linear-gradient(135deg, #1a2a6c, #2c3e50); /* 背景渐变 */
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        /* 主容器样式 */
        .container {
            display: flex;
            max-width: 900px;
            width: 100%;
            background-color: rgba(255, 255, 255, 0.95); /* 半透明白色背景 */
            border-radius: 15px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3); /* 阴影效果 */
            overflow: hidden;
            position: relative;
        }

        /* 左侧横幅区域样式 */
        .banner {
            flex: 1;
            background: linear-gradient(135deg, #0a2463, #3e92cc); /* 渐变背景 */
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

        /* 横幅装饰性三角形背景 */
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

        /* 横幅内容容器 */
        .banner-content {
            z-index: 2; /* 确保内容在装饰层上方 */
        }

        /* 系统logo样式 */
        .logo {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .logo i {
            font-size: 2.5rem;
            margin-right: 15px;
            color: #FFA500; /* 橙色图标 */
        }

        .logo h1 {
            font-size: 2.2rem;
            font-weight: 700;
        }

        /* 横幅标题 */
        .banner h2 {
            font-size: 1.8rem;
            margin-bottom: 20px;
            font-weight: 600;
        }

        /* 横幅描述文本 */
        .banner p {
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 25px;
            max-width: 350px;
        }

        /* 特性列表容器 */
        .features {
            text-align: left;
            margin-top: 20px;
            width: 100%;
            max-width: 300px;
        }

        /* 单个特性项样式 */
        .feature {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .feature i {
            color: #FFA500; /* 橙色图标 */
            font-size: 1.2rem;
            margin-right: 10px;
            min-width: 20px;
        }

        /* 右侧表单区域样式 */
        .form-section {
            flex: 1;
            padding: 50px 40px;
            background-color: white;
            position: relative;
        }

        /* 表单容器 */
        .form-container {
            max-width: 400px;
            margin: 0 auto;
        }

        /* 标签切换区域 */
        .tabs {
            display: flex;
            margin-bottom: 30px;
            border-bottom: 2px solid #eee; /* 底部边框 */
            position: relative;
        }

        /* 单个标签样式 */
        .tab {
            padding: 12px 25px;
            cursor: pointer;
            font-size: 1.1rem;
            font-weight: 600;
            color: #777; /* 默认灰色 */
            position: relative;
            transition: all 0.3s ease;
        }

        /* 激活标签样式 */
        .tab.active {
            color: #0a2463; /* 深蓝色 */
        }

        /* 标签下方滑动指示条 */
        .tab-slider {
            position: absolute;
            bottom: -2px;
            height: 3px;
            background: #0a2463; /* 深蓝色 */
            border-radius: 3px;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.27, 1.55); /* 平滑动画 */
            z-index: 1;
        }

        /* 表单默认状态（隐藏） */
        .form {
            display: none;
            opacity: 0;
            transform: translateY(10px);
            transition: opacity 0.5s ease, transform 0.5s ease;
        }

        /* 激活表单样式 */
        .form.active {
            display: block;
            opacity: 1;
            transform: translateY(0);
        }

        /* 表单标题 */
        .form-title {
            font-size: 1.8rem;
            color: #0a2463; /* 深蓝色 */
            margin-bottom: 25px;
            font-weight: 700;
        }

        /* 输入框组 */
        .input-group {
            margin-bottom: 20px;
            position: relative;
        }

        /* 输入框图标 */
        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #777;
        }

        /* 输入框样式 */
        .input-group input {
            width: 100%;
            padding: 14px 14px 14px 45px; /* 左侧留出图标空间 */
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        /* 输入框聚焦效果 */
        .input-group input:focus {
            border-color: #0a2463; /* 深蓝色边框 */
            box-shadow: 0 0 0 2px rgba(10, 36, 99, 0.2); /* 发光效果 */
            outline: none;
        }

        /* 复选框组样式 */
        .checkbox-group {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .checkbox-group input {
            margin-right: 10px;
        }

        /* 按钮样式 */
        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(to right, #0a2463, #3e92cc); /* 渐变按钮 */
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 15px;
        }

        /* 按钮悬停效果 */
        .btn:hover {
            background: linear-gradient(to right, #091d52, #357bb8); /* 深色渐变 */
            transform: translateY(-2px); /* 上浮效果 */
            box-shadow: 0 5px 15px rgba(10, 36, 99, 0.3); /* 阴影增强 */
        }

        /* 社交登录分隔线 */
        .social-login {
            text-align: center;
            margin: 25px 0;
            position: relative;
        }

        /* 分隔线伪元素 */
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

        /* 社交图标容器 */
        .social-icons {
            display: flex;
            justify-content: center;
            gap: 15px; /* 图标间距 */
        }

        /* 单个社交图标 */
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

        /* 不同社交平台颜色 */
        .social-icon.facebook {
            background-color: #3b5998; /* Facebook蓝 */
        }

        .social-icon.google {
            background-color: #dd4b39; /* Google红 */
        }

        .social-icon.twitter {
            background-color: #1da1f2; /* Twitter蓝 */
        }

        /* 社交图标悬停效果 */
        .social-icon:hover {
            transform: translateY(-3px); /* 上浮效果 */
        }

        /* 忘记密码链接 */
        .forgot-password {
            text-align: center;
            margin-top: 10px;
        }

        .forgot-password a {
            color: #0a2463; /* 深蓝色 */
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .forgot-password a:hover {
            color: #3e92cc; /* 亮蓝色 */
            text-decoration: underline;
        }

        /* 表单底部链接 */
        .form-footer {
            text-align: center;
            margin-top: 20px;
            color: #777;
        }

        .form-footer a {
            color: #0a2463; /* 深蓝色 */
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .form-footer a:hover {
            color: #3e92cc; /* 亮蓝色 */
            text-decoration: underline;
        }

        /* 火车图标动画 */
        .train-icon {
            margin-top: 25px;
            font-size: 3rem;
            color: #FFA500; /* 橙色 */
            animation: moveTrain 8s linear infinite; /* 无限循环动画 */
        }

        /* 火车移动动画关键帧 */
        @keyframes moveTrain {
            0% { transform: translateX(-100px); } /* 起始位置 */
            50% { transform: translateX(100px); } /* 中间位置 */
            100% { transform: translateX(-100px); } /* 回到起始位置 */
        }

        /* 响应式设计：小屏幕适配 */
        @media (max-width: 768px) {
            .container {
                flex-direction: column; /* 改为垂直布局 */
            }

            .banner {
                padding: 30px 20px; /* 减小内边距 */
            }

            .form-section {
                padding: 30px 20px; /* 减小内边距 */
            }

            .logo h1 {
                font-size: 1.8rem; /* 减小字体 */
            }

            .banner h2 {
                font-size: 1.5rem; /* 减小字体 */
            }
        }
    </style>
</head>
<body>
<!-- 主容器 -->
<div class="container">
    <!-- 左侧宣传栏 -->
    <div class="banner">
        <div class="banner-content">
            <!-- 系统Logo -->
            <div class="logo">
                <i class="fas fa-train"></i>
                <h1>头大列车票务系统</h1>
            </div>
            <h2>畅行中国，便捷出行</h2>
            <p>随时随地预订火车票，享受安全、舒适、便捷的旅程</p>

            <!-- 特性列表 -->
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

            <!-- 动态火车图标 -->
            <div class="train-icon">
                <i class="fas fa-train"></i>
            </div>
        </div>
    </div>

    <!-- 右侧表单区域 -->
    <div class="form-section">
        <div class="form-container">
            <!-- 登录/注册标签页 -->
            <div class="tabs">
                <div class="tab active" data-tab="login">登录</div>
                <div class="tab" data-tab="register">注册</div>
                <div class="tab-slider"></div> <!-- 滑动指示器 -->
            </div>

            <!-- 登录表单 -->
            <form class="form active" id="login-form" action="<%= request.getContextPath() %>/auth/login" method="post">
                <h2 class="form-title">欢迎回来</h2>

                <!-- 错误提示信息 -->
                <% if (request.getAttribute("error") != null) { %>
                    <div style="color: red; margin-bottom: 20px; text-align: center;">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <!-- 用户名/手机/邮箱输入 -->
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" placeholder="用户名/手机号/邮箱" name="userIdentifier" required>
                </div>

                <!-- 密码输入 -->
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" placeholder="密码" name="password" required>
                </div>

                <!-- 记住我选项 -->
                <div class="checkbox-group">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">记住我</label>
                </div>

                <!-- 登录按钮 -->
                <button type="submit" class="btn">登录</button>

                <!-- 忘记密码链接 -->
                <div class="forgot-password">
                    <a href="<%= request.getContextPath() %>/forgotPassword">忘记密码?</a>
                </div>

                <!-- 社交登录区域 -->
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

                <!-- 切换到注册链接 -->
                <div class="form-footer">
                    <p>还没有账号? <a href="#" class="switch-to-register">立即注册</a></p>
                </div>
            </form>

            <!-- 注册表单 -->
            <form class="form" id="register-form" action="<%= request.getContextPath() %>/auth/register" method="post">
                <h2 class="form-title">创建新账户</h2>

                <!-- 错误提示信息 -->
                <% if (request.getAttribute("error") != null) { %>
                    <div style="color: red; margin-bottom: 20px; text-align: center;">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <!-- 用户名输入 -->
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" placeholder="用户名" name="username" required>
                </div>

                <!-- 邮箱输入 -->
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" placeholder="电子邮箱" name="email" required>
                </div>

                <!-- 手机号输入 -->
                <div class="input-group">
                    <i class="fas fa-phone"></i>
                    <input type="tel" placeholder="手机号码" name="phone" required>
                </div>

                <!-- 密码输入 -->
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" placeholder="设置密码" name="password" required>
                </div>

                <!-- 确认密码输入 -->
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" placeholder="确认密码" name="confirmPassword" required>
                </div>

                <!-- 用户协议复选框 -->
                <div class="checkbox-group">
                    <input type="checkbox" id="terms" name="terms" required>
                    <label for="terms">我已阅读并同意<a href="<%= request.getContextPath() %>/terms">《用户协议》</a>和<a href="<%= request.getContextPath() %>/privacy">《隐私政策》</a></label>
                </div>

                <!-- 注册按钮 -->
                <button type="submit" class="btn">注册账号</button>

                <!-- 切换到登录链接 -->
                <div class="form-footer">
                    <p>已有账号? <a href="#" class="switch-to-login">立即登录</a></p>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // 页面加载完成后执行
    document.addEventListener('DOMContentLoaded', function() {
        // 获取DOM元素
        const loginTab = document.querySelector('.tab[data-tab="login"]');
        const registerTab = document.querySelector('.tab[data-tab="register"]');
        const tabSlider = document.querySelector('.tab-slider');
        const loginForm = document.getElementById('login-form');
        const registerForm = document.getElementById('register-form');
        const switchToRegister = document.querySelector('.switch-to-register');
        const switchToLogin = document.querySelector('.switch-to-login');

        // 初始化标签滑块位置
        updateTabSlider(loginTab);

        // 切换表单函数
        function switchForm(tab) {
            // 更新标签激活状态
            loginTab.classList.remove('active');
            registerTab.classList.remove('active');
            tab.classList.add('active');

            // 更新滑块位置
            updateTabSlider(tab);

            // 切换表单显示
            if (tab === loginTab) {
                loginForm.classList.add('active');
                registerForm.classList.remove('active');
            } else {
                registerForm.classList.add('active');
                loginForm.classList.remove('active');
            }
        }

        // 更新滑块位置函数
        function updateTabSlider(tab) {
            const tabRect = tab.getBoundingClientRect();
            const containerRect = tab.parentElement.getBoundingClientRect();

            tabSlider.style.width = `${tabRect.width}px`; // 设置滑块宽度匹配标签
            tabSlider.style.left = `${tabRect.left - containerRect.left}px`; // 设置滑块水平位置
        }

        // 标签点击事件监听
        loginTab.addEventListener('click', () => switchForm(loginTab));
        registerTab.addEventListener('click', () => switchForm(registerTab));

        // 注册/登录链接点击事件
        switchToRegister.addEventListener('click', (e) => {
            e.preventDefault(); // 阻止默认跳转
            switchForm(registerTab);
        });

        switchToLogin.addEventListener('click', (e) => {
            e.preventDefault(); // 阻止默认跳转
            switchForm(loginTab);
        });
    });
</script>
</body>
</html>