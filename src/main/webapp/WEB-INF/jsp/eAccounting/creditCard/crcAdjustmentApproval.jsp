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
            dataField : "isActive",
            headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
            width: 30,
            renderer : {
                type : "CheckBoxEditRenderer",
                showLabel : false,
                editable : true,
                checkValue : "Active",
                unCheckValue : "Inactive",
                disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                    if(item.appvStus == "A" || item.appvStus == "J")
                        return true;
                    return false;
                }
            }
        },{
            dataField : "adjNo",
            headerText : "Adjustment No",
            width : 120
        }, {
            dataField : "submissionDate",
            headerText : "Submission Date",
            width : 130
        }, {
            dataField : "crcName",
            headerText : "Cardholder Name",
            width : 250
        }, {
            dataField : "period",
            headerText : "Month /Year",
            width : 120
        }, {
            dataField : "costCenter",
            headerText : "Cost Center",
            width : 120,
            style : "aui-grid-user-custom-left"
        }, {
            dataField : "costCenterDesc",
            headerText : "Cost Center Description",
            width : 175,
            style : "aui-grid-user-custom-left"
        }, {
            dataField : "adjType",
            headerText : "Adjustment Type",
            width : 250,
            style : "aui-grid-user-custom-left"
        }, {
            dataField : "adjAmt",
            headerText : "Amount",
            width : 100,
            dataType: "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
        }, {
            dataField : "adjRem",
            headerText : "Remark",
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
            usePaging : true,
            pageRowCount : 20,
            showRowCheckColumn : false,
            showRowNumColumn : false,
            selectionMode : "multipleCells"
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
console.log("dblClick : appvStus :: " + event.item.appvStus);
            if(event.item.appvStus == "R" || event.item.appvStus == "P") {
                // Request / Pending
                obj = {
                        docNo : event.item.adjNo,
                        mode : "A"
                };
            } else  {
                // Approved / Rejected
                obj = {
                        docNo : event.item.adjNo,
                        mode : "V"
                };
            }

            fn_adjustmentPop(obj);
        });

        $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    });

    function fn_listAdjApp() {
        // Validation
        if(FormUtil.isEmpty($("#frAdjPeriod").val())) {
            Common.alert("Please enter from period");
            return false;
        }

        if(FormUtil.isEmpty($("#toAdjPeriod").val())) {
            Common.alert("Please enter to period");
            return false;
        }

        Common.ajax("GET", "/eAccounting/creditCard/selectAdjustmentAppvList.do?", $("#adjustmentForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(allowanceAdjGridID, result);
        });
    }

    function fn_costCenterSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
    }

    function fn_setCostCenter() {
        $("#costCenter").val($("#search_costCentr").val());
        $("#costCenterDesc").val($("#search_costCentrName").val());
    }

    function fn_adjustmentPop(v) {
        console.log("fn_adjustmentPop");
        console.log(v);

        Common.popupDiv("/eAccounting/creditCard/crcAdjustmentPop.do", v, null, true, "crcAdjustmentPop");
    }

    function fn_bulkApproval(v) {
        console.log("fn_bulkApproval");
        var adjAppList = AUIGrid.getItemsByValue(allowanceAdjGridID, "isActive", "Active");

        if(adjAppList.length == 0) {
            Common.alert("No data selected.");
        } else {
            if(v == "A") {
                // Approve
                Common.alert("Confirm to approve these adjustments?", function(result) {
                    var obj = {
                            action : v,
                            grid : adjAppList
                    };

                    Common.ajax("POST", "/eAccounting/creditCard/approvalUpdate.do", obj, function(result) {
                        console.log(result);
                        Common.alert("Adjustment(s) approved");
                    });
                });

            } else {
                // Reject
                Common.alert("Confirm to reject these adjustments?", function(result) {
                    $("#rejectAdjPop").show();
                });
            }
        }
    }

    function fn_rejectProceed(v) {
        console.log("fn_rejectProceed");
        if(v == "P") {
            // v = P (Proceed)
            if($("#rejctResn").val() == null || $("#rejctResn").val() == "") {
                Common.alert("Reject reason cannot be empty");
                return false;
            }

            var obj = {
                    action : 'J',
                    rejctResn : $("#rejctResn").val(),
                    grid : AUIGrid.getItemsByValue(allowanceAdjGridID, "isActive", "Active")
            };

            Common.ajax("POST", "/eAccounting/creditCard/approvalUpdate.do", obj, function(result) {
                console.log(result);
                Common.alert("Adjustment(s) rejected");
                $("#rejectAdjPop").hide();
                $("#rejctResn").val("");

                fn_listAdjApp();
            });
        }
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
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_listAdjApp()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
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
                        <th scope="row">Cost Center</th>
                        <td>
                            <input type="text" title="" placeholder="" class="" id="costCenter" name="costCenter" />
                            <a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Credit Cardholder Name/Number</th>
                        <td>
                            <select class="w100p multy_select" multiple="multiple" id="crcDropdown" name="crcDropdown">
                                <c:forEach var="list" items="${crcHolder}" varStatus="status">
                                    <option value="${list.crcId}">${list.crcInfo}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <th scope="row">Cost Center Description</th>
                        <td>
                            <input type="text" title="" placeholder="" class="w100p" id="costCenterDesc" name="costCenterDesc" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Adjustment Number</th>
                        <td>
                            <input type="text" title="Adjustment Number" placeholder="Adjustment Number" class="w100p" id="adjNo" name="adjNo" />
                        </td>
                        <th scope="row">Adjustment Type</th>
                        <td>
                            <select class="w100p multy_select" multiple="multiple" id="adjType" name="adjType">
                                <option value="">Choose One</option>
                                <option value="1">Transfer between Credit Card Holder</option>
                                <option value="2">Transfer between Period</option>
                                <option value="3">Addition</option>
                                <option value="4">Deduction</option>
                            </select>
                        </td>
                    </tr>
                    <!--
                    <tr>
                        <th scope="row">Status</th>
                        <td>
                            <select class="w100p multy_select" multiple="multiple" id="status" name="status">
                                <option value="">Choose One</option>
                                <option value="D">Draft</option>
                                <option value="R">Request</option>
                                <option value="A">Approved</option>
                                <option value="J">Rejected</option>
                            </select>
                        </td>
                    </tr>
                     -->
                </tbody>
            </table>
        </form>
    </section>

    <section class="search_result">
        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#" onclick="javascript:fn_bulkApproval('A')" id="approve_btn"><spring:message code="invoiceApprove.title" /></a></p></li>
            <li><p class="btn_grid"><a href="#" onclick="javascript:fn_bulkApproval('J')" id="reject_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
        </ul>

        <article class="grid_wrap" id="allowanceAdj_grid_wrap"></article>
    </section>

    <div class="popup_wrap msg_box" id="rejectAdjPop" style="display:none">
        <header class="pop_header">
            <h1>Reject Reason</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
            </ul>
        </header>

        <section class="pop_body">
            <p class="msg_txt">
                <spring:message code="rejectionWebInvoiceMsg.registMsg" />
                <textarea cols="20" rows="5" id="rejctResn" placeholder="Reject reason max 400 characters"></textarea>
            </p>

            <ul class="center_btns">
                <li><p class="btn_blue"><a href="#" onclick="javascript:fn_rejectProceed('P')">Proceed</a></p></li>
                <li><p class="btn_blue"><a href="#" onclick="javascript:fn_rejectProceed('C')">Cancel</a></p></li>
            </ul>
        </section>
    </div>
</section>