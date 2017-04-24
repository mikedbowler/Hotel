<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Registration Validation</title>
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

<p>
<% boolean error = false;
while(true){
try	{		
//LoadmySQLdriver
Class.forName("com.mysql.jdbc.Driver").newInstance();	
//Connect	 to	the	local	database	
Connection	conn	=	DriverManager.getConnection ("jdbc:mysql://127.0.0.1/hoteldb","root","root1"	);	

String fullname = request.getParameter("firstname").trim() + " " + request.getParameter("lastname").trim();
String email = request.getParameter("email").trim();
String address = request.getParameter("address").trim();
String phone_no = request.getParameter("phonenumber").trim();

Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM Customer WHERE Name=\"" + fullname + "\" and Email=\"" + email + "\" and Address=\"" + address + "\" and Phone_no=\"" + phone_no + "\";");
if(rs.next() == true){
	error = true;
	break;
}	
rs = stmt.executeQuery("Select max(CID) FROM Customer");
rs.next();
int max = rs.getInt(1) + 1;
stmt.executeUpdate("INSERT INTO Customer VALUES (" + max + ",\"" + fullname + "\",\"" + phone_no + "\",\"" + address + "\",\"" + email + "\");");

//	Close	the	ResultSet
rs.close();	
//ClosetheStatement
stmt.close();	
//	Close	the	Connection
conn.close();	
}catch(SQLException sqle){	
out.println(sqle.getMessage());	
error = true;
}catch(Exception e){	
out.println(e.getMessage());
error = true;	
}	
break;
}

if(!error){
	out.println("<ul>" + 
"<li><a href=\"signin.html\">Sign In</a></li>" +
"</ul>" +

"<div align=\"center\">" +

"<h1>Registration Successful!</h1>" +
"<h2>Sign in using your Name and Email</h2>" +
"</div>"
	);
}
else{
	out.println("<ul>" + 
"<li><a href=\"signin.html\">Sign In</a></li>" +
"</ul>" +

"<div align=\"center\">" +

"<h1>An Error Occurred</h1>" +
"<h2>Use the Back button on your browser to return to the Registration Page</h2>" +
"</div>"
	);
}
%>	

</p>

</body>
</html>