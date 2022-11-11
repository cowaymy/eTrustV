<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var instDtMM = new Date().getMonth()+1;

instDtMM = FormUtil.lpad(instDtMM, 2, "0");

$("#dataForm").empty();

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

function btnGeneratePDF_Click(){
    if(validRequiredField() == true){

        var orderNum = "";
        var custNm = "";
        var addrDtl = "";
        var addrStr = "";
        var postCode = "";
        var city = "";
        var area = "";
        var state = "";
        var country = "";
        var productName = "";
        var amtAftDisc = "";
        var custVaNo = "";
        var jomPayNo = "";
        var unbillDiscAmt = "";

        if($("#otOrdNo").val() != "" && $("#otOrdNo").val() != null){
            orderNum = $("#otOrdNo").val();
            custNm = $("#custName").val();
            addrDtl = $("#addrDtl").val();
            addrStr = $("#addrStr").val();
            postCode = $("#addrPostCode").val();
            city = $("#addrCity").val();
            area = $("#addrArea").val();
            state = $("#addrState").val();
            country = $("#addrCntry").val();
            productName = $("#prdType").val();
            amtAftDisc = $("#aftDisAmt").val();
            custVaNo = $("#custVaNo").val();
            jomPayNo = $("#ctJompay").val();
            unbillDiscAmt = $("#unbillDisc").val();
        }


        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");


        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }
        $("#reportDownFileName").val("PUBLIC_Outstanding Letter-"+orderNum+" "+custNm);
        $("#ReportForm #viewType").val("PDF");
        $("#ReportForm #reportFileName").val("/sales/outstandingLetter_V1.rpt");


        $("#ReportForm #V_ORDERNO").val(orderNum);
        $("#ReportForm #V_CUSTNAME").val(custNm);
        $("#ReportForm #V_ADDRDTL").val(addrDtl);
        $("#ReportForm #V_ADDRSTR").val(addrStr);
        $("#ReportForm #V_POSTCODE").val(postCode);
        $("#ReportForm #V_AREA").val(area);
        $("#ReportForm #V_CITY").val(city);
        $("#ReportForm #V_STATE").val(state);
        $("#ReportForm #V_COUNTRY").val(country);
        $("#ReportForm #V_PRODUCTTYPE").val(productName);
        $("#ReportForm #V_AMTAFTDIS").val(amtAftDisc);
        $("#ReportForm #V_CUSTVANO").val(custVaNo);
        $("#ReportForm #V_JOMPAY").val(jomPayNo);
        $("#ReportForm #V_UBLDISC").val(unbillDiscAmt);
        $("#ReportForm #V_DATE").val(date);


        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("ReportForm", option);

    }else{
        return false;
    }
}

function fn_validSearchLists() {
    var isValid = true, msg = "";

    if(FormUtil.isEmpty($('#otOrdNo').val())
    ) {
   	    isValid = false;
        msg += '* <spring:message code="sal.alert.msg.plzKeyinOrdNo" /><br/>';
       }

    if(!isValid) Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

    return isValid;
}

function fn_selectListAjaxs() {

    Common.ajax("GET", "/sales/order/selectOrderOutstandingList.do", $("#SearchForm").serialize(), function(result) {

        console.log(result);

	     if(result != null){
	    	 if(result.ordDtl.appTypeId == '66' && (result.ordDtl.currRentalStus == "SUS" || result.ordDtl.currRentalStus == "WOF" ||
	    		result.ordDtl.currRentalStus == "RET" || result.ordDtl.currRentalStus == "TER" || result.ordDtl.currRentalStus == "INV") ){
	    		 $("#totOtstnd").val(result.p1[0].ordTotOtstnd);
	             $("#ordId").val(result.ordId);
	             $("#odUblAmt").val(result.p1[0].ordUnbillAmt);
	             $("#custName").val(result.ordDtl.custName);
	             $("#addrDtl").val(result.ordDtl.instAddrDtl);
	             $("#addrStr").val(result.ordDtl.instStreet);
	             $("#addrArea").val(result.ordDtl.instArea);
	             $("#addrCity").val(result.ordDtl.instCity);
	             $("#addrCntry").val(result.ordDtl.instCountry);
	             $("#addrPostCode").val(result.ordDtl.instPostcode);
	             $("#addrState").val(result.ordDtl.instState);
	             $("#prdType").val(result.ordDtl.productType);
	             $("#salesOrdNo").val(result.ordDtl.salesOrdNo);
	             $("#custVaNo").val(result.ordDtl.vaNo);
	             $("#ctJompay").val(result.ordDtl.jompay);

	               $('#totOtstnd').change();
	               $('#unbillDisc').change();
	    	 }
	    	 else{
	    		 $("#totOtstnd").val("");
	    		 $("#ordId").val("");
	    		 $("#odUblAmt").val("");
	    		 $("#otOrdNo").val("");
	    		 $("#unbillDisc").val("");
	    		 $("#aftDisAmt").val("");
	    		 Common.alert("Invalid Order");
	             return false;
	    	 }


	     }

    });

}

function fn_removeComma(str) {
	 var tempstr = "";
	    var digit = str;

	    for (var x = 0; x < digit.length; x++) {
	     if (digit.charAt(x)!= ",") {
	       tempstr += digit.charAt(x);
	     }
	    }
	    return tempstr;
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function validRequiredField() {

    var valid = true;
    var message = "";

    if ($("#otOrdNo").val() == null || $("#otOrdNo").val().length == 0) {
        valid = false;
        message += 'Please search order.|!|';
    }

    if ($("#totOtstnd").val() == null || $("#totOtstnd").val().length == 0) {
        valid = false;
        message += 'Invalid Bill Outstanding Amount.|!|';
    }

    if (valid == false) {
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);

    }

    return valid;
}

$(function(){
    $('#btnLedger1').click(function() {

    	if($("#ordId").val() != null && $("#ordId").val() != "" ){
    	    Common.popupWin("SearchForm", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
    	}else{
    		   Common.alert("Please search order first before view order ledger.");
    		   return false;
    	}
    });
    $('#btnSrch1').click(function() {

        if(fn_validSearchLists()) fn_selectListAjaxs();

    });
    $('#totOtstnd').change(function() {

    	$("#unbillDisc").val(0);
    	$("#aftDisAmt").val($('#totOtstnd').val());

    });
    $('#unbillDisc').change(function() {
    	var format = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;

    	 if(format.test($("#unbillDisc").val())) {
    		 $("#unbillDisc").val(0);
             Common.alert("No special characters allowed on discount(%).");
             return false;
    	 }

        var outstandingValue = Number(fn_removeComma($('#totOtstnd').val()));
        var outstandAmt = Number(fn_removeComma($("#totOtstnd").val()));
        var unbillAmount = Number(fn_removeComma($("#odUblAmt").val()));
        var unbillDiscount = Number(fn_removeComma($("#unbillDisc").val()));
        var total = 0;

        if(unbillAmount <= 0){

            $("#unbillDisc").val(0);
            Common.alert("Unbill Amount is " + $("#odUblAmt").val() + ". No discount allowed.");
            return false;

        }else{
	         if(outstandingValue >= 0){
	          total = 0;
	  		  total = (unbillAmount - (unbillAmount * (unbillDiscount/100))) + outstandingValue;
	  		  total = total.toFixed(2);
       		  $("#aftDisAmt").val(numberWithCommas(total));

	        }else if(outstandingValue < 0){
	        	 total = 0;
	        	 total = ((unbillAmount - (outstandingValue * -1)) - ((unbillAmount - (outstandingValue * -1)) * (unbillDiscount/100))) ;
	        	 total = total.toFixed(2);
	        	 $("#aftDisAmt").val(numberWithCommas(total));
	        }
        }
    });
});

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Outstanding Letter</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="SearchForm" name="SearchForm" form action="#" method="post" >

<table class="type1"><!-- table start -->
<h3>Order Information</h3>
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.OrderNo'/></th>
    <td>
    <input id="otOrdNo" name="otOrdNo" type="text" title="Order No" placeholder="" class="w100p" />
    </td>

    <td colspan="3"  >
        <ul class="btns">
      <li>
        <p class="btn_grid">
         <a id="btnSrch1" href="#"><span class="search"></span><spring:message code="sales.Search"/></a>
        </p>
       </li>
      </ul>
      <ul class="btns">
      <li>
        <p class="btn_grid">
          <a id="btnLedger1" href="#"><spring:message code="sal.btn.ledger" /></a>
        </p>
       </li>
      </ul>
      <ul class="btns">
      <li>
        <p class="btn_grid">
          <a href="#" onClick="javascript: btnGeneratePDF_Click()">Print</a>
        </p>
       </li>
      </ul></td>
</tr>
<tr>
    <th scope="row">Bill Outstanding Amount</th>
    <td>
    <input id="totOtstnd" name="totOtstnd" type="text" title="Bill Outstanding Amount" placeholder="" class="w100p" readonly="readonly"/>
    </td>
    <td colspan="3" ></td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.unbillAmt'/></th>
    <td>
    <input id="odUblAmt" name="odUblAmt" type="text" title="Unbill Amount" placeholder="" class="w100p" readonly="readonly"/>
    </td>
    <td colspan="3" ></td>
</tr>
<tr><th scope="row" ></th></tr>
<tr><th scope="row" ></th></tr>
<tr><th scope="row" ></th></tr>
</tbody>
</table><!-- table end -->

<table class="type1"><!-- table start -->
<h3>Adjustment</h3>
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Unbill Discount(%)</th>
    <td>
    <input id="unbillDisc" name="unbillDisc" type="text" title="Unbill Discount" placeholder="" class="w100p" />
    </td>
    <td colspan="3" ></td>
</tr>
<tr>
    <th scope="row">After Discount Amount</th>
    <td>
    <input id="aftDisAmt" name="aftDisAmt" type="text" title="After Discount Amount" placeholder="" class="w100p" readonly="readonly"/>
    </td>
    <td colspan="3" ></td>
</tr>
</tbody>
</table><!-- table end -->

<input type="hidden" id="ordId" name="ordId">

</form>

<form id="ReportForm" name="ReportForm" form action="#" method="post" >

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="custName" name="custName" value="" />
<input type="hidden" id="addrDtl" name="addrDtl" value="" />
<input type="hidden" id="addrStr" name="addrStr" value="" />
<input type="hidden" id="addrArea" name="addrArea" value="" />
<input type="hidden" id="addrCity" name="addrCity" value="" />
<input type="hidden" id="addrCntry" name="addrCntry" value="" />
<input type="hidden" id="addrPostCode" name="addrPostCode" value="" />
<input type="hidden" id="addrState" name="addrState" value="" />
<input type="hidden" id="prdType" name="prdType" value="" />
<input type="hidden" id="salesOrdNo" name="salesOrdNo" value="" />
<input type="hidden" id="custVaNo" name="custVaNo" value="" />
<input type="hidden" id="ctJompay" name="ctJompay" value="" />
<input type="hidden" id="V_ORDERNO" name="V_ORDERNO" value="" />
<input type="hidden" id="V_CUSTNAME" name="V_CUSTNAME" value="" />
<input type="hidden" id="V_ADDRDTL" name="V_ADDRDTL" value="" />
<input type="hidden" id="V_ADDRSTR" name="V_ADDRSTR" value="" />
<input type="hidden" id="V_POSTCODE" name="V_POSTCODE" value="" />
<input type="hidden" id="V_AREA" name="V_AREA" value="" />
<input type="hidden" id="V_CITY" name="V_CITY" value="" />
<input type="hidden" id="V_STATE" name="V_STATE" value="" />
<input type="hidden" id="V_COUNTRY" name="V_COUNTRY" value="" />
<input type="hidden" id="V_PRODUCTTYPE" name="V_PRODUCTTYPE" value="" />
<input type="hidden" id="V_AMTAFTDIS" name="V_AMTAFTDIS" value="" />
<input type="hidden" id="V_CUSTVANO" name="V_CUSTVANO" value="" />
<input type="hidden" id="V_JOMPAY" name="V_JOMPAY" value="" />
<input type="hidden" id="V_UBLDISC" name="V_UBLDISC" value="" />
<input type="hidden" id="V_DATE" name="V_DATE" value="" />

</form>



</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->