// com.toudatrain.model.DAO.StationDAO.java
package model.DAO;

import model.Station;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StationDAO extends BaseDAO {
    public List<Station> getAllStations() {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM stations";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Station station = new Station();
                station.setId(rs.getInt("id"));
                station.setStationName(rs.getString("station_name"));
                station.setCity(rs.getString("city"));
                station.setProvince(rs.getString("province"));
                station.setStationCode(rs.getString("station_code"));
                stations.add(station);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return stations;
    }

    public Station getStationById(int id) {
        String sql = "SELECT * FROM stations WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Station station = new Station();
                station.setId(rs.getInt("id"));
                station.setStationName(rs.getString("station_name"));
                station.setCity(rs.getString("city"));
                station.setProvince(rs.getString("province"));
                station.setStationCode(rs.getString("station_code"));
                return station;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return null;
    }

    public Station getStationByName(String name) {
        String sql = "SELECT * FROM stations WHERE station_name = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Station station = new Station();
                station.setId(rs.getInt("id"));
                station.setStationName(rs.getString("station_name"));
                station.setCity(rs.getString("city"));
                station.setProvince(rs.getString("province"));
                station.setStationCode(rs.getString("station_code"));
                return station;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return null;
    }
}