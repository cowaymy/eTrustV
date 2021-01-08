<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

    var rotID = "${rotId}";
    var salesOrdID = "${salesOrdId}";
    var rotCallLogGridID, rotHistoryGridID;
    var ccpAtchFileGrpId, ccpFileId;
    var ccpAtchFlg = 0;

    var update = new Array();
    var attachmentList = new Array();
    <c:forEach var="file" items="${ccpAttachment}">
    var obj = {
            atchFileGrpId : "${file.atchFileGrpId}"
            ,atchFileId : "${file.atchFileId}"
            ,atchFileName : "${file.atchFileName}"
    };
    attachmentList.push(obj);
    </c:forEach>

    var rotCLColumnLayout = [
        {
            dataField : "rotID",
            visible : false
        },
        {
            dataField : "rotCallStus",
            headerText : "Status",
            width : 120
        },
        {
            dataField : "rotCallDt",
            headerText : "Date",
            width : 120
        },
        {
            dataField : "rotRem",
            headerText : "Remark",
            width : 300
        },
        {
            dataField : "rotCallRespdPic",
            headerText : "Caller",
            width : 150
        },
        {
            dataField : "rotCallRespdId",
            visible : false
        },
        {
            dataField : "crtDt",
            headerText : "Create Date",
            width : 120
        }
    ];

    var rotCLGridOption = {
        usePaging : true,
        pageRowCount : 20,
        editable : false,
        showRowNumColumn : true,
        showStateColumn : false,
        wordWrap : true
    };

    var rotHistColumnLayout = [
        {
            dataField : "rotReqDt",
            headerText : "ROT Request<br/>Date",
            width : 100
        },
        {
            dataField : "oldCustId",
            headerText : "Old<br/>Customer ID",
            width : 100
        },
        {
            dataField : "oldCustName",
            headerText : "Old<br/>Customer Name",
            width : 200
        },
        {
            dataField : "newCustId",
            headerText : "New<br/>Customer ID",
            width : 100
        },
        {
            dataField : "newCustName",
            headerText : "New<br/>Customer Name",
            width : 200
        },
        {
            dataField : "status",
            headerText : "ROT Status",
            width : 100
        },
        {
            dataField : "rotReason",
            headerText : "ROT Reason",
            width : 130
        },
        {
            dataField : "productUsageMonth",
            headerText : "Product Usage<br/>Month",
            width : 120
        }
    ];

    var rotHistGridOption = {
        usePaging : true,
        pageRowCount : 20,
        editable : false,
        showRowNumColumn : true,
        showStateColumn : false,
        headerHeight : 40,
        wordWrap : true
    };

    $(document).ready(function() {
        console.log("rootUpdatePop");

        rotCallLogGridID = AUIGrid.create("#callLog_grid_wrap", rotCLColumnLayout, rotCLGridOption);
        rotHistoryGridID = AUIGrid.create("#rotHist_grid_wrap", rotHistColumnLayout, rotHistGridOption);

        // Initiate CCP Tab - Start
        var chsStatus = '${ccpInfoMap.chsStus}';
        var chsRsn = '${ccpInfoMap.chsRsn}';
         console.log("chsStatus : "+ chsStatus);
         console.log("chsRsn : "+ chsRsn);
         if(chsStatus == "YELLOW") {
            $('#chs_stus').append("<span class='red_text'>"+chsStatus+"</span>");
            $('#chs_rsn').append("<span class='red_text'>"+chsRsn+"</span>");
        }else if (chsStatus == "GREEN") {
            $('#chs_stus').append("<span class='black_text''>"+chsStatus+"</span>");
            $('#chs_rsn').append("<span class='black_text'>"+chsRsn+"</span>");
        }else{
            $('#chs_stus').append("<span class='black_text''>"+chsStatus+"</span>");
            $('#chs_rsn').append("<span class='black_text'>"+chsRsn+"</span>");
        }

        var mst = getMstId();
        var ordUnitSelVal = $("#_ordUnitSelVal").val();
        var rosUnitSelVal = $("#_rosUnitSelVal").val();
        var susUnitSelVal = $("#_susUnitSelVal").val();
        var custUnitSelVal = $("#_custUnitSelVal").val();

        getUnitCombo(mst, 212  , ordUnitSelVal , '_ordUnit');
        getUnitCombo(mst, 213  , rosUnitSelVal , '_ordMth');
        getUnitCombo(mst, 216  , susUnitSelVal , '_ordSuspen');
        getUnitCombo(mst, 210  , custUnitSelVal , '_ordExistingCust');

        var ccpId = $("#_editCcpId").val();

        var rentPayModeId = $("#_rentPayModeId").val();
        var applicantTypeId = $("#_applicantTypeId").val();
        console.log("applicantTypeId : " + applicantTypeId);
        console.log("rentPayModeId : " + rentPayModeId);
        var selVal = '';
        if(rentPayModeId == 131){
            if(applicantTypeId == 964){
                selVal = '29';
            }else{
                selVal = '22';
            }
        }

        var ccpStus = $("#_ccpStusId").val();
        doGetCombo('/sales/ccp/getCcpStusCodeList', '', ccpStus,'_statusEdit', 'S');

        CommonCombo.make('_incomeRangeEdit', '/sales/ccp/getLoadIncomeRange' , {editCcpId : ccpId}, selVal , optionModule);
        doGetCombo('/sales/ccp/getCcpRejectCodeList', '', '','_rejectStatusEdit', 'S');

        //Feedback
        /*
        var selReasonCode = $("#_ccpResnId").val();
        doGetCombo('/sales/ccp/selectReasonCodeFbList', '', selReasonCode,'_reasonCodeEdit', 'S');
        */

        bind_RetrieveData();

        //Disabled ComboBox
        $("#_ordUnit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordMth").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordSuspen").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordExistingCust").attr({"disabled" : "disabled" , "class" : "w100p disabled"});

        //SMS Checked
        // Consignment Change
        $("#_updSmsChk").change(function() {
            $("#_updSmsMsg").val('');
            $("#_updSmsMsg").attr("disabled" , "disabled");

            if($("#_updSmsChk").is(":checked") == true){
                var currStus = $("#_statusEdit").val();
                if(currStus != null && currStus != ''){
                    fn_ccpStatusChangeFunc(currStus);
                }
            }
        });

        $("#save_rotCcpbtn").click(fn_saveRotCCPValidation);

        /*
        if("${ccpInfoMap.ccpAtchGrpId}" != null && "${ccpInfoMap.ccpAtchGrpId}" != "") {
            // CCP Attachment is not empty
            // calls function to fetch file data (common function to share with ROT Detail for file assignment placing)
            fn_retrievAttachment("${ccpInfoMap.ccpAtchGrpId}", "ccp");
        }
        */

        /*
        if(attachmentList.length <= 0) {
            setInputFile();
        }
        */

        $(".auto_file").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");

        $("#ccpForm :file").change(function() {
            console.log("ccpform file change");
            var div = $(this).parents(".auto_file");
            var oriFileName = div.find(":text").val();

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    update.push(attachmentList[i].atchFileId);
                    console.log(JSON.stringify(update));
                }
            }

            ccpAtchFlg = 1;
            console.log("ccpAtchFlg :: " + ccpAtchFlg);
        });

        $(".input_text").dblclick(function() {
            var oriFileName = $(this).val();
            var fileGrpId;
            var fileId;

            for(var i = 0; i < attachmentList.length; i++) {
                if(attachmentList[i].atchFileName == oriFileName) {
                    fileGrpId = attachmentList[i].atchFileGrpId;
                    fileId = attachmentList[i].atchFileId;
                }
            }

            fn_atchViewDown(fileGrpId, fileId);
        });
        //$("#ccpFileSelector").click(fn_atchViewDown($("#ccpAtchFileGrpId").val(), $("#ccpFileId").val()));
        // Initiate CCP Tab - End

        // ROT Details Tab - Start
        // General
        $("#rotReqAS option[value='" + "${rotInfoMap.rotReqAs}" + "']").attr('selected', 'selected');
        $("#rotReqRebill option[value='" + "${rotInfoMap.rotReqRebill}" + "']").attr('selected', 'selected');
        $("#rotReqInvoiceGrp option[value='" + "${rotInfoMap.rptReqInvcGrp}" + "']").attr('selected', 'selected');

        // RPS Tab
        $("#estmBillTypeCheckbox").attr({"disabled" : "disabled", "class" : "disabled"});
        $("#smsBillTypeCheckbox").attr({"disabled" : "disabled", "class" : "disabled"});
        $("#postBillTypeCheckbox").attr({"disabled" : "disabled", "class" : "disabled"});
        $("#btnThirdPartyOwnt").attr({"disabled" : "disabled", "class" : "disabled"});

        if("${rotInfoMap.is3rdParty}" == "1") {
            $("#sctThrdParty").removeClass("blind");
        }

        if("${rotInfoMap.paymodeId}" == "131") {
            $("#sctCrCard").removeClass("blind");
        }

        if("${rotInfoMap.paymodeId}" == "132") {
            $("#sctDirectDebit").removeClass("blind");
        }

        // TODO
        // ROT Details attachment retrieve and loop set files
        if("${rotInfoMap.rotAtchGrpId}" != null && "${rotInfoMap.rotAtchGrpId}" != "") {
            // ROT Attachment is not empty
            // calls function to fetch file data (common function to share with CCP for file assignment placing)
            fn_retrievAttachment("${rotInfoMap.rotAtchGrpId}", "rot");
        }

        // ROT Details Tab - End

        // ROT Call-Log Grid Data Init
        fn_retrieveRotCallLog();
        $("#supplier_search_btn").click(fn_popSupplierSearchPop);
        $("#rotCL_add_btn").click(fn_clAddRow);

        // ROT History Grid Data Init
        fn_retrieveRotHist();
    });

    // General Functions - Start
    function setInputFile() {
        $(".auto_file").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
    }

    function fn_retrievAttachment(attachId, type) {
        console.log("fn_retrieveAttachment");
        console.log("attachId :: " + attachId);
        console.log("attach Type :: " + type);

        Common.ajax("GET", "/sales/ownershipTransfer/getAttachments.do", {attachId : attachId}, function(result) {
            console.log(result);
            if(result.data) {
                $("#attachTd").html("");
                $("#ccpAtchTd").html("");
                if(type == "rot") {
                    for(var i = 0; i < result.data.length; i++) {
                        console.log("getAttachmentInfo :: attachList :: " + i);
                        var atchTdId = "atchId" + (i + 1);
                        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                        $(".input_text[name='" + atchTdId + "']").val(result.data[i].atchFileName);
                    }
                }

                $(".input_text").dblclick(function() {
                    var oriFileName = $(this).val();
                    var fileGrpId;
                    var fileId;
                    for(var i = 0; i < attachList.length; i++) {
                        if(attachList[i].atchFileName == oriFileName) {
                            fileGrpId = attachList[i].atchFileGrpId;
                            fileId = attachList[i].atchFileId;
                        }
                    }
                    fn_atchViewDown(fileGrpId, fileId);
                });

                /*
                if(type == "ccp") {
                    ccpAtchFileGrpId = result.data[0].atchFileGrpId;
                    ccpFileId = result.data[0].atchFileId;
                    $("#ccpAtchTd").append("<div class='auto_file w100p'><input type='text' class='input_text' name='ccpFileSelector'/><span class='label_text'><a href='#'>File</a></span></label></div>");
                    $(".input_text[id='ccpFileSelector']").val(result.data[0].atchFileName);
                }
                */
            }
        });
    }

    function fn_atchViewDown(fileGrpId, fileId) {
        console.log("fn_atchViewDown :: fileGrpId :: " + fileGrpId);
        console.log("fn_atchViewDown :: fileId :: " + fileId);

        var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
        };

        Common.ajax("GET", "/sales/ownershipTransfer/getAttachmentInfo.do", data, function(result) {
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
    // General Functions - End

    // CCP Functions - Start
    function getMstId(){

        var mstId = $("#_ccpMasterId").val();
        if(mstId == 0){
            mstId = 1;
        }else{
            mstId = 2;
        }

        return mstId;
    }

    function getUnitCombo(mst , ctgryVal, selVal ,comId){
        unitCombo("/sales/ccp/getOrderUnitList", mst, ctgryVal , selVal, comId, 'S');
    }

    function unitCombo(url, mst , ctgryVal , selCode, obj , type, callbackFn){
        $.ajax({
            type : "GET",
            url : getContextPath() + url,
            data : {ccpMasterId : mst ,  screCtgryTypeId : ctgryVal},
            dataType : "json",
            async : false,
            contentType : "application/json;charset=UTF-8",
            beforeSend:function(){
                Common.showLoader();
            },
            success : function(data) {
                var rData = data;
                doDefCombo(rData, selCode, obj , type,  callbackFn);
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
            },
            complete: function(){
                Common.removeLoader();
            }
        });
    } ;

    var optionModule = {
        type: "S",
        isShowChoose: false
    };

    function  bind_RetrieveData(){
        var ccpStus = $("#_ccpStusId").val();
        var ficoScre = '${ccpInfoMap.ccpFico}'; //FICO SCORE
        var bankrupt = '${ccpInfoMap.ctosBankrupt}'; //BANKRUPT  //CTOS_BANKRUPT
        var ccpHold = '${ccpInfoMap.ccpIsHold}';  // 0 , 1

        console.log("ccpStus : " + ccpStus +", ficoScre : " + ficoScre + " , bankrupt : " + bankrupt + ", ccpHold : " + ccpHold);

        $("#_isPreVal").val("1");
        //Fico
         if($("#_editCustTypeId").val() == '964' && $("#_editCustNation").val() == 'MALAYSIA'){
             $("#_ficoScore").attr("disabled" , false);
         }else{
             $("#_ficoScore").val("0");
             $("#_ficoScore").attr("disabled" , "disabled");
         }

        //bind and Setting by CcpStatus
        if(ccpStus == "1"){
            $("#_incomeRangeEdit").attr("disabled" , false);
            $("#_rejectStatusEdit").val('');
            $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_reasonCodeEdit").attr("disabled" , false);
            $("#_spcialRem").attr("disabled" , false);
            $("#_pncRem").attr("disabled" , false);
            //chkbox
            $("#_onHoldCcp").attr("disabled" , false);
            $("#_summon").attr("disabled" , false);
            $("#_letterOfUdt").attr("disabled" , false);

            if(ficoScre >= 350 && ficoScre <= 450){
                if(ccpHold == 0){   ////on hold
                    if(isAllowSendSMS() == true){
                        $("#_smsDiv").css("display" , "");
                        $("#_updSmsChk").prop('checked', true) ;
                        $("#_updSmsMsg").attr("disabled" , false);
                        $("#_reasonCodeEdit").val("2177");
                        setSMSMessage('Pending' , 'FAILED CTOS SCORE');
                    }
                }
            }else if(ficoScre >= 451 && ficoScre <= 500){
                if(bankrupt == 1 && ccpHold == 0){
                    if(isAllowSendSMS() == true){
                        $("#_smsDiv").css("display" , "");
                        $("#_updSmsChk").prop('checked', true) ;
                        $("#_updSmsMsg").attr("disabled" , false);
                        $("#_reasonCodeEdit").val("1872");
                        setSMSMessage('Pending' , 'FAILED CTOS');
                    }
                }
            }else if(ficoScre == 0){
                if(bankrupt == 1 && ccpHold == 0){
                    if(isAllowSendSMS() == true){
                        $("#_smsDiv").css("display" , "");
                        $("#_updSmsChk").prop('checked', true) ;
                        $("#_updSmsMsg").attr("disabled" , false);
                        $("#_reasonCodeEdit").val("1872");
                        setSMSMessage('Pending' , 'FAILED CTOS');
                    }
                }
            }

        }else if(ccpStus == "5"){
            //field
            $("#_incomeRangeEdit").attr("disabled" , false);
            $("#_rejectStatusEdit").val('');
            $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_reasonCodeEdit").attr("disabled" , false);
            $("#_spcialRem").attr("disabled" , false);
            $("#_pncRem").attr("disabled" , false);
            //chkbox
            $("#_onHoldCcp").attr("checked" , false);
            $("#_onHoldCcp").attr("disabled" , "disabled");
            $("#_summon").attr("disabled" , false);
            $("#_letterOfUdt").attr("disabled" , false);

        }else if(ccpStus == "6"){
            //field
            $("#_incomeRangeEdit").attr("disabled" , false);
            $("#_rejectStatusEdit").attr("disabled" , false);
            $("#_reasonCodeEdit").attr("disabled" , false);
            $("#_spcialRem").attr("disabled" , false);
            $("#_pncRem").attr("disabled" , false);
            //chkbox
            $("#_onHoldCcp").attr("checked" , false);
            $("#_onHoldCcp").attr("disabled" , "disabled");
            $("#_summon").attr("disabled" , false);
            $("#_letterOfUdt").attr("disabled" , false);
        }

        //Set Check Box
        var ccpIsHold = $("#_ccpIsHold").val() == '1' ? true : false;
        var ccpIsSaman = $("#_ccpIsSaman").val() == '1' ? true : false;
        var ccpIsLou = $("#_ccpIsLou").val() == '1' ? true : false;

        if(ccpIsHold == true){
            $("#_onHoldCcp").attr("checked" , true);
        }

        if(ccpIsSaman == true){
            $("#_summon").attr("checked" , true);
        }

        if(ccpIsLou == true){
            $("#_letterOfUdt").attr("checked" , true);
        }
    }

    function fn_ccpStatusChangeFunc(getVal){
        var isHold = $("#_onHoldCcp").is("checked") == true? 1 : 0;
        var ficoScre = '${ccpInfoMap.ccpFico}'; //FICO SCORE
        var bankrupt = '${ccpInfoMap.ctosBankrupt}'; //BANKRUPT  //CTOS_BANKRUPT

        $("#_smsDiv").css("display" , "none");
        $("#_updSmsChk").attr("checked" , false);
        $("#_updSmsMsg").val('');
        $("#_updSmsMsg").attr("disabled" , "disabled");

        if(getVal != null && getVal != ''){
            if(getVal == '1'){
                //ACTIVE
                $("#_incomeRangeEdit").attr("disabled" , false);
                $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
                $("#_reasonCodeEdit").attr("disabled" , false);
                $("#_spcialRem").attr("disabled" , false);
                $("#_pncRem").attr("disabled" , false);

                if($("#_editCustTypeId").val() == '964' && $("#_editCustNation").val() == 'MALAYSIA'){
                    $("#_ficoScore").attr("disabled" , false);
                }else{
                    $("#_ficoScore").val("0");
                    $("#_ficoScore").attr("disabled" , "disabled");
                }

                $("#_onHoldCcp").attr("disabled" , false);
                $("#_summon").attr("disabled" , false);
                $("#_letterOfUdt").attr("disabled" , false);

                if(ficoScre >= 350 && ficoScre <= 450){
                    if(isHold == 0){
                        // on hold
                        if(isAllowSendSMS() == true){
                            $("#_smsDiv").css("display" , "");
                            $("#_updSmsChk").prop('checked', true) ;
                            $("#_updSmsMsg").attr("disabled" , false);
                            $("#_reasonCodeEdit").val("2177");
                            setSMSMessage('Pending' , $("#_reasonCodeEdit option:selected").text());
                        }
                    }
                } else if(ficoScre >= 451 && ficoScre <= 500){
                    if(bankrupt == 1 && isHold == 0){
                        if(isAllowSendSMS() == true){
                            $("#_smsDiv").css("display" , "");
                            $("#_updSmsChk").prop('checked', true) ;
                            $("#_updSmsMsg").attr("disabled" , false);
                            $("#_reasonCodeEdit").val("1872");
                            setSMSMessage('Pending' , $("#_reasonCodeEdit option:selected").text());
                        }
                    }
                } else if(ficoScre == 0){
                    if(bankrupt == 1 && isHold == 0){
                        if(isAllowSendSMS() == true){
                            $("#_smsDiv").css("display" , "");
                            $("#_updSmsChk").prop('checked', true) ;
                            $("#_updSmsMsg").attr("disabled" , false);
                            $("#_reasonCodeEdit").val("1872");
                            setSMSMessage('Pending' , $("#_reasonCodeEdit option:selected").text());
                        }
                    }
                }

            } else if(getVal == '5'){
                // APPROVE
                $("#_incomeRangeEdit").attr("disabled" , false);
                $("#_rejectStatusEdit").val('');
                $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
                $("#_reasonCodeEdit").attr("disabled" , false);
                $("#_spcialRem").attr("disabled" , false);
                $("#_pncRem").attr("disabled" , false);

                $("#_onHoldCcp").attr("checked" , false);
                $("#_onHoldCcp").attr("disabled" , "disabled");
                $("#_summon").attr("disabled" , false);
                $("#_letterOfUdt").attr("disabled" , false);

                // Fico Ajax Call
                var ccpid = $("#_editCcpId").val();
                var data = {ccpId : ccpid};
                Common.ajax("GET", "/sales/ownershipTransfer/getFicoScoreByAjax", data , function(result) {
                    $("#_ficoScore").val(result.ccpFico);
                    $("#_ficoScore").attr("disabled" , false);
                });

                if(isAllowSendSMS() == true){
                    if(isHold == 0){
                        $("#_smsDiv").css("display" , "");
                        $("#_updSmsMsg").attr("disabled" , false);
                        $("#_updSmsChk").prop('checked', true) ;
                        $("#_reasonCodeEdit").val('');
                        setSMSMessage('Approved' , ' ');
                    }
                }
            } else if(getVal == '6'){
                //CANCEL
                $("#_incomeRangeEdit").attr("disabled" , false);
                $("#_rejectStatusEdit").attr({"disabled" : false , "class" : "w100p"});
                $("#_reasonCodeEdit").attr("disabled" , false);
                $("#_spcialRem").attr("disabled" , false);
                $("#_pncRem").attr("disabled" , false);

                $("#_onHoldCcp").attr("checked" , false);
                $("#_onHoldCcp").attr("disabled" , "disabled");
                $("#_summon").attr("disabled" , false);
                $("#_letterOfUdt").attr("disabled" , false);

                $("#_ficoScore").val("0");
                $("#_ficoScore").attr("disabled" , "disabled");
            }
        }
    }

    function isAllowSendSMS(){
        var salesmanMemTypeID  = $("#_editSalesMemTypeId").val();
        var editSalesManTelMobile = $("#_editSalesManTelMobile").val();

        if(salesmanMemTypeID != 1 && salesmanMemTypeID != 2){
            Common.alert('<spring:message code="sal.alert.msg.notHpCody" />');
            return false;

        }else{
            if(isValidMobileNo(editSalesManTelMobile) == false){
                Common.alert('<spring:message code="sal.alert.msg.salesmanNumInvalid" />');
                return false;
            }
        }
        return true;
    }

    function setSMSMessage(status, remark){
        var salesmanMemTypeID  = $("#_editSalesMemTypeId").val();
        var custName = $("#_editCustName").val().substr(0 , 15).trim();
        var ordNo = $("#_editOrdNo").val();
        var webSite = salesmanMemTypeID == '1'?  "hp.coway.com.my" : "cody.coway.com.my";

        var message = "Order : " + ordNo + "\n" + "Name : " + custName + "\n" + "CCPstatus : " + status + "\n" + "Remark :" + remark + "\n";

        $("#_updSmsMsg").val(message);

        //Msg Count Init
        $('#_charCounter').html('Total Character(s) : '+ message.length);
    }

    function  isValidMobileNo(inputContact){
        if(isNaN(inputContact) == true){
            return false;
        }

        if(inputContact.length != 10 && inputContact.length != 11){
            return false;
        }

        if( inputContact.substr(0 , 3) != '010' &&
            inputContact.substr(0 , 3) != '011' &&
            inputContact.substr(0 , 3) != '012' &&
            inputContact.substr(0 , 3) != '013' &&
            inputContact.substr(0 , 3) != '014' &&
            inputContact.substr(0 , 3) != '015' &&
            inputContact.substr(0 , 3) != '016' &&
            inputContact.substr(0 , 3) != '017' &&
            inputContact.substr(0 , 3) != '018' &&
            inputContact.substr(0 , 3) != '019'
          ) {
            return false;
        }

        return true;

    }

    function fn_suggestRem(text){
        var textarr = text.split('-');
        console.log("textarr  : " + JSON.stringify(textarr));
        var rtnStr = '';
        for (var idx = 0; idx < textarr.length; idx++) {
           if(idx > 0){
               rtnStr += textarr[idx];
           }
       }

        return rtnStr;
    }

    function fn_chgFunFeedBack(val){
        var suggRem = fn_suggestRem($("#_reasonCodeEdit option:selected").text());

        var ccpstus = $("#_ccpStusId").val();
        var rtnstr = '';
        if(ccpstus == 1){
            rtnstr = 'Pending';
        }else{
            rtnstr = 'Approved'
        }
         setSMSMessage(rtnstr , suggRem);
    }

    function fn_saveRotCCPValidation() {
        console.log("fn_saveRotCCPValidation");

        //Validation
        if(null == $("#_statusEdit").val() || '' == $("#_statusEdit").val()){
             Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Status'/>");
             return;
        } else {
            if('6' == $("#_statusEdit").val()){
                if(null == $("#_rejectStatusEdit").val() || '' == $("#_rejectStatusEdit").val()){
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Reject Status'/>");
                    return;
                }
            }

            if('6' == $("#_statusEdit").val()){  //|| '1' == $("#_statusEdit").val()
                if(null == $("#_reasonCodeEdit").val() || '' == $("#_reasonCodeEdit").val()){
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Feedback Code'/>");
                    return;
                }
            }
        }

        if(null == $("#_incomeRangeEdit").val() || '' == $("#_incomeRangeEdit").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Income Range'/>");
            return;
        }

        if(null == $("#_ficoScore").val() || '' == $("#_ficoScore").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Fico Score' />");
            return;
        } else {
            if($("#_ficoScore").val() > 850 || $("#_ficoScore").val() < 300 && $("#_ficoScore").val() != 0){
                Common.alert('<spring:message code="sal.alert.text.ficoRange" />');
                return;
            }
        }

        //Validation (Call Entry Count)
        var ccpOrdEditId = $("#_editOrdId").val();
        var salData = {salesOrdId : ccpOrdEditId};
        var sst = '${orderDetail.basicInfo.corpCustTypeId}';

        console.log(salData);
        var callEntCount = 0;

        if(sst == 5495 || sst == 5496){
            callEntCount = 0;
        } else {
            Common.ajaxSync("GET", "/sales/ccp/countCallEntry", salData , function(result) {
                callEntCount = result.totCount;
                console.log("Call Entry Count : " + callEntCount);
            });
        }

        if(callEntCount > 0){
            Common.alert('<spring:message code="sal.alert.msg.existInCallEtry" />');
            return;
        }

        //Validation Success - Save
        //Check box params Setting
        //_letterOfUdt
        if($("#_letterOfUdt").is(":checked") == true) {
            $("#_letterOfUdt").val("1");
        } else {
           $("#_letterOfUdt").val("0");
        }

        //_summon
        if($("#_summon").is(":checked") == true) {
            $("#_summon").val("1");
        } else {
            $("#_summon").val("0");
        }

        //_onHoldCcp
        if($("#_onHoldCcp").is(":checked") == true) {
            $("#_onHoldCcp").val("1");
        } else {
            $("#_onHoldCcp").val("0");
        }

        //SMS
        if($("#_updSmsChk").is(":checked") == true) {
            $("#_isChkSms").val("1");

            //msg setting
            var realMsg =   $("#_updSmsMsg").val();
            $("#_hiddenUpdSmsMsg").val(realMsg); //msg contents

            var salesmanPhNum = $("#_editSalesManTelMobile").val();
            $("#_hiddenSalesMobile").val(salesmanPhNum);

        } else {
            $("#_isChkSms").val("0");
        }

        //_summon
        if($("#agmReq").is(":checked") == true) {
            $("#agmReq").val("1");
        } else {
            $("#agmReq").val("0");
        }

        //_summon
        if($("#cowayTemplate").is(":checked") == true) {
            $("#cowayTemplate").val("1");
        } else {
            $("#cowayTemplate").val("0");
        }

        fn_saveRotCCP();
    }

    function fn_saveRotCCP() {
        console.log("fn_saveRotCCP");

        // if($("input[name=ccpFileSelector]")[0].files[0] == "" || $("input[name=ccpFileSelector]")[0].files[0] == null) {
        if(ccpAtchFlg == 0) {
            if($("input[name=ccpFile]")[0].files[0] == "" || $("input[name=ccpFile]")[0].files[0] == null) {
                Common.alert("Attachment required.");
                return false;
            }
        } else {
            if(update == null) {
                Common.alert("Attachement required.");
                return false;
            }
        }


        if($("#ccpAtchFileGrpId").val() != null && $("#ccpAtchFileGrpId").val() != "") {
            console.log("Update attachment");

            var formData = Common.getFormData("ccpForm");
            formData.append("atchFileGrpId", $("#ccpAtchFileGrpId").val());
            formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));

            Common.ajaxFile("/sales/ownershipTransfer/attachmentUpdate.do", formData, function(result) {
                console.log("fn_saveRotCCP :: attachmentUpdate");
                console.log(result);

                fn_doSaveRotCCP();
            })

        } else {
            console.log("New attachment");

            var formData = Common.getFormData("ccpForm");
            Common.ajaxFile("/sales/ownershipTransfer/attachmentUpload.do", formData, function(result) {
                console.log("fn_saveRotCCP :: attachmentUpload");
                console.log(result);
                $("#ccpAtchFileGrpId").val(result.data.fileGroupKey);
                fn_doSaveRotCCP();
            });
        }
    }

    function fn_doSaveRotCCP() {
        console.log("fn_doSaveRotCCP");
        console.log($("#ccpForm").serializeJSON());

        Common.ajax("POST", "/sales/ownershipTransfer/saveRotCCP.do", $("#ccpForm").serializeJSON(), function(result) {
            console.log(result);
        });
    }
    // CCP Functions - End

    // ROT Call Log Functions - Start
    function fn_retrieveRotCallLog() {
        Common.ajax("GET", "/sales/ownershipTransfer/selectRotCallLog.do", {rotId : rotId}, function(result) {
           console.log(result);
           AUIGrid.setGridData(rotCallLogGridID, result);
        });
    }

    function fn_popSupplierSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM10"}, null, true, "supplierSearchPop");
    }

    function fn_setPopSupplier() {
        $("#newMemAccId").val($("#search_memAccId").val());
        $("#newMemAccName").val($("#search_memAccName").val());
    }

    function fn_clAddRow() {
        // Validation
        if(FormUtil.isEmpty($("#newMemAccId").val())) {
            Common.alert("Responder required.");
            return false;
        }

        if(FormUtil.isEmpty($("#callDt").val())) {
            Common.alert("Call Log date required.");
            return false;
        }

        if(FormUtil.isEmpty($("#callLogStus").val())) {
            Common.alert("Call Log status required.");
            return false;
        }

        if(FormUtil.isEmpty($("#callLogRem").val())) {
            Common.alert("Call Log remark required.");
            return false;
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

        var gridData = {
            rotID : rotID,
            rotCallStus : $("#callLogStus").val(),
            rotCallDt : $("#callDt").val(),
            rotRem : $("#callLogRem").val(),
            rotCallRespdPic : $("#newMemAccName").val(),
            rotCallRespdId : $("#newMemAccId").val(),
            crtDt : today
        }

        AUIGrid.addRow(rotCallLogGridID, gridData, "first");

        fn_clearCallLogInput();
    }

    function fn_clearCallLogInput() {
        $("#newMemAccId").val("");
        $("#newMemAccName").val("");
        $("#callDt").val("");
        $("#callLogStus").val("");
        $("#callLogRem").val("");
    }

    function fn_saveCallLog() {
        var addedItems = AUIGrid.getAddedRowItems(rotCallLogGridID);

        if(addedItems.length <= 0) {
            return false
        } else {
            Common.ajax("POST", "/ownershipTransfer/saveRotCallLog.do", GridCommon.getEditData(myGridID), function(result) {
                console.log(result);

                if(result.code == "00") {
                    Common.alert("Call Log save success.", fn_retrieveRotCallLog());
                } else {
                    Common.alert("Call Log save failure.");
                }
            });
        }
    }
    // ROT Call Log Functions - End

    // ROT History Functions - Start
    function fn_retrieveRotHist() {
        Common.ajax("GET", "/sales/ownershipTransfer/selectRotHistory.do", {salesOrdID : salesOrdID, rotId : rotId}, function(result) {
            console.log(result);
            AUIGrid.setGridData(rotHistoryGridID, result);
         });
    }
    // ROT History Functions - End

</script>

<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
    <!-- pop_header start -->
    <header class="pop_header">
        <h1 id="hTitle">
            <spring:message code="sal.page.title.ordReq" />
        </h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="btnCloseReq" href="#"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
    <!--
      ****************************************************************************
                                         Order Detail Page Include START
      *****************************************************************************
    -->
    <!-- %@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%> -->
    <!--
      ****************************************************************************
                                         Order Detail Page Include END
      *****************************************************************************
    -->
    <!--
      ****************************************************************************
                                         Ownership Transfer Update START
      *****************************************************************************
    -->
    <!-- tap_wrap - Start -->
    <section class="tap_wrap">
        <!-- Tab Buttons -->
        <ul class="tap_type1 num4">
            <li id="tab_ccp"><a href="#">CCP</a></li>
            <li id="tab_rot"><a href="#">ROT Details</a></li>
            <li id="tab_rotCL" class="on"><a href="#">ROT Call-Log</a></li>
            <li id="tab_rotHist"><a href="#">ROT History</a></li>
        </ul>

        <!-- ********************************************************************************** -->
        <!-- CCP Tab - Start -->
        <!-- ********************************************************************************** -->
        <article class="tap_area">
            <form action="#" id="ccpForm" method="post">
                <input type="hidden" name="editCcpId" id="_editCcpId" value="${ccpId}"/>

                <!--  from Basic -->
                <input type="hidden"  name="editOrdId" id="_editOrdId" value="${orderDetail.basicInfo.ordId}">
                <input type="hidden" name="editAppTypeCode" value="${orderDetail.basicInfo.appTypeCode }">
                <input type="hidden" name="editOrdStusId" value="${orderDetail.basicInfo.ordStusId}">
                <input type="hidden"  id="_editCustName" value="${orderDetail.basicInfo.custName}">
                <input type="hidden" id="_editOrdNo" value="${orderDetail.basicInfo.ordNo}">
                <input type="hidden" id="_editCustTypeId" value="${orderDetail.basicInfo.custTypeId}">
                <input type="hidden" id="_editCustNation" value="${orderDetail.basicInfo.custNation}">
                <!-- from SalesMan (HP/CODY) -->
                <input type="hidden" name="editSalesMemTypeId" id="_editSalesMemTypeId" value="${salesMan.memType}">
                <input type="hidden" id="_editSalesManTelMobile" name="editSalesManTelMobile"  value="${salesMan.telMobile}">

                <!-- from GSTCertInfo -->
                <input type="hidden" name="editEurcFilePathName" value="${orderDetail.gstCertInfo.eurcFilePathName}">

                <!-- Cust Type Id  > Ccp Master Id -->
                <input type="hidden" name="ccpMasterId" value="${ccpMasterId}" id="_ccpMasterId">

                <!-- from FieldMap -->
                <input type="hidden" id="_ordUnitSelVal" value="${fieldMap.ordUnitSelVal}">
                <input type="hidden" id="_rosUnitSelVal" value="${fieldMap.rosUnitSelVal}">
                <input type="hidden" id="_susUnitSelVal" value="${fieldMap.susUnitSelVal}">
                <input type="hidden" id="_custUnitSelVal" value="${fieldMap.custUnitSelVal}">

                <!-- from IncomMap -->
                <input type="hidden" id="_rentPayModeId" name="rentPayModeId" value="${incomMap.rentPayModeId}">
                <input type="hidden" id="_applicantTypeId" name="applicantTypeId" value="${incomMap.applicantTypeId}">

                <!-- from ccpInfoMap  -->
                <input type="hidden" id="_ccpStusId" name="ccpStusId" value="${ccpInfoMap.ccpStusId}">
                <input type="hidden" id="_ccpIncRngId" value="${ccpInfoMap.ccpIncomeRangeId}">
                <input type="hidden" id="_ccpResnId" value="${ccpInfoMap.resnId}">

                <input type="hidden" id="_ccpIsHold" value="${ccpInfoMap.ccpIsHold}">
                <input type="hidden" id="_ccpIsSaman" value="${ccpInfoMap.ccpIsSaman}">
                <input type="hidden" id="_ccpIsLou" value="${ccpInfoMap.ccpIsLou}">

                <!-- previous -->
                <input type="hidden" id="_isPreVal" >

                <!-- cust ID  -->
                <input type="hidden" id="_editCustId" value="${orderDetail.basicInfo.custId}">

                <input type="hidden" id="ccpAtchFileGrpId" name="ccpAtchFileGrpId" value="${ccpInfoMap.ccpAtchGrpId}">
                <input type="hidden" id="ccpRotId" name="ccpRotId" value="${rotId}">

                <!-- calSaveForm Hidden Fields - Start -->
                <input type="hidden" name="saveCcpId" id="_saveCcpId" value="${ccpId}"/>
                <input type="hidden" name="ccpTotalScorePoint" value="${fieldMap.totUnitPoint}">
                <input type="hidden" id="_saveCustTypeId" name="saveCustTypeId" value="${orderDetail.basicInfo.custTypeId}">
                <input type="hidden"  name="saveOrdId" id="_saveOrdId" value="${orderDetail.basicInfo.ordId}">
                <input type="hidden"  name="bndlId" id="_bndlId" value="${orderDetail.basicInfo.bndlId}">

                <!-- Ord Unit  -->
                <input type="hidden" name="saveOrdUnit"  id="_saveOrdUnit">
                <input type="hidden" name="saveOrdCount"  value="${fieldMap.ordUnitCount }">
                <input type="hidden" name="saveOrdPoint"  value="${fieldMap.orderUnitPoint}">

                <!-- Avg ROS Mth -->
                <input type="hidden" name="saveRosUnit"  id="_saveRosUnit">
                <input type="hidden" name="saveRosCount"  value="${fieldMap.rosCount}">
                <input type="hidden" name="saveRosPoint"  value="${fieldMap.rosUnitPoint}">

                <!-- Suspension/Termination  -->
                <input type="hidden" name="saveSusUnit"  id="_saveSusUnit">
                <input type="hidden" name="saveSusCount"  value="${fieldMap.susUnitCount}">
                <input type="hidden" name="saveSusPoint"  value="${fieldMap.susUnitPoint}">

                <!-- Existing Customer -->
                <input type="hidden" name="saveCustUnit"  id="_saveCustUnit" >
                <input type="hidden" name="saveCustCount"  value="${fieldMap.custUnitCount}">
                <input type="hidden" name="saveCustPoint"  value="${fieldMap.custUnitPoint}">

                <!-- check box(sms) -->
                <input type="hidden" name="isChkSms" id="_isChkSms">
                <input type="hidden" name="hiddenUpdSmsMsg" id="_hiddenUpdSmsMsg">
                <input type="hidden" name="hiddenSalesMobile" id="_hiddenSalesMobile">
                <!-- calSaveForm Hidden Fields - End -->

                <!--  CCP Score Point Section - Start -->
                <article class="title_line">
                    <h3><spring:message code="sal.title.text.ccpScorePoint" /></h3>
                </article>

                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 210px" />
                        <col style="width: *" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row">CCP Attachment</th>
	                        <td>
	                            <!--
                                <div class="auto_file w100p" id="ccpAtchTd">
                                    <input type="file" id="ccpFileSelector" name="ccpFileSelector" title="file add" />
                                </div>
                                -->
                                <c:forEach var="files" items="${ccpAttachment}" varStatus="st">
                                    <div class="auto_file2 attachment_file w100p">
                                        <input type="file" title="file add" style="width:300px" />
                                        <label>
                                        <input type="text" class="input_text" readonly="readonly" value="${files.atchFileName}" />
                                        <c:if test="${ccpInfoMap.name eq 'Active'}">
                                            <span class='label_text'><a href='#'>File</a></span>
                                        </c:if>
                                        </label>
                                    </div>
                                </c:forEach>
                                <c:if test="${fn:length(ccpAttachment) <= 0}">
                                    <c:if test="${ccpInfoMap.name eq 'Active'}">
                                        <div class="auto_file attachment_file w100p">
                                            <input type="file" title="file add" style="width:300px" id="ccpFile" name="ccpFile" />
                                        </div>
                                    </c:if>
                                </c:if>
	                        </td>
                        </tr>
                    </tbody>
                </table>

                <section class="search_table">
                    <!-- CCP Score Point table - Start -->
                    <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width: 210px" />
                            <col style="width: *" />
                            <col style="width: 80px" />
                            <col style="width: *" />
                            <col style="width: 80px" />
                            <col style="width: *" />
                        </colgroup>

                        <tbody>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.ordUnit" /></th>
                                <td>
                                    <select class="w100p" name="ordUnit" id="_ordUnit"></select>
                                </td>
                                <th scope="row"><spring:message code="sal.title.text.count" /></th>
                                <td>
                                    <span><b>${fieldMap.ordUnitCount }</b></span>
                                </td>
                                <th scope="row"><spring:message code="sal.title.text.point" /></th>
                                <td>
                                    <span><b>${fieldMap.orderUnitPoint}</b></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.avgRosMth" /></th>
                                <td>
                                    <select class="w100p" name="ordMth" id="_ordMth"></select>
                                </td>
                                <th scope="row"><spring:message code="sal.title.text.count" /></th>
                                <td>
                                    <span><b>${fieldMap.rosCount}</b></span>
                                </td>
                                <th scope="row"><spring:message code="sal.title.text.point" /></th>
                                <td>
                                    <span><b>${fieldMap.rosUnitPoint}</b></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.suspensionTermination" /></th>
                                <td>
                                    <select class="w100p" name="ordSuspen" id="_ordSuspen"></select>
                                </td>
                                <th scope="row"><spring:message code="sal.title.text.count" /></th>
                                <td>
                                    <span><b>${fieldMap.susUnitCount}</b></span>
                                </td>
                                <th scope="row"><spring:message code="sal.title.text.point" /></th>
                                <td>
                                    <span><b>${fieldMap.susUnitPoint}</b></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.existCust" /></th>
                                <td>
                                    <select class="w100p" name="ordExistingCust" id="_ordExistingCust"></select>
                                </td>
                                <th scope="row"><spring:message code="sal.title.text.count" /></th>
                                <td>
                                    <span><b>${fieldMap.custUnitCount}</b></span>
                                </td>
                                <th scope="row"><spring:message code="sal.title.text.point" /></th>
                                <td>
                                    <span><b>${fieldMap.custUnitPoint}</b></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.totPoint" /></th>
                                <td colspan="5">
                                    <b>${fieldMap.totUnitPoint}</b>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- CCP Score Point table - End -->
                </section>
                <!--  CCP Score Point Section - End -->

                <!-- CCP Result Section - Start -->
                <article class="title_line">
                    <h3><spring:message code="sal.title.text.ccpResult" /></h3>
                </article>

                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:190px" />
                        <col style="width:*" />
                        <col style="width:140px" />
                        <col style="width:*" />
                        <col style="width:140px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row"><spring:message code="sal.title.text.ccpStatus" /></th>
                            <td>
                                <span><select class="w100p" name="statusEdit" id="_statusEdit" onchange="javascript : fn_ccpStatusChangeFunc(this.value)"></select></span>
                            </td>
                            <th scope="row"><spring:message code="sal.title.text.ccpIncomeRange" /></th>
                            <td>
                                <span><select class="w100p" name="incomeRangeEdit" id="_incomeRangeEdit"></select></span>
                            </td>
                            <th scope="row"><spring:message code="sal.title.text.rejStus" /></th>
                            <td>
                                <span><select class="w100p" name="rejectStatusEdit" id="_rejectStatusEdit"></select></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="sal.title.text.ficoScore" /></th>
                            <td>
                                <span><input type="text" id="_ficoScore" name="ficoScore" value="${ccpInfoMap.ccpFico}" disabled="disabled" maxlength="10" class="w100p"></span>
                            </td>
                            <th scope="row">CHS Status</th>
                            <td id="chs_stus">
                            </td>
                            <th scope="row">CHS Reason</th>
                            <td id="chs_rsn">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">ROT Feedback Code</th>
                            <td colspan="5">
                                <span>
                                    <select class="w100p" name="reasonCodeEdit" id="_reasonCodeEdit" onchange="javascript: fn_chgFunFeedBack(this.value)">
                                        <c:forEach var="list" items="${remarkList}" varStatus="status">
                                            <option value="${list.codeId}">${list.codeName}</option>
                                        </c:forEach>
                                    </select>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="sal.title.text.specialRem" /></th>
                            <td colspan="5">
                                <textarea cols="20" rows="5" id="_spcialRem" name="spcialRem" maxlength="4000">${ccpInfoMap.ccpRem}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="sal.title.text.pncRem" /></th>
                            <td colspan="5">
                                <textarea cols="20" rows="5" id="_pncRem" name="pncRem" maxlength="4000">${ccpInfoMap.ccpPncRem}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Need Agreement</th>
                            <td>
                                <span><input type="checkbox"  id="agmReq"  name="agmReq"/></span>
                            </td>
                            <th scope="row">Coway Template</th>
                            <td>
                                <span><input type="checkbox"  id="cowayTemplate"  name="cowayTemplate"/></span>
                            </td>
                            <th scope="row"><spring:message code="sal.title.text.onHoldCcp" /></th>
                            <td>
                                <span><input type="checkbox"  id="_onHoldCcp"  name="onHoldCcp"/></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">ROT CCP Remark</th>
                            <td colspan="5">
                                <textarea cols="20" rows="5" id="rotCcpRem" name="rotCcpRem" maxlength="4000">${ccpInfoMap.ccpPncRem}</textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div id="_smsDiv" style="display: none;">
                    <aside class="title_line">
                       <h2><spring:message code="sal.title.text.smsInfo" /></h2>
                    </aside>

                    <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:180px" />
                            <col style="width:*" />
                        </colgroup>

                        <tbody>
                            <tr>
                                <td colspan="2">
                                <label><input type="checkbox"  id="_updSmsChk"  /><span><spring:message code="sal.title.text.sendSmsQuest" /></span></label>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.smsMsg" /></th>
                                <td><textarea cols="20" rows="5" name="updSmsMsg" id="_updSmsMsg" ></textarea></td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="_charCounter"><spring:message code="sal.title.text.totChars" /></span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <aside class="title_line">
                    <ul class="center_btns">
                        <li><p class="btn_blue2"><a href="#" id="save_rotCcpbtn">Save CCP</a></p></li>
                    </ul>
                </aside>
                <!-- CCP Result Section - End -->
            </form>
        </article>
        <!-- ********************************************************************************** -->
        <!-- CCP Tab - End -->
        <!-- ********************************************************************************** -->

        <!-- ********************************************************************************** -->
        <!-- ROT Tab - Start -->
        <!-- ********************************************************************************** -->
        <article class="tap_area">
            <!-- General ROT - Start -->
            <aside class="title_line">
                <h2>ROT Details</h2>
            </aside>

            <section class="search_table">
                <table class="type1">
                    <colgroup>
                        <col style="width: 140px" />
                        <col style="width: 100px" />
                        <col style="width: 140px" />
                        <col style="width: 100px" />
                        <col style="width: 140px" />
                        <col style="width: 100px" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row">ROT Reason</th>
                            <td colspan="5">
                                <span id="rotReason">${rotInfoMap.rotReason}</span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Require A/S</th>
                            <td>
                                <select id="rotReqAS" name="rotReqAS" class="w100p" disabled>
                                    <option value="1">YES</option>
                                    <option value="0">NO</option>
                                </select>
                            </td>
                            <th scope="row">Require Rebill</th>
                            <td>
                                <select id="rotReqRebill" name="rotReqRebill" class="w100p" disabled>
                                    <option value="1">YES</option>
                                    <option value="0">NO</option>
                                </select>
                            </td>
                            <th scope="row">Require Invoice Grouping</th>
                            <td>
                                <select id="rotReqInvoiceGrp" name="rotReqInvoiceGrp" class="w100p" disabled>
                                    <option value="1">YES</option>
                                    <option value="0">NO</option>
                                </select>
                            </td>
                        </tr>
                        <!-- auto_file start -->
                        <!--
                        <tr>
                            <th scope="row">Attachment 1</th>
                            <td colspan="5" id="attachTd1">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector1" name="fileSelector1" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 2</th>
                            <td colspan="5" id="attachTd2">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector2" name="fileSelector2" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 3</th>
                            <td colspan="5" id="attachTd3">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector3" name="fileSelector3" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 4</th>
                            <td colspan="5" id="attachTd4">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector4" name="fileSelector4" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 5</th>
                            <td colspan="5" id="attachTd5">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector5" name="fileSelector5" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 6</th>
                            <td colspan="5" id="attachTd6">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector6" name="fileSelector6" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 7</th>
                            <td colspan="5" id="attachTd7">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector7" name="fileSelector7" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 8</th>
                            <td colspan="5" id="attachTd8">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector8" name="fileSelector8" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 9</th>
                            <td colspan="5" id="attachTd9">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector9" name="fileSelector9" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment 10</th>
                            <td colspan="5" id="attachTd10">
                                <div class="auto_file_d attachment_file w100p">
                                    <input type="file" id="fileSelector10" name="fileSelector10" title="file add" readonly='readonly' />
                                </div>
                            </td>
                        </tr>
                         -->
                        <tr>
                            <th scope="row">ROT Request Attachment</th>
                            <td colspan="5" id="attachTd">
                                <div class="auto_file2 auto_file3">
                                    <input type="file" title="file add" />
                                </div>
                            </td>
                        </tr>
                        <!-- auto_file end -->
                    </tbody>
                </table>
            </section>
            <!-- General ROT - End -->

            <!-- ROT Details - Start -->
            <section class="tap_wrap">
                <ul class="tap_type1 num4">
                    <li id="tabCT" class="on"><a href="#" class="on"><spring:message code="sal.title.text.customer" /></a></li>
                    <li id="tabMA"><a href="#"><spring:message code="sal.title.text.mailingAddr" /></a></li>
                    <li id="tabCP"><a href="#"><spring:message code="sal.tap.title.contactPerson" /></a></li>
                    <li id="tabRP"><a href="#"><spring:message code="sal.title.text.rentalPaySetting" /></a></li>
                    <li id="tabIN"><a href="#"><spring:message code="sal.text.inst" /></a></li>
                </ul>

                <!-- tabCT (Customer) - Start -->
                <article class="tap_area">
                    <section class="search_table">
                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 140px" />
                                <col style="width: *" />
                                <col style="width: 170px" />
                                <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.customerId" /></th>
                                    <td>
                                        <span id="custIdOwnt">${rotInfoMap.rotNewCustId}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.type" /></th>
                                    <td>
                                        <span id="custTypeNmOwnt">${rotInfoMap.custType}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.name" /></th>
                                    <td>
                                        <span id="nameOwnt">${rotInfoMap.rotNewCustName}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
                                    <td>
                                        <span id="nricOwnt">${rotInfoMap.nric}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.nationality" /></th>
                                    <td>
                                        <span id="nationNmOwnt">${rotInfoMap.custNationality}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.race" /></th>
                                    <td>
                                        <span id="raceOwnt">${rotInfoMap.custRace}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.dob" /></th>
                                    <td>
                                        <span id="dobOwnt">${rotInfoMap.dob}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.gender" /></th>
                                    <td>
                                        <span id="genderOwnt">${rotInfoMap.custGender}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
                                    <td>
                                        <span id="pasSportExprOwnt">${rotInfoMap.passSportExpr}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
                                    <td>
                                        <span id="visaExprOwnt">${rotInfoMap.visaExpr}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.email" /></th>
                                    <td>
                                        <span id="emailOwnt">${rotInfoMap.custEmail}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.indutryCd" /></th>
                                    <td>
                                        <span id="corpTypeNmOwnt">${rotInfoMap.industryCode}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.employee" /></th>
                                    <td colspan="3">
                                        <span id="empChkOwnt"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.remark" /></th>
                                    <td colspan="3">
                                        <span id="custRemOwnt">${rotInfoMap.custRem}</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </section>
                </article>
                <!-- tabCT (Customer) - Start -->

                <!-- tabMA (Mailing Address) - Start -->
                <article class="tap_area">
                    <section class="search_table">
                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 140px" />
                                <col style="width: *" />
                                <col style="width: 170px" />
                                <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
                                    <td colspan="3">
                                        <span id="txtMailAddrDtlOwnt">${rotInfoMap.mailAddr1}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.street" /></th>
                                    <td colspan="3">
                                        <span id="txtMailStreetOwnt">${rotInfoMap.mailAddr2}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.area" /></th>
                                    <td colspan="3">
                                        <span id="txtMailAreaOwnt">${rotInfoMap.mailArea}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.city" /></th>
                                    <td>
                                        <span id="txtMailCityOwnt">${rotInfoMap.mailCity}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.postCode" /></th>
                                    <td>
                                        <span id="txtMailPostcodeOwnt">${rotInfoMap.mailPostcode}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.state" /></th>
                                    <td>
                                        <span id="txtMailStateOwnt">${rotInfoMap.mailState}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.country" /></th>
                                    <td>
                                        <span id="txtMailCountryOwnt">${rotInfoMap.mailCountry}</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 140px" />
                                <col style="width: *" />
                                <col style="width: 170px" />
                                <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row">Billing Group</th>
                                    <td>
                                        <span id="billingGrpNo">${rotInfoMap.billingGrp}</span>
                                    </td>
                                    <th scope="row">Billing Type</th>
                                    <td>
                                        <input type="checkbox" id="smsBillTypeCheckbox" <c:if test="${rotInfoMap.billSms eq '1'}">checked</c:if> /><span class="txt_box">SMS</span>
                                        <input type="checkbox" id="postBillTypeCheckbox" <c:if test="${rotInfoMap.billPost eq '1'}">checked</c:if> /><span class="txt_box">Post</span>
                                        <input type="checkbox" id="estmBillTypeCheckbox" <c:if test="${rotInfoMap.billStm eq '1'}">checked</c:if> /><span class="txt_box">E-Statement</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </section>
                </article>
                <!-- tabMA (Mailing Address) - Start -->

                <!-- tabCP (Contact Person) - Start -->
                <article class="tap_area">
                    <section class="search_table">
                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 140px" />
                                <col style="width: *" />
                                <col style="width: 170px" />
                                <col style="width: *" />
                                <col style="width: 170px" />
                                <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.name" /></th>
                                    <td>
                                        <span id="txtContactNameOwnt">${rotInfoMap.cntcName}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.initial" /></th>
                                    <td>
                                        <span id="txtContactInitialOwnt">${rotInfoMap.cntcInitial}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.gender" /></th>
                                    <td>
                                        <span id="txtContactGenderOwnt">${rotInfoMap.cntcGender}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.nric" /></th>
                                    <td>
                                        <span id="txtContactICOwnt">${rotInfoMap.cntcNric}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.dob" /></th>
                                    <td>
                                        <span id="txtContactDOBOwnt">${rotInfoMap.cntcDob}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.race" /></th>
                                    <td>
                                        <span id="txtContactRaceOwnt">${rotInfoMap.cntcRace}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.email" /></th>
                                    <td>
                                        <span id="txtContactEmailOwnt">${rotInfoMap.cntcEmail}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.dept" /></th>
                                    <td>
                                        <span id="txtContactDeptOwnt">${rotInfoMap.cntcDept}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.post" /></th>
                                    <td>
                                        <span id="txtContactPostOwnt">${rotInfoMap.cntcPost}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.telM" /></th>
                                    <td>
                                        <span id="txtContactTelMobOwnt">${rotInfoMap.telM}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.telR" /></th>
                                    <td>
                                        <span id="txtContactTelResOwnt">${rotInfoMap.telR}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.telO" /></th>
                                    <td>
                                        <span id="txtContactTelOffOwnt">${rotInfoMap.telO}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.telF" /></th>
                                    <td>
                                        <span id="txtContactTelFaxOwnt">${rotInfoMap.telF}</span>
                                    </td>
                                    <th scope="row"></th>
                                    <td></td>
                                    <th scope="row"></th>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                  </section>
                </article>
                <!-- tabCP (Contact Person) - Start -->

                <!-- tabRP (Rental Pay Setting) - Start -->
                <article class="tap_area">
                    <section class="search_table">
                        <table class="type1 mb1m">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 170px" />
                                <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.payByThirdParty" /></th>
                                    <td colspan="3">
                                        <input type="checkbox" id="btnThirdPartyOwnt" <c:if test="${rotInfoMap.is3rdParty eq '1'}">checked</c:if> />
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- ***************************************** -->
                        <!-- ********** Third party - Start ********** -->
                        <!-- ***************************************** -->
                        <section id="sctThrdParty" class="blind">
                            <aside class="title_line">
                                <h3><spring:message code="sal.text.thirdParty" /></h3>
                            </aside>

                            <table class="type1">
                                <caption>table</caption>
                                <colgroup>
                                    <col style="width: 170px" />
                                    <col style="width: *" />
                                    <col style="width: 190px" />
                                    <col style="width: *" />
                                </colgroup>

                                <tbody>
                                    <tr>
                                        <th scope="row"><spring:message code="sal.text.customerId" /></th>
                                        <td>
                                            <span id="txtThirdPartyIDOwnt">${rotInfoMap.paymode3rdPartyId}</span>
                                        </td>
                                        <th scope="row"><spring:message code="sal.text.type" /></th>
                                        <td>
                                            <span id="txtThirdPartyTypeOwnt">${rotInfoMap.paymode3rdPartyCtype}</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="sal.text.name" /></th>
                                        <td>
                                            <span id="txtThirdPartyNameOwnt">${rotInfoMap.paymode3rdPartyName}</span>
                                        </td>
                                        <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
                                        <td>
                                            <span id="txtThirdPartyNRICOwnt">${rotInfoMap.paymode3rdPartyNric}</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </section>
                        <!-- *************************************** -->
                        <!-- ********** Third party - End ********** -->
                        <!-- *************************************** -->

                        <!-- **************************************************** -->
                        <!-- ********** Rental Paymode Section - Start ********** -->
                        <!-- **************************************************** -->
                        <section id="sctRentPayMode">
                            <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 170px" />
                                <col style="width: *" />
                                <col style="width: 190px" />
                                <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.rentalPaymode" /></th>
                                    <td>
                                        <span id="cmbRentPaymodeOwnt">${rotInfoMap.paymode}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.nricPassbook" /></th>
                                    <td>
                                        <span id="txtRentPayICOwnt">${rotInfoMap.issuNric}</span>
                                    </td>
                                    </tr>
                                </tbody>
                            </table>
                        </section>

                        <!-- ****************************************************************** -->
                        <!-- ********** Rental Paymode Section - Credit Card - Start ********** -->
                        <!-- ****************************************************************** -->
                        <section id="sctCrCard" class="blind">
                            <aside class="title_line">
                                <h3><spring:message code="sal.page.subtitle.creditCard" /></h3>
                            </aside>

                            <table class="type1 mb1m">
                                <caption>table</caption>
                                <colgroup>
                                    <col style="width: 170px" />
                                    <col style="width: *" />
                                    <col style="width: 190px" />
                                    <col style="width: *" />
                                </colgroup>

                                <tbody>
                                    <tr>
                                        <th scope="row"><spring:message code="sal.text.creditCardNumber" /></th>
                                        <td>
                                            <span id="txtRentPayCRCNoOwnt">${rotInfoMap.custOriCrcNo}</span>
                                        </td>
                                        <th scope="row"><spring:message code="sal.text.creditCardType" /></th>
                                        <td>
                                            <span id="txtRentPayCRCTypeOwnt">${rotInfoMap.crcType}</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="sal.text.nameOnCard" /></th>
                                        <td>
                                            <span id="txtRentPayCRCNameOwnt">${rotInfoMap.custCrcOwner}</span>
                                        </td>
                                        <th scope="row"><spring:message code="sal.text.expiry" /></th>
                                        <td>
                                            <span id="txtRentPayCRCExpiryOwnt">${rotInfoMap.crcExpr}</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="sal.text.issueBank" /></th>
                                        <td>
                                            <span id="txtRentPayCRCBankOwnt">${rotInfoMap.crcBank}</span>
                                        </td>
                                        <th scope="row"><spring:message code="sal.text.cardType" /></th>
                                        <td>
                                            <span id="rentPayCRCCardTypeOwnt">${rotInfoMap.cardType}</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </section>
                        <!-- **************************************************************** -->
                        <!-- ********** Rental Paymode Section - Credit Card - End ********** -->
                        <!-- **************************************************************** -->

                        <!-- ***************************************************************** -->
                        <!-- ********** Rental Paymode Section - Debit Card - Start ********** -->
                        <!-- ***************************************************************** -->
                        <section id="sctDirectDebit" class="blind">
                            <aside class="title_line">
                                <h3><spring:message code="sal.page.subtitle.directDebit" /></h3>
                            </aside>

                            <table class="type1">
                                <caption>table</caption>
                                <colgroup>
                                    <col style="width: 170px" />
                                    <col style="width: *" />
                                    <col style="width: 190px" />
                                    <col style="width: *" />
                                </colgroup>

                                <tbody>
                                    <tr>
                                        <th scope="row"><spring:message code="sal.text.accountNumber" /></th>
                                        <td>
                                            <span id="txtRentPayBankAccNoOwnt">${rotInfoMap.ddAccNo}</span>
                                        </td>
                                        <th scope="row"><spring:message code="sal.text.accountType" /></th>
                                        <td>
                                            <span id="txtRentPayBankAccTypeOwnt">${rotInfoMap.ddAccType}</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="sal.text.accountHolder" /></th>
                                        <td>
                                            <span id="txtRentPayBankAccNameOwnt">${rotInfoMap.custAccOwner}</span>
                                        </td>
                                        <th scope="row"><spring:message code="sal.text.issueBankBranch" /></th>
                                        <td>
                                            <span id="txtRentPayBankAccBankBranchOwnt">${rotInfoMap.ddIssueBankBrnch}</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="sal.text.issueBank" /></th>
                                        <td colspan=3>
                                            <span id="txtRentPayBankAccBankOwnt">${rotInfoMap.ddBank}</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </section>
                        <!-- *************************************************************** -->
                        <!-- ********** Rental Paymode Section - Debit Card - End ********** -->
                        <!-- *************************************************************** -->
                    </section>
                </article>
                <!-- tabRP (Rental Pay Setting) - Start -->

                <!-- tabBG (Rental Billing Group) - Start -->
                <!--
                <article id="billGroup" class="tap_area">
                <a>Intentionally left blank</a>
                </article>
                 -->
                <!-- tabBG (Rental Billing Group) - Start -->

                <!-- tabIN (Installation) - Start -->
                <article class="tap_area">
                    <aside class="title_line">
                        <h3><spring:message code="sal.text.instAddr" /></h3>
                    </aside>

                    <section class="search_table">
                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                            <col style="width: 140px" />
                            <col style="width: *" />
                            <col style="width: 170px" />
                            <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
                                    <td colspan="3">
                                        <span id="txtInstAddrDtlOwnt">${rotInfoMap.instAddr1}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.street" /></th>
                                    <td colspan="3">
                                        <span id="txtInstStreetOwnt">${rotInfoMap.instAddr2}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.area" /><span class="must">*</span></th>
                                    <td colspan="3">
                                        <span id="txtInstAreaOwnt">${rotInfoMap.instArea}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.city" /><span class="must">*</span></th>
                                    <td>
                                        <span id="txtInstCityOwnt">${rotInfoMap.instCity}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">*</span></th>
                                    <td>
                                        <span id="txtInstPostcodeOwnt">${rotInfoMap.instPostcode}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.state" /><span class="must">*</span></th>
                                    <td>
                                        <span id="txtInstStateOwnt">${rotInfoMap.instState}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
                                    <td>
                                        <span id="txtInstCountryOwnt">${rotInfoMap.instCountry}</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <aside class="title_line">
                            <h3><spring:message code="sal.title.text.installCntcPerson" /></h3>
                        </aside>

                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 140px" />
                                <col style="width: *" />
                                <col style="width: 170px" />
                                <col style="width: *" />
                                <col style="width: 170px" />
                                <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
                                    <td>
                                        <span id="txtInstContactNameOwnt">${rotInfoMap.instCntcName}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.initial" /></th>
                                    <td>
                                        <span id="txtInstContactInitialOwnt">${rotInfoMap.instCntcInitial}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.gender" /></th>
                                    <td>
                                        <span id="txtInstContactGenderOwnt">${rotInfoMap.instCntcGender}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.nric" /></th>
                                    <td>
                                        <span id="txtInstContactICOwnt">${rotInfoMap.instCntcNric}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.dob" /></th>
                                    <td>
                                        <span id="txtInstContactDOBOwnt">${rotInfoMap.instCntcDob}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.race" /></th>
                                    <td>
                                        <span id="txtInstContactRaceOwnt">${rotInfoMap.instCntcRace}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.email" /></th>
                                    <td>
                                        <span id="txtInstContactEmailOwnt">${rotInfoMap.instCntcEmail}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.dept" /></th>
                                    <td>
                                        <span id="txtInstContactDeptOwnt">${rotInfoMap.instCntcDept}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.post" /></th>
                                    <td>
                                        <span id="txtInstContactPostOwnt">${rotInfoMap.instCntcPost}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.telM" /></th>
                                    <td>
                                        <span id="txtInstContactTelMobOwnt">${rotInfoMap.instTelM}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.telR" /></th>
                                    <td>
                                        <span id="txtInstContactTelResOwnt">${rotInfoMap.instTelR}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.text.telO" /></th>
                                    <td>
                                        <span id="txtInstContactTelOffOwnt">${rotInfoMap.instTelO}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.text.telF" /></th>
                                    <td>
                                        <span id="txtInstContactTelFaxOwnt">${rotInfoMap.instTelF}</span>
                                    </td>
                                    <th scope="row"></th>
                                    <td></td>
                                    <th scope="row"></th>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>

                        <aside class="title_line">
                            <h3><spring:message code="sal.title.text.installInfomation" /></h3>
                        </aside>

                        <table class="type1">
                            <caption>table</caption>
                            <colgroup>
                                <col style="width: 140px" />
                                <col style="width: *" />
                                <col style="width: 170px" />
                                <col style="width: *" />
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /><span class="must">*</span></th>
                                    <td colspan="3">
                                        <span id="cmbDSCBranchOwnt">${rotInfoMap.brnchName}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.title.text.perferInstDate" /><span class="must">*</span></th>
                                    <td>
                                        <span id="dpPreferInstDateOwnt">${rotInfoMap.preInstDt}</span>
                                    </td>
                                    <th scope="row"><spring:message code="sal.title.text.perferInstTime" /><span class="must">*</span></th>
                                    <td>
                                        <span id="tpPreferInstTimeOwnt">${rotInfoMap.preInstTm}</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><spring:message code="sal.title.text.specialInstruction" /><span class="must">*</span></th>
                                    <td colspan=3>
                                        <span id="txtInstSpecialInstructionOwnt">${rotInfoMap.instct}</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </section>
                </article>
                <!-- tabIN (Installation) - End -->
            </section>
            <!-- ROT Details - End -->
        </article>
        <!-- ********************************************************************************** -->
        <!-- ROT Tab - End -->
        <!-- ********************************************************************************** -->

        <!-- ********************************************************************************** -->
        <!-- ROT Call Log Tab - Start -->
        <!-- ********************************************************************************** -->
        <article class="tap_area">
            <form action="#" id="rotCLForm" method="post">
                <input type="hidden" id="newMemAccId" name="newMemAccId">

                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:190px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row">Respond By</th>
                            <td>
                                <input type="text" title="" placeholder="" class="" id="newMemAccName" name="memAccId"/>
                                <a href="#" class="search_btn" id="supplier_search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Date</th>
                            <td>
                                <input type="text" title="Call Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="callDt" name="callDt"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">ROT Call Log Status</th>
                            <td>
                                <select id="callLogStus" name="callLogStus" class="w100p">
                                    <option value="">Select One</option>
                                    <option value="ACT">Active</option>
                                    <option value="VER">Verification</option>
                                    <option value="APP">Approve</option>
                                    <option value="ONH">On-Hold</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Remark</th>
                            <td>
                                <textarea cols="20" rows="5" id="callLogRem" name="callLogRem" maxlength="500" placeholder="Enter up to 500 characters"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <aside class="title_line">
                    <ul class="center_btns">
                        <li><p class="btn_blue2"><a href="#" id="rotCL_add_btn">Add</a></p></li>
                    </ul>
                </aside>

                <!--  ROT Call Log Grid Wrap - Start -->
                <article class="grid_wrap">
                    <div id="callLog_grid_wrap" style="width:100%; margin:0 auto;"></div>
                </article>
                <!--  ROT Call Log Grid Wrap - End -->

                <aside class="title_line">
                    <ul class="center_btns">
                        <li><p class="btn_blue2"><a href="#" id="save_rotCLbtn">Save Call Log</a></p></li>
                    </ul>
                </aside>
            </form>
        </article>
        <!-- ********************************************************************************** -->
        <!-- ROT Call Log Tab - End -->
        <!-- ********************************************************************************** -->

        <!-- ********************************************************************************** -->
        <!-- ROT History Tab - Start -->
        <!-- ********************************************************************************** -->
        <article class="tap_area">
            <!--  ROT Call Log Grid Wrap - Start -->
            <article class="grid_wrap">
                <div id="rotHist_grid_wrap" style="width:100%; margin:0 auto;"></div>
            </article>
            <!--  ROT Call Log Grid Wrap - End -->
        </article>
        <!-- ********************************************************************************** -->
        <!-- ROT History Tab - End -->
        <!-- ********************************************************************************** -->

    </section>
    <!-- tap_wrap - End -->
    <!--
      ****************************************************************************
                                         Ownership Transfer Update END
      *****************************************************************************
    -->
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->