package controller;

import model.User;
import model.DAO.UserDAO;
import util.DBConnection;
import util.PasswordUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(urlPatterns = { "/auth/login", "/auth/register", "/auth/logout" })
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Connection conn;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new ServletException("数据库连接失败", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String servletPath = req.getServletPath();  // "/auth/login", "/auth/register", "/auth/logout"
        switch (servletPath) {
            case "/auth/login":
            case "/auth/register":
                // 不管是 login 还是 register，都转发到根目录下的 index.jsp
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                break;
            case "/auth/logout":
                handleLogout(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String servletPath = req.getServletPath();
        switch (servletPath) {
            case "/auth/login":
                handleLogin(req, resp);
                break;
            case "/auth/register":
                handleRegister(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("userIdentifier");
        String password = req.getParameter("password");

        User user = userDAO.getUserByUsername(username);
        if (user != null
                && PasswordUtils.verifyPassword(password, user.getPasswordHash(), user.getSalt())) {
            // 登录成功，保存 session 并跳转主页面

            HttpSession session = req.getSession(true);
            session.setAttribute("userInfo", user);
            resp.sendRedirect(req.getContextPath() + "/main.jsp");
        } else {
            // 登录失败，回到 index.jsp 并显示错误
            req.setAttribute("error", "用户名或密码错误");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username        = req.getParameter("username");
        String email           = req.getParameter("email");
        String phone           = req.getParameter("phone");
        String realName        = req.getParameter("realName");
        String idNumber        = req.getParameter("idNumber");
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // 1. 密码匹配校验
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "两次输入的密码不匹配");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }

        // 2. 用户名唯一性校验
        if (userDAO.getUserByUsername(username) != null) {
            req.setAttribute("error", "用户名已存在");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }

        // 3. 生成盐和哈希
        String salt = PasswordUtils.generateSalt();
        String hash = PasswordUtils.hashPassword(password, salt);

        // 4. 封装用户并入库
        User user = new User();
        user.setUsername(username);
        user.setSalt(salt);
        user.setPasswordHash(hash);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRealName(realName);
        user.setIdNumber(idNumber);

        if (userDAO.registerUser(user)) {
            // 注册成功后重定向到登录页（GET /auth/login）
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        } else {
            req.setAttribute("error", "注册失败，请重试");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }

    @Override
    public void destroy() {
        super.destroy();
        if (conn != null) {
            try { conn.close(); }
            catch (SQLException ignore) {}
        }
    }
}
