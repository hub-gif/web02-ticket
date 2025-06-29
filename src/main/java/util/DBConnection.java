package util;

import java.sql.*;

public class DBConnection {
    static {
        // 显式加载驱动（关键修复）
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL驱动加载失败: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://192.168.151.241:3306/train?"
                + "useSSL=false&"
                + "serverTimezone=Asia/Shanghai&"
                + "allowPublicKeyRetrieval=true&"
                + "connectTimeout=5000"; // 5秒连接超时

        String username = "user01";
        String password = "123456";

        return DriverManager.getConnection(url, username, password);
    }
}