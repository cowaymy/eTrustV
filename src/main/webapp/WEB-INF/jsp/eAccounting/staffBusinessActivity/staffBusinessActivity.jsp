<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    var carMilePrct, carMileRate, minAmt, minPeriod, maxPeriod1, maxPeriod2, advRetDate, advReqDate1, advReqDate2, advRetMth1, advRetMth2;
    var advType, claimNo, repayStus, appvStus, clmType, mode;
    var menu = "MAIN";
    var busActGridId, approveLineGridID;
    var selectRowIdx;
    var currList = ["MYR", "USD"];
    var newGridID;
    var update = new Array();
    var remove = new Array();
    var attachmentList = new Array();
    var gAtchFileGrpId;

    // Main Menu Grid Listing Grid -- Start
    var busActColumnLayout = [{
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
    },  {
        dataField : "payee",
        headerText : "Payee Code"
    },{
        dataField : "payeeName",
        headerText : "Payee Name"
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
        dataField : "rqstDt",
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
        dataField : "repayStus",
        visible : false
    }, {
        dataField : "repayStusDesc",
        headerText : "Settlement Status"
    },{
        dataField : "advOcc",
        headerText : "Occasion",
        visible : false
    },{
        dataField : "isResubmitAllow",
        visible : false
    }];

    var busActGridPros = {
        usePaging : true,
        pageRowCount : 40,
        selectionMode : "singleCell",
        showRowCheckColumn : false,
        showRowAllCheckBox : false
    };
    // Main Menu Advance Listing Grid -- End

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

    //Refund Grid Start
    var myColumnLayout = [ {
    dataField : "clamUn",
    editable : false,
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "clmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "budgetCode",
    headerText : '<spring:message code="expense.Activity" />',
    editable : false,
    colSpan : 2
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
            fn_budgetCodePop(rowIndex);
            }
        },
    colSpan : -1
}, {
    dataField : "budgetCodeName",
    headerText : '<spring:message code="newWebInvoice.activityName" />',
    style : "aui-grid-user-custom-left",
    editable : false
},{
    dataField : "glAccCode",
    headerText : '<spring:message code="expense.GLAccount" />',
    editable : false,
    colSpan : 2
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
            fn_glAccountSearchPop(rowIndex);
            }
        },
    colSpan : -1
}, {
    dataField : "glAccCodeName",
    headerText : '<spring:message code="newWebInvoice.glAccountName" />',
    style : "aui-grid-user-custom-left",
    editable : false
}, {
    dataField : "invcDt",
    headerText : 'Invoice Date',
    dataType : "date",
    //formatString : "dd/mm/yyyy",
    editRenderer : {
        type : "CalendarRenderer",
        formatString : "dd/mm/yyyy",
        openDirectly : true, // 에디팅 진입 시 바로 달력 열기
        onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
        showExtraDays : true, // 지난 달, 다음 달 여분의 날짜(days) 출력
        titles : [gridMsg["sys.info.grid.calendar.titles.sun"], gridMsg["sys.info.grid.calendar.titles.mon"], gridMsg["sys.info.grid.calendar.titles.tue"], gridMsg["sys.info.grid.calendar.titles.wed"], gridMsg["sys.info.grid.calendar.titles.thur"], gridMsg["sys.info.grid.calendar.titles.fri"], gridMsg["sys.info.grid.calendar.titles.sat"]],
        formatYearString : gridMsg["sys.info.grid.calendar.formatYearString"],
        formatMonthString : gridMsg["sys.info.grid.calendar.formatMonthString"],
        monthTitleString : gridMsg["sys.info.grid.calendar.monthTitleString"]
    }
}, {
    dataField : "invcNo",
    headerText : 'Invoice No.',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "supplierName",
    headerText : "Supplier Name"
}, {
    dataField : "taxName",
    headerText : '<spring:message code="newWebInvoice.taxCode" />',
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
    renderer : {
        type : "DropDownListRenderer",
        list : currList
    }
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
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.description" />',
    style : "aui-grid-user-custom-left",
    width : 100,
    editRenderer : {
        maxlength: 100
    }
}, {
    dataField : "yN",
    visible : false // Color 칼럼은 숨긴채 출력시킴
},  {
    dataField : "insufficient",
    headerText : "Insufficient",
    visible : false, // Color 칼럼은 숨긴채 출력시킴
    editable : false
}
];

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    editable : true,
    showStateColumn : true,
    softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
    softRemoveRowMode : false,
    rowIdField : "clmSeq",
    headerHeight : 40,
    //height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};
    //Refund Grid End

    $(document).ready(function () {

        //fn_setAutoFile2();

        busActGridId = AUIGrid.create("#grid_wrap", busActColumnLayout, busActGridPros);
        approveLineGridID = GridCommon.createAUIGrid("#approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);

        $("#advType").multipleSelect("setSelects", [3]);
        $("#_staffBusinessAdvBtn").click(function() {
            //Param Set
            var gridObj = AUIGrid.getSelectedItems(busActGridId);
            if(gridObj == null || gridObj.length <= 0 ){
                Common.alert("* No Record Selected. ");
                return;
            }
            var claimno = gridObj[0].item.clmNo;
            $("#_clmNo").val(claimno);

            fn_report(advType);
        });

        $("#settlementUpd_btn").click(fn_settlementConfirm); // Manual update settlement status - Finance use only
        $("#request_btn").click(fn_busActReqPop);

        $("#advList_btn").click(function() {
            //Validation
            //advType
            if(null == $("#advType").val()){
                Common.alert('*Please select the advance type');
                return;
            }
            fn_searchAdv();
        });

        $("#refund_btn").click(fn_repaymentPop);

        $("#search_costCenter_btn").click(fn_costCenterSearchPop);
        $("#search_payee_btn").click(fn_popPayeeSearchPop);

        // New Request
        $("#busActReqClose_btn").click(fn_closePop);
        $("#reqCostCenter_search_btn").click(fn_popCostCenterSearchPop);

        AUIGrid.bind(busActGridId, "cellClick", function(event) {
            console.log("advGridId cellclick :: " + event.rowIndex);
            console.log("advGridId cellclick clmNo :: " + event.item.clmNo);

            claimNo = event.item.clmNo;
            repayStus = event.item.repayStus;
            advType = event.item.advType;
            clmType = event.item.clmNo.substr(0, 2);
            appvStus = event.item.appvPrcssStus;
         });

        // Advanced Refund
        $("#advRefClose_btn").click(fn_closePop);
        $("#add_row").click(fn_addRow);
        $("#remove_row").click(fn_removeRow);
        fn_setNewGridEvent();
        fn_setKeyInDate();
        newGridID = AUIGrid.create("#refundSettement_grid_wrap", myColumnLayout, myGridPros);
        AUIGrid.resize(newGridID, 980, $(".refundSettement_grid_wrap").innerHeight());

        AUIGrid.bind(busActGridId, "cellDoubleClick", function( event ) {
            console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            console.log("CellDoubleClick clmNo : " + event.item.clmNo);
            console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
            console.log("CellDoubleClick appvPrcssStus : " + event.item.appvPrcssStus);

            if(event.item.appvPrcssStus == "T") {
                mode = "DRAFT";
                clmType = event.item.clmNo.substr(0, 2);
                appvStus = event.item.appvPrcssStus;
                console.log("draft coming in");

                if(advType == "3") {
                    $("#advOcc").val(event.item.advOcc);
                    $("#advOcc option[value=" + event.item.advOcc + "]").attr('selected', true);
                    fn_busActReqPop();
                } else if(advType == "4") {
                    fn_repaymentPop();
                }
                //fn_viewEditPop(event.item.clmNo, event.item.appvStus);
            } else {
                clmType = event.item.clmNo.substr(0, 2);
                fn_requestPop(event.item.appvPrcssNo, clmType);
            }
        });

        /* $('#trvAdvFileSelector').on('change', function(evt) {
        	var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
            	return;
            }

            var reader = new FileReader();
          //reader.readAsText(file); // 파일 내용 읽기
            reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
            reader.onload = function(event) {
                if (typeof event.target.result != "undefined") {
                    // 그리드 CSV 데이터 적용시킴
                    Common.alert("Please attach supporting document zipped files!");
                    checkRefundFlg = false;
                    return checkRefundFlg;

                } else {
                    Common.alert("<spring:message code='pay.alert.noData'/>");
                }
            };

            reader.onerror = function() {
                Common.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
            };
    }); */

        $("#editRejBtn").click(fn_editRejected);

    	// Attachment update
        $("#busActReqForm :file").change(function() {
            var div = $(this).parents(".auto_file2");
            var oriFileName = div.find(":text").val();

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    update.push(attachmentList[i].atchFileId);
                }
            }
        });

        $(".auto_file2 a:contains('Delete')").click(function() {
            var div = $(this).parents(".auto_file2");
            var oriFileName = div.find(":text").val();

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    remove.push(attachmentList[i].atchFileId);
                }
            }
        });

        $("#advRepayForm :file").change(function() {
            var div = $(this).parents(".auto_file2");
            var oriFileName = div.find(":text").val();

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    update.push(attachmentList[i].atchFileId);
                }
            }
        });

        $(".auto_file2 a:contains('Delete')").click(function() {
            var div = $(this).parents(".auto_file2");
            var oriFileName = div.find(":text").val();

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    remove.push(attachmentList[i].atchFileId);
                }
            }
        });
    });



    /************************************************
     ********** MAIN MENU SEARCH ICONS *****************
     ************************************************/
     function fn_searchAdv() {
         Common.ajax("GET", "/eAccounting/staffBusinessActivity/advanceListing.do", $("#searchForm").serialize(), function(result) {
             console.log(result);
             AUIGrid.setGridData(busActGridId, result);
         });
     }

     function fn_popPayeeSearchPop() {
         Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop", accGrp:"VM10"}, null, true, "supplierSearchPop");
     }

     function fn_setPopSupplier() {
         if(menu == "MAIN") {
             $("#memAccCode").val($("#search_memAccId").val());
         } else if(menu == "REQ") {
             $("#payeeCode").val($("#search_memAccId").val());
             $("#payeeName").val($("#search_memAccName").val());
             //$("#bankId").val($("#search_bankCode").val());
             //$("#bankName").val($("#search_bankName").val());
             $("#bankAccNo").val($("#search_bankAccNo").val());
         }
     }

     function fn_popCostCenterSearchPop() {
         Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
     }

     function fn_setPopCostCenter() {
         if(menu == "MAIN") {
             $("#listCostCenter").val($("#search_costCentr").val());
         } else if(menu == "REQ") {
             $("#costCenterCode").val($("#search_costCentr").val());
             $("#costCenterName").val($("#search_costCentrName").val());
         }
     }

     function fn_costCenterSearchPop() {
         Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
     }

     function fn_setCostCenter() {
         $("#listCostCenter").val($("#search_costCentr").val());
     }

     function fn_repaymentPop() {
    	 AUIGrid.clearGridData(newGridID); // To clear the previous data
    	 fn_setNewGridEvent();
    	 console.log("fn_repaymentPop");
         menu = "REF";

         if(claimNo == null || claimNo == "") {
             Common.alert("No advance request claim selected for repayment.");
             return false;
         }

         if(claimNo.substring(0, 1) == "R") {
             if(appvStus != "A") {
                 Common.alert("Selected Advance Request Claim No is not allowed for repayment!");
                 return false;
             }
         }

         if(claimNo.substring(0, 1) == "A") {
             if(appvStus != "T" && mode != "DRAFT") {
                 Common.alert("Selected Advance Request Claim No is not allowed for repayment!");
                 return false;
             }
         }

         if(repayStus == "3" || repayStus == "4" || repayStus == "5") {
             // Repaid
             if(repayStus == "3") {
                 Common.alert("Request is repaid.");
                 return false;
             }

             // Pending Approval
             if(repayStus == "4") {
                 Common.alert("Repayment claim pending approval.");
                 return false;
             }

             // Draft
             if(repayStus == "5") {
                 Common.alert("Drafted repayment exist!");
                 return false;
             }
         }

         $("#advRepayPop").show();
         if(advType == "3") {
             $("#repayBank").hide();
             $("#repayBank").hide();
             $("#trvAdvRepay").show();

             //$("#refAdvType").empty().append('<option selected="selected" value="4">Staff - Business Activities Settlement</option>');
             $("#refAdvType option[value=4]").attr('selected', 'selected');
             console.log('refAdvType: ' + $("#refAdvType").val());
         }

         if(clmType == "R3") { //Celeste TODO- change to R3
             $("#repayEditClmNo").hide();
             Common.ajax("GET", "/eAccounting/staffBusinessActivity/getRefundDetails.do", {claimNo : claimNo}, function(result) {
                 console.log(result);

                 $("#refClmNo").val(claimNo);
                 $("#advReqClmNo").val(claimNo);
                 $("#refKeyDate").val(fn_getToday); //Wawa take by today date
                 //$("#refKeyDate").val(result.entryDt); --
                 $("#refCostCenterCode").val(result.costCenter);
                 $("#refCreateUsername").val(result.crtUserNm);
                 $("#refPayeeCode").val(result.payeeCode);
                 $("#refPayeeName").val(result.payeeName);
                 $("#refBankName").val(result.bankName);
                 $("#refBankAccNo").val(result.bankAccNo);
                 $("#refEventStartDt").val(result.advPrdFr);
                 $("#refEventEndDt").val(result.advPrdTo);
                 //$("#trvAdvRepayAmt").val(result.totAmt.toFixed(2));
                 var refAdvAmt = result.totAmt;
                 $("#refAdvAmt").val(AUIGrid.formatNumber(result.totAmt, "#,##0.00"));
                 $("#refTotExp").val();
                 var balanceAmt = refAdvAmt - $("#refTotExp").val();
                 //$("#refBalAmt").val(AUIGrid.formatNumber(balanceAmt, "#,##0.00"));
                 balanceAmt = AUIGrid.formatNumber(balanceAmt, "#,##0.00");
                 $("#refBalAmt").val(balanceAmt);
                 $("#expTypeNm").val(result.expTypeNm);
                 $("#expType").val(result.expType);
                 $("#refAdvRepayDate").val(result.advRefdDt);
                 console.log("refAdvRepayDate: " + $("#refAdvRepayDate").val())
             });

         } else if(clmType == "A2") { //Celeste TODO- change to A2
             $("#advRepayPop").show();

             $("#refAdvType option[value=4]").attr('selected', 'selected');
             $("#refKeyDate").val(fn_getToday);
             var data = {
                     clmNo : claimNo,
                     advType : advType,
                     entryDt : $("#refKeyDate").val()
             };

             console.log(data);
             Common.ajax("GET", "/eAccounting/staffBusinessActivity/getAdvClmInfo.do", data, function(results) {

                 console.log("getAdvClmInfo.do");
                 console.log("getRefDtlsGrid.do");
                 console.log(results);

                 $("#trvAdvRepay").show();

                 $("#repayDraftClaimNo").text(claimNo);
                 $("#refClmNo").val(results.clmNo);
                 $("#advReqClmNo").val(results.advReqClmNo);
                 $("#refKeyDate").val(fn_getToday);
                 $("#refCostCenterCode").val(results.costCenter);
                 $("#costCenterName").val(results.costCenterNm);
                 $("#bankId").val(results.bankCode);
                 $("#refCreateUsername").val(results.crtUserName);
                 $("#refPayeeCode").val(results.payee);
                 $("#refPayeeName").val(results.payeeName);
                 $("#bankId").val(results.bankCode);
                 $("#refBankName").val(results.bankName);
                 $("#refBankAccNo").val(results.bankAccNo);
                 $("#refAdvAmt").val(AUIGrid.formatNumber(results.reqAdvTotAmt,"#,##0.00"));
                 $("#refAdvRepayDate").val(results.advRefdDt);
                 $("#trvBankRefNo").val(results.invcNo);
                 $("#trvRepayRem").val(results.advRem);
                 $("#expType").val(results.othExp);
                 $("#expTypeNm").val(results.othNm);

                 $("#refEventStartDt").val(results.advPrdFr);
                 $("#refEventEndDt").val(results.advPrdTo);
                 $("#refAtchFileGrpId").val(results.fileAtchGrpId);
                 $("#refTotExp").val(AUIGrid.formatNumber(results.totAmt, "#,##0.00"));
                 $("#refBankRef").val(results.advRefdRef);
                 var balanceAmt = results.reqAdvTotAmt - results.totAmt;
                 balanceAmt = AUIGrid.formatNumber(balanceAmt, "#,##0.00");
                 $("#refBalAmt").val(balanceAmt);
                 $("#refMode").empty();
                 $('#refMode').append($('<option value="CASH">Cash</option>'));
                 $('#refMode').append($('<option value="OTRX">Online</option>'));
                 $("#refMode option[value=" + results.advRefdMode + "]").attr('selected', true);
                 Common.ajax("GET", "/eAccounting/staffBusinessActivity/getRefDtlsGrid.do", data, function(results1) {
                	 AUIGrid.setGridData(newGridID, results1);
                 });

               // Request file selector
               /* Need check the Array is empty or not */
               if(!Array.isArray(results.attachmentList) || results.attachmentList.length !=0){
            	   gAtchFileGrpId = results.attachmentList[0].atchFileGrpId;
                   var atchObj = {
                           atchFileGrpId : results.attachmentList[0].atchFileGrpId,
                           atchFileId : results.attachmentList[0].atchFileId,
                           atchFileName : results.attachmentList[0].atchFileName
                   };
                   attachmentList.push(atchObj);
               }



                 $("#trvAdvFileSelector").html("");
                 $("#trvAdvFileSelector").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='1'/></div>");
                 $(".input_text").val(results.atchFileName);
                 $(".input_text").dblclick(function() {
                     var data = {
                             atchFileGrpId : results.fileAtchGrpId,
                             atchFileId : results.atchFileId
                     };

                     console.log(data);

                     Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(flResult) {
                         console.log(flResult);
                         if(flResult.fileExtsn == "jpg" || flResult.fileExtsn == "png" || flResult.fileExtsn == "gif") {
                             // TODO View
                             var fileSubPath = flResult.fileSubPath;
                             fileSubPath = fileSubPath.replace('\', '/'');
                             console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + flResult.physiclFileName);
                             window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + flResult.physiclFileName);
                         } else {
                             var fileSubPath = flResult.fileSubPath;
                             fileSubPath = fileSubPath.replace('\', '/'');
                             console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                                     + "&fileName=" + flResult.physiclFileName + "&orignlFileNm=" + flResult.atchFileName);
                             window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                                 + "&fileName=" + flResult.physiclFileName + "&orignlFileNm=" + flResult.atchFileName);
                         }
                     });
                 });
             });
         }

     }

     function fn_report(advType) {
          if (advType == '3') {
              $("#dataForm #reportFileName").val('/e-accounting/staffBusinessReq.rpt');
           }
          else{
              $("#dataForm #reportFileName").val('/e-accounting/staffBusinessRefund.rpt');
          }
           $("#dataForm #reportDownFileName").val(claimNo);

           var option = {
                   isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
           };
           Common.report("dataForm", option);
     }

     /************************************************
      ********** SEARCH / NEW REQUEST / SETTLEMENT *******
      ************************************************/
    function fn_busActReqPop() {
        console.log("fn_busActReqPop");

        advType = "3";
        $(".input_text").val("");
        /* $("#bankName").val("CIMB BANK BHD");
        $("#bankId").val("3"); */
        $("#costCenterCode").val("${costCentr}");

        $("#reqAdvType").attr("disabled", true);

        menu = "REQ";
        if(advType == "" || advType == null) {
            advType = $("#advType").val();
        }

        if(advType == "" || advType == null) {
            Common.alert("Please select an advance type to request.");
            return false;
        } else {
            if($('#advType:contains(",")').length < 0) {
                Common.alert("Please select an advance type to request.");
            }
            //var advTypeArr = advType.split(",");
            //if(advTypeArr.length() > 1) {
                //Common.alert("Please select an advance type to request.");
            //}
        }

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

        $("#busActReqPop").show();
        $("#reqEditClmNo").hide();

        // Get configuration based on advance type
        Common.ajax("GET", "/eAccounting/staffBusinessActivity/busActReqPop.do", {advType : advType}, function(results) {
            console.log("fn_busActReqPop :: Advance Request :: " + results);

            $('busActReqForm :input').val();

            $("#keyDate").val(today);
            $("#createUserId").val(results.userId);
            $("#createUsername").val(results.userName);
            $("#costCenterCode").val("${costCentr}");

            $("#payeeCode").val(results.rqstCode);
            $("#payeeName").val(results.rqstName);

            if(advType == "3") {
                console.log("Business Activity");
                $("#busActAdv").show();

                $("#reqAdvType option[value=3]").attr('selected', 'selected');

                minPeriod = parseInt(0);
                maxPeriod1 = parseInt(results.sMaxRepayDay1);
                maxPeriod2 = parseInt(results.sMaxRepayDay2);
                advRetDate = results.sTrDt;

                var rDate = results.sTrn1.split(",");

                advReqDate1 = parseInt(rDate[0]);
                advRetMth1 = parseInt(rDate[1]);

                rDate = results.sTrn2.split(",");

                advReqDate2 = parseInt(rDate[0]);
                advRetMth2 = parseInt(rDate[1]);

                var defaultAmt = 0;
                $("#reqTotAmt").val(AUIGrid.formatNumber(defaultAmt, "#,##0.00"));

            }

            if(appvStus == "T") {
                console.log("request :: appvStus :: T");

                var data = {
                        clmNo : claimNo,
                        advType : advType
                };

                console.log(data);
                Common.ajax("GET", "/eAccounting/staffBusinessActivity/getAdvClmInfo.do", data, function(results) {
                	//Common.ajax("GET", "/eAccounting/staffBusinessActivity/getRefDtlsGrid.do", data, function(results1) {
	                    console.log("getAdvClmInfo.do");
	                    //console.log("getRefDtlsGrid.do");
	                    console.log(results);

	                    $("#reqEditClmNo").show();
	                    $("#advHeader").text("Edit Staff Advance");
	                    $("#createUserId").val(results.crtUserId);
	                    $("#costCenterName").val(results.costCenterNm);
	                    $("#bankId").val(results.bankCode);
	                    $("#atchFileGrpId").val(results.fileAtchGrpId);
	                    $("#clmNo").val(claimNo);

	                    $("#reqDraftClaimNo").text(claimNo);
	                    $("#reqAdvType option[value=" + results.advType + "]").attr('selected', 'selected');
	                    $("#reqAdvType").val(results.advType);
	                    $("#reqAdvType").attr("readonly", true);
	                    $("#keyDate").attr("disabled", "disabled");
	                    $("#keyDate").val(results.entryDt);
	                    $("#costCenterCode").val(results.costCenter);
	                    $("#createUsername").val(results.crtUserName);
	                    $("#payeeCode").val(results.payee);
	                    $("#payeeName").val(results.payeeName);
	                    $("#bankName").val(results.bankName);
	                    $("#bankAccNo").val(results.bankAccNo);
	                    $("#advOcc option[value=" + results.othExp + "]").attr('selected', true);

	                    $("#eventStartDt").val(results.advPrdFr);
	                    $("#eventEndDt").val(results.advPrdTo);
	                    $("#busActReqRem").val(results.advRem);

	                    $("#reqTotAmt").val(AUIGrid.formatNumber(parseFloat(results.totAmt), "#,##0.00"));


 	                 // Request file selector
	                    gAtchFileGrpId = results.attachmentList[0].atchFileGrpId;
	                    var atchObj = {
	                            atchFileGrpId : results.attachmentList[0].atchFileGrpId,
	                            atchFileId : results.attachmentList[0].atchFileId,
	                            atchFileName : results.attachmentList[0].atchFileName
	                    };
	                    attachmentList.push(atchObj);

	                    $("#fileSelector").html("");
	                    $("#fileSelector").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='1'/></div>");
	                    //$(".input_text").val(results.atchFileName);
	                    $(".input_text").val(results.attachmentList[0].atchFileName);
	                    $(".input_text").dblclick(function() {
	                        var data = {
	                                atchFileGrpId : results.fileAtchGrpId,
	                                atchFileId : results.atchFileId
	                        };

	                        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(flResult) {
	                            console.log(flResult);
	                            if(flResult.fileExtsn == "jpg" || flResult.fileExtsn == "png" || flResult.fileExtsn == "gif") {
	                                // TODO View
	                                var fileSubPath = flResult.fileSubPath;
	                                fileSubPath = fileSubPath.replace('\', '/'');
	                                console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + flResult.physiclFileName);
	                                window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + flResult.physiclFileName);
	                            } else {
	                                var fileSubPath = flResult.fileSubPath;
	                                fileSubPath = fileSubPath.replace('\', '/'');
	                                console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
	                                        + "&fileName=" + flResult.physiclFileName + "&orignlFileNm=" + flResult.atchFileName);
	                                window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
	                                    + "&fileName=" + flResult.physiclFileName + "&orignlFileNm=" + flResult.atchFileName);
	                            }
	                        });
	                    });
	                    $("#refdDate").val(results.advRefdDt);

	                    fn_eventPeriod("F");
	                });
                //});
            }
        });
    }

    /************************************************
     ********** SEARCH / NEW REQUEST / SETTLEMENT *******
     ************************************************/

     function fn_eventPeriod(mode) {
         console.log("fn_eventPeriod :: onChange");

         //var errMsg = "Travel advance can only be applied for outstation trip with qualifying expenses of more than RM400 and stay of at least two(2) consecutive nights.";
         var errMsg = "Selected dates need to be future date";
         var arrDt, fDate, tDate, dateDiff, rDate;
         var dd, mm, yyyy;

         var cDate = new Date();

         if(mode == "F") {
             arrDt = $("#eventStartDt").val().split("/");
             fDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

             if(fDate > cDate) {
                 if($("#eventEndDt").val() == "") {
                     fDate.setDate(fDate.getDate() + minPeriod);
                     dd = fDate.getDate();
                     if(dd < 10) {
                         dd = "0" + dd;
                     }
                     mm = fDate.getMonth() + 1;
                     yyyy = fDate.getFullYear();

                     if(mm < 10) {
                         mm = "0" + mm;
                     }

                     $("#eventEndDt").val(dd + "/" + mm + "/" + yyyy);
                     $("#daysCount").val(minPeriod);
                 }
             } else {
                 Common.alert(errMsg);
                 $("#eventStartDt").val("");
                 $("#eventEndDt").val("");
                 $("#daysCount").val("");
                 $("#refdDate").val("");
                 return false;
             }
         } else if(mode == "T") {
             arrDt = $("#eventEndDt").val().split("/");
             tDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);
             var nDate = new Date();
             nDate.setDate(nDate.getDate() + minPeriod);

             if(tDate < cDate) {
                 Common.alert(errMsg);
                 $("#eventStartDt").val("");
                 $("#eventEndDt").val("");
                 $("#daysCount").val("");
                 $("#refdDate").val("");
                 return false;
             } else if (tDate <= nDate && tDate > cDate) {
                 Common.alert(errMsg);
                 $("#eventStartDt").val("");
                 $("#eventEndDt").val("");
                 $("#daysCount").val("");
                 $("#refdDate").val("");
                 return false;
             }

             if($("#eventStartDt").val() == "") {
                 tDate.setDate(tDate.getDate() - minPeriod);
                 dd = tDate.getDate();
                 if(dd < 10) {
                     dd = "0" + dd;
                 }
                 mm = tDate.getMonth() + 1;
                 yyyy = tDate.getFullYear();

                 if(mm < 10) {
                     mm = "0" + mm;
                 }

                 $("#eventStartDt").val(dd + "/" + mm + "/" + yyyy);
                 $("#daysCount").val(minPeriod);
             }
         }

         //Calculate day difference
         if($("#eventStartDt").val() != "" && $("#eventEndDt").val() != "") {
             arrDt = $("#eventStartDt").val().split("/");
             fDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

             arrDt = $("#eventEndDt").val().split("/");
             tDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

             dateDiff = ((new Date(tDate - fDate))/1000/60/60/24) + 1;
             $("#daysCount").val(dateDiff);

             /* if(dateDiff < 3) {
                 $("#eventStartDt").val("");
                 $("#eventEndDt").val("");
                 $("#daysCount").val("");
                 $("#refdDate").val("");
                 Common.alert(errMsg);
                 return false;
             } else {
                 $("#daysCount").val(dateDiff);
             } */

         }

         if($("#eventEndDt").val() != "") {
             if(dateDiff < minPeriod) {
                 Common.alert(errMsg);
                 $("#eventStartDt").val("");
                 $("#eventEndDt").val("");
                 $("#daysCount").val("");
                 $("#refdDate").val("");
                 return false;
             } else {
            	 if($("#advOcc :selected").val() == '6531' || $("#advOcc :selected").val() == '6532' || $("#advOcc :selected").val() == '6533')
            	 {
            		 arrDt = $("#eventEndDt").val().split("/");
                     if(arrDt[0] <= advReqDate1) {
                         rDate = new Date(arrDt[2], parseInt(arrDt[1]) - 1, parseInt(arrDt[0]) + maxPeriod1);
                     } else if (arrDt[0] >= advReqDate1) {
                         rDate = new Date(arrDt[2], parseInt(arrDt[1]) - 1, parseInt(arrDt[0]) + maxPeriod1);
                     }
            	 }
            	 else
            	 {
            		 arrDt = $("#eventEndDt").val().split("/");
                     if(arrDt[0] <= advReqDate1) {
                         rDate = new Date(arrDt[2], parseInt(arrDt[1]) - 1, parseInt(arrDt[0]) + maxPeriod2);
                     } else if (arrDt[0] >= advReqDate1) {
                         rDate = new Date(arrDt[2], parseInt(arrDt[1]) - 1, parseInt(arrDt[0]) + maxPeriod2);
                     }
            	 }


                 dd = rDate.getDate();
                 mm = rDate.getMonth() + 1;
                 yyyy = rDate.getFullYear();

                 if(mm < 10) {
                     mm = "0" + mm;
                 }
                 if(dd < 10) {
                     dd = "0" + dd;
                 }

                 // PERFORM CHECKING HERE BY PASSING YYYYMMDD
                 fn_checkRefdDate(yyyy, mm, dd);

                 //$("#refdDate").val(dd + "/" + mm + "/" + yyyy);
             }
         }
     }

    function fn_checkRefdDate(yyyy, mm, dd) {
        var data = {
                yyyy : yyyy,
                mm : mm,
                dd : dd
        };

        Common.ajax("GET", "/eAccounting/staffBusinessActivity/checkRefdDate.do", data, function(result) {
            console.log(result);

            if(result.code == "00") {
                var date = result.data;
                $("#refdDate").val(date.substr(-2) + "/" + date.substr(4, 2) + "/" + date.substr(0, 4));
            }
        });
    }

    // New Request Save
    function fn_newSaveReq(mode) {
        $("#reqAdvType").attr("disabled", false);

        var formData = Common.getFormData("busActReqForm");

        Common.ajaxFile("/eAccounting/staffBusinessActivity/attachmentUpload.do", formData, function(result) {
           console.log(result);

           $("#atchFileGrpId").val(result.data.fileGroupKey);
           $("#advOccDesc").val($("#advOcc option:selected").text());

           var obj = $("#busActReqForm").serializeJSON();
           console.log(obj);

           Common.ajax("POST", "/eAccounting/staffBusinessActivity/saveAdvReq.do", obj, function(result1) {
               console.log(result1);

               $("#clmNo").val(result1.data.clmNo);

               if(mode == "S") {
                   var length = AUIGrid.getGridData(approveLineGridID).length;
                   if(length >= 1) {
                       for(var i = 0; i < length; i++) {
                           if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
                               Common.alert('<spring:message code="approveLine.userId.msg" />' + (i + 1) + ".");
                               return false;
                           }
                       }
                   }

                   var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
                   var obj = $("#busActReqForm").serializeJSON();
                   obj.apprGridList = apprGridList;

                   Common.ajax("POST", "/eAccounting/webInvoice/checkFinAppr.do", obj, function(resultFinAppr) {
                       console.log(resultFinAppr);

                       if(resultFinAppr.code == "99") {
                           Common.alert("Please select relevant final approver.");
                       } else {
                           fn_submitReq();
                       }
                   });
               } else if (mode == "D" && result1.message == "success") {
                   fn_alertClmNo(result1.data.clmNo, result1.data.advType);
               } else {
                   fn_closePop();
                   fn_searchAdv();
               }
           });
        });
    }

    //Request edit save
    function fn_editSaveReq(mode) {
        console.log("fn_editSaveReq");
    	var formData = Common.getFormData("busActReqForm");
        formData.append("atchFileGrpId", $("#atchFileGrpId").val());
        formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        //formData.append("advOccDesc", $("#advOcc option:selected").text());
        console.log(formData);
        Common.ajaxFile("/eAccounting/staffBusinessActivity/attachmentUpdate.do", formData, function(result) {
           console.log(result);

           var advOccDesc = $("#advOcc option:selected").text();
           $("#advOccDesc").val(advOccDesc);
           var obj = $("#busActReqForm").serializeJSON();
           obj.reqAdvType = $("#reqAdvType").val();
           obj.advOccDesc = $("#advOccDesc").val();
           console.log("saveAdvReq in Edit Save Draft");
           console.log(obj);

           Common.ajax("POST", "/eAccounting/staffBusinessActivity/saveAdvReq.do", obj, function(result1) {

               $("#clmNo").val(result1.data.clmNo);

               if(mode == "S") {
                   var length = AUIGrid.getGridData(approveLineGridID).length;
                   if(length >= 1) {
                       for(var i = 0; i < length; i++) {
                           if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
                               Common.alert('<spring:message code="approveLine.userId.msg" />' + (i + 1) + ".");
                               return false;
                           }
                       }
                   }

                   var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
                   var obj = $("#busActReqForm").serializeJSON();
                   obj.apprGridList = apprGridList;

                   Common.ajax("POST", "/eAccounting/webInvoice/checkFinAppr.do", obj, function(resultFinAppr) {
                       console.log(resultFinAppr);

                       if(resultFinAppr.code == "99") {
                           Common.alert("Please select relevant final approver.");
                       } else {
                           fn_submitReq();
                       }
                   });
               } else {
                   fn_closePop();
                   fn_searchAdv();
               }
           });
        });
    }

    // Refund Save
     function fn_saveRefund(v) {
         console.log("fn_saveRefund");
         console.log(mode);

         if(fn_checkRefund()) {
             if(mode != "DRAFT") {
                 var formData = Common.getFormData("advRepayForm");

                 if(fn_checkSubmitRefund()){
                 Common.ajaxFile("/eAccounting/staffBusinessActivity/attachmentUpload.do", formData, function(result) {
                    console.log(result);

                    $("#refAtchFileGrpId").val(result.data.fileGroupKey);
                    $("#refAdvType_h").val($("#refAdvType").val());

                    var obj = $("#advRepayForm").serializeJSON();
                    var gridData = GridCommon.getEditData(newGridID);
                    obj.gridData = gridData;

                    console.log("gridData :" + obj);

                    Common.ajax("POST", "/eAccounting/staffBusinessActivity/saveAdvRef.do", obj, function(result1) {
                        console.log(result1);

                        $("#refClmNo").val(result1.data.clmNo);

                        if(v == "S") {
                            // Create row
                            AUIGrid.addRow(approveLineGridID, {memCode : "P0128", name : "TAN LEE JUN"}, "last");
                            fn_appvLineGridAddRow();

                            $("#requestAppvLine").hide();
                            $("#appvLinePop").show();
                            $("#repaymentAppvLine").show();
                            AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());
                        } else {
                            fn_closePop();
                            fn_searchAdv();
                        }
                    });
                 });
                 }
             } else {
                 var formData = Common.getFormData("advRepayForm");
                 if(fn_checkSubmitRefund()){
                 console.log($("#refAtchFileGrpId").val())
                 formData.append("atchFileGrpId", $("#refAtchFileGrpId").val());
                 formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                 console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                 formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
                 console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
                 Common.ajaxFile("/eAccounting/staffBusinessActivity/attachmentUpdate.do", formData, function(result) {
                     console.log(result);

                     $("#refAtchFileGrpId").val(result.data.fileGroupKey);
                     $("#refAdvType_h").val($("#refAdvType").val());
                     $("#refSubmitFlg").val("1"); // 1=draft existing
                     $("#clmNo").val();

                     var obj = $("#advRepayForm").serializeJSON();
                     var gridData = GridCommon.getEditData(newGridID);
                     obj.gridData = gridData;
                     console.log(obj);

                     Common.ajax("POST", "/eAccounting/staffBusinessActivity/saveAdvRef.do", obj, function(result1) {
                         console.log(result1);

                         $("#refClmNo").val(result1.data.clmNo);

                         if(v == "S") {
                             // Create row
                             AUIGrid.addRow(approveLineGridID, {memCode : "P0128", name : "TAN LEE JUN"}, "last");
                             fn_appvLineGridAddRow();

                             $("#requestAppvLine").hide();
                             $("#appvLinePop").show();
                             $("#repaymentAppvLine").show();
                             AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());
                         } else {
                             fn_closePop();
                             AUIGrid.clearGridData(newGridID);
                             fn_searchAdv();
                         }
                     });
                 });
             }}
         }
     }

     function fn_submitRef() {
         console.log("fn_submitRef");

         var data = $("#advRepayForm").serializeJSON();
         var apprLineGrid = AUIGrid.getOrgGridData(approveLineGridID);
         data.apprLineGrid = apprLineGrid;
         var gridData = GridCommon.getGridData(newGridID);
         data.gridData = gridData;

         console.log(data);

         Common.ajax("POST", "/eAccounting/staffBusinessActivity/submitAdvReq.do", data, function(result) {
             console.log(result);
             $("#advRepayPop").hide();
             $("#appvLinePop").hide();

             fn_closePop();
             fn_alertClmNo(result.data.clmNo, result.data.advType);
             fn_searchAdv();
         })
     }

   //Start : Check sufficient flag before settlement submission - nora
     function fn_checkSubmitRefund(){
    	 console.log("fn_checkSubmitRefund");
    	 var length = AUIGrid.getRowCount(newGridID);
    	    var suff = true;
    	 for(var i = 0; i < length; i++){
    		 console.log(AUIGrid.getCellValue(newGridID, i, "insufficient"))
    		 if(AUIGrid.getCellValue(newGridID, i, "insufficient") == 'Y'){
    			 var budgetCd = AUIGrid.getCellValue(newGridID, i, "budgetCode");
    			 var glAcc = AUIGrid.getCellValue(newGridID, i, "glAccCode");
    			 suff = false;
    			 Common.alert("Insufficient Available Budget:\n\n [Budget Code: " + budgetCd + ", GL Acc Code: " + glAcc +"]" );
    			 return suff;
    		 }
    		 continue;
    	 }
    	 return suff

     }
     //End : Check sufficient flag before settlement submission - nora

     function fn_checkRefund() {
         console.log("fn_checkRefund");
         var checkRefundFlg = true;

         // Feedback 20211227 - Settlement item 1 fix
         if(AUIGrid.getRowCount(newGridID) == 0) {
             Common.alert("No details key in. Kindly add details.");
             checkRefundFlg = false;
             return checkRefundFlg;
         }

         if($("#refMode :selected").val() == 'OTRX')
         {
             if($("#refBankRef").val() == "" || $("#refBankRef").val() == null) {
                 Common.alert("Bank Reference is required.");
                 checkRefundFlg = false;
                 return checkRefundFlg;
             }
         }

         if(FormUtil.isEmpty($("#trvRepayRem").val()) || $("#trvRepayRem").val() == null) {
             Common.alert("Remarks required.");
             checkRefundFlg = false;
             return checkRefundFlg;
         }

         //if(FormUtil.isEmpty($("#refClmNo").val())){
        	 if(mode != "DRAFT"){
        		 if($("input[name=trvAdvFileSelector]").get(0).files.length == 0) {
                     Common.alert("Please attach supporting document zipped files!")
                     checkRefundFlg = false;
                     return checkRefundFlg;
                 }
        	 }
         //}
         var newFlag = fn_saveSubmitCheckRowValidation();
         console.log(newFlag);
         if(!newFlag){
        	 checkRefundFlg = false;
         }
         return checkRefundFlg;
     }

   //Check settlement submission details row has data
     function fn_saveSubmitCheckRowValidation() {
         console.log("fn_saveSubmitCheckRowValidation");
         var checkRowFlg = true;
         var settlementRowCount = AUIGrid.getRowCount(newGridID);
         console.log(settlementRowCount);
         if(settlementRowCount > 0){
             for(var i=0; i < settlementRowCount; i++){
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "budgetCode"))){
                     Common.alert("Please choose a budget code.");
                     checkRowFlg = false;
                     return checkRowFlg;
                 }
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "glAccCode"))){
                     Common.alert("Please choose a GL code.");
                     checkRowFlg = false;
                     return checkRowFlg;
                 }
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "totAmt")) || AUIGrid.getCellValue(newGridID, i, "totAmt") <= 0){
                     Common.alert("Please enter an amount.");
                     checkRowFlg = false;
                     return checkRowFlg;
                 }
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "invcNo"))){
                     Common.alert("Please enter an Invoice Number.");
                     checkRowFlg = false;
                     return checkRowFlg;
                 }
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "invcDt"))){
                     Common.alert("Please enter a date.");
                     checkRowFlg = false;
                     return checkRowFlg;
                 }
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "expDesc"))){
                     Common.alert("Please enter a remark.");
                     checkRowFlg = false;
                     return checkRowFlg;
                 }
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "supplierName"))){
                     Common.alert("Please enter a Supplier Name.");
                     checkRowFlg = false;
                     return checkRowFlg;
                 }
               var cmpBudgetCode = AUIGrid.getCellValue(newGridID, i, "budgetCode");
                 var data = {
                         costCentr : $("#refCostCenterCode").val(),
                         budgetCode : cmpBudgetCode
                 };
                 Common.ajaxSync("GET", "/eAccounting/webInvoice/selectBudgetCodeList", data, function(result) {
                     console.log("bugetlength " + result.length);
                     if(result.length != 1) {
                         Common.alert("Budget Code not belongs to this month.");
                         checkRowFlg = false;
                         return checkRowFlg;
                     }
                 })
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

    //Empty Validation checking
    function fn_requestCheck() {
        console.log("fn_requestCheck");

        var errMsg;

        // Travel Request
        if(advType == 3) {
            //errMsg = "Travel advance can only be applied for outstation trip with qualifying expenses of more than RM400 and stay of at least two(2) consecutive nights."
            errMsg = ""

            if(FormUtil.isEmpty($("#costCenterCode").val())) {
                Common.alert("Please select the cost center.");
                return false;
            }

            if(FormUtil.isEmpty($("#payeeCode").val())) {
                Common.alert("Please select the payee's code.");
                return false;
            }

            if(FormUtil.isEmpty($("#bankAccNo").val())) {
                Common.alert("Please input bank account number.")
                return false;
            } else {
                if($("#bankAccNo").val().length < 10) {
                    Common.alert("Please input bank account number.");
                    return false;
                }
            }

            if(FormUtil.isEmpty($("#advOcc").val())){
            	Common.alert("Please select the advance occasions.");
            	return false;
            }

            if(FormUtil.isEmpty($("#eventStartDt").val()) && FormUtil.isEmpty($("#eventStartDt").val())) {
                Common.alert("Please select event period.");
                return false
            } else {
                arrDt = $("#eventStartDt").val().split("/");
                fDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

                arrDt = $("#eventEndDt").val().split("/");
                tDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

                dateDiff = ((new Date(tDate - fDate))/1000/60/60/24) + 1;

                if(dateDiff <= 0) {
                    $("#trvPeriodFr").val("");
                    $("#trvPeriodTo").val("");
                    $("#daysCount").val("");
                    $("#refdDate").val("");
                    Common.alert(errMsg);
                    return false;
                } else {
                    $("#daysCount").val(dateDiff);
                }
            }

            if(FormUtil.isEmpty($("#busActReqRem").val())) {
                Common.alert("Please enter remark.");
                return false;
            }

            if(FormUtil.isEmpty($("#reqTotAmt").val()) || $("#reqTotAmt").val() == '0.00')
            {
            	Common.alert("Please enter Total Advanced Amount.");
                return false;
            }
            else
            {
            	if(parseFloat($("#reqTotAmt").val()) < minAmt) {
                    Common.alert(errMsg);
                    return false;
                }
            }
        }
        if(advType == 4) {
        	if(FormUtil.isEmpty($("#refMode").val())) {
                Common.alert("Please select a refund mode.");
                return false;
            }

            if($("#refMode").val() == "OTRX") {
                if(FormUtil.isEmpty($("#refBankRef").val())) {
                    Common.alert("Please enter bank reference.");
                    return false;
                }
            }

            if(FormUtil.isEmpty($("#refBankRef").val())) {
                Common.alert("Please enter remark.");
                return false;
            }

        }
        if(mode != "DRAFT") {
            if($("input[name=fileSelector]")[0].files[0] == "" || $("input[name=fileSelector]")[0].files[0] == null) {
                Common.alert("Please attach supporting document zipped files!")
                return false;
            }
        }
        return true;
    }

    function fn_submitReq() {
        console.log("fn_submitReq");

        $("#reqAdvType").attr("disabled", false);

        var data = $("#busActReqForm").serializeJSON();
        var apprLineGrid = AUIGrid.getOrgGridData(approveLineGridID);
        data.apprLineGrid = apprLineGrid;

        console.log(data);

        Common.ajax("POST", "/eAccounting/staffBusinessActivity/submitAdvReq.do", data, function(result) {
            console.log(result);
            $("#appvLinePop").hide();
            $("#advReqMsgPop").hide();
            $("#acknowledgement").hide();

            //$("#advType").val('');
            fn_closePop();

            fn_alertClmNo(result.data.clmNo, result.data.advType);
            fn_searchAdv();
        });
    }

    function fn_advReqAck(mode) {
        console.log("fn_advReqAck :: " + mode);
        if(mode == "A") {
            if($("#ack1Checkbox").is(":checked") == false) {
                Common.alert("Acknowledgement required!");
                return false;
            } else {
                // Create row
                AUIGrid.addRow(approveLineGridID, {memCode : "P0128", name : "TAN LEE JUN"}, "last");
                fn_appvLineGridAddRow();

                $("#appvLinePop").show();
                $("#requestAppvLine").show();
                $("#repaymentAppvLine").hide();
                AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());
            }
        } else if(mode == "J") {
            $("#advReqMsgPop").hide();
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

    function fn_requestPop(appvPrcssNo, clmType) {
        console.log("fn_requestPop");

        var data = {
                clmType : clmType,
                appvPrcssNo : appvPrcssNo,
                type : "view"
        };

        Common.popupDiv("/eAccounting/staffBusinessActivity/staffBusActApproveViewPop.do", data, null, true, "webInvoiceAppvViewPop");
    }

    function fn_settlementConfirm() {
        console.log("fn_settlementConfirm");

        // Display Acknowledgement Pop
        $("#manualSettMsgPop").show();
        $("#acknowledgementSett").show();
    }

    function fn_settlementUpdate() {
        // Manual settlement - Finance use only
        /*
        TODO
        1. Common.ajax("POST", ) -- Update FCM0027M's ADV_REFD_NO, ADV_REFD_DT; Without inserting repayment/settlement record
        */
        console.log("fn_settlementUpdate");

        if(claimNo == "" || claimNo == null) {
            Common.alert("No advance request selected for manual settlement.");
            return false;

        } else {
            Common.ajax("POST", "/eAccounting/staffBusinessActivity/manualStaffBusinessAdvReqSettlement.do", {clmNo : claimNo}, function(result) {
                console.log(result);
                $("#manualSettMsgPop").hide();
            });
        }
    }

    /*******************************************
     ****************** COMMON ******************
     ********************************************/

     function fn_setAutoFile2() {
    	$(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a id='btnfileDel'>Delete</a></span>");
     }

     function fn_setKeyInDate() {
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
    	    $("#keyDate").val(today)
    	}

   //file Delete
     $("#btnfileDel").click(function() {
         $("#reqAttchFile").val('');
         $(".input_text").val('');
         console.log("fileDel complete.");
     });

     function fn_alertClmNo(clmNo, advType) {
         console.log("fn_alertClmNo");

         if(advType == '4'){
        	    Common.alert("Claim number : <b>" + clmNo + "</b><br>Registration of Settlement Advance has completed.");
         } else{
        	 Common.alert("Claim number : <b>" + clmNo + "</b><br>Registration of new advance request has completed.");
         }

         fn_closePop
     }

     function fn_setGridData(gridId, data) {
    	    console.log(data);
    	    AUIGrid.setGridData(gridId, data);
    	}

     function fn_closePop() {
         console.log("fn_closePop");
         appvStus = null;
         mdoe = null;
         //advType = null;

         if(menu == "REQ") {
             $("#busActReqForm").clearForm();
             $("#busActReqPop").hide();

             $("#reqAdvType").attr("disabled", false);
         } else if(menu == "REF") {
             $("#advRepayForm").clearForm();
             $("#advRepayPop").hide();

             $("#refAdvType").empty();
             $("#refAdvType").append('<option value="3">Staff Business Activity</option>');
             $("#refAdvType").append('<option selected="selected" value="4">Staff Business Activity - Repayment</option>');
         }

         if($("#appvLinePop").is(':visible')) {
             $("#appvLinePop").hide();
             $("#requestAppvLine").hide();
             $("#repaymentAppvLine").hide();
         }

         if($("#advReqMsgPop").is(':visible')) {
             $("#advReqMsgPop").hide();
             $("#ack1Checkbox").prop("checked", false);
         }

         $("#ack1Checkbox").prop("checked", false);
         AUIGrid.destroy("#approveLine_grid_wrap");
         approveLineGridID = GridCommon.createAUIGrid("#approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);

         menu = "MAIN";
         mode = "";
         claimNo = "";
     }

     function fn_addRow() {
    	   /*  if(AUIGrid.getRowCount(newGridID) > 0) {
    	        console.log("clamUn" + AUIGrid.getCellValue(newGridID, 0, "clamUn"));
    	        AUIGrid.addRow(newGridID, {clamUn:AUIGrid.getCellValue(newGridID, 0, "clamUn"),taxCode:"OP (Purchase(0%):Out of scope)",cur:AUIGrid.getCellValue(newGridID, 0, "cur"),totAmt:0}, "last");
    	    } else { */
    	        Common.ajax("GET", "/eAccounting/staffBusinessActivity/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"A2"}, function(result) {
    	            console.log(result);
    	            AUIGrid.addRow(newGridID, {clamUn:result.clamUn,taxName:"OP (Purchase(0%):Out of scope)",cur:"MYR",totAmt:0}, "last");
    	        });
    	    //}
    	}

    	function fn_removeRow() {
    	    console.log("fn_removeRow");
    		var total = Number($("#refTotExp").text().replace(',', ''));
    	    var value = fn_getValue(selectRowIdx);
    	    value = Number(value.replace(',', ''));
    	    total -= value;
    	    $("#refTotExp").text(AUIGrid.formatNumber(total, "#,##0.00"));
    	    $("#refTotExp").val(total);
    	    var balanceAmt = $("#refAdvAmt").val() - $("#refTotExp").val();
    	    balanceAmt = AUIGrid.formatNumber(balanceAmt, "#,##0.00");
            $("#refBalAmt").val(balanceAmt);
            console.log(selectRowIdx)
    	    AUIGrid.removeRow(newGridID, selectRowIdx);
    	}

    	function fn_setNewGridEvent() {
    	    AUIGrid.bind(newGridID, "cellClick", function( event )
    	            {
    	                console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
    	                selectRowIdx = event.rowIndex;
    	            });

    	            AUIGrid.bind(newGridID, "cellEditBegin", function( event ) {
    	                // return false; // false, true 반환으로 동적으로 수정, 편집 제어 가능
    	                if($("#invcType").val() == "S") {
    	                    if(event.dataField == "taxNonClmAmt") {
    	                        if(event.item.taxAmt <= 30) {
    	                            Common.alert('<spring:message code="newWebInvoice.gstLess.msg" />');
    	                            AUIGrid.forceEditingComplete(newGridID, null, true);
    	                        }
    	                    }
    	                } else {
    	                    if(event.dataField == "taxNonClmAmt") {
    	                        Common.alert('<spring:message code="newWebInvoice.gstFullTax.msg" />');
    	                        AUIGrid.forceEditingComplete(newGridID, null, true);
    	                    }
    	                }
    	          });

    	            AUIGrid.bind(newGridID, "cellEditEnd", function( event ) {
    	                if(event.dataField == "netAmt" || event.dataField == "taxAmt" || event.dataField == "taxNonClmAmt" || event.dataField == "totAmt") {
    	                    var taxAmt = 0;
    	                    var taxNonClmAmt = 0;
    	                    if($("#invcType").val() == "S") {
    	                        if(event.dataField == "netAmt") {
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
    	                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", taxAmt);
    	                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
    	                        }
    	                        if(event.dataField == "taxAmt") {
    	                            if(event.value > 30) {
    	                                Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
    	                                AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", event.oldValue);
    	                            } else {
    	                                var taxAmtCnt = fn_getTotTaxAmt(event.rowIndex);
    	                                if((taxAmtCnt + event.value) > 30) {
    	                                    Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
    	                                    AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", event.oldValue);
    	                                }
    	                            }
    	                        }
    	                    } else {
    	                        if(event.dataField == "netAmt") {
    	                            taxAmt = event.item.oriTaxAmt;
    	                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", taxAmt);
    	                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
    	                        }
    	                    }

    	                    var totAmt = fn_getTotalAmount();
    	                    $("#refTotExp").text(AUIGrid.formatNumber(totAmt, "#,##0.00"));

    	                    $("#refTotExp").val(totAmt.toFixed(2));
    	                    var refAdvAmt = $("#refAdvAmt").val();
    	                    totAmt = $("#refTotExp").val();
    	                    refAdvAmt = Number(refAdvAmt.replace(/[^0-9.-]+/g,""));
    	                    var balanceAmt = (parseFloat(refAdvAmt)-parseFloat(totAmt)).toFixed(2);
    	                    //var balanceAmt = 567.00 -1234.00;
    	                    //balanceAmt = AUIGrid.formatNumber(balanceAmt, "#,##0.00");
    	                    /* $("#refBalAmt").text(AUIGrid.formatNumber(balanceAmt, "#,##0.00")); //Celeste */
    	                    $("#refBalAmt").val(balanceAmt);

    	                    var availableVar = {
    	                        costCentr : $("#refCostCenterCode").val(),
    	                        //stYearMonth : $("#keyDate").val().substring(3),
    	                        stYearMonth : $("#refKeyDate").val().substring(3),
    	                        stBudgetCode : event.item.budgetCode,
    	                        stGlAccCode : event.item.glAccCode
    	                    }///HERE

    	                    var availableAmtCp = 0;
    	                    Common.ajax("GET", "/eAccounting/webInvoice/checkBgtPlan.do", availableVar, function(result1) {
    	                        console.log(result1.ctrlType);

    	                        if(result1.ctrlType == "Y") {
    	                            Common.ajax("GET", "/eAccounting/webInvoice/availableAmtCp.do", availableVar, function(result) {
    	                                console.log("availableAmtCp");
    	                                console.log(result.totalAvailable);

    	                                var finAvailable = (parseFloat(result.totalAvilableAdj) - parseFloat(result.totalPending) - parseFloat(result.totalUtilized)).toFixed(2);

    	                                if(parseFloat(finAvailable) < parseFloat(event.item.totAmt)) {
    	                                    console.log("else if :: result.totalAvailable < event.item.totAmt");
    	                                    Common.alert("Insufficient budget amount available for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
    	                                    console.log("Insufficient budget amount available for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
    	                                    console.log("Invc Date: " + AUIGrid.getCellValue(newGridID, event.rowIndex, "invcDt"));
    	                                    AUIGrid.setCellValue(newGridID, event.rowIndex, "netAmt", "0.00");
    	                                    AUIGrid.setCellValue(newGridID, event.rowIndex, "totAmt", "0.00");
    	                                    AUIGrid.setCellValue(newGridID, event.rowIndex, "insufficient", "");

    	                                    var totAmt = fn_getTotalAmount();
    	                                    //$("#refBalAmt").text(AUIGrid.formatNumber(totAmt, "#,##0.00"));
    	                                    console.log(totAmt);
    	                                    $("#refBalAmt").val(totAmt);
    	                                    var refAdvAmt = $("#refAdvAmt").val();
    	                                    var refTotExp = $("#refTotExp").val();
    	                                    var balanceAmt = refAdvAmt - refTotExp;
    	                                    $("#refBalAmt").val(balanceAmt.toFixed(2)); //Celeste
    	                                    //var finalRefBalAmt = AUIGrid.formatNumber($("#refBalAmt").val(), "#,##0.00");
    	                                    //$("#refBalAmt").val(finalRefBalAmt);
    	                                } else {
    	                                    var idx = AUIGrid.getRowCount(newGridID);

    	                                    console.log("Details count :: " + idx);

    	                                    for(var a = 0; a < idx; a++) {
    	                                        console.log("for a :: " + a);

    	                                        if(event.item.budgetCode == AUIGrid.getCellValue(newGridID, a, "budgetCode") && event.item.glAccCode == AUIGrid.getCellValue(newGridID, a, "glAccCode")) {
    	                                            availableAmtCp += AUIGrid.getCellValue(newGridID, a, "totAmt");
    	                                            console.log(availableAmtCp);
    	                                        }
    	                                    }

    	                                    if(result.totalAvailable < availableAmtCp) {
    	                                        console.log("else :: result.totalAvailable < availableAmtCp");

    	                                        Common.alert("Insufficient budget amount available for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
    	                                        console.log("Insufficient budget amount available for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
    	                                        AUIGrid.setCellValue(newGridID, event.rowIndex, "netAmt", "0.00");
    	                                        AUIGrid.setCellValue(newGridID, event.rowIndex, "totAmt", "0.00");
    	                                        AUIGrid.setCellValue(newGridID, event.rowIndex, "insufficient", "");

    	                                        var totAmt = fn_getTotalAmount();
    	                                        totAmt = AUIGrid.formatNumber(totAmt, "#,##0.00");
    	                                        $("#refBalAmt").val(totAmt);
    	                                        console.log(totAmt);
    	                                        $("#refBalAmt").val(totAmt);
    	                                        var refAdvAmt = $("#refAdvAmt").val();
    	                                        var refTotExp = $("#refTotExp").val();
    	                                        var balanceAmt = refAdvAmt - refTotExp;
    	                                        $("#refBalAmt").text(AUIGrid.formatNumber(balanceAmt, "#,##0.00"));
    	                                        //balanceAmt = AUIGrid.formatNumber(balanceAmt, "#,##0.00");
    	                                        //$("#refBalAmt").val(balanceAmt); //Celeste


    	                                    }else{
    	                                    	AUIGrid.setCellValue(newGridID, event.rowIndex, "insufficient", "N");
    	                                    }
    	                                }
    	                            });
    	                        }
    	                        console.log("insufficient: " + AUIGrid.getCellValue(newGridID, event.rowIndex, "insufficient"));
    	                        AUIGrid.setCellValue(newGridID, event.rowIndex, "insufficient", "N");
    	                    });
    	                }

    	                if(event.dataField == "taxCode") {
    	                    console.log("taxCode Choice Action");
    	                    console.log(event.item.taxCode);
    	                    var data = {
    	                            taxCode : event.item.taxCode
    	                    };
    	                    Common.ajax("GET", "/eAccounting/webInvoice/selectTaxRate.do", data, function(result) {
    	                        console.log(result);
    	                        AUIGrid.setCellValue(newGridID, event.rowIndex, "taxRate", result.taxRate);
    	                    });
    	                }

    	                if(event.dataField == "cur") {
    	                    console.log("currency change");

    	                    var fCur = AUIGrid.getCellValue(newGridID, 0, "cur");

    	                    if(event.rowIndex != 0) {
    	                        if(AUIGrid.getRowCount(newGridID) > 1) {
    	                            var cCur = AUIGrid.getCellValue(newGridID, event.rowIndex, "cur");

    	                            if(cCur != fCur) {
    	                                Common.alert("Different currency selected!");
    	                                AUIGrid.setCellValue(newGridID, event.rowIndex, "cur", fCur);
    	                            }
    	                        }
    	                    } else {
    	                        for(var i = 1; i < AUIGrid.getRowCount(newGridID); i++) {
    	                            AUIGrid.setCellValue(newGridID, i, "cur", fCur);
    	                        }
    	                    }
    	                }

    	                if(event.dataField == "invcNo") {
    	                    var data = {
    	                            memAccId : $("#refPayeeCode").val(),
    	                            invcNo : AUIGrid.getCellValue(newGridID, event.rowIndex, "invcNo")
    	                    }

    	                    Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(sameVenderResult) {
    	                        if(sameVenderResult.data) {
    	                            Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
    	                        }
    	                    });
    	                }

    	                if(event.dataField == "invcDt") {
    	                	var errMsg = "Selected dates cannot be future date";
    	                    var arrInvcDt, invcDtFDate, invcDtTDate, invcDtRDate;
    	                    var dd, mm, yyyy;

    	                    var invcDtCDate = new Date();

    	                    if(event.item.invcDt != null && event.item.invcDt != "")
    	                    {
    	                    	arrInvcDt = event.item.invcDt.split("/");;
    	                    	invcDtFDate = new Date(arrInvcDt[2], arrInvcDt[1]-1, arrInvcDt[0]);

    	                    	if(invcDtFDate > invcDtCDate)
    	                    	{
    	                    		AUIGrid.setCellValue(newGridID, event.rowIndex, "invcDt", "");
    	                    		Common.alert(errMsg);
    	                    	}
    	                    }
    	                }
    	          });

    	    AUIGrid.bind(newGridID, "selectionChange", function(event) {
    	        if(event.dataField == "cur") {
    	            if(AUIGrid.getRowCount(newGridID > 1)) {
    	                var fCur = AUIGrid.getCellValue(newGridID, 0, "cur");
    	                var cCur = AUIGrid.getCellValue(newGridID, event.rowIndex, "cur");

    	                if(cCur != fCur) {
    	                    Common.alert("Different currency selected.");
    	                }
    	            }
    	        }
    	    });
    	}

    	function fn_getValue(index) {
    	    return AUIGrid.getCellFormatValue(newGridID, index, "totAmt");
    	}

    	function fn_budgetCodePop(rowIndex){
    	    if(!FormUtil.isEmpty($("#refCostCenterCode").val())){
    	        var data = {
    	                rowIndex : rowIndex
    	                ,costCentr : $("#refCostCenterCode").val()
    	                ,costCentrName : $("#newCostCenterText").val()
    	        };
    	        Common.popupDiv("/eAccounting/webInvoice/budgetCodeSearchPop.do", data, null, true, "budgetCodeSearchPop");
    	    } else {
    	        Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
    	    }
    	}

    	function fn_getTotalAmount() {

    		sum = 0;

    	    var totAmtList = AUIGrid.getColumnValues(newGridID, "totAmt");
    	    if(totAmtList.length > 0) {
    	        for(var i in totAmtList) {
    	            sum += totAmtList[i];
    	        }
    	    }
    	    return sum;
    	}

    	//Gl Account Pop 호출
    	function fn_glAccountSearchPop(rowIndex){

    	    var myValue = AUIGrid.getCellValue(newGridID, rowIndex, "budgetCode");

    	    if(!FormUtil.isEmpty(myValue)){
    	        var data = {
    	                rowIndex : rowIndex
    	                ,costCentr : $("#refCostCenterCode").val()
    	                ,costCentrName : $("#newCostCenterText").val()
    	                ,budgetCode : AUIGrid.getCellValue(newGridID, rowIndex, "budgetCode")
    	                ,budgetCodeName : AUIGrid.getCellValue(newGridID, rowIndex, "budgetCodeName")
    	        };
    	           Common.popupDiv("/eAccounting/webInvoice/glAccountSearchPop.do", data, null, true, "glAccountSearchPop");
    	    } else {
    	        Common.alert('<spring:message code="webInvoice.budgetCode.msg" />');
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

     /*******************************
     Approval Line Functions -- Start
     ********************************/
     function fn_appvLineGridAddRow() {
         AUIGrid.addRow(approveLineGridID, {}, "first");
     }

     function fn_appvLineGridDeleteRow() {
         AUIGrid.removeRow(approveLineGridID, selectRowIdx);
     }

     function fn_searchUserIdPop() {
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
                     Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
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

     function fn_saveRequest(v) {
         console.log("fn_saveRequest");
         if(fn_requestCheck()) {
             if(v == "D" || v == "S") {
                 if(claimNo == null || claimNo == "") {
                     fn_newSaveReq(v);
                 } else {
                    fn_editSaveReq(v)
                 }
             } else if(v == "A") {
                 $("#advReqMsgPop").show();
                 $("#acknowledgement").show();
             }
         }
     }

   //Edit Rejected
     function fn_editRejected() {
     console.log("fn_editRejected");

     var gridObj = AUIGrid.getSelectedItems(busActGridId);
     var list = AUIGrid.getCheckedRowItems(busActGridId);

     if(gridObj != "" || list != "") {
         var status;
         var selClmNo;
         var isEditRejectedAllow;

         if(list.length > 1) {
             Common.alert("* Only 1 record is permitted. ");
             return;
         }

         if(gridObj.length > 0) {
             status = gridObj[0].item.appvPrcssStus;
             selClmNo = gridObj[0].item.clmNo;
             isEditRejectedAllow = gridObj[0].item.isResubmitAllow;
         } else {
             status = list[0].item.appvPrcssStus;
             selClmNo = list[0].item.clmNo;
             isEditRejectedAllow = list[0].item.isResubmitAllow;
         }

         if(isEditRejectedAllow == "0"){
             Common.alert("* You are not allow to perform Edit Rejected on the selected claim. Please reselect. ");
         }else{
        	 if(status == "J") {
                 Common.ajax("POST", "/eAccounting/staffBusinessActivity/editRejected.do", {clmNo : selClmNo}, function(result1) {
                     console.log(result1);

                     Common.alert("New claim number : " + result1.data.newClmNo);
                     fn_searchAdv();
                 });
             } else {
                 Common.alert("Only rejected claims are allowed to edit.");
             }
         }

     } else {
         Common.alert("* No Value Selected. ");
         return;
     }
 }

</script>

<!-- ************************************************************* STYLE ************************************************************* -->

<style>
.popup_wrap2 {
	height: 625px;
	max-height: 625px;
	position: fixed;
	top: 20px;
	left: 50%;
	z-index: 1001;
	margin-left: -500px;
	width: 1000px;
	background: #fff;
	border: 1px solid #ccc;
}

.popup_wrap2:after {
	content: "";
	display: block;
	position: fixed;
	top: 0;
	left: 0;
	z-index: -1;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.6);
}

.pop_body2 {
	height: 620px;
	padding: 10px;
	background: #fff;
	overflow-y: scroll;
}

.tap_block {
	margin-top: 10px;
	margin-bottom: 10px;
	border: 1px solid #ccc;
	padding: 10px;
	border-radius: 3px;
}

.aui-grid-user-custom-right {
	text-align: right;
}
</style>

<!-- ************************************************************* LAYOUT ************************************************************* -->

<!-- ************************************************************************************************************************************* -->
<!-- ************************************************************* MAIN MENU ************************************************************* -->
<!-- ************************************************************************************************************************************* -->

<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value=" " />
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

    <input type="hidden" id="_clmNo" name="V_CLMNO" />
</form>

<section id="content">
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>e-Accounting</li>
		<li>Staff - Business Activity</li>
	</ul>

	<aside class="title_line">
		<p class="fav">
			<a href="#" class="click_add_on"><spring:message
					code="webInvoice.fav" /></a>
		</p>
		<h2>Staff - Business Activity</h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <li><p class="btn_blue"><a href="#" id="settlementUpd_btn">Manual Settlement</a></p></li>
            </c:if>
			<li><p class="btn_blue"><a href="#" id="request_btn">New Request</a></p></li>
			<li><p class="btn_blue"><a href="#" id="refund_btn">Settlement</a></p></li>
			<li><p class="btn_blue"><a href="#" id="advList_btn"><span class="search"></span>Search</a></p></li>
		</ul>
	</aside>


	<section class="search_table">
		<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" id="memAccName" name="memAccName"> <input
				type="hidden" id="costCenterText" name="costCenterText">

			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 200px" />
					<col style="width: *" />
					<col style="width: 200px" />
					<col style="width: *" />
				</colgroup>

				<tbody>
					<tr>
						<th scope="row">Advance Type</th>
						<td><select class="multy_select w100p" multiple="multiple"
							id="advType" name="advType">
								<option value="3">Staff Business Activity</option>
								<option value="4">Staff Business Activity - Settlement</option>

						</select></td>
						<th scope="row">Cost Center Code</th>
						<td><input type="text" title="" placeholder="" class=""
							style="width: 200px" id="listCostCenter" name="listCostCenter" />
							<a href="#" class="search_btn" id="search_costCenter_btn"><img
								src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
								alt="search" /></a></td>
					</tr>
					<tr>
						<th scope="row">Member Code</th>
						<td><input type="text" title="" placeholder="" class=""
							style="width: 200px" id="memAccCode" name="memAccCode" /> <a
							href="#" class="search_btn" id="search_payee_btn"><img
								src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
								alt="search" /></a></td>
						<th scope="row">Approval Status</th>
						<td><select class="multy_select w100p" multiple="multiple"
							id="appvPrcssStus" name="appvPrcssStus">
								<option value="T"><spring:message
										code="webInvoice.select.tempSave" /></option>
								<option value="R"><spring:message
										code="webInvoice.select.request" /></option>
								<option value="P"><spring:message
										code="webInvoice.select.progress" /></option>
								<option value="A"><spring:message
										code="webInvoice.select.approved" /></option>
								<option value="J"><spring:message
										code="pettyCashRqst.rejected" /></option>
						</select></td>
					</tr>
					<tr>
						<th scope="row">Claim No</th>
						<td>
							<div class="date_set w100p">
								<p>
									<input type="text" title="Claim No Start" id="clmNoStart"
										name="clmNoStart" class="w100p" />
								</p>
								<span><spring:message code="webInvoice.to" /></span>
								<p>
									<input type="text" title="Claim No End" id="clmNoEnd"
										name="clmNoEnd" class="w100p" />
								</p>
							</div>
						</td>
						<th scope="row">Repayment Status</th>
						<td><select class="multy_select w100p" multiple="multiple"
							id="refundStus" name="refundStus">
								<option value="1">Not due</option>
								<option value="2">Due but not repaid yet</option>
								<option value="3">Repaid</option>
								<option value="4">Pending Approval</option>
								<option value="5">Draft</option>
						</select></td>
					</tr>
					<tr>
						<th scope="row">Request Date</th>
						<td>
							<div class="date_set w100p">
								<p>
									<input type="text" title="Request Start Date"
										placeholder="DD/MM/YYYY" class="j_date" id="reqStartDt"
										name="reqStartDt" />
								</p>
								<span><spring:message code="webInvoice.to" /></span>
								<p>
									<input type="text" title="Request End Date"
										placeholder="DD/MM/YYYY" class="j_date" id="reqEndDt"
										name="reqEndDt" />
								</p>
							</div>
						</td>
						<th scope="row">Approval Date</th>
						<td>
							<div class="date_set w100p">
								<p>
									<input type="text" title="Approval Start Date"
										placeholder="DD/MM/YYYY" class="j_date" id="appStartDt"
										name="appStartDt" />
								</p>
								<span><spring:message code="webInvoice.to" /></span>
								<p>
									<input type="text" title="Approval End Date"
										placeholder="DD/MM/YYYY" class="j_date" id="appEndDt"
										name="appEndDt" />
								</p>
							</div>
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
                <li><p class="link_btn"><a href="#" id="_staffBusinessAdvBtn">Staff Business Advance</a></p></li>
                <li><p class="link_btn"><a href="#" id="editRejBtn">Edit Rejected</a></p></li>
            </ul>
            <ul class="btns">
            </ul>
            <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->
	<!-- <section class="search_result">
		<article id="grid_wrap"
			style="width: 100%;"></article>
	</section> -->
	<section class="search_result"><!-- search_result start -->
        <article class="grid_wrap" id="grid_wrap"  style="height:500px"></article><!-- grid_wrap end -->
    </section>

</section>
<!-- content end -->

<!-- ********************************************************************************************************************************* -->
<!-- ******************************************************** ADVANCE REQUEST ******************************************************** -->
<!-- ********************************************************************************************************************************* -->

<div class="popup_wrap2" id="busActReqPop" style="display: none;">

	<header class="pop_header">
		<h1 id="advHeader">New Advance Request</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#" id="busActReqClose_btn"><spring:message
							code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>
	</header>

	<section class="pop_body2">
		<section class="search_table">
			<form action="#" method="post" enctype="multipart/form-data"
				id="busActReqForm">
				<input type="hidden" id="createUserId" name="createUserId" />
				<input type="hidden" id="costCenterName" name="costCenterName" />
				<!-- <input type="hidden" id="bankId" name="bankId"/> -->
				<input type="hidden" id="clmNo" name="clmNo" />
				<input type="hidden" id="atchFileGrpId" name="atchFileGrpId" />
				<input type="hidden" id="advOccDesc" name="advOccDesc" />

				<ul class="right_btns mb10">
					<!--
                    <li><p class="btn_blue2"><a href="javascript:fn_saveRequest('D');" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
                    <li><p class="btn_blue2"><a href="javascript:fn_saveRequest('S');" id="requestSubmit_btn"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
                    -->
					<li><p class="btn_blue2">
							<a href="javascript:fn_saveRequest('D');" id="tempSave_btn"><spring:message
									code="newWebInvoice.btn.tempSave" /></a>
						</p></li>
					<li><p class="btn_blue2">
							<a href="javascript:fn_saveRequest('A');" id="requestSubmit_btn"><spring:message
									code="newWebInvoice.btn.submit" /></a>
						</p></li>
				</ul>

				<table class="type1">
					<caption>Advance Request General Details</caption>
					<colgroup>
						<col style="width: 200px" />
						<col style="width: *" />
						<col style="width: 200px" />
						<col style="width: *" />
					</colgroup>

					<tbody>
						<tr id="reqEditClmNo" style="display: none;">
							<th scope="row">Claim No</th>
							<td colspan="3"><span id="reqDraftClaimNo"></span></td>
						</tr>
						<tr>
							<th scope="row">Advance Type</th>
							<td><select class="readonly w100p" id="reqAdvType"
								name="reqAdvType">
									<option value="3">Staff Business Activity</option>
									<option value="4">Staff Business Activity - Repayment</option>
							</select></td>
							<th scope="row">Entry Date</th>
							<td><input type="text" title="" placeholder="DD/MM/YYYY"
								class="j_date w100p" id="keyDate" name="keyDate" readonly /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="webInvoice.costCenter" /><span
								class="must">*</span></th>
							<td><input type="text" title=""
								placeholder="Cost Center Code" class="" id="costCenterCode"
								name="costCenterCode" value="${costCentr}" readonly /> <a
								href="#" class="search_btn" id="reqCostCenter_search_btn"> <img
									src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
									alt="search" />
							</a></td>
							<th scope="row">Create User ID</th>
							<td><input type="text" title="" placeholder="Requestor ID"
								class="w100p" id="createUsername" name="createUsername" readonly />
							</td>
						</tr>
						<tr>
							<th scope="row">Payee Code<span class="must">*</span></th>
							<td><input type="text" title="" placeholder="" class="w100p"
								id="payeeCode" name="payeeCode" readonly /> <!--
                                <a href="#" class="search_btn" id="reqPayee_search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                                --></td>
							<th scope="row">Payee Name</th>
							<td><input type="text" title="" placeholder="" class="w100p"
								id="payeeName" name="payeeName" value="${name}" readonly /></td>
						</tr>
						<tr>
							<th scope="row">Bank</th>
							<!-- <td><input type="text" title="Bank Name"
								placeholder="Bank Name" class="w100p" id="bankName"
								name="bankName" value="CIMB BANK BHD" readonly /> <input type="text" title="Bank Name" placeholder="Bank Name" class="w100p" id="bankName" name="bankName" value="${bankId}" readonly/>
							</td> -->
							<td><select class="w100p" id="bankId" name="bankId">
	                                    <c:forEach var="list" items="${bankName}" varStatus="status">
	                                       <option value="${list.bankId}">${list.bankName}</option>
	                                    </c:forEach>
                                    </select>
							</td>
							<th scope="row">Bank Account</th>
							<td><input type="text" title="Bank Account No"
								placeholder="Bank Account No" class="w100p" id="bankAccNo"
								name="bankAccNo" maxlength="16"
								onKeypress="return event.charCode >= 48 && event.charCode <= 57" />
								<!-- <input type="text" title="Bank Account No" placeholder="Bank Account No" class="w100p" id="bankAccNo" name="bankAccNo" value="${bankAccNo}" readonly/> -->
							</td>
						</tr>
						<tr>
                            <th scope="row">Advanced Occasions<span class="must">*</span></th>
                            <td><select id="advOcc" name="advOcc"
                                class="w100p">
                                    <option value="">Choose One</option>
                                    <c:forEach var="list" items="${advOcc}" varStatus="status">
                                        <option value="${list.code}">${list.codeName}</option>
                                    </c:forEach>
                            </select></td>
                            <th scope="row">Total Advanced (RM)<span class="must">*</span></th>
                            <td colspan=1><input type="text" title="" placeholder="" class="w100p"
                                id="reqTotAmt" name="reqTotAmt" />
					</tbody>
				</table>

				<!-- Business Activity Advance Division Start-->

				<div id="busActAdv" style="display: none;">
					<table class="type1">
						<caption>New Advance Request</caption>
						<colgroup>
							<col style="width: 200px" />
							<col style="width: *" />
							<col style="width: 200px" />
						</colgroup>


						<tr>
							<th scope="row">Event Date<span class="must">*</span></th>
							<td>
								<div class="date_set w100p">
									<p>
										<input style="colspan=2" type="text" title="Create start Date"
											placeholder="DD/MM/YYYY" class="j_date" id="eventStartDt"
											name="eventStartDt" onChange="fn_eventPeriod('F')" />
									</p>
									<span><spring:message code="webInvoice.to" /></span>
									<p>
										<input type="text" title="Create end Date"
											placeholder="DD/MM/YYYY" class="j_date" id="eventEndDt"
											name="eventEndDt" onChange="fn_eventPeriod('T')" />
									</p>
								</div>
							</td>
							<td><input type="text" placeholder="No. of Days"
								style="width: 150px" id="daysCount" name="daysCount" readonly />
								<span style="line-height: 20px; text-align: center;">Days</span>
							</td>
						</tr>
<!-- 						<tr>
						     <th scope="row">Total Advanced (RM)<span class="must">*</span></th>
                            <td colspan=1><input type="text" title="" placeholder="" class="w100p"
                                id="reqTotAmt" name="reqTotAmt" />
						</tr> -->

						<tr>
							<th scope="row">Remarks<span class="must">*</span></th>
							<td colspan="2"><textarea id="busActReqRem"
									name="busActReqRem" placeholder="Enter up to 200 characters"
									maxlength="200" style="resize: none"></textarea></td>
						</tr>
					</table>
				</div>

				<!-- Business Activity Advance Division End -->

				<table class="type1">
					<caption>New Advance Request</caption>
					<colgroup>
						<col style="width: 200px" />
						<col style="width: *" />
						<col style="width: 100px" />
					</colgroup>
					<!--  <tr>
                        <th scope="row">Attachment<span class="must">*</span></th>
                        <td>
                            <div class="auto_file">
                                <input type="file" id="fileSelector" name="fileSelector" title="file add" accept=".rar, .zip" />
                            </div>
                        </td>

                    </tr>-->
					<!--  <tr>
					    <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
					    <td colspan="3" id="attachTd">
					    <div class="auto_file2 attachment_file w100p">
					    <input type="file" title="file" style="width:300px" />
					    </div>
					    </td>
					</tr> -->
					<tr>
						<th scope="row">Attachment<span class="must">*</span></th>
						<td colspan=2>
							<div class="auto_file2">
								<!-- auto_file2 start -->
								<input id="fileSelector" name="fileSelector" type="file" title="file add" />
							</div>
							<!-- auto_file2 end -->
						</td>
					</tr>
					<tr>
						<th scope="row">Settlement Due Date</th>
						<td colspan="2"><input type="text" title="Refund Date"
							placeholder="Refund Date" id="refdDate" name="refdDate" style=""
							readonly /></td>
					</tr>
				</table>
			</form>
		</section>
	</section>
</div>

<!-- ******************************************************************************************************************************** -->
<!-- ******************************************************** ADVANCE REFUND ******************************************************** -->
<!-- ******************************************************************************************************************************** -->

<div class="popup_wrap2" id="advRepayPop" style="display: none;">

	<header class="pop_header">
		<h1>Settlement</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#;" id="advRefClose_btn"><spring:message
							code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>
	</header>

	<section class="pop_body">
		<section class="search_table">
			<form action="#" method="post" enctype="multipart/form-data"
				id="advRepayForm">
				<input type="hidden" id="createUserId" name="createUserId" />
				<input type="hidden" id="costCenterName" name="costCenterName" />
				<input type="hidden" id="bankId" name="bankId" />
				<input type="hidden" id="refClmNo" name="refClmNo" />
				<input type="hidden" id="refAtchFileGrpId" name="refAtchFileGrpId" />
				<input type="hidden" id="refAdvType_h" name="refAdvType_h" />
				<input type="hidden" id="expType" name="expType" />
				<input type="hidden" id="expTypeNm" name="expTypeNm" />
				<input type="hidden" id="refAdvRepayDate" name="refAdvRepayDate" />
				<input type="hidden" id="refSubmitFlg" name="refSubmitFlg" />

				<ul class="right_btns mb10">
					<li><p class="btn_blue2">
							<a href="javascript:fn_saveRefund('D');" id="tempSave_btn"><spring:message
									code="newWebInvoice.btn.tempSave" /></a>
						</p></li>
					<li><p class="btn_blue2">
							<a href="javascript:fn_saveRefund('S');" id="repaySubmit_btn"><spring:message
									code="newWebInvoice.btn.submit" /></a>
						</p></li>
				</ul>

				<table class="type1">
					<caption>Advance Repayment General Details</caption>
					<colgroup>
						<col style="width: 200px" />
						<col style="width: *" />
						<col style="width: 200px" />
						<col style="width: *" />
					</colgroup>

					<tbody>
						<tr id="repayEditClmNo">
							<th scope="row">Claim No</th>
							<td colspan="3"><span id="repayDraftClaimNo"></span></td>
						</tr>
						<tr>
							<th scope="row">Advance Type</th>
							<td><select class="readonly w100p" id="refAdvType"
								name="refAdvType" readonly disabled="disabled">
									<option value="3">Staff Business Activity</option>
                                    <option value="4">Staff Business Activity - Repayment</option>
							</select></td>
							<th scope="row">Entry Date</th>
							<td><input type="text" title="" placeholder="DD/MM/YYYY"
								class="w100p readonly" id="refKeyDate" name="refKeyDate" readonly/>
							</td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="webInvoice.costCenter" /><span
								class="must">*</span></th>
							<td><input type="text" title=""
								placeholder="Cost Center Code" class="w100p"
								id="refCostCenterCode" name="refCostCenterCode"
								value="${costCentr}" readonly /></td>
							<th scope="row">Create User ID</th>
							<td><input type="text" title="" placeholder="Requestor ID"
								class="w100p" id="refCreateUsername" name="refCreateUsername"
								readonly /></td>
						</tr>
						<tr>
							<th scope="row">Payee Code<span class="must">*</span></th>
							<td><input type="text" title="" placeholder="" class="w100p"
								id="refPayeeCode" name="refPayeeCode" readonly /></td>
							<th scope="row">Payee Name</th>
							<td><input type="text" title="" placeholder="" class="w100p"
								id="refPayeeName" name="refPayeeName" value="${name}" readonly />
							</td>
						</tr>
						<tr id="repayBank">
							<th scope="row">Bank</th>
							<td><input type="text" title="Bank Name"
								placeholder="Bank Name" class="w100p" id="refBankName"
								name="refBankName" value="${bankId}" readonly /></td>
							<th scope="row">Bank Account</th>
							<td><input type="text" title="Bank Account No"
								placeholder="Bank Account No" class="w100p" id="refBankAccNo"
								name="refBankAccNo" value="${bankAccNo}" readonly /></td>
						</tr>
						<tr>
                            <th scope="row">Event Date<span class="must">*</span></th>
                            <td colspan=3>
                                <div class="date_set w100p">
                                    <p>
                                        <input type="text" title="Create start Date"
                                            placeholder="DD/MM/YYYY" class="j_date" id="refEventStartDt"
                                            name="refEventStartDt" readonly/>
                                    </p>
                                    <span><spring:message code="webInvoice.to" /></span>
                                    <p>
                                        <input type="text" title="Create end Date"
                                            placeholder="DD/MM/YYYY" class="j_date" id="refEventEndDt"
                                            name="refEventEndDt" readonly/>
                                    </p>
                                </div>
                            </td>
                        </tr>
						<tr>
                        <th scope="row">Claim No for Advance Request</th>
                        <td colspan=3><input class="readonly w100p" type="text"
                            title="Advance Request Claim No"
                            placeholder="Advance Request Claim No" id="advReqClmNo"
                            name="advReqClmNo" style="" readonly /></td>
                    </tr>
                    <tr>
                        <th scope="row">Advance Amount (RM)</th>
                        <td colspan=3><input class="readonly w100p" type="text"
                            title="Adcance Amount (RM)"
                            placeholder="Adcance Amount (RM)" id="refAdvAmt"
                            name="refAdvAmt" style="" readonly /></td>
                    </tr>
                    <tr>
                        <th scope="row">Total Expenses (RM)</th>
                        <td colspan=3><input class="readonly w100p" type="text"
                            title="Total Expenses (RM)"
                            placeholder="Total Expenses (RM)" id="refTotExp"
                            name="refTotExp" style=""  readonly /></td>
                    </tr>
                    <tr>
                        <th scope="row">Balance Amount (RM)</th>
                        <td colspan=1><input class="readonly w100p" type="text"
                            title="Balance Amount (RM)"
                            placeholder="Balance Amount (RM)" id="refBalAmt"
                            name="refBalAmt" style="" readonly /></td>
                        <td colspan=2>(+) Repay to Company / (-) Repay to Requestor</td>
                    </tr>
                    <tr>
                        <th scope="row">Refund Mode</th>
                        <td>
                            <select class="readonly w100p" id="refMode"
                                name="refMode" readonly>
                                    <option value="CASH">Cash</option>
                                    <option value="OTRX">Online</option>
                            </select>
                        </td>
                        <th scope="row">Bank Reference</th>
                            <td><input type="text" title="Bank Reference" placeholder="Bank Reference" class="w100p"
                                id="refBankRef" name="refBankRef" value="${name}" /></td>
                    </tr>
					</tbody>
				</table>

				<table class="type1" id="trvAdvRepay" style="display: none;">
					<caption>Advance Repayment</caption>
					<colgroup>
						<col style="width: 200px" />
						<col style="width: *" />
						<col style="width: 100px" />
					</colgroup>

					<!-- <tr>
						<th scope="row">Amount Repaid (RM)</th>
						<td colspan="2"><input type="text" title="Amount Repaid (RM)"
							placeholder="Amount Repaid (RM)" id="trvAdvRepayAmt"
							name="trvAdvRepayAmt" style="" readonly /></td>
					</tr>
					<tr>
						<th scope="row">Repayment Due Date</th>
						<td colspan="2"><input type="text" title="Repayment Date"
							placeholder="Repayment Date" id="trvAdvRepayDate"
							name="trvAdvRepayDate" class="j_date" style="" /></td>
					</tr> -->

					<!--
                    <tr>
                        <th scope="row">Bank-In Advice Ref No</th>
                        <td colspan="2">
                            <input type="text" title="Bank-In Advice Ref No" placeholder="Bank-In Advice Ref No" id="trvBankRefNo" name="trvBankRefNo" style="200px" />
                        </td>
                    </tr>
                    -->
                    <tr>
                        <th scope="row">Remarks<span class="must">*</span></th>
                        <td colspan="3"><textarea id="trvRepayRem" name="trvRepayRem"
                                placeholder="Enter up to 100 characters" maxlength="100"
                                style="resize: none"></textarea></td>
                    </tr>
                    <tr>
                        <th scope="row">Attachment<span class="must">*</span></th>
                        <!-- <td colspan="2" id="trvAdvFileSelector"
                                    name="trvAdvFileSelector" >
                            <div class="auto_file attachment_file w100p">
                                <input type="file"  title="file add" />
                            </div>
                        </td> -->
                        <td colspan=3>
                            <div class="auto_file2">
                                <!-- auto_file2 start -->
                                <input id="trvAdvFileSelector" name="trvAdvFileSelector" type="file" title="file add" />
                            </div>
                            <!-- auto_file2 end -->
                        </td>
                    </tr>
        </table>
        </form>
    </section><!-- search_result end -->

<section class="search_result"><!-- search_result start -->

        <aside class="title_line"><!-- title_line start -->
            <ul class="right_btns">
                <li><p class="btn_grid"><a href="#" id="add_row">Add</a></p></li>
                <li><p class="btn_grid"><a href="#" id="remove_row">Delete</a></p></li>
            </ul>
        </aside><!-- title_line end -->

        <!-- Refund Grid - Start -->
        <article class="grid_wrap" id="refundSettement_grid_wrap"></article>
        <!-- Refund Grid - End -->

    </section>

</section>
</div>

<!-- ********************************************************************************************************************************************* -->
<!-- ******************************************************** ADVANCE REQUEST MESSAGE POP ******************************************************** -->
<!-- ********************************************************************************************************************************************* -->

<div class="popup_wrap size_small" id="advReqMsgPop"
	style="display: none;">
	<header class="pop_header">
		<h1 id="advReqMsgPopHeader">Submission of Request</h1>
		<ul class="right_opt">
			<li>
				<p class="btn_blue2">
					<a href="#"> <spring:message code="newWebInvoice.btn.close" />
					</a>
				</p>
			</li>
		</ul>
	</header>

	<section class="pop_body">
		<div id="acknowledgement"
			style="padding-top: 1%; padding-left: 1%; padding-right: 1%">
			<table class="type1" style="border: none">
				<caption>New Advance Request</caption>
				<colgroup>
					<col style="width: 30px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<td colspan="2"
							style="font-size: 14px; font-weight: bold; padding-bottom: 2%">
							Are you sure you want to submit this advance request?</td>
					</tr>
					<tr>
						<td><input type="checkbox" id="ack1Checkbox"
							name="ack1Checkbox" value="1" /></td>
						<td
							style="padding-top: 2%; padding-bottom: 2%; text-align: justify;">
							By checking this box, you acknowledge that you have read and
							understand all the policies and rules with respect to advance to
							staff, and agree to abide by all the policies and rules.</td>
					</tr>
				</tbody>
			</table>

			<ul class="center_btns" id="agreementButton">
				<li><p class="btn_blue">
						<a href="javascript:fn_advReqAck('A');">Yes</a>
					</p></li>
				<li><p class="btn_blue">
						<a href="javascript:fn_advReqAck('J');">No</a>
					</p></li>
			</ul>

		</div>

	</section>
</div>

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

<!-- ********************************************************************************************************************************************** -->
<!-- ******************************************************** ADVANCE REQUEST APPROVAL POP ******************************************************** -->
<!-- ********************************************************************************************************************************************** -->

<div class="popup_wrap size_mid2" id="appvLinePop"
	style="display: none;">
	<header class="pop_header">
		<h1>
			<spring:message code="approveLine.title" />
		</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>
	</header>

	<section class="pop_body">
		<section class="search_result">
			<ul class="right_btns">
				<li><p class="btn_grid">
						<a href="javascript:fn_appvLineGridDeleteRow()" id="lineDel_btn"><spring:message
								code="newWebInvoice.btn.delete" /></a>
					</p></li>
			</ul>

			<article class="grid_wrap" id="approveLine_grid_wrap"></article>

			<ul class="center_btns" id="requestAppvLine" style="display: none;">
				<li><p class="btn_blue2">
						<a href="javascript:fn_saveRequest('S')" id="submit"><spring:message
								code="newWebInvoice.btn.submit" /></a>
					</p></li>
			</ul>

			<ul class="center_btns" id="repaymentAppvLine" style="display: none;">
				<li><p class="btn_blue2">
						<a href="javascript:fn_submitRef()" id="submit"><spring:message
								code="newWebInvoice.btn.submit" /></a>
					</p></li>
			</ul>

		</section>
	</section>
</div>