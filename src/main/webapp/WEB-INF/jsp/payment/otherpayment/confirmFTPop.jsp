<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function(){
	doGetCombo('/common/selectCodeList.do', '396' , ''   , 'newReason' , 'S', '');
	searchFTList();
});

// ajax list 조회.
function searchFTList(){
	Common.ajax("POST","/payment/selectReqFTInfo.do",$("#_ftSearchForm").serializeJSON(), function(result){    		

		$("#oldOrdNo").text(result.srcOrdNo);
		$("#oldCustNm").text(result.srcCustName);
		$("#oldAmt").text(result.srcAmt);
		$("#newOrdNo").text(result.ftOrdNo);
		$("#newCustNm").text(result.ftCustName);
		$("#newAmt").text(result.ftAmt);
		$("#newReason").val(result.ftResn);    
		$("#newRemark").val(result.ftRem);  
		$("#newRequestor").text(result.ftCrtUserNm);    
		$("#newRequestDt").text(result.ftCrtDt);    
	});
}

//승인처리
function fn_approval(){

	if($("#ftStusId").val() != 1 ){
        Common.alert("<spring:message code='pay.alert.onlyActiveReqApproval'/>");   
        return;
	}

	if( FormUtil.byteLength($("#appvRemark").val()) > 3000 ){
		Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
    	return;
    }

	//저장처리
	Common.confirm("<spring:message code='pay.alert.wantToReqFundTransfer'/>",function (){

	    
	    Common.ajax("POST", "/payment/approvalFT.do", $("#_ftSearchForm").serializeJSON(), function(result) {
			var message = "<spring:message code='pay.alert.fundTransSuccess'/>";

    		Common.alert(message, function(){
				searchList();
				$('#_confirmFTPop').remove();    	      
    		});        
	    });
	});
}

//반려처리
function fn_reject(){
	if($("#ftStusId").val() != 1 ){
        Common.alert("<spring:message code='pay.alert.onlyActiveReqReject'/>");   
        return;
	}

    if(FormUtil.checkReqValue($("#appvRemark"))){
    	Common.alert("<spring:message code='pay.alert.inputRemark'/>");
        return;
    }

	if( FormUtil.byteLength($("#appvRemark").val()) > 3000 ){
		Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
    	return;
    }

	//저장처리
	Common.confirm("<spring:message code='pay.alert.wanstToRejectFundTrans'/>",function (){
	    Common.ajax("POST", "/payment/rejectFT.do", $("#_ftSearchForm").serializeJSON(), function(result) {
			var message = "<spring:message code='pay.alert.fundTransSuccessReject'/>";

    		Common.alert(message, function(){
				searchList();
				$('#_confirmFTPop').remove();    	      
    		});        
	    });
	});
}


</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Confirm Fund Transfer</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
		</ul>
	</header><!-- pop_header end -->

	<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
		<!-- search_table start -->
		<section class="search_table">
			<form name="_ftSearchForm" id="_ftSearchForm"  method="post">
				<input id="ftReqId" name="ftReqId" value="${ftReqId}" type="hidden" />
				<input id="ftStusId" name="ftStusId" value="${ftStusId}" type="hidden" />

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
							<td id="oldOrdNo">
							</td>
							<th scope="row">Customer Name</th>
							<td id="oldCustNm">
							</td>
						</tr>
						<tr>
							<th scope="row">Amount</th>
							<td colspan="3" id="oldAmt">
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
							<td id="newOrdNo">
							</td>
							<th scope="row">Customer Name</th>
							<td id="newCustNm">
							</td>
						</tr>
						<tr>
							<th scope="row">Amount</th>
							<td colspan="3" id="newAmt">
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
							<th scope="row">Requestor</th>
							<td id="newRequestor">
							</td>
							<th scope="row">Reason</th>
							<td>
								<select id="newReason" name="newReason" class="w100p" disabled></select>
							</td>
						</tr>						
						<tr>
							<th scope="row">Request Date</th>
							<td id="newRequestDt" colspan="3">
							</td>

						</tr>
						<tr>
							<th scope="row">Request Remark</th>
							<td colspan="3">
								<textarea id="newRemark" name="newRemark"  cols="15" rows="2" placeholder="" class="readonly" readonly ></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">Remark</th>
							<td colspan="3">
								<textarea id="appvRemark" name="appvRemark"  cols="15" rows="2" placeholder="" ></textarea>
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