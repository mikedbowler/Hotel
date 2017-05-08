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

<% 

try{
	
Class.forName("com.mysql.jdbc.Driver").newInstance(); 

Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HotelDB","root","root1"); 

Statement stmt = conn.createStatement();

String fullName = (request.getParameter("firstname")+" "+request.getParameter("lastname")).trim();
String email = request.getParameter("email").trim();

ResultSet rs = stmt.executeQuery("SELECT C.Name,C.Email from Customer C");
boolean success = false; boolean isAdmin = false;

if(fullName.equals("admin admin") && email.equals("admin@hh.com"))
	isAdmin = true;

while(rs.next() && !isAdmin)
{
	String name = rs.getString("Name");
	String email2 = rs.getString("Email");
	
	if(name.equals(fullName) && email2.equals(email))
	{
		success = true;
		break;
	}
}

if(isAdmin){
	session.setAttribute("firstName", request.getParameter("firstname"));
	session.setAttribute("lastName", request.getParameter("lastname"));
	session.setAttribute("email", email);
 	%>
 	<script>
 	
 	window.open("statistics.html","_self")
 	
 	alert("Welcome Admin!")
 	
 	</script>	
 	<%
}
else if(success){
	rs.close();
	PreparedStatement pstmt=conn.prepareStatement("Select CID FROM Customer where Name=? and Email=?;");
	pstmt.setString(1, fullName);
	pstmt.setString(2, email);
	rs = pstmt.executeQuery();
	rs.next();
	session.setAttribute("CID", rs.getInt("CID"));
	session.setAttribute("firstName", request.getParameter("firstname"));
	session.setAttribute("lastName", request.getParameter("lastname"));
	session.setAttribute("email", email);

%>
<script>
window.open("reservation.jsp","_self")

</script>
<%
}
else{
	%>
	<script>
	
	window.open("signin.html","_self")
	
	alert("Invalid Credentials.")
	
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