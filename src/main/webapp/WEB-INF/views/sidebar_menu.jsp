<%-- 
    Document   : sidebar_menu
    Created on : 2022. 6. 10., 오후 3:25:30
    Author     : skylo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="deu.cse.spring_webmail.control.CommandType"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate, max-age=0">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Expires" content="0">
        <title>웹메일 시스템 메뉴</title>

        <script>
            window.onload = function () {
                if (window.history && window.history.pushState) {
                    window.history.pushState('forward', null, './main_menu?page=1');
                    window.onpopstate = function (event) {
                        if (event.state == 'forward') {
                                    location.replace('<%= request.getContextPath()%>/index.jsp');
                        }
                    };
                }
            }
        </script>

    </head>
    <body>
        <br> <br>

        <span style="color: indigo"> <strong>사용자: <%= session.getAttribute("userid")%> </strong> </span> <br>

        <p> <a href="main_menu?page=1"> 메일 읽기 </a> </p>
        <p> <a href="write_mail"> 메일 쓰기 </a> </p>

        <p> <a href="trashcan"> 휴지통 </a> </p>
        <p> <a href="update_user"> 사용자 수정 </a> </P>

        <p> <a href="mysent_mail"> 보낸 메일함 </a> </p>

        <p><a href="remove_user"> 회원 탈퇴</a> </p>
        <p><a href="login.do?menu=<%= CommandType.LOGOUT%>">로그아웃</a></p>
    </body>
</html>
