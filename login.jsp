<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        * {
            padding: 0;
            margin: 0;
            box-sizing: border-box;
        }
        body {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, sans-serif;
        }
        .outer-box {
            background-color: #f2f2f2;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body onload="document.getElementById('loginForm').reset();">
    <div class="outer-box">
        <form id="loginForm" action="login.jsp" method="post">
            <label for="email">Email Id:</label>
            <input type="text" name="email" placeholder="Write your email id" required><br>
            <label for="pwd">Password:</label>
            <input type="password" name="pwd" placeholder="Write your password" required><br>
            <input type="submit" value="Login">
        </form>
    </div>
</body>
</html>

<%@page import="java.sql.*,java.util.*"%>
<%
String email = request.getParameter("email");
String password = request.getParameter("pwd");

try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "raju", "Nagaraju1136@");
    String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, email);
    ps.setString(2, password);
    ResultSet resultset = ps.executeQuery();
    
    if (resultset.next()) {
        String role = resultset.getString("role");
        if ("admin".equals(role)) {
            response.sendRedirect("admin.html");
        } else {
            response.sendRedirect("user.html");
        }
    }
    conn.close();
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
