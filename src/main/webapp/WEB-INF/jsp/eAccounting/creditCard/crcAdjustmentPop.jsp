<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
</style>
<script  type="text/javascript">
    var clmYyyy, clmMm;
    var update = new Array();
    var remove = new Array();
    var mode = "${item.mode}";
    var authorized = "${item.apprGrp}";
    var cnt = 0;
    var fileClick = 0; // For edit purpose only

    $(document).ready(function(){
        console.log("crcAdjustmentPop.jsp")

        // Default views
        $("#sPeriod").prop("disabled", true);
        $("#sCostCenter").prop("disabled", true);
        $("#sCostCenterName").prop("disabled", true);
        $("#sCrcHolder").prop("disabled", true);
        $("#sAmt").prop("disabled", true);
        $("#rPeriod").prop("disabled", true);
        $("#rCostCenter").prop("disabled", true);
        $("#rCostCenterName").prop("disabled", true);
        $("#rCrcHolder").prop("disabled", true);
        $("#rAmt").prop("disabled", true);
        $("#adjRem").prop("disabled", true);

        // setInputFile2()
        $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Delete</a></span>");
        //$("#reqFileSelector").html("");
        //$("#reqFileSelector").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='1'/></div>");

        // Default hide Approval Buttons (Approve/Reject)
        //$("#appBtns").hide();

        // View/Approval/Edit Mode :: View Set - Start
        if("${item.mode}" != "N") {
            if("${item.mode}" == "A") {
                $("#appBtns").show();
                $("#reqBtns").hide();

            } else if("${item.mode}" == "V") {
                $("#appBtns").hide();
                $("#reqBtns").hide();

            } else if("${item.mode}" == "E") {
                $("#appBtns").hide();
                $("#reqBtns").show();
            }

            var adjItems = $.parseJSON('${adjItems}');

            $("#adjNo").val(adjItems[0].adjNo);
            $("#atchFileGrpId").val(adjItems[0].atchFileGrpId);
            $("#sCrcId_h").val(adjItems[0].sCrditCardId);
            $("#rCrcId_h").val(adjItems[0].rCrditCardId);
            $('select[name="adjType"]').find('option[value="' + adjItems[0].adjType + '"]').attr('selected', 'selected');
            $('select[name="adjType"]').prop("disabled", true);

            var adjType = adjItems[0].adjType;
            var mm;

            if(adjType == "4") {
                mm = adjItems[0].sCrcLimitAdjMm;
                if(mm.length < 2) {
                    mm = "0" + mm;
                }

                $("#sPeriod").val(mm + "/" + adjItems[0].sCrcLimitAdjYyyy);
            }

            $("#sCostCenter").val(adjItems[0].sCostCenter);
            $("#sCostCenterName").val(adjItems[0].sCostCenterName);
            $("#sCrcHolder option[value=" + adjItems[0].sCrditCardId + "]").attr('selected', 'selected');
            $("#sAmt").val(adjItems[0].sAdjAmt);

            if(adjType == "3") {
                mm = adjItems[0].rCrcLimitAdjMm;
                if(mm.length < 2) {
                    mm = "0" + mm;
                }

                $("#rPeriod").val(mm + "/" + adjItems[0].rCrcLimitAdjYyyy);
            }

            $("#rCostCenter").val(adjItems[0].rCostCenter);
            $("#rCostCenterName").val(adjItems[0].rCostCenterName);
            $("#rCrcHolder option[value=" + adjItems[0].rCrditCardId + "]").attr('selected', 'selected');
            $("#rAmt").val(adjItems[0].rAdjAmt);

            $("#adjRem").val(adjItems[0].adjRem);

            // Attachment Related Setting & Functionalities - Start
            $("#attachTd").html("");

            // Set File(s) - Start
            if("${item.mode}" == "E") {
                // Edit Mode
                $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' value='" + adjItems[0].atchFileName + "'/><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Delete</a></span></div>");
                fn_chgAdjType(adjItems[0].adjType.toString());

            } else {
                // View/Approval Mode
                $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' /></div>");
                $(".input_text").val(adjItems[0].atchFileName);
            }
            // Set File(s) - End

            // File Field action
            $(".input_text").dblclick(function() {
                var oriFileName = $(this).val();
                var fileGrpId;
                var fileId;
                for(var i = 0; i < adjItems.length; i++) {
                    if(adjItems[i].atchFileName == oriFileName) {
                        fileGrpId = adjItems[i].atchFileGrpId;
                        fileId = adjItems[i].atchFileId;
                    }
                }
                fn_atchViewDown(fileGrpId, fileId);
            });

            $("#adjForm :file").change(function() {
                var div = $(this).parents(".auto_file2");
                var oriFileName = div.find(":text").val();
                console.log(oriFileName);
                for(var i = 0; i < adjItems.length; i++) {
                    if(adjItems[i].atchFileName == oriFileName) {
                        update.push(adjItems[i].atchFileId);
                        console.log(JSON.stringify(update));
                    }
                }
                fileClick++;
            });

            $(".auto_file2 a:contains('Delete')").click(function() {
                var div = $(this).parents(".auto_file2");
                var oriFileName = div.find(":text").val();
                console.log(oriFileName);
                for(var i = 0; i < adjItems.length; i++) {
                    if(adjItems[i].atchFileName == oriFileName) {
                        remove.push(adjItems[i].atchFileId);
                        console.log(JSON.stringify(remove));
                    }
                }
                fileClick++;
            });
            // Attachment Related Setting & Functionalities - End
        } else {
            $("#appBtns").hide();
            $("#reqBtns").show();
        }
        // View/Approval/Edit Mode :: View Set - End
    });

    function fn_chgAdjType(type) {
        console.log("fn_chgAdjType :: type = " + type);

        switch(type) {
        case "0":
            // Empty Adjustment Type
            $("#adjForm").clearForm();

            $("#sPeriod").prop("disabled", true);
            $("#sCrcHolder").prop("disabled", true);
            $("#sAmt").prop("disabled", true);

            $("#rPeriod").prop("disabled", true);
            $("#rCrcHolder").prop("disabled", true);
            $("#rAmt").prop("disabled", true);

            $("#adjRem").prop("disabled", true);

            cnt++;

            break;

        case "1":
            // Transfer between Credit Card Holder
            $("#sPeriod").prop("disabled", false);
            $("#sCrcHolder").prop("disabled", false);
            $("#sAmt").prop("disabled", false);

            $("#rPeriod").prop("disabled", false);
            $("#rCrcHolder").prop("disabled", false);
            $("#rAmt").prop("disabled", false);
            $("#rAmt").attr("readonly", true);

            $("#adjRem").prop("disabled", false);

            if(authorized != "BUDGET" && cnt > 0) {
                $('select[name="rCrcHolder"]').find('option[value="0"]').attr('selected', 'selected');
                $("#rCostCenter").val("");
                $("#rCostCenterName").val("");
            }

            cnt++;

            break;

        case "2":
            // Transfer between Period
            $("#sPeriod").prop("disabled", false);
            $("#sCrcHolder").prop("disabled", false);
            $("#sAmt").prop("disabled", false);

            $("#rPeriod").prop("disabled", false);
            $("#rCrcHolder").prop("disabled", true);
            $("#rAmt").prop("disabled", true);
            $("#rAmt").attr("readonly", true);

            $("#adjRem").prop("disabled", false);

            if(authorized != "BUDGET" && cnt > 0) {
                $("#rPeriod").val("");
            }

            cnt++;

            break;

        case "3":
            // Addition
            $("#sPeriod").prop("disabled", true);
            $("#sCrcHolder").prop("disabled", true);
            $("#sAmt").prop("disabled", true);

            $("#rPeriod").prop("disabled", false);
            $("#rCrcHolder").prop("disabled", false);
            $("#rAmt").prop("disabled", false);
            $("#rAmt").attr("readonly", false);

            $("#adjRem").prop("disabled", false);

            if(authorized != "BUDGET" && cnt > 0) {
                $("#sPeriod").val("");
                $('select[name="sCrcHolder"]').find('option[value="0"]').attr('selected', 'selected');
                $("#sCostCenter").val("");
                $("#sCostCenterName").val("");
            }

            cnt++;

            break;

        case "4":
            // Reduction
            $("#sPeriod").prop("disabled", false);
            $("#sCrcHolder").prop("disabled", false);
            $("#sAmt").prop("disabled", false);

            $("#rPeriod").prop("disabled", true);
            $("#rCrcHolder").prop("disabled", true);
            $("#rAmt").prop("disabled", true);
            $("#rAmt").attr("readonly", true);

            $("#adjRem").prop("disabled", false);

            if(authorized != "BUDGET" && cnt > 0) {
                $("#rPeriod").val("");
                $('select[name="rCrcHolder"]').find('option[value="0"]').attr('selected', 'selected');
                $("#rCostCenter").val("");
                $("#rCostCenterName").val("");
            }

            cnt++;

            break;
        }
    }

    function fn_chgSPeriod(val) {
        console.log("fn_chgSPeriod");
        if($("#adjType").val() == "1") {
            // $("#rPeriod").val(val);

            if(!FormUtil.isEmpty($("sCrcHolder").val())) {
                $("#rCrcHolder option[value=" + $("sCrcHolder").val() + "]").attr('selected', 'selected');
                $("#rCostCenter").val($("#sCostCenter").val());
                $("#rCostCenterName").val($("#sCostCenterName").val());
            }
        }
    }

    function fn_chgSAmt(val) {
        console.log("fn_chgSAmt");
        if($("#adjType").val() == "1" || $("#adjType").val() == "2") {
            $("#rAmt").val(val);
        }
    }

    function fn_chgCrc(type, val) {
        console.log("fn_chgCrc :: type = " + type + "; val = " + val);

        if(type == "SC") {
            console.log("SC");
            $("#sCostCenter").val("");
            $("#sCostCenterName").val("");

        } else if(type == "RC") {
            console.log("RC");
            $("#rCostCenter").val("");
            $("#rCostCenterName").val("");

        }

        Common.ajax("GET", "/eAccounting/creditCard/getCardInfo.do", {crcId : val}, function(result) {
            console.log(result);
            console.log("adjType :: " + $("#adjType").val());

            if($("#adjType").val() == "2") {
                // Transfer between Card Holder
                $("#sCrcId_h").val(val);
                $("#rCrcId_h").val(val);

                $("#sCostCenter").val(result.data.costCentr);
                $("#sCostCenterName").val(result.data.costCenterText);

                $("#rCostCenter").val(result.data.costCentr);
                $("#rCostCenterName").val(result.data.costCenterText);

                // $("#sCrcHolder option[value=" + val + "]").attr('selected', 'selected');
                $("#rCrcHolder option[value=" + val + "]").attr('selected', 'selected');

            } else {
                // Not Transfer between Card Holder Adjustment Type
                if(type == "SC") {
                    console.log("getCardInfo :: SC");
                    $("#sCrcId_h").val(val);
                    $("#sCostCenter").val(result.data.costCentr);
                    $("#sCostCenterName").val(result.data.costCenterText);

                } else if(type == "RC") {
                    console.log("getCardInfo :: RC");
                    $("#rCrcId_h").val(val);
                    $("#rCostCenter").val(result.data.costCentr);
                    $("#rCostCenterName").val(result.data.costCenterText);

                }
            }
        });
    }

    function fn_atchViewDown(fileGrpId, fileId) {
        var data = {
                atchFileGrpId : fileGrpId,
                atchFileId : fileId
        };

        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
            console.log(result);
            if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
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
    };

    function fn_validation() {
        console.log("fn_validation");

        var flg = true;

        if($("#adjType").val() == "1" || $("#adjType").val() == "2") {
            // Adjustment between Card Holder/Adjustment between Period
            if($("sPeriod").val() == "" && $("sPeriod").val() == null) {
                Common.alert("Sender Period cannot be empty.");
                flg = false;
            }

            if($("sCrcHolder").val() == "" && $("sCrcHolder").val() == null) {
                Common.alert("Sending Card Holder cannot be empty.");
                flg = false;
            }

            if($("sAmt").val() == "" && $("sAmt").val() == null) {
                Common.alert("Sending Amount cannot be empty.");
                flg = false;
            }

            if($("rPeriod").val() == "" && $("rPeriod").val() == null) {
                Common.alert("Receiver Period cannot be empty.");
                flg = false;
            }

            if($("rCrcHolder").val() == "" && $("rCrcHolder").val() == null) {
                Common.alert("Receiving Card Holder cannot be empty.");
                flg = false;
            }

            if($("rAmt").val() == "" && $("rAmt").val() == null) {
                Common.alert("Receiving Amount cannot be empty.");
                flg = false;
            }

        } else if($("#adjType").val() == "3") {
            // Addition
            if($("rPeriod").val() == "" && $("rPeriod").val() == null) {
                Common.alert("Receiver Period cannot be empty.");
                flg = false;
            }

            if($("rCrcHolder").val() == "" && $("rCrcHolder").val() == null) {
                Common.alert("Receiving Card Holder cannot be empty.");
                flg = false;
            }

            if($("rAmt").val() == "" && $("rAmt").val() == null) {
                Common.alert("Receiving Amount cannot be empty.");
                flg = false;
            }

        } else if($("#adjType").val() == "4") {
            // Deduction
            if($("sPeriod").val() == "" && $("sPeriod").val() == null) {
                Common.alert("Sender Period cannot be empty.");
                flg = false;
            }

            if($("sCrcHolder").val() == "" && $("sCrcHolder").val() == null) {
                Common.alert("Sending Card Holder cannot be empty.");
                flg = false;
            }

            if($("sAmt").val() == "" && $("sAmt").val() == null) {
                Common.alert("Sending Amount cannot be empty.");
                flg = false;
            }
        }

        if(FormUtil.isEmpty($("#adjRem").val())) {
            Common.alert("Remark is required.");
            flg = false;
        }

        if(mode == "N") {
            if($("input[name=attachment]")[0].files[0] == "" || $("input[name=attachment]")[0].files[0] == null) {
                Common.alert("Attachment required.");
                flg = false;
            }
        } else {
            if(fileClick > 0 && (update.length === 0 || remove.length === 0)) {
                Common.alert("Attachment required.");
                flg = false;
            }
        }

        return flg;
    }

    /* Save/Edit Functionalities
     * Param :: val = Draft (D) / Submit (S)
     */
    // ========== Submit/Draft - Start ==========
    function fn_reqAdjustment(val) {
        console.log("fn_reqAdjustment");

        if(fn_validation()) {
            var formData = Common.getFormData("adjForm");

            if(FormUtil.isEmpty($("#adjNo").val())) {
                // New Adjustment
                Common.ajaxFile("/eAccounting/creditCard/adjFileUpload.do", formData, function(result) {
                    console.log(result);

                    $("#atchFileGrpId").val(result.data.fileGroupKey);

                    if($("#adjType").prop("disabled") == true) $("#adjType").prop("disabled", false);

                    if($("#sPeriod").prop("disabled") == true) $("#sPeriod").prop("disabled", false);
                    if($("#sCrcHolder").prop("disabled") == true) $("#sCrcHolder").prop("disabled", false);
                    if($("#sAmt").prop("disabled") == true) $("#sAmt").prop("disabled", false);

                    if($("#rPeriod").prop("disabled") == true) $("#rPeriod").prop("disabled", false);
                    if($("#rCrcHolder").prop("disabled") == true) $("#rCrcHolder").prop("disabled", false);
                    if($("#rAmt").prop("disabled") == true) $("#rAmt").prop("disabled", false);

                    if(result.code == "00") {
                        Common.ajax("POST", "/eAccounting/creditCard/saveRequest.do", $("#adjForm").serializeJSON(), function(result2) {
                            console.log(result2);
                            $("#crcAdjustmentPop").remove();

                            // Submit
                            if(result2.code == "00" && val ==  "S") {
                                Common.ajax("POST", "/eAccounting/creditCard/submitAdjustment.do", {docNo : result2.data}, function (result3) {
                                    console.log(result3);

                                    if(result3.code == "00") {
                                        Common.alert("Allowance adjustment submitted document number : " + result2.data);
                                    } else {
                                        Common.alert("Allowance adjustment fail to submit.");
                                    }
                                });
                            } else if(result2.code == "00" && val == "D") {
                                Common.alert("Allowance adjustment drafted document number : " + result2.data);

                            } else if(result2.code == "99") {
                                Common.alert("Allowance adjustment failed to save.");
                            }
                        });
                    }
                });
            } else {
                // Edit Adjustment
                formData.append("atchFileGrpId", $("#atchFileGrpId").val());
                formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

                if(fileClick > 0) {
                    Common.ajaxFile("/eAccounting/creditCard/adjFileUpdate.do"), formData, function(result) {
                        if(result.code == "00") {
                            fn_editRequest(val);
                        } else {
                            Common.alert("File update failed");
                        }
                    }
                } else {
                    fn_editRequest(val);
                }
            }
        }
    }

    function fn_editRequest(val) {
        console.log("fn_editRequest");

        if($("#adjType").prop("disabled") == true) $("#adjType").prop("disabled", false);

        if($("#sPeriod").prop("disabled") == true) $("#sPeriod").prop("disabled", false);
        if($("#sCrcHolder").prop("disabled") == true) $("#sCrcHolder").prop("disabled", false);
        if($("#sAmt").prop("disabled") == true) $("#sAmt").prop("disabled", false);

        if($("#rPeriod").prop("disabled") == true) $("#rPeriod").prop("disabled", false);
        if($("#rCrcHolder").prop("disabled") == true) $("#rCrcHolder").prop("disabled", false);
        if($("#rAmt").prop("disabled") == true) $("#rAmt").prop("disabled", false);

        Common.ajax("POST", "/eAccounting/creditCard/editRequest.do", $("#adjForm").serializeJSON(), function(result2) {
            console.log(result2);
            $("#crcAdjustmentPop").remove();

            // Submit
            if(result2.code == "00" && val ==  "S") {
                Common.ajax("POST", "/eAccounting/creditCard/submitAdjustment.do", {docNo : result2.data}, function (result3) {
                    console.log(result3);

                    if(result3.code == "00") {
                        Common.alert("Allowance adjustment submitted document number : " + result2.data);
                    } else {
                        Common.alert("Allowance adjustment fail to submit.");
                    }
                });
            } else if(result2.code == "00" && val == "D") {
                Common.alert("Allowance adjustment updated");

            } else if(result2.code == "99") {
                Common.alert("Allowance adjustment failed to update.");
            }
        });
    }
    // ========== Submit/Draft - End ==========
    // ========== Approve/Reject - Start ==========
    function fn_appAdjustment(v) {
        console.log("fn_appAdjustment :: " + v);

        var msg;
        if(v == "A") {
            msg = "Do you wish to approve this adjustment document?";
        } else {
            msg = "Do you wish to reject this adjustment document?";
        }

        Common.alert(msg, function (result) {
            if(v == "A") {
                Common.ajax("POST", "/eAccounting/creditCard/approvalUpdate.do", {adjNo : $("#adjNo").val(), action : v}, function(result2) {
                    console.log("approvalUpdate.do :: A :: " + result2);
                    $("#crcAdjustmentPop").remove();

                    if(result2.code == "00") {
                        Common.alert("Allowance adjustment successfully approved");
                    } else {
                        Common.alert("Allowance adjustment failed to approve");
                    }
                });
            } else {
                $("#crcAdjustmentPop").remove();
                $("#rejectAdjPop").show();
            }
        });
    }

    function fn_rejectProceed(v) {
        console.log("fn_rejectProceed");
        if(v == "P") {
            // v = P (Proceed)
            if($("#rejctResn").val() == null || $("#rejctResn").val() == "") {
                Common.alert("Reject reason cannot be empty");
                return false;
            }

            var data = {
                action : "J",
                rejResn : $("#rejctResn").val(),
                adjNo : $("#adjNo").val()
            };

            Common.ajax("POST", "/eAccounting/creditCard/approvalUpdate.do", data, function(result) {
                $("#adjForm").clearForm()
                $("#rejctResn").val("");
                $("#rejectAdjPop").remove();

                if(result.code == "00") {
                    Common.alert("Allowance adjustment successfully rejected");
                } else {
                    Common.alert("Allowance adjustment fail to reject");
                }
            });

        } else {
            // v = C (Cancel)
            $("#rejectAdjPop").hide();
        }
    }
    // ========== Approve/Reject - End ==========

</script>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
    <h1>Allowance Limit Adjustment</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body" style="min-height:200px">
        <section class="search_table">
            <form action="#" method="post" id="adjForm" name="adjForm">
                <input type="hidden" id="adjNo" name="adjNo" />
                <input type="hidden" id="sCrcId_h" name="sCrcId_h" />
                <input type="hidden" id="rCrcId_h" name="rCrcId_h" />
                <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" />

                <section class="search_table">
                    <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:130px" />
                            <col style="width:*" />
                        </colgroup>

                        <tbody>
                            <tr>
                                <th scope="row">Adjustment Type</th>
                                <td>
                                    <select class="w100p" id="adjType" name="adjType" onchange="javascript:fn_chgAdjType(this.value);" >
                                        <option value="0">Choose One</option>
                                        <option value="1">Transfer between Credit Card Holder</option>
                                        <option value="2">Transfer between Period</option>
                                        <option value="3">Addition</option>
                                        <option value="4">Deduction</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </section>

                <div class="divine_auto">
                    <!-- Sender -->
                    <div style="width:50%">
                        <aside class="title_line budget">
                            <h3>Sender</h3>
                        </aside>

                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:130px" />
                                <col style="width:*" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row">Month/Year</th>
                                    <td>
                                        <input type="text" id="sPeriod" name="sPeriod" title="" placeholder="MM/YYYY" class="j_date2 w100p" onchange="javascript:fn_chgSPeriod(this.value);">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Cost Center</th>
                                    <td>
                                        <input type="text" id="sCostCenter" name="sCostCenter" title="" placeholder="" class="w100p" readonly="readonly"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Cost Center Description</th>
                                    <td>
                                        <input type="text" id="sCostCenterName" name="sCostCenterName" title="" placeholder="" class="w100p" readonly="readonly"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Credit Cardholder Name</th>
                                    <td>
                                        <select class="w100p" id="sCrcHolder" name="sCrcHolder" onchange="javascript:fn_chgCrc('SC', this.value)">
                                            <option value="">Choose One</option>
                                            <c:forEach var="list" items="${crcHolder}" varStatus="status">
                                                <option value="${list.crcId}">${list.crcInfo}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Sender Amount</th>
                                    <td>
                                        <input type="text" id="sAmt" name="sAmt" title="" placeholder="Sender Amount" class="w100p" onchange="javascript:fn_chgSAmt(this.value);" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Receiver -->
                    <div style="width:50%">
                        <aside class="title_line budget">
                            <h3>Receiver</h3>
                        </aside>

                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:130px" />
                                <col style="width:*" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row">Month/Year</th>
                                    <td>
                                        <input type="text" id="rPeriod" name="rPeriod" title="" placeholder="MM/YYYY" class="j_date2 w100p">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Cost Center</th>
                                    <td>
                                        <input type="text" id="rCostCenter" name="rCostCenter" title="" placeholder="" class="w100p" readonly="readonly" />
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Cost Center Description</th>
                                    <td>
                                        <input type="text" id="rCostCenterName" name="rCostCenterName" title="" placeholder="" class="w100p" readonly="readonly" />
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Credit Cardholder Name</th>
                                    <td>
                                        <select class="w100p" id="rCrcHolder" name="rCrcHolder" onchange="javascript:fn_chgCrc('RC', this.value)">
                                            <option value="0">Choose One</option>
                                            <c:forEach var="list" items="${crcHolder}" varStatus="status">
                                                <option value="${list.crcId}">${list.crcInfo}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Receiver Amount</th>
                                    <td>
                                        <input type="text" id="rAmt" name="rAmt" title="" placeholder="Receiver Amount" class="w100p" readonly="readonly" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <section class="search_table">
                    <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:130px" />
                            <col style="width:*" />
                        </colgroup>

                        <tbody>
                            <tr>
                                <th scope="row">Remarks</th>
                                <td>
                                    <textarea class="w100p" rows="2" style="height:auto" id="adjRem" name="adjRem"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Attachment</th>
                                <td id="attachTd">
                                    <div class="auto_file2">
                                        <input type="file" id="attachment" name="attachment" title="file add" />
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </section>

                <ul class="center_btns" id="reqBtns">
                    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_reqAdjustment('D')">Save Draft</a></p></li>
                    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_reqAdjustment('S')">Submit</a></p></li>
                </ul>

                <ul class="center_btns" id="appBtns">
                    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_appAdjustment('A')">Approve</a></p></li>
                    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_appAdjustment('J')">Reject</a></p></li>
                </ul>

            </form>
        </section>
    </section>
</div>

<div class="popup_wrap msg_box" id="rejectAdjPop" style="display:none">
    <header class="pop_header">
        <h1>Reject Reason</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <p class="msg_txt">
            <spring:message code="rejectionWebInvoiceMsg.registMsg" />
            <textarea cols="20" rows="5" id="rejctResn" placeholder="Reject reason max 400 characters"></textarea>
        </p>

        <ul class="center_btns">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_rejectProceed('P')">Proceed</a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_rejectProceed('C')">Cancel</a></p></li>
        </ul>
    </section>
</div>