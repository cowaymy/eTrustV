<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//생성 후 반환 ID
var purchaseGridID;
var serialTempGridID;
var memGridID;
var paymentGridID;

$(document).ready(function() {



        $("#btnLedger").click(function() {
            //Common.popupDiv("/sales/pos/posSystemPop.do", '', null , true , '_insDiv');
            Common.popupDiv("/supplement/orderLedgerViewPop.do", '', null , true , '_insDiv');
        });


    //Member Search Popup
    $('#memBtnPop').click(function() {
        var callParam = {callPrgm : "1"};
    	Common.popupDiv("/common/memberPop.do", callParam, null, true);
    });

    $('#salesmanPopCd').change(function(event) {

        var memCd = $('#salesmanPopCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd, 1);
        }
    });

    //Save Btn
    $("#_saveBtn").click(function() {

    	var parcelTrackNo =  $("#_infoParcelTrackNo").val();
    	var supRefStus =  $("#_infoSupRefStus").val();
    	var supRefStg =  $("#_infoSupRefStgId").val();
    	var supRefId =  $("#_infoSupRefId").val();
    	var inputParcelTrackNo = $("#parcelTrackNo").val();
    	var supRefNo = $("#_infoSupRefNo").val();
    	var custName = $("#_infoCustName").val();
    	var custEmail = $("#_infoCustEmail").val();

    	if ($("#parcelTrackNo").val() == null || $("#parcelTrackNo").val().trim() == "") {
            Common.alert('Parcel tracking number is required.');
            return;
        }

        console.log("New Tracking No :: " + $("#parcelTrackNo").val());
        console.log("Ex Tracking No :: " + $("#_infoParcelTrackNo").val());
        console.log("_infoSupRefStus :: " + $("#_infoSupRefStus").val());
        console.log("_infoSupRefStg :: " + $("#_infoSupRefStg").val());

    	var param = {parcelTrackNo: parcelTrackNo, supRefId: supRefId, inputParcelTrackNo: inputParcelTrackNo, supRefNo: supRefNo, custName : custName, custEmail : custEmail};


    	Common.ajax('GET', "/supplement/checkDuplicatedTrackNo", param, function(result) {
    		console.log("result.length :: " + result.length);
            if(result.length > 0 ){
                Common.alert("Parcel tracking number already exist!");
                return;
            }else{
            	Common.ajax("POST", "/supplement/updateRefStgStatus.do", param, function(result) {
                    if(result.code == "00") {//successful update
                        console.log("Success");
                        Common.alert(" The tracking number for "+ supRefNo + " has been update successfully." , fn_popClose());
                    } else {
                        console.log("failed");
                        Common.alert(result.message,fn_popClose);
                       }
                 });
            }
      });

	});
});


//Close
function fn_popClose(){
	$("#_systemClose").click();
}

function fn_bookingAndpopClose(){
	$("#_systemClose").click();
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<input type="hidden" id="_infoParcelTrackNo" value="${orderInfo.parcelTrackNo}">
<input type="hidden" id="_infoSupRefStus" value="${orderInfo.supRefStusId}">
<input type="hidden" id="_infoSupRefStg" value="${orderInfo.supRefStgId}">
<input type="hidden" id="_infoSupRefId" value="${orderInfo.supRefId}">
<input type="hidden" id="_infoSupRefNo" value="${orderInfo.supRefNo}">
<input type="hidden" id="_infoCustName" value="${orderInfo.custName}">
<input type="hidden" id="_infoCustEmail" value="${orderInfo.custEmail}">


<header class="pop_header">
<h1><spring:message code="supplement.title.parcelTrackingNo" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_systemClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <%-- <li><p class="btn_blue2"><a id="_purchBtn"><spring:message code="sal.title.text.purchItems" /></a></p></li> --%>
   <%--  <li><p class="btn_blue2" ><a id="_purchMemBtn" style="display: none;"><spring:message code="sal.title.text.memList" /></a></p></li> --%>
   <li><p class="btn_blue2"><a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a></p></li>
    <!-- <li><p class="btn_blue2"><a id="_purchBtn">LEDGER</a></p></li> -->
    <%-- <li><p class="btn_blue2"><a id="_posReqSaveBtn"><spring:message code="sal.btn.save" /></a></p></li> --%>
</ul>

<section class="tap_wrap">
<!------------------------------------------------------------------------------
    Supplement Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/supplementDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Supplement Detail Page Include END
------------------------------------------------------------------------------->
</section>
<br/>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="supplement.text.parcelTrackingNo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="supplement.text.parcelTrackingNo" /></th>
    <td>
     <input type="text" title=""  class="w100p" name="parcelTrackNo" id="parcelTrackNo" />
    </td>
    <th></th>
    <td>
    </td>
</tr>
</br>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="_saveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->