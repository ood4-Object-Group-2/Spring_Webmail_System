<%-- 
    Document   : sign_up
    Created on : 2023. 4. 9., 오후 3:14:18
    Author     : qntjd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="deu.cse.spring_webmail.control.CommandType"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>회원 가입</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
        <script>
            <c:if test="${!empty msg}">
            alert("${msg}");
            </c:if>
        </script>
    </head>
    <body>
        <%@include file="header.jspf"%>

        <div id="signup_form">
            <form method="POST" action="signup.do" name="SignUp" >
                <table>
                    <tr>
                        <td style="text-align: right;">I&nbsp;&nbsp;&nbsp;D :</td>
                        <td><input type="text" name="id" minlength="3" maxlength="20"></td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">P&nbsp;&nbsp;W :</td>
                        <td><input type="password" name="pw" minlength="6" maxlength="16"></td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">Check PW :</td>
                        <td><input type="password" name="check_pw"></td>
                    </tr>
                </table>
                <br>
                <input type="submit" value="회원 가입">&nbsp;&nbsp;&nbsp;
                <input type="button" value="가입 취소" onclick="location.href= '${pageContext.request.contextPath}'">
            </form>
        </div>

        <%@include file="footer.jspf"%>
    </body>
</html>