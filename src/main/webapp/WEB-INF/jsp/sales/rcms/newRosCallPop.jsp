<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

//Create and Return ID
var smsGridID;


var optionComboReason = {
        type: "S",
        chooseMessage: "No Reason Code",
        isShowChoose: true  
};

var optionComboFeedback = {
        type: "S",
        chooseMessage: "No Feedback Code",
        isShowChoose: true  
};

var optionComboStatus = {
        type: "S",
        chooseMessage: "No ROS Status",
        isShowChoose: true  
};


$(document).ready(function() {
	
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
		Common.alert("Do Save!");
	});
});

function createSMSGrid(){
	
	var smsLayout = [
	                  {   dataField : "code",     headerText : 'Type',     width :'10%' }
	                 ,{   dataField : "rem",  headerText : 'Remark',         width : '65%' }
	                 ,{   dataField : "userName",    headerText : 'Creator',        width : '15%' }
	                 ,{   dataField : "callCrtDt", headerText : 'Create Date',   width : '10%' }	                 
	                ];
	
	
	var smsGridPros = {
	        usePaging           : true,         //페이징 사용
	        pageRowCount        : 5,           //한 화면에 출력되는 행 개수 20(기본값:20)            
	        editable            : false,            
	        fixedColumnCount    : 0,            
	        showStateColumn     : true,             
	        displayTreeOpen     : false,            
	        selectionMode       : "singleRow",  //"multipleCells",            
	        headerHeight        : 30,       
	        useGroupingPanel    : false,        //그룹핑 패널 사용
	        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
	        noDataMessage       : "No data found.",
	        groupingMessage     : "Here groupping"
	    };
	
	smsGridID = GridCommon.createAUIGrid("grid_sms_ticket_wrap", smsLayout, "", smsGridPros);
	
	//Set Grid
	
	if('${ordId}' != null){
		Common.ajax("GET", "/sales/rcms/selectROSSMSCodyTicketLogList", {ordId : '${ordId}'}, function(result){
			AUIGrid.setGridData(smsGridID, result);
	    });	
	}
}

function fn_chkDate(inputDate){
	
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
 
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>ROS Call Log - New ROS Call Log</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_newRosCallClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<!-- Content Start -->

<aside class="title_line"><!-- title_line start -->
<h3>SMS to Cody Ticket Log</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_sms_ticket_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>Order Full Details</h3>
</aside><!-- title_line end -->
<section class="tap_wrap mt0"><!-- tap_wrap start --> 
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">HP / Cody</a></li>
    <li><a id="aTabCI" href="#" onClick="javascript:chgGridTab('custInfo');">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a id="aTabMA" href="#">Mailling Info</a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#">Payment Channel</a></li>
</c:if>
    <li><a id="aTabMI" href="#" onClick="javascript:chgGridTab('memInfo');">Membership Info</a></li>
    <li><a href="#" onClick="javascript:chgGridTab('docInfo');">Document Submission</a></li>
    <li><a href="#" onClick="javascript:chgGridTab('callLogInfo');">Call Log</a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
    <li><a href="#">Quarantee Info</a></li>
</c:if>
    <li><a href="#" onClick="javascript:chgGridTab('payInfo');">Payment Listing</a></li>
    <li><a href="#" onClick="javascript:chgGridTab('transInfo');">Last 6 Months Transaction</a></li>
    <li><a href="#">Order Configuration</a></li>
    <li><a href="#" onClick="javascript:chgGridTab('autoDebitInfo');">Auto Debit Result</a></li>
    <li><a href="#">Relief Certificate</a></li>
    <li><a href="#" onClick="javascript:chgGridTab('discountInfo');">Discount</a></li>
    <li><a href="#" onClick="javascript:chgGridTab('rentalfulldetail');">Rental Full Detail</a></li>
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
<h3>NEW ROS Remark</h3>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">email to Customer</a></p></li>
    <li><p class="btn_grid"><a href="#">Invoice</a></p></li>
    <li><p class="btn_grid"><a href="#">Edit Rent Pay Setting</a></p></li>
</ul>

<form action="#" method="post">

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
        <th scope="row">Action<span class="must">*</span></th>
        <td>
        <select class="w100p">
            <option value="56">Call-In</option>
            <option value="57">Call-Out</option>
            <option value="58">Internal Feedback</option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Main Reason</th>
        <td>
        <select class="w100p" id="_mainReason"></select>
        </td>
    </tr>
    <tr>
        <th scope="row">FeedBack</th>
        <td>
        <select class="w100p disabled" id="_feedback" disabled="disabled"></select>
        </td>
    </tr>
    <tr>
        <th scope="row">ROS Status<span class="must">*</span></th>
        <td>
        <select class="w100p" id="_rosStatus"></select>
        </td>
    </tr>
    <tr>
        <th scope="row">ROS Remark<span class="must">*</span></th>
        <td>
            <textarea></textarea>
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
        <th scope="row">Recall Date</th>
        <td colspan="3"><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
    </tr>
    <tr>
        <th scope="row">Recall Time</th>
        <td colspan="3">
        <div class="time_picker w100p"><!-- time_picker start -->
        <input type="text" title="" placeholder="" class="time_date w100p" />
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
        <th scope="row">Collection Amount</th>
        <td><input type="text" title="" placeholder="" class="w100p"  onkeyup="fn_inputAmt(this)"  id="_collectAmt"/></td>
        <th scope="row">SMS Cody<span class="must">**</span></th>
        <td><label><input type="checkbox" /><span>SMS to Cody?</span></label></td>
    </tr>
    <tr>
        <th scope="row">PTP Date</th>
        <td colspan="3"><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  onchange="javascript : fn_chkDate(this.value)" id="_ptpDate" readonly="readonly"/></td>
    </tr>
    <tr>
        <th scope="row">SMS Remark<span class="must">**</span></th>
        <td colspan="3">
            <textarea></textarea>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
</div>
</div><!-- divine_auto end -->
</form>
<hr/>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_rosCallSaveBtn">Save</a></p></li>
</ul>
</section>
</div>