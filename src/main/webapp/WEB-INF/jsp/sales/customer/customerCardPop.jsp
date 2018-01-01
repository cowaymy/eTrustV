<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Customer Credit Card</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
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
    <td><span>${detailcard.userName}
        <c:if test="${not empty detailcard.custCrcCrtDt }">
            <c:if test="${detailcard.custCrcCrtDt ne '01-01-1900'}">
                (${detailcard.custCrcCrtDt})
            </c:if>
        </c:if>
        </span>
    </td>
</tr>
<tr>
    <th scope="row">Credit No</th>
    <td><span>${detailcard.custOriCrcNo }</span></td>
    <th scope="row">Update By</th>
    <td><span>${detailcard.userName1}
        <c:if test="${not empty detailcard.custCrcUpdDt}">
            <c:if test="${detailcard.custCrcUpdDt ne '01-01-1900'}">
                (${detailcard.custCrcUpdDt})
            </c:if>
        </c:if>
        </span>
    </td>
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
</div>