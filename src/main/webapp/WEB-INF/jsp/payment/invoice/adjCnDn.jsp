<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">

var myGridID,subGridID;

//Default Combo Data
var adjStatusData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"}];

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        headerHeight : 35,
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
	//Adjustment Status 생성
    doDefCombo(adjStatusData, '' ,'status', 'S', '');
	
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	
	// 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
    	var adjId = AUIGrid.getCellValue(myGridID, event.rowIndex, 'memoAdjId');    	
    	Common.popupDiv('/payment/initAdjustmentDetailPop.do', {adjId : adjId, mode : "SEARCH"}, null , true ,'_adjustmentDetailPop');
    });
    
});

var columnLayout=[
    { dataField:"code" ,headerText:"<spring:message code='pay.head.type'/>" ,editable : false , visible : false},
    { dataField:"memoItmTxs" ,headerText:"<spring:message code='pay.head.adjustmentTaxes'/>" ,editable : false  , visible : false},
    { dataField:"memoItmChrg" ,headerText:"<spring:message code='pay.head.adjustmentCharges'/>" ,editable : false  , visible : false},
    { dataField:"memoAdjRptNo" ,headerText:"<spring:message code='pay.head.reportNo'/>" ,editable : false  , visible : false},
    { dataField:"memoAdjId" ,headerText:"<spring:message code='pay.head.adjustmentId'/>" ,editable : false  , visible : false},
    { dataField:"memoAdjRefNo" ,headerText:"<spring:message code='pay.head.cnDnNo'/>" ,editable : false },
    { dataField:"memoAdjInvcNo" ,headerText:"<spring:message code='pay.head.invoiceNo'/>" ,editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false},
    { dataField:"memoItmAmt" ,headerText:"<spring:message code='pay.head.adjustmentAmount'/>" ,editable : false },
    { dataField:"resnDesc" ,headerText:"<spring:message code='pay.head.reason'/>" ,editable : false },
    { dataField:"userName" ,headerText:"<spring:message code='pay.head.requestor'/>" ,editable : false },
    { dataField:"deptName" ,headerText:"<spring:message code='pay.head.department'/>" ,editable : false },
    { dataField:"memoAdjCrtDt" ,headerText:"<spring:message code='pay.head.requestCreateDate'/>" ,editable : false },    
    { dataField:"code1" ,headerText:"<spring:message code='pay.head.status'/>" ,editable : false },
    { dataField:"memoAdjRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false }
    ];

// 리스트 조회.
function fn_getAdjustmentListAjax() {
	
	if(FormUtil.checkReqValue($("#orderNo")) &&
			FormUtil.checkReqValue($("#invoiceNo")) &&
			FormUtil.checkReqValue($("#adjNo"))){
        Common.alert("<spring:message code='pay.alert.orderNoOrInvoiceNoOrAdjNo'/>");
        return;
    }
	
    Common.ajax("GET", "/payment/selectAdjustmentList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_cmmSearchInvoicePop(){
    Common.popupDiv('/payment/common/initCommonSearchInvoicePop.do', null, null , true ,'_searchInvoice');
}


//popup 크기
var winPopOption = {
        width : "1300px",   // 창 가로 크기
        height : "850px"    // 창 세로 크기
};

function _callBackInvoicePop(searchInvoicePopGridID,rowIndex, columnIndex, value, item){
    //location.href="/payment/initNewAdj.do?refNo=" + AUIGrid.getCellValue(searchInvoicePopGridID, rowIndex, "taxInvcRefNo");
    
    $('#_searchInvoice').hide();
    Common.popupWin("searchForm", "/payment/initNewAdj.do?refNo=" + AUIGrid.getCellValue(searchInvoicePopGridID, rowIndex, "taxInvcRefNo"), winPopOption);
}

function fn_openWinPop(val){
	if(val == 'BATCH_REQ'){
		Common.popupWin("searchForm", "/payment/initBatchAdjCnDnListPop.do", {width : "1200px", height : "550", resizable: "no", scrollbars: "no"});
	}else if(val == 'SUMMARY'){
		Common.popupWin("searchForm", "/payment/initInvAdjCnDnPop.do", {width : "1200px", height : "450", resizable: "no", scrollbars: "no"});
	}else if(val == 'APPROVAL'){
		Common.popupWin("searchForm", "/payment/initApprovalAdjCnDnListPop.do", {width : "1200px", height : "650", resizable: "no", scrollbars: "no"});
	}	
}

function fn_Clear(){
    $("#searchForm")[0].reset();
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Invoice Adjustment (CN / DN)</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_getAdjustmentListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_Clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
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
				        <th scope="row">Order No.</th>
					    <td>
					       <input id="orderNo" name="orderNo" type="text" placeholder="Order No." class="w100p" />
					    </td>
					    <th scope="row">Adjustment Status</th>
                        <td>
                            <select id="status" name="status" class="w100p"></select>
                        </td>
                    </tr>
					<tr>
					   <th scope="row">Invoice No.</th>
					   <td>
					       <input id="invoiceNo" name="invoiceNo" type="text" placeholder="Invoice No." class="w100p" />
                        </td>
					    <th scope="row">Adjustment No.</th>
                        <td>
                           <input id="adjNo" name="adjNo" type="text" placeholder="Adjustment No." class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Report No.</th>
                        <td>
                            <input id="reportNo" name="reportNo" type="text" placeholder="report No." class="w100p" />
                        </td>
					    <th scope="row">Creator</th>
					    <td>
					        <input id="creator" name="creator" type="text" placeholder="Creator" class="w100p">                               
					    </td>
					</tr>
                </tbody>
            </table>
            <!-- table end -->
            <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                        <li><p class="link_btn type2"><a href="javascript:fn_cmmSearchInvoicePop();"><spring:message code='pay.btn.link.newCnDnReq'/></a></p></li>
                        </c:if>
                        <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                        <li><p class="link_btn type2"><a href="javascript:fn_openWinPop('BATCH_REQ');"><spring:message code='pay.btn.link.newBatchReq'/></a></p></li>
                        </c:if>
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                        <li><p class="link_btn type2"><a href="javascript:fn_openWinPop('SUMMARY');"><spring:message code='pay.btn.link.genSummaryList'/></a></p></li>
                        </c:if>
                        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
                        <li><p class="link_btn type2"><a href="javascript:fn_openWinPop('APPROVAL');"><spring:message code='pay.btn.link.approval'/></a></p></li>                                                                      
                        </c:if>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">	
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>


