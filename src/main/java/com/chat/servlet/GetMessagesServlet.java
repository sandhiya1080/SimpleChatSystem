package com.chat.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.chat.util.DBConnection;

@WebServlet("/GetMessagesServlet")
public class GetMessagesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("username") == null) {

            response.setStatus(
                HttpServletResponse.SC_UNAUTHORIZED
            );

            return;
        }

        String currentUser =
            (String) session.getAttribute("username");

        String otherUser =
            request.getParameter("receiver");

        if (otherUser == null ||
            otherUser.trim().isEmpty()) {

            response.setStatus(
                HttpServletResponse.SC_BAD_REQUEST
            );

            return;
        }

        otherUser = otherUser.trim();

        String sql =
            "SELECT sender, receiver, message, message_time " +
            "FROM messages " +
            "WHERE (sender = ? AND receiver = ?) " +
            "OR (sender = ? AND receiver = ?) " +
            "ORDER BY message_time ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                 con.prepareStatement(sql);
             PrintWriter out = response.getWriter()) {

            ps.setString(1, currentUser);
            ps.setString(2, otherUser);
            ps.setString(3, otherUser);
            ps.setString(4, currentUser);

            ResultSet rs = ps.executeQuery();

            StringBuilder json =
                new StringBuilder("[");

            boolean first = true;

            while (rs.next()) {

                if (!first) {
                    json.append(",");
                }

                json.append("{");

                json.append("\"sender\":\"")
                    .append(rs.getString("sender"))
                    .append("\",");

                json.append("\"receiver\":\"")
                    .append(rs.getString("receiver"))
                    .append("\",");

                json.append("\"message\":\"")
                    .append(
                        rs.getString("message")
                          .replace("\\", "\\\\")
                          .replace("\"", "\\\"")
                          .replace("\n", "\\n")
                    )
                    .append("\",");

                json.append("\"message_time\":\"")
                    .append(rs.getString("message_time"))
                    .append("\"");

                json.append("}");

                first = false;
            }

            json.append("]");

            out.print(json.toString());

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );
        }
    }
}