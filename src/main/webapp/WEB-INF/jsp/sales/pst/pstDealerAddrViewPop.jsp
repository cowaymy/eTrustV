<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.dealerAddress" /></h1>
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
    <td colspan="3">
    <span>${addrView.stusCode}</span>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td>${addrView.crtUserName}</td>
    <th scope="row"><spring:message code="sal.text.updateBy" /></th>
    <td>${addrView.updUserName}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
    <td colspan="3"><span>${addrView.addrDtl}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /></th>
    <td colspan="3"><span>${addrView.street}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.area4th" /></th>
    <td colspan="3">${addrView.area}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ciry2nd" /></th>
    <td>${addrView.city}</td>
    <th scope="row"><spring:message code="sal.title.text.postcode3rd" /></th>
    <td>${addrView.postcode}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.state1st" /></th>
    <td>${addrView.state}
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td>${addrView.country}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remarks" /></th>
    <td colspan="3"><span>${addrView.rem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->