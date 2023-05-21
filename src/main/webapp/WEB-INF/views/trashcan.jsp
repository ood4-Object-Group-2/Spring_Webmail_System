<%-- 
    Document   : trashcan
    Created on : 2023 May 2, 01:43:39
    Author     : MS
--%>

<%@page import="deu.cse.spring_webmail.control.CommandType"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>복구</td>
                        <td>완전삭제</td>
                    </tr>
                </c:forEach>
            </tbody>
            </table>
        </div>

        <%@include file="footer.jspf"%>
    </body>
</html>
