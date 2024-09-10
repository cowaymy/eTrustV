<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
    //화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    today = "${today}";
    memberType = "${memberType}";
    var userTypeId = '${SESSION_INFO.userTypeId}';
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
            $(".j_date2").monthpicker("destroy");
            $('.j_date2').unbind('monthpicker-change-year');
            if (val == "1") { //ctComm_PDF.rpt
                $("#searchForm #confirmChk").val("N");
                $("#searchForm #mConfirm").show();
                
                if (userTypeId == 3) {
                	var currentYear = new Date().getFullYear();
                    var currentMonth = new Date().getMonth();
                    var months = [];
                    var allowedMonths = [];
                    
                    for (var i = 0; i < 3; i++) {
                        var month = currentMonth - i;
                        var year = currentYear;

                        if (month < 0) {
                            month += 12;
                            year -= 1;
                        }
                        
                        months.push({
                            month: month + 1, 
                            year: year
                        });
                    }
                    
                    months.forEach(function(item) {
                        if (!allowedMonths[item.year]) {
                            allowedMonths[item.year] = [];
                        }
                        allowedMonths[item.year].push(item.month);
                    });
                    var disabledMonths = {};

                    for (var year in allowedMonths) {
                        var allowed = allowedMonths[year];
                        var allMonths = Array.from({length: 12}, (_, i) => i + 1);

                        var disabled = allMonths.filter(month => !allowed.includes(month));
                     
                        if (disabled.length > 0) {
                            disabledMonths[year] = disabled;
                            }
                     }
                     var monthOptions = {
                             pattern: 'mm/yyyy',
                             startYear: months[2].year,
                             finalYear: months[0].year,
                             selectedMonth: months[1].month,
                             selectedYear: months[1].year,
                             dateSeparator: '/'
                        };
                   
                     $(".j_date2").monthpicker(monthOptions);
                     $(".j_date2").monthpicker("disableHideMonths", disabledMonths[monthOptions.selectedYear]);
                     $(".j_date2").monthpicker("setValue", monthOptions);
                     $(".j_date2").monthpicker("setMonthPickerToCurrentMonthAndYear", monthOptions);
                     setMonthPicker(monthOptions, disabledMonths, val); 
                } 
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
                    //Common.alert("Unable to find [" + salesPersonCd + "] in  CT Code .<br />Please ensure you key in the correct member code.");
                    Common.alert("<spring:message code='commission.alert.common.unableCtCode' arguments='"+salesPersonCd+"' htmlEscape='false' />");
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

            if (type == "1") {
                var confirmChk = $("#searchForm [name=confirmChk]").val();
                
                if (salesPersonCd == "") {
                  Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Code' htmlEscape='false'/>");
                  return;
                }else   if (confirmChk != "Y") {
                    //Common.alert("Please key in the CT Code before confirmation");
                    Common.alert("<spring:message code='commission.alert.report.enterCtCode'/>");
                    return;
                }
               //Wording in CT's commission statement changed for Enhancement: request for CT commission report module   
                if(year >= 2024 && month >=05 || year > 2024)
                {
                	reportFileName = "/commission/CTCommission_PDF_202409.rpt"; 
                }
                else {
                	reportFileName = "/commission/CTCommission_PDF.rpt"; //100%Extrade
                }
                
                reportDownFileName = "CTCommission_" + today; //report name         
                reportViewType = "PDF"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="Memcode" name="@CTCode" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');

                $("#reportForm #Memcode").val(salesPersonCd);
                $("#reportForm #Month").val(month);
                $("#reportForm #Year").val(year);
                $("#reportForm #TaskID").val(taskID);
            } else if (type == "2") {

                reportFileName = "/commission/CTCommission_Excel.rpt"; //reportFileName
                reportDownFileName = "CTCommission_Excel_" + today; //report name     
                reportViewType = "EXCEL"; //viewType

                //set parameters        
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
                $("#reportForm #TaskID").val(taskID);

            } else if (type == "3") {

                reportFileName = "/commission/AllCTCommission_PDF.rpt"; //reportFileName
                reportDownFileName = "AllCTCommission_" + today; //report name     
                reportViewType = "PDF"; //viewType

                //set parameters
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Month" name="@Month" value="" /> ');
                $($reportForm).append('<input type="hidden" id="Year" name="@Year" value="" /> ');         
          
          $("#reportForm #TaskID").val(taskID);
          $("#reportForm #Month").val(month);
            $("#reportForm #Year").val(year);

            } else if (type == "4") {

                reportFileName = "/commission/AS.rpt"; //reportFileName
                reportDownFileName = "AS" + today; //report name     
                reportViewType = "EXCEL"; //viewType

                //set parameters            
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');
            
                $("#reportForm #TaskID").val(taskID);
                
            } else if (type == "5") {

                reportFileName = "/commission/BS.rpt"; //reportFileName
                reportDownFileName = "BS" + today; //report name     
                reportViewType = "EXCEL"; //viewType

                //set parameters            
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);

            } else if (type == "6") {

                reportFileName = "/commission/Collection.rpt"; //reportFileName
                reportDownFileName = "Collection" + today; //report name     
                reportViewType = "EXCEL"; //viewType

                //set parameters      
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);

           } else if (type == "7") {

                reportFileName = "/commission/Installation.rpt"; //reportFileName
                reportDownFileName = "Installation" + today; //report name     
                reportViewType = "EXCEL"; //viewType

                //set parameters      
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);

           } else if (type == "8") {

                reportFileName = "/commission/Membership.rpt"; //reportFileName
                reportDownFileName = "Membership" + today; //report name     
                reportViewType = "EXCEL"; //viewType

                //set parameters      
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');

                $("#reportForm #TaskID").val(taskID);

           } else if (type == "9") {

                reportFileName = "/commission/ProductReturn.rpt"; //reportFileName
                reportDownFileName = "ProductRet" + today; //report name     
                reportViewType = "EXCEL"; //viewType

                //set parameters      
                $($reportForm).append('<input type="hidden" id="TaskID" name="@TaskID" value="" /> ');

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
    
    function setMonthPicker(monthOptions, disabledMonths, val) {
        $('.j_date2').monthpicker(monthOptions).bind('monthpicker-change-year', (e, year) => {
        	if (year == monthOptions.startYear) {
               $(e.target).monthpicker('disableHideMonths', disabledMonths[monthOptions.startYear]);
            } else if (year == monthOptions.finalYear) {
               $(e.target).monthpicker('disableHideMonths', disabledMonths[monthOptions.finalYear]);
            }  else {
               $(e.target).monthpicker('disableHideMonths', []);
            }     
        })
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
        <h2><spring:message code='commission.title.reportCT'/></h2>
    </aside>
    <!-- title_line end -->


    <section class="search_table">
        <!-- search_table start -->
        <form name="searchForm" id="searchForm" method="post">
            <input type="hidden" id="confirmChk" name="confirmChk" value="N" />
            <input type="hidden" id="memType" name="memType" value="3" />
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
                                    <option value="1">Coway Technician Commission</option>
                                </c:if>
                                <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
	                                <option value="2">Coway Technician Commission Raw (Excel)</option>                              
	                                <option value="3">Coway Technician Commission (All)</option>
	                                <option value="4">Coway Technician Comm (AS)</option>
	                                <option value="5">Coway Technician Comm (BS)</option>                               
	                                <option value="6">Coway Technician Comm (Collection)</option>                               
	                                <option value="7">Coway Technician Comm (Installation)</option>                             
	                                <option value="8">Coway Technician Comm (Membership)</option>                               
	                                <option value="9">Coway Technician Comm (ProdRet)</option>       
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