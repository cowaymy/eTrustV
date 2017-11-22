<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    $('input:radio[name=printMethod]').is(':checked');
    
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
    {dataField:"billId" ,headerText:"Bill ID",visible : false},
    {dataField:"email" ,headerText:"Email",visible : false},
    {dataField:"custBillGrpNo", headerText:"Group No",width: 200 , editable : false },
    {dataField:"year", headerText:"Year",width: 100 , editable : false },
    {dataField:"month", headerText:"Month",width: 100 , editable : false },
    {dataField:"soNo", headerText:"Order No",width: 250 , editable : false },
    {dataField:"custName", headerText:"Customer Name"}
];

function fn_getCompanyStatementListAjax() {        
	var valid = ValidRequiredField();
	if(!valid){
		 Common.alert("* Please key in either Bill No or Order No.<br />");
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
      Common.alert('<b>No print type selected.</b>');
  }
}

//SEND EMAIL
function fn_sendEInvoice(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);
  
  if (selectedItem[0] > -1){
	  if(FormUtil.checkReqValue($("#eInvoiceForm #send_email")) ){
	      Common.alert('* Please key in the email.<br />');
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
      Common.alert('<b>No print type selected.</b>');
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
        Common.alert('No claim record selected.');
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
        <li>Company Statement</li>
    </ul>
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Company Statement</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateStatement();">Statement Generate</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getCompanyStatementListAjax();"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_Clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->
    <!-- search_table start--> 
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
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
                        <th scope="row">Billing Number</th>
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
                    </tbody>
              </table>
        </form>
        <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                        <ul class="btns">
                            <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_sendEStatementPop();">Send E-Statement</a></p></li>
                        </ul>
                        <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
    </section>
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/Official_StatementOfAccount(COMPANY)_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="" />
    <input type="hidden" id="v_month" name="v_month" />
    <input type="hidden" id="v_year" name="v_year" />
    <input type="hidden" id="v_billId" name="v_billId" />
    <!-- 이메일 전송인 경우 모두 필수 -->
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

