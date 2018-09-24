<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
 
    doGetCombo('/common/selectCodeList.do', '10' , ''   , 'appType' , 'M', 'f_multiCombo');//Application Type 생성
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'' , 'keyBranch' , 'M', 'f_multiCombo'); //key-in Branch 생성
    doGetComboSepa('/common/selectBranchCodeList.do', '2' , ' - '  ,'' , 'dscBranch' , 'M', 'f_multiCombo');//Branch생성
    doGetComboAndGroup('/common/selectProductList.do', '' , ''   , 'product' , 'S', '');//product 생성
  

    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });  
    
    $("#custId").keyup(function() {
    	 var str = $("#custId").val();
    	 var pattern_special = /[~!@\#$%<>^&*\()\-=+_\’]/gi, pattern_eng = /[A-za-z]/g;

    	  if (pattern_special.test(str) || pattern_eng.test(str)) {
    		  $("#custId").val(str.replace(/[^0-9]/g, ""));
    	  }
    });
    
   $(function() {
  	   $("#orderStatus").multipleSelect("disable");
   });//AS-IS에서 1일 때만 체크해서 넘김, -> TO-BE에서 DB조회시 1과 일치하는 것만 검색해오게 함

    
});

function f_multiCombo() {
    $(function() {
        $('#appType').multipleSelect({
            selectAll : true, // 전체선택 
            width : '80%'
        }).multipleSelect("checkAll");
        
        $("#keyBranch").multipleSelect({
            width : '80%'
        });
        
        $("#dscBranch").multipleSelect({
            width : '80%'
        });
        
    });
}

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 25
};

var columnLayout=[
    {dataField:"orderid", headerText:"Order ID",visible : false},
    {dataField:"email", headerText:"Email",visible : false},
    {dataField:"orderno", headerText:"Order No"},
    {dataField:"orderstatuscode", headerText:"Status"},
    {dataField:"apptypecode", headerText:"App Type"},
    {dataField:"orderdate", headerText:"Order Date"},
    {dataField:"stockdesc", headerText:"Product"},
    {dataField:"customername", headerText:"Customer Name"},
    {dataField:"customeric", headerText:"NRIC/Company No"},
    {dataField:"creator", headerText:"Creator"},
    {dataField:"month" ,headerText:"Month",width: 100 , editable : false ,visible : false},
    {dataField:"year" ,headerText:"Year",width: 100 , editable : false ,visible : false}
];

function fn_getProformaInvoiceListAjax() {        
	var valid = ValidRequiredField();
	if(!valid){
		 Common.alert("* Please key in either Bill No or Order No.<br />");
	}else{
		Common.ajax("GET", "/payment/selectProformaInvoiceList.do", $("#searchForm").serialize(), function(result) {
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



//Layer close
hideViewPopup=function(val){   
  $(val).hide();
}


//Crystal Report Option Pop-UP
function fn_openDivPop(){
	
	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
	
	if (selectedItem[0] > -1){
		
		$('input:checkbox[name=boosterPump]').eq(0).attr("checked", false);
		$('input:radio[name=advance]').attr("checked", false);
		//$('input:radio[name=printMethod]').eq(0).attr("checked", false);
		
		$('#popup_wrap').show();
	}else{
		Common.alert('<b>No print type selected.</b>');
	}  
}

//크리스탈 레포트
function fn_generateStatement(){    
    //옵션 팝업 닫기
    $('#popup_wrap').hide();
    
	//report form에 parameter 세팅
	//옵션 초기화
    var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "month");
    var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "year");
    if( parseInt(year)*100 + parseInt(month) >= 201810){
        $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Performa_PDF_SST.rpt');
    }
    else {
        $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Performa_PDF.rpt');
    }
	$("#reportPDFForm #v_adv1Boolean").val(0);
    $("#reportPDFForm #v_adv2Boolean").val(0);
    $("#reportPDFForm #v_bustPump").val(0);
    
    //옵션 세팅
	$("#reportPDFForm #v_orderId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "orderid"));
	$("#reportPDFForm #viewType").val("PDF");
	
	if ($("#advance1").is(":checked")) $("#reportPDFForm #v_adv1Boolean").val(1);
    if ($("#advance2").is(":checked")) $("#reportPDFForm #v_adv2Boolean").val(1);
    if ($("#boosterPump").is(":checked")) $("#reportPDFForm #v_bustPump").val(1);    
    
        
        
	
	//report 호출
	//var option = {
	//	isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	//};
	
	//Common.report("reportPDFForm", option);
    Common.report("reportPDFForm");
	
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
	    //옵션 초기화
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "month");
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "year");
        if( parseInt(year)*100 + parseInt(month) >= 201810){
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Performa_PDF_SST.rpt');
        }
        else {
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Performa_PDF.rpt');
        }
	    $("#reportPDFForm #v_adv1Boolean").val(0);
	    $("#reportPDFForm #v_adv2Boolean").val(0);
	    $("#reportPDFForm #v_bustPump").val(0);
	    
	    //옵션 세팅
	    $("#reportPDFForm #v_orderId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "orderid"));
	    $("#reportPDFForm #viewType").val("MAIL_PDF");
	    
	    if ($("#advance1").is(":checked")) $("#reportPDFForm #v_adv1Boolean").val(1);
	    if ($("#advance2").is(":checked")) $("#reportPDFForm #v_adv2Boolean").val(1);
	    if ($("#boosterPump").is(":checked")) $("#reportPDFForm #v_bustPump").val(1); 
	    
	    
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
	    var emailTitle = "Proforma Invoice " + AUIGrid.getCellValue(myGridID, selectedGridValue, "orderid");
	    $("#reportPDFForm #emailSubject").val(emailTitle);
	    $("#reportPDFForm #emailText").val(message);
	    $("#reportPDFForm #emailTo").val($("#eInvoiceForm #send_email").val());

	    Common.report("reportPDFForm");
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
        <li>Proforma Invoice</li>
    </ul>
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2> Proforma Invoice</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_openDivPop();">Generate Invoice</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getProformaInvoiceListAjax();"><span class="search"></span>Search</a></p></li>
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
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:170px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Order No</th>
                        <td>
                            <input id="orderNo" name="orderNo" placeholder="Order Number" type="text" class="w100p" />
                        </td>
                        <th scope="row">Application Type</th>
                        <td>
                            <select id="appType" name="appType" class="multy_select w100p"></select>
                        </td>
                        <th scope="row">Order Date</th>
                        <td>
                           <div class="date_set w100p"><!-- date_set start -->
                           <p><input type="text" name="orderDt1" placeholder="DD/MM/YYYY" class="j_date" readonly/></p>
                           <span>To</span>
                           <p><input type="text" name="orderDt2" placeholder="DD/MM/YYYY" class="j_date" readonly/></p>
                           </div><!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Order Status</th>
                        <td>
                            <select id="orderStatus" name="orderStatus"  class="multy_select w100p" multiple="multiple">
                                <option value="1">Active</option>
                                <option value="4">Completed</option>
                                <option value="10">Cancelled</option>
                            </select>
                        </td>
                        <th scope="row">Key-In Branch</th>
                        <td>
                           <select id="keyBranch" name="keyBranch" class="multy_select w100p" multiple="multiple"></select>
                        </td>
                        <th scope="row">DSC Branch</th>
                        <td>
                           <select id="dscBranch" name="dscBranch" class="multy_select w100p" multiple="multiple"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer ID</th>
                        <td>
                            <input id="custId" name="custId" type="text" class="w100p" />
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                            <input id="dustName" name="custName" type="text" class="w100p" />
                        </td>
                        <th scope="row">NRIC/Company No</th>
                        <td>
                            <input id="custIc" name="custIc" type="text" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                    <th scope="row">Product</th>
                        <td>
                            <select id="product" name="product" class="w100p"></select>
                        </td>
                        <th scope="row">Salesman</th>
                        <td>
                            <input id="memberCode" name="memberCode" type="text" class="w100p" />
                        </td>
                        <th scope="row">Rental Status</th>
                        <td>
                            <select id="rentalStatus" name="rentalStatus" class="multy_select w100p" multiple="multiple" >
                                <option value="REG">Regular</option>
                                <option value="INV">Investigate</option>
                                <option value="SUS">Suspend</option>
                                <option value="RET">Return</option>
                                <option value="CAN">Cancel</option>
                                <option value="TER">Terminate</option>
                                <option value="WOF">Write Off</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Reference No</th>
                        <td>
                            <input id="refNo" name="refNo" type="text" class="w100p" />
                        </td>
                        <th scope="row">PO No</th>
                        <td>
                            <input id="poNo" name="poNo" type="text" class="w100p" />
                        </td>
                        <th scope="row">Contact No</th>
                        <td>
                            <input id="contactNo" name="contactNo" type="text" class="w100p" />
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
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_sendEStatementPop();">Send E-Statement</a></p></li>
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
    <input type="hidden" id="viewType" name="viewType" value="" />
    <input type="hidden" id="v_orderId" name="v_orderId" />    
    <input type="hidden" id="v_adv1Boolean" name="v_adv1Boolean" />
    <input type="hidden" id="v_adv2Boolean" name="v_adv2Boolean" />
    <input type="hidden" id="v_bustPump" name="v_bustPump" />
    <!-- 이메일 전송인 경우 모두 필수-->
    <input type="hidden" id="emailSubject" name="emailSubject" value="" />
    <input type="hidden" id="emailText" name="emailText" value="" />
    <input type="hidden" id="emailTo" name="emailTo" value="" /> 
</form>
<!--------------------------------------------------------------- 
    POP-UP (PRINT OPTION)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="popup_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>PRINT OPTION</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#popup_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    <!-- pop_body start -->
    <form name="optionForm" id="optionForm"  method="post">
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
	                        <th scope="row">Option</th>
	                        <td>
	                            <label><input type="checkbox" id="boosterPump" name="boosterPump"/><span>Booster Pump</span></label>
	                            <label><input type="radio" id="advance1" name="advance" /><span>Advanced 1 Year</span></label>
	                            <label><input type="radio" id="advance2" name="advance" /><span>Advanced 2 Year</span></label>
	                        </td>
	                    </tr>
	                   </tbody>  
	            </table>
	        </section>        
	        <ul class="center_btns" >
	            <li><p class="btn_blue2"><a href="javascript:fn_generateStatement();">Generate</a></p></li>
	        </ul>
	    </section>
    </form>       
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
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