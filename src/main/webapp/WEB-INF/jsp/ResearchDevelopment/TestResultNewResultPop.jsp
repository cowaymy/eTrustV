<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    /* var regGridID;
    var myFltGrd10; */
    var productCode;
    //var asMalfuncResnId;

    $(document).ready(
    	    function() {
    	    	//createAUIGrid();

                $("#cmbbranchId").change(
                	    function() {
                	        doGetCombo('/services/as/selectCTByDSC.do', $("#cmbbranchId").val(), '', 'cmbctId', 'S','');
                }); // INCHARGE CT

                var isF = true;

                //fn_getASOrderInfo(); // GET AS ORDER INFOR.
               // fn_getASEvntsInfo(); // GET AS EVENT INFOR.
                //fn_getASHistoryInfo(); // GET AS HISTORY INFOR

                fn_DisablePageControl(); // DISABLE ALL THE FIELD
                $("#ddlStatus").attr("disabled", false); // ENABLE BACK STATUS

                //AUIGrid.resize(myFltGrd10, 950, 200);

                fn_getPEXTestResultInfo();
                //fn_getASRulstEditFilterInfo();

               /*  if ('${REF_REQST}' > 0) { // TO BE REMOVE
                    $("#IN_HOUSE_CLOSE").val("Y");
                }

                if ('${IS_AUTO}' == "true") { // TO BE REMOVE
                    $("#inHouseRepair_div").attr("style", "display:none");
                } */

    });

    function fn_inHouseAutoClose() {
        if ('${IS_AUTO}' == "true") {
            $("#ddlStatus").attr("disabled", false);
            $('#ddlStatus').val("4");
            fn_doSave();

            setTimeout(function() {
                $("#_newPEXTestResultDiv1").remove();
            }, 2000);
        }
    }

    function createAUIGrid() {
        var columnLayout = [ {
            dataField : "asNo",
            headerText : "<spring:message code='service.grid.ASTyp'/>",
            editable : false
        }, {
            dataField : "c2",
            headerText : "<spring:message code='service.grid.ASRs'/>",
            width : 80,
            editable : false,
            dataType : "date",
            formatString : "dd/mm/yyyy"
        }, {
            dataField : "code",
            headerText : "<spring:message code='service.grid.Status'/>",
            width : 80
        }, {
            dataField : "asReqstDt",
            headerText : "<spring:message code='service.grid.ReqstDt'/>",
            width : 100,
            editable : false,
            dataType : "date",
            formatString : "dd/mm/yyyy"
        }, {
            dataField : "asSetlDt",
            headerText : "<spring:message code='service.grid.SettleDate'/>",
            width : 100,
            editable : false,
            dataType : "date",
            formatString : "dd/mm/yyyy"
        }, {
            dataField : "c3",
            headerText : "<spring:message code='service.grid.ErrCde'/>",
            width : 150,
            editable : false
        }, {
            dataField : "c4",
            headerText : "<spring:message code='service.grid.ErrDesc'/>",
            width : 150,
            editable : false
        }, {
            dataField : "c5",
            headerText : "<spring:message code='service.grid.CTCode'/>",
            width : 150,
            editable : false
        }, {
            dataField : "c6",
            headerText : "<spring:message code='service.grid.Solution'/>",
            width : 150,
            editable : false
        }, {
            dataField : "c7",
            headerText : "<spring:message code='service.grid.ASAmt'/>",
            width : 150,
            dataType : "numeric",
            formatString : "#,##0.00",
            editable : false
        } ];

        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            selectionMode : "singleRow",
            showRowNumColumn : true
        };

        regGridID = GridCommon.createAUIGrid("reg_grid_wrap", columnLayout, "",
                gridPros);
    }

    function fn_getASHistoryInfo() {
        Common.ajax("GET", "/services/as/getASHistoryInfo.do", $(
                "#resultPEXTestResultForm").serialize(), function(result) {
            AUIGrid.setGridData(regGridID, result);
        });
    }



    function fn_getASRulstEditFilterInfo() {
        Common.ajax("GET", "/services/as/getASRulstEditFilterInfo", {
            REF_REQST : $('#REF_REQST').val()
        }, function(result) {
            if (result != null) {
                if (result.length > 0) {
                    for (i in result) {
                        AUIGrid.addRow(myFltGrd10, result[i], "last");
                    }
                }
            }

        });
    }

    function fn_getPEXTestResultInfo() {
        Common.ajax("GET", "/ResearchDevelopment/getPEXTestResultInfo", $(
                "#resultPEXTestResultForm").serialize(), function(result) {
            if (result != "") {
                fn_setPEXTestResultInfo(result);
            }
        });
    }

    function fn_getDefectEntry() {
        //3rd AS
        var SALES_ORD_NO = $("#ORD_NO").val();

        Common.ajax("GET", "/services/as/selectDefectEntry.do?ORD_NO=" + SALES_ORD_NO, "", function(result) {
            console.log("selectDefectEntry");

            if (result != null && result.length > 0) {
	            	$("#def_part").val(result[0].defectCodeDp);
	                $("#def_part_id").val(result[0].asDefectPartId);
	                $("#def_part_text").val(result[0].defectDescDp);

	                $("#def_def").val(result[0].defectCodeDd);
	                $("#def_def_id").val(result[0].asDefectDtlResnId);
	                $("#def_def_text").val(result[0].defectDescDd);

	                $("#def_code").val(result[0].defectCodeDc);
	                $("#def_code_id").val(result[0].asDefectId);
	                $("#def_code_text").val(result[0].defectDescDc);
           } else {
		            $("#def_part").val("");
		            $("#def_part_id").val("");
		            $("#def_part_text").val("");
		            $("#def_def").val("");
		            $("#def_def_id").val("");
		            $("#def_def_text").val("");
		            $("#def_code").val("");
		            $("#def_code_id").val("");
		            $("#def_code_text").val("");
	            }
            });
    }

    function fn_asDefectEntryHideSearch(result) {
        //DP DEFETC PART
        $("#def_part").val(result[0].defectCode);
        $("#def_part_id").val(result[0].defectId);
        $("#def_part_text").val(result[0].defectDesc);
        $("#DP").hide();
        //DD AS PROBLEM SYMPTOM LARGE
        $("#def_def").val(result[1].defectCode);
        $("#def_def_id").val(result[1].defectId);
        $("#def_def_text").val(result[1].defectDesc);
        $("#DD").hide();
        //DC AS PROBLEM SYMPTOM SMALL
        $("#def_code").val(result[2].defectCode);
        $("#def_code_id").val(result[2].defectId);
        $("#def_code_text").val(result[2].defectDesc);
        $("#DC").hide();
    }

    function fn_asDefectEntryNormal(indicator) {

//      if (indicator == 1) {
        if (indicator != 2) { //3rd AS
            //DP DEFETC PART
            $("#def_part").val("");
            $("#def_part_id").val("");
            $("#def_part_text").val("");
            $("#DP").show();
            //DD AS PROBLEM SYMPTOM LARGE
            $("#def_def").val("");
            $("#def_def_id").val("");
            $("#def_def_text").val("");
            $("#DD").show();
            //DC AS PROBLEM SYMPTOM SMALL
            $("#def_code").val("");
            $("#def_code_id").val("");
            $("#def_code_text").val("");
            $("#DC").show();
        } else {
            fn_getDefectEntry();
        }
    }

    function fn_setPEXTestResultInfo(result) {

        $("#creator").val(result[0].crtUserId);
        $("#creatorat").val(result[0].crtDt);
        $("#txtResultNo").text(result[0].testResultNo);

        $("#ddlStatus").val(result[0].testResultStus);
        $("#dpSettleDate").val(result[0].testSettleDt);
        $("#tpSettleTime").val(result[0].testSettleTime);
        $("#ddlDSCCode").val(result[0].dscId);
        $("#ddlDSCCodeText").val(result[0].dscCode);

        $("#ddlCTCodeText").val(result[0].ctCode);
        $("#ddlCTCode").val(result[0].ctId);
        $("#CTID").val(result[0].ctId);

        $("#txtAMPReading").val(result[0].amp);
        $("#txtVoltage").val(result[0].voltage);
        $("#ddlProdGenuine").val(result[0].prodGenuine);
        $("#txtTestResultRemark").val(result[0].testResultRem);

        $('#def_part').val(result[0].defLargeCode);
        $('#def_part_text').val(result[0].defectPartLarge);
        $('#def_part_id').val(result[0].defLargeId);

        $('#def_code').val(result[0].probLargeCode);
        $('#def_code_text').val(result[0].problemSymptomLarge);
        $('#def_code_id').val(result[0].probLargeId);

        $('#def_def').val(result[0].probSmallCode);
        $('#def_def_text').val(result[0].problemSymptomSmall);
        $('#def_def_id').val(result[0].probSmallId);

        $("#PROD_CDE").val(result[0].prodCde);

        fn_ddlStatus_SelectedIndexChanged("Y");
    }

    function fn_inHouseGetProductDetails() {
        $("#productCode").val(productCode);
    }

     function fn_getASOrderInfo() {
        Common.ajax("GET", "/services/as/getASOrderInfo.do", $("#resultASForm").serialize(), function(result) {

        	$("#txtASNo").text($("#AS_NO").val());
            $("#txtOrderNo").text(result[0].ordNo);
            $("#txtAppType").text(result[0].appTypeCode);
            $("#txtCustName").text(result[0].custName);
            $("#txtCustIC").text(result[0].custNric);
            $("#txtContactPerson").text(result[0].instCntName);

            $("#txtTelMobile").text(result[0].instCntTelM);
            $("#txtTelResidence").text(result[0].instCntTelR);
            $("#txtTelOffice").text(result[0].instCntTelO);
            //$("#txtInstallAddress").text(result[0].instCntName);
            $("#txtInstallAddress").text(result[0].instAddrDtl);

            $("#txtProductCode").text(result[0].stockCode);
            $("#txtProductName").text(result[0].stockDesc);
            $("#txtSirimNo").text(result[0].lastInstallSirimNo);
            $("#txtSerialNo").text(result[0].lastInstallSerialNo);

            $("#txtCategory").text(result[0].c2);
            $("#txtInstallNo").text(result[0].lastInstallNo);
            $("#txtInstallDate").text(result[0].c1);
            $("#txtInstallBy").text(result[0].lastInstallCtCode);
            $("#txtInstruction").text(result[0].instct);
            $("#txtMembership").text(result[0].c5);
            $("#txtExpiredDate").text(result[0].c6);

            $("#PROD_CDE").val(result[0].stockCode);

            // KR-OHK Serial Check
            $("#pItmCode").val(result[0].stockCode);

            // ONGHC - 20200221 ADD FOR PSI
            $("#PROD_CAT").val(result[0].c2code);

            doGetCombo('/services/as/getASFilterInfo.do?prdctCd=' + result[0].stockCode, '', '', 'ddlFilterCode', 'S', '');
        });
    }

    /* function fn_getASEvntsInfo() {
        Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm").serialize(), function(result) {
            $("#txtASStatus").text(result[0].code);
            $("#txtRequestDate").text(result[0].asReqstDt);
            $("#txtRequestTime").text(result[0].asReqstTm);

            $("#txtAppDt").text(result[0].asAppntDt);
            $("#txtAppTm").text(result[0].asAppntTm);

            $("#txtMalfunctionCode").text(result[0].asMalfuncId);
            $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);
            $("#txtDSCCode").text(result[0].c7 + "-" + result[0].c8);
            $("#txtInchargeCT").text(result[0].c10 + "-" + result[0].c11);

            $("#txtRequestor").text(result[0].c3);
            $("#txtASKeyBy").text(result[0].c1);
            $("#txtRequestorContact").text(result[0].asRemReqsterCntc);
            $("#txtASKeyAt").text(result[0].asCrtDt);

            // KR-OHK Serial Check
            $("#hidSerialRequireChkYn").val(result[0].serialRequireChkYn);
            if ($("#hidSerialRequireChkYn").val() == 'Y') {
                $("#btnSerialEdit").attr("style", "");
                $("#serialSearch").attr("style", "");

                $("#pLocationType").val(result[0].whLocGb);
                $('#pLocationCode').val(result[0].ctWhLocId);
            }
        });
    } */

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

    function fn_loadDftCde(itm, prgmCde) {
        if (itm != null) {
            if (prgmCde == 'DC') {
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
            }
        }
    }

    /* function getASStockPrice(_PRC_ID) {
        var ret = 0;
        Common.ajaxSync("GET", "/services/as/getASStockPrice.do", {
            PRC_ID : _PRC_ID
        }, function(result) {
            try {
                ret = parseInt(result[0].amt, 10);
            } catch (e) {
                Common.alert("<spring:message code='service.msg.NoStkPrc'/>");
                ret = 0;
            }
        });
        return ret;

    } */

    function fn_ddlStatus_SelectedIndexChanged(ind) {

        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

        $("#ddlCTCode").val(selectedItems[0].item.ctID);
        $("#ddlDSCCode").val(selectedItems[0].item.dscID);
        $("#ddlCTCodeText").val(selectedItems[0].item.ctCode);
        $("#ddlDSCCodeText").val(selectedItems[0].item.dscCode);

        switch ($("#ddlStatus").val()) {
        case "4":
            // COMPLETE
            fn_openField_Complete();
            // RESET SECTION
            fn_rstRecall(); //RECALL
            $("#defEvt_div").attr("style", "display:block");
            $("#chrFee_div").attr("style", "display:block");
            $("#recall_div").attr("style", "display:none");

            break;

         case "1":
            // INHOUSE ACTIVE
            fn_openField_Complete();
            // RESET SECTION
            fn_rstRecall(); //RECALL
            //fn_rstDftEnt(); //DEFECT ENTRY
            $("#defEvt_div").attr("style", "display:block");
            $("#chrFee_div").attr("style", "display:none");
            $("#recall_div").attr("style", "display:none");
            break;

        default:
            $("#m2").hide();
            $("#m4").hide();
            $("#m5").hide();
            $("#m7").hide();
            $("#m10").hide();
            $("#m11").hide();
            $("#m12").hide();
            $("#m14").hide();
            break;
        }
    }

    function fn_rstRecall() {
        $("#CTCode").val("");
        $("#CTGroup").val("");
        $("#callRem").val("");
    }

    function fn_rstDftEnt() {

        $("#def_code").val("");
        $("#def_code_id").val("");
        $("#def_code_text").val("");

        $("#def_part").val("");
        $("#def_part_id").val("");
        $("#def_part_text").val("");

        $("#def_def").val("");
        $("#def_def_id").val("");
        $("#def_def_text").val("");

    }

    function fn_openField_Complete() {
        // OPEN MANDATORY
        $("#m2").show();
        $("#m3").hide();
        $("#m4").show();
        $("#m5").show();
        $("#m6").show();
        $("#m7").show();
        $("#m8").show();
        $("#m9").show();
        $("#m10").show();
        $("#m11").show();
        $("#m12").show();
        $("#m13").show();
        $("#m14").show();
        $("#m15").show();
        $("#m16").show();

        $("#btnSaveDiv").attr("style", "display:inline");
        $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");
        $('#tpSettleTime').removeAttr("disabled").removeClass("readonly");
        $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");
        $('#ddlCTCode').removeAttr("disabled").removeClass("readonly");
        $('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");

        if ($('#PROD_CAT').val() == "54" || $('#PROD_CAT').val() == "400"
            || $('#PROD_CAT').val() == "57" || $('#PROD_CAT').val() == "56") {
	        $("#m15").show();
	        $("#psiRcd").attr("disabled", false);
	        $("#m16").show();
	        $("#lpmRcd").attr("disabled", false);
        } else {
	        $("#m15").hide();
	        $("#psiRcd").attr("disabled", true);
	        $("#m16").hide();
	        $("#lpmRcd").attr("disabled", true);
	    }
    }

    function fn_clearPageField() {

        $("#btnSaveDiv").attr("style", "display:none");
        $('#dpSettleDate').attr("disabled", true);
        $('#tpSettleTime').attr("disabled", true);
        $('#ddlDSCCode').attr("disabled", true);
        $('#ddlCTCode').attr("disabled", true);
        $('#txtTestResultRemark').attr("disabled", true);

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
       /*  var addedRowItems = AUIGrid.getAddedRowItems(myFltGrd10); // FEE CHARGE ADD SET
        var editedRowItems = AUIGrid.getEditedRowItems(myFltGrd10); // FEE CHARGE EDIT SET
        var removedRowItems = AUIGrid.getRemovedItems(myFltGrd10); // FEE CHARGE DELETE SET */

        var _PEX_DEFECT_ID = 0;
        var _PEX_DEFECT_PART_ID = 0;
        var _PEX_DEFECT_DTL_RESN_ID = 0;

        // DEFECT ENTRY
        if ($('#ddlStatus').val() == '4' || $('#ddlStatus').val() == '1') {
        	 _PEX_DEFECT_PART_ID = $('#def_part_id').val();
        	 _PEX_DEFECT_DTL_RESN_ID = $('#def_def_id').val();
        	 _PEX_DEFECT_ID = $('#def_code_id').val();
        }

        // IN HOUSE
       /*  var inHInd = "";
        if ($('#ddlStatus').val() == '4') {
            inHInd = 'WEB';//inHInd = "";
        } */

        var PEXResultM = {
            // GENERAL DATA
            TEST_RESULT_ID : $("#TEST_RESULT_ID").val(),
            TEST_RESULT_NO : $("#TEST_RESULT_NO").val(),
            //CT_ID : $('#ddlCTCode').val(),
            TEST_SETTLE_DT : $('#dpSettleDate').val(),
            TEST_SETTLE_TIME : $('#tpSettleTime').val(),
            TEST_RESULT_STUS : $('#ddlStatus').val(),
            AMP : $('#txtAMPReading').val(),
            VOLTAGE : $('#txtVoltage').val(),
            PROD_GENUINE : $('#ddlProdGenuine').val(),
            //AS_BRNCH_ID : $('#ddlDSCCode').val(),
            TEST_RESULT_REM : $('#txtTestResultRemark').val(),

            // PEX DEFECT ENTRY
            PEX_DEFECT_PART_ID : _PEX_DEFECT_PART_ID,
            PEX_DEFECT_DTL_RESN_ID : _PEX_DEFECT_DTL_RESN_ID,
            PEX_DEFECT_ID : _PEX_DEFECT_ID,

            // OTHER
            RCD_TMS : $("#RCD_TMS").val(),

        }

        var saveForm = {
            "PEXResultM" : PEXResultM
        }


            Common.ajax("POST", "/ResearchDevelopment/newPEXTestResultAdd.do", saveForm,
                function(result) {
                   if (result.data != "" && result.data != null && result.data != "null") {
                	   Common.alert("<b>PEX test result save successfully.</b>");
                          $("#txtResultNo").html("<font size='3' color='red'> <b> " + result.data + " </b></font>");
                          fn_DisablePageControl();
                          $("#_newPEXTestResultDiv1").remove();
                          fn_searchPEXTestResult();
                    }
                 }, function() {
                     $("#_newPEXTestResultDiv1").remove();
                     fn_searchPEXTestResult();
                 });
    }

    function fn_DisablePageControl() {
        $("#ddlStatus").attr("disabled", true);
        $("#dpSettleDate").attr("disabled", true);
        $("#tpSettleTime").attr("disabled", true);
        $("#ddlDSCCode").attr("disabled", true);
        $("#ddlCTCode").attr("disabled", true);
        $("#txtTestResultRemark").attr("disabled", true);

        $("#def_code").attr("disabled", true);
        $("#def_def").attr("disabled", true);
        $("#def_part").attr("disabled", true);

        $("#def_code_text").attr("disabled", true);
        $("#def_def_text").attr("disabled", true);
        $("#def_part_text").attr("disabled", true);

        $("#def_code").attr("disabled", true);
        $("#def_def_id").attr("disabled", true);
        $("#def_part").attr("disabled", true);

        $("#def_code").attr("disabled", true);
        $("#def_def_id").attr("disabled", true);
        $("#def_part").attr("disabled", true);

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

                if (FormUtil.checkReqValue($("#txtTestResultRemark"))) { //TEST RESULT REMARK
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

    function fn_doClear() {
        $("#ddlStatus").val("");
        $("#dpSettleDate").val("");
        $("#ddlStatus").val("");
        $("#tpSettleTime").val("");
        $("#ddlDSCCode").val("");
        $("#ddlCTCode").val("");
        $("#txtTestResultRemark").val("");

        $("#def_type").val("");
        $("#def_code").val("");
        $("#def_def").val("");
        $("#def_part").val("");

        $("#def_type_id").val("");
        $("#def_code_id").val("");
        $("#def_def_id").val("");
        $("#def_part_id").val("");
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

        var sDate = (vdte).split("/");
        var tDate = new Date();
        var tMth = tDate.getMonth() + 1;
        var tYear = tDate.getFullYear();
        var sMth = parseInt(sDate[1]);
        var sYear = parseInt(sDate[2]);

        if (tYear > sYear) {
            Common.alert("* Settle Date must be in current month and year");
            $(obj).val("");
            return;
        } else {
            if (tMth > sMth) {
                Common.alert("* Settle Date must be in current month and year");
                $(obj).val("");
                return;
            }
        }
    }

    function fn_doAllaction(obj) {
        var ord_id = '${orderDetail.basicInfo.ordId}';

        var vdte = $(obj).val();
        var text = "";

        if ($(obj).attr('id') == "requestDate") {
            text = "<spring:message code='service.title.RequestDate' />";
        } else {
            text = "<spring:message code='service.grid.AppntDt' />";
        }

        var fmt = fn_valDtFmt(vdte);
        if (!fmt) {
            Common.alert("* " + text
                    + " <spring:message code='service.msg.invalidDate' />");
            $(obj).val("");
            return;
        }

        var crtDt = new Date();
        var apptDt = vdte;
        var date = apptDt.substring(0, 2);
        var month = apptDt.substring(3, 5);
        var year = apptDt.substring(6, 10);

        var dd = String(crtDt.getDate()).padStart(2, '0');
        var mm = String(crtDt.getMonth() + 1).padStart(2, '0');
        var yyyy = crtDt.getFullYear();

        var strdate = yyyy + mm + dd;
        var enddate = year + month + date;

        if (enddate < strdate) {
            Common.alert(text + " must be greater or equal to Current Date ");
            $(obj).val("");
            return;
        }

        var options = {
            ORD_ID : ord_id,
            S_DATE : vdte,
            CTCodeObj : 'CTCodeObj',
            CTIDObj : 'CTIDObj',
            CTgroupObj : 'CTgroupObj'
        }

        Common.popupDiv("/organization/allocation/allocation.do", {
            ORD_ID : ord_id,
            S_DATE : vdte,
            OPTIONS : options,
            TYPE : 'AS'
        }, null, true, '_doAllactionDiv');
    }

    function fn_secChk(obj) {

        if (obj.id == "defEvt_dt" || obj.id == "chrFee_dt") {
            if ($("#ddlStatus").val() != '4') {
                Common
                        .alert("This section only applicable for <b>Complete</b> status");
                return;
            }
        }
    }

    function fn_serialModifyPop() {
        $("#serialNoChangeForm #pSerialNo").val($("#stockSerialNo").val()); // Serial No
        $("#serialNoChangeForm #pSalesOrdId").val($("#ORD_ID").val()); // 주문 ID
        $("#serialNoChangeForm #pSalesOrdNo").val($("#ORD_NO").val()); // 주문 번호
        $("#serialNoChangeForm #pRefDocNo").val($("#AS_NO").val()); //
        // $("#serialNoModifyForm #pItmCode").val( $("#stkCode").val()  ); // 제품 ID
        $("#serialNoChangeForm #pCallGbn").val("AS");
        $("#serialNoChangeForm #pMobileYn").val("N");

        if (Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("serialNoChangeForm",
                    "/logistics/serialChange/serialNoChangePop.do", {
                        width : "1000px",
                        height : "1000px",
                        height : "720",
                        resizable : "no",
                        scrollbars : "yes"
                    });
        } else {
            Common.popupDiv("/logistics/serialChange/serialNoChangePop.do", $(
                    "#serialNoChangeForm").serializeJSON(), null, true,
                    '_serialNoChangePop');
        }
    }

    function fn_chkDt2() {
        var crtDt = new Date();
        var apptDt = $("#appDate").val();
        var date = apptDt.substring(0, 2);
        var month = apptDt.substring(3, 5);
        var year = apptDt.substring(6, 10);

        var dd = String(crtDt.getDate()).padStart(2, '0');
        var mm = String(crtDt.getMonth() + 1).padStart(2, '0');
        var yyyy = crtDt.getFullYear();

        var strdate = yyyy + mm + dd;
        var enddate = year + month + date;

        if (enddate < strdate) {
            alert("Appointment Date must be greater or equal to Current Date ");
            $("#appDate").val("");
            $("#CTSSessionCode").val("");
            $("#CTCode").val("");
            $("#CTGroup").val("");
            $("#callRem").val("");
            return;
        } else {
            fn_doAllaction('#appDate');
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
        }

        Common.popupDiv("/services/as/dftTypPop.do", {
            callPrgm : dftTyp,
            prodCde : $("#PROD_CDE").val(),
            ddCde : ddCde,
            dtCde : dtCde
        }, null, true);
    }

    function validate(evt) {
        var theEvent = evt || window.event;

        // Handle paste
        if (theEvent.type === 'paste') {
            key = event.clipboardData.getData('text/plain');
        } else {
            // Handle key press
            var key = theEvent.keyCode || theEvent.which;
            key = String.fromCharCode(key);
        }
        var regex = /[0-9]|\./;
        if (!regex.test(key)) {
            theEvent.returnValue = false;
            if (theEvent.preventDefault)
                theEvent.preventDefault();
        }
    }

</script>
<div id="popup_wrap" class="popup_wrap">
    <!-- popup_wrap start -->
    <section id="content">
        <!-- content start -->
        <form id="resultPEXTestResultForm" method="post">
            <div style="display: none">
                <input type="text" name="TEST_RESULT_ID" id="TEST_RESULT_ID" value="${TEST_RESULT_ID}" />
                <input type="text" name="TEST_RESULT_NO" id="TEST_RESULT_NO" value="${TEST_RESULT_NO}" />
                <input type="text" name="SO_EXCHG_ID" id="SO_EXCHG_ID" value="${SO_EXCHG_ID}" />
                <input type="text" name="RCD_TMS" id="RCD_TMS" value="${RCD_TMS}" />
                <input type="text" name="PROD_CDE" id="PROD_CDE" />
                <input type="text" name="PROD_CAT" id="PROD_CAT" />
            </div>
        </form>
        <header class="pop_header">
            <!-- pop_header start -->
            <h1>
                Add PEX Text Result
            </h1>
            <ul class="right_opt">
                <li><p class="btn_blue2">
                        <a href="#"><spring:message code='sys.btn.close' /></a>
                    </p></li>
            </ul>
        </header>
        <!-- pop_header end -->
        <form id="resultASAllForm" method="post">
            <input type="hidden" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
            <input type="hidden" id='hidStockSerialNo' name='hidStockSerialNo' />
            <input  type="hidden" id='hidSerialChk' name='hidSerialChk' />
            <section class="pop_body">
                <!-- pop_body start -->
                <%-- <section class="tap_wrap">
                    <!-- tap_wrap start -->
                    <ul class="tap_type1">
                        <li><a href="#" class="on"><spring:message
                                    code='service.title.General' /></a></li>
                        <li><a href="#"><spring:message
                                    code='service.title.OrderInformation' /></a></li>
                        <li><a href="#"
                            onclick=" javascirpt:AUIGrid.resize(regGridID, 950,300); "><spring:message
                                    code='service.title.asPassEvt' /></a></li>
                    </ul>
                    <article class="tap_area">
                        <!-- tap_area start -->
                        <table class="type1">
                            <!-- table start -->
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 150px" />
                                <col style="width: *" />
                                <col style="width: 150px" />
                                <col style="width: *" />
                                <col style="width: 150px" />
                                <col style="width: *" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code='service.grid.ASNo' /></th>
                                    <td><span id="txtASNo"></span></td>
                                    <th scope="row"><spring:message
                                            code='service.grid.SalesOrder' /></th>
                                    <td><span id="txtOrderNo"></span></td>
                                    <th scope="row"><spring:message
                                            code='service.title.ApplicationType' /></th>
                                    <td><span id="txtAppType"></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message
                                            code='service.title.asStatus' /></th>
                                    <td><span id='txtASStatus'></span></td>
                                    <th scope="row">Malfunction Code</th>
                                    <td><span id='txtMalfunctionCode'></span></td>
                                    <th scope="row">Malfunction Reason</th>
                                    <td><span id='txtMalfunctionReason'></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"></th>
                                    <td><span id='txtProdCde'></span></td>
                                    <th scope="row"><spring:message
                                            code='service.grid.ReqstDt' /></th>
                                    <td><span id='txtRequestDate'></span></td>
                                    <th scope="row"><spring:message
                                            code='service.title.ReqstTm' /></th>
                                    <td><span id='txtRequestTime'></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"></th>
                                    <td><span></span></td>
                                    <th scope="row"><spring:message
                                            code='service.title.AppointmentDate' /></th>
                                    <td><span id='txtAppDt'></span></td>
                                    <th scope="row"><spring:message
                                            code='service.title.AppointmentTm' /></th>
                                    <td><span id='txtAppTm'></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message
                                            code='service.title.DSCCode' /></th>
                                    <td><span id='txtDSCCode'></span></td>
                                    <th scope="row"><spring:message
                                            code='service.title.InchargeCT' /></th>
                                    <td colspan="3"><span id='txtInchargeCT'></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message
                                            code='service.title.CustomerName' /></th>
                                    <td colspan="3"><span id="txtCustName"></span></td>
                                    <th scope="row"><spring:message
                                            code='service.title.NRIC_CompanyNo' /></th>
                                    <td><span id="txtCustIC"></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message
                                            code='service.title.ContactNo' /></th>
                                    <td colspan="5"><span id="txtContactPerson"></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code='sal.text.telM' /></th>
                                    <td><span id="txtTelMobile"></span></td>
                                    <th scope="row"><spring:message code='sal.text.telR' /></th>
                                    <td><span id="txtTelResidence"></span></td>
                                    <th scope="row"><spring:message code='sal.text.telO' /></th>
                                    <td><span id="txtTelOffice"></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message
                                            code='service.title.InstallationAddress' /></th>
                                    <td colspan="5"><span id="txtInstallAddress"></span></td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code='service.title.Rqst' /></th>
                                    <td colspan="3"><span id="txtRequestor"></span></td>
                                    <th scope="row"><spring:message code='service.grid.CrtBy' /></th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message
                                            code='service.title.RqstCtc' /></th>
                                    <td colspan="3"><span id="txtRequestorContact"></span></td>
                                    <th scope="row"><spring:message code='sal.text.createDate' /></th>
                                    <td><span id="txtASKeyAt"></span></td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- table end -->
                    </article>
                    <!-- tap_area end -->
                    <article class="tap_area">
                        <!------------------------------------------------------------------------------
          Order Detail Page Include START
         ------------------------------------------------------------------------------->
                      <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
                        <!------------------------------------------------------------------------------
          Order Detail Page Include END
         ------------------------------------------------------------------------------->
                    </article>
                    <article class="grid_wrap">
                        <!-- grid_wrap start -->
                    </article>
                    <!-- grid_wrap end -->
                    </article>
                    <!-- tap_area end -->
                    <article class="tap_area">
                        <!-- tap_area start -->
                        <article class="grid_wrap">
                            <!-- grid_wrap start -->
                            <div id="reg_grid_wrap"
                                style="width: 100%; height: 300px; margin: 0 auto;"></div>
                        </article>
                        <!-- grid_wrap end -->
                    </article>
                    <!-- tap_area end -->
                </section> --%>
                <!-- tap_wrap end -->
	            <aside class="title_line">
                    <h3 class="red_text">
                        <spring:message code='service.msg.msgFillIn' />
                    </h3>
                </aside>
                <article class="acodi_wrap">
                    <dl>
                        <dt class="click_add_on on">
                            <a href="#">PEX Test Result Detail</a>
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
                                        <th scope="row">Test Result No</th>
                                        <td><span id='txtResultNo'></span></td>
                                        <th scope="row"><spring:message code='sys.title.status' /></th>
                                        <td><select class="w100p" id="ddlStatus" name="ddlStatus"
                                            onChange="fn_ddlStatus_SelectedIndexChanged()">
                                                <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                                                <c:forEach var="list" items="${asCrtStat}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${list.codeId!='4'}">
                                                             <%-- <option value="${list.codeId}">${list.codeName}</option> --%>
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
                                        <input type="hidden" title=""
                                            placeholder="<spring:message code='service.title.DSCCode' />"
                                            class="" id='ddlDSCCode' name='ddlDSCCode' />
                                          <input type="text" title="" placeholder="" class="readonly"
                                            disabled="disabled" id='ddlDSCCodeText' name='ddlDSCCodeText' />
                                        </td>
                                        <th scope="row"><spring:message code='service.grid.CTCode' />
                                            <span id='m7' name='m7' class="must" style="display: none">*</span></th>
                                        <td>
                                            <input type="hidden" title="" placeholder="<spring:message code='service.grid.CTCode' />" class="" id='ddlCTCode' name='ddlCTCode' />
                                            <input type="text" title="" placeholder="" disabled="disabled" id='ddlCTCodeText' name='ddlCTCodeText' /></td>
                                   </tr>
                                        <th scope="row">AMP Reading<span id='m7' name='m7' class="must" style="display: none">*</span></th>
                                        <td><input type="text" title="" placeholder="AMP Reading"
                                            class="" id='txtAMPReading' name='txtAMPReading' onkeypress='validate(event)' /></td>
                                        <th scope="row">Voltage<span id='m7' name='m7' class="must" style="display: none">*</span></th>
                                        <td><input type="text" title="" placeholder="Voltage"
                                            class="" id='txtVoltage' name='txtVoltage' onkeypress='validate(event)' /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">Product Genuine
                                            <span id='m5' name='m5' class="must" style="display: none">*</span></th>
                                        <td><select id='ddlProdGenuine' name='ddlProdGenuine' class="w100p">
                                            <option value="">Choose One</option>
                                            <option value="G">Genuine</option>
                                            <option value="NG">Non-Genuine</option>
                                        </select></td>
                                        <th></th><td></td>
                                        </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.title.Remark' />
                                        <span id='m14' name='m14' class="must" style="display: none">*</span></th>
                                        <td colspan="3">
                                        <textarea cols="20" rows="5" placeholder="Test result remark from RCT" id='txtTestResultRemark' name='txtTestResultRemark'></textarea></td>
                                    </tr>
                                </tbody>
                            </table>
                        </dd>

                        <dt class="click_add_on" id='defEvt_dt' onclick="fn_secChk(this);">
                            <a href="#">PEX Defect Entry</a>
                        </dt>
                        <dd id='defEvt_div' style="display: none">
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
                                            onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();" />
                                            <a  class="search_btn" id="DP" onclick="fn_dftTyp('DP')">
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
                                onclick="javascript:$('#resultASAllForm').clearForm();"><spring:message
                                    code='sys.btn.clear' /></a>
                        </p>
                    </li>
                </ul>
            </section>
        </form>
    </section>
</div>
<script type="text/javaScript">

</script>