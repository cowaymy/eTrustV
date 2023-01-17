<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
	//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
	today = "${today}";
	$(document)
			.ready(
					function() {

						//form clear
						$("#clear").click(function() {
							$("#searchForm")[0].reset();
						});

						// search member code
						$('#generate')
								.click(
										function() {
											var $reportForm = $("#reportForm")[0];

											$($reportForm).empty(); //remove children
											var memCode = $(
													"#searchForm [name=memCode]")
													.val(); //member code
											var cmmYear = $(
													"#searchForm [name=cmmYear]")
													.val(); //commission year

											if (memCode == "") {
												Common
														.alert("Please select the member.");
												return;
											} else if (cmmYear == "") {
												Common
														.alert("Please select the year ");
												return;
											}

											var reportDownFileName = ""; //download report name
											var reportFileName = ""; //reportFileName
											var reportViewType = ""; //viewType

											//default input setting
											$($reportForm)
													.append(
															'<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
											$($reportForm)
													.append(
															'<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
											$($reportForm)
													.append(
															'<input type="hidden" id="viewType" name="viewType" /> '); // download report  type

											var option = {
												isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
											};

											$($reportForm)
													.append(
															'<input type="hidden" id="V_MEMBERCODE" name="V_MEMBERCODE" value="" /> ');
											$($reportForm)
													.append(
															'<input type="hidden" id="V_YEAR" name="V_YEAR" value="" /> ');

											if (cmmYear >= 2018) {
												reportFileName = "/commission/MemberIncomeStatement2018.rpt"; //reportFileName

											} else {
												reportFileName = "/commission/MemberIncomeStatement.rpt"; //reportFileName
											}

											reportDownFileName = "MemberIncomeStatement_"
													+ today; //report name
											reportViewType = "PDF"; //viewType

											//report info
											if (reportFileName == ""
													|| reportDownFileName == ""
													|| reportViewType == "") {
												Common
														.alert("<spring:message code='sys.common.alert.validation' arguments='Report Info' htmlEscape='false'/>");
												return;
											}

											$("#reportForm #V_MEMBERCODE").val(
													memCode);
											$("#reportForm #V_YEAR").val(
													cmmYear);

											//default setting
											$("#reportForm #reportFileName")
													.val(reportFileName);
											$("#reportForm #reportDownFileName")
													.val(reportDownFileName);
											$("#reportForm #viewType").val(
													reportViewType);

											//  report 호출

											Common.report("reportForm", option);

										});
						//CP58
						// search member code
						$('#cp58')
								.click(
										function() {
											var $reportForm = $("#reportForm")[0];

											$($reportForm).empty(); //remove children
											var memCode = $(
													"#searchForm [name=memCode]")
													.val(); //member code
											var cmmYear = $(
													"#searchForm [name=cmmYear]")
													.val(); //commission year

											if (memCode == "") {
												Common
														.alert("Please select the member.");
												return;
											} else if (cmmYear == "") {
												Common
														.alert("Please select the year ");
												return;
											}

											var reportDownFileName = ""; //download report name
											var reportFileName = ""; //reportFileName
											var reportViewType = ""; //viewType

											//default input setting
											$($reportForm)
													.append(
															'<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
											$($reportForm)
													.append(
															'<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
											$($reportForm)
													.append(
															'<input type="hidden" id="viewType" name="viewType" /> '); // download report  type

											var option = {
												isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
											};

											$($reportForm)
													.append(
															'<input type="hidden" id="V_MEMBERCODE" name="V_MEMBERCODE" value="" /> ');
											$($reportForm)
													.append(
															'<input type="hidden" id="V_YEAR" name="V_YEAR" value="" /> ');

											//reportFileName = "/commission/CP58.rpt"; //reportFileName

											if(cmmYear >= 2022){
                                                reportFileName = "/commission/CP58_2023.rpt"; //reportFileName

                                            }else{
                                                reportFileName = "/commission/CP58.rpt"; //reportFileName

                                            }

											reportDownFileName = "CP58_"
													+ today; //report name
											reportViewType = "PDF"; //viewType

											//report info
											if (reportFileName == ""
													|| reportDownFileName == ""
													|| reportViewType == "") {
												Common
														.alert("<spring:message code='sys.common.alert.validation' arguments='Report Info' htmlEscape='false'/>");
												return;
											}

											$("#reportForm #V_MEMBERCODE").val(
													memCode);
											$("#reportForm #V_YEAR").val(
													cmmYear);

											//default setting
											$("#reportForm #reportFileName")
													.val(reportFileName);
											$("#reportForm #reportDownFileName")
													.val(reportDownFileName);
											$("#reportForm #viewType").val(
													reportViewType);

											//  report 호출

											Common.report("reportForm", option);

										});

						// search member code popup
						$('#memBtn').click(
								function() {
									Common.popupDiv("/common/memberPop.do", $(
											"#searchForm").serializeJSON(),
											null, true);
								});

					});

	function fn_loadOrderSalesman(memId, memCode) {
		$("#memCode").val(memCode);
	}
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>Commission</li>
		<li>Report</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>HP Income Statement</h2>
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
						<th scope="row"><spring:message
								code='commission.text.search.memCode' /></th>
						<%-- <td colspan="3"><input type="text" id="memCode" name="memCode" title="" class="readonly w100p" readonly="readonly" value="${loginId }" />
						</td> --%>
						<td colspan="3"><input type="text" title="" placeholder=""
							id="memCode" name="memCode"
							<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' && PAGE_AUTH.funcUserDefine2 != 'Y'}"> value="${loginId }" readonly </c:if> />
							<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
								<a id="memBtn" href="#" class="search_btn"><img
									src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
									alt="search" /></a>
							</c:if></td>
					</tr>
					<tr>
						<th scope="row"><spring:message
								code='commission.text.search.statementYear' /></th>
						<td colspan="3"><select id="cmmYear" name="cmmYear"
							style="width: 100px;">
								<option value=""></option>
								<c:forEach var="list" items="${yearList }">
									<option value="${list.cmmYear}">${list.cmmYear}</option>
								</c:forEach>
						</select></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->

			<ul class="center_btns">
				<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
					<li><p class="btn_blue2 big">
							<a href="#" id="generate" id="generate">Generate</a>
						</p></li>
					<li><p class="btn_blue2 big">
							<a href="#" id="cp58" id="cp58">CP58 Form</a>
						</p></li>
				</c:if>
				<li><p class="btn_blue2 big">
						<a href="#" id="clear" name="clear">CLEAR</a>
					</p></li>
			</ul>

		</form>
	</section>
</section>
<!-- search_table end -->
<!-- content end -->
<form name="reportForm" id="reportForm" method="post"></form>