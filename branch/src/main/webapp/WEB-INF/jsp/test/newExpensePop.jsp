<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var myFileCaches = {};
var keyValueList = $.parseJSON('${taxCodeList}');

/* =========================
 * Grid Design -Start
 * =========================
 */

/* =========================
 * Claim Summary Grid - Start
 * =========================
 */
var newGridPros = {
    usePaging : true,
    pageRowCount : 20,
    headerHeight : 40,
    height : 175,
    softRemoveRowMode : false,
    rowIdField : "clmSeq",
    selectionMode : "multipleCells"
};

var newGridColumnLayout = [ {
    dataField : "invcNo",
    headerText : "Invoice No."
}, {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />',
    visible : false
}, {
    dataField : "invcDt",
    headerText : '<spring:message code="webInvoice.invoiceDate" />'
}, {
    dataField : "supplirName",
    headerText : '<spring:message code="crditCardNewReim.supplierBrName" />'
}, {
    dataField : "gstRgistNo",
    headerText : '<spring:message code="pettyCashNewExp.gstBrRgist" />'
}, {
    dataField : "invcTypeName",
    headerText : '<spring:message code="pettyCashNewExp.invcBrType" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "gstBeforAmt",
    headerText : '<spring:message code="pettyCashNewExp.amtBrBeforeGst" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "gstAmt",
    headerText : '<spring:message code="pettyCashNewExp.gst" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "taxNonClmAmt",
    headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="pettyCashNewExp.totBrAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
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
}, {
    dataField : "claimType",
    visible : false
}
];

/* =========================
 * Claim Summary Grid - End
 * =========================
 */

/* =========================
 * Hidden Claim Details Grid - Start
 * =========================
 */

 var hNewGridColumnLayout = [ {
        dataField : "clamUn",
        headerText : '<spring:message code="newWebInvoice.seq" />'
    }, {
        dataField : "expGrp",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "clmSeq",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "costCentr",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "costCentrName",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "memAccId",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "bankCode",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "bankAccNo",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "clmMonth",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "invcDt",
        headerText : '<spring:message code="webInvoice.invoiceDate" />'
    }, {
        dataField : "expType",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "expTypeName",
        headerText : '<spring:message code="pettyCashNewExp.expBrType" />',
        style : "aui-grid-user-custom-left"
    }, {
        dataField : "glAccCode",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "glAccCodeName",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "budgetCode",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "budgetCodeName",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "supplirName",
        headerText : '<spring:message code="crditCardNewReim.supplierBrName" />'
    }, {
        dataField : "taxCode",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "taxName",
        headerText : '<spring:message code="newWebInvoice.taxCode" />'
    }, {
        dataField : "gstRgistNo",
        headerText : '<spring:message code="pettyCashNewExp.gstBrRgist" />'
    }, {
        dataField : "invcType",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "invcTypeName",
        headerText : '<spring:message code="pettyCashNewExp.invcBrType" />',
        style : "aui-grid-user-custom-left"
    }, {
        dataField : "invcNo",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "supplir",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "cur",
        headerText : '<spring:message code="newWebInvoice.cur" />'
    }, {
        dataField : "gstBeforAmt",
        headerText : '<spring:message code="pettyCashNewExp.amtBrBeforeGst" />',
        style : "aui-grid-user-custom-right",
        dataType: "numeric",
        formatString : "#,##0.00"
    }, {
        dataField : "gstAmt",
        headerText : '<spring:message code="pettyCashNewExp.gst" />',
        style : "aui-grid-user-custom-right",
        dataType: "numeric",
        formatString : "#,##0.00"
    }, {
        dataField : "taxNonClmAmt",
        headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
        style : "aui-grid-user-custom-right",
        dataType: "numeric",
        formatString : "#,##0.00"
    }, {
        dataField : "totAmt",
        headerText : '<spring:message code="pettyCashNewExp.totBrAmt" />',
        style : "aui-grid-user-custom-right",
        dataType: "numeric",
        formatString : "#,##0.00",
        expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
            // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
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
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "carMilagDt",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField: "locFrom",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField: "locTo",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "carMilag",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "carMilagAmt",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "tollAmt",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "parkingAmt",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "purpose",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "expDesc",
        headerText : '<spring:message code="newWebInvoice.remark" />',
        style : "aui-grid-user-custom-left",
        width : 200
    }, {
        dataField : "yN",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }
    ];

    //그리드 속성 설정
    var hNewGridPros = {
        usePaging : true,
        pageRowCount : 20,
        headerHeight : 40,
        height : 175,
        softRemoveRowMode : false,
        rowIdField : "clmSeq",
        selectionMode : "multipleCells"
    };

/* =========================
 * Hidden Claim Details Grid - End
 * =========================
 */

/* =========================
 * Grid Design -End
 * =========================
 */

var newGridID;
var hNewGridID;
var mileageGridID;
var myGridID;

var cnfmFlg = "N";

var claimNo = "";

$(document).ready(function() {
    console.log("newExpsensePop :: ready :: start");

    // Claim Details table attachment buttons
    //setInputFile2();

    // Pop up event
    //fn_myGridSetEvent();
    fn_setEvent();

    // General Button events caller
    $("#addDtls_btn").click(fn_addDtlsPop); // To-Do :: To rename function and button
    $("#addCMDtls_btn").click(fn_addCMDtlsPop); // To-Do :: To rename function and button
    $("#cnfmClaimBtn").click(fn_confirmClaim);
    $("#expPopCloseBtn").click(fn_closeNew);
    $("#request_btn").click(fn_approveLinePop);
    $("#supplier_search_btn").click(fn_popSupplierSearchPop);
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);

    $("#bankDtlsRow").attr("hidden", true);

    $("#draftReq_Btns").attr("hidden", true);
    $("#centerBtns").attr("hidden", true);
    $("#gridTotalText").attr("hidden", true);

    if(cnfmFlg != "N") {
        $("#newCostCenter").attr("disabled", true);
        $("#newMemAccId").attr("disabled", true);
        $("#newClmMonth").attr("disabled", true);
    }

    console.log("newExpsensePop :: ready :: end");
});

/* =====================
 * Button Key Events Functions - Start
 * =====================
 */
// Normal Claim - Attachment Button
function setInputFile2() {
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_addDtlsPop() {
    console.log("fn_addDtlsPop :: start");

    console.log(claimNo);
    console.log($("hClaimNo").val());

    Common.popupDiv("/test/newDtlsPop.do", {callType:"new", claimNo: claimNo, type: "nc"}, null, true, "newStaffDtlsClaimPop");
    console.log("fn_addDtlsPop :: end");
}

function fn_addCMDtlsPop() {
    console.log("fn_addCMDtlsPop :: start");

    console.log(claimNo);
    console.log($("hClaimNo").val());

    // Check existing CM claim
    Common.ajax("GET", "/test/checkCM.do", {claimNo : claimNo}, function(result) {
        console.log(result);

        if(result.cnt == 0) {
            Common.popupDiv("/test/newDtlsPop.do", {callType:"new", claimNo: claimNo, type: "cm"}, null, true, "newStaffDtlsClaimPop");
        } else {
            Common.popupDiv("/test/newDtlsPop.do", {callType:"new", claimNo: claimNo, type: "cm", clamUn : result.clamUn}, null, true, "newStaffDtlsClaimPop");
        }

    });

    console.log("fn_addCMDtlsPop :: end");
}

function fn_confirmClaim() {
    console.log("confirmClaim :: start");
    cnfmFlg = "Y";

    if($("#newCostCenter").val() == "") {
        Common.alert("Please select cost center.");
        return false;
    }

    if($("#newMemAccId").val() == "") {
        Common.alert("Please select staff code.");
        return false;
    }

    if($("#newClmMonth").val() == "") {
        Common.alert("Please select claim month.");
        return false;
    }

    // Disable further editing of general claim details
    $("#newCostCenter").attr("disabled", true);
    $("#newMemAccId").attr("disabled", true);
    $("#newClmMonth").attr("disabled", true);

    AUIGrid.destroy("#newStaffCliam_grid_wrap");
    newGridID = AUIGrid.create("#newStaffCliam_grid_wrap", newGridColumnLayout, newGridPros);
    hNewGridID = AUIGrid.create("#hNewStaffCliam_grid_wrap", hNewGridColumnLayout, hNewGridPros);
    $("#hNewStaffCliam_grid_wrap").hide();

    // Hide/Unhide display elements upon confirm button click
    $("#cnfmClaimBtn").attr("hidden", true);
    $("#gridTotalText").attr("hidden", false);
    $("#draftReq_Btns").attr("hidden", false);
    $("#centerBtns").attr("hidden", false);
    $("#allTotAmt_text").attr("hidden", false);

    // Get claim number currently cater only staff claim (J4)
    if($("#claimType").val() == "J4") {
        Common.ajax("GET", "/test/getClaimNo.do", null, function(result) {
            console.log(result);

            claimNo = result.claimNo;
            $("hClaimNo").val(claimNo);

            var genClaimData = {
                    clmNo : result.claimNo,
                    clmType : $("#claimType").val(),
                    costCenter : $("#newCostCenter").val(),
                    clmMth : $("#newClmMonth").val(),
                    memAccId : $("#newMemAccId").val()
                }

                // Save general claim data (FCM0019M)
            Common.ajax("POST", "/test/saveClaim.do", genClaimData, function(result1) {
                console.log(result1);
            })
        })
    }

    fn_selectSummary();

    // Query DB from FCM0019M and group by FCM0020D
    console.log("confirmClaim :: end");
}

function fn_PopExpenseTypeSearchPop() {
    Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J4'}, null, true, "expenseTypeSearchPop");
}

function fn_setPopExpType() {
    console.log("Action");
    AUIGrid.setCellValue(myGridID , selectRowIdx , "budgetCode", $("#search_budgetCode").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "budgetCodeName", $("#search_budgetCodeName").val());

    AUIGrid.setCellValue(myGridID , selectRowIdx , "expType", $("#search_expType").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "expTypeName", $("#search_expTypeName").val());

    AUIGrid.setCellValue(myGridID , selectRowIdx , "glAccCode", $("#search_glAccCode").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "glAccCodeName", $("#search_glAccCodeName").val());
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
}

function fn_popSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
}

function fn_setCostCenterEvent() {
    $("#newCostCenter").change(function(){
        var costCenter = $(this).val();
        console.log(costCenter);
        if(!FormUtil.isEmpty(costCenter)){
            Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:costCenter}, function(result) {
                console.log(result);
                if(result.length > 0) {
                    var row = result[0];
                    console.log(row);
                    $("#newCostCenterText").val(row.costCenterText);
                }
            });
        }
   });
}

function fn_setSupplierEvent() {
    $("#newMemAccId").change(function(){
        var memAccId = $(this).val();
        console.log(memAccId);
        if(!FormUtil.isEmpty(memAccId)){
            Common.ajax("GET", "/eAccounting/webInvoice/selectSupplier.do?_cacheId=" + Math.random(), {memAccId:memAccId}, function(result) {
                console.log(result);
                if(result.length > 0) {
                    var row = result[0];
                    console.log(row);
                    $("#newMemAccName").val(row.memAccName);
                    $("#bankCode").val(row.bankCode);
                    $("#bankName").val(row.bankName);
                    $("#bankAccNo").val(row.bankAccNo);
                }
            });
        }
   });
}

function fn_closeNew() {
    console.log("fn_closeNew");

    if(claimNo != "") {
        fn_removeClaim(claimNo, "", "", "");
    } else {
        fn_closeNewClaimPop();
    }
}

function fn_removeClaim(clmNo, clmUn, source, clmType) {
    console.log("fn_removeClaim");

    Common.confirm("Do you wish to delete this claim?", function() {
        if(source == "VIEW") {
            $("#viewStaffDtlsClaimPop").remove();
        }

        Common.ajax("GET", "/test/removeClaim.do", {claimNo : clmNo, clamUn : clmUn, clmType : clmType}, function(result) {
            console.log(result);
        });
    });

}

function fn_approveLinePop() {
    console.log("fn_approveLinePop");

    // Check request - Request once per user per month
    Common.ajax("POST", "/eAccounting/staffClaim/checkOnceAMonth.do?_cacheId=" + Math.random(), {clmType : $("#claimType").val(), memAccId : $("#newMemAccId").val(), clmMonth : $("#newClmMonth").val()}, function(result) {
        console.log(result);
        if(result.data > 0) {
            Common.alert(result.message);
        } else {
            Common.popupDiv("/test/approveLinePop.do", {claimNo : claimNo}, null, true, "approveLineSearchPop");
        }
    });
}


/* =====================
 * Button Key Events - End
 * =====================
 */

 /* =====================
  * General Events - Start
  * =====================
  */

/* =====================
 * General Events - End
 * =====================
 */

/* ===================================================================================================
 * Car Mileage and Normal Claim Grid Events - Start
 * ===================================================================================================
 */

 function fn_setEvent() {
    $("#form_newStaffClaim :text").change(function(){
            var id = $(this).attr("id");
            console.log(id);
            if(id == "newClmMonth") {
                var clmMonth = $(this).val();
                console.log(clmMonth);
                var month = clmMonth.substring(0, 2);
                var year = clmMonth.substring(3);
                console.log("year : " + year + " month : " + month);
                clmMonth = year + month;

                var now = new Date;
                var mm = now.getMonth() + 1;
                var yyyy = now.getFullYear();
                if(mm < 10){
                    mm = "0" + mm
                }
                now = yyyy + "" + mm;
                console.log("yyyy : " + yyyy + " mm : " + mm);

                console.log(clmMonth);
                console.log(now);
                if(Number(clmMonth) > Number(now)) {
                    Common.alert('<spring:message code="pettyCashExp.onlyPastDt.msg" />');
                    $(this).val(mm + "/" + yyyy);
                }
            } else if(id == "newCostCenter") {
                if(!FormUtil.isEmpty($("#newCostCenter").val())){
                    Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:$("#newCostCenter").val()}, function(result) {
                        console.log(result);
                        if(result.length > 0) {
                            var row = result[0];
                            console.log(row);
                            $("#newCostCenterText").val(row.costCenterText);
                        }
                    });
                }
            } else if(id == "gstRgistNo") {
                if($("#invcType").val() == "F") {
                    var gstRgistNo = $(this).val();
                    console.log(gstRgistNo);
                    /*if(gstRgistNo.length != 12) {
                        Common.alert('Please insert 12 digits GST Registration No');
                        $("#gstRgistNo").val("");
                    }*/
                }
            }
       });

     // 파일 선택하기
        $('#file').on('change', function(evt) {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                console.log("파일 선택 시 취소!!");

                delete myFileCaches[selectRowIdx + 1];

                AUIGrid.updateRow(mileageGridID, {
                    atchFileName :  ""
                }, selectRowIdx);
                return;
            }

            /* if(file.size > 2048000) {
                alert("개별 파일은 2MB 를 초과해선 안됩니다.");
                return;
            } */

            console.log(recentGridItem);

            myFileCaches[selectRowIdx + 1  ] = {
                file : file,
                clamUn : recentGridItem.clamUn,
                seq : selectRowIdx + 1
            };

            if(!FormUtil.isEmpty(recentGridItem.atchFileGrpId)) {
                update.push(recentGridItem.atchFileId);
                console.log(JSON.stringify(update));
            }

            console.log("업로드 할 파일 선택 : \r\n" + file.name);
            console.log(myFileCaches);

            AUIGrid.updateRow(mileageGridID, {
                atchFileName :  file.name
            }, selectRowIdx);
        });

     $(":input:radio[name=expGrp]").on('change', function(evt) {
         fn_checkExpGrp();
     });

     AUIGrid.bind(newGridID, "cellDoubleClick", function(event) {
         console.log("newGridID cellDoubleClick clmNo : " + claimNo);
         console.log("newGridID cellDoubleClick clmUn : " + event.item.clamUn);
         console.log("newGridID cellDoubleClick claimType : " + event.item.claimType);

         Common.popupDiv("/test/viewDtlsPop.do", {claimNo: claimNo, clmUn: event.item.clamUn, claimType: event.item.claimType}, null, true, "viewStaffDtlsClaimPop");
     });
}

function fn_checkExpGrp() {
    console.log("checkExpGrp Action");
    if($(":input:radio[name=expGrp]:checked").val() == "1") {
        console.log("createMileageGrid");
        $("#noMileage").hide();
        $("#myGird_btn").hide();
        fn_destroyMyGrid();
        fn_clearData();
        $("#mileage_btn").show();
    } else {
        console.log("createMyGrid");
        $("#mileage_btn").hide();
        $("#noMileage").show();
        fn_destroyMileageGrid();
        fn_clearData();
        $("#myGird_btn").show();
    }
}

function fn_destroyMyGrid() {
    AUIGrid.destroy("#my_grid_wrap");
    myGridID = null;
}

function fn_destroyMileageGrid() {
    AUIGrid.destroy("#mileage_grid_wrap");
    mileageGridID = null;
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
    }

    $("#attachTd").html("");
    $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");
}

function fn_createMyGrid() {
    console.log("isCreated : " + AUIGrid.isCreated("#my_grid_wrap"));
    if(AUIGrid.isCreated("#my_grid_wrap")) {
        fn_destroyMyGrid();
    }

    myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);

    fn_myGridSetEvent();
}

function fn_createMileageAUIGrid() {
    console.log("isCreated : " + AUIGrid.isCreated("#mileage_grid_wrap"));
    if(AUIGrid.isCreated("#mileage_grid_wrap")) {
        fn_destroyMileageGrid();
    }

    mileageGridID = AUIGrid.create("#mileage_grid_wrap", mileageGridColumnLayout, mileageGridPros);

    fn_mileageGridSetEvent();
}

function fn_myGridSetEvent() {
    AUIGrid.bind(myGridID, "cellClick", function( event )
            {
                console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                selectRowIdx = event.rowIndex;
            });

    AUIGrid.bind(myGridID, "cellEditBegin", function( event ) {
        if($("#invcType").val() == "S") {
            if(event.dataField == "taxNonClmAmt") {
                if(event.item.taxAmt <= 30) {
                    Common.alert('<spring:message code="newWebInvoice.gstLess.msg" />');
                    AUIGrid.forceEditingComplete(myGridID, null, true);
                }
            }
        } else {
            if(event.dataField == "taxNonClmAmt") {
                Common.alert('<spring:message code="newWebInvoice.gstFullTax.msg" />');
                AUIGrid.forceEditingComplete(myGridID, null, true);
            }
        }
  });

    AUIGrid.bind(myGridID, "cellEditEnd", function( event ) {
        if(event.dataField == "gstBeforAmt" || event.dataField == "gstAmt" || event.dataField == "taxNonClmAmt") {
            var taxAmt = 0;
            var taxNonClmAmt = 0;
            if($("#invcType").val() == "S") {
                if(event.dataField == "gstBeforAmt") {
                    var taxAmtCnt = fn_getTotTaxAmt(event.rowIndex);
                    if(taxAmtCnt >= 30) {
                        taxNonClmAmt = event.item.oriTaxAmt;
                    } else {
                        if(taxAmtCnt == 0) {
                            if(event.item.oriTaxAmt > 30) {
                                taxAmt = 30;
                                taxNonClmAmt = event.item.oriTaxAmt - 30;
                            } else {
                                taxAmt = event.item.oriTaxAmt;
                            }
                        } else {
                            if((taxAmtCnt + event.item.oriTaxAmt) > 30) {
                                taxAmt = 30 - taxAmtCnt;
                                if(event.item.oriTaxAmt > taxAmt) {
                                    taxNonClmAmt = event.item.oriTaxAmt - taxAmt;
                                } else {
                                    taxNonClmAmt = taxAmt - event.item.oriTaxAmt;
                                }
                            } else {
                                taxAmt = event.item.oriTaxAmt;
                                taxNonClmAmt = 0;
                            }
                        }
                    }
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", taxAmt);
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
                }
                if(event.dataField == "gstAmt") {
                    if(event.value > 30) {
                        Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
                        AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", event.oldValue);
                    } else {
                        var taxAmtCnt = fn_getTotTaxAmt(event.rowIndex);
                        if((taxAmtCnt + event.value) > 30) {
                            Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
                            AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", event.oldValue);
                        }
                    }
                }
            } else {
                if(event.dataField == "gstBeforAmt") {
                    taxAmt = event.item.oriTaxAmt;
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", taxAmt);
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
                }
            }
        }
        if(event.dataField == "taxCode") {
            console.log("taxCode Choice Action");
            console.log(event.item.taxCode);
            var data = {
                    taxCode : event.item.taxCode
            };
            Common.ajax("GET", "/eAccounting/webInvoice/selectTaxRate.do", data, function(result) {
                console.log(result);
                AUIGrid.setCellValue(myGridID, event.rowIndex, "taxRate", result.taxRate);
                AUIGrid.setCellValue(myGridID, event.rowIndex, "taxName", result.taxName);
            });
        }
  });
}

function fn_mileageGridSetEvent() {
    AUIGrid.bind(mileageGridID, "cellEditEnd", function( event ) {
        if(event.dataField == "carMilag") {
            var result = 0;
            var oriCarMilag = event.item.carMilag;
            var reCarMilag = 0;
            var totCarMilag = fn_getTotCarMilag(event.rowIndex);
            if(totCarMilag > 600) {
                result = oriCarMilag * 0.5;
            } else {
                if(totCarMilag == 0) {
                    if((totCarMilag + oriCarMilag) > 600) {
                        reCarMilag = 600 - totCarMilag;
                        if(oriCarMilag > reCarMilag) {
                            oriCarMilag = oriCarMilag - reCarMilag;
                            result = (oriCarMilag * 0.5) + (reCarMilag * 0.7);
                        } else {
                            oriCarMilag = reCarMilag - oriCarMilag;
                            result = (oriCarMilag * 0.5) + (reCarMilag * 0.7);
                        }
                    } else {
                        result = oriCarMilag * 0.7;
                    }
                } else {
                    if((totCarMilag + oriCarMilag) > 600) {
                        reCarMilag = 600 - totCarMilag;
                        if(oriCarMilag > reCarMilag) {
                            oriCarMilag = oriCarMilag - reCarMilag;
                            result = (oriCarMilag * 0.5) + (reCarMilag * 0.7);
                        } else {
                            oriCarMilag = reCarMilag - oriCarMilag;
                            result = (oriCarMilag * 0.5) + (reCarMilag * 0.7);
                        }
                    } else {
                        result = oriCarMilag * 0.7;
                    }
                }
            }
            AUIGrid.setCellValue(mileageGridID, event.rowIndex, "carMilagAmt", result);
        }
  });
}

/* =========================================================
 * Add/Remove detail row for normal claim and car mileage claim - Start
 * =========================================================
 */
function fn_addMyGridRow() {
    if(AUIGrid.getRowCount(myGridID) > 0) {
        AUIGrid.addRow(myGridID, {clamUn:AUIGrid.getCellValue(myGridID, 0, "clamUn"),expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",gstBeforAmt:0,gstAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
    } else {
        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J4"}, function(result) {
            console.log(result);
            AUIGrid.addRow(myGridID, {clamUn:result.clamUn,expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",gstBeforAmt:0,gstAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
        });
    }
}

function fn_mileageAdd() {
    if(AUIGrid.getRowCount(mileageGridID) > 0) {
        AUIGrid.addRow(mileageGridID, {clamUn:AUIGrid.getCellValue(mileageGridID, 0, "clamUn"),expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",carMilag:0,carMilagAmt:0,tollAmt:0,parkingAmt:0}, "last");
    } else {
        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J4"}, function(result) {
            console.log(result);
            AUIGrid.addRow(mileageGridID, {clamUn:result.clamUn,expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",carMilag:0,carMilagAmt:0,tollAmt:0,parkingAmt:0}, "last");
        });
    }
}

function fn_addRow(claimNo, allTotAmt, detailData, clamUn) {

    var atchFileGrpId;

    console.log("fn_addRow Action");

    console.log(fn_checkEmpty());
    if(fn_checkEmpty()) {

        console.log($(":input:radio[name=expGrp]:checked").val());
        if($(":input:radio[name=expGrp]:checked").val() == "1") {
            console.log("Car Mileage Expense")
            // jQuery Ajax Form 사용
            /*var formData = new FormData();
            $.each(myFileCaches, function(n, v) {
                console.log("n : " + n + " v.file : " + v.file);
                formData.append(n, v.file);
                formData.append(n, v.clamUn + claimNo +v.seq);
            });*/
            console.log(clmSeq);

            var formData = Common.getFormData("form_newPopStaffClaim");

            if(clmSeq == 0) {
                console.log("Car Mileage Expense Add")
                //Common.ajaxFile("/test/cmFileUpload.do", formData, function(result) {
                Common.ajaxFile("/test/ncFileUpload.do", formData, function(result) {
                    console.log(result);

                    var gridDataList = AUIGrid.getGridData(mileageGridID);
                    for(var i = 0; i < gridDataList.length; i++) {
                        var data = {
                                costCentr : $("#newCostCenter").val(),
                                costCentrName : $("#newCostCenterText").val(),
                                memAccId : $("#newMemAccId").val(),
                                bankCode : $("#bankCode").val(),
                                bankAccNo : $("#bankAccNo").val(),
                                clmMonth : $("#newClmMonth").val(),
                                expType : "J4001",
                                expTypeName : "Car Mileage",
                                glAccCode : "61130110",
                                glAccCodeName : "TRAVELLING CLAIM - LOCAL (LAND/SEA TRANSPORT)",
                                budgetCode : "01311",
                                budgetCodeName : "Local travel - Milleage",
                                clamUn : gridDataList[i].clamUn,
                                expGrp : gridDataList[i].expGrp,
                                carMilagDt : gridDataList[i].carMilagDt,
                                locFrom : gridDataList[i].locFrom,
                                locTo : gridDataList[i].locTo,
                                cur : "MYR",
                                carMilag : gridDataList[i].carMilag,
                                carMilagAmt : gridDataList[i].carMilagAmt,
                                tollAmt : gridDataList[i].tollAmt,
                                parkingAmt : gridDataList[i].parkingAmt,
                                purpose : gridDataList[i].purpose,
                                expDesc : gridDataList[i].expDesc,
                                gstBeforAmt : gridDataList[i].carMilagAmt + gridDataList[i].tollAmt + gridDataList[i].parkingAmt,
                                gstAmt : 0,
                                taxNonClmAmt : 0
                        }
                        data.atchFileGrpId = result.data.fileGroupKey
                        console.log(data);
                        //AUIGrid.addRow(newGridID, data, "last");
                    }

                    atchFileGrpId = result.data.fileGroupKey;

                    var data1 = {
                            clmType : "CM",
                            clamUn : clamUn,
                            claimNo : claimNo,
                            invcDt : data.invcDt,
                            invcType : data.invcType,
                            invcNo : data.invcNo,
                            supplirName : data.supplirName,
                            gstRgistNo : data.gstRgistNo,
                            expDesc : data.expDesc,
                            atchFileGrpId : data.atchFileGrpId,
                            gridData : detailData,
                            allTotAmt : allTotAmt
                        }

                    console.log("data1 :: " + data1);

                    // Insert FCM0020D claim details
                    Common.ajax("POST", "/test/saveClaimDtls.do", data1, function(result1) {
                        console.log(result1);

                        AUIGrid.setGridData(newGridID, result1.summaryGrid);
                        AUIGrid.setGridData(hNewGridID, result1.hiddenGrid)

                        Common.ajax("GET", "/test/getTotal.do", {claimNo: claimNo}, function(result2) {
                            console.log(result2);

                            console.log(result2.total);

                            var allTotAmt = 0.00;

                            console.log($.number(result2.total, 2, '.', ''));

                            allTotAmt = $.number(result2.total, 2, '.', ',');

                            console.log(allTotAmt);
                            $("#allTotAmt_text").text(allTotAmt);

                            //$("#allTotAmt_text").text(result1.total);
                        });
                    });

                    $("#newStaffDtlsClaimPop").remove();

                    // Grid 초기화
                    fn_destroyMileageGrid();
                    //fn_createMileageAUIGrid();

                    //fn_selectSummary();
                    //fn_getAllTotAmt();
                });
            }
        } else {
            console.log("Normal Expense")
            var formData = Common.getFormData("form_newPopStaffClaim");
            console.log(clmSeq);
            if(clmSeq == 0) {
                console.log("Normal Expense Add")
                var data = {
                        claimNo : claimNo
                        ,costCentr : $("#newCostCenter").val()
                        ,costCentrName : $("#newCostCenterText").val()
                        ,memAccId : $("#newMemAccId").val()
                        ,bankCode : $("#bankCode").val()
                        ,bankAccNo : $("#bankAccNo").val()
                        ,clmMonth : $("#newClmMonth").val()
                        ,supplir : $("#supplir").val()
                        ,supplirName : $("#supplirName").val()
                        ,invcType : $("#invcType").val()
                        ,invcTypeName : $("#invcType option:selected").text()
                        ,invcNo : $("#invcNo").val()
                        ,invcDt : $("#invcDt").val()
                        ,gstRgistNo : $("#gstRgistNo").val()
                        ,cur : "MYR"
                        ,expDesc : $("#expDesc").val()
                        ,gridData : GridCommon.getEditData(myGridID)
                };

                Common.ajaxFile("/test/ncFileUpload.do", formData, function(result) {
                    console.log(result);

                    data.atchFileGrpId = result.data.fileGroupKey
                    console.log(data);

                    if(data.gridData.add.length > 0) { // Check if after adding "details", summarized grid will add
                        for(var i = 0; i < data.gridData.add.length; i++) {
                            data.gridData.add[i].costCentr = data.costCentr;
                            data.gridData.add[i].costCentrName = data.costCentrName;
                            data.gridData.add[i].memAccId = data.memAccId;
                            data.gridData.add[i].bankCode = data.bankCode;
                            data.gridData.add[i].bankAccNo = data.bankAccNo;
                            data.gridData.add[i].clmMonth = data.clmMonth;
                            data.gridData.add[i].supplir = data.supplir;
                            data.gridData.add[i].supplirName = data.supplirName;
                            data.gridData.add[i].invcType = data.invcType;
                            data.gridData.add[i].invcTypeName = data.invcTypeName;
                            data.gridData.add[i].invcNo = data.invcNo;
                            data.gridData.add[i].invcDt = data.invcDt;
                            data.gridData.add[i].gstRgistNo = data.gstRgistNo;
                            data.gridData.add[i].cur = data.cur;
                            data.gridData.add[i].expDesc = data.expDesc;
                            data.gridData.add[i].atchFileGrpId = data.atchFileGrpId;
                            //AUIGrid.addRow(newGridID, data.gridData.add[i], "last");
                        }
                    }

                    atchFileGrpId = result.data.fileGroupKey;

                    var data1 = {
                            clmType : "NC",
                            clamUn : clamUn,
                            claimNo : claimNo,
                            invcDt : data.invcDt,
                            invcType : data.invcType,
                            invcNo : data.invcNo,
                            supplirName : data.supplirName,
                            gstRgistNo : data.gstRgistNo,
                            expDesc : data.expDesc,
                            atchFileGrpId : data.atchFileGrpId,
                            gridData : detailData,
                            allTotAmt : allTotAmt
                        }

                    console.log("data1 :: " + data1);

                    // Insert FCM0020D claim details
                    Common.ajax("POST", "/test/saveClaimDtls.do", data1, function(result1) {
                        console.log(result);

                        AUIGrid.setGridData(newGridID, result1.summaryGrid);
                        AUIGrid.setGridData(hNewGridID, result1.hiddenGrid)

                        Common.ajax("GET", "/test/getTotal.do", {claimNo: claimNo}, function(result2) {
                            console.log(result2);

                            console.log(result2.total);

                            var allTotAmt = 0.00;

                            console.log($.number(result2.total, 2, '.', ''));

                            allTotAmt = $.number(result2.total, 2, '.', ',');

                            console.log(allTotAmt);
                            $("#allTotAmt_text").text(allTotAmt);

                            //$("#allTotAmt_text").text(result1.total);
                        });
                    });

                    $("#newStaffDtlsClaimPop").remove();

                    //fn_selectSummary();
                    //fn_getAllTotAmt();
                });
            }

            fn_clearData();
        }

    }

    //fn_selectSummary();
}

function fn_removeMyGridRow() {
    AUIGrid.removeRow(myGridID, selectRowIdx);
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newMemAccId").val())) {
        Common.alert('<spring:message code="staffClaim.staffCode.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newClmMonth").val())) {
        Common.alert('<spring:message code="pettyCashExp.clmMonth.msg" />');
        checkResult = false;
        return checkResult;
    }
    // Car Mileage Expense
    if($(":input:radio[name=expGrp]:checked").val() == "1"){
        var length = AUIGrid.getGridData(mileageGridID).length;
        if(length > 0) {
            for(var i = 0; i < length; i++) {
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "carMilagDt"))) {
                    Common.alert('<spring:message code="staffClaim.date.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "locFrom"))) {
                    Common.alert('<spring:message code="staffClaim.from.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "locTo"))) {
                    Common.alert('<spring:message code="staffClaim.to.msgstaffClaim.to.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "purpose"))) {
                    Common.alert('<spring:message code="staffClaim.purpose.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
            }
        } else {
            Common.alert('<spring:message code="staffClaim.mileage.msg" />');
            checkResult = false;
            return checkResult;
        }
    } else {
        if(FormUtil.isEmpty($("#invcDt").val())) {
            Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
            checkResult = false;
            return checkResult;
        }
        if($("#invcType").val() == "F") {
            if(FormUtil.isEmpty($("#supplirName").val())) {
                Common.alert('<spring:message code="staffClaim.supplierName.msg" />');
                checkResult = false;
                return checkResult;
            }
            if(FormUtil.isEmpty($("#invcNo").val())) {
                Common.alert('<spring:message code="webInvoice.invcNo.msg" />');
                checkResult = false;
                return checkResult;
            }
            if(FormUtil.isEmpty($("#gstRgistNo").val())) {
                Common.alert('Please enter GST Rgist No.');
                checkResult = false;
                return checkResult;
            }
            var length = AUIGrid.getGridData(myGridID).length;
            if(length > 0) {
                for(var i = 0; i < length; i++) {
                    if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "expTypeName"))) {
                        Common.alert('<spring:message code="webInvoice.expType.msg" />' + (i +1) + ".");
                        checkResult = false;
                        return checkResult;
                    }
                    if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "taxCode"))) {
                        Common.alert('<spring:message code="webInvoice.taxCode.msg" />' + (i +1) + ".");
                        checkResult = false;
                        return checkResult;
                    }
                    if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "gstBeforAmt"))) {
                        Common.alert('<spring:message code="pettyCashExp.amtBeforeGstOfLine.msg" />' + (i +1) + ".");
                        checkResult = false;
                        return checkResult;
                    }
                }
            }
        }
    }
    return checkResult;
}

function fn_getTotTaxAmt(rowIndex) {
    var taxAmtCnt = 0;
    var amtArr = AUIGrid.getColumnValues(myGridID, "gstAmt", true);
    console.log(amtArr);

    for(var i = 0; i < amtArr.length; i++) {
        taxAmtCnt += amtArr[i];
    }

    var value = AUIGrid.getCellValue(myGridID, rowIndex, "gstAmt");
    console.log(taxAmtCnt);
    console.log(value);
    taxAmtCnt -= value;
    console.log("taxAmtCnt : " + taxAmtCnt);
    return taxAmtCnt;
}

function fn_getAllTotAmt() {

    var allTotAmt = 0.00;
    var totAmtList = AUIGrid.getColumnValues (newGridID, "totAmt", true);
    console.log(totAmtList.length);

    for(var i = 0; i < totAmtList.length; i++) {
        allTotAmt += totAmtList[i];
    }

    console.log($.number(allTotAmt, 2, '.', ''));

    allTotAmt = $.number(allTotAmt, 2, '.', ',');

    console.log(allTotAmt);
    $("#allTotAmt_text").text(allTotAmt);
}

function fn_getTotCarMilag(rowIndex) {
    var totCarMilag = 0;
    // 필터링이 된 경우 필터링 된 상태의 값만 원한다면 false 지정
    var amtArr = AUIGrid.getColumnValues(mileageGridID, "carMilag", true);
    console.log(amtArr);
    for(var i = 0; i < amtArr.length; i++) {
        totCarMilag += amtArr[i];
    }
    // 0번째 행의 name 칼럼의 값 얻기
    var value = AUIGrid.getCellValue(mileageGridID, rowIndex, "carMilag");
    console.log(totCarMilag);
    console.log(value);
    totCarMilag -= value;
    console.log("totCarMilag : " + totCarMilag);
    return totCarMilag;
}

/* =========================================================
 * Add/Remove detail row for normal claim and car mileage claim - End
 * =========================================================
 */

/* ===================================================================================================
 * Car Mileage and Normal Claim Grid Events - End
 * ===================================================================================================
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
<h1><spring:message code="newStaffClaim.title" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2" id="expPopCloseBtn"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newStaffClaim">
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
<input type="hidden" id="hClaimNo" name="hClaimNo">

<ul class="right_btns mb10" id="draftReq_Btns"'>
    <!-- <li><p class="btn_blue2"><a href="#" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li> -->
    <li><p class="btn_blue2"><a href="#" id="request_btn"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>

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
    <select class="w100p" id="claimType" name="memberType">
        <option value="J1">Web Invoice</option>
        <option value="J2">Petty Cash</option>
        <option value="J3">Credit Card</option>
        <option value="J4" selected>Staff Claim</option>
        <option value="J5">SCM Activity Fund</option>
        <option value="J7">Cody Claim</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<!-- ===================================================================================================================== -->

<article class="tap_block">
<aside class="title_line">
    <h2>Claim Information</h2>
</aside>
<table class="type1"><!-- table start --><!-- FCM0019M -->
    <caption><spring:message code="webInvoice.table" /></caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
        <tr>
            <th scope="row"><spring:message code="webInvoice.costCenter" /><span class="must">*</span></th>
            <td>
                <input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr" value="${costCentr}"/>
                <a href="#" class="search_btn" id="costCenter_search_btn">
                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                </a>
            </td>
            <th scope="row"><spring:message code="staffClaim.staffCode" /><span class="must">*</span></th>
            <td>
                <input type="text" title="" placeholder="" class="" id="newMemAccId" name="memAccId" value="${code}"/>
                <a href="#" class="search_btn" id="supplier_search_btn">
                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                </a>
            </td>
        </tr>
        <tr id="bankDtlsRow">
            <th scope="row"><spring:message code="newWebInvoice.bank" /></th>
            <td>
                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName" name="bankName"/>
            </td>
            <th scope="row">
                <spring:message code="pettyCashNewCustdn.bankAccNo" />
            </th>
            <td>
                <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo"/>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="pettyCashExp.clmMonth" /><span class="must">*</span></th>
            <td>
                <input type="text" title="" placeholder="MM/YYYY" class="j_date2 w100p" id="newClmMonth" name="clmMonth"/>
            </td>
        </tr>
    </tbody>
</table><!-- table end -->
</article>

<ul class="center_btns" style="margin-top: 10px">
    <li><p class="btn_blue2" id="cnfmClaimBtn"><a href="#">Confirm</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

<!-- ===================================================================================================================== -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
    <h2 class="total_text" id="gridTotalText"><spring:message code="newWebInvoice.total" /><span id="allTotAmt_text"></span></h2>
</aside><!-- title_line end -->

<article class="grid_wrap" id="newStaffCliam_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
<article class="grid_wrap" id="hNewStaffCliam_grid_wrap" ><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<!-- ===================================================================================================================== -->

<ul class="center_btns" id="centerBtns">
    <li><p class="btn_blue2"><a href="#" id="addDtls_btn">Add Details</a></p></li>
    <li><p class="btn_blue2"><a href="#" id="addCMDtls_btn">Add Car Mileage</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->