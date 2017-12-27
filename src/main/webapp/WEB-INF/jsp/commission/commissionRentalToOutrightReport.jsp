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
		});		

		// search member code
		$('#generate').click(function() {
			var $reportForm = $("#reportForm")[0];

			$($reportForm).empty(); //remove children			
			var cmmDt = $("#searchForm #cmmDt").val(); //commission date
			 
		 if (cmmDt == "") {
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

			reportFileName = "/commission/RentalToOutrightRawData.rpt"; //reportFileName				
			reportDownFileName = "RentalToOutrightRaw_" + today; //report name			
			reportViewType = "EXCEL"; //viewType

			//set parameters
			$($reportForm).append('<input type="hidden" id="V_CONVERTMONTH" name="V_CONVERTMONTH" value="" /> ');	
			$($reportForm).append('<input type="hidden" id="V_CONVERTYEAR" name="V_CONVERTYEAR" value="" /> ');	
			$("#reportForm #V_CONVERTYEAR").val(year);
			$("#reportForm #V_CONVERTMONTH").val(month);
			
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
				isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
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
		<li><spring:message code='commission.text.head.rentalToOutrightReport'/></li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2><spring:message code='commission.title.rentalToOutright'/></h2>
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
				</colgroup>
				<tbody>				
					<tr>
						<th scope="row"><spring:message code='commission.text.search.period'/></th>
						<td><input type="text" id="cmmDt" name="cmmDt" title="Date" class="j_date2" value="${cmmDt }" /></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->

			<ul class="center_btns">
                <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
					<li><p class="btn_blue2 big">
							<a href="#" id="generate" id="generate"><spring:message code='commission.button.generate'/></a>
						</p></li>
                </c:if>
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