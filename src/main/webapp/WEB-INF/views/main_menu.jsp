<%-- 
    Document   : main_menu
    Created on : 2022. 6. 10., 오후 3:15:45
    Author     : skylo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>주메뉴 화면</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
        <script>
            <c:if test="${!empty msg}">
                alert("${msg}");
            </c:if>
        </script>
    </head>
    <body>
        <%@include file="header.jspf"%>

        <div id="sidebar">
            <jsp:include page="sidebar_menu.jsp" />
        </div>

        <!-- 메시지 삭제 링크를 누르면 바로 삭제되어 실수할 수 있음. 해결 방법은? -->
        <div id="main">
            <table id="mail">
                <thead>
                    <tr>
                        <th> No. </th>
                        <th> 보낸 사람 </th>
                        <th> 제목 </th>
                        <th> 보낸 날짜 </th>
                        <th> 삭제 </th>
                        <td> 읽음 여부 </td>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${messageList}" var="list" varStatus="status">
                        <tr style="border-bottom: thin solid black">
                            <td id="no">${list.getNo()}</td>
                            <td id="sender">${list.getSender()}</td>
                            <td id="subject"><a href="show_message?msgid=${list.getNo()}">${list.getSubject()}</a></td>
                            <td id="date">${list.getDate()}</td>
                            <td id="delete"><a href="delete_mail.do?msgid=${list.getNo()}">삭제</a></td>
                            <td id="delete">
                                <c:set var="isRead" value="false" />
                                <c:forEach var="i" begin="0" end="${message_id.size() - 1}" step="1">
                                    <c:if test="${message_id[message_id.size() - 1 - status.index] == r_check[message_id.size() - 1 - i]}">
                                        <c:set var="isRead" value="true" /> 읽음
                                    </c:if>
                                </c:forEach>
                            </td>
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
