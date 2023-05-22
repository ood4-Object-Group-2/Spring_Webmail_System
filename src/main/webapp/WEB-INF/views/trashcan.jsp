<%-- 
    Document   : trashcan
    Created on : 2023 May 2, 01:43:39
    Author     : MS
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 제어기에서 처리하면 로직 관련 소스 코드 제거 가능! -->
<jsp:useBean id="pop3" scope="page" class="deu.cse.spring_webmail.model.Pop3Agent" />
<%
    pop3.setHost((String) session.getAttribute("host"));
    pop3.setUserid((String) session.getAttribute("userid"));
    pop3.setPassword((String) session.getAttribute("password"));
%>

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
            <table id = "mail">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>보낸 사람</th>
                        <th>제목</th>
                        <th>보낸 날짜</th>
                        <th>복구</th>
                        <th>완전 삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${messageList}" var="list">
                        <tr style="border-bottom: thin solid black">
                            <td id="no">${list.getNo()}</td>
                            <td id="sender">${list.getSender()}</td>
                            <td id="subject"><a href="show_message?msgid=${list.getNo()}">${list.getSubject()}</a></td>
                            <td id="date">${list.getDate()}</td>
                            <td>복구</td>
                            <td id="delete"><a href="delete_mail.do?msgid=${list.getNo()}">완전 삭제</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div id="page_list">
                <c:forEach var="num" begin="${paging.getFirst()}" end="${paging.getLast()}">
                    <a href="main_menu?page=${num}">${num}</a>
                </c:forEach>
            </div>
        </div>

        <%@include file="footer.jspf"%>
    </body>
</html>
