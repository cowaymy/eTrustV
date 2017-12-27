<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

var myGridID;

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        headerHeight : 35,
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	
	// 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        var adjId = AUIGrid.getCellValue(myGridID, event.rowIndex, 'memoAdjId');
        var batchId = AUIGrid.getCellValue(myGridID, event.rowIndex, 'batchId');
        
        if(batchId == 0){
        	Common.popupDiv('/payment/initAdjustmentDetailPop.do', {adjId : adjId, mode : "APPROVAL"}, null , true ,'_adjustmentDetailPop');
        }else{
        	Common.popupDiv('/payment/initApprovalBatchPop.do', {batchId : batchId}, null , true ,'_approvalBatchPop');
        }
         
    });
    
});

var columnLayout=[
    { dataField:"code" ,headerText:"<spring:message code='pay.head.type'/>" ,editable : false , visible : false},
    { dataField:"memoItmTxs" ,headerText:"<spring:message code='pay.head.adjustmentTaxes'/>" ,editable : false  , visible : false},
    { dataField:"memoItmChrg" ,headerText:"<spring:message code='pay.head.adjustmentCharges'/>" ,editable : false  , visible : false},
    { dataField:"memoAdjRptNo" ,headerText:"<spring:message code='pay.head.reportNo'/>" ,editable : false  , visible : false},
    { dataField:"memoAdjId" ,headerText:"<spring:message code='pay.head.adjustmentId'/>" ,editable : false  , visible : false},
    
    { dataField:"batchId" ,headerText:"<spring:message code='pay.head.batchId'/>" ,editable : false },
    { dataField:"memoAdjRefNo" ,headerText:"<spring:message code='pay.head.cnDnNo'/>" ,editable : false },
    { dataField:"memoAdjInvcNo" ,headerText:"<spring:message code='pay.head.invoiceNo'/>" ,editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false},
    { dataField:"memoItmAmt" ,headerText:"<spring:message code='pay.head.adjustmentAmount'/>" ,editable : false },
    { dataField:"resnDesc" ,headerText:"<spring:message code='pay.head.reason'/>" ,editable : false },
    { dataField:"userName" ,headerText:"<spring:message code='pay.head.requestor'/>" ,editable : false },
    { dataField:"deptName" ,headerText:"<spring:message code='pay.head.department'/>" ,editable : false },
    { dataField:"memoAdjCrtDt" ,headerText:"<spring:message code='pay.head.requestCreateDate'/>" ,editable : false },
    { dataField:"memoAdjRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false }
    ];

// 리스트 조회.
function fn_getAdjustmentListAjax() {
    
    if(FormUtil.checkReqValue($("#orderNo")) &&
            FormUtil.checkReqValue($("#invoiceNo")) &&
            FormUtil.checkReqValue($("#batchId")) &&
            FormUtil.checkReqValue($("#adjNo"))){
        Common.alert("<spring:message code='pay.alert.oneEntry'/>");
        return;
    }
    
    Common.ajax("GET", "/payment/selectAdjustmentList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

</script>
  
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Approval Adjustment (CN / DN)</h1>
		<ul class="right_opt">
			<li><p class="btn_blue"><a href="javascript:fn_getAdjustmentListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
		</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->
		<form name="searchForm" id="searchForm"  method="post">
            <input type="hidden" name="status" id="status" value="1" />
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
                        <th scope="row">Batch ID</th>
                        <td>
                           <input id="batchId" name="batchId" type="text" placeholder="Batch ID" class="w100p" />
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
                </tbody>
            </table>
            <!-- table end -->
        </form>

		<!-- grid_wrap start -->
		<article id="grid_wrap" class="grid_wrap"></article>
		<!-- grid_wrap end -->
	</section>	
</div>