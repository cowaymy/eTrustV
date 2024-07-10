<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
var myGridID;
var estmHisPopGridID;
var callPrgm = '${callPrgm}';
var custBillId = '${custBillId}';
var tinID = 0;
//Grid에서 선택된 RowID
var selectedGridValue;

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 20
};

//AUIGrid 칼럼 설정
var estmHisPopColumnLayout = [
    {
        dataField : "refNo",
        headerText : "<spring:message code='pay.head.refNo'/>",
        editable : false,
    }, {
        dataField : "name",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false
    }, {
        dataField : "email",
        headerText : "<spring:message code='pay.head.email'/>",
        style : "my-custom-up",
        editable : false,
    },{
        dataField : "crtDt",
        headerText : "<spring:message code='pay.head.at'/>",
        editable : false,
    },{
        dataField : "userName",
        headerText : "<spring:message code='pay.head.by'/>",
        editable : false,
}];

$(document).ready(function(){
	changeBillingInfo(custBillId);
	$('#changeTypeForm #custBillId').val(custBillId);//hidden
});

$(function(){
    $('#changeBillPopCloseBtn').click(function() {
        if(callPrgm == 'BILLING_GROUP'){
            searchList();
        }else if(callPrgm == 'BILLING_GROUP_ADMIN'){
        	searchList();
        }
    });
});

function changeBillingInfo(custBillId){

	Common.ajax("GET","/payment/selectChangeBillType.do", {"custBillId":custBillId}, function(result){
		console.log(result);
        $('#changeTypeForm #custTypeId').val(result.data.basicInfo.typeId);//hidden
        $('#changeBill_grpNo').text(result.data.basicInfo.custBillGrpNo);
        $('#changeBill_ordGrp').text(result.data.grpOrder.orderGrp);$('#changeBill_ordGrp').css("color","red");
        $('#changeBill_remark').text(result.data.basicInfo.custBillRem);

        var isPost = result.data.basicInfo.custBillIsPost;
        var isSms = result.data.basicInfo.custBillIsSms;
        var isEstm = result.data.basicInfo.custBillIsEstm;

        if(isPost == 1 && isSms == 1 && isEstm == 1){
        	$("#changePop_estm").prop('checked', true);
        	$("#changePop_estm").prop('disabled', false);
          $('#changePop_estmVal').val(result.data.basicInfo.custBillEmail);
        }else if(isPost == 1 && isSms == 1 && isEstm == 0){
        	$("#changePop_sms").prop('checked', true);
        }else if(isPost == 1 && isSms == 0 && isEstm == 0){
        	$("#changePop_post").prop('checked', true);
        }else if(isPost == 0 && isSms == 1 && isEstm == 0){
        	$("#changePop_sms").prop('checked', true);
        }else if(isPost == 0 && isSms == 0 && isEstm == 1){
        	$("#changePop_estm").prop('checked', true);
        	$("#changePop_estm").prop('disabled', false);
          $('#changePop_estmVal').val(result.data.basicInfo.custBillEmail);
        }else if(isPost == 0 && isSms == 1 && isEstm == 1){
        	$("#changePop_estm").prop('checked', true);
        	$("#changePop_estm").prop('disabled', false);
          $('#changePop_estmVal').val(result.data.basicInfo.custBillEmail);
        }else if(isPost == 1 && isSms == 0 && isEstm == 1){
        	$("#changePop_estm").prop('checked', true);
        	$("#changePop_estm").prop('disabled', false);
          $('#changePop_estmVal').val(result.data.basicInfo.custBillEmail);
        }else{
        	$("#changePop_sms").prop('checked', false);
        	$("#changePop_estm").prop('checked', true);
        	$("#changePop_post").prop('checked', false);
        }

        var eInvFlg = result.data.basicInfo.eInvFlg;
        $("#changePop_isEInvoice").prop('checked', false); //reset
        tinID = result.data.basicInfo.tinId;

        var custTypeId = $('#changeTypeForm #custTypeId').val();
        if(eInvFlg == 1){
            $("#changePop_isEInvoice").prop('checked', true);
        }
        else{
            $("#changePop_isEInvoice").prop('checked', false);
        }

        //20240710 [CELESTE]: Turn off due to unable to collect back all the TIN from Corporate customer. WIND requested to temporarily turn off the checking.
        /*if(custTypeId == "965"){
        	 $("#changePop_isEInvoice").prop('checked', true); // Mandatory for corporate
        	//$("#changePop_isEInvoice").prop('disabled', true);
        	$("#changePop_isEInvoice").on('click', function() {
        		return false;
        	});
        }else{
            if(eInvFlg == 1){
                $("#changePop_isEInvoice").prop('checked', true);
            }
            else{
                $("#changePop_isEInvoice").prop('checked', false);
            }
        }*/

        AUIGrid.destroy(estmHisPopGridID);
        estmHisPopGridID = GridCommon.createAUIGrid("estmHisPopGrid", estmHisPopColumnLayout,null,gridPros);
        AUIGrid.setGridData(estmHisPopGridID, result.data.estmReqHistory);
        AUIGrid.resize(estmHisPopGridID,935,300);
    });
}

function fn_changeBillSave(){

    var custBillEmail = $('#changePop_estmVal').val();
    var reasonUpd = $("#changePop_Reason").val();
    var custBillId = $("#changeTypeForm #custBillId").val();
    var custTypeId = $('#changeTypeForm #custTypeId').val();
    var valid = true;
    var message = "";
    var isPost = 0;
    var isSms = 0;
    var isEstm = 0;
    var isEInvFlg = 0;
    if($("#changePop_post").is(":checked")){
    	isPost = 1;
    }else{
    	isPost = 0;
    }

    if($("#changePop_sms").is(":checked")){
        isSms = 1;
    }else{
    	isSms = 0;
    }

    if($("#changePop_estm").is(":checked")){

    	if(custBillEmail == ''){
    		Common.alert("* Please request new email.");
    		return;
    	}

    	isEstm = 1;
    }else{
    	isEstm = 0;
    }

    if($("#changePop_isEInvoice").is(":checked")){
    	isEInvFlg = 1;
    }else{
    	isEInvFlg = 0;
    }

    if($("#changePop_post").is(":checked") == false && $("#changePop_sms").is(":checked") == false && $("#changePop_estm").is(":checked") == false ){
        valid = false;
        message += "<spring:message code='pay.alert.selectBillingType'/>";
    }

    if($("#changePop_sms").is(":checked") && custTypeId == "965"){
        valid = false;
        message += "<spring:message code='pay.alert.smsNotAllow.'/>";
    }

  //20240710 [CELESTE]: Turn off due to unable to collect back all the TIN from Corporate customer. WIND requested to temporarily turn off the checking.
    /* if($("#changePop_isEInvoice").is(":checked") == true && tinID == "0"){
    	valid = false;
    	message += "* E-Invoice is not allow. Please update customer's TIN number in Customer Management before choosing e-Invoice. <br />";
    } */

    if($.trim(reasonUpd) ==""){
        valid = false;
        message += "<spring:message code='pay.alert.reasonToUpdate'/>";

    }else{
        if ($.trim(reasonUpd).length > 200){
            valid = false;
            message += "<spring:message code='pay.alert.than200Characters.'/>";
        }
    }

    if(valid){

        Common.ajax("GET","/payment/saveChangeBillType.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "post" : isPost, "sms" : isSms, "estm" : isEstm, "custBillEmail" :custBillEmail, "isEInvFlg" :isEInvFlg}, function(result){
            console.log(result);
            Common.alert(result.message);
        });
    }else{
        Common.alert(message);
    }
}

function fn_reqNewMail(){
    $("#estmNewReqPop").show();
}

function fn_newReqSave(){
    var reqEmail = $("#newReqEmail").val();
    var reqAdditionalEmail = $("#newReqAdditionalEmail").val();
    var reasonUpd = $("#newReqReason").val();
    var custBillId = $("#changeTypeForm #custBillId").val();
    var valid = true;
    var message = "";

    if ($.trim(reqEmail) === "") {
    	  valid = false;
    	  message += "<spring:message code='pay.alert.emailAddress.'/>";
    	} else {
    	  // Regular expression pattern to validate email address
    	  var pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    	  if (!pattern.test($.trim(reqEmail))) {
    	    valid = false;
    	    message += "<spring:message code='pay.alert.invalidEmail'/>";
    	  }
    	}

    	if ($.trim(reqAdditionalEmail) !== "") {
    	  // Regular expression pattern to validate email address
    	  var pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    	  if (!pattern.test($.trim(reqAdditionalEmail))) {
    	    valid = false;
    	    message += "<spring:message code='pay.alert.invalidAddEmail'/>";
    	  }
    	}


    if($.trim(reasonUpd) ==""){
        valid = false;
        message += "<spring:message code='pay.alert.reasonToUpdate'/>";
    }else{
        if ($.trim(reasonUpd).length > 200){
            valid = false;
            message += "<spring:message code='pay.alert.than200Characters'/>";
        }
    }

    if(valid){
        Common.ajax("GET","/payment/saveNewReq.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "reqEmail" : reqEmail, "reqAdditionalEmail" : reqAdditionalEmail}, function(result){
            console.log(result);
            $("#newReqEmail").val("");
            $("#newReqAdditionalEmail").val("");
            $("#newReqReason").val("");
            Common.alert(result.message);
            $("#estmNewReqPop").hide();
            $("#changeBillTypePop").hide();
            if(callPrgm == 'BILLING_GROUP'){
                searchList();
            }else if(callPrgm == 'BILLING_GROUP_ADMIN'){
            	searchList();
            }
        });

    }else{
        Common.alert(message);
    }
}

function fn_estmReqPopClose(){
	Common.popupDiv('/payment/initChangeBillingTypePop.do', {"custBillId":custBillId, "callPrgm" : "BILLING_GROUP_ADMIN"}, null , true);
}

</script>

<div id="changeBillTypePop" class="popup_wrap" style=";"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1>Billing Group Maintenance - Billing Type</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" id="changeBillPopCloseBtn"><spring:message code='sys.btn.close'/></a></p></li>
            </ul>
        </header><!-- pop_header end -->
        <section class="pop_body"><!-- pop_body start -->
            <section class="tap_wrap"><!-- tap_wrap start -->
                <ul class="tap_type1">
                    <li><a href="#" class="on" id="tab_billType" >Billing Type Info</a></li>
                    <li><a href="#" id="tab_estmHis">E-Statement History</a></li>
                </ul>
                <article class="tap_area"><!-- tap_area start -->
                    <table class="type1"><!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:140px" />
                            <col style="width:*" />
                            <col style="width:180px" />
                            <col style="width:*" />
                        </colgroup>
                        <tbody>
                        <tr>
                            <th scope="row">Billing Group</th>
                            <td id="changeBill_grpNo">
                            </td>
                            <th scope="row">Total Order In Group</th>
                            <td id="changeBill_ordGrp">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" rowspan="3">Current Bill Type</th>
                            <td colspan="3">
                                <label><input type="radio" id="changePop_post" name="billType"/><span>Post</span></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <label><input type="radio" id="changePop_sms" name="billType"/><span>SMS</span></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
	                            <label><input type="radio"   id="changePop_estm" name="billType"/><span>E-Statement </span></label>
	                            <input type="text" title="" placeholder="" class="readonly" id="changePop_estmVal" name="changePop_estmVal" readonly="readonly"/><p class="btn_sky"><a href="javascript:fn_reqNewMail();"><spring:message code='pay.btn.requestNewEmail'/></a></p>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">E-Invoice</th>
                            <td colspan="3"><input id="changePop_isEInvoice" name="changePop_isEInvoice" type="checkbox" /></td> <!-- If checked, e-Invoice else remain as Tax Invoice -->
                        </tr>
                        <tr>
                            <th scope="row">Reason Update</th>
                            <td colspan="3">
                                <textarea cols="20" rows="5" placeholder="" id="changePop_Reason"></textarea>
                            </td>
                        </tr>
                        </tbody>
                    </table><!-- table end -->
                    <ul class="center_btns">
                        <li><p class="btn_blue2 big"><a href="javascript:fn_changeBillSave();"><spring:message code='sys.btn.save'/></a></p></li>
                    </ul>
                </article><!-- tap_area end -->
                <article class="tap_area"><!-- tap_area start -->
                    <article id="estmHisPopGrid" class="grid_wrap"><!-- grid_wrap start -->
                    </article><!-- grid_wrap end -->
                </article><!-- tap_area end -->
            </section><!-- tap_wrap end -->
        </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
<div id="estmNewReqPop" class="popup_wrap size_small" style="display: none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1>E-Statement - New Request</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" onclick="fn_estmReqPopClose();"><spring:message code='sys.btn.close'/></a></p></li>
            </ul>
        </header><!-- pop_header end -->
        <section class="pop_body"><!-- pop_body start -->
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Email</th>
                        <td>
                            <input type="text" id="newReqEmail" name="newReqEmail" title="" placeholder="" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Additional Email</th>
                        <td>
                            <input type="text" id="newReqAdditionalEmail" name="newReqAdditionalEmail" title="" placeholder="" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Reason Update</th>
                        <td>
                        <textarea cols="20" rows="5" placeholder="" id="newReqReason"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="javascript:fn_newReqSave();"><spring:message code='sys.btn.save'/></a></p></li>
            </ul>
        </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
<form name="changeTypeForm" id="changeTypeForm">
	<input type="hidden" name="custBillId" id="custBillId">
	<input type="hidden" name="custTypeId" id="custTypeId">
</form>
