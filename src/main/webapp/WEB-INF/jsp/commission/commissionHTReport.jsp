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
            if (val == "1") { //ctComm_PDF.rpt
                $("#searchForm #confirmChk").val("N");
                $("#searchForm #mConfirm").show();

            }



            $("#mLvlcontainer").hide(); //stat
            $("#searchForm #memberLvlcontainer").hide();
            if (val == "10") { //ctComm_PDF.rpt

             $("#searchForm #mLvlcontainer").show();

            }else if (val == "8" || val == "9" || val == "12") {

             $("#searchForm #memberLvlcontainer").show();

            }





        });



        // search member code popup
        $('#memBtn').click(function() {
            Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
        });

        // search member confirm
        $('#confirm').click(function() {
            $("#searchForm [name=confirmChk]").val("N");
            var cmmDt = $("#searchForm #cmmDt").val(); //commission date
            var monthConf = Number(cmmDt.substring(0, 2));
            var yearConf = Number(cmmDt.substring(3));
            var taskIDConf = monthConf + (yearConf * 12) - 24157; //taskId
            $("#searchForm #taskIDConf").val(taskIDConf);
            var salesPersonCd = $("#searchForm [name=salesPersonCd]").val();
            if (salesPersonCd == "") {
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Code' htmlEscape='false'/>");
                return;
            }
            Common.ajax("GET", "/commission/report/selectMemberCount", $("#searchForm").serialize(), function(result) {
                //console.log("<spring:message code='sys.msg.success'/>");
                //console.log("mem_type: " + $("#searchForm [name=memType]").val());
                if (result < 1) {
                    Common.alert("Unable to find [" + salesPersonCd + "] in HT Code .<br />Please ensure you key in the correct member code.");
                    $("#searchForm [name=salesPersonCd]").val("");
                } else {
                	$("#searchForm #memberLevel").val(result.emplyLev);
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

            var mLvl = $("#searchForm #mLvl").val(); //member level
            var memberLvl = $("#searchForm #memberLvl").val(); //member level
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
            var memLvl = $("#searchForm #memberLevel").val();

            if (type == "1") {
                var confirmChk = $("#searchForm [name=confirmChk]").val();

                if (salesPersonCd == "") {
                  Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Code' htmlEscape='false'/>");
                  return;
                }else   if (confirmChk != "Y") {
                    Common.alert("Please key in the HT Code before confirmation");
                    //Common.alert("<spring:message code='commission.alert.report.enterCtCode'/>");
                    return;
                }

                if(memLvl == '2')
                {
                	if (taskID >= 140){ // start from comm month = 09/2024. Added by Ming Shan, 09/09/2024
                        reportFileName = "/commission/SHMCommission_PDF_202409.rpt"; //reportFileName
                        reportDownFileName = "SHMCommission_" + salesPersonCd + "_" + today;  //report name
                        reportViewType = "PDF"; //viewType
                    }
                	else if (taskID >= 136){ // start from comm month = 05/2024. Added by Celeste, 24/05/2024
                		reportFileName = "/commission/SHMCommission_PDF_202405.rpt"; //reportFileName
                        reportDownFileName = "SHMCommission_" + salesPersonCd + "_" + today;  //report name
                        reportViewType = "PDF"; //viewType
                	}
                	else if (taskID >= 132){ // start from comm month = 01/2024. Added by Celeste, 02/02/2024
                		reportFileName = "/commission/SHMCommission_PDF_202402.rpt"; //reportFileName
                        reportDownFileName = "SHMCommission_" + salesPersonCd + "_" + today;  //report name
                        reportViewType = "PDF"; //viewType
                	}
                	else{
                		reportFileName = "/commission/SHMCommission_PDF.rpt"; //reportFileName
                        reportDownFileName = "SHMCommission_" + salesPersonCd + "_" + today;  //report name
                        reportViewType = "PDF"; //viewType
                	}
                }
                else if(memLvl == '3')
                {
                	if (taskID >= 140){ // start from comm month = 09/2024. Added by Ming Shan, 09/09/2024
                        reportFileName = "/commission/HTMCommission_PDF_202409.rpt"; //reportFileName
                        reportDownFileName = "HTMCommission_" + salesPersonCd + "_" + today;  //report name
                        reportViewType = "PDF"; //viewType
                    }
                	else if (taskID >= 136){ // start from comm month = 05/2024. Added by Celeste, 24/05/2024
                		reportFileName = "/commission/HTMCommission_PDF_202405.rpt"; //reportFileName
                        reportDownFileName = "HTMCommission_" + salesPersonCd + "_" + today;  //report name
                        reportViewType = "PDF"; //viewType
                	}
                	else if (taskID >= 132){ // start from comm month = 01/2024. Added by Celeste, 02/02/2024
                		reportFileName = "/commission/HTMCommission_PDF_202402.rpt"; //reportFileName
                        reportDownFileName = "HTMCommission_" + salesPersonCd + "_" + today;  //report name
                        reportViewType = "PDF"; //viewType
                	}
                	else{
                		reportFileName = "/commission/HTMCommission_PDF.rpt"; //reportFileName
                        reportDownFileName = "HTMCommission_" + salesPersonCd + "_" + today;  //report name
                        reportViewType = "PDF"; //viewType
                	}
                }
                else
                {
                	if (taskID >= 141){ // start from comm month = 10/2024. Added by Celeste, 07/10/2024 - 100% Payout for Extrade
                        reportFileName = "/commission/HTCommission_PDF_202410.rpt"; //reportFileName
                        reportViewType = "PDF"; //viewType
                        reportDownFileName = "HTCommission_" + salesPersonCd + "_" + today;  //report name
                    }
                	else if (taskID >= 140){ // start from comm month = 09/2024. Added by Ming Shan, 09/09/2024
                        reportFileName = "/commission/HTCommission_PDF_202409.rpt"; //reportFileName
                        reportViewType = "PDF"; //viewType
                        reportDownFileName = "HTCommission_" + salesPersonCd + "_" + today;  //report name
                    }
                	else if (taskID >= 132){ // start from comm month = 01/2024. Added by Celeste, 02/02/2024
                		reportFileName = "/commission/HTCommission_PDF_202402.rpt"; //reportFileName
                        reportViewType = "PDF"; //viewType
                        reportDownFileName = "HTCommission_" + salesPersonCd + "_" + today;  //report name
                	}
                	else if(taskID >= 122){ // start from comm month = 03/2023. Added by Hui Ding, 13/04/2023
                		reportFileName = "/commission/HTCommission_PDF.rpt"; //reportFileName
                        reportViewType = "PDF"; //viewType
                        reportDownFileName = "HTCommission_" + salesPersonCd + "_" + today;  //report name
                	}
                	else {
	                    reportFileName = "/commission/HTCommission_PDF_20230406.rpt"; //reportFileName
	                    reportViewType = "PDF"; //viewType
	                    reportDownFileName = "HTCommission_" + salesPersonCd + "_" + today;  //report name
                	}
                }

                //set parameters
                $($reportForm).append('<input type="hidden" id="Memcode" name="@Memcode" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');


                $("#reportForm #Memcode").val(salesPersonCd);
                $("#reportForm #Month").val(month);
                $("#reportForm #Year").val(year);
                $("#reportForm #TaskID").val(taskID);
            }
            else if (type == "6") {

                reportFileName = "/commission/HTNonIncntRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "HTNonIncnt" + today; //report name
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
            else if (type == '10'){

                debugger;
                if (mLvl == '') {
                    Common.alert("Please select a member level before generating the report.");
                    return;
                }
                if (mLvl == 4) {
                    if(year >= 2024 && month >=09|| year > 2024){
                        reportFileName = "/commission/HT_Sales_Rental_Commission_202410.rpt";
                    }
                    else{
                        reportFileName = "/commission/HT_Sales_Rental_Commission.rpt";
                    }

                    reportDownFileName = "HT Sales Rental Commission_" + today;
                    reportViewType = "EXCEL";

                    $($reportForm).append('<input type="hidden" id="EMPLEV" name="EMPLEV" value="" /> ');
                    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                    $("#reportForm #EMPLEV").val(mLvl);
                    $("#reportForm #TaskID").val(taskID);

                } else if (mLvl == 3) {
                     reportFileName = "/commission/HTM_Sales_Rental_Commission.rpt";
                     reportDownFileName = "HTM Sales Rental Commission_" + today;
                     reportViewType = "EXCEL";

                     $($reportForm).append('<input type="hidden" id="EMPLEV1" name="EMPLEV1" value="" /> ');
                     $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                     $("#reportForm #EMPLEV1").val(mLvl);
                     $("#reportForm #TaskID").val(taskID);

                } else if (mLvl == 2) {
                    reportFileName = "/commission/SHTM_Sales_Rental_Commission.rpt";
                    reportDownFileName = "SHTM Sales Rental Commission_" + today;
                    reportViewType = "EXCEL";

                    $($reportForm).append('<input type="hidden" id="EMPLEV2" name="EMPLEV2" value="" /> ');
                    $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');

                    $("#reportForm #EMPLEV2").val(mLvl);
                    $("#reportForm #TaskID").val(taskID);
               }
            }
            else if (type == '12'){

                if (memberLvl == '') {
                    Common.alert("Please select a member level before generating the report.");
                    return;
                }
                if (memberLvl == 3) {
                    reportFileName = "/commission/HTM_Sales_Rental_Commission_Overriding.rpt"; //reportFileName
                    reportDownFileName = "HTM Sales Rental Commission Overriding_" + today; //report name
                    reportViewType = "EXCEL"; //viewType

                    //set parameters
                    $($reportForm).append('<input type="hidden" id="HTM" name="HTM" value="" /> ');
                    $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');

                    $("#reportForm #HTM").val("7");
                    $("#reportForm #TaskID").val(taskID);


                } else if (memberLvl == 2) {
                    reportFileName = "/commission/SHTM_Promoted_Overriding_Commission.rpt"; //reportFileName
                    reportDownFileName = "SHTM Sales Rental Commission Overriding_" + today; //report name
                    reportViewType = "EXCEL"; //viewType

                    //set parameters
                    $($reportForm).append('<input type="hidden" id="SHTM" name="SHTM" value="" /> ');
                    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                    $("#reportForm #SHTM").val("7");
                    $("#reportForm #TaskID").val(taskID);
                }
            }
            else if (type == '13'){
            	reportFileName = "/commission/HT_Comm_Raw_All.rpt"; //reportFileName
                reportDownFileName = "HTCommissionRawAll_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="HTM" name="HTM" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);
            }
            else if (type == '14'){
            	reportFileName = "/commission/HT_Comm_Cal_Raw_Data.rpt"; //reportFileName
                reportDownFileName = "HTCommissionCalRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #HTM").val("7");
                $("#reportForm #TaskID").val(taskID);
            }
            else if (type == '15'){
            	reportFileName = "/commission/HTM_Comm_Raw_All.rpt"; //reportFileName
                reportDownFileName = "HTMCommissionRawAll_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="HTM" name="HTM" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);
            }
            else if (type == '16'){
            	reportFileName = "/commission/HTM_Comm_Cal_Raw_Data.rpt"; //reportFileName
                reportDownFileName = "HTMCommissionCalRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);
            }


            /*
            // Celeste 20241224: Report clean up [S]
            else if (type == "2") {

            	if (taskID >= 142){
            		reportFileName = "/commission/HTCommissionRawData_M_Excel_202412.rpt"; //reportFileName
            	}else{
            		reportFileName = "/commission/HTCommissionRawData_M_Excel.rpt"; //reportFileName
            	}
            	//reportFileName = "/commission/HTCommissionRawData_M_Excel.rpt"; //reportFileName
                reportDownFileName = "HTCommissionRawData_Mark_Excel_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="HT" name="HT" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');
               // $($reportForm).append('<input type="hidden" id="Month" name="Month"  value ="" />');
             //   $($reportForm).append('<input type="hidden" id="Year" name="Year"  value ="" />');

                $("#reportForm #HT").val("7");
                $("#reportForm #TaskID").val(taskID);
                //$("#reportForm #Month").val(month);
                //$("#reportForm #Year").val(year);


            } else if (type == "3") {

                reportFileName = "/commission/HTMCommissionRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "HTMCommissionRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="HTM" name="HTM" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #HTM").val("7");
                $("#reportForm #TaskID").val(taskID);

            }

            else if (type == "4") {

                reportFileName = "/commission/CommCalHTRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "CommCalHTRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');
            $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
            $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');

            $("#reportForm #Month").val(month);
            $("#reportForm #Year").val(year);
            $("#reportForm #TaskID").val(taskID);

            } else if (type == "5") {

                reportFileName = "/commission/ComCalHTMRawData_Excel.rpt"; //reportFileName
                reportDownFileName = "ComCalHTMRawData_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);

           }

            else if (type == "7") {
                if(year >= 2024 && month >=11|| year > 2024){
                    reportFileName = "/commission/HTCommissionRawData_R_Excel_202412.rpt"; //reportFileName
                }
                else if(year >= 2024 && month >=09|| year > 2024)
                {
                    reportFileName = "/commission/HTCommissionRawData_R_Excel_202409.rpt"; //reportFileName
                }
                else {
                    reportFileName = "/commission/HTCommissionRawData_R_Excel.rpt"; //reportFileName
                }

                reportDownFileName = "HTCommissionRawData_Rate_Excel_" + today; //report name
                reportViewType = "EXCEL"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="HT" name="HT" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');
               // $($reportForm).append('<input type="hidden" id="Month" name="Month"  value ="" />');
             //   $($reportForm).append('<input type="hidden" id="Year" name="Year"  value ="" />');

                $("#reportForm #HT").val("7");
                $("#reportForm #TaskID").val(taskID);
                //$("#reportForm #Month").val(month);
                //$("#reportForm #Year").val(year);
            }
            else if (type == '8') {

                if (memberLvl == '') {
                    Common.alert("Please select a member level before generating the report.");
                    return;
                }
                if (memberLvl == 3) {
                	if (taskID >= 142){
                		reportFileName = "/commission/HTMCommissionRawMark_Excel_202412.rpt"; //reportFileName
                	}else{
                		reportFileName = "/commission/HTMCommissionRawMark_Excel.rpt"; //reportFileName
                	}
                    reportDownFileName = "HTMCommissionRawMark_" + today; //report name **PREVIOUSLY MANAGER
                    reportViewType = "EXCEL"; //viewType

                    //set parameters
                    $($reportForm).append('<input type="hidden" id="HTM" name="HTM" value="" /> ');
                    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                    $("#reportForm #HTM").val("7");
                    $("#reportForm #TaskID").val(taskID);

                } else if (memberLvl == 2) {
                	if (taskID >= 142){
                		reportFileName = "/commission/SHTMCommissionRawMark_Excel_202412.rpt"; //reportFileName
                	}else{
                		reportFileName = "/commission/SHTMCommissionRawMark_Excel.rpt"; //reportFileName
                	}

                    reportDownFileName = "SHTMCommissionRawMark_" + today; //report name **PREVIOUSLY MANAGER
                    reportViewType = "EXCEL"; //viewType

                    //set parameters
                    $($reportForm).append('<input type="hidden" id="SHTM" name="SHTM" value="" /> ');
                    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                    $("#reportForm #SHTM").val("7");
                    $("#reportForm #TaskID").val(taskID);
                }

            } else if (type == '9') {

                if (memberLvl == '') {
                    Common.alert("Please select a member level before generating the report.");
                    return;
                }
                if (memberLvl == 3) {
                	if (year >= 2024 && month >=11|| year > 2024){
                		reportFileName = "/commission/HTMCommissionRawRate_Excel_202412.rpt"; //reportFileName
                	}
                	else if(year >= 2024 && month >=09|| year > 2024)
                    {
                		reportFileName = "/commission/HTMCommissionRawRate_Excel_202409.rpt"; //reportFileName
                    }
                    else {
                    	reportFileName = "/commission/HTMCommissionRawRate_Excel.rpt"; //reportFileName
                    }

                    reportDownFileName = "HTMCommissionRawRate_" + today; //report name **PREVIOUSLY MANAGER
                    reportViewType = "EXCEL"; //viewType

                    //set parameters
                    $($reportForm).append('<input type="hidden" id="HTM" name="HTM" value="" /> ');
                    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                    $("#reportForm #HTM").val("7");
                    $("#reportForm #TaskID").val(taskID);


                } else if (memberLvl == 2) {
                	if (year >= 2024 && month >=11|| year > 2024){
                		reportFileName = "/commission/SHTMCommissionRawRate_Excel_202412.rpt"; //reportFileName
                	}
                	else if(year >= 2024 && month >=09|| year > 2024)
                    {
                		reportFileName = "/commission/SHTMCommissionRawRate_Excel_202409.rpt"; //reportFileName
                    }
                    else {
                    	reportFileName = "/commission/SHTMCommissionRawRate_Excel.rpt"; //reportFileName
                    }

                    reportDownFileName = "SHTMCommissionRawRate_" + today; //report name **PREVIOUSLY MANAGER
                    reportViewType = "EXCEL"; //viewType

                    //set parameters
                    $($reportForm).append('<input type="hidden" id="SHTM" name="SHTM" value="" /> ');
                    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

                    $("#reportForm #SHTM").val("7");
                    $("#reportForm #TaskID").val(taskID);
                }
            }
            */
            // Celeste 20241224: Report clean up [E]

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
            if(type == "6" || type == "1")
                var option = { isProcedure : true };
            else{
                var option = { isProcedure : false };
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
        <li><spring:message code='commission.text.head.ctReport'/></li>
        <li><spring:message code='commission.text.head.report'/></li>
    </ul>

    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>HT Commission Report</h2>
    </aside>
    <!-- title_line end -->


    <section class="search_table">
        <!-- search_table start -->
        <form name="searchForm" id="searchForm" method="post">
            <input type="hidden" id="confirmChk" name="confirmChk" value="N" />
            <input type="hidden" id="memType" name="memType" value="7" />
            <input type="hidden" id="taskIDConf" name="taskIDConf"/>
            <input type="hidden" id="memberLevel" name="memberLevel"/>
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
                        <td colspan="3"><select id="reportType" name="reportType" style="width:300px;">
                                <option value="">Report/Raw Data Type</option>
                                <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' }">
                                    <option value="1">Homecare Technician Commission</option>
                                </c:if>
                                <!-- Celeste 20241224: Report clean up [S]-->
                                <%-- <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                                    <option value="2">Homecare Technician Commission Raw (Mark)</option>
                                    <option value="7">Homecare Technician Commission Raw (Rate)</option>
                                    <option value="3">Homecare Technician Manager Commission</option>
                                    <option value="8">HTM / SHTM Commission Raw (Mark)</option>
                                    <option value="9">HTM / SHTM Commission Raw (Rate)</option>
                                    <option value="4">Homecare Technician Comm Calculation</option>
                                    <option value="5">Homecare Technician Manager Comm Calculation</option>
                                    <option value="6">Homecare Technician Non-Monetary Incentive</option>
                                    <option value="10">HT / HTM / SHTM Sales Rental Commission</option>
                                    <option value="12">HTM / SHTM Sales Rental Commission Overriding</option>
                                </c:if> --%>
                                <!-- Celeste 20241224: Report clean up [E]-->
                                <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                                    <option value="13">HT Comm Raw (All)</option>
                                    <option value="14">HT Comm Calculation</option>
                                    <option value="15">Manager Comm Raw (All)</option>
                                    <option value="16">Manager Comm Calculation</option>
                                    <option value="6">Homecare Technician Non-Monetary Incentive</option>
                                    <option value="10">HT / HTM / SHTM Sales Rental Commission</option>
                                    <option value="12">HTM / SHTM Sales Rental Commission Overriding</option>
                                </c:if>
                        </select></td>
                    </tr>
                    <tr id="mConfirm" name="mConfirm" style="display: none;">
                        <th scope="row"><spring:message code='commission.text.search.memCode'/></th>
                        <td colspan="3"><input type="text" id="salesPersonCd" name="salesPersonCd" <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' && PAGE_AUTH.funcUserDefine2 != 'Y'}"> value="${loginId }" readonly</c:if>  />
                            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}"><a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if>
                            <p class="btn_sky">
                                <a href="#" id="confirm" name="confirm"><spring:message code='commission.button.confirm'/></a>
                            </p>
                        </td>
                        <tr id="mLvlcontainer" name="mLvlcontainer" style="display: none;">
                        <th scope="row">Member Level</th>
                        <td colspan="3">
                <select id="mLvl" name="mLvl">
            <option value="">Select a Member Level</option>

            <option value="2">SHTM</option>
            <option value="3">HTM</option>
            <option value="4">HT</option>
        </select>
    </td>
    <td>



                        </td>
                    </tr>
                                            <tr id="memberLvlcontainer" name="memberLvlcontainer" style="display: none;">
                        <th scope="row">Member Level</th>
                        <td colspan="3">
                <select id="memberLvl" name="memberLvl">
            <option value="">Select a Member Level</option>

            <option value="2">SHTM</option>
            <option value="3">HTM</option>
        </select>
    </td>
    <td>



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