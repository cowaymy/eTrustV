<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta content="width=1280px,user-scalable=yes,target-densitydpi=device-dpi" name="viewport"/>
<title>eTrust system</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/master.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/common.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.ui.core.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.ui.datepicker.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script type="text/javaScript" language="javascript">

    function fn_goPstStockList(){
        location.href = "/sales/pst/getPstRequestDOStockEditPop.do?isPop=true&pstSalesOrdId=${pstInfo.pstSalesOrdId}&pstRefNo=${pstInfo.pstRefNo}";
    }

</script>
</head>
<body>

<div id="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>PST Request Info Edit</h1>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post">

<ul class="tap_type1">
    <li><a href="#" class="on">PST info</a></li>
    <li><a href="#">PST Mail Address</a></li>
    <li><a href="#">PST Delivery Address</a></li>
    <li><a href="#">PST Mail Contact</a></li>
    <li><a href="#">PST Delivery Contact</a></li>
    <li><a href="#" onclick="javascript:fn_goPstStockList()">PST Stock List</a></li>
</ul>

<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">PSO ID</th>
    <td><span><c:out value="${pstInfo.pstSalesOrdId}"/></span></td>
    <th scope="row">PSO Ref No</th>
    <td><span><c:out value="${pstInfo.pstRefNo}"/></span></td>
    <th scope="row">Customer PO</th>
    <td><span><c:out value="${pstInfo.pstCustPo}"/></span></td>
</tr>
<tr>
    <th scope="row">Currency Type</th>
    <td><span><c:out value="${pstInfo.code}"/></span></td>
    <th scope="row">Currency Rate</th>
    <td><span><c:out value="${pstInfo.pstCurRate}"/></span></td>
    <th scope="row">Person In Charge</th>
    <td><span><c:out value="${pstInfo.userName}"/></span></td>
</tr>
<tr>
    <th scope="row">PSO Status</th>
    <td><span><c:out value="${pstInfo.code1}"/></span></td>
    <th scope="row">Create By</th>
    <td><span><c:out value="${pstInfo.userName1}"/></span></td>
    <th scope="row">Create AT</th>
    <td><span><c:out value="${pstInfo.c1}"/></span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5" class="h70"></td>
</tr>
</tbody>
</table><!-- table end -->
<!--
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">CLEAR</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
 -->
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>