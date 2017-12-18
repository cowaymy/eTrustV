<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myRequestDCFGridID;


//Grid Properties 설정
	var gridPros = {
	        // 편집 가능 여부 (기본값 : false)
	        editable : false,        
	        // 상태 칼럼 사용
	        showStateColumn : false,
	        // 기본 헤더 높이 지정
	        headerHeight : 35,
	        
	        softRemoveRowMode:false
	
	};
// AUIGrid 칼럼 설정
var requestDcfColumnLayout = [ 
	{dataField : "groupSeq",headerText : "Payment<br>Group No.",width : 100 , editable : false, visible : false},
	{dataField : "payItmModeId",headerText : "Pay Type ID",width : 240 , editable : false, visible : false},
	{dataField : "appType",headerText : "App. Type",width : 130 , editable : false},
	{dataField : "payItmModeNm",headerText : "Pay Type",width : 110 , editable : false},
	{dataField : "custId",headerText : "Customer ID",width : 140 , editable : false},
	{dataField : "salesOrdNo",headerText : "Sales<br>Order", editable : false},
	{dataField : "payItmAmt",headerText : "Amount", width : 120 ,editable : false, dataType:"numeric", formatString : "#,##0.00" },
	{dataField : "payItmRefDt",headerText : "Transaction<br>Date",width : 120 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
	{dataField : "orNo",headerText : "WOR No.",width : 150,editable : false},
	{dataField : "brnchId",headerText : "Key In<br>Branch",width : 100,editable : false, visible : false},
	{dataField : "crcStateMappingId",headerText : "CRC State.<br>ID",width : 110,editable : false, visible : false},
	{dataField : "crcStateMappingDt",headerText : "CRC Mapping<br>Date",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "bankStateMappingId",headerText : "Bank State.<br>ID",width : 110,editable : false, visible : false},
	{dataField : "bankStateMappingDt",headerText : "Bank Mapping<br>Date",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "revStusId",headerText : "Reverse Status ID",width : 110,editable : false, visible : false},
	{dataField : "revStusNm",headerText : "Reverse<br>Status",width : 110,editable : false, visible : false},
	{dataField : "revDt",headerText : "Reverse<br>Date",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false}
];


$(document).ready(function(){
	myRequestDCFGridID = GridCommon.createAUIGrid("grid_request_dcf_wrap", requestDcfColumnLayout,null,gridPros);
	searchDCFList();
});

// ajax list 조회.
function searchDCFList(){
	Common.ajax("POST","/payment/selectPaymentListByGroupSeq.do",$("#_dcfSearchForm").serializeJSON(), function(result){    		
		AUIGrid.setGridData(myRequestDCFGridID, result);
	});
}

</script>   

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>View Group Payment Key-In List</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
		<!-- search_result start -->
		<section class="search_result">     
			<!-- grid_wrap start -->
			<article id="grid_request_dcf_wrap" class="grid_wrap"></article>
			<!-- grid_wrap end -->
		</section>
		
		<form name="_dcfSearchForm" id="_dcfSearchForm"  method="post">
			<input id="groupSeq" name="groupSeq" value="${groupSeq}" type="hidden" />
		</form>
	</section>
</div>
