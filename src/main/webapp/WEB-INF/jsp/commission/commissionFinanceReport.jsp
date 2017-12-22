<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
	//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
	today = "${today}";
	
	$(document).ready(function() {

		//form clear
		$("#clear").click(function() {
			$("#searchForm")[0].reset();
			$("#reportType").trigger("change");
		});

		//change report type box
		$("#reportType").change(function() {
			val = $(this).val();
			var $reportForm = $("#reportForm")[0];
			$($reportForm).empty(); //remove children		
		});

		// search member code
		$('#generate').click(function() {
			var $reportForm = $("#reportForm")[0];

			$($reportForm).empty(); //remove children
			var type = $("#reportType").val(); //report type
			var cmmDt = $("#searchForm #cmmDt").val(); //commission date
			 
			if (type == "") {
				//Common.alert("Please select Report Type ");
				Common.alert("<spring:message code='commission.alert.report.selectType'/>");
				return;
			} else if (cmmDt == "") {
				//Common.alert("Please select Commission Period ");
				Common.alert("<spring:message code='commission.alert.report.selectPeriod'/>");
				return;
		  } 

			var reportDownFileName = ""; //download report name
			var reportFileName = ""; //reportFileName
			var reportViewType = ""; //viewType

			//default input setting
			$($reportForm).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name		  
			$($reportForm).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
			$($reportForm).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type
			var month = Number(cmmDt.substring(0, 2));
			var year = Number(cmmDt.substring(3));
			var taskID = month + (year * 12) - 24157; //taskId

			if (type == "4") {	
				reportFileName = "/commission/AllCommissionRawDate_Excel.rpt"; //reportFileName				
				reportDownFileName = "AllCommissionRawDate_Excel_" + today; //report name			
				reportViewType = "EXCEL"; //viewType

				//set parameters
				$($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');	
				$("#reportForm #TaskID").val(taskID);
			} else if (type == "10") {

				reportFileName = "/commission/SalesPVReport_Excel.rpt"; //reportFileName
				reportDownFileName = "SalesPV_Excel_" + today; //report name     
				reportViewType = "EXCEL"; //viewType

				//set parameters		
				$($reportForm).append('<input type="hidden" id="PvMth" name="PvMth" value="" /> ');
				$($reportForm).append('<input type="hidden" id="PvYear" name="PvYear" value="" /> ');
				$("#reportForm #PvMth").val(month);
				$("#reportForm #PvYear").val(year);

			} else if (type == "12") {

				reportFileName = "/commission/AdvPayRawData_Excel.rpt"; //reportFileName
				reportDownFileName = "AdvPayment_Excel_" + today; //report name     
				reportViewType = "EXCEL"; //viewType

				//set parameters			
		    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');	
		 
	      $("#reportForm #TaskID").val(taskID);

			}
			
			//report info
			if (reportFileName == "" || reportDownFileName == "" || reportViewType == "") {
				Common.alert("<spring:message code='sys.common.alert.validation' arguments='Report Info' htmlEscape='false'/>");
				return;
			}

			//default setting
			$("#reportForm #reportFileName").val(reportFileName);
			$("#reportForm #reportDownFileName").val(reportDownFileName);
			$("#reportForm #viewType").val(reportViewType);

			//  report 호출
			var option = {
				isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
			};
			Common.report("reportForm", option);		
			  
		});

	});

</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li><spring:message code='commission.text.head.commission'/></li>
		<li><spring:message code='commission.text.head.report'/></li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2><spring:message code='commission.title.finance'/></h2>
	</aside>
	<!-- title_line end -->


	<section class="search_table">
		<!-- search_table start -->
		<form name="searchForm" id="searchForm" method="post">
			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 170px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message code='commission.text.search.reportType'/></th>
						<td colspan="3"><select id="reportType" name="reportType">
								<option value="">Report/Raw Data Type</option>
								<option value="4">Finance Commisision</option>
								<option value="10">Sales PV Report</option>								
								<option value="12">Advanced Payment Report</option>							
						</select></td>
					</tr>					
					<tr>
						<th scope="row"><spring:message code='commission.text.search.period'/></th>
						<td colspan="3"><input type="text" id="cmmDt" name="cmmDt" title="Date" class="j_date2" value="${cmmDt }" /></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->

			<ul class="center_btns">
				<li><p class="btn_blue2 big">
						<a href="#" id="generate" id="generate"><spring:message code='commission.button.generate'/></a>
					</p></li>
				<li><p class="btn_blue2 big">
						<a href="#" id="clear" name="clear"><spring:message code='sys.btn.clear'/></a>
					</p></li>
			</ul>

		</form>
	</section>
</section>
<!-- search_table end -->
<!-- content end -->
<form name="reportForm" id="reportForm" method="post"></form>