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
    console.log("staffAdvanceApproveViewPop");
    var myGridID;
    var myGridData = $.parseJSON('${appvInfoAndItems}');
    var attachList = null;

    $(document).ready(function () {
        //myGridID = AUIGrid.create("#approveView_grid_wrap", myColumnLayout, myGridPros);

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

        if(myGridData[0].advType == 1) {
            //$("#trvAdv").css("display", "none");
            $("#advanceRefDiv").css("display", "none");
            //$("#advanceRefDiv").hide();

            $("#viewTrvLoc").text(myGridData[0].advLocFr + " To " + myGridData[0].advLocTo);
            $("#viewTrvPeriod").text(myGridData[0].advPrdFr + " To " + myGridData[0].advPrdTo + " (" + myGridData[0].datediff + " Days)" );
            $("#viewTrvDays").text();
            $("#viewTrvRem").text(myGridData[0].expDesc);

            $("#viewTrvAccAmt").text("RM" + myGridData[0].accAmt.trim());
            if(myGridData[0].milAmt.trim() != "0.00") {
                $("#viewTrvMil").text("RM" + myGridData[0].milAmt.trim() + " - " + myGridData[0].milDist + "km");
            } else {
                $("#viewTrvMil").text("RM" + myGridData[0].milAmt.trim());
            }
            $("#viewTrvTollAmt").text("RM" + myGridData[0].tollAmt.trim());
            if(myGridData[0].othAmt.trim() != "0.00") {
                $("#viewTrvOth").text("RM" + myGridData[0].othAmt.trim() + " - " + myGridData[0].othRem);
            } else {
                $("#viewTrvOth").text("RM" + myGridData[0].othAmt.trim());
            }

            var trvTotAmt = (parseFloat(myGridData[0].accAmt.trim().replace(",", "")) + parseFloat(myGridData[0].milAmt.trim().replace(",", "")) + parseFloat(myGridData[0].tollAmt.trim().replace(",", "")) + parseFloat(myGridData[0].othAmt.trim().replace(",", ""))).toFixed(2);
            //$("#viewTrvTotAmt").text("RM" + trvTotAmt.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
            $("#viewTrvTotAmt").text("RM" + myGridData[0].clmAmt.trim())
            $("#viewTrvRefdDt").text(myGridData[0].advRefdDt);

        } else if(myGridData[0].advType == 2) {
            $("#trvAdvGen").css("display", "none");
            $("#trvAdvDtl").css("display", "none");
            $("#reqRefdDate").css("display", "none");

            $("#refTrvPeriod").text(myGridData[0].refTrvPrdFr + " To " + myGridData[0].refTrvPrdTo);
            $("#refAdvReqClmNo").text(myGridData[0].advRefdClmNo);
            $("#refAmtRepay").text(myGridData[0].repayAmt.toFixed(2));
            $("#refRepayDate").text(myGridData[0].advRefdDt);
            $("#refBankInRefNo").text(myGridData[0].invcNo);
            $("#trvRefRem").text(myGridData[0].expDesc);
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
                    console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                            + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                    window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                        + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
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
                            <col style="width:100px" />
                        </colgroup>

                        <tr>
                            <th scope="row">Location</th>
                            <td colspan="2">
                                <span id="viewTrvLoc"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Travel Period</th>
                            <td>
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
                            <td colspan="2">
                                <span id="viewTrvRem"></span>
                            </td>
                        </tr>
                    </table>

                    <article class="tap_block" id="trvAdvDtl">
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
                                    <span id="viewTrvAccAmt"></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Estimated Mileage (km)</th>
                                <td colspan="2">
                                    <span id="viewTrvMil"></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Toll (Travel by Car)</th>
                                <td colspan="2">
                                    <span id="viewTrvTollAmt"></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Other Transportation</th>
                                <td colspan="2">
                                    <span id="viewTrvOth"></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><b>Total Travel Advance (RM)</b></th>
                                <td colspan="2">
                                    <span id="viewTrvTotAmt"></span>
                                </td>
                            </tr>
                        </table>
                    </article>
                </div>

                <div id="advanceRefDiv">
                    <table class="type1">
                        <caption>Advance Refund</caption>
                        <colgroup>
                            <col style="width:200px" />
                            <col style="width:*" />
                            <col style="width:100px" />
                        </colgroup>

                        <tr>
                            <th scope="row">Travel Period</th>
                            <td colspan="2">
                                <span id="refTrvPeriod"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Claim No for Advance Request</th>
                            <td colspan="2">
                                <span id="refAdvReqClmNo"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Amount Repaid (RM)</th>
                            <td colspan="2">
                                <span id="refAmtRepay"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Repayment Due Date</th>
                            <td colspan="2">
                                <span id="refRepayDate"></span>
                            </td>
                        </tr>
                        <!--
                        <tr>
                            <th scope="row">Bank-in Advice Ref Note</th>
                            <td colspan="2">
                                <span id="refBankInRefNo"></span>
                            </td>
                        </tr>
                         -->
                        <tr>
                            <th scope="row">Remarks</th>
                            <td colspan="2">
                                <span id="trvRefRem"></span>
                            </td>
                        </tr>
                    </table>
                </div>

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
                        <td colspan="2" id="attachTd">
                            <div class="auto_file2 auto_file3">
                                <input type="file" title="file add" />
                            </div>
                            <!-- <div class="auto_file w100p">
                                <input type="file" id="fileSelector" name="fileSelector" title="file add" accept=".rar, .zip" />
                            </div> -->
                        </td>
                    </tr>
                    <tr id="reqRefdDate">
                        <th scope="row">Repayment Due Date</th>
                        <td colspan="2">
                            <span id="viewTrvRefdDt"></span>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="approveView.approveStatus" /></th>
                        <td colspan="2" style="height:60px" id="viewAppvStus">${appvPrcssStus}</td>
                    </tr>
                    <tr id="rejectReasonRow">
                        <th scope="row">Reject Reason</th>
                        <td colspan="3">${rejctResn}</td>
                    </tr>
                </table>
            </form>
        </section>

        <ul class="center_btns" id="appvBtns">
            <li><p class="btn_blue2"><a href="#" id="pApprove_btn"><spring:message code="invoiceApprove.title" /></a></p></li>
            <li><p class="btn_blue2"><a href="#" id="pReject_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
        </ul>

    </section><!-- pop_body end -->

</div><!-- popup_wrap end -->