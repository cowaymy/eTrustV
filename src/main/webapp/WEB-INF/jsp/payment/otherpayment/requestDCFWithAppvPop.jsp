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
	doGetCombo('/common/selectCodeList.do', '392' , ''   , 'reason' , 'S', '');
	
	myRequestDCFGridID = GridCommon.createAUIGrid("grid_request_dcf_wrap", requestDcfColumnLayout,null,gridPros);

	searchDCFList();
});

// ajax list 조회.
function searchDCFList(){
	Common.ajax("POST","/payment/selectPaymentListByGroupSeq.do",$("#_dcfSearchForm").serializeJSON(), function(result){    		
		AUIGrid.setGridData(myRequestDCFGridID, result);
		recalculateTotalAmt();
	});
}

//clear 처리
function fn_clear(){
	//form.reset 함수는 쓰지 않는다. groupSeq 때문임.
	$("#reason").val('');
	$("#remark").val('');

}

//Amount 계산
function recalculateTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(myRequestDCFGridID);
    var totalAmt = 0;

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            totalAmt += AUIGrid.getCellValue(myRequestDCFGridID, i ,"payItmAmt");
        }
    }

	$("#totalAmt").val(totalAmt);    
    $("#totalAmtTxt").val($.number(totalAmt,2));    
}

//저장처리
function fn_request(){

	//Merchant Bank 체크
    if(FormUtil.checkReqValue($("#reason option:selected"))){
        Common.alert('* No Reason Selected');
        return;
    }
	
	if( Number($("#totalAmt").val()) <= 0 ){
    	Common.alert('* Total amount is less than zero');
    	return;
    }	

	if( FormUtil.byteLength($("#remark").val()) > 3000 ){
    	Common.alert('* Please input the Remark below or less than 3000 bytes.');
    	return;
    }

	//저장처리
	Common.confirm('<b>Are you sure want to process Reverse ?</b>',function (){

	    
	    Common.ajax("POST", "/payment/requestDCFWithAppv.do", $("#_dcfSearchForm").serializeJSON(), function(result) {
			var message = "<b>DCF has successfully completed<br></b>";
			message += "<b>DRN No : " + result.returnKey + "</b><br>";

    		Common.alert(message, function(){
				fn_searchAdvMatchList();
				$('#_requestDCFWithAppvPop').remove();    	      
    		});        
	    });
	});
}


</script>   

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>REJECT WITH TICKET</h1>
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

		<!-- search_table start -->
		<section class="search_table">
			<form name="_dcfSearchForm" id="_dcfSearchForm"  method="post">
				<input id="groupSeq" name="groupSeq" value="${groupSeq}" type="hidden" />

				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:160px" />
						<col style="width:*" />
						<col style="width:160px" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Reason</th>
							<td>
								<select id="reason" name="reason" class="w100p"></select>
							</td>
							<th scope="row">Total Amount</th>
							<td>
								<input id="totalAmtTxt" name="totalAmtTxt" type="text" class="readonly w100p" readonly />
								<input id="totalAmt" name="totalAmt" type="hidden" class="readonly w100p" readonly />
							</td>
						</tr>
						<tr>
							<th scope="row">Remark</th>
							<td colspan="3">
					            <textarea id="remark" name="remark"  cols="15" rows="3" placeholder=""></textarea>
							</td>
						</tr>
						</tbody>
				  </table>
			</form>
		</section>

		<ul class="center_btns">
			<li><p class="btn_blue"><a href="javascript:fn_request();">Save</a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_clear();">Clear</a></p></li>
		</ul> 
	</section>
</div>