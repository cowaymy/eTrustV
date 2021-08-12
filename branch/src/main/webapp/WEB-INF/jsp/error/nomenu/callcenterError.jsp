<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=1280px,user-scalable=yes,target-densitydpi=device-dpi" name="viewport"/>
    <title>eTrust system - Invalid Token</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/master.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/common.css"/>

</head>
<body>

<div id="wrap"><!-- wrap start -->
    <section id="content"><!-- content start -->
        <div class="error">
            <article class="error_contents">
                <h2>Error :(</h2>
                <p class="comment01" id="errorMessage">${errorMessage}</p>
            </article>
        </div>

    </section><!-- container end -->
    <hr/>

</div><!-- wrap end -->
</body>
</html>