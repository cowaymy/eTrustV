<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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
        headerText : "Ref No",
        editable : false,
    }, {
        dataField : "name",
        headerText : "Status",
        editable : false
    }, {
        dataField : "email",
        headerText : "Email",
        style : "my-custom-up",
        editable : false,
    },{
        dataField : "crtDt",
        headerText : "At",
        editable : false,
    },{
        dataField : "userName",
        headerText : "By",
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
        }
    });
});

function changeBillingInfo(custBillId){
	
	Common.ajax("GET","/payment/selectChangeBillType.do", {"custBillId":custBillId}, function(result){
		
        $('#changeTypeForm #custTypeId').val(result.data.basicInfo.typeId);//hidden
        $('#changeBill_grpNo').text(result.data.basicInfo.custBillGrpNo);
        $('#changeBill_ordGrp').text(result.data.grpOrder.orderGrp);$('#changeBill_ordGrp').css("color","red");
        $('#changeBill_remark').text(result.data.basicInfo.custBillRem);
        
        if(result.data.basicInfo.custBillIsPost == "1"){
            $("#changePop_post").prop('checked', true);
        }else{
            $("#changePop_post").prop('checked', false);
        }
        
        if(result.data.basicInfo.custBillIsSms == "1"){
            $("#changePop_sms").prop('checked', true);
        }else{
            $("#changePop_sms").prop('checked', false);
        }
        
        if(result.data.basicInfo.custBillIsEstm == "1"){
            $("#changePop_estm").prop('checked', true);
            $("#changePop_estm").prop('disabled', false);
            $('#changePop_estmVal').val(result.data.basicInfo.custBillEmail);
        }else{
            $("#changePop_estm").prop('checked', false);
            $("#changePop_estm").prop('disabled', true);
            $('#changePop_estmVal').val("");
        }
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
    if($("#changePop_post").is(":checked")){
        $("#changePop_post").val(1);
    }else{
        $("#changePop_post").val(0);
    }
    
    if($("#changePop_sms").is(":checked")){
        $("#changePop_sms").val(1);
    }else{
        $("#changePop_sms").val(0);
    }
    
    if($("#changePop_estm").is(":checked")){
        $("#changePop_estm").val(1);
    }else{
        $("#changePop_estm").val(0);
    }
    
    var valid = true;
    var message = "";
    
    if($("#changePop_post").is(":checked") == false && $("#changePop_sms").is(":checked") == false && $("#changePop_estm").is(":checked") == false ){
        valid = false;
        message += "* Please select at least one billing type.<br />";
    }
    
    if($("#changePop_sms").is(":checked") && custTypeId == "965"){
        valid = false;
        message += "* SMS is not allow for company type customer.<br />";
    }
    
    if($.trim(reasonUpd) ==""){
        valid = false;
        message += "* Please key in the reason to update.<br />";
        
    }else{
        if ($.trim(reasonUpd).length > 200){
            valid = false;
            message += "* Reason to update cannot more than 200 characters.<br />";
        }
    }
    
    if(valid){
        var post = $("#changePop_post").val();
        var sms = $("#changePop_sms").val();
        var estm = $("#changePop_estm").val();
        Common.ajax("GET","/payment/saveChangeBillType.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "post" : post, "sms" : sms, "estm" : estm, "custBillEmail" :custBillEmail}, function(result){
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
    
    if($.trim(reqEmail) == ""){
        valid = false;
        message += "* Please key in the email address.<br />";
    }else{
        if(FormUtil.checkEmail($.trim(reqEmail)) == true){
            valid = false;
            message += "* The email is invalid.<br />"; 
         }
    }
    
    if($.trim(reqAdditionalEmail) != ""){
    	if(FormUtil.checkEmail($.trim(reqAdditionalEmail)) == true){
            valid = false;
            message += "* The additional email is invalid.<br />"; 
        }
    }
    
    if($.trim(reasonUpd) ==""){
        valid = false;
        message += "* Please key in the reason to update.<br />";
    }else{
        if ($.trim(reasonUpd).length > 200){
            valid = false;
            message += "* Reason to update cannot more than 200 characters.<br />";
        }
    }
    
    if(valid){
        Common.ajax("GET","/payment/saveNewReq.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "reqEmail" : reqEmail, "reqAdditionalEmail" : reqAdditionalEmail}, function(result){
            console.log(result);
            $("#newReqEmail").val("");
            $("#newReqAdditionalEmail").val("");
            $("#newReqReason").val("");
            Common.alert(result.message);
        });
        
    }else{
        Common.alert(message);
    }
}

function fn_estmReqPopClose(){
	Common.popupDiv('/payment/initChangeBillingTypePop.do', {"custBillId":custBillId, "callPrgm" : "BILLING_GROUP"}, null , true);
}

</script>

<div id="changeBillTypePop" class="popup_wrap" style=";"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1>Billing Group Maintenance - Billing Type</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" id="changeBillPopCloseBtn">CLOSE</a></p></li>
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
                                <label><input type="checkbox" id="changePop_post" name="changePop_post"/><span>Post</span></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <label><input type="checkbox" id="changePop_sms" name="changePop_sms"/><span>SMS</span></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
	                            <label><input type="checkbox" disabled="disabled"  id="changePop_estm" name="changePop_estm"/><span>E-Statement </span></label>
	                            <input type="text" title="" placeholder="" class="readonly" id="changePop_estmVal" name="changePop_estmVal"/><p class="btn_sky"><a href="javascript:fn_reqNewMail();">Request New Email</a></p>
                            </td>
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
                        <li><p class="btn_blue2 big"><a href="javascript:fn_changeBillSave();">SAVE</a></p></li>
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
                <li><p class="btn_blue2"><a href="#" onclick="fn_estmReqPopClose();">CLOSE</a></p></li>
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
                <li><p class="btn_blue2 big"><a href="javascript:fn_newReqSave();">SAVE</a></p></li>
            </ul>
        </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
<form name="changeTypeForm" id="changeTypeForm">
	<input type="hidden" name="custBillId" id="custBillId">
	<input type="hidden" name="custTypeId" id="custTypeId">
</form>
