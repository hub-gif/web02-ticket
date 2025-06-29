// com.toudatrain.model.DAO.TicketDAO.java
package model.DAO;

import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.SeatType;

public class TicketDAO extends BaseDAO {
    public List<Ticket> searchTickets(String startStationName, String endStationName, String departureDate) {
        List<Ticket> tickets = new ArrayList<>();
        // 多表JOIN查询（核心调整点）
        String sql = "SELECT "
                + "c.ID AS checi_id, c.StartStation, c.EndingStation, c.date, c.StartTime, c.EndingTime, c.distance, "
                + "tr.type AS type, "
                + "tk.ticket_ID, tk.Price, tk.Check_ID, "
                + "si.Information AS seat_type, si.price_multiplier "
                + "FROM checi c "
                + "JOIN train tr ON c.train_ID = tr.train_ID "       // 关联列车类型
                + "JOIN `checi-ticket` ct ON c.checi_ID = ct.checi_ID " // 关联车次与票
                + "JOIN ticket tk ON ct.ticket_ID = tk.ticket_ID "   // 关联票详情
                + "JOIN seatinformation si ON tk.seat_ID = si.seat_ID " // 关联座位类型
                + "WHERE c.StartStation = ? "
                + "AND c.EndingStation = ? "
                + "AND c.date = ? "
                // 可扩展：若需过滤余票，需在ticket表添加库存字段（如 tk.available > 0）
                + "ORDER BY c.StartTime"; // 按发车时间排序


        try (Connection conn = getConnection();          // 使用try-with-resources自动关闭资源
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // 绑定查询参数
            pstmt.setString(1, startStationName);
            pstmt.setString(2, endStationName);
            pstmt.setString(3, departureDate);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Ticket ticket = new Ticket();

                    // 1. 设置车次信息（Checi）
                    Checi checi = new Checi();
                    Station starStation=new Station();
                    Station endStation =new Station();
                    checi.setId(rs.getString("checi_id"));
                    starStation.setStationName(rs.getString("StartStation"));
                    endStation.setStationName(rs.getString("EndingStation"));
                    checi.setStartStation(starStation);
                    checi.setEndStation(endStation);
                    checi.setStartTime(rs.getString("StartTime"));
                    checi.setEndTime(rs.getString("EndingTime"));
                    checi.setDistance(rs.getInt("distance"));
                    ticket.setCheci(checi);

                    // 2. 设置列车类型（Train）
                    Train train = new Train();
                    TrainType trainType = new TrainType();
                    trainType.setTypeName(rs.getString("type")); // 如"高铁"
                    train.setTrainType(trainType);
                    ticket.setTrain(train);

                    // 3. 设置票务信息（Ticket）
                    ticket.setTicket_ID(rs.getInt("ticket_ID"));
                    ticket.setPrice(rs.getDouble("Price"));
                    ticket.setCheck_ID(rs.getInt("Check_ID")); // 检票口

                    // 4. 设置座位类型（SeatInformation）
                   SeatType seat = new SeatType();
                    seat.setTypeName(rs.getString("seat_type")); // 如"一等座"
                    seat.setPriceMultiplier(rs.getDouble("price_multiplier"));
                    ticket.setSeat(seat);

                    // 5. 计算最终票价（基础价 × 倍率）
                    double finalPrice = ticket.getPrice() * seat.getPriceMultiplier();
                    ticket.setPrice(finalPrice);

                    tickets.add(ticket);
                }
            }
        } catch (SQLException e) {
            // 优化：记录日志或抛出自定义异常
            e.printStackTrace();
        }
        return tickets;
    }

    public Ticket getTicketById(int id) {
        String sql = "SELECT t.*, tr.*, tt.*, s1.*, s2.*, st.* " +
                "FROM tickets t " +
                "JOIN trains tr ON t.train_id = tr.id " +
                "JOIN train_types tt ON tr.train_type_id = tt.id " +
                "JOIN stations s1 ON tr.start_station_id = s1.id " +
                "JOIN stations s2 ON tr.end_station_id = s2.id " +
                "JOIN seat_types st ON t.seat_type_id = st.id " +
                "WHERE t.id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Ticket ticket = new Ticket();

                // 设置车票信息
                ticket.setId(rs.getInt("t.id"));
                ticket.setAvailableSeats(rs.getInt("t.available_seats"));
                ticket.setPrice(rs.getDouble("t.base_price"));
                ticket.setDepartureDate(rs.getString("t.departure_date"));

                // 设置列车信息
                Train train = new Train();
                train.setId(rs.getInt("tr.id"));
                train.setTrainNumber(rs.getString("tr.train_number"));
                train.setDepartureTime(rs.getString("tr.departure_time"));
                train.setArrivalTime(rs.getString("tr.arrival_time"));
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

                return ticket;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return null;
    }

    public boolean bookTicket(int ticketId, int quantity) {
        String sql = "UPDATE tickets SET available_seats = available_seats - ? WHERE id = ? AND available_seats >= ?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, ticketId);
            pstmt.setInt(3, quantity);

            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            close(conn, pstmt);
        }
    }

    public boolean cancelTicket(int ticketId, int quantity) {
        String sql = "UPDATE tickets SET available_seats = available_seats + ? WHERE id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, ticketId);

            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            close(conn, pstmt);
        }
    }
}