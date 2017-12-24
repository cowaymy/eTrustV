<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

$(document).ready(function() {
	$("#status").change(function() {
		$("#CTCode").val("");
		$("#CTName").val("");
		$("#sirimNo").val("");
		$("#serialNo").val("");
		$("#refNo1").val("");
		$("#refNo2").val("");
		$("#failReason").val("0");
		$("#nextCallDate").val("");
		$("#remark").val("");
	});
});

function fn_installProductExchangeSave(){
	Common.ajax("POST", "/services/saveInstallationProductExchange.do",  $("#insertPopupForm").serializeJSON(), function(result) {
		Common.alert("Saved",fn_saveDetailclose);

    });
}

function fn_saveDetailclose(){
	addinstallationResultProductDetailPopId.remove();
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Installation Result - Product Exchange</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form  id="insertPopupForm" method="post">
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Installation Info</a></li>
    <li><a href="#">Exchange Info</a></li>
    <li><a href="#">Order Info</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Install Type</th>
    <td><span><c:out value="${viewDetail.installationInfo.codeName}"/></span></td>
    <th scope="row">Install Number</th>
    <td><span><c:out value="${viewDetail.installationInfo.installEntryNo}"/></span></td>
    <th scope="row">Request Install Date</th>
    <td><span><fmt:formatDate value="${viewDetail.installationInfo.installDt}" pattern="dd-MM-yyyy "/></span></td>
</tr>
<tr>
    <th scope="row">Assigned Technician</th>
    <td colspan="3"><span><c:out value=" (${viewDetail.installationInfo.c1}) ${viewDetail.installationInfo.c3}"  /></span></td>
    <th scope="row">Result Status</th>
    <td><span><c:out value="${viewDetail.installationInfo.name}"/></span></td>
</tr>
<tr>
    <th scope="row">Stock Category</th>
    <td><span><c:out value="${viewDetail.installationInfo.codename1}"/></span></td>
    <th scope="row">Install Stock</th>
    <td colspan="3"><span><c:out value="( ${viewDetail.installationInfo.stkCode} ) ${viewDetail.installationInfo.stkDesc}" /></span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td><span><c:out value="${viewDetail.exchangeInfo.codeName}"/></span></td>
    <th scope="row">Creator</th>
    <td><span><c:out value="${viewDetail.exchangeInfo.c1}"/></span></td>
    <th scope="row">Create Date</th>
    <td><span><fmt:formatDate value="${viewDetail.exchangeInfo.soExchgCrtDt}" pattern="dd-MM-yyyy hh:mm a "/></span></td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <td><span><c:out value="${viewDetail.exchangeInfo.salesOrdNo}"/></span></td>
    <th scope="row">Request Status</th>
    <td><span><c:out value="${viewDetail.exchangeInfo.name2}"/></span></td>
    <th scope="row">Request Stage</th>
    <td><span><c:out value="${viewDetail.exchangeInfo.name1}"/></span></td>
</tr>
<tr>
    <th scope="row">Reason</th>
    <td colspan="5"><span><c:out value="${viewDetail.exchangeInfo.c2} - ${viewDetail.exchangeInfo.c3} "/></span></td>
</tr>
<tr>
    <th scope="row">Product (From)</th>
    <td colspan="5"><span><c:out value="${viewDetail.exchangeInfo.c10} - ${viewDetail.exchangeInfo.c11} "/></span></td>
</tr>
<tr>
    <th scope="row">Product (To)</th>
    <td colspan="5"><span><c:out value="${viewDetail.exchangeInfo.c5} - ${viewDetail.exchangeInfo.c6} "/></span></td>
</tr>
<tr>
    <th scope="row">Price / RPF (From)</th>
    <td><span><fmt:formatNumber value="${viewDetail.exchangeInfo.soExchgOldPrc}" type="number" pattern=".00"/></span></td>
    <th scope="row">PV (From)</th>
    <td><span><fmt:formatNumber value="${viewDetail.exchangeInfo.soExchgOldPv}" pattern=".00"/></span></td>
    <th scope="row">Rental Fees (From)</th>
    <td><span><fmt:formatNumber value="${viewDetail.exchangeInfo.soExchgOldRentAmt}" pattern=".00"/></span></td>
</tr>
<tr>
    <th scope="row">Price / RPF (To)</th>
    <td><span><fmt:formatNumber value="${viewDetail.exchangeInfo.soExchgNwPrc}" pattern=".00"/></span></td>
    <th scope="row">PV (To)</th>
    <td><span><fmt:formatNumber value="${viewDetail.exchangeInfo.soExchgNwPv}" pattern=".00"/></span></td>
    <th scope="row">Rental Fees (To)</th>
    <td><span><fmt:formatNumber value="${viewDetail.exchangeInfo.soExchgNwRentAmt}" pattern=".00"/></span></td>
</tr>
<tr>
    <th scope="row">Promotion (From)</th>
    <td colspan="5"><span><c:out value="${viewDetail.exchangeInfo.c7} - ${viewDetail.exchangeInfo.c8} "/></span></td>
</tr>
<tr>
    <th scope="row">Promotion (To)</th>
    <td colspan="5"><span><c:out value="${viewDetail.exchangeInfo.c12} - ${viewDetail.exchangeInfo.c13} "/></span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><c:out value="${viewDetail.exchangeInfo.c15}"/></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->

<%--
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">HP / Cody</a></li>
    <li><a href="#">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a href="#">Mailling Info</a></li>
    <li><a href="#">Rental Pay Setting</a></li>
    <li><a href="#">Membership Info</a></li>
    <li><a href="#">Document Submission</a></li>
    <li><a href="#">Call Log</a></li>
    <li><a href="#">Guarantee Info</a></li>
    <li><a href="#">Payment Listing</a></li>
    <li><a href="#">Last 6 Months Transaction</a></li>
    <li><a href="#">Order Configuration</a></li>
    <li><a href="#">Auto Debit Result</a></li>
    <li><a href="#">Relief Certificate</a></li>
    <li><a href="#">Discount</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Progress Status</th>
    <td><span><c:out value="${viewDetail.progressInfo.prgrs}"/></span></td>
    <th scope="row">Agreement No</th>
    <td><span><c:out value="${viewDetail.progressInfo.prgrs}"/></span></td>
    <th scope="row">Agreement Expiry</th>
    <td><span><c:out value="${viewDetail.progressInfo.prgrs}"/></span></td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordNo}"/></span></td>
    <th scope="row">Order Date</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordDt}"/></span></td>
    <th scope="row">Status</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordStusName}"/></span></td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td><span><c:out value="${viewDetail.basicInfo.appTypeDesc}"/></span></td>
    <th scope="row">Reference No</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordRefNo}"/></span></td>
    <th scope="row">Key At(By)</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordCrtDt} (${viewDetail.basicInfo.ordCrtUserId})"/></span></td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td><span><c:out value="${viewDetail.basicInfo.stockDesc}"/></span></td>
    <th scope="row">PO Number</th>
    <td><span><c:out value="${viewDetail.basicInfo.stockDesc}"/></span></td>
    <th scope="row">Key-inBranch</th>
    <td><span><c:out value="(${viewDetail.basicInfo.keyinBrnchCode}) ${viewDetail.basicInfo.keyinBrnchName}"/></span></td>
</tr>
<tr>
    <th scope="row">PV</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordPv}"/></span></td>
    <th scope="row">Price/RPF</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordAmt}"/></span></td>
    <th scope="row">Rental Fees</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordMthRental}"/></span></td>
</tr>
<tr>
    <th scope="row">Installment Duration</th>
    <td></td>
    <th scope="row">PV Month(Month/Year)</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordPvMonth}/${viewDetail.basicInfo.ordPvYear}"/></span></td>
    <th scope="row">Rental Status</th>
    <td><span><c:out value="${viewDetail.basicInfo.rentalStus}"/></span></td>
</tr>
<tr>
    <th scope="row">Promotion</th>
    <td colspan="3"><span><c:out value="(${viewDetail.basicInfo.ordPromoCode}) ${viewDetail.basicInfo.ordPromoDesc}"/></span></td>
    <th scope="row">Related No</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Serial Number</th>
    <td><span><c:out value="${viewDetail.tabInstallationInfo.lastInstallSerialNo}"/></span></td>
    <th scope="row">Sirim Number</th>
    <td><span><c:out value="${viewDetail.tabInstallationInfo.lastInstallSirimNo}"/></span></td>
    <th scope="row">Update At(By)</th>
    <td><span><c:out value="${viewDetail.basicInfo.updDt} (${viewDetail.basicInfo.updUserId})"/></span></td>
</tr>
<tr>
    <th scope="row">Obligation Period</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">CCP Remark</th>
    <td colspan="5"></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="divine2"><!-- divine3 start -->

<article>
<h3>Salesman Info</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Order Made By</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

<article>
<h3>Cody Info</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Service By</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody Code</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody Name</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody NRIC</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

</section><!-- divine2 start -->


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><span><c:out value="${viewDetail.basicInfo.custId}"/></span></td>
    <th scope="row">Customer Name</th>
    <td colspan="3"><span><c:out value="${viewDetail.basicInfo.custName}"/></span></td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
    <td><span><c:out value="${viewDetail.basicInfo.custType}"/></span></td>
    <th scope="row">NRIC/Company No</th>
    <td><span><c:out value="${viewDetail.basicInfo.custNric}"/></span></td>
    <th scope="row">JomPay Ref-1</th>
    <td><span><c:out value="${viewDetail.basicInfo.jomPayRef}"/></span></td>
</tr>
<tr>
    <th scope="row">Nationality</th>
    <c:if test="${viewDetail.basicInfo.custNation  != '' }">
    <td><span><c:out value="${viewDetail.basicInfo.custNation}"/></span></td>
    </c:if>
    <c:if test="${viewDetail.basicInfo.custNation  == '' }">
    <td><span>-</span></td>
    </c:if>
    <th scope="row">Gender</th>
    <c:if test="${viewDetail.basicInfo.custGender  == 'F' }">
    <td><span>Female</span></td>
    </c:if>
    <c:if test="${viewDetail.basicInfo.custGender  == 'M' }">
    <td><span>Male</span></td>
    </c:if>
    <th scope="row">Race</th>
    <c:if test="${viewDetail.basicInfo.custRace  != '' }">
    <td><span><c:out value="${viewDetail.basicInfo.custRace}"/></span></td>
    </c:if>
    <c:if test="${viewDetail.basicInfo.custRace  == '' }">
    <td><span>-</span></td>
    </c:if>
</tr>
<tr>
    <th scope="row">VA Number</th>
    <td><span><c:out value="${viewDetail.basicInfo.custVaNo}"/></span></td>
    <th scope="row">Passport Exprire</th>
    <td><span><c:out value="${viewDetail.basicInfo.custPassportExpr}"/></span></td>
    <th scope="row">Visa Exprire</th>
    <td><span><c:out value="${viewDetail.basicInfo.custVisaExpr}"/></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Same Rental Group Order(s)</h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Installation Address</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Country</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">State</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Area</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Prefer Install Date</th>
    <td><span>text</span></td>
    <th scope="row">Prefer Install Time</th>
    <td><span>text</span></td>
    <th scope="row">Postcode</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Instruction</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">DSC Verification Remark</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Installed Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td><span>text</span></td>
    <th scope="row">CT Name</th>
    <td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span><c:out value="${viewDetail.basicInfo.custVisaExpr}"/></span></td>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span><c:out value="${viewDetail.basicInfo.custVisaExpr}"/></span></td>
    <th scope="row">Email</th>
    <td><span>text</span></td>
    <th scope="row">Fax No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>text</span></td>
    <th scope="row">Department</th>
    <td><span>text</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Mailing Address</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Country</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">State</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Area</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Billing Group</th>
    <td><span>text</span></td>
    <th scope="row">Billing Type</th>
    <td>
    <label><input type="checkbox" /><span>SMS</span></label>
    <label><input type="checkbox" /><span>Post</span></label>
    <label><input type="checkbox" /><span>E-statement</span></label>
    </td>
    <th scope="row">Postcode</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>text</span></td>
    <th scope="row">Email</th>
    <td><span>text</span></td>
    <th scope="row">Fax No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>text</span></td>
    <th scope="row">Departiment</th>
    <td><span>text</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Guarantee Status</th>
    <td colspan="3"><span>text</span></td>
</tr>
<tr>
    <th scope="row">HP Code</th>
    <td><span>text</span></td>
    <th scope="row">HP Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">HM Code</th>
    <td><span>text</span></td>
    <th scope="row">HM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">SM Code</th>
    <td><span>text</span></td>
    <th scope="row">SM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">GM Code</th>
    <td><span>text</span></td>
    <th scope="row">GM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">BS Availability</th>
    <td><span>text</span></td>
    <th scope="row">BS Frequency</th>
    <td><span>text</span></td>
    <th scope="row">Last BS Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">BS Cody Code</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Config Remark</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Happy Call Service</th>
    <td colspan="5">
    <label><input type="checkbox" /><span>Installation Type</span></label>
    <label><input type="checkbox" /><span>BS Type</span></label>
    <label><input type="checkbox" /><span>AS Type</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Prefer BS Week</th>
    <td colspan="5">
    <label><input type="radio" name="week" /><span>None</span></label>
    <label><input type="radio" name="week" /><span>Week1</span></label>
    <label><input type="radio" name="week" /><span>Week2</span></label>
    <label><input type="radio" name="week" /><span>Week3</span></label>
    <label><input type="radio" name="week" /><span>Week4</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reference No</th>
    <td><span>text</span></td>
    <th scope="row">Certificate Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">GST Registration No</th>
    <td colspan="3"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end --> --%>

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Result</h3>
</aside><!-- title_line end -->

<input type="hidden" value="${viewDetail.installationInfo.c2}" id="hiddenAssignCTMemId" name="hiddenAssignCTMemId"/>
<input type="hidden" value="${viewDetail.installationInfo.c5}" id="hiddenAssignCTWHId" name="hiddenAssignCTWHId"/>
<input type="hidden" value="${viewDetail.installationInfo.installStkId}" id="hiddenInstallStkId" name="hiddenInstallStkId"/>
<input type="hidden" value="${viewDetail.installationInfo.c8}" id="hiddenInstallStkCategoryId" name="hiddenInstallStkCategoryId"/>
<input type="hidden" value="${viewDetail.installationInfo.c6}" id="hiddenDSCBranchId" name="hiddenDSCBranchId"/>
<input type="hidden" value="${viewDetail.installationInfo.c10}" id="hiddenDOWarehouseCode" name="hiddenDOWarehouseCode"/>
<input type="hidden" value="${viewDetail.installationInfo.c9}" id="hiddenDOWarehouseId" name="hiddenDOWarehouseId"/>
<input type="hidden" value="${viewDetail.basicInfo.ordId}" id="hiddenOrderId" name="hiddenOrderId"/>
<input type="hidden" value="${viewDetail.basicInfo.ordStusId}" id="hiddenOrderStatusId" name="hiddenOrderStatusId"/>
<input type="hidden" value="${viewDetail.basicInfo.appTypeCode}" id="hiddenAppTypeCode" name="hiddenAppTypeCode"/>
<input type="hidden" value="${viewDetail.installationInfo.installEntryNo}" id="hiddenInstallNo" name="hiddenInstallNo"/>
<input type="hidden" value="${viewDetail.installationInfo.installEntryId}" id="hiddenInstallEntryId" name="hiddenInstallEntryId"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" id="status" name="status">
        <c:forEach var="list" items="${viewDetail.installStatus}" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Actual Install Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="acInstallDate" name="acInstallDate" /></td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td><input type="text" title="" placeholder="" class="" id="CTCode" name="CTCode"/><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    <input type="hidden" title="" placeholder="" class="" id="CTID" name="CTID"/>
    </td>
    <th scope="row">CT Name</th>
    <td><input type="text" title="" placeholder="" class="" id="CTName" name="CTName"/></td>
</tr>
<tr>
    <th scope="row">Sirim Number</th>
    <td><input type="text" title="" placeholder="" class="" id="sirimNo" name="sirimNo"/></td>
    <th scope="row">Serial Number</th>
    <td><input type="text" title="" placeholder="" class="" id="serialNo" name="serialNo"/></td>
</tr>
 <tr>
    <th scope="row">Ref Number (1)</th>
    <td><input type="text" title="" placeholder="" class="" id="refNo1" name="refNo1"/></td>
    <th scope="row">Ref Number (2)</th>
    <td><input type="text" title="" placeholder="" class="" id="refNo2" name="refNo2"/></td>
</tr>
<tr>
    <th scope="row">Failed Reason</th>
    <td><input type="text" title="" placeholder="" class="" id="failReason" name="failReason"/></td>
    <th scope="row">Next Call Date</th>
    <td><input type="text" title="" placeholder="" class="" id="nextCallDate" name="nextCallDate"/></td>
</tr>
<tr>
    <td colspan="4">
    <label><input type="checkbox" id="checkCommission" name="checkCommission"/><span>Allow Commission ?</span></label>
    <label><input type="checkbox" id="reqSms" name="reqSms"/><span>Require SMS ?</span></label>
    <label><input type="checkbox" id="checkTrade" name="checkTrade"/><span>Is trade in ?</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea cols="20" rows="5" placeholder="" id="remark" name="remark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_installProductExchangeSave()">Save</a></p></li>
</ul>
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->