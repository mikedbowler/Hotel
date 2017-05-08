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



<% 

try{
	
Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

Statement stmt = conn.createStatement();

String fullName = (request.getParameter("firstname")+" "+request.getParameter("lastname")).trim();
String phone = request.getParameter("phonenumber").trim();
String address = request.getParameter("address").trim();
String email = request.getParameter("email").trim();

ResultSet rs = stmt.executeQuery("SELECT C.Name,C.Email from Customer C");
boolean success = true;
while(rs.next())
{
	String name = rs.getString("Name");
	String email2 = rs.getString("Email");
	
	if(name.equals(fullName) && email2.equals(email))
	{
		%>
		<script>
		
		window.open("index.html","_self")
		
		alert("Another user already has these credentials.")
		
		</script>	
		<%
		success = false;
		break;
	}
}

if(success){
PreparedStatement pstmt=conn.prepareStatement("INSERT INTO CUSTOMER (CID,Name,Phone_no,Address,Email) VALUES (null,?,?,?,?)");
pstmt.setString(1,fullName); 
pstmt.setString(2,phone); 
pstmt.setString(3,address); 
pstmt.setString(4,email); 

pstmt.executeUpdate();

rs.close();

pstmt=conn.prepareStatement("Select max(CID) max FROM Customer;");
rs = pstmt.executeQuery();
rs.next();

session.setAttribute("CID", rs.getInt("max"));
session.setAttribute("firstName", request.getParameter("firstname"));
session.setAttribute("lastName", request.getParameter("lastname"));
session.setAttribute("email", email);

%>
<script>
window.open("reservation.jsp","_self")

</script>
<%
}
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