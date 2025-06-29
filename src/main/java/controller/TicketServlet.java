// com.toudatrain.controller.TicketServlet.java
package controller;

import model.Station;
import model.Ticket;
import model.DAO.StationDAO;
import model.DAO.TicketDAO;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ticket/*")
public class TicketServlet extends HttpServlet {
    private TicketDAO ticketDAO = new TicketDAO();
    private StationDAO stationDAO = new StationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        if (action == null || action.equals("/")) {
            showTicketSearchPage(req, resp);
        } else if (action.equals("/search")) {
            searchTickets(req, resp);
        } else if (action.equals("/detail")) {
            showTicketDetail(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 显示车票搜索页面。
     * 该方法从数据库中获取所有车站信息，将其设置到请求属性中，
     * 然后将请求转发到 main.jsp 页面以显示车票搜索界面。
     *
     * @param req HttpServletRequest 对象，包含客户端请求信息
     * @param resp HttpServletResponse 对象，用于向客户端发送响应
     * @throws ServletException 如果在处理请求时发生 servlet 错误
     * @throws IOException 如果在输入输出操作时发生错误
     */
    private void showTicketSearchPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 调用 StationDAO 的 getAllStations 方法，从数据库中获取所有车站信息
        List<Station> stations = stationDAO.getAllStations();
        // 将获取到的车站列表设置到请求属性中，供 main.jsp 页面使用
        req.setAttribute("stations", stations);
        // 转发请求到 main.jsp 页面，显示车票搜索界面
        req.getRequestDispatcher("/main.jsp").forward(req, resp);
    }

    /**
     * 处理车票搜索请求，根据用户输入的出发站、终点站和出发日期查询车票信息。
     * 如果用户输入信息不完整，则重定向到车票搜索页面。
     * 查询成功后，将相关信息保存到请求属性中，并转发到 main.jsp 页面显示查询结果。
     *
     * @param req HttpServletRequest 对象，包含客户端请求信息
     * @param resp HttpServletResponse 对象，用于向客户端发送响应
     * @throws ServletException 如果在处理请求时发生 servlet 错误
     * @throws IOException 如果在输入输出操作时发生错误
     */
    private void searchTickets(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 从请求参数中获取出发站名称
        String startStationName = req.getParameter("fromStation");
        // 从请求参数中获取终点站名称
        String endStationName = req.getParameter("toStation");
        // 从请求参数中获取出发日期字符串
        String dateStr = req.getParameter("departDate");

        // 检查出发站、终点站和出发日期是否为空，如果为空则重定向到车票搜索页面
        if (startStationName == null || endStationName == null || dateStr == null) {
            resp.sendRedirect(req.getContextPath() + "/ticket");
            return;
        }

        // 将日期字符串转换为 java.sql.Date 对象
        Date departureDate = Date.valueOf(dateStr);

        // 调用 TicketDAO 的 searchTickets 方法，根据出发站、终点站和出发日期查询车票列表
        List<Ticket> trainList = ticketDAO.searchTickets(startStationName, endStationName, departureDate);

        // 将出发站名称设置到请求属性中，供后续页面使用
        req.setAttribute("startStation", startStationName);
        // 将终点站名称设置到请求属性中，供后续页面使用
        req.setAttribute("endStation", endStationName);
        // 将出发日期设置到请求属性中，供后续页面使用
        req.setAttribute("departureDate", departureDate);
        // 将查询到的车票列表设置到请求属性中，供后续页面使用
        req.setAttribute("trainList", trainList);

        // 转发请求到 main.jsp 页面，显示车票查询结果
        req.getRequestDispatcher("/main.jsp").forward(req, resp);
    }

    private void showTicketDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ticketIdStr = req.getParameter("id");

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
            req.getRequestDispatcher("/ticket_detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        if (action.equals("/book")) {
            bookTicket(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void bookTicket(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ticketIdStr = req.getParameter("ticketId");
        String passengerName = req.getParameter("passengerName");
        String passengerIdNumber = req.getParameter("passengerIdNumber");
        String passengerPhone = req.getParameter("passengerPhone");
        String seatNumber = req.getParameter("seatNumber");

        if (ticketIdStr == null || passengerName == null || passengerIdNumber == null || passengerPhone == null) {
            req.setAttribute("error", "请填写完整的购票信息");
            req.getRequestDispatcher("/ticket_detail.jsp").forward(req, resp);
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            Ticket ticket = ticketDAO.getTicketById(ticketId);

            if (ticket == null || ticket.getAvailableSeats() <= 0) {
                req.setAttribute("error", "车票已售罄");
                req.getRequestDispatcher("/ticket_detail.jsp").forward(req, resp);
                return;
            }

            // 这里应该添加更多的验证逻辑，如身份证号码格式验证等

            // 锁定车票库存
            if (!ticketDAO.bookTicket(ticketId, 1)) {
                req.setAttribute("error", "车票已售罄");
                req.getRequestDispatcher("/ticket_detail.jsp").forward(req, resp);
                return;
            }

            // 保存订单信息
            // 这部分逻辑将在OrderServlet中实现
            // 这里暂时重定向到订单确认页面
            resp.sendRedirect(req.getContextPath() + "/order/create?ticketId=" + ticketId +
                    "&passengerName=" + passengerName +
                    "&passengerIdNumber=" + passengerIdNumber +
                    "&passengerPhone=" + passengerPhone +
                    "&seatNumber=" + seatNumber);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}