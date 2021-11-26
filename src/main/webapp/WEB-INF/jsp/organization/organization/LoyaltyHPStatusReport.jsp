<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
    //화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    today = "${today}";
    $(document).ready(function() {

        doGetCombo('/organization/selectOrgCode.do', '', '','cmbOrgCode', 'M', 'f_multiCombo');

        //change report type box
        $("#reportType").change(function() {
            val = $(this).val();
            var $reportForm = $("#reportForm")[0];
            $($reportForm).empty(); //remove children

            if ($("#reportType").val() == "4" || $("#reportType").val() == "5") {
                $("#cmbOrgCode").val("");
                $("#orgCodeSelect").show();
            } else {
                $("#cmbOrgCode").val("");
                $("#orgCodeSelect").hide();
            }
        });

        var userType = '${SESSION_INFO.userTypeId}';

        if(userType == 1){

            if ("${SESSION_INFO.memberLevel}" == "0") {

                $("#reportType").val(4); // SGM view

            } else if ("${SESSION_INFO.memberLevel}" == "1") {

                $("#reportType").val(1); // GM view

            } else if ("${SESSION_INFO.memberLevel}" == "2") {

                $("#reportType").val(2); // SM view

            } else if ("${SESSION_INFO.memberLevel}" == "3") {

                $("#reportType").val(3); // HM view
            }

            $("#reportType").attr('disabled',true);

        } else if (userType == 4 || userType == 6){
        	 $("#reportType").val(5); // Staff
        	 $("#reportType").attr('disabled',true);
        }else {

            $("#reportType").attr('disabled',false);
        }

        if (userType == 1 && "${SESSION_INFO.memberLevel}" == "0") {
            $("#searchForm #orgCodeSelect").show();
        }else if (userType == 4 || userType == 6){
        	 $("#searchForm #orgCodeSelect").show();
        }

        $('#generate').click(function() {

        	var $reportForm = $("#reportForm")[0];
        	var userType = '${SESSION_INFO.userTypeId}';

            $($reportForm).empty(); //remove children
            var type = $("#reportType").val(); //report type

            if (type == "") {
                Common.alert("<spring:message code='commission.alert.report.selectType'/>");
                return;
            }

            if (type == "4" && ($("#cmbOrgCode").val() == null)) {
                Common.alert("Please select Org Code");
                return;
            }

            var reportDownFileName = ""; //download report name
            var reportFileName = ""; //reportFileName
            var reportViewType = ""; //viewType
            var reportOrgCode = "";

            //default input setting
            $($reportForm).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
            $($reportForm).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
            $($reportForm).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type

            if (type == "1") {

                reportFileName = "/organization/LoyaltyHPStatusGM.rpt"; //reportFileName
                reportDownFileName = "LoyaltyHPStatusGM_" + today; //report name
                reportViewType = "PDF"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="OrgCode" name="@OrgCode" value="" /> ');

                $("#reportForm #OrgCode").val("${orgCode}");
                //  report 호출
                var option = {
                    isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
                };

            }else if (type == "2") {
            	reportFileName = "/organization/LoyaltyHPStatusSM_Excel.rpt"; //reportFileName
                reportDownFileName = "LoyaltyHPStatusSM_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="GrpCode" name="@GrpCode" value="" /> ');

                $("#reportForm #GrpCode").val("${grpCode}");
                //  report 호출
                var option = {
                    isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
                };
            }
            else if (type == "3") {
            	reportFileName = "/organization/LoyaltyHPStatusHM_Excel.rpt"; //reportFileName
                reportDownFileName = "LoyaltyHPStatusHM_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="DeptCode" name="@DeptCode" value="" /> ');

                $("#reportForm #DeptCode").val("${deptCode}");

                //  report 호출
                var option = {
                    isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
                };
            }
            else if (type == "4") {

            	var ORGCODE = "";
                reportFileName = "/organization/LoyaltyHPStatus.rpt"; //reportFileName
                reportDownFileName = "LoyaltyHPStatusSGM_" + today; //report name
                reportViewType = "PDF"; //viewType

                //set parameters

                if ($("#cmbOrgCode").val() != '' && $("#cmbOrgCode").val() != null) {
                    var MultiORGCode = $("#cmbOrgCode").val().toString().replace(/,/g, "','");
                    ORGCODE += MultiORGCode;
                }

                $($reportForm).append('<input type="hidden" id="V_ORGCODE" name="V_ORGCODE" value="" /> ');
                $("#reportForm #V_ORGCODE").val(ORGCODE);

                var option = {
                        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };
            } else if (type == "5") {

                var ORGCODE = "";
                reportFileName = "/organization/LoyaltyHPStatus.rpt"; //reportFileName
                reportDownFileName = "LoyaltyHPStatus_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters

                if ($("#cmbOrgCode").val() != '' && $("#cmbOrgCode").val() != null) {
                    var MultiORGCode = $("#cmbOrgCode").val().toString().replace(/,/g, "','");
                    ORGCODE += MultiORGCode;
                }

                $($reportForm).append('<input type="hidden" id="V_ORGCODE" name="V_ORGCODE" value="" /> ');
                $("#reportForm #V_ORGCODE").val(ORGCODE);

                var option = {
                        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };
            }

            //default setting
            $("#reportForm #reportFileName").val(reportFileName);
            $("#reportForm #reportDownFileName").val(reportDownFileName);
            $("#reportForm #viewType").val(reportViewType);

            Common.report("reportForm", option);
        });
    });

    function f_multiCombo(){
        $(function() {
            $('#cmbOrgCode').change(function() {
            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '30%'
            });
        });
    }
</script>

<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>Organization</li>
		<li>Organization Mgmt.</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Loyalty HP Status Report</h2>
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
						<td colspan="3"><select id="reportType" name="reportType"
							style="width: 300px;">
								<option value="">Report Type</option>
								<option value="4">Loyalty HP Status HP - SGM report</option>
								<option value="1">Loyalty HP Status HP - GM report</option>
								<option value="2">Loyalty HP Status HP - SM report
									(excel)</option>
								<option value="3">Loyalty HP Status HP - HM report
									(excel)</option>
								<option value="5">Loyalty HP Status report</option>
						</select></td>
					</tr>
					<tr id="orgCodeSelect" name="orgCodeSelect" style="display: none;">
						<th scope="row">Org Code</th>
						<td colspan="2"><select class="w50p" id="cmbOrgCode"
							name="cmbOrgCode" multiple="multiple"></select></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->

			<ul class="center_btns">
				<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
					<li><p class="btn_blue2 big">
							<a href="#" id="generate" id="generate"><spring:message
									code='commission.button.generate' /></a>
						</p></li>
				</c:if>
			</ul>

		</form>
	</section>
</section>
<!-- search_table end -->
<!-- content end -->
<form name="reportForm" id="reportForm" method="post"></form>