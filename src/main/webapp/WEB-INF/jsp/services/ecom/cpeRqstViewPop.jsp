<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function () {

    //fn_setCpeReqDtl(); //TODO: Yong - populate details related to Cpe Request
    //fn_setCpeSubReqTypeDtl(); //TODO: Yong - populate details related to specific Cpe Request Sub Type e.g. Product Exchange or Promotion Code change
    //fn_setCpeAppvDtl(); //TODO: Yong - populate details related to approval or rejection status
});

function fn_setCpeReqDt() {
    var appvCashAmt = "${requestInfo.appvCashAmt}";
    $("#appvCashAmt").val(appvCashAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
}

function fn_setCpeSubReqTypeDtl() {
    var reqstAmt = "${requestInfo.reqstAmt}";
    $("#reqstAmt").val(reqstAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
}

function fn_setCpeAppvDtl() {
    var custdnNric = "${requestInfo.custdnNric}";
    $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="pettyCashViewRqst.title" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" enctype="multipart/form-data" id="form_newReqst">
<input type="hidden" id="newCrtUserId" name="crtUserId" value="${requestInfo.crtUserId}">
<input type="hidden" id="clmNo" name="clmNo" value="${requestInfo.cpeId}">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="cpe.cpeId" /></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" id="cpeId" name="cpeId" value="${requestInfo.cpeId}"</td>
    <th scope="row"><spring:message code="cpe.salesOrdNo" /></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" id="salesOrdNo" name="salesOrdNo" value="${requestInfo.salesOrdNo}"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="cpe.type" /></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="cpeType" name="cpeType" value="${requestInfo.cpeType}"/></td>
    <th scope="row"><spring:message code="cpe.subtype" /></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="cpeSubType" name="cpeSubtype" value="${requestInfo.cpeSubtype}"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="cpe.appvPrcssNo" /></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="appvPrcssNo" name="appvPrcssNo" value="${requestInfo.appvPrcssNo}"/></td>
    <th scope="row"><spring:message code="cpe.crtUserId" /></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="crtUserId" name="crtUserId" value="${requestInfo.crtUserId}"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="cpe.crtDt" /></th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="crtDt" name="crtDt" value="${requestInfo.crtDt}"/></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- TODO: Yong - Depending on authority / member type and (branch?) enable Approve / Reject buttons and relevant Remarks -->

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->