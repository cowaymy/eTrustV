<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

.mycustom-disable-color {color : #cccccc;}

.aui-grid-body-panel table tr:hover {background:#D9E5FF; color:#000;}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {background:#D9E5FF; color:#000;}
.aui-grid-user-custom-left {text-align:left;}
.aui-grid-user-custom-right {text-align:right;}

.pop_body{max-height:535px; padding:10px; background:#fff; overflow-y:scroll;}

.popup_wrap2{max-height:525px; position:fixed; top:20px; left:50%; z-index:1001; margin-left:-500px; width:1000px; background:#fff; border:1px solid #ccc;}
.popup_wrap2:after{content:""; display:block; position:fixed; top:0; left:0; z-index:-1; width:100%; height:100%; background:rgba(0,0,0,0.6);}
.popup_wrap2.size_big2{width:1240px!important; margin-left:-620px!important;}
.pop_body2{height:505px; padding:10px; background:#fff; overflow-y:scroll;}
</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    var selectRowIdx, selectBatchId, selectAtchGrpId, selectAppvPrcssNo, selectAppvPrcssStus;
    var mode;

    var attachList = null;

    // **************
    // Grid Layout - Start
    // **************

    var myGridID, bulkInvcGrid, approveLineGridID, dtlSearchGrid, dtlExcelGrid;

    // Main Menu Grid Layout
    var columnLayout = [
        {
            dataField : "batchId",
            headerText : "Batch ID",
            cellMerge : true,
            //mergeRef : "appvPrcssNo",
            width : "10%",
            height : 30
        },{
            dataField : "batchStusId",
            headerText : "Batch Status",
            width : "15%",
            height : 30,
            visible : true,
            cellMerge : true,
            //mergeRef : "batchId",
            //mergePolicy : "restrict"
        },{
            dataField : "appvPrcssStus",
            visible : false
        },{
            dataField : "totalClaims",
            headerText : "Total Claims",
            width : "10%",
            height : 30,
            visible : true,
            cellMerge : true,
            //mergeRef : "batchId",
            //mergePolicy : "restrict"
        },{
            dataField : "amt",
            headerText : "Batch Total",
            style : "aui-grid-user-custom-right",
            width : "10%",
            visible : true,
            dataType: "numeric",
            formatString : "#,##0.00"
        },{
            dataField : "crtDt",
            headerText : "Upload Date",
            width : "10%",
            height : 30,
            visible : true,
            cellMerge : true,
            mergeRef : "batchId",
            //mergePolicy : "restrict"
        },{
            dataField : "crtUser",
            headerText : "Uploader",
            width : "17%",
            height : 30,
            visible : true,
            cellMerge : true,
            mergeRef : "batchId",
            //mergePolicy : "restrict"
        },{
            dataField : "cnfmDt",
            headerText : "Approval Date",
            width : "10%",
            height : 30,
            visible : true,
            cellMerge : true,
            mergeRef : "batchId",
            //mergePolicy : "restrict"
        },{
            dataField : "cnfmUserId",
            headerText : "Approval User",
            width : "17%",
            height : 30,
            visible : true,
            cellMerge : true,
            mergeRef : "batchId",
            //mergePolicy : "restrict"
        }, {
            dataField : "atchFileGrpId",
            visible : false,
            cellMerge : true,
            mergeRef : "batchId",
        }, {
            dataField : "appvPrcssNo",
            visible : false,
            cellMerge : true,
            mergeRef : "batchId",
        }
    ];

    // New Upload Result Layout
    var uploadItemLayout = [
        {
            dataField : "clmNo",
            headerText : "Claim No",
            width : "10%"
        }, {
            dataField : "costCenter",
            headerText : "Cost Center",
            width : "10%",
            //height : 30,
            visible : true
        },{
            dataField : "supplier",
            headerText :"Supplier",
            width : "20%",
            //height : 30 ,
            visible : true
        },{
            dataField : "invcNo",
            headerText : "Invoice No",
            width : "10%",
            //height : 30,
            visible : true
        },{
            dataField : "invcDt",
            headerText : "Invoice Date",
            width : "10%",
            //height : 30,
            visible :true
        },{
            dataField : "payDt",
            headerText : "Payment Due Date",
            width: "8%",
            //height : 30,
            visible : true
            //dataType : "date",
            //formatString : "dd/mm/yyyy"
        },{
            dataField : "billPeriodFr",
            headerText : "Billing Period From",
            width : "8%",
            //height : 30,
            visible : true,
            //dataType : "date",
            //formatString : "dd/mm/yyyy"
        },{
            dataField : "billPeriodTo",
            headerText : "Billing Period To",
            width : "8%",
            //height : 30,
            visible : true
            //dataType : "date",
            //formatString : "dd/mm/yyyy"
        },{
            dataField : "budget",
            headerText : "Budget",
            width : "20%",
            //height : 30,
            visible : true
        },{
            dataField : "glAcc",
            headerText : "GL Account",
            width : "20%",
            //height : 30,
            visible : true
        },{
            dataField : "amt",
            headerText : "Amount",
            style : "aui-grid-user-custom-right",
            width : "7%",
            //height : 30,
            visible : true,
            dataType: "numeric",
            formatString : "#,##0.00"
        },{
            dataField : "expDesc",
            headerText : "Expenses Description",
            width : "25%",
            //height : 30,
            visible : true
        },{
            dataField : "utilNo",
            headerText : "Utility No",
            width : "10%",
            //height : 30,
            visible:true
        },{
            dataField : "jpayNo",
            headerText : "JomPay No",
            width : "10%",
            //height : 30,
            visible : true
        }
    ];

    // Main Menu + Upload Result Grid Option
    var mGridoptions = {
        showStateColumn : false ,
        editable : false,
        pageRowCount : 20,
        usePaging : true,
        showPageRowSelect : true,
        showRowNumColumn : false,
        setColumnSizeList : true
    };

    var gridoptions = {
        showStateColumn : false ,
        editable : false,
        pageRowCount : 10,
        usePaging : true,
        //wordWrap : true,
        showPageRowSelect : true,
        showRowNumColumn : true,
        setColumnSizeList : true
    };

    // Approval line Grid Layout
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

    // Approval line Grid Option
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

    // Details Seach Grid Layout
    var dtlSearchColLayout = [
        {
            dataField : "batchId",
            headerText : "Batch ID",
            width : "10%"
        }, {
            dataField : "clmNo",
            headerText : "Claim No",
            width : "15%"
        }, {
            dataField : "invcNo",
            headerText : "Invoice No",
            width : "20%"
        }, {
            dataField : "supplier",
            headerText : "Supplier",
            width : "30%"
        }, {
            dataField : "costCenter",
            headerText : "Cost Center",
            width : "30%"
        }, {
            dataField : "utilNo",
            headerText : "Utility No",
            width : "15%"
        }, {
            dataField : "batchStusId",
            headerText : "Batch Status",
            width : "10%"
        }, {
            dataField : "apprPrcssDt",
            headerText : "Approval Date",
            width : "8%"
        }, {
            dataField : "crtUser",
            headerText : "Requestor",
            width : "10%"
        }, {
            dataField : "expDesc",
            headerText : "Expenses Description",
            width : "20%"
        }
    ]

    // Details Seach Grid Option
    var dtlSearchGridPros = {
        usePaging : true,
        pageRowCount : 20,
        showStateColumn : false,
        enableRestore : true,
        showRowNumColumn : false,
        selectionMode : "multipleCells",
        showRowNumColumn : true
    };

    // **************
    // Grid Layout - End
    // **************

    $(document).ready(function(){
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"appvPrcssNo", gridoptions);
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, mGridoptions);
        //bulkInvcGrid = GridCommon.createAUIGrid("#bulkInvcUp_grid_wrap", uploadItemLayout, null, gridoptions);
        approveLineGridID = GridCommon.createAUIGrid("#approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);

        if(bulkInvcGrid == null) {
            bulkInvcGrid = GridCommon.createAUIGrid("#bulkInvcUp_grid_wrap", uploadItemLayout, null, gridoptions);
        }

        //$("#lineDel_btn").click(fn_appvLineGridDeleteRow);
        //$("#submit").click(fn_newRegistMsgPop);

        AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
                console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                selectRowIdx = event.rowIndex;
        });

        fn_appvLineGridAddRow();

        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            console.log("CellDoubleClick rowIndex :: " + event.rowIndex + ", columnIndex :: " + event.columnIndex + "clicked");
            selectBatchId = event.item.batchId;
            selectAtchGrpId = event.item.atchFileGrpId;
            selectAppvPrcssNo = event.item.appvPrcssNo;
            selectAppvPrcssStus = event.item.appvPrcssStus;

            fn_newUpload('APPV');
        });

        $("#search_costCenter_btn").click(fn_costCenterSearchPop);
        $("#search_supplier_btn").click(fn_supplierSearchPop);
    });

    function fn_searchUpload() {
        if(myGridID == null) {
            //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"appvPrcssNo", gridoptions);
            myGridID = AUIGrid.create("#grid_wrap", columnLayout, mGridoptions);
        }

        Common.ajax("GET", "/eAccounting/paymentUpload/selectBulkInvcList.do",  $('#SearchForm').serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(myGridID, result);

            AUIGrid.setCellMerge(myGridID, true);
        });
    }

    function fn_resultFileUp() {
        var formData = new FormData();
        formData.append("csvFile", $("input[name=fileSelector]")[0].files[0]);
        formData.append("currSeq", $("#batchInvcSeq").val());

        //Ajax 호출
        Common.ajaxFile("/eAccounting/paymentUpload/processBulkInvoice.do", formData, function(result) {
            var message = "";

            if(result.code == 99){
                //Common.alert(result.message);
                $("#pop_up_3").show();
                $("#pop3_closeBtn").attr('class', 'btn_blue2');
                $("#popHeader3").text("File Upload Error")
                $("#errorMessage").show();
                $("#errorMessage").html(result.message);
                $("#comUpload").hide();
                $("#bulkInvcApprRegister").hide();
                $("#bulkInvcRejctRegister").hide();
            }else{

                Common.confirm(result.message, function(result2) {
                    $("#batchInvcSeq").val(result.data);

                    // Retrieve uploaded content results
                    Common.ajax("GET", "/eAccounting/paymentUpload/uploadResultList", {seq : $("#batchInvcSeq").val()}, function(result2) {
                        console.log(result2);

                        if(bulkInvcGrid == null) {
                            bulkInvcGrid = GridCommon.createAUIGrid("#bulkInvcUp_grid_wrap", uploadItemLayout, null, gridoptions);
                        }

                        AUIGrid.setGridData(bulkInvcGrid, result2.resultList);
                        AUIGrid.resize(bulkInvcGrid, 1195, 350);
                        AUIGrid.hideColumnByDataField(bulkInvcGrid, "clmNo");

                        var amtArr = AUIGrid.getColumnValues(bulkInvcGrid, "amt", true);
                        fn_sumUpload(amtArr);

                        // Display content result
                        $("#uploadContent").show();
                        $("#bulkInvcUp_grid_wrap").show();
                        $("#suppDocFile").show();
                        $("#suppDocFileSelector").show();
                        $("a#uploadBtn").text("Reupload");
                        $("#proceedBtn").show();

                        console.log("uploadResultList :: batchInvcSeq :: " + $("#batchInvcSeq").val());

                        fn_searchUpload();
                    });
                });
            }
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
            } catch (e) {
                console.log(e);
            }
            alert("Fail : " + jqXHR.responseJSON.message);
        });

    }

    function fn_newUpload(val) {
        $("#mode").val(val);

        $("#new_wrap").show();
        $("#batchInvcSeq").val("");

        if(val == "NEW") {
            $("#new_pop_header").text("New Bulk Invoices Upload");

            $("#uploadContent").hide();
            $("#suppDocFile").hide();
            $("#suppDocFileSelector").hide();
            $("#proceedBtn").hide();
            $("#viewAppvLbl").hide();
            $("#bulkAppvBtns").hide();
            $("#bulkFilesUploadRow").show();
            $("#bulkGenDtls").hide();

            AUIGrid.hideColumnByDataField(bulkInvcGrid, "clmNo");
        }

        if(val == "APPV") {
            AUIGrid.showColumnByDataField(bulkInvcGrid, "clmNo");

            $("#new_pop_header").text("View Bulk Invoices Upload");

            $("#batchFileSelector").attr('readonly');
            $("#suppDocFileSelector").attr('readonly');
            $("#newBulkBtns").hide();

            $("#bulkGenDtls").show();
            $("#newBatchId").text(selectBatchId);

            var data = {
                batchId : selectBatchId,
                atchFileGrpId : selectAtchGrpId,
                appvPrcssStus : selectAppvPrcssStus,
                appvPrcssNo : selectAppvPrcssNo
            };

            //$("#rejectRsnLbl").hide();

            if(selectAppvPrcssStus == "A" || selectAppvPrcssStus == "J") {
                $("#appvBtn").hide();
                $("#rejBtn").hide();

                if(selectAppvPrcssStus == "J") {
                    $("#rejectRsnLbl").show();
                }
            }

            Common.ajax("GET", "/eAccounting/paymentUpload/uploadResultList", data, function(result) {
                console.log(result);

                if(bulkInvcGrid == null) {
                    bulkInvcGrid = GridCommon.createAUIGrid("#bulkInvcUp_grid_wrap", uploadItemLayout, null, gridoptions);
                }
                AUIGrid.setGridData(bulkInvcGrid, result.resultList);
                AUIGrid.resize(bulkInvcGrid, 1195, 350);

                if(result.attachmentList != null) {
                    for(var i = 0; i < result.attachmentList.length; i++) {
                        var attachment = result.attachmentList[i];
                        console.log(i + " :: " + result.attachmentList[i].atchFileName);

                        if(result.attachmentList[i].atchFileName.search(".csv") != -1) {
                            //$(".input_text[name='fileSelector']").val(result.attachmentList[i].atchFileName);
                            $("#atchFileCSVId").val(result.attachmentList[i].atchFileId);
                        }

                        if((result.attachmentList[i].atchFileName.search(".zip") != -1) || (result.attachmentList[i].atchFileName.search(".rar") != -1)) {
                            //$(".input_text[name='fileSelector2']").val(result.attachmentList[i].atchFileName);
                            $("#atchFileSuppId").val(result.attachmentList[i].atchFileId);
                        }
                    }
                }

                var appvPrcssStus;
                for(var i = 0; i < result.appvPrcssStus.length; i++) {
                    if(appvPrcssStus == null) {
                        appvPrcssStus = result.appvPrcssStus[i];
                    } else {
                        appvPrcssStus += "<br />" + result.appvPrcssStus[i];
                    }
                }

                if(result.appvAct == "Y") {
                    if(selectAppvPrcssStus != "A" && selectAppvPrcssStus != "J") {
                        $("#appvBtn").show();
                        $("#rejBtn").show();
                        //$("#rejectRsnLbl").hide();
                    }
                } else {
                    $("#appvBtn").hide();
                    $("#rejBtn").hide();
                }

                if(selectAppvPrcssStus == "A" || selectAppvPrcssStus == "J") {
                    $("#finApprAct").show();

                    if(selectAppvPrcssStus == "J") {
                        $("#rejectRsnLbl").show();
                        if(result.rejctResn != "") {
                            $("#rejctRsn").text(result.rejctResn);
                        }
                    }
                }

                var amtArr = AUIGrid.getColumnValues(bulkInvcGrid, "amt", true);
                fn_sumUpload(amtArr);

                $("#uploadContent").show();
                $("#suppDocFile").show();
                $("#suppDocFileSelector").show();
                $("#proceedBtn").show();
                $("#viewAppvLbl").show();
                $("#bulkInvcUp_grid_wrap").show();
                $("#bulkFilesUploadRow").hide();

                $("#viewAppvStus").html(appvPrcssStus);
                $("#viewFinAppr").text(result.finalAppr);

            });
        }
    }

    function fn_sumUpload(arr) {
        var totalAmt = 0;
        for(var a = 0; a < arr.length; a++) {
            totalAmt += parseFloat(arr[a]);
        }
        $("#uploadAmt").text(totalAmt.toFixed(2));
    }

    function fn_closeUpload() {
        console.log("close");

        mode = $("#mode").val();

        if(mode == "NEW") {
            Common.ajax("POST", "/eAccounting/paymentUpload/clearTempResults", {seq : $("#batchInvcSeq").val()}, function(result) {
                console.log(result);
            });
        }

        AUIGrid.destroy("#bulkInvcUp_grid_wrap");
        bulkInvcGrid = null;

        $('#new_wrap').hide();
        $("#batchInvcSeq").val("");

        //$("#rejectRsnLbl").hide();
        $("#rejctRsn").text('');

        $("#uploadAmt").text('');
    }

    function fn_proceed() {
        console.log("fn_proceed");

        if($("input[name=fileSelector2]")[0].files[0] == "" || $("input[name=fileSelector2]")[0].files[0] == null) {
            Common.alert("Please attach supporting document zipped files!")
            return false;
        }

        $("#appvLinePop").show();
        AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());
    }

    function fn_submit() {
        console.log("fn_submit");

        Common.confirm("Do you wish to proceed with the uploads??", function() {
            var formData = Common.getFormData("form_newBulkInvoice");
            Common.ajaxFile("/eAccounting/paymentUpload/attachmentUpload.do", formData, function(result) {
                console.log(result);

                $("#atchFileGrpId").val(result.data.fileGroupKey);

                var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
                var data = {
                    seq : $("#batchInvcSeq").val(),
                    atchFileGrpId : $("#atchFileGrpId").val(),
                    apprLineGrid : apprGridList
                }

                Common.ajax("POST", "/eAccounting/paymentUpload/confirmBulkInvc.do", data, function(result2) {

                    console.log(result2);

                    if(result2.code == "99") {
                        Common.alert("Please select the relevant final approver.");
                    } else {
                        $("#pop_up_3").show();
                        $("#pop_up_3").attr('class', 'popup_wrap msg_box');
                        $("#comUpload").show();
                        $("#popHeader3").text("Success");
                        $("#uploadSuccMsg").text("Bulk Invoices upload completed. Batch ID : " + result2.message);
                        //$("#batchIdSucc").text("Batch ID : " + result2.message);
                        $("#errorMessage").hide();
                        $("#bulkInvcApprRegister").hide();
                        $("#bulkInvcRejctRegister").hide();

                        $("#appvLinePop").hide();
                        AUIGrid.destroy("#approveLine_grid_wrap");

                        fn_closeUpload();

                        AUIGrid.destroy("#grid_wrap");
                        myGridID = null;

                        fn_searchUpload();
                    }
                });
            });
        });
    }

    /***************************
    Detail Search/Gen Excel Functions
    ***************************/
    function fn_dtlSrch() {
        console.log("fn_dtlSrch");

        dtlSearchGrid = GridCommon.createAUIGrid("#dtlSearch_grid_wrap", dtlSearchColLayout, null, dtlSearchGridPros);
        AUIGrid.resize(dtlSearchGrid, 1195, 350);

        $("#genExcelPop").show();
        $("#dtlSearch_grid_wrap").show()
    }

    function fn_costCenterSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
    }

    function fn_setCostCenter() {
        $("#costCenter").val($("#search_costCentr").val());
        $("#costCenterText").val($("#search_costCentrName").val());
    }

    function fn_supplierSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM11"}, null, true, "supplierSearchPop");
    }

    function fn_setSupplier() {
        $("#memAccId").val($("#search_memAccId").val());
        $("#memAccName").val($("#search_memAccName").val());
    }

    function fn_dtlSearch() {
        console.log("fn_dtlSearch");

        $("#excelFlag").val("0");

        Common.ajax("GET", "/eAccounting/paymentUpload/selectBulkInvcDtlList.do",  $('#DtlSearchForm').serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(dtlSearchGrid, result);

            //AUIGrid.setCellMerge(dtlSearchGrid, true);
        });
    }

    function fn_closeDtlSearch() {
        AUIGrid.destroy("#dtlSearch_grid_wrap");
        dtlSearchGrid = null;

        $("#genExcelPop").hide();
        $("#dtlSearch_grid_wrap").hide()

        AUIGrid.destroy("#bulkInvcUp_grid_wrap");
        bulkInvcGrid = null;

        $('#new_wrap').hide();
        $("#batchInvcSeq").val("");
    }

    function fn_getAppvExcelInfo() {
        var list = AUIGrid.getColumnValues(dtlSearchGrid, "appvPrcssNo", true);
        console.log(list);

        $("#excelFlag").val("1");

        Common.ajax("GET", "/eAccounting/paymentUpload/selectBulkInvcDtlList.do",  $('#DtlSearchForm').serialize(), function(result) {
            console.log(result);

            //그리드 생성
            fn_makeGrid();

            AUIGrid.setGridData(dtlExcelGrid, result);

            GridCommon.exportTo("excel_grid_wrap", 'xlsx', "BulkDetailRaw");
            /*if(result.data.length > 0) {

                GridCommon.exportTo("excel_grid_wrap", 'xlsx', clmNo + "_" + reqstDt);
            } else {
                Common.alert('There is no data to download.');
            }*/
        });
    }

    function fn_makeGrid() {
        var excelColLayout = [
            {
                dataField : "batchId",
                headerText : "Batch ID",
                cellMerge : true
            }, {
                dataField : "clmNo",
                headerText : "Claim No",
                cellMerge : true
            }, {
                dataField : "reqstDt",
                headerText : "Request Date",
                cellMerge : true
            }, {
                dataField : "reqstUserId",
                headerText : "Request User ID",
                cellMerge : true
            }, {
                dataField : "apprPrcssDt",
                headerText : "Approval Date",
                cellMerge : true
            }, {
                dataField : "batchStusId",
                headerText : "Approval Status",
                cellMerge : true
            }, {
                dataField : "invcNo",
                headerText : "Invoice No"
            }, {
                dataField : "invcDt",
                headerText : "Invoice Date"
            }, {
                dataField : "payDt",
                headerText : "Payment Due Date"
            }, {
                dataField : "supplier",
                headerText : "Supplier Code"
            }, {
                dataField : "supplierName",
                headerText : "Supplier Name"
            }, {
                dataField : "costCenter",
                headerText : "Cost Center Code"
            }, {
                dataField : "costCenterName",
                headerText : "Cost Center Name"
            }, {
                dataField : "budgetCode",
                headerText : "Budget Code"
            }, {
                dataField : "budgetName",
                headerText : "Budget Name"
            }, {
                dataField : "glAccNo",
                headerText : "GL Account No"
            }, {
                dataField : "glAccName",
                headerText : "GL Account Name"
            }, {
                dataField : "amt",
                headerText : "Amount"
            }, {
                dataField : "utilNo",
                headerText : "Utility No"
            }, {
                dataField : "jpayNo",
                headerText : "Jompay No"
            }, {
                dataField : "expDesc",
                headerText : "Expense Description"
            }];

        var excelOptions = {
                enableCellMerge : true,
                showStateColumn:false,
                fixedColumnCount    : 6,
                showRowNumColumn    : false,
                //headerHeight : 100,
                usePaging : false
          };

        dtlExcelGrid = GridCommon.createAUIGrid("#excel_grid_wrap", excelColLayout, "", excelOptions);
    }

    /*******************
     Approval Functions
     *******************/
    function fn_atchViewDown(fileType) {

        var flId;

        if(fileType == "batch") {
            console.log("download CSV");
            flId = $("#atchFileCSVId").val();

            $("#reportFileName").val("/e-accounting/BulkInvcCsv.rpt");
            $("#viewType").val("EXCEL");
            $("#reportDownFileName").val("Bulk_Invoices_" + selectBatchId);
            $("#V_BATCHID").val(selectBatchId);

            var option = {
                isProcedure : true
            };

            fn_report(option);
        } else if(fileType == "supp") {
            console.log("download Supporting Doc Zipped");
            flId = $("#atchFileSuppId").val();

            var data = {
                    atchFileGrpId : selectAtchGrpId,
                    atchFileId : flId
            };

            Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                console.log(result);
                if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                    // TODO View
                    var fileSubPath = result.fileSubPath;
                    fileSubPath = fileSubPath.replace('\', '/'');
                    window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                } else {
                    var fileSubPath = result.fileSubPath;
                    fileSubPath = fileSubPath.replace('\', '/'');
                    window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                        + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                }
            });
        } else if(fileType == "payDoc") {
            console.log("download payment document(s)");

            $("#reportFileName").val("/e-accounting/BulkInvoice.rpt");
            $("#viewType").val("PDF");

            $("#V_BATCHID").val(selectBatchId);
            console.log("V_BATCHID :: " + $("#V_BATCHID").val());

            Common.ajax("GET", "/eAccounting/paymentUpload/getBatchClmNos.do", {batchId : selectBatchId}, function(result) {
                console.log(result);

                var clmNoList = result.resultList;

                var i = clmNoList.length - 1;

                bulkInvcInt = setInterval(function() {
                    console.log(i);

                    if(i>= 0) {
                        //var clmNo = clmNoList[i].clmNo;

                        //console.log(clmNo);

                        $("#V_CLMNO").val(clmNoList[i].clmNo);
                        $("#reportDownFileName").val(clmNoList[i].clmNo);

                        console.log("V_CLMNO :: " + $("#V_CLMNO").val());

                        var option = {
                            isProcedure : true
                        };

                        fn_report(option);

                        i--;
                    } else {
                        fn_stopBulkinvc();
                    }
                }, 10000);
            });
        }
    }

    function fn_report(option) {
        Common.report("rptForm", option);
    }

    function fn_stopBulkinvc() {
        clearInterval(bulkInvcInt);
    }

    function fn_appv(stus) {
        $("#pop_up_3").attr('class', 'popup_wrap msg_box');
        $("#pop_up_3").show();
        $("#errorMessage").hide();
        $("#comUpload").hide();

        if(stus == "A") {
            $("#popHeader3").text("Approval of Bulk Invoices Upload");
            $("#bulkInvcApprRegister").show();
            $("#bulkInvcRejctRegister").hide();
        } else if(stus = "J") {
            $("#popHeader3").text("Rejection of Bulk Invoices Upload");
            $("#bulkInvcApprRegister").hide();
            $("#bulkInvcRejctRegister").show();
        }
    }

    function fn_proceedAppv(stus) {
        var data;

        if(stus == "A") {
            data = {
                appvPrcssNo : selectAppvPrcssNo,
                appvStus : stus
            };
        } else if(stus == "J") {
            data = {
                appvPrcssNo : selectAppvPrcssNo,
                appvStus : stus,
                rejctResn : $("#rejctResn").val()
            };
        }

        Common.ajax("GET", "/eAccounting/paymentUpload/getAppvInfo.do", data, function(result) {
            console.log(result);

            if(result.code == 99) {
                Common.alert(result.message);
            } else {
                console.log("exist");
                fn_closeUpload();
                fn_searchUpload();
            }
            $("#pop_up_3").hide();
        });
    }

    /*******************
     Approval Line Functions
     *******************/
    function fn_appvLineGridAddRow() {
        AUIGrid.addRow(approveLineGridID, {}, "first");
    }

    function fn_appvLineGridDeleteRow() {
        AUIGrid.removeRow(approveLineGridID, selectRowIdx);
    }

    function fn_searchUserIdPop() {
        Common.popupDiv("/common/memberPop.do", {callPrgm:"NRIC_VISIBLE"}, null, true);
    }

    function fn_newRegistMsgPop() {
        var length = AUIGrid.getGridData(approveLineGridID).length;
        var checkMemCode = true;
        console.log(length);
        // 1개의 default Line 존재
        if(length >= 1) {
            for(var i = 0; i < length; i++) {
                if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
                    Common.alert('<spring:message code="approveLine.userId.msg" />' + (i +1) + ".");
                    checkMemCode = false;
                }
            }
        }
        console.log(checkMemCode);
        if(checkMemCode) {
            Common.popupDiv("/eAccounting/webInvoice/newRegistMsgPop.do", null, null, true, "registMsgPop");
        }
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
                    Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
                }
                else {
                    console.log(memInfo);
                    AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "memCode", memInfo.memCode);
                    AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "name", memInfo.name);
                }
            });
        } else {
            Common.alert('Not allowed to select same User ID in Approval Line');
        }
    }


</script>
</head>
<body>

<form id="rptForm">
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
    <input type="hidden" id="V_CLMNO" name="V_CLMNO" />
    <input type="hidden" id="V_BATCHID" name="V_BATCHID" />
</form>

<form id="dataForm">
    <input type="hidden" id="mode" name="mode" value="" />
    <input type="hidden" id="batchInvcSeq" name="batchInvcSeq" value="" />

    <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="" />
    <input type="hidden" id="atchFileCSVId" name="atchFileCSVId" value="" />
    <input type="hidden" id="atchFileSuppId" name="atchFileSuppId" value="" />
</form>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>E-Accounting</li>
        <li>Bulk Invoices Upload</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Bulk Invoices Upload</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newUpload('NEW')">New Upload</a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_searchUpload()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_dtlSrch()">Detail Search</a></p></li>
            <li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/eAccounting/Invoices_Batch.csv">Download Template</a></p></li>
        </ul>
    </aside><!-- title_line end -->


    <section class="search_table"><!-- search_table start -->
        <form id="SearchForm" name="SearchForm"   method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Batch ID</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Batch ID Start" id="bchIdStart" name="bchIdStart" class="w100p" /></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Batch ID End" id="bchIdEnd" name="bchIdEnd" class="w100p"  /></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row">Status</th>
                        <td>
                            <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
                                <option value="R"><spring:message code="webInvoice.select.request" /></option>
                                <option value="P"><spring:message code="webInvoice.select.progress" /></option>
                                <option value="A"><spring:message code="webInvoice.select.approved" /></option>
                                <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Upload Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Upload Start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Upload End Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
                            </div><!-- date_set end -->
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap"></div>
    </article><!-- grid_wrap end -->
</section><!-- search_result end -->

<!-------------------------------------------------------------------------------------
    POP-UP (BULK INVOICES UPLOAD)
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap size_big" id="new_wrap" style="display: none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1 id="new_pop_header">New Bulk Invoices Upload</h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#" onclick="javascript:fn_closeUpload()">CLOSE</a>
                </p>
            </li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
        <section class="search_table">
            <!-- table start -->
            <form action="#" method="post" enctype="multipart/form-data" id="form_newBulkInvoice">
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 200" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                        <tr id="bulkGenDtls" style="display : none">
                            <th scope="row" id="newBatchIdLbl">Batch ID</th>
                            <td colspan="3" id="newBatchId"></td>
                        </tr>
                        <tr id="bulkFilesUploadRow">
                            <th scope="row" id="invcFile">Batch File</th>
                            <td>
                                <!-- auto_file start -->
                                <div class="auto_file w100p" id="batchFileSelector">
                                    <input type="file" id="fileSelector" name="fileSelector" title="file add" accept=".csv" />
                                </div>
                                <!-- auto_file end -->
                            </td>
                            <th scope="row" id="suppDocFile">Payment Supporting Documents Batch</th>
                            <td>
                                <!-- auto_file start -->
                                <div class="auto_file w100p" id="suppDocFileSelector">
                                    <input type="file" id="fileSelector2" name="fileSelector2" title="file add" accept=".rar, .zip" />
                                </div>
                                <!-- auto_file end -->
                            </td>
                        </tr>
                        <tr id="viewAppvLbl">
                            <th scope="row"><spring:message code="approveView.approveStatus" /></th>
                            <td colspan="3" style="height:60px" id="viewAppvStus"></td>
                        </tr>
                        <tr id="rejectRsnLbl" style="display:none">
                            <th scope="row">Reject</th>
                            <td colspan="3" id="rejctRsn">
                        </tr>
                        <tr id="finApprAct" style="display:none">
                            <th scope="row">Final Approver</th>
                            <td colspan="3" id="viewFinAppr"></td>
                        </tr>
                    </tbody>
                </table>
            </form>
            <!-- table end -->
        </section>

        <!-- table start -->
        <!-- grid_wrap start -->
        <div id="uploadContent">
            <aside class="title_line"><!-- title_line start -->
                <header class="pop_header" id="pop_header">
                    <h1>Bulk Invoices Upload Content</h1>
                </header>
            </aside><!-- title_line end -->
            <aside class="title_line"><!-- title_line start -->
                <h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="uploadAmt"></span></h2>
            </aside><!-- title_line end -->
            <table class="type1">
                <caption>table</caption>
                <tbody>
                    <tr>
                        <td colspan='5'>
                            <div id="bulkInvcUp_grid_wrap" style="width: 100%; height: 350px; margin: 0 auto; display: none"></div>
                        </td>
                    </tr>
                </tbody>
             </table>
         <!-- table end -->
         <!-- grid_wrap end -->
        </div>
    <!-- pop_body end -->

        <ul class="center_btns" id="newBulkBtns">
            <li><p class="btn_blue2"><a href="javascript:fn_resultFileUp();" id="uploadBtn">Upload</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_proceed();" id="proceedBtn">Proceed</a></p></li>
        </ul>
        <ul class="center_btns" id="bulkAppvBtns">
            <li><p class="btn_blue2"><a href="javascript:fn_atchViewDown('batch');" id="dlCsvBtn">Download CSV</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_atchViewDown('supp');" id="dlSuppBtn">Download Supporting Doc</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_atchViewDown('payDoc');" id="dlPayBtn">Download Payment Doc</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_appv('A');" id="appvBtn">Approve</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_appv('J');" id="rejBtn">Reject</a></p></li>
        </ul>
    </section>
</div>
<!-- popup_wrap end -->

<!-------------------------------------------------------------------------------------
    POP-UP (APPROVAL LINE)
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap size_mid2" id="appvLinePop" style="display: none;">
    <header class="pop_header"><!-- pop_header start -->
        <h1><spring:message code="approveLine.title" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <section class="search_result"><!-- search_result start -->
            <ul class="right_btns">
                <li><p class="btn_grid"><a href="javascript:fn_appvLineGridDeleteRow()" id="lineDel_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
            </ul>

            <article class="grid_wrap" id="approveLine_grid_wrap"><!-- grid_wrap start -->
            </article><!-- grid_wrap end -->

            <ul class="center_btns">
                <li><p class="btn_blue2"><a href="javascript:fn_submit()" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
            </ul>

        </section><!-- search_result end -->
    </section><!-- pop_body end -->
</div><!-- popup_wrap end -->

<!-------------------------------------------------------------------------------------
    POP-UP (DETAILED UPLOAD GEN EXCEL)
-------------------------------------------------------------------------------------->
<div class="popup_wrap2 size_big2" id="genExcelPop" style="display: none;">

    <input type="hidden" id="memAccName" name="memAccName">
    <input type="hidden" id="costCenterText" name="costCenterText">

    <header class="pop_header" id="pop_header">
        <h1>Detail Gen</h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#" onclick="javascript:fn_closeDtlSearch()">CLOSE</a>
                </p>
            </li>
        </ul>
    </header>

    <section class="pop_body2">
        <form id="DtlSearchForm" name="DtlSearchForm" method="post">

            <input type="hidden" id="excelFlag" name="excelFlag">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:175px" />
                    <col style="width:*" />
                    <col style="width:175px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Claim No</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Claim No Start" id="clmNoStart" name="clmNoStart" class="w100p" /></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Claim No End" id="clmNoEnd" name="clmNoEnd" class="w100p"  /></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row">Invoice No</th>
                        <td><input type="text" id="invcNo" name ="invcNo" title="" placeholder="" class="w100p" /></td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
                        <td>
                            <input type="text" title="" placeholder="" class="" id="costCenter" name="costCenter" />
                            <a href="#" class="search_btn" id="search_costCenter_btn">
                                <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                            </a>
                        </td>
                        <th scope="row">Supplier</th>
                        <td>
                            <input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId" />
                            <a href="#" class="search_btn" id="search_supplier_btn">
                                <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Utility No</th>
                        <td><input type="text" id="utilNo" name ="utilNo" title="" placeholder="" class="w100p" /></td>
                        <th scope="row"><spring:message code="webInvoice.status" /></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
                                <option value="A"><spring:message code="webInvoice.select.approved" /></option>
                                <option value="R"><spring:message code="webInvoice.select.request" /></option>
                                <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Approval Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Approval Start Date" placeholder="DD/MM/YYYY" class="j_date" id="appStartDt" name="appStartDt"/></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Approval End Date" placeholder="DD/MM/YYYY" class="j_date" id="appEndDt" name="appEndDt"/></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row"></th>
                        <td></td>
                    </tr>
                    <tr>
                        <th scope="row">Expenses Description</th>
                        <td colspan='3'><input type="text" id="utilNo" name ="expDesc" title="" placeholder="" class="w100p" /></td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>

        <div id="dtlSrchContent">
            <table class="type1">
                <caption>table</caption>
                <tbody>
                    <tr>
                        <td colspan='5'>
                            <div id="dtlSearch_grid_wrap" style="width: 100%; height: 350px; margin: 0 auto; display: none"></div>
                        </td>
                    </tr>
                </tbody>
             </table>
        </div>

        <article class="grid_wrap" id="excel_grid_wrap"  style="display : none"><!-- grid_wrap start    style="display: none;" -->
        </article><!-- grid_wrap end -->

        <ul class="center_btns" id="newBulkBtns">
            <li><p class="btn_blue2"><a href="javascript:fn_dtlSearch();" id="dtlSearchBtn">Search</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_getAppvExcelInfo();" id="genExcelBtn">Gen Excel</a></p></li>
        </ul>

    </section>
</div>

<!-------------------------------------------------------------------------------------
    POP-UP (NEW UPLOADED BATCH ERROR)
-------------------------------------------------------------------------------------->
<div class="popup_wrap" id="pop_up_3" style="display: none;">
    <header class="pop_header">
        <h1 id="popHeader3">Error</h1>
        <ul class="right_opt">
            <li>
                <p class="pop_close" id="pop3_closeBtn">
                    <a href="#">
                        <spring:message code="newWebInvoice.btn.close" />
                    </a>
                </p>
            </li>
        </ul>
    </header>

    <section class="pop_body">
        <div id="errorMessage" style="padding:1%; display:none"></div>
        <div id="bulkInvcApprRegister" style="display : none">
            <p class="msg_txt">Are you sure you want to approve this bulk invoice batch?</p>
            <ul class="center_btns">
                <li><p class="btn_blue2"><a href="javascript:fn_proceedAppv('A')" id="confirm_btn"><spring:message code="approvalWebInvoMsg.confirm" /></a></p></li>
                <li><p class="btn_blue2"><a href="#" id="cancel_btn"><spring:message code="approvalWebInvoMsg.cancel" /></a></p></li>
            </ul>
        </div>

        <div id="bulkInvcRejctRegister" style="display : none">
            <p class="msg_txt">
                <spring:message code="rejectionWebInvoiceMsg.registMsg" />
                <br /><br />
                <textarea cols="20" rows="5" id="rejctResn"></textarea>
            </p>

            <ul class="center_btns mt20">
                <li><p class="btn_blue2"><a href="javascript:fn_proceedAppv('J')" id="rejct_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
                <li><p class="btn_blue2"><a href="#" id="cancel_btn"><spring:message code="approvalWebInvoMsg.cancel" /></a></p></li>
            </ul>
        </div>

        <div id="comUpload" style="display : none">
            <p class="msg_txt" id="uploadSuccMsg"></p>
        </div>
    </section>
</div>