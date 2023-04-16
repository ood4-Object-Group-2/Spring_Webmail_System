<%-- 
    Document   : update_user
    Created on : 2023 Mar 30, 03:25:15
    Author     : MS
--%>

<%@page import="deu.cse.spring_webmail.control.CommandType"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name = "viewport" content = "width=device-width, initial-scale=1.0">
        <title>회원정보 수정</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
    </head>
    <body>
        <%@include file="../header.jspf"%>
        
        <div id="sidebar">
            <jsp:include page="../sidebar_previous_menu.jsp" />
        </div>
        <h1>회원 정보를 수정합니다.</h1>
        <div id="login_form">
        <form method="POST" name ="UpdateUser" action = "update_user.do">
                사용자 : <%= session.getAttribute("userid") %><br/>
                현재 암호: <input type="password" name="nowpasswd" size="20"> <br /> 
                새&nbsp;&nbsp;&nbsp; 암호: <input type="password" name="newpasswd" size="20"><br /> 
                재&nbsp;&nbsp;&nbsp; 입력: <input type="password" name="newpasswd2" size="20"><br /> 
                <br>
                <input type="reset" value="다시 입력" name="B2">   <input type="submit" value="확 인" name="B2">
        </form>
        </div>
        <%@include file="../footer.jspf"%>
    </body>
</html>
