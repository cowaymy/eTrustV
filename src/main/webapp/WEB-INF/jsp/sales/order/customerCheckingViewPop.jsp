<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javaScript" language="javascript">


$(document).ready(function(){




});



</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>I-Care Eligibility</h1>
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
    <th scope="row">Rental Status</th>
    <td>${result.rentStus }</td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>${result.product }</td>
    <th scope="row" style="display:none;">Payment Mode</th>
    <td style="display:none;">${result.payMode }</td>
    <th></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Installed Date</th>
    <td>${result.installDt }</td>
    <th scope="row" style="display:none;">Issued Bank</th>
    <td style="display:none;">${result.bankName }</td>
    <th></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Pair with I-Care</th>
    <td>${icare }</td>
    <th scope="row" style="display:none;">Aging Month (Avg. Last 6 mth)</th>
    <td style="display:none;">${aging.agingMth }</td>
    <th></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Eligible for Key In</th>
    <td>${verify }</td>
    <th scope="row" style="display:none;">Unit Count</th>
    <td style="display:none;">${result.untCnt}</td>
    <th></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Own Purchase</th>
    <td>${result.ownPurchse}</td>
    <th></th>
    <td></td>
</tr>
<tr style="display:none;" >
    <th scope="row">Installation Address</th>
    <td colspan="3">${result.instAdd }</td>
</tr>
<tr>
   <th colspan="4">
        <span class="must">
        <br/>
            CCP APPROVAL SUBJECT TO CREDIBILITY CHECK ON PAYMENT PATTERN, RENTAL STATUS, PAYMENT MODE AND INSTALLATION ADDRESS TO ALL EXISTING UNITS.<br/>
            MANAGEMENT RESERVE THE RIGHT TO REJECT APPLICATION IF ANY OF THE CONDITION DOES NOT MEET.<br/><br/>
        </span>

    </th>

</tr>
</tbody>
</table><!-- table end -->





</section><!-- pop_body end -->

</div><!-- popup_wrap end -->