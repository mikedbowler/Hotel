<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
try{

	 Class.forName("com.mysql.jdbc.Driver").newInstance(); 

	 Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

	 Statement stmt = conn.createStatement();
	 ResultSet rs = null;
	 
	 PreparedStatement pstmt = conn.prepareStatement("DELETE FROM RoomReservation WHERE InvoiceNo=?"); 
	 pstmt.setInt(1,(Integer)session.getAttribute("InvoiceNo"));
	 pstmt.executeUpdate();
	 pstmt = conn.prepareStatement("DELETE FROM BreakfastReservation WHERE InvoiceNo=?"); 
	 pstmt.setInt(1,(Integer)session.getAttribute("InvoiceNo"));
	 pstmt.executeUpdate();
	 pstmt = conn.prepareStatement("DELETE FROM ServiceReservation WHERE InvoiceNo=?"); 
	 pstmt.setInt(1,(Integer)session.getAttribute("InvoiceNo"));
	 pstmt.executeUpdate();
	 
	//ClosetheStatement
	 pstmt.close();
	 // Close the Connection 
	 conn.close(); 
	 }catch(SQLException sqle){
	 	out.println(sqle.getMessage()); 
	 }catch(Exception e){ 
	 	out.println(e.getMessage());
	 }
%>

<script>
alert("Cancelation Successful!");
window.open("reservation.jsp","_self");
</script>

</body>
</html>