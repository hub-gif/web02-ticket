// com.toudatrain.model.DAO.OrderDAO.java
package model.DAO;

import model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class OrderDAO extends BaseDAO {
    public String createOrder(User user, Ticket ticket, String passengerName,
                              String passengerIdNumber, String passengerPhone, String seatNumber) {
        String orderNumber = generateOrderNumber();
        double totalPrice = ticket.getPrice();

        String sql = "INSERT INTO orders (user_id, ticket_id, order_number, status, " +
                "total_price, passenger_name, passenger_id_number, passenger_phone, seat_number) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, user.getId());
            pstmt.setInt(2, ticket.getId());
            pstmt.setString(3, orderNumber);
            pstmt.setString(4, "未支付");
            pstmt.setDouble(5, totalPrice);
            pstmt.setString(6, passengerName);
            pstmt.setString(7, passengerIdNumber);
            pstmt.setString(8, passengerPhone);
            pstmt.setString(9, seatNumber);

            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0 ? orderNumber : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            close(conn, pstmt);
        }
    }

    public boolean payOrder(String orderNumber, String paymentMethod) {
        String sql = "UPDATE orders SET status = '已支付', payment_method = ?, payment_time = NOW() " +
                "WHERE order_number = ? AND status = '未支付'";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, paymentMethod);
            pstmt.setString(2, orderNumber);

            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            close(conn, pstmt);
        }
    }

    public boolean cancelOrder(String orderNumber) {
        String sql = "UPDATE orders SET status = '已取消' WHERE order_number = ? AND status = '未支付'";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, orderNumber);

            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            close(conn, pstmt);
        }
    }

    public Order getOrderByNumber(String orderNumber) {
        String sql = "SELECT o.*, u.*, t.*, tr.*, s1.*, s2.*, st.* " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "JOIN ticket t ON o.ticket_id = t.ticket_ID " +           // 修改表名和字段名
                "JOIN checi tr ON t.checi_ID = tr.checi_ID " +           // 使用checi表而非train
                "JOIN stationtable s1 ON tr.StartStation = s1.StationInformation " +  // 简化关联
                "JOIN stationtable s2 ON tr.EndingStation = s2.StationInformation " + // 简化关联
                "JOIN seatinformation st ON t.seat_ID = st.seat_ID " +   // 修改表名和字段名
                "WHERE o.order_number = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, orderNumber);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Order order = new Order();

                // 设置订单信息（保持不变）
                order.setId(rs.getInt("o.id"));
                order.setOrderNumber(rs.getString("o.order_number"));
                order.setOrderTime(rs.getTimestamp("o.order_time"));
                order.setStatus(rs.getString("o.status"));
                order.setTotalPrice(rs.getDouble("o.total_price"));
                order.setPassengerName(rs.getString("o.passenger_name"));
                order.setPassengerIdNumber(rs.getString("o.passenger_id_number"));
                order.setPassengerPhone(rs.getString("o.passenger_phone"));
                order.setSeatNumber(rs.getString("o.seat_number"));
                order.setPaymentMethod(rs.getString("o.payment_method"));
                order.setPaymentTime(rs.getTimestamp("o.payment_time"));

                // 设置用户信息（保持不变）
                User user = new User();
                user.setId(rs.getInt("u.id"));
                user.setUsername(rs.getString("u.username"));
                user.setEmail(rs.getString("u.email"));
                user.setPhone(rs.getString("u.phone"));
                order.setUser(user);

                // 设置车票信息
                Ticket ticket = new Ticket();
                ticket.setId(rs.getInt("t.ticket_ID"));
                ticket.setAvailableSeats(rs.getInt("t.available_seats")); // 假设表中有该字段
                ticket.setPrice(rs.getDouble("t.Price"));                // 修改字段名
                ticket.setDepartureDate(rs.getString("tr.date"));        // 从checi表获取日期

                // 设置列车信息
                Train train = new Train();
                train.setId(rs.getInt("tr.checi_ID"));
                train.setTrainNumber(rs.getString("tr.ID"));            // 修改字段名
                train.setDepartureTime(rs.getString("tr.StartTime"));   // 修改字段名
                train.setArrivalTime(rs.getString("tr.EndingTime"));    // 修改字段名
                train.setDuration(rs.getString("tr.duration"));         // 假设表中有该字段
                train.setDistance(rs.getInt("tr.distance"));

                // 设置列车类型（简化，直接从checi表获取）
                TrainType trainType = new TrainType();
                trainType.setId(rs.getInt("tr.train_ID"));
                trainType.setTypeName(rs.getString("tr.Level"));        // 修改字段名
                train.setTrainType(trainType);

                // 设置起点站
                Station startStation = new Station();
                startStation.setId(rs.getInt("s1.ID"));
                startStation.setStationName(rs.getString("s1.StationInformation")); // 修改字段名
                train.setStartStation(startStation);

                // 设置终点站
                Station endStation = new Station();
                endStation.setId(rs.getInt("s2.ID"));
                endStation.setStationName(rs.getString("s2.StationInformation")); // 修改字段名
                train.setEndStation(endStation);

                ticket.setTrain(train);

                // 设置座位类型
                SeatType seatType = new SeatType();
                seatType.setId(rs.getInt("st.seat_ID"));
                seatType.setTypeName(rs.getString("st.Information"));   // 修改字段名
                seatType.setPriceMultiplier(rs.getDouble("st.price_multiplier"));
                ticket.setSeatType(seatType);

                order.setTicket(ticket);

                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return null;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.*, t.*, tr.*, s1.*, s2.*, st.* " +
                "FROM orders o " +
                "JOIN users u ON o.user_ID = u.ID " +
                "JOIN ticket t ON o.ticket_ID = t.ticket_ID " +           // 修改表名和字段名
                "JOIN checi tr ON t.checi_ID = tr.checi_ID " +           // 使用checi表而非train
                "JOIN stationtable s1 ON tr.StartStation = s1.StationInformation " +  // 简化关联
                "JOIN stationtable s2 ON tr.EndingStation = s2.StationInformation " + // 简化关联
                "JOIN seatinformation st ON t.seat_ID = st.seat_ID " +   // 修改表名和字段名
                "WHERE o.user_ID = ? " +
                "ORDER BY o.order_time DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();

                // 设置订单信息（保持不变）
                order.setId(rs.getInt("o.ID"));
                order.setOrderNumber(rs.getString("o.order_number"));
                order.setOrderTime(rs.getTimestamp("o.order_time"));
                order.setStatus(rs.getString("o.status"));
                order.setTotalPrice(rs.getDouble("o.total_price"));
                order.setPassengerName(rs.getString("o.passenger_name"));
                order.setPassengerIdNumber(rs.getString("o.passenger_id_number"));
                order.setPassengerPhone(rs.getString("o.passenger_phone"));
                order.setSeatNumber(rs.getString("o.seat_number"));
                order.setPaymentMethod(rs.getString("o.payment_method"));
                order.setPaymentTime(rs.getTimestamp("o.payment_time"));

                // 设置用户信息（保持不变）
                User user = new User();
                user.setId(rs.getInt("u.ID"));
                user.setUsername(rs.getString("u.username"));
                user.setEmail(rs.getString("u.email"));
                user.setPhone(rs.getString("u.phone"));
                order.setUser(user);

                // 设置车票信息
                Ticket ticket = new Ticket();
                ticket.setId(rs.getInt("t.ticket_ID"));
                ticket.setAvailableSeats(rs.getInt("t.seat_ID")); // 假设表中有该字段
                ticket.setPrice(rs.getDouble("t.Price"));                // 修改字段名
                ticket.setDepartureDate(rs.getString("tr.date"));        // 从checi表获取日期

                // 设置列车信息
                Train train = new Train();
                train.setId(rs.getInt("tr.checi_ID"));
                train.setTrainNumber(rs.getString("tr.ID"));            // 修改字段名
                train.setDepartureTime(rs.getString("tr.StartTime"));   // 修改字段名
                train.setArrivalTime(rs.getString("tr.EndingTime"));    // 修改字段名
             //   train.setDuration(rs.getString("tr.duration"));         // 假设表中有该字段
                train.setDistance(rs.getInt("tr.distance"));

                // 设置列车类型（简化，直接从checi表获取）
                TrainType trainType = new TrainType();
                trainType.setId(rs.getInt("tr.train_ID"));
                trainType.setTypeName(rs.getString("tr.Level"));        // 修改字段名
                train.setTrainType(trainType);

                // 设置起点站
                Station startStation = new Station();
                startStation.setId(rs.getInt("s1.ID"));
                startStation.setStationName(rs.getString("s1.StationInformation")); // 修改字段名
                train.setStartStation(startStation);

                // 设置终点站
                Station endStation = new Station();
                endStation.setId(rs.getInt("s2.ID"));
                endStation.setStationName(rs.getString("s2.StationInformation")); // 修改字段名
                train.setEndStation(endStation);

                ticket.setTrain(train);

                // 设置座位类型
                SeatType seatType = new SeatType();
                seatType.setId(rs.getInt("st.seat_ID"));
                seatType.setTypeName(rs.getString("st.Information"));   // 修改字段名
                seatType.setPriceMultiplier(rs.getDouble("st.price_multiplier"));
                ticket.setSeatType(seatType);

                order.setTicket(ticket);

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return orders;
    }

    private String generateOrderNumber() {
        // 生成唯一订单号，格式：YYMMDD + 8位随机数
        String timestamp = new java.text.SimpleDateFormat("yyMMdd").format(new java.util.Date());
        String randomPart = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        return "TD" + timestamp + randomPart;
    }

    public List<Order> getOrdersByUserId(int userId, String status, String keyword, int page, int pageSize) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.*, t.*, tr.*, s1.*, s2.*, st.* " +
                "FROM orders o " +
                "JOIN users u ON o.user_ID = u.ID " +
                "JOIN ticket t ON o.ticket_ID = t.ticket_ID " +
                "JOIN checi tr ON t.checi_ID = tr.checi_ID " +
                "JOIN stationtable s1 ON tr.StartStation = s1.StationInformation " +
                "JOIN stationtable s2 ON tr.EndingStation = s2.StationInformation " +
                "JOIN seatinformation st ON t.seat_ID = st.seat_ID " +
                "WHERE o.user_ID = ? ";

        // 添加状态筛选条件
        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql += " AND o.status = ? ";
        }

        // 添加关键词搜索条件
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (o.order_number LIKE ? OR tr.ID LIKE ? OR o.order_time LIKE ?) ";
        }

        sql += " ORDER BY o.order_time DESC LIMIT ? OFFSET ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            int paramIndex = 1;
            pstmt.setInt(paramIndex++, userId);

            if (status != null && !status.isEmpty() && !"all".equals(status)) {
                pstmt.setString(paramIndex++, status);
            }

            if (keyword != null && !keyword.isEmpty()) {
                String searchTerm = "%" + keyword + "%";
                pstmt.setString(paramIndex++, searchTerm);
                pstmt.setString(paramIndex++, searchTerm);
                pstmt.setString(paramIndex++, searchTerm);
            }

            pstmt.setInt(paramIndex++, pageSize);
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();

                // 设置订单信息
                order.setId(rs.getInt("o.ID"));
                order.setOrderNumber(rs.getString("o.order_number"));
                order.setOrderTime(rs.getTimestamp("o.order_time"));
                order.setStatus(rs.getString("o.status"));
                order.setTotalPrice(rs.getDouble("o.total_price"));
                order.setPassengerName(rs.getString("o.passenger_name"));
                order.setPassengerIdNumber(rs.getString("o.passenger_id_number"));
                order.setPassengerPhone(rs.getString("o.passenger_phone"));
                order.setSeatNumber(rs.getString("o.seat_number"));
                order.setPaymentMethod(rs.getString("o.payment_method"));
                order.setPaymentTime(rs.getTimestamp("o.payment_time"));

                // 设置用户信息
                User user = new User();
                user.setId(rs.getInt("u.ID"));
                user.setUsername(rs.getString("u.username"));
                user.setEmail(rs.getString("u.email"));
                user.setPhone(rs.getString("u.phone"));
                order.setUser(user);

                // 设置车票信息
                Ticket ticket = new Ticket();
                ticket.setId(rs.getInt("t.ticket_ID"));
                ticket.setAvailableSeats(rs.getInt("t.seat_ID"));
                ticket.setPrice(rs.getDouble("t.Price"));
                ticket.setDepartureDate(rs.getString("tr.date"));

                // 设置列车信息
                Train train = new Train();
                train.setId(rs.getInt("tr.checi_ID"));
                train.setTrainNumber(rs.getString("tr.ID"));
                train.setDepartureTime(rs.getString("tr.StartTime"));
                train.setArrivalTime(rs.getString("tr.EndingTime"));
                train.setDistance(rs.getInt("tr.distance"));

                // 设置列车类型
                TrainType trainType = new TrainType();
                trainType.setId(rs.getInt("tr.train_ID"));
                trainType.setTypeName(rs.getString("tr.Level"));
                train.setTrainType(trainType);

                // 设置起点站
                Station startStation = new Station();
                startStation.setId(rs.getInt("s1.ID"));
                startStation.setStationName(rs.getString("s1.StationInformation"));
                train.setStartStation(startStation);

                // 设置终点站
                Station endStation = new Station();
                endStation.setId(rs.getInt("s2.ID"));
                endStation.setStationName(rs.getString("s2.StationInformation"));
                train.setEndStation(endStation);

                ticket.setTrain(train);

                // 设置座位类型
                SeatType seatType = new SeatType();
                seatType.setId(rs.getInt("st.seat_ID"));
                seatType.setTypeName(rs.getString("st.Information"));
                seatType.setPriceMultiplier(rs.getDouble("st.price_multiplier"));
                ticket.setSeatType(seatType);

                order.setTicket(ticket);

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return orders;
    }

    // 获取订单总数，用于分页计算
    public int getTotalOrdersCount(int userId, String status, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders o " +
                "JOIN ticket t ON o.ticket_ID = t.ticket_ID " +
                "JOIN checi tr ON t.checi_ID = tr.checi_ID " +
                "WHERE o.user_ID = ? ");

        List<Object> params = new ArrayList<>();
        params.add(userId);

        // 添加状态筛选条件
        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND o.status = ? ");
            params.add(status);
        }

        // 添加关键词搜索条件
        if (keyword != null && !keyword.isEmpty()) {
            // 检查是否为日期格式
            if (keyword.contains("-")) {
                sql.append(" AND DATE(o.order_time) = ? ");
                params.add(keyword);
            } else {
                sql.append(" AND (o.order_number LIKE ? OR tr.ID LIKE ?) ");
                params.add("%" + keyword + "%");
                params.add("%" + keyword + "%");
            }
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return count;
    }
}