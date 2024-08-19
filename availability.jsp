<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Availability</title>
</head>
<body>
    <h2>Check Book Availability</h2>
    <form action="availability.jsp" method="post">
        <label for="bookid">Enter Book ID:</label>
        <input type="number" name="bookid" placeholder="Enter Book ID" required>
        <br><br>
        <input type="submit" value="Check Availability">
    </form>

    <%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String bookId = request.getParameter("bookid");

        if (bookId != null && !bookId.isEmpty()) {
            try {
                // Load MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish a connection to the database
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "raju", "Nagaraju1136@");

                // SQL query to fetch the availability status of the book
                String sql = "SELECT availability_status FROM Books WHERE book_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(bookId));

                // Execute the query
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    int availabilityStatus = rs.getInt("availability_status");

                    if (availabilityStatus == 1) {
                        out.println("<p>The book with ID " + bookId + " is <strong>available</strong>.</p>");
                    } else if (availabilityStatus == 0) {
                        out.println("<p>The book with ID " + bookId + " is <strong>not available</strong>.</p>");
                    }
                } else {
                    out.println("<p>No book found with ID " + bookId + ". Please try again.</p>");
                }

                // Close the connection
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p>Please enter a valid Book ID.</p>");
        }
    }
    %>
</body>
</html>
