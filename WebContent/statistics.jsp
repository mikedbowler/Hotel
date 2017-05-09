<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: #333333;
}

li {
    float: left;
}

li a {
    display: block;
    color: white;
    text-align: center;
    padding: 16px;
    text-decoration: none;
}

li a:hover {
    background-color: #111111;
}
</style>
<title>Insert title here</title>
</head>

<ul>
  <li><a href="signin.html">Logout</a></li>
</ul>

<body>

<%
try{

Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

Statement stmt = conn.createStatement();

ResultSet rs = null;

out.println("<h2>Highest Rated Room Types:</h2><br>");

PreparedStatement pstmt=conn.prepareStatement("SELECT T3.HotelID, T3.Type FROM (SELECT max(T1.sum) max, T1.HotelID FROM (SELECT sum(rr.Rating) sum, r.HotelID, r.Type FROM Room r JOIN RoomReview rr on r.HotelID=rr.HotelID and r.Room_no=rr.Room_no WHERE rr.DateSubmitted>=? and rr.DateSubmitted<=? GROUP BY r.HotelID, r.Type) T1 GROUP BY T1.HotelID) T2 JOIN (SELECT sum(rr.Rating) sum, r.HotelID, r.Type FROM Room r JOIN RoomReview rr on r.HotelID=rr.HotelID and r.Room_no=rr.Room_no WHERE rr.DateSubmitted>=? and rr.DateSubmitted<=? GROUP BY r.HotelID, r.Type) T3 on T2.HotelID=T3.HotelID and T2.max=T3.sum;");
pstmt.setDate(1,java.sql.Date.valueOf(request.getParameter("in")));
pstmt.setDate(2,java.sql.Date.valueOf(request.getParameter("out")));
pstmt.setDate(3,java.sql.Date.valueOf(request.getParameter("in")));
pstmt.setDate(4,java.sql.Date.valueOf(request.getParameter("out")));
rs = pstmt.executeQuery();

%>

<table border="1">
<tr>
<th>
HotelID
</th>
<th>
Best Room Type
</th>
</tr>

<% 

while(rs.next()){
	out.println("<tr><td>"+rs.getInt("HotelID")+"</td><td>"+rs.getString("Type")+"</td></tr>");
}

%>

</table>
<br>
<h2>Top 5 Customers</h2>
<table border="1">
<tr>
<th>
Customer Name
</th>
<th>
Total Spent
</th>
</tr>

<%

pstmt=conn.prepareStatement("SELECT c.name, T1.totalSpent FROM (SELECT mr.CID, sum(TotalAmt) totalSpent FROM Reservation r, MakeReservation mr WHERE r.InvoiceNo = mr.InvoiceNo AND r.ResDate>=? AND r.ResDate<=? GROUP BY mr.CID ) T1, Customer c WHERE c.CID = T1.CID ORDER BY T1.totalSpent DESC LIMIT 5;");
pstmt.setDate(1,java.sql.Date.valueOf(request.getParameter("in")));
pstmt.setDate(2,java.sql.Date.valueOf(request.getParameter("out")));
rs = pstmt.executeQuery();

while(rs.next()){
	out.println("<tr><td>"+rs.getString("name")+"</td><td>"+rs.getFloat("totalSpent")+"</td></tr>");
}

%>
</table><br>

<h2>Best Breakfast Type:</h2><br>

<%
rs.close();
pstmt=conn.prepareStatement("SELECT T1.bType FROM (SELECT SUM(bR.rating) sum, bR.bType FROM breakfastReview bR  WHERE bR.dateSubmitted>=? AND bR.dateSubmitted<=? GROUP BY bR.bType) T1 WHERE T1.sum=(SELECT max(T2.sum) FROM (SELECT SUM(bR.rating) sum, bR.bType FROM breakfastReview bR  WHERE bR.dateSubmitted>=? AND bR.dateSubmitted<=? GROUP BY bR.bType) T2);");
pstmt.setDate(1,java.sql.Date.valueOf(request.getParameter("in")));
pstmt.setDate(2,java.sql.Date.valueOf(request.getParameter("out")));
pstmt.setDate(3,java.sql.Date.valueOf(request.getParameter("in")));
pstmt.setDate(4,java.sql.Date.valueOf(request.getParameter("out")));
rs = pstmt.executeQuery();
if(rs.next()){
	out.println(rs.getString("bType"));
}
else{
	out.println("N/A");
}
%>
<br>
<h2>Best Service:</h2><br>

<%
rs.close();
pstmt=conn.prepareStatement("SELECT T1.sType FROM (SELECT SUM(sR.rating) sum, sR.sType FROM ServiceReview sR  WHERE sR.dateSubmitted>=? AND sR.dateSubmitted<=? GROUP BY sR.sType) T1 WHERE T1.sum=(SELECT max(T2.sum) FROM (SELECT SUM(sR.rating) sum, sR.sType FROM ServiceReview sR  WHERE sR.dateSubmitted>=? AND sR.dateSubmitted<=? GROUP BY sR.sType) T2);");
pstmt.setDate(1,java.sql.Date.valueOf(request.getParameter("in")));
pstmt.setDate(2,java.sql.Date.valueOf(request.getParameter("out")));
pstmt.setDate(3,java.sql.Date.valueOf(request.getParameter("in")));
pstmt.setDate(4,java.sql.Date.valueOf(request.getParameter("out")));
rs = pstmt.executeQuery();
if(rs.next()){
	out.println(rs.getString("sType"));
}
else{
	out.println("N/A");
}

/*
<p>
This information will be dynamically placed, once the database is queried<br>

1. For a given time period (begin date and end date) compute the highest rated room type for each hotel.<br>
	SELECT T3.HotelID, T3.Type FROM (SELECT max(T1.sum) max, T1.HotelID FROM (SELECT sum(rr.Rating) sum, r.HotelID, r.Type FROM Room r JOIN RoomReview rr on r.HotelID=rr.HotelID and r.Room_no=rr.Room_no WHERE rr.DateSubmitted>=? and rr.DateSubmitted<=? GROUP BY r.HotelID, r.Type) T1 GROUP BY T1.HotelID) T2 JOIN (SELECT sum(rr.Rating) sum, r.HotelID, r.Type FROM Room r JOIN RoomReview rr on r.HotelID=rr.HotelID and r.Room_no=rr.Room_no WHERE rr.DateSubmitted>=? and rr.DateSubmitted<=? GROUP BY r.HotelID, r.Type) T3 on T2.HotelID=T3.HotelID and T2.max=T3.sum;

2. For a given time period (begin date and end date) compute the 5 best customers (in terms of money spent in reservations).<br>
	SELECT c.name, T1.totalSpent
	FROM (SELECT CID, sum(TotalAmt) totalSpent
          FROM Reservation r, MakeReservation mr
          WHERE r.InvoiceNo = mr.InvoiceNo
		   AND r.ResDate > '2009-01-01'
           AND r.ResDate < '2011-11-01'
          GROUP BY mr.CID ) T1, Customer c
    WHERE c.CID = T1.CID
    ORDER BY T1.totalSpent DESC
    LIMIT 5;
	
3. For a given time period (begin date and end date) compute the highest rated breakfast type across all hotels.<br>
	SELECT T2.bType
    FROM( SELECT MAX(T1.sum), T1.bType
	      FROM (SELECT SUM(bR.rating) sum, bR.bType
		        FROM breakfastReview bR 
		        WHERE bR.dateSubmitted > '2009-01-01'
			      AND bR.dateSubmitted < '2015-05-01'
		        GROUP BY bR.bType) T1) T2;
								
4. For a given time period (begin date and end date) compute the highest rated service type across all hotels.
	SELECT T2.sType
	FROM( SELECT MAX(T1.sum), T1.sType
	      FROM (SELECT SUM(sR.rating) sum, sR.sType
		        FROM serviceReview sR 
			    WHERE sR.dateSubmitted > '2009-01-01' 
			      AND sR.dateSubmitted < '2015-05-01'
		        GROUP BY sR.sType) T1) T2;
				
</p>
*/

// Close the ResultSet 
rs.close(); 
//ClosetheStatement
stmt.close();
// Close the Connection 
conn.close(); 

}catch(SQLException sqle){
	out.println(sqle.getMessage()); 
}catch(Exception e){ 
	out.println(e.getMessage());
}
%>

</body>
</html>