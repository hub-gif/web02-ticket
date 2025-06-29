package controller;

import model.User;
import model.DAO.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profile/*")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        if (action == null || action.equals("/")) {
            showProfile(req, resp);
        } else if (action.equals("/edit")) {
            showEditProfile(req, resp);
        } else if (action.equals("/changePassword")) {
            showChangePassword(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        switch (action) {
            case "/update":
                updateProfile(req, resp);
                break;
            case "/changePassword":
                changePassword(req, resp);
                break;
            case "/uploadAvatar":
                // 处理头像上传的逻辑
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("userInfo");

        if (user != null) {
            user = userDAO.getUserById(user.getId());
            req.setAttribute("userInfo", user);
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    private void showEditProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("userInfo");

        if (user != null) {
            user = userDAO.getUserById(user.getId());
            req.setAttribute("userInfo", user);
            req.getRequestDispatcher("/profile_edit.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    private void showChangePassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/change_password.jsp").forward(req, resp);
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("userInfo");

        if (user != null) {
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String realName = req.getParameter("realName");
            String idNumber = req.getParameter("idNumber");
            String gender = req.getParameter("gender");
            String birthday = req.getParameter("birthday");
            String address = req.getParameter("address");
            String preference = req.getParameter("preference");

            user.setEmail(email);
            user.setPhone(phone);
            user.setRealName(realName);
            user.setIdNumber(idNumber);
            user.setGender(gender);
            user.setBirthday(birthday);
            user.setAddress(address);
            user.setPreference(preference);

            if (userDAO.updateUserProfile(user)) {
                req.setAttribute("message", "个人信息更新成功");
                // 更新session中的用户信息
                session.setAttribute("user", userDAO.getUserById(user.getId()));
            } else {
                req.setAttribute("error", "个人信息更新失败");
            }

            req.setAttribute("userInfo", user);
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    private void changePassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            String oldPassword = req.getParameter("oldPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "两次输入的新密码不一致");
                req.getRequestDispatcher("/change_password.jsp").forward(req, resp);
                return;
            }

            if (userDAO.changePassword(user.getId(), oldPassword, newPassword)) {
                req.setAttribute("message", "密码修改成功，请使用新密码登录");
                // 密码修改成功后，使当前会话失效，要求用户重新登录
                session.invalidate();
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "密码修改失败，原密码可能不正确");
                req.getRequestDispatcher("/change_password.jsp").forward(req, resp);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }
}