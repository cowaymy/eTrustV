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
    <td><span>${detailbank.codename}</span></td>
    <th scope="row">Create By</th>
    <td><span><c:if test="${not empty detailbank.custacccrtdt}">(${detailbank.custacccrtdt})</c:if></span></td>
</tr>
<tr>
    <th scope="row">Account No</th>
    <td><span>${detailbank.custaccno}</span></td>
    <th scope="row">Update By</th>
    <td><span>${detailbank.username1}<c:if test="${not empty detailbank.custaccupddt}">(${detailbank.custaccupddt})</c:if></span></td>
</tr>
<tr>
    <th scope="row">Account Holder</th>
    <td><span>${detailbank.custAccOwner}</span></td>
    <th scope="row">Issue Bank</th>
    <td><span>${detailbank.bankcode}<c:if test="${not empty detailbank.bankname}">${detailbank.bankname}</c:if></span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>${detailbank.custaccrem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</section><!-- pop_body end -->
