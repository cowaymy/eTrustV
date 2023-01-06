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
            width : 160
        }, {
            dataField : "crcNo",
            headerText : "Card No.",
            width : 150
        }, {
            dataField : "crcPic",
            headerText : "Person-In-Charge Name",
            width : 160
        }, {
            dataField : "crcCostCenter",
            headerText : "Cost Center",
            width : 80
        }, {
            dataField : "crcCostCenterDesc",
            headerText : "Cost Center Description",
            width : 150
        }, {
            dataField : "m1",
            headerText : "Jan",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m2",
            headerText : "Feb",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m3",
            headerText : "Mar",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m4",
            headerText : "Apr",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m5",
            headerText : "May",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m6",
            headerText : "Jun",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m7",
            headerText : "Jul",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m8",
            headerText : "Aug",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m9",
            headerText : "Sep",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m10",
            headerText : "Oct",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m11",
            headerText : "Nov",
            width : 75,
            labelFunction : currencyCellFormatText
        }, {
            dataField : "m12",
            headerText : "Dec",
            width : 75,
            labelFunction : currencyCellFormatText
        }
    ];

    var allowancePlanGridPros = {
            usePaging : false,
            showStateColumn : false,
            fixedColumnCount : 6
    };

    $(document).ready(function () {
        console.log("crcAllowanceSummary.jsp");
        allowancePlanGridID = AUIGrid.create("#allowancePlan_grid_wrap", allowancePlanColLayout, allowancePlanGridPros);

        // Default year
        var date = new Date();
        var year = date.getFullYear();
        $("#year").val(year);

        AUIGrid.bind(allowancePlanGridID, "cellDoubleClick", function(event) {
            var colIndex = event.columnIndex;
            crcId = event.item.crcId;
            var year = $("#year").val();
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

        Common.ajax("GET", "/eAccounting/creditCard/selectAllowanceSummary.do?", $("#allowanceForm").serialize(), function(result) {
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

    function fn_excelDown() {
        console.log("fn_excelDown");
        GridCommon.exportTo("allowancePlan_grid_wrap", "xlsx", "AllowancePlanSummary");
    }

    function currencyCellFormatText(rowIndex, columnIndex, value, headerText, item, dataField){
    	if(value != null && value != ""){
        	var data = parseFloat(value).toFixed(2);
        	var text = data.toString().replace(/(?<!\..*)(\d)(?=(?:\d{3})+(?:\.|$))/g, '$1,');
            return text;
    	}
    	else{
    		return "0.00";
    	}
    }
</script>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
        <h2>Allowance Limit Summary</h2>
        <ul class="right_btns">
        <!-- <li><p class="btn_blue"><a href="#" onclick="javascript:fn_adjustmentPop()"><span class="search"></span>New Adjustment</a></p></li> -->
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
                            <p class=""><input style="background-color: #edebeb;" type="text" id="stMonth" name="stMonth" title="" placeholder="" class="w100p" value="1" readonly/></p>
                            <span>~</span>
                            <p class=""><input style="background-color: #edebeb;" type="text" id="edMonth" name="edMonth" title="" placeholder="" class="w100p" value="12" readonly/></p>
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

    <ul class="right_btns">
        <li><p class="btn_grid"><a href="javascript:fn_excelDown();">GENERATE</a></p></li>
    </ul>

    <section class="search_result">
        <article class="grid_wrap" id="allowancePlan_grid_wrap"></article>
    </section>

</section>