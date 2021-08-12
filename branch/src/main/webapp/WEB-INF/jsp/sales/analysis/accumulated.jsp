<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

function fn_report(type) {

	if($("#yyyymmDate").val() == null || $("#yyyymmDate").val() == ''){
		Common.alert('<spring:message code="sal.alert.msg.keyInDate" />');
		return;
	}

	$("#V_INPUTDATE").val("01/"+$("#yyyymmDate").val());

	if(type == "PDF"){
		$("#viewType").val('PDF');
	}else if(type == "EXCEL"){
		$("#viewType").val('EXCEL');
	}else{
		return false;
	}

	if(dataForm.reportType.value=="0"){
		$("#reportFileName").val('/sales/AccumulatedAccReport_PDF_ver2.rpt');
		$("#reportDownFileName").val("AccumulatedAccReport_" + $("#V_INPUTDATE").val());
	}else if(dataForm.reportType.value=="1"){
		$("#reportFileName").val('/sales/AccumulatedAccReport_REN_Opt_Details_PDF.rpt');
        $("#reportDownFileName").val("AccumulatedAccReportRenOperationLeaseDetails_" + $("#V_INPUTDATE").val());
	}else if(dataForm.reportType.value=="2"){
        $("#reportFileName").val('/sales/AccumulatedAccReport_REN_Fin_Details_PDF.rpt');
        $("#reportDownFileName").val("AccumulatedAccReportRenFinanceLeaseDetails_" + $("#V_INPUTDATE").val());
	}else if(dataForm.reportType.value=="3"){
		$("#reportFileName").val('/sales/AccMembershipDetail_PDF.rpt');
        $("#reportDownFileName").val("AccumulatedMembershipReportDetails_" + $("#V_INPUTDATE").val());
	}

//	alert($("#V_INPUTDATE").val());

	var option = {
        isProcedure : true
    };

    Common.report("dataForm", option);
}

$(function(){

$("#btn1").click(function() {

    fn_report1();
});

$("#btn2").click(function() {

    fn_report2();
});

$("#btn3").click(function() {

    fn_report3();
});

$("#btn4").click(function() {

    fn_report4();
});

$("#btn5").click(function() {

    fn_report5();
});

$("#btn6").click(function() {

    fn_report6();
});

$("#btn7").click(function() {

    fn_report7();
});

$("#btn8").click(function() {

    fn_report8();
});

$("#btn9").click(function() {

    fn_report9();
});
});


function fn_report1() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm1", option);
}

function fn_report2() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm2", option);
}

function fn_report3() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm3", option);
}

function fn_report4() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm4", option);
}

function fn_report5() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm5", option);
}

function fn_report6() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm6", option);
}

function fn_report7() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm7", option);
}

function fn_report8() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm8", option);
}

function fn_report9() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm9", option);
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.accumulatedAccRpt" /></h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="dataForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccReport_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="V_INPUTDATE" name="V_INPUTDATE" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.reportType" /></th>
    <td>
    <select class="w100p" id="reportType" name="reportType">
        <option value="0"><spring:message code="sal.combo.text.rptAccumulatedAcc" /></option>
        <option value="1">Report Rental Operating Lease Details Account</option>
        <option value="2">Report Rental Finance Lease Details Account</option>
        <option value="3"><spring:message code="sal.combo.text.rptMemDetAcc" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.date" /></th>
    <td><input type="text" id="yyyymmDate" name="yyyymmDate"  placeholder="DD/MM/YYYY" class="j_date2 w100p" /></td>
</tr>
<tr>
    <td colspan="2"><p><span><spring:message code="sal.title.text.valReqDate" /></span></p></td>
</tr>
</tbody>
</table><!-- table end -->


<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt><spring:message code="sal.title.text.link" /></dt>
        <dd>
        <ul class="btns">
            <li><p class="link_btn"><a href="#" id="btn1">Accumulated Account Rental Operating Lease Raw</a></p></li>
            <li><p class="link_btn"><a href="#" id="btn2">Accumulated Account Rental Finance Lease Raw</a></p></li>
            <li><p class="link_btn"><a href="#" id="btn3">Accumulated Account Membership Raw</a></p></li>
        </ul>

        <ul class="btns">
            <li><p class="link_btn"><a href="#" id="btn4">Accumulated Account Outright Raw</a></p></li>
            <li><p class="link_btn"><a href="#" id="btn5">Rental Operating Lease Details Opening/New Raw</a></p></li>
            <li><p class="link_btn"><a href="#" id="btn6">Rental Operating Lease Details Others Raw</a></p></li>
        </ul>

        <ul class="btns">
            <li><p class="link_btn"><a href="#" id="btn7">Rental Finance Lease Details Opening/New Raw</a></p></li>
            <li><p class="link_btn"><a href="#" id="btn8">Rental Finance Lease Details Others Raw</a></p></li>
            <li><p class="link_btn"><a href="#" id="btn9">Membership Details Raw</a></p></li>
        </ul>


        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->



</form>

<form id="dataForm1">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccRentalOprtgLease_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
<form id="dataForm2">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccRentalFinLease_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
<form id="dataForm3">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccMembership_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
<form id="dataForm4">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccOutright_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
<form id="dataForm5">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccReport_REN_Opt_Details_Opening_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
<form id="dataForm6">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccReport_REN_Opt_Details_Others_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
<form id="dataForm7">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccReport_REN_Fin_Details_Opening_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
<form id="dataForm8">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccReport_REN_Fin_Details_Others_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
<form id="dataForm9">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccMembershipDetail_Excel.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" /><!-- View Type  -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report('PDF');"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report('EXCEL');"><spring:message code="sal.btn.genExcel" /></a></p></li>
</ul>

</section><!-- content end -->