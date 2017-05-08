<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
    <%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Checkout</title>
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

<ul>
  <li><a href="signin.html">Logout</a></li>
  <li><a href="update.jsp">Update User Info</a></li>
  <li><a href="review.html">Write a Review</a></li>
</ul>

<body>
	<!--This page will be our online reservation screen-->
	
<script>
function validateForm() {
    var fname = document.forms["chkForm"]["firstname"].value;
    var lanme = document.forms["chkForm"]["lastname"].value;
    var addr = document.forms["chkForm"]["address"].value;
    var ccnum = document.forms["chkForm"]["cardnumber"].value;
    var sec = document.forms["chkForm"]["seccode"].value;
    
    if (fname=="" || lname=="" || addr=="" || ccnum=="" || sec=="") {
        alert("All fields must be filled out!");
        return false;
    }
    
}
</script>

<div align="center">
<h1>Additional Requests</h1>
<form name="checkoutForm" method="POST" action="checkout_val.jsp" onsubmit="return validateForm()">
 <%
 try{

 Class.forName("com.mysql.jdbc.Driver").newInstance(); 

 Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

 Statement stmt = conn.createStatement();
 ResultSet rs = null;

 Enumeration paramNames = request.getParameterNames();
 Integer hotelID = (Integer)session.getAttribute("hotelID");
 int counter = 0;
 while(paramNames.hasMoreElements()) {
   String paramName = (String)paramNames.nextElement();
   if(!paramName.contains("box")){
 	  break;
   }
   counter++;
   String paramValue = request.getParameter(paramName);
   int roomID = Integer.valueOf(paramValue);
   out.println("<input type=\"hidden\" name=\""+counter+"\" value=\""+roomID+"\">");
   
   out.println("<h2>Room "+roomID+"</h2>");
   
   PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and Room_no=?");
   pstmt.setInt(1,hotelID);
   pstmt.setInt(2,roomID); 
   rs = pstmt.executeQuery();
   rs.next();
   
   out.println("<h3>Type: "+rs.getString("Type")+"</h3>");
   out.println("<h3>Start Date: "+rs.getDate("SDate")+"</h3>");
   out.println("<h3>End Date: "+rs.getDate("EDate")+"</h3>");
   
   out.println("Start Date: <input type=\"date\" name=\"sDate"+counter+"\"> End Date: <input type=\"date\" name=\"eDate"+counter+"\"><br>");
   pstmt.close();
   
   pstmt=conn.prepareStatement("SELECT * FROM Breakfast WHERE HotelID=?");
   pstmt.setInt(1,hotelID);
   rs = pstmt.executeQuery();
   
   int bCounter = 0;
   out.println("<h3>Breakfasts:</h3>");
   while(rs.next()){
	   bCounter++;
	   out.println(rs.getString("bType")+" ($"+rs.getFloat("bPrice")+") Quantity: <input type=\"text\" name=\"bQuantity"+counter+"_"+bCounter+"\"><br>");
   }
   rs.close();
   pstmt.close();
   
   pstmt=conn.prepareStatement("SELECT * FROM Service WHERE HotelID=?");
   pstmt.setInt(1,hotelID);
   rs = pstmt.executeQuery();
   
   int sCounter = 0;
   out.println("<h3>Services:</h3>");
   while(rs.next()){
	   sCounter++;
	   out.println(rs.getString("sType")+" ($"+rs.getFloat("sCost")+") <input type=\"checkbox\" name=\"sQuantity"+counter+"_"+sCounter+"\"><br>");
   }
   rs.close();
   pstmt.close();
   
   out.println("<br><br>");  
}
session.setAttribute("numRooms", counter);
out.println("<input type=\"submit\" value=\"Confirm\">");
   
// Close the ResultSet 
//rs.close(); 
//ClosetheStatement
//pstmt.close();
// Close the Connection 
conn.close(); 
}catch(SQLException sqle){
	out.println(sqle.getMessage()); 
}catch(Exception e){ 
	out.println(e.getMessage());
}
%>
</form>
</div>

</body>
</html>