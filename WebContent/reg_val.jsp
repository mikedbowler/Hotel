<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Registration Validation</title>
</head>
<body>

<p>This page won't have any design, it is strictly for the purpose of<br>
input validation and redirecting the user to the next page if input is<br>
valid, otherwise redirects them back to registration.
</p>

<% 

try{
	
Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","Strike12"); 

Statement stmt = conn.createStatement();

String fullName = (request.getParameter("firstname")+" "+request.getParameter("lastname")).trim();
String phone = request.getParameter("phonenumber").trim();
String address = request.getParameter("address").trim();
String email = request.getParameter("email").trim();

ResultSet rs = stmt.executeQuery("SELECT C.Name,C.Email from Customer C");

while(rs.next())
{
	String name = rs.getString("Name");
	String email2 = rs.getString("Email");
	
	if(name.equals(fullName))
	{
		%>
		<script>
		
		window.open("registration.html","_self")
		
		alert("Name already exists!")
		
		</script>	
		<%
		break;
	}
	else if(email2.equals(email))
	{
		%>
		<script>
		
		window.open("registration.html","_self")
		
		alert("Email already exists!")
		
		</script>	
		<%
		break;
	}
}

PreparedStatement pstmt=conn.prepareStatement("INSERT INTO CUSTOMER (CID,Name,Phone_no,Address,Email) VALUES (null,?,?,?,?)");
pstmt.setString(1,fullName); 
pstmt.setString(2,phone); 
pstmt.setString(3,address); 
pstmt.setString(4,email); 

pstmt.executeUpdate();

%>
<script>
window.open("reservation.html","_self")


</script>
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

</body>
</html>