<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!-- ############  Tooltip ######################-->
<style type="text/css">
    [data-tooltip-text]:hover {
    position: relative;
}
[data-tooltip-text]:hover:after {
    background-color: #000000;
    background-color: rgba(0, 0, 0, 0.8);

    -webkit-box-shadow: 0px 0px 3px 1px rgba(50, 50, 50, 0.4);
    -moz-box-shadow: 0px 0px 3px 1px rgba(50, 50, 50, 0.4);
    box-shadow: 0px 0px 3px 1px rgba(50, 50, 50, 0.4);

    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;

    color: #FFFFFF;
    font-size: 10px;
    content: attr(data-tooltip-text);

  margin-bottom: 10px;
    top: 130%;
    left: -50%;
    padding: 7px 12px;
    position: absolute;
    width: auto;
    min-width: 150px;
    max-width: 3000px;
    word-wrap: break-word;
    word-break:break-word;
    white-space:pre;
    text-overflow:clip;
    z-index: 9999;
}
</style>
<!-- ############  Tooltip ######################-->

<script type="text/javascript">

//Create and Return ID
var smsGridID;

var optionComboReason = {
        type: "S",
        chooseMessage: '<spring:message code="sal.combo.choose.msg.noReasonCode" />',
        isShowChoose: true
};

var optionComboFeedback = {
        type: "S",
        chooseMessage: '<spring:message code="sal.combo.choose.msg.noFeedbackCode" />',
        isShowChoose: true
};

var optionComboStatus = {
        type: "S",
        chooseMessage: '<spring:message code="sal.combo.choose.msg.noRosStus" />',
        isShowChoose: true
};


$(document).ready(function() {/////////////////////////////////////////////////////////////////////////////// Doc Ready Func Start

    console.log("ordID : " + '${ordId}');
    console.log("billID : " + '${custBillId}');

	createSMSGrid();
	//Init
	CommonCombo.make("_mainReason", "/sales/rcms/getReasonCodeList", {typeId : '1175' , stusCodeId : '1'}, '', optionComboReason);  //Reason Code
	CommonCombo.make("_rosStatus", "/common/selectCodeList.do", {groupCode : '391'}, '', optionComboStatus);  //Reason Code
	//doGetCombo('/common/selectCodeList.do', '8', '','cmbTypeId', 'M' , 'f_multiCombo');            // Customer Type Combo Box

	//Change Reason Func
	$("#_mainReason").change(function() {

		if($(this).val() == null || $(this).val() == ''){
			$("#_feedback").val('');
			$("#_feedback").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
		}else{
			$("#_feedback").attr({"disabled" : false , "class" : "w100p"});
			CommonCombo.make("_feedback", "/sales/rcms/getFeedbackCodeList", {resnId : $(this).val()}, '', optionComboFeedback);
		}
	});

	//Save
	$("#_rosCallSaveBtn").click(function() {

		if(fn_validation() == true){

			if($("#_groupRemSync").is(":checked") == true ){

				var rtnList;

				rtnList = fn_chkROSCallLogBillGroupOrderCount();

				if(rtnList.length > 1){
					Common.confirm('<spring:message code="sal.title.text.tot" />' + rtnList.length + '<spring:message code="sal.alert.msg.areUsureWantToUpdate" />', fn_save);
				}else{
					fn_save();
				}
			}else{
				fn_save();
			}
		}else{
			console.log("validation false....");
		}

	});
});////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Doc Ready Func End

function fn_save(){

	if($("#_groupRemSync").is(":checked") == true ){
		$("#_chkGrp").val("1");
	}else{
		$("#_chkGrp").val("0");
	}

	if($("#_smsChk").is(":checked") == true ){
		$("#_chkSmS").val("1");
	}else{
		$("#_chkSmS").val("0");
	}

	var resultStr = fn_makeTime($("#_reCallYMD").val() , $("#_reCallTime").val());
	$("#_reCallDate").val(resultStr);

	 Common.ajax("POST", "/sales/rcms/insertNewRosCall", $("#_insForm").serializeJSON() , function(result) {

		 console.log("result.isResult : " + result.isResult);
		 console.log("result.chkSms : " + result.chkSms);
		 console.log("result.total : " + result.total);
		 console.log("result.success : " + result.success);

		if(result != null){
			if(result.isResult == true){
				if(result.chkSms > 0){
					console.log("send SMS Result : " + result.smsResultMSg);
					if(result.total == result.success){
	                    Common.alert('<spring:message code="sal.alert.msg.rosMarkSuccessfullySavedSMSAlready" />');
	                    $("#_newRosCallClose").click(); //close Pop
	                }else{
	                    Common.alert('<spring:message code="sal.alert.msg.rosMarkSuccessfullySavedSMSfail" />');
	                    $("#_newRosCallClose").click(); //close Pop
	                }
				}else{
					Common.alert('<spring:message code="sal.alert.msg.rosRemSuccessfullySaved" />');
					$("#_newRosCallClose").click(); //close Pop
				}
			}else{
				Common.alert('<spring:message code="sal.alert.msg.failToSaveRosRemTryAgain" />');
			}
		}else{
			Common.alert('<spring:message code="sal.alert.msg.failToPrepareSaveData" />');
		}
	});
}

function fn_reloadPage(){
	$("#_newRosCallClose").click();
	$("#_searchBtn").click();
}

function fn_validation(){

	//1. Action
	if($("#_action").val() == null || $("#_action").val() == ''){
		Common.alert('<spring:message code="sal.alert.msg.plzSelTheAction" />');
		return false;
	}

	//2. Main Reason
	if($("#_mainReason").val() == null || $("#_mainReason").val() == ''){
		Common.alert('<spring:message code="sal.alert.msg.selTheMainReason" />');
		return false;
	}

	//3.Feedback
	if($("#_feedback").val() == null || $("#_feedback").val() == ''){
		Common.alert('<spring:message code="sal.alert.msg.selTheFeedbackCode" />');
		return false;
	}

	//4. Collect Amt
	if($("#_collectAmt").val() == null || $("#_collectAmt").val() == ''){
		Common.alert('<spring:message code="sal.alert.msg.plzKeyInAmount" />');
		return false;
	}

	//5. Amt Check
/* 	if(Number($("#_collectAmt").val()) < 0){
		Common.alert("* Collection amount must be larger than 0.<br />");
        return false;
	} */

	//6. Remark
    if($("#_rosRem").val() == null || $("#_rosRem").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.plzKeyInRosRemark" />');
        return false;
    }

	//7.SMS
    if($("#_smsChk").is(":checked") == true ){

    	if($("#_smsRem").val() == null || $("#_smsRem").val() == '' ){
    		 Common.alert('<spring:message code="sal.alert.msg.plzKeyIntheSmsRem" />');
    	        return false;
    	}

    	var orderNo = '${ordNo}';
    	var feedbackStr = '';
    	feedbackStr =  $("#_feedback option:selected").text().trim();

    	var fullSMS = '';
    	fullSMS = orderNo + ' ' + feedbackStr + $("#_smsRem").val().trim();
    	console.log("fullSMS : " + fullSMS);
    	console.log("fullSMS.length : " + fullSMS.length);
    	if(fullSMS.length > 160){
    		Common.alert('<spring:message code="sal.alert.msg.smsMsgExceed160Char" />');
    		$("#_fullSms").val('');
    		return false;
    	}
    	$("#_fullSms").val(fullSMS);
    }

	return true;
}


function fn_chkROSCallLogBillGroupOrderCount(){

	var ajaxOpt = {async: false};
	var resultList;
	Common.ajax("GET", "/sales/rcms/selectROSCallLogBillGroupOrderCnt", {custBillId : '${custBillId}'}, function(result) {
		if(result != null ){
			resultList = result;
		}else{
			Common.alert("Server Error. Please try again.");
		}
	},'', ajaxOpt);

	return resultList;
}

function createSMSGrid(){

	var smsLayout = [
	                  {   dataField : "code",     headerText : '<spring:message code="sal.title.type" />',     width :'10%' }
	                 ,{   dataField : "rem",  headerText : '<spring:message code="sal.text.remark" />',         width : '65%' }
	                 ,{   dataField : "userName",    headerText : '<spring:message code="sal.text.creator" />',        width : '15%' }
	                 ,{   dataField : "callCrtDt", headerText : '<spring:message code="sal.text.createDate" />',   width : '10%' }
	                ];


	var smsGridPros = {
	        usePaging           : true,         //페이징 사용
	        pageRowCount        : 5,           //한 화면에 출력되는 행 개수 20(기본값:20)
	        editable            : false,
	        fixedColumnCount    : 0,
	        showStateColumn     : true,
	        displayTreeOpen     : false,
	//        selectionMode       : "singleRow",  //"multipleCells",
	        headerHeight        : 30,
	        useGroupingPanel    : false,        //그룹핑 패널 사용
	        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        showRowNumColumn    : true
	    };

	smsGridID = GridCommon.createAUIGrid("grid_sms_ticket_wrap", smsLayout, "", smsGridPros);

	//Set Grid

	if('${ordId}' != null){
		Common.ajax("GET", "/sales/rcms/selectROSSMSCodyTicketLogList", {ordId : '${ordId}'}, function(result){
			AUIGrid.setGridData(smsGridID, result);
	    });
	}
}

function fn_chkDate(id,inputDate){

    var d = new Date();
    var keyinArr;
    keyinArr = inputDate.split('/');
    var keyinDate = new Date(keyinArr[2] , keyinArr[1] , keyinArr[0]);
    var currDate = new Date(d.getFullYear(), (d.getMonth() + 1), d.getDate());
    var gap = (keyinDate.getTime() - currDate.getTime())/1000/60/60/24;
    //console.log("gap : " + gap);
    if(gap > 90){
    	Common.alert("Can not be bigger than 90days");
    	$("#_ptpDate").val('');
    	$("#_ptpDate").focus();
    }

    if(gap < 0 ) {
        $("#"+id).val('');
        $("#"+id).focus();
    	Common.alert('<spring:message code="sal.alert.msg.previousDtNtAllowed" />');
    }
}

/*** Input Number Only ***/
var prev = "";
var regexp = /^\d*(\.\d{0,2})?$/;

function fn_inputAmt(obj){

    if(obj.value.search(regexp) == -1){
        obj.value = prev;
    }else{
        prev = obj.value;
    }
}
/*** ************* ***/

 function fn_chkMaxAmtCheck(value){

	if(value > 10000){
		$("#_collectAmt").val("10000");
	}else if(value < 0){
		$("#_collectAmt").val("0");
	}else{
		$("#_collectAmt").val(value);
	}
}

 function fn_editRentPaySetting() {

	//DIV --Grid ID Dup...
	//Common.popupDiv("/sales/rcms/orderModifyPop.do", {salesOrderId : '${ordId}' , ordEditType : 'PAY'}, null, true);


	//Window
	var winPopOpt = {width: "1000px",  height: "500px" };
	Common.popupWin("_winPopForm", "/sales/rcms/orderModifyPop.do", winPopOpt);''

}

 function  isValidMobileNo(inputContact){


	    if(isNaN(inputContact) == true){
	    	return false;
	    }
	    if(inputContact.length != 10 && inputContact != 11){
	    	return false;
	    }
	    if( inputContact.substr(0 , 3) != '010' &&
	        inputContact.substr(0 , 3) != '011' &&
	        inputContact.substr(0 , 3) != '012' &&
	        inputContact.substr(0 , 3) != '013' &&
	        inputContact.substr(0 , 3) != '014' &&
	        inputContact.substr(0 , 3) != '015' &&
	        inputContact.substr(0 , 3) != '016' &&
	        inputContact.substr(0 , 3) != '017' &&
	        inputContact.substr(0 , 3) != '018' &&
	        inputContact.substr(0 , 3) != '019'
	      ){
	    	return false;
	    }
	    return true;
}

function fn_chkValidNumber(){

	if($("#_smsChk").is(":checked") == true){

		if($("#_salesManMemCode").val() != null && $("#_salesManMemCode").val() != ''){

			if(isValidMobileNo($("#_salesManMemTelMobile").val().trim()) == true){
				//Valid Success
		        $("#_smsRem").attr({"class" : "" , "disabled" : false});
			}else{
				$('#_smsChk').attr('checked', false);
				$("#_smsRem").val('');
		        $("#_smsRem").attr({"class" : "disabled" , "disabled" : "disabled"});
	            Common.alert('<spring:message code="sal.alert.msg.invalidCodyMobNum" />');
			}
		}else{
			$('#_smsChk').attr('checked', false);
			$("#_smsRem").val('');
	        $("#_smsRem").attr({"class" : "disabled" , "disabled" : "disabled"});
			Common.alert('<spring:message code="sal.alert.msg.noInchargeCodyFoundOrder" />');
		}
	}else{
		$("#_smsRem").val('');
		$("#_smsRem").attr({"class" : "disabled" , "disabled" : "disabled"});
	}
}

function fn_invoice(){

	Common.popupDiv("/payment/initTaxInvoiceRentalPop.do", '', null, true);

}

function fn_makeTime(ymd , time){

	console.log("input ymd : " + ymd);
	console.log("input time : " + time);

	var rtnDate = "";
	var ap = '';
	var tempTime;

	if(ymd != null && ymd != ''){

		if(time != null && time != ''){

			tempTime = Number(time.substr(0, 2));
			ap = time.substr(6,8);

			console.log("tempTime : " + tempTime);
			console.log("ap : " + ap);

			if(ap == 'PM'){
				tempTime += 12;
			}

			rtnDate =   ymd + ' ' + tempTime +':00:00';
	    }else{
	    	rtnDate =   ymd + ' ' +'00:00:00';
	    }
	}

	console.log("rtnDate  :  " + rtnDate);
	return rtnDate;
}

</script>

<form id="_winPopForm">
    <input type="hidden"  name="salesOrderId" value="${ordId}">
    <input type="hidden"  name="ordEditType" value="PAY">
</form>

<c:set var="tooltipResult" value="MemberCode:${salesManMap.memCode }
Member Name : ${salesManMap.name }
Member NRIC : ${salesManMap.nric }
Mobile No : ${salesManMap.telMobile}
 " />

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.rosCallLogNewRosCallLog" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_newRosCallClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<!-- Content Start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.smsToCodyTickeyLog" /></h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_sms_ticket_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.orderFullDetails" /></h3>
</aside><!-- title_line end -->
<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.hpCody" /></a></li>
    <li><a id="aTabCI" href="#" onClick="javascript:chgGridTab('custInfo');"><spring:message code="sal.title.text.custInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.installInfo" /></a></li>
    <li><a id="aTabMA" href="#"><spring:message code="sal.title.text.maillingInfo" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#"><spring:message code="sal.title.text.paymentChnnl" /></a></li>
</c:if>
    <li><a id="aTabMI" href="#" onClick="javascript:chgGridTab('memInfo');"><spring:message code="sal.title.text.memshipInfo" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('docInfo');"><spring:message code="sal.title.text.docuSubmission" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('callLogInfo');"><spring:message code="sal.title.text.callLog" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
    <li><a href="#"><spring:message code="sal.title.text.quaranteeInfo" /></a></li>
</c:if>
    <li><a href="#" onClick="javascript:chgGridTab('payInfo');"><spring:message code="sal.title.text.paymentListing" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('transInfo');"><spring:message code="sal.title.text.lastSixMonthTrnsaction" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.ordConfiguration" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('autoDebitInfo');"><spring:message code="sal.title.text.autoDebitResult" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.reliefCertificate" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('discountInfo');"><spring:message code="sal.title.text.discount" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('rentalfulldetail');"><spring:message code="sal.title.text.rentfullDetails" /></a></li>
</ul>

<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfoIncludeViewLedger.jsp" %>
<!------------------------------------------------------------------------------
    HP / Cody
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/hpCody.jsp" %>
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/custInfo.jsp" %>
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/installInfo.jsp" %>
<!------------------------------------------------------------------------------
    Mailling Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mailInfo.jsp" %>
<!------------------------------------------------------------------------------
    Payment Channel
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/payChannel.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Membership Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/membershipInfo.jsp" %>
<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------
    Call Log
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/callLog.jsp" %>
<!------------------------------------------------------------------------------
    Quarantee Info
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/qrntInfo.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Payment Listing
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/payList.jsp" %>
<!------------------------------------------------------------------------------
    Last 6 Months Transaction
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/last6Month.jsp" %>
<!------------------------------------------------------------------------------
    Order Configuration
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/orderConfig.jsp" %>
<!------------------------------------------------------------------------------
    Auto Debit Result
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/autoDebit.jsp" %>
<!------------------------------------------------------------------------------
    Relief Certificate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rliefCrtfcat.jsp" %>
<!------------------------------------------------------------------------------
    Discount
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/discountList.jsp" %>
<!------------------------------------------------------------------------------
    Rental Full Details
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/rcms/include/rentalFullDetails.jsp" %>
</section><!-- tap_wrap end -->
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.newRosRemark" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a onclick="javascript : fn_underDevelop()"><spring:message code="sal.title.text.emailToCust" /></a></p></li>
    <li><p class="btn_grid"><a onclick="javascript : fn_invoice()"><spring:message code="sal.btn.link.invoice" /></a></p></li>
    <li><p class="btn_grid"><a onclick="javascript : fn_editRentPaySetting()"><spring:message code="sal.title.text.editRentPaySetting" /></a></p></li>
</ul>

<form id="_insForm">
<input type="hidden" name="orderId" value="${ordId}">
<input type="hidden" name="custBillId" value="${custBillId}">
<input type="hidden" id="_chkGrp" name="chkGrp"> <!-- check Group  -->
<input type="hidden" id="_chkSmS" name="chkSmS"> <!-- check SMS  -->
<input type="hidden" id="_reCallDate" name="reCallDate">

<!-- hidden Value  -->
<input type="hidden" id="_salesManMemCode" name="" value="${salesManMap.memCode }">
<input type="hidden" id="_salesManMemName" name="" value="${salesManMap.name }">
<input type="hidden" id="_salesManMemNric" name="" value="${salesManMap.nric }">
<input type="hidden" id="_salesManMemTelMobile" name="salesManMemTelMobile" value="${salesManMap.telMobile}">

<input type="hidden" id="_fullSms" name="fullSms">
<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:40%" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.action" /><span class="must">*</span></th>
        <td>
        <select class="w100p" id="_action" name="action">
            <option value="56"><spring:message code="sal.combo.text.callIn" /></option>
            <option value="57"><spring:message code="sal.combo.text.callOut" /></option>
            <option value="58"><spring:message code="sal.combo.text.internalFeedback" /></option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.mainReason" /></th>
        <td>
        <select class="w100p" id="_mainReason" name="mainReason"></select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.feedback" /></th>
        <td>
        <select class="w100p disabled" id="_feedback" name="feedback" disabled="disabled"></select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.rosStus" /><span class="must">*</span></th>
        <td>
        <select class="w100p" id="_rosStatus" name="rosStatus"></select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.rosRemark" /><span class="must">*</span></th>
        <td>
            <textarea id="_rosRem" name="rosRem"></textarea>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
</div>

<div style="width:50%;">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:20%" />
        <col style="width:*" />
        <col style="width:20%" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.reCallDate" /></th>
        <td colspan="3"><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="_reCallYMD" name="reCallDtYmd" onchange="javascript : fn_chkDate(this.id,this.value)"/></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.reCallTime" /></th>
        <td colspan="3">
        <div class="time_picker w100p"><!-- time_picker start -->
        <input type="text" title="" placeholder="" class="time_date w100p"  id="_reCallTime"/>
        <ul>
            <li>Time Picker</li>
            <li><a href="#">12:00 AM</a></li>
            <li><a href="#">01:00 AM</a></li>
            <li><a href="#">02:00 AM</a></li>
            <li><a href="#">03:00 AM</a></li>
            <li><a href="#">04:00 AM</a></li>
            <li><a href="#">05:00 AM</a></li>
            <li><a href="#">06:00 AM</a></li>
            <li><a href="#">07:00 AM</a></li>
            <li><a href="#">08:00 AM</a></li>
            <li><a href="#">09:00 AM</a></li>
            <li><a href="#">10:00 AM</a></li>
            <li><a href="#">11:00 AM</a></li>
            <li><a href="#">12:00 PM</a></li>
            <li><a href="#">01:00 PM</a></li>
            <li><a href="#">02:00 PM</a></li>
            <li><a href="#">03:00 PM</a></li>
            <li><a href="#">04:00 PM</a></li>
            <li><a href="#">05:00 PM</a></li>
            <li><a href="#">06:00 PM</a></li>
            <li><a href="#">07:00 PM</a></li>
            <li><a href="#">08:00 PM</a></li>
            <li><a href="#">09:00 PM</a></li>
            <li><a href="#">10:00 PM</a></li>
            <li><a href="#">11:00 PM</a></li>
        </ul>
        </div><!-- time_picker end -->
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.collectionAmt" /></th>
        <td><input type="text" title="" placeholder="" class="w100p"  onkeyup="fn_inputAmt(this)"  onblur="javascript : fn_chkMaxAmtCheck(this.value)" id="_collectAmt" name="collectAmt"/></td>
        <th scope="row"><spring:message code="sal.title.text.smsCody" /><span class="must">**</span></th>
        <td data-tooltip-text="${tooltipResult}"><label><input type="checkbox"  id="_smsChk" name="smsChk" onchange="javascript : fn_chkValidNumber()" /><span>SMS to Cody?</span></label></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.ptpDate" /></th>
        <td colspan="3"><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  onchange="javascript : fn_chkDate(this.id,this.value)" id="_ptpDate" readonly="readonly" name="ptpDate"/></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.smsRemark" /><span class="must">**</span></th>
        <td colspan="3">
            <textarea id="_smsRem" name="smsRem" class="disabled" disabled="disabled"></textarea>
        </td>
    </tr>

    </tbody>
    </table><!-- table end -->
</div>
</div><!-- divine_auto end -->
   <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:20%" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.grpRemSync" /></th>
        <td colspan="3"><input type="checkbox" id="_groupRemSync" name="groupRemSync"></td>
    </tr>
    </tbody>
    </table>
</form>
<hr/>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_rosCallSaveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>
</section>
</div>