<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    //$('input:radio[name=printMethod]').is(':checked');
    $('input:radio[name=printMethod]').eq(0).attr("checked", true);  
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });  
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 25
};

var columnLayout=[
    {dataField:"taskId", headerText:"Task ID",visible : false},
    {dataField:"renDateTimeYear", headerText:"Year",visible : false},
    {dataField:"renDateTimeMonth", headerText:"Month",visible : false},
    {dataField:"email", headerText:"Email",visible : false},
    {dataField:"salesOrdNo", headerText:"Order No"},
    {dataField:"name", headerText:"Customer Name"},
    {dataField:"rentDocNo", headerText:"Invoice No"}, 
    {dataField:"renDateTime", headerText:"Invoice Date"},
    {dataField:"rentAmt", headerText:"Invoice Amount"},
    {dataField:"rentInstNo", headerText:"Installment No"}
];

function fn_getCompanyInvoiceListtAjax() {        
    var valid = ValidRequiredField();
    if(!valid){
         Common.alert("* Please key in either Bill No or Order No.<br />");
    }else{
        Common.ajax("GET", "/payment/selectInvoiceList.do", $("#searchForm").serialize(), function(result) {
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
        
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "renDateTimeYear");
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "renDateTimeMonth");
        var brNo = AUIGrid.getCellValue(myGridID, selectedGridValue, "rentDocNo");
        var paramMonth  = parseInt(month) < 10 ? "0" + month : month;
        
        //report form에 parameter 세팅
        if($('input:radio[name=printMethod]').eq(0).is(':checked')){
            if(parseInt(year) < 2014){
                $("#reportPDFForm #reportFileName").val('/statement/Official_Invoice_PDF.rpt');
            }else{
                if( parseInt(year) == 2014 && parseInt(month) < 5){
                    $("#reportPDFForm #reportFileName").val('/statement/Official_Invoice_PDF.rpt');
                }else{
                    $("#reportPDFForm #reportFileName").val('/statement/Official_Invoice_PDF201405.rpt');
                }
            }
        }else{
            if(parseInt(year) < 2014){
                $("#reportPDFForm #reportFileName").val('/statement/Official_Invoice_PDF_NoHearder.rpt');
            }else{
                if( parseInt(year) == 2014 && parseInt(month) < 5){
                    $("#reportPDFForm #reportFileName").val('/statement/Official_Invoice_PDF_NoHearder.rpt');
                }else{
                    $("#reportPDFForm #reportFileName").val('/statement/Official_Invoice_PDF201405_NoHearder.rpt');
                }
            }
        }
        
        //$("#reportPDFForm #reportDownFileName").val(brNo+paramMonth+year+".pdf");
        $("#reportPDFForm #viewType").val("PDF");
        $("#reportPDFForm #v_month").val(month);
        $("#reportPDFForm #v_year").val(year);
        $("#reportPDFForm #v_brNo").val(brNo);
        $("#reportPDFForm #v_type").val(6);
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

//Send E-Invoice 팝업
function fn_sendEInvoicePop(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    
    if (selectedItem[0] > -1){
    	var email = AUIGrid.getCellValue(myGridID, selectedGridValue, "email");
        $('#einvoice_wrap').show();
        $('#send_email').val(email);
    }else{
        Common.alert('No claim record selected.');
    }
}

//크리스탈 레포트 - send E-Invoice
function fn_sendEInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    
    if (selectedItem[0] > -1){
        
        if(FormUtil.checkReqValue($("#eInvoiceForm #send_email")) ){
            Common.alert('* Please key in the email.<br />');
            return;
        }
        
        //크리스탈 레포트 조회 parameter
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "renDateTimeYear");
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "renDateTimeMonth");
        var brNo = AUIGrid.getCellValue(myGridID, selectedGridValue, "rentDocNo");        
        var paramMonth  = parseInt(month) < 10 ? "0" + month : month;
        
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
        var emailTitle = "Rental Invoice " + paramMonth + "/" + year;
        
        //report form에 parameter 세팅
        $("#reportPDFForm #reportFileName").val('/statement/Official_Invoice_PDF.rpt');
        $("#reportPDFForm #viewType").val("MAIL_PDF");
        $("#reportPDFForm #reportDownFileName").val(brNo+paramMonth+year);
        
        $("#reportPDFForm #v_month").val(month);
        $("#reportPDFForm #v_year").val(year);
        $("#reportPDFForm #v_brNo").val(brNo);
        $("#reportPDFForm #v_type").val(6);
        $("#reportPDFForm #v_printLive").val(0);
        $("#reportPDFForm #v_taskId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taskId"));
        
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

function fn_Clear(){
    $("#searchForm")[0].reset();
}
</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Company Invoice</li>
    </ul>
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Company Invoice</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateInvoice();">Generate Invoice</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getCompanyInvoiceListtAjax();"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_Clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->
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
                           <input type="text" name="period" title="기준년월" class="j_date2 w100p" placeholder="MM/YYYY"/>
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
                        <th scope="row">Print Method</th>
                        <td>
                           <label><input type="radio" name="printMethod" value="" /><span>With Hearder</span></label>
                           <label><input type="radio" name="printMethod" value="" /><span>No Hearder</span></label>
                        </td>
                    </tr>
                    </tbody>
              </table>
        </form>
        <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="javascript:fn_sendEInvoicePop();">Send E-Invoice</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
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
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_month" name="v_month" />
    <input type="hidden" id="v_year" name="v_year" />
    <input type="hidden" id="v_brNo" name="v_brNo" />
    <input type="hidden" id="v_type" name="v_type" />
    <input type="hidden" id="v_printLive" name="v_printLive" />
    <input type="hidden" id="v_taskId" name="v_taskId" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
    <!-- 이메일 전송인 경우 모두 필수-->
    <input type="hidden" id="emailSubject" name="emailSubject" value="" />
    <input type="hidden" id="emailText" name="emailText" value="" />
    <input type="hidden" id="emailTo" name="emailTo" value="" />
</form>
<!--------------------------------------------------------------- 
    POP-UP (E-INVOICE)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="einvoice_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="einvoice_pop_header">
        <h1>COMPANY INVOICE - E-INVOICE</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#einvoice_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    
    <!-- pop_body start -->
    <form name="eInvoiceForm" id="eInvoiceForm"  method="post">
	    <section class="pop_body">
	        <!-- search_table start -->
	        <section class="search_table">
	            <!-- table start -->
	            <table class="type1">
	                <caption>table</caption>
	                 <colgroup>
	                    <col style="width:165px" />
	                    <col style="width:*" />                
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row">Email</th>
	                        <td>
	                            <input type="text" id="send_email" name="send_email" title="Email Address" placeholder="Email Address" class="w100p" />
	                        </td>
	                    </tr>
	                 </tbody>  
	            </table>
	        </section>
	        <ul class="center_btns" >
	            <li><p class="btn_blue2"><a href="javascript:fn_sendEInvoice();">Generate & Send</a></p></li>
	        </ul>
	    </section>
    </form>       
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->