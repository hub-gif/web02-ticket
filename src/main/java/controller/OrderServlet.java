// com.toudatrain.controller.OrderServlet.java
package controller;

// 导入模型类
import model.Order;
import model.Ticket;
import model.User;
// 导入数据访问对象
import model.DAO.OrderDAO;
import model.DAO.TicketDAO;
// 导入Servlet相关类
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 订单管理Servlet
 * 处理订单相关的所有请求，包括创建订单、查看订单、支付订单、取消订单等操作
 * 映射路径：/order/*
 */
@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {
    // 订单数据访问对象
    private OrderDAO orderDAO = new OrderDAO();
    // 车票数据访问对象
    private TicketDAO ticketDAO = new TicketDAO();

    /**
     * 处理GET请求
     * 根据不同的路径执行不同的操作
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取请求路径信息
        String action = req.getPathInfo();

        // 根据路径分发到不同的处理方法
        if (action == null || action.equals("/")) {
            // 显示订单列表
            showOrderList(req, resp);
        } else if (action.equals("/create")) {
            // 显示创建订单页面
            showCreateOrder(req, resp);
        } else if (action.equals("/detail")) {
            // 显示订单详情
            showOrderDetail(req, resp);
        } else if (action.equals("/pay")) {
            // 处理支付流程
            processPayment(req, resp);
        } else if (action.equals("/cancel")) {
            // 取消订单
            cancelOrder(req, resp);
        } else {
            // 未找到的资源返回404错误
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 处理POST请求
     * 主要处理表单提交操作
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取请求路径信息
        String action = req.getPathInfo();

        // 根据路径分发到不同的处理方法
        if (action.equals("/create")) {
            // 创建新订单
            createOrder(req, resp);
        } else if (action.equals("/pay")) {
            // 确认支付
            confirmPayment(req, resp);
        } else {
            // 未找到的资源返回404错误
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 显示订单列表
     * 获取当前用户的所有订单并跳转到订单管理页面
     */
    /**
     * 显示订单列表
     * 获取当前用户的所有订单并跳转到订单管理页面
     */
    private void showOrderList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 从会话中获取用户信息
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("userInfo");

        // 如果用户未登录，重定向到登录页面
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // 获取筛选和搜索参数
        String status = req.getParameter("status");
        String keyword = req.getParameter("keyword");

        // 获取分页参数
        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                // 处理非法页码参数
                page = 1;
            }
        }

        // 设置每页显示数量
        int pageSize = 10;

        // 获取筛选后的订单列表
        List<Order> orders = orderDAO.getOrdersByUserId(user.getId(), status, keyword, page, pageSize);

        // 获取订单总数
        int totalCount = orderDAO.getTotalOrdersCount(user.getId(), status, keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // 设置请求属性
        req.setAttribute("orderList", orders);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("status", status);
        req.setAttribute("keyword", keyword);

        // 转发到订单管理页面
        req.getRequestDispatcher("/order_management.jsp").forward(req, resp);
    }

    /**
     * 显示创建订单页面
     * 根据车票ID显示订单创建表单
     */
    private void showCreateOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取表单参数
        String ticketIdStr = req.getParameter("ticketId");
        String passengerName = req.getParameter("passengerName");
        String passengerIdNumber = req.getParameter("passengerIdNumber");
        String passengerPhone = req.getParameter("passengerPhone");
        String seatNumber = req.getParameter("seatNumber");

        // 如果没有车票ID参数，重定向到车票页面
        if (ticketIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/ticket");
            return;
        }

        try {
            // 转换车票ID为整数
            int ticketId = Integer.parseInt(ticketIdStr);
            // 获取车票信息
            Ticket ticket = ticketDAO.getTicketById(ticketId);

            // 如果车票不存在，返回404错误
            if (ticket == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 设置页面属性
            req.setAttribute("ticket", ticket);
            req.setAttribute("passengerName", passengerName);
            req.setAttribute("passengerIdNumber", passengerIdNumber);
            req.setAttribute("passengerPhone", passengerPhone);
            req.setAttribute("seatNumber", seatNumber);

            // 转发到订单创建页面
            req.getRequestDispatcher("/order_create.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            // 参数格式错误返回400错误
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    /**
     * 创建新订单
     * 处理订单创建表单提交
     */
    private void createOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 从会话中获取用户信息
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // 如果用户未登录，重定向到登录页面
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // 获取表单参数
        String ticketIdStr = req.getParameter("ticketId");
        String passengerName = req.getParameter("passengerName");
        String passengerIdNumber = req.getParameter("passengerIdNumber");
        String passengerPhone = req.getParameter("passengerPhone");
        String seatNumber = req.getParameter("seatNumber");

        // 如果没有车票ID参数，重定向到车票页面
        if (ticketIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/ticket");
            return;
        }

        try {
            // 转换车票ID为整数
            int ticketId = Integer.parseInt(ticketIdStr);
            // 获取车票信息
            Ticket ticket = ticketDAO.getTicketById(ticketId);

            // 如果车票不存在，返回404错误
            if (ticket == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 创建订单并获取订单号
            String orderNumber = orderDAO.createOrder(user, ticket, passengerName,
                    passengerIdNumber, passengerPhone, seatNumber);

            // 如果订单创建成功，跳转到订单详情页面
            if (orderNumber != null) {
                resp.sendRedirect(req.getContextPath() + "/order/detail?orderNumber=" + orderNumber);
            } else {
                // 订单创建失败，释放车票库存
                ticketDAO.cancelTicket(ticketId, 1);
                // 设置错误信息并转发回车票详情页面
                req.setAttribute("error", "订单创建失败，请重试");
                req.getRequestDispatcher("/ticket_detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            // 参数格式错误返回400错误
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    /**
     * 显示订单详情
     * 根据订单号显示订单详细信息
     */
    private void showOrderDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取订单号参数
        String orderNumber = req.getParameter("orderNumber");

        // 如果没有订单号，重定向到订单列表
        if (orderNumber == null) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        // 根据订单号获取订单信息
        Order order = orderDAO.getOrderByNumber(orderNumber);

        // 如果订单不存在，返回404错误
        if (order == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 设置订单属性并转发到订单详情页面
        req.setAttribute("order", order);
        req.getRequestDispatcher("/order_detail.jsp").forward(req, resp);
    }

    /**
     * 处理支付流程
     * 显示支付页面
     */
    private void processPayment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取订单号参数
        String orderNumber = req.getParameter("orderNumber");

        // 如果没有订单号，重定向到订单列表
        if (orderNumber == null) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        // 根据订单号获取订单信息
        Order order = orderDAO.getOrderByNumber(orderNumber);

        // 验证订单状态（必须是"未支付"状态）
        if (order == null || !"未支付".equals(order.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        // 设置订单属性并转发到支付页面
        req.setAttribute("order", order);
        req.getRequestDispatcher("/payment.jsp").forward(req, resp);
    }

    /**
     * 确认支付
     * 处理支付表单提交
     */
    private void confirmPayment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取表单参数
        String orderNumber = req.getParameter("orderNumber");
        String paymentMethod = req.getParameter("paymentMethod");

        // 验证参数是否存在
        if (orderNumber == null || paymentMethod == null) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        // 执行支付操作
        if (orderDAO.payOrder(orderNumber, paymentMethod)) {
            // 支付成功，跳转到订单详情页面
            resp.sendRedirect(req.getContextPath() + "/order/detail?orderNumber=" + orderNumber);
        } else {
            // 支付失败，设置错误信息并重新显示支付页面
            req.setAttribute("error", "支付失败，请重试");
            processPayment(req, resp);
        }
    }

    /**
     * 取消订单
     * 处理订单取消请求
     */
    private void cancelOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取订单号参数
        String orderNumber = req.getParameter("orderNumber");

        // 如果没有订单号，重定向到订单列表
        if (orderNumber == null) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        // 根据订单号获取订单信息
        Order order = orderDAO.getOrderByNumber(orderNumber);

        // 验证订单状态（必须是"未支付"状态）
        if (order == null || !"未支付".equals(order.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        // 执行取消订单操作
        if (orderDAO.cancelOrder(orderNumber)) {
            // 取消成功，释放车票库存
            ticketDAO.cancelTicket(order.getTicket().getId(), 1);
            // 重定向到订单列表页面
            resp.sendRedirect(req.getContextPath() + "/order");
        } else {
            // 取消失败，设置错误信息并显示订单详情
            req.setAttribute("error", "取消订单失败，请重试");
            showOrderDetail(req, resp);
        }
    }
}