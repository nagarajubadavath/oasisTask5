<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borrow a Book</title>
</head>
<body>
    <h2>Borrow a Book</h2>
    <form action="BorrowBooks.jsp" method="post">
        <label for="user_id">User ID:</label>
        <input type="text" name="user_id" placeholder="Enter your User ID" required>
        <br><br>
        <label for="book_id">Book ID:</label>
        <input type="number" name="book_id" placeholder="Enter the Book ID you want to borrow" required>
        <br><br>
        <input type="submit" value="Borrow Book">
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

                // SQL query to get the book title based on book_id from the books table
                String sqlBook = "SELECT title FROM Books WHERE book_id = ?";
                PreparedStatement psBook = conn.prepareStatement(sqlBook);
                psBook.setInt(1, Integer.parseInt(bookId));
                ResultSet rsBook = psBook.executeQuery();

                if (rsBook.next()) {
                    String bookTitle = rsBook.getString("title");

                    // SQL query to insert the borrowing information into the borrowed table
                    String sqlInsert = "INSERT INTO borrowed (user_id, title) VALUES (?, ?)";
                    PreparedStatement psInsert = conn.prepareStatement(sqlInsert);

                    psInsert.setString(1, userId);
                    psInsert.setString(2, bookTitle);

                    int i = psInsert.executeUpdate();
                    if (i > 0) {
                        out.println("<p>The book <strong>" + bookTitle + "</strong> has been successfully borrowed by User ID: " + userId + ".</p>");
                    } else {
                        out.println("<p>Failed to borrow the book. Please try again.</p>");
                    }

                    psInsert.close();
                } else {
                    out.println("<p>No book found with ID " + bookId + ". Please check the ID and try again.</p>");
                }

                rsBook.close();
                psBook.close();
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
