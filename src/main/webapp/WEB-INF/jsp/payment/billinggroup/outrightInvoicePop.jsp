<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){

	setTimeout(function() { 
		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	    
	    // Master Grid 셀 클릭시 이벤트
	    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
	        selectedGridValue = event.rowIndex;
	    });  
	}, 100);
	
    
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 25
};

var columnLayout=[             
    {dataField:"salesOrdId", headerText:"Order ID" ,visible : false},
    {dataField:"email", headerText:"Email" ,visible : false},
    {dataField:"salesOrdNo", headerText:"Order No"},
    {dataField:"codeName", headerText:"App Type"},
    {dataField:"salesDt", headerText:"Order Date"},
    {dataField:"name", headerText:"CustomerName"}
];

function fn_getOutrightInvoiceListAjax() {     
    
    console.log("appType : " + $("#appType").val());
    console.log($("searchForm").serialize());
    Common.ajax("GET", "/payment/selectOutrightInvoiceList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}


//크리스탈 레포트
function fn_generateStatement(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);
  
  if (selectedItem[0] > -1){
      //report form에 parameter 세팅
      $("#reportPDFForm #v_orderId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "salesOrdId"));
      $("#reportPDFForm #viewType").val("PDF");
      Common.report("reportPDFForm");
  }else{
      Common.alert('<b>No print type selected.</b>');
  }
}

//Email
function fn_sendEInvoice(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);

  if (selectedItem[0] > -1){
      if(FormUtil.checkReqValue($("#eInvoiceForm #send_email")) ){
          Common.alert('* Please key in the email.<br />');
          return;
      }
      //report form에 parameter 세팅
      $("#reportPDFForm #v_orderId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "salesOrdId"));
      $("#reportPDFForm #viewType").val("MAIL_PDF");
      
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
      var emailTitle = "Outright Invoice " + AUIGrid.getCellValue(myGridID, selectedGridValue, "salesOrdId");
      $("#reportPDFForm #emailSubject").val(emailTitle);
      $("#reportPDFForm #emailText").val(message);
      $("#reportPDFForm #emailTo").val($("#eInvoiceForm #send_email").val());
      
      Common.report("reportPDFForm");
   
  }else{
      Common.alert('<b>No print type selected.</b>');
  }
}

//Layer close
hideViewPopup=function(val){
    $(val).hide();
}
</script>   

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Outright Invoice</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateStatement();">Statement Generate</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getOutrightInvoiceListAjax();">Search</a></p></li>
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
                        <th scope="row">Order Number</th>
                        <td colspan="3">
                            <input id="orderNo" name="orderNo" type="text" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Application Type</th>
                        <td>
                            <select id="appType" name="appType" class="multy_select" multiple="multiple">
                                <option value="67">Outright</option>
                                <option value="68">Installment</option>
                            </select>
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                           <input id="custName" name="custName" type="text" class="w100p" />
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
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/InstOutInvoice_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="" />
    <input type="hidden" id="v_orderId" name="v_orderId" />
    <!-- 이메일 전송인 경우 모두 필수-->
    <input type="hidden" id="emailSubject" name="emailSubject" value="" />
    <input type="hidden" id="emailText" name="emailText" value="" />
    <input type="hidden" id="emailTo" name="emailTo" value="" /> 
</form>
</div>