<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Checkout</title>
<style>
ul.header {
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
	
<%
try{

Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

//Boolean flag to tell the next page if credit card info is on file or not
boolean hasCC = false;
session.setAttribute("hasCC",hasCC);
%>
	
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

<ul class="header">
  <li><a href="signin.html">Sign In</a></li>
  <li><a href="index.html">Registration</a></li>
  <li><a href="reservation.html">Reservation</a></li>
  <li><a href="review.html">Review</a></li>
</ul>

 <%
    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM CreditCard c WHERE c.name=?");
    pstmt.setString(1, session.getAttribute("firstname")+" "+session.getAttribute("lastname"));
   	ResultSet rs = pstmt.executeQuery();
    
    String[] name={"",""};
	String fname="";
	String lname="";
	String address="";
	String cardnumber="";
	String seccode="";
	String cType="";
	String expdate="";
    
    if(rs.next())
    {
    	//Prefill out all of the customer's information in the boxes
    	//if they have a credit card on file with us already
    	name = rs.getString("Name").split(" ");
    	fname=name[0];
    	lname=name[1];
    	address=rs.getString("BillingAddr");
    	cardnumber=rs.getString("Cnumber");
    	seccode=rs.getString("SecCode");
    	cType=rs.getString("Type");
    	expdate=rs.getString("ExpDate");
    	
    	hasCC=true;
    	session.setAttribute("hasCC",hasCC);
    	%>
    	<script>
    	alert("Credit card information is on file!");
    	</script>
    	<%
    }

 %>

<form name="chkForm" method="POST" action="checkout_val.jsp" onsubmit="return validateForm()" >
 <fieldset>
 	
 	<legend>Transaction Summary:</legend>
 	 	
 <!--Will add code to display total amount later-->
 	<p>Total Amount:</p>

 </fieldset>
 
 <fieldset>
 	<legend>Credit Card Information:</legend>
 	
 	First name:
  	<input type="text" name="firstname" value=<%= fname%> placeholder="First&nbsp;Name">
  	<br>
  	Last name:
  	<input type="text" name="lastname" value=<%= lname%> placeholder="Last&nbsp;Name">
  	<br>
  	Billing Address:
 	<input type="text" maxlength="60" name="address" value="<%= address%>" placeholder="Street,City,State,Zip">
  	<br>
  	Card number:
  	<input type="text" name="cardnumber" value=<%= cardnumber%> placeholder="Card Number">
  	<br>
  	Security Code:
  	<input type="text" name="seccode" value=<%= seccode%> placeholder="Security Code">
  	<br>
  	Type:
  	<select name="ctype">
  	<option value="MasterCard">MasterCard</option>
  	<option value="Visa">Visa</option>
  	<option value="Discover">Discover</option>
	</select>
	<br>
	Expiration Date:
	<input type="date" value=<%= expdate%> name="expdate">
 </fieldset>
 <br>
 <input type="submit" value="Reserve Now">
</form>


<%
// Close the ResultSet 
rs.close(); 
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