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
    {dataField:"salesOrdId", headerText:"<spring:message code='pay.head.orderId'/>",visible : false},
//     {dataField:"email", headerText:"<spring:message code='pay.head.email'/>",visible : false},
    {dataField:"salesOrdNo", headerText:"<spring:message code='pay.head.orderNo'/>"},
    {dataField:"stusCodeNm", headerText:"<spring:message code='pay.head.status'/>"},
    {dataField:"appTypeNm", headerText:"<spring:message code='pay.head.appType'/>"},
    {dataField:"orderdate", headerText:"<spring:message code='pay.head.orderDate'/>"},
    {dataField:"stkDesc", headerText:"<spring:message code='pay.head.product'/>"},
    {dataField:"custNm", headerText:"<spring:message code='pay.head.custName'/>"},
    {dataField:"nric", headerText:"<spring:message code='pay.head.nricCompanyNo'/>"},
//     {dataField:"creator", headerText:"<spring:message code='pay.head.creator'/>"},
//     {dataField:"month" ,headerText:"Month",width: 100 , editable : false ,visible : false},
//     {dataField:"year" ,headerText:"Year",width: 100 , editable : false ,visible : false}
];

$(document).ready(function(){

        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

//         doGetCombo('/common/selectCodeList.do', '10' , ''   , 'appType' , 'M', 'f_multiCombo');//Application Type 생성
        doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'' , 'keyBranch' , 'M', 'f_multiCombo'); //key-in Branch 생성
//         doGetComboSepa('/common/selectBranchCodeList.do', '2' , ' - '  ,'' , 'dscBranch' , 'M', 'f_multiCombo');//Branch생성
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

        $('#rentalStatus').multipleSelect({
            //selectAll : true, // 전체선택
            width : '80%'
        })

    });
}


function fn_getAdvancedRentalInvoiceListAjax() {
    var valid = ValidRequiredField();
//     if(!valid){
//         Common.alert("* Please key in Order No.");
//     }else{
        Common.ajax("GET", "/payment/selectAdvancedRentalInvoiceList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
//     }
}

function ValidRequiredField(){
    var valid = true;

    if( $("#salesOrderNo").val() == "")
        valid = false;

    return valid;
}



//Layer close
hideViewPopup=function(val){
  $(val).hide();
}


//Crystal Report Option Pop-UP
function fn_openDivPop(){


    var salesOrderId = AUIGrid.getCellValue(myGridID, 0, "salesOrdId");

    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1){

     Common.ajax("GET", "/payment/selectProductBasicInfo.do",  {salesOrderId: salesOrderId}, function(result) {

     if(result[0].rentalStus !="REG"){
    	   Common.alert("Only allow to generate the order with status in REG.");
     }
     else {
    	   Common.ajax("GET", "/payment/selectProductUsageMonth.do",  {salesOrderId: salesOrderId}, function(result1) {
    		   if(result1[0].productUsageMonth >= 49){
    			   Common.alert("Cannot generate for order with the usage period more than 49 months (due to installment left less than 12 months)");
    			   }
    		   else{

    			   Common.ajax("GET", "/payment/getOderOutsInfo.do",  {ordId: salesOrderId}, function(result2) {

    				      if(result2[0].ordTotOtstnd > 0){
    				    	   Common.alert("Order with outstanding balance not allow to generate the quotation");
    				    	  }
    				      else{

    				    	   if(result[0].advDisc ==0){
    				    		   document.getElementById("advance1").disabled = true;
    				    		   document.getElementById("advance2").disabled = true;
    				    		     }
    				    	   else{
    				    		   document.getElementById("advance1").disabled = false;
    				    		   document.getElementById("advance2").disabled = false;
    				    		     }

    				    	   $('input:radio[name=advance]').attr("checked", false);
    				    	   $('input:radio[name=printMethod]').eq(0).attr("checked", false);

    				    	   $('#popup_wrap2').show();
    				    	}
    				    });
    			    }
    		   });
    	    }
        });
     }
    else{
    Common.alert("<spring:message code='pay.alert.noPrintType'/>");
    }

}

//크리스탈 레포트
function fn_generateStatement(){


    //옵션 팝업 닫기
    $('#popup_wrap2').hide();

    //report form에 parameter 세팅
    //옵션 초기화

    var salesOrderId = AUIGrid.getCellValue(myGridID, 0, "salesOrdId");

    var userId;

    Common.ajaxSync("GET", "/login/getLoginDtls.do", {}, function (result) {

        userId = result.userId;

    });



	var selectedItem = AUIGrid.getSelectedIndex(myGridID);

		if (selectedItem[0] > -1) {

// 			$('input:radio[name=advance]').attr("checked", false);
			$('input:radio[name=printMethod]').eq(0).attr("checked", false);

			$('#popup_wrap2').show();
		} else {
			Common.alert("<spring:message code='pay.alert.noPrintType'/>");
		}

		$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_AdvancedRentalInvoice_PDF.rpt');

		$("#reportPDFForm #v_adv1Boolean").val(0);
		$("#reportPDFForm #v_adv2Boolean").val(0);
		$("#reportPDFForm #v_noadv1Boolean").val(0);
		$("#reportPDFForm #v_noadv2Boolean").val(0);

		//옵션 세팅
		$("#reportPDFForm #v_orderId").val(salesOrderId);
		$("#reportPDFForm #v_creatorId").val(userId);
		$("#reportPDFForm #viewType").val("PDF");
		$("#reportPDFForm #reportDownFileName").val('PUBLIC_TaxInvoice_AdvancedRentalInvoice');

		if ($("#advance1").is(":checked"))
			$("#reportPDFForm #v_adv1Boolean").val(1);
		if ($("#advance2").is(":checked"))
			$("#reportPDFForm #v_adv2Boolean").val(1);
		if ($("#no_advance1").is(":checked"))
			$("#reportPDFForm #v_noadv1Boolean").val(1);
		if ($("#no_advance2").is(":checked"))
			$("#reportPDFForm #v_noadv2Boolean").val(1);

		Common.report("reportPDFForm");

	}

	//Layer close
	hideViewPopup = function(val) {
		$(val).hide();
	}

	function fn_clear() {
		$("#searchForm")[0].reset();
		AUIGrid.clearGridData(myGridID);
	}
</script>


<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>AdvancedInvoiceQuotationRental</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
  <form id="frmLedger" name="frmLedger" action="#" method="post">
            <input id="ordId" name="ordId" type="hidden" value="" />
        </form>
<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_openDivPop();"><spring:message code='pay.btn.invoice.generate'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getAdvancedRentalInvoiceListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
        	<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
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
                            <input id="salesOrderNo" name="orderNo" placeholder="Order Number" type="text" class="w100p" />
                        </td>
                        <th scope="row">Order Date</th>
                        <td>
                           <div class="date_set w100p"><!-- date_set start -->
                           <p><input type="text" name="orderDt1" placeholder="dd/MM/yyyy" class="j_date" readonly/></p>
                           <span>To</span>
                           <p><input type="text" name="orderDt2" placeholder="dd/MM/yyyy" class="j_date" readonly/></p>
                           </div><!-- date_set end -->
                        </td>

                        <th scope="row">Key-In Branch</th>
                        <td>
                           <select id="keyBranch" name="keyBranch" class="multy_select w100p" multiple="multiple"></select>
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
                        </td>                        <th scope="row">Rental Status</th>
                        <td>
                            <select id="rentalStatus" name="rentalStatus" class="multy_select w100p" multiple="multiple" >
                                <option value="REG">Regular</option>
<!--                                 <option value="INV">Investigate</option> -->
<!--                                 <option value="SUS">Suspend</option> -->
<!--                                 <option value="RET">Return</option> -->
<!--                                 <option value="CAN">Cancel</option> -->
<!--                                 <option value="TER">Terminate</option> -->
<!--                                 <option value="WOF">Write Off</option> -->
                            </select>
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
    <input type="hidden" id="v_orderId" name="v_orderId" />
    <input type="hidden" id="v_creatorId" name="v_creatorId" />
    <input type="hidden" id="v_adv1Boolean" name="v_adv1Boolean" />
    <input type="hidden" id="v_adv2Boolean" name="v_adv2Boolean" />
    <input type="hidden" id="v_noadv1Boolean" name="v_noadv1Boolean" />
    <input type="hidden" id="v_noadv2Boolean" name="v_noadv2Boolean" />
<!--     <input type="hidden" id="v_bustPump" name="v_bustPump" /> -->
    <!-- 이메일 전송인 경우 모두 필수-->
    <input type="hidden" id="emailSubject" name="emailSubject" value="" />
    <input type="hidden" id="emailText" name="emailText" value="" />
    <input type="hidden" id="emailTo" name="emailTo" value="" />
    <input type="hidden" id ="reportDownFileName" name="reportDownFileName" value=""/>
</form>
</div>
<!---------------------------------------------------------------
    POP-UP (PRINT OPTION)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="popup_wrap2" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>PRINT OPTION</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#popup_wrap2')"><spring:message code='sys.btn.close'/></a></p></li>
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
<!--                                 <label><input type="checkbox" id="boosterPump" name="boosterPump"/><span>Booster Pump</span></label> -->

                                <label><input type="radio" id="advance1" name="advance" /><span>Advanced 1 Year</span></label>
                                <label><input type="radio" id="advance2" name="advance" /><span>Advanced 2 Year</span></label>
                                <label><input type="radio" id="no_advance1" name="advance" /><span>Without Discount (1 year adv)</span></label>
                                <label><input type="radio" id="no_advance2" name="advance" /><span>Without Discount (2 years adv)</span></label>
                            </td>
                        </tr>
                       </tbody>
                </table>
            </section>
            <ul class="center_btns" >
                <li><p class="btn_blue2"><a href="javascript:fn_generateStatement();"><spring:message code='pay.btn.generate'/></a></p></li>
            </ul>
        </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
