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
    {dataField:"taskId", headerText:"<spring:message code='pay.head.taskId'/>",visible : false},
    {dataField:"rdtmonth", headerText:"<spring:message code='pay.head.month'/>",visible : false},
    {dataField:"rdtyear", headerText:"<spring:message code='pay.head.year'/>",visible : false},
    {dataField:"email", headerText:"<spring:message code='pay.head.email'/>",visible : false},
    {dataField:"salesOrdNo", headerText:"<spring:message code='pay.head.orderNo'/>"},
    {dataField:"name", headerText:"<spring:message code='pay.head.custName'/>"},
    {dataField:"rentDocNo", headerText:"<spring:message code='pay.head.invoiceNo'/>"},
    {dataField:"salesDt", headerText:"<spring:message code='pay.head.invoiceDate'/>"},
    {dataField:"rentAmt", headerText:"<spring:message code='pay.head.invoiceAmt'/>"},
    {dataField:"rentInstNo", headerText:"<spring:message code='pay.head.installmentNo'/>"}
];

$(document).ready(function(){
    
		   myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
	    // Master Grid 셀 클릭시 이벤트
	    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
	        selectedGridValue = event.rowIndex;
	    });  
});


function fn_getIndividualStatementListAjax() {        
    var valid = ValidRequiredField();
    if(!valid){
         Common.alert("* Please key in either Bill No or Order No.<br />");
    }else{
        Common.ajax("GET", "/payment/selectRentalList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
}

function ValidRequiredField(){
    var valid = true;
    
    if($("#brNumber").val() == "" && $("#orderNo").val() == "")
        valid = false;
    
    return valid;
}



//크리스탈 레포트
function fn_generateInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    
    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "rdtyear");
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "rdtmonth");
        
        if(parseInt(year) < 2014){
            $("#reportPDFForm #reportFileName").val('/statement/Official_StatementOfAccount_PDF.rpt');
        }else{
            if( parseInt(year) ==  2014 && parseInt(month) < 5 ){
                $("#reportPDFForm #reportFileName").val('/statement/Official_StatementOfAccount_PDF.rpt');
            }else{
                $("#reportPDFForm #reportFileName").val('/statement/Official_StatementOfAccount_PDF201405.rpt');
            }
        }
        
        $("#reportPDFForm #viewType").val("PDF");
        $("#reportPDFForm #v_month").val(month);    
        $("#reportPDFForm #v_year").val(year);
        $("#reportPDFForm #v_brNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "rentDocNo"));    
        $("#reportPDFForm #v_type").val(2);
        $("#reportPDFForm #v_printLive").val(0);
        $("#reportPDFForm #v_taskId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taskId"));
          
        //report 호출
        var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };
    
        Common.report("reportPDFForm", option);
     
    }else{
        Common.alert('<b>No print type selected.</b>');
    }
}

//EMAIL
function fn_sendEInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    
    if (selectedItem[0] > -1){
        if(FormUtil.checkReqValue($("#eInvoiceForm #send_email")) ){
              Common.alert('* Please key in the email.<br />');
              return;
          }
        //report form에 parameter 세팅
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "rdtyear");
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "rdtmonth");
        
        if(parseInt(year) < 2014){
            $("#reportPDFForm #reportFileName").val('/statement/Official_StatementOfAccount_PDF.rpt');
        }else{
            if( parseInt(year) ==  2014 && parseInt(month) < 5 ){
                $("#reportPDFForm #reportFileName").val('/statement/Official_StatementOfAccount_PDF.rpt');
            }else{
                $("#reportPDFForm #reportFileName").val('/statement/Official_StatementOfAccount_PDF201405.rpt');
            }
        }
        
        $("#reportPDFForm #viewType").val("MAIL_PDF");
        $("#reportPDFForm #v_month").val(month);    
        $("#reportPDFForm #v_year").val(year);
        $("#reportPDFForm #v_brNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "rentDocNo"));    
        $("#reportPDFForm #v_type").val(2);
        $("#reportPDFForm #v_printLive").val(0);
        $("#reportPDFForm #v_taskId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taskId"));
        
        //E-mail 내용
        var paramMonth  = parseInt(month) < 10 ? "0" + month : month;
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
        var emailTitle = "Individual Statement  " + paramMonth + "/" + year;
        $("#reportPDFForm #emailSubject").val(emailTitle);
        $("#reportPDFForm #emailText").val(message);
        $("#reportPDFForm #emailTo").val($("#eInvoiceForm #send_email").val());
          
        //report 호출
        var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };
    
        Common.report("reportPDFForm", option);
     
    }else{
        Common.alert('<b>No print type selected.</b>');
    }
}

//Layer close
hideViewPopup=function(val){
    $(val).hide();
}

function fn_clear(){
    $("#searchForm")[0].reset();
    AUIGrid.clearGridData(myGridID);
}
</script>

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Individual Rental Statement</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateInvoice();"><spring:message code='pay.btn.invoice.generate'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getIndividualStatementListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>    

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
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
                        <th scope="row">BR Number</th>
                        <td>
                            <input id="brNumber" name="brNumber" type="text" class="w100p" />
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
                           <input id="customerName" name="customerName" type="text" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer NRIC</th>
                        <td>
                            <input id="customerNRIC" name="customerNRIC" type="text" class="w100p" />
                        </td>
                        <th scope="row"></th>
                        <td>
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
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="" />    
    <input type="hidden" id="v_month" name="v_month" />
    <input type="hidden" id="v_year" name="v_year" />
    <input type="hidden" id="v_brNo" name="v_brNo" />
    <input type="hidden" id="v_type" name="v_type" />
    <input type="hidden" id="v_printLive" name="v_printLive" />
    <input type="hidden" id="v_taskId" name="v_taskId" />
    <!-- 이메일 전송인 경우 모두 필수-->
    <input type="hidden" id="emailSubject" name="emailSubject" value="" />
    <input type="hidden" id="emailText" name="emailText" value="" />
    <input type="hidden" id="emailTo" name="emailTo" value="" />
</form>
</div>
