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

 function fn_inchgDept_SelectedIndexChanged() {
    $("#ddlSubDeptUpd option").remove();
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDeptList").val(), '', '', 'ddlSubDeptUpd', 'S', '');
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
<h1>Supplement Tag Management - Approval</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_systemClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->



<section class="tap_wrap">
<!------------------------------------------------------------------------------
    Supplement Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/tagManagementContent.jsp" %>
<!------------------------------------------------------------------------------
    Supplement Detail Page Include END
------------------------------------------------------------------------------->
</section>
<br/>

<aside class="title_line"><!-- title_line start -->
<h2>Tag Approval</h2>
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
    <th scope="row"><spring:message code="service.text.InChrDept" /></th>
    <td colspan="3">
        <select class="select w100p" id="inchgDeptList" name="inchgDeptList" onChange="fn_inchgDept_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${inchgDept}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.grid.subDept" /></th>
    <td colspan="3">
    <select id='ddlSubDeptUpd' name='ddlSubDeptUpd' class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="supplement.text.supplementTagStus" /></th>
    <td colspan="3">
            <select class="select w100p"  id="tagStus" name="tagStus">
            <option value="">Choose One</option>
                <c:forEach var="list" items="${tagStus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.attachment" /></th>
    <td colspan = "3">
           <div class="auto_file">
                    <input type="file" title="file add" id="payFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
           </div>
     </td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.Remark" /></th>
    <td colspan="3">
        <input type="text" title="" placeholder="Remark" class="w100p" id="_remark" " name="remark" />
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