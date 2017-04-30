<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<p>This page won't have any design, it is strictly for the purpose of<br>
input validation and redirecting the user to the next page if input is<br>
valid, otherwise redirects them back to sign in.
</p>

<% 

try{
	
Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","Strike12"); 

String fullName = (request.getParameter("firstname")+" "+request.getParameter("lastname")).trim();
String email = request.getParameter("email").trim();

if(fullName.equals("admin admin") && email.equals("admin@hh.com"))
{
	%>
	<script>
	
	window.open("statistics.html","_self")
	
	alert("Welcome Admin!")
	
	</script>	
	<%
}

PreparedStatement stmt = conn.prepareStatement("SELECT C.Name,C.Email FROM Customer C WHERE C.Name=? AND C.Email=?");
stmt.setString(1,fullName);
stmt.setString(2,email);

ResultSet rs = stmt.executeQuery();

while(rs.next())
{
		%>
		<script>
		
		window.open("reservation.html","_self")
		
		alert("Welcome!")
		
		</script>	
		<%
}

%>
<script>
window.open("signin.html","_self")

alert("Invalid Name or Email")
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