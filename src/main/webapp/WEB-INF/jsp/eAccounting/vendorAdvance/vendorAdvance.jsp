<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

</style>
<script type="text/javascript">
    var advGridId, settlementGridId, approveLineGridID, budgetGridID, glAccGridID;
    var selectRowIdx, gRowIndex;
    var advGridSelectRowId, advGridClmNo, advGridAdvType, advAppvPrcssNo, advGridAppvPrcssStus, advGridRepayStus;
    var gAtchFileGrpId;
    var currList = ["MYR", "USD"];
    var gUserId = '${userId}';
    var gUsername = '${userName}';
    var gCostCenter = '${costCentr}';

    var update = new Array();
    var remove = new Array();
    var attachmentList = new Array();
    var settlementTotalAdv = 0;

    //Main Menu Grid Listing Grid -- Start
    var advanceColumnLayout = [{
        dataField : "postDate",
        headerText : "Posting Date",
        dataType : "date",
        formatString : "dd/mm/yyyy",
        width : 100
    }, {
        dataField : "clmNo",
        headerText : "Claim No"
    }, {
        dataField : "advType",
        visible : false
    }, {
        dataField : "payeeName",
        headerText : "Payee"
    }, {
        dataField : "costCenter",
        headerText : "Cost Center Code"
    }, {
        dataField : "costCenterNm",
        headerText : "Cost Center Name"
    }, {
        dataField : "amt",
        headerText : "Amount",
        dataType: "numeric",
        formatString : "#,##0.00",
        style : "aui-grid-user-custom-right"
    }, {
        dataField : "appvPrcssNo",
        visible : false
    }, {
        dataField : "appvDt",
        headerText : "Approval Date",
        dataType : "date",
        formatString : "dd/mm/yyyy",
        width : 100
    }, {
        dataField : "advRefdDt",
        headerText : "Settlement Due Date",
        dataType : "date",
        formatString : "dd/mm/yyyy",
        width : 100
    }, {
        dataField : "appvPrcssStus",
        visible : false
    }, {
        dataField : "appvPrcssStusDesc",
        headerText : "Approval Status"
    }, {
        dataField : "settlementStus",
        visible : false
    }, {
        dataField : "settlementStusDesc",
        headerText : "Settlement Status"
    }];

    var advanceGridPros = {
        usePaging : true,
        pageRowCount : 40,
        selectionMode : "singleCell",
        showRowCheckColumn : false,
        showRowAllCheckBox : false
    };
    // Main Menu Advance Listing Grid -- End

    // Settlement Grid -- Start
    var settlementColLayout = [{
        dataField : "clamUn",
        editable : false,
        headerText : "Seq",
        width : "10%"
    }, {
        dataField : "clmSeq",
        visible : false
    }, {
        dataField : "budgetCode",
        headerText : "Budget Code",
        editable : false,
        colSpan : 2,
        width : "10%"
    }, {
        dataField : "",
        headerText : '',
        width : 30,
        editable : false,
        renderer : {
            type : "IconRenderer",
            iconTableRef : {
                "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"
            },
            iconWidth : 24,
            iconHeight : 24,
            onclick : function(rowIndex, columnIndex, value, item) {
                gRowIndex = rowIndex;
                fn_budgetCodePop(rowIndex);
            }
        },
        colSpan : -1
    }, {
        dataField : "budgetCodeName",
        headerText : '<spring:message code="newWebInvoice.activityName" />',
        style : "aui-grid-user-custom-left",
        editable : false,
        width : "15%"
    }, {
        dataField : "glAccCode",
        headerText : "GL Account Code",
        editable : false,
        colSpan : 2,
        width : "10%"
    }, {
        dataField : "",
        headerText : '',
        width: 30,
        editable : false,
        renderer : {
            type : "IconRenderer",
            iconTableRef :  {
                "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"// default
            },
            iconWidth : 24,
            iconHeight : 24,
            onclick : function(rowIndex, columnIndex, value, item) {
                gRowIndex = rowIndex;
                fn_glAccountSearchPop(rowIndex);
            }
        },
        colSpan : -1
    }, {
        dataField : "glAccCodeName",
        headerText : '<spring:message code="newWebInvoice.glAccountName" />',
        style : "aui-grid-user-custom-left",
        editable : false,
        width : "15%"
    }, {
        dataField : "invcDt",
        headerText : "Invoice Date",
        dataType : "date",
        formatString : "dd/mm/yyyy",
        editRenderer : {
            type : "CalendarRenderer",
            defaultFormat : "dd/mm/yyyy",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
            onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
            showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
          },
   /*      editRenderer : {
            type : "CalendarRenderer",
            openDirectly : true,
            onlyCalendar : true,
            shwoExtraDays : true,
            titles : [gridMsg["sys.info.grid.calendar.titles.sun"], gridMsg["sys.info.grid.calendar.titles.mon"], gridMsg["sys.info.grid.calendar.titles.tue"], gridMsg["sys.info.grid.calendar.titles.wed"], gridMsg["sys.info.grid.calendar.titles.thur"], gridMsg["sys.info.grid.calendar.titles.fri"], gridMsg["sys.info.grid.calendar.titles.sat"]],
            formatYearString : gridMsg["sys.info.grid.calendar.formatYearString"],
            formatMonthString : gridMsg["sys.info.grid.calendar.formatMonthString"],
            monthTitleString : gridMsg["sys.info.grid.calendar.monthTitleString"]
        }, */
        width : "10%"
    }, {
        dataField : "invcNo",
        headerText : "Invoice No.",
        width : "13%"
    }, {
        dataField : "supplierName",
        headerText : "Supplier Name",
        width : "15%"
    }, {
        dataField : "taxCode",
        headerText : "Tax Code",
        width : "15%"
    }, {
        dataField : "currency",
        headerText : "Currency",
        renderer : {
            type : "DropDownListRenderer",
            list : currList
        },
        width : "8%"
    }, /*{ // To enable this section if require tax code change/tax amount input
        dataField : "netAmt",
        headerText : "Net Amount",
        dataType : "numeric",
        formatString : "#,##0.00",
        editRenderer : {
            type : "inputEditRenderer",
            onlyNumeric : true,
            autoThousandSeparator : true,
            allowPoint : true
        },
        width : "15%"
    }, {
        dataField : "taxAmt",
        headerText : "Tax Amount",
        dataType : "numeric",
        formatString : "#,##0.00",
        editRenderer : {
            type : "inputEditRenderer",
            onlyNumeric : true,
            autoThousandSeparator : true,
            allowPoint : true
        },
        width : "15%"
    },*/ {
        dataField : "totalAmt",
        headerText : "Total Amount",
        dataType : "numeric",
        formatString : "#,##0.00",
        editRenderer : {
            type : "inputEditRenderer",
            onlyNumeric : true,
            autoThousandSeparator : true,
            allowPoint : true
        },
        width : "15%"
    }, {
        dataField : "rem",
        headerText : "Description",
        width : 150,
        width : "20%"
    }];

    var settlementGridPros = {
        usePaging : true,
        pageRowCount : 20,
        editable : true,
        showStateColumn : true,
        softRemovePolicy : "exceptNew",
        softRemoveRowMode : false,
        rowIdField : "clmSeq",
        selectionMode : "singleCell",
        enableColumnResize : false
    };
    // Settlement Grid -- End

    // Approval Line Grid -- Start
    var approveLineColumnLayout = [
        {
            dataField : "approveNo",
            headerText : '<spring:message code="approveLine.approveNo" />',
            dataType: "numeric",
            expFunction : function( rowIndex, columnIndex, item, dataField ) {
                return rowIndex + 1;
            }
        }, {
            dataField : "memCode",
            headerText : '<spring:message code="approveLine.userId" />',
            colSpan : 2
        }, {
            dataField : "",
            headerText : '',
            width: 30,
            renderer : {
                type : "IconRenderer",
                iconTableRef :  {
                    "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"
                },
                iconWidth : 24,
                iconHeight : 24,
                onclick : function(rowIndex, columnIndex, value, item) {
                    console.log("selectRowIdx : " + selectRowIdx);
                    selectRowIdx = rowIndex;
                    fn_searchUserIdPop();
                }
            },
            colSpan : -1
        },{
            dataField : "name",
            headerText : '<spring:message code="approveLine.name" />',
            style : "aui-grid-user-custom-left"
        }, {
            dataField : "",
            headerText : '<spring:message code="approveLine.addition" />',
            renderer : {
                type : "IconRenderer",
                iconTableRef :  {
                    "default" : "${pageContext.request.contextPath}/resources/images/common/btn_plus.gif"// default
                },
                iconWidth : 12,
                iconHeight : 12,
                onclick : function(rowIndex, columnIndex, value, item) {
                    var rowCount = AUIGrid.getRowCount(approveLineGridID);
                    if (rowCount > 3) {
                        Common.alert('<spring:message code="approveLine.appvLine.msg" />');
                    } else {
                        fn_appvLineGridAddRow();
                    }
                }
           }
        }
    ];

    var approveLineGridPros = {
        usePaging : true,
        pageRowCount : 20,
        showStateColumn : true,
        enableRestore : true,
        showRowNumColumn : false,
        softRemovePolicy : "exceptNew",
        softRemoveRowMode : false,
        selectionMode : "multipleCells"
    };
    // Approval Line Grid -- End

    // Budget Code Search Grid -- Start
    var budgetcolumnLayout = [ {
            dataField : "budgetCode",
            headerText : '<spring:message code="expense.Activity" />'
        }, {
            dataField : "budgetCodeText",
            headerText : '<spring:message code="expense.ActivityName" />',
            style : "aui-grid-user-custom-left"
        }
    ];
    // Budget Code Search Grid -- End

    // GL Code Search Grid -- Start
    var glCodecolumnLayout = [
        {
            dataField : "glAccCode",
            headerText : '<spring:message code="expense.GLAccount" />'
        }, {
            dataField : "glAccDesc",
            headerText : '<spring:message code="expense.GLAccountName" />',
            style : "aui-grid-user-custom-left"
        }
    ];
    // GL Code Search Grid -- End

    $(document).ready(function () {
        console.log("vendorAdvance.jsp");

        // Vendor Advance Request Grid
        advGridId = GridCommon.createAUIGrid("#grid_wrap", advanceColumnLayout, null, advanceGridPros);
        // Vendor Advance Settlement Grid
        //settlementGridId = AUIGrid.create("#settlementGridWrap", settlementColLayout, settlementGridPros);
        settlementGridId = GridCommon.createAUIGrid("#settlement_grid_wrap", settlementColLayout, null, settlementGridPros);
        // Approval Line
        approveLineGridID = GridCommon.createAUIGrid("#approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);
        // Settlement - Budget Search
        budgetGridID = GridCommon.createAUIGrid("#budgetGrid", budgetcolumnLayout, "budgetCode", {editable : false});
        // Settlement - GL Code Search
        glAccGridID = GridCommon.createAUIGrid("#glCodeGrid", glCodecolumnLayout, "glAccCode", {editable : false});

        AUIGrid.resize(budgetGridID, 565, $(".budgetGrid").innerHeight());
        AUIGrid.resize(glAccGridID, 565, $(".glCodeGrid").innerHeight());

        //$("#settlementUpd_btn").click(fn_settlementUpdate); // Manual update settlement status - Finance use only
        $("#settlementUpd_btn").click(fn_settlementConfirm); // Manual update settlement status - Finance use only
        $("#request_btn").click(fn_advReqPop);
        $("#advList_btn").click(fn_searchAdv);
        $("#refund_btn").click(fn_repaymentPop);

        $("#search_costCenter_btn").click(fn_costCenterSearchPop);
        $("#search_payee_btn").click(fn_popPayeeSearchPop);

        fn_setAdvGridEvent();

        // =======================================================================
        // Advance Request - Start
        //$("#advReqClose_btn").click(fn_closePop("M"));
        doGetCombo("/common/selectCodeList.do", '483', '', 'advOccasion', 'S', '');

        $("#supplier_search_btn").click(fn_popSupplierSearchPop);
        $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);

        $("#reqDraft").click(fn_reqDraft);
        $("#reqSubmit").click(fn_reqSubmit);

        $("#keyDate").val($.datepicker.formatDate('dd/mm/yy', new Date()));
        $("#keyDate").attr("readOnly", true);

        // Attachment update
        $("#form_vendorAdvanceReq :file").change(function() {
            var div = $(this).parents(".auto_file");
            var oriFileName = div.find(":text").val();

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    update.push(attachmentList[i].atchFileId);
                }
            }
        });

        //$("#acknowledgement_closeBtn").click(fn_closePop("S"))
        // Advance Request - End
        // =======================================================================
        // Advance Settlement - Start
        //$("#advSettlementClose_btn").click(fn_closePop("M"));\\

        $("#settlementDraft").click(fn_settlementDraft);
        $("#settlementSubmit").click(fn_settlementSubmit);

        //$("#settlement_add_row").click(fn_settlementAddRow);
        //$("#settlement_remove_row").click(fn_settlementRemoveRow);

        $("#settlementBudgetSearch_closeBtn").click(fn_closePop("S"));
        $("#settlementGlSearch_closeBtn").click(fn_closePop("S"));

        $("#form_vendorAdvanceSettlement :file").change(function() {
            var div = $(this).parents(".auto_file");
            var oriFileName = div.find(":text").val();

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    update.push(attachmentList[i].atchFileId);
                }
            }
        });

        // Advance Settlement - End
        // =======================================================================

        $(".auto_file a:contains('Delete')").click(function() {
            var div = $(this).parents(".auto_file");
            var oriFileName = div.find(":text").val();

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    remove.push(attachmentList[i].atchFileId);
                }
            }
        });

        $("#approvalLine_closeBtn").click(fn_closePop("S"));

        $("#editRejBtn").click(fn_editRejected);



    });

    function fn_closePop(type) {
        console.log("fn_closePop :: type :: " + type);

        advGridSelectRowId = null;
        advGridClmNo = null;
        advGridAdvType = null;
        advAppvPrcssNo = null;
        advGridAppvPrcssStus = null;
        advGridRepayStus = null;
        attachmentList = new Array();

        if(type == "M") {
            if($("#advReqPop").is(":visible")) {
                $("#form_vendorAdvanceReq").clearForm();
                $("#advReqPop").hide();

                if($("#keyDate").hasClass("readonly")) $("#keyDate").removeClass("readonly");
                if($("#reqCostCenter").hasClass("readonly")) $("#reqCostCenter").removeClass("readonly");
                if($("#newMemAccId").hasClass("readonly")) $("#newMemAccId").removeClass("readonly");
                if($("#totalAdv").hasClass("readonly")) $("#totalAdv").removeClass("readonly");
                if($("#advOccasion").hasClass("readonly")) $("#advOccasion").removeClass("readonly");
                if($("#advRem").hasClass("readonly")) $("#advRem").removeClass("readonly");

                if($("#keyDate").attr("readonly")) $("#keyDate").removeAttr("readonly");
                if($("#reqCostCenter").attr("readonly")) $("#reqCostCenter").removeAttr("readonly");
                if($("#newMemAccId").attr("readonly")) $("#newMemAccId").removeAttr("readonly");
                if($("#totalAdv").attr("readonly")) $("#totalAdv").removeAttr("readonly");
                if($("#advOccasion").attr("readonly")) $("#advOccasion").removeAttr("readonly");
                if($("#advRem").attr("readonly")) $("#advRem").removeAttr("readonly");

                $("#reqFileSelector").html();

            } else if($("#settlementPop").is(":visible")) {
                $("#form_vendorAdvanceSettlement").clearForm();
                AUIGrid.clearGridData(settlementGridId);
                $("#settlementPop").hide();

                if($("#eventStartDt").hasClass("readonly")) $("#eventStartDt").removeClass("readonly");
                if($("#eventEndDt").hasClass("readonly")) $("#eventEndDt").removeClass("readonly");
                if($("#settlementMode").hasClass("readonly")) $("#settlementMode").removeClass("readonly");
                if($("#bankRef").hasClass("readonly")) $("#bankRef").removeClass("readonly");
                if($("#settlementRem").hasClass("readonly")) $("#settlementRem").removeClass("readonly");

                if($("#eventStartDt").attr("readonly")) $("#eventStartDt").removeAttr("readonly");
                if($("#eventEndDt").attr("readonly")) $("#eventEndDt").removeAttr("readonly");
                if($("#settlementMode").attr("readonly")) $("#settlementMode").removeAttr("readonly");
                if($("#bankRef").attr("readonly")) $("#bankRef").removeAttr("readonly");
                if($("#settlementRem").attr("readonly")) $("#settlementRem").removeAttr("readonly");

                $("#settlementFileSelector").html();

            }
        } else if(type == "S") {
            if($("#budgetSearchPop").is(":visible")) {
                AUIGrid.clearGridData(budgetGridID);
                $("#bgSForm").clearForm();
                $("#budgetSearchPop").hide();

            } else if($("#glSearchPop").is(":visible")) {
                AUIGrid.clearGridData(glAccGridID);
                $("#glSForm").clearForm();
                $("#glSearchPop").hide();

            } else if($("#advReqMsgPop").is(":visible")) {
                $("#advReqMsgPop").hide();
                $("#ack1Checkbox").prop('checked', false);

            }

            if($("#appvLinePop").is(":visible")) {
                $("#appvLinePop").hide();
                $("#requestAppvLine").hide();
                AUIGrid.clearGridData(approveLineGridID);
            }
        }
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = 0;
            }
        });

        //advType = "";
    };

    // Payee, Cost Center Search Button functions - Start
    // Main Menu
    function fn_popPayeeSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop", accGrp:"VM13"}, null, true, "supplierSearchPop");
    }

    // Main Menu
    function fn_costCenterSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
    }

    // Advance Request
    function fn_popSupplierSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM11"}, null, true, "supplierSearchPop");
    }

    // Advance Request
    function fn_popCostCenterSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
    }

    function fn_setPopSupplier() {
        if($("#advReqPop").is(":visible")) {
            $("#newMemAccId").val($("#search_memAccId").val());
            $("#newMemAccName").val($("#search_memAccName").val());
            $("#gstRgistNo").val($("#search_gstRgistNo").val());
            $("#bankCode").val($("#search_bankCode").val());
            $("#bankName").val($("#search_bankName").val());
            $("#bankAccNo").val($("#search_bankAccNo").val());

        } else {
            $("#memAccCode").val($("#search_memAccId").val());
        }
    }

    function fn_setPopCostCenter() {
        if($("#advReqPop").is(":visible")) {
            $("#reqCostCenter").val($("#search_costCentr").val());
            $("#newCostCenterText").val($("#search_costCentrName").val());

        } else {
            $("#listCostCenter").val($("#search_costCentr").val());
        }
    }

    function fn_setCostCenter() {
        $("#listCostCenter").val($("#search_costCentr").val());
    }
    // Payee, Cost Center Search Button functions - End

    // Main Menu - Functions - Start
    function fn_setAdvGridEvent() {
        AUIGrid.bind(advGridId, "cellClick", function(event) {
            advGridSelectRowId = event.rowIndex;

            advGridClmNo = event.item.clmNo;
            advGridAdvType = event.item.advType; // 5 = Request; 6 = Settlement
            advAppvPrcssNo = event.item.appvPrcssNo;
            advGridAppvPrcssStus = event.item.appvPrcssStus; // Current claim number's approval status
            advGridRepayStus = event.item.settlementStus;
        });

        AUIGrid.bind(advGridId, "cellDoubleClick", function(event) {
            advGridSelectRowId = event.rowIndex;

            advGridClmNo = event.item.clmNo;
            advGridAdvType = event.item.advType; // 5 = Request; 6 = Settlement
            advAppvPrcssNo = event.item.appvPrcssNo;
            advGridAppvPrcssStus = event.item.appvPrcssStus; // Current claim number's approval status
            advGridRepayStus = event.item.settlementStus;

            if(advGridAdvType == "5") {
                // Display vendor advance request data
                fn_advReqPop();

            } else if(advGridAdvType == "6") {
                // Display vendor advance settlement data
                fn_repaymentPop();
            }
        });
    }
    // Main Menu - Functions - End

    // Main Menu - Top Buttons - Start
    function fn_searchAdv() {
        console.log("fn_searchAdv");
        Common.ajax("GET", "/eAccounting/vendorAdvance/advanceListing.do", $("#searchForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(advGridId, result);
        });
    }

    function fn_advReqPop() {
        /*
        Callers ::
        1. Request Button
        2. Grid Double Click Record
        */
        console.log("fn_advReqPop");

        if(advGridClmNo != "" && advGridClmNo != null) {
            $("#reqNewClmNo").val(advGridClmNo);

            // Grid Double Click Trigger - Start
            var data = {
                    clmNo : advGridClmNo,
                    appvPrcssNo : advAppvPrcssNo,
                    advType : advGridAdvType,
                    appvPrcssStus : advGridAppvPrcssStus
            };

            Common.ajax("GET", "/eAccounting/vendorAdvance/selectVendorAdvanceDetails.do", data, function(result) {
                console.log(result);

                if(advGridAppvPrcssStus == "A" || advGridAppvPrcssStus == "J" || advGridAppvPrcssStus == "R" || advGridAppvPrcssStus == "P") {
                    // Approved, Rejected, Request, Pending
                    // Fields are not editable
                    $("#h1_req").text("Vendor Advance Request - View");

                    $("#reqDraft").hide();
                    $("#reqSubmit").hide();
                    $("#rejectReasonRow").hide();
                    $("#finalAppvRow").hide();

                    $("#keyDate").addClass("readonly");
                    $("#reqCostCenter").addClass("readonly");
                    $("#newMemAccId").addClass("readonly");
                    $("#totalAdv").addClass("readonly");
                    $("#advOccasion").addClass("readonly");
                    $("#advRem").addClass("readonly");
                    $("#advCurr").addClass("readonly");

                    $("#keyDate").attr("readonly", "readonly");
                    $("#reqCostCenter").attr("readonly", "readonly");
                    $("#newMemAccId").attr("readonly", "readonly");
                    $("#totalAdv").attr("readonly", "readonly");
                    $("#advOccasion").attr("disabled", "true");
                    $("#advRem").attr("readonly", "readonly");
                    $("#advCurr").attr("disabled", "true");

                    $("#supplier_search_btn").hide();
                    $("#costCenter_search_btn").hide();
                    $("#reqCostCenter").val(result.data.costCenter + '/' + result.data.costCenterNm);
                    $("#appvStusRow").show();
                    $("#viewAppvStus").html(result.data.appvPrcssStus);

                    if(advGridAppvPrcssStus == "A" || advGridAppvPrcssStus == "J"){
                    	Common.ajax("GET", "/eAccounting/webInvoice/getFinalApprAct.do", {appvPrcssNo: advAppvPrcssNo}, function(result1) {
                    		$("#finalAppvRow").show();
                    		$("#viewFinalApprover").html(result1.finalAppr);
                    		if(advGridAppvPrcssStus == "J"){
                                $("#rejectReasonRow").show();
                                $("#viewRejectReason").html(result.data.rejctResn);

                            }
                        });
                    }

                } else if(advGridAppvPrcssStus == "T") {
                    // Draft
                    $("#h1_req").text("Vendor Advance Request - Edit");

                    $("#reqDraft").show();
                    $("#reqSubmit").show();

                    if($("#reqCostCenter").hasClass("readonly")) $("#reqCostCenter").removeClass("readonly");
                    //if($("#newMemAccId").hasClass("readonly")) $("#newMemAccId").removeClass("readonly");
                    if($("#totalAdv").hasClass("readonly")) $("#totalAdv").removeClass("readonly");
                    if($("#advOccasion").hasClass("readonly")) $("#advOccasion").removeClass("readonly");
                    if($("#advRem").hasClass("readonly")) $("#advRem").removeClass("readonly");

                    if($("#reqCostCenter").attr("readonly")) $("#reqCostCenter").removeAttr("readonly");
                    //if($("#newMemAccId").attr("readonly")) $("#newMemAccId").removeAttr("readonly");
                    if($("#totalAdv").attr("readonly")) $("#totalAdv").removeAttr("readonly");
                    if($("#advOccasion").attr("readonly")) $("#advOccasion").removeAttr("readonly");
                    if($("#advRem").attr("readonly")) $("#advRem").removeAttr("readonly");

                    $("#supplier_search_btn").show();
                    $("#costCenter_search_btn").show();
                    $("#reqCostCenter").val(result.data.costCenter);
                }
                console.log(result.data.advOcc);
                // Set queried values
                $("#keyDate").val(result.data.crtDt);
                $("#newMemAccId").val(result.data.memAccId);
                $("#newMemAccName").val(result.data.memAccName);
                //$("#reqCostCenter").val(result.data.costCenter);
                //$("#totalAdv").val(result.data.totAmt);
                $("#totalAdvHeader").text("Total Advance (" + result.data.cur + ")");
                //$("#totalAdv").val(result.data.totAmt);
                $("#totalAdv").val(AUIGrid.formatNumber(Number(result.data.totAmt), "#,##0.00"));
                //$("#advOccasion option[value='" + result.data.advOcc + "']").attr("selected", "selected");
                $("#advOccasion").val(result.data.advOcc).prop("selected", true);
                console.log(result.data.advOcc);
                console.log($("#advOccasion").val());
                $("#advRem").val(result.data.rem);
                $("#reqCrtUserName").val(result.data.userName);
                $("#bankName").val(result.data.bankName);
                $("#bankAccNo").val(result.data.bankAccNo);
                $("#advCurr").val(result.data.cur).prop("selected", true);

                // Request file selector
                gAtchFileGrpId = result.data.attachList[0].atchFileGrpId;
                var atchObj = {
                        atchFileGrpId : result.data.attachList[0].atchFileGrpId,
                        atchFileId : result.data.attachList[0].atchFileId,
                        atchFileName : result.data.attachList[0].atchFileName
                };
                attachmentList.push(atchObj);

                $("#reqFileSelector").html();
                $("#reqFileSelector").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='1'/></div>");
                $(".input_text").val(result.data.attachList[0].atchFileName);
                $(".input_text").dblclick(function() {
                    var data = {
                            atchFileGrpId : result.data.attachList[0].atchFileGrpId,
                            atchFileId : result.data.attachList[0].atchFileId
                    };

                    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(flResult) {
                        console.log(flResult);
                        if(flResult.fileExtsn == "jpg" || flResult.fileExtsn == "png" || flResult.fileExtsn == "gif") {
                            // TODO View
                            var fileSubPath = flResult.fileSubPath;
                            fileSubPath = fileSubPath.replace('\', '/'');
                            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + flResult.physiclFileName);

                        } else {
                            var fileSubPath = flResult.fileSubPath;
                            fileSubPath = fileSubPath.replace('\', '/'');
                            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + flResult.physiclFileName + "&orignlFileNm=" + flResult.atchFileName);
                        }
                    });
                });
            });
            // Grid Double Click Trigger - End

        } else {
            // Button Trigger - New
            $("#reqDraft").show();
            $("#reqSubmit").show();

            $("#keyDate").val(fn_getToday);

            $("#supplier_search_btn").show();
            $("#costCenter_search_btn").show();

            if(FormUtil.isEmpty($("#reqCrtUserName").val())) {
                $("#reqCrtUserName").val(gUsername);
            }

            if(FormUtil.isEmpty($("#reqCostCenter").val())) {
                $("#reqCostCenter").val(gCostCenter);
            }
        }

        $("#advReqPop").show();
    }

    function fn_repaymentPop() {
        console.log("fn_repaymentPop");

        AUIGrid.resize(settlementGridId, 963, $(".settlement_grid_wrap").innerHeight());
        fn_setSettlementGridEvent();

        $("#settlementKeyDate").val(fn_getToday);

        if(advGridClmNo == "" || advGridClmNo == null) {
            Common.alert("No advance request selected for settlement.");
            return false;

        } else {
            var data = {
                    clmNo : advGridClmNo,
                    appvPrcssNo : advAppvPrcssNo,
                    advType : advGridAdvType,
                    appvPrcssStus : advGridAppvPrcssStus
            };

            Common.ajax("GET", "/eAccounting/vendorAdvance/selectVendorAdvanceDetails.do", data, function(result) {
                console.log(result);

                console.log("advGridAppvPrcssStus: ", advGridAppvPrcssStus);
                console.log("advGridAdvType: ", advGridAdvType);
                if(advGridAdvType == "5") {
                    if(advGridAppvPrcssStus == "A") {
                        // Approved Vendor Advance Request
                        AUIGrid.setProp(settlementGridId, {"editable" : "true"});

                        $("#keyDate").val(fn_getToday);

                        if(FormUtil.isEmpty($("#settlementCrtUserName").val())) {
                            $("#settlementCrtUserName").val(gUsername);
                        }

                        if(FormUtil.isEmpty($("#settlementCostCenter").val())) {
                            $("#settlementCostCenter").val(gCostCenter);
                        }

                        $("#settlementAdvRefdNo").val(advGridClmNo);

                        $("#settlementTotalAdv").val(result.data.totAmt);
                        $("#settlementTotalAdv").val(AUIGrid.formatNumber(Number(result.data.totAmt), "#,##0.00"));
                        $("#settlementTotalAdvHeader").text("Advance Amount (" + result.data.cur + ")");
                        $("#settlementTotalExp").val(0);
                        $("#settlementTotalExp").val(AUIGrid.formatNumber(0, "#,##0.00"));
                        $("#settlementTotalExpHeader").text("Total Expenses (" + result.data.cur + ")");
                        //$("#settlementTotalBalance").val(result.data.balAmt);
                        $("#settlementTotalBalance").val($("#settlementTotalAdv").val() - $("#settlementTotalExp").val());
                        $("#settlementTotalBalance").val(AUIGrid.formatNumber(Number(result.data.balAmt), "#,##0.00"));
                        $("#settlementMemAccId").val(result.data.memAccId);
                        $("#settlementMemAccName").val(result.data.memAccName);

                        $("#settlementPop").show();

                    } else {
                        Common.alert("Selected claim not allowed for settlement.");
                        return false;
                    }

                } else if(advGridAdvType == "6") {
                    if(advGridAppvPrcssStus == "T") {
                        // Settlement Claim Type + Draft = Allow continuation of editing settlement
                        $("h1_settlement").text("Vendor Advance Settlement - Edit");

                        $("#settlementNewClmNo").val(advGridClmNo);

                        AUIGrid.setProp(settlementGridId, {"editable" : "true"});

                        if($("#eventStartDt").hasClass("readonly")) $("#eventStartDt").removeClass("readonly");
                        if($("#eventEndDt").hasClass("readonly")) $("#eventEndDt").removeClass("readonly");
                        if($("#settlementMode").hasClass("readonly")) $("#settlementMode").removeClass("readonly");
                        if($("#bankRef").hasClass("readonly")) $("#bankRef").removeClass("readonly");
                        if($("#settlementRem").hasClass("readonly")) $("#settlementRem").removeClass("readonly");

                        if($("#eventStartDt").attr("readonly")) $("#eventStartDt").removeAttr("readonly");
                        if($("#eventEndDt").attr("readonly")) $("#eventEndDt").removeAttr("readonly");
                        if($("#settlementMode").attr("readonly")) $("#settlementMode").removeAttr("readonly");
                        if($("#bankRef").attr("readonly")) $("#bankRef").removeAttr("readonly");
                        if($("#settlementRem").attr("readonly")) $("#settlementRem").removeAttr("readonly");

                        console.log("here",result);
                        $("#settlementMemAccId").val(result.data.memAccId);
                        $("#settlementMemAccName").val(result.data.memAccName);
                        $("#settlementCostCenter").val(result.data.costCenter);
                        $("#settlementCrtUserName").val(result.data.userName);
                    } else {
                        // Settlement Claim Type + Approved/Rejected/Pending Approval/Request = Allow view
                        //$("#h1_settlement").text("Vendor Advance Settlement - View");
                        $("#h1_settlement").replaceWith('<h1 id="h1_settlement">Vendor Advance Settlement - View</h1>');

                        AUIGrid.setProp(settlementGridId, {"editable" : "false"});


                        $("#eventStartDt").addClass("readonly");
                        $("#eventEndDt").addClass("readonly");
                        $("#settlementMode").addClass("readonly");
                        $("#bankRef").addClass("readonly");
                        $("#settlementRem").addClass("readonly");

                        $("#eventStartDt").attr("readonly", "readonly");
                        $("#eventEndDt").attr("readonly", "readonly");
                        $("#settlementMode").attr("readonly", "readonly");
                        $("#bankRef").attr("readonly", "readonly");
                        $("#settlementRem").attr("readonly", "readonly");
                        $("#settlementKeyDate").attr("disabled", "disabled");

                        $("#settlementDraft").hide();
                        $("#settlementSubmit").hide();
                        $("#settlement_add_row").hide();
                        $("#settlement_remove_row").hide();
                        $("#appvStusRowSett").show();

                        if(advGridAppvPrcssStus == "A" || advGridAppvPrcssStus == "J"){
                            Common.ajaxSync("GET", "/eAccounting/webInvoice/getFinalApprAct.do", {appvPrcssNo: advAppvPrcssNo}, function(result1) {
                                $("#finApprActRowSett").show();
                                $("#viewFinAppr").html(result1.finalAppr);
                                if(advGridAppvPrcssStus == "J"){
                                    $("#rejectReasonRowSett").show();
                                    $("#viewRejctResn").html(result.data.rejctResn);

                                }
                            });
                        }

                        $("#settlementMemAccId").val(result.data.memAccId);
                        $("#settlementMemAccName").val(result.data.memAccName);
                        $("#settlementCostCenter").val(result.data.costCenter);
                        $("#settlementCrtUserName").val(result.data.userName);
                        $("#viewAppvStusSett").html(result.data.appvPrcssStus);
                    }

                    //set queried values
                    //$("#settlementMemAccId").val();
                    //$("#settlementMemAccName").val();
                    $("#eventStartDt").val(result.data.advPrdFr);
                    $("#eventEndDt").val(result.data.advPrdTo);
                    settlementTotalAdv = result.data.totAmt;
                    $("#settlementTotalAdv").val(AUIGrid.formatNumber(result.data.totAmt, "#,##0.00"));
                    //$("#settlementTotalAdv").val(AUIGrid.formatNumber(result.data.totAmt), "#,##0.00");
                    $("#settlementTotalAdvHeader").text("Advance Amount (" + result.data.settlementItems[0].currency + ")");
                    $("#settlementTotalExp").val(result.data.expAmt);
                    $("#settlementTotalExp").val(AUIGrid.formatNumber(Number(result.data.expAmt), "#,##0.00"));
                    $("#settlementTotalExpHeader").text("Total Expenses (" + result.data.settlementItems[0].currency + ")");
                    $("#settlementTotalBalance").val(Number(result.data.totAmt) - Number(result.data.expAmt));
                    $("#settlementTotalBalance").val(AUIGrid.formatNumber((result.data.totAmt) - (result.data.expAmt), "#,##0.00"));
                    $("#settlementMode option[value=" + result.data.advRefMode + "]").attr('selected', true);
                    $("#settlementMode").attr('disabled', true);
                    $("#bankRef").val(result.data.advRefdRef);
                    // $("#settlementFileSelector").val(); // Settlement file
                    $("#settlementRem").val(result.data.rem);

                    // Settlement file selector
                    gAtchFileGrpId = result.data.attachList[0].atchFileGrpId;
                    attachmentList = result.data.attachList[0];

                    $("#settlementFileSelector").html();
                    $("#settlementFileSelector").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='1'/></div>");
                    $(".input_text").val(result.data.attachList[0].atchFileName);
                    $(".input_text").dblclick(function() {
                        var data = {
                                atchFileGrpId : result.data.attachList[0].atchFileGrpId,
                                atchFileId : result.data.attachList[0].atchFileId
                        };

                        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(flResult) {
                            console.log(flResult);
                            if(flResult.fileExtsn == "jpg" || flResult.fileExtsn == "png" || flResult.fileExtsn == "gif") {
                                // TODO View
                                var fileSubPath = result.fileSubPath;
                                fileSubPath = fileSubPath.replace('\', '/'');
                                window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);

                            } else {
                                var fileSubPath = flResult.fileSubPath;
                                fileSubPath = fileSubPath.replace('\', '/'');
                                window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + flResult.physiclFileName + "&orignlFileNm=" + flResult.atchFileName);
                            }
                        });
                    });

                    AUIGrid.setGridData(settlementGridId, result.data.settlementItems);

                    $("#settlementPop").show();
                }
            });
        }
    }

    function fn_settlementUpdate() {
        // Manual settlement - Finance use only
        /*
        TODO
        1. Common.ajax("POST", ) -- Update FCM0027M's ADV_REFD_NO, ADV_REFD_DT; Without inserting repayment/settlement record
        */
        console.log("fn_settlementUpdate");

        if(advGridClmNo == "" || advGridClmNo == null) {
            Common.alert("No advance request selected for manual settlement.");
            return false;

        } else {
            Common.ajax("POST", "/eAccounting/vendorAdvance/manualVendorAdvReqSettlement.do", {clmNo : advGridClmNo}, function(result) {
                console.log(result);
                $("#manualSettMsgPop").hide();
            });
        }
    }
    // Main Menu - Top Buttons - End

    // Common Functions - Start
    function fn_getToday() {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();

        if(dd < 10) {
            dd = "0" + dd;
        }
        if(mm < 10){
            mm = "0" + mm
        }

        today = dd + "/" + mm + "/" + yyyy;

        return today;
    }

    function fn_saveValidation() {
        console.log("fn_saveValidation");
        var flag = true;
        var regExpSpecChar = /^[^*|\":<>[\]{}`\\()';@&$]+$/;
        var regExpSpecCharFile = /^[^*|\"<>[\]{}`()';@&$]+$/;

        if($("#advReqPop").is(":visible")) {
            // Vendor Advance Request
            if(FormUtil.isEmpty($("#newMemAccId").val())) {
                Common.alert("Payee Code is required.");
                flag = false;
                return flag;
            }

            if(FormUtil.isEmpty($("#totalAdv").val())) {
                Common.alert("Total Advance is required.");
                flag = false;
                return flag;
            }

            if(FormUtil.isEmpty($("#advOccasion").val())) {
                Common.alert("Advance Occasions is required.");
                flag = false;
                return flag;
            }

            if(FormUtil.isEmpty($("#advRem").val())) {
                Common.alert("Remarks is required.");
                flag = false;
                return flag;
            }
            else if (regExpSpecChar.test($("#advRem").val()) == false) {
            	Common.alert("Special characters is not allow in Remark.");
                flag = false;
                return flag;
            }

            if(FormUtil.isEmpty($("#reqNewClmNo").val())) {
                // New Request - Empty attachment check
                if($("input[name=reqFileSelector]")[0].files[0] == "" || $("input[name=reqFileSelector]")[0].files[0] == null) {
                    Common.alert("Please attach supporting document in zipped format.");
                    flag = false;
                    return flag;
                }
                else if(regExpSpecCharFile.test($("input[name=reqFileSelector]").val()) == false) {
                	Common.alert("Special characters is not allow as File Name.");
                    flag = false;
                    return flag;
                }
            }

        } else if($("#settlementPop").is(":visible")) {
            // Vendor Advance Settlement
            if(FormUtil.isEmpty($("#eventStartDt").val()) || FormUtil.isEmpty($("#eventEndDt").val())) {
                Common.alert("Event Start/End Date is required.");
                flag = false;
                return flag;
            }
            else{
            	if($("#eventStartDt").val() > $("#eventEndDt").val()){
            		Common.alert("Event Date invalid. Please choose again.");
            		flag = false;
            		return flag;
            	}
            }

            if(FormUtil.isEmpty($("#settlementMode").val())) {
                Common.alert("Refund mode is required.");
                flag = false;
                return flag;
            }

            if($("#settlementMode").val() == "OTRX") {
                if(FormUtil.isEmpty($("#bankRef").val())) {
                    Common.alert("Please select bank reference.");
                    flag = false;
                    return flag;
                }
            }

            if(FormUtil.isEmpty($("#settlementNewClmNo").val())) {
                // New Settlement - Empty attachment check
                if($("input[name=settlementFileSelector]")[0].files[0] == "" || $("input[name=settlementFileSelector]")[0].files[0] == null) {
                    Common.alert("Please attach supporting document in zipped format.");
                    flag = false;
                    return flag;
                }
            }

            var newFlag = fn_saveSubmitCheckRowValidation();
            console.log(newFlag);
            if(!newFlag){
            	flag = false;
            }
            return flag;
        }

        return flag;
    }

    //Check settlement submission details row has data
    function fn_saveSubmitCheckRowValidation() {
    	console.log("fn_saveSubmitCheckRowValidation");
    	var checkRowFlg = true;
    	var settlementRowCount = AUIGrid.getRowCount(settlementGridId);
    	console.log(settlementRowCount);
    	if(settlementRowCount > 0){
    		for(var i=0; i < settlementRowCount; i++){
    			if(FormUtil.isEmpty(AUIGrid.getCellValue(settlementGridId, i, "budgetCode"))){
    				Common.alert("Please choose a budget code.");
    				checkRowFlg = false;
    				return checkRowFlg;
    			}
    			if(FormUtil.isEmpty(AUIGrid.getCellValue(settlementGridId, i, "glAccCode"))){
    				Common.alert("Please choose a GL code.");
    				checkRowFlg = false;
    				return checkRowFlg;
    			}
    			if(FormUtil.isEmpty(AUIGrid.getCellValue(settlementGridId, i, "totalAmt")) || AUIGrid.getCellValue(settlementGridId, i, "totalAmt") <= 0){
    				Common.alert("Please enter an amount.");
    				checkRowFlg = false;
    				return checkRowFlg;
    			}
    			if(FormUtil.isEmpty(AUIGrid.getCellValue(settlementGridId, i, "invcNo"))){
    				Common.alert("Please enter an Invoice Number.");
    				checkRowFlg = false;
    				return checkRowFlg;
    			}
    			else{
   	                checkRowFlg = fn_selectSameVender(i);
   	                if(!checkRowFlg){
   	                	checkRowFlg = false;
   	                }
    			}
    		}
    		return checkRowFlg;
    	}
    	else{
    		Common.alert("Please enter at least 1 detail line.");
    		checkRowFlg = false;
    		return checkRowFlg;
    	}
    	return checkRowFlg;
    }

    function fn_selectSameVender(i){
    	var checkRowFlg = true;
    	var data = {
                memAccId : $("#settlementMemAccId").val(),
                invcNo : AUIGrid.getCellValue(settlementGridId, i, "invcNo")
        }

    	Common.ajaxSync("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result1) {
    		console.log(result1.data);
    		if(result1.data) {
    			Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
    			checkRowFlg = false;
    		}
    	})
    	return checkRowFlg;
    }

    function fn_attachmentUpload(type) {
        // Insert Attachment before updating respective data
        console.log("fn_attachmentUpload");

        var url;
        var formData;

        if($("#advReqPop").is(":visible")) {
            url = "/eAccounting/vendorAdvance/reqAttachmentUpload.do";
            formData = Common.getFormData("form_vendorAdvanceReq");

        } else if($("#settlementPop").is(":visible")) {
            url = "/eAccounting/vendorAdvance/settlementAttachmentUpload.do";
            formData = Common.getFormData("form_vendorAdvanceSettlement");
        }

        console.log("fn_attachmentUpload :: url :: " + url);

        Common.ajaxFile(url, formData, function(result) {
            /*
            On file's successful upload, execute insertion into FCM0027M, FCM0028D
            */
            if($("#advReqPop").is(":visible")) {
                // New Vendor Advance Request insert - No Claim Number
                $("#reqAtchFileGrpId").val(result.data.fileGroupKey);
                fn_insertVendorAdvReq(type);

            } else if($("#settlementPop").is(":visible")) {
                // New Vendor Advance Settlement insert - No Claim Number
                $("#settlementAtchFileGrpId").val(result.data.fileGroupKey);
                fn_insertVendorAdvSettlement(type);
            }
        });
    }

    function fn_attachmentUpdate(type) {
        // Update Attachment before updating respective data
        console.log("fn_attachmentUpdate");

        var url;
        var formData;

        if($("#advReqPop").is(":visible")) {
            url = "/eAccounting/vendorAdvance/reqAttachmentUpdate.do";
            formData = Common.getFormData("form_vendorAdvanceReq");

        } else if($("#settlementPop").is(":visible")) {
            url = "/eAccounting/vendorAdvance/settlementAttachmentUpdate.do";
            formData = Common.getFormData("form_vendorAdvanceSettlement");
        }

        formData.append("atchFileGrpId", gAtchFileGrpId);
        formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

        console.log("fn_attachmentUpload :: url :: " + url);

        Common.ajaxFile(url, formData, function(result) {
            /*
            On file's successful upload, execute FCM0027M, FCM0028D record(s) update(s)
            */
            if($("#advReqPop").is(":visible")) {
                // Vendor Advance Request Update - Claim Number Exist
                $("#reqAtchFileGrpId").val(result.data.fileGroupKey);
                fn_updateVendorAdvReq(type);

            } else if($("#settlementPop").is(":visible")) {
                // Vendor Advance Settlement Update - Claim Number Exist
                $("#settlementAtchFileGrpId").val(result.data.fileGroupKey);
                fn_updateVendorAdvSettlement(type);
            }
        });
    }

    function fn_insertVendorAdvReq(type) {
        // New Vendor Advance Request insert - No Claim Number
        console.log("fn_insertVendorAdvReq");
        var obj = $("#form_vendorAdvanceReq").serializeJSON();
        var gridData = GridCommon.getEditData(settlementGridId);
        obj.gridData = gridData;
        console.log(obj);

        Common.ajax("POST", "/eAccounting/vendorAdvance/insertVendorAdvReq.do", obj, function(result) {
            console.log(result);

            if(result.code == "00") {
                // Success save FCM0027M, FCM0028D
                if(type == "D") {
                    console.log("fn_insertVendorAdvReq :: D");
                    $("#advReqClose_btn").click();
                    $("#approvalLine_closeBtn").click();
                    Common.alert("New Vendor Advance draft save has been completed.<br/>Claim Number : " + result.data);
                } else if(type == "S") {
                    console.log("fn_insertVendorAdvReq :: S");
                    $("#reqNewClmNo").val(result.data);
                    // Acknowledgement Accepted - Submit mode
                    $("#appvLinePop").show();
                    $("#requestAppvLine").show();
                    $("#repaymentAppvLine").hide();
                    AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());
                    AUIGrid.addRow(approveLineGridID, {}, "first");

                    fn_setApprovalGridEvent();
                }
            } else {
                Common.alert(result.message);
            }
        });
    }

    function fn_insertVendorAdvSettlement(type) {
        // New Vendor Advance Settlement insert - No Claim Number
        console.log("fn_insertVendorAdvSettlement");
        var obj = $("#form_vendorAdvanceSettlement").serializeJSON();
        var gridData = AUIGrid.getOrgGridData(settlementGridId);
        obj.gridData = gridData;
        console.log(obj);

        Common.ajax("POST", "/eAccounting/vendorAdvance/insertVendorAdvSettlement.do", obj, function(result) {
            console.log(result);

            if(result.code == "00") {
                // Success save FCM0027M, FCM0028D
                if(type == "D") {
                    console.log("fn_insertVendorAdvSettlement :: D");
                    $("#advSettlementClose_btn").click();

                    Common.alert("New Vendor Advance Settlement draft save has been completed.<br/>Claim Number : " + result.data);

                } else if(type == "S") {
                    console.log("fn_insertVendorAdvSettlement :: S");
                    $("#settlementNewClmNo").val(result.data);
                    // Acknowledgement Accepted - Submit mode
                    $("#appvLinePop").show();
                    $("#requestAppvLine").show();
                    $("#repaymentAppvLine").hide();
                    AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());
                    AUIGrid.addRow(approveLineGridID, {}, "first");

                    fn_setApprovalGridEvent();
                }
            } else {
                Common.alert(result.message);
            }
        });
    }

    function fn_updateVendorAdvReq(type) {
        // Vendor Advance Request Update - Claim Number Exist
        /*
        Caller :: fn_attachmentUpdate()
        */
        console.log("fn_updateVendorAdvReq");
        var obj = $("#form_vendorAdvanceReq").serializeJSON();
        console.log(obj);

        Common.ajax("POST", "/eAccounting/vendorAdvance/updateVendorAdvReq.do", obj, function(result) {
            console.log(result);

            if(result.code == "00") {
                // Success
                if(type == "D") {
                    console.log("fn_updateVendorAdvReq :: D");
                    $("#advReqClose_btn").click();

                    Common.alert("Vendor Advance Request draft save has been updated.");

                } else if(type == "S") {
                    console.log("fn_updateVendorAdvReq :: S");
                    $("#appvLinePop").show();
                    $("#requestAppvLine").show();
                    $("#repaymentAppvLine").hide();
                    AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());
                    AUIGrid.addRow(approveLineGridID, {}, "first");

                    fn_setApprovalGridEvent();
                }

            } else {
                Common.alert(result.message);
            }
        });
    }

    function fn_updateVendorAdvSettlement(type) {
        // Vendor Advance Settlement Update - Claim Number Exist
        /*
        Caller :: fn_attachmentUpdate()
        */
        console.log("fn_updateVendorAdvSettlement");
        var obj = $("#form_vendorAdvanceSettlement").serializeJSON();
        var gridData = GridCommon.getEditData(settlementGridId);
        obj.gridData = gridData;
        console.log(obj);

        Common.ajax("POST", "/eAccounting/vendorAdvance/updateVendorAdvSettlement.do", obj, function(result) {
            console.log(result);

            if(result.code == "00") {
                // Success update FCM0027M, FCM0028D
                if(type == "D") {
                    console.log("fn_updateVendorAdvSettlement :: D");
                    $("#advSettlementClose_btn").click();

                    Common.alert("Vendor Advance Settlement draft save has been updated.");

                } else if(type == "S") {
                    console.log("fn_insertVendorAdvSettlement :: S");
                    $("#appvLinePop").show();
                    $("#requestAppvLine").show();
                    $("#repaymentAppvLine").hide();
                    AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());
                    AUIGrid.addRow(approveLineGridID, {}, "first");

                    fn_setApprovalGridEvent();

                }
            } else {
                Common.alert(result.message);
            }
        });

    }

    function fn_setGridData(gridId, data) {
        console.log(data);
        AUIGrid.setGridData(gridId, data);
    }
    // Common Functions - End

    // Advance Request Functions - Start
    function fn_reqDraft() {
        /*
        Vendor Advance Request Draft Button
        */
        console.log("fn_reqDraft");
        var checkEmpty = fn_saveValidation();

        if(!checkEmpty) {
            return false;
        }

        // Check claim number exist (New/Edit)
        if(FormUtil.isEmpty($("#reqNewClmNo").val())) {
            // New
            console.log("fn_reqDraft :: new advance request");
            fn_attachmentUpload("D");

        } else {
            // Edit
            console.log("fn_reqDraft :: update advance request");
            fn_attachmentUpdate("D");
        }
    }

    function fn_reqSubmit() {
        console.log("fn_reqSubmit");
        var checkEmpty = fn_saveValidation();

        if(!checkEmpty) {
            return false;
        }

        // Display Acknowledgement Pop
        $("#advReqMsgPop").show();
        //$("#acknowledgement").show();
    }

    function fn_settlementConfirm() {
        console.log("fn_settlementConfirm");

        // Display Acknowledgement Pop
        $("#manualSettMsgPop").show();
        $("#acknowledgementSett").show();
    }

    function fn_advReqAck(mode) {
        console.log("fn_advReqAck :: " + mode);

        // Hide acknowledgement pop  up
        //$("#advReqMsgPop").hide();
        //$("#ack1Checkbox").prop('checked', false);

        if(mode == "A") {
            // Acknowledgement Accepted
            // Check claim number exist (New/Edit)
            if($("#ack1Checkbox").is(":checked") == false) {
                Common.alert("Acknowledgement required!");
                return false;
            }else{
            	if(FormUtil.isEmpty($("#reqNewClmNo").val())) {
                    // New
                    console.log("fn_advReqAck :: new advance request");
                    fn_attachmentUpload("S");

                } else {
                    // Edit
                    console.log("fn_advReqAck :: update advance request");
                    fn_attachmentUpdate("S");
                }
            }
        } else if(mode == "J") {
            // Acknowledgement Rejected
            // Do nothing
        }

        // Acknowledgement for Manual Settlement
        if(mode == "Y") {
        	// Acknowledgement = YES
        	fn_settlementUpdate();
        }
        else if(mode == "N") {
        	// Acknowledgement = YES
        	fn_closePop('S');
        }
    }
    // Advance Request Functions - End

    // Advance Settlement Functions - Start
    function fn_settlementDraft() {
        /*
        Vendor Advance Settlement Draft Button
        */
        console.log("fn_settlementDraft");
        var checkEmpty = fn_saveValidation();

        if(!checkEmpty) {
            return false;
        }

        // Check claim number exist (New/Edit)
        if(FormUtil.isEmpty($("#settlementNewClmNo").val())) {
            // New
            console.log("fn_settlementDraft :: new advance request");
            fn_attachmentUpload("D");

        } else {
            // Edit
            console.log("fn_settlementDraft :: update advance request");
            fn_attachmentUpdate("D");
        }
    }

    function fn_settlementSubmit() {
        /*
        Vendor Advance Settlement Submit Button
        */
        console.log("fn_settlementSubmit");
        var checkEmpty = fn_saveValidation();

        console.log(checkEmpty);
        if(!checkEmpty) {
            return false;
        }

        // Check claim number exist (New/Edit)
        if(FormUtil.isEmpty($("#settlementNewClmNo").val())) {
            // New
            console.log("fn_settlementSubmit :: new advance settlement");
            fn_attachmentUpload("S");

        } else {
            // Edit
            console.log("fn_settlementSubmit :: update advance settlement");
            fn_attachmentUpdate("S");
        }
    }

    function fn_setSettlementGridEvent() {
        console.log("fn_setSettlementGridEvent");

        AUIGrid.bind(settlementGridId, "cellClick", function(event) {
            selectRowIdx = event.rowIndex;
        });

        // cellEditEnd - Start
        AUIGrid.bind(settlementGridId, "cellEditEnd", function(event) {
            if(event.dataField == "totalAmt" || event.dataField == "netAmt" || event.dataField == "taxAmt") {
                // Set Settlement's total expenses
                var totAmt = fn_getTotalExpenses();
                console.log("totAmt: " + totAmt);
                $("#settlementTotalExp").val(AUIGrid.formatNumber(totAmt, "#,##0.00"));
                $("#settlementTotAmt").val(AUIGrid.formatNumber(totAmt, "#,##0.00"));
                console.log("settlementTotalAdv BEFORE: " + $("#settlementTotalAdv").val());
                var settlementGridSettTotalAdv = parseFloat($("#settlementTotalAdv").val().replace(",", "")).toFixed(0);
                $("#settlementTotalBalance").val(settlementGridSettTotalAdv - totAmt);
                $("#settlementTotalBalance").val(AUIGrid.formatNumber($("#settlementTotalBalance").val(), "#,##0.00"));

                // Check budget
                var rowVar = {
                        costCentr : $("#settlementCostCenter").val(),
                        stYearMonth : $("#settlementKeyDate").val(),
                        stBudgetCode : AUIGrid.getCellValue(settlementGridId, event.rowIndex, "budgetCode"),
                        stGlAccCode : AUIGrid.getCellValue(settlementGridId, event.rowIndex, "glAccCode")
                };

                var availableAmtCp = 0;
                // checkBgtPlan - Start
                Common.ajax("GET", "/eAccounting/webInvoice/checkBgtPlan.do", rowVar, function(result) {
                    console.log("checkBgtPlan :: budgetCode :: " + event.item.budgetCode + "; glAccCode :: " + event.item.glAccCode + "; ctrlType :: " + result.ctrlType);

                    if(result.ctrlType == "Y") {
                        // availableAmtCp - Start
                        Common.ajax("GET", "/eAccounting/webInvoice/availableAmtCp.do", rowVar, function(result1) {
                            console.log("availableAmtCp :: budgetCode :: " + event.item.budgetCode + "; glAccCode :: " + event.item.glAccCode + "; totalAvailable :: " + result1.totalAvailable);

                            var finAvailable = (parseFloat(result.totalAvilableAdj) - parseFloat(result.totalPending) - parseFloat(result.totalUtilized)).toFixed(2);

                            if(parseFloat(finAvailable) < parseFloat(event.item.totAmt)) {
                                console.log("finAvailable < totAmt");
                                Common.alert("Insufficient budget amount for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
                                AUIGrid.setCellValue(settlementGridId, event.rowIndex, "totAmt", "0.00");
                            }
                        });
                        // availableAmtCp - End
                    }
                });
                // checkBgtPlan - End
            }

            if(event.dataField == "invcNo") {
                var data = {
                        memAccId : $("#settlementMemAccId").val(),
                        invcNo : AUIGrid.getCellValue(settlementGridId, event.rowIndex, "invcNo")
                }

                Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
                    if(result.data) {
                        Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
                    }
                });
            }

            if(event.dataField == "currency") {
                console.log("currency change");

                var fCur = AUIGrid.getCellValue(settlementGridId, 0, "currency");

                if(event.rowIndex != 0) {
                    if(AUIGrid.getRowCount(settlementGridId) > 1) {
                        var cCur = AUIGrid.getCellValue(settlementGridId, event.rowIndex, "currency");

                        if(cCur != fCur) {
                            Common.alert("Different currency selected!");
                            AUIGrid.setCellValue(settlementGridId, event.rowIndex, "currency", fCur);
                        }
                    }
                } else {
                    for(var i = 1; i < AUIGrid.getRowCount(settlementGridId); i++) {
                        AUIGrid.setCellValue(settlementGridId, i, "currency", fCur);
                    }
                }
            }
        });
        // cellEditEnd - End
    }

    function fn_getTotalExpenses() {
        console.log("fn_getTotalExpenses");

        var sum = 0;
        var totAmtList = AUIGrid.getColumnValues(settlementGridId, "totalAmt");
        if(totAmtList.length > 0) {
            for(var i in totAmtList) {
                sum += totAmtList[i];
            }
        }

        return sum;
    }

    function fn_getSettlementBalance() {
        console.log("fn_getSettlementBalance");

        var advAmt = $("#settlementReqAmt").val();
        var expAmt = $("#totAmt").val();

        var balanceAmt = parseFloat(advAmt) - parseFloat(expAmt);
        $("#balanceAmt").val(balanceAmt);
        $("#settlementTotalBalance").text(AUIGrid.formatNumber(balanceAmt, "#,##0.00"));
    }

    function fn_settlementAddRow() {
        console.log("fn_settlementAddRow");

        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"A3"}, function(result) {
            console.log(result);
            AUIGrid.addRow(
                settlementGridId,
                {
                    clamUn : result.clamUn,
                    taxCode : "OP (Purchase(0%):Out of scope)",
                    cur : "MYR",
                    totAmt : 0
                },
                "last"
            );
        });
    }

    function fn_settlementRemoveRow() {
        console.log("fn_settlementRemoveRow");
    }

    // Settlement Grid - Search Button functions - Start
    function fn_budgetCodePop(rowIndex) {
        // console.log("fn_budgetCodePop");
        if(!FormUtil.isEmpty($("#settlementCostCenter").val())) {
            $("#budgetSearchPop").show();

            // Set budgetSearchPop's value (Cost Center)
            $("#hBudgetCostCentrName").val($("#settlementCostCenterText").val());
            $("#hBudgetCostCentr").val($("#settlementCostCenter").val());
            $("#budgetCostCenter").val($("#settlementCostCenter").val())
            $("#hBudgetRowIndex").val(rowIndex);

            fn_setSettlementBudgetGridEvent();
        } else {
            Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        }
    }

    function fn_glAccountSearchPop(rowIndex) {
        console.log("fn_glAccountSearchPop");

        var myValue = AUIGrid.getCellValue(settlementGridId, rowIndex, "budgetCode");

        if(!FormUtil.isEmpty(myValue)){
            $("#glSearchPop").show();

            // Set glSearchPop's value (Cost Center, Budget Code)
            $("#hGLcostCentrName").val($("#settlementCostCenterText").val());
            $("#hGLcostCentr").val($("#settlementCostCenter").val());
            $("#hGLbudgetCodeName").val(AUIGrid.getCellValue(settlementGridId, rowIndex, "budgetCodeName"));
            $("#hGLbudgetCode").val(AUIGrid.getCellValue(settlementGridId, rowIndex, "budgetCode"));
            $("#hGLRowIndex").val(rowIndex);
            $("#glCostCenter").val($("#settlementCostCenter").val());
            $("#glBudgetCode").val(AUIGrid.getCellValue(settlementGridId, rowIndex, "budgetCode"));

            fn_setSettlementGLGridEvent();

        } else {
            Common.alert('<spring:message code="webInvoice.budgetCode.msg" />');
        }
    }
    // Settlement Grid - Search Button functions - End

    // Settlement - Budget Code Search functions - Start
    function fn_setSettlementBudgetGridEvent() {
        console.log("fn_setSettlementBudgetGridEvent");
        //console.log("hBudgetRowIndex :: " + $("#hBudgetRowIndex").val());
        console.log("gRowIndex :: " + gRowIndex);

        AUIGrid.bind(budgetGridID, "cellDoubleClick", function(event) {
            AUIGrid.setCellValue(settlementGridId, gRowIndex, "budgetCode", AUIGrid.getCellValue(budgetGridID, event.rowIndex, "budgetCode"));
            AUIGrid.setCellValue(settlementGridId, gRowIndex, "budgetCodeName", AUIGrid.getCellValue(budgetGridID, event.rowIndex, "budgetCodeText"));

            AUIGrid.setCellValue(settlementGridId, event.rowIndex, "glAccCode", "");
            AUIGrid.setCellValue(settlementGridId, event.rowIndex, "glAccCodeName", "");
            AUIGrid.setCellValue(settlementGridId, event.rowIndex, "totAmt", "0.00");

            var totAmt = fn_getTotalExpenses();
            $("#settlementTotalExp").val(AUIGrid.formatNumber(totAmt, "#,##0.00"));
            $("#settlementTotAmt").val(totAmt);

            $("#bgSForm").clearForm();
            AUIGrid.clearGridData(budgetGridID);

            gRowIndex = null;
            $("#budgetSearchPop").hide();
        });
    }

    function fn_selectBudgetListAjax() {
        var data = {
                costCentr : $("#budgetCostCenter").val(),
                budgetCodeText : $("#budgetCodeText").val()
        };
        Common.ajax("GET", "/eAccounting/webInvoice/selectBudgetCodeList", data, function(result) {
            console.log(result);
            AUIGrid.setGridData(budgetGridID, result);
        });
    }
    // Settlement - Budget Code Search functions - End

    // Settlement - GL Code Search functions - Start
    function fn_setSettlementGLGridEvent() {
        console.log("fn_setSettlementGLGridEvent");
        //console.log("hGLRowIndex :: " + $("#hGLRowIndex").val());
        console.log("gRowIndex :: " + gRowIndex);

        AUIGrid.bind(glAccGridID, "cellDoubleClick", function(event) {
            AUIGrid.setCellValue(settlementGridId, gRowIndex, "glAccCode", AUIGrid.getCellValue(glAccGridID, event.rowIndex , "glAccCode"));
            AUIGrid.setCellValue(settlementGridId, gRowIndex, "glAccCodeName",  AUIGrid.getCellValue(glAccGridID, event.rowIndex , "glAccDesc"));

            $("#glSForm").clearForm();
            AUIGrid.clearGridData(glAccGridID);

            gRowIndex = null;
            $("#glSearchPop").hide();
        });
    }

    function fn_selectGlListAjax() {
        var data = {
                costCentr : $("#glCostCenter").val(),
                budgetCode : $("#glBudgetCode").val()
        };
        Common.ajax("GET", "/eAccounting/webInvoice/selectGlCodeList", data, function(result) {
            console.log(result);
            AUIGrid.setGridData(glAccGridID, result);
        });
    }
    // Settlement - GL Code Search functions - End
    // Advance Settlement Functions - End

    // Approval Line Grid - Start
    function fn_setApprovalGridEvent() {
        console.log("fn_setApprovalGridEvent");
    }

    function fn_appvLineGridAddRow() {
        AUIGrid.addRow(approveLineGridID, {}, "first");
    }

    function fn_appvLineGridDeleteRow() {
        AUIGrid.removeRow(approveLineGridID, selectRowIdx);
    }

    function fn_searchUserIdPop() {
        console.log("fn_searchUserIdPop");
        Common.popupDiv("/common/memberPop.do", {callPrgm:"NRIC_VISIBLE"}, null, true);
    }

    function fn_loadOrderSalesman(memId, memCode) {
        var result = true;
        var list = AUIGrid.getColumnValues(approveLineGridID, "memCode", true);

        if(list.length > 0) {
            for(var i = 0; i < list.length; i ++) {
                if(memCode == list[i]) {
                    result = false;
                }
            }
        }

        if(result) {
            Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {
                if(memInfo == null) {
                    Common.alert('<b>Member not found.</br>Your input member code : ' + memCode + '</b>');

                } else {
                    console.log(memInfo);
                    AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "memCode", memInfo.memCode);
                    AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "name", memInfo.name);
                }
            });
        } else {
            Common.alert('Not allowed to select same User ID in Approval Line');
        }
    }

    function fn_approvalSubmit() {
        console.log("fn_approvalSubmit");

        // Duplicate newWebInvoiceRegistMsgPop's fn_approveLineSubmit
        if($("#settlementPop").is(":visible")) {
            var newGridList = AUIGrid.getOrgGridData(settlementGridId);
            var date = new Date();
            var year = date.getFullYear();
            var month = date.getMonth() + 1;
            var costCenter = $("#settlementCostCenter").val();

            var data = {
                    newGridList : newGridList,
                    year : year,
                    month : month,
                    costCentr : costCenter
            };

            Common.ajax("POST", "/eAccounting/webInvoice/budgetCheck.do", data, function(result) {
                console.log(result);

                if(result.length > 0) {
                    Common.alert('<spring:message code="newWebInvoRegistMsg.budget.msg" />');
                } else {
                    fn_approvalLineSubmit();
                }
            });
        } else if($("#advReqPop").is(":visible")) {
            fn_approvalLineSubmit();
        }

    }

    function fn_approvalLineSubmit() {
        console.log("fn_approvalLineSubmit");
        var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
        var gridData = AUIGrid.getOrgGridData(settlementGridId);

        var obj, msg;

        // Serialize form and set Object's value
        if($("#advReqPop").is(":visible")) {
            obj = $("#form_vendorAdvanceReq").serializeJSON();
            obj.clmNo = $("#reqNewClmNo").val();
            obj.apprGridList = apprGridList;
            obj.gridData = gridData;

            msg = "Request";

        } else if($("#settlementPop").is(":visible")) {
            obj = $("#form_vendorAdvanceSettlement").serializeJSON();
            obj.clmNo = $("#settlementNewClmNo").val();
            obj.apprGridList = apprGridList;

            msg = "Settlement";
        }

        console.log(obj);
        Common.ajax("POST", "/eAccounting/webInvoice/checkFinAppr.do", obj, function(result) {
            console.log(result);

            if(result.code == "99") {
                Common.alert("Please select the relevant final approver.");
            } else {
                Common.ajax("POST", "/eAccounting/vendorAdvance/approveLineSubmit.do", obj, function(sResult) {
                    console.log(sResult);

                    if(sResult.code == "00") {
                        Common.alert("Registration of new Vendor Advance " + msg + " has been completed. Claim No: " + obj.clmNo);
                    } else {
                        Common.alert("Registration of new Vendor Advance " + msg + " failed.");
                    }
                });

                fn_closePop('M');
                fn_closePop('S');
            }
        });
    }
    // Approval Line Grid - End

    //Edit Rejected
    function fn_editRejected() {
    console.log("fn_editRejected");

    var gridObj = AUIGrid.getSelectedItems(advGridId);
    var list = AUIGrid.getCheckedRowItems(advGridId);

    if(gridObj != "" || list != "") {
        var status;
        var selClmNo;

        if(list.length > 1) {
            Common.alert("* Only 1 record is permitted. ");
            return;
        }

        if(gridObj.length > 0) {
            status = gridObj[0].item.appvPrcssStus;
            selClmNo = gridObj[0].item.clmNo;
        } else {
            status = list[0].item.appvPrcssStus;
            selClmNo = list[0].item.clmNo;
        }

        if(status == "J") {
            Common.ajax("POST", "/eAccounting/vendorAdvance/editRejected.do", {clmNo : selClmNo}, function(result1) {
                console.log(result1);

                Common.alert("New claim number : " + result1.data.newClmNo);
                fn_searchAdv();
            })
        } else {
            Common.alert("Only rejected claims are allowed to edit.");
        }
    } else {
        Common.alert("* No Value Selected. ");
        return;
    }
}
</script>

<style>
.popup_wrap2{
    height:625px;
    max-height:625px;
    position:fixed;
    top:20px;
    left:50%;
    z-index:1001;
    margin-left:-500px;
    width:1000px;
    background:#fff;
    border:1px solid #ccc;
}

.popup_wrap2.size_mid2{
    width:600px!important;
    margin-left:-300px!important;
}

.popup_wrap2:after{
    content:"";
    display:block;
    position:fixed;
    top:0;
    left:0;
    z-index:-1;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.6);
}

.pop_body2{
    height:620px;
    padding:10px;
    background:#fff;
    overflow-y:scroll;
}

.tap_block{
    margin-top:10px;
    margin-bottom:10px;
    border:1px solid #ccc;
    padding:10px;
    border-radius:3px;
}

.aui-grid-user-custom-left {
    text-align:left;
}

.aui-grid-user-custom-right {
    text-align:right;
}
</style>

<!--
*************************************************
*************** MAIN MENU - START ***************
*************************************************
 -->

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
        <h2>Vendor Advance</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <li><p class="btn_blue"><a href="#" id="settlementUpd_btn">Manual Settlement</a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="#" id="request_btn">New Request</a></p></li>
            <li><p class="btn_blue"><a href="#" id="refund_btn">Settlement</a></p></li>
            <li><p class="btn_blue"><a href="#" id="advList_btn"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form action="#" method="post" id="searchForm">
            <input type="hidden" id="memAccName" name="memAccName">
            <input type="hidden" id="costCenterText" name="costCenterText">

            <table class="type1"><!-- table start -->
                <caption><spring:message code="webInvoice.table" /></caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Advance Type</th>
                        <td>
                            <select class="multy_select" multiple="multiple" id="advType" name="advType">
                                <option value="5">Vendor Advance - Request</option>
                                <option value="6">Vendor Advance - Settlement</option>
                            </select>
                        </td>
                        <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
                        <td>
                           <input type="text" title="" placeholder="" class="" style="width:200px" id="listCostCenter" name="listCostCenter"/>
                           <a href="#" class="search_btn" id="search_costCenter_btn">
                               <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                           </a>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Member Code</th>
                        <td>
                           <input type="text" title="" placeholder="" class="" style="width:200px" id="memAccCode" name="memAccCode"/>
                           <a href="#" class="search_btn" id="search_payee_btn">
                               <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                           </a>
                        </td>
                        <th scope="row"><spring:message code="webInvoice.status" /></th>
                        <td>
                            <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
                                <option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
                                <option value="R"><spring:message code="webInvoice.select.request" /></option>
                                <option value="P"><spring:message code="webInvoice.select.progress" /></option>
                                <option value="A"><spring:message code="webInvoice.select.approved" /></option>
                                <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="invoiceApprove.clmNo" /></th>
                        <td>
                            <!-- <input type="text" title="" placeholder="" class="" id="clmNo" name="clmNo"/>  -->
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Claim No Start" id="clmNoStart" name="clmNoStart" class="cRange" /></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Claim No End" id="clmNoEnd" name="clmNoEnd" class="cRange" /></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row">Repayment Status</th>
                        <td>
                            <select class="multy_select" multiple="multiple" id="refundStus" name="refundStus">
                                <option value="1">Not Due</option>
                                <option value="2">Due but not repaid</option>
                                <option value="3">Repaid</option>
                                <option value="4">Pending Approval</option>
                                <option value="5">Draft</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Request Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" id="reqStartDt" name="reqStartDt"/></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" id="reqEndDt" name="reqEndDt"/></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row">Approval Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Approval Start Date" placeholder="DD/MM/YYYY" class="j_date" id="appStartDt" name="appStartDt"/></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Approval End Date" placeholder="DD/MM/YYYY" class="j_date" id="appEndDt" name="appEndDt"/></p>
                            </div><!-- date_set end -->
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </section>

    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
            <dt>Link</dt>
        <dd>
            <ul class="btns">
                <li><p class="link_btn"><a href="#" id="editRejBtn">Edit Rejected</a></p></li>
            </ul>
            <ul class="btns">
            </ul>
            <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->
    <section class="search_result"><!-- search_result start -->
        <article class="grid_wrap" id="grid_wrap" style="height:500px"></article><!-- grid_wrap end -->
    </section>
</section>

<!--
***********************************************
*************** MAIN MENU - END ***************
***********************************************
-->

<!--
*******************************************************
*************** ADVANCE REQUEST - START ***************
*******************************************************
-->
<div class="popup_wrap2" id="advReqPop" style="display:none;">
    <header class="pop_header">
        <h1 id="h1_req">New Advance Request</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="advReqClose_btn" onclick="javascript:fn_closePop('M')"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body2">
        <ul class="right_btns mb10">
            <li><p class="btn_blue2"><a href="#" id="reqDraft"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
            <li><p class="btn_blue2"><a href="#" id="reqSubmit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
        </ul>

        <section class="search_table">
            <form action="#" id="form_vendorAdvanceReqUpd" method="post"></form>

            <form action="#" method="post" enctype="multipart/form-data" id="form_vendorAdvanceReq">
                <input type="hidden" id="reqNewClmNo" name="reqNewClmNo">
                <input type="hidden" id="reqAtchFileGrpId" name="reqAtchFileGrpId">
                <input type="hidden" id="newCostCenterText" name="costCentrName">
                <input type="hidden" id="bankCode" name="bankCode">
                <input type="hidden" id="totAmt" name="totAmt">
                <input type="hidden" id="crtUserId" name="crtUserId" value="${userId}">

                <table class="type1"><!-- table start -->
                    <caption><spring:message code="webInvoice.table" /></caption>
                    <colgroup>
                        <col style="width:150px" />
                        <col style="width:*" />
                        <col style="width:150px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row">Advance Type</th>
                            <td>
                                <select class="readonly w100p" id="reqAdvType" name="reqAdvType">
                                    <option value="5" selected="selected">Vendor Advance - Request</option>
                                </select>
                            </td>
                            <th scope="row">Entry Date</th>
                            <td>
                                <input type="text" title="" placeholder="DD/MM/YYYY" class="w100p" id="keyDate" name="keyDate"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="" id="reqCostCenter" name="reqCostCentr" value="${costCentr}" readonly/>
                                <a href="#" class="search_btn" id="costCenter_search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                            </td>
                            <th scope="row"><spring:message code="newWebInvoice.createUserId" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="reqCrtUserName" value="${userName}"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Payee Code</th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly" id="newMemAccId" name="memAccId" readonly="readonly" />
                                <a href="#" class="search_btn" id="supplier_search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                            </td>
                            <th scope="row">Payee Name</th>
                            <td>
                            <input type="text" title="" placeholder="" class="w100p" id="newMemAccName" name="memAccName" disabled/></td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="newWebInvoice.bank" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName"/>
                            </td>
                            <th scope="row"><spring:message code="newWebInvoice.bankAccount" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Advance Currency</th>
                            <td colspan="3">
                                <select id="advCurr" name="advCurr">
                                    <option value="MYR" selected>MYR</option>
                                    <option value="USD">USD</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" id="totalAdvHeader">Total Advance (RM)</th>
                            <td colspan="3">
                                <input type="text" title="Total Advance (RM)" placeholder="Total Advance (RM)" id="totalAdv" name="totalAdv" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Advance Occasions</th>
                            <td colspan="3">
                                <select id="advOccasion" name="advOccasion"></select>
                            </td>
                        </tr>
                        <tr id="appvStusRow" style="display:none;">
	                        <th scope="row"><spring:message code="approveView.approveStatus" /></th>
	                        <td colspan="3" style="height:60px" id="viewAppvStus" name="viewAppvStus"></td>
	                    </tr>
	                    <tr id="rejectReasonRow" style="display:none;">
	                        <th scope="row">Reject Reason</th>
	                        <td colspan="3" id="viewRejectReason" name="viewRejectReason"></td>
	                    </tr>
	                    <tr id=finalAppvRow style="display:none;">
                            <th scope="row">Final Approver</th>
                            <td colspan="2" style="height:60px" id="viewFinalApprover" name="viewFinalApprover"></td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="newWebInvoice.remark" /></th>
                            <td colspan="3">
                                <textarea cols="20" rows="5" id="advRem" name="advRem" maxlength="100" placeholder="Enter up to 100 characters"></textarea></td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
                            <td colspan="3" id="attachTd">
                                <div class="auto_file attachment_file w100p"><!-- auto_file start -->
                                    <input type="file" id="reqFileSelector" name="reqFileSelector" title="file add" style="width:300px" />
                                </div><!-- auto_file end -->
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
            </form>
        </section><!-- search_table end -->
    </section>
</div>
<!--
*****************************************************
*************** ADVANCE REQUEST - END ***************
*****************************************************
-->

<!--
***********************************************************************
*************** ADVANCE REQUEST ACKNOWLEDGEMENT - START ***************
***********************************************************************
-->
<div class="popup_wrap size_small" id="advReqMsgPop" style="display: none;">
    <header class="pop_header">
        <h1 id="advReqMsgPopHeader">Submission of Request</h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#" id="acknowledgement_closeBtn" onclick="javascript:fn_closePop('S')">
                        <spring:message code="newWebInvoice.btn.close" />
                    </a>
                </p>
            </li>
        </ul>
    </header>

    <section class="pop_body">
        <div id="acknowledgement" style="padding-top:1%; padding-left: 1%; padding-right: 1%">
            <table class="type1" style="border: none">
                <caption>New Advance Request</caption>
                <colgroup>
                    <col style="width:30px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <td colspan="2" style="font-size : 14px; font-weight : bold; padding-bottom : 2%">
                            Are you sure you want to submit this advance request?
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="checkbox" id="ack1Checkbox" name="ack1Checkbox" value="1" />
                        </td>
                        <td style="padding-top : 2%; padding-bottom : 2%; text-align : justify;">
                            By checking this box, you acknowledge that you have read and understand all the policies and rules with respect to advance, and agree to abide by all the policies and rules.
                        </td>
                    </tr>
                </tbody>
            </table>

            <ul class="center_btns" id="agreementButton">
                <li><p class="btn_blue"><a href="javascript:fn_advReqAck('A');">Yes</a></p></li>
                <li><p class="btn_blue"><a href="javascript:fn_advReqAck('J');">No</a></p></li>
            </ul>
        </div>
    </section>
</div>
<!--
*********************************************************************
*************** ADVANCE REQUEST ACKNOWLEDGEMENT - END ***************
*********************************************************************
-->

<!--
***********************************************************************
*************** MANUAL SETTLEMENT ACKNOWLEDGEMENT - START ***************
***********************************************************************
-->
<div class="popup_wrap size_small" id="manualSettMsgPop" style="display: none;">
    <header class="pop_header">
        <h1 id="manualSettMsgPopHeader">Manual Settlement Confirmation</h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#" id="acknowledgementSett_closeBtn" onclick="javascript:fn_closePop('S')">
                        <spring:message code="newWebInvoice.btn.close" />
                    </a>
                </p>
            </li>
        </ul>
    </header>

    <section class="pop_body">
        <div id="acknowledgementSett" style="padding-top:1%; padding-left: 1%; padding-right: 1%">
            <table class="type1" style="border: none">
                <caption>Manual Settlement</caption>
                <colgroup>
                    <col style="width:30px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <td colspan="2" style="font-size : 14px; font-weight : bold; padding-bottom : 2%">
                            Are you sure you want to manual settle this advance request?
                        </td>
                    </tr>
                </tbody>
            </table>

            <ul class="center_btns" id="agreementButton">
                <li><p class="btn_blue"><a href="javascript:fn_advReqAck('Y');">Yes</a></p></li>
                <li><p class="btn_blue"><a href="javascript:fn_advReqAck('N');">No</a></p></li>
            </ul>
        </div>
    </section>
</div>
<!--
*********************************************************************
*************** MANUAL SETTLEMENT ACKNOWLEDGEMENT - END ***************
*********************************************************************
-->

<!--
**********************************************************
*************** ADVANCE SETTLEMENT - START ***************
**********************************************************
-->
<div class="popup_wrap2" id="settlementPop" style="display:none;">
    <header class="pop_header">
        <h1 id="h1_settlement">Vendor Advance Settlement</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="advSettlementClose_btn" onclick="javascript:fn_closePop('M')"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <ul class="right_btns mb10">
            <li><p class="btn_blue2"><a href="#" id="settlementDraft"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
            <li><p class="btn_blue2"><a href="#" id="settlementSubmit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
        </ul>

        <section class="search_table">
            <form action="#" id="form_vendorAdvanceSettlementUpd" method="post"></form>

            <form action="#" method="post" enctype="multipart/form-data" id="form_vendorAdvanceSettlement">
                <input type="hidden" id="settlementNewClmNo" name="settlementNewClmNo">
                <input type="hidden" id="settlementAtchFileGrpId" name="settlementAtchFileGrpId">
                <input type="hidden" id="settlementCostCenterText" name="settlementCostCenterText">
                <input type="hidden" id="bankCode" name="bankCode">
                <input type="hidden" id="settlementReqAmt" name="settlementReqAmt"> <!-- Requested amount -->
                <input type="hidden" id="settlementTotAmt" name="settlementTotAmt"> <!-- Expenses total amount -->
                <input type="hidden" id="balanceAmt" name="balanceAmt"> <!-- Requested amount - Expenses total amount -->
                <input type="hidden" id="crtUserId" name="crtUserId" value="${userId}">
                <input type="hidden" id="settlementAdvRefdNo" name="settlementAdvRefdNo">

                <table class="type1"><!-- table start -->
                    <caption><spring:message code="webInvoice.table" /></caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />
                        <col style="width:180px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row">Advance Type</th>
                            <td>
                                <select class="readonly w100p" id="settlementType" name="settlementType">
                                    <option value="6" selected="selected">Vendor Advance - Settlement</option>
                                </select>
                            </td>
                            <th scope="row">Entry Date</th>
                            <td>
                                <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p" id="settlementKeyDate" name="settlementKeyDate"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="settlementCostCenter" name="settlementCostCenter" value="${costCentr}"/>
                            </td>
                            <th scope="row"><spring:message code="newWebInvoice.createUserId" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="settlementCrtUserName" name="settlementCrtUserName" value="${userName}"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Payee Code</th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="settlementMemAccId" name="settlementMemAccId"/>
                            </td>
                            <th scope="row">Payee Name</th>
                            <td>
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="settlementMemAccName" name="settlementMemAccName"/></td>
                        </tr>
                        <tr id="settlementBankRow" style="display: none">
                            <th scope="row"><spring:message code="newWebInvoice.bank" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="settlementBankName" name="settlementBankName"/>
                            </td>
                            <th scope="row"><spring:message code="newWebInvoice.bankAccount" /></th>
                            <td>
                                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="settlementBankAccNo" name="settlementBankAccNo"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Event Date</th>
                            <td>
                                <div class="date_set w100p"><!-- date_set start -->
                                    <p><input type="text" title="Event Start Date" placeholder="DD/MM/YYYY" class="j_date" id="eventStartDt" name="eventStartDt"/></p>
                                    <span><spring:message code="webInvoice.to" /></span>
                                    <p><input type="text" title="Event End Date" placeholder="DD/MM/YYYY" class="j_date" id="eventEndDt" name="eventEndDt"/></p>
                                </div><!-- date_set end -->
                            </td>
                            <th></th>
                            <td></td>
                        </tr>
                        <tr>
                            <th scope="row" id="settlementTotalAdvHeader">Advance Amount (RM)</th>
                            <td colspan="3">
                                <input type="text" title="Total Advance (RM)" placeholder="Total Advance (RM)" id="settlementTotalAdv" name="settlementTotalAdv" class="readonly" readonly="readonly" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" id="settlementTotalExpHeader">Total Expenses (RM)</th>
                            <td colspan="3">
                                <input type="text" title="Total Expenses (RM)" placeholder="Total Expenses (RM)" id="settlementTotalExp" name="settlementTotalExp" class="readonly" readonly="readonly" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Balance Amount</th>
                            <td colspan="3">
                                <input type="text" title="Balance (RM)" placeholder="Balance (RM)" id="settlementTotalBalance" name="settlementTotalBalance" class="readonly" readonly="readonly" />
                                <span>
                                    (+) Repay to Company / (-) Repay to Requestor
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Refund Mode</th>
                            <td>
                                <select class="readonly w100p" id="settlementMode" name="settlementMode">
                                    <option value="CASH" selected="selected">Cash</option>
                                    <option value="OTRX" selected="selected">Online</option>
                                </select>
                            </td>
                            <th scope="row">Bank Reference</th>
                            <td>
                                <input type="text" title="Bank Reference" placeholder="Bank Reference" id="bankRef" name="bankRef" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="newWebInvoice.remark" /></th>
                            <td colspan="3">
                                <textarea cols="20" rows="5" id="settlementRem" name="settlementRem" maxlength="200" placeholder="Enter up to 200 characters"></textarea></td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
                            <td colspan="3" id="attachTd">
                                <div class="auto_file attachment_file w100p"><!-- auto_file start -->
                                    <input type="file" id="settlementFileSelector" name="settlementFileSelector" title="file add" style="width:300px" />
                                </div><!-- auto_file end -->
                            </td>
                        </tr>
                        <tr id="appvStusRowSett" style="display:none;">
                            <th scope="row"><spring:message code="approveView.approveStatus" /></th>
                            <td colspan="3" style="height:60px" id="viewAppvStusSett"></td>
                        </tr>
                        <tr id="rejectReasonRowSett" style="display:none;">
                            <th scope="row">Reject Reason</th>
                            <td colspan="3" id="viewRejctResn"></td>
                        </tr>
                        <tr id="finApprActRowSett" style="display:none;">
                            <th scope="row">Final Approver</th>
                            <td colspan="3" id="viewFinAppr"></td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
            </form>
        </section><!-- search_table end -->

        <aside>
            <ul class="right_btns">
                <li><p class="btn_grid"><a href="#" id="settlement_add_row" onclick="javascript:fn_settlementAddRow()"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
                <li><p class="btn_grid"><a href="#" id="settlement_remove_row" onclick="javascript:fn_settlementRemoveRow()"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
            </ul>
        </aside>
        <article class="grid_wrap" id="settlement_grid_wrap"></article>

        <!--
        <section class="search_result" style="width: 100%">
            <article class="grid_wrap" id="settlementGridWrap"></article>
        </section>
        -->
    </section>
</div>
<!--
********************************************************
*************** ADVANCE SETTLEMENT - END ***************
********************************************************
-->
<!--
****************************************************************
*************** SETTLEMENT BUDGET SEARCH - START ***************
****************************************************************
-->
<div class="popup_wrap2 size_mid2" id="budgetSearchPop" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code="expense.ActivityCodeSearch" /></h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#" id="settlementBudgetSearch_closeBtn" onclick="javascript:fn_closePop('S')">
                        <spring:message code="newWebInvoice.btn.close" />
                    </a>
                </p>
            </li>
        </ul>
    </header>

    <section class="pop_body" style="min-height: auto;">

        <ul class="right_btns mb10">
            <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_selectBudgetListAjax();"><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
        </ul>

        <section class="search_table">
            <form action="#" method="post" id="bgSForm" >
                <input type="hidden" name="hBudgetCostCentrName">
                <input type="hidden" name="hBudgetCostCentr">
                <input type="hidden" name="hBudgetRowIndex">

                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:100px" />
                        <col style="width:*" />
                        <col style="width:130px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
                            <td>
                                <input type="text" placeholder="" class="readonly w100p" readonly="readonly" id="budgetCostCenter" />
                            </td>
                            <th scope="row"><spring:message code="expense.ActivityName" /></th>
                            <td>
                                <input type="text" id="budgetCodeText" name ="budgetCodeText" title="<spring:message code='expense.ActivityName' />" placeholder="" class="w100p" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </section>

        <section class="search_result">
            <article class="grid_wrap" id="budgetGrid"></article>
        </section>
    </section>
</div>
<!--
**************************************************************
*************** SETTLEMENT BUDGET SEARCH - END ***************
**************************************************************
-->
<!--
************************************************************
*************** SETTLEMENT GL SEARCH - START ***************
************************************************************
-->
<div class="popup_wrap2 size_mid2" id="glSearchPop" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code="expense.GlAccountSearch" /></h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#" id="settlementGlSearch_closeBtn" onclick="javascript:fn_closePop('S')">
                        <spring:message code="expense.CLOSE" />
                    </a>
                </p>
            </li>
        </ul>
    </header>

    <section class="pop_body" style="min-height: auto;">
        <ul class="right_btns mb10">
            <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_selectGlListAjax();"><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
        </ul>

        <section class="search_table">
            <form action="#" id="glSForm" name="glSForm" method="post">
                <input type="hidden" name="hGLcostCentrName">
                <input type="hidden" name="hGLcostCentr">
                <input type="hidden" name="hGLbudgetCodeName">
                <input type="hidden" name="hGLbudgetCode">
                <input type="hidden" name="hGLRowIndex">

                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:130px" />
                        <col style="width:*" />
                        <col style="width:130px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
                            <td>
                                <input type="text" placeholder="" class="readonly w100p" readonly="readonly" value="" id="glCostCenter" />
                            </td>
                            <th scope="row"><spring:message code="expense.Activity" /></th>
                            <td>
                                <input type="text" placeholder="" class="readonly w100p" readonly="readonly" value="" id="glBudgetCode" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </section>

        <section class="search_result">
            <article class="grid_wrap" id="glCodeGrid"></article>
        </section>
    </section>
</div>
<!--
**********************************************************
*************** SETTLEMENT GL SEARCH - END ***************
**********************************************************
-->
<!--
*****************************************************
*************** APPROVAL LINE - START ***************
*****************************************************
-->
<div class="popup_wrap2 size_mid2" id="appvLinePop" style="display: none;">
    <header class="pop_header">
        <h1><spring:message code="approveLine.title" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="approvalLine_closeBtn" onclick="javascript:fn_closePop('S')"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <section class="search_result">
            <ul class="right_btns">
                <li><p class="btn_grid"><a href="javascript:fn_appvLineGridDeleteRow()" id="lineDel_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
            </ul>

            <article class="grid_wrap" id="approveLine_grid_wrap"></article>

            <ul class="center_btns" id="requestAppvLine" style="display: none;">
                <li><p class="btn_blue2"><a href="javascript:fn_approvalSubmit('S')" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
            </ul>

            <ul class="center_btns" id="repaymentAppvLine" style="display: none;">
                <li><p class="btn_blue2"><a href="javascript:fn_submitRef()" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
            </ul>

        </section>
    </section>
</div>
<!--
***************************************************
*************** APPROVAL LINE - END ***************
***************************************************
-->