<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javaScript">

    var grdBatchID;
    var gridIfColumnLayout =
        [
            {
                dataField: "jobInstanceId",
                headerText: "JOB_INSTANCE_ID",
                visible: false
            },
            {
                dataField: "jobExecutionId",
                headerText: "JOB_EXECUTION_ID",
                visible: false
            },
            {
                dataField: "jobName",
                headerText: "JOB_NAME",
                editable: false,
                width: "10%"
            },
            {
                dataField: "startTime",
                headerText: "START_TIME",
                editable: false,
                width: "13%"
            }, {
            dataField: "endTime",
            headerText: "END_TIME",
            editable: false,
            width: "13%"
        }, {
            dataField: "status",
            headerText: "STATUS",
            editable: false,
            width: "10%"
        }, {
            dataField: "exitCode",
            headerText: "EXIT_CODE",
            editable: false,
            width: "10%"
        }, {
            dataField: "exitMessage",
            editable: false,
            headerText: "EXIT_MESSAGE"
        }, {
            dataField: "stepName",
            headerText: "STEP_NAME",
            width: "10%",
            visible: false
        }, {
            dataField: "messageCount",
            headerText: "DETAIL",
            editable: false,
            width: "10%"
        }, {
            dataField: "stepExecutionId",
            headerText: "STEP_EXECUTION_ID",
            width: "10%",
            editable: false,
            visible: false
        }
        ];


    $(document).ready(function () {
        // 워드랩 적용
        var auiGridProps = {
            wordWrap: false
        };
        grdBatchID = GridCommon.createAUIGrid("grdBatchID", gridIfColumnLayout, null, auiGridProps);
        AUIGrid.resize(grdBatchID);
        AUIGrid.bind(grdBatchID, "cellDoubleClick", function (event) {
            var stepExecutionId = AUIGrid.getCellValue(grdBatchID, event.rowIndex, "stepExecutionId");
            var messageCount = AUIGrid.getCellValue(grdBatchID, event.rowIndex, "messageCount");
            if(messageCount > 0){
                Common.popupDiv("/common/monitoring/batchDetailPop.do", {stepExecutionId : stepExecutionId});
            }else{
                Common.setMsg("no data.");
            }
        });

        fn_getJobNames();

        $('#searchStartDt').val($.datepicker.formatDate('dd/mm/yy', new Date()));
        $('#searchEndDt').val($.datepicker.formatDate('dd/mm/yy', new Date()));

        $("#sStatus").multipleSelect("checkAll");
        $("#sExitCode").multipleSelect("checkAll");
    });


    function fn_search() {

        if (FormUtil.checkReqValue($("#searchStartDt")) || FormUtil.checkReqValue($("#searchEndDt"))) {
            var date = "<spring:message code='sys.msg.date' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ date +"'/>");
            return false;
        }

        Common.ajax(
            "GET",
            "/common/monitoring/getBatchList.do",
            $("#searchForm").serialize(),
            function (data, textStatus, jqXHR) { // Success
                AUIGrid.clearGridData(grdBatchID);
                AUIGrid.setGridData(grdBatchID, data);
            },
            function (jqXHR, textStatus, errorThrown) { // Error
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            }
        );
    }

    function fn_getJobNames() {
        CommonCombo.make("sJobName", "/common/monitoring/getJobNames.do", {}, "", {
            id: "jobName",
            name: "jobName"
        });
    }
</script>

<section id="content"><!-- content start -->
    <ul class="path">
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href=javascript:void(0); class="click_add_on"><spring:message
                code='sys.label.monitoring'/></a></p>
        <h2><spring:message code='sys.label.batch'/> <spring:message code='sys.label.monitoring'/></h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a onclick="fn_search()"><span class="search"></span><spring:message
                        code='sys.btn.search'/></a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->


    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:110px"/>
                    <col style="width:*"/>
                    <col style="width:110px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row"><spring:message code='sys.label.job'/></th>
                    <td>
                        <select class="" id="sJobName" name="jobName">
                        </select>
                    </td>
                    <th scope="row"><spring:message code='sys.label.search'/> <spring:message
                            code='sys.label.date'/></th>
                    <td colspan="">
                        <div class="date_set"><!-- date_set start -->
                            <p><input id="searchStartDt" name="searchStartDt" type="text" title=""
                                      placeholder="DD/MM/YYYY"
                                      class="j_date" readonly/></p>
                            <span>~</span>
                            <p><input id="searchEndDt" name="searchEndDt" type="text" title="" placeholder="DD/MM/YYYY"
                                      class="j_date" readonly/></p>
                        </div><!-- date_set end -->
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='sys.label.status'/></th>
                    <td>
                        <select class="multy_select" multiple="multiple" id="sStatus" name="status">
                            <option value="COMPLETED" selected>COMPLETED</option>
                            <option value="STARTING" selected>STARTING</option>
                            <option value="STARTED" selected>STARTED</option>
                            <option value="STOPPING" selected>STOPPING</option>
                            <option value="STOPPED" selected>STOPPED</option>
                            <option value="FAILED" selected>FAILED</option>
                            <option value="ABANDONED" selected>ABANDONED</option>
                            <option value="UNKNOWN" selected>UNKNOWN</option>
                        </select>
                    </td>
                    <th scope="row"><spring:message code='sys.label.exit'/> <spring:message code='sys.label.code'/></th>
                    <td>
                        <select class="multy_select" multiple="multiple" id="sExitCode" name="exitCode">
                            <option value="COMPLETED" selected>COMPLETED</option>
                            <option value="EXECUTING" selected>EXECUTING</option>
                            <option value="FAILED" selected>FAILED</option>
                            <option value="NOOP" selected>NOOP</option>
                            <option value="STOPPED" selected>STOPPED</option>
                            <option value="UNKNOWN" selected>UNKNOWN</option>
                        </select>
                    </td>
                </tr>
                </tbody>
            </table><!-- table end -->

            <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
            </aside><!-- link_btns_wrap end -->

        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->
        <div class="divine_auto"><!-- divine_auto start -->
            <aside class="title_line"><!-- title_line start -->
                <h3 class="pt0"><spring:message code='sys.label.batch'/> <spring:message
                        code='sys.label.monitoring'/></h3>
            </aside><!-- title_line end -->

            <article class="grid_wrap autoHeight"><!-- grid_wrap start -->
                <div id="grdBatchID" style="height:390px;"></div>
            </article><!-- grid_wrap end -->

        </div><!-- divine_auto end -->
    </section><!-- search_result end -->

</section>
<!-- content end -->