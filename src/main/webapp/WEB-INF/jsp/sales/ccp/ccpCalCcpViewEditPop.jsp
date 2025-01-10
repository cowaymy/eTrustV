<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* 커스텀 행 스타일 */
.my-yellow-style {
    background:#FFE400;
    font-weight:bold;
    color:#22741C;
}

.my-pink-style {
    background:#FFA7A7;
    font-weight:bold;
    color:#22741C;
}

.my-green-style {
    background:#86E57F;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript">

var optionUnit = { isShowChoose: false};
var optionModule = {
        type: "S",
        isShowChoose: false
};

var myFileCaches = {};

$(function() {
    $('#_updSmsMsg').keyup(function (e){

        var content = $(this).val();

       // $(this).height(((content.split('\n').length + 1) * 2) + 'em');

        $('#_charCounter').html('Total Character(s) : '+content.length);
    });
    $('#_updSmsMsg').keyup();
});


$(document).ready(function() {

   /*  //to List
    $("#_btnList").click(function() {
        window.close();
    }); */

    $("#_btnClose").click(function() {
        window.close();
    });

    var firstDateCalled = "${ccpInfoMap.firstCallDt}";

   if(firstDateCalled != null && firstDateCalled != '' && "${SESSION_INFO.roleId}" != "206"){
        $("#firstCallDate").val("${ccpInfoMap.firstCallDt}");
        $("#firstCallDate").attr("class", "w100p readonly");
        $("#firstCallDate").attr("readonly", "readonly");
    }else{
        $("#firstCallDate").val("${ccpInfoMap.firstCallDt}");
    }

    $("#custIsPayerValue").val("${ccpInfoMap.custIsPayer}");
    $("#thePayerValue").val("${ccpInfoMap.thePayer}");
    $("#failVeriReasonValue").val("${ccpInfoMap.failVerRsn}");

    var bankruptcy = '${ccpInfoMap.ctosBankrupt}' == 1 ? "YES" : "NO";
    $("#bankruptcy").text(bankruptcy);

    if('${ccpInfoMap.fileName}' != null && '${ccpInfoMap.fileName}' != "" ){
    	 $("#ccpAttachFileField").hide();
    	 $("#ccpAttachTxtField").show();
    }else{
    	$("#ccpAttachFileField").show();
    	$("#ccpAttachTxtField").hide();
    }

    var chsStatus = '${ccpInfoMap.chsStus}';
    var chsRsn = '${ccpInfoMap.chsRsn}';
     console.log("chsStatus : "+ chsStatus);
     console.log("chsRsn : "+ chsRsn);
     if(chsStatus == "YELLOW") {
        $('#chs_stus').append("<span class='red_text'>"+chsStatus+"</span>");
        $('#chs_rsn').append("<span class='red_text'>"+chsRsn+"</span>");

        $('#ctosScoreRow, #experianScoreRow, #scoreGrpRow').addClass("blind");
    }else if (chsStatus == "GREEN") {
        $('#chs_stus').append("<span class='black_text''>"+chsStatus+"</span>");
        $('#chs_rsn').append("<span class='black_text'>"+chsRsn+"</span>");

        $('#ctosScoreRow, #experianScoreRow, #scoreGrpRow').addClass("blind");
    }else{
        $('#chs_stus').append("<span class='black_text''>"+chsStatus+"</span>");
        $('#chs_rsn').append("<span class='black_text'>"+chsRsn+"</span>");

        $('#ctosScoreRow, #experianScoreRow, #scoreGrpRow').removeClass("blind");
    }

     $("#man1").hide();
     $("#man2").hide();
     $("#man3").hide();
     var custType =  $('#_editCustTypeId').val();
     if(custType == "965"){
         $("#man1").show();
         $("#man2").show();
         $("#man3").show();
     }

     $('#eResubmitAtch').hide();
     $('#eResubmitTh').hide();
     $('#eResubmitTd').hide();
     console.log('${ccpEresubmitMap.salesOrdId}');
     if(!('${ccpEresubmitMap.salesOrdId}' == "" && '${ccpEresubmitMap.salesOrdId}' =="")){
         var elements = document.getElementsByClassName("auto_file3");
            for(var i = 0; i < elements.length; i++) {
                elements[i].className = "auto_file3 auto_file2";
            }

         $('#eResubmitAtch').show();
         $('#eResubmitTh').show();
         $('#eResubmitTd').show();
         if('${ccpEresubmitMap.atchFileGrpId}' != 0){
             fn_loadAtchment('${ccpEresubmitMap.atchFileGrpId}');
         }
     }


    //Init
    var mst = getMstId();
    var ordUnitSelVal = $("#_ordUnitSelVal").val();
    var rosUnitSelVal = $("#_rosUnitSelVal").val();
    var susUnitSelVal = $("#_susUnitSelVal").val();
    var custUnitSelVal = $("#_custUnitSelVal").val();

    getUnitCombo(mst, 212  , ordUnitSelVal , '_ordUnit');
    getUnitCombo(mst, 213  , rosUnitSelVal , '_ordMth');
    getUnitCombo(mst, 216  , susUnitSelVal , '_ordSuspen');
    getUnitCombo(mst, 210  , custUnitSelVal , '_ordExistingCust');

    //Income Range ComboBox
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
    //doGetCombo('/sales/ccp/getLoadIncomeRange', {editCcpId : ccpId} , selVal ,'_incomeRangeEdit', 'S');
    //CommonCombo.make('_incomeRangeEdit', '/sales/ccp/getLoadIncomeRange' , {editCcpId : ccpId}, selVal , optionModule);

    //Ccp Status
    var ccpStus = $("#_ccpStusId").val();
    doGetCombo('/sales/ccp/getCcpStusCodeList2', '', ccpStus,'_statusEdit', 'S');
    //Ccp eResubmit Status
    var ccpErStus = $("#_eRStusId").val();
    doGetCombo('/sales/ccp/getCcpStusCodeList', '', ccpErStus,'_eRstatusEdit', 'S');
    //Reject
    doGetCombo('/sales/ccp/getCcpRejectCodeList', '', '','_rejectStatusEdit', 'S'); //Status
    //Feedback
    var selReasonCode = $("#_ccpResnId").val();
    doGetCombo('/sales/ccp/selectReasonCodeFbList', '', selReasonCode,'_reasonCodeEdit', 'S'); //Reason

    //Bind Filed
    bind_RetrieveData();

    //Disabled ComboBox
    $("#_ordUnit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    $("#_ordMth").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    $("#_ordSuspen").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    $("#_ordExistingCust").attr({"disabled" : "disabled" , "class" : "w100p disabled"});

    //CCP SMS Suspense
    $("#_smsDiv").css("display" , "none");

    //SMS Checked
    // Consignment Change
    $("#_updSmsChk").change(function() {
        //Init
        $("#_updSmsMsg").val('');
        $("#_updSmsMsg").attr("disabled" , "disabled");
        if($("#_updSmsChk").is(":checked") == true){
            /* if(isAllowSendSMS() == true){
                $("#_updSmsMsg").attr("disabled" , false);
                setSMSMessage();
            } */

            var currStus = $("#_statusEdit").val();
            if(currStus != null && currStus != ''){
                fn_ccpStatusChangeFunc(currStus);
            }
        }
    });

    $('#ccpAttachFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[1] != null){
            delete myFileCaches[1];
        }else if(file != null){
            myFileCaches[1] = {file:file};
        }
    });

    //Save
    $("#_calBtnSave").click(function() {

        //Validation
        if( null == $("#_statusEdit").val() || '' == $("#_statusEdit").val()){
             Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Status'/>");
             return;
        }else{
            /*
            if( '6' == $("#_statusEdit").val()){
                if(null == $("#_rejectStatusEdit").val() || '' == $("#_rejectStatusEdit").val()){
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Reject Status'/>");
                    return;
                }
            }
            */
            if( '6' == $("#_statusEdit").val() || '1' == $("#_statusEdit").val()) {
                if(null == $("#_reasonCodeEdit").val() || '' == $("#_reasonCodeEdit").val()){
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Feedback Code'/>");
                    return;
                }
            }
        }

        var custType =  $('#_editCustTypeId').val();
        if(custType == "965"){
            if($('#cowayTemplate').val() == "" && $("#agmReq").is(":checked") == true){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Coway Template'/>");
                return;
            }
            if($('#cntPeriodValue').val() == "0" && $("#agmReq").is(":checked") == true){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Contract Period'/>");
                return;
            }
        }else{
            if($('#cowayTemplate').val() == ""){
                $('#cowayTemplate').val("0");
            }
        }
        /*
        if( null == $("#_incomeRangeEdit").val() || '' == $("#_incomeRangeEdit").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Income Range'/>");
            return;
        }
        */
        if( null == $("#_ficoScore").val() || '' == $("#_ficoScore").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Fico Score' />");
            return;
        }else{
            //if( $("#_ficoScore").val() > 850 || $("#_ficoScore").val() < 300 && $("#_ficoScore").val() !=  0){
            if( $("#_ficoScore").val() > 9999 || $("#_ficoScore").val() < 0){
                Common.alert('<spring:message code="sal.alert.text.ficoRange" />');
                return;
            }
        }

        //EXPERIAN
        if( null == $("#_experianScore").val() || '' == $("#_experianScore").val()){
            Common.alert("* Please Enter Experian Score");
            return;
        }else{
            if( $("#_experianScore").val() > 9999 || $("#_experianScore").val() < 0){
                Common.alert("* Please key in Experian score range between 0 to 800 points.");
                return;
            }
        }

        if( null == $("#_experianRisk").val() || '' == $("#_experianRisk").val()){
            Common.alert("* Please Enter Experian Risk");
            return;
        }else{
            if( $("#_experianRisk").val() < 0 || ($("#_experianRisk").val() > 10 && $("#_experianRisk").val() != 9999) ){
                Common.alert("* Please key in Experian Risk range between 0 to 10 points.");
                return;
            }
        }
        //EXPERIAN

        //Validation (Call Entry Count)
        var ccpOrdEditId = $("#_editOrdId").val();
        var salData = {salesOrdId : ccpOrdEditId};
        var sst = '${orderDetail.basicInfo.corpCustTypeId}';

        console.log(salData);
        var callEntCount = 0;

        if(sst == 5495 || sst == 5496){
            callEntCount = 0;
        }
        else{
        Common.ajaxSync("GET", "/sales/ccp/countCallEntry", salData , function(result) {
            callEntCount = result.totCount;
            console.log("Call Entry Count : " + callEntCount);
        });
        }





        /* if(callEntCount > 0){
            Common.alert('<spring:message code="sal.alert.msg.existInCallEtry" />');
            return;
        } */
       //Validation Success - Save
       //Check box params Setting
       //_letterOfUdt
       if($("#_letterOfUdt").is(":checked") == true){
           $("#_letterOfUdt").val("1");
       }else{
           $("#_letterOfUdt").val("0");
       }
       //_summon
       if($("#_summon").is(":checked") == true){
           $("#_summon").val("1");
       }else{
           $("#_summon").val("0");
       }
       //_onHoldCcp
       if($("#_onHoldCcp").is(":checked") == true){
           $("#_onHoldCcp").val("1");
       }else{
           $("#_onHoldCcp").val("0");
       }
       //SMS
       if($("#_updSmsChk").is(":checked") == true){
           $("#_isChkSms").val("1");

           //msg setting
           var realMsg =   $("#_updSmsMsg").val();
           $("#_hiddenUpdSmsMsg").val(realMsg); //msg contents
           var salesmanPhNum = $("#_editSalesManTelMobile").val();
           $("#_hiddenSalesMobile").val(salesmanPhNum);

       }else{
           $("#_isChkSms").val("0");
       }
       //_summon
       if($("#agmReq").is(":checked") == true){
           $("#agmReq").val("1");
       }else{
           $("#agmReq").val("0");
       }
       //_summon
       /* if($("#cowayTemplate").is(":checked") == true){
           $("#cowayTemplate").val("1");
       }else{
           $("#cowayTemplate").val("0");
       } */
       calSave();

    });//Save End


});//Doc Ready Func End

function fn_loadAtchment(atchFileGrpId) {
    Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
        //console.log(result);
       if(result) {
            if(result.length > 0) {
                $("#attachTd").html("");
                for ( var i = 0 ; i < result.length ; i++ ) {
                    switch (result[i].fileKeySeq){
                    case '1':
                        sofFrId = result[i].atchFileId;
                        sofFrName = result[i].atchFileName;
                        $(".input_text[id='sofFrFileTxt']").val(sofFrName);
                        break;
                    case '2':
                        softcFrFileId = result[i].atchFileId;
                        softcFrFileName = result[i].atchFileName;
                        $(".input_text[id='softcFrFileTxt']").val(softcFrFileName);
                        break;
                    case '3':
                        nricFrFileId = result[i].atchFileId;
                        nricFrFileName = result[i].atchFileName;
                        $(".input_text[id='nricFrFileTxt']").val(nricFrFileName);
                        break;
                    case '4':
                        msofFrFileId = result[i].atchFileId;
                        msofFrFileName = result[i].atchFileName;
                        $(".input_text[id='msofFrFileTxt']").val(msofFrFileName);
                        break;
                    case '5':
                        msoftcFrFileId = result[i].atchFileId;
                        msoftcFrFileName = result[i].atchFileName;
                        $(".input_text[id='msoftcFrFileTxt']").val(msoftcFrFileName);
                        break;
                    case '6':
                        payFrFileId = result[i].atchFileId;
                        payFrFileName = result[i].atchFileName;
                        $(".input_text[id='payFrFileTxt']").val(payFrFileName);
                        break;
                    case '7':
                        govFrFileId = result[i].atchFileId;
                        govFrFileName = result[i].atchFileName;
                        $(".input_text[id='govFrFileTxt']").val(govFrFileName);
                        break;
                    case '8':
                        letFrFileId = result[i].atchFileId;
                        letFrFileName = result[i].atchFileName;
                        $(".input_text[id='letFrFileTxt']").val(letFrFileName);
                        break;
                    case '9':
                        docFrFileId = result[i].atchFileId;
                        docFrFileName = result[i].atchFileName;
                        $(".input_text[id='docFrFileTxt']").val(docFrFileName);
                        break;
                     default:
                         Common.alert("no files");
                    }
                }

                // 파일 다운
                $(".input_text").dblclick(function() {
                    var oriFileName = $(this).val();
                    var fileGrpId;
                    var fileId;
                    for(var i = 0; i < result.length; i++) {
                        if(result[i].atchFileName == oriFileName) {
                            fileGrpId = result[i].atchFileGrpId;
                            fileId = result[i].atchFileId;
                        }
                    }
                    if(fileId != null) fn_atchViewDown(fileGrpId, fileId);
                });
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
        //console.log(result)
        var fileSubPath = result.fileSubPath;
        fileSubPath = fileSubPath.replace('\', '/'');

        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            //console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            //console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function calSave(){

    var ordUnit = $("#_ordUnit").val();
    var rosUnit = $("#_ordMth").val();
    var susUnit = $("#_ordSuspen").val();
    var custUnit = $("#_ordExistingCust").val();

    $("#_saveOrdUnit").val(ordUnit);
    $("#_saveRosUnit").val(rosUnit);
    $("#_saveSusUnit").val(susUnit);
    $("#_saveCustUnit").val(custUnit);

    var fileName = $("#ccpAttachFile").val().split('\\');
    var atchFileGrpId = '';
    var atchFileId = '';

    var formData = new FormData();
    $.each(myFileCaches, function(n, v) {
        console.log("n : " + n + " v.file : " + v.file);
        formData.append(n, v.file);
    });
debugger;
console.log("fileName = " + fileName);
console.log("grpId = " + $("#atchFileGrpId").val() );
    if(fileName != null && fileName != "" && $.trim(fileName) != ""){
      Common.ajaxFile("/sales/ccp/attachCcpReportFileUpload.do", formData, function(result) {
    	  atchFileGrpId = result.data.fileGroupKey;
          atchFileId = result.data.atchFileId;

    	  $("#atchFileGrpId").val(atchFileGrpId);

    	  fn_save();
      });

    }else{
    	fn_save();
    }
}

function fn_save(){
	Common.ajax("POST", "/sales/ccp/calSave", $("#calSaveForm").serializeJSON() , function(result) {

        var msg = "";

        msg += '<spring:message code="sal.alert.msg.successBr" />';
        //msg += result.message; //SMS Result

        //Common.alert(msg);
        //Btn Disabled
        $("#_calBtnSave").css("display" , "none");

        //Make View
        $("#_ordUnit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordMth").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordSuspen").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordExistingCust").attr({"disabled" : "disabled" , "class" : "w100p disabled"});

        $("#_statusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_eRstatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_incomeRangeEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_reasonCodeEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_spcialRem").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_pncRem").attr({"disabled" : "disabled" , "class" : "w100p disabled"});

        $("#_letterOfUdt").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_summon").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_onHoldCcp").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_updSmsChk").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_updSmsMsg").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ficoScore").attr({"disabled" : "disabled" , "class" : "w100p disabled"});

        //experian
        $("#_experianScore").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_experianRisk").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        //experian

        Common.alert(msg);
        $("#_calSearch").click();
    });
}

function fn_ccpStatusChangeFunc(getVal){

    var isHold = $("#_onHoldCcp").is("checked") == true? 1 : 0;
    var ficoScre = '${ccpInfoMap.ccpFico}'; //FICO SCORE
    var bankrupt = '${ccpInfoMap.ctosBankrupt}'; //BANKRUPT  //CTOS_BANKRUPT

    //experian
    var experianScore = '${ccpInfoMap.ccpExperians}';
    var experianRisk = '${ccpInfoMap.ccpExperianr}';
    var experianbankrupt = '${ccpInfoMap.experianBankrupt}';
    var expPrcss = '${ccpInfoMap.expPrcss}';

    //Init
    $("#_smsDiv").css("display" , "none");
    $("#_updSmsChk").attr("checked" , false);
    $("#_updSmsMsg").val('');
    $("#_updSmsMsg").attr("disabled" , "disabled");


    if(getVal != null && getVal != ''){

        if(getVal == '1'){  //ACTIVE

            //field
            $("#_incomeRangeEdit").attr("disabled" , false);
            $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_reasonCodeEdit").attr("disabled" , false);
            $("#_spcialRem").attr("disabled" , false);
            $("#_pncRem").attr("disabled" , false);
            $("#_eRstatusEdit").attr("disabled" , false);

           if($("#_editCustTypeId").val() == '964' && $("#_editCustNation").val() == 'MALAYSIA'){
               $("#_ficoScore").attr("disabled" , false);
               //experian
               $("#_experianScore").attr("disabled" , false);
               $("#_experianRisk").attr("disabled" , false);
               //experian
           }else{
               $("#_ficoScore").val("0");
               $("#_ficoScore").attr("disabled" , "disabled");
               //experian
               $("#_experianScore").val("0");
               $("#_experianScore").attr("disabled" , "disabled");
               $("#_experianRisk").val("0");
               $("#_experianRisk").attr("disabled" , "disabled");
               //experian
           }

             //chkbox
            $("#_onHoldCcp").attr("disabled" , false);
            $("#_summon").attr("disabled" , false);
            $("#_letterOfUdt").attr("disabled" , false);

            if (expPrcss == 0){
            	if(ficoScre >= 350 && ficoScre <= 450){
                    if(isHold == 0){   ////on hold
                    	$("#_reasonCodeEdit").val("2177");
                    }
            	}else if(ficoScre >= 451 && ficoScre <= 500){
                    if(bankrupt == 1 && isHold == 0){
                    	$("#_reasonCodeEdit").val("1872");
                    }
            	}else if(ficoScre == 0){
                    if(bankrupt == 1 && isHold == 0){
                    	$("#_reasonCodeEdit").val("1872");
                    }
            	}
            }

            // 20210617 - LaiKW- Uncommented allow SMS section
            //20230519 - Keyi - CCP SMS Suspend
            /* if(isAllowSendSMS() == true){
                $("#_smsDiv").css("display" , "");
                $("#_updSmsChk").prop('checked', true) ;
                $("#_updSmsMsg").attr("disabled" , false);
                setSMSMessage('Active', $("#_reasonCodeEdit option:selected").text());
            } */

            //20230519 - Keyi CCP SMS Suspend
            /* if (expPrcss == 0){
                //sms  changed by Lee(2018/01/18)
                if(ficoScre >= 350 && ficoScre <= 450){
                    if(isHold == 0){   ////on hold
                        if(isAllowSendSMS() == true){
                            $("#_smsDiv").css("display" , "");
                            $("#_updSmsChk").prop('checked', true) ;
                            $("#_updSmsMsg").attr("disabled" , false);
                            $("#_reasonCodeEdit").val("2177");
                            setSMSMessage('Pending' , $("#_reasonCodeEdit option:selected").text());
                        }
                    } //
                }else if(ficoScre >= 451 && ficoScre <= 500){
                    if(bankrupt == 1 && isHold == 0){
                        if(isAllowSendSMS() == true){
                            $("#_smsDiv").css("display" , "");
                            $("#_updSmsChk").prop('checked', true) ;
                            $("#_updSmsMsg").attr("disabled" , false);
                            $("#_reasonCodeEdit").val("1872");
                            setSMSMessage('Pending' , $("#_reasonCodeEdit option:selected").text());
                        }
                    }
                }else if(ficoScre == 0){
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
            }else if (expPrcss == 1){
                if(experianScore == 0 && experianRisk == 0){
                    if(experianbankrupt > 0 && isHold == 0){   //on hold
                        if(isAllowSendSMS() == true){
                            $("#_smsDiv").css("display" , "");
                            $("#_updSmsChk").prop('checked', true) ;
                            $("#_updSmsMsg").attr("disabled" , false);
                            setSMSMessage('REQUEST ADVANCE' , 'NO SCORE - REQUEST 1Y OR 2YRS ADVANCE RENTAL FEE');
                        }
                    } //
                }else if(experianScore == 9999 && experianRisk == 0){
                    if(experianbankrupt > 0 && isHold == 0){
                        if(isAllowSendSMS() == true){
                            $("#_smsDiv").css("display" , "");
                            $("#_updSmsChk").prop('checked', true) ;
                            $("#_updSmsMsg").attr("disabled" , false);
                            setSMSMessage('REQUEST ADVANCE' , 'NO SCORE - REQUEST 1Y OR 2YRS ADVANCE RENTAL FEE');
                        }
                    }
                }
            } */
        }else if(getVal == '5'){  // APPROVE

             //field //FICO it doesn`t work
             $("#_incomeRangeEdit").attr("disabled" , false);
             $("#_rejectStatusEdit").val('');
             $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
             $("#_reasonCodeEdit").attr("disabled" , false);
             $("#_spcialRem").attr("disabled" , false);
             $("#_pncRem").attr("disabled" , false);
             $("#_eRstatusEdit option[value=5]").attr('selected', 'selected');
             $("#_eRstatusEdit").attr("disabled" , true);

              //chkbox
             $("#_onHoldCcp").attr("checked" , false);
             $("#_onHoldCcp").attr("disabled" , "disabled");
             $("#_summon").attr("disabled" , false);
             $("#_letterOfUdt").attr("disabled" , false);

             //Fico Ajax Call
             var ccpid = $("#_editCcpId").val();
             var data = {ccpId : ccpid};
             Common.ajax("GET", "/sales/ccp/getFicoScoreByAjax", data , function(result) {
                 $("#_ficoScore").val(result.ccpFico);
                 $("#_ficoScore").attr("disabled" , false);
                 //experian
                 $("#_experianScore").val(result.ccpExperians);
                 $("#_experianScore").attr("disabled" , false);
                 $("#_experianRisk").val(result.ccpExperianr);
                 $("#_experianRisk").attr("disabled" , false);
                 //experian
             });

             //CCP Feedback Code not sync (20230607)
             $("#_reasonCodeEdit").val('');

             //sms Changed by Lee (2018/01/18)
             //20230519 Keyi CCP SMS Suspend
             /* if(isAllowSendSMS() == true){
                 if(isHold == 0){
                     $("#_smsDiv").css("display" , "");
                     $("#_updSmsMsg").attr("disabled" , false);
                     //$("#_updSmsChk").prop('checked', true) ;
                     $("#_updSmsChk").prop('checked', true) ;
                     $("#_reasonCodeEdit").val('');
                     setSMSMessage('Approved' , ' ');
                 }
             } */
        }else if(getVal == '6'){  //CANCEL

            //field
            $("#_incomeRangeEdit").attr("disabled" , false);
            $("#_rejectStatusEdit").attr({"disabled" : false , "class" : "w100p"});
            $("#_reasonCodeEdit").attr("disabled" , false);
            $("#_spcialRem").attr("disabled" , false);
            $("#_pncRem").attr("disabled" , false);
            $("#_eRstatusEdit option[value=6]").attr('selected', 'selected');
            $("#_eRstatusEdit").attr("disabled" , true);
            //chkbox
            $("#_onHoldCcp").attr("checked" , false);
            $("#_onHoldCcp").attr("disabled" , "disabled");
            $("#_summon").attr("disabled" , false);
            $("#_letterOfUdt").attr("disabled" , false);

            $("#_ficoScore").val("0");
            $("#_ficoScore").attr("disabled" , "disabled");

            //experian
            $("#_experianScore").val("0");
            $("#_experianScore").attr("disabled" , "disabled");
            $("#_experianRisk").val("0");
            $("#_experianRisk").attr("disabled" , "disabled");
            //experian
        }

    }

}

function fn_ccpScoreChangeFunc(ccpFico, ccpExperianr){

//     let score_group_style = "";
//     let score_group_desc = "";

//  if((ccpFico >= 701 && ccpFico <= 850) || (ccpExperianr >= 9 && ccpExperianr <= 10)){
//  score_group_style = "green_text";
//  score_group_desc  = "Excellent Score"
//}else if((ccpFico >= 551 && ccpFico <= 700) || (ccpExperianr >= 4 && ccpExperianr <= 8)){
//  score_group_style = "green_text";
//  score_group_desc = "Good Score"
//}else if((ccpFico >= 300 && ccpFico <= 550) || (ccpExperianr >= 1 && ccpExperianr <= 3)){
//  score_group_style = "black_text";
//  score_group_desc = "Low Score";
//}else if(ccpFico == 9999 || ccpExperianr == 9999){
//  score_group_style = "red_text";
//  score_group_desc = "No Score Insufficient CCRIS";
//}else{
//  score_group_style = "red_text";
//  score_group_desc = "No Score";
//}

//$('#score_group').addClass(score_group_style).text(score_group_desc);

    var scoreProv, score;

    if(ccpFico > 0){
    	scoreProv = "CTOS";
    	score = ccpFico;

    }else if(ccpExperianr > 0){
    	scoreProv = "EXPERIAN";
    	score= ccpExperianr;

    }else{
    	scoreProv = "CTOS";
        score = ccpFico;
    }

    var data = {
    		scoreProv : scoreProv,
    		score : score,
    		homeCat : '${ccpInfoMap.homeCat}',
    		ccpStus: '${ccpInfoMap.ccpStusId}',
    		ccpUpdDt : '${ccpInfoMap.ccpUpdDt}',
    		custCat: ( '${ccpInfoMap.custCat}' == null ) ? "NULL" : '${ccpInfoMap.custCat}'
    };

    Common.ajax("GET", "/sales/ccp/getScoreGrpByAjax", data , function(result) {
    	if(result != null){
    		$('#score_group').text(result.scoreGrp);
	        $('#unitEntitle').text(result.unitEntitle);
	        $('#prodEntitle').text(result.prodEntitle);
	    }
    });
}

function  bind_RetrieveData(){

    var ccpStus = $("#_ccpStusId").val();
    var ficoScre = '${ccpInfoMap.ccpFico}'; //FICO SCORE
    var bankrupt = '${ccpInfoMap.ctosBankrupt}'; //BANKRUPT  //CTOS_BANKRUPT
    var ccpHold = '${ccpInfoMap.ccpIsHold}';  // 0 , 1
    //EXPERIAN
    var expScre = '${ccpInfoMap.ccpExperians}'; //EXPERIAN SCORE
    var expRisk = '${ccpInfoMap.ccpExperianr}'; //EXPERIAN RISK
    var expBankrupt = '${ccpInfoMap.experianBankrupt}'; //EXPERIAN_BANKRUPT
    var expPrcss = '${ccpInfoMap.expPrcss}';
    //EXPERIAN

    console.log("ccpStus : " + ccpStus +", ficoScre : " + ficoScre + " , bankrupt : " + bankrupt + ", expScre : " + expScre + ", expRisk : " + expRisk + ", expBankrupt : " + expBankrupt + ", ccpHold : " + ccpHold);
    //pre Value
    $("#_isPreVal").val("1");
    //Fico
     if($("#_editCustTypeId").val() == '964' && $("#_editCustNation").val() == 'MALAYSIA'){
         $("#_ficoScore").attr("disabled" , false);
         //experian
         $("#_experianScore").attr("disabled" , false);
         $("#_experianRisk").attr("disabled" , false);
         //experian
     }else{
         $("#_ficoScore").val("0");
         $("#_ficoScore").attr("disabled" , "disabled");
         //experian
         $("#_experianScore").val("0");
         $("#_experianScore").attr("disabled" , "disabled");
         $("#_experianRisk").val("0");
         $("#_experianRisk").attr("disabled" , "disabled");
         //experian
     }
    //bind and Setting by CcpStatus
    if(ccpStus == "1"){

        //field
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

        //CCP Feedback Code not sync (20230607)
        if (expPrcss == 0){
        	if(ficoScre >= 350 && ficoScre <= 450){
                if(ccpHold == 0){////on hold
                    $("#_reasonCodeEdit").val("2177");
                }
            }else if(ficoScre >= 451 && ficoScre <= 500){
                if(bankrupt == 1 && ccpHold == 0){
                     $("#_reasonCodeEdit").val("1872");
                }
            }else if(ficoScre == 0){
                if(bankrupt == 1 && ccpHold == 0){
                        $("#_reasonCodeEdit").val("1872");
                }
            }
        }


        // 20210617 - LaiKW - Uncommented
        // 20230519 - Keyi - CCP SMS Suspend
        /* if(isAllowSendSMS() == true){
            $("#_smsDiv").css("display" , "");
            $("#_updSmsChk").prop('checked', true) ;
            $("#_updSmsMsg").attr("disabled" , false);
            setSMSMessage('Active', $("#_reasonCodeEdit option:selected").text());
        } */

        // 20230519 - Keyi - CCP SMS Suspend
        /* if (expPrcss == 0){
            //sms  changed by Lee(2018/01/18)

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
        }else if (expPrcss == 1){
            if(expScre == 0 && expRisk == 0){
                if(expBankrupt > 0 && ccpHold == 0){   //on hold
                    if(isAllowSendSMS() == true){
                        $("#_smsDiv").css("display" , "");
                        $("#_updSmsChk").prop('checked', true) ;
                        $("#_updSmsMsg").attr("disabled" , false);
                        setSMSMessage('REQUEST ADVANCE' , 'NO SCORE - REQUEST 1Y OR 2YRS ADVANCE RENTAL FEE');
                    }
                } //
            }else if(expScre == 9999 && (expRisk == 0 || expRisk == 9999)){
                if(expBankrupt > 0 && ccpHold == 0){
                    if(isAllowSendSMS() == true){
                        $("#_smsDiv").css("display" , "");
                        $("#_updSmsChk").prop('checked', true) ;
                        $("#_updSmsMsg").attr("disabled" , false);
                        setSMSMessage('REQUEST ADVANCE' , 'NO SCORE - REQUEST 1Y OR 2YRS ADVANCE RENTAL FEE');
                    }
                }
            }
        } */


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

        /* if(isAllowSendSMS() == true){

            $("#_smsDiv").css("display" , "");
            $("#_updSmsChk").prop('checked', true) ;
            $("#_updSmsMsg").attr("disabled" , false);
            setSMSMessage();
        } */

        //sms  changed by Lee(2018/01/18)
       /*  if(ficoScre >= 501 && ficoScre <= 850){
            if(ccpHold == 0){   ////on hold
                if(isAllowSendSMS() == true){
                    $("#_smsDiv").css("display" , "");
                    $("#_updSmsChk").prop('checked', true) ;
                    $("#_updSmsMsg").attr("disabled" , false);
                    setSMSMessage('Approved' , ' ');
                }
            }
        }else if(ficoScre >= 451 && ficoScre <= 500){
            if(bankrupt == 0 && ccpHold == 0){
                if(isAllowSendSMS() == true){
                    $("#_smsDiv").css("display" , "");
                    $("#_updSmsChk").prop('checked', true) ;
                    $("#_updSmsMsg").attr("disabled" , false);
                    setSMSMessage('Approved' , ' ');
                }
            }
        }else if(ficoScre == 0){
            if(bankrupt == 0 && ccpHold == 0){
                if(isAllowSendSMS() == true){
                    $("#_smsDiv").css("display" , "");
                    $("#_updSmsChk").prop('checked', true) ;
                    $("#_updSmsMsg").attr("disabled" , false);
                    setSMSMessage('Approved' , ' ');
                }
            }
        } */

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

    fn_ccpScoreChangeFunc(ficoScre,expRisk);

}// bindData

//changed by Lee (2018/01/18)
function setSMSMessage(status, remark){

    var salesmanMemTypeID  = $("#_editSalesMemTypeId").val();
    var custName = $("#_editCustName").val().substr(0 , 15).trim();
    var ordNo = $("#_editOrdNo").val();
    //var ccpStatus = $("#_statusEdit").val() == '1' ? "Pending" : "Approved";
    var webSite = salesmanMemTypeID == '1'?  "hp.coway.com.my" : "cody.coway.com.my";
    //var message = "Order : " + ordNo + "\n" + "Name : " + custName + "\n" + "CCPstatus : " + status + "\n" + "Remark :"+ remark + "\n" + webSite;

    //REMOVE WEBSITE - REQUESTED BY NURL - CPD DEPARTMENT 20200707 - [SYSTEM CHANGE REQUISITION]
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
      ){
        return false;
    }

    return true;

}


function isAllowSendSMS(){

    var salesmanMemTypeID  = $("#_editSalesMemTypeId").val();
    var editSalesManTelMobile = $("#_editSalesManTelMobile").val();

   // if(salesmanMemTypeID != 1 && salesmanMemTypeID != 2){
    if(salesmanMemTypeID != 1 && salesmanMemTypeID != 2 && salesmanMemTypeID != 7){

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

    /* var unitJson = {ccpMasterId : mst ,  screCtgryTypeId : ctgryVal};
    var optionUnit = { isShowChoose: false};
    var selectVal = '';
    selectVal = selVal.trim();
    CommonCombo.make(comId, "/sales/ccp/getOrderUnitList", unitJson, selectVal , optionUnit);  */
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

//그리드 속성 설정
var gridPros = {
    usePaging           : true,         //페이징 사용
    pageRowCount             : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
    editable                      : false,
    fixedColumnCount         : 0,
    showStateColumn         : true,
    displayTreeOpen           : false,
//    selectionMode       : "singleRow",  //"multipleCells",
    headerHeight               : 50,
    useGroupingPanel         : false,        //그룹핑 패널 사용
    skipReadonlyColumns    : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    wrapSelectionMove      : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wordWrap                  : true,
    showRowNumColumn    : true
};

function chgTab(tabNm) {
    switch(tabNm) {
        case 'custInfo' :
            AUIGrid.resize(custInfoGridID, 942, 380);
            if(AUIGrid.getRowCount(custInfoGridID) <= 0) {
                fn_selectOrderSameRentalGroupOrderList();
            }
            break;
        case 'memInfo' :
            AUIGrid.resize(memInfoGridID, 942, 380);
            if(AUIGrid.getRowCount(memInfoGridID) <= 0) {
                fn_selectMembershipInfoList();
            }
            break;
        case 'docInfo' :
            AUIGrid.resize(docGridID, 942, 380);
            if(AUIGrid.getRowCount(docGridID) <= 0) {
                fn_selectDocumentList();
            }
            break;
        case 'callLogInfo' :
            AUIGrid.resize(callLogGridID, 942, 380);
            if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                fn_selectCallLogList();
            }
            break;
        case 'payInfo' :
            AUIGrid.resize(payGridID, 942, 380);
            if(AUIGrid.getRowCount(payGridID) <= 0) {
                fn_selectPaymentList();
            }
            break;
        case 'transInfo' :
            AUIGrid.resize(transGridID, 942, 380);
            if(AUIGrid.getRowCount(transGridID) <= 0) {
                fn_selectTransList();
            }
            break;
        case 'autoDebitInfo' :
            AUIGrid.resize(autoDebitGridID, 942, 380);
            if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                fn_selectAutoDebitList();
            }
            break;
        case 'discountInfo' :
            AUIGrid.resize(discountGridID, 942, 380);
            if(AUIGrid.getRowCount(discountGridID) <= 0) {
                fn_selectDiscountList();
            }
            break;
        case 'ccpStusHist' :
            AUIGrid.resize(ccpStusHistGridID, 942, 380);
            if(AUIGrid.getRowCount(ccpStusHistGridID) <= 0) {
                fn_selectCcpStusHistList();
            }
            break;
        case 'custScoreCard' :
         AUIGrid.resize(custScoreCardGridID, 942, 380);
         if(AUIGrid.getRowCount(custScoreCardGridID) <= 0) {
        	 fn_selectCustScoreCardList();
         }
            break;
    };
}


 function fn_displayReport(viewType){
        var isRe = false;
        if (viewType == "FICO_VIEW"){
            Common.ajax("GET", "/sales/ccp/getResultRowForCTOSDisplayForCCPCalculation", {viewType : viewType , nric : '${orderDetail.basicInfo.custNric}'}, function(result){
                console.log("result : " + result);
                console.log("content  :  " + JSON.stringify(result));
                 if(result.subPath != null && result.subPath !='' && result.fileName != null && result.fileName != ''){
                     window.open(DEFAULT_RESOURCE_FILE+'/'+result.subPath+ '/' + result.fileName, 'report' , "width=800, height=600");
                }else{
                    isRe  = true;
                }
            },'',{async : false});
            if(isRe == true){
                Common.alert('<spring:message code="sal.alert.msg.noResultCTOS" />');
                return;
            }
        }else if(viewType == "EXPERIAN_VIEW"){
            // Experian project
            Common.ajax("GET", "/sales/ccp/getResultRowForEXPERIANDisplayForCCPCalculation", {viewType : viewType , nric : '${orderDetail.basicInfo.custNric}'}, function(result){
                console.log("result : " + result);
                console.log("content  :  " + JSON.stringify(result));
                 if(result.subPath != null && result.subPath !='' && result.fileName != null && result.fileName != ''){
                     window.open(DEFAULT_RESOURCE_FILE+'/'+result.subPath+ '/' + result.fileName, 'report' , "width=800, height=600");
                }else{
                    isRe  = true;
                }
            },'',{async : false});
            if(isRe == true){
                Common.alert("No result from EXPERIAN");
                return;
            }
        }
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
     //$("#_reasonCodeEdit").val(val);
     var ccpstus = $("#_ccpStusId").val();
     var rtnstr = '';
     if(ccpstus == 1){
         rtnstr = 'Pending';
     }else{
         rtnstr = 'Approved'
     }
      setSMSMessage(rtnstr , suggRem);
 }

 function fn_installationArea(){
     Common.popupDiv("/sales/ccp/ccpCalInstallationAreaPop.do", '', null, true, "_instPopDiv");
 }

 function fn_changeDetails(){
     $("#firstCallDateUpd").val($("#firstCallDate").val());
     console.log("HELLO : " + $("#firstCallDateUpd").val());
     console.log("HELLO2 : " + $("#firstCallDate").val());
    }
</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ccpCalEdit" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_btnClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="overflow-y : auto"><!-- pop_body start -->
<form id="_editForm">
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
    <input type="hidden"  id="_editCustId" value="${orderDetail.basicInfo.custId}">

    <!-- from ccpEresubmitMap  -->
     <input type="hidden" id="_eRStusId" name="ccpErStusId" value="${ccpEresubmitMap.stusId}">

</form>
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num5">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.text.salPerson" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.custInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.installInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.maillingInfo" /></a></li>
    <c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#"><spring:message code="sal.title.text.paymentChnnl" /></a></li>
    </c:if>
    <li><a href="#"><spring:message code="sal.title.text.reliefCertificate" /></a></li>
    <li><a href="#" onClick="javascript:chgTab('docInfo');"><spring:message code="sal.title.text.docuSubmission" /></a></li>
    <li><a href="#" onClick="javascript:chgTab('payInfo');"><spring:message code="sal.title.text.paymentListing" /></a></li>
    <li><a href="#" onClick="javascript:chgTab('ccpStusHist');">CCP Status History</a></li>
    <li><a href="#" onClick="javascript:chgTab('ccpTicket');">CCP Ticket</a></li>
    <li><a href="#" onClick="javascript:chgTab('custScoreCard');">Customer Score Card</a></li>
</ul>
<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfoIncludeViewLedger.jsp" %>
<!------------------------------------------------------------------------------
    Sales Person
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/hpCodySalesOnly.jsp" %>
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/custInfoExceptGrid.jsp" %>
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/installInfo.jsp" %>
<!------------------------------------------------------------------------------
    Mailling Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mailInfo.jsp" %>
<!------------------------------------------------------------------------------
    Payment Channel
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/payChannel.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Relief Certificate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rliefCrtfcat.jsp" %>
<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------
    Payment Listing
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/payList.jsp" %>
<!------------------------------------------------------------------------------
    Ccp Status History
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/ccpStusHist.jsp" %>
<!------------------------------------------------------------------------------
    CCP Ticket
------------------------------------------------------------------------------->
<c:set var="logs" value="${orderDetail.ccpTicketLogs}" />
<%@ include file="/WEB-INF/jsp/sales/ccp/include/ticketLog.jsp" %>
<!------------------------------------------------------------------------------
    Customer Score Card
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/ccp/include/custScoreCard.jsp" %>
</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.ccpScorePoint" /></h3>
<ul class="right_btns">
<%--     <li><p class="btn_blue2"><a onclick="javascript: fn_installationArea()"><spring:message code="sal.title.text.installArea" /></a></p></li> --%>
<!--    <li><p class="btn_blue2"><a onclick="javascript: fn_displayReport('FICO_VIEW')"><spring:message code="sal.title.text.ficoReport" /></a></p></li> -->
<!--    <li><p class="btn_blue2"><a onclick="javascript: fn_displayReport('CTOS_VIEW')"><spring:message code="sal.title.text.ctosReport" /></a></p></li> -->
    <li><p class="btn_blue2"><a onclick="javascript: fn_displayReport('FICO_VIEW')">CTOS Score</a></p></li>
    <li><p class="btn_blue2"><a onclick="javascript: fn_displayReport('EXPERIAN_VIEW')">Experian Score</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:210px" />
    <col style="width:*" />
    <col style="width:80px" />
    <col style="width:*" />
    <col style="width:80px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ordUnit" /></th>
    <td>
        <select class="w100p" name="ordUnit" id="_ordUnit"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.count" /></th>
    <td colspan='4'><span><b>${fieldMap.ordUnitCount }</b></span></td>
    <!--
    <th scope="row"><spring:message code="sal.title.text.point" /></th>
    <td><span><b>${fieldMap.orderUnitPoint}</b></span></td>
    -->
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.avgRosMth" /></th>
    <td> <select class="w100p" name="ordMth" id="_ordMth"></select></td>
    <th scope="row"><spring:message code="sal.title.text.count" /></th>
    <td colspan='4'><span><b>${fieldMap.rosCount}</b></span></td>
    <!--
    <th scope="row"><spring:message code="sal.title.text.point" /></th>
    <td><span><b>${fieldMap.rosUnitPoint}</b></span></td>
    -->
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.suspensionTermination" /></th>
    <td> <select class="w100p" name="ordSuspen" id="_ordSuspen"></select></td>
    <th scope="row"><spring:message code="sal.title.text.count" /></th>
    <td colspan='4'><span><b>${fieldMap.susUnitCount}</b></span></td>
    <!--
    <th scope="row"><spring:message code="sal.title.text.point" /></th>
    <td><span><b>${fieldMap.susUnitPoint}</b></span></td>
    -->
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.existCust" /></th>
    <td><select class="w100p" name="ordExistingCust" id="_ordExistingCust"></select></td>
    <th scope="row"><spring:message code="sal.title.text.count" /></th>
    <td colspan='4'><span><b>${fieldMap.custUnitCount}</b></span></td>
    <!--
    <th scope="row"><spring:message code="sal.title.text.point" /></th>
    <td><span><b>${fieldMap.custUnitPoint}</b></span></td>
    -->
</tr>
<!--
<tr>
    <th scope="row"><spring:message code="sal.title.text.totPoint" /></th>
    <td colspan="5"><b>${fieldMap.totUnitPoint}</b></td>
</tr>
-->
</tbody>
</table><!-- table end -->


</section><!-- search_table end -->

<div id="eResubmitAtch">
<aside class="title_line"><!-- title_line start -->
<h3>eResubmit Documents</h3>
</aside><!-- title_line end -->
<form  id="eResubmitForm">

<table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:350px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Sales Order Form (SOF)</th>
            <td>
                <div id='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='sofFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='sofFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Sales Order Form's T&C (SOF T&C)</th>
            <td>
                <div id='uploadfiletest1' class='auto_file3'>
                    <input type='file' title='file add'  id='softcFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='softcFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">NRIC / VISA /Bank Card</th>
            <td>
                <div id='uploadfiletest2' class='auto_file3'>
                    <input type='file' title='file add'  id='nricFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='nricFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Mattress Sales ORder Form (MSOF)</th>
            <td>
                <div id='uploadfiletest3' class='auto_file3'>
                    <input type='file' title='file add'  id='msofFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='msofFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Mattress Sales Order Form's T&C (MSOF T&C)</th>
            <td>
                <div id='uploadfiletest4' class='auto_file3'>
                    <input type='file' title='file add'  id='msoftcFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='msoftcFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Payment document / Payment Channel</th>
            <td>
                <div id='uploadfiletest5' class='auto_file3'>
                    <input type='file' title='file add'  id='payFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='payFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Government (Agreement / SST / LO)</th>
            <td>
                <div id='uploadfiletest6' class='auto_file3'>
                    <input type='file' title='file add'  id='govFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='govFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Declaration letter</th>
            <td>
                <div id='uploadfiletest7' class='auto_file3'>
                    <input type='file' title='file add'  id='letFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='letFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Supporting document (Utility bill / SSM / Others)</th>
            <td>
                <div id='uploadfiletest8' class='auto_file3'>
                    <input type='file' title='file add'  id='docFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='docFrFileTxt'  name=''/>
                    </label>
                </div>
            </td>
        </tr>
        </tbody>
        </table>
</form>
</div>


<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.ccpResult" /></h3>
</aside><!-- title_line end -->
<form  id="calSaveForm" name="calSaveForm">
<input type="hidden" name="saveCcpId" id="_saveCcpId" value="${ccpId}"/>
<input type="hidden" name="ccpTotalScorePoint" value="${fieldMap.totUnitPoint}">
<input type="hidden" id="_saveCustTypeId" name="saveCustTypeId" value="${orderDetail.basicInfo.custTypeId}">
<input type="hidden"  name="saveOrdId" id="_saveOrdId" value="${orderDetail.basicInfo.ordId}">
<input type="hidden"  name="bndlId" id="_bndlId" value="${orderDetail.basicInfo.bndlId}">
<input type="hidden"  name="saveCustId" id="saveCustId" value="${orderDetail.basicInfo.custId}">
<input type="hidden"  name="saveSalesOrgCode" id="saveOrgCode" value="${orderDetail.salesmanInfo.orgCode}">
<input type="hidden"  name="saveSalesMemType" id="saveSalesMemType" value="${orderDetail.salesmanInfo.memType}">
<input type="hidden"  name="saveSalesManId" id="saveSalesManId" value="${orderDetail.salesmanInfo.memId}">

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

<!-- firstCallDate update  -->
<input type="hidden"  id="firstCallDateUpd" name="firstCallDateUpd" placeholder="DD/MM/YYYY"  class="j_date" >
<table class="type1"><!-- table start -->
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
    <th scope="row">CCP Attachment</th>
    <td colspan="5">
        <div class='auto_file3 w100p' id="ccpAttachFileField">
            <input type='file' title='file add' id='ccpAttachFile' accept='application/pdf''/>
            <label style="width: 400px;">
                <input type='text' class='input_text' readonly='readonly' id='ccpAttachFileTxt'  name=''/>
            </label>
            <input type="hidden" name="atchFileGrpId" id="atchFileGrpId" value="${ccpInfoMap.fileId}">
        </div>
        <div id="ccpAttachTxtField"><span>${ccpInfoMap.fileName}</span></div>
    </td>
</tr>
<tr>

    <th scope="row"><spring:message code="sal.title.text.ccpStatus" /></th>
    <td colspan="5"><span><select class="w100p" name="statusEdit" id="_statusEdit" onchange="javascript : fn_ccpStatusChangeFunc(this.value)"></select></span></td>

    <!--eResubmit status -->

    <th id="eResubmitTh" scope="row">eResubmit Status</th>
    <td id="eResubmitTd"><span><select class="w100p" name="eRstatusEdit" id="_eRstatusEdit"></select></span></td>

    <!--
    <th scope="row"><spring:message code="sal.title.text.ccpIncomeRange" /></th>
    <td><span><select class="w100p" name="incomeRangeEdit" id="_incomeRangeEdit"></select></span></td>
    <th scope="row"><spring:message code="sal.title.text.rejStus" /></th>
    <td><span><select class="w100p" name="rejectStatusEdit" id="_rejectStatusEdit"></select></span></td>
    -->
</tr>
<tr id="ctosScoreRow" class="blind">
<!--  "sal.title.text.ficoScore" THIS IS IN THE TABLE SYS0052M-->
<!--    <th scope="row"><spring:message code="sal.title.text.ficoScore" /></th> -->
    <th scope="row">CTOS Score</th>
    <td colspan="5" ><span><input type="text" id="_ficoScore" name="ficoScore" value="${ccpInfoMap.ccpFico}" onchange="javascript : fn_ccpScoreChangeFunc(this.value,0)" disabled="disabled" maxlength="10"></span></td>
</tr>
<tr>
    <th scope="row">Bankruptcy</th>
    <td colspan="5" id="bankruptcy"></td>
    </td>
</tr>
<tr id="experianScoreRow" class="blind">
    <th scope="row">Experian Score</th>
    <td colspan="5">
        <span>
            <input style="width:87pt" type="text" id="_experianScore" name="experianScore" value="${ccpInfoMap.ccpExperians}" disabled="disabled" maxlength="10">
            <input style="width:87pt" type="text" id="_experianRisk" name="experianRisk" value="${ccpInfoMap.ccpExperianr}" onchange="javascript : fn_ccpScoreChangeFunc(0,this.value)" disabled="disabled" maxlength="10">
        </span>
    </td>
</tr>
<tr id="scoreGrpRow" class="blind">
    <th scope="row">Score Group</th>
    <td colspan="5" id="score_group">
    </td>
</tr>
<tr>
    <th scope="row">Customer Category</th>
    <td colspan="5">${ccpInfoMap.custCat}</td>
</tr>
<tr>
    <th scope="row">CHS Status</th>
    <td colspan="5" id="chs_stus">
<%--     <span>${ccpInfoMap.chsStus}</span> --%>
    </td>
</tr>
<tr>
    <th scope="row">CHS Reason</th>
    <td colspan="5" id="chs_rsn">
 <%--     <span>${ccpInfoMap.chsRsn}</span> --%>
    </td>
</tr>
<tr>
    <th scope="row">Product Entitlement</th>
        <td colspan="5" id="prodEntitle"></td>
    </td>
</tr>
<tr>
    <th scope="row">Unit Entitlement</th>
    <td colspan="5" id="unitEntitle"></td>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ccpFeedbackCode" /></th>
    <td colspan="5"><span><select class="w100p" name="reasonCodeEdit" id="_reasonCodeEdit" onchange="javascript: fn_chgFunFeedBack(this.value)"></select></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.specialRem" /></th>
    <td colspan="5"><textarea cols="20" rows="5" id="_spcialRem" name="spcialRem" maxlength="4000">${ccpInfoMap.ccpRem}</textarea></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.pncRem" /></th>
    <td colspan="5"><textarea cols="20" rows="5" id="_pncRem" name="pncRem" maxlength="4000">${ccpInfoMap.ccpPncRem}</textarea></td>
</tr>
<tr>
    <!--
    <th scope="row"><spring:message code="sal.title.letterOfUnder" /></th>
    <td><span><input type="checkbox"  id="_letterOfUdt"  name="letterOfUdt"/></span></td>
    <th scope="row"><spring:message code="sal.title.text.summon" /></th>
    <td><span><input type="checkbox"  id="_summon"  name="summon"/></span></td>
    -->
    <!-- 20201023 - LaiKW - Amend checkbox -->
    <th scope="row">Agreement Required<span class="must" id="man1" >*</span></th>
    <td><span><input type="checkbox"  id="agmReq"  name="agmReq"/></span></td>
    <th scope="row">Coway Template<span class="must" id="man2">*</span></th>
    <td>
    <!-- <span><input type="checkbox"  id="cowayTemplate"  name="cowayTemplate"/></span> -->
    <select class="w100p" id="cowayTemplate" name="cowayTemplate">
        <option value="" selected>Choose One</option>
        <option value="1">YES</option>
        <option value="0">NO</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.onHoldCcp" /></th>
    <td><span><input type="checkbox"  id="_onHoldCcp"  name="onHoldCcp"/></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.cntcAgrPeriod" /><span class="must" id="man3">*</span></th>
    <td>
    <select class="w100p" id="cntPeriodValue" name="cntPeriodValue">
        <option value="0" selected>Choose One</option>
        <option value="12">12</option>
        <option value="24">24</option>
        <option value="36">36</option>
        <option value="48">48</option>
        <option value="60">60</option>
    </select>
    </td>
    <th scope="row">First Call Date</th>
    <td colspan="3">
    <input type="text" title="First Call Date"  placeholder="DD/MM/YYYY"  class="j_date"  id="firstCallDate" name="firstCallDate" onchange = "fn_changeDetails()"/>
    </td>
</tr>
<tr>
    <th scope="row">Customer Is Payer</th>
    <td>
    <select class="w100p" id="custIsPayerValue" name="custIsPayerValue">
        <option value="" selected>Choose One</option>
        <option value="Yes">Yes</option>
        <option value="No">No</option>
    </select>
    </td>
    <th scope="row">The Payer</th>
    <td>
    <select class="w100p" id="thePayerValue" name="thePayerValue">
    <option value="" selected>Choose One</option>
        <option value="7213">PIBG</option>
        <option value="7214">PARENTS</option>
        <option value="7215">KOPERASI</option>
        <option value="7216">TEACHER(PERSONAL ACCOUNT)</option>
        <option value="7217">THIRD PARTY COMPANY</option>
        <option value="7218">SCHOOL ALUMNI</option>
        <option value="7229">CUSTOMER</option>
    </select>
    </td>
        <th scope="row">Failed Verification Reason</th>
    <td>
    <select class="w100p" id="failVeriReasonValue" name="failVeriReasonValue">
        <option value="" selected>Choose One</option>
            <option value="7219">SPONSOR</option>
            <option value="7220">RETURN TO SCORER</option>
            <option value="7221">UNREACHABLE</option>
            <option value="7222">CUSTOMER REQUEST CANCEL</option>
            <option value="7223">CUSTOMER CHANGE DETAILS</option>
            <option value="7230">REFUSAL ON VERIFICATION</option>
        </select>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<div id="_smsDiv" style="display: none;">
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.smsInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
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
</table><!-- table end -->

</div>
<ul class="center_btns">
    <!-- <li><p class="btn_blue2"><a id="_btnList">List</a></p></li> -->
    <li><p class="btn_blue2"><a id="_calBtnSave"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section>
</div>