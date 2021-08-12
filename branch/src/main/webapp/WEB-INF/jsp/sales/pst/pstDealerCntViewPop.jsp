<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.dealerContact" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

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
    <th scope="row"><spring:message code="sal.title.status" /></th>
    <td colspan="3"><span>${cntView.stusCode }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><span>${cntView.dealerInitialCode }</span></td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td><span>${cntView.dealerInitialCode }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><span>${cntView.cntName }</span></td>
    <th scope="row"><spring:message code="sal.text.updateBy" /></th>
    <td><span>${cntView.dealerInitialCode }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span>${cntView.nric }</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${cntView.gender }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${cntView.raceName }</span></td>
    <th scope="row"><spring:message code="sal.title.text.telMobile1" /></th>
    <td><span>${cntView.telM1 }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMobile2" /></th>
    <td><span>${cntView.telM2 }</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span>${cntView.telO }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span>${cntView.telR }</span></td>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><span>${cntView.telf }</span></td>
</tr>
</tbody>
</table><!-- table end -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->