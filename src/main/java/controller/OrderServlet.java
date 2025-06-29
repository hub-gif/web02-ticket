// com.toudatrain.controller.OrderServlet.java
package controller;

import model.Order;
import model.Ticket;
import model.User;
import model.DAO.OrderDAO;
import model.DAO.TicketDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        if (action == null || action.equals("/")) {
            showOrderList(req, resp);
        } else if (action.equals("/create")) {
            showCreateOrder(req, resp);
        } else if (action.equals("/detail")) {
            showOrderDetail(req, resp);
        } else if (action.equals("/pay")) {
            processPayment(req, resp);
        } else if (action.equals("/cancel")) {
            cancelOrder(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        if (action.equals("/create")) {
            createOrder(req, resp);
        } else if (action.equals("/pay")) {
            confirmPayment(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showOrderList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        java.util.List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/order_management.jsp").forward(req, resp);
    }

    private void showCreateOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ticketIdStr = req.getParameter("ticketId");
        String passengerName = req.getParameter("passengerName");
        String passengerIdNumber = req.getParameter("passengerIdNumber");
        String passengerPhone = req.getParameter("passengerPhone");
        String seatNumber = req.getParameter("seatNumber");

        if (ticketIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/ticket");
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            Ticket ticket = ticketDAO.getTicketById(ticketId);

            if (ticket == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            req.setAttribute("ticket", ticket);
            req.setAttribute("passengerName", passengerName);
            req.setAttribute("passengerIdNumber", passengerIdNumber);
            req.setAttribute("passengerPhone", passengerPhone);
            req.setAttribute("seatNumber", seatNumber);

            req.getRequestDispatcher("/order_create.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void createOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String ticketIdStr = req.getParameter("ticketId");
        String passengerName = req.getParameter("passengerName");
        String passengerIdNumber = req.getParameter("passengerIdNumber");
        String passengerPhone = req.getParameter("passengerPhone");
        String seatNumber = req.getParameter("seatNumber");

        if (ticketIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/ticket");
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            Ticket ticket = ticketDAO.getTicketById(ticketId);

            if (ticket == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String orderNumber = orderDAO.createOrder(user, ticket, passengerName,
                    passengerIdNumber, passengerPhone, seatNumber);

            if (orderNumber != null) {
                resp.sendRedirect(req.getContextPath() + "/order/detail?orderNumber=" + orderNumber);
            } else {
                // 订单创建失败，释放车票库存
                ticketDAO.cancelTicket(ticketId, 1);
                req.setAttribute("error", "订单创建失败，请重试");
                req.getRequestDispatcher("/ticket_detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void showOrderDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderNumber = req.getParameter("orderNumber");

        if (orderNumber == null) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        Order order = orderDAO.getOrderByNumber(orderNumber);

        if (order == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        req.setAttribute("order", order);
        req.getRequestDispatcher("/order_detail.jsp").forward(req, resp);
    }

    private void processPayment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderNumber = req.getParameter("orderNumber");

        if (orderNumber == null) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        Order order = orderDAO.getOrderByNumber(orderNumber);

        if (order == null || !"未支付".equals(order.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        req.setAttribute("order", order);
        req.getRequestDispatcher("/payment.jsp").forward(req, resp);
    }

    private void confirmPayment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderNumber = req.getParameter("orderNumber");
        String paymentMethod = req.getParameter("paymentMethod");

        if (orderNumber == null || paymentMethod == null) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        if (orderDAO.payOrder(orderNumber, paymentMethod)) {
            resp.sendRedirect(req.getContextPath() + "/order/detail?orderNumber=" + orderNumber);
        } else {
            req.setAttribute("error", "支付失败，请重试");
            processPayment(req, resp);
        }
    }

    private void cancelOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderNumber = req.getParameter("orderNumber");

        if (orderNumber == null) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        Order order = orderDAO.getOrderByNumber(orderNumber);

        if (order == null || !"未支付".equals(order.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        if (orderDAO.cancelOrder(orderNumber)) {
            // 释放车票库存
            ticketDAO.cancelTicket(order.getTicket().getId(), 1);
            resp.sendRedirect(req.getContextPath() + "/order");
        } else {
            req.setAttribute("error", "取消订单失败，请重试");
            showOrderDetail(req, resp);
        }
    }
}