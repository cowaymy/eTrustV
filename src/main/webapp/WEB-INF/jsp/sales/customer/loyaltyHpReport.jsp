<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
    //화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    today = "${today}";
    $(document).ready(function() {

        //change report type box
        $("#reportType").change(function() {
            val = $(this).val();
            var $reportForm = $("#reportForm")[0];
            $($reportForm).empty(); //remove children
        });

    	var userType = '${SESSION_INFO.userTypeId}';

        if(userType == 1){

            if ("${SESSION_INFO.memberLevel}" == "1") {

                $("#reportType").val(1); // GM view

                 } else if ("${SESSION_INFO.memberLevel}" == "2") {

                     $("#reportType").val(2); // SM view

                 } else if ("${SESSION_INFO.memberLevel}" == "3") {

                     $("#reportType").val(3); // HM view

                 }

               $("#reportType").attr('disabled',true);

           } else {
        	   $("#reportType").attr('disabled',false);
           }

        $('#generate').click(function() {
            var $reportForm = $("#reportForm")[0];

            $($reportForm).empty(); //remove children
            var type = $("#reportType").val(); //report type

            if (type == "") {
                //Common.alert("Please select Report Type ");
                Common.alert("<spring:message code='commission.alert.report.selectType'/>");
                return;
            }

            var reportDownFileName = ""; //download report name
            var reportFileName = ""; //reportFileName
            var reportViewType = ""; //viewType

            //default input setting
            $($reportForm).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
            $($reportForm).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
            $($reportForm).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type

            if (type == "1") {

                reportFileName = "/sales/LoyaltyWsHpGm_PDF.rpt"; //reportFileName
                reportDownFileName = "LoyaltyWsHpGm_" + today; //report name
                reportViewType = "PDF"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="OrgCode" name="@OrgCode" value="" /> ');

                $("#reportForm #OrgCode").val("${orgCode}");

            } else if (type == "2") {

                reportFileName = "/sales/LoyaltyWsHpSm_PDF.rpt"; //reportFileName
                reportDownFileName = "LoyaltyWsHpSm_" + today; //report name
                reportViewType = "PDF"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="GrpCode" name="@GrpCode" value="" /> ');

                $("#reportForm #GrpCode").val("${grpCode}");

            } else if (type == "3") {

            	reportFileName = "/sales/LoyaltyWsHpHm_Excel.rpt"; //reportFileName
            	reportDownFileName = "LoyaltyWsHpHm_" + today; //report name
            	reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="DeptCode" name="@DeptCode" value="" /> ');

                $("#reportForm #DeptCode").val("${deptCode}");

            } else if (type == "4") {

                reportFileName = "/sales/LoyaltyWsHpSmAll_Excel.rpt"; //reportFileName
                reportDownFileName = "LoyaltyWsHpSmAll_" + today; //report name
                reportViewType = "EXCEL"; //viewType

            } else if (type == "5") {

                reportFileName = "/sales/LoyaltyWsHpHmAll_Excel.rpt"; //reportFileName
                reportDownFileName = "LoyaltyWsHpHmAll_" + today; //report name
                reportViewType = "EXCEL"; //viewType

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
        <li>Sales</li>
        <li>Customer</li>
    </ul>

    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>Loyalty HP Report</h2>
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
                        <th scope="row">Report Type</th>
                        <td colspan="3"><select id="reportType" name="reportType" style="width:300px;">
                                        <option value="">Report Type</option>
                                <c:choose>
                                    <c:when test="${PAGE_AUTH.funcUserDefine1 != 'Y' }">
                                        <option value="1">Loyalty WS HP - GM report</option>
                                        <option value="2">Loyalty WS HP - SM report</option>
                                        <option value="3">Loyalty WS HP - HM report</option>
                                    </c:when>
                                    <c:when test="${PAGE_AUTH.funcUserDefine1 == 'Y' }">
                                        <option value="4">Loyalty WS HP - SM report - All (Excel)</option>
                                        <option value="5">Loyalty WS HP - HM report - All (Excel)</option>
                                    </c:when>
                                </c:choose>
                        </select></td>
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
            </ul>

        </form>
    </section>
</section>
<!-- search_table end -->
<!-- content end -->
<form name="reportForm" id="reportForm" method="post"></form>