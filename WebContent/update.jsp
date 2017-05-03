<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Update Info</title>
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

<ul>
  <li><a href="reservation.jsp">Reserve a Room</a></li>
</ul>

<div align="center">

<script>
function validateForm() {
    var fname = document.forms["regForm"]["firstname"].value;
    var lname = document.forms["regForm"]["lastname"].value;
    var email = document.forms["regForm"]["email"].value;
    var phonenumber = document.forms["regForm"]["phonenumber"].value;
    var address = document.forms["regForm"]["address"].value;
    
    if (fname=="" || lname=="" || email=="" || phonenumber=="" || address=="") {
        alert("All fields must be filled out!");
        return false;
    }
}
</script>

<% 

try{
	
Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

Statement stmt = conn.createStatement();

String firstname = (String)session.getAttribute("firstName"); 
String lastname = (String)session.getAttribute("lastName"); 
String fullName = ((String)session.getAttribute("firstName")+" "+(String)session.getAttribute("lastName"));
String email = (String)session.getAttribute("email");

int CID = 0; String phone = null; String address = null;

ResultSet rs = stmt.executeQuery("SELECT * from Customer C");

while(rs.next())
{
	String name = rs.getString("Name");
	String phone2 = rs.getString("Phone_no");
	String address2 = rs.getString("Address");
	String email2 = rs.getString("Email");
	
	if(name.equals(fullName) && email2.equals(email))
	{
		CID = rs.getInt("CID");
		phone = phone2;
		address = address2;
		break;
	}
}

%>

<form name="regForm" method="post" action="update_val.jsp" onsubmit="return validateForm()">
  <input type="hidden" name="CID" value="<%=String.valueOf(CID)%>">
  First name:
  <input type="text" name="firstname" value="<%=firstname%>">
  <br>
  Last name:
  <input type="text" name="lastname" value="<%=lastname%>">
  <br>
  Email:
  <input type="email" name="email" value="<%=email%>">
  <br>
  Phone number:
  <input type="text" name="phonenumber" value="<%=phone%>">
  <br>
  Address:
  <input type="text" name="address" value="<%=address%>">
  <br><br>
  <input type="submit" value="Register">
</form> 

<%
//Close the ResultSet 
rs.close(); 
//ClosetheStatement
stmt.close();
//Close the Connection 
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