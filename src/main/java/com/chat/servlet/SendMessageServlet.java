package com.chat.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.chat.util.DBConnection;

@WebServlet("/SendMessageServlet")
public class SendMessageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // Check login session
        if (session == null ||
            session.getAttribute("username") == null) {

            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                "{\"success\":false,\"message\":\"Not logged in\"}"
            );
            return;
        }

        String sender =
            (String) session.getAttribute("username");

        String receiver =
            request.getParameter("receiver");

        String message =
            request.getParameter("message");

        // Validate input
        if (receiver == null ||
            receiver.trim().isEmpty() ||
            message == null ||
            message.trim().isEmpty()) {

            response.setStatus(
                HttpServletResponse.SC_BAD_REQUEST
            );

            response.getWriter().write(
                "{\"success\":false,\"message\":\"Invalid input\"}"
            );

            return;
        }

        receiver = receiver.trim();
        message = message.trim();

        String sql =
            "INSERT INTO messages " +
            "(sender, receiver, message) " +
            "VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                 con.prepareStatement(sql)) {

            ps.setString(1, sender);
            ps.setString(2, receiver);
            ps.setString(3, message);

            int rows = ps.executeUpdate();

            if (rows > 0) {

                response.getWriter().write(
                    "{\"success\":true,\"message\":\"Message sent\"}"
                );

            } else {

                response.getWriter().write(
                    "{\"success\":false,\"message\":\"Message not sent\"}"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().write(
                "{\"success\":false,\"message\":\"Database error\"}"
            );
        }
    }
}