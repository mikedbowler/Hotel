<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*"%>
    <%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Reservation Validation</title>
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
</ul>

<body>

<script>
function validateForm() {
	var chx = document.getElementsByTagName('input');
	
	var bool = false;
	for (var i=0; i<chx.length; i++) {
	    if (chx[i].type == 'checkbox' && chx[i].checked) {
	      bool = true;
	    } 
    }
	if(bool == false){
		alert("A checkbox button must be selected.");
		return false;
	}
}
function validateForm2() {
	var type = document.forms["searchForm"]["type"].value;
    var sDate = document.forms["searchForm"]["sDate"].value;
    var eDate = document.forms["searchForm"]["eDate"].value;
    
    if (dates.compare(sDate,eDate)>0 && !sDate.equals("") && !eDate.equals("")) {
        alert("Start date must be before the end date!");
        return false;
    }
}
</script>

<%
try{

Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

Statement stmt = conn.createStatement();

Enumeration paramNames = request.getParameterNames();
Integer hotelID = 0;
while(paramNames.hasMoreElements()) {
   String paramName = (String)paramNames.nextElement();
   if(paramName.contains("radio")){
	   String paramValue = request.getParameter(paramName);
	   hotelID = Integer.valueOf(paramValue);
	   session.setAttribute("hotelID", hotelID);
	   break;
   }
}
hotelID = (Integer)session.getAttribute("hotelID");
boolean[] isParam = new boolean[3];
	if(request.getParameter("type") != null && !request.getParameter("type").equals("na"))
		isParam[0] = true;
	if(request.getParameter("sDate") != "" && request.getParameter("sDate") != null)
		isParam[1] = true;
	if(request.getParameter("eDate") != "" && request.getParameter("eDate") != null)
		isParam[2] = true;
	
ResultSet rs = null;
if(isParam[0] && isParam[1] && isParam[2]){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and Type=? and SDate<=? and EDate>=?");
	pstmt.setInt(1,hotelID);
	pstmt.setString(2,request.getParameter("type"));
	pstmt.setDate(3,java.sql.Date.valueOf(request.getParameter("sDate")));
	pstmt.setDate(4,java.sql.Date.valueOf(request.getParameter("eDate")));
	rs = pstmt.executeQuery();
}
else if(isParam[0] && isParam[1]){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and Type=? and SDate<=?");
	pstmt.setInt(1,hotelID);
	pstmt.setString(2,request.getParameter("type"));
	pstmt.setDate(3,java.sql.Date.valueOf(request.getParameter("sDate")));
	rs = pstmt.executeQuery();
}
else if(isParam[0] && isParam[2]){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and Type=? and EDate>=?");
	pstmt.setInt(1,hotelID);
	pstmt.setString(2,request.getParameter("type"));
	pstmt.setDate(3,java.sql.Date.valueOf(request.getParameter("eDate")));
	rs = pstmt.executeQuery();
}
else if(isParam[1] && isParam[2]){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and SDate<=? and EDate>=?");
	pstmt.setInt(1,hotelID);
	pstmt.setDate(2,java.sql.Date.valueOf(request.getParameter("sDate")));
	pstmt.setDate(3,java.sql.Date.valueOf(request.getParameter("eDate")));
	rs = pstmt.executeQuery();
}
else if(isParam[0]){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and Type=?");
	pstmt.setInt(1,hotelID);
	pstmt.setString(2,request.getParameter("type"));
	rs = pstmt.executeQuery();
}
else if(isParam[1]){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and SDate<=?");
	pstmt.setInt(1,hotelID);
	pstmt.setDate(2,java.sql.Date.valueOf(request.getParameter("sDate")));
	rs = pstmt.executeQuery();
}
else if(isParam[2]){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and EDate>=?");
	pstmt.setInt(1,hotelID);
	pstmt.setDate(2,java.sql.Date.valueOf(request.getParameter("eDate")));
	rs = pstmt.executeQuery();
}
else {
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Room WHERE HotelID=?");
	pstmt.setInt(1,hotelID);
	rs = pstmt.executeQuery();
}

%>
<div align="center">
<h1>Reserve Rooms</h1>
<form name="resForm" method="POST" action="res_val.jsp" onsubmit="return validateForm()">
	<table>
	  <tr>
	    <th>Reserve</th>
	    <th>Room_no</th>
	    <th>Price</th>
	    <th>Capacity</th>
	    <th>Floor_no</th>
	    <th>Description</th>
	    <th>Type</th>
	    <th>SDate</th>
	    <th>EDate</th>
	    <th>Discount</th>
	  </tr>
<% 
while(rs.next()){
	out.println("<tr><td><input type=\"checkbox\" name=\"box\" value=\""+rs.getInt("Room_no")+"\"></td>");
	out.println("<td>"+rs.getInt("Room_no")+"</td>");
	out.println("<td>$"+rs.getInt("Price")+"</td>");
	out.println("<td>"+rs.getInt("Capacity")+"</td>");
	out.println("<td>"+rs.getInt("Floor_no")+"</td>");
	out.println("<td>"+rs.getString("Description")+"</td>");
	out.println("<td>"+rs.getString("Type")+"</td>");
	out.println("<td>"+rs.getDate("SDate")+"</td>");
	out.println("<td>"+rs.getDate("EDate")+"</td>");
	out.println("<td>"+rs.getFloat("Discount")+"</td></tr>");
}
%>  
	</table>
   <input type="submit" value="Continue">
</form>
<br>
<form name="searchForm" method="POST" action="res_val.jsp" onsubmit="return validateForm2()">
   Search for: <br>
   Room Type:
  <select name="type">
    <option value="na"></option>
    <option value="Single">Single</option>
    <option value="Double">Double</option>
    <option value="Suite">Suite</option>
  </select>
   Start Date:
  <input type="date" name="sDate">
   End Date:
  <input type="date" name="eDate">
  <br>
  <br>
  <input type="submit" value="Search">
  
</form>

<%
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

</div>

</body>
</html>