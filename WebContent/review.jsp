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

<script>
function validateForm() {
    alert("Thank you for your feedback!");
}
</script>

<ul>
  <li><a href="signin.html">Sign In</a></li>
  <li><a href="index.html">Registration</a></li>
  <li><a href="reservation.html">Reservation</a></li>
  <li><a href="statistics.html">Hotel Statistics</a></li>
</ul>

<h1>Please take a moment to write a review</h1>

<%
try{

Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

%>

<form name="revForm" method="POST" action="res_val.jsp" onsubmit="return validateForm()" >

<fieldset>
<legend>Select the Hotel you Visited:</legend>

Hotel (Street,City,State,Country,Zip):
<select name="hotel">

<%
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM HOTEL");

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
  	<option value="Standard">Standard</option>
  	<option value="Light Breakfast">Light Breakfast</option>
  	<option value="Continental">Continental</option>
  	<option value="Buffet">Buffet</option>
  	</select>
  <br>
  <input type="radio" name="rtype" value="Service"> Service: 
  	<select name="service">
  	<option value="Laundry">Laundry</option>
  	<option value="Massage">In Room Massage</option>
  	<option value="Food">In Room Food Delivery</option>
  	<option value="Movies">In Room Movies</option>
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