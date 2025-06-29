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
                && password.equals(user.getPasswordHash())) {
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
            setError(req, resp, "两次输入的密码不匹配"); return;
        }
        // 2. 用户名唯一性校验
        if (userDAO.getUserByUsername(username) != null) {
            setError(req, resp, "用户名已存在"); return;
        }

        // 3. 封装用户——此处不再生成 salt/hash，直接把明文密码放到 passwordHash 字段里
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(password); // 明文
        user.setEmail(email);
        user.setPhone(phone);
        user.setRealName(realName);
        user.setIdNumber(idNumber);

        // 4. 入库
        if (userDAO.registerUser(user)) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        } else {
            setError(req, resp, "注册失败，请重试");
        }
    }

    // 辅助方法
    private void setError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
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
