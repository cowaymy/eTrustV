<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    $(document).ready(
            function() {

                //fn_DisablePageControl(); // DISABLE ALL THE FIELD
                $("#ddlStatus").attr("disabled", false); // ENABLE BACK STATUS

                $("#dscCode").val("${DSC_CODE}");
                $("#ddlCTCodeText").val("${CT_CODE}");
                $("#PROD_CDE").val("${STK_CODE}");

                fn_getTestResultInfo();

    });

    function fn_getASReasonCode2(_obj, _tobj, _v) {
        var reasonCode = $(_obj).val();
        var reasonTypeId = _v;

        if (reasonCode == "") {
            return;
        }

        Common.ajax("GET", "/services/as/getASReasonCode2.do", {
            RESN_TYPE_ID : reasonTypeId,
            CODE : reasonCode
        }, function(result) {
            if (result.length > 0) {
                $("#" + _tobj + "_text").val((result[0].resnDesc.trim()).trim());
                $("#" + _tobj + "_id").val(result[0].resnId);

            } else {
                $("#" + _tobj + "_text").val("<spring:message code='service.msg.NoDfctCode'/>");
            }
        });
    }

    function fn_ddlStatus_SelectedIndexChanged(ind) {

        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

        $("#ddlCTCode").val(selectedItems[0].item.asMemId);
        $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
        $("#ddlCTCodeText").val(selectedItems[0].item.lastInstallCtCode);
        $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);

        switch ($("#ddlStatus").val()) {
        case "4":
            // COMPLETE
            fn_openField_Complete();
            $("#defEvt_div").attr("style", "display:block");
            break;

         case "1":
            // INHOUSE ACTIVE
            fn_openField_Complete();
            $("#defEvt_div").attr("style", "display:block");
            break;

        default:
            $("#m2").hide();
            $("#m4").hide();
            $("#m5").hide();
            $("#m7").hide();
            $("#m9").hide();
            $("#m10").hide();
            $("#m11").hide();
            $("#m12").hide();
            $("#m13").hide();
            $("#m14").hide();
            $("#m17").hide();
            $("#m18").hide();
            break;
        }
    }

    function fn_openField_Complete() {
        // OPEN MANDATORY
        $("#m2").show();
        $("#m4").show();
        $("#m5").show();
        $("#m7").show();
        $("#m9").show();
        $("#m10").show();
        $("#m11").show();
        $("#m12").show();
        $("#m13").show();
        $("#m14").show();
        $("#m17").show();
        $("#m18").show();

        $("#btnSaveDiv").attr("style", "display:inline");
        $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");
        $('#tpSettleTime').removeAttr("disabled").removeClass("readonly");
        $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");
        $('#ddlCTCode').removeAttr("disabled").removeClass("readonly");
        $("#ddlProdGenuine").removeAttr("disabled").removeClass("readonly");
        $('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");
        $('#manufacDate').removeAttr("disabled").removeClass("readonly");

    }

    function fn_doSave() {
        // AS RESULT INFORMATION
        if (!fn_validRequiredField_Save_ResultInfo()) {
            return;
        }

        if ($("#ddlStatus").val() == 4 || $("#ddlStatus").val() == 1) { // COMPLETE OR ACTIVE
            // AS DEFECTIVE EVENT
            if (!fn_validRequiredField_Save_DefectiveInfo()) {
                return;
            }
        }

        fn_setSaveFormData();
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form') {
                return $(':input', this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden'
                    || tag === 'textarea') {
                this.value = '';
            } else if (type === 'checkbox' || type === 'radio') {
                this.checked = false;
            } else if (tag === 'select') {
                this.selectedIndex = -1;
            }
        });
    };

    function fn_setSaveFormData() {

        var _TEST_AS_DEFECT_TYPE_ID = 0;
        var _TEST_AS_DEFECT_ID = 0;
        var _TEST_AS_DEFECT_PART_ID = 0;
        var _TEST_AS_DEFECT_DTL_RESN_ID = 0;
        var _TEST_AS_SLUTN_RESN_ID = 0;

        // DEFECT ENTRY
        if ($('#ddlStatus').val() == '4' || $('#ddlStatus').val() == '1') {
            _TEST_AS_DEFECT_TYPE_ID = $('#def_type_id').val();
            _TEST_AS_DEFECT_ID = $('#def_code_id').val();
            _TEST_AS_DEFECT_PART_ID = $('#def_part_id').val();
            _TEST_AS_DEFECT_DTL_RESN_ID = $('#def_def_id').val();
            _TEST_AS_SLUTN_RESN_ID = $('#solut_code_id').val();
        }

        var upResultM = {
            // GENERAL DATA
            TEST_UP_ID : "${TEST_RESULT_ID}",
            TEST_UP_NO : "${TEST_RESULT_NO}",
            TEST_UP_SETL_DT : $('#dpSettleDate').val(),
            TEST_UP_SETL_TM : $('#tpSettleTime').val(),
            TEST_UP_STUS : $('#ddlStatus').val(),
            TEST_MNF_DT : $('#manufacDate').val(),
            TEST_UP_GNE : $('#ddlProdGenuine').val(),
            TEST_UP_REM : $('#txtTestResultRemark').val(),
            TEST_YN : $('#ddlStatus').val() == 4 ? "Y" : "",

            // AS DEFECT ENTRY
            TEST_AS_DEFECT_TYPE_ID : _TEST_AS_DEFECT_TYPE_ID,
            TEST_AS_DEFECT_ID : _TEST_AS_DEFECT_ID,
            TEST_AS_DEFECT_PART_ID : _TEST_AS_DEFECT_PART_ID,
            TEST_AS_DEFECT_DTL_RESN_ID : _TEST_AS_DEFECT_DTL_RESN_ID,
            TEST_AS_SLUTN_RESN_ID : _TEST_AS_SLUTN_RESN_ID
        }

        var saveForm = {
            "upResultM" : upResultM
        }

        // SAVE RESULT
            Common.ajax("POST", "/ResearchDevelopment/editUsedPartReTestResult.do", saveForm,
                function(result) {
                   if (result.data != "" && result.data != null && result.data != "null") {
                      Common.alert("<b>AS result save successfully.</b></br> New Used Part Return Test Result Number : <b>" + result.data + " </b>");
                          $("#txtResultNo").html("<font size='3' color='red'> <b> " + result.data + " </b></font>");
                          fn_DisablePageControl();
                          $("#_editUPResultDiv1").remove();
                          fn_searchUsedPart();
                    } else {
                          Common.alert("<b>Used Part Return Test Result save successfully.</b>");
                          $("#txtResultNo").html( "<font size='3' color='red'> <b> " + $("#txtResultNo").val() + " </b></font>");
                          fn_DisablePageControl();
                          $("#_editUPResultDiv1").remove();
                          fn_searchUsedPart();
                    }
                 }, function() {
                     $("#_editUPResultDiv1").remove();
                     fn_searchUsedPart();
                 });
    }

    function fn_DisablePageControl() {
        $("#ddlStatus").attr("disabled", true);
        $("#dpSettleDate").attr("disabled", true);
        $("#tpSettleTime").attr("disabled", true);
        $("#ddlDSCCode").attr("disabled", true);
        $("#ddlCTCode").attr("disabled", true);
        $("#ddlProdGenuine").attr("disabled", true);
        $("#txtTestResultRemark").attr("disabled", true);
        $("#manufacDate").attr("disabled", true);

        $("#def_code").attr("disabled", true);
        $("#def_def").attr("disabled", true);
        $("#def_part").attr("disabled", true);
        $("#def_type").attr("disabled", true);
        $("#solut_code").attr("disabled", true);

        $("#def_code_text").attr("disabled", true);
        $("#def_def_text").attr("disabled", true);
        $("#def_part_text").attr("disabled", true);
        $("#def_type_text").attr("disabled", true);
        $("#solut_code_text").attr("disabled", true);

        $("#def_def_id").attr("disabled", true);

        $("#btnSaveDiv").attr("style", "display:none");
    }

    function fn_validRequiredField_Save_DefectiveInfo() {
        var rtnMsg = "";
        var rtnValue = true;

        if (FormUtil.checkReqValue($("#def_code_id"))) {
            rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Defect Code' htmlEscape='false'/> </br>";
            rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#def_part_id"))) {
            rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Defect Part' htmlEscape='false'/> </br>";
            rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#def_def"))) {
            rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Detail of Defect' htmlEscape='false'/> </br>";
            rtnValue = false;
        }

        if ($("#ddlStatus").val() == 4) { // IN HOUSE REPAIR
            if ($("input[name='replacement'][value='1']").prop("checked")) {
                if (FormUtil.checkReqValue($("#serialNo"))) {
                    rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Loan Product Serial Nuber' htmlEscape='false'/> </br>";
                    rtnValue = false;
                }
            }
        }

        if (rtnValue == false) {
            Common.alert(rtnMsg);
        }

        return rtnValue;
    }

    function fn_validRequiredField_Save_ResultInfo() {
        var text = "";
        var rtnMsg = "";
        var rtnValue = true;

        if (FormUtil.checkReqValue($("#ddlStatus"))) {
            text = "<spring:message code='service.grid.Status'/>";
            rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
            rtnValue = false;
        } else {
            if ($("#ddlStatus").val() == 4 || $("#ddlStatus").val() == 1) { // COMPLETE OR ACTIVE
                if (FormUtil.checkReqValue($("#dpSettleDate"))) { // IF SATTLE DATE IS EMPTY
                    text = "<spring:message code='service.grid.SettleDate'/>";
                    rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
                    rtnValue = false;
                }

                if (FormUtil.checkReqValue($("#tpSettleTime"))) { // SETTLE TIME
                    rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Settle Time' htmlEscape='false'/> </br>";
                    rtnValue = false;
                }

                if (FormUtil.checkReqValue($("#txtTestResultRemark"))) {
                    rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='[AS Result Detail] Remark' htmlEscape='false'/> </br>";
                    rtnValue = false;
                }

            }
        }

        if (rtnValue == false) {
            Common.alert(rtnMsg);
        }

        return rtnValue;
    }

    function fn_valDtFmt(val) {
        var dateRegex = /^(?=\d)(?:(?:31(?!.(?:0?[2469]|11))|(?:30|29)(?!.0?2)|29(?=.0?2.(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(?:\x20|$))|(?:2[0-8]|1\d|0?[1-9]))([-.\/])(?:1[012]|0?[1-9])\1(?:1[6-9]|[2-9]\d)?\d\d(?:(?=\x20\d)\x20|$))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
        return dateRegex.test(val);
    }

    function fn_chkDt(obj) {
        var vdte = $(obj).val();

        var fmt = fn_valDtFmt(vdte);
        if (!fmt) {
            Common.alert("* Settle Date invalid date format.");
            $(obj).val("");
            return;
        }

    }

    function fn_secChk(obj) {

        if (obj.id == "defEvt_dt") {
            if ($("#ddlStatus").val() != '4') {
                Common
                        .alert("This section only applicable for <b>Complete</b> status");
                return;
            }
        }
    }

    function fn_dftTyp(dftTyp) {
        var ddCde = "";
        var dtCde = "";
        if (dftTyp == "DC") {
            if ($("#def_def_id").val() == "" || $("#def_def_id").val() == null) {
                var text = "<spring:message code='service.text.dtlDef' />";
                var msg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
                Common.alert(msg);
                return false;
            } else {
                ddCde = $("#def_def_id").val();
            }
        } else if (dftTyp == "DD") {
            if ($("#def_part_id").val() == "" || $("#def_part_id").val() == null) {
                var text = "<spring:message code='service.text.defPrt' />";
                var msg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
                Common.alert(msg);
                return false;
            } else {
                ddCde = $("#def_def_id").val();
            }
        } else if (dftTyp == "SC") {
            if ($("#def_type_id").val() == ""
                || $("#def_type_id").val() == null) {
            var text = "<spring:message code='service.text.defTyp' />";
            var msg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
            Common.alert(msg);
            return false;
        } else {
            dtCde = $("#def_type_id").val();
        }
    }

        Common.popupDiv("/services/as/dftTypPop.do", {
            callPrgm : dftTyp,
            prodCde : $("#PROD_CDE").val(),
            ddCde : ddCde,
            dtCde : dtCde
        }, null, true);
    }

    function fn_loadDftCde(itm, prgmCde) {
        if (itm != null) {
            if (prgmCde == 'DT') {
                $("#def_type").val(itm.code);
                $("#def_type_id").val(itm.id);
                $("#def_type_text").val(itm.descp);

                //DEPENDENCY
                $("#solut_code").val("");
                $("#solut_code_id").val("");
                $("#solut_code_text").val("");

                var msg = "";

                if (itm.id == "7059") {
                    if ($("#def_part_id").val() == "5299"
                            || $("#def_part_id").val() == "5300"
                            || $("#def_part_id").val() == "5301"
                            || $("#def_part_id").val() == "5302"
                            || $("#def_part_id").val() == "5321"
                            || $("#def_part_id").val() == "5332") {
                        var text1 = "<spring:message code='service.text.defPrt' />";
                        var text2 = $("#def_part_text").val();
                        var text3 = itm.descp;
                        var text4 = "<spring:message code='service.text.defTyp' />";
                        var text = text1 + ";" + text2 + ";" + text3;
                        msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

                        $("#def_type").val("");
                        $("#def_type_id").val("");
                        $("#def_type_text").val("");
                    }

                    if ($("#def_def_id").val() == "6041"
                            || $("#def_def_id").val() == "6042"
                            || $("#def_def_id").val() == "6043"
                            || $("#def_def_id").val() == "6044"
                            || $("#def_def_id").val() == "6045"
                            || $("#def_def_id").val() == "6046") {
                        var text1 = "<spring:message code='service.text.dtlDef' />";
                        var text2 = $("#def_def_text").val();
                        var text3 = itm.descp;
                        var text4 = "<spring:message code='service.text.defTyp' />";
                        var text = text1 + ";" + text2 + ";" + text3;
                        msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

                        $("#def_type").val("");
                        $("#def_type_id").val("");
                        $("#def_type_text").val("");
                    }

                    if (msg != "") {
                        Common.alert(msg);
                        return false;
                    }
                }

                if (itm.id == "7072") {
                    if ($("#def_part_id").val() == "5299"
                            || $("#def_part_id").val() == "5300"
                            || $("#def_part_id").val() == "5301"
                            || $("#def_part_id").val() == "5302"
                            || $("#def_part_id").val() == "5321"
                            || $("#def_part_id").val() == "5332") {
                        var text1 = "<spring:message code='service.text.defPrt' />";
                        var text2 = $("#def_part_text").val();
                        var text3 = itm.descp;
                        var text4 = "<spring:message code='service.text.defTyp' />";
                        var text = text1 + ";" + text2 + ";" + text3;
                        msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

                        $("#def_type").val("");
                        $("#def_type_id").val("");
                        $("#def_type_text").val("");
                    }

                    if ($("#def_def_id").val() == "6041"
                            || $("#def_def_id").val() == "6042"
                            || $("#def_def_id").val() == "6043"
                            || $("#def_def_id").val() == "6044"
                            || $("#def_def_id").val() == "6045"
                            || $("#def_def_id").val() == "6046"
                            || $("#def_def_id").val() == "6008"
                            || $("#def_def_id").val() == "6015"
                            || $("#def_def_id").val() == "6023"
                            || $("#def_def_id").val() == "6031") {
                        var text1 = "<spring:message code='service.text.dtlDef' />";
                        var text2 = $("#def_def_text").val();
                        var text3 = itm.descp;
                        var text4 = "<spring:message code='service.text.defTyp' />";
                        var text = text1 + ";" + text2 + ";" + text3;
                        msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

                        $("#def_type").val("");
                        $("#def_type_id").val("");
                        $("#def_type_text").val("");
                    }

                    if (msg != "") {
                        Common.alert(msg);
                        return false;
                    }
                }
            } else if (prgmCde == 'DC') {
                $("#def_code").val(itm.code);
                $("#def_code_id").val(itm.id);
                $("#def_code_text").val(itm.descp);
            } else if (prgmCde == 'DP') {
                $("#def_part").val(itm.code);
                $("#def_part_id").val(itm.id);
                $("#def_part_text").val(itm.descp);

                if (itm.id == "5299" || itm.id == "5300" || itm.id == "5301"
                        || itm.id == "5302" || itm.id == "5321"
                        || itm.id == "5332") {
                    if ($("#def_type_id").val() == "7059") {
                        var text1 = "<spring:message code='service.text.defTyp' />";
                        var text2 = $("#def_type_text").val();
                        var text3 = itm.descp;
                        var text4 = "<spring:message code='service.text.defPrt' />";
                        var text = text1 + ";" + text2 + ";" + text3;
                        var msg = "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

                        $("#def_part").val("");
                        $("#def_part_id").val("");
                        $("#def_part_text").val("");

                        Common.alert(msg);
                        return false;
                    }

                    if ($("#def_type_id").val() == "7072") {
                        var text1 = "<spring:message code='service.text.defTyp' />";
                        var text2 = $("#def_type_text").val();
                        var text3 = itm.descp;
                        var text4 = "<spring:message code='service.text.defPrt' />";
                        var text = text1 + ";" + text2 + ";" + text3;
                        var msg = "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

                        $("#def_part").val("");
                        $("#def_part_id").val("");
                        $("#def_part_text").val("");

                        Common.alert(msg);
                        return false;
                    }
                }
            } else if (prgmCde == 'DD') {
                $("#def_def").val(itm.code);
                $("#def_def_id").val(itm.id);
                $("#def_def_text").val(itm.descp);

                // DEPENDENCY
                $("#def_code").val("");
                $("#def_code_id").val("");
                $("#def_code_text").val("");

                if (itm.id == "6041" || itm.id == "6042" || itm.id == "6043"
                        || itm.id == "6044" || itm.id == "6045"
                        || itm.id == "6046") {
                    if ($("#def_type_id").val() == "7059") {
                        var text1 = "<spring:message code='service.text.defTyp' />";
                        var text2 = $("#def_type_text").val();
                        var text3 = itm.descp;
                        var text4 = "<spring:message code='service.text.dtlDef' />";
                        var text = text1 + ";" + text2 + ";" + text3;
                        var msg = "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

                        $("#def_def").val("");
                        $("#def_def_id").val("");
                        $("#def_def_text").val("");

                        Common.alert(msg);
                        return false;
                    }
                }

                if (itm.id == "6041" || itm.id == "6042" || itm.id == "6043"
                        || itm.id == "6044" || itm.id == "6045"
                        || itm.id == "6046" || itm.id == "6008"
                        || itm.id == "6015" || itm.id == "6023"
                        || itm.id == "6031") {
                    if ($("#def_type_id").val() == "7072") {
                        var text1 = "<spring:message code='service.text.defTyp' />";
                        var text2 = $("#def_type_text").val();
                        var text3 = itm.descp;
                        var text4 = "<spring:message code='service.text.dtlDef' />";
                        var text = text1 + ";" + text2 + ";" + text3;
                        var msg = "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

                        $("#def_def").val("");
                        $("#def_def_id").val("");
                        $("#def_def_text").val("");

                        Common.alert(msg);
                        return false;
                    }
                }
            } else if (prgmCde == 'SC') {
                $("#solut_code").val(itm.code);
                $("#solut_code_id").val(itm.id);
                $("#solut_code_text").val(itm.descp);
            }
        }
    }

    function fn_getTestResultInfo() {
        Common.ajax("GET", "/ResearchDevelopment/getTestResultInfo.do", $("#resultUPForm").serialize(), function(result) {

            $("#txtResultNo").text(result[0].testResultNo);
            $("#ddlStatus").val(result[0].testUpStus);
            $("#dpSettleDate").val(result[0].testUpSetlDt);
            $("#tpSettleTime").val(result[0].testUpSetlTm);
            $("#ddlProdGenuine").val(result[0].testUpGne);
            $("#manufacDate").val(result[0].testMnfDt);
            $("#txtTestResultRemark").val(result[0].testUpRem);

            $("#def_part").val(result[0].defectCodeB2);
            $("#def_part_id").val(result[0].defectIdB2);
            $("#def_part_text").val(result[0].defectDescB2);

            $("#def_def").val(result[0].defectCodeB3);
            $("#def_def_id").val(result[0].defectIDB3);
            $("#def_def_text").val(result[0].defectDescB3);

            $("#def_code").val(result[0].defectCodeB1);
            $("#def_code_id").val(result[0].defectIDB1);
            $("#def_code_text").val(result[0].defectDescB1);

            $("#def_type").val(result[0].defectCodeB0);
            $("#def_type_id").val(result[0].defectIDB0);
            $("#def_type_text").val(result[0].defectDescB0);

            $("#solut_code").val(result[0].defectCodeB4);
            $("#solut_code_id").val(result[0].defectIDB4);
            $("#solut_code_text").val(result[0].defectDescB4);

          });
    };

</script>
<div id="popup_wrap" class="popup_wrap">
    <!-- popup_wrap start -->
    <section id="content">
        <!-- content start -->
        <form id="resultUPForm" method="post">
            <div style="display: none">
                <input type="text" name="PROD_CDE" id="PROD_CDE" />
                <input type="text" name="TEST_RESULT_NO" id="TEST_RESULT_NO" value="${TEST_RESULT_NO}" />
                <input type="text" name="DSC_CODE" id="DSC_CODE" value="${DSC_CODE}" />
                <input type="text" name="TEST_RESULT_ID" id="TEST_RESULT_ID" value="${TEST_RESULT_ID}" />
            </div>
        </form>
        <header class="pop_header">
            <!-- pop_header start -->
            <h1><spring:message code='rnd.title.editUsedPartTestRst' /></h1>
            <ul class="right_opt">
                <li><p class="btn_blue2">
                        <a href="#"><spring:message code='sys.btn.close' /></a>
                    </p></li>
            </ul>
        </header>
        <!-- pop_header end -->
        <form id="resultUPAllForm" method="post">
            <section class="pop_body">
                <!-- pop_body start -->
                <aside class="title_line">
                    <h3 class="red_text">
                        <spring:message code='service.msg.msgFillIn' />
                    </h3>
                </aside>
                <article class="acodi_wrap">
                    <dl>
                        <dt class="click_add_on on">
                            <a href="#"><spring:message code='service.title.asRstDtl' /></a>
                        </dt>
                        <dd>
                            <table class="type1">
                                <!-- table start -->
                                <caption>table</caption>
                                <colgroup>
                                    <col style="width: 160px" />
                                    <col style="width: *" />
                                    <col style="width: 110px" />
                                    <col style="width: *" />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row"><spring:message code='service.grid.ResultNo' /></th>
                                        <td><span id='txtResultNo'></span></td>
                                        <th scope="row"><spring:message code='sys.title.status' /></th>
                                        <td><select class="w100p" id="ddlStatus" name="ddlStatus"
                                            onChange="fn_ddlStatus_SelectedIndexChanged()">
                                                <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                                                <c:forEach var="list" items="${asCrtStat}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${list.codeId!='4'}">
                                                              <option value="${list.codeId}">${list.codeName}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${list.codeId}">${list.codeName}</option>
                                                       </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                        </select></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.grid.SettleDate' />
                                        <span id='m2' name='m2' class="must" style="display: none">*</span></th>
                                        <td><input type="text" title="Create start Date" id='dpSettleDate' name='dpSettleDate'
                                            placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" onChange="fn_chkDt('#dpSettleDate')" /></td>
                                       <th scope="row">
                                        <spring:message code='service.grid.SettleTm' />
                                        <span id='m4' name='m4' class="must" style="display: none">*</span></th>
                                        <td>
                                            <div class="time_picker">
                                                <input type="text" title="" placeholder="Settle Time" id='tpSettleTime' name='tpSettleTime'
                                                    class="readonly time_date" disabled="disabled" />
                                                <ul>
                                                    <li><spring:message code='service.text.timePick' /></li>
                                                    <c:forEach var="list" items="${timePick}" varStatus="status">
                                                        <li><a href="#">${list.codeName}</a></li>
                                                    </c:forEach>
                                                </ul>
                                            </div> <!-- time_picker end -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.title.DSCCode' />
                                        <span id='m5' name='m5' class="must" style="display: none">*</span></th>
                                        <td>
                                          <input type="text" title="" placeholder="" class="readonly"
                                            disabled="disabled" id='dscCode' name='dscCode' />
                                        </td>
                                        <th scope="row"><spring:message code='service.grid.CTCode' />
                                            <span id='m7' name='m7' class="must" style="display: none">*</span></th>
                                        <td>
                                            <input type="hidden" title="" placeholder="<spring:message code='service.grid.CTCode' />" class="" id='ddlCTCode' name='ddlCTCode' />
                                            <input type="text" title="" placeholder="" disabled="disabled" id='ddlCTCodeText' name='ddlCTCodeText' /></td>
                                   </tr>

                                    <tr>
                                        <th scope="row">Product Genuine
                                            <span id='m17' name='m17' class="must" style="display: none">*</span></th>
                                        <td><select id='ddlProdGenuine' name='ddlProdGenuine' class="w100p">
                                            <option value="">Choose One</option>
                                            <option value="Genuine">Genuine</option>
                                            <option value="Non Genuine">Non Genuine</option>
                                        </select></td>


                                        <th scope="row">Manufacturing Date
                                        <span id='m18' name='m18' class="must" style="display: none">*</span></th>
                                        <td><input type="text" title="Manufacturing Date" id='manufacDate' name='manufacDate'
                                            placeholder="DD/MM/YYYY" class="readonly j_date" /></td>

                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.title.Remark' />
                                        <span id='m14' name='m14' class="must" style="display: none">*</span></th>
                                        <td colspan="3">
                                        <textarea cols="20" rows="5" placeholder="remark" id='txtTestResultRemark' name='txtTestResultRemark'></textarea></td>
                                    </tr>
                                </tbody>
                            </table>
                        </dd>

                        <dt class="click_add_on" id='defEvt_dt' onclick="fn_secChk(this);">
                            <a href="#"><spring:message code='service.title.asDefEnt' /></a>
                        </dt>
                        <dd id='defEvt_div'>
                            <table class="type1">
                                <!-- table start -->
                                <caption>table</caption>
                                <colgroup>
                                    <col style="width: 140px" />
                                    <col style="width: *" />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row"><spring:message code='service.text.defPrt' />
                                        <span id='m11' name='m11' class="must" >*</span></th>
                                        <td>
                                        <input type="text" title="" placeholder="" disabled="disabled" id='def_part' name='def_part' class=""
                                            onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();" /> <a
                                            class="search_btn" id="DP" onclick="fn_dftTyp('DP')">
                                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
                                            alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" />
                                        <input type="text" title="" placeholder="" id='def_part_text' name='def_part_text' class="" disabled style="width: 60%;" /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.text.dtlDef' />
                                        <span id='m12' name='m12' class="must">*</span></th>
                                        <td><input type="text" title="" placeholder="" disabled="disabled" id='def_def' name='def_def' class=""
                                            onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();" />
                                        <a class="search_btn" id="DD" onclick="fn_dftTyp('DD')">
                                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
                                                alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" />
                                        <input type="text" title="" placeholder="" id='def_def_text' name='def_def_text' class="" disabled style="width: 60%;" /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message  code='service.text.defCde' />
                                        <span id='m10' name='m10' class="must">*</span></th>
                                        <td><input type="text" title="" placeholder="" disabled="disabled" id='def_code' name='def_code' class=""
                                            onblur="fn_getASReasonCode2(this, 'def_code', '303')" onkeyup="this.value = this.value.toUpperCase();" />
                                        <a class="search_btn" id="DC" onclick="fn_dftTyp('DC')">
                                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
                                            alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" />
                                        <input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' class="" disabled style="width: 60%;" /></td>
                                    </tr>

                                    <tr>
                                            <th scope="row"><spring:message code='service.text.defTyp' /><span id='m9' name='m9' class="must" style="display:none">*</span></th>
                                        <td>
                                            <input type="text" title="" id='def_type' name='def_type' placeholder="" disabled="disabled"  class="" onblur="fn_getASReasonCode2(this, 'def_type' ,'387')" onkeyup="this.value = this.value.toUpperCase();"/>
                                            <a class="search_btn" id="HDT" onclick="fn_dftTyp('DT')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                                            <input type="hidden" title="" id='def_type_id' name='def_type_id' placeholder="" class="" />
                                            <input type="text" title="" placeholder="" id='def_type_text' name='def_type_text' class="" disabled style="width:60%;"/>
                                        </td>
                                    </tr>

                                    <tr>
                                            <th scope="row"><spring:message code='service.text.sltCde' /><span id='m13' name='m13' class="must" style="display:none">*</span></th>
                                        <td>
                                            <input type="text" title="" placeholder="" class="" disabled="disabled" id='solut_code' name='solut_code' onblur="fn_getASReasonCode2(this, 'solut_code'  ,'337')" onkeyup="this.value = this.value.toUpperCase();"/>
                                            <a class="search_btn" id="HSC" onclick="fn_dftTyp('SC')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                                            <input type="hidden" title="" placeholder="" class="" id='solut_code_id' name='solut_code_id' />
                                            <input type="text" title="" placeholder="" class="" id='solut_code_text' name='solut_code_text' disabled style="width:60%;"/>
                                        </td>
                                    </tr>

                                </tbody>
                            </table>
                        </dd>
                        </dl>
                </article>
                <ul class="center_btns mt20" id='btnSaveDiv'>
                    <li><p class="btn_blue2 big">
                            <a href="#" onclick="fn_doSave()"><spring:message
                                    code='sys.btn.save' /></a>
                        </p></li>
                    <li>
                        <p class="btn_blue2 big">
                            <a href="#"
                                onclick="javascript:$('#resultUPAllForm').clearForm();"><spring:message
                                    code='sys.btn.clear' /></a>
                        </p>
                    </li>
                </ul>
                 <!-- pop_body end -->
            </section>
        </form>
    </section>
</div>