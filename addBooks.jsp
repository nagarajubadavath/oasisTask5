<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Books</title>
</head>
<body>
    <form name="form1" action="addBooks.jsp" method="post">
        <label for="bookid">Book Id:</label>
        <input type="number" name="bookid" placeholder="Enter book Id" required>
        <br>
        <label for="title">Title:</label>
        <input type="text" name="title" placeholder="Enter book title" required>
        <br>
        <label for="author">Author:</label>
        <input type="text" name="author" placeholder="Enter author name" required>
        <br>
        <label for="isbn">ISBN:</label>
        <input type="text" name="isbn" placeholder="Enter ISBN number" required>
        <br>
        <label for="category">Category:</label>
        <input type="text" name="category" placeholder="Enter book category" required>
        <br>
        <label for="status">Available Status:</label>
        <input type="text" name="status" placeholder="Enter 1 (available) or 0 (not available)" required>
        <br>
        <input type="submit" value="Insert">
    </form>
</body>
</html>


<%@page import="java.sql.*,java.util.*"%>
<%
String bookid = request.getParameter("bookid");
String title = request.getParameter("title");
String author = request.getParameter("author");
String isbn = request.getParameter("isbn");
String category = request.getParameter("category");
String status = request.getParameter("status");

// Validate the input parameters
if (bookid == null || bookid.isEmpty() || title == null || title.isEmpty() ||
    author == null || author.isEmpty() || isbn == null || isbn.isEmpty() ||
    category == null || category.isEmpty() || status == null || status.isEmpty()) {
    
    out.println("<html><body>");
    out.println("<h2>Please fill in all the fields.</h2>");
    out.println("<a href='addBooks.jsp'>Go back</a>");
    out.println("</body></html>");
} else {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "raju", "Nagaraju1136@");

        String sql = "INSERT INTO Books (book_id, title, author, isbn, category,availability_status) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement pst = conn.prepareStatement(sql);
        pst.setInt(1, Integer.parseInt(bookid));
        pst.setString(2, title);
        pst.setString(3, author);
        pst.setString(4, isbn);
        pst.setString(5, category);
        pst.setString(6, status);
        
        int i = pst.executeUpdate();
        if(i > 0) {
            out.println("inserted successfully");
        } else {
            out.println("<b>Insertion failed. Please try again.</b>");
        }
        pst.close();
        conn.close();
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>
