<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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
    <th scope="row">Account</th>
    <td><span>${detailbank.codeName}</span></td>
    <th scope="row">Create By</th>
    <td><span>${detailbank.userName}<c:if test="${not empty detailbank.custAccCrtDt}">(${detailbank.custAccCrtDt})</c:if></span></td>
</tr>
<tr>
    <th scope="row">Account No</th>
    <td><span>${detailbank.custAccNo}</span></td>
    <th scope="row">Update By</th>
    <td><span>${detailbank.userName1}<c:if test="${not empty detailbank.custAccUpdDt}">(${detailbank.custAccUpdDt})</c:if></span></td>
</tr>
<tr>
    <th scope="row">Account Holder</th>
    <td><span>${detailbank.custAccOwner}</span></td>
    <th scope="row">Issue Bank</th>
    <td><span>${detailbank.bankCode}<c:if test="${not empty detailbank.bankName}">${detailbank.bankName}</c:if></span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>${detailbank.custAccRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</section><!-- pop_body end -->
