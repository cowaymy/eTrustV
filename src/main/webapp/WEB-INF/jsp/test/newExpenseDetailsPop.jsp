<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var clmSeq = 0;
var keyValueList = $.parseJSON('${taxCodeList}');

/* =========================
 * Grid Design -Start
 * =========================
 */

/* =========================
 * Normal Claim Grid - Start
 * =========================
 */
var myGridPros = {
    editable : true,
    softRemoveRowMode : false,
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160,
    selectionMode : "multipleCells"
};

var myGridColumnLayout = [ {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "expGrp",
    visible : false
}, {
    dataField : "clmSeq",
    visible : false
}, {
    dataField : "expType",
    visible : false
}, {
    dataField : "expTypeName",
    headerText : '<spring:message code="pettyCashNewExp.expTypeBrName" />',
    style : "aui-grid-user-custom-left",
    colSpan : 2
}, {
    dataField : "",
    headerText : '',
    width: 30,
    editable : false,
    renderer : {
        type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"
        },
        iconWidth : 24,
        iconHeight : 24,
        onclick : function(rowIndex, columnIndex, value, item) {
            console.log("CellClick rowIndex : " + rowIndex + ", columnIndex : " + columnIndex + " clicked");
            selectRowIdx = rowIndex;
            fn_PopExpenseTypeSearchPop();
            }
        },
    colSpan : -1
}, {
    dataField : "glAccCode",
    visible : false
}, {
    dataField : "glAccCodeName",
    visible : false
}, {
    dataField : "budgetCode",
    visible : false
}, {
    dataField : "budgetCodeName",
    visible : false
}, {
    dataField : "taxCode",
    headerText : '<spring:message code="newWebInvoice.taxCode" />',
    renderer : {
        type : "DropDownListRenderer",
        list : keyValueList,
        keyField : "taxCode",
        valueField : "taxName",
    }
}, {
    dataField : "taxName",
    visible : false
}, {
    dataField : "taxRate",
    dataType: "numeric",
    visible : false
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
    editable : false
}, {
    dataField : "gstBeforAmt",
    headerText : '<spring:message code="newWebInvoice.netAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true,
        allowPoint : true
    }
}, {
    dataField : "oriTaxAmt",
    dataType: "numeric",
    visible : false,
    expFunction : function( rowIndex, columnIndex, item, dataField ) {
        return (item.gstBeforAmt * (item.taxRate / 100));
    }
}, {
    dataField : "gstAmt",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true,
        allowPoint : true
    }
}, {
    dataField : "taxNonClmAmt",
    headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true,
        allowPoint : true
    }
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false,
    expFunction : function( rowIndex, columnIndex, item, dataField ) {
        return (item.gstBeforAmt + item.gstAmt + item.taxNonClmAmt);
    },
    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
        if(item.yN == "N") {
            return "my-cell-style";
        }
        return null;
    }
}, {
    dataField : "atchFileGrpId",
    visible : false
}
];
/* =========================
 * Normal claim Grid - End
 * =========================
 */

/* =========================
 * Car Mileage Claim Grid - Start
 * =========================
 */
 var mileageGridPros = {
    headerHeight : 20,
    editable : true,
    height : 175,
    showStateColumn : true,
    softRemoveRowMode : false,
    enableRestore : true,
    rowIdField : "id",
    selectionMode : "multipleCells"
};

var mileageGridColumnLayout = [ {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "expGrp",
    visible : false
}, {
    dataField : "clmSeq",
    visible : false
}, {
    dataField : "carMilagDt",
    headerText : '<spring:message code="pettyCashNewExp.date" />',
    editRenderer : {
        type : "CalendarRenderer",
        openDirectly : true,
        onlyCalendar : true,
        showExtraDays : true,
        titles : [gridMsg["sys.info.grid.calendar.titles.sun"], gridMsg["sys.info.grid.calendar.titles.mon"], gridMsg["sys.info.grid.calendar.titles.tue"], gridMsg["sys.info.grid.calendar.titles.wed"], gridMsg["sys.info.grid.calendar.titles.thur"], gridMsg["sys.info.grid.calendar.titles.fri"], gridMsg["sys.info.grid.calendar.titles.sat"]],
        formatYearString : gridMsg["sys.info.grid.calendar.formatYearString"],
        formatMonthString : gridMsg["sys.info.grid.calendar.formatMonthString"],
        monthTitleString : gridMsg["sys.info.grid.calendar.monthTitleString"]
    }
}, {

    headerText : '<spring:message code="newStaffClaim.location" />',
    children : [
        {
                dataField: "locFrom",
                headerText: '<spring:message code="newStaffClaim.from" />',
                style : "aui-grid-user-custom-left"
        }, {
                dataField: "locTo",
                headerText: '<spring:message code="newStaffClaim.to" />',
                style : "aui-grid-user-custom-left"
        }
    ]
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
    editable : false
}, {
    dataField : "carMilag",
    headerText : '<spring:message code="newStaffClaim.mileageBrKm" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true,
        allowPoint : true
    }
}, {
    dataField : "carMilagAmt",
    headerText : '<spring:message code="newStaffClaim.mileageBrAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false
}, {
    dataField : "tollAmt",
    headerText : '<spring:message code="newStaffClaim.tollsBrRm" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true,
        allowPoint : true
    }
}, {
    dataField : "parkingAmt",
    headerText : '<spring:message code="newStaffClaim.parkingBrRm" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true,
        allowPoint : true
    }
}, {
    dataField : "purpose",
    headerText : '<spring:message code="newStaffClaim.purpose" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.remark" />',
    style : "aui-grid-user-custom-left",
    width : 150
}
];
/* =========================
 * Car Mileage Claim Grid - End
 * =========================
 */

/* =========================
 * Grid Design -End
 * =========================
 */

var newGridID;
var mileageGridID;
var myGridID;

$(document).ready(function() {
    console.log("newExpenseDetailsPop :: ready :: start");

    // Layout display controlled by button clicked
    if("${claimType}" == "nc") {
        // Create Normal Claim Grid
        myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);
        $("#normalExp_radio").attr("checked", "checked");
        $("#carMileage_radio").attr("disabled", true);
    } else {
        // Create Car Mileage Claim Grid
        myGridID = AUIGrid.create("#mileage_grid_wrap", mileageGridColumnLayout, mileageGridPros);
        $("#carMileage_radio").attr("checked", "checked");
        $("#normalExp_radio").attr("disabled", true);

        if("${clamUn}" != "") {
            var data = {
                    clmNo : "${claimNo}",
                    clamUn : "${clamUn}",
                    claimType : "${claimType}"
            }

            Common.ajax("GET", "/test/selectStaffClaimInfo.do?_cacheId=" + Math.random(), data, fn_setStaffClaimInfo);
        }
    }

    fn_checkExpGrp();

    // Pop up event
    fn_setEvent();

    // General Button events caller
    $("#add_row").click(fn_addMyGridRow);
    $("#remove_row").click(fn_removeMyGridRow);

    $("#add_btn").click(claimDtls);
    $("#mileage_add").click(fn_mileageAdd);

    // Invoice Type change
    $("#invcType").change(function() {
        console.log($("#invcType").val())
        var invcType = $("#invcType").val();
        if(invcType == "F") {
            $("#gstRgistNoLbl").append("<span class='must'>*</span>");
        } else {
            $('span', "#gstRgistNoLbl").empty().remove();
        }
    })

    fn_getAllTotAmt
    console.log("newExpenseDetailsPop :: ready :: end");
});

/* =====================
 * Button Key Events Functions - Start
 * =====================
 */

function claimDtls() {
    console.log("saveDtls :: start");

    var clamUn = "";
    var detailData;
    if("${claimType}" == "nc") {
        detailData = AUIGrid.getOrgGridData(myGridID);
        clamUn = "";
    } else {
        detailData = AUIGrid.getOrgGridData(mileageGridID);
        clamUn = "${clamUn}";

        /*if("${clamUn}" != "") {
            console.log("Inactive existing CM");

            Common.ajax("GET", "/test/removeClaim.do", {claimNo : $("#claimNo").val(), clamUn : clamUn, clmType : "CM"}, function(iResult) {
                console.log(iResult);
            })
        }*/
    }
    fn_addRow($("#claimNo").val(), Number($("#allTotAmt_text").text().replace(/, /gi, "")), detailData, clamUn);

    //fn_selectSummary();

    console.log("saveDtls :: end");
}

function deleteFullDtls() {
    Common.confirm("Do you which to delete this invoice entry", fn_deleteDtl);
}

function fn_setStaffClaimInfo(result) {
    console.log("fn_setStaffClaimInfo");
    console.log(result);
    // Car Mileage Expense
    console.log("carMileage_radio checked");
    $("#normalExp_radio").prop("checked", false);
    $("#carMileage_radio").prop("checked", true);
    fn_checkExpGrp();

    $("#newCostCenter").val(result.costCentr);
    $("#newCostCenterText").val(result.costCentrName);
    $("#newMemAccId").val(result.memAccId);
    $("#newMemAccName").val(result.memAccName);
    $("#bankCode").val(result.bankCode);
    $("#bankName").val(result.bankName);
    $("#bankAccNo").val(result.bankAccNo);
    $("#newClmMonth").val(result.clmMonth);
    $("#expType").val(result.expType);
    $("#expTypeName").val(result.expTypeName);
    $("#glAccCode").val(result.glAccCode);
    $("#glAccCodeName").val(result.glAccCodeName);
    $("#budgetCode").val(result.budgetCode);
    $("#budgetCodeName").val(result.budgetCodeName);

    console.log(result);

    AUIGrid.setGridData(mileageGridID, result.itemGrp);
}

//

/* =====================
 * Button Key Events - End
 * =====================
 */

</script>

<!-- CSS -->
<style>
.tap_block{
    border:1px solid #ccc;
    padding:10px;
    border-radius:3px;
}
.tap_block2{
    margin-top:10px;
    border:1px solid #ccc;
    padding:10px;
    border-radius:3px;
}
</style>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Expenses Details</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newPopStaffClaim">
<input type="hidden" id="newCostCenterText" name="costCentrName">
<input type="hidden" id="newMemAccName" name="memAccName">
<input type="hidden" id="supplir" name="supplir">
<input type="hidden" id="bankCode" name="bankCode">
<input type="hidden" id="expType" name="expType">
<input type="hidden" id="budgetCode" name="budgetCode">
<input type="hidden" id="budgetCodeName" name="budgetCodeName">
<input type="hidden" id="glAccCode" name="glAccCode">
<input type="hidden" id="glAccCodeName" name="glAccCodeName">
<input type="hidden" id="taxRate">
<input type="hidden" id="claimNo" name="claimNo" value="${claimNo}">

<!-- ===================================================================================================================== -->

<ul class="right_btns mb10">
    <li><p class="btn_blue2"><a href="#" id="add_btn"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="delete_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
    <!-- <li><p class="btn_blue2"><a href="#" id="clear_btn"><spring:message code="pettyCashNewCustdn.clear" /></a></p></li> -->
</ul>

<!-- ===================================================================================================================== -->

<article class="tap_block2">
<aside class="title_line">
    <h2>Claim Details</h2>
</aside>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Claim Type</th>
    <td>
        <label>
            <input type="radio" id="normalExp_radio" name="expGrp" value="0"/><span><spring:message code="newStaffClaim.normalExp" /></span>
        </label>
        <label>
            <input type="radio" id="carMileage_radio" name="expGrp" value="1" /><span><spring:message code="newStaffClaim.carMileage" /></span>
        </label>
    </td>
</tr>
</tbody>
</table><!-- table end -->
<table class="type1" id="noMileage"><!-- table start --><!-- FCM0020D -->
    <caption><spring:message code="webInvoice.table" /></caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
        <tr>
            <th scope="row"><spring:message code="newWebInvoice.invoiceType" /></th>
            <td>
            <select class="w100p" id="invcType" name="invcType">
                <option value="0" selected>Choose One</option>
                <option value="F"><spring:message code="newWebInvoice.select.fullTax" /></option>
                <option value="S"><spring:message code="newWebInvoice.select.simpleTax" /></option>
            </select>
            </td>
       </tr>
       <tr>
            <th scope="row"><spring:message code="pettyCashNewExp.invcNo" /><span class='must'>*</span></th>
            <td>
                <input type="text" title="" placeholder="" class="w100p" id="invcNo" name="invcNo" autocomplete=off/>
            </td>
            <th scope="row"><spring:message code="webInvoice.invoiceDate" /><span class='must'>*</span></th>
            <td>
                <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="invcDt" name="invcDt" />
            </td>
       </tr>
        <tr>
            <th scope="row"><spring:message code="pettyCashNewExp.supplierName" /></th>
            <td>
                <input type="text" title="" placeholder="" class="w100p" id="supplirName" name="supplirName"/>
            </td>
            <th scope="row" id="gstRgistNoLbl"><spring:message code="pettyCashNewExp.gstRgistNo" /></th>
            <td>
                <input type="text" title="" placeholder="" class="w100p" id="gstRgistNo" name="gstRgistNo" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="newWebInvoice.remark" /></th>
            <td colspan="3">
                <input type="text" title="" placeholder="" class="w100p" id="expDesc" name="expDesc" />
            </td>
        </tr>
    </tbody>
</table><!-- table end -->

<!-- ===================================================================================================================== -->

<table class="type1" id="claimAttachment"><!-- table start --><!-- FCM0020D -->
    <caption><spring:message code="webInvoice.table" /></caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
        <tr>
            <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
            <td colspan="3" id="attachTd">
                <div class="auto_file2 auto_file3"><!-- auto_file start -->
                    <input type="file" title="file add" />
                </div><!-- auto_file end -->
            </td>
        </tr>
    </tbody>
</table><!-- table end -->

<!-- ===================================================================================================================== -->

<!-- Normal Claim Grid and Button - Start -->
<aside class="title_line" id="myGird_btn"><!-- title_line start -->
    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#" id="add_row"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
        <li><p class="btn_grid"><a href="#" id="remove_row"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
    </ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="my_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
<!-- Normal Claim Grid and Button - End -->

<!-- ===================================================================================================================== -->

<!-- Mileage Claim Grid and Button - Start -->
<aside class="title_line" id="mileage_btn" style="display: none;"><!-- title_line start -->
    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#" id="mileage_add"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
        <%-- <li><p class="btn_grid"><a href="#" id="mileage_remove"><spring:message code="newWebInvoice.btn.delete" /></a></p></li> --%>
    </ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="mileage_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
<!-- 파일 input , 감춰놓기 -->
<input type="file" id="file" style="display: none;"></input>
<!-- Mileage Claim Grid and Button - End -->
</article>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->