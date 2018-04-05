<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$.fn.clearForm = function() {

    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if(type === 'checkbox') {
            this.checked = false;
        }
        else if (tag === 'select'){
            this.selectedIndex = 0;
        }

    });
};

function btnGenerate_Click(){
        fn_report("PDF");
}

function btnGenerate_Excel_Click(){
           fn_report("EXCEL");
}

function fn_report(viewType){

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    var whereSQL = '';
    var whereSQL2 = '';

    // Rental Status
    if($("#cmbRentalStatus").val() != "" && $("#cmbRentalStatus").val() != "null") {
        whereSQL += "AND RS.STUS_CODE_ID = '" + $("#cmbRentalStatus").val() + "' ";
    }

    // Paymode
    if($("#paymode").val() != "" && $("#paymode").val() != "null") {
        whereSQL += "AND R.MODE_ID = '" + $("#paymode").val() + "' ";
    }

    // Customer Type
    if($("#customerType").val() != "" && $("#customerType").val() != "null") {
        whereSQL += "AND C.TYPE_ID = '" + $("#customerType").val() + "' ";
    }

    // Enrolment
    if($("#enrolment").val() == "1") {
        whereSQL += "AND (ADD_MONTHS(R.DD_REJCT_DT, 6) >= SYSDATE)";
    } else if($("#enrolment").val() == "2") {
        whereSQL += "AND (R.DD_REJCT_DT <> null and R.DD_REJCT_DT <> '1/1/1900')";
    }

    // Aging Month
    if($("#txtAgingMonthFr").val().trim() != "") {
        whereSQL2 += "AND t1.CurrentMthAging >= " + $("#txtAgingMonthFr").val().trim() + " ";
    }

    if($("#txtAgingMonthTo").val().trim() != "") {
        whereSQL2 += "AND t1.CurrentMthAging < " + $("#txtAgingMonthTo").val().trim() + " ";
    }

    // Deduction Status
    if($("#deductionStus").is(":checked")) {
        whereSQL2 += "AND t2.DeductionStatusID = " + $("#deductionStus").val() + " ";
    }

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    $("#reportDownFileName").val("SMSRawData_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#form #reportFileName").val("/logistics/SMSRawData.rpt");

    if(viewType == "PDF"){
        $("#form #viewType").val("PDF");
    }else if(viewType == "EXCEL"){
        $("#form #viewType").val("EXCEL");
    }

    $("#form #v_WhereSQL1").val(whereSQL);
    $("#form #v_WhereSQL2").val(whereSQL2);

    console.log(whereSQL);
    console.log(whereSQL2);

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

}

var rentalStus = [{"codeId":"REG","codeName":"REG"},{"codeId":"INV","codeName":"INV"},{"codeId":"SUS","codeName":"SUS"},{"codeId":"RET","codeName":"RET"}]
doDefCombo(rentalStus, '', 'cmbRentalStatus', 'S', '');

CommonCombo.make("customerType", "/common/selectCodeList.do", {groupCode : '8'}, null, null);
CommonCombo.make("enrolment", "/logistics/sms/selectEnrolmentFilter.do", '' , '');

var paymode = [{"codeId":"130","codeName":"Regular"},{"codeId":"131","codeName":"Credit Card"},{"codeId":"132","codeName":"Direct Debit"}];
doDefCombo(paymode, '', 'paymode', 'S', '');

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>SMS Raw Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form" name="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Rental Status</th>
    <td>
        <select id="cmbRentalStatus" name="cmbRentalStatus" class="w100p"></select>
    </td>
    <th scope="row">Aging Month</th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
            <p><input type="text" title="" placeholder="" class="w100p" id="txtAgingMonthFr"/></p>
            <span><spring:message code="sal.title.to" /></span>
            <p><input type="text" title="" placeholder="" class="w100p" id="txtAgingMonthTo"/></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Paymode</th>
    <td>
        <select id="paymode" name="paymode" class="w100p"></select>
    </td>
    <th scope="row">Failed Deduction Status</th>
    <td>
        <p><input type="checkbox" id="deductionStus" name="deductionStus" value="8">Failed</input></p>
    </td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
        <td>
            <select class="w100p" id="customerType"></select>
        </td>
    <th scope="row">Enrolment</th>
    <td>
            <select class="100p" id="enrolment"></select>
    </td>
</tr>
<tr>
    <th scope="row" colspan="4">Race : Non-Korean || Order Status : Completed || Application Type : Rental</th>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:btnGenerate_Click();"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:btnGenerate_Excel_Click();"><spring:message code="sal.btn.genExcel" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />


<input type="hidden" id="v_WhereSQL1" name="v_WhereSQL1" value="" />
<input type="hidden" id="v_WhereSQL2" name="v_WhereSQL2" value="" />

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->