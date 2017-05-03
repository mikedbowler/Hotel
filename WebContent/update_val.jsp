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

int CID = Integer.parseInt(request.getParameter("CID"));
String fullName = (request.getParameter("firstname")+" "+request.getParameter("lastname")).trim();
String phone = request.getParameter("phonenumber").trim();
String address = request.getParameter("address").trim();
String email = request.getParameter("email").trim();

ResultSet rs = stmt.executeQuery("SELECT * from Customer C");
boolean success = true;
while(rs.next())
{
	String name = rs.getString("Name");
	String email2 = rs.getString("Email");
	int CID2 = rs.getInt("CID");
	
	if(name.equals(fullName) && email2.equals(email) && CID2 != CID)
	{
		%>
		<script>
		
		window.open("update.jsp","_self")
		
		alert("Another user already has these credentials.")
		
		</script>	
		<%
		success = false;
		break;
	}
}

if(success){
PreparedStatement pstmt=conn.prepareStatement("UPDATE CUSTOMER SET Name=?,Phone_no=?,Address=?,Email=? where CID=?");
pstmt.setString(1,fullName); 
pstmt.setString(2,phone); 
pstmt.setString(3,address); 
pstmt.setString(4,email); 
pstmt.setString(5,String.valueOf(CID));

pstmt.executeUpdate();

session.setAttribute("firstName", request.getParameter("firstname"));
session.setAttribute("lastName", request.getParameter("lastname"));
session.setAttribute("email", email);

%>
<script>
window.open("reservation.html","_self")

alert("Success!")

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