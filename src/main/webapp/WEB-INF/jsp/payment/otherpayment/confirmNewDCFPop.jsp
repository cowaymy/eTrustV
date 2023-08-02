<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myRequestDCFGridID;

var myRequestNewDCFGridID;

// var groupSeqList = [];
// var reqNo;
// var dcfStus;

var issueBank;
var merchantBank;
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
// AUIGrid 칼럼 설정
var requestDcfColumnLayout = [
    {dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGroupNo'/>",width : 100 , editable : false, visible : false},
    {dataField : "payItmModeId",headerText : "<spring:message code='pay.head.payTypeId'/>",width : 240 , editable : false, visible : false},
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
    {dataField : "revDt",headerText : "<spring:message code='pay.head.reverseDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false}
];

var requestNewDcfColumnLayout = [
    { dataField:"seq", headerText : 'No.', dataType: "numeric"},
//     { dataField:"procSeq" ,headerText:"Process Seq" ,editable : false , width : 120 , visible : false },
    { dataField:"appType" ,headerText:"AppType" ,editable : false , width : 120 , visible : false },
    { dataField:"advMonth" ,headerText:"AdvanceMonth" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120, visible : false},
    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100, visible : false },
    { dataField:"salesOrdId" ,headerText:"Order ID" ,editable : false , width : 100  , visible : false },
    { dataField:"rpf" ,headerText:"Master RPF" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"rpfPaid" ,headerText:"Master RPF Paid" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 , visible : false},
    { dataField:"salesOrdNo" ,headerText:"Order No" ,editable : false , width : 100 },
    { dataField:"billType" ,headerText:"Bill TypeID" ,editable : false , width : 100 , visible : false },
    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },
    { dataField:"instlmt" ,headerText:"Installment" ,editable : false , width : 100, visible : false },
    { dataField:"amt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00", visible : false},
    { dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00", visible : false},
    { dataField:"targetAmt" ,headerText:"Target<br>Amount" ,editable : true , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100 , visible : false},
    { dataField:"asignAmt" ,headerText:"assignAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"billStus" ,headerText:"billStatus" ,editable : false , width : 100 , visible : false },
    { dataField:"custNm" ,headerText:"custNm" ,editable : false , width : 300, visible : false},
    { dataField:"srvcLdgrCntrctId" ,headerText:"SrvcContractID" ,editable : false , width : 100 , visible : false },
    { dataField:"billAsId" ,headerText:"Bill AS Id" ,editable : false , width : 150 , visible : false },
    { dataField:"dscntAmt" ,headerText:"discountAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"srvMemId" ,headerText:"Service Membership Id" ,editable : false , width : 150 , visible : false },
    { dataField:"refDetails" ,headerText:"Ref Details/JomPay Ref" ,editable : false , width : 150 },
    { dataField:"trNo" ,headerText:"TR No" ,editable : true , width : 150 },
    { dataField:"trIssueDt" ,headerText:"TR Issue Date" ,editable : false , width : 150 },
//     { dataField:"collectorCode" ,headerText:"Collector Code" ,editable : false , width : 250 },
    { dataField:"collMemId" ,headerText:"Collector Id" ,editable : false , width : 150 ,visible : false},
    { dataField:"allowComm" ,headerText:"Commission" ,editable : false , width : 150},
];

$(document).ready(function(){

    myRequestDCFGridID = GridCommon.createAUIGrid("grid_request_dcf_wrap", requestDcfColumnLayout,null,gridPros);
    myRequestNewDCFGridID = GridCommon.createAUIGrid("grid_request_new_dcf_wrap", requestNewDcfColumnLayout,null,gridPros);

    doGetCombo('/common/selectCodeList.do', '36','', 'payType', 'S', '');
    doGetCombo('/common/getAccountList.do', 'CASH','', 'cashBankAcc', 'S', '');
    doGetCombo('/common/getAccountList.do', 'CHQ','', 'chequeBankAcc', 'S', '' );
    doGetCombo('/common/getAccountList.do', 'ONLINE','', 'onlineBankAcc', 'S', '' );
    doGetCombo('/common/selectCodeList.do', '115','', 'creditCardType', 'S', '');
    doGetCombo('/common/selectCodeList.do', '130' , ''   ,'creditCardMode', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '21' , '', 'creditCardBrand' , 'S', '');

    searchDCFList();
});

// ajax list 조회.
function searchDCFList(){

    Common.ajax("POST","/payment/selectRequestDCFByGroupSeq.do", {groupSeq : $("#groupSeq").val()}, function(result){
        AUIGrid.setGridData(myRequestDCFGridID, result);
        recalculateTotalAmt();
        searchReqDCFNewInfo();
    });
}

function searchReqDCFNewInfo(){

    Common.ajax("POST","/payment/selectReqDcfNewInfo.do", {reqNo : $("#dcfReqNo").val()}, function(result){
        $("#requestor").val(result.dcfCrtUserNm);
        $("#reqReason").val(result.dcfResnCode);
        $("#reqDate").val(result.reqstDt);
        $("#ReqRemark").val(result.remark);

        $("#rekeyInStus").val(result.rekeyInStus);

        $("#attachTd").html("");
        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' id='atchImg' name='1'/></div>");
        $("#atchImg[name='1']").val(result.atchFileName);

        allowAppvFlg = result.allowAppvFlg;

        if(result.atchFileGrpId != null && result.atchFileId != null){
	        $("#atchImg").dblclick(function() {
	            var oriFileName = $(this).val();

	            var data = {
	                    atchFileGrpId : result.atchFileGrpId,
	                    atchFileId : result.atchFileId
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
	        });
        }

        if(result.rekeyInStus == "NO"){
        	$("#newOrderInfoSection").hide();
        	$("#paymentInfoSection").hide();
        }else{

        	Common.ajax("POST","/payment/selectRequestNewDCFByGroupSeq.do", {reqNo: $("#dcfReqNo").val()}, function(result){
        		AUIGrid.setGridData(myRequestNewDCFGridID, result);
        	});

            $("#newOrderInfoSection").show();
            $("#paymentInfoSection").show();

            $("#payType").val(result.newPayType);
            $("#newTotalAmtTxt").val(result.newTotalAmt.toFixed(2));

            if(result.newPayType == "105"){
            	$("#cashPayInfo").show();

            	$("#cashTotalAmtTxt").val(result.newTotalAmt.toFixed(2));
            	$("#cashBankType").val(result.bankType);
            	$("#cashBankAcc").val(result.bankAccId);
            	$("#cashVAAcc").val(result.vaAcc);
            	$("#cashTrxDate").val(result.trxDt);
            	$("#cashSlipNo").val(result.slipNo);
            	$("#cashTrxId").val(result.trxId);

            }else if(result.newPayType == "106"){
            	$("#chequePayInfo").show();

                $("#chequeTotalAmtTxt").val(result.newTotalAmt.toFixed(2));
                $("#chequeBankType").val(result.bankType);
                $("#chequeBankAcc").val(result.bankAccId);
                $("#chequeVAAcc").val(result.vaAcc);
                $("#chequeTrxDate").val(result.trxDt);
                $("#chequeSlipNo").val(result.chqNo);
                $("#chequeTrxId").val(result.trxId);

            }else if(result.newPayType == "107"){

            	var cardModeVal = result.cardMode;
            	issueBank = result.issueBank;
            	merchantBank = result.merchantBank;

                if(cardModeVal == 2710){
                    //IssuedBank 생성 : PBB, HLB, MBB, AMBank, HSBC, SCB, UOB
                    doGetCombo('/common/getIssuedBankList.do', 'CRC2710' , ''   , 'creditIssueBank' , 'S', 'f_deptmultiCombo');

                    //Merchant Bank 생성 : CIMB, PBB, HLB, MBB, AM BANK, HSBC, SCB, UOB
                    doGetCombo('/common/getAccountList.do', 'CRC2710' , ''   , 'creditMerchantBank' , 'S', 'f_deptmultiCombo');

                }else if(cardModeVal == 2712){      //MPOS IPP
                  //IssuedBank 생성 : PBB, HLB, MBB, AMBank, HSBC, SCB, UOB
                    doGetCombo('/common/getIssuedBankList.do', 'CRC2712' , ''   , 'creditIssueBank' , 'S', 'f_deptmultiCombo');

                    //Merchant Bank 생성 : CIMB, PBB, HLB, MBB, AM BANK, HSBC, SCB, UOB
                    doGetCombo('/common/getAccountList.do', 'CRC2712' , ''   , 'creditMerchantBank' , 'S', 'f_deptmultiCombo');
                }else{
                    //IssuedBank 생성 : ALL
                    doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'creditIssueBank' , 'S', 'f_deptmultiCombo');

                    //Merchant Bank 생성
                    if(cardModeVal == 2708){      //POS
                        doGetCombo('/common/getAccountList.do', 'CRC2708' , ''   , 'creditMerchantBank' , 'S', 'f_deptmultiCombo');
                    }else if(cardModeVal == 2709){      //MOTO
                        doGetCombo('/common/getAccountList.do', 'CRC2709' , ''   , 'creditMerchantBank' , 'S', 'f_deptmultiCombo');
                    }else if(cardModeVal == 2711){      //MPOS
                        doGetCombo('/common/getAccountList.do', 'CRC2711' , ''   , 'creditMerchantBank' , 'S', 'f_deptmultiCombo');
                    }
                }

                var tenureTypeData = [];
                var tenureTypeData1 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "24","codeName": "24 Months"}];
                var tenureTypeData2 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"},{"codeId": "36","codeName": "36 Months"}];
                var tenureTypeData3 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"}];
                var tenureTypeData4 = [{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"}];
                var tenureTypeData5 = [{"codeId": "12","codeName": "12 Months"},{"codeId": "24","codeName": "24 Months"}];

                var creditMerBank = result.merchantBank;

                if(creditMerBank == 102 || creditMerBank == 104){        //HSBC OR CIMB
                  doDefCombo(tenureTypeData1, '' ,'creditTenure', 'S', '');
                }else if(creditMerBank == 100 || creditMerBank == 106 || creditMerBank == 553 || creditMerBank == 871){        // MBB OR AMB OR UOB
                      doDefCombo(tenureTypeData2, '' ,'creditTenure', 'S', '');
                  }else if(creditMerBank == 105){        //HLB
                      doDefCombo(tenureTypeData3, '' ,'creditTenure', 'S', '');
                  }else if(creditMerBank == 107 ){        //PBB
                      doDefCombo(tenureTypeData4, '' ,'creditTenure', 'S', '');
                  }else if(creditMerBank == 563){        //SCB
                      doDefCombo(tenureTypeData5, '' ,'creditTenure', 'S', '');
                  }else {        //OTHER
                      doDefCombo(tenureTypeData, '' ,'creditTenure', 'S', '');
                  }

            	$("#creditPayInfo").show();

            	$("#creditCardType").val(result.cardType);
            	$("#creditTotalAmtTxt").val(result.newTotalAmt.toFixed(2));
            	$("#creditCardMode").val(result.cardMode);
            	$("#creditCardBrand").val(result.cardBrand);
            	$("#creditCardNo").val(result.cardNo);
            	$("#creditApprNo").val(result.cardApprovalNo);
            	$("#creditIssueBank").val(result.issueBank);
            	$("#creditCardHolderName").val(result.cardHolder);
            	$("#creditExpDt").val(result.expDt);
            	$("#creditMerchantBank").val(result.merchantBank);
            	$("#creditTrxDate").val(result.trxDt);
            	$("#creditTenure").val(result.tenure);

            }else if(result.newPayType == "108"){
            	$("#onlinePayInfo").show();

                $("#onlineTotalAmtTxt").val(result.newTotalAmt.toFixed(2));
                $("#onlineVAAcc").val(result.vaAcc);
                $("#onlineBankType").val(result.bankType);
                $("#onlineBankAcc").val(result.bankAccId);
                $("#onlineTrxDate").val(result.trxDt);
                $("#onlineEFT").val(result.eft);
                $("#onlineTrxId").val(result.trxId);
                $("#onlineBankChgAmt").val(result.bankChrgAmt);

            }
        }

          if(allowAppvFlg != null && allowAppvFlg == 'Y'){
              if($("#dcfStusId").val() == "A" || $("#dcfStusId").val() == "J" ){
                     $("#btn_appv").hide();
                     $("#btn_reject").hide();
                     $("#headerLbl").text("View Confirm DCF");
                     $("#remark").prop("disabled", true);
                     $("#remField").hide();
               }
           }
           else{
               $("#btn_appv").hide();
               $("#btn_reject").hide();
               $("#headerLbl").text("View Confirm DCF");
               $("#remark").prop("disabled", true);
               $("#remField").hide();
           }
    });
}

function f_deptmultiCombo(){
    $("#creditIssueBank").val(issueBank);
    $("#creditMerchantBank").val(merchantBank);

}

//Amount 계산
function recalculateTotalAmt(){
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

//승인처리
function fn_approval(){

    if($("#dcfStusId").val() != "P" ){
        Common.alert("<spring:message code='pay.alert.approvalOnlyActive'/>");
        return;
    }

    if(!FormUtil.isEmpty($("#remark").val())) {
        if( FormUtil.byteLength($("#remark").val()) < 1 ){
            Common.alert("<spring:message code='pay.alert.insertRemark'/>");
            return;
        }

        if( FormUtil.byteLength($("#remark").val()) > 3000 ){
            Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
            return;
        }
    } else {
        Common.alert("<spring:message code='pay.alert.insertRemark'/>");
        return;
    }

    //저장처리
    var appvData  = {
        remark : $("#remark").val(),
        reqNo : $("#dcfReqNo").val(),
        groupSeq : $("#groupSeq").val()
    };

    Common.confirm("<spring:message code='pay.alert.confirmDcf'/>",function (){
        Common.ajax("POST", "/payment/approvalNewDCF.do", appvData, function(result) {

            if(result.message != null){
                 var message = result.message;
            }else{
                 var message = "DCF has fail to approval due to payment has been reversed\nKindly reject it."
            }

            Common.alert(message, function(){
                searchList();
                $('#_confirmNewDCFPop').remove();
            });
        });
    });
}

//반려처리
function fn_reject(){

    if($("#dcfStusId").val() != "P" ){
        Common.alert("<spring:message code='pay.alert.rejectOnlyActive'/>");
        return;
    }
    if(!FormUtil.isEmpty($("#remark").val())) {
        if(FormUtil.checkReqValue($("#remark"))){
            Common.alert("<spring:message code='pay.alert.inputRemark'/>");
            return;
        }

        if( FormUtil.byteLength($("#remark").val()) > 3000 ){
            Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
            return;
        }
    } else {
        Common.alert("<spring:message code='pay.alert.inputRemark'/>");
        return;
    }

    //저장처리
    var rejectData  = {
    		remark : $("#remark").val(),
    		reqNo : $("#dcfReqNo").val()
    };

    Common.confirm("<spring:message code='pay.alert.wantToRejectDcf'/>",function (){
        Common.ajax("POST", "/payment/rejectNewDCF.do", rejectData, function(result) {
            var message = "<spring:message code='pay.alert.dcfSuccessReject'/>";

            Common.alert(message, function(){
                searchList();
                $('#_confirmNewDCFPop').remove();
            });
        });
    });
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1 id="headerLbl">Confirm DCF</h1>
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
                <input id="dcfReqNo" name="dcfReqNo" value="${dcfReqNo}" type="hidden" />
                <input id="dcfStusId" name="dcfStusId" value="${dcfStusId}" type="hidden" />
                <input id="dcfReqType" name="dcfReqType" value="${dcfReqType}" type="hidden" />
            </form>

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
                            <th scope="row">Attachment</th>
                            <td id="attachTd"></td>

                            <th scope="row">Rekey-in Status</th>
                            <td>
                                <input id="rekeyInStus" name="rekeyInStus" type="text" class="readonly" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Request Remark</th>
                            <td colspan="3">
                                <textarea id="ReqRemark" name="ReqRemark"  cols="15" rows="3" placeholder="" class="readonly" readonly></textarea>
                            </td>
                        </tr>
                        <tr id="remField">
                            <th scope="row" id="remarkLbl">Remark<span class='must'>*</span></th>
                            <td colspan="3">
                                <textarea id="remark" name="remark"  cols="15" rows="3" placeholder=""></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- WHEN REKEY-IN STATUS = YES, WILL SHOW THIS PART -->
                <section id="newOrderInfoSection">
                     <!-- NEW ORDER INFO START -->
                     <span>New Order Info:</span>
                     <table class="type1" >
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:160px" />
                            <col style="width:*" />
                            <col style="width:160px" />
                            <col style="width:*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Order No.</th>
                                   <td>
                                        <input type="text" id="ordNo" name="ordNo" style="width: 209px;" class="readonly" readonly/>
                                   </td>

                                <th scope="row">Total Amount</th>
                                <td>
                                    <input id="newTotalAmtTxt" name="newTotalAmtTxt" type="text" class="readonly w100p" readonly />
                                    <input id="newTotalAmt" name="newTotalAmt" type="hidden" class="readonly w100p" readonly />
                                </td>
                            </tr>
                        </tbody>
                     </table>
                     <!-- NEW ORDER INFO END -->

                     <!-- SELECTED NEW ORDER START -->
                     <section class="search_result">
                          <article id="grid_request_new_dcf_wrap" class="grid_wrap"></article>
                     </section>
                     <!-- SELECTED NEW ORDER END -->

                     <!-- PAYMENT INFO START, NEED HIDE & SHOW FOR ABOVE SELECTED PAYMENT TYPE -->
                     <span>Payment Info:</span>
                     <table class="type1" >
                        <caption>table</caption>
                        <colgroup>
                           <col style="width:160px" />
                           <col style="width:*" />
                           <col style="width:160px" />
                           <col style="width:*" />
                        </colgroup>
                        <tbody>
                           <tr>
                               <th scope="row">Payment Type</th>
                               <td>
                                   <select id="payType" name="payType" class="w100p" disabled></select>
                               </td>
                           </tr>
                        </tbody>
                     </table>
                </section>

	            <section id="paymentInfoSection" style="display:block;">
	                <!--
	                ***************************************************************************************
	                ***************************************************************************************
	                *************                                     CASH PAYMENT INFO                                                   ****
	                ***************************************************************************************
	                ***************************************************************************************
	                -->
	                <section id="cashPayInfo" style="display:none;">
                        <table class="type1" >
	                          <caption>table</caption>
	                          <colgroup>
	                              <col style="width:160px" />
	                              <col style="width:*" />
	                              <col style="width:160px" />
	                              <col style="width:*" />
	                          </colgroup>
	                          <tbody>
	                              <tr>
	                                  <th scope="row">Amount<span class='must'>*</span></th>
	                                  <td>
	                                        <input id="cashTotalAmtTxt" name="cashTotalAmtTxt" type="text" class="readonly w100p" readonly />
	                                        <input id="cashTotalAmt" name="cashTotalAmt" type="hidden" class="readonly w100p" readonly />
	                                  </td>

	                                  <th scope="row">Bank Type<span class='must'>*</span></th>
	                                  <td>
	                                       <select id="cashBankType" name="cashBankType" class="w100p" disabled>
	                                          <option value="">Choose One</option>
	                                          <option value="2728">JomPay</option>
	                                          <option value="2729">MBB CDM</option>
	                                          <option value="2730">VA</option>
	                                          <option value="2731">Others</option>
	                                      </select>
	                                  </td>
	                              </tr>
	                              <tr>
	                                  <th scope="row">Bank Account<span class='must'>*</span></th>
	                                  <td>
	                                        <select id="cashBankAcc" name="cashBankAcc" class="w100p" class="readonly" readonly disabled></select>
	                                  </td>

	                                  <th scope="row">VA Account<span class='must'>*</span></th>
	                                  <td>
	                                      <input type="text" id="cashVAAcc" name="cashVAAcc" class="w100p readonly" readonly size="22" maxlength="30"  />
	                                  </td>
	                              </tr>
	                              <tr>
	                                  <th scope="row">Transaction Date<span class='must'>*</span></th>
	                                  <td>
	                                       <div class="date_set w100p">
	                                          <input type="text" id="cashTrxDate" name="cashTrxDate" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p readonly" readonly disabled/>
	                                       </div>
	                                  </td>

	                               <th scope="row">Slip No<span class='must'>*</span></th>
	                               <td>
	                                   <input type="text" id="cashSlipNo" name="cashSlipNo" class="w100p readonly" readonly />
	                               </td>
	                           </tr>
	                           <tr>
	                               <th scope="row">Transaction ID</th>
	                               <td>
	                                    <input type="text" id="cashTrxId" name="cashTrxId" class="w100p readonly" readonly />
	                               </td>
	                           </tr>
                            </tbody>
                        </table>
	                </section>


	                <!--
	                ***************************************************************************************
	                ***************************************************************************************
	                *************                                     CHEQUE PAYMENT INFO                                               ****
	                ***************************************************************************************
	                ***************************************************************************************
	                -->
	                <section id="chequePayInfo" style="display:none;">
                         <table class="type1" >
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:160px" />
                                <col style="width:*" />
                                <col style="width:160px" />
                                <col style="width:*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Amount<span class='must'>*</span></th>
                                    <td>
                                          <input id="chequeTotalAmtTxt" name="chequeTotalAmtTxt" type="text" class="readonly w100p" readonly />
                                    </td>

                                    <th scope="row">Bank Type<span class='must'>*</span></th>
                                    <td>
                                         <select id="chequeBankType" name="chequeBankType" class="w100p" disabled>
                                            <option value="">Choose One</option>
                                            <option value="2728">JomPay</option>
                                            <option value="2729">MBB CDM</option>
                                            <option value="2730">VA</option>
                                            <option value="2731">Others</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Bank Account<span class='must'>*</span></th>
                                    <td>
                                          <select id="chequeBankAcc" name="chequeBankAcc" class="w100p" disabled></select>
                                    </td>

                                    <th scope="row">VA Account<span class='must'>*</span></th>
                                    <td>
                                        <input type="text" id="chequeVAAcc" name="chequeVAAcc" class="w100p readonly" maxlength="30" readonly/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Transaction Date<span class='must'>*</span></th>
                                    <td>
                                         <div class="date_set w100p">
                                            <input type="text" id="chequeTrxDate" name="chequeTrxDate" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p readonly" readonly disabled/>
                                         </div>
                                    </td>

                                    <th scope="row">Slip No<span class='must'>*</span></th>
                                    <td>
                                        <input type="text" id="chequeSlipNo" name="chequeSlipNo" class="w100p readonly" readonly />
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Transaction ID</th>
                                    <td>
                                         <input type="text" id="chequeTrxId" name="chequeTrxId" class="w100p readonly" readonly />
                                    </td>
                                </tr>
                             </tbody>
                         </table>
	                </section>



	              <!--
	              ***************************************************************************************
	              ***************************************************************************************
	              *************                                   CREDIT CARD PAYMENT INFO                                         ****
	              ***************************************************************************************
	              ***************************************************************************************
	              -->
	              <section id="creditPayInfo" style="display:none;">
                         <table class="type1" >
                           <caption>table</caption>
                           <colgroup>
                               <col style="width:160px" />
                               <col style="width:*" />
                               <col style="width:160px" />
                               <col style="width:*" />
                           </colgroup>
                           <tbody>
                               <tr>
                                   <th scope="row">Card Type<span class='must'>*</span></th>
                                   <td>
                                         <select id="creditCardType" name="creditCardType" class="w100p" disabled></select>
                                   </td>

                                   <th scope="row">Amount<span class='must'>*</span></th>
                                   <td>
                                         <input id="creditTotalAmtTxt" name="creditTotalAmtTxt" type="text" class="readonly w100p" readonly />
                                   </td>
                               </tr>
                               <tr>
                                   <th scope="row">Card Mode<span class='must'>*</span></th>
                                   <td>
                                        <select id="creditCardMode" name="creditCardMode" class="w100p" disabled></select>
                                   </td>

                                   <th scope="row">Card Brand<span class='must'>*</span></th>
                                   <td>
                                        <select id="creditCardBrand" name="creditCardBrand" class="w100p" disabled></select>
                                   </td>
                               </tr>
                               <tr>
                                   <th scope="row">Card No<span class='must'>*</span></th>
                                   <td>
                                         <input type="text" id="creditCardNo" name="creditCardNo" class="wAuto readonly" readonly /></p>
                                   </td>

                                   <th scope="row">Approval No<span class='must'>*</span></th>
                                   <td>
                                       <input type="text" id="creditApprNo" name="creditApprNo" class="w100p readonly" readonly maxlength="6"  />
                                   </td>
                               </tr>
                               <tr>
                                   <th scope="row">Issue Bank<span class='must'>*</span></th>
                                   <td>
                                         <select id="creditIssueBank" name="creditIssueBank" class="w100p" disabled></select>
                                   </td>

                                   <th scope="row">Credit Card Holder Name</th>
                                   <td>
                                       <input type="text" id="creditCardHolderName" name="creditCardHolderName" class="w100p readonly" readonly />
                                   </td>
                               </tr>
                               <tr>
                                    <th scope="row">Expiry Date (mm/yyyy)<span class='must'>*</span></th>
                                   <td>
                                        <div class="date_set w100p">
                                           <input type="text" id="creditExpDt" name="creditExpDt" title="Expiry Date" placeholder="MM/YYYY" class="j_date2 w100p" disabled/>
                                        </div>
                                   </td>

                                   <th scope="row">Merchant Bank<span class='must'>*</span></th>
                                   <td>
                                       <select id="creditMerchantBank" name="creditMerchantBank" class="w100p" disabled></select>
                                   </td>
                               </tr>
                               <tr>
                                   <th scope="row">Transaction Date<span class='must'>*</span></th>
                                   <td>
                                        <div class="date_set w100p">
                                           <input type="text" id="creditTrxDate" name="creditTrxDate" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p readonly" readonly disabled/>
                                        </div>
                                   </td>

                                   <th scope="row">Tenure</th>
                                   <td>
                                     <select id="creditTenure" name="creditTenure" class="w100p" disabled></select>
                                   </td>
                               </tr>
                            </tbody>
                         </table>
	                </section>



	               <!--
	               ***************************************************************************************
	               ***************************************************************************************
	               *************                                     ONLINE PAYMENT INFO                                                   ****
	               ***************************************************************************************
	               ***************************************************************************************
	               -->
	               <section id="onlinePayInfo" style="display:none ;">
                       <table class="type1" >
	                           <caption>table</caption>
	                           <colgroup>
	                               <col style="width:160px" />
	                               <col style="width:*" />
	                               <col style="width:160px" />
	                               <col style="width:*" />
	                           </colgroup>
	                           <tbody>
	                               <tr>
	                                   <th scope="row">Amount<span class='must'>*</span></th>
	                                   <td>
	                                         <input id="onlineTotalAmtTxt" name="onlineTotalAmtTxt" type="text" class="readonly w100p" readonly />
	                                   </td>

	                                   <th scope="row">VA Account<span class='must'>*</span></th>
	                                   <td>
	                                       <input type="text" id="onlineVAAcc" name="onlineVAAcc" class="w100p readonly" readonly size="22" maxlength="30" />
	                                   </td>
	                               </tr>
	                               <tr>
	                                   <th scope="row">Bank Type<span class='must'>*</span></th>
	                                   <td>
	                                        <select id="onlineBankType" name="onlineBankType" class="w100p" disabled>
	                                           <option value="2728">JomPay</option>
	                                           <option value="2729">MBB CDM</option>
	                                           <option value="2730">VA</option>
	                                           <option value="2731">Others</option>
	                                       </select>
	                                   </td>

	                                   <th scope="row">Bank Account<span class='must'>*</span></th>
	                                   <td>
	                                         <select id="onlineBankAcc" name="onlineBankAcc" class="w100p" disabled></select>
	                                   </td>
	                               </tr>
	                               <tr>
	                                   <th scope="row">Transaction Date<span class='must'>*</span></th>
	                                   <td>
	                                        <div class="date_set w100p">
	                                           <input type="text" id="onlineTrxDate" name="onlineTrxDate" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p readonly" readonly disabled/>
	                                        </div>
	                                   </td>

	                                   <th scope="row" d="onlineEftLbl">EFT<span class='must'>*</span></th>
	                                   <td>
	                                       <input type="text" id="onlineEFT" name="onlineEFT" class="w100p readonly" readonly />
	                                   </td>
	                               </tr>
	                               <tr>
	                                   <th scope="row">Transaction ID</th>
	                                   <td>
	                                        <input type="text" id="onlineTrxId" name="onlineTrxId" class="w100p readonly" readonly />
	                                   </td>

	                                   <th scope="row">Bank Charge Amount</th>
	                                   <td>
	                                        <input type="text" id="onlineBankChgAmt" name="onlineBankChgAmt" class="w100p readonly" maxlength="10" readonly/>
	                                   </td>
	                               </tr>
	                            </tbody>
	                       </table>
	                </section>
	              <!-- PAYMENT INFO END -->
                </section>
        </section>

        <ul class="center_btns">
            <li><p class="btn_blue" id="btn_appv"><a href="javascript:fn_approval();"><spring:message code='pay.btn.approval'/></a></p></li>
            <li><p class="btn_blue" id="btn_reject"><a href="javascript:fn_reject();"><spring:message code='pay.btn.reject'/></a></p></li>
        </ul>
    </section>
</div>