<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h3>Payment Info</h3>
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
    <th scope="row">Total Amount</th>
    <td colspan=3><input id=payment_totalAmt name="payment_totalAmt" type="text" value="RM ${paymentInfo.payAmt}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Payment Mode</th>
    <td colspan=3>
        <c:if test="${paymentInfo.payMode eq '6507'}"><input id=payment_paymentMode name="payment_paymentMode" type="text" value="Cash" title="" placeholder="" class="w100p readonly" readonly /></c:if>
        <c:if test="${paymentInfo.payMode eq '6508'}"><input id=payment_paymentMode name="payment_paymentMode" type="text" value="Cheque" title="" placeholder="" class="w100p readonly" readonly /></c:if>
        <c:if test="${paymentInfo.payMode eq '6509'}"><input id=payment_paymentMode name="payment_paymentMode" type="text" value="Credit Card" title="" placeholder="" class="w100p readonly" readonly /></c:if>
        <c:if test="${paymentInfo.payMode eq '6528'}"><input id=payment_paymentMode name="payment_paymentMode" type="text" value="Credit Card (MOTO/MOTO IPP)" title="" placeholder="" class="w100p readonly" readonly /></c:if>
    </td>
</tr>
<!--  only show when payment-mode == cash/cheque [s] -->
<c:if test="${paymentInfo.payMode eq '6507' or paymentInfo.payMode eq '6508'}" >
<tr>
    <th scope="row">Transaction ID<span class="must">*</span></th>
    <td colspan=1><input id=payment_transactionID name="payment_transactionID" type="text" title="" placeholder="" class="w100p" /></td>
    <td colspan=2><input id=payment_allowCommFlg name="payment_allowCommFlg" type="checkBox" checked/>Allow commission for this payment</td>
</tr>
<tr>
    <th scope="row">TR Ref No</th>
    <td colspan=3><input id=payment_trRefNo name="payment_trRefNo" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">TR Issue Date</th>
    <td colspan=3>
        <div class="date_set w100p">
            <p><input id=payment_trIssuedDt name="payment_trIssuedDt" type="text" title="" placeholder="" class="j_date" /></p>
        </div>
    </td>
</tr>
</c:if>
<!--  only show when payment-mode == cash/cheque [e] -->
<!--  only show when payment-mode == card [s] -->
<c:if test="${paymentInfo.payMode eq '6509'}" >
<tr>
    <th scope="row">Card Mode</th>
    <td colspan=3><!--  <input id=payment_cardMode name="payment_cardMode" type="text" value="${paymentInfo.cardModeDesc}" title="" placeholder="" class="w100p readonly" readonly />-->
        <select id="payment_cardMode" name="payment_cardMode" class="w100p" disabled="true">
            <option value="">Choose One</option>
            <c:forEach var="list" items="${payment_cardMode}" varStatus="status">
                   <option value="${list.code}">${list.codeName}</option>
            </c:forEach>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Card No</th>
    <td colspan=3><input id=payment_cardNo name="payment_cardNo" type="text" value="${paymentInfo.cardNo}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Approval No</th>
    <td colspan=3><input id=payment_approvalNo name="payment_approvalNo" type="text" value="${paymentInfo.approvalNo}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Expiry Date</th>
    <td colspan=3><input id=payment_expDt name="payment_expDt" type="text" value="${paymentInfo.expiryDate}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Transaction Date</th>
    <td colspan=3><input id=payment_transactionDt name="payment_transactionDt" type="text" value="${paymentInfo.transactionDate}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Credit Card Holder Name</th>
    <td colspan=3><input id=payment_ccHolderName name="payment_ccHolderName" type="text" value="${paymentInfo.crcName}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Issued Bank</th>
    <td colspan=3><!--  <input id=payment_issuedBank name="payment_issuedBank" type="text" value="${paymentInfo.issuBankDesc}" title="" placeholder="" class="w100p readonly" readonly />-->
        <select id="payment_issuedBank" name="payment_issuedBank" class="w100p" disabled="true">
            <option value="">Choose One</option>
            <c:forEach var="list" items="${payment_issuedBank}" varStatus="status">
                   <option value="${list.code}">${list.codeName}</option>
            </c:forEach>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Card Type</th>
    <td colspan=3><!-- <input id=payment_cardType name="payment_cardType" type="text" value="${paymentInfo.cardBrandDesc}" title="" placeholder="" class="w100p readonly" readonly /> -->
        <select id="payment_cardType" name="payment_cardType" class="w100p" disabled="true">
            <option value="">Choose One</option>
            <c:forEach var="list" items="${payment_cardType}" varStatus="status">
                   <option value="${list.code}">${list.codeName}</option>
            </c:forEach>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Merchant Bank</th>
    <td colspan=3><!--  <input id=payment_merchantBank name="payment_merchantBank" type="text" value="${paymentInfo.merchantBankDesc}" title="" placeholder="" class="w100p readonly" readonly />-->
        <select id="payment_merchantBank" name="payment_merchantBank" class="w100p" disabled="true">
            <option value="">Choose One</option>
            <c:forEach var="list" items="${payment_merchantBank}" varStatus="status">
                   <option value="${list.code}">${list.codeName}</option>
            </c:forEach>
        </select>
    </td>
</tr>
</c:if>
<!--  only show when payment-mode == card [e] -->
<!--  only show when payment-mode == card moto [s] -->
<c:if test="${paymentInfo.payMode eq '6528'}" >
<tr>
    <th scope="row">Card Mode<span class="must">*</span></th>
    <!--  <td colspan=3><input id=payment_cardMode name="payment_cardMode" type="text" title="" placeholder="" class="w100p"/></td>-->
    <td colspan=3>
	    <select id="payment_cardMode" name="payment_cardMode" class="w100p" >
	        <option value="">Choose One</option>
	        <c:forEach var="list" items="${payment_cardMode}" varStatus="status">
	               <option value="${list.code}">${list.codeName}</option>
	        </c:forEach>
	    </select>
    </td>
</tr>
<tr>
    <th scope="row">Card No<span class="must">*</span></th>
    <td colspan=3><input id=payment_cardNo name="payment_cardNo" type="text" title=""  value="${paymentInfo.cardNo}" placeholder="" class="w100p creditCardText" maxlength=19 oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"/></td>
</tr>
<tr>
    <th scope="row">Approval No<span class="must">*</span></th>
    <td colspan=3><input id=payment_approvalNo name="payment_approvalNo" type="text" title="" value="${paymentInfo.approvalNo}" placeholder="" class="w100p "  /></td>
</tr>
<tr>
    <th scope="row">Expiry Date<span class="must">*</span></th>
    <td colspan=3><input id=payment_expDt name="payment_expDt" type="text" title="" value="${paymentInfo.expiryDate}" placeholder="" class="w100p " maxlength=4 oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" /></td>
</tr>
<tr>
    <th scope="row">Transaction Date<span class="must">*</span></th>
    <td colspan=3>
        <!--  <input id=payment_transactionDt name="payment_transactionDt" type="text" title="" value="${paymentInfo.transactionDate}" placeholder="" class="w100p"  />-->
        <div class="date_set w100p">
            <p><input type="text" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date" id="payment_transactionDt" value="${paymentInfo.transactionDate}" name="payment_transactionDt"/></p>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Credit Card Holder Name<span class="must">*</span></th>
    <td colspan=3><input id=payment_ccHolderName name="payment_ccHolderName" type="text" title="" value="${paymentInfo.crcName}" placeholder="" class="w100p "  /></td>
</tr>
<tr>
    <th scope="row">Issued Bank<span class="must">*</span></th>
    <!--  <td colspan=3><input id=payment_issuedBank name="payment_issuedBank" type="text" title="" placeholder="" class="w100p"  /></td> -->
    <td colspan=3>
        <select id="payment_issuedBank" name="payment_issuedBank" class="w100p" >
            <option value="">Choose One</option>
            <c:forEach var="list" items="${payment_issuedBank}" varStatus="status">
                   <option value="${list.code}">${list.codeName}</option>
            </c:forEach>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Card Type<span class="must">*</span></th>
    <!-- <td colspan=3><input id=payment_cardType name="payment_cardType" type="text" title="" placeholder="" class="w100p" /></td> -->
    <td colspan=3>
        <select id="payment_cardType" name="payment_cardType" class="w100p" >
            <option value="">Choose One</option>
            <c:forEach var="list" items="${payment_cardType}" varStatus="status">
                   <option value="${list.code}">${list.codeName}</option>
            </c:forEach>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Merchant Bank<span class="must">*</span></th>
    <!-- <td colspan=3><input id=payment_merchantBank name="payment_merchantBank" type="text" title="" placeholder="" class="w100p"  /></td> -->
    <td colspan=3>
        <select id="payment_merchantBank" name="payment_merchantBank" class="w100p" >
            <option value="">Choose One</option>
            <c:forEach var="list" items="${payment_merchantBank}" varStatus="status">
                   <option value="${list.code}">${list.codeName}</option>
            </c:forEach>
        </select>
    </td>
</tr>
</c:if>
<!--  only show when payment-mode == card moto [e] -->

</tbody>
</table><!-- table end -->


</article><!-- tap_area end -->