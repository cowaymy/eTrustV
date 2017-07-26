<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Credit Card Type</th>
    <td><span>${detailcard.code }</span></td>
    <th scope="row">Create By</th>
    <td><span>${detailcard.userName}<c:if test="${not empty detailcard.custCrcCrtDt }">(${detailcard.custCrcCrtDt})</c:if></span></td>
</tr>
<tr>
    <th scope="row">Credit No</th>
    <td><span>${detailcard.custOriCrcNo }</span></td>
    <th scope="row">Update By</th>
    <td><span>${detailcard.userName1}<c:if test="${not empty detailcard.custCrcUpdDt}">(${detailcard.custCrcUpdDt})</c:if></span></td>
</tr>
<tr>
    <th scope="row">Name On Card</th>
    <td><span>${detailcard.custCrcOwner}</span></td>
    <th scope="row">Expiry Date</th>
    <td><span>${detailcard.custCrcExpr}</span></td>
</tr>
<tr>
    <th scope="row">Card Type</th>
    <td><span>${detailcard.codeName}</span></td>
    <th scope="row">Issue Bank</th>
    <td><span>${detailcard.bankCode}<c:if test="${not empty detailcard.bankId}">-${detailcard.bankId}</c:if></span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>${detailcard.custCrcRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- pop_body end -->