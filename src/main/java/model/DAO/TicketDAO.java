// com.toudatrain.model.DAO.TicketDAO.java
package model.DAO;

import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.SeatType;

public class TicketDAO extends BaseDAO {
    public List<Ticket> searchTickets(String startStationName, String endStationName, Date departureDate) {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT t.*, tr.*, tt.*, s1.*, s2.*, st.* " +
                "FROM tickets t " +
                "JOIN trains tr ON t.train_id = tr.id " +
                "JOIN train_types tt ON tr.train_type_id = tt.id " +
                "JOIN stations s1 ON tr.start_station_id = s1.id " +
                "JOIN stations s2 ON tr.end_station_id = s2.id " +
                "JOIN seat_types st ON t.seat_type_id = st.id " +
                "WHERE s1.station_name = ? AND s2.station_name = ? AND t.departure_date = ? " +
                "AND t.available_seats > 0 " +
                "ORDER BY tr.departure_time";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, startStationName);
            pstmt.setString(2, endStationName);
            pstmt.setDate(3, departureDate);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Ticket ticket = new Ticket();

                // 设置车票信息
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
                model.SeatType seatType = new model.SeatType();
                seatType.setId(rs.getInt("st.id"));
                seatType.setTypeName(rs.getString("st.type_name"));
                seatType.setDescription(rs.getString("st.description"));
                seatType.setPriceMultiplier(rs.getDouble("st.price_multiplier"));
                ticket.setSeatType(seatType);

                tickets.add(ticket);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
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