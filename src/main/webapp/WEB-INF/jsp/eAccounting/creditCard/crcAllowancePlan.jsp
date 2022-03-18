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

    var allowancePlanGridID;

    var allowancePlanColLayout = [
        {
            dataField : "crcId",
            visible : false
        }, {
            dataField : "crcHolderNm",
            headerText : "Cardholder Name",
            width : 300
        }, {
            dataField : "crcNo",
            headerText : "Card No.",
            width : 200
        }, {
            dataField : "crcPic",
            headerText : "Card No.",
            width : 200
        }, {
            dataField : "crcCostCenter",
            headerText : "Cost Center",
            width : 120
        }, {
            dataField : "crcCostCenterDesc",
            headerText : "Cost Center Description",
            width : 250
        }, {
            dataField : "m1",
            headerText : "Jan",
            width : 75
        }, {
            dataField : "m2",
            headerText : "Feb",
            width : 75
        }, {
            dataField : "m3",
            headerText : "Mar",
            width : 75
        }, {
            dataField : "m4",
            headerText : "Apr",
            width : 75
        }, {
            dataField : "m5",
            headerText : "May",
            width : 75
        }, {
            dataField : "m6",
            headerText : "Jun",
            width : 75
        }, {
            dataField : "m7",
            headerText : "Jul",
            width : 75
        }, {
            dataField : "m8",
            headerText : "Aug",
            width : 75
        }, {
            dataField : "m9",
            headerText : "Sep",
            width : 75
        }, {
            dataField : "m10",
            headerText : "Oct",
            width : 75
        }, {
            dataField : "m11",
            headerText : "Nov",
            width : 75
        }, {
            dataField : "m12",
            headerText : "Dec",
            width : 75
        }
    ];

    var allowancePlanGridPros = {
            usePaging : false,
            showStateColumn : false,
            showRowNumColumn : false
    };

    $(document).ready(function () {
        console.log("crcAllowancePlan.jsp");
        allowancePlanGridID = AUIGrid.create("#allowancePlan_grid_wrap", allowancePlanColLayout, allowancePlanGridPros);

        // Default year
        var date = new Date();
        var year = date.getFullYear();
        $("#year").val(year);

        AUIGrid.bind(allowancePlanGridID, "cellDoubleClick", function(event) {
            var colIndex = event.columnIndex;
            crcId = event.item.crcId;

            if(colIndex > 5) {
                var month = event.dataField.replace("m", "");
                console.log("cellDoubleClick :: crcId :: " + crcId);
                console.log("cellDoubleClick :: year :: " + $("#year").val());
                console.log("cellDoubleClick :: month :: " + month);

                var clmMonth;

                if(month.length < 2) {
                    clmMonth = year + "0" + month;
                } else {
                    clmMonth = year + month;
                }

                Common.popupDiv("/eAccounting/creditCard/monthlyAllowancePop.do", {crcId : crcId, year : $("#year").val(), month : month, clmMonth : clmMonth}, null, true, "monthlyAllowancePop");
            }
        });
    });

    function fn_listAllowancePln() {
        // Validation
        if(FormUtil.isEmpty($("#year").val())) {
            Common.alert("Please enter year");
            return false;
        }

        Common.ajax("GET", "/eAccounting/creditCard/selectAllowancePlan.do?", $("#allowanceForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(allowancePlanGridID, result);
        });
    }

    function fn_setGridData(gridId, data) {
        console.log(data);
        AUIGrid.setGridData(gridId, data);
    }

    function fn_adjustmentPop() {
        console.log("crcAllowancePlan :: fn_adjustmentPop");

        Common.popupDiv("/eAccounting/creditCard/crcAdjustmentPop.do", {mode : "N"}, null, true, "crcAdjustmentPop");
    }

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCrditCardUserName").val())) {
        Common.alert('<spring:message code="crditCardMgmt.cardholder.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newChrgUserName").val())) {
        Common.alert('<spring:message code="crditCardMgmt.chargeName.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('<spring:message code="crditCardMgmt.chargeDepart.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#crditCardNo1").val()) || FormUtil.isEmpty($("#crditCardNo2").val()) || FormUtil.isEmpty($("#crditCardNo3").val()) || FormUtil.isEmpty($("#crditCardNo4").val())) {
        Common.alert('<spring:message code="crditCardMgmt.crditCardNo.msg" />');
        checkResult = false;
        return checkResult;
    }
    return checkResult;
}

function fn_viewMgmtPop() {
    if(crditCardSeq == 0) {
        Common.alert('<spring:message code="crditCardMgmt.selectData.msg" />');
    } else {
        var data = {
                crditCardSeq : crditCardSeq,
                callType : "view"
        };
        Common.popupDiv("/eAccounting/creditCard/viewMgmtPop.do", data, null, true, "viewMgmtPop");
    }
}

function fn_removeRegistMsgPop() {
    if(crditCardSeq == 0) {
        Common.alert('<spring:message code="crditCardMgmt.selectData.msg" />');
    } else {
        if(checkRemoved) {
            Common.alert('<spring:message code="crditCardMgmt.alreadyDel.msg" />');
        } else {
            Common.popupDiv("/eAccounting/creditCard/removeRegistMsgPop.do", null, null, true, "registMsgPop");
        }
    }
}
</script>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
        <h2>Allowance Limit Plan</h2>
        <ul class="right_btns">
<li><p class="btn_blue"><a href="#" onclick="javascript:fn_adjustmentPop()"><span class="search"></span>New Adjustment</a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_listAllowancePln()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
        </ul>
    </aside>

    <section class="search_table">
        <form action="#" method="post" id="allowanceForm">
            <input type="hidden" id="crditCardUserId" name="crditCardUserId">
            <input type="hidden" id="chrgUserId" name="chrgUserId">
            <input type="hidden" id="costCenterText" name="costCentrName">

            <table class="type1">
                <caption><spring:message code="webInvoice.table" /></caption>
                <colgroup>
                    <col style="width:170px" />
                    <col style="width:*" />
                    <col style="width:210px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Year</th>
                        <td>
                            <input type="text" title="" placeholder="" class="w100p" id="year" name="year" />
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
                        <th scope="row">Month</th>
                        <td>
                            <p class=""><input type="text" id="stMonth" name="stMonth" title="" placeholder="" class="w100p" value="1" /></p>
                            <span>~</span>
                            <p class=""><input type="text" id="edMonth" name="edMonth" title="" placeholder="" class="w100p" value="12" /></p>
                        </td>
                        <th scope="row">Person-In-Charge Name</th>
                        <td>
                            <select class="w100p multy_select" multiple="multiple" id="crcPic" name="crcPic">
                                <c:forEach var="list" items="${crcPic}" varStatus="status">
                                    <option value="${list.crcId}">${list.crcPic}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </section>

    <section class="search_result">
        <article class="grid_wrap" id="allowancePlan_grid_wrap"></article>
    </section>

</section>