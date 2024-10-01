<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;
var typeData = [];
typeData = [{"codeId": "67","codeName": "Outright"},{"codeId": "68","codeName": "Installment"}];

var gridPros = {
        showRowNumColumn : false,
        editable: false,
        showStateColumn: false,
        usePaging : false
};

var columnLayout=[             
    {dataField:"salesOrdId", headerText:"<spring:message code='pay.head.orderId'/>" ,visible : false},
    {dataField:"email", headerText:"<spring:message code='pay.head.email'/>" ,visible : false},
    {dataField:"salesOrdNo", headerText:"<spring:message code='pay.head.orderNo'/>"},
    {dataField:"codeName", headerText:"<spring:message code='pay.head.appType'/>"},
    {dataField:"salesDt", headerText:"<spring:message code='pay.head.orderDate'/>"},
    {dataField:"name", headerText:"<spring:message code='pay.head.custName'/>"}
];

$(document).ready(function(){
    
	doDefCombo(typeData, '' ,'appType', 'M', 'f_multiCombo');
	 
		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	    
	    // Master Grid 셀 클릭시 이벤트
	    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
	        selectedGridValue = event.rowIndex;
	    });  
});


function fn_getOutrightInvoiceListAjax(goPage) {     
    //페이징 변수 세팅
    $("#pageNo").val(goPage);  
    
    Common.ajax("GET", "/payment/selectOutrightInvoiceList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result.list);
        
        //전체건수 세팅
        _totalRowCount = result.totalRowCount;
        
        //페이징 처리를 위한 옵션 설정
        var pagingPros = {
                // 1페이지에서 보여줄 행의 수
                rowCount : $("#rowCount").val()
        };
        
        GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);
    });
}

//페이지 이동
function moveToPage(goPage){
  //페이징 변수 세팅
  $("#pageNo").val(goPage);
  Common.ajax("GET", "/payment/selectOutrightInvoiceList.do", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result.list);
      
      //페이징 처리를 위한 옵션 설정
      var pagingPros = {
              // 1페이지에서 보여줄 행의 수
              rowCount : $("#rowCount").val()
      };
      
      GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);        
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
	  Common.alert("<spring:message code='pay.alert.noPrintType'/>");
  }
}

//Email
function fn_sendEInvoice(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);

  if (selectedItem[0] > -1){
      if(FormUtil.checkReqValue($("#eInvoiceForm #send_email")) ){
    	  Common.alert("<spring:message code='pay.alert.emailAddress.'/>");
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
	  Common.alert("<spring:message code='pay.alert.noPrintType'/>");
  }
}

//Layer close
hideViewPopup=function(val){
    $(val).hide();
}

function f_multiCombo() {
    $(function() {
        $('#appType').multipleSelect({
            //selectAll : true, // 전체선택 
            width : '80%'
        })
    });
}

function fn_clear(){
    $("#searchForm")[0].reset();
    AUIGrid.clearGridData(myGridID);
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
            <li><p class="btn_blue"><a href="javascript:fn_generateStatement();"><spring:message code='pay.btn.invoice.generate'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getOutrightInvoiceListAjax(1);"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul> 
        
    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
			<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
            <input type="hidden" name="rowCount" id="rowCount" value="25" />
            <input type="hidden" name="pageNo" id="pageNo" />
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
                            <select id="appType" name="appType" class="multy_select w100p"></select>
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
            <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
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