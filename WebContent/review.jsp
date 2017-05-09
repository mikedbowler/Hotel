<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Review</title>

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

input {

margin: 5px 0px 5px 0px;

}

</style>

</head>
<body>

<%
try{

Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

ResultSet rs=null;
%>

<script>
function validateForm() {
	
	var room_no = document.forms["revForm"]["room_no"].value;
	var rtype = document.forms["revForm"]["rtype"].value;

	if(room_no=="" && rtype=="Room")
	{
		alert("Must enter room number for a room review!")
		return false;
	}

}
</script>

<ul>
  <li><a href="signin.html">Logout</a></li>
  <li><a href="reservation.jsp">Reserve a Room</a></li>
  <li><a href="update.jsp">Update User Info</a></li>
</ul>

<h1>Please take a moment to write a review</h1>

<form name="revForm" method="POST" action="rev_val.jsp" onsubmit="return validateForm()" >

<fieldset>
<legend>Select the Hotel you Visited:</legend>

Hotel (Street,City,State,Country,Zip):
<select name="hotel">

<%
Statement stmt = conn.createStatement();
rs = stmt.executeQuery("SELECT * FROM HOTEL");

//Populate drop down list to allow cutomer to select the hotel they stayed at.
while(rs.next())
{
	%>
	<option value="<%=rs.getString("HotelID")%>"><%=rs.getString("Street")+", "+rs.getString("City")+", "+rs.getString("State")+", "+rs.getString("Country")+", "+rs.getString("ZIP")%></option>
	<%
}

%>

</select>

</fieldset>

<fieldset>
  	<legend>Select Review Type:</legend>
  		
  <input type="radio" name="rtype" value="Room" checked> Room:
  <input type="text" name="room_no" maxlength="3" placeholder="Enter Room Number">
  <br>
  <input type="radio" name="rtype" value="Breakfast"> Breakfast: 
  	<select name="breakfast">
<%
stmt = conn.createStatement();
rs = stmt.executeQuery("SELECT * FROM Breakfast");

//Populate drop down list to allow cutomer to select the breakfast they ordered.
while(rs.next())
{
	%>
	<option value="<%=rs.getString("bType")%>"><%=rs.getString("bType")%></option>
	<%
}

%>

</select>
  <br>
  <input type="radio" name="rtype" value="Service"> Service: 
  	<select name="service">
 <%
stmt = conn.createStatement();
rs = stmt.executeQuery("SELECT * FROM Service");

//Populate drop down list to allow cutomer to select the service they ordered.
while(rs.next())
{
	%>
	<option value="<%=rs.getString("sType")%>"><%=rs.getString("sType")%></option>
	<%
}

%>

</select>
  	</select>	
  <br>
</fieldset>
  
<fieldset>
<legend>Comments:</legend>

<textarea name="comments" rows="3" cols="30" maxlength="100" placeholder="Please tell us about your stay."></textarea>

</fieldset>

<fieldset>
<legend>Rating:</legend>

<input type="radio" name="rating" value="1"> 1
<input type="radio" name="rating" value="2"> 2 
<input type="radio" name="rating" value="3" checked> 3 
<input type="radio" name="rating" value="4"> 4
<input type="radio" name="rating" value="5"> 5


</fieldset>
<br>
<input type="submit" value="Submit Review">

</form>
<%
// Close the ResultSet 
rs.close(); 
//Close the Statement
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