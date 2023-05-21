<%-- 
    Document   : trashcan
    Created on : 2023 May 2, 01:43:39
    Author     : MS
--%>

<%@page import="deu.cse.spring_webmail.control.CommandType"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="deu.cse.spring_webmail.model.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name = "viewport" content = "width=device-width, initial-scale=1.0">
        <title>휴지통</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
    </head>
    <body>
        <%@include file="header.jspf"%>
        <%
            String name = (String)session.getAttribute("userid");
            try{
                HikariConfiguration dbConfig = (HikariConfiguration)request.getAttribute("dbConfig");
                javax.sql.DataSource ds = dbConfig.dataSource();
                
                Connection con = ds.getConnection();
                String sql = "SELECT * FROM mail.trash_mail where username = ?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, name);
                ResultSet rs = pst.executeQuery();
        %>
        <div id="sidebar">
            <jsp:include page="sidebar_previous_menu.jsp" />
        </div>

        <div id="main">
            <table>
            <thead>
            <tr>
                <td>No.</td>
                <td>보낸 사람</td>
                <td>제목</td>
                <td>보낸 날짜</td>
                <td>복구</td>
                <td>완전 삭제</td>
            </tr>
            </thead>
            <tbody>
                <c:forEach var = "trashmails" items = "">
                    <%
                   while(rs.next()){
                       out.println("<tr>");
                       out.println("<td>" + rs.getString("message_name") + "</td>");
                       out.println("<td>" + rs.getString("sender") + "</td>");
                       out.println("<td>" + rs.getString("last_updated") + "</td>");
                       out.println("<td>복구하기</td>");
                       out.println("<td>삭제하기</td>");
                       out.println("</tr>");
                   }
                   
                   rs.close();
                   pst.close();
                   con.close();
                
                %>
                </c:forEach>
            </tbody>
            </table>
            <%
                } catch(Exception e){
                    out.println("에러 원인 : " + e.getMessage());
                }
            %>
        </div>

        <%@include file="footer.jspf"%>
    </body>
</html>
