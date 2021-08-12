<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    var gridID;

    $(document).ready(function() {
        createAUIGrid();

        AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
            fn_setDetail(gridID, event.rowIndex);
        });

        if("${SESSION_INFO.userTypeId}" != "4") {
            if("${SESSION_INFO.memberLevel}" == "1") {
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("readonly", true);

            } else if("${SESSION_INFO.memberLevel}" == "2") {
                $("#orgCode").val("${orgCode}");
                $("#grpCode").val("${grpCode}");

                $("#orgCode").attr("readonly", true);
                $("#grpCode").attr("readonly", true);

            } else if("${SESSION_INFO.memberLevel}" == "3") {
                $("#orgCode").val("${orgCode}");
                $("#grpCode").val("${grpCode}");
                $("#deptCode").val("${deptCode}");

                $("#orgCode").attr("readonly", true);
                $("#grpCode").attr("readonly", true);
                $("#deptCode").attr("readonly", true);

            } else if("${SESSION_INFO.memberLevel}" == "4") {
                $("#orgCode").val("${orgCode}");
                $("#grpCode").val("${grpCode}");
                $("#deptCode").val("${deptCode}");
                $("#memCode").val("${memCode}");

                $("#orgCode").attr("readonly", true);
                $("#grpCode").attr("readonly", true);
                $("#deptCode").attr("readonly", true);
                $("#memCode").attr("readonly", true);
            }
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

    function fn_creditPoints() {
        Common.popupDiv("/incentive/goldPoints/uploadPointsPop.do", null, null, true, "uploadPointsPop");
    }

    function fn_setDetail(gridID, rowIdx){
        Common.popupDiv("/incentive/goldPoints/viewPointsDetailPop.do", { memCode : AUIGrid.getCellValue(gridID, rowIdx, "memCode") }, null, true, "viewPointsDetailPop");
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
          <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_creditPoints();">Credit Points</a></p></li>
          </c:if>
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

    <article class="grid_wrap" id="grid_wrap"></article>

</section>