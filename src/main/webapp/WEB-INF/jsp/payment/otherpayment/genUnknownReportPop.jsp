<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript">

var currentDate = new Date();
var dd = currentDate.getDate();
var mm = currentDate.getMonth() + 1;
var yyyy = currentDate.getFullYear();

$(document).ready(function(){
	var payModeCombo = "";

	if('${PAY_MODE}' == "105") {
		payModeCombo = "CASH";
	} else if('${PAY_MODE}' == "106") {
		payModeCombo = "CHQ";
	} else if('${PAY_MODE}' == "108") {
		payModeCombo = "ONLINE";
	}

	doGetCombo('/common/getAccountList.do', payModeCombo,'', 'bankAcc', 'S', '' );
});

function fn_generateReport(){

	console.log($("#trxBankDateFr").val());
	console.log($("#trxBankDateTo").val());

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    var d1Array = $("#trxBankDateFr").val().split("/");
    var d1 = new Date(d1Array[2] + "-" + d1Array[1] + "-" + d1Array[0]);
    var d2Array = $("#trxBankDateTo").val().split("/");
    var d2 = new Date(d2Array[2] + "-" + d2Array[1] + "-" + d2Array[0]);

    var dayDiff =  Math.floor((Date.UTC(d2.getFullYear(), d2.getMonth(), d2.getDate()) - Date.UTC(d1.getFullYear(), d1.getMonth(), d1.getDate()) ) /(1000 * 60 * 60 * 24));

    console.log(dayDiff);

    var whereSQL = '';

    if(dayDiff <= 30) {
        if($("#trxBankDateFr").val() != "") {
            whereSQL += " AND A.F_TRNSC_DT >= TO_DATE('" + $("#trxBankDateFr").val() + "', 'DD/MM/YYYY') ";
        } else {
            Common.alert("Please fill in transaction from date.");
        }

        if($("#trxBankDateTo").val() != "") {
            whereSQL += " AND A.F_TRNSC_DT < TO_DATE('" + $("#trxBankDateTo").val() + "', 'DD/MM/YYYY') + 1";
        } else {
            Common.alert("Please fill in transaction to date.");
        }

        if($("#bankAcc").val() != "") {
            whereSQL += " AND A.F_TRNSC_REM = '" + $("#bankAcc").val() + "' ";
        }

        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#reportDownFileName").val("Bank_Statement_Unknown"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportForm #v_WhereSQL").val(whereSQL);
        $("#reportForm #viewType").val("EXCEL");
        $("#reportForm #reportFileName").val("/payment/BankStmtUnknown.rpt");

        var option = {
                isProcedure : true
        };

        Common.report("reportForm", option);
    } else {
    	Common.alert("Date range must be or equal to 30 days.");
    }
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Generate Bank Statement Unknown Report</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="" onsubmit="return false;">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th>Bank In Date</th>
    <td>
    <!-- date_set start -->
        <div class="date_set">
            <p><input type="text" id="trxBankDateFr" name="trxBankDateFr" title="Bank In Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
            <span>To</span>
            <p><input type="text" id="trxBankDateTo" name="trxBankDateTo" title="Bank In End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div>
    <!-- date_set end -->
    </td>
    <th scope="row">Bank Account</th>
    <td><select class="w100p" id="bankAcc" name="bankAcc"></select></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_generateReport();">Generate Report</a></p></li>
</ul>

</form>
</section><!-- search_table end -->


</section><!-- content end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->

<form name="reportForm" id="reportForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="Excel" />
    <input type="hidden" id="v_WhereSQL" name="v_WhereSQL" value="" />
</form>