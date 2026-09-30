<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Chat System - Login</title>

    <style>

        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }

        .login-container {
            width: 350px;
            margin: 120px auto;
            padding: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px #aaa;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background-color: #333;
            color: white;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="submit"]:hover {
            background-color: #555;
        }

    </style>

</head>

<body>

    <div class="login-container">

        <h2>Simple Chat System</h2>
        <%
    String error = request.getParameter("error");

    if ("invalid".equals(error)) {
%>

    <p style="color:red; text-align:center;">
        Invalid username. Please try again.
    </p>

<%
    } else if ("database".equals(error)) {
%>

    <p style="color:red; text-align:center;">
        Database error. Please try again.
    </p>

<%
    }
%>

        <form action="LoginServlet" method="post">

            <label>Username</label>

            <input type="text"
                   name="username"
                   placeholder="Enter username"
                   required>

            <input type="submit"
                   value="Login">

        </form>

    </div>

</body>
</html>