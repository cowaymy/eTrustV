<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
console.log("vendorRequestViewMasterPop");
var myGridID;
//var myGridData = $.parseJSON('${appvInfoAndItems}');
var vendorInfo = "${vendorInfo}";
var attachmentList = new Array();

var attachList = null;

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

//그리드 속성 설정
var mGridPros = {
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var mGridID;


var mileageGridID;

$(document).ready(function () {

    var appvPrccNo = "${vendorInfo.appvPrcssNo}";
    var vendorCountry = "${vendorInfo.addCountry}";
    var bankCountry = "${vendorInfo.bankCountry}";
    var bankList = "${vendorInfo.bank}";
    var paymentMethod = "${vendorInfo.payType}";
    var designation = "${vendorInfo.contactDesignation}";
    $("#keyDate").val("${vendorInfo.updDate}");


    $("#vendorCountry option[value='"+ vendorCountry +"']").attr("selected", true);
    $("#bankCountry option[value='"+ bankCountry +"']").attr("selected", true);
    $("#bankList option[value='"+ bankList +"']").attr("selected", true);
    $("#paymentMethod option[value='"+ paymentMethod +"']").attr("selected", true);
    $("#designation option[value='"+ designation +"']").attr("selected", true);

    $('#vendorCountry').attr("disabled", true);
    $('#bankCountry').attr("disabled", true);
    $('#bankList').attr("disabled", true);
    $('#paymentMethod').attr("disabled", true);
    $('#vendorGroup').attr("disabled", true);
    $('#designation').attr("disabled", true);

    var costCenterName =  $("#costCenterName").val();
    var costCenter =  $("#costCenter").val();
});
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View Submit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_approveView">
<input type="hidden" id="viewMemAccId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Sync to eMRO
    <c:choose>
        <c:when test="${vendorInfo.syncEmro eq '1'}">
            <input id="syncEmro" name="syncEmro" type="checkbox" onClick="return false" checked/>
        </c:when>
        <c:otherwise>
            <input id="syncEmro" name="syncEmro" type="checkbox" onClick="return false"/>
        </c:otherwise>
        </c:choose></th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="syncEmro" name="syncEmro" value="${updateUserName}"/></td>
</tr>
<tr>
    <th scope="row">Vendor Account ID</th>
    <td colspan=3><input type="text" title="" id="newVendorCode" name="vendorCode" placeholder="" class="readonly w100p" readonly="readonly" value="${vendorInfo.vendorAccId}"/></td><!--  value="${claimNo}"-->
</tr>
<tr>
    <th scope="row">Vendor Group</th>
        <td>
           <select class="w100p" id=vendorGroup name="vendorGroup">
                  <!--  <option value="VM02"<c:if test="${vendorInfo.vendorGrp eq 'VM02'}">selected="selected"</c:if>>VM02 - Coway_Supplier_Foreign</option>-->
                  <option value="VM02"<c:if test="${vendorInfo.vendorGrp eq 'VM02'}">selected="selected"</c:if>>VM02 - Coway_Supplier_Foreign</option>
                  <option value="VM03"<c:if test="${vendorInfo.vendorGrp eq 'VM03'}">selected="selected"</c:if>>VM03 - Coway_Supplier_Foreign (Related Company)</option>
                  <option value="VM11"<c:if test="${vendorInfo.vendorGrp eq 'VM11'}">selected="selected"</c:if>>VM11 - Coway_Suppliers_Local</option>
           </select>
        </td>
    <th scope="row">Key in date</th>
    <td>
    <input type="text" title="" id="keyDate" name="keyDate" placeholder="DD/MM/YYYY" class="readonly w100p" readonly="readonly"/>
    </td>
</tr>
<tr>
      <th scope="row">Cost Center</th>
      <td><input type="text" title="" placeholder="" class="readonly w100p" id="newCostCenter" name="costCentr" value="${vendorInfo.costCenter}" readonly="readonly"/></td>
    <th scope="row">Create User ID</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" id="userName" readonly="readonly" value="${vendorInfo.userName}" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th colspan=2 scope="row">Registered Company/Individual Name</th>
    <td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="regCompName" name="regCompName" value="${vendorInfo.vendorName}"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Company Registration No/IC No</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="regCompNo" name="regCompNo" value="${vendorInfo.vendorRegNoNric}"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Email Address (payment advice)</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="emailPayAdv" name="emailPayAdv" value="${vendorInfo.payAdvEmail1}"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Email Address 2 (payment advice)</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="emailPayAdv2" name="emailPayAdv2" value="${vendorInfo.payAdvEmail2}"/></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Address</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Street</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="street" name="street" value="${vendorInfo.addStreet}"/></td>
    <th scope="row">House/Lot Number</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="houseNo" name="houseNo" value="${vendorInfo.addHouseLotNo}"/></td>
</tr>
<tr>
    <th scope="row">Postal Code</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="postalCode" name="postalCode" value="${vendorInfo.addPostalCode}"/></td>
    <th scope="row">City</th>
        <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="city" name="city" value="${vendorInfo.addCity}"/></td>
</tr>
<tr>
    <th scope="row">Country</th>
        <td colspan=3>
           <select  style="text-transform:uppercase" class="readonly w100p" id="vendorCountry" name="vendorCountry">
            <c:forEach var="list" items="${countryList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
        </td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Payment Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th>Payment Terms <b>(Days)</b></th>
    <td><input type="text" min="1"  title="" placeholder="" class="readonly w100p" readonly='readonly' id="paymentTerms" name="paymentTerms" value="${vendorInfo.payTerm}"/></td>
    <th>Payment Method</th>
    <td>
        <select class="readonly w100p" id=paymentMethod name="paymentMethod">
                  <!--  <option value="CASH">CASH</option>-->
                  <option value="CASH"<c:if test="${vendorInfo.payType eq 'CASH'}">selected="selected"</c:if>>CASH</option>
                  <option value="CHEQ"<c:if test="${vendorInfo.payType eq 'CHEQ'}">selected="selected"</c:if>>CHEQUE</option>
                  <option value="OTRX"<c:if test="${vendorInfo.payType eq 'OTRX'}">selected="selected"</c:if>>ONLINE TRANSFER</option>
                  <option value="TTRX"<c:if test="${vendorInfo.payType eq 'TTRX'}">selected="selected"</c:if>>TELEGRAPHIC TRANSFER</option>
           </select>
    </td>
</tr>
<tr>
    <th>Others (Please State)</th>
    <td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="others" name="others" value="${vendorInfo.payOth}" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Bank Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Country</th>
    <td>
        <select  style="text-transform:uppercase" class="readonly w100p" id="bankCountry" name="bankCountry">
            <c:forEach var="list" items="${countryList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
    </td>
    <th scope="row">Account Holder</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="bankAccHolder" name="bankAccHolder" value="${vendorInfo.bankAccHolder}"/></td>
</tr>
<tr>
    <th scope="row">Bank</th>
    <td>
        <select class="readonly w100p" id="bankList" name="bankList">
            <option value=""<c:if test="${vendorInfo.bank eq ''}">selected="selected"</c:if>></option>
            <c:forEach var="list" items="${bankList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
    </td>
    <th scope="row">Bank Account Number</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="bankAccNo" name="bankAccNo" value="${vendorInfo.bankAccNo}"/></td>
</tr>
<tr>
    <th>Branch</th>
    <td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="branch" name="branch" value="${vendorInfo.bankBranch}"/></td>
</tr>
<tr>
    <th scope="row">Swift Code</th>
    <td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="swiftCode" name="swiftCode" value="${vendorInfo.swiftCode}"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Contact Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Designation</th>
    <td>
    <select class="w100p" id=designation name="designation">
                  <option value="Company"<c:if test="${vendorInfo.contactDesignation eq 'Company'}">selected="selected"</c:if>>Company</option>
                  <option value="Mr."<c:if test="${vendorInfo.contactDesignation eq 'Mr.'}">selected="selected"</c:if>>Mr.</option>
                  <option value="Mr. and Mrs."<c:if test="${vendorInfo.contactDesignation eq 'Mr. and Mrs.'}">selected="selected"</c:if>>Mr. and Mrs.</option>
                  <option value="Ms."<c:if test="${vendorInfo.contactDesignation eq 'Ms.'}">selected="selected"</c:if>>Ms.</option>
    </select>
    </td>
    <th scope="row"> Name</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="vendorName" name="email" value="${vendorInfo.contactName}"/></td>
</tr>
<tr>
    <th>Phone Number</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="vendorPhoneNo" name="phoneNo" value="${vendorInfo.contactPhoneNo}"/></td>
    <th>Email Address</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="vendorEmail" name="email" value="${vendorInfo.contactEmail}"/></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
</table><!-- table end -->

</form>
</section><!-- search_table end -->


<article class="grid_wrap" id="approveView_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->