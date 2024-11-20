<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$("#dataForm").empty();

var nowMonth = new Date().getMonth();

nowMonth = FormUtil.lpad(nowMonth, 2, "0");

$("#mypSalesMonth").val(nowMonth+"/"+new Date().getFullYear());

function btnGenerate_Click(){
	
	if(!($("#mypSalesMonth").val() == null || $("#mypSalesMonth").val().length == 0)){
		fn_report();
	}else{
		Common.alert('<spring:message code="sal.alert.msg.plzSelSalesMonth" />');
	}
}

function fn_report(){
	
	$("#reportFileName").val("");
	$("#reportDownFileName").val("");
	var whereSQL = "";
	
	var salesMonth = parseInt($("#mypSalesMonth").val().substring(0, 2));
	var salesYear = parseInt($("#mypSalesMonth").val().substring(3, 7));
	
	$("#V_MONTH").val(salesMonth);
	$("#V_YEAR").val(salesYear);	
	
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    whereSQL += " AND TO_DATE(TO_CHAR(som.PV_YEAR) || '/' || LPAD(TO_CHAR(som.PV_MONTH),2,'0') || '/' || '01','YYYY/MM/DD') BETWEEN ADD_MONTHS(TO_DATE(TO_CHAR(" + salesYear+ ") || '/' || LPAD(TO_CHAR(" + salesMonth+ "),2,'0') || '/' || '01','YYYY/MM/DD'), -1) AND TO_DATE(TO_CHAR(" + salesYear + ") || '/' || LPAD(TO_CHAR(" + salesMonth+ "),2,'0') || '/' || '01','YYYY/MM/DD') ";
    if("${SESSION_INFO.roleId}" == 256) {
        whereSQL += " AND som.BRNCH_ID = "+"${SESSION_INFO.userBranchId}"+" ";
    }
    
	$("#form #reportDownFileName").val("ASOSalesReport_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	$("#form #reportFileName").val("/sales/ASONetSalesReport.rpt");
	$("#form #viewType").val("PDF");
	$("#V_WHERESQL").val(whereSQL);

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);
	
}
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.text.title.asoSalesReport" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.salesMonth" /></th>
    <td><input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="mypSalesMonth"/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click();"><spring:message code="sal.btn.generateRpt" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="PDF" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_MONTH" name="V_MONTH" value="" />
<input type="hidden" id="V_YEAR" name="V_YEAR" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->