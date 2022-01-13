<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    var carMilePrct, carMileRate, minAmt, minPeriod, advRetDate, advReqDate1, advReqDate2, advRetMth1, advRetMth2;
    var advType, claimNo, repayStus, appvStus, clmType, mode;
    var menu = "MAIN";
    var advGridId, approveLineGridID;
    var selectRowIdx;

    // Main Menu Grid Listing Grid -- Start
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
        dataField : "payee",
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
        dataField : "rqstDt",
        headerText : "Submission Date",
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
        headerText : "Repayment Status"
    }];

    var advanceGridPros = {
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

    $(document).ready(function () {
        console.log("staffAdvance :: ready");

        advGridId = AUIGrid.create("#grid_wrap", advanceColumnLayout, advanceGridPros);
        approveLineGridID = GridCommon.createAUIGrid("#approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);

        $("#request_btn").click(fn_advReqPop);
        $("#advList_btn").click(fn_searchAdv);
        $("#refund_btn").click(fn_repaymentPop);

        $("#search_costCenter_btn").click(fn_costCenterSearchPop);
        $("#search_payee_btn").click(fn_popPayeeSearchPop);

        // Advance Request
        $("#advReqClose_btn").click(fn_closePop);

        $("#reqCostCenter_search_btn").click(fn_popCostCenterSearchPop);
        $("#reqPayee_search_btn").click(fn_popPayeeSearchPop);

        $("#mileage").blur(fn_calcMil);
        $("#mileageAmt").change(fn_calTotalAdv);
        $("#accmdtAmt").change(fn_calTotalAdv);
        $("#tollAmt").change(fn_calTotalAdv);
        $("#othTrsptAmt").change(fn_calTotalAdv);

        // Advance Refund
        $("#advRefClose_btn").click(fn_closePop);

        AUIGrid.bind(advGridId, "cellClick", function(event) {
           console.log("advGridId cellclick :: " + event.rowIndex);
           console.log("advGridId cellclick clmNo :: " + event.item.clmNo);

           claimNo = event.item.clmNo;
           repayStus = event.item.repayStus;
           advType = event.item.advType;
           clmType = event.item.clmNo.substr(0, 2);
           appvStus = event.item.appvPrcssStus;
        });

        AUIGrid.bind(advGridId, "cellDoubleClick", function( event ) {
            console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            console.log("CellDoubleClick clmNo : " + event.item.clmNo);
            console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
            console.log("CellDoubleClick appvPrcssStus : " + event.item.appvPrcssStus);

            if(event.item.appvPrcssStus == "T") {
                mode = "DRAFT";
                clmType = event.item.clmNo.substr(0, 2);
                appvStus = event.item.appvPrcssStus;

                if(advType == "1") {
                    fn_advReqPop();
                } else if(advType == "2") {
                    fn_repaymentPop();
                }
                //fn_viewEditPop(event.item.clmNo, event.item.appvStus);
            } else {
                clmType = event.item.clmNo.substr(0, 2);
                fn_requestPop(event.item.appvPrcssNo, clmType);
            }
        });

        AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
            console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            selectRowIdx = event.rowIndex;
        });
    });

    /************************************************
    ********** REQUEST MENU SEARCH BUTTONS **********
    ************************************************/
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
            //$("#bankAccNo").val($("#search_bankAccNo").val());
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

    /******************************************
    ********** MAIN MENU BLUE BUTTON **********
    *******************************************/

    function fn_searchAdv() {
        Common.ajax("GET", "/eAccounting/staffAdvance/advanceListing.do", $("#searchForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(advGridId, result);
        });
    }

    function fn_advReqPop() {
        console.log("fn_advReqPop");

        $("#bankName").val("CIMB BANK BHD");
        $("#bankId").val("3");

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

        $("#advReqPop").show();
        $("#reqEditClmNo").hide();

        // Get configuration based on advance type
        Common.ajax("GET", "/eAccounting/staffAdvance/advReqPop.do", {advType : advType}, function(results) {
            console.log("advReqPop :: Advance Request :: " + results);

            $('advReqForm :input').val();

            $("#keyDate").val(today);
            $("#createUserId").val(results.userId);
            $("#createUsername").val(results.userName);

            $("#payeeCode").val(results.rqstCode);
            $("#payeeName").val(results.rqstName);

            if(advType == "1") {
                console.log("Travel Advance");
                $("#trvAdv").show();

                $("#reqAdvType option[value=1]").attr('selected', 'selected');

                carMilePrct = results.sCarMilePrct;
                carMileRate = results.sCarMileRate;
                minAmt = parseInt(results.sMinAmt);
                minPeriod = parseInt(results.sPeriod);
                advRetDate = results.sTrDt;

                var rDate = results.sTrn1.split(",");

                advReqDate1 = parseInt(rDate[0]);
                advRetMth1 = parseInt(rDate[1]);

                rDate = results.sTrn2.split(",");

                advReqDate2 = parseInt(rDate[0]);
                advRetMth2 = parseInt(rDate[1]);

                var defaultAmt = 0;

                $("#mileageAmt").val(defaultAmt.toFixed(2));
                $("#accmdtAmt").val(defaultAmt.toFixed(2));
                $("#tollAmt").val(defaultAmt.toFixed(2));
                $("#othTrsptAmt").val(defaultAmt.toFixed(2));
                $("#reqTotAmt").val(defaultAmt.toFixed(2));

            } else if(advType == "3") {
                console.log("Event Advance");
            }

            if(appvStus == "T") {
                console.log("request :: appvStus :: T");

                var data = {
                        clmNo : claimNo,
                        advType : advType
                };

                console.log(data);
                Common.ajax("GET", "/eAccounting/staffAdvance/getAdvClmInfo.do", data, function(results) {
                    console.log("getAdvClmInfo.do");
                    console.log(results);

                    $("#reqEditClmNo").show();

                    $("#createUserId").val(results.crtUserId);
                    $("#costCenterName").val(results.costCenterNm);
                    $("#bankId").val(results.bankCode);
                    $("#atchFileGrpId").val(results.fileAtchGrpId);
                    $("#clmNo").val(claimNo);

                    $("#reqDraftClaimNo").text(claimNo);
                    $("#reqAdvType option[value=" + results.advType + "]").attr('selected', 'selected');
                    $("#reqAdvType").val(results.advType);
                    $("#reqAdvType").attr("readonly", true);
                    $("#keyDate").val(results.entryDt);
                    $("#costCenterCode").val(results.costCenter);
                    $("#createUsername").val(results.crtUserName);
                    $("#payeeCode").val(results.payee);
                    $("#payeeName").val(results.payeeName);
                    $("#bankName").val(results.bankName);
                    $("#bankAccNo").val(results.bankAccno);

                    $("#locationFrom").val(results.advLocFr);
                    $("#locationTo").val(results.advLocTo);
                    $("#trvPeriodFr").val(results.advPrdFr);
                    $("#trvPeriodTo").val(results.advPrdTo);
                    $("#trvReqRem").val(results.advRem);

                    $("#accmdtAmt").val(results.accAmt.toFixed(2));
                    $("#mileageAmt").val(results.milAmt.toFixed(2));
                    $("#mileage").val(results.milDist);
                    $("#tollAmt").val(results.tollAmt.toFixed(2));
                    $("#othTrsptAmt").val(results.othAmt.toFixed(2));
                    $("#trsptMode").val(results.othRem);
                    $("#reqTotAmt").val(parseFloat(results.accAmt) + parseFloat(results.milAmt) + parseFloat(results.tollAmt) + parseFloat(results.othAmt));

                    $("#fileSelector").html("");
                    $("#fileSelector").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='1'/></div>");
                    $(".input_text").val(results.atchFileName);
                    $(".input_text").dblclick(function() {
                        var data = {
                                atchFileGrpId : results.fileAtchGrpId,
                                atchFileId : results.atchFileId
                        };

                        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(flResult) {
                            console.log(flResult);
                            if(flResult.fileExtsn == "jpg" || flResult.fileExtsn == "png" || flResult.fileExtsn == "gif") {
                                // TODO View
                                var fileSubPath = result.fileSubPath;
                                fileSubPath = fileSubPath.replace('\', '/'');
                                console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                                window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
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

                    /*
                    $("#").val()
                    $("#").val()
                    $("#").val()
                    $("#").val()*/

                    fn_trvPeriod("F");
                });
            }
        });
    }

    function fn_repaymentPop() {
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
        if(advType == "1") {
            $("#repayBank").hide();
            $("#repayBank").hide();
            $("#trvAdvRepay").show();

            $("#refAdvType").empty().append('<option selected="selected" value="2">Staff Travel Expenses - Repayment</option>');
        }

        if(clmType == "R2") {
            $("#repayEditClmNo").hide();
            Common.ajax("GET", "/eAccounting/staffAdvance/getRefundDetails.do", {claimNo : claimNo}, function(result) {
                console.log(result);

                $("#refClmNo").val(claimNo);
                $("#advReqClmNo").val(claimNo);
                $("#refKeyDate").val(result.entryDt);
                $("#refCostCenterCode").val(result.costCenter);
                $("#refCreateUsername").val(result.crtUserNm);
                $("#refPayeeCode").val(result.payeeCode);
                $("#refPayeeName").val(result.payeeName);
                $("#refBankName").val(result.bankName);
                $("#refBankAccNo").val(result.bankAccNo);
                $("#trvAdvRepayAmt").val(result.totAmt.toFixed(2));
            });

        } else if(clmType == "A1") {
            $("#advRepayPop").show();

            var data = {
                    clmNo : claimNo,
                    advType : advType
            };

            console.log(data);
            Common.ajax("GET", "/eAccounting/staffAdvance/getAdvClmInfo.do", data, function(results) {
                console.log("getAdvClmInfo.do");
                console.log(results);

                $("#trvAdvRepay").show();

                $("#repayDraftClaimNo").text(claimNo);
                $("#advReqClmNo").val(results.advReqClmNo);
                $("#refKeyDate").val(results.entryDt);
                $("#refCostCenterCode").val(results.costCenter);
                $("#refCreateUsername").val(results.crtUserNm);
                $("#refPayeeCode").val(results.payee);
                $("#refPayeeName").val(results.payeeName);
                $("#refBankName").val(results.bankName);
                $("#refBankAccNo").val(results.bankAccNo);
                $("#trvAdvRepayAmt").val(results.totAmt.toFixed(2));
                $("#trvAdvRepayDate").val(results.advRefdDt);
                $("#trvBankRefNo").val(results.invcNo);
                $("#trvRepayRem").val(results.advRem);

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
                            var fileSubPath = result.fileSubPath;
                            fileSubPath = fileSubPath.replace('\', '/'');
                            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
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

    /********************************************
    ********** MAIN MENU GRID FUNCTION **********
    *********************************************/

    function fn_viewEditPop(clmNo) {
        console.log("fn_viewEditPop");

        Common.ajax("GET", "", data, function(result) {
            console.log(result);

            $("#advReqPop").show();
        })
    }

    function fn_requestPop(appvPrcssNo, clmType) {
        console.log("fn_requestPop");

        var data = {
                clmType : clmType,
                appvPrcssNo : appvPrcssNo,
                type : "view"
        };

        Common.popupDiv("/eAccounting/staffAdvance/staffAdvanceAppvViewPop.do", data, null, true, "webInvoiceAppvViewPop");
    }

    /*******************************************
    ****************** COMMON ******************
    ********************************************/

    function fn_alertClmNo(clmNo) {
        console.log("fn_alertClmNo");

        Common.alert("Claim number : <b>" + clmNo + "</b><br>Registration of new advance request has completed.");
    }

    function fn_closePop() {
        console.log("fn_closePop");
        appvStus = null;
        mdoe = null;
        advType = null;

        if(menu == "REQ") {
            $("#advReqForm").clearForm();
            $("#advReqPop").hide();

            $("#reqAdvType").attr("disabled", false);
        } else if(menu == "REF") {
            $("#advRepayForm").clearForm();
            $("#advRepayPop").hide();

            $("#refAdvType").empty();
            $("#refAdvType").append('<option value="1">Staff Travel Expense</option>');
            $("#refAdvType").append('<option selected="selected" value="2">Staff Travel Expenses - Repayment</option>');
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

        AUIGrid.destroy("#approveLine_grid_wrap");
        approveLineGridID = GridCommon.createAUIGrid("#approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);

        menu = "MAIN";
        mode = "";
        claimNo = "";
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

        advType = "";
    };

    /********************************************
    ****************** REQUEST ******************
    *********************************************/

    function fn_trvPeriod(mode) {
        console.log("fn_trvPeriod :: onChange");

        var errMsg = "Travel advance can only be applied for outstation trip with qualifying expenses of more than RM400 and stay of at least two(2) consecutive nights.";
        var arrDt, fDate, tDate, dateDiff, rDate;
        var dd, mm, yyyy;

        var cDate = new Date();

        if(mode == "F") {
            arrDt = $("#trvPeriodFr").val().split("/");
            fDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

            if(fDate > cDate) {
                if($("#trvPeriodTo").val() == "") {
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

                    $("#trvPeriodTo").val(dd + "/" + mm + "/" + yyyy);
                    //$("#daysCount").val(minPeriod);
                }
            } else {
                Common.alert(errMsg);
                $("#trvPeriodFr").val("");
                $("#trvPeriodTo").val("");
                $("#daysCount").val("");
                $("#refdDate").val("");
                return false;
            }
        } else if(mode == "T") {
            arrDt = $("#trvPeriodTo").val().split("/");
            tDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);
            var nDate = new Date();
            nDate.setDate(nDate.getDate() + minPeriod);

            if(tDate < cDate) {
                Common.alert(errMsg);
                $("#trvPeriodFr").val("");
                $("#trvPeriodTo").val("");
                $("#daysCount").val("");
                $("#refdDate").val("");
                return false;
            } else if (tDate <= nDate && tDate > cDate) {
                Common.alert(errMsg);
                $("#trvPeriodFr").val("");
                $("#trvPeriodTo").val("");
                $("#daysCount").val("");
                $("#refdDate").val("");
                return false;
            }

            if($("#trvPeriodFr").val() == "") {
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

                $("#trvPeriodFr").val(dd + "/" + mm + "/" + yyyy);
                //$("#daysCount").val(minPeriod);
            }
        }

        //Calculate day difference
        if($("#trvPeriodFr").val() != "" && $("#trvPeriodTo").val() != "") {
            arrDt = $("#trvPeriodFr").val().split("/");
            fDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

            arrDt = $("#trvPeriodTo").val().split("/");
            tDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

            dateDiff = ((new Date(tDate - fDate))/1000/60/60/24) + 1;

            if(dateDiff < 3) {
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

        if($("#trvPeriodTo").val() != "") {
            if(dateDiff < minPeriod) {
                Common.alert(errMsg);
                $("#trvPeriodFr").val("");
                $("#trvPeriodTo").val("");
                $("#daysCount").val("");
                $("#refdDate").val("");
                return false;
            } else {
                arrDt = $("#trvPeriodTo").val().split("/");
                if(arrDt[0] <= advReqDate1) {
                    rDate = new Date(arrDt[2], parseInt(arrDt[1]) - 1 + advRetMth1, advRetDate);
                } else if (arrDt[0] >= advReqDate1) {
                    rDate = new Date(arrDt[2], parseInt(arrDt[1]) - 1 + advRetMth2, advRetDate);
                }

                dd = rDate.getDate();
                mm = rDate.getMonth() + 1;
                yyyy = rDate.getFullYear();

                if(mm < 10) {
                    mm = "0" + mm;
                }

                $("#refdDate").val(dd + "/" + mm + "/" + yyyy);
            }
        }
    }

    function fn_calcMil() {
        var distance = parseFloat($("#mileage").val());
        var prct = parseFloat(carMilePrct) / 100;
        var amt = Math.round((distance * parseFloat(carMileRate)) * prct);

        $("#mileageAmt").val(amt.toFixed(2));
        fn_calTotalAdv();
    }

    function fn_calTotalAdv() {
        var acc, mil, toll, oth;

        acc = $("#accmdtAmt").val();
        mil = $("#mileageAmt").val();
        toll = $("#tollAmt").val();
        oth = $("#othTrsptAmt").val();

        if(acc == "" || acc == null) {
            acc = 0;
        }

        if(mil == "" || mil == null) {
            mil = 0;
        }

        if(toll == "" || toll == null) {
            toll = 0;
        }

        if(oth == "" || oth == null) {
            oth = 0;
        }

        var total = parseFloat(acc) + parseFloat(mil) + parseFloat(toll) + parseFloat(oth);
        $("#reqTotAmt").val(total.toFixed(2));
    }

    /*************************************************
    ****************** REQUEST SAVE ******************
    **************************************************/

    function fn_advanceRequest() {
        console.log("fn_advanceRequest");

        if(fn_requestCheck) {
            $("#advReqMsgPop").show();
            $("#acknowledgement").show();
        }
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

    }

    function fn_requestCheck() {
        console.log("fn_requestCheck");

        var errMsg;

        // Travel Request
        if(advType == 1) {
            errMsg = "Travel advance can only be applied for outstation trip with qualifying expenses of more than RM400 and stay of at least two(2) consecutive nights."

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

            if(FormUtil.isEmpty($("#locationFrom").val()) && FormUtil.isEmpty($("#locationTo").val())) {
                Common.alert("Please enter the traveling locations");
                return false;
            }

            if(FormUtil.isEmpty($("#trvPeriodFr").val()) && FormUtil.isEmpty($("#trvPeriodTo").val())) {
                Common.alert("Please select traveling period.");
                return false
            } else {
                arrDt = $("#trvPeriodFr").val().split("/");
                fDate = new Date(arrDt[2], arrDt[1]-1, arrDt[0]);

                arrDt = $("#trvPeriodTo").val().split("/");
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

            if(FormUtil.isEmpty($("#trvReqRem").val())) {
                Common.alert("Please enter remark.");
                return false;
            }

            if(parseFloat($("#accmdtAmt").val()) == 0) {
                if(parseFloat($("#reqTotAmt").val()) > minAmt) {
                    Common.alert(errMsg);
                    return false;
                }
            }

            if(parseFloat($("#reqTotAmt").val()) < minAmt) {
                Common.alert(errMsg);
                return false;
            }

            if(parseFloat($("#othTrsptAmt").val()) > 0) {
                if($("#trsptMode").val() == "" || $("#trsptMode").val() == null) {
                    Common.alert("Please enter mode of transportation.");
                    return false;
                }
            }

            if(mode != "DRAFT") {
                if($("input[name=fileSelector]")[0].files[0] == "" || $("input[name=fileSelector]")[0].files[0] == null) {
                    Common.alert("Please attach supporting document zipped files!")
                    return false;
                }
            }

        } else if(type == 3) {

        }
        return true;
    }

    function fn_newSaveReq(mode) {
        $("#reqAdvType").attr("disabled", false);

        var formData = Common.getFormData("advReqForm");
        Common.ajaxFile("/eAccounting/staffAdvance/attachmentUpload.do", formData, function(result) {
           console.log(result);

           $("#atchFileGrpId").val(result.data.fileGroupKey);

           var obj = $("#advReqForm").serializeJSON();
           console.log(obj);

           Common.ajax("POST", "/eAccounting/staffAdvance/saveAdvReq.do", obj, function(result1) {
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
                   var obj = $("#advReqForm").serializeJSON();
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
                   fn_alertClmNo(result1.data.clmNo);
               } else {
                   fn_closePop();
                   fn_searchAdv();
               }
           });
        });
    }

    function fn_submitReq() {
        console.log("fn_submitReq");

        $("#reqAdvType").attr("disabled", false);

        /*
        if(appvStus == "T") {
            $("#clmNo").val(claimNo);
        }
        */

        var data = $("#advReqForm").serializeJSON();
        var apprLineGrid = AUIGrid.getOrgGridData(approveLineGridID);
        data.apprLineGrid = apprLineGrid;

        console.log(data);

        Common.ajax("POST", "/eAccounting/staffAdvance/submitAdvReq.do", data, function(result) {
            console.log(result);
            $("#appvLinePop").hide();
            $("#advReqMsgPop").hide();
            $("#acknowledgement").hide();

            $("#advType").val('');
            fn_closePop();
            fn_alertClmNo(result.data.clmNo);
            fn_searchAdv();
        });
    }

    function fn_editSaveReq(mode) {
        var formData = Common.getFormData("advReqForm");
        formData.append("atchFileGrpId", $("#atchFileGrpId").val());
        Common.ajaxFile("/eAccounting/staffAdvance/attachmentUpdate.do", formData, function(result) {
           console.log(result);

           Common.ajax("POST", "/eAccounting/staffAdvance/saveAdvReq.do", $("#advReqForm").serializeJSON(), function(result1) {
           //Common.ajax("POST", "/eAccounting/staffAdvance/saveAdvReq.do", formData, function(result1) {
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
                   var obj = $("#advReqForm").serializeJSON();
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

    /************************************************
    ****************** REFUND SAVE ******************
    *************************************************/

    function fn_saveRefund(v) {
        console.log("fn_saveRefund");

        if(fn_checkRefund) {
            if(mode != "DRAFT") {
                var formData = Common.getFormData("advRepayForm");
                Common.ajaxFile("/eAccounting/staffAdvance/attachmentUpload.do", formData, function(result) {
                   console.log(result);

                   $("#refAtchFileGrpId").val(result.data.fileGroupKey);

                   var obj = $("#advRepayForm").serializeJSON();

                   Common.ajax("POST", "/eAccounting/staffAdvance/saveAdvRef.do", obj, function(result1) {
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
            } else {
                var formData = Common.getFormData("advRepayForm");
                formData.append("atchFileGrp", $("refATchFileGrpId").val());
                Common.ajaxFile("/eAccounting/staffAdvance/attachmentUpdate.do", formData, function(result) {
                    console.log(result);

                    var obj = $("#advRepayForm").serializeJSON();

                    Common.ajax("POST", "/eAccounting/staffAdvance/saveAdvRef.do", obj, function(result1) {
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
        }
    }

    function fn_submitRef() {
        console.log("fn_submitRef");

        var data = $("#advRepayForm").serializeJSON();
        var apprLineGrid = AUIGrid.getOrgGridData(approveLineGridID);
        data.apprLineGrid = apprLineGrid;

        console.log(data);

        Common.ajax("POST", "/eAccounting/staffAdvance/submitAdvReq.do", data, function(result) {
            console.log(result);
            $("#advRepayPop").hide();
            $("#appvLinePop").hide();

            fn_closePop();
            fn_alertClmNo(result.data.clmNo);
            fn_searchAdv();
        })
    }

    function fn_checkRefund() {
        console.log("fn_checkRefund");

        if(advType == "1") {
            if($("#trvAdvRepayDate").val() == "" || $("#trvAdvRepayDate").val() == null) {
                Common.alert("Repayment Date required.");
                return false;
            }

            if($("#trvBankRefNo").val() == "" || $("#trvBankRefNo").val() == null) {
                Common.alert("Bank-In Advice Ref No required.");
                return false;
            }

            if($("#trvRepayRem").val() == "" || $("#trvRepayRem").val() == null) {
                Common.alert("Remarks required.");
                return false;
            }

            if(mode != "DRAFT") {
                if($("input[name=trvAdvFileSelector]")[0].files[0] == "" || $("input[name=trvAdvFileSelector]")[0].files[0] == null) {
                    Common.alert("Please attach supporting document zipped files!")
                    return false;
                }
            }
        }

        return true;
    }

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

    /*****************************
    Approval Line Functions -- End
    ******************************/

</script>

<!-- ************************************************************* STYLE ************************************************************* -->

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

.aui-grid-user-custom-right {
    text-align:right;
}

</style>

<!-- ************************************************************* LAYOUT ************************************************************* -->

<!-- ************************************************************************************************************************************* -->
<!-- ************************************************************* MAIN MENU ************************************************************* -->
<!-- ************************************************************************************************************************************* -->

<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/Web_Invoice.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

    <input type="hidden" id="_clmNo" name="V_CLMNO" />
</form>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>e-Accounting</li>
        <li>Staff Advance</li>
    </ul>

    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
        <h2>Staff - Travel Advance</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" id="request_btn">New Request</a></p></li>
            <li><p class="btn_blue"><a href="#" id="refund_btn">Repayment</a></p></li>
            <li><p class="btn_blue"><a href="#" id="advList_btn"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside>


    <section class="search_table">
        <form id="searchForm" name="searchForm" method="post">
            <input type="hidden" id="memAccName" name="memAccName">
            <input type="hidden" id="costCenterText" name="costCenterText">

            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Advance Type</th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="advType" name="advType">
                                <option value="1">Staff Travel Expense</option>
                                <option value="2">Staff Travel Expense - Repayment</option>
                                <!--
                                <option value="3">Staff / Company Events</option>
                                <option value="4">Staff / Company Events - Repayment</option>
                                 -->
                            </select>
                        </td>
                        <th scope="row">Cost Center Code</th>
                        <td>
                            <input type="text" title="" placeholder="" class="" style="width:200px" id="listCostCenter" name="listCostCenter"/>
                            <a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Member Code</th>
                        <td>
                            <input type="text" title="" placeholder="" class="" style="width:200px" id="memAccCode" name="memAccCode"/>
                            <a href="#" class="search_btn" id="search_payee_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                        <th scope="row">Approval Status</th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
                                <option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
                                <option value="R"><spring:message code="webInvoice.select.request" /></option>
                                <option value="P"><spring:message code="webInvoice.select.progress" /></option>
                                <option value="A"><spring:message code="webInvoice.select.approved" /></option>
                                <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Claim No</th>
                        <td>
                            <div class="date_set w100p">
                                <p><input type="text" title="Claim No Start" id="clmNoStart" name="clmNoStart" class="w100p" /></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Claim No End" id="clmNoEnd" name="clmNoEnd" class="w100p"  /></p>
                            </div>
                        </td>
                        <th scope="row">Repayment Status</th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="refundStus" name="refundStus">
                                <option value="1">Not due</option>
                                <option value="2">Due but not repaid yet</option>
                                <option value="3">Repaid</option>
                                <option value="4">Pending Approval</option>
                                <option value="5">Draft</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Request Date</th>
                        <td>
                            <div class="date_set w100p">
                                <p><input type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" id="reqStartDt" name="reqStartDt"/></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" id="reqEndDt" name="reqEndDt"/></p>
                            </div>
                        </td>
                        <th scope="row">Approval Date</th>
                        <td>
                            <div class="date_set w100p">
                                <p><input type="text" title="Approval Start Date" placeholder="DD/MM/YYYY" class="j_date" id="appStartDt" name="appStartDt"/></p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p><input type="text" title="Approval End Date" placeholder="DD/MM/YYYY" class="j_date" id="appEndDt" name="appEndDt"/></p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </section>

    <section class="search_result">
        <article id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></article>
    </section>

</section><!-- content end -->

<!-- ********************************************************************************************************************************* -->
<!-- ******************************************************** ADVANCE REQUEST ******************************************************** -->
<!-- ********************************************************************************************************************************* -->

<div class="popup_wrap2" id="advReqPop" style="display: none;">

    <header class="pop_header">
        <h1>New Advance Request</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="advReqClose_btn"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body2">
        <section class="search_table">
            <form action="#" method="post" enctype="multipart/form-data" id="advReqForm">
                <input type="hidden" id="createUserId" name="createUserId" />
                <input type="hidden" id="costCenterName" name="costCenterName" />
                <input type="hidden" id="bankId" name="bankId" value="3"/>
                <input type="hidden" id="clmNo" name="clmNo" />
                <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" />

                <ul class="right_btns mb10">
                    <!--
                    <li><p class="btn_blue2"><a href="javascript:fn_saveRequest('D');" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
                    <li><p class="btn_blue2"><a href="javascript:fn_saveRequest('S');" id="requestSubmit_btn"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
                    -->
                    <li><p class="btn_blue2"><a href="javascript:fn_saveRequest('D');" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
                    <li><p class="btn_blue2"><a href="javascript:fn_saveRequest('A');" id="requestSubmit_btn"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
                </ul>

                <table class="type1">
                    <caption>Advance Request General Details</caption>
                    <colgroup>
                        <col style="width:200px" />
                        <col style="width:*" />
                        <col style="width:200px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr id="reqEditClmNo" style="display: none;">
                            <th scope="row">Claim No</th>
                            <td colspan="3">
                                <span id="reqDraftClaimNo"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Advance Type</th>
                            <td>
                                <select class="readonly w100p" id="reqAdvType" name="reqAdvType">
                                    <option value="1">Staff Travel Expenses</option>
                                    <option value="2">Staff Travel Expenses - Repayment</option>
                                </select>
                            </td>
                            <th scope="row">Entry Date</th>
                            <td>
                                <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p" id="keyDate" name="keyDate" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="webInvoice.costCenter" /><span class="must">*</span></th>
                            <td>
                                <input type="text" title="" placeholder="Cost Center Code" class="" id="costCenterCode" name="costCenterCode" value="${costCentr}" readonly />
                                <a href="#" class="search_btn" id="reqCostCenter_search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                            </td>
                            <th scope="row">Create User ID</th>
                            <td>
                                <input type="text" title="" placeholder="Requestor ID" class="w100p" id="createUsername" name="createUsername" readonly/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Payee Code<span class="must">*</span></th>
                            <td>
                                <input type="text" title="" placeholder="" class="w100p" id="payeeCode" name="payeeCode" readonly/>
                                <!--
                                <a href="#" class="search_btn" id="reqPayee_search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                                -->
                            </td>
                            <th scope="row">Payee Name</th>
                            <td>
                                <input type="text" title="" placeholder="" class="w100p" id="payeeName" name="payeeName" value="${name}" readonly/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Bank</th>
                            <td>
                                <input type="text" title="Bank Name" placeholder="Bank Name" class="w100p" id="bankName" name="bankName" value="CIMB BANK BHD" readonly/>
                                <!-- <input type="text" title="Bank Name" placeholder="Bank Name" class="w100p" id="bankName" name="bankName" value="${bankId}" readonly/> -->
                            </td>
                            <th scope="row">Bank Account</th>
                            <td>
                                <input type="text" title="Bank Account No" placeholder="Bank Account No" class="w100p" id="bankAccNo" name="bankAccNo" maxlength="10"
                                onKeypress="return event.charCode >= 48 && event.charCode <= 57"/>
                                <!-- <input type="text" title="Bank Account No" placeholder="Bank Account No" class="w100p" id="bankAccNo" name="bankAccNo" value="${bankAccNo}" readonly/> -->
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Travel Advance Division -->

                <div id="trvAdv" style="display: none;">
                    <table class="type1">
                        <caption>New Advance Request</caption>
                        <colgroup>
                            <col style="width:200px" />
                            <col style="width:*" />
                            <col style="width:130px" />
                        </colgroup>

                        <tr>
                            <th scope="row">Location<span class="must">*</span></th>
                            <td colspan="2">
                                <div class="date_set w100p">
                                    <p>
                                        <input type="text" title="Location From" placeholder="From" class="w100p" id="locationFrom" name="locationFrom" />
                                    </p>
                                    <span><spring:message code="webInvoice.to" /></span>
                                    <p>
                                        <input type="text" title="Location To" placeholder="To" class="w100p" id="locationTo" name="locationTo" />
                                    </p>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Travel Period<span class="must">*</span></th>
                            <td>
                                <div class="date_set w100p">
                                    <p>
                                        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="trvPeriodFr" name="trvPeriodFr" onChange="fn_trvPeriod('F')" />
                                    </p>
                                    <span><spring:message code="webInvoice.to" /></span>
                                    <p>
                                        <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="trvPeriodTo" name="trvPeriodTo" onChange="fn_trvPeriod('T')" />
                                    </p>
                                </div>
                            </td>
                            <td>
                                <input type="text" placeholder="No. of Days" style="width:80px" id="daysCount" name="daysCount" readonly />
                                <span style="line-height:20px; text-align: center;">Days</span>
                            </td>
                        </tr>
                        <!-- <tr>
                            <th scope="row">Purpose of Travel<span class="must">*</span></th>
                            <td colspan="2">
                                <textarea id="trvPurp" name="trvPurp" placeholder="Enter up to 200 characters" maxlength="200" style="resize:none"></textarea>
                            </td>
                        </tr> -->
                        <tr>
                            <th scope="row">Remarks<span class="must">*</span></th>
                            <td colspan="2">
                                <textarea id="trvReqRem" name="trvReqRem" placeholder="Enter up to 200 characters" maxlength="200" style="resize:none"></textarea>
                            </td>
                        </tr>
                    </table>

                    <article class="tap_block">
                        <aside class="title_line">
                            <b style="color:#25527c;">Travel Advance Calculation</b>
                        </aside>
                        <table class="type1">
                            <caption>New Advance Request</caption>
                            <colgroup>
                                <col style="width:200px" />
                                <col style="width:*" />
                                <col style="width:100px" />
                            </colgroup>
                            <tr>
                                <th scope="row">Accommodation</th>
                                <td colspan="2">
                                    <span style="line-height:20px; text-align: center;">RM</span>
                                    <input type="text" title="Accommodation Amount" placeholder="Accommodation Amount" id="accmdtAmt" name="accmdtAmt" style="200px"/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Estimated Mileage (km)</th>
                                <td colspan="2">
                                    <span style="line-height:20px; text-align: center;">RM</span>
                                    <input type="text" title="Mileage Amount" placeholder="Mileage Amount 50%" id="mileageAmt" name="mileageAmt" style="200px" readonly/>
                                    <input type="text" title="mileage" placeholder="Mileage (km)" id="mileage" name="mileage" style="200px"/>
                                    <span style="line-height:20px; text-align: center;">km</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Toll (Travel by Car)</th>
                                <td colspan="2">
                                    <span style="line-height:20px; text-align: center;">RM</span>
                                    <input type="text" title="Toll Amount" placeholder="Toll Amount" id="tollAmt" name="tollAmt" style="200px"/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Other Transportation</th>
                                <td colspan="2">
                                    <span style="line-height:20px; text-align: center;">RM</span>
                                    <input type="text" title="Other Transportation Amount" placeholder="Other Transportation Amount" id="othTrsptAmt" name="othTrsptAmt" style="200px"/>
                                    <input type="text" title="Mode of Transportation" placeholder="Mode of Transportation" id="trsptMode" name="trsptMode" style="200px"/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><b>Total Travel Advance (RM)</b></th>
                                <td colspan="2">
                                    <span style="line-height:20px; text-align: center;">RM</span>
                                    <input type="text" title="Grand Total" placeholder="Grand Total" id="reqTotAmt" name="reqTotAmt" style="200px" readonly/>
                                </td>
                            </tr>
                        </table>
                    </article>
                </div>

                <!-- Travel Advance Division -->

                <table class="type1">
                    <caption>New Advance Request</caption>
                    <colgroup>
                        <col style="width:200px" />
                        <col style="width:*" />
                        <col style="width:100px" />
                    </colgroup>
                    <tr>
                        <th scope="row">Attachment<span class="must">*</span></th>
                        <td>
                            <div class="auto_file">
                                <input type="file" id="fileSelector" name="fileSelector" title="file add" accept=".rar, .zip" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Repayment Due Date</th>
                        <td colspan="2">
                            <input type="text" title="Refund Date" placeholder="Refund Date" id="refdDate" name="refdDate" style="200px" readonly/>
                        </td>
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
        <h1>Advance Repayment</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#;" id="advRefClose_btn"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body2">
        <section class="search_table">
            <form action="#" method="post" enctype="multipart/form-data" id="advRepayForm">
                <input type="hidden" id="createUserId" name="createUserId" />
                <input type="hidden" id="costCenterName" name="costCenterName" />
                <input type="hidden" id="bankId" name="bankId" />
                <input type="hidden" id="refClmNo" name="refClmNo" />
                <input type="hidden" id="refAtchFileGrpId" name="refAtchFileGrpId" />

                <ul class="right_btns mb10">
                    <li><p class="btn_blue2"><a href="javascript:fn_saveRefund('D');" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
                    <li><p class="btn_blue2"><a href="javascript:fn_saveRefund('S');" id="repaySubmit_btn"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
                </ul>

                <table class="type1">
                    <caption>Advance Repayment General Details</caption>
                    <colgroup>
                        <col style="width:200px" />
                        <col style="width:*" />
                        <col style="width:200px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr id="repayEditClmNo">
                            <th scope="row">Claim No</th>
                            <td colspan="3">
                                <span id="repayDraftClaimNo"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Advance Type</th>
                            <td>
                                <select class="readonly w100p" id="refAdvType" name="refAdvType">
                                    <option value="1">Staff Travel Expenses</option>
                                    <option value="2">Staff Travel Expenses - Repayment</option>
                                </select>
                            </td>
                            <th scope="row">Entry Date</th>
                            <td>
                                <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p" id="refKeyDate" name="refKeyDate" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="webInvoice.costCenter" /><span class="must">*</span></th>
                            <td>
                                <input type="text" title="" placeholder="Cost Center Code" class="w100p" id="refCostCenterCode" name="refCostCenterCode" value="${costCentr}" readonly />
                            </td>
                            <th scope="row">Create User ID</th>
                            <td>
                                <input type="text" title="" placeholder="Requestor ID" class="w100p" id="refCreateUsername" name="refCreateUsername" readonly/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Payee Code<span class="must">*</span></th>
                            <td>
                                <input type="text" title="" placeholder="" class="w100p" id="refPayeeCode" name="refPayeeCode" readonly/>
                            </td>
                            <th scope="row">Payee Name</th>
                            <td>
                                <input type="text" title="" placeholder="" class="w100p" id="refPayeeName" name="refPayeeName" value="${name}" readonly/>
                            </td>
                        </tr>
                        <tr id="repayBank">
                            <th scope="row">Bank</th>
                            <td>
                                <input type="text" title="Bank Name" placeholder="Bank Name" class="w100p" id="refBankName" name="refBankName" value="${bankId}" readonly/>
                            </td>
                            <th scope="row">Bank Account</th>
                            <td>
                                <input type="text" title="Bank Account No" placeholder="Bank Account No" class="w100p" id="refBankAccNo" name="refBankAccNo" value="${bankAccNo}" readonly/>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <table class="type1" id="trvAdvRepay" style="display: none;">
                    <caption>Advance Repayment</caption>
                    <colgroup>
                        <col style="width:200px" />
                        <col style="width:*" />
                        <col style="width:100px" />
                    </colgroup>
                    <tr>
                        <th scope="row">Claim No for Advance Request</th>
                        <td colspan="2">
                            <input type="text" title="Advance Request Claim No" placeholder="Advance Request Claim No" id="advReqClmNo" name="advReqClmNo" style="200px" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Amount Repaid (RM)</th>
                        <td colspan="2">
                            <input type="text" title="Amount Repaid (RM)" placeholder="Amount Repaid (RM)" id="trvAdvRepayAmt" name="trvAdvRepayAmt" style="200px" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Repayment Due Date</th>
                        <td colspan="2">
                            <input type="text" title="Repayment Date" placeholder="Repayment Date" id="trvAdvRepayDate" name="trvAdvRepayDate" class="j_date" style="200px" />
                        </td>
                    </tr>
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
                            <td colspan="2">
                                <textarea id="trvRepayRem" name="trvRepayRem" placeholder="Enter up to 200 characters" maxlength="200" style="resize:none"></textarea>
                            </td>
                        </tr>
                    <tr>
                        <th scope="row">Attachment<span class="must">*</span></th>
                        <td colspan="2">
                            <div class="auto_file w100p">
                                <input type="file" id="trvAdvFileSelector" name="trvAdvFileSelector" title="file add" accept=".rar, .zip" />
                            </div>
                        </td>
                    </tr>
                </table>
            </form>
        </section>
    </section>
</div>

<!-- ********************************************************************************************************************************************* -->
<!-- ******************************************************** ADVANCE REQUEST MESSAGE POP ******************************************************** -->
<!-- ********************************************************************************************************************************************* -->

<div class="popup_wrap size_small" id="advReqMsgPop" style="display: none;">
    <header class="pop_header">
        <h1 id="advReqMsgPopHeader">Submission of Request</h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#">
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
                            By checking this box, you acknowledge that you have read and understand all the policies and rules with respect to advance to staff, and agree to abide by all the policies and rules.
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

<!-- ********************************************************************************************************************************************** -->
<!-- ******************************************************** ADVANCE REQUEST APPROVAL POP ******************************************************** -->
<!-- ********************************************************************************************************************************************** -->

<div class="popup_wrap size_mid2" id="appvLinePop" style="display: none;">
    <header class="pop_header">
        <h1><spring:message code="approveLine.title" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <section class="search_result">
            <ul class="right_btns">
                <li><p class="btn_grid"><a href="javascript:fn_appvLineGridDeleteRow()" id="lineDel_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
            </ul>

            <article class="grid_wrap" id="approveLine_grid_wrap">
            </article>

            <ul class="center_btns" id="requestAppvLine" style="display: none;">
                <li><p class="btn_blue2"><a href="javascript:fn_saveRequest('S')" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
            </ul>

            <ul class="center_btns" id="repaymentAppvLine" style="display: none;">
                <li><p class="btn_blue2"><a href="javascript:fn_submitRef()" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
            </ul>

        </section>
    </section>
</div>