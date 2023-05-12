<%-- 
    Document   : mysent_mail
    Created on : 2023. 5. 12., 오후 11:05:53
    Author     : 이혜리
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>

<!-- 제어기에서 처리하면 로직 관련 소스 코드 제거 가능!
<jsp:useBean id="pop3" scope="page" class="deu.cse.spring_webmail.model.Pop3Agent" />
<%
    pop3.setHost((String) session.getAttribute("host"));
    pop3.setUserid((String) session.getAttribute("userid"));
    pop3.setPassword((String) session.getAttribute("password"));
%>
-->

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>보낸 메일함</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
        <script>
            <c:if test="${!empty msg}">
            alert("${msg}");
            </c:if>
        </script>
    </head>
    <body>
        <%@include file="../header.jspf"%>

        <div id="sidebar">
            <jsp:include page="sidebar_sent_menu.jsp" />
        </div>
        <!-- 메시지 삭제 링크를 누르면 바로 삭제되어 실수할 수 있음. 해결 방법은? -->
        <div id="main">
            <table id="mail">
                <thead>
                    <tr>
                        <th> No. </th>
                        <th> 받는 사람 </th>
                        <th> 제목 </th>
                        <th> 보낸 날짜 </th>
                        <th> 삭제 </th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${list}" var="list">
                        <tr style="border-bottom: thin solid black">
                            <td id="no">${list.getNo()}</td>
                            <td id="sender">${list.getSender()}</td>
                            <td id="subject"><a href="show_message?msgid=${list.getNo()}">${list.getSubject()}</a></td>
                            <td id="date">${list.getDate()}</td>
                            <td id="delete"><a href="delete_mail.do?msgid=${list.getNo()}">삭제</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <%@include file="../footer.jspf"%>
    </body>
</html>
