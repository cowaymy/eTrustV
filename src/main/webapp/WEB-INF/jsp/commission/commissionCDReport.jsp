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
                    Common.alert("<spring:message code='commission.alert.report.unableCodyCode' arguments='"+salesPersonCd+"' htmlEscape='false' />");
                    //Common.alert("Unable to find [" + salesPersonCd + "] in  Cody Code .<br />Please ensure you key in the correct member code.");
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

                reportFileName = "/commission/CodyComm_PDF.rpt"; //reportFileName
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

                reportFileName = "/commission/CMCommissionRawData_Excel.rpt"; //reportFileName
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

            reportFileName = "/commission/CodyCommissionRawData_Excel.rpt"; //reportFileName
            reportDownFileName = "CodyCommissionRawData_Excel_" + today; //report name     
            reportViewType = "EXCEL"; //viewType

            //set parameters
            $($reportForm).append('<input type="hidden" id="Cody" name="Cody" value="" /> ');
            $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

            $("#reportForm #Cody").val(memberType);
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
                                <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' || PAGE_AUTH.funcUserDefine2 == 'Y'}">
	                                <option value="1">Cody Commisision Statement</option>
                                </c:if>
                                <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
	                                <option value="9">Cody Commission Raw (All)</option>
	                                <option value="2">Cody Manager Commission</option>
	                                <option value="3">Cody Comm Calculation</option>
	                                <option value="4">Cody Manager Comm Calculation</option>
	                                <option value="5">Hand Collection Data</option>
	                                <option value="6">Cody Retation Report</option>
	                                <option value="7">Cody SHI Index Raw</option>
	                                <option value="8">Cody Manager SHI Index Raw</option>
                                </c:if>
                        </select></td>
                    </tr>
                    <tr id="mConfirm" name="mConfirm" style="display: none;">
                        <%-- <th scope="row"><spring:message code='commission.text.search.memCode'/></th>
                            <td colspan="3"><input type="text" id="salesPersonCd" name="salesPersonCd" <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">value="${loginId }" readonly</c:if> />
                            <c:if test="${PAGE_AUTH.funcUserDefine1 != 'Y'}"> <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if>
                            <p class="btn_sky">
                                <a href="#" id="confirm" name="confirm"><spring:message code='commission.button.confirm'/></a>
                            </p>
                        </td>
                        --test
                         --%>
                        <th scope="row"><spring:message code='commission.text.search.memCode'/></th>
                            <td colspan="3"><input type="text" id="salesPersonCd" name="salesPersonCd" value="" />
                            <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
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