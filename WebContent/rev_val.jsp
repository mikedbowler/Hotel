<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Review Validation</title>

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

</head>
<body>

<ul>
  <li><a href="signin.html">Logout</a></li>
  <li><a href="reservation.jsp">Reserve a Room</a></li>
  <li><a href="update.jsp">Update User Info</a></li>
</ul>

<h1>Thank You! Your Feedback is Appreciated!</h1>

<%
try{

Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

ResultSet rs=null;

PreparedStatement pstmt=null;

String fullname=session.getAttribute("firstName")+" "+session.getAttribute("lastName");
String cid="";
pstmt = conn.prepareStatement("SELECT CID FROM Customer c WHERE c.Name=? ");
pstmt.setString(1,fullname);
rs=pstmt.executeQuery();

if(rs.next())
{
	cid = rs.getString("CID");
}


String hotel = request.getParameter("hotel");
String rType = request.getParameter("rtype");
String comments = request.getParameter("comments");
String rating = request.getParameter("rating");
String room_no="";
String bType="";
String sType="";

if(rType.equals("Room"))
{
	room_no=request.getParameter("room_no");
	pstmt = conn.prepareStatement("SELECT * FROM (SELECT rr.InvoiceNo, rr.Room_no, rr.HotelID, mr.CID FROM RoomReservation rr JOIN MakeReservation mr ON rr.InvoiceNo=mr.InvoiceNo) t1 WHERE t1.HotelID=? AND t1.Room_no=? AND t1.CID=(SELECT CID FROM Customer c WHERE c.Name=? );");
	pstmt.setString(1, hotel);
	pstmt.setString(2, room_no);
	pstmt.setString(3, fullname);
	rs=pstmt.executeQuery();
	
	if(rs.next())
	{
		pstmt = conn.prepareStatement("SELECT * FROM RoomReview rr WHERE rr.Room_no=? AND rr.HotelID=? AND rr.CID=?");
		pstmt.setString(1,room_no);
		pstmt.setString(2,hotel);
		pstmt.setString(3,cid);
		rs=pstmt.executeQuery();
		
		if(!rs.next())
		{
		pstmt = conn.prepareStatement("INSERT INTO RoomReview (Room_no,HotelID,CID,Rating,TextComment,DateSubmitted) VALUES (?,?,?,?,?,current_date())");
		pstmt.setString(1, room_no);
		pstmt.setString(2, hotel);
		pstmt.setString(3, cid);
		pstmt.setString(4, rating);
		pstmt.setString(5, comments);
		pstmt.executeUpdate();
		}
		else
		{
			rs.close();
			pstmt.close();
			%>
			<script>
			window.open("review.jsp","_self")
		
			alert("Cannot write another review for the same room!")
			</script>
			<%
		}
	}
	else
	{
		rs.close();
		pstmt.close();
		%>
		<script>
		window.open("review.jsp","_self")
	
		alert("Invalid, please ensure Hotel and Room number match your reservation!")
		</script>
		<%
	}
	
}
else if(rType.equals("Breakfast"))
{
	bType=request.getParameter("breakfast");
	pstmt = conn.prepareStatement("SELECT * FROM (SELECT br.InvoiceNo, br.bType, br.HotelID, mr.CID FROM BreakfastReservation br JOIN MakeReservation mr ON br.InvoiceNo=mr.InvoiceNo) t1 WHERE t1.HotelID=? AND t1.bType=? AND t1.CID=?");
	pstmt.setString(1, hotel);
	pstmt.setString(2, bType);
	pstmt.setString(3, cid);
	rs=pstmt.executeQuery();
	
	if(rs.next())
	{
		pstmt = conn.prepareStatement("SELECT * FROM BreakfastReview br WHERE br.bType=? AND br.HotelID=? AND br.CID=?");
		pstmt.setString(1,bType);
		pstmt.setString(2,hotel);
		pstmt.setString(3,cid);
		rs=pstmt.executeQuery();
		
		if(!rs.next())
		{
		pstmt = conn.prepareStatement("INSERT INTO BreakfastReview (bType,HotelID,CID,Rating,TextComment,DateSubmitted) VALUES (?,?,?,?,?,current_date())");
		pstmt.setString(1, bType);
		pstmt.setString(2, hotel);
		pstmt.setString(3, cid);
		pstmt.setString(4, rating);
		pstmt.setString(5, comments);
		pstmt.executeUpdate();
		}
		else
		{
			rs.close();
			pstmt.close();
			%>
			<script>
			window.open("review.jsp","_self")
		
			alert("Cannot write another review for the same breakfast!")
			</script>
			<%
		}
	}
	else
	{
		rs.close();
		pstmt.close();
		%>
		<script>
		window.open("review.jsp","_self")
	
		alert("Invalid, please ensure Hotel and Breakfast type match your reservation!")
		</script>
		<%
	}
}
else if(rType.equals("Service"))
{
	sType=request.getParameter("service");
	pstmt = conn.prepareStatement("SELECT * FROM (SELECT sr.InvoiceNo, sr.sType, sr.HotelID, mr.CID FROM ServiceReservation sr JOIN MakeReservation mr ON sr.InvoiceNo=mr.InvoiceNo) t1 WHERE t1.HotelID=? AND t1.sType=? AND t1.CID=?");
	pstmt.setString(1, hotel);
	pstmt.setString(2, sType);
	pstmt.setString(3, cid);
	rs=pstmt.executeQuery();
	
	if(rs.next())
	{
		pstmt = conn.prepareStatement("SELECT * FROM ServiceReview sr WHERE sr.sType=? AND sr.HotelID=? AND sr.CID=?");
		pstmt.setString(1,sType);
		pstmt.setString(2,hotel);
		pstmt.setString(3,cid);
		rs=pstmt.executeQuery();
		
		if(!rs.next())
		{
		pstmt = conn.prepareStatement("INSERT INTO ServiceReview (sType,HotelID,CID,Rating,TextComment,DateSubmitted) VALUES (?,?,?,?,?,current_date())");
		pstmt.setString(1, sType);
		pstmt.setString(2, hotel);
		pstmt.setString(3, cid);
		pstmt.setString(4, rating);
		pstmt.setString(5, comments);
		pstmt.executeUpdate();
		}
		else
		{
			rs.close();
			pstmt.close();
			%>
			<script>
			window.open("review.jsp","_self")
		
			alert("Cannot write another review for the same service!")
			</script>
			<%
		}
	}
	else
	{
		rs.close();
		pstmt.close();
		%>
		<script>
		window.open("review.jsp","_self")
	
		alert("Invalid, please ensure Hotel and Service type match your reservation!")
		</script>
		<%
	}
}


// Close the ResultSet 
rs.close(); 
//Close the Statement
pstmt.close();
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