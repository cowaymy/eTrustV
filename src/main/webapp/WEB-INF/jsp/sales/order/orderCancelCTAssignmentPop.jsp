<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

	//AUIGrid 생성 후 반환 ID
	var cancelLogGridID;       // Cancellation Log Transaction list
	var prodReturnGridID;      // Product Return Transaction list
	
	 $(document).ready(function(){
		 
		//AUIGrid 그리드를 생성합니다. 
        cancelLogGrid();  
        prodReturnGrid();
        
        /*  AUIGrid.setSelectionMode(addrGridID, "singleRow"); */
        //Call Ajax
        fn_cancelLogTransList(); 
        fn_productReturnTransList();
        
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
	    
	    //Member Search Popup
	    $('#memBtn').click(function() {
	        Common.popupDiv("/sales/order/ctSearchPop.do", $("#tabForm").serializeJSON(), null, true);
	    });

	    $('#salesmanCd').change(function(event) {

	        var memCd = $('#salesmanCd').val().trim();

	        if(FormUtil.isNotEmpty(memCd)) {
	            fn_loadOrderSalesman(0, memCd);
	        }
	    });
	    
	    function fn_loadOrderSalesman(memId, memCode) {

	        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

	            if(memInfo == null) {
	                Common.alert('<b><spring:message code="sal.alert.msg.memNotFound" />'+memCode+'</b>');
	            }
	            else {
	                $('#hiddenSalesmanId').val(memInfo.memId);
	                $('#salesmanCd').val(memInfo.memCode);
	               
	                $('#salesmanCd').removeClass("readonly");
	              
	            }
	        });
	    }
	    
	    function fn_saveCT(){
	    	if(ctForm.salesmanCd.value == ""){
	            Common.alert("<spring:message code='sal.alert.msg.pleaseSelectTheAssignCt' />");
	            return false;
	        }
	    	
	    	Common.ajax("GET", "/sales/order/saveCtAssignment.do", $("#ctForm").serializeJSON(), function(result) {
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
	    
	    function fn_success(){
	        fn_orderCancelListAjax();
	        
	        $("#_close").click();
	        Common.popupDiv("/sales/order/ctAssignmentInfoPop.do", $("#detailForm").serializeJSON(), null , true, '_CTDiv');
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

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.ctAssignMent" /></h1>
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
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:200px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.requestNo" /></th>
        <td><span>${cancelReqInfo.reqNo}</span></td>
        <th scope="row"><spring:message code='sal.text.creator' /></th>
        <td><span>${cancelReqInfo.crtUserId}</span></td>
        <th scope="row"><spring:message code="sal.text.requestDate" /></th>
        <td><span>${cancelReqInfo.callRecallDt}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.requestStatus" /></th>
        <td><span>${cancelReqInfo.reqStusName}</span></td>
        <th scope="row"><spring:message code="sal.title.text.requestStage" /></th>
        <td><span>${cancelReqInfo.reqStage}</span></td>
        <th scope="row"><spring:message code="sal.text.requestReason" /></th>
        <td>${cancelReqInfo.reqResnCode} - ${cancelReqInfo.reqResnDesc}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.callStatus" /></th>
        <td><span>${cancelReqInfo.callStusName}</span></td>
        <th scope="row"><spring:message code="sal.title.text.reCallDate" /></th>
        <td><span>${cancelReqInfo.callRecallDt}</span></td>
        <th scope="row"><spring:message code="sal.text.requestor" /></th>
        <td><span>${cancelReqInfo.reqster}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.appTypeOnRequest" /></th>
        <td><span>${cancelReqInfo.appTypeName}</span></td>
        <th scope="row"><spring:message code="sal.text.stockOnRequest" /></th>
        <td colspan="3">${cancelReqInfo.stockCode} - ${cancelReqInfo.stockName}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.outstandingOnRequest" /></th>
        <td><span>${cancelReqInfo.ordOtstnd}</span></td>
        <th scope="row"><spring:message code="sal.text.penaltyAmtOnRequest" /></th>
        <td><span>${cancelReqInfo.pnaltyAmt}</span></td>
        <th scope="row"><spring:message code="sal.text.adjustmentAmtOnRequest" /></th>
        <td><span>${cancelReqInfo.adjAmt}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.grandTotalOnRequest" /></th>
        <td><span>${cancelReqInfo.grandTot}</span></td>
        <th scope="row"><spring:message code="sal.text.usingMonthsOnRequest" /></th>
        <td><span>${cancelReqInfo.usedMth}</span></td>
        <th scope="row"><spring:message code="sal.text.obligatioinMonthsOnRequest" /></th>
        <td><span>${cancelReqInfo.obligtMth}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.underCoolingOffPeriod" /></th>
        <td><span>${cancelReqInfo.isUnderCoolPriod}</span></td>
        <th scope="row"><spring:message code="sal.text.appointmentDate" /></th>
        <td><span>${cancelReqInfo.appRetnDg}</span></td>
        <th scope="row"><spring:message code="sal.text.actualCancelDate" /></th>
        <td><span>${cancelReqInfo.actualCanclDt}</span></td>
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
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(cancelLogGridID)">Cancellation Log Transaction</a></dt>
    <dd>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="cancelLog" style="width:100%; height:280px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(prodReturnGridID)"><spring:message code="sal.text.productReturnTransaction" /></a></dt>
    <dd>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="productReturn" style="width:100%; height:280px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
</dl>
</article><!-- acodi_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Coway Technician (CT)Assignment</h2>
</aside><!-- title_line end -->

<form id="ctForm" name="ctForm" method="post">
<input type="hidden" id="stkRetnId" name="stkRetnId" value="${ctAssignmentInfo.stkRetnId}">
<input type="hidden" id="stkRetnCtFrom" name="stkRetnCtFrom" value="${ctAssignmentInfo.memId}">
<input type="hidden" id="stkRetnCtGrpFrom" name="stkRetnCtGrpFrom" value="${ctAssignmentInfo.ctGrp}">
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
    <th scope="row"><spring:message code="sal.title.text.returnNo" /></th>
    <td><span>${ctAssignmentInfo.retnNo}</span></td>
    <th scope="row"><spring:message code="sal.text.ctGroupCurrent" /></th>
    <td><span>${ctAssignmentInfo.ctGrp}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ctCodeCurrent" /></th>
    <td><span>${ctAssignmentInfo.memCode}</span></td>
    <th scope="row"><spring:message code="sal.text.ctNameCurrent" /></th>
    <td><span>${ctAssignmentInfo.memName} (${ctAssignmentInfo.nric})</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.assignCt" /><span class="must">*</span></th>
    <td><input type="text" title="" id="salesmanCd" name="salesmanCd" value="${ctAssignmentInfo.memCode}" placeholder="" class="" />
          <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
          <a href="#" id="memBtn" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row"><spring:message code="sal.text.ctName" /></th>
    <td><span></span>${ctAssignmentInfo.memName} (${ctAssignmentInfo.nric})</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ctGroup" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="saveCtGroup" name="saveCtGroup">
        <option value="A">Group A</option>
        <option value="B">Group B</option>
        <option value="C">Group C</option>
    </select>
    </td>
    <th scope="row"></th>
    <td><span></span></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveCT()"><spring:message code="sal.btn.saveCtAssignment" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->