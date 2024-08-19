<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return a Book</title>
</head>
<body>
    <h2>Return a Book</h2>
    <form action="ReturnBooks.jsp" method="post">
        <label for="user_id">User ID:</label>
        <input type="text" name="user_id" placeholder="Enter your User ID" required>
        <br><br>
        <label for="book_id">Book ID:</label>
        <input type="number" name="book_id" placeholder="Enter the Book ID you want to return" required>
        <br><br>
        <input type="submit" value="Return Book">
    </form>

    <%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userId = request.getParameter("user_id");
        String bookId = request.getParameter("book_id");

        if (userId != null && !userId.isEmpty() && bookId != null && !bookId.isEmpty()) {
            try {
                // Load MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish a connection to the database
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "raju", "Nagaraju1136@");

                // Check if the book is borrowed by the user
                String sqlCheck = "SELECT * FROM borrowed WHERE user_id = ? AND title = (SELECT title FROM Books WHERE book_id = ?)";
                PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
                psCheck.setString(1, userId);
                psCheck.setInt(2, Integer.parseInt(bookId));
                ResultSet rsCheck = psCheck.executeQuery();

                if (rsCheck.next()) {
                    String bookTitle = rsCheck.getString("title");

                    // Delete the entry from the borrowed table
                    String sqlDelete = "DELETE FROM borrowed WHERE user_id = ? AND title = ?";
                    PreparedStatement psDelete = conn.prepareStatement(sqlDelete);
                    psDelete.setString(1, userId);
                    psDelete.setString(2, bookTitle);
                    int i = psDelete.executeUpdate();

                    if (i > 0) {
                        // Update the availability status in the books table
                        String sqlUpdate = "UPDATE Books SET availability_status = 1 WHERE book_id = ?";
                        PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                        psUpdate.setInt(1, Integer.parseInt(bookId));
                        int j = psUpdate.executeUpdate();

                        if (j > 0) {
                            out.println("<p>The book <strong>" + bookTitle + "</strong> has been successfully returned by User ID: " + userId + ".</p>");
                        } else {
                            out.println("<p>Failed to update the book's availability status. Please try again.</p>");
                        }

                        psUpdate.close();
                    } else {
                        out.println("<p>Failed to remove the book from the borrowed list. Please try again.</p>");
                    }

                    psDelete.close();
                } else {
                    out.println("<p>No record found for the given User ID and Book ID. Please check your details and try again.</p>");
                }

                rsCheck.close();
                psCheck.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p>Please fill in all the fields.</p>");
        }
    }
    %>
</body>
</html>
