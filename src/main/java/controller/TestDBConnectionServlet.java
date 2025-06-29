package controller;

import util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet("/test-db")
public class TestDBConnectionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            out.println("<h2>数据库连接成功！</h2>");

            // 测试查询（可选）
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT 1")) {
                if (rs.next()) {
                    out.println("测试查询结果: " + rs.getInt(1));
                }
            }
        } catch (Exception e) {
            out.println("<h2>连接异常</h2>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace(); // 服务器日志记录
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) {}
            }
        }
    }
}