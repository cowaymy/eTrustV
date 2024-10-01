<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 25
};

var columnLayout=[              
    {dataField:"salesOrdNo", headerText:"<spring:message code='pay.head.orderNo'/>"},
    {dataField:"name", headerText:"<spring:message code='pay.head.custName'/>"},
    {dataField:"srvMemQuotNo", headerText:"<spring:message code='pay.head.quotationNo'/>"},
    {dataField:"invcRefNo", headerText:"<spring:message code='pay.head.invoiceNo'/>"},
    {dataField:"invcRefDt", headerText:"<spring:message code='pay.head.invoiceDate'/>"},
    {dataField:"invcSubMemPacAmt", headerText:"<spring:message code='pay.head.invoiceAmt'/>"},
    {dataField:"invcSubMemBsAmt", headerText:"<spring:message code='pay.head.installmentNo'/>"},
    {dataField:"email", headerText:"<spring:message code='pay.head.email'/>", visible:false}
];

$(document).ready(function(){
  
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
        
        // Master Grid 셀 클릭시 이벤트
        AUIGrid.bind(myGridID, "cellClick", function( event ){ 
            selectedGridValue = event.rowIndex;
        });  	
});

function fn_getMembershipInvoiceListAjax() {        
    var valid = ValidRequiredField();
    if(!valid){
    	Common.alert("<spring:message code='pay.alert.billNoOROrderNo'/>");
    }else{
        Common.ajax("GET", "/payment/selectMembershipList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
}

function ValidRequiredField(){
    var valid = true;
    
    if($("#invoiceNo").val() == "" && $("#orderNo").val() == "")
        valid = false;
    
    return valid;
}

//크리스탈 레포트
function fn_generateStatement(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    
    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        $("#reportPDFForm #v_invoiceNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "invcRefNo"));
        $("#reportPDFForm #viewType").val("PDF");
        //report 호출
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportPDFForm", option);
    }else{
    	Common.alert("<spring:message code='pay.alert.noPrintType'/>");
    }
}

//크리스탈 레포트 - send E-Invoice
function fn_sendEInvoice(){
    //E-mail 내용
    var message = "";
    message += "Dear customer,\n\n" +
	    "Please refer to the attachment of the re-send invoice as per requested.\n" +
	    "By making the simple switch to e-invoice, you help to save trees, which is great news for the environment." +
	    "\n\n" +
	    "NOTE :Please do not reply this email as this is computer generated e-mail." +
	    "\n\n\n" +
	    "Thank you and have a wonderful day.\n\n" +
	    "Regards\n" +
	    "Management Team of Coway Malaysia Sdn. Bhd.";
        
    //E-mail 제목
    var emailTitle = "Membership Invoice ";
    
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    
    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        $("#reportPDFForm #v_invoiceNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "invcRefNo"));
        //report 호출
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };
        
        //report form에 parameter 세팅
        $("#reportPDFForm #viewType").val("MAIL_PDF");
        
        $("#reportPDFForm #emailSubject").val(emailTitle);
        $("#reportPDFForm #emailText").val(message);
        $("#reportPDFForm #emailTo").val($("#eInvoiceForm #send_email").val());
        
       Common.report("reportPDFForm", option);
    }else{
    	Common.alert("<spring:message code='pay.alert.noPrintType'/>");
    }
}

function fn_clear(){
    $("#searchForm")[0].reset();
    AUIGrid.clearGridData(myGridID);
}
</script>

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Invoice</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateStatement();"><spring:message code='pay.btn.invoice.generate'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getMembershipInvoiceListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul> 
    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
			<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:*" />
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Invoice Number</th>
                        <td>
                            <input id="invoiceNo" name="invoiceNo" type="text" class="w100p" />
                        </td>
                        <th scope="row">Statement Period</th>
                        <td>
                           <input type="text" name="period" title="기준년월" class="j_date2 w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Order Number</th>
                        <td>
                            <input id="orderNo" name="orderNo" type="text" class="w100p" />
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                           <input id="custName" name="custName" type="text" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer NRIC</th>
                        <td>
                            <input id="custNRIC" name="custNRIC" type="text" class="w100p" />
                        </td>
                        <th scope="row">Quotation No</th>
                        <td>
                            <input id="quotationNo" name="quotationNo" type="text" class="w100p" />
                        </td>
                    </tr>
                    </tbody>
              </table>
        </form>
        </section>
         <!-- search_result start -->
        <section class="search_result">     
            <!-- grid_wrap start -->
            <article id="grid_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>
</section>
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/SrvMembership_Invoice.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="" />
    <input type="hidden" id="v_invoiceNo" name="v_invoiceNo" />
    <!-- 이메일 전송인 경우 모두 필수-->
    <input type="hidden" id="emailSubject" name="emailSubject" value="" />
    <input type="hidden" id="emailText" name="emailText" value="" />
    <input type="hidden" id="emailTo" name="emailTo" value="" />
</form>
</div>