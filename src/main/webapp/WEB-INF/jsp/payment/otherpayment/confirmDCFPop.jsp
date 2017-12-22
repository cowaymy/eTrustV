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
	{dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGroupNo'/>",width : 100 , editable : false, visible : false},
	{dataField : "payItmModeId",headerText : "<spring:message code='pay.head.payTypeId'/>",width : 240 , editable : false, visible : false},
	{dataField : "appType",headerText : "<spring:message code='pay.head.appType'/>",width : 130 , editable : false},
	{dataField : "payItmModeNm",headerText : "<spring:message code='pay.head.payType'/>",width : 110 , editable : false},
	{dataField : "custId",headerText : "<spring:message code='pay.head.customerId'/>",width : 140 , editable : false},
	{dataField : "salesOrdNo",headerText : "<spring:message code='pay.head.salesOrder'/>", editable : false},
	{dataField : "payItmAmt",headerText : "<spring:message code='pay.head.amount'/>", width : 120 ,editable : false, dataType:"numeric", formatString : "#,##0.00" },
	{dataField : "payItmRefDt",headerText : "<spring:message code='pay.head.transactionDate'/>",width : 120 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
	{dataField : "orNo",headerText : "<spring:message code='pay.head.worNo'/>",width : 150,editable : false},
	{dataField : "brnchId",headerText : "<spring:message code='pay.head.keyInBranch'/>",width : 100,editable : false, visible : false},
	{dataField : "crcStateMappingId",headerText : "<spring:message code='pay.head.crcStateId'/>",width : 110,editable : false, visible : false},
	{dataField : "crcStateMappingDt",headerText : "<spring:message code='pay.head.crcMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "bankStateMappingId",headerText : "<spring:message code='pay.head.bankStateId'/>",width : 110,editable : false, visible : false},
	{dataField : "bankStateMappingDt",headerText : "<spring:message code='pay.head.bankMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "revStusId",headerText : "<spring:message code='pay.head.reverseStatusId'/>",width : 110,editable : false, visible : false},
	{dataField : "revStusNm",headerText : "<spring:message code='pay.head.reverseStatus'/>",width : 110,editable : false, visible : false},
	{dataField : "revDt",headerText : "<spring:message code='pay.head.reverseDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false}
];


$(document).ready(function(){
	
	myRequestDCFGridID = GridCommon.createAUIGrid("grid_request_dcf_wrap", requestDcfColumnLayout,null,gridPros);
	searchDCFList();
});

// ajax list 조회.
function searchDCFList(){
	Common.ajax("POST","/payment/selectPaymentListByGroupSeq.do",$("#_dcfSearchForm").serializeJSON(), function(result){    		
		AUIGrid.setGridData(myRequestDCFGridID, result);
		recalculateTotalAmt();
		searchReqDCFInfo();
	});
}

// confirm 창에서는 Request 정보 (reason / remark)를 조회하여 보여준다.
function searchReqDCFInfo(){
	Common.ajax("POST","/payment/selectReqDcfInfo.do",$("#_dcfSearchForm").serializeJSON(), function(result){    		
		$("#requestor").val(result.dcfCrtUserNm);
		$("#reqReason").val(result.dcfResnCode);    
		$("#reqDate").val(result.dcfCrtDt);  
		$("#ReqRemark").val(result.dcfRem);    
	});
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

//승인처리
function fn_approval(){

	if($("#dcfStusId").val() != 1 ){
        Common.alert("<b>Only [Active] Request is allowed to Approval.</b>");   
        return;
	}

	if( FormUtil.byteLength($("#remark").val()) > 3000 ){
    	Common.alert('* Please input the Remark below or less than 3000 bytes.');
    	return;
    }

	//저장처리
	Common.confirm('<b>Are you sure want to confirm DCF ?</b>',function (){

	    
	    Common.ajax("POST", "/payment/approvalDCF.do", $("#_dcfSearchForm").serializeJSON(), function(result) {
			var message = "<b>DCF has successfully approval<br></b>";

    		Common.alert(message, function(){
				searchList();
				$('#_confirmDCFPop').remove();    	      
    		});        
	    });
	});
}

//반려처리
function fn_reject(){
	if($("#dcfStusId").val() != 1 ){
        Common.alert("<b>Only [Active] Request is allowed to Reject.</b>");   
        return;
	}

    if(FormUtil.checkReqValue($("#remark"))){
        Common.alert('* Please input the Remark');
        return;
    }

	if( FormUtil.byteLength($("#remark").val()) > 3000 ){
    	Common.alert('* Please input the Remark below or less than 3000 bytes.');
    	return;
    }

	//저장처리
	Common.confirm('<b>Are you sure want to reject DCF ?</b>',function (){
	    Common.ajax("POST", "/payment/rejectDCF.do", $("#_dcfSearchForm").serializeJSON(), function(result) {
			var message = "<b>DCF has successfully reject<br></b>";

    		Common.alert(message, function(){
				searchList();
				$('#_confirmDCFPop').remove();    	      
    		});        
	    });
	});
}


</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Confirm DCF</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
		<!-- grid_wrap start -->
	    <article class="grid_wrap">
	        <div id="grid_request_dcf_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
	    </article>
	    <!-- grid_wrap end -->

		<!-- search_table start -->
		<section class="search_table">
			<form name="_dcfSearchForm" id="_dcfSearchForm"  method="post">
				<input id="groupSeq" name="groupSeq" value="${groupSeq}" type="hidden" />
				<input id="reqNo" name="reqNo" value="${reqNo}" type="hidden" />
				<input id="dcfStusId" name="dcfStusId" value="${dcfStusId}" type="hidden" />

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
							<th scope="row">Requestor</th>
							<td>
								<input id="requestor" name="requestor" type="text" class="readonly" readonly />
							</td>
							<th scope="row">Request Date</th>
							<td>
								<input id="reqDate" name="reqDate" type="text" class="readonly" readonly />
							</td>
						</tr>

						<tr>
							<th scope="row">Request Reason</th>
							<td>
								<input id="reqReason" name="reqReason" type="text" class="readonly" readonly />
							</td>
							<th scope="row">Total Amount</th>
							<td>
								<input id="totalAmtTxt" name="totalAmtTxt" type="text" class="readonly" readonly />
								<input id="totalAmt" name="totalAmt" type="hidden" class="readonly" readonly />
							</td>
						</tr>
						<tr>
							<th scope="row">Request Remark</th>
							<td colspan="3">
					            <textarea id="ReqRemark" name="ReqRemark"  cols="15" rows="3" placeholder="" class="readonly" readonly></textarea>
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
			<li><p class="btn_blue"><a href="javascript:fn_approval();"><spring:message code='pay.btn.approval'/></a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_reject();"><spring:message code='pay.btn.reject'/></a></p></li>
		</ul> 
	</section>
</div>