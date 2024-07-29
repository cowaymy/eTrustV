<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 그리드 객체
var myPopGridID;
var attachList = null;

//AUIGrid 칼럼 설정
var myPopLayout = [
    { dataField:"billItmType" ,headerText:"Sales Type",width: 200 , editable : false},
    { dataField:"billItmRefNo" ,headerText:"<spring:message code='pay.head.orderNumber'/>",width: 200 , editable : false},
    { dataField:"memoItmChrg" ,headerText:"<spring:message code='pay.head.amount'/>", editable : false, dataType : "numeric",formatString : "#,##0.00" ,width : 120},
    //{ dataField:"memoItmTxs" ,headerText:"<spring:message code='pay.head.gst'/>", editable : false ,dataType : "numeric",formatString : "#,##0.00" ,width : 120},
    { dataField:"memoItmTxs" ,headerText:"Tax Amount", editable : false ,dataType : "numeric",formatString : "#,##0.00" ,width : 120},
    { dataField:"memoItmAmt" ,headerText:"<spring:message code='pay.head.total'/>", editable : false, dataType : "numeric",formatString : "#,##0.00" ,width : 120}

    ];

//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){

    //Grid Properties 설정
    var gridPros = {
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false,     // 상태 칼럼 사용
            height : 200
    };

    // Order 정보 (Master Grid) 그리드 생성
    myPopGridID = GridCommon.createAUIGrid("grid_Pop_wrap", myPopLayout,null,gridPros);

    //초기화면 로딩시 조회
    selectAdjustmentDetailPop("${adjId}", "${invNo}");

    //모드에 따라 버튼 세팅
    if("${mode}" == "SEARCH"){
    	$("#centerBtn1").show();
    }else if("${mode}" == "APPROVAL"){
        $("#centerBtn2").show();
        $("#appvRemTxt").show();
    }

});

//report 조회 변수
var memoAdjId;
var invoiceType;
var miscType;
var memoStatus;
var memoAdjTypeId;
var memoInvoiceNo;
var month;
var year;
var refNo;
var genEInv;

var totalChrg = "0.00";
var totalGST = "0.00";
var totalAmt = "0.00";
//상세 팝업
function selectAdjustmentDetailPop(adjId, invNo){

	console.log('adjId:'+adjId);
	console.log('InvNo:'+invNo);
    //데이터 조회 (초기화면시 로딩시 조회)
    Common.ajax("GET", "/payment/selectAdjustmentDetailPop.do", {"adjId":adjId, "invNo":invNo}, function(result) {
        console.log(result);
        if(result != 'undefined'){

            //Master데이터 출력
            memoAdjId = result.master.memoAdjId;
            invoiceType = result.master.memoAdjInvcTypeId;
            miscType = result.master.taxInvcType;
            memoStatus = result.master.memoAdjStusId;
            memoAdjTypeId  = result.master.memoAdjTypeId;
            memoInvoiceNo = result.master.taxInvcRefNo;
            month = result.master.month;
            year = result.master.year;
            refNo = result.master.memoAdjRefNo;
            genEInv = result.master.genEInv;

            $("#tRequestor").text(result.master.memoAdjCrtUserId);
            $("#tStatus").text(result.master.memoAdjStusNm);
            $("#tDept").text(result.master.deptName);
            $("#tRefNo").text(result.master.memoAdjRefNo);
            $("#tReportNo").text(result.master.memoAdjRptNo);
            $("#tType").text(result.master.memoAdjTypeNm);
            $("#tReason").text(result.master.resnDesc);
            $("#tInvoiceNo").text(result.master.taxInvcRefNo);
            $("#tInvoiceDt").text(result.master.taxInvcRefDt);
            $("#tGrpNo").text(result.master.taxInvcGrpNo);
            $("#tOrderNo").text(result.master.ordNo);
            $("#tMemoRemark").text(result.master.memoAdjRem);
            $("#tCustNmt").text(result.master.taxInvcCustName);
            $("#tContactPerson").text(result.master.taxInvcCntcPerson);
            $("#tAddr").text(result.master.address);
            $("#tInvoiceRemark").text(result.master.taxInvcRem);
            $("#finalAppv").text(result.finalAppr);

            //Detail데이터 출력
            AUIGrid.setGridData(myPopGridID, result.detailList);

            //History 데이터 출력
            $("#history").children().remove();
            $.each( result.histlList, function(key, value) {
            	$("#history").append("<li>  "+value.memoAdjRefNo+" - " + value.adjStusName+ " on " + value.adjCrtDt+ "</li>");
            });

            $("#totalChrg").text("");
            $("#totalGST").text("");
            $("#totalAmt").text("");
            $.each( result.detailList, function(key, value) {

                totalChrg = parseFloat(totalChrg.toString()) +  parseFloat(value.memoItmChrg.toString());
                totalGST  = parseFloat(totalGST.toString()) + parseFloat(value.memoItmTxs.toString());
                totalAmt  = parseFloat(totalAmt.toString()) + parseFloat(value.memoItmAmt.toString());
            });

            $("#totalChrg").text("Total Charges: RM" + totalChrg.toFixed(2));
            $("#totalGST").text("Total Tax Amount: RM" + totalGST.toFixed(2));
            $("#totalAmt").text("Total Amount: RM" + totalAmt.toFixed(2));

            attachList = result.attachList;
            console.log(attachList);
            if(attachList) {
                if(attachList.length > 0) {
                    $("#attachTd").html("");
                    for(var i = 0; i < attachList.length; i++) {
                        //$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
                        var atchTdId = "atchId" + (i+1);
                        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                        $(".input_text[name='" + atchTdId + "']").val(attachList[i].atchFileName);
                    }

                    // 파일 다운
                    $(".input_text").dblclick(function() {
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
            }

            var appvPrcssStus;
            if(result.apprList) {
                for(var i = 0; i < result.apprList.appvPrcssStus.length; i++) {
                    if(appvPrcssStus == null) {
                        appvPrcssStus = result.apprList.appvPrcssStus[i];
                    } else {
                        appvPrcssStus += "<br />" + result.apprList.appvPrcssStus[i];
                    }
                }
                $("#viewAppvStus").html(appvPrcssStus);
            }
        }
    });

}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
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

//크리스탈 레포트
function fn_generateReport(){

	if (memoStatus != 4){
		Common.alert("<spring:message code='pay.alert.onlyComplete'/>");
        return;
	}

	if(invoiceType ==  0){
        $("#reportPDFFormOld #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF_BeforeGST.rpt');

    }

    if(invoiceType ==  126 || invoiceType == 127){
    	if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
    		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF_EIV.rpt');
    	}else{
	    	if( parseInt(year)*100 + parseInt(month) >= 201809){
	    		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF_SST.rpt');
	    	}
	    	else{
	    		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF.rpt');
	    	}
    	}
    }else{
        if( miscType == 117 ){
        	if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscHP_PDF_EIV.rpt');
        	}else{
	        	if( parseInt(year)*100 + parseInt(month) >= 201809){
	        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscHP_PDF_SST.rpt');
	            }
	            else{
	            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscHP_PDF.rpt');
	            }
        	}
        }else if(miscType == 118) {
        	if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscAS_PDF_EIV.rpt');
        	}else{
	        	if( parseInt(year)*100 + parseInt(month) >= 202403){
	                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscAS_PDF_SST_202404.rpt');
	            }
	        	else if( parseInt(year)*100 + parseInt(month) >= 201809){
	        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscAS_PDF_SST.rpt');
	            }
	            else{
	            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscAS_PDF.rpt');
	            }
        	}
        }else if(miscType == 119) {
        	if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscSRV_PDF_EIV.rpt');
            }else{
	        	if( parseInt(year)*100 + parseInt(month) >= 202403){
	                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscSRV_PDF_SST_202404.rpt');
	            }
	            else if( parseInt(year)*100 + parseInt(month) >= 201809){
	        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscSRV_PDF_SST.rpt');
	            }
	            else{
	            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscSRV_PDF.rpt');
	            }
            }
        }else if(miscType == 121) {
        	if( parseInt(year)*100 + parseInt(month) >= 201809){
        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF_SST.rpt');
            }
            else{
            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF.rpt');
            }
        }else if(miscType == 122) {
        	if( parseInt(year)*100 + parseInt(month) >= 201809){
        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF_SST.rpt');
            }
            else{
            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF.rpt');
            }
        }else if(miscType == 123) {
        	if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscWholeSales_PDF_EIV.rpt');
            }else{
	        	if( parseInt(year)*100 + parseInt(month) >= 201809){
	        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscWholeSales_PDF_SST.rpt');
	            }
	            else{
	            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscWholeSales_PDF.rpt');
	            }
            }
        }else if(miscType == 124) {
        	if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF_EIV.rpt');
        	}else{
	        	if( parseInt(year)*100 + parseInt(month) >= 201809){
	        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF_SST.rpt');
	            }
	            else{
	            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF.rpt');
	            }
        	}
        }else if(miscType == 125) {
        	if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscTermination_PDF_EIV.rpt');
        	}else{
	        	if( parseInt(year)*100 + parseInt(month) >= 201809){
	        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscTermination_PDF_SST.rpt');
	            }
	            else{
	            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscTermination_PDF.rpt');
	            }
        	}
        }else if(miscType == 142) {
        	if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF_EIV.rpt');
        	} else{
	        	if( parseInt(year)*100 + parseInt(month) >= 201809){
	        		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF_SST.rpt');
	            }
	            else{
	            	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF.rpt');
	            }
        	}
        }else if(invoiceType == 128) {

                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_ServiceCare_PDF_SST.rpt');
        }

    }

    $("#reportPDFForm #v_adjid").val(memoAdjId);
    $("#reportPDFForm #v_type").val(invoiceType);
    if(invoiceType == 0){
        $("#reportPDFFormOld #v_adjid").val(memoAdjId);
        $("#reportPDFFormOld #v_type").val(invoiceType);
        $("#reportPDFFormOld #v_refno").val(refNo);

    }

    //report 호출
    var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
    };

    if(invoiceType == 0){
        Common.report("reportPDFFormOld", option);
    }
    else{
        Common.report("reportPDFForm", option);
    }
}

/* KV-reportForDecision */
 function fn_reportForDecision()
 {
	    var date = new Date();
        var day =date.getDate();
        if(date.getDate() < 10){
         day = "0"+date.getDate();
         }
	   $("#reportPDFFormRFD #v_adjid").val(memoAdjId);
	   $("#reportPDFFormRFD #v_type").val(invoiceType);
	  /*  alert( $("#reportPDFFormRFD #v_adjid").val());
	   alert( $("#reportPDFFormRFD #v_type").val()); */
	   $("#reportPDFFormRFD #reportFileName").val('/statement/RFD_CNDN.rpt');
	   $("#reportPDFFormRFD #viewType").val("PDF");
       $("#reportPDFFormRFD #reportDownFileName").val("AdjustmentRFD_"+day+date.getMonth()+date.getFullYear());

       //report 호출
      var option = {
               isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
       };

      Common.report("reportPDFFormRFD", option);


 }

function fn_approve(process){
	if($("#appvRem").val() == "") {
		Common.alert("Approver remark cannot be empty!");
		return false;
	}

	var param = {"adjId":"${adjId}" ,
			           "process" : process,
			           "invoiceType" : invoiceType,
			           "memoAdjTypeId" : memoAdjTypeId,
			           "invoiceNo" : memoInvoiceNo,
			           "appvRem" : $("#appvRem").val()};

    Common.ajax("POST", "/payment/approvalAdjustment.do", param, function(result) {
        Common.alert("Invoice Adjustment successfully confirmed.<br />",function(){
        	fn_getAdjustmentListAjax();    //메인 페이지 조회
        	$('#_adjustmentDetailPop').remove();
        });

    });

}


</script>
<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>Credit Note / Debit Note</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>

    <!-- pop_body start -->
    <section class="pop_body">
        <aside class="title_line mt0">
            <h2>Adjustment Information</h2>
        </aside>

        <!-- table start -->
        <table class="type1">
            <caption>table</caption>
            <colgroup>
                <col style="width:180px" />
                <col style="width:*" />
                <col style="width:180px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Requestor ID</th>
                    <td id="tRequestor"></td>
                    <th scope="row">Adjustment Status</th>
                    <td id="tStatus"></td>
                </tr>
                <tr>
                    <th scope="row">Department</th>
                    <td colspan="3" id="tDept"></td>
                </tr>
                <tr>
                    <th scope="row">Adjustment Number</th>
                    <td id="tRefNo"></td>
                    <th scope="row">Report No.</th>
                    <td id="tReportNo"></td>
                </tr>
                <tr>
                    <th scope="row">Adjustment Type</th>
                    <td id="tType"></td>
                    <th scope="row">Reason</th>
                    <td id="tReason"></td>
                </tr>
                <tr>
                    <th scope="row">Invoice No</th>
                    <td id="tInvoiceNo"></td>
                    <th scope="row">Invoice Date</th>
                    <td id="tInvoiceDt"></td>
                </tr>
                <tr>
                    <th scope="row">Group No.</th>
                    <td id="tGrpNo"></td>
                    <th scope="row">Order No.</th>
                    <td id="tOrderNo"></td>
                </tr>
                <tr>
                    <th scope="row">Description</th>
                    <td colspan="3"  id="tMemoRemark"></td>
                </tr>
                <tr>
                    <th scope="row">Customer Name</th>
                    <td colspan="3"  id="tCustNmt"></td>
                </tr>
                <tr>
                    <th scope="row">Address</th>
                    <td colspan="3"  id="tAddr"></td>
                </tr>
                <tr>
                    <th scope="row">Approval Status</th>
                    <!-- <td colspan="3" style="height:60px" id="viewAppvStus"></td> -->
                    <td colspan="3" style="height:60px">
                        <div class="w100p"><!-- tran_list start -->
                            <ul id="viewAppvStus">
                            </ul>
                        </div><!-- tran_list end -->
                    </td>
                </tr>
                <tr>
                    <th scope="row">Final Approver</th>
                    <td colspan="3"  id="finalAppv"></td>
                </tr>
                <tr>
				    <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
				    <td colspan="3" id="attachTd">
				        <div class="auto_file2 auto_file3"><!-- auto_file start -->
				            <input type="file" title="file add" />
				        </div><!-- auto_file end -->
				    </td>
				</tr>
				<tr id="appvRemTxt" style="display: none">
                    <th scope="row">Approver Comment</th>
                    <td colspan="3"><textarea class="w100p" rows="2" style="height:auto" id="appvRem" name="appvRem"></textarea></td>
                </tr>
            </tbody>
        </table><!-- table end -->

        <aside class="title_line">
            <h2>Item(s) Information</h2>
        </aside>
        <article id="grid_Pop_wrap" class="grid_wrap"></article>

        <section class="history-info">
            <div class="tran_list fl_none w100p"><!-- tran_list start -->
	            <table>
		            <tr>
		                <th colspan="2"></th>
			            <th  id="totalChrg"></th>
			            <th id="totalGST"></th>
			            <th id="totalAmt"></th>
		            </tr>
	            </table>
            </div><!-- tran_list end -->
        </section>

        <aside class="title_line">
            <h2>History Information</h2>
        </aside>

        <section class="history-info">
            <div class="tran_list fl_none w100p"><!-- tran_list start -->
                <ul id="history">
                </ul>
            </div><!-- tran_list end -->
        </section>

        <ul class="center_btns mt20" id="centerBtn1" style="display: none">
            <li><p class="btn_blue2"><a href="javascript:fn_generateReport();"><spring:message code='pay.btn.generateCnDn'/></a></p></li>
            <!-- By KV -reportForDecision-->
            <li><p class="btn_blue2"><a href="javascript:fn_reportForDecision();"><spring:message code='pay.btn.reportForDecision'/></a></p></li>
        </ul>
        <ul class="center_btns mt20" id="centerBtn2" style="display: none">
            <li><p class="btn_blue2"><a href="javascript:fn_approve('APPROVE');"><spring:message code='pay.btn.approve'/></a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_approve('REJECT');"><spring:message code='pay.btn.reject'/></a></p></li>
        </ul>
    </section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_adjid" name="v_adjid" />
    <input type="hidden" id="v_type" name="v_type" />
</form>

<form name="reportPDFFormOld" id="reportPDFFormOld"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_adjid" name="v_adjid" />
    <input type="hidden" id="v_type" name="v_type" />
    <input type="hidden" id="v_refno" name="v_refno" />
</form>

<form name="reportPDFFormRFD" id="reportPDFFormRFD"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_adjid" name="v_adjid" />
    <input type="hidden" id="v_type" name="v_type" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
</form>


