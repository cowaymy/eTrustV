<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>
<script type="text/javascript">

    //AUIGrid 생성 후 반환 ID
    var cancelLogGridID;       // Cancellation Log Transaction list
    var prodReturnGridID;      // Product Return Transaction list
    var anoOrdNo = "${hcOrder.anoOrdNo}";
    var ordCtgryCd = "${hcOrder.ordCtgryCd}";
    var _cancleMsg = "Another order :  "+ anoOrdNo +"<br/>is also canceled together.<br/>Do you want to continue?";
    var branchTypeId = '${branchTypeId}';

    $(document).ready(function(){
        /* KV -cancellation status */
        doGetCombo('/sales/order/selectcancellationstatus.do', '', '', 'addStatus', 'S', '');

        if($("#callStusId").val() == '1'){
            $("#addDiv").css("display" , "none");
            $("#callStusId").val('');
        }

	    // AUIGrid 그리드를 생성합니다.
	    cancelLogGrid();
	    prodReturnGrid();

	    /* AUIGrid.setSelectionMode(addrGridID, "singleRow"); */
	    //Call Ajax
	    fn_cancelLogTransList();
	    fn_productReturnTransList();

	    // j_dateHc
        /* var pickerOpts = {
	        changeMonth : true,
        	changeYear : true,
            dateFormat : "dd/mm/yy"
        };
        $(".j_dateHc").datepicker(pickerOpts); */

        // Btn Auth
        if (basicAuth == true) {
            $("#_basicUpdBtn").css("display" , "");
        } else {
            $("#_basicUpdBtn").css("display" , "none");
        }

	    $("#m3").hide();   // ASSIGN CT
	    $("#m4").hide();   // DSC BRANCH
	    $("#m5").hide();   // REQUEST DATE
	    $("#m6").hide();   // APPOINTMENT DATE
	    $("#m7").hide();   // RECALL DATE
	    $("#m8").hide();   // APPOINTMENT SESSION
	    $("#m9").hide();   // REMARK

	    if("${SESSION_INFO.roleId}" != "212"){
	        $("#deactPayModeYes").attr('disabled','disabled');
	    }
	    else {
	        $("#deactPayModeYes").removeAttr("disabled");
	    }
    });

    function cancelLogGrid() {
        // Cancellation Log Transaction Column
        var cancelLogColumnLayout = [
             {dataField : "code1", headerText : "<spring:message code='sal.text.type' />", width : '7%'},
             {dataField : "code", headerText : "<spring:message code='sal.text.status' />", width : '7%'},
             {dataField : "callRem", headerText : "<spring:message code='sal.text.remark' />", width : '40%'},
             {dataField : "crtDt", headerText : "<spring:message code='sal.text.createDate' />", width : '10%'},
             {dataField : "callentryUserName", headerText : "<spring:message code='sal.text.creator' />", width : '13%'},
             {dataField : "updDt", headerText : "<spring:message code='sal.title.text.updateDate' />", width : '10%'},
             {dataField : "userName", headerText : "<spring:message code='sal.text.updator' />", width : '13%'}
         ];

        //그리드 속성 설정
        var gridPros = {
            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 10(기본값:10)
            pageRowCount : 10,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false, //true
            displayTreeOpen : false, //true
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false, //true
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : false, //false
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping",
            wordwrap : true
        };

        cancelLogGridID = GridCommon.createAUIGrid("#cancelLog", cancelLogColumnLayout,'', gridPros);
    }

    function prodReturnGrid(){
        // Product Return Transaction Column
        var prodReturnColumnLayout = [
             {dataField : "retnNo", headerText : "<spring:message code='sal.title.text.returnNo' />", width : '15%'},
             {dataField : "code", headerText : "<spring:message code='sal.text.status' />", width : '10%'},
             {dataField : "created1", headerText : "<spring:message code='sal.text.createDate' />", width : '11%'},
             {dataField : "username1", headerText : "<spring:message code='sal.text.creator' />", width : '11%'},
             {dataField : "memCodeName2", headerText : "Assign DT"},
             {dataField : "ctGrp", headerText : "<spring:message code='sal.title.text.group' />", width : '8%'},
             {dataField : "whLocCodeDesc", headerText : "<spring:message code='sal.title.text.returnWarehouse' />", width : '25%'}
         ];

        //그리드 속성 설정
        var gridPros = {
            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 10(기본값:10)
            pageRowCount : 10,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false, //true
            displayTreeOpen : false, //true
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false, //true
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : false, //false
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };

        prodReturnGridID = GridCommon.createAUIGrid("#productReturn", prodReturnColumnLayout,'',gridPros);
    }


    // 리스트 조회. (Cancellation Log Transaction list)
    function fn_cancelLogTransList() {
        Common.ajax("GET", "/sales/order/cancelLogTransList.do", $("#tabForm").serialize(), function(result) {
            AUIGrid.setGridData(cancelLogGridID, result);
        });
    }

    // 리스트 조회. (Product Return Transaction list)
    function fn_productReturnTransList() {
        Common.ajax("GET", "/sales/order/productReturnTransList.do", $("#tabForm").serialize(), function(result) {
            AUIGrid.setGridData(prodReturnGridID, result);
        });
    }

    //resize func (tab click)
    function fn_resizefunc(gridName){ //
        AUIGrid.resize(gridName, 950, 300);
    }

    //add by hgham
    function fn_doAllaction(){
        var ord_id = '${cancelReqInfo.ordId}';  // '143486';
        var vdte   = $("#requestDate").val();
        /* var options ={
              ORD_ID: ord_id,
              S_DATE: vdte,
              CallBackFun:'fn_allactionFun'
        } */

        //Common.popupDiv("/homecare/services/install/hcAllocation.do" ,{ORD_ID:ord_id  , S_DATE:vdte , OPTIONS:options ,TYPE:'RTN'}, null , true , '_doAllactionDiv');
        Common.popupDiv("/homecare/services/install/hcAllocation.do", {ORD_ID : ord_id, S_DATE : vdte, TYPE : 'RTN'}, null, true, '_doAllactionDiv');
    }

    function fn_allactionFun(obj){
        $("#addAppRetnDt").val(obj.dDate);
        $("#ctId").val(obj.ct);
        $("select[name=cmbAssignCt]").val(obj.ct);
        $("select[name=cmbAssignCt]").addClass("w100p disabled");
        $("select[name=cmbAssignCt]").attr('disabled','disabled');

        $("#CTGroup").val(obj.ctSubGrp);
        $("#brnchId").val(obj.brnchId);
        $("#CTSSessionCode").val(obj.sessionCode);
    }

    function onChangeStatusType(){
        $("#m3").hide(); // ASSIGN CT
        $("#m4").hide(); // DSC BRANCH
        $("#m5").hide(); // REQUEST DATE
        $("#m6").hide(); // APPOINTMENT DATE
        $("#m7").hide(); // RECALL DATE
        $("#m8").hide(); // APPOINTMENT SESSION
        $("#m9").hide(); // REMARK

        if($("#addStatus").val() == '19') { // RECALL
            $("select[name=cmbAssignCt]").attr('disabled', 'disabled');
            $("select[name=cmbAssignCt]").addClass("w100p disabled");
            $("select[name=cmbAssignCt]").val('');
            $("#requestDate").attr('disabled','disabled');
            $("#requestDate").val('');
            $("select[name=cmbFeedbackCd]").removeAttr("disabled");
            $("select[name=cmbFeedbackCd]").removeClass("w100p disabled");
            $("select[name=cmbFeedbackCd]").addClass("w100p");
            $("select[name=cmbCtGroup]").attr('disabled', 'disabled');
            $("select[name=cmbCtGroup]").addClass("w100p disabled");
            $("select[name=cmbCtGroup]").val('');
            $("#addAppRetnDt").attr('disabled','disabled');
            $("#addAppRetnDt").val('');
            $("#addCallRecallDt").removeAttr("disabled");

            $("#m7").show();
            $("#m9").show();

        } else if($("#addStatus").val() == '32') { // COMFIRM TO CANCEL
            $("select[name=cmbFeedbackCd]").removeAttr("disabled");
            $("select[name=cmbFeedbackCd]").removeClass("w100p disabled");
            $("select[name=cmbFeedbackCd]").addClass("w100p");
            $("select[name=cmbAssignCt]").attr('disabled', 'disabled');
            $("select[name=cmbAssignCt]").addClass("w100p disabled");
            $("#addCallRecallDt").attr('disabled','disabled');
            $("#addCallRecallDt").val('');

            if("${cancelReqInfo.reqStageId}" == '24') { // BEFORE INSTALL
                $("select[name=cmbCtGroup]").attr('disabled', 'disabled');
                $("select[name=cmbCtGroup]").addClass("w100p disabled");
                $("select[name=cmbCtGroup]").val('');
                $("#addAppRetnDt").attr('disabled','disabled');
                $("#addAppRetnDt").val('');
                $("#requestDate").attr('disabled','disabled');
                $("#requestDate").val('');

                $("#m9").show();

            } else {
                $("select[name=cmbCtGroup]").removeAttr("disabled");
                $("select[name=cmbCtGroup]").removeClass("w100p disabled");
                $("select[name=cmbCtGroup]").addClass("w100p");
                $("#requestDate").removeAttr("disabled");

		        $("#m3").show();
		        $("#m4").show();
		        $("#m5").show();
		        $("#m6").show();
		        $("#m8").show();
		        $("#m9").show();
		    }

        } else if($("#addStatus").val() == '31') { // Reversal Of Cancellation
            $("select[name=cmbAssignCt]").removeAttr("disabled");
            $("select[name=cmbAssignCt]").removeClass("w100p disabled");
            $("select[name=cmbAssignCt]").addClass("w100p");
            $("select[name=cmbAssignCt]").val('');
            $("select[name=cmbFeedbackCd]").removeAttr("disabled");
            $("select[name=cmbFeedbackCd]").removeClass("w100p disabled");
            $("select[name=cmbFeedbackCd]").addClass("w100p");
            $("select[name=cmbCtGroup]").attr('disabled', 'disabled');
            $("select[name=cmbCtGroup]").addClass("w100p disabled");
            $("select[name=cmbCtGroup]").val('');
            $("#addAppRetnDt").attr('disabled','disabled');
            $("#addAppRetnDt").val('');
            $("select[name=cmbAssignCt]").attr('disabled', 'disabled');
            $("select[name=cmbAssignCt]").addClass("w100p disabled");
            $("#requestDate").attr('disabled','disabled');
            $("#requestDate").val('');

            if("${cancelReqInfo.reqStageId}" == '24'){ // BEFORE INSTALL
                $("#addCallRecallDt").removeAttr("disabled");
            } else {
                $("#addCallRecallDt").attr('disabled','disabled');
                $("#addCallRecallDt").val('');
            }
            $("#m9").show();

        } else if($("#addStatus").val() == '105'){ // CONTINUE RENTEL
            $("select[name=cmbAssignCt]").removeAttr("disabled");
            $("select[name=cmbAssignCt]").removeClass("w100p disabled");
            $("select[name=cmbAssignCt]").addClass("w100p");
            $("select[name=cmbAssignCt]").val('');
            $("select[name=cmbFeedbackCd]").removeAttr("disabled");
            $("select[name=cmbFeedbackCd]").removeClass("w100p disabled");
            $("select[name=cmbFeedbackCd]").addClass("w100p");
            $("select[name=cmbCtGroup]").attr('disabled', 'disabled');
            $("select[name=cmbCtGroup]").addClass("w100p disabled");
            $("select[name=cmbCtGroup]").val('');
            $("#addAppRetnDt").attr('disabled','disabled');
            $("#addAppRetnDt").val('');
            $("select[name=cmbAssignCt]").attr('disabled', 'disabled');
            $("select[name=cmbAssignCt]").addClass("w100p disabled");
            $("#requestDate").attr('disabled','disabled');
            $("#requestDate").val('');

            if("${cancelReqInfo.reqStageId}" == '24'){ // BEFORE INSTALL
                $("#addCallRecallDt").removeAttr("disabled");
            } else {
                $("#addCallRecallDt").attr('disabled','disabled');
                $("#addCallRecallDt").val('');
            }
            $("#m9").show();
        }

        fn_feebackcode();
    }

    /*KV - feedback code  */
    function fn_feebackcode() {
        var fdb = "";

        if($("#addStatus").val() == '19'){     // Recall
            fdb = '5529';
        }
        if($("#addStatus").val() == '32'){     // Confirm To Cancel
            fdb = '5530';
        }
        if($("#addStatus").val() == '31'){     // Reversal Of Cancellation
            fdb = '5531';
        }
        if($("#addStatus").val() == '105'){     //Continue Rental
            fdb = '5532';
        }
       doGetCombo('/sales/order/selectcancellationfeedback.do', fdb, '', 'cmbFeedbackCd', 'S', '');
    }

    // Save 저장
    function fn_saveCancel(){
        if(addCallForm.addStatus.value == "") {
            Common.alert("<spring:message code='sal.alert.msg.pleaseSelectTheStatus' />");
            return false;
        }

        if($("#addStatus").val() == '19') { // RECALL
            if(addCallForm.cmbFeedbackCd.value == "" || addCallForm.cmbFeedbackCd.value  == null) {
                Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                return false;
            }
            if(addCallForm.addCallRecallDt.value == "" || addCallForm.addCallRecallDt.value == null) {
                Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRecallDate' />");
                return false;
            }
            if(addCallForm.addRem.value == "") {
                Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                return false;
            }

        } else if($("#addStatus").val() == '32') { // CONFIRM TO CANCEL
            if("${cancelReqInfo.reqStageId}" == '24') { // BEFORE INSTALL
                if(addCallForm.cmbFeedbackCd.value == "" || addCallForm.cmbFeedbackCd.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                    return false;
                }
                if(addCallForm.addRem.value == "" || addCallForm.addRem.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                    return false;
                }

            } else if("${cancelReqInfo.reqStageId}" == '25') {
                if(addCallForm.requestDate.value == "" || addCallForm.requestDate.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.plzSelInputReqDate' />");
                	return false;
                }
                if(addCallForm.cmbAssignCt.value == "" || addCallForm.cmbAssignCt.value == null){
                    Common.alert("<spring:message code='sal.alert.msg.plzReSelReqDate' />");
                    return false;
                }
                if(addCallForm.cmbFeedbackCd.value == "" || addCallForm.cmbFeedbackCd.value == null){
                	Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                	return false;
                }
                if(addCallForm.cmbAssignCt.value == "" || addCallForm.cmbAssignCt.value == null){
                	Common.alert("<spring:message code='sal.pleaseKeyInTheAssignCT' />");
                	return false;
                }
                if(addCallForm.cmbCtGroup.value == "" || addCallForm.cmbCtGroup.value == null){
                    // Common.alert("Please key in the CT Group");
                    // return false;
                }

                if(addCallForm.addAppRetnDt.value == "" || addCallForm.addAppRetnDt.value == null){
                    Common.alert("<spring:message code='sal.pleaseKeyInTheAppointmentDate' />");
                    return false;
                }
                if(addCallForm.addRem.value == "" || addCallForm.addRem.value == null){
                	 Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                	 return false;
                }

            } else {
                if(addCallForm.cmbFeedbackCd.value == "" || addCallForm.cmbFeedbackCd.value == null){
                	Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                	return false;
                }
                if(addCallForm.addRem.value == "" || addCallForm.addRem.value == null){
                	Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                	return false;
                }
            }

        } else if($("#addStatus").val() == '31') { // REVERSAL OF CANCELLATION
            if("${cancelReqInfo.reqStageId}" == '24') { // BEFORE INSTALL
                if(addCallForm.cmbFeedbackCd.value == "" || addCallForm.cmbFeedbackCd.value == null){
                    Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                    return false;
                }
                if(addCallForm.addRem.value == "" || addCallForm.addRem.value == null){
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                    return false;
                }
                if(addCallForm.addCallRecallDt.value == "" || addCallForm.addCallRecallDt.value == null){
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRecallDate' />");
                    return false;
                }
            } else {
                if(addCallForm.cmbFeedbackCd.value == "" || addCallForm.cmbFeedbackCd.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                    return false;
                }
                if(addCallForm.addRem.value == "" || addCallForm.addRem.value == null){
                	Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                	return false;
                }
            }

        } else if($("#addStatus").val() == '105') { // Continue Rental
            if("${cancelReqInfo.reqStageId}" == '24' ){ // before installl
                if(addCallForm.cmbFeedbackCd.value == "" || addCallForm.cmbFeedbackCd.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                    return false;
                }
                if(addCallForm.addRem.value == "" || addCallForm.addRem.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                    return false;
                }
                if(addCallForm.addCallRecallDt.value == "" || addCallForm.addCallRecallDt.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRecallDate' />");
                    return false;
                }
            } else {
                if(addCallForm.cmbFeedbackCd.value == "" || addCallForm.cmbFeedbackCd.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                    return false;
                }
                if(addCallForm.addRem.value == "" || addCallForm.addRem.value == null) {
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                    return false;
                }
            }
        }
        // have Another Order Cancled together
        if(js.String.isNotEmpty(anoOrdNo) /* && ordCtgryCd == 'MAT' */) {
        	Common.confirm('<spring:message code="sal.page.title.orderCancellation" />' + DEFAULT_DELIMITER + "<b>"+ _cancleMsg +"</b>", fn_procSaveCancel);
        } else {
        	fn_procSaveCancel();
        }
    }

    // 저장
    function fn_procSaveCancel() {
    	console.log($("#addCallForm").serializeJSON());
         Common.ajax("GET", "/homecare/sales/order/hcSaveCancel.do", $("#addCallForm").serializeJSON(), function(result) {
        	Common.alert(result.message);

            if(result.code == '00') {   // success
                fn_success();
            }
        }, function(jqXHR, textStatus, errorThrown) {
            try {
                Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
            } catch (e) {
            	Common.alert("Saving data prepration failed.");
            }
            // alert("Fail : " + jqXHR.responseJSON.message);
        });
    }

    function fn_cancelReload(){
        fn_orderCancelListAjax();

        if($("#addStatus").val() == '32' ||$("#addStatus").val() == '31' ||$("#addStatus").val() == '105'){
            $("#callStusId").val(1);
        }
        $("#_close").click();
        Common.popupDiv("/sales/order/cancelNewLogResultPop.do", $("#detailForm").serializeJSON(), null , true, '_newDiv');
    }

    function fn_success(){
        fn_orderCancelListAjax();
        $("#_close").click();
    }

    function fn_changeDeactPaymode(x){
        console.log(x);
        if(x == 1){
            $('#deactPayModeYes').prop("checked",true);
            $('#deactPayModeNo').removeAttr("checked");
            $("#deactPayMode").val("");
            $("#deactPayMode").val(x);
        }
        else {
            $('#deactPayModeNo').prop("checked",true);
            $('#deactPayModeYes').removeAttr("checked");
            $("#deactPayMode").val("");
            $("#deactPayMode").val(x);
        }
    }

    //그리드 속성 설정
    var gridPros = {
        usePaging                : true,         // 페이징 사용
        pageRowCount         : 10,            // 한 화면에 출력되는 행 개수 20(기본값:20)
        editable                   : false,
        fixedColumnCount     : 0,
        showStateColumn      : true,
        displayTreeOpen       : false,
        selectionMode          : "singleRow",  // "multipleCells",
        headerHeight            : 30,
        useGroupingPanel      : false,        // 그룹핑 패널 사용
        skipReadonlyColumns : true,         // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove    : true,         // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn : true,         // 줄번호 칼럼 렌더러 출력
        noDataMessage         : "No order found.",
        groupingMessage      : "Here groupping"
    };

    function chgGridTab(tabNm) {
        switch(tabNm) {
            case 'custInfo' :
                AUIGrid.resize(custInfoGridID, 942, 380);
                break;

            case 'memInfo' :
                AUIGrid.resize(memInfoGridID, 942, 380);
                break;

            case 'docInfo' :
                AUIGrid.resize(docGridID, 942, 380);
                if(AUIGrid.getRowCount(docGridID) <= 0) {
                    fn_selectDocumentList();
                }
                break;

            case 'callLogInfo' :
                AUIGrid.resize(callLogGridID, 942, 380);
                if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                    fn_selectCallLogList();
                }
                break;

            case 'payInfo' :
                AUIGrid.resize(payGridID, 942, 380);
                if(AUIGrid.getRowCount(payGridID) <= 0) {
                    fn_selectPaymentList();
                }
                break;

            case 'transInfo' :
                AUIGrid.resize(transGridID, 942, 380);
                if(AUIGrid.getRowCount(transGridID) <= 0) {
                    fn_selectTransList();
                }
                break;

            case 'autoDebitInfo' :
                AUIGrid.resize(autoDebitGridID, 942, 380);
                if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                    fn_selectAutoDebitList();
                }
                break;

            case 'discountInfo' :
                AUIGrid.resize(discountGridID, 942, 380);
                if(AUIGrid.getRowCount(discountGridID) <= 0) {
                    fn_selectDiscountList();
                }
                break;
        };
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<!-- pop_header start -->
<header class="pop_header">
<h1><spring:message code="sal.page.title.orderCancellationNew" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<form id="tabForm" name="tabForm" action="#" method="post">
    <input id="docId" name="docId" type="hidden" value="${paramDocId}">
    <input id="typeId" name="typeId" type="hidden" value="${paramTypeId}">
    <input id="refId" name="refId" type="hidden" value="${paramRefId}">
</form>
<section class="pop_body"><!-- pop_body start -->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#"><spring:message code="sal.title.cancellationRequestInfo" /></a></dt>
    <dd>
	    <table class="type1"><!-- table start -->
		    <caption>table</caption>
		    <colgroup>
		        <col style="width:130px" />
		        <col style="width:*" />
		        <col style="width:130px" />
		        <col style="width:*" />
		        <col style="width:160px" />
		        <col style="width:*" />
		    </colgroup>
		    <tbody>
			    <tr>
			        <th scope="row"><spring:message code="sal.text.requestNo" /></th>
			        <td><span>${cancelReqInfo.reqNo}</span></td>
			        <th scope="row"><spring:message code='sal.text.creator' /></th>
			        <td>${cancelReqInfo.crtUserId}</td>
			        <th scope="row"><spring:message code="sal.text.requestDate" /></th>
			        <td>${cancelReqInfo.callRecallDt}</td>
			    </tr>
			    <tr>
			        <th scope="row"><spring:message code="sal.text.requestStatus" /></th>
			        <td><span>${cancelReqInfo.reqStusName}</span></td>
			        <th scope="row"><spring:message code="sal.title.text.requestStage" /></th>
			        <td>${cancelReqInfo.reqStage}
			        </td>
			        <th scope="row"><spring:message code="sal.text.requestReason" /></th>
			        <td>${cancelReqInfo.reqResnCode} - ${cancelReqInfo.reqResnDesc}
			        </td>
			    </tr>
			    <tr>
			        <th scope="row"><spring:message code="sal.title.text.callStatus" /></th>
			        <td>
			        <span>${cancelReqInfo.callStusName}</span>
			        </td>
			        <th scope="row"><spring:message code="sal.title.text.reCallDate" /></th>
			        <td>${cancelReqInfo.callRecallDt}
			        </td>
			        <th scope="row"><spring:message code="sal.text.requestor" /></th>
			        <td>${cancelReqInfo.reqster}
			        </td>
			    </tr>
			    <tr>
			        <th scope="row"><spring:message code="sal.text.appTypeOnRequest" /></th>
			        <td>
			        <span>${cancelReqInfo.appTypeName}</span>
			        </td>
			        <th scope="row"><spring:message code="sal.text.stockOnRequest" /></th>
			        <td colspan="3">${cancelReqInfo.stockCode} - ${cancelReqInfo.stockName}
			        </td>
			    </tr>
			    <tr>
			        <th scope="row"><spring:message code="sal.text.outstandingOnRequest" /></th>
			        <td>
			        <span>${cancelReqInfo.ordOtstnd}</span>
			        </td>
			        <th scope="row"><spring:message code="sal.text.penaltyAmtOnRequest" /></th>
			        <td>${cancelReqInfo.pnaltyAmt}
			        </td>
			        <th scope="row"><spring:message code="sal.text.adjustmentAmtOnRequest" /></th>
			        <td>${cancelReqInfo.adjAmt}
			        </td>
			    </tr>
			    <tr>
			        <th scope="row"><spring:message code="sal.text.grandTotalOnRequest" /></th>
			        <td>
			        <span>${cancelReqInfo.grandTot}</span>
			        </td>
			        <th scope="row"><spring:message code="sal.text.usingMonthsOnRequest" /></th>
			        <td>${cancelReqInfo.usedMth}
			        </td>
			        <th scope="row"><spring:message code="sal.text.obligatioinMonthsOnRequest" /></th>
			        <td>${cancelReqInfo.obligtMth}
			        </td>
			    </tr>
			    <tr>
			        <th scope="row"><spring:message code="sal.text.underCoolingOffPeriod" /></th>
			        <td>
			        <span></span>
			        </td>
			        <th scope="row"><spring:message code="sal.text.appointmentDate" /></th>
			        <td>
			            <c:choose >
			                <c:when test="${cancelReqInfo.appRetnDg eq '01-01-1900'}">
			                -
			                </c:when>
			                <c:otherwise>
			                    ${cancelReqInfo.appRetnDg}
			                </c:otherwise>
			            </c:choose>
			        </td>
			        <th scope="row"><spring:message code="sal.text.actualCancelDate" /></th>
			        <td>
			            <c:choose >
			                <c:when test="${cancelReqInfo.actualCanclDt eq '01-01-1900'}">
			                -
			                </c:when>
			                <c:otherwise>
			                    ${cancelReqInfo.actualCanclDt}
			                </c:otherwise>
			            </c:choose>
			        </td>
			    </tr>
			    <tr>
			        <th scope="row">OCR <spring:message code="sal.text.remark" /></th>
			        <td colspan="5">${cancelReqInfo.reqRem}
			        </td>
			    </tr>
		    </tbody>
	    </table><!-- table end -->
    </dd>
    <dt class="click_add_on"><a href="#"><spring:message code="sal.title.text.orderFullDetails" /></a></dt>
    <dd>
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
			        <li><a href="#"><spring:message code="sal.title.text.paymentListing" /></a></li>
			    </c:if>
		        <li><a href="#" onClick="javascript:chgGridTab('payInfo');"><spring:message code="sal.title.text.paymentListing" /></a></li>
		        <li><a href="#" onClick="javascript:chgGridTab('transInfo');"><spring:message code="sal.title.text.lastSixMonthTrnsaction" /></a></li>
		        <li><a href="#"><spring:message code="sal.title.text.ordConfiguration" /></a></li>
		        <li><a href="#" onClick="javascript:chgGridTab('autoDebitInfo');"><spring:message code="sal.title.text.autoDebitResult" /></a></li>
		        <li><a href="#"><spring:message code="sal.title.text.reliefCertificate" /></a></li>
		        <li><a href="#" onClick="javascript:chgGridTab('discountInfo');"><spring:message code="sal.title.text.discount" /></a></li>
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
        </section><!-- tap_wrap end -->
    </dd>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(cancelLogGridID)"><spring:message code="sal.text.cancellationLogTransaction" /></a></dt>
    <dd>
	    <article class="grid_wrap"><!-- grid_wrap start -->
	        <div id="cancelLog" style="width:100%; height:480px; margin:0 auto;"></div>
	    </article><!-- grid_wrap end -->
    </dd>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(prodReturnGridID)"><spring:message code="sal.text.productReturnTransaction" /></a></dt>
    <dd>
	    <article class="grid_wrap"><!-- grid_wrap start -->
	        <div id="productReturn" style="width:100%; height:480px; margin:0 auto;"></div>
	    </article><!-- grid_wrap end -->
    </dd>
</dl>
</article><!-- acodi_wrap end -->

<div id="addDiv">
	<aside class="title_line"><!-- title_line start -->
	   <h2>Add Call Result</h2>
	</aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
	    <form id="addCallForm" name="addCallForm" action="#" method="post" autocomplete=off>
		    <input id="paramdocId" name="paramdocId" type="hidden" value="${paramDocId}">
		    <input id="paramtypeId" name="paramtypeId" type="hidden" value="${paramTypeId}">
		    <input id="paramrefId" name="paramrefId" type="hidden" value="${paramRefId}">
		    <input id="reqStageId" name="reqStageId" type="hidden" value="${cancelReqInfo.reqStageId}">
		    <input id="paramCallEntryId" name="paramCallEntryId" type="hidden" value="${cancelReqInfo.callEntryId}">
		    <input id="paramReqId" name="paramReqId" type="hidden" value="${cancelReqInfo.reqId}">
		    <input id="paramOrdId" name="paramOrdId" type="hidden" value="${cancelReqInfo.ordId}">
		    <input id="paramAnoOrdId" name="paramAnoOrdId" type="hidden" value="${hcOrder.anoOrdId}"/>
		    <input id="paramOrdCtgryCd" name="paramOrdCtgryCd" type="hidden" value="${hcOrder.ordCtgryCd}"/>
		    <input id="paramStockId" name="paramStockId" type="hidden" value="${cancelReqInfo.stockId}">
		    <input id="callStusId" name="callStusId" type="hidden" >
		    <input id="appTypeId" name="appTypeId" type="hidden" value="${cancelReqInfo.appTypeId}">
		    <input id="rcdTms" name="rcdTms" type="hidden" value="${rcdTms}">
		    <!--  add by hgham  -->
		    <input id="ctId" name="ctId" type="hidden" >

		      <!--  added by Adib -->
  <input type="hidden" name="pgmPath" value="sales/order/hcCancelNewLogResultPop"/>
  <input id="rentPayMode" name="rentPayMode" type="hidden" value="${orderDetail.rentPaySetInf.payModeId}">
  <input id="rentPayId" name="rentPayId" type="hidden" value="${orderDetail.rentPaySetInf.rentPayId}"/>

		    <table class="type1"><!-- table start -->
		        <caption>table</caption>
			    <colgroup>
			        <col style="width:160px" />
			        <col style="width:*" />
			        <col style="width:180px" />
			        <col style="width:*" />
	            </colgroup>
		        <tbody>
			        <tr>
					    <th scope="row"><spring:message code="sal.text.status" /><span id='m1' name='m1' class="must">*</span></th>
						<td>
						    <select id="addStatus" name="addStatus" class="w100p" onchange="onChangeStatusType();" />
						</td>
						<th scope="row"><spring:message code="sal.text.feddbackCode" /><span id='m2' name='m2' class="must">*</span></th>
						<td>
						    <select id="cmbFeedbackCd" name="cmbFeedbackCd" class="disabled" disabled="disabled" >
						        <option value="">Feedback Code</option>
						    </select>
		                </td>
					</tr>
		            <tr>
				        <th scope="row">Assign DT<span id='m3' name='m3' class="must" >*</span></th>
				        <td><input type="text" id="cmbAssignCt" name="cmbAssignCt" class="readonly " readonly="readonly" /></td>
				        <th scope="row"><spring:message code="sal.title.text.dscBrnch" /><span id='m4' name='m4' class="must">*</span></th>
				        <td>
				            <input type="text" id="dtSubGrp" name="dtSubGrp"  class="readonly" readonly="readonly" />
				            <input type="hidden" id="brnchId" name="brnchId"  class="readonly" readonly="readonly" />
				            <div style="display:none">
				                <select id="cmbCtGroup" name="cmbCtGroup" class="disabled" disabled="disabled">
				                    <option value="">CT Group</option>
				                    <option value="A">Group A</option>
				                    <option value="B">Group B</option>
				                    <option value="C">Group C</option>
				                </select>
				            </div>
				        </td>
	                </tr>
		            <tr>
		                <th scope="row"><spring:message code="sal.text.requestDate" /><span id='m5' name='m5' class="must">*</span></th>
		                <td>
		                    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc w100p" id="requestDate" name="requestDate"  onChange="fn_doAllaction()" disabled="disabled"/>
		                </td>
		                <th scope="row"><spring:message code="sal.text.appointmentDate" /><span id='m6' name='m6' class="must">*</span></th>
		                <td>
		                    <input type="text" id="addAppRetnDt" name="addAppRetnDt" title="Create start Date" placeholder="DD/MM/YYYY"  readonly="readonly" class="j_dateHc readonly" />
		                </td>
		            </tr>
		            <tr>
		                <th scope="row"><spring:message code="sal.title.text.reCallDate" /><span id='m7' name='m7' class="must">*</span></th>
		                <td>
		                    <input type="text" id="addCallRecallDt" name="addCallRecallDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc" disabled="disabled" />
		                </td>
		                <th scope="row">Appointment <br> Session <span id='m8' name='m8' class="must">*</span></th>
		                <td>
		                    <input type="text" title="" placeholder=""  id="CTSSessionCode" name="CTSSessionCode" class="readonly"  readonly="readonly" />
		                </td>
		            </tr>
		            <c:if test ="${orderDetail.rentPaySetInf.payModeId eq '130' or orderDetail.rentPaySetInf.payModeId eq '131' or orderDetail.rentPaySetInf.payModeId eq '132'}">
                    <c:if test ="${orderDetail.basicInfo.rentalStus eq 'RET' or orderDetail.basicInfo.rentalStus eq 'TER'}">
                    <c:if test ="${orderDetail.logView.prgrsId eq '13' or orderDetail.logView.prgrsId eq '12' or orderDetail.logView.prgrsId eq '11'}">
		            <tr>
		            <th scope="row">Deactivate Paymode</th>
		            <td>
		            <div style="display:inline-block;width:100%;">
		            <div style="display:inline-block;">
		            <label for="deactPayModeYes">YES</label>
		            <input id="deactPayModeYes" type="checkbox" value="1" name="deactPayMode" onChange="fn_changeDeactPaymode(this.value)"/>
		            </div>
		            <div style="display:inline-block;">
		            <label for="deactPayModeNo">NO</label>
		            <input  id="deactPayModeNo" type="checkbox" value="0" name="deactPayMode" onChange="fn_changeDeactPaymode(this.value)" checked/>
		            </div>
		            </div>
		            </td>
		            </tr>
		            </c:if>
		            </c:if>
		            </c:if>
		            <tr>
		                <th scope="row"><spring:message code="sal.text.remark" /><span id='m9' name='m9' class="must">*</span></th>
		                <td colspan="3">
		                    <textarea id="addRem" name="addRem" cols="20" rows="5"></textarea>
		                </td>
		            </tr>
	            </tbody>
	        </table><!-- table end -->
		</form>
	</section><!-- search_table end -->
	<ul class="center_btns mt20">
	    <li><p class="btn_blue2 big"><a href="#" onClick="fn_saveCancel()"><spring:message code="sal.btn.save" /></a></p></li>
	</ul>
</div>
</section><!-- pop_body end -->
</div>
