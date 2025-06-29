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

    private void showTicketSearchPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Station> stations = stationDAO.getAllStations();
        req.setAttribute("stations", stations);
        req.getRequestDispatcher("/ticket_search.jsp").forward(req, resp);
    }

    private void searchTickets(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String startStationName = req.getParameter("startStation");
        String endStationName = req.getParameter("endStation");
        String dateStr = req.getParameter("departureDate");

        if (startStationName == null || endStationName == null || dateStr == null) {
            resp.sendRedirect(req.getContextPath() + "/ticket");
            return;
        }

        Date departureDate = Date.valueOf(dateStr);

        List<Ticket> tickets = ticketDAO.searchTickets(startStationName, endStationName, departureDate);

        req.setAttribute("startStation", startStationName);
        req.setAttribute("endStation", endStationName);
        req.setAttribute("departureDate", departureDate);
        req.setAttribute("tickets", tickets);

        req.getRequestDispatcher("/ticket_search_result.jsp").forward(req, resp);
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