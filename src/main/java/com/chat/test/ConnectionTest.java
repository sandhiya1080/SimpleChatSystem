package com.chat.test;

import java.sql.Connection;

import com.chat.util.DBConnection;

public class ConnectionTest {

    public static void main(String[] args) {

        try {
            Connection con = DBConnection.getConnection();

            if (con != null) {
                System.out.println("Database connected successfully!");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}