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
</style>
<script type="text/javascript">
    console.log("vendorAdvanceApproveViewPop");
    var myGridID;
    var myGridData = $.parseJSON('${appvInfoAndItems}');
    var attachList = null;
    var myColumnLayout = [ {
        dataField : "clmUn",
        headerText : '<spring:message code="newWebInvoice.seq" />'
    }, {
        dataField : "clmSeq",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "expGrp",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "expGrp",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "appvItmSeq",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "glAccCode",
        headerText : '<spring:message code="expense.GLAccount" />'
    }, {
        dataField : "glAccCodeName",
        headerText : '<spring:message code="newWebInvoice.glAccountName" />',
        style : "aui-grid-user-custom-left"
    }, {
        dataField : "budgetCode",
        headerText : '<spring:message code="approveView.budget" />'
    }, {
        dataField : "budgetCodeName",
        headerText : '<spring:message code="approveView.budgetName" />',
        style : "aui-grid-user-custom-left"
    },{
        dataField : "invcDt",
        headerText : "Invoice Date",
        dataType : "date",
        formatString : "dd/mm/yyyy",
        editRenderer : {
            type : "CalendarRenderer",
            openDirectly : true,
            onlyCalendar : true,
            shwoExtraDays : true,
            titles : [gridMsg["sys.info.grid.calendar.titles.sun"], gridMsg["sys.info.grid.calendar.titles.mon"], gridMsg["sys.info.grid.calendar.titles.tue"], gridMsg["sys.info.grid.calendar.titles.wed"], gridMsg["sys.info.grid.calendar.titles.thur"], gridMsg["sys.info.grid.calendar.titles.fri"], gridMsg["sys.info.grid.calendar.titles.sat"]],
            formatYearString : gridMsg["sys.info.grid.calendar.formatYearString"],
            formatMonthString : gridMsg["sys.info.grid.calendar.formatMonthString"],
            monthTitleString : gridMsg["sys.info.grid.calendar.monthTitleString"]
        },
        width : "10%"
    }, {
        dataField : "invcNo",
        headerText : "Invoice No.",
        width : "13%"
    }, {
        dataField : "memAccName",
        headerText : "Supplier Name",
        width : "15%"
    },{
        dataField : "taxName",
        visible : false // Color 칼럼은 숨긴채 출력시킴
    }, {
        dataField : "taxCode",
        headerText : '<spring:message code="newWebInvoice.taxCode" />'
    }, {
        dataField : "cur",
        headerText : '<spring:message code="newWebInvoice.cur" />'
    },{
        dataField : "netAmt",
        headerText : '<spring:message code="newWebInvoice.totalAmount" />',
        style : "aui-grid-user-custom-right",
        dataType: "numeric",
        formatString : "#,##0.00",
        editable : false//,
        /*expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
            // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
            return (item.netAmt + item.taxAmt + item.taxNonClmAmt);
        }*/
    }, {
        dataField : "expDesc",
        headerText : '<spring:message code="newWebInvoice.description" />',
        style : "aui-grid-user-custom-left",
        width : 200
    }
    ];

    var myGridPros = {
    	    // 페이징 사용
    	    usePaging : true,
    	    // 한 화면에 출력되는 행 개수 20(기본값:20)
    	    pageRowCount : 20,
    	    headerHeight : 40,
    	    height : 160,
    	    // 셀 선택모드 (기본값: singleCell)
    	    selectionMode : "multipleCells"
    	};

    	var mGridColumnLayout = [ {
    	    dataField : "clamUn",
    	    headerText : '<spring:message code="newWebInvoice.seq" />'
    	}, {
    	    dataField : "expGrp",
    	    visible : false // Color 칼럼은 숨긴채 출력시킴
    	}, {
    	    dataField : "clmSeq",
    	    visible : false // Color 칼럼은 숨긴채 출력시킴
    	}, {
    	    dataField : "expType",
    	    visible : false // Color 칼럼은 숨긴채 출력시킴
    	}, {
    	    dataField : "expTypeName",
    	    headerText : '<spring:message code="pettyCashNewExp.expTypeBrName" />',
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
    	    dataField : "taxCode",
    	    visible : false // Color 칼럼은 숨긴채 출력시킴
    	}, {
    	    dataField : "taxName",
    	    headerText : '<spring:message code="newWebInvoice.taxCode" />'
    	}, {
    	    dataField : "taxRate",
    	    dataType: "numeric",
    	    visible : false // Color 칼럼은 숨긴채 출력시킴
    	}, {
    	    dataField : "cur",
    	    headerText : '<spring:message code="newWebInvoice.cur" />',
    	    editable : false
    	}, {
    	    dataField : "totAmt",
    	    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    	    style : "aui-grid-user-custom-right",
    	    dataType: "numeric",
    	    formatString : "#,##0.00",
    	    /*expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
    	        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
    	        return (item.gstBeforAmt + item.gstAmt + item.taxNonClmAmt);
    	    }*/
    	}, {
    	    dataField : "atchFileGrpId",
    	    visible : false // Color 칼럼은 숨긴채 출력시킴
    	}, {
    	    dataField : "cnt",
    	    visible : false
    	}, {
    	    dataField : "advRefdMode",
    	    visible : false
    	}, {
    		dataField : "advRefdRef",
            visible : false
    	}
    	];

    $(document).ready(function () {
        myGridID = AUIGrid.create("#approveView_grid_wrap", myColumnLayout, myGridPros);

        $("#viewClmNo").text(myGridData[0].clmNo);
        $("#viewClmType").text(myGridData[0].clmType);
        $("#viewAdvType").text(myGridData[0].advTypeDesc);
        $("#viewAdvEntryDt").text(myGridData[0].reqstDt);
        $("#viewAdvCostCenter").text(myGridData[0].costCentr + " - " + myGridData[0].costCentrName);
        $("#viewAdvCrtUser").text(myGridData[0].reqstUserId);
        $("#viewAdvPayeeCode").text(myGridData[0].memAccId);
        $("#viewAdvPayeeNm").text(myGridData[0].memAccName);
        $("#viewAdvBankNm").text(myGridData[0].bank);
        $("#viewAdvBankAccNo").text(myGridData[0].bankAccNo);

        if(myGridData[0].advType == 3 || myGridData[0].advType == 5) {
            $("#approveView_grid_wrap").css("display","none");
            $("#viewTrvPeriod").text(myGridData[0].advPrdFr + " To " + myGridData[0].advPrdTo + " (" + myGridData[0].datediff + " Days)" );
            $("#viewTrvDays").text();
            $("#viewTrvRem").text(myGridData[0].rem);
            $("#viewTrvTotAmt").text(myGridData[0].cur + " "+ AUIGrid.formatNumber(myGridData[0].repayAmt, "#,##0.00"));
            $("#viewTrvTotExp").text(myGridData[0].cur + " "+ AUIGrid.formatNumber(myGridData[0].totAmt, "#,##0.00"));
            $("#viewTrvBalAmt").val(myGridData[0].repayAmt - AUIGrid.formatNumber(myGridData[0].totAmt));
            $("#viewTrvBalAmt").text(myGridData[0].cur + " "+ AUIGrid.formatNumber($("#viewTrvBalAmt").val(), "#,##0.00"));
            if(myGridData[0].advType == 5)
            {
            	$("#trvPeriod").hide();
            }

            fn_setGridData(myGridID, myGridData);

            if(myGridData[0].appvPrcssStus == "A" || myGridData[0].appvPrcssStus == "J"){
	            Common.ajax("GET", "/eAccounting/webInvoice/getFinalApprAct.do", {appvPrcssNo: myGridData[0].appvPrcssNo}, function(result) {
	                console.log(result);

	                $("#finApprAct").show();
	                $("#viewFinAppr").text(result.finalAppr);
	            });
            }
        } else if(myGridData[0].advType == 4 || myGridData[0].advType == 6) {

            $("#refTrvPeriod").text(myGridData[0].refTrvPrdFr + " To " + myGridData[0].refTrvPrdTo);
            $("#refAdvReqClmNo").text(myGridData[0].advRefdClmNo);
            $("#refRepayDate").text(myGridData[0].advRefdDt);
            $("#refBankInRefNo").text(myGridData[0].invcNo);
            $("#viewTrvTotAmt").text(myGridData[0].cur + " " + AUIGrid.formatNumber(myGridData[0].repayAmt, "#,##0.00"));
            $("#viewTrvRem").text(myGridData[0].rem);
            $("#viewTrvPeriod").text(myGridData[0].advPrdFr + " To " + myGridData[0].advPrdTo + " (" + myGridData[0].datediff + " Days)" );
            $("#viewTrvDays").text();
            $("#viewTrvTotExp").text(myGridData[0].cur + " "+ AUIGrid.formatNumber(myGridData[0].totAmt, "#,##0.00"));
            $("#viewTrvBalAmt").val(myGridData[0].repayAmt - AUIGrid.formatNumber(myGridData[0].totAmt));
            $("#viewTrvBalAmt").text(myGridData[0].cur + " "+ AUIGrid.formatNumber($("#viewTrvBalAmt").val(), "#,##0.00"));
            $("#viewTrvRefundMode option[value=" + myGridData[0].advRefdMode + "]").attr('selected', true);
            $("#viewTrvRefundMode").attr("disabled", true);
            $("#viewTrvBankRef").text(myGridData[0].advRefdRef);
            fn_setGridData(myGridID, myGridData);
        }

        $("#attachTd").html("");
        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='1'/></div>");
        $(".input_text[name='1']").val(myGridData[0].atchFileName);
        $(".input_text").dblclick(function() {
            var data = {
                    atchFileGrpId : myGridData[0].atchFileGrpId,
                    atchFileId : myGridData[0].atchFileId
            };

            Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                console.log(result);
                if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                    // TODO View
                    var fileSubPath = result.fileSubPath;
                    fileSubPath = fileSubPath.replace('\', '/'');
                    console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                    window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                } else {
                    var fileSubPath = result.fileSubPath;
                    fileSubPath = fileSubPath.replace('\', '/'');
                    console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                    window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                }
            });
        });

        //$("#fileListPop_btn").click(fn_fileListPop);

        // 2018-07-03 - LaiKW - Added looping calculation of total - Start
        var totalAmt = 0;
        for(var i = 0; i < myGridData.length; i++  ) {
            totalAmt += myGridData[i].appvAmt;
        }
        $("#viewAppvAmt").text(totalAmt);
        // 2018-07-03 - LaiKW - Added looping calculation of total - End

        $("#viewAppvAmt").text(AUIGrid.formatNumber(totalAmt, "#,##0.00"));

        $("#pApprove_btn").click(fn_approvalSubmit);
        $("#pReject_btn").click(fn_RejectSubmit);


        if(myGridData[0].appvPrcssStus == "A" || myGridData[0].appvPrcssStus == "J") {
            $("#appvBtns").hide();
            $("#pApprove_btn").hide();
            $("#pReject_btn").hide();

            $("#finApprAct").show();

            if(myGridData[0].appvPrcssStus == "A") {
                $("#rejectReasonRow").css("display", "none");
            }

            Common.ajax("GET", "/eAccounting/webInvoice/getFinalApprAct.do", {appvPrcssNo: myGridData[0].appvPrcssNo}, function(result) {
                console.log(result);

                $("#viewFinAppr").text(result.finalAppr);
            });
        } else {
            $("#finApprAct").hide();
            if("${type}" == "view") {
                $("#appvBtns").hide();
            }
        }
    });

    function fn_approvalSubmit() {
        var rows = AUIGrid.getRowIndexesByValue(invoAprveGridID, "clmNo", [$("#viewClmNo").text()]);
        // isActive
        AUIGrid.setCellValue(invoAprveGridID, rows, "isActive", "Active");
        fn_approveRegistPop();
    }

    function fn_RejectSubmit() {
        var rows = AUIGrid.getRowIndexesByValue(invoAprveGridID, "clmNo", [$("#viewClmNo").text()]);
        AUIGrid.setCellValue(invoAprveGridID, rows, "isActive", "Active");
        fn_rejectRegistPop();
    }

    function fn_atchViewDown(fileGrpId, fileId) {
        var data = {
                atchFileGrpId : fileGrpId,
                atchFileId : fileId
        };
        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
            console.log(result);
            if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                // TODO View
                var fileSubPath = result.fileSubPath;
                fileSubPath = fileSubPath.replace('\', '/'');
                console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            } else {
                var fileSubPath = result.fileSubPath;
                fileSubPath = fileSubPath.replace('\', '/'');
                console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                        + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            }
        });
    }
</script>

<!-- ************************************************************* LAYOUT ************************************************************* -->

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
    <h1><spring:message code="approveView.title" /></h1>
    <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
    </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->

        <section class="search_table"><!-- search_table start -->
            <form action="#" method="post" id="form_approveView">
                <input type="hidden" id="viewMemAccId">

                <table class="type1"><!-- table start -->
	                <caption><spring:message code="webInvoice.table" /></caption>
	                <colgroup>
	                    <col style="width:200px" />
	                    <col style="width:*" />
	                    <col style="width:200px" />
	                    <col style="width:*" />
	                </colgroup>

	                <tbody>
	                    <tr>
	                        <th>Claim No</th>
	                        <td>
	                            <span id="viewClmNo"></span>
	                        </td>
	                        <th>Claim Type</th>
	                        <td>
	                            <span id="viewClmType"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row">Advance Type</th>
	                        <td>
	                            <span id="viewAdvType"></span>
	                        </td>
	                        <th scope="row">Entry Date</th>
	                        <td>
	                            <span id="viewAdvEntryDt"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	                        <td>
	                            <span id="viewAdvCostCenter"></span>
	                        </td>
	                        <th scope="row">Create User ID</th>
	                        <td>
	                            <span id="viewAdvCrtUser"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row">Payee Code</th>
	                        <td>
	                            <span id="viewAdvPayeeCode"></span>
	                        </td>
	                        <th scope="row">Payee Name</th>
	                        <td>
	                            <span id="viewAdvPayeeNm"></span>
	                        </td>
	                    </tr>
	                    <tr id="appvGenBankRow">
	                        <th scope="row">Bank</th>
	                        <td>
	                            <span id="viewAdvBankNm"></span>
	                        </td>
	                        <th scope="row">Bank Account</th>
	                        <td>
	                            <span id="viewAdvBankAccNo"></span>
	                        </td>
	                    </tr>
	                </tbody>
                </table>

                <!-- Travel Advance Division -->

                <div id="trvAdv">
                    <table class="type1" id="trvAdvGen">
                        <caption>New Advance Request</caption>
                        <colgroup>
                            <col style="width:200px" />
	                        <col style="width:*" />
	                        <col style="width:200px" />
                        </colgroup>

                        <tr id="trvPeriod">
                            <th scope="row">Event Date</th>
                            <td colspan=4>
                                <span id="viewTrvPeriod"></span>
                            </td>
                        </tr>
                        <!-- <tr>
                            <th scope="row">Purpose of Travel</th>
                            <td colspan="2">
                                <textarea id="trvPurp" name="trvPurp" placeholder="Enter up to 200 characters" maxlength="200" style="resize:none"></textarea>
                            </td>
                        </tr> -->
                        <tr>
                            <th scope="row">Remarks</th>
                            <td colspan="4">
                                <span id="viewTrvRem"></span>
                            </td>
                        </tr>
                        <tr>
                                <th scope="row">Advance Amount</th>
                                <td colspan="4">
                                    <span id="viewTrvTotAmt"></span>
                                </td>
                        </tr>
                        <tr>
                                <th scope="row">Total Expenses</th>
                                <td colspan="4">
                                    <span id="viewTrvTotExp"></span>
                                </td>
                        </tr>
                        <tr>
                                <th scope="row">Balance Amount</th>
                                <td colspan="4">
                                    <span id="viewTrvBalAmt"></span>
                                </td>
                        </tr>
                        <tr>
                                <th scope="row">Refund Mode</th>
                                <td colspan="4">
                                    <select class="readonly w100p" id="viewTrvRefundMode">
	                                    <option value="CASH">Cash</option>
	                                    <option value="OTRX">Online</option>
                                    </select>
                                </td>
                        </tr>
                        <tr>
                                <th scope="row">Bank Reference</th>
                                <td colspan="4">
                                    <span id="viewTrvBankRef"></span>
                                </td>
                        </tr>
                    </table>

                <!-- Travel Advance Division -->

                <table class="type1" id="appvReqGeneral2">
                    <caption>New Advance Request</caption>
                    <colgroup>
                        <col style="width:200px" />
                        <col style="width:*" />
                        <col style="width:100px" />
                    </colgroup>
                    <tr>
                        <th scope="row">Attachment</th>
                        <td colspan="4" id="attachTd">
                            <div class="auto_file2 auto_file3">
                                <input type="file" title="file add" />
                            </div>
                            <!-- <div class="auto_file w100p">
                                <input type="file" id="fileSelector" name="fileSelector" title="file add" accept=".rar, .zip" />
                            </div> -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="approveView.approveStatus" /></th>
                        <td colspan="4" style="height:60px" id="viewAppvStus">${appvPrcssStus}</td>
                    </tr>
                    <tr id="rejectReasonRow" style=display:none>
                        <th scope="row">Reject Reason</th>
                        <td colspan="4">${rejctResn}</td>
                    </tr>
                    <tr id="finApprAct">
                        <th scope="row">Final Approver</th>
                        <td colspan="4" id="viewFinAppr"></td>
                    </tr>
                </table>
            </form>
        </section>

        <article class="grid_wrap" id="approveView_grid_wrap"><!-- grid_wrap start -->
        </article><!-- grid_wrap end -->
        <ul class="center_btns" id="appvBtns">
            <li><p class="btn_blue2"><a href="#" id="pApprove_btn"><spring:message code="invoiceApprove.title" /></a></p></li>
            <li><p class="btn_blue2"><a href="#" id="pReject_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
        </ul>

    </section><!-- pop_body end -->

</div><!-- popup_wrap end -->