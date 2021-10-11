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
    </td>
</tr>
<!--  only show when payment-mode == cash/cheque [s] -->
<c:if test="${paymentInfo.payMode eq '6507' || paymentInfo.payMode eq '6508'}" >
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
    <td colspan=3><input id=payment_trIssuedDt name="payment_trIssuedDt" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</c:if>
<!--  only show when payment-mode == cash/cheque [e] -->
<!--  only show when payment-mode == card [s] -->
<c:if test="${paymentInfo.payMode eq '6509'}" >
<tr>
    <th scope="row">Card Mode</th>
    <td colspan=3><input id=payment_cardMode name="payment_cardMode" type="text" value="${paymentInfo.cardModeDesc}" title="" placeholder="" class="w100p readonly" readonly /></td>
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
    <th scope="row">Expiry Date (CVV)</th>
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
    <td colspan=3><input id=payment_issuedBank name="payment_issuedBank" type="text" value="${paymentInfo.issuBankDesc}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Card Type</th>
    <td colspan=3><input id=payment_cardType name="payment_cardType" type="text" value="${paymentInfo.cardBrandDesc}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Merchant Bank</th>
    <td colspan=3><input id=payment_merchantBank name="payment_merchantBank" type="text" value="${paymentInfo.merchantBankDesc}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
</c:if>
<!--  only show when payment-mode == card [e] -->

</tbody>
</table><!-- table end -->


</article><!-- tap_area end -->