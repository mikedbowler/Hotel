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

<ul class="header">
  <li><a href="signin.html">Logout</a></li>
  <li><a href="reservation.html">Reservation</a></li>
  <li><a href="review.html">Review</a></li>
</ul>
 
 <%
 try{

 Class.forName("com.mysql.jdbc.Driver").newInstance(); 

 Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

 Statement stmt = conn.createStatement();
 ResultSet rs = null;
 
 Integer hotelID = (Integer)session.getAttribute("hotelID");
 Integer numRooms = (Integer)session.getAttribute("numRooms");
 
 PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Breakfast WHERE HotelID=?"); 
 pstmt.setInt(1,hotelID);
 rs = pstmt.executeQuery();
 int numBreakfasts = 0;
 while(rs.next())
	 numBreakfasts++;
 rs.close();
 
 pstmt = conn.prepareStatement("SELECT * FROM Service WHERE HotelID=?"); 
 pstmt.setInt(1,hotelID);
 rs = pstmt.executeQuery();
 int numServices = 0;
 while(rs.next())
	 numServices++;
 rs.close();
 
float totalPrice = 0;
 
 for(int i = 1; i <= numRooms; i++){
	 Integer roomID = Integer.parseInt(request.getParameter(String.valueOf(i)));
	 pstmt = conn.prepareStatement("SELECT * FROM Room WHERE HotelID=? and Room_no=?"); 
	 pstmt.setInt(1,hotelID); 
	 pstmt.setInt(2,roomID);
	 rs = pstmt.executeQuery();
	 rs.next();
	 totalPrice += rs.getInt("Price")*(1.0-rs.getFloat("Discount"));
	 rs.close();
	 
	 pstmt = conn.prepareStatement("SELECT * FROM Breakfast WHERE HotelID=?"); 
	 pstmt.setInt(1,hotelID); 
	 rs = pstmt.executeQuery();
	 for(int j = 1; j <= numBreakfasts; j++){
		 rs.next();
		 if(request.getParameter("bQuantity"+i+"_"+j)!="" && request.getParameter("bQuantity"+i+"_"+j)!=null)
		 	totalPrice += rs.getFloat("bPrice") * Integer.parseInt(request.getParameter("bQuantity"+i+"_"+j));
	 }
	 rs.close();
	 
	 pstmt = conn.prepareStatement("SELECT * FROM Service WHERE HotelID=?"); 
	 pstmt.setInt(1,hotelID); 
	 rs = pstmt.executeQuery();
	 for(int j = 1; j <= numServices; j++){
		 rs.next();
		 if(request.getParameter("sQuantity"+i+"_"+j)!="" && request.getParameter("sQuantity"+i+"_"+j)!=null)
		 	totalPrice += rs.getFloat("sCost");
	 }
 }
 
 pstmt = conn.prepareStatement("INSERT INTO Reservation VALUES (null,?,?)"); 
 pstmt.setDate(1,new java.sql.Date(System.currentTimeMillis())); 
 pstmt.setFloat(2,totalPrice); 
 pstmt.executeUpdate();
 
 
 pstmt = conn.prepareStatement("SELECT max(InvoiceNo) max FROM Reservation"); 
 rs = pstmt.executeQuery();
 rs.next();
 int invoiceNo = rs.getInt("max");
 rs.close();
 
 int[] breakfastQuantity = new int[numBreakfasts];
 boolean[] serviceQuantity = new boolean[numServices];
 
 for(int i = 1; i <= numRooms; i++){
	 Integer roomID = Integer.parseInt(request.getParameter(String.valueOf(i)));
	 pstmt = conn.prepareStatement("INSERT INTO RoomReservation VALUES (?,?,?,?,?)"); 
	 pstmt.setInt(1,invoiceNo); 
	 pstmt.setInt(2,roomID);
	 pstmt.setInt(3,hotelID);
	 pstmt.setDate(4,java.sql.Date.valueOf(request.getParameter("sDate"+i)));
	 pstmt.setDate(5,java.sql.Date.valueOf(request.getParameter("eDate"+i)));
	 pstmt.executeUpdate();
	 
	 for(int j = 1; j <= numBreakfasts; j++){
		 if(request.getParameter("bQuantity"+i+"_"+j)!="" && request.getParameter("bQuantity"+i+"_"+j)!=null)
			 breakfastQuantity[j-1] += Integer.parseInt(request.getParameter("bQuantity"+i+"_"+j));
	 }
	 for(int j = 1; j <= numServices; j++){
		 if(request.getParameter("sQuantity"+i+"_"+j)!="" && request.getParameter("sQuantity"+i+"_"+j)!=null)
			 serviceQuantity[j-1] = true;
	 }
 }
 pstmt = conn.prepareStatement("SELECT * FROM Breakfast WHERE HotelID=?"); 
 pstmt.setInt(1,hotelID); 
 rs = pstmt.executeQuery();
 for(int i = 1; i <= numBreakfasts; i++){
	 rs.next();
	 if(breakfastQuantity[i-1] != 0){
		 pstmt = conn.prepareStatement("INSERT INTO BreakfastReservation VALUES (?,?,?,?)"); 
		 pstmt.setInt(1,invoiceNo); 
		 pstmt.setString(2,rs.getString("bType")); 
		 pstmt.setInt(3,hotelID);
		 pstmt.setInt(4,breakfastQuantity[i-1]);
		 pstmt.executeUpdate();
	 }
 }
 rs.close();
 
 pstmt = conn.prepareStatement("SELECT * FROM Service WHERE HotelID=?"); 
 pstmt.setInt(1,hotelID); 
 rs = pstmt.executeQuery();
 for(int i = 1; i <= numServices; i++){
	 rs.next();
	 if(serviceQuantity[i-1]){
		 pstmt = conn.prepareStatement("INSERT INTO ServiceReservation VALUES (?,?,?)"); 
		 pstmt.setInt(1,invoiceNo); 
		 pstmt.setString(2,rs.getString("sType")); 
		 pstmt.setInt(3,hotelID);
		 pstmt.executeUpdate();
	 }
 }
 
 session.setAttribute("InvoiceNo", invoiceNo);
//Boolean flag to tell the next page if credit card info is on file or not
boolean hasCC = false;
session.setAttribute("hasCC",hasCC);
 
 pstmt = conn.prepareStatement("SELECT * FROM CreditCard c WHERE c.name=?");
 pstmt.setString(1, session.getAttribute("firstName")+" "+session.getAttribute("lastName"));
 rs = pstmt.executeQuery();
 
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

<form name="chkForm" method="POST" action="confirm.jsp" onsubmit="return validateForm()" >
<fieldset>
	
	<legend>Transaction Summary:</legend>
<% 	 	
pstmt = conn.prepareStatement("SELECT * FROM Reservation r WHERE r.InvoiceNo=?");
pstmt.setInt(1, (Integer)session.getAttribute("InvoiceNo"));
rs = pstmt.executeQuery();
String totalAmount="0.00";
if(rs.next())
{
	totalAmount=rs.getString("TotalAmt");
}
%>
	<p>Total Amount: $<%=totalAmount%></p>

</fieldset>

<fieldset>
	<legend>Credit Card Information:</legend>
	
	First name:
	<input type="text" name="firstname" value="<%= fname%>" placeholder="First&nbsp;Name">
	<br>
	Last name:
	<input type="text" name="lastname" value="<%= lname%>" placeholder="Last&nbsp;Name">
	<br>
	Billing Address:
	<input type="text" maxlength="60" name="address" value="<%= address%>" placeholder="Street,City,State,Zip">
	<br>
	Card number:
	<input type="text" name="cardnumber" value="<%= cardnumber%>" placeholder="Card Number">
	<br>
	Security Code:
	<input type="text" name="seccode" value="<%= seccode%>" placeholder="Security Code">
	<br>
	Type:
	<select id="SelectType" name="ctype">
	<option value="MasterCard">MasterCard</option>
	<option value="Visa">Visa</option>
	<option value="Discover">Discover</option>
	</select>
	
<script>
SelectElement("<%=cType%>");
function SelectElement(valueToSelect)
{    
 var element = document.getElementById("SelectType");
 element.value = valueToSelect;
 
 if(valueToSelect=="")
 {
 	element.value = "MasterCard";
	}
}
</script>
	<br>
	Expiration Date:
	<input type="date" value="<%= expdate%>" name="expdate">
</fieldset>
<br>
<input type="submit" value="Reserve Now">
</form>

<form name="cancelForm" method="POST" action="cancel.jsp" >
<input type="submit" value="Cancel Reservation">

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