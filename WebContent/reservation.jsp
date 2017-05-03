<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Online Reservation</title>

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
	<!--This page will be our online reservation screen-->
	
<script>
function validateForm() {
	var chx = document.getElementsByTagName('input');
	
	var bool = false;
	for (var i=0; i<chx.length; i++) {
	    if (chx[i].type == 'radio' && chx[i].checked) {
	      bool = true;
	    } 
    }
	if(bool == false){
		alert("A radio button must be selected.");
		return false;
	}
}
function validateForm2() {
	var state = document.forms["searchForm"]["state"].value;
    var country = document.forms["searchForm"]["country"].value;
    
    if (state=="" && country=="") {
        alert("All fields cannot be empty!");
        return false;
    }
}
</script>

<ul>
  <li><a href="signin.html">Logout</a></li>
  <li><a href="update.jsp">Update User Info</a></li>
</ul>

<%
try{

Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

Statement stmt = conn.createStatement();

ResultSet rs = null;
if(request.getParameter("state") != "" && request.getParameter("state") != null && request.getParameter("country") != "" && request.getParameter("country") != null){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Hotel WHERE State=? and Country=?");
	pstmt.setString(1,request.getParameter("state"));
	pstmt.setString(2,request.getParameter("country"));
	rs = pstmt.executeQuery();
}
else if(request.getParameter("state") != "" && request.getParameter("state") != null){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Hotel WHERE State=?");
	pstmt.setString(1,request.getParameter("state"));
	rs = pstmt.executeQuery();
}
else if(request.getParameter("country") != "" && request.getParameter("country") != null){
	PreparedStatement pstmt=conn.prepareStatement("SELECT * FROM Hotel WHERE Country=?");
	pstmt.setString(1,request.getParameter("country"));
	rs = pstmt.executeQuery();
}
else
	rs = stmt.executeQuery("SELECT * from Hotel");
%>
<div align="center">
<h1>Choose a Hotel</h1>
<form name="resForm" method="POST" action="res_val.jsp" onsubmit="return validateForm()">
	<table>
	  <tr>
	    <th>Reserve</th>
	    <th>Street</th>
	    <th>City</th>
	    <th>State</th>
	    <th>Country</th>
	    <th>Zip</th>
	  </tr>
<% 
while(rs.next()){
	out.println("<tr><td><input type=\"radio\" name=\"radio\" value=\""+rs.getInt("HotelID")+"\"></td>");
	out.println("<td>"+rs.getString("Street")+"</td>");
	out.println("<td>"+rs.getString("City")+"</td>");
	out.println("<td>"+rs.getString("State")+"</td>");
	out.println("<td>"+rs.getString("Country")+"</td>");
	out.println("<td>"+rs.getString("ZIP")+"</td></tr>");
}
%>  
	</table>
   <input type="submit" value="Continue">
</form>
<br>
<form name="searchForm" method="POST" action="reservation.jsp" onsubmit="return validateForm2()">
   Search for: <br>
   State:
  <input type="text" name="state" placeholder="State">
   Country:
  <input type="text" name="country" placeholder="Country">
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