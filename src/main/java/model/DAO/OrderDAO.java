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
        double totalPrice = ticket.getActualPrice();

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
        String sql = "SELECT o.*, u.*, t.*, tr.*, tt.*, s1.*, s2.*, st.* " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "JOIN tickets t ON o.ticket_id = t.id " +
                "JOIN trains tr ON t.train_id = tr.id " +
                "JOIN train_types tt ON tr.train_type_id = tt.id " +
                "JOIN stations s1 ON tr.start_station_id = s1.id " +
                "JOIN stations s2 ON tr.end_station_id = s2.id " +
                "JOIN seat_types st ON t.seat_type_id = st.id " +
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

                // 设置订单信息
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

                // 设置用户信息
                User user = new User();
                user.setId(rs.getInt("u.id"));
                user.setUsername(rs.getString("u.username"));
                user.setEmail(rs.getString("u.email"));
                user.setPhone(rs.getString("u.phone"));
                order.setUser(user);

                // 设置车票信息
                Ticket ticket = new Ticket();
                ticket.setId(rs.getInt("t.id"));
                ticket.setAvailableSeats(rs.getInt("t.available_seats"));
                ticket.setBasePrice(rs.getDouble("t.base_price"));
                ticket.setDepartureDate(rs.getDate("t.departure_date"));

                // 设置列车信息
                Train train = new Train();
                train.setId(rs.getInt("tr.id"));
                train.setTrainNumber(rs.getString("tr.train_number"));
                train.setDepartureTime(rs.getTime("tr.departure_time"));
                train.setArrivalTime(rs.getTime("tr.arrival_time"));
                train.setDuration(rs.getString("tr.duration"));
                train.setDistance(rs.getInt("tr.distance"));

                // 设置列车类型
                TrainType trainType = new TrainType();
                trainType.setId(rs.getInt("tt.id"));
                trainType.setTypeName(rs.getString("tt.type_name"));
                trainType.setDescription(rs.getString("tt.description"));
                trainType.setSpeedLevel(rs.getInt("tt.speed_level"));
                train.setTrainType(trainType);

                // 设置起点站
                Station startStation = new Station();
                startStation.setId(rs.getInt("s1.id"));
                startStation.setStationName(rs.getString("s1.station_name"));
                startStation.setCity(rs.getString("s1.city"));
                startStation.setProvince(rs.getString("s1.province"));
                startStation.setStationCode(rs.getString("s1.station_code"));
                train.setStartStation(startStation);

                // 设置终点站
                Station endStation = new Station();
                endStation.setId(rs.getInt("s2.id"));
                endStation.setStationName(rs.getString("s2.station_name"));
                endStation.setCity(rs.getString("s2.city"));
                endStation.setProvince(rs.getString("s2.province"));
                endStation.setStationCode(rs.getString("s2.station_code"));
                train.setEndStation(endStation);

                ticket.setTrain(train);

                // 设置座位类型
                SeatType seatType = new SeatType();
                seatType.setId(rs.getInt("st.id"));
                seatType.setTypeName(rs.getString("st.type_name"));
                seatType.setDescription(rs.getString("st.description"));
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
        String sql = "SELECT o.*, u.*, t.*, tr.*, tt.*, s1.*, s2.*, st.* " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "JOIN tickets t ON o.ticket_id = t.id " +
                "JOIN trains tr ON t.train_id = tr.id " +
                "JOIN train_types tt ON tr.train_type_id = tt.id " +
                "JOIN stations s1 ON tr.start_station_id = s1.id " +
                "JOIN stations s2 ON tr.end_station_id = s2.id " +
                "JOIN seat_types st ON t.seat_type_id = st.id " +
                "WHERE o.user_id = ? " +
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

                // 设置订单信息
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

                // 设置用户信息
                User user = new User();
                user.setId(rs.getInt("u.id"));
                user.setUsername(rs.getString("u.username"));
                user.setEmail(rs.getString("u.email"));
                user.setPhone(rs.getString("u.phone"));
                order.setUser(user);

                // 设置车票信息
                Ticket ticket = new Ticket();
                ticket.setId(rs.getInt("t.id"));
                ticket.setAvailableSeats(rs.getInt("t.available_seats"));
                ticket.setBasePrice(rs.getDouble("t.base_price"));
                ticket.setDepartureDate(rs.getDate("t.departure_date"));

                // 设置列车信息
                Train train = new Train();
                train.setId(rs.getInt("tr.id"));
                train.setTrainNumber(rs.getString("tr.train_number"));
                train.setDepartureTime(rs.getTime("tr.departure_time"));
                train.setArrivalTime(rs.getTime("tr.arrival_time"));
                train.setDuration(rs.getString("tr.duration"));
                train.setDistance(rs.getInt("tr.distance"));

                // 设置列车类型
                TrainType trainType = new TrainType();
                trainType.setId(rs.getInt("tt.id"));
                trainType.setTypeName(rs.getString("tt.type_name"));
                trainType.setDescription(rs.getString("tt.description"));
                trainType.setSpeedLevel(rs.getInt("tt.speed_level"));
                train.setTrainType(trainType);

                // 设置起点站
                Station startStation = new Station();
                startStation.setId(rs.getInt("s1.id"));
                startStation.setStationName(rs.getString("s1.station_name"));
                startStation.setCity(rs.getString("s1.city"));
                startStation.setProvince(rs.getString("s1.province"));
                startStation.setStationCode(rs.getString("s1.station_code"));
                train.setStartStation(startStation);

                // 设置终点站
                Station endStation = new Station();
                endStation.setId(rs.getInt("s2.id"));
                endStation.setStationName(rs.getString("s2.station_name"));
                endStation.setCity(rs.getString("s2.city"));
                endStation.setProvince(rs.getString("s2.province"));
                endStation.setStationCode(rs.getString("s2.station_code"));
                train.setEndStation(endStation);

                ticket.setTrain(train);

                // 设置座位类型
                SeatType seatType = new SeatType();
                seatType.setId(rs.getInt("st.id"));
                seatType.setTypeName(rs.getString("st.type_name"));
                seatType.setDescription(rs.getString("st.description"));
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
}