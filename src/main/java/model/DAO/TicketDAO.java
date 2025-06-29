package model.DAO;

import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO extends BaseDAO {

    public List<Ticket> searchTickets(String startStationName, String endStationName, Date departureDate) {
        List<Ticket> tickets = new ArrayList<>();
        String sql =
                "SELECT " +
                        "  t.id                  AS ticket_id, " +
                        "  t.available_seats     AS available_seats, " +
                        "  t.base_price          AS base_price, " +
                        "  t.departure_date      AS departure_date, " +

                        "  tr.id                 AS train_id, " +
                        "  tr.train_number       AS train_number, " +
                        "  tr.departure_time     AS departure_time, " +
                        "  tr.arrival_time       AS arrival_time, " +
                        "  tr.duration           AS duration, " +
                        "  tr.distance           AS distance, " +

                        "  tt.id                 AS train_type_id, " +
                        "  tt.type_name          AS train_type_name, " +
                        "  tt.description        AS train_type_description, " +
                        "  tt.speed_level        AS speed_level, " +

                        "  s1.id                 AS start_station_id, " +
                        "  s1.station_name       AS start_station_name, " +
                        "  s1.city               AS start_station_city, " +
                        "  s1.province           AS start_station_province, " +
                        "  s1.station_code       AS start_station_code, " +

                        "  s2.id                 AS end_station_id, " +
                        "  s2.station_name       AS end_station_name, " +
                        "  s2.city               AS end_station_city, " +
                        "  s2.province           AS end_station_province, " +
                        "  s2.station_code       AS end_station_code, " +

                        "  st.id                 AS seat_type_id, " +
                        "  st.type_name          AS seat_type_name, " +
                        "  st.description        AS seat_type_description, " +
                        "  st.price_multiplier   AS price_multiplier " +

                        "FROM tickets t " +
                        "JOIN trains tr     ON t.train_id         = tr.id " +
                        "JOIN train_types tt ON tr.train_type_id   = tt.id " +
                        "JOIN stations s1   ON tr.start_station_id = s1.id " +
                        "JOIN stations s2   ON tr.end_station_id   = s2.id " +
                        "JOIN seat_types st ON t.seat_type_id      = st.id " +
                        "WHERE s1.station_name LIKE ? " +
                        "  AND s2.station_name LIKE ? " +
                        "  AND t.departure_date = ? " +
                        "  AND t.available_seats > 0 " +
                        "ORDER BY tr.departure_time";

        try (
                Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, startStationName);
            pstmt.setString(2, endStationName);
            pstmt.setDate(3, departureDate);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Ticket ticket = new Ticket();
                    ticket.setId(rs.getInt("ticket_id"));
                    ticket.setAvailableSeats(rs.getInt("available_seats"));
                    ticket.setBasePrice(rs.getDouble("base_price"));
                    ticket.setDepartureDate(rs.getDate("departure_date"));

                    Train train = new Train();
                    train.setId(rs.getInt("train_id"));
                    train.setTrainNumber(rs.getString("train_number"));
                    train.setDepartureTime(rs.getTime("departure_time"));
                    train.setArrivalTime(rs.getTime("arrival_time"));
                    train.setDuration(rs.getString("duration"));
                    train.setDistance(rs.getInt("distance"));

                    TrainType trainType = new TrainType();
                    trainType.setId(rs.getInt("train_type_id"));
                    trainType.setTypeName(rs.getString("train_type_name"));
                    trainType.setDescription(rs.getString("train_type_description"));
                    trainType.setSpeedLevel(rs.getInt("speed_level"));
                    train.setTrainType(trainType);

                    Station startStation = new Station();
                    startStation.setId(rs.getInt("start_station_id"));
                    startStation.setStationName(rs.getString("start_station_name"));
                    startStation.setCity(rs.getString("start_station_city"));
                    startStation.setProvince(rs.getString("start_station_province"));
                    startStation.setStationCode(rs.getString("start_station_code"));
                    train.setStartStation(startStation);

                    Station endStation = new Station();
                    endStation.setId(rs.getInt("end_station_id"));
                    endStation.setStationName(rs.getString("end_station_name"));
                    endStation.setCity(rs.getString("end_station_city"));
                    endStation.setProvince(rs.getString("end_station_province"));
                    endStation.setStationCode(rs.getString("end_station_code"));
                    train.setEndStation(endStation);

                    ticket.setTrain(train);

                    SeatType seatType = new SeatType();
                    seatType.setId(rs.getInt("seat_type_id"));
                    seatType.setTypeName(rs.getString("seat_type_name"));
                    seatType.setDescription(rs.getString("seat_type_description"));
                    seatType.setPriceMultiplier(rs.getDouble("price_multiplier"));
                    ticket.setSeatType(seatType);

                    tickets.add(ticket);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    public Ticket getTicketById(int id) {
        String sql =
                "SELECT " +
                        "  t.id                  AS ticket_id, " +
                        "  t.available_seats     AS available_seats, " +
                        "  t.base_price          AS base_price, " +
                        "  t.departure_date      AS departure_date, " +

                        "  tr.id                 AS train_id, " +
                        "  tr.train_number       AS train_number, " +
                        "  tr.departure_time     AS departure_time, " +
                        "  tr.arrival_time       AS arrival_time, " +
                        "  tr.duration           AS duration, " +
                        "  tr.distance           AS distance, " +

                        "  tt.id                 AS train_type_id, " +
                        "  tt.type_name          AS train_type_name, " +
                        "  tt.description        AS train_type_description, " +
                        "  tt.speed_level        AS speed_level, " +

                        "  s1.id                 AS start_station_id, " +
                        "  s1.station_name       AS start_station_name, " +
                        "  s1.city               AS start_station_city, " +
                        "  s1.province           AS start_station_province, " +
                        "  s1.station_code       AS start_station_code, " +

                        "  s2.id                 AS end_station_id, " +
                        "  s2.station_name       AS end_station_name, " +
                        "  s2.city               AS end_station_city, " +
                        "  s2.province           AS end_station_province, " +
                        "  s2.station_code       AS end_station_code, " +

                        "  st.id                 AS seat_type_id, " +
                        "  st.type_name          AS seat_type_name, " +
                        "  st.description        AS seat_type_description, " +
                        "  st.price_multiplier   AS price_multiplier " +

                        "FROM tickets t " +
                        "JOIN trains tr     ON t.train_id         = tr.id " +
                        "JOIN train_types tt ON tr.train_type_id   = tt.id " +
                        "JOIN stations s1   ON tr.start_station_id = s1.id " +
                        "JOIN stations s2   ON tr.end_station_id   = s2.id " +
                        "JOIN seat_types st ON t.seat_type_id      = st.id " +
                        "WHERE t.id = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Ticket ticket = new Ticket();
                    ticket.setId(rs.getInt("ticket_id"));
                    ticket.setAvailableSeats(rs.getInt("available_seats"));
                    ticket.setBasePrice(rs.getDouble("base_price"));
                    ticket.setDepartureDate(rs.getDate("departure_date"));

                    Train train = new Train();
                    train.setId(rs.getInt("train_id"));
                    train.setTrainNumber(rs.getString("train_number"));
                    train.setDepartureTime(rs.getTime("departure_time"));
                    train.setArrivalTime(rs.getTime("arrival_time"));
                    train.setDuration(rs.getString("duration"));
                    train.setDistance(rs.getInt("distance"));

                    TrainType trainType = new TrainType();
                    trainType.setId(rs.getInt("train_type_id"));
                    trainType.setTypeName(rs.getString("train_type_name"));
                    trainType.setDescription(rs.getString("train_type_description"));
                    trainType.setSpeedLevel(rs.getInt("speed_level"));
                    train.setTrainType(trainType);

                    Station startStation = new Station();
                    startStation.setId(rs.getInt("start_station_id"));
                    startStation.setStationName(rs.getString("start_station_name"));
                    startStation.setCity(rs.getString("start_station_city"));
                    startStation.setProvince(rs.getString("start_station_province"));
                    startStation.setStationCode(rs.getString("start_station_code"));
                    train.setStartStation(startStation);

                    Station endStation = new Station();
                    endStation.setId(rs.getInt("end_station_id"));
                    endStation.setStationName(rs.getString("end_station_name"));
                    endStation.setCity(rs.getString("end_station_city"));
                    endStation.setProvince(rs.getString("end_station_province"));
                    endStation.setStationCode(rs.getString("end_station_code"));
                    train.setEndStation(endStation);

                    ticket.setTrain(train);

                    SeatType seatType = new SeatType();
                    seatType.setId(rs.getInt("seat_type_id"));
                    seatType.setTypeName(rs.getString("seat_type_name"));
                    seatType.setDescription(rs.getString("seat_type_description"));
                    seatType.setPriceMultiplier(rs.getDouble("price_multiplier"));
                    ticket.setSeatType(seatType);

                    return ticket;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean bookTicket(int ticketId, int quantity) {
        String sql = "UPDATE tickets SET available_seats = available_seats - ? "
                + "WHERE id = ? AND available_seats >= ?";
        try (
                Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, ticketId);
            pstmt.setInt(3, quantity);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelTicket(int ticketId, int quantity) {
        String sql = "UPDATE tickets SET available_seats = available_seats + ? WHERE id = ?";
        try (
                Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, ticketId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
