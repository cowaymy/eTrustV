<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 그리드 객체
var myPopGridID;


//AUIGrid 칼럼 설정
var myPopLayout = [   
    { dataField:"billItmType" ,headerText:"<spring:message code='pay.head.billType'/>",width: 200 , editable : false},
    { dataField:"billItmRefNo" ,headerText:"<spring:message code='pay.head.orderNumber'/>",width: 200 , editable : false},
    { dataField:"memoItmChrg" ,headerText:"<spring:message code='pay.head.amount'/>", editable : false, dataType : "numeric",formatString : "#,##0.00" ,width : 120},
    { dataField:"memoItmTxs" ,headerText:"<spring:message code='pay.head.gst'/>", editable : false ,dataType : "numeric",formatString : "#,##0.00" ,width : 120},
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
    selectAdjustmentDetailPop("${adjId}");
    
    //모드에 따라 버튼 세팅
    if("${mode}" == "SEARCH"){
    	$("#centerBtn1").show();
    }else if("${mode}" == "APPROVAL"){
        $("#centerBtn2").show();
    }
   
});

//report 조회 변수
var memoAdjId;
var invoiceType;
var miscType;
var memoStatus;
var memoAdjTypeId;
var memoInvoiceNo;


//상세 팝업
function selectAdjustmentDetailPop(adjId){
    
    //데이터 조회 (초기화면시 로딩시 조회)       
    Common.ajax("GET", "/payment/selectAdjustmentDetailPop.do", {"adjId":adjId}, function(result) {
        if(result != 'undefined'){
           
            //Master데이터 출력
            memoAdjId = result.master.memoAdjId;
            invoiceType = result.master.memoAdjInvcTypeId;
            miscType = result.master.taxInvcType;
            memoStatus = result.master.memoAdjStusId;
            memoAdjTypeId  = result.master.memoAdjTypeId;
            memoInvoiceNo = result.master.taxInvcRefNo;
            
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

            //Detail데이터 출력
            AUIGrid.setGridData(myPopGridID, result.detailList);
            
            //History 데이터 출력
            $("#history").children().remove();
            $.each( result.histlList, function(key, value) {
            	$("#history").append("<li>  "+value.memoAdjRefNo+" - " + value.adjStusName+ " on " + value.adjCrtDt+ "</li>");
            });            
        }
    });
}

//크리스탈 레포트
function fn_generateReport(){
	
	if (memoStatus != 4){
		Common.alert('<b>Only in complete status is allow to print.</b>');
        return;
	}
    
    if(invoiceType ==  126 || invoiceType == 127){
        $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF.rpt');
    }else{
        if( miscType == 117 ){
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscHP_PDF.rpt');
        }else if(miscType == 118) {
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscAS_PDF.rpt');
        }else if(miscType == 119) {
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscSRV_PDF.rpt');
        }else if(miscType == 121) {
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF.rpt');
        }else if(miscType == 122) {
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF.rpt');
        }else if(miscType == 123) {
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscWholeSales_PDF.rpt');
        }else if(miscType == 124) {
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_PDF.rpt');
        }else if(miscType == 142) {
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_CreditNote_MiscItemBankPOS_PDF.rpt');
        }
    }
    
    $("#reportPDFForm #v_adjid").val(memoAdjId);
    $("#reportPDFForm #v_type").val(invoiceType);
    
    //report 호출
    var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("reportPDFForm", option);
}

function fn_approve(process){
	var param = {"adjId":"${adjId}" , 
			           "process" : process, 
			           "invoiceType" : invoiceType, 
			           "memoAdjTypeId" : memoAdjTypeId, 
			           "invoiceNo" : memoInvoiceNo};
	
    Common.ajax("POST", "/payment/approvalAdjustment.do", param, function(result) {
        Common.alert("Invoice Adjustment successfully confirmed.<br />",function(){
        	fn_getAdjustmentListAjax();    //메인 페이지 조회        	
        	$('#_adjustmentDetailPop').hide();
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
                    <th scope="row">Memo Ref No.</th>
                    <td id="tRefNo"></td>
                    <th scope="row">Report No.</th>
                    <td id="tReportNo"></td>
                </tr>
                <tr>
                    <th scope="row">Memo Type</th>
                    <td id="tType"></td>
                    <th scope="row">Memo Reason</th>
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
                    <th scope="row">Memo Remark</th>
                    <td colspan="3"  id="tMemoRemark"></td>
                </tr>
                <tr>
                    <th scope="row">Customer Name</th>
                    <td colspan="3"  id="tCustNmt"></td>
                </tr>
                <tr>
                    <th scope="row">Contact Person</th>
                    <td colspan="3"  id="tContactPerson"></td>
                </tr>
                <tr>
                    <th scope="row">Address</th>
                    <td colspan="3"  id="tAddr"></td>
                </tr>
                <tr>
                    <th scope="row">Remark</th>
                    <td colspan="3"  id="tInvoiceRemark"></td>
                </tr>
            </tbody>
        </table><!-- table end -->

        <aside class="title_line">
            <h2>Item(s) Information</h2>
        </aside>
        <article id="grid_Pop_wrap" class="grid_wrap"></article>

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
