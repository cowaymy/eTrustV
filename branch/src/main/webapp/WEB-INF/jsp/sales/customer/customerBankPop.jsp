<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custBankAcc" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.account" /></th>
    <td><span>${detailbank.codeName}</span></td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td><span>${detailbank.userName}
        <c:if test="${not empty detailbank.custAccCrtDt}">
            <c:if test="${detailbank.custAccCrtDt ne '01-01-1900'}">
            (${detailbank.custAccCrtDt})
            </c:if>
        </c:if>
        </span>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.accNo" /></th>
    <td><span>${detailbank.custAccNo}</span></td>
    <th scope="row"><spring:message code="sal.text.updateBy" /></th>
    <td><span>${detailbank.userName1}
        <c:if test="${not empty detailbank.custAccUpdDt}">
            <c:if test="${detailbank.custAccUpdDt ne '01-01-1900'}">
                (${detailbank.custAccUpdDt})
            </c:if>
        </c:if>
        </span>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.accountHolder" /></th>
    <td><span>${detailbank.custAccOwner}</span></td>
    <th scope="row"><spring:message code="sal.text.issueBank" /></th>
    <td><span>${detailbank.bankCode}<c:if test="${not empty detailbank.bankName}">${detailbank.bankName}</c:if></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><span>${detailbank.custAccRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</section><!-- pop_body end -->
</div>