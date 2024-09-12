<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
	//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
	today = "${today}";
	memberType = "${memberType}";
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
			$("#mConfirm").hide(); //stat
			if (val == "1") { //CodyComm_PDF.rpt
				$("#searchForm #confirmChk").val("N");
				$("#searchForm #mConfirm").show();
			}
		});

		// search member code popup
		$('#memBtn').click(function() {
			Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
		});

		// search member confirm
		$('#confirm').click(function() {
			$("#searchForm [name=confirmChk]").val("N");
			var salesPersonCd = $("#searchForm [name=salesPersonCd]").val();
			if (salesPersonCd == "") {
				Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Code' htmlEscape='false'/>");
				return;
			}
			Common.ajax("GET", "/commission/report/selectMemberCount", $("#searchForm").serialize(), function(result) {
				console.log("<spring:message code='sys.msg.success'/>");
				if (result < 1) {
					//Common.alert("Unable to find [" + salesPersonCd + "] in  HP Code .<br />Please ensure you key in the correct member code.");
					Common.alert("<spring:message code='commission.alert.report.unableHpCode' arguments='"+salesPersonCd+"' htmlEscape='false' />");
					$("#searchForm [name=salesPersonCd]").val("");
				} else {
					$("#searchForm [name=confirmChk]").val("Y");
					Common.alert("<spring:message code='sys.msg.success'/>");
				}
			});
		});

		// search member code
		$('#generate').click(function() {
			var $reportForm = $("#reportForm")[0];

			$($reportForm).empty(); //remove children
			var type = $("#reportType").val(); //report type
			var cmmDt = $("#searchForm #cmmDt").val(); //commission date
			var salesPersonCd = $("#searchForm [name=salesPersonCd]").val(); //member code

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

			var option = {
			        isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
			      };

			var option2 = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                  };

			if (type == "1") {
				var confirmChk = $("#searchForm [name=confirmChk]").val();
				if (salesPersonCd == "") {
			    Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Code' htmlEscape='false'/>");
			    return;
			  }else   if (confirmChk != "Y") {
					//Common.alert("Please key in the HP Code before confirmation");
					Common.alert("<spring:message code='commission.alert.report.enterHpCode'/>");
					return;
				}

// 				var d = new Date();
//                 var h = d.getHours();
//                 if(8 < h && h < 18){
//                     Common.alert("This report can only be generated from 6pm onwards");
//                     return;
//                 }

                 var d = new Date();
                 var h = d.getDate();
                 var i = d.getHours();
                 if(h == 1 || h == 2 || h == 3){
                	 if(8 < i && i < 18){
                		 Common.alert("This report cannot be generated on 1st, 2nd, and 3rd day of every month during working hours from 9am - 6pm");
                         return;
                	 }

                 }

				  option = {
	                      isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	                    };

				if(salesPersonCd=="503581"){//GCM

					if(year >= 2021 && month >=12 || year > 2021)
                    {
                        reportFileName = "/commission/SGMComm_PDF_2022.rpt"; //reportFileName
                    }
					else
					{
						reportFileName = "/commission/SGMComm_PDF.rpt"; //reportFileName
					}
				 	$($reportForm).append('<input type="hidden" id="Memcode" name="@Memcode" value="" /> ');
			    $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');
			    $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
			    $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');
				}else{
					if(year >= 2024 && month >=09|| year > 2024)
                    {
                        reportFileName = "/commission/HPComm_PDF_202409.rpt";
                    }
				    else if(year >= 2024 && month >=03|| year > 2024)
                    {
                        reportFileName = "/commission/HPComm_PDF_202403.rpt"; //100% Extrade + 36 Months Government
                    }
					else if(year >= 2024 && month >=01|| year > 2024)
                    {
                        reportFileName = "/commission/HPComm_PDF_202402.rpt"; //reportFileName
                    }
					else if(year >= 2023 && month >=10 || year > 2023)
                    {
                        reportFileName = "/commission/HPComm_PDF_202311.rpt"; //reportFileName
                    }
				    else if(year >= 2022 && month >=02 || year > 2022)
					{
						reportFileName = "/commission/HPComm_PDF_202203.rpt"; //reportFileName
					}
					else if(year >= 2022 && month >=01 || year > 2022)
					{
						reportFileName = "/commission/HPComm_PDF_202201.rpt"; //reportFileName
					}
					else if(year >= 2021 && month >=12 || year > 2021)
					{
						reportFileName = "/commission/HPComm_PDF_2022.rpt"; //reportFileName
					}
					else if (month >= 10 && year >= 2018 || year > 2018){
						reportFileName = "/commission/HPComm_PDF_201810.rpt"; //reportFileName
					}
					else{
						reportFileName = "/commission/HPComm_PDF.rpt"; //reportFileName
					}
					 //set parameters
			     $($reportForm).append('<input type="hidden" id="Memcode" name="Memcode" value="" /> ');
			     $($reportForm).append('<input type="hidden" id="Month" name="Month" value="" /> ');
			     $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');
			     $($reportForm).append('<input type="hidden" id="Year" name="Year" value="" /> ');
				}
				reportDownFileName = "HPCommission_" + today; //report name
				reportViewType = "PDF"; //viewType

				$("#reportForm #Memcode").val(salesPersonCd);
				$("#reportForm #Month").val(month);
				$("#reportForm #Year").val(year);
				$("#reportForm #TaskID").val(taskID);
			} else if (type == "2") {
				if(year >= 2024 && month >=09|| year > 2024)
                {
					reportFileName = "/commission/HPCommissionRawData_Excel_202409.rpt"; //reportFileName
                }
				else {
					reportFileName = "/commission/HPCommissionRawData_Excel.rpt"; //reportFileName
				}
				
				reportDownFileName = "HPCommissionRawData_" + today; //report name
				reportViewType = "EXCEL"; //viewType

				//set parameters
				$($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');
				$($reportForm).append('<input type="hidden" id="CommDate" name="CommDate" value="" /> ');
				$("#reportForm #TaskID").val(taskID);
				$("#reportForm #CommDate").val(cmmDt.substring(3)+"-"+cmmDt.substring(0, 2)+"-"+"01");

			} else if (type == "3") {

				reportFileName = "/commission/HPTBBRawFile_Excel.rpt"; //reportFileName
				reportDownFileName = "HPTBBRawFile_" + today; //report name
				reportViewType = "EXCEL"; //viewType

				//set parameters
				$($reportForm).append('<input type="hidden" id="CommDate" name="CommDate" value="" /> ');
		    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

		    $("#reportForm #CommDate").val(cmmDt.substring(3)+"-"+cmmDt.substring(0, 2)+"-"+"01");
	      $("#reportForm #TaskID").val(taskID);

			} else if (type == "4") {

				reportFileName = "/commission/CommCalHPRawData_Excel.rpt"; //reportFileName
				reportDownFileName = "CommCalHPRawData_" + today; //report name
				reportViewType = "EXCEL"; //viewType

				//set parameters
				$($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

				$("#reportForm #TaskID").val(taskID);

			} else if (type == "5") {

				reportFileName = "/commission/HPSHIReport.rpt"; //reportFileName
				reportDownFileName = "HPSHIRaw_" + today; //report name
				reportViewType = "EXCEL"; //viewType

				//set parameters
				$($reportForm).append('<input type="hidden" id="CommDate" name="CommDate" value="" /> ');
				$($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

				$("#reportForm #CommDate").val(cmmDt.substring(3)+"-"+cmmDt.substring(0, 2)+"-"+"01");
				$("#reportForm #TaskID").val(taskID);

			} else if (type == "6") {

                reportFileName = "/commission/HPCommissionRentalRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "HPCommissionRentalRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                 $($reportForm).append('<input type="hidden" id="Month" name="Month" value="" /> ');
                 $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');
                 $($reportForm).append('<input type="hidden" id="Year" name="Year" value="" /> ');



               $("#reportForm #Month").val(month);
               $("#reportForm #Year").val(year);
               $("#reportForm #TaskID").val(taskID);


            }else if (type == "7") {

                 var d = new Date();
                 var h = d.getDate();
                 var i = d.getHours();
                 if(h == 1 || h == 2 || h == 3){
                     if(8 < i && i < 18){
                         Common.alert("This report cannot be generated on 1st, 2nd, and 3rd day of every month during working hours from 9am - 6pm");
                         return;
                     }

                 }

                  option = {
                          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                        };

                reportFileName = "/commission/HPNonIncntRawData_Excel.rpt"; //reportFileName
                //$($reportForm).append('<input type="hidden" id="Memcode" name="@Memcode" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');
                reportDownFileName = "HPNonIncnt_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //$("#reportForm #Memcode").val(salesPersonCd);
                $("#reportForm #Month").val(month);
                $("#reportForm #Year").val(year);
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

            Common.report("reportForm", option);


			$("#searchForm #confirmChk").val("N");

		});

	});

	// set member code
	function fn_loadOrderSalesman(memId, memCode) {
		$("#salesPersonCd").val(memCode);
	}
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li><spring:message code='commission.text.head.commission'/></li>
        <li><spring:message code='commission.text.head.report'/></li>
        <li><spring:message code='commission.text.head.hpReport'/></li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2><spring:message code='commission.title.reportHP'/></h2>
	</aside>
	<!-- title_line end -->


	<section class="search_table">
		<!-- search_table start -->
		<form name="searchForm" id="searchForm" method="post">
			<input type="hidden" id="confirmChk" name="confirmChk" value="N" />
			<input type="hidden" id="memType" name="memType" value="1" />
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
								<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
								    <option value="1">HP Commission Statement</option>
								</c:if>
								<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
									<option value="2">HP Commission Raw (All)</option>
									<option value="3">HP TBB File Data Raw</option>
									<option value="4">HP Comm Calculation</option>
									<option value="5">HP SHI Index Raw</option>
									<option value="6">HP Rental Commission Raw</option>
									<option value="7">HP Non-Monetary Incentive</option>
								</c:if>
						</select></td>
					</tr>
					<tr id="mConfirm" name="mConfirm" style="display: none;">
						<th scope="row"><spring:message code='commission.text.search.memCode'/></th>
						<td colspan="3"><input type="text" id="salesPersonCd" name="salesPersonCd" <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' && PAGE_AUTH.funcUserDefine2 != 'Y'}"> value="${loginId }" readonly</c:if> />
						  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y' }"><a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if>
							<p class="btn_sky">
								<a href="#" id="confirm" name="confirm"><spring:message code='commission.button.confirm'/></a>
							</p></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code='commission.text.search.period'/></th>
						<td colspan="3"><input type="text" id="cmmDt" name="cmmDt" title="Date" class="j_date2" value="${cmmDt }" /></td>
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