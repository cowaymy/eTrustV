<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myRequestFTFinalGridID;

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

//AUIGrid 칼럼 설정 : targetFinalBillGridID
var targetFinalBillColumnLayout = [
    { dataField:"procSeq" ,headerText:"Process Seq" ,editable : false , width : 120 , visible : true },
    { dataField:"appType" ,headerText:"AppType" ,editable : false , width : 120 , visible : true },
    { dataField:"advMonth" ,headerText:"AdvanceMonth" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00" , visible : true },
    { dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120, visible : true},
    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100, visible : true },
    { dataField:"ordId" ,headerText:"Order ID" ,editable : false , width : 100  , visible : true },
    { dataField:"mstRpf" ,headerText:"Master RPF" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : true },
    { dataField:"mstRpfPaid" ,headerText:"Master RPF Paid" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : true },
    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 },
    { dataField:"ordNo" ,headerText:"Order No" ,editable : false , width : 100 },
    { dataField:"billTypeId" ,headerText:"Bill TypeID" ,editable : false , width : 100 , visible : true },
    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },
    { dataField:"installment" ,headerText:"Installment" ,editable : false , width : 100 },
    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"targetAmt" ,headerText:"Target<br>Amount" ,editable : true , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100 , visible : true},
    { dataField:"assignAmt" ,headerText:"assignAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : true },
    { dataField:"billStatus" ,headerText:"billStatus" ,editable : false , width : 100 , visible : true },
    { dataField:"custNm" ,headerText:"custNm" ,editable : false , width : 300, visible : true},
    { dataField:"srvcContractID" ,headerText:"SrvcContractID" ,editable : false , width : 100 , visible : true },
    { dataField:"billAsId" ,headerText:"Bill AS Id" ,editable : false , width : 150 , visible : true },
    { dataField:"discountAmt" ,headerText:"discountAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : true },
    { dataField:"srvMemId" ,headerText:"Service Membership Id" ,editable : false , width : 150 , visible : true }
];

$(document).ready(function(){
	doGetCombo('/common/selectCodeList.do', '396' , ''   , 'newReason' , 'S', '');

	myRequestFTFinalGridID= GridCommon.createAUIGrid("grid_request_ft_wrap", targetFinalBillColumnLayout,null,gridPros);
	searchFTList();
});

// ajax list 조회.
function searchFTList(){
	Common.ajax("POST","/payment/selectFTOldData.do",$("#_ftSearchForm").serializeJSON(), function(result){
		$("#oldOrdNo").val(result.salesOrdNo);
		$("#oldCustNm").val(result.custNm);
		$("#oldAmt").val(result.totAmt);

		//AUIGrid.setGridData(myRequestFTOldGridID, result);
		//recalculateTotalAmt();
	});
}

//clear 처리
function fn_FtClear(){
	//form.reset 함수는 쓰지 않는다. groupSeq 때문임.
	$("#newRemark").val('');
	$("#newReason").val('');
	$("#newAmt").val('');
	$("#newCustNm").val('');
	$("#newOrdNo").val('');
	AUIGrid.clearGridData(myRequestFTFinalGridID);
}

//저장처리
function fn_FTRequest(){

	//Merchant Bank 체크
    if(FormUtil.checkReqValue($("#newReason option:selected"))){
        Common.alert("<spring:message code='pay.alert.noReasonSelected'/>");
        return;
    }

	if( Number($("#newAmt").val()) <= 0 ){
    	Common.alert("<spring:message code='pay.alert.totalAmtZero'/>");
    	return;
    }

	if( Number($("#oldAmt").val()) != Number($("#newAmt").val())){
    	Common.alert("<spring:message code='pay.alert.amountDifferent'/>");
    	return;
    }

	if( FormUtil.byteLength($("#newRemark").val()) > 3000 ){
    	Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
    	return;
    }

		if( FormUtil.byteLength($("#newRemark").val()) > 3000 ){
    	Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
    	return;
    }

	//저장처리
	Common.confirm("<spring:message code='pay.alert.wantToReqFundTransfer'/>",function (){

		//param data array
		var data = {};

		var gridList = AUIGrid.getGridData(targetFinalBillGridID);       //그리드 데이터
		var formList = $("#_ftSearchForm").serializeArray();       //폼 데이터

		//array에 담기
		if(gridList.length > 0) {
			data.all = gridList;
		}  else {
			Common.alert("<spring:message code='pay.alert.noPaymentData'/>");
			return;
		}

	    if(formList.length > 0) data.form = formList;
		else data.form = [];



	    Common.ajax("POST", "/payment/requestFT.do", data, function(result) {

			var message = "<spring:message code='pay.alert.ftSuccessReq' arguments='"+result.returnKey+"' htmlEscape='false'/>";

    		Common.alert(message, function(){
				searchList();
				$('#_requestFTPop').remove();
    		});
	    });
	});
}

function fn_newOrderSearchPop(){
	var appTypeId = $("#appTypeId").val();
	Common.popupDiv('/payment/common/initNewOrderSearchPop.do', {"appTypeId" : appTypeId}, null , true ,'_newOrderForFTPop');
}

function fn_newOrderSearchPopCallBack(returnGrid){
	AUIGrid.setGridData(myRequestFTFinalGridID, returnGrid);
	$('#_newOrderForFTPop').remove();
	setTargetInfo();
}

function setTargetInfo(){
	//Fund Transfer 총 금액 세팅
	var rowCnt = AUIGrid.getRowCount(myRequestFTFinalGridID);
	var totalAmt = 0;

	if(rowCnt > 0){
		$("#newOrdNo").val(AUIGrid.getCellValue(myRequestFTFinalGridID, 0 ,"ordNo"));
		$("#newCustNm").val(AUIGrid.getCellValue(myRequestFTFinalGridID, 0 ,"custNm"));

		for(var i = 0; i < rowCnt; i++){
			totalAmt += AUIGrid.getCellValue(myRequestFTFinalGridID, i ,"targetAmt");
		}
	}

	$("#newAmt").val(totalAmt.toFixed(2));
}


</script>

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Request Fund Transfer</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
		<!-- search_table start -->
		<section class="search_table">
			<form name="_ftSearchForm" id="_ftSearchForm"  method="post">
				<input id="groupSeq" name="groupSeq" value="${groupSeq}" type="hidden" />
				<input id="payId" name="payId" value="${payId}" type="hidden" />
				<input id="appTypeId" name="appTypeId" value="${appTypeId}" type="hidden" />

				<!-- title_line start -->
				<aside class="title_line">
					<h2 class="pt0">Source Information</h2>
				</aside>
				<!-- title_line end -->

				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:140px" />
						<col style="width:*" />
						<col style="width:140px" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Order No.(OLD)</th>
							<td>
								 <input type="text" name="oldOrdNo" id="oldOrdNo" title="" placeholder="" class="readonly"  readonly />
							</td>
							<th scope="row">Customer Name</th>
							<td>
								 <input type="text" name="oldCustNm" id="oldCustNm" title="" placeholder="" class="readonly"  readonly />
							</td>
						</tr>
						<tr>
							<th scope="row">Amount</th>
							<td colspan="3">
								 <input type="text" name="oldAmt" id="oldAmt" title="" placeholder="" class="readonly"  readonly  />
							</td>
						</tr>
						</tbody>
				  </table>

				<!-- title_line start -->
				<aside class="title_line">
					<h2 class="pt0">Target Information</h2>
				</aside>
				<!-- title_line end -->
				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:140px" />
						<col style="width:*" />
						<col style="width:140px" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Order No.(NEW)</th>
							<td>
								 <input type="text" name="newOrdNo" id="newOrdNo" title="" placeholder="" class="readonly" readonly />
								 <p class="btn_sky">
									<a href="javascript:fn_newOrderSearchPop();" id="search">Search</a>
								</p>
							</td>
							<th scope="row">Customer Name</th>
							<td>
								 <input type="text" name="newCustNm" id="newCustNm" title="" placeholder="" class="readonly" readonly  />
							</td>
						</tr>
						<tr>
							<th scope="row">Amount</th>
							<td colspan="3">
								 <input type="text" name="newAmt" id="newAmt" title="" placeholder="" class="readonly" readonly  />
							</td>

						</tr>
						</tbody>
				  </table>

				  <!-- title_line start -->
				<aside class="title_line">
					<h2 class="pt0">Request Information</h2>
				</aside>
				<!-- title_line end -->
				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:140px" />
						<col style="width:*" />
						<col style="width:140px" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Reason</th>
							<td colspan="3">
								<select id="newReason" name="newReason" class="w100p"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">Remark</th>
							<td colspan="3">
					            <textarea id="newRemark" name="newRemark"  cols="15" rows="2" placeholder=""></textarea>
							</td>
						</tr>
						</tbody>
				  </table>
			</form>
		</section>
		<!-- search_result start -->
		<section class="search_result" style="display:none">
			<!-- grid_wrap start -->
			<article id="grid_request_ft_wrap" class="grid_wrap"></article>
			<!-- grid_wrap end -->
		</section>
		<ul class="center_btns">
			<li><p class="btn_blue"><a href="javascript:fn_FTRequest();"><spring:message code='pay.btn.request'/></a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_FtClear();"><spring:message code='sys.btn.clear'/></a></p></li>
		</ul>
	</section>
</div>