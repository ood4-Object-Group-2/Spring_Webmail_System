<%-- 
    Document   : sidebar_sent_menu
    Created on : 2023. 5. 13., 오전 2:37:52
    Author     : 이혜리
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <br> <br> 

        <span style="color: indigo">
            <strong>사용자: <%= session.getAttribute("userid") %> </strong>
        </span> <br> <br>
       
        <p><a href="main_menu?page=1"> 이전 메뉴로 </a></p>
    </body>
</html>