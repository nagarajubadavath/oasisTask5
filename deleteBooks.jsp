<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Book</title>
</head>
<body>
    <h2>Delete a Book</h2>
    <form action="deleteBooks.jsp" method="post">
        <label for="bookid">Enter Book ID to Delete:</label>
        <input type="number" name="bookid" placeholder="Enter Book ID" required>
        <br><br>
        <input type="submit" value="Delete Book">
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

                // SQL query to delete the record based on book_id
                String sql = "DELETE FROM Books WHERE book_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(bookId));

                // Execute the update and check the number of affected rows
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<p>Book with ID " + bookId + " has been successfully deleted.</p>");
                } else {
                    out.println("<p>No book found with ID " + bookId + ". Please try again.</p>");
                }

                // Close the connection
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
