<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

//Create and Return Grid Id
var rosGridID,excelGridID;

var optionModule = {
        type: "M",
        isCheckAll: false,
        isShowChoose: false
};

var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
        editable            : false,
        fixedColumnCount    : 0,
        showStateColumn     : true,
        displayTreeOpen     : false,
   //     selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        noDataMessage       : "No order found.",
        groupingMessage     : "Here groupping"
    };

var rosSummaryReportData = [{"codeId": "ROSRC","codeName": "ROS Caller RC Report"},{"codeId": "ROSMR","codeName": "ROS Caller Main Reason"}];

$(document).ready(function() {/////////////////////////////////////////////////////////////// Document Ready Func Start

	createRosCallGrid();

	CommonCombo.make("_appType", "/sales/rcms/getAppTypeList", {codeMasterId : '10'}, "66|!|1412", optionModule);
	doGetCombo('/common/selectCodeList.do', '95', '','cmbCorpTypeId', 'M' , 'f_multiCombo');     // Company Type Combo Box
	doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'EXHC'}, '', 'listProductId', 'S', 'fn_setOptGrpClass');//product 생성
	CommonCombo.make("mainReason", "/sales/rcms/getReasonCodeList", {typeId : '1175' , stusCodeId : '1'},  '', {type: "S"});  //Reason Code
	CommonCombo.make("rosStatus", "/common/selectCodeList.do", {groupCode : '391'}, '', {type: "S"});  //Reason Code
	CommonCombo.make("rosCallerType", "/sales/rcms/selectAgentTypeList", {codeMasterId : '329'}, '',  { type: "S"});
	CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {stus:'1'} ,'',  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});


	//Search
	$("#_searchBtn").click(function() {

		Common.ajax("GET","/sales/rcms/selectRosCallLogList" , $("#_searchForm").serialize(),function(result){
			//set Grid Data
			AUIGrid.setGridData(rosGridID, result);
			AUIGrid.setGridData(excelGridID, result);
		});
	});

	/* $("#rosCallerType").change(function(){
		CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {stus:'1',agentType: this.value} ,'',  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});
	}); */

	AUIGrid.bind(rosGridID, "cellDoubleClick", function(event){
		if('${PAGE_AUTH.funcUserDefine1}' == 'Y'){
			fn_newROSCall();
		}else{
			Common.alert("Access Deny");
		}

	});

	$('#excelDown').click(function() {
	    GridCommon.exportTo("excel_grid_wrap", 'xlsx', "ROS Call Log");
	 });

	$('#_btnGenVip').click(function() {

		var whereSql = '';

		if(FormUtil.isEmpty($("#vipCustForm  #vip_custId").val()) && FormUtil.isEmpty($("#vipCustForm  #vip_custName").val()) ){
	           Common.alert("Please keyin either 1 field");
	            return;
	    }else{
	    	if(FormUtil.isNotEmpty($("#vipCustForm  #vip_custId").val()) ){
	    		whereSql += " AND T2.CUST_ID = " + $("#vipCustForm  #vip_custId").val();
	    	}

	        if(FormUtil.isNotEmpty($("#vipCustForm  #vip_custName").val()) ){
	        	whereSql += " AND UPPER(T2.NAME) LIKE UPPER(" + "'%"  + $("#vipCustForm  #vip_custName").val() + "%')";
	        	//whereSql += " AND UPPER(T2.NAME) = '"  + $("#vipCustForm  #vip_custName").val() + "' ";
            }

	    }

		var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#reportFileName").val("/sales/rosCaller/RosCaller_VIPCust.rpt");
        $("#V_WHERESQL").val(whereSql);
        $("#reportDownFileName").val("ROS Caller VVIP Cusomer Info_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

        var option = {
                isProcedure : true
        };

        Common.report("reportForm", option);
	});

	$('#_btnGenSum').click(function(){

		var rptType                 =  $("#rosSum_reportType").val();
		var rosSumCaller         = $("#rosSum_Caller").val();
		var rosSumRentusStus = $("#rosSum_rentalStatus").val();
		var rosSumStartDt       = $("#rosSum_StartDt").val();
		var rosSumEndDt         = $("#rosSum_EndDt").val();
		var rosSumResn         = $("#rosSum_mainReason").val();

		var whereSql = '';
		var runNo = 0;

		var date = new Date(), y = date.getFullYear(), m = date.getMonth();
		var firstDay = new Date(y, m, 1);
		var lastDay = new Date(y, m + 1, 0);
		//Get Current Month
		var currentMonth = m < 10 ? ("0" + (m + 1)) : (m+1).toString();

		console.log(currentMonth);

		var today = $.datepicker.formatDate('ddmmyy', date);
		var f_firstDay = $.datepicker.formatDate('yy/mm/dd', firstDay);
		var f_lastDay = $.datepicker.formatDate('yy/mm/dd', lastDay);

		var startDtSplit;
        var endDtSplit

        var startDt;
        var endDt;

        // Format Date
        if(FormUtil.isNotEmpty(rosSumStartDt)){
        	startDtSplit = rosSumStartDt.split("/");
            startDt = startDtSplit[2] + '/' + startDtSplit[1] + '/' + startDtSplit[0];
        }
        if(FormUtil.isNotEmpty(rosSumEndDt)){
            endDtSplit = rosSumEndDt.split("/");
            endDt  = endDtSplit[2] + '/' + endDtSplit[1] + '/' + endDtSplit[0];
        }


		if(rptType == null){
			Common.alert("<spring:message code='sal.alert.msg.plzSelReportType' />");
			return;
		}else if(FormUtil.isNotEmpty(rosSumStartDt) && FormUtil.isNotEmpty(rosSumEndDt) &&
				( currentMonth != endDtSplit[1] || currentMonth != startDtSplit[1])){
		    Common.alert("Please select within current month");
		    return;
		}else{
			if(rptType == 'ROSRC'){

				if(FormUtil.isNotEmpty(rosSumCaller) ){
			        whereSql += " AND  T0.AGENT_ID IN (";
			        $('#rosSum_Caller :selected').each(function(i, mul){
			            if(runNo > 0){
			                whereSql += ",'"+$(mul).val()+"'";
			            }else{
			                whereSql += "'"+$(mul).val()+"'";
			            }
			            runNo += 1;
			        });
			        whereSql += ") ";

			        runNo = 0;
			    }

			    if(FormUtil.isNotEmpty(rosSumRentusStus) ){
			    	whereSql += " AND  RENS.STUS_CODE_ID IN (";
                    $('#rosSum_rentalStatus :selected').each(function(i, mul){
                        if(runNo > 0){
                            whereSql += ",'"+$(mul).val()+"'";
                        }else{
                            whereSql += "'"+$(mul).val()+"'";
                        }
                        runNo += 1;
                    });
                    whereSql += ") ";

                    runNo = 0;
                }

			    if(FormUtil.isEmpty(rosSumStartDt) && FormUtil.isEmpty(rosSumEndDt)){

			    	whereSql += " AND PM.PAY_DATA >= TO_DATE('" + f_firstDay + "','YYYY/MM/DD') AND PM.PAY_DATA    <= TO_DATE('" + f_lastDay + "','YYYY/MM/DD') ";

			    }else if(FormUtil.isNotEmpty(rosSumStartDt) && FormUtil.isNotEmpty(rosSumEndDt)){

                    whereSql += " AND PM.PAY_DATA >= TO_DATE('" + startDt + "','YYYY/MM/DD') AND PM.PAY_DATA    <= TO_DATE('" + endDt + "','YYYY/MM/DD') ";

                }else{
                	Common.alert("<spring:message code='sal.alert.msg.plzSelKeyinDateFromTo' />");
                    return;
                }

			    if(FormUtil.isNotEmpty(rosSumResn) ){
			    	whereSql += " AND  RM.RESN_ID = " + rosSumResn;

			    	if(FormUtil.isNotEmpty(rosSumStartDt) && FormUtil.isNotEmpty(rosSumEndDt)){
			    		whereSql += " AND ROS.ROS_CALL_CRT_DT >= TO_DATE('" + startDt + "','YYYY/MM/DD') AND ROS.ROS_CALL_CRT_DT  <= TO_DATE('" + endDt + "','YYYY/MM/DD') ";
			    	}else{
			    		whereSql += " AND ROS.ROS_CALL_CRT_DT >= TO_DATE('" + f_firstDay + "','YYYY/MM/DD') AND ROS.ROS_CALL_CRT_DT    <= TO_DATE('" + f_lastDay + "','YYYY/MM/DD') ";
			    	}
                }

			    $("#reportFileName").val("/sales/rosCaller/RosCaller_RCRaw.rpt");
			    $("#V_WHERESQL").val(whereSql);
			    $("#reportDownFileName").val("ROS Caller RCRaw_"+today );

			    console.log(whereSql);
		        var option = {
		                isProcedure : true
		        };

		        Common.report("reportForm", option);

			}

		    if(rptType == 'ROSMR'){

		    	if(FormUtil.isNotEmpty(rosSumCaller) ){
                    whereSql += " AND  RCMS.AGENT_ID IN (";
                    $('#rosSummaryForm  #rosSum_Caller :selected').each(function(i, mul){
                        if(runNo > 0){
                            whereSql += ",'"+$(mul).val()+"'";
                        }else{
                            whereSql += "'"+$(mul).val()+"'";
                        }
                        runNo += 1;
                    });
                    whereSql += ") ";

                    runNo = 0;
                }

                if(FormUtil.isNotEmpty(rosSumRentusStus) ){
                    whereSql += " AND  RENS.STUS_CODE_ID IN (";
                    $('#rosSummaryForm  #rosSum_rentalStatus :selected').each(function(i, mul){
                        if(runNo > 0){
                            whereSql += ",'"+$(mul).val()+"'";
                        }else{
                            whereSql += "'"+$(mul).val()+"'";
                        }
                        runNo += 1;
                    });
                    whereSql += ") ";

                    runNo = 0;
                }

                if(FormUtil.isEmpty(rosSumStartDt) && FormUtil.isEmpty(rosSumEndDt)){

                	whereSql += " AND ROS.ROS_CALL_CRT_DT >= TO_DATE('" + f_firstDay + "','YYYY/MM/DD') AND ROS.ROS_CALL_CRT_DT    <= TO_DATE('" + f_lastDay + "','YYYY/MM/DD') ";

                }else if(FormUtil.isNotEmpty(rosSumStartDt) && FormUtil.isNotEmpty(rosSumEndDt)){

                    startDtSplit = rosSumStartDt.split("/");
                    endDtSplit = rosSumEndDt.split("/");

                    startDt = startDtSplit[2] + '/' + startDtSplit[1] + '/' + startDtSplit[0];
                    endDt  = endDtSplit[2] + '/' + endDtSplit[1] + '/' + endDtSplit[0];

                    whereSql += " AND ROS.ROS_CALL_CRT_DT >= TO_DATE('" + startDt + "','YYYY/MM/DD') AND ROS.ROS_CALL_CRT_DT  <= TO_DATE('" + endDt + "','YYYY/MM/DD') ";

                }else{
                    Common.alert("<spring:message code='sal.alert.msg.plzSelKeyinDateFromTo' />");
                    return;
                }

                if(FormUtil.isNotEmpty(rosSumResn) ){
                    whereSql += " AND  RM.RESN_ID = " + rosSumResn;
                }

                console.log(whereSql)

                $("#reportFileName").val("/sales/rosCaller/RosCaller_MainReason.rpt");
                $("#V_WHERESQL").val(whereSql);
                $("#reportDownFileName").val("ROS Caller MainReason_"+today);

                var option = {
                        isProcedure : true
                };

                Common.report("reportForm", option);

            }

		}

	});


});////////////////////////////////////////////////////////////////////////////////////////////////// Document Ready Func End

function f_multiCombo(){
    $(function() {
        $('#cmbCorpTypeId').change(function() {

        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '80%'
        });
    });
}

function chgGridTab(tabNm) {
    switch(tabNm) {
        case 'custInfo' :
            AUIGrid.resize(custInfoGridID, 920, 300);
            break;
        case 'memInfo' :
            AUIGrid.resize(memInfoGridID, 920, 300);
            break;
        case 'docInfo' :
            AUIGrid.resize(docGridID, 920, 300);
            if(AUIGrid.getRowCount(docGridID) <= 0) {
                fn_selectDocumentList();
            }
            break;
        case 'callLogInfo' :
            AUIGrid.resize(callLogGridID, 920, 300);
            if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                fn_selectCallLogList();
            }
            break;
        case 'payInfo' :
            AUIGrid.resize(payGridID, 920, 300);
            if(AUIGrid.getRowCount(payGridID) <= 0) {
                fn_selectPaymentList();
            }
            break;
        case 'transInfo' :
            AUIGrid.resize(transGridID, 920, 300);
            if(AUIGrid.getRowCount(transGridID) <= 0) {
                fn_selectTransList();
            }
            break;
        case 'autoDebitInfo' :
            AUIGrid.resize(autoDebitGridID, 920, 300);
            if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                fn_selectAutoDebitList();
            }
            break;
        case 'discountInfo' :
            AUIGrid.resize(discountGridID, 920, 300);
            if(AUIGrid.getRowCount(discountGridID) <= 0) {
                fn_selectDiscountList();
            }
            break;
        case 'afterList' :
            AUIGrid.resize(afterServceGridID, 940, 300);
            break;
        case 'beforeList' :
            AUIGrid.resize(beforeServceGridID, 940, 300);
            break;
        case 'rentalfulldetail' :
        	AUIGrid.resize(agmHistoryGridID, 940, 180);
            AUIGrid.resize(billingGroupLatestSummaryGridID, 940, 180);
            AUIGrid.resize(agreementGridID, 940, 180);
            break;
    };
}

function fn_underDevelop(){
	Common.alert("This Program is Under Development.");
}

function fn_orderUloadBatch(){
	Common.popupDiv("/sales/rcms/orderUploadBatchListPop.do", null ,  null , true, '_updLoadDiv');
}


function createRosCallGrid(){
	 var rosColumnLayout =  [
	                            {dataField : "ordNo", headerText : '<spring:message code="sal.text.ordNo" />', width : '5%' , editable : false},
	                            {dataField : "firstInstallDt", headerText : '<spring:message code="sal.text.insDate" />', width : '7%', editable : false},
	                            {dataField : "ordStusName", headerText : '<spring:message code="sal.text.orderStatus" />', width : '7%' , editable : false},
	                            {dataField : "appTypeCode", headerText : '<spring:message code="sal.title.text.appType" />', width : '7%' , editable : false},
	                            {dataField : "stockDesc", headerText : '<spring:message code="sal.title.text.product" />', width : '8%' , editable : false},
	                            {dataField : "custName", headerText : '<spring:message code="sal.text.custName" />', width : '8%' , editable : false},
	                            {dataField : "custId", headerText : '<spring:message code="sal.text.customerId" />', width : '5%' , editable : false},
	                            {dataField : "custType", headerText : '<spring:message code="sal.text.custType" />', width : '5%' , editable : false},
	                            {dataField : "rentalStus", headerText : '<spring:message code="sal.text.rentalStatus" />', width : '5%' , editable : false},
	                            {dataField : "currMthAging", headerText : '<spring:message code="sal.title.msg.currAgingMonth" />', width : '7%' , editable : false},
	                            {dataField : "currentOs", headerText : '<spring:message code="sal.text.currOutstnd" />', width : '7%' , editable : false},
	                            {dataField : "rosCaller", headerText : '<spring:message code="sal.title.text.rosCaller" />', width : '7%' , editable : false},
	                            {dataField : "rosMainReason", headerText : '<spring:message code="sal.title.text.mainReason"/>', width : '10%' , editable : false},
	                            {dataField : "paymode", headerText : '<spring:message code="sal.title.paymode" />', width : '7%' , editable : false},
	                            {dataField : "etr", headerText : '<spring:message code="sal.title.text.etr" />', width : '5%' , editable : false},
	                            {dataField : "ordId", visible : false},
	                            {dataField : "custBillId", visible : false}
	                           ];

	 var excelColumnLayout =  [
                             {dataField : "ordNo", headerText : '<spring:message code="sal.text.ordNo" />', width : 200 , editable : false, dataType : "string"},
                             {dataField : "firstInstallDt", headerText : '<spring:message code="sal.text.insDate" />', width :200, editable : false},
                             {dataField : "ordStusName", headerText : '<spring:message code="sal.text.orderStatus" />', width : 200 , editable : false},
                             {dataField : "appTypeCode", headerText : '<spring:message code="sal.title.text.appType" />', width : 200 , editable : false},
                             {dataField : "stockDesc", headerText : '<spring:message code="sal.title.text.product" />', width : 200 , editable : false},
                             {dataField : "custName", headerText : '<spring:message code="sal.text.custName" />', width : 200 , editable : false},
                             {dataField : "custId", headerText : '<spring:message code="sal.text.customerId" />', width : 200 , editable : false},
                             {dataField : "custType", headerText : '<spring:message code="sal.text.custType" />', width : 200 , editable : false},
                             {dataField : "rentalStus", headerText : '<spring:message code="sal.text.rentalStatus" />', width : 200 , editable : false},
                             {dataField : "currMthAging", headerText : '<spring:message code="sal.title.msg.currAgingMonth" />', width : 200 , editable : false},
                             {dataField : "currentOs", headerText : '<spring:message code="sal.text.currOutstnd" />', width : 200 , editable : false},
                             {dataField : "rosCaller", headerText : '<spring:message code="sal.title.text.rosCaller" />', width : 200 , editable : false},
                             {dataField : "rosMainReason", headerText : '<spring:message code="sal.title.text.mainReason"/>', width : 200 , editable : false},
                             {dataField : "paymode", headerText : '<spring:message code="sal.title.paymode" />', width : 200 , editable : false},
                             {dataField : "coltAmt", headerText : '<spring:message code="sal.title.text.collectionAmt" />', width : 200 , editable : false},
                             {dataField : "recallDt", headerText : '<spring:message code="sal.title.text.reCallDate" />', width : 200 , editable : false},
                             {dataField : "ptpDt", headerText : '<spring:message code="sal.title.text.ptpDate" />', width : 200 , editable : false},
                             {dataField : "keyInDt", headerText : '<spring:message code="sal.text.keyInDate" />', width : 200 , editable : false},
                            ];

	    //그리드 속성 설정
	    var gridPros = {

	            usePaging           : true,         //페이징 사용
	            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
	            fixedColumnCount    : 1,
	            showStateColumn     : true,
	            displayTreeOpen     : false,
	//            selectionMode       : "singleRow",  //"multipleCells",
	            headerHeight        : 30,
	            useGroupingPanel    : false,        //그룹핑 패널 사용
	            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
	            noDataMessage       : "No Ros Call found.",
	            groupingMessage     : "Here groupping"
	    };

	    rosGridID = GridCommon.createAUIGrid("#rosCall_grid_wrap", rosColumnLayout,'', gridPros);
	    excelGridID = GridCommon.createAUIGrid("#excel_grid_wrap", excelColumnLayout,'', gridPros);
}

function fn_newROSCall(){

	//Validation
	var selectedItem = AUIGrid.getSelectedItems(rosGridID);
    if(selectedItem.length <= 0){
        Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
        return;
    }
    //Popup
    Common.popupDiv("/sales/rcms/newRosCallPop.do", {salesOrderId : selectedItem[0].item.ordId , ordNo : selectedItem[0].item.ordNo, custId : selectedItem[0].item.custId, custBillId : selectedItem[0].item.custBillId}, null , true , '_newDiv');
}

function fn_chargeOrderBillingType(){

	//Validation
    var selectedItem = AUIGrid.getSelectedItems(rosGridID);
    if(selectedItem.length <= 0){
        Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
        return;
    }
    //Popup
	Common.popupDiv('/payment/initChangeBillingTypePop.do', {custBillId : selectedItem[0].item.custBillId , callPrgm : "BILLING_GROUP"}, null , true);

}

function searchList(){
	$("#_searchBtn").click();
}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};

hideViewPopup=function(val){
    $(val).hide();
}

function fn_feedbackList(){
	Common.popupDiv("/sales/rcms/feedbackPop.do", null ,  null , true, '_feedbackPop');
}

function fn_vipCustList(){
    $("#vipCust_wrap").show();
}

function fn_rosSumList(){
	$("#rosSummary_wrap").show();

	CommonCombo.make("rosSum_mainReason", "/sales/rcms/getReasonCodeList", {typeId : '1175' , stusCodeId : '1'},  '', {type: "S"});  //Reason Code
    CommonCombo.make("rosSum_CallerType", "/sales/rcms/selectAgentTypeList", {codeMasterId : '329'}, '2326',  { type: "S"});
    CommonCombo.make("rosSum_Caller", "/sales/rcms/selectRosCaller", {stus:'1',agentType: '2326'} ,'',  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});
    doDefCombo(rosSummaryReportData, '' ,'rosSum_reportType', 'S', '');
    CommonCombo.make('rosSum_rentalStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 26} , '',
            {
                id: "code",              // 콤보박스 value 에 지정할 필드명.
                name: "codeName",  // 콤보박스 text 에 지정할 필드명.
                isShowChoose: false,
                isCheckAll : false,
                type : 'M'
                });
}

function fn_setOptGrpClass() {
    $("optgroup").attr("class" , "optgroup_text");
}

$(function() {
	$("#rosCallerType").change(function(){
		CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {stus:'1',agentType: this.value} ,'',  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});
	});
});
</script>



<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.text.rosCallLog" /></h2>
<ul class="right_btns">
    <%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a onclick="javascript:fn_newROSCall()"><span ></span><spring:message code="sal.title.text.newRosCall" /></a></p></li>
    </c:if> --%>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a onclick="javascript:fn_chargeOrderBillingType()"><span ></span><spring:message code="sal.title.text.chargeOrderBillingType" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue"><a onclick="javascript:fn_orderUloadBatch()"><span ></span><spring:message code="sal.title.text.orderRemUploadBatch" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a id="_searchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a onclick="javascript:$('#_searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="_searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>
        <input type="text" title="" placeholder="Order No" class="w100p" id="_ordNo" name="ordNo"/>
    </td>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="_appType" name="appType"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_rentalStatus" name="rentalStatus">
        <option value="ACT"><spring:message code="sal.btn.active" /></option>
        <option value="REG"><spring:message code="sal.combo.text.regular" /></option>
        <option value="INV"><spring:message code="sal.combo.text.investigate" /></option>
        <option value="SUS"><spring:message code="sal.combo.text.supend" /></option>
        <option value="RET"><spring:message code="sal.combo.text.returned" /></option>
        <option value="CAN"><spring:message code="sal.combo.text.cancelled" /></option>
        <option value="TER"><spring:message code="sal.combo.text.terminated" /></option>
        <option value="WOF"><spring:message code="sal.combo.text.writeOff" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td>
        <input type="text" title="" placeholder="Customer ID (Number Only)" class="w100p" id="_custId" name="custId" />
    </td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td>
        <input type="text" title="" placeholder="Customer Name" class="w100p" id="_custName" name="custName"/>
    </td>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
    <td>
        <input type="text" title="" placeholder="NRIC/Company Number" class="w100p" id="_custNric" name="custNric" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.poNum'/></th>
    <td>
        <input id="listPoNo" name="poNo" type="text" title="PO No" placeholder="<spring:message code='sales.poNum'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.companyType" /></th>
    <td>
        <select id="cmbCorpTypeId" name="cmbCorpTypeId" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='sales.ContactNo'/></th>
    <td>
    <input id="listContactNo" name="contactNo" type="text" title="Contact No" placeholder="<spring:message code='sales.ContactNo'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.prod'/></th>
    <td>
        <select id="listProductId" name="productId" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.SeriacNo'/></th>
    <td>
        <input id="listSerialNo" name="serialNo" type="text" title="Serial Number" placeholder="<spring:message code='sales.SeriacNo'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.vaNum'/></th>
    <td>
        <input id="listVaNo" name="vaNo" type="text" title="VA Number" placeholder="<spring:message code='sales.vaNum'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agentType" /></th>
        <td>
        <select class="w100p" id="rosCallerType" name="rosCallerType"></select>
        </td>
     <th scope="row"><spring:message code='sal.title.text.reCallDate'/></th>
        <td>
            <div class="date_set w100p"><!-- date_set start -->
                <p><input id="listRclStartDt" name="rclStartDt" type="text" value="" title="Recall start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
            <span>To</span>
                <p><input id="listRclEndDt" name="rclEndDt" type="text" value="" title="Recall end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </div><!-- date_set end -->
        </td>
     <th scope="row"><spring:message code="sal.title.text.mainReason" /></th>
        <td>
            <select class="w100p" id="mainReason" name="mainReason"></select>
        </td>
</tr>
<tr>
     <th scope="row"><spring:message code="sal.title.text.rosCaller" /></th>
         <td>
             <select id="rosCaller" name="rosCaller" class="multy_select w100p" multiple="multiple"></select>
         </td>
     <th scope="row"><spring:message code='sal.title.text.ptpDate'/></th>
         <td>
         <div class="date_set w100p"><!-- date_set start -->
             <p><input id="listPtpStartDt" name="ptpStartDt" type="text" value="" title="PTP start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                 <span>To</span>
             <p><input id="listPtpEndDt" name="ptpEndDt" type="text" value="" title="PTP end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
          </div><!-- date_set end -->
         </td>
     <th scope="row"><spring:message code="sal.title.text.rosStus" /></th>
         <td>
             <select class="w100p" id="rosStatus" name="rosStatus"></select>
         </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt><spring:message code="sal.title.text.link" /></dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a onclick="javascript:fn_feedbackList()"><spring:message code="sal.title.text.feedbackList" /></a></p></li>
        <li><p class="link_btn"><a onclick="javascript:fn_vipCustList()">VVIP Customer Info</a></p></li>
        <li><p class="link_btn"><a onclick="javascript:fn_rosSumList()">ROS Summary Report</a></p></li>
        <%-- <li><p class="link_btn"><a href="${pageContext.request.contextPath}/payment/initInvoiceIssue.do">Invoice</a></p></li>  --%>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>

<form id="reportForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns mt10">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    </c:if>
        <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code="sal.title.text.download" /></a></p></li>

</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="rosCall_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
<div id="excel_grid_wrap" style="display:none"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->



<!-- VVIP Customer Info Wrap -->
<div class="popup_wrap size_small" id="vipCust_wrap" style="display:none;">

    <header class="pop_header">
        <h1>VVIP Customer Info</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#vipCust_wrap')">CLOSE</a></p></li>
        </ul>
    </header>

    <form name="vipCustForm" id="vipCustForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                <tr>
                    <th scope="row"><spring:message code="sal.text.customerId" /></th>
                    <td><input type="text" title="" placeholder="Customer Id" class="w100p" id="vip_custId" name="vipCustId"/></td>
                 </tr>
                 <tr>
                    <th scope="row"><spring:message code="sal.text.custName" /></th>
                    <td><input type="text" title="" placeholder="Customer Name" class="w100p" id="vip_custName" name="vipCustName"/></td>
                </tr>
                </tbody>
            </table>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a id="_btnGenVip" href="#"><spring:message code="sal.btn.generate" /></a></p></li>
            <li><p class="btn_blue2"><a onclick="javascript:$('#vipCustForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>

<!-- ROS Summary Report Wrap -->
<div class="popup_wrap size_medium" id="rosSummary_wrap" style="display:none;">

    <header class="pop_header">
        <h1>ROS Summary Report</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#rosSummary_wrap')">CLOSE</a></p></li>
        </ul>
    </header>

    <form name="rosSummaryForm" id="rosSummaryForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                <tr>
                    <th scope="row"><spring:message code="sal.text.reportType" /></th>
                    <td><select class="w100p" id="rosSum_reportType" name="rosSum_reportType"></select></td>
                    <th scope="row"><spring:message code="sal.title.text.agentType" /></th>
                    <td><select class="w100p" id="rosSum_CallerType" name="rosSum_CallerType" disabled></select></td>

                 </tr>
                 <tr>
                    <th scope="row"><spring:message code="sal.title.text.rosCaller" /></th>
                    <td><select id="rosSum_Caller" name="rosSum_Caller" class="multy_select w100p" multiple="multiple"></select></td>
                    <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
                    <td><select id="rosSum_rentalStatus" name="rosSum_rentalStatus" class="multy_select w100p" multiple="multiple"></select></td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code="sal.title.date" /></th>
                    <td>
                        <div class="date_set w100p">
                            <p><input id="rosSum_StartDt" name="rosSum_StartDt" type="text" value="" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input id="rosSum_EndDt" name="rosSum_EndDt" type="text" value="" placeholder="DD/MM/YYYY" class="j_date" /></p>
                        </div>
                    </td>
                    <th scope="row"><spring:message code="sal.title.text.mainReason" /></th>
                    <td><select class="w100p" id="rosSum_mainReason" name="rosSum_mainReason"></select></td>
                </tr>
                </tbody>
            </table>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a id="_btnGenSum" href="#"><spring:message code="sal.btn.generate" /></a></p></li>
            <li><p class="btn_blue2"><a onclick="javascript:$('#vipCustForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>


</section><!-- content end -->

