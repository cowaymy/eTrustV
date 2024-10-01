<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 25,
        showFooter: false
};

var columnLayout=[             
    {dataField:"billId" ,headerText:"<spring:message code='pay.head.billId'/>",visible : false},
    {dataField:"email" ,headerText:"<spring:message code='pay.head.email'/>",visible : false},
    {dataField:"custBillGrpNo", headerText:"<spring:message code='pay.head.grpNo'/>",width: 200 , editable : false },
    {dataField:"year", headerText:"<spring:message code='pay.head.year'/>",width: 100 , editable : false },
    {dataField:"month", headerText:"<spring:message code='pay.head.month'/>",width: 100 , editable : false },
    {dataField:"soNo", headerText:"<spring:message code='pay.head.orderNo'/>",width: 250 , editable : false },
    {dataField:"custName", headerText:"<spring:message code='pay.head.custName'/>"}
];

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
	
	    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
		    $('input:radio[name=printMethod]').is(':checked');
		    
		     // Master Grid 셀 클릭시 이벤트
		    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
		        selectedGridValue = event.rowIndex;
		    });
		     
		    //AUIGrid.resize(myGridID);
	
});



function fn_getCompanyStatementListAjax() {        
    var valid = ValidRequiredField();
    if(!valid){
         Common.alert("<spring:message code='pay.alert.billNoOROrderNo'/>");
    }else{
        Common.ajax("GET", "/payment/selectCompStatementList", $("#searchForm").serialize(), function(result) {
            console.log(result);
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
function fn_generateStatement(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);

  if (selectedItem[0] > -1){
      //report form에 parameter 세팅
      $("#reportPDFForm #viewType").val("PDF");
      $("#reportPDFForm #v_billId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "billId"));
      $("#reportPDFForm #v_year").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "year"));
      $("#reportPDFForm #v_month").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "month"));
            
      //report 호출
      var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

      Common.report("reportPDFForm", option);
   
  }else{
      Common.alert("<spring:message code='pay.alert.noPrintType'/>");
  }
}

//SEND EMAIL
function fn_sendEInvoice(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);
  
  if (selectedItem[0] > -1){
      if(FormUtil.checkReqValue($("#eInvoiceForm #send_email")) ){
          Common.alert("<spring:message code='pay.alert.emailAddress.'/>");
          return;
      }
      //report form에 parameter 세팅      
      $("#reportPDFForm #v_billId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "billId"));
      $("#reportPDFForm #v_year").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "year"));
      $("#reportPDFForm #v_month").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "month"));
      $("#reportPDFForm #viewType").val("MAIL_PDF");
      
      
      //E-mail 내용
      var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "year");
      var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "month");
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
      var emailTitle = "Company Statement  " + paramMonth + "/" + year;
      $("#reportPDFForm #emailSubject").val(emailTitle);
      $("#reportPDFForm #emailText").val(message);
      $("#reportPDFForm #emailTo").val($("#eInvoiceForm #send_email").val());
            
      //report 호출
      var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

      Common.report("reportPDFForm", option);
   
  }else{
      Common.alert("<spring:message code='pay.alert.noPrintType'/>");
  }
}

//Send E-Invoice 팝업
function fn_sendEStatementPop(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    
    if (selectedItem[0] > -1){
        var email = AUIGrid.getCellValue(myGridID, selectedGridValue, "email");
        $('#einvoice_wrap').show();
        $('#send_email').val(email);
    }else{
        Common.alert("<spring:message code='pay.alert.noClaim'/>");
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
<h1>Company Statement</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
<ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateStatement();"><spring:message code='pay.btn.invoice.generate'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getCompanyStatementListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
</ul>

<section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
        	<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
            <table class="type1"> 
                <caption>table</caption>
                <colgroup>
                    <col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:160px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Billing Number</th>
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
                    </tbody>
              </table>
        </form>
        
    </section>
    <section class="search_result">
        <article id="aa" class="grid_wrap">
            <div id="grid_wrap"></div>
        </article>
    </section>
</section>
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/Official_StatementOfAccount(COMPANY)_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="" />
    <input type="hidden" id="v_month" name="v_month" />
    <input type="hidden" id="v_year" name="v_year" />
    <input type="hidden" id="v_billId" name="v_billId" />
    <input type="hidden" id="emailSubject" name="emailSubject" value="" />
    <input type="hidden" id="emailText" name="emailText" value="" />
    <input type="hidden" id="emailTo" name="emailTo" value="" />
</form>
</div>
