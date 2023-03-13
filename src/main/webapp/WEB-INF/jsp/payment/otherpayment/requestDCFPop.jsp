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
	{dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGrpNo'/>",width : 100 , editable : false, visible : false},
	{dataField : "payItmModeId",headerText : "<spring:message code='pay.head.payTypeId'/>",width : 240 , editable : false, visible : false},
	{dataField : "appType",headerText : "<spring:message code='pay.head.appType'/>",width : 130 , editable : false},
	{dataField : "payItmModeNm",headerText : "<spring:message code='pay.head.payType'/>",width : 110 , editable : false},
	{dataField : "custId",headerText : "<spring:message code='pay.head.customerId'/>",width : 140 , editable : false},
	{dataField : "salesOrdNo",headerText : "<spring:message code='pay.head.salesOrder'/>", editable : false},
	{dataField : "totAmt",headerText : "<spring:message code='pay.head.amount'/>", width : 120 ,editable : false, dataType:"numeric", formatString : "#,##0.00" },
	{dataField : "payItmRefDt",headerText : "<spring:message code='pay.head.transDate'/>",width : 120 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
	{dataField : "orNo",headerText : "<spring:message code='pay.head.worNo'/>",width : 150,editable : false},
	{dataField : "brnchId",headerText : "<spring:message code='pay.head.keyInBranch'/>",width : 100,editable : false, visible : false},
	{dataField : "crcStateMappingId",headerText : "<spring:message code='pay.head.crcState'/>",width : 110,editable : false, visible : false},
	{dataField : "crcStateMappingDt",headerText : "<spring:message code='pay.head.crcMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "bankStateMappingId",headerText : "<spring:message code='pay.head.bankStateId'/>",width : 110,editable : false, visible : false},
	{dataField : "bankStateMappingDt",headerText : "<spring:message code='pay.head.bankMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "revStusId",headerText : "<spring:message code='pay.head.reverseStatusId'/>",width : 110,editable : false, visible : false},
	{dataField : "revStusNm",headerText : "<spring:message code='pay.head.reverseStatus'/>",width : 110,editable : false, visible : false},
	{dataField : "revDt",headerText : "<spring:message code='pay.head.reverseDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false}
];


$(document).ready(function(){
	fetch("/payment/checkDCFPopValid.do?groupSeq=${groupSeq}")
	.then(resp => resp.json())
	.then(d => {
		if (d.success) {
			doGetCombo('/common/selectCodeList.do', '392' , ''   , 'reason' , 'S', '');

			myRequestDCFGridID = GridCommon.createAUIGrid("grid_request_dcf_wrap", requestDcfColumnLayout,null,gridPros);

			searchDCFList();
		} else {
			Common.alert(d.message, () => {
				$("#popup_wrap .pop_header .right_opt .btn_blue2 a").click()
			});
		}
	})

});

// ajax list 조회.
function searchDCFList(){
	Common.ajax("POST","/payment/selectPaymentListByGroupSeq.do",$("#_dcfSearchForm").serializeJSON(), function(result){
		AUIGrid.setGridData(myRequestDCFGridID, result);
		recalculateDCFTotalAmt();
	});
}

//clear 처리
function fn_DCFClear(){
	//form.reset 함수는 쓰지 않는다. groupSeq 때문임.
	$("#reason").val('');
	$("#remark").val('');

}

//Amount 계산
function recalculateDCFTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(myRequestDCFGridID);
    var totalAmt = 0;

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            totalAmt += AUIGrid.getCellValue(myRequestDCFGridID, i ,"totAmt");
        }
    }

	$("#totalAmt").val(totalAmt);
    $("#totalAmtTxt").val($.number(totalAmt,2));
}

//저장처리
function fn_DCFRequest(){

	//Merchant Bank 체크
    if(FormUtil.checkReqValue($("#reason option:selected"))){
        Common.alert("<spring:message code='pay.alert.noReason'/>");
        return;
    }

	if( Number($("#totalAmt").val()) <= 0 ){
    	Common.alert("<spring:message code='pay.alert.amtThanZero'/>");
    	return;
    }

	if($("#remark").val() == ''){
		Common.alert("<spring:message code='pay.alert.inputRemark'/>");
    	return;
	}

	if( FormUtil.byteLength($("#remark").val()) > 3000 ){
    	Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
    	return;
    }

	//저장처리
	Common.confirm("<spring:message code='pay.alert.wantToRequestDcf'/>",function (){


	    Common.ajax("POST", "/payment/requestDCF.do", $("#_dcfSearchForm").serializeJSON(), function(result) {

	    	if (result.error) {
	    		var message = result.error;
	    	} else {
				var message = "<spring:message code='pay.alert.dcfSuccessReq' arguments='"+result.returnKey+"' htmlEscape='false'/>";
	    	}

    		Common.alert(message, function(){
				searchList();
				$('#_requestDCFPop').remove();
    		});
	    });
	});
}


</script>

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Request DCF</h1>
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
			<li><p class="btn_blue"><a href="javascript:fn_DCFRequest();"><spring:message code='pay.btn.request'/></a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_DCFClear();"><spring:message code='sys.btn.clear'/></a></p></li>
		</ul>
	</section>
</div>