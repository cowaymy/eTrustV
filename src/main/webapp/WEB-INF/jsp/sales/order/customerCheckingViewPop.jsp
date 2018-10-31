<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">


$(document).ready(function(){



});



</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View Customer Checking UI</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Order Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td>${result.salesOrdNo }</td>
    <th scope="row">App Type</th>
    <td>${result.appType }</td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td>${result.custName }</td>
    <th scope="row">Account Status</th>
    <td>${result.rentStus }</td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>${result.product }</td>
    <th scope="row">Payment Mode</th>
    <td>${result.payMode }</td>
</tr>
<tr>
    <th scope="row">Installed Date</th>
    <td>${result.installDt }</td>
    <th scope="row">Issued Bank</th>
    <td>${result.bankName }</td>
</tr>
<tr>
    <th scope="row">Pair with I-Care</th>
    <td>${result.iCare }</td>
    <th scope="row">Aging Month</th>
    <td>${aging.agingMth }</td>
</tr>
</tbody>
</table><!-- table end -->





</section><!-- pop_body end -->

</div><!-- popup_wrap end -->