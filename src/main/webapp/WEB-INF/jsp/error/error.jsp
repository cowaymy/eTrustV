<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Basic Sample - jsp/error/error.jsp</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/master.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/common.css" />

    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-2.2.4.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/util.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/common.js"></script>        <!-- 일반 공통 js -->

    <script type="text/javaScript">
        $(function () {
        });
    </script>
</head>

<body>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td width="100%" height="100%" align="center" valign="middle" style="padding-top: 150px;">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><spring:message code='sys.msg.fail'/></td>
                    <td>
                        <span style="font-family: Tahoma; font-weight: bold; color: #000000; line-height: 150%; width: 440px; height: 70px;">${exception}</span>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>