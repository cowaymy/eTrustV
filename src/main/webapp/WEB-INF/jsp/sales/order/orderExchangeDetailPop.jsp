<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	
  
    $(document).ready(function(){
        
        if(initForm.initType.value == '283'){   //Product Exchange 
            $("#prodExchngDiv").show();
            $("#applicationDiv").hide();
            $("#OwnerShipDiv").hide();
        }
        if(initForm.initType.value == '282'){   //Application Exchange
            $("#prodExchngDiv").hide();
            $("#applicationDiv").show();
            $("#OwnerShipDiv").hide();
        }
        if(initForm.initType.value == '284'){   //OwnerShip Exchange
            $("#prodExchngDiv").hide();
            $("#applicationDiv").hide();
            $("#OwnerShipDiv").show();
        }
    });
    
    function fn_cancelReq(){
    	
    	var msg = "";
    	msg += "Order Number : " + ${exchangeDetailInfo.salesOrdNo }+"<br>";
//    	msg += "Exchange Type : " + ${exchangeDetailInfo.codeName } + "<br />";
//    	msg += "Request Date : " + ${exchangeDetailInfo.soExchgCrtDt } + "<br />";
//    	msg += "Request By : " + ${exchangeDetailInfo.soExchgCrtUserName } + "<br />";
    	msg += "<br />Are you sure want to cancel this request ?";
    	
//    	Common.alert(msg);

        if(initForm.initType.value == '283'){
        	Common.confirm(msg,fn_saveCancel);
        }else{
        	Common.alert("Invalid pointer. Cancellation process terminated.");
        }
    	
    }
    
    function fn_saveCancel(){
    	Common.popupDiv("/sales/order/orderExchangeRemPop.do", $("#initForm").serializeJSON(), null , true, '_exchgDiv');
    }
    
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Sales Order Exchange View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_dClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="initForm" name="initForm" method="post">
    <input type="hidden" id="initType" name="initType" value="${initType }">
    <input type="hidden" id="exchgStus" name="exchgStus" value="${exchgStus }">
    <input type="hidden" id="exchgCurStusId" name="exchgCurStusId" value="${exchgCurStusId }">
    <input type="hidden" id="salesOrderId" name="salesOrderId" value="${exchangeDetailInfo.soId }">
    <input type="hidden" id="soExchgIdDetail" name="soExchgIdDetail" value="${soExchgIdDetail }">
</form>

<aside class="title_line"><!-- title_line start -->
<h2>Exchange Information</h2>
<c:if test="${exchgStus eq 1}">
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" id="btnCancel" onclick="fn_cancelReq()">Cancel Request</a></p></li>
</ul>
</c:if>
</aside><!-- title_line end -->

<div id="prodExchngDiv" style="display:none;"><!-- Product Exchange Type start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:135px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td>
    <span>${exchangeDetailInfo.codeName }</span>
    </td>
    <th scope="row">Creator</th>
    <td>${exchangeDetailInfo.soExchgCrtUserName }
    </td>
    <th scope="row">Creator Date</th>
    <td>${exchangeDetailInfo.soExchgCrtDt }
    </td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <td>
    <span>${exchangeDetailInfo.salesOrdNo }</span>
    </td>
    <th scope="row">Request Status</th>
    <td>${exchangeDetailInfo.name2 }
    </td>
    <th scope="row">Request Stage</th>
    <td>${exchangeDetailInfo.name1 }
    </td>
</tr>
<tr>
    <th scope="row">Reason</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgResnIdCode } - ${exchangeDetailInfo.soExchgResnDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Product(From)</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgOldStkCode } - ${exchangeDetailInfo.soExchgOldStkDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Product(To)</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgNwStkCode } - ${exchangeDetailInfo.soExchgNwStkDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Price / PDF(From)</th>
    <td>
    <span>${exchangeDetailInfo.soExchgOldPrc }</span>
    </td>
    <th scope="row">PV(From)</th>
    <td>${exchangeDetailInfo.soExchgOldPv }
    </td>
    <th scope="row">Rental Fees(From)</th>
    <td>${exchangeDetailInfo.soExchgOldDefRentAmt }
    </td>
</tr>
<tr>
    <th scope="row">Price / PDF(To)</th>
    <td>
    <span>${exchangeDetailInfo.soExchgNwPrc }</span>
    </td>
    <th scope="row">PV(To)</th>
    <td>${exchangeDetailInfo.soExchgNwPv }
    </td>
    <th scope="row">Rental Fees(To)</th>
    <td>${exchangeDetailInfo.soExchgNwDefRentAmt }
    </td>
</tr>
<tr>
    <th scope="row">Promotion(From)</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgOldPromoCode } - ${exchangeDetailInfo.soExchgOldPromoDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Promotion(To)</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgNwPromoCode } - ${exchangeDetailInfo.soExchgNwPromoDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgRem }</span>
    </td>
</tr>
<tr>
    <th scope="row">Reference Number</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgFormNo }</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</div><!-- type1 end -->

<div id="applicationDiv" style="display:none;"><!-- Application Type start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:155px" />
    <col style="width:*" />
    <col style="width:135px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td>
    <span>${exchangeDetailInfo.codeName }</span>
    </td>
    <th scope="row">Creator</th>
    <td>${exchangeDetailInfo.soExchgCrtUserName }
    </td>
    <th scope="row">Creator Date</th>
    <td>${exchangeDetailInfo.soExchgCrtDt }
    </td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <td>
    <span>${exchangeDetailInfo.salesOrdNo }</span>
    </td>
    <th scope="row">Request Status</th>
    <td>${exchangeDetailInfo.name2 }
    </td>
    <th scope="row">Request Stage</th>
    <td>${exchangeDetailInfo.name1 }
    </td>
</tr>
<tr>
    <th scope="row">Reason</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgResnIdCode } - ${exchangeDetailInfo.soExchgResnDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Add Type(From)</th>
    <td>
    <span>${exchangeDetailInfo.soExchgNwAppTypeCodeName }</span>
    </td>
    <th scope="row">Price / PDF(From)</th>
    <td>${exchangeDetailInfo.soExchgOldPrc }
    </td>
    <th scope="row">PV(From)</th>
    <td>${exchangeDetailInfo.soExchgOldPv }
    </td>
</tr>
<tr>
    <th scope="row">Add Type(To)</th>
    <td>
    <span>${exchangeDetailInfo.exchgOldAppTypeCodeName }</span>
    </td>
    <th scope="row">Price / PDF(To)</th>
    <td>${exchangeDetailInfo.soExchgNwPrc }
    </td>
    <th scope="row">PV(To)</th>
    <td>${exchangeDetailInfo.soExchgNwPv }
    </td>
</tr>
<tr>
    <th scope="row">Promotion(From)</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgOldPromoCode } - ${exchangeDetailInfo.soExchgOldPromoDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Promotion(To)</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgNwPromoCode } - ${exchangeDetailInfo.soExchgNwPromoDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgRem }</span>
    </td>
</tr>
<tr>
    <th scope="row">Reference Number</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgFormNo }</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</div><!-- type2 end -->

<div id="OwnerShipDiv" style="display:none;"><!-- OwnerShip Type start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:155px" />
    <col style="width:*" />
    <col style="width:135px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td>
    <span>${exchangeDetailInfo.codeName }</span>
    </td>
    <th scope="row">Creator</th>
    <td>${exchangeDetailInfo.soExchgCrtUserName }
    </td>
    <th scope="row">Creator Date</th>
    <td>${exchangeDetailInfo.soExchgCrtDt }
    </td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <td>
    <span>${exchangeDetailInfo.salesOrdNo }</span>
    </td>
    <th scope="row">Request Status</th>
    <td>${exchangeDetailInfo.name2 }
    </td>
    <th scope="row">Request Stage</th>
    <td>${exchangeDetailInfo.name1 }
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgRem }</span>
    </td>
</tr>
<tr>
    <th scope="row">Reference Number</th>
    <td colspan="5">
    <span>${exchangeDetailInfo.soExchgFormNo }</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Customer(From)</a></li>
    <li><a href="#">Customer(To)</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td>
    <span>${exchangeInfoOwnershipFr.custId }</span>
    </td>
    <th scope="row">Customer Type</th>
    <td>${exchangeInfoOwnershipFr.codeName }
    </td>
    <th scope="row">Race</th>
    <td>${exchangeInfoOwnershipFr.raceName }
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">
    <span>${exchangeInfoOwnershipFr.name }</span>
    </td>
    <th scope="row">Nationality</th>
    <td>${exchangeInfoOwnershipFr.nationName }
    </td>
</tr>
<tr>
    <th scope="row">NRIC/Company Number</th>
    <td colspan="3">
    <span>${exchangeInfoOwnershipFr.nric }</span>
    </td>
    <th scope="row">Gender</th>
    <td>${exchangeInfoOwnershipFr.gender }
    </td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td colspan="3">
    <span>${exchangeInfoOwnershipFr.email }</span>
    </td>
    <th scope="row">DOB</th>
    <td>${exchangeInfoOwnershipFr.dob }
    </td>
</tr>
<tr>
    <th scope="row">Passport Expire</th>
    <td>
    <span>${exchangeInfoOwnershipFr.pasSportExpr }</span>
    </td>
    <th scope="row">Visa Expire</th>
    <td colspan="3">${exchangeInfoOwnershipFr.visaExpr }
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">${exchangeInfoOwnershipFr.rem }
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td>
    <span>${exchangeInfoOwnershipTo.codeName }</span>
    </td>
    <th scope="row">Customer Type</th>
    <td>${exchangeInfoOwnershipTo.codeName }
    </td>
    <th scope="row">Race</th>
    <td>${exchangeInfoOwnershipTo.raceName }
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">
    <span>${exchangeInfoOwnershipTo.name }</span>
    </td>
    <th scope="row">Nationality</th>
    <td>${exchangeInfoOwnershipTo.nationName }
    </td>
</tr>
<tr>
    <th scope="row">NRIC/Company Number</th>
    <td colspan="3">
    <span>${exchangeInfoOwnershipTo.email }</span>
    </td>
    <th scope="row">Gender</th>
    <td>${exchangeInfoOwnershipTo.gender }
    </td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td colspan="3">
    <span>${exchangeInfoOwnershipTo.email }</span>
    </td>
    <th scope="row">DOB</th>
    <td>${exchangeInfoOwnershipTo.dob }
    </td>
</tr>
<tr>
    <th scope="row">Passport Expire</th>
    <td>
    <span>${exchangeInfoOwnershipTo.pasSportExpr }</span>
    </td>
    <th scope="row">Visa Expire</th>
    <td colspan="3">${exchangeInfoOwnershipTo.visaExpr }
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">${exchangeInfoOwnershipTo.rem }
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</div><!-- type3 end -->

<aside class="title_line"><!-- title_line start -->
<h2>Order Information</h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">HP / Cody</a></li>
    <li><a href="#" onClick="javascript:chgTab('custInfo');">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a href="#">Mailling Info</a></li>
<!--<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}"> -->
    <li><a href="#">Payment Channel</a></li>
<!--</c:if> -->
    <li><a href="#" onClick="javascript:chgTab('memInfo');">Membership Info</a></li>
    <li><a href="#" onClick="javascript:chgTab('docInfo');">Document Submission</a></li>
    <li><a href="#" onClick="javascript:chgTab('callLogInfo');">Call Log</a></li>
    <!-- 
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
 -->
    <li><a href="#">Quarantee Info</a></li>
    <!-- 
</c:if> -->
    <li><a href="#" onClick="javascript:chgTab('payInfo');">Payment Listing</a></li>
    <li><a href="#" onClick="javascript:chgTab('transInfo');">Last 6 Months Transaction</a></li>
    <li><a href="#">Order Configuration</a></li>
    <li><a href="#" onClick="javascript:chgTab('autoDebitInfo');">Auto Debit Result</a></li>
    <li><a href="#">Relief Certificate</a></li>
    <li><a href="#" onClick="javascript:chgTab('discountInfo');">Discount</a></li>
</ul>


</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->