<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myRequestRefundGridID;
var attachList = null;
var allowAppvFlg = null;
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
var oldTotalAmt = 0;
// AUIGrid 칼럼 설정
var requestDcfColumnLayout = [
	{dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGroupNo'/>",width : 100 , editable : false, visible : false},
	{dataField : "payItmModeId",headerText : "<spring:message code='pay.head.payTypeId'/>",width : 240 , editable : false, visible : false},
	{dataField : "reqId",headerText : "Request ID",width : 240 , editable : false, visible : false},
	{dataField : "appType",headerText : "<spring:message code='pay.head.appType'/>",width : 130 , editable : false},
	{dataField : "payItmModeNm",headerText : "<spring:message code='pay.head.payType'/>",width : 110 , editable : false},
	{dataField : "custId",headerText : "<spring:message code='pay.head.customerId'/>",width : 140 , editable : false},
	{dataField : "salesOrdNo",headerText : "<spring:message code='pay.head.salesOrder'/>", editable : false},
	{dataField : "totAmt",headerText : "<spring:message code='pay.head.amount'/>", width : 120 ,editable : false, dataType:"numeric", formatString : "#,##0.00" },
	{dataField : "payItmRefDt",headerText : "<spring:message code='pay.head.transactionDate'/>",width : 120 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
	{dataField : "orNo",headerText : "<spring:message code='pay.head.worNo'/>",width : 150,editable : false},
	{dataField : "brnchId",headerText : "<spring:message code='pay.head.keyInBranch'/>",width : 100,editable : false, visible : false},
	{dataField : "crcStateMappingId",headerText : "<spring:message code='pay.head.crcStateId'/>",width : 110,editable : false, visible : false},
	{dataField : "crcStateMappingDt",headerText : "<spring:message code='pay.head.crcMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "bankStateMappingId",headerText : "<spring:message code='pay.head.bankStateId'/>",width : 110,editable : false, visible : false},
	{dataField : "bankStateMappingDt",headerText : "<spring:message code='pay.head.bankMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "revStusId",headerText : "<spring:message code='pay.head.reverseStatusId'/>",width : 110,editable : false, visible : false},
	{dataField : "revStusNm",headerText : "<spring:message code='pay.head.reverseStatus'/>",width : 110,editable : false, visible : false},
	{dataField : "revDt",headerText : "<spring:message code='pay.head.reverseDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
	{dataField : "appvPrcssNo",headerText : "Approval Process No",width : 110,editable : false, visible : false} ,
	{dataField : "payId",headerText : "Pay ID",width : 110,editable : false, visible : false}
];


$(document).ready(function(){
	myRequestRefundGridID = GridCommon.createAUIGrid("grid_request_dcf_wrap", requestDcfColumnLayout,null,gridPros);
	searchRefundList();

	if(allowAppvFlg != null && allowAppvFlg == 'Y'){
		if($("#appvStus").val() == "A" || $("#appvStus").val() == "J" ){
	          $("#approvalDiv").hide();
	          $("#headerLbl").text("View Confirm Refund");
	          $("#remark").prop("disabled", true);
	          $("#remarkSec").hide();
	    }
	}
	else{
		$("#approvalDiv").hide();
        $("#headerLbl").text("View Confirm Refund");
        $("#remark").prop("disabled", true);
        $("#remarkSec").hide();
	}


});

// ajax list 조회.
function searchRefundList(){
	Common.ajaxSync("POST","/payment/selectRequestRefundByGroupSeq.do",$("#_refundSearchForm").serializeJSON(), function(result){
		AUIGrid.setGridData(myRequestRefundGridID, result);
		recalculateTotalAmt();
		searchReqRefundInfo();
 		$("#refStusId").val($("#refStusId").val()[0]);
		console.log($("#refStusId").val());
		console.log(allowAppvFlg);
	});
}

// confirm 창에서는 Request 정보 (reason / remark)를 조회하여 보여준다.
function searchReqRefundInfo(){
	console.log("searchReqRefundInfo");
	Common.ajaxSync("POST","/payment/selectReqRefundInfo.do",$("#_refundSearchForm").serializeJSON(), function(result){
		console.log(result);
		$("#refundType").val(result.reqRefundInfo.refundType);
		if(result.reqRefundInfo.newPayType == "107"){
			$("#crcSec").show();
		}
		else{
			$("#onlineSec").show();
		}
		$("#beneficiaryName").val(result.reqRefundInfo.cardHolder);
		$("#refundAmt").val(result.reqRefundInfo.newTotalAmt.toFixed(2));
		$("#bankAccNo").val(result.reqRefundInfo.bankAcc);
		$("#bankName").val(result.reqRefundInfo.issueBankName);
		$("#crcCardNo").val(result.reqRefundInfo.cardNo);
		$("#cardIssueBank").val(result.reqRefundInfo.issueBankName);
		$("#apprNo").val(result.reqRefundInfo.cardApprovalNo);
		allowAppvFlg = result.allowAppvFlg;

		attachList = result.attachList;
        console.log(attachList);
        if(attachList) {
            if(attachList.length > 0) {
                for(var i = 0; i < attachList.length; i++) {
                    /* result.data.itemGrp[i].atchFileId = attachList[i].atchFileId;
                    result.data.itemGrp[i].atchFileName = attachList[i].atchFileName;
                    var str = attachList[i].atchFileName.split(".");
                    result.data.itemGrp[i].fileExtsn = str[1];
                    result.data.itemGrp[i].fileCnt = 1; */
                    $("#attachment").val(attachList[i].atchFileName);
                }

            }
            $("#attachment").dblclick(function() {
                var oriFileName = $(this).val();
                var fileGrpId;
                var fileId;
                for(var i = 0; i < attachList.length; i++) {
                    if(attachList[i].atchFileName == oriFileName) {
                        fileGrpId = attachList[i].atchFileGrpId;
                        fileId = attachList[i].atchFileId;
                    }
                }
                fn_atchViewDown(fileGrpId, fileId);
            });
        }
		$("#requestor").val(result.reqRefundInfo.reqstUserId);
		$("#reqReason").val(result.reqRefundInfo.resnDesc);
		$("#reqDate").val(result.reqRefundInfo.refCrtDt);
		$("#reqRemark").val(result.approvalRemark);
	});
}


//Amount 계산
function recalculateTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(myRequestRefundGridID);
    var totalAmt = 0;

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            totalAmt += AUIGrid.getCellValue(myRequestRefundGridID, i ,"totAmt");
        }
    }

    //oldTotalAmt = totalAmt;
    oldTotalAmt = Math.round(totalAmt * 100) / 100;
}

//승인처리
function fn_approval(){

	console.log($("#appvStus").val());
	if($("#appvStus").val() != "1" ){
        Common.alert("Only [Approve-In-Progress] is allowed for Approval");
        return;
	}

	if(!FormUtil.isEmpty($("#remark").val())) {
		if( FormUtil.byteLength($("#remark").val()) < 1 ){
	        Common.alert("<spring:message code='pay.alert.insertRemark'/>");
	        return;
	    }

	    if( FormUtil.byteLength($("#remark").val()) > 400 ){
	        Common.alert("* Please input the Remark below or less than 400 bytes.");
	        return;
	    }
	} else {
		Common.alert("<spring:message code='pay.alert.insertRemark'/>");
		return;
	}

	if( Number($("#refundAmt").val().replace(/,/gi, "")) > Number(oldTotalAmt)){
        Common.alert("Refund Amount cannot be greater than Total Amount. Please reject this request.");
        return;
    }

	//저장처리
	Common.confirm("Are you sure you want to confirm the Refund Request ? ",function (){
		//var oldInfoGridList = AUIGrid.getItemsByValue(myRequestRefundGridID, "isActive", "isActive");
		//var oldInfoGridList = AUIGrid.getCheckedRowItems(confirmRefundGridID);
		var oldInfoGridList = AUIGrid.getItemsByValue(myRequestRefundGridID);
/* 		var appvPrcssNo = AUIGrid.getColumnDistinctValues(myRequestRefundGridID, "appvPrcssNo");
		var appvLineSeq = AUIGrid.getColumnDistinctValues(myRequestRefundGridID, "appvLineSeq");
		$("#appvPrcssNo").val(appvPrcssNo);
		$("#appvLineSeq").val(appvLineSeq); */
		console.log(oldInfoGridList);
/* 		console.log(appvPrcssNo);
		console.log(appvLineSeq); */
		var reqId = AUIGrid.getColumnDistinctValues(myRequestRefundGridID, "reqId");
		//$("#reqId").val(parseReqNo);
		console.log("display: " + $("#_refundSearchForm").serializeJSON());

	    Common.ajax("POST", "/payment/approvalRefund.do", $("#_refundSearchForm").serializeJSON(), function(result) {
	    	console.log(result);
	    	if (result.code == "00") {
	            var message = result.message;
	    	} else {
	    		var message = result.message;
	    	}
    		Common.alert(message, function(){
				searchList();
				$('#_confirmRefundPop').remove();
    		});
	    });
	});
}

//반려처리
function fn_reject(){
	console.log($("#appvStus").val());
	if($("#appvStus").val() != "1" ){
        Common.alert("<spring:message code='pay.alert.rejectOnlyActive'/>");
        return;
	}
	if(!FormUtil.isEmpty($("#remark").val())) {
		if(FormUtil.checkReqValue($("#remark"))){
	        Common.alert("<spring:message code='pay.alert.inputRemark'/>");
	        return;
	    }

	    if( FormUtil.byteLength($("#remark").val()) > 400 ){
	        Common.alert("* Please input the Remark below or less than 400 bytes.");
	        return;
	    }
	} else {
		Common.alert("<spring:message code='pay.alert.inputRemark'/>");
        return;
	}

	//저장처리
	Common.confirm("Are you sure you want to reject Refund ?",function (){
	    Common.ajax("POST", "/payment/rejectRefund.do", $("#_refundSearchForm").serializeJSON(), function(result) {
			var message = "Refund Request has successfully rejected.";

    		Common.alert(message, function(){
				searchList();
				$('#_confirmRefundPop').remove();
    		});
	    });
	});
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/payment/getAttachmentInfo1.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            // TODO View
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1 id="headerLbl">Confirm Refund</h1>
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
			<form name="_refundSearchForm" id="_refundSearchForm"  method="post">
				<input id="groupSeq" name="groupSeq" value="${groupSeq}" type="hidden" />
				<input id="reqNo" name="reqNo" value="${reqId}" type="hidden" />
				<input id="refStusId" name="refStusId" value="${refStusId}" type="hidden" />
				<input id="salesOrdNo" name="salesOrdNo" value="${salesOrdNo}" type="hidden" />
				<input id="appvStus" name="appvStus" value="${appvStus}" type="hidden" />
				<%-- <input id="reqId" name="reqId" value="${reqNo}" type="hidden" /> --%>

				<aside class="title_line"><!-- title_line start -->
				<h1 id="headerConfirmRefundLbl">Refund Information</h1>
				</aside>
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
					       <th>Refund Type</th>
					       <td colspan="3">
					           <input id="refundType" name="refundType" type="text" class="readonly w100p" readonly/>
					       </td>
					   </tr>
					   <tr>
					       <th>Refund Amount (RM)</th>
					       <td colspan="3">
					           <input id="refundAmt" name="refundAmt" type="text" class="readonly w100p" readonly/>
					       </td>
					   </tr>
					   <tbody id="onlineSec" style="display: none;">
						   <tr>
						       <th>Beneficiary Name</th>
						       <td colspan="3">
						           <input id="beneficiaryName" name="beneficiaryName" type="text" class="readonly w100p" readonly/>
						       </td>
						   </tr>
						   <tr>
						       <th>Bank Account No.</th>
						       <td colspan="3">
						           <input id="bankAccNo" name="bankAccNo" type="text" class="readonly w100p" readonly/>
						       </td>
						   </tr>
						   <tr>
						       <th>Bank Name</th>
						       <td colspan="3">
						           <input id="bankName" name="bankName" type="text" class="readonly w100p" readonly/>
						       </td>
						   </tr>
                       </tbody>
					   <tbody id="crcSec" style="display: none;">
					       <tr>
                           <th>Credit Card No.</th>
                           <td colspan="3">
                               <input id="crcCardNo" name="crcCardNo" type="text" class="readonly w100p" readonly/>
                           </td>
                       </tr>

                       <tr>
                           <th>Card Issue Bank</th>
                           <td colspan="3">
                               <input id="cardIssueBank" name="cardIssueBank" type="text" class="readonly w100p" readonly/>
                           </td>
                       </tr>
                       <tr>
                           <th>Appr No.</th>
                           <td colspan="3">
                               <input id="apprNo" name="apprNo" type="text" class="readonly w100p" readonly/>
                           </td>
                       </tr>
					   </tbody>
					   <tr>
					       <th>Reason</th>
					       <td colspan="3">
					           <input id="reqReason" name="reqReason" type="text" class="readonly w100p" readonly/>
					       </td>
					   </tr>
					   <tr>
					       <th>Attachement</th>
					       <td colspan="3">
					           <input id="attachment" name="attachment" type="text" class="readonly w100p" readonly/>
					       </td>
					   </tr>
					   <tr>
                            <th scope="row">Request Remark</th>
                            <td colspan="3">
                                <textarea id="reqRemark" name="reqRemark"  cols="15" rows="3" placeholder="" class="readonly" readonly></textarea>
                            </td>
                        </tr>
                        <tr id="remarkSec">
                            <th scope="row" id="remarkLbl">Remark<span class='must'>*</span></th>
                            <td colspan="3">
                                <textarea id="remark" name="remark"  cols="15" rows="3" placeholder="" maxlength = "400"></textarea>
                            </td>
                        </tr>
					</tbody>
					<!-- <tbody>
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
					            <textarea id="reqRemark" name="reqRemark"  cols="15" rows="3" placeholder="" class="readonly" readonly></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row" id="remarkLbl">Remark<span class='must'>*</span></th>
							<td colspan="3">
					            <textarea id="remark" name="remark"  cols="15" rows="3" placeholder=""></textarea>
							</td>
						</tr>
					</tbody> -->
				</table>
			</form>
		</section>

		<div id="approvalDiv">
		  <ul class="center_btns">
            <li><p class="btn_blue"><a href="javascript:fn_approval();"><spring:message code='pay.btn.approval'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_reject();"><spring:message code='pay.btn.reject'/></a></p></li>
          </ul>
		</div>

	</section>
</div>