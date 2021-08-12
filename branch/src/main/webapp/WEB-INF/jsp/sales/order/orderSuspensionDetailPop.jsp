<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
    var inchargeGridID; 
    var callResultGridID;
    var callLogGirdID;
    
    $(document).ready(function(){
        
        createInchargeGrid();
        createCallResultGrid();
        createcallLogGird();
        
        //Call Ajax
        fn_getInchargeAjax(); 
        fn_getCallResultAjax();
        fn_getCallLogAjax();
    });
    
    function createInchargeGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var inchargeColumnLayout = [{
                dataField : "userName",
                headerText : '<spring:message code="sal.title.text.userName" />',
                width : 160,
                editable : false
            }, {
                dataField : "userFullName",
                headerText : '<spring:message code="sal.text.name" />',
                editable : false
            }];
       
        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : true, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        inchargeGridID = GridCommon.createAUIGrid("#incharge_grid_wrap", inchargeColumnLayout, "", gridPros);
    }
    
    function createCallResultGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var callResultColumnLayout = [{
                dataField : "stusCode",
                headerText : '<spring:message code="sal.title.status" />',
                width : 110,
                editable : false
            }, {
                dataField : "recalldt",
                headerText : '<spring:message code="sal.title.text.reCallDate" />',
                width : 130,
                editable : false
            }, {
                dataField : "resnDesc",
                headerText : '<spring:message code="sal.title.text.feedback" />',
                width : 160,
                editable : false
            }, {
                dataField : "callRem",
                headerText : '<spring:message code="sal.title.remark" />',
                editable : false
            }, {
                dataField : "callCrtUserName",
                headerText : '<spring:message code="sal.title.text.keyBy" />',
                width : 110,
                editable : false
            }, {
                dataField : "callCrtDt",
                headerText : '<spring:message code="sal.title.text.keyAt" />',
                dataType : "date", 
                formatString : "dd/mm/yyyy",
                width : 120,
                editable : false
            }];
       
        // 그리드 속성 설정
         var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
    //        fixedColumnCount : 0,
            showStateColumn : false, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            wordWrap :  true,
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
            groupingMessage : "Here groupping"
        }; 
        
/*         var gridPros = {
                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
              //  fixedColumnCount    : 0,            
                showStateColumn     : false,             
                displayTreeOpen     : false,            
              //selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping",
                wordWrap :  true
            }; */
        
        callResultGridID = GridCommon.createAUIGrid("#callResult_grid_wrap", callResultColumnLayout, "", gridPros);
    }
    
    function createcallLogGird() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var callLogColumnLayout = [{
                dataField : "codeName",
                headerText : '<spring:message code="sal.title.type" />',
                width : 130,
                editable : false
            }, {
                dataField : "'resnDesc",
                headerText : '<spring:message code="sal.title.text.feedback" />',
                width : 160,
                editable : false
            }, {
                dataField : "stusCodeName",
                headerText : '<spring:message code="sal.title.text.action" />',
                width : 120,
                editable : false
            }, {
                dataField : "callRosAmt",
                headerText : '<spring:message code="sal.title.amount" />',
                width : 70,
                editable : false
            },{
                dataField : "callRem",
                headerText : '<spring:message code="sal.title.remark" />',
                width : 350,
                editable : false
            }, {
                dataField : "rosCallerUserName",
                headerText : '<spring:message code="sal.title.text.caller" />',
                width : 110,
                editable : false
            }, {
                dataField : "callCrtUserName",
                headerText : '<spring:message code="sal.text.creator" />',
                width : 110,
                editable : false
            },{
                dataField : "callCrtDt",
                headerText : "CreateDate",
                dataType : '<spring:message code="sal.title.date" />', 
                formatString : "dd/mm/yyyy",
                width : 120,
                editable : false
            }];
       
        // 그리드 속성 설정
         var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
            editable : true,
       //     fixedColumnCount : 0,
            showStateColumn : false, 
            displayTreeOpen : false,
            selectionMode : "multipleCells",
            wordWrap :  true,
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
            groupingMessage : "Here groupping"
        }; 
        
/*         var gridPros = {
                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
              //  fixedColumnCount    : 0,            
                showStateColumn     : false,             
                displayTreeOpen     : false,            
              //selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping",
                wordWrap :  true
            }; */
        
        callLogGirdID = GridCommon.createAUIGrid("#callLog_grid_wrap", callLogColumnLayout, '',gridPros);
    }
    
    // contact Ajax
    function fn_getInchargeAjax(){
        Common.ajax("GET", "/sales/order/inchargePersonList.do",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(inchargeGridID, result);
        });
    }
    
 // contact Ajax
    function fn_getCallResultAjax(){
        Common.ajax("GET", "/sales/order/suspendCallResultList.do",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(callResultGridID, result);
        });
    }
 
 // contact Ajax
    function fn_getCallLogAjax(){
        Common.ajax("GET", "/sales/order/callResultLogList.do",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(callLogGirdID, result);
        });
    }
 
    //resize func (tab click)
    function fn_resizefunc(gridName){ // 
       AUIGrid.resize(gridName, 950, 300);
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
<h1><spring:message code="sal.title.text.suspendView" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="getParamForm" name="getParamForm" method="GET">
    <input type="hidden" id="susId" name="susId" value="${susId }">
    <input type="hidden" id="salesOrdId" name="salesOrdId" value="${salesOrdId }">
</form>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.suspendCallLogInfo" /></h2>
</aside><!-- title_line end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.title.text.suspendInfo" /></a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(callResultGridID)"><spring:message code="sal.title.text.suspendCallResult" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.orderDetails" /></a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(callLogGirdID)"><spring:message code="sal.title.text.fullCallLog" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.suspendNumber" /></th>
    <td><span>${suspensionInfo.susNo }</span></td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td><span>${suspensionInfo.susCrtDt }</span></td>
    <th scope="row"><spring:message code="sal.title.creator" /></th>
    <td><span>${suspensionInfo.susCrtUserName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.status" /></th>
    <td><span>${suspensionInfo.code }</span></td>
    <th scope="row"><spring:message code="sal.title.text.updateDate" /></th>
    <td><span>${suspensionInfo.susUpdDt }</span></td>
    <th scope="row"><spring:message code="sal.text.updator" /></th>
    <td><span>${suspensionInfo.susUpdUserName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNum" /></th>
    <td><span>${suspensionInfo.salesOrdNo }</span></td>
    <th scope="row"><spring:message code="sal.title.text.investigateNumber" /></th>
    <td><span>${suspensionInfo.invNo }</span></td>
    <th scope="row"></th>
    <td><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.suspendInchargePerson" /></h3>
</aside><!-- title_line end

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
 -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="incharge_grid_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start 

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="callResult_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->

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

</article><!-- tap_area end --><!--###################################  -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="callLog_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->



</section><!-- pop_body end -->

</div><!-- popup_wrap end -->