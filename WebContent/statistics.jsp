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

<p>

This information will be dynamically placed, once the database is queried<br>
/* INCOMPLETE */
1. For a given time period (begin date and end date) compute the highest rated room type for each hotel.<br>
	SELECT MAX(T1.sum), T1.type
	FROM Room r
	JOIN (SELECT Sum(rr.rating) sum, r.type, rr.HotelID, rr.Room_no
	      FROM Room r
          JOIN RoomReview rr
          ON r.HotelID = rr.HOTELID AND r.Room_No = rr.Room_No
          GROUP BY rr.HotelID, rr.Room_No) T1
    ON r.Type = T1.type AND r.HotelID  = T1.HotelID AND r.Room_no = T1.Room_No
    GROUP BY T1.HotelID

/* FINISHED */
2. For a given time period (begin date and end date) compute the 5 best customers (in terms of money spent in reservations).<br>
	SELECT c.name, T1.totalSpent
	FROM (SELECT CID, sum(TotalAmt) totalSpent
          FROM Reservation r, MakeReservation mr
          WHERE r.InvoiceNo = mr.InvoiceNo
		   AND r.ResDate > '2009-01-01' /*Start Date*/
           AND r.ResDate < '2011-11-01' /*End Date*/
          GROUP BY mr.CID ) T1, Customer c
    WHERE c.CID = T1.CID
    ORDER BY T1.totalSpent DESC
    LIMIT 5;

/* FINISHED */	
3. For a given time period (begin date and end date) compute the highest rated breakfast type across all hotels.<br>
	SELECT T2.bType
    FROM( SELECT MAX(T1.sum), T1.bType
	      FROM (SELECT SUM(bR.rating) sum, bR.bType
		        FROM breakfastReview bR 
		        WHERE bR.dateSubmitted > '2009-01-01' /*Start Date*/
			      AND bR.dateSubmitted < '2015-05-01' /*End Date*/
		        GROUP BY bR.bType) T1) T2;
				
/* FINISHED */				
4. For a given time period (begin date and end date) compute the highest rated service type across all hotels.
	SELECT T2.sType
	FROM( SELECT MAX(T1.sum), T1.sType
	      FROM (SELECT SUM(sR.rating) sum, sR.sType
		        FROM serviceReview sR 
			    WHERE sR.dateSubmitted > '2009-01-01' /*Start Date*/
			      AND sR.dateSubmitted < '2015-05-01' /*End Date*/
		        GROUP BY sR.sType) T1) T2;
				
</p>

</body>
</html>