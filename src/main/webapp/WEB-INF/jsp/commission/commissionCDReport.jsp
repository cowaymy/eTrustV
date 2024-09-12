<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
    //화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    today = "${today}";
    memberType = "${memberType}";
    $(document).ready(function() {
    	var memLevel = "";

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
        	var cmmDt = $("#searchForm #cmmDt").val(); //commission date
            var monthConf = Number(cmmDt.substring(0, 2));
            var yearConf = Number(cmmDt.substring(3));
            var taskIDConf = monthConf + (yearConf * 12) - 24157; //taskId
            $("#searchForm #taskIDConf").val(taskIDConf);

            $("#searchForm [name=confirmChk]").val("N");
            var salesPersonCd = $("#searchForm [name=salesPersonCd]").val();
            if (salesPersonCd == "") {
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Code' htmlEscape='false'/>");
                return;
            }
            Common.ajax("GET", "/commission/report/selectMemberCount", $("#searchForm").serialize(), function(result) {
                console.log("<spring:message code='sys.msg.success'/>");
                if (result < 1) {
                    Common.alert("<spring:message code='commission.alert.report.unableCodyCode' arguments='"+salesPersonCd+"' htmlEscape='false' />");
                    //Common.alert("Unable to find [" + salesPersonCd + "] in  Cody Code .<br />Please ensure you key in the correct member code.");
                    $("#searchForm [name=salesPersonCd]").val("");
                } else {
                	memLevel = result.emplyLev;
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
                Common.alert("<spring:message code='commission.alert.report.selectType'/>");
                //Common.alert("Please select Report Type ");
                return;
            } else if (cmmDt == "") {
                Common.alert("<spring:message code='commission.alert.report.selectPeriod'/>");
                //Common.alert("Please select Commission Period ");
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

            if (type == "1") {
                var confirmChk = $("#searchForm [name=confirmChk]").val();
                if (salesPersonCd == "") {
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Code' htmlEscape='false'/>");
                return;
              }else   if (confirmChk != "Y") {
                  Common.alert("<spring:message code='commission.alert.report.enterCodyCode'/>");
                    //Common.alert("Please key in the Cody Code before confirmation");
                    return;
                }

//                 var d = new Date();
//                 var h = d.getHours();
//                 if(8 < h && h < 18){
//                 	Common.alert("This report can only be generated from 6pm onwards");
//                 	return;
//                 }

//                 var d = new Date();
//                 var h = d.getDate();
//                 if(h == 1){
//                     Common.alert("This report cannot be generated on first day of every month");
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
console.log(month);
console.log(year);
			if(memLevel == 0){
				reportFileName = "/commission/CodyComm_SGCM_PDF.rpt";
			}
			else
			{
				if(year >= 2024 && month >=09 || year > 2024)
                {
                    reportFileName = "/commission/CodyComm_PDF_202409.rpt"; //100%Extrade
                }
				else if(year >= 2024 && month >=03 || year > 2024)
                {
                    reportFileName = "/commission/CodyComm_PDF_202403.rpt"; //100%Extrade
                }
				else if(year >= 2024 && month >=01 || year > 2024)
                {
                    reportFileName = "/commission/CodyComm_PDF_202402.rpt"; //reportFileName
                }
				else if(year >= 2023 && month >=11 || year > 2023)
                {
                    reportFileName = "/commission/CodyComm_PDF_202311.rpt"; //reportFileName
                }
				else if(year >= 2023 && month >=08 || year > 2023)
	            {
	            	reportFileName = "/commission/CodyComm_PDF_202308.rpt"; //reportFileName
	            }
	            else if(year >= 2022 && month >=02 || year > 2022)
	            {
	            	reportFileName = "/commission/CodyComm_PDF_202203.rpt"; //reportFileName
	            }
	            else if(year >= 2022 && month >=01 || year > 2022)
	            {
	            	reportFileName = "/commission/CodyComm_PDF_202201.rpt"; //reportFileName
	            }
	            else if(year >= 2021 && month >=12 || year > 2021)
	            {
	            	reportFileName = "/commission/CodyComm_PDF_2022.rpt"; //reportFileName
	            }
	            else if (month >= 9 && year >= 2020 || year > 2020){

	            	console.log(1);
	               reportFileName = "/commission/CodyComm_PDF_202010.rpt"; //reportFileName
	            }
	            else if (month >= 10 && year >= 2018 || year >2018){
	            	console.log(2);
	                reportFileName = "/commission/CodyComm_PDF_201810.rpt"; //reportFileName
	            }
	            else{
	                reportFileName = "/commission/CodyComm_PDF.rpt"; //reportFileName
	            }
			}
                reportDownFileName = "CodyCommission_" + today; //report name
                reportViewType = "PDF"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="Memcode" name="@Memcode" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');

                $("#reportForm #Memcode").val(salesPersonCd);
                $("#reportForm #Month").val(month);
                $("#reportForm #Year").val(year);
                $("#reportForm #TaskID").val(taskID);
            } else if (type == "2") {
            	if(year >= 2024 && month >=09|| year > 2024)
                {
                    reportFileName = "/commission/CMCommissionRawData_Excel_202409.rpt";
                }
            	else {
            		reportFileName = "/commission/CMCommissionRawData_Excel.rpt"; //reportFileName
            	}
                reportDownFileName = "CMCommissionRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="CM" name="CM" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #CM").val("2");
                $("#reportForm #TaskID").val(taskID);

            } else if (type == "3") {

                reportFileName = "/commission/CommCalCodyRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "CommCalCodyRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');
            $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
            $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');

            $("#reportForm #Month").val(month);
            $("#reportForm #Year").val(year);
            $("#reportForm #TaskID").val(taskID);

            } else if (type == "4") {

                reportFileName = "/commission/ComCalCMRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "ComCalCMRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);

            } else if (type == "5") {

                reportFileName = "/commission/HandCollectRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "HandCollectRawData__" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);

            } else if (type == "6") {

                reportFileName = "/commission/CodyRentationRaw_Excel.rpt"; //reportFileName
                reportDownFileName = "CodyRentationRaw__" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);

            } else if (type == "7") {

                reportFileName = "/commission/CodySHIReport.rpt"; //reportFileName
                reportDownFileName = "CodySHIRaw__" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="CommDate" name="CommDate" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #CommDate").val(cmmDt.substring(3)+"-"+cmmDt.substring(0, 2)+"-"+"01");
                $("#reportForm #TaskID").val(taskID);

            } else if (type == "8") {

                reportFileName = "/commission/CMSHIReport.rpt"; //reportFileName
                reportDownFileName = "CMSHIRaw_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="CommDate" name="CommDate" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #CommDate").val(cmmDt.substring(3)+"-"+cmmDt.substring(0, 2)+"-"+"01");
                $("#reportForm #TaskID").val(taskID);

            } else if (type == "9") {
            	if(year >= 2024 && month >=09|| year > 2024)
                {
            		reportFileName = "/commission/CodyCommissionRawData_Excel_202409.rpt";
                }
            	else {
            		reportFileName = "/commission/CodyCommissionRawData_Excel.rpt"; //reportFileName
            	}
            
                reportDownFileName = "CodyCommissionRawData_Excel_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="Cody" name="Cody" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #Cody").val(memberType);
                $("#reportForm #TaskID").val(taskID);

          } else if (type == "10") {

              reportFileName = "/commission/CodyMBORawData_Excel.rpt"; //reportFileName
              reportDownFileName = "CodyMBORawData_Excel_" + today; //report name
              reportViewType = "EXCEL"; //viewType

              //set parameters
              $($reportForm).append('<input type="hidden" id="V_TASK_ID" name="V_TASK_ID" value="" /> ');
              $($reportForm).append('<input type="hidden" id="V_COMM_DT" name="V_COMM_DT" value="" /> ');

              $("#reportForm #V_COMM_DT").val(cmmDt.substring(3)+cmmDt.substring(0, 2)+"01");
              $("#reportForm #V_TASK_ID").val(taskID);

          }else if (type == "11") {

                var d = new Date();
                var h = d.getDate();
                var i = d.getHours();
                if(h == 1 || h == 2 || h == 3){
                    if(8 < i && i < 18){
                        Common.alert("This report cannot be generated on 1st, 2nd, and 3rd day of every month during working hours from 9am - 6pm");
                        return;
                    }

                }
                reportFileName = "/commission/CDNonIncntRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "CDNonIncnt_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                //$($reportForm).append('<input type="hidden" id="Memcode" name="@Memcode" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');

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

            if(type == "10" || type == "11" || type == "1")
            	var option = { isProcedure : true };
            else{
            	var option = { isProcedure : false }
            }

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
        <li><spring:message code='commission.text.head.cdReport'/></li>
    </ul>

    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2><spring:message code='commission.title.reportCD'/></h2>
    </aside>
    <!-- title_line end -->


    <section class="search_table">
        <!-- search_table start -->
        <form name="searchForm" id="searchForm" method="post">
            <input type="hidden" id="confirmChk" name="confirmChk" value="N" />
            <input type="hidden" id="memType" name="memType" value="2" />
            <input type="hidden" id="taskIDConf" name="taskIDConf" value="" />
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
                                <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' }">
	                                <option value="1">Cody Commisision Statement</option>
                                </c:if>
                                <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
	                                <option value="9">Cody Commission Raw (All)</option>
	                                <option value="2">Cody Manager Commission</option>
	                                <option value="3">Cody Comm Calculation</option>
	                                <option value="4">Cody Manager Comm Calculation</option>
	                                <option value="5">Hand Collection Data</option>
	                                <option value="6">Cody Rentation Report</option>
	                                <option value="7">Cody SHI Index Raw</option>
	                                <option value="8">Cody Manager SHI Index Raw</option>
	                                <option value="10">Cody MBO Raw</option>
	                                <option value="11">Cody Non-Monetary Incentive</option>
                                </c:if>
                        </select></td>
                    </tr>
                    <tr id="mConfirm" name="mConfirm" style="display: none;">
                        <th scope="row"><spring:message code='commission.text.search.memCode'/></th>
                            <td colspan="3"><input type="text" id="salesPersonCd" name="salesPersonCd" <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' && PAGE_AUTH.funcUserDefine2 != 'Y'}">value="${loginId }" readonly</c:if> />
                            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}"> <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if>
                            <p class="btn_sky">
                                <a href="#" id="confirm" name="confirm"><spring:message code='commission.button.confirm'/></a>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.period'/></th>
                        <td colspan="3"><input type="text" id="cmmDt" name="cmmDt" title="Date" class="j_date2" value="${cmmDt }" /></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <ul class="center_btns">
                <c:if test="${PAGE_AUTH.funcPrint == 'Y'}"><li><p class="btn_blue2 big">
                        <a href="#" id="generate" id="generate"><spring:message code='commission.button.generate'/></a>
                    </p></li></c:if>
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