<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h3>Update Status</h3>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" id="SARefNo_header">SA Reference No<span class="must">*</span></th>
    <td><input type="text" title="" id="SARefNo" name="SARefNo" placeholder="Key-in by Admin" class="w100p" /></td>
    <c:if test="${preSalesInfo.custTypeCode eq '965'}" > <!-- Company -->
        <th scope="row">Purchase Order<span class="must">*</span></th>
    </c:if>
    <c:if test="${preSalesInfo.custTypeCode eq '964'}" > <!-- Individual -->
        <th scope="row">Purchase Order</th>
    </c:if>
    <td><input type="text" title="" id="PONo" name="PONo" placeholder="Key-in by Admin" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Action<span class="must">*</span></th>
    <td colspan='3'>
         <select class="w100p"  id="action" name="action" onclick="fn_displaySpecialInst()">
            <option value="5">Approved</option>
            <option value="6">Rejected</option>
            <option value="1">Active</option>
        </select>
    </td>
</tr>
<!-- 20210321 - LaiKW - Checkbox bypass payment matching for unmatch amount -->
<c:if test="${paymentInfo.payMode eq '6507' or paymentInfo.payMode eq '6508' or paymentInfo.payMode eq '6509'}" >
<tr>
    <th scope="row">Unmatch Payment</th>
    <td colspan="3">
        <input type="checkbox" id="unmatchPayment" name="unmatchPayment" /><span class="must">Please proceed manual key in payment</span>
    </td>
</tr>
</c:if>
<tr id="specInst">
    <th scope="row" id="specialInst_header"><span>Special Instruction</span></th>
    <td colspan='3'>
    <select id="specialInstruction" name="specialInstruction" class="w100p">
        <option value="">Choose One</option>
        <c:forEach var="list" items="${specialInstruction}" varStatus="status">
               <option value="${list.code}">${list.codeName}</option>
        </c:forEach>
    </select></td>
</tr>
<tr>
    <th scope="row">Others Remark</th>
    <c:if test="${eSvmInfo.stus eq '1'}">
	    <td colspan='3'>
	        <textarea cols="40" rows="5"  id="remark" name="remark" placeholder="Others Remark" maxlength="1000">${eSvmInfo.appvRem}</textarea>
	    </td>
    </c:if>
    <c:if test="${eSvmInfo.stus ne '1'}">
	    <td colspan='3'>
	        <textarea cols="40" rows="5"  id="remark" name="remark" placeholder="Others Remark" maxlength="1000" readonly>${eSvmInfo.appvRem}</textarea>
	    </td>
    </c:if>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->