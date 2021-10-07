<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    var gridID;

    $(document).ready(function() {
        createAUIGrid();

        AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
            fn_setDetail(gridID, event.rowIndex);
        });

        if("${SESSION_INFO.userTypeId}" != "4" && "${SESSION_INFO.userTypeId}" != "6") {
        	$("#orgCode").val("${orgCode}");
            $("#grpCode").val("${grpCode}");
            $("#deptCode").val("${deptCode}");
            $("#memCode").val("${memCode}");

            $("#orgCode").attr("readonly", true);
            $("#grpCode").attr("readonly", true);
            $("#deptCode").attr("readonly", true);
            $("#memCode").attr("readonly", true);
        }

    });

    function createAUIGrid() {
        var columnLayout = [{
        	dataField : "gpItmId",
            headerText : "Gold Points ID",
            visible : false
        }, {
            dataField : "memCode",
            headerText : "Member Code",
            width : "10%"
        }, {
            dataField : "memName",
            headerText : "Member Name",
            width : "30%"
        }, {
            dataField : "status",
            headerText : "Status",
            width : "10%"
        }, {
            dataField : "positionDesc",
            headerText : "Position Desc",
            width : "20%"
        }, {
            dataField : "totBalPts",
            headerText : "Gold Points Available",
            width : "30%"
        }];

        var gridOpt = {
                usePaging : true,
                pageRowCount : 20,
                editable : false,
                showStateColumn : false,
                showRowNumColumn : true
        }

        gridID = AUIGrid.create("#grid_wrap", columnLayout, gridOpt);
    }

    function fn_search() {
        Common.ajax("GET", "/incentive/goldPoints/searchPointsSummary.do", $("#searchForm").serialize(), function(result) {
           console.log(result);
           AUIGrid.setGridData(gridID, result);
        });
    }

    function fn_setDetail(gridID, rowIdx){
        Common.popupDiv("/incentive/goldPoints/viewPointsDetailPop.do", { memCode : AUIGrid.getCellValue(gridID, rowIdx, "memCode") }, null, true, "viewPointsDetailPop");
    }

    function fn_excelDownGoldPoints() {
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon
            .exportTo("grid_wrap", "xlsx",
                "<spring:message code='incentive.title.goldPointsList'/>");
    }

    function fn_generateGpRawData() {

        //set date portion for report download filename - start
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        if (month < 10) {
          month = "0" + month;
        }
        //set date portion for report download filename - end

        var $reportForm = $("#reportForm")[0];

        $($reportForm).empty(); //remove children

        var reportDownFileName = "GoldPointsRawData_" + day + month + date.getFullYear(); //report name
        var reportFileName = "/misc/GoldPointsRawData_Excel.rpt"; //reportFileName
        var reportViewType = "EXCEL"; //viewType

        //default input setting
        $($reportForm).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
        $($reportForm).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
        $($reportForm).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type

        //default setting
        $("#reportForm #reportFileName").val(reportFileName);
        $("#reportForm #reportDownFileName").val(reportDownFileName);
        $("#reportForm #viewType").val(reportViewType);

        //report 호출
        var option = {
            isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
        };
        Common.report("reportForm", option);
    }

</script>

<section id="content">

    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Incentive Rewards</li>
        <li>Gold Points Redemption</li>
        <li>Points Summary</li>
    </ul>

    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Points Summary</h2>
        <ul class="right_btns">
          <li><p class="btn_blue"><a href="javascript:fn_search();">Search</a></p></li>
        </ul>
    </aside>

    <form action="#" id="searchForm" method="post">
        <table class="type1">
            <caption>table</caption>
            <colgroup>
                <col style="width:130px" />
                <col style="width:*" />
                <col style="width:130px" />
                <col style="width:*" />
                <col style="width:130px" />
                <col style="width:*" />
                <col style="width:130px" />
                <col style="width:*" />
            </colgroup>

            <tbody>
                <tr>
                    <th scope="row">Member Type</th>
                    <td>
                        <select class="w100p" id="cmbMemType" name="cmbMemType">
                            <option value="" selected>Select Account</option>
                            <c:forEach var="list" items="${memberType}" varStatus="status">
                                <option value="${list.codeId}">${list.codeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th scope="row">Member Code</th>
                    <td>
                        <input type="text" title="Member Code" placeholder="" class="w100p" id="memCode" name="memCode" />
                    </td>
                    <th scope="row">Member Name</th>
                    <td>
                        <input type="text" title="Member Name" placeholder="" class="w100p" id="memName" name="memName" />
                    </td>
                    <th scope="row">IC Number</th>
                    <td>
                        <input type="text" title="IC Number" placeholder="" class="w100p" id="icNum" name="icNum" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Organization Code</th>
                    <td>
                        <input type="text" title="Organization Code" placeholder="Organization Code" class="w100p" id="orgCode" name="orgCode" />
                    </td>
                    <th scope="row">Group Code</th>
                    <td>
                        <input type="text" title="Group Code" placeholder="Group Code" class="w100p" id="grpCode" name="grpCode" />
                    </td>
                    <th scope="row">Department Code</th>
                    <td>
                        <input type="text" title="Department Code" placeholder="Department Code" class="w100p" id="deptCode" name="deptCode" />
                    </td>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="status" name="status">
                            <option value="" selected>Select Account</option>
                            <c:forEach var="list" items="${status }" varStatus="status">
                                <option value="${list.statuscodeid}">${list.name}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>

    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid">
                <a href="#" onClick="fn_excelDownGoldPoints()"><spring:message code='service.btn.Generate' /></a>
                </p></li>
        </c:if>
    </ul>

    <!-- Link Wrap Start -->
    <article class="link_btns_wrap">
        <p class="show_btn">
            <a href="#"><img
                src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
                alt="link show" /></a>
        </p>
        <dl class="link_list">
            <dt>
                <spring:message code="sal.title.text.link" />
            </dt>
            <dd>
                <ul class="btns">
                    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                    <li><p class="link_btn"><a href="#" onClick="fn_generateGpRawData()">GP Raw Data</a></p></li>
                    </c:if>
                </ul>
                <p class="hide_btn">
                    <a href="#"><img
                        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
                        alt="hide" /></a>
                </p>
            </dd>
        </dl>
    </article>
    <!-- Link Wrap End -->

    <article class="grid_wrap" id="grid_wrap"></article>

    <!-- crystal report -->
    <form name="reportForm" id="reportForm" method="post"></form>

</section>