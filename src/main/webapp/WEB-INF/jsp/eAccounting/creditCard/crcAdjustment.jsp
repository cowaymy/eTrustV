<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 첨부파일 버튼 스타일 재정의*/
.aui-grid-button-renderer {
     width:100%;
     padding: 4px;
 }
</style>
<script type="text/javascript">
    var clickType = "";
    var crcId = 0;
    var checkRemoved = false;

    var allowanceAdjGridID;

    var allowanceAdjColLayout = [
        {
            dataField : "adjNo",
            headerText : "Adjustment No",
            width : 150
        }, {
            dataField : "submissionDate",
            headerText : "Submission Date",
            width : 130
        }, {
            dataField : "crcName",
            headerText : "Cardholder Name",
            width : 250
        }, {
            dataField : "crcNo",
            headerText : "Card Number",
            width : 160
        }, {
            dataField : "period",
            headerText : "Month /Year",
            width : 120
        }, {
            dataField : "adjType",
            headerText : "Adjustment Type",
            width : 300,
            style : "aui-grid-user-custom-left"
        }, {
            dataField : "adjAmt",
            headerText : "Amount",
            width : 100,
            dataType: "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
        }, {
            dataField : "requestor",
            headerText : "Requestor",
            width : 200
        }, {
            dataField : "appvStus",
            visible : false
        }, {
            dataField : "appvStusName",
            headerText : "Approval Status",
            width : 130
        }
    ];

    var allowanceAdjGridPros = {
            usePaging : false,
            showStateColumn : false,
            showRowNumColumn : false
    };

    $(document).ready(function () {
        console.log("crcAdjustment.jsp");
        allowanceAdjGridID = AUIGrid.create("#allowanceAdj_grid_wrap", allowanceAdjColLayout, allowanceAdjGridPros);

        // Default year
        var date = new Date();
        var year = date.getFullYear();
        $("#frAdjPeriod").val("01/" + year);
        $("#toAdjPeriod").val("12/" + year);

        AUIGrid.bind(allowanceAdjGridID, "cellDoubleClick", function(event) {
            var obj;

            /*
            if(event.item.appvStus == "R" || event.item.appvStus == "P") {
                // Request / Pending
                obj = {
                        docNo : event.item.adjNo,
                        mode : "A"
                };
            } else if(event.item.appvStus == "A" || event.item.appvStus == "J") {
            */
            if(event.item.appvStus == "R" || event.item.appvStus == "P" || event.item.appvStus == "A" || event.item.appvStus == "J") {
                // Approved / Rejected
                obj = {
                        docNo : event.item.adjNo,
                        mode : "V"
                };
            } else {
                // Draft
                obj = {
                        docNo : event.item.adjNo,
                        mode : "E"
                };
            }

            fn_adjustmentPop(obj);
        });
    });

    function fn_listAdjPln() {
        // Validation
        if(FormUtil.isEmpty($("#frAdjPeriod").val())) {
            Common.alert("Please enter from period");
            return false;
        }

        if(FormUtil.isEmpty($("#toAdjPeriod").val())) {
            Common.alert("Please enter to period");
            return false;
        }

        Common.ajax("GET", "/eAccounting/creditCard/selectAdjustmentList.do?", $("#adjustmentForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(allowanceAdjGridID, result);
        });
    }

    function fn_adjustmentPop(v) {
        console.log("fn_adjustmentPop");
        console.log(v);

        Common.popupDiv("/eAccounting/creditCard/crcAdjustmentPop.do", v, null, true, "crcAdjustmentPop");
    }

    function fn_costCenterSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
    }

    function fn_setCostCenter() {
        $("#costCenter").val($("#search_costCentr").val());
        /* $("#costCenterText").val($("#search_costCentrName").val()); */
    }
</script>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
        <h2>Allowance Limit Adjustment</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_adjustmentPop({mode:'N'})">New Adjustment</a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_listAdjPln()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
        </ul>
    </aside>

    <section class="search_table">
        <form action="#" method="post" id="adjustmentForm">
            <input type="hidden" id="crditCardUserId" name="crditCardUserId">
            <input type="hidden" id="chrgUserId" name="chrgUserId">
            <input type="hidden" id="costCenterText" name="costCentrName">

            <table class="type1">
                <caption><spring:message code="webInvoice.table" /></caption>
                <colgroup>
                    <col style="width:250px" />
                    <col style="width:*" />
                    <col style="width:250px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Month/Year</th>
                        <td>
                            <p><input type="text" id="frAdjPeriod" name="frAdjPeriod" title="" placeholder="" class="j_date2 w100p" /></p>
                            <span>~</span>
                            <p><input type="text" id="toAdjPeriod" name="toAdjPeriod" title="" placeholder="" class="j_date2 w100p" /></p>
                        </td>
                        <th scope="row">Adjustment Type</th>
                        <td>
                            <select class="w100p multy_select" multiple="multiple" id="selAdjType" name="selAdjType">
                                <option value="1">Transfer between Credit Card Holder</option>
                                <option value="2">Transfer between Period</option>
                                <option value="3">Addition</option>
                                <option value="4">Deduction</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Adjustment Number</th>
                        <td>
                            <div class="date_set w100p">
                                <p><input type="text" title="From Adjustment Number" placeholder="From Adjustment Number" class="w100p" id="frAdjNo" name="frAdjNo" /></p>
                                <span>To</span>
                                <p><input type="text" title="To Adjustment Number" placeholder="To Adjustment Number" class="w100p" id="toAdjNo" name="toAdjNo" /></p>
                            </div>
                        </td>
                        <th scope="row">Credit Cardholder Name/Number</th>
                        <td>
                            <select class="w100p multy_select" multiple="multiple" id="crcDropdown" name="crcDropdown">
                                <c:forEach var="list" items="${crcHolder}" varStatus="status">
                                    <option value="${list.crcId}">${list.crcInfo}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Cost Center</th>
                        <td>
                            <input type="text" title="" placeholder="" class="" id="costCenter" name="costCenter" />
                            <a href="#" class="search_btn" id="search_costCenter_btn" onclick="javascript:fn_costCenterSearchPop()"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                        <th scope="row">Status</th>
                        <td>
                            <select class="w100p multy_select" multiple="multiple" id="status" name="status">
                                <option value="D">Draft</option>
                                <option value="R">Request</option>
                                <option value="A">Approved</option>
                                <option value="J">Rejected</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </section>

    <section class="search_result">
        <article class="grid_wrap" id="allowanceAdj_grid_wrap"></article>
    </section>

</section>