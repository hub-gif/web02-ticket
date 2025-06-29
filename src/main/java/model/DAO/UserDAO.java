package model.DAO;

import model.User;
import java.sql.*;

public class UserDAO extends BaseDAO {

    /** 根据用户名查询用户 */
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setSalt(rs.getString("salt"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setRealName(rs.getString("real_name"));
                    u.setIdNumber(rs.getString("id_number"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setCreateTime(rs.getTimestamp("create_time"));
                    u.setUpdateTime(rs.getTimestamp("update_time"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 按 ID 查询用户 （供 changePassword 使用） */
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setSalt(rs.getString("salt"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setRealName(rs.getString("real_name"));
                    u.setIdNumber(rs.getString("id_number"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setCreateTime(rs.getTimestamp("create_time"));
                    u.setUpdateTime(rs.getTimestamp("update_time"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 注册新用户
     * 注意：这里不做任何哈希，Servlet 里必须先调用 PasswordUtils
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users "
                + "(username, password_hash, salt, email, phone, real_name, id_number) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());  // Servlet 已经算好的 hash
            ps.setString(3, user.getSalt());          // Servlet 已经生成的 salt
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getRealName());
            ps.setString(7, user.getIdNumber());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** 更新用户资料（不含密码、头像） */
    public boolean updateUserProfile(User user) {
        String sql = "UPDATE users "
                + "SET email=?, phone=?, real_name=?, id_number=? "
                + "WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getRealName());
            ps.setString(4, user.getIdNumber());
            ps.setInt(5, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** 更新用户头像 */
    public boolean updateUserAvatar(int userId, String avatarPath) {
        String sql = "UPDATE users SET avatar=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, avatarPath);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 修改密码：只做新密码哈希和写回
     * 旧密码校验可留在 Servlet 或也可放到这里
     */
    public boolean changePassword(int userId, String newHash, String newSalt) {
        String sql = "UPDATE users SET password_hash=?, salt=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHash);
            ps.setString(2, newSalt);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
