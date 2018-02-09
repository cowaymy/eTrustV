<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

    //AUIGrid 생성 후 반환 ID
    var cancelLogGridID;       // Cancellation Log Transaction list
    var prodReturnGridID;      // Product Return Transaction list

    $(document).ready(function(){
    	if($("#callStusId").val() == '1'){
    		$("#addDiv").css("display" , "none");
    		$("#callStusId").val('');
    	}
        //AUIGrid 그리드를 생성합니다.
        cancelLogGrid();
        prodReturnGrid();

       /*  AUIGrid.setSelectionMode(addrGridID, "singleRow"); */
        //Call Ajax
        fn_cancelLogTransList();
        fn_productReturnTransList();

        //j_date
        var pickerOpts={
                changeMonth:true,
                changeYear:true,
                dateFormat: "dd/mm/yy"
        };

        $(".j_date").datepicker(pickerOpts);

        var monthOptions = {
            pattern: 'mm/yyyy',
            selectedYear: 2017,
            startYear: 2007,
            finalYear: 2027
        };

        $(".j_date2").monthpicker(monthOptions);
//        alert(("#callStusId").val());
//        if($("#callStusId").val() == '32' || $("#callStusId").val() == '31'){
//            $("#addDiv").css("display" , "none");
//          $("#addDiv").hide();
//        }

        //Btn Auth
        if(basicAuth == true){
            $("#_basicUpdBtn").css("display" , "");
        }else{
            $("#_basicUpdBtn").css("display" , "none");
        }
    });

    function cancelLogGrid(){
        // Cancellation Log Transaction Column
        var cancelLogColumnLayout = [
             {dataField : "code1", headerText : "<spring:message code='sal.text.type' />", width : '10%'}, 
             {dataField : "code", headerText : "<spring:message code='sal.text.status' />", width : '10%'},
             {dataField : "crtDt", headerText : "<spring:message code='sal.text.createDate' />", width : '20%'}, 
             {dataField : "callentryUserName", headerText : "<spring:message code='sal.text.creator' />", width : '20%'},
             {dataField : "updDt", headerText : "<spring:message code='sal.title.text.updateDate' />", width : '20%'}, 
             {dataField : "userName", headerText : "<spring:message code='sal.text.updator' />", width : '20%'}
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

        cancelLogGridID = GridCommon.createAUIGrid("#cancelLog", cancelLogColumnLayout,'', gridPros);
    }

    function prodReturnGrid(){
        // Product Return Transaction Column
        var prodReturnColumnLayout = [
             {dataField : "retnNo", headerText : "<spring:message code='sal.title.text.returnNo' />", width : '15%'}, 
             {dataField : "code", headerText : "<spring:message code='sal.text.status' />", width : '10%'},
             {dataField : "created1", headerText : "<spring:message code='sal.text.createDate' />", width : '11%'}, 
             {dataField : "username1", headerText : "<spring:message code='sal.text.creator' />", width : '11%'},
             {dataField : "memCodeName2", headerText : "<spring:message code='sal.title.text.assignCt' />"}, 
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

	    var ord_id ='${cancelReqInfo.ordId}'   ;// '143486';
	    var  vdte   =$("#requestDate").val();

	    var options ={
	            ORD_ID: ord_id,
	            S_DATE: vdte,
	            CallBackFun:'fn_allactionFun'
	    }

	    Common.popupDiv("/organization/allocation/allocation.do" ,{ORD_ID:ord_id  , S_DATE:vdte , OPTIONS:options ,TYPE:'RTN'}, null , true , '_doAllactionDiv');
	}



	function fn_allactionFun(obj){

		   console.log(obj);
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
    	if($("#addStatus").val() == '19'){     // Recall
    		$("select[name=cmbAssignCt]").attr('disabled', 'disabled');
            $("select[name=cmbAssignCt]").addClass("w100p disabled");
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
    	}
    	if($("#addStatus").val() == '32'){     // Confirm To Cancel
            $("select[name=cmbFeedbackCd]").removeAttr("disabled");
            $("select[name=cmbFeedbackCd]").removeClass("w100p disabled");
            $("select[name=cmbFeedbackCd]").addClass("w100p");
            $("#addCallRecallDt").attr('disabled','disabled');
            $("#addCallRecallDt").val('');
            if($("#reqStageId").val() == '24'){     // before installl
            	$("select[name=cmbCtGroup]").attr('disabled', 'disabled');
                $("select[name=cmbCtGroup]").addClass("w100p disabled");
                $("select[name=cmbCtGroup]").val('');
                $("#addAppRetnDt").attr('disabled','disabled');
                $("#addAppRetnDt").val('');
                $("select[name=cmbAssignCt]").attr('disabled', 'disabled');
                $("select[name=cmbAssignCt]").addClass("w100p disabled");
                $("#requestDate").attr('disabled','disabled');
                $("#requestDate").val('');
            }else{
            	$("select[name=cmbCtGroup]").removeAttr("disabled");
                $("select[name=cmbCtGroup]").removeClass("w100p disabled");
                $("select[name=cmbCtGroup]").addClass("w100p");
                //$("#addAppRetnDt").removeAttr("disabled");
                $("select[name=cmbAssignCt]").removeAttr("disabled");
                $("select[name=cmbAssignCt]").removeClass("w100p disabled");
                $("select[name=cmbAssignCt]").addClass("w100p");
                $("#requestDate").removeAttr("disabled");
            }

        }
    	if($("#addStatus").val() == '31'){     // Reversal Of Cancellation
            $("select[name=cmbAssignCt]").removeAttr("disabled");
            $("select[name=cmbAssignCt]").removeClass("w100p disabled");
            $("select[name=cmbAssignCt]").addClass("w100p");
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
            if($("#reqStageId").val() == '24'){     // before installl
            	$("#addCallRecallDt").removeAttr("disabled");
            }else{
            	$("#addCallRecallDt").attr('disabled','disabled');
                $("#addCallRecallDt").val('');
            }
        }
    }

    function fn_saveCancel(){
    	if(addCallForm.addStatus.value == ""){
    		Common.alert("<spring:message code='sal.alert.msg.pleaseSelectTheStatus' />");
    		return false;
    	}
    	console.log("status : " + $("#reqStageId").val());
    	if($("#addStatus").val() == '19'){     // Recall
//    		if($("#reqStageId").val() == '24'){     // before installl
    			if(addCallForm.cmbFeedbackCd.value == ""){
    				Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
    				return false;
    			}
    			if(addCallForm.addCallRecallDt.value == ""){
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRecallDate' />");
                    return false;
                }
    			if(addCallForm.addRem.value == ""){
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                    return false;
                }
//    		}
    	}
    	if($("#addStatus").val() == '32'){     // Confirm To Cancel
    		
          if($("#reqStageId").val() == '24'){     // before installl
        	  console.log("before : " + $("#reqStageId").val());
                if(addCallForm.cmbFeedbackCd.value == ""){
                    Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                    return false;
                }
                if(addCallForm.addRem.value == ""){
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                    return false;
                }
            }else if($("#reqStageId").val() == '25'){
            	console.log("after : " + $("#reqStageId").val());
            	if(addCallForm.cmbFeedbackCd.value == ""){
                    Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                    return false;
                }
                if(addCallForm.cmbAssignCt.value == ""){
                    Common.alert("<spring:message code='sal.pleaseKeyInTheAssignCT' />");
                    return false;
                }
                if(addCallForm.cmbCtGroup.value == ""){
                   // Common.alert("Please key in the CT Group");
                   // return false;
                }
                if(addCallForm.addAppRetnDt.value == ""){
                    Common.alert("<spring:message code='sal.pleaseKeyInTheAppointmentDate' />");
                    return false;
                }
                if(addCallForm.addRem.value == ""){
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                    return false;
                }
            }else{
            	console.log("else : " + $("#reqStageId").val());
            	if(addCallForm.cmbFeedbackCd.value == ""){
                    Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                    return false;
                }
            	if(addCallForm.addRem.value == ""){
                    Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                    return false;
                }
            }
        }
    	if($("#addStatus").val() == '31'){     // Reversal Of Cancellation
            if($("#reqStageId").val() == '24'){     // before installl
                  if(addCallForm.cmbFeedbackCd.value == ""){
                      Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                      return false;
                  }
                  if(addCallForm.addRem.value == ""){
                      Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                      return false;
                  }
                  if(addCallForm.addCallRecallDt.value == ""){
                      Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRecallDate' />");
                      return false;
                  }
              }else{
                  if(addCallForm.cmbFeedbackCd.value == ""){
                      Common.alert("<spring:message code='sal.alert.msg.plzSelFeedbackCode' />");
                      return false;
                  }
                  if(addCallForm.addRem.value == ""){
                      Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheRemark' />");
                      return false;
                  }
                  //if(addCallForm.cmbAssignCt.value == ""){
                  //    Common.alert("Please key in the Assign CT");
                  //    return false;
                  //}
              }
          }
    	Common.ajax("GET", "/sales/order/saveCancel.do", $("#addCallForm").serializeJSON(), function(result) {
            Common.alert(result.msg, fn_success);

        }, function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                    Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                    }
                catch (e) {
                    console.log(e);
                    alert("Saving data prepration failed.");
                }
                alert("Fail : " + jqXHR.responseJSON.message);
        });
    }

//    function fn_reloadPage(){
        //Parent Window Method Call
//        fn_orderCancelListAjax();
//        Common.popupDiv('/sales/order/cancelReqInfoPop.do', $('#detailForm').serializeJSON(), null , true, '_editDiv2');
//        $("#_close").click();
//    }

    function fn_cancelReload(){
    	fn_orderCancelListAjax();
    	if($("#addStatus").val() == '32' ||$("#addStatus").val() == '31'){
    		$("#callStusId").val(1);
    	}

    	$("#_close").click();
    	Common.popupDiv("/sales/order/cancelNewLogResultPop.do", $("#detailForm").serializeJSON(), null , true, '_newDiv');



    }

    function fn_success(){
//    	fn_cancelReload();
        fn_orderCancelListAjax();
    	$("#_close").click();
    }

  //그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
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
        noDataMessage       : "No order found.",
        groupingMessage     : "Here groupping"
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
<!--
    <li><p class="btn_blue2"><a href="#">COPY</a></p></li>
    <li><p class="btn_blue2"><a href="#">EDIT</a></p></li>
    <li><p class="btn_blue2"><a href="#">NEW</a></p></li>
 -->
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
<!--
    <tr>
        <th scope="row">Bank Account</th>
        <td>
        <span>${cancelReqInfo.bankAcc}</span>
        </td>
        <th scope="row">Issue Bank</th>
        <td>${cancelReqInfo.issBank}
        </td>
        <th scope="row">Account Name</th>
        <td>${cancelReqInfo.accName}
        </td>
    </tr>
    <tr>
        <th scope="row">Attachment</th>
        <td colspan="5">${cancelReqInfo.attach}
        </td>
    </tr>
 -->
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
<form id="addCallForm" name="addCallForm" action="#" method="post">
    <input id="paramdocId" name="paramdocId" type="hidden" value="${paramDocId}">
    <input id="paramtypeId" name="paramtypeId" type="hidden" value="${paramTypeId}">
    <input id="paramrefId" name="paramrefId" type="hidden" value="${paramRefId}">
    <input id="reqStageId" name="reqStageId" type="hidden" value="${cancelReqInfo.reqStageId}">
    <input id="paramCallEntryId" name="paramCallEntryId" type="hidden" value="${cancelReqInfo.callEntryId}">
    <input id="paramReqId" name="paramReqId" type="hidden" value="${cancelReqInfo.reqId}">
    <input id="paramOrdId" name="paramOrdId" type="hidden" value="${cancelReqInfo.ordId}">
    <input id="paramStockId" name="paramStockId" type="hidden" value="${cancelReqInfo.stockId}">
    <input id="callStusId" name="callStusId" type="hidden" >
    <input id="appTypeId" name="appTypeId" type="hidden" value="${cancelReqInfo.appTypeId}">

    <!--  add by hgham  -->
    <input id="ctId" name="ctId" type="hidden" >

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
			    <th scope="row"><spring:message code="sal.text.status" /><span class="must">*</span></th>
			    <td>
			    <select id="addStatus" name="addStatus" class="w100p" onchange="onChangeStatusType()">
			        <option value=""><spring:message code="sal.title.text.callLogStus" /></option>
			        <option value="19"><spring:message code="sal.combo.text.recall" /></option>
			        <option value="32"><spring:message code="sal.combo.text.confirmToCancel" /></option>
			        <option value="31"><spring:message code="sal.combo.text.reversalOfCancellation" /></option>
			    </select>
			    </td>
			    <th scope="row"><spring:message code="sal.text.feddbackCode" /></th>
			    <td>
			    <select id="cmbFeedbackCd" name="cmbFeedbackCd" class="disabled" disabled="disabled">
                    <option value="">Feedback Code</option>
                    <c:forEach var="list" items="${selectFeedback }">
                        <option value="${list.resnId}">${list.codeResnDesc}</option>
                    </c:forEach>
			    </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code="sal.title.text.assignCt" /></th>
			    <td>
			    <select id="cmbAssignCt" name="cmbAssignCt" class="w100p" disabled="disabled">
			        <option value=""></option>
                     <c:forEach var="list" items="${selectAssignCTList }">
                        <option value="${list.memId}">${list.memCodeName}</option>
                    </c:forEach> 
			    </select>
			    </td>

			    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
				    <td>
				            <input type="text" title="" placeholder=""  id="CTGroup" name="CTGroup" class="readonly "    readonly="readonly"  />
				            <input type="hidden" title="" placeholder="" class="disabled" id="brnchId" name="brnchId"  class="readonly"    readonly="readonly" />
				          <div  style="display:none">
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
	                <th scope="row"><spring:message code="sal.text.requestDate" /><span class="must">*</span></th>
				    <td>
				    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="requestDate" name="requestDate"  onChange="fn_doAllaction()"/>
				    </td>


	                <th scope="row"><spring:message code="sal.text.appointmentDate" /></th>
	                <td>
	                  <input type="text" id="addAppRetnDt" name="addAppRetnDt" title="Create start Date" placeholder="DD/MM/YYYY" readonly="readonly"    class="j_date readonly"  />
	                </td>
            </tr>
			<tr>
			       <th scope="row"><spring:message code="sal.title.text.reCallDate" /></th>
				    <td>
				      <input type="text" id="addCallRecallDt" name="addCallRecallDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" disabled="disabled" />
				    </td>

				      <th scope="row">Appointment <br> Sessione </th>
                    <td>
                          <input type="text" title="" placeholder=""  id="CTSSessionCode" name="CTSSessionCode" class="readonly"    readonly="readonly"  />
                    </td>

			</tr>

			<tr>
			    <th scope="row"><spring:message code="sal.text.remark" /><span class="must">*</span></th>
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
