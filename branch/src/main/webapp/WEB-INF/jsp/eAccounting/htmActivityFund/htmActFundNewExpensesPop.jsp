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
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#my_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
}
</style>

<script type="text/javascript">
    var clmNo = "";
    var clmSeq = 0;
    var atchFileGrpId;
    var attachList;
    var callType = "${callType}";
    var selectRowIdx;
    var deleteRowIdx;
    var expTypeName;

    //file action list
    var update = new Array();
    var remove = new Array();

    var newGridColumnLayout = [
        {
            dataField : "clamUn",
            headerText : '<spring:message code="newWebInvoice.seq" />'
        }, {
            dataField : "expGrp",
            visible : false
        }, {
            dataField : "clmSeq",
            visible : false
        }, {
            dataField : "costCentr",
            visible : false
        }, {
            dataField : "costCentrName",
            visible : false
        }, {
            dataField : "memAccId",
            visible : false
        }, {
            dataField : "bankCode",
            visible : false
        }, {
            dataField : "bankAccNo",
            visible : false
        }, {
            dataField : "clmMonth",
            visible : false
        }, {
            dataField : "invcDt",
            headerText : '<spring:message code="webInvoice.invoiceDate" />'
        }, {
            dataField : "expType",
            visible : false
        }, {
            dataField : "expTypeName",
            headerText : '<spring:message code="pettyCashNewExp.expBrType" />',
            style : "aui-grid-user-custom-left"
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
            dataField : "supplirName",
            headerText : '<spring:message code="crditCardNewReim.supplierBrName" />'
        }, {
            dataField : "taxCode",
            visible : false
        }, {
            dataField : "taxName",
            headerText : '<spring:message code="newWebInvoice.taxCode" />'
        }, {
            dataField : "gstRgistNo",
            headerText : '<spring:message code="pettyCashNewExp.gstBrRgist" />',
            visible : false
        }, {
            dataField : "invcType",
            visible : false
        }, {
            dataField : "invcTypeName",
            headerText : '<spring:message code="pettyCashNewExp.invcBrType" />',
            style : "aui-grid-user-custom-left",
            visible : false
        }, {
            dataField : "invcNo",
            visible : false
        }, {
            dataField : "supplir",
            visible : false
        }, {
            dataField : "cur",
            headerText : '<spring:message code="newWebInvoice.cur" />'
        }, {
            dataField : "gstBeforAmt",
            headerText : '<spring:message code="pettyCashNewExp.amtBrBeforeGst" />',
            style : "aui-grid-user-custom-right",
            dataType: "numeric",
            formatString : "#,##0.00",
            visible : false
        }, {
            dataField : "gstAmt",
            headerText : '<spring:message code="pettyCashNewExp.gst" />',
            style : "aui-grid-user-custom-right",
            dataType: "numeric",
            formatString : "#,##0.00",
            visible : false
        }, {
            dataField : "taxNonClmAmt",
            headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
            style : "aui-grid-user-custom-right",
            dataType: "numeric",
            formatString : "#,##0.00",
            visible : false
        }, {
            dataField : "totAmt",
            headerText : '<spring:message code="pettyCashNewExp.totBrAmt" />',
            style : "aui-grid-user-custom-right",
            dataType: "numeric",
            styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                if(item.yN == "N") {
                    return "my-cell-style";
                }
                return null;
            }
        }, {
            dataField : "atchFileGrpId",
            visible : false
        }, {
            dataField : "expDesc",
            headerText : '<spring:message code="newWebInvoice.remark" />',
            style : "aui-grid-user-custom-left",
            width : 200
        }, {
            dataField : "yN",
            visible : false
        }
    ];

    var newGridPros = {
        usePaging : true,
        pageRowCount : 20,
        headerHeight : 40,
        height : 175,
        softRemoveRowMode : false,
        rowIdField : "clmSeq",
        selectionMode : "multipleCells"
    };

    var myGridColumnLayout = [
        {
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
            },
            visible : false
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
            },
            visible : false
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
            },
            visible : false
        }, {
            dataField : "totAmt",
            headerText : '<spring:message code="newWebInvoice.totalAmount" />',
            style : "aui-grid-user-custom-right",
            dataType: "numeric",
            formatString : "#,##0.00",
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

    var myGridPros = {
        editable : true,
        softRemoveRowMode : false,
        rowIdField : "clmSeq",
        headerHeight : 40,
        height : 160,
        selectionMode : "multipleCells"
    };

    var myGridID;
    var newGridID;

    $(document).ready(function () {
        newGridID = AUIGrid.create("#newHtmClaim_grid_wrap", newGridColumnLayout, newGridPros);
        myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);

        setInputFile2();

        $("#supplier_search_btn").click(fn_popSupplierSearchPop);
        $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);
        $("#expenseType_search_btn").click(fn_PopExpenseTypeSearchPop);
        $("#sSupplier_search_btn").click(fn_popSubSupplierSearchPop);

        $("#clear_btn").click(fn_clearData);
        $("#add_btn").click(fn_addRow);
        $("#delete_btn").click(fn_deleteStaffClaimExp);
        $("#tempSave_btn").click(fn_tempSave);
        $("#request_btn").click(function() {
            var result = fn_checkClmMonthAndMemAccId();
            if(result) {
                fn_approveLinePop($("#newMemAccId").val(), $("#newClmMonth").val());
            }
        });
        $("#add_row").click(fn_addMyGridRow);
        $("#remove_row").click(fn_removeMyGridRow);

        AUIGrid.bind(newGridID, "cellDoubleClick", function( event )
                {
                    console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                    console.log("CellDoubleClick clmNo : " + event.item.clmNo + " CellDoubleClick clmSeq : " + event.item.clmSeq);
                    // TODO pettyCash Expense Info GET
                    if(clmNo != null && clmNo != "") {
                        selectRowIdx = event.rowIndex;
                        clmSeq = event.item.clmSeq;
                        atchFileGrpId = event.item.atchFileGrpId;
                        fn_selectStaffClaimInfo();
                    } else {
                        Common.alert('<spring:message code="pettyCashNewExp.beforeSave.msg" />');
                    }
                });

        AUIGrid.bind(newGridID, "cellClick", function( event )
                {
                    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                    console.log("CellClick expTypeName : " + event.item.expTypeName + " CellClick clmSeq : " + event.item.clmSeq);
                    // TODO pettyCash Expense Info GET
                    deleteRowIdx = event.rowIndex;
                    clmSeq = event.item.clmSeq;
                    atchFileGrpId = event.item.atchFileGrpId;
                    expTypeName = event.item.expTypeName;
                });

        fn_setCostCenterEvent();
        fn_setSupplierEvent();
        fn_myGridSetEvent();
        fn_setEvent();

    });

    function setInputFile2() {
        $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
    }

    function fn_myButtonClick(item){
        console.log("fn_myButtonClick Action")
        recentGridItem = item; // 그리드의 클릭한 행 아이템 보관
        var input = $("#file");
        input.trigger('click'); // 파일 브라우저 열기
    };

    function fn_tempSave() {
        fn_insertHtmActFundClaimExp(callType);
    }

    function fn_clearData() {
        if($(":input:radio[name=expGrp]:checked").val() == "1"){
            fn_destroyMileageGrid();
            fn_createMileageAUIGrid();
        } else {
            $("#invcDt").val("");
            $("#supplirName").val("");
            $("#gstRgistNo").val("");
            $("#invcType").val("F");
            $("#invcNo").val("");
            $("#expDesc").val("");

            fn_destroyMyGrid();
            fn_createMyGrid();

            fn_myGridSetEvent();

            $("#attachTd").html("");
            $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");
        }
    }
</script>

<!-- ============================ -->
<!-- ========== DESIGN ========== -->
<!-- ============================ -->

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1><spring:message code="newStaffClaim.title" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body">

        <section class="search_table"><!-- search_table start -->
            <form action="#" method="post" id="form_newHtmActFundClaim">
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

                <ul class="right_btns mb10">
                    <li><p class="btn_blue2"><a href="#" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
                    <li><p class="btn_blue2"><a href="#" id="request_btn"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
                </ul>

                <table class="type1">
                    <caption><spring:message code="webInvoice.table" /></caption>
                    <colgroup>
                        <col style="width:190px" />
                        <col style="width:*" />
                        <col style="width:150px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr" value="${costCentr}" disabled/>
                                <a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                            </td>
                            <th scope="row"><spring:message code="staffClaim.staffCode" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="" id="newMemAccId" name="memAccId" value="${code}" disabled/>
                                <a href="#" class="search_btn" id="supplier_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="newWebInvoice.bank" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName" name="bankName"/>
                            </td>
                            <th scope="row"><spring:message code="pettyCashNewCustdn.bankAccNo" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
                            <td>
                                <input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="newClmMonth" name="clmMonth"/>
                            </td>
                            <th></th>
                            <td></td>
                        </tr>
                    </tbody>
                </table>

                <table class="type1 mt10" id="noMileage">
                    <caption><spring:message code="webInvoice.table" /></caption>
                    <colgroup>
                        <col style="width:190px" />
                        <col style="width:*" />
                        <col style="width:150px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row"><spring:message code="webInvoice.invoiceDate" /></th>
                            <td>
                                <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="invcDt" name="invcDt" />
                            </td>
                            <th scope="row"><spring:message code="pettyCashNewExp.invcNo" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="w100p" id="invcNo" name="invcNo" autocomplete=off/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="pettyCashNewExp.supplierName" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="w100p" id="supplirName" name="supplirName"/>
                            </td>
                            <th scope="row"></th>
                            <td></td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
                            <td colspan="3" id="attachTd">
                                <div class="auto_file2 auto_file3">
                                    <input type="file" title="file add" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="newWebInvoice.remark" /></th>
                            <td colspan="3">
                                <input type="text" title="" placeholder="" class="w100p" id="expDesc" name="expDesc" />
                            </td>
                        </tr>
                    </tbody>
                </table>

                <aside class="title_line" id="myGird_btn">
                    <ul class="right_btns">
                        <li><p class="btn_grid"><a href="#" id="add_row"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
                        <li><p class="btn_grid"><a href="#" id="remove_row"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
                    </ul>
                </aside>

                <article class="grid_wrap" id="my_grid_wrap"></article>

                <aside class="title_line" id="mileage_btn" style="display: none;">
                    <ul class="right_btns">
                        <li><p class="btn_grid"><a href="#" id="mileage_add"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
                    </ul>
                </aside>

                <article class="grid_wrap" id="mileage_grid_wrap"></article>

                <input type="file" id="file" style="display: none;"></input>

                <ul class="center_btns">
                    <li><p class="btn_blue2"><a href="#" id="add_btn"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
                    <li><p class="btn_blue2"><a href="#" id="delete_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
                    <li><p class="btn_blue2"><a href="#" id="clear_btn"><spring:message code="pettyCashNewCustdn.clear" /></a></p></li>
                </ul>

            </form>
        </section>

        <section class="search_result">
            <aside class="title_line">
                <h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="allTotAmt_text"></span></h2>
            </aside>

            <article class="grid_wrap" id="newHtmClaim_grid_wrap"></article>
        </section>
    </section>
</div>