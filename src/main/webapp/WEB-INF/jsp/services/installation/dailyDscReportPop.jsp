<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
function fn_Validation(){
	if($("#crtDt").val() != '' || $("#endDt").val() != ''){
        if($("#crtDt").val() == '' || $("#endDt").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#pvMonth").val() == ''){
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='PV month' htmlEscape='false'/>");
        return false;
	}
	return true;
}

function fn_openReport(reportType){
	if(fn_Validation()){
		var date = new Date();
        var month = date.getMonth()+1;
        var day = "";
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }
		var startDate = "";
		var endDate = "";
		var pvMonth = 0;
		var pvYear = 0;
		var array = $("#pvMonth").val().split('/');
		var startDateArray =  $("#crtDt").val().split('/');
		var endDateArray =  $("#endDt").val().split('/');
		startDate = startDateArray[2] + "-" + startDateArray[1] + "-" + startDateArray[0];
		endDate =  endDateArray[2] + "-" + endDateArray[1] + "-" + endDateArray[0];
		pvMonth = parseInt($("#pvMonth").val().substring(0,2));
		pvYear = parseInt($("#pvMonth").val().substring(3,7));
		var reportPath = "";
		var reportTitle = "DailyDSCReport_" +day+month+date.getFullYear();
		
		if(reportType == "PDF" || reportType == "EXCELFORM"){
			reportPath = "/services/NetSalesReport_PDF_2.rpt";
		}else{
			reportPath = "/services/NetSalesReport_Excel_2.rpt";
		}
		 $("#reportForm #V_STARTDATE").val(startDate);
		 $("#reportForm #V_ENDDATE").val(endDate);
		 $("#reportForm #V_PVMONTH").val(pvMonth);
		 $("#reportForm #V_PVYEAR").val(pvYear);
		 $("#reportForm #reportFileName").val(reportPath);
		 $("#reportForm #viewType").val(reportType);
		 $("#reportForm #reportDownFileName").val(reportTitle);
		 
		 
		 //report 호출
	     var option = {
	             isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	     };
	     
	     Common.report("reportForm", option);
	}
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Daily DSC Report</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Date</th>
    <td>

    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="crtDt" name="crtDt" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row">PV Month</th>
    <td>
    <input type="text" title="기준년월" class="j_date2 w100p" id="pvMonth" name="pvMonth"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<form action="#" id="reportForm" method="post">
<input type="hidden" id="V_STARTDATE" name="V_STARTDATE" />
<input type="hidden" id="V_ENDDATE" name="V_ENDDATE" />
<input type="hidden" id="V_PVMONTH" name="V_PVMONTH" />
<input type="hidden" id="V_PVYEAR" name="V_PVYEAR" />
<input type="hidden" id="v_startdate" name="v_startdate" />
<input type="hidden" id="v_enddate" name="v_enddate" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport('PDF');">Generate PDF</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport('EXCEL');">Generate Excel</a></p></li>
    <!-- <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport('EXCELFORM');">Generate PDF In Excel</a></p></li> -->
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
