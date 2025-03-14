<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    $(document).ready(function() {
         if ($("#userType").val() == "2"&& $("#memberLevel").val() == "4") {
               //doGetCombo('/services/bs/getCdUpMemList.do', $(this).val(), '', 'CMGroup', 'S','fn_cmdBranchCode');
               doGetCombo("/services/bs/report/selectCodyBranch.do",'', '', 'branchCmb', 'S','fn_setDefaultBranch');
               doGetCombo("/services/bs/report/getCdUpMem.do", '','', 'CMGroup', 'S', 'fn_setDefaultCM');
               doGetCombo("/services/bs/report/selectCodyList2.do",'', '', 'codyList', 'S','fn_setDefaultCody');
               $("#clearbtn").hide();
           } else {
                //  doGetCombo("/services/bs/report/reportBranchCodeList.do",'' ,''   , 'branchCmb' , 'S', '');
                doGetCombo("/services/bs/report/safetyLevelList.do",'', '', 'safetyLv', 'S', '');
                doGetCombo("/services/bs/report/selectRegion.do",'', '', 'regionCmb', 'S', '');//region
           }

         $("#forecastMonth").change(function(){

             if ($("#userType").val() == "2"&& $("#memberLevel").val() == "4") {
                 //doGetCombo('/services/bs/getCdUpMemList.do', $(this).val(), '', 'CMGroup', 'S','fn_cmdBranchCode');
                 doGetCombo("/services/bs/report/selectCodyBranch.do",'', '', 'branchCmb', 'S','fn_setDefaultBranch');
                 doGetCombo("/services/bs/report/getCdUpMem.do", '','', 'CMGroup', 'S', 'fn_setDefaultCM');
                 doGetCombo("/services/bs/report/selectCodyList2.do",'', '', 'codyList', 'S','fn_setDefaultCody');
                 $("#clearbtn").hide();
             } else {
                  //  doGetCombo("/services/bs/report/reportBranchCodeList.do",'' ,''   , 'branchCmb' , 'S', '');
                  doGetCombo("/services/bs/report/safetyLevelList.do",'', '', 'safetyLv', 'S', '');
                  doGetCombo("/services/bs/report/selectRegion.do",'', '', 'regionCmb', 'S', '');//region
                  doGetCombo("/services/bs/report/reportBranchCodeList.do","0", '','branchCmb', 'S', ''); //branch by region
             }
             });

         $("#regionCmb").change(function() {
             doGetCombo("/services/bs/report/reportBranchCodeList.do",$("#regionCmb").val(), '','branchCmb', 'S', ''); //branch by region
         });

         $("#branchCmb").change(function() {
             doGetCombo("/services/bs/report/selectCMGroupList.do",$("#branchCmb").val(), '','CMGroup', 'S', '');
                     if ($("#branchCmb").val() != '0') {
                         $("#safetyLv").prop("disabled",true);
                     } else {
                         $("#safetyLv").prop("disabled",false);
                     }
                 });

              $("#CMGroup").change(function() {
                    doGetCombo("/services/bs/report/selectCodyList.do",$("#CMGroup").val(), '','codyList', 'S', '');
               });

             if ($("#userType").val() == "2"&& $("#memberLevel").val() == "4") {
                     //doGetCombo('/services/bs/getCdUpMemList.do', $(this).val(), '', 'CMGroup', 'S','fn_cmdBranchCode');
                     doGetCombo("/services/bs/report/selectCodyBranch.do",'', '', 'branchCmb', 'S','fn_setDefaultBranch');
                     doGetCombo("/services/bs/report/getCdUpMem.do", '','', 'CMGroup', 'S', 'fn_setDefaultCM');
                     doGetCombo("/services/bs/report/selectCodyList2.do",'', '', 'codyList', 'S','fn_setDefaultCody');
                     $("#clearbtn").hide();
                }
             });

    function fn_setDefaultCM() {
        $('#CMGroup option:eq(1)').attr('selected', 'selected');
        $("#CMGroup").prop("disabled", true);
        //$('#CMGroup').attr('class', 'w100p readonly ');
    }

    function fn_setDefaultCody() {
        $('#codyList option:eq(1)').attr('selected', 'selected');
        $("#codyList").prop("disabled", true);
        //$('#codyList').attr('class', 'w100p readonly ');

    }

    function fn_setDefaultBranch() {
        $('#branchCmb option:eq(1)').attr('selected', 'selected');
        $("#branchCmb").prop("disabled", true);
        $("#safetyLv").prop("disabled", true);
        //$('#branchCmb').attr('class', 'w100p readonly ');

    }

    function fn_validation() {
        if ($("#forecastMonth").val() == '') {
            Common
                    .alert("<spring:message code='sys.common.alert.validation' arguments='forecast month' htmlEscape='false'/>");
            return false;
        }
        /* if (!$("#regionCmb").val().trim() && ($("#branchCmb").val() == '' || $("#branchCmb").val() == null)) {
            Common
                    .alert("<spring:message code='sys.common.alert.validation' arguments='Branch' htmlEscape='false'/>");
            return false;
        } */

        if ($("#CMGroup").text() == 'choose one') {
            if ($("#branchCmb").val() != '0') {
                Common
                        .alert("<spring:message code='sys.common.alert.validation' arguments='CM Group' htmlEscape='false'/>");
                return false;
            }
        }

        return true;
    }

    function fn_simplifyFormula(x) {

        if (x != "") {
            return 1 + (x / 100);
        } else {
            return 0;
        }

    }

    function fn_openReport() {
        if (fn_validation()) {
            var date = new Date();
            var month = date.getMonth() + 1;
            var day = date.getDate();
            if (date.getDate() < 10) {
                day = "0" + date.getDate();
            }
            var forecastDt2 = $("#forecastMonth").val().substring(3, 7) + "-"+ $("#forecastMonth").val().substring(0, 2);

            if ($("#branchCmb").val() !="0") {
                console.log("===========")
                console.log($("#branchCmb").val());
                var cmid = $("#CMGroup").val();
                var codyId = $("#codyList").val();
                var branchId = $("#branchCmb").val();
                var forecastDt = $("#forecastMonth").val().substring(3, 7)+ "-" + $("#forecastMonth").val().substring(0, 2) + "-01";
                if (cmid == '' && codyId == null || cmid == '' && codyId == '') {
                    cmid = 0;
                    console.log("BSFilterForecastByBranch");
                    $("#hsFilterForm #reportFileName").val(
                            '/services/BSFilterForecastByBranch.rpt');
                    $("#hsFilterForm #reportDownFileName").val(
                            "BSFilterForecast_" + month + date.getFullYear());
                    $("#hsFilterForm #V_FORECASTDATE").val(forecastDt);
                    $("#hsFilterForm #V_BRANCHID").val(branchId);
                    $("#hsFilterForm #V_CMID").val(cmid);

                } else if (cmid > 0 && codyId == 0) {
                    console.log("BSFilterForecast_CM");
                    $("#hsFilterForm #reportFileName").val(
                            '/services/BSFilterForecastByCMGroup.rpt');
                    $("#hsFilterForm #reportDownFileName").val(
                            "BSFilterForecast_" + month + date.getFullYear());
                    $("#hsFilterForm #V_FORECASTDATE").val(forecastDt);
                    $("#hsFilterForm #V_BRANCHID").val(branchId);
                    $("#hsFilterForm #V_CMID").val(cmid);
                } else if (cmid > 0 && codyId > 0) {
                    console.log("BSFilterForecast_Cody");
                    $("#hsFilterForm #reportFileName").val(
                            '/services/BSFilterForecast_Cody.rpt');
                    $("#hsFilterForm #reportDownFileName").val(
                            "BSFilterForecast_" + month + date.getFullYear());
                    $("#hsFilterForm #V_FORECASTDATE").val(forecastDt);
                    $("#hsFilterForm #V_BRANCHID").val(branchId);
                    $("#hsFilterForm #V_MEMBERID").val(codyId);
                    $("#hsFilterForm #V_MEMBERLVL").val(4);
                }

                if ($("#exportType").val() == "PDF") {
                    $("#hsFilterForm #viewType").val("PDF");
                    var option = {
                        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                    };

                    Common.report("hsFilterForm", option);

                } else {
                    $("#hsFilterForm #viewType").val("EXCEL");
                    var option = {
                        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                    };

                    Common.report("hsFilterForm", option);
                }

            } else {
                console.log("BSFilterForecast_AllBranches");
                console.log("safetyLv value " + $("#safetyLv").val());
                console.log("Date" + $("#forecastMonth").val().substring(3, 7)+ "-" + $("#forecastMonth").val().substring(0, 2));
                console.log("Region ID :  " + $("#regionCmb").val());
                console.log("fn_simplifyFormula "+ fn_simplifyFormula($("#safetyLv").val()))

                var regionCmb = $("#regionCmb").val();
                if(!regionCmb){
                    regionCmb =  0;
                }


                $("#hsFilterForm #reportFileName").val('/services/BSFilterForecast_AllBranches.rpt');
                $("#hsFilterForm #reportDownFileName").val("BSFilterForecast_" + month + date.getFullYear());
                //$("#hsFilterForm #viewType").val("PDF");
                $("#hsFilterForm #V_FORECASTDATE").val(forecastDt2);
                $("#hsFilterForm #V_REGION").val(regionCmb);
                $("#hsFilterForm #V_SAFETYLVL").val(
                        fn_simplifyFormula($("#safetyLv").val()));

                if ($("#exportType").val() == "PDF") {
                    $("#hsFilterForm #viewType").val("PDF");
                    var option = {
                        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                    };

                    Common.report("hsFilterForm", option);

                } else {
                    $("#hsFilterForm #viewType").val("EXCEL");
                    var option = {
                        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                    };

                    Common.report("hsFilterForm", option);
                }
            }

        }
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form') {
                return $(':input', this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden'
                    || tag === 'textarea') {
                this.value = '';
            } else if (type === 'checkbox' || type === 'radio') {
                this.checked = false;
            } else if (tag === 'select') {
                this.selectedIndex = -1;
            }
        });
    };
</script>

<div id="popup_wrap" class="popup_wrap">
    <!-- popup_wrap start -->

    <header class="pop_header">
        <!-- pop_header start -->
        <h1>HS Filter Forecast Listing</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2">
                    <a href="#"><spring:message code='expense.CLOSE' /></a>
                </p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <section class="pop_body">
        <!-- pop_body start -->

        <section class="search_table">
            <!-- search_table start -->
            <form action="#" method="post" id="hsFilterForm">
                <input type="hidden" id="V_FORECASTDATE" name="V_FORECASTDATE" /> <input
                    type="hidden" id="V_BRANCHID" name="V_BRANCHID" /> <input
                    type="hidden" id="V_MEMBERID" name="V_MEMBERID" /> <input
                    type="hidden" id="V_MEMBERLVL" name="V_MEMBERLVL" /> <input
                    type="hidden" id="V_CMID" name="V_CMID" /> <input type="hidden"
                    id="V_SAFETYLVL" name="V_SAFETYLVL" /> <input type="hidden"
                    id="V_REGION" name="V_REGION" /> <input type="hidden"
                    id="memberLevel" name="memberLevel" value="${memberLevel}">
                <input type="hidden" id="userName" name="userName"
                    value="${userName}"> <input type="hidden" id="userType"
                    name="userType" value="${userType}">
                <!--reportFileName,  viewType 모든 레포트 필수값 -->
                <input type="hidden" id="reportFileName" name="reportFileName" /> <input
                    type="hidden" id="viewType" name="viewType" /> <input
                    type="hidden" id="reportDownFileName" name="reportDownFileName"
                    value="DOWN_FILE_NAME" />

                <table class="type1">
                    <!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 170px" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Export Type</th>
                            <td><select id="exportType" name="exportType">
                                    <option value="PDF">PDF</option>
                                    <option value="EXCEL">Excel</option>
                            </select></td>
                        </tr>
                        <tr>
                            <th scope="row">Forecast Month</th>
                            <td><input type="text" title="기준년월" class="j_date2"
                                id="forecastMonth" name="forecastMonth" /></td>
                        </tr>
                        <tr>
                            <th scope="row">Region</th>
                            <td><select id="regionCmb" name="regionCmb">
                            </select></td>
                        </tr>
                        <tr>
                            <th scope="row">Branch</th>
                            <td><select id="branchCmb" name="branchCmb">
                            </select></td>
                        </tr>

                        <tr>
                            <th scope="row">Safety Level</th>
                            <td><select id="safetyLv" name="safetyLv">
                            </select></td>
                        </tr>
                        <tr>
                            <th scope="row">CM Group</th>
                            <td><select id="CMGroup" name="CMGroup">
                            </select></td>
                        </tr>
                        <tr>
                            <th scope="row">Cody</th>
                            <td><select id="codyList" name="codyList">
                            </select></td>
                        </tr>
                    </tbody>
                </table>
                <!-- table end -->

                <ul class="center_btns">
                    <li><p class="btn_blue2 big">
                            <a href="#" onclick="javascript:fn_openReport()"><spring:message
                                    code='service.btn.Generate' /></a>
                        </p></li>
                    <li><p class="btn_blue2 big">
                            <a href="#" id="clearbtn"
                                onclick="javascript:$('#hsFilterForm').clearForm();"><spring:message
                                    code='service.btn.Clear' /></a>
                        </p></li>
                </ul>

            </form>
        </section>
        <!-- search_table end -->

    </section>
    <!-- pop_body end -->

</div>
<!-- popup_wrap end -->

