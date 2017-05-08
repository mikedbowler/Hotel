<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Checkout Validation</title>
</head>

<body>
<%
/*
*
*
*
This page has no visible content currently, just works behind the scenes.
*
*
*
*/
try{
Class.forName("com.mysql.jdbc.Driver").newInstance(); 
Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 
String fullname = request.getParameter("firstname").trim()+" "+request.getParameter("lastname").trim();
String address = request.getParameter("address").trim();
String ccNum = request.getParameter("cardnumber").trim();
String sec = request.getParameter("seccode").trim();
String type = request.getParameter("ctype");
String expDate = request.getParameter("expdate");
PreparedStatement pstmt = conn.prepareStatement("INSERT INTO CreditCard (Cnumber,Name,BillingAddr,SecCode,Type,ExpDate) VALUES (?,?,?,?,?,?)");
pstmt.setString(1, ccNum);
pstmt.setString(2, fullname);
pstmt.setString(3, address);
pstmt.setString(4, sec);
pstmt.setString(5, type);
pstmt.setString(6, expDate);
/*
If the customer did not have a credit card on file this will enter their 
information in the system. 
*/
boolean hasCC = ((Boolean) session.getAttribute("hasCC")).booleanValue();
if(!hasCC)
{
pstmt.execute();
%>
<script>
alert("Credit card information entered!");
</script>
<%
}

pstmt = conn.prepareStatement("INSERT INTO MakeReservation VALUES (?,?,?)");
pstmt.setInt(1, (Integer)session.getAttribute("CID"));
pstmt.setString(2, ccNum);
pstmt.setInt(3, (Integer)session.getAttribute("InvoiceNo"));
pstmt.executeUpdate();

%>
<script>
alert("Reservation Successful!");
window.open("reservation.jsp","_self");
</script>
<%


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
</body>
</html>