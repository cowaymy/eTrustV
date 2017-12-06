<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

function fn_report(type) {
	
	$("#V_INPUTDATE").val("01/"+$("#yyyymmDate").val());
	
	if(type == "PDF"){
		$("#viewType").val('PDF');
	}else if(type == "EXCEL"){
		$("#viewType").val('EXCEL');
	}else{
		return false;
	}
	
	if(dataForm.reportType.value=="0"){
		$("#reportFileName").val('/sales/AccumulatedAccReport_PDF.rpt');
		$("#reportDownFileName").val("AccumulatedAccReport_" + $("#V_INPUTDATE").val());
	}else if(dataForm.reportType.value=="1"){
		$("#reportFileName").val('/sales/AccumulatedAccReport_REN_Details_PDF.rpt');
        $("#reportDownFileName").val("AccumulatedAccReportRenDetails_" + $("#V_INPUTDATE").val());
	}else if(dataForm.reportType.value=="2"){
		$("#reportFileName").val('/sales/AccMembershipDetail_PDF.rpt');
        $("#reportDownFileName").val("AccumulatedMembershipReportDetails_" + $("#V_INPUTDATE").val());
	}
	
//	alert($("#V_INPUTDATE").val());
	
	var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("dataForm", option);
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
<h2>Accumulated Account Report</h2>
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
    <th scope="row">Report Type</th>
    <td>
    <select class="w100p" id="reportType" name="reportType">
        <option value="0">Report Accumulated Account</option>
        <option value="1">Report Rental Details Account</option>
        <option value="2">Report Membershipsales Details Account</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Date</th>
    <td><input type="text" id="yyyymmDate" name="yyyymmDate" title="기준년월" placeholder="DD/MM/YYYY" class="j_date2 w100p" /></td>
</tr>
<tr>
    <td colspan="2"><p><span>(Valid report date : Start on 1/1/2013 onwards)</span></p></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report('PDF');">Generate In PDF</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report('EXCEL');">Generate In Excel</a></p></li>
    <li><p class="btn_blue2"><a href="#">Clear</a></p></li>
</ul>

</section><!-- content end -->