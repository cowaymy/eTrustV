<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var optionState = {chooseMessage: " 1.States "};
var optionCity = {chooseMessage: "2. City"};
var optionPostCode = {chooseMessage: "3. Post Code"};
var optionArea = {chooseMessage: "4. Area"};
var myFileCaches = {};
var atchFileGrpId = 0;
var issuedBankTxt;
var checkFileValid = true;
var isRejoinMem =  $("#isRejoinMem").val();

function fn_memberSave(){

    if( $("#eHPuserType").val() == "1") {
        $('#eHPmemberType').attr("disabled", false);
        $('#eHPsearchdepartment').attr("disabled", false);
        $('#eHPsearchSubDept').attr("disabled", false);
    }

    $("#eHPstreetDtl1").val(eHPinsAddressForm.streetDtl.value);
    $("#eHPaddrDtl1").val(eHPinsAddressForm.addrDtl.value);
    $("#eHPtraineeType").val(($("#eHPtraineeType1").value));
    $("#eHPsubDept").val(($("#eHPsearchSubDept").value));

    var gender = "";
    if( $('input[name=gender]:checked', '#eHPmemberAddForm').val() == "M"){
        gender = "M";
    }else if( $('input[name=gender]:checked', '#eHPmemberAddForm').val() == "F"){
        gender = "F";
    }

    var formData = new FormData();
    $.each(myFileCaches, function(n, v) {
        console.log("n : " + n + " v.file : " + v.file);
        formData.append(n, v.file);
    });
    //formData.append('atchFileGrpId',atchFileGrpId);

    Common.ajaxFile("/organization/attachFileUpload.do", formData, function(result) {
        if(result != 0 && result.code == 00) {
            atchFileGrpId = result.data.fileGroupKey;
            console.log("atchFileGrpId :: " + atchFileGrpId);

            var jsonObj =  {
                    eHPareaId : $("#eHPareaId").val(),
                    eHPstreetDtl : $("#eHPstreetDtl").val(),
                    eHPaddrDtl : $("#eHPaddrDtl").val(),
                    //eHPtraineeType : $("#eHPtraineeType").val(),
                    eHPsubDept : $("#eHPsubDept").val(),
                    eHPuserType : $("#eHPuserType").val(),
                    eHPmemType : $("#eHPmemType").val(),
                    eHPmemberType : $("#eHPmemberType").val(),
                    eHPmemberNm : $("#eHPmemberNm").val(),
                    eHPjoinDate : $("#eHPjoinDate").val(),
                    //eHPgender : $("#eHPgender").val(),
                    eHPgender : gender,
                    eHPBirth : $("#eHPBirth").val(),
                    eHPcmbRace : $("#eHPcmbRace").val(),
                    eHPnational : $("#eHPnational").val(),
                    eHPnric : $("#eHPnric").val(),
                    eHPmarrital : $("#eHPmarrital").val(),
                    eHPemail : $("#eHPemail").val(),
                    eHPmobileNo : $("#eHPmobileNo").val(),
                    eHPofficeNo : $("#eHPofficeNo").val(),
                    eHPresidenceNo : $("#eHPresidenceNo").val(),
                    eHPsponsorCd : $("#eHPsponsorCd").val(),
                    eHPsponsorNm : $("#eHPsponsorNm").val(),
                    eHPsponsorNric : $("#eHPsponsorNric").val(),
                    eHPdeptCd : $("#eHPdeptCd").val(),
                    eHPmeetingPoint : $("#eHPmeetingPoint").val(),
                    //eHPtraineeType1 : $("#eHPtraineeType1").val(),
                    eHPissuedBank : $("#eHPissuedBank").val(),
                    eHPbankAccNo : $("#eHPbankAccNo").val(),
                    eHPincomeTaxNo : $("#eHPincomeTaxNo").val(),
                    eHPcollectionBrnch : $("#eHPcollectionBranch").val(),
                    eHPcodyPaExpr : $("#eHPcodyPaExpr").val(),
                    eHPspouseCode : $("#eHPspouseCode").val(),
                    eHPspouseName : $("#eHPspouseName").val(),
                    eHPspouseNric : $("#eHPspouseNric").val(),
                    eHPspouseOcc : $("#eHPspouseOcc").val(),
                    eHPspouseDob : $("#eHPspouseDob").val(),
                    eHPspouseContat : $("#eHPspouseContat").val(),
                    //eHPorientation : $("#course").val(), //20-10-2021 - HLTANG - close for LMS project
                    atchFileGrpId : atchFileGrpId,
                    isRejoinMem :  $("#isRejoinMem").val(),
                    salOrgRejoin : $("#salOrgRejoin").val(),
                    memId : $("#memId").val(),
                    eHPregOpt : $("#eHPregOpt").val()

            };
            // jsonObj.form = $("#memberAddForm").serializeJSON();

            console.log("-------------------------" + JSON.stringify(jsonObj));
            Common.ajax("POST", "/organization/eHPmemberSave",  jsonObj , function(result) {
                console.log("message : " + result.message );

               if(result.code == "99"){
                	Common.alert(result.message);
                }else{
                	// Only applicable to HP Applicant
                    if($("#eHPmemberType").val() == "2803") {
                        $("#eHPaplcntNRIC").val($("#eHPnric").val());
                        $("#eHPaplcntName").val($("#eHPmemberNm").val());
                        $("#eHPaplcntMobile").val($("#eHPmobileNo").val());

                        //Fix HP agreement SMS and Email Link
                        var jsonObjHp = {
                        		aplcntNRIC  : $("#eHPaplcntNRIC").val(),
                        		aplcntName : $("#eHPaplcntName").val(),
                        		aplcntMobile : $("#eHPaplcntMobile").val()
                        };

                        // Get ID and identification
                        Common.ajax("GET", "/organization/getApplicantInfo", jsonObjHp, function(result) {
                            console.log("saving member details");
                            console.log(result);

                            var aplcntId = result.id;
                            var idntfc = result.idntfc;
                            var MemberID = idntfc + aplcntId
                            
                            // Construct Agreement URL via SMS
                            /* VER NBL [S] var cnfmSms = " COWAY: Click " +
                                          "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + idntfc + aplcntId +
                                          " for confirmation of HP agreement. TQ!"; */
//                             var cnfmSms = " COWAY: HP Application successful. Click " +
//                                                   "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + idntfc + aplcntId +
//                                                   " to accept T&C." + "Password: " + "${pdfPwd}";
                            /* VER NBL [E] */

//                             console.log(cnfmSms);

                            if($("#eHPmobileNo").val() != "") {
                                var rTelNo = $("#eHPmobileNo").val();
                                console.log("eHPmobileNo INNN : ");
                                
                                /*
                                Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:rTelNo , msg :cnfmSms} , function(result) {
                                    console.log("sms.");
                                    console.log( result);
                                });
                                */

                                Common.ajax("GET","/organization/sendWhatsAppHp.do", {rTelNo:rTelNo, MemberID:MemberID}, function(result) {
                                	console.log("whatsapp.");
                                    console.log(result);
                                });
                                
                            }

                            if($("#eHPemail").val() != "") {
                                var recipient = $("#eHPemail").val();
                                var url = "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + idntfc + aplcntId;

                                // Send Email file, recipient
                                Common.ajax("GET", "/organization/sendEmail.do", {url:url, recipient:recipient,password:'true'}, function(result) {
                                    console.log("email.");
                                    console.log(result);
                                })
                            }
                        });
                    }
                    Common.alert(result.message,fn_close);
                }

            });
        } else {
            Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
        }
    }, function(result){
        Common.alert("Upload Failed. Please check with System Administrator.");
    });
}

$(function(){
    $('#nricFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[1] != null){
            delete myFileCaches[1];
        }else if(file != null){
            myFileCaches[1] = {file:file};
        }
        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow picture with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[1].file['checkFileValid'] = false;
            Common.alert(msg);
        }
        else{
            myFileCaches[1].file['checkFileValid'] = true;
        }
        console.log(myFileCaches);
    });

    $('#paymentFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[4] != null){
            delete myFileCaches[4];
        }else if(file != null){
            myFileCaches[4] = {file:file};
        }
        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow picture with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[4].file['checkFileValid'] = false;
            Common.alert(msg);
        }
        else{
            myFileCaches[4].file['checkFileValid'] = true;
        }
        console.log(myFileCaches);
    });

    $('#passportFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[3] != null){
            delete myFileCaches[3];
        }else if(file != null){
            myFileCaches[3] = {file:file};
        }
        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow picture with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[3].file['checkFileValid'] = false;
            Common.alert(msg);
        }
        else{
            myFileCaches[3].file['checkFileValid'] = true;
        }
        console.log(myFileCaches);
    });

    $('#otherFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[6] != null){
            delete myFileCaches[6];
        }else if(file != null){
            myFileCaches[6] = {file:file};
        }
        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow picture with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[6].file['checkFileValid'] = false;
            Common.alert(msg);
        }
        else{
            myFileCaches[6].file['checkFileValid'] = true;
        }
    });

    $('#otherFile2').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[7] != null){
            delete myFileCaches[7];
        }else if(file != null){
            myFileCaches[7] = {file:file};
        }
        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow picture with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[7].file['checkFileValid'] = false;
            Common.alert(msg);
        }
        else{
            myFileCaches[7].file['checkFileValid'] = true;
        }
        console.log(myFileCaches);
    });

    $('#statementFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[2] != null){
            delete myFileCaches[2];
        }else if(file != null){
            myFileCaches[2] = {file:file};
        }
        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow picture with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[2].file['checkFileValid'] = false;
            Common.alert(msg);
        }
        else{
            myFileCaches[2].file['checkFileValid'] = true;
        }
        console.log(myFileCaches);
    });

    $('#hpAppForm').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[5] != null){
            delete myFileCaches[5];
        }else if(file != null){
            myFileCaches[5] = {file:file};
        }
        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow picture with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[5].file['checkFileValid'] = false;
            Common.alert(msg);
        }
        else{
            myFileCaches[5].file['checkFileValid'] = true;
        }
    });

    $('#terminateAgreement').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[8] != null){
            delete myFileCaches[8];
        }else if(file != null){
            myFileCaches[8] = {file:file};
        }
        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow picture with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[8].file['checkFileValid'] = false;
            Common.alert(msg);
        }
        else{
            myFileCaches[8].file['checkFileValid'] = true;
        }
        console.log(myFileCaches);
    });

});

function fn_close(){
    $("#popup_wrap").remove();
}
function fn_saveConfirm(){

    if(fn_saveValidation()){
        if($("#eHPmemberType").val() == 2803){
            Common.confirm($("#eHPmemberNm").val() + "</br>" +
                                   $("#eHPnric").val() + "</br>" +
                                   issuedBankTxt + "</br>" +
                                   "A/C : " + $("#eHPbankAccNo").val() + "</br></br>" +
                                   "Do you want to save with above information (for commission purpose)?", fn_memberSave);
        } else {
            Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
        }
    }
}


function fn_departmentCode(value){
     if($("#eHPmemberType").val() != 2){
            $("#eHPhideContent").hide();
        }else{
            $("#eHPhideContent").show();
        }
     if($("#eHPmemberType").val() == 5){
          $("#eHPtrTrainee").show();
     }else{
        $("#eHPtrTrainee").hide();
     }

     $("#eHPjoinDate").val($.datepicker.formatDate('dd/mm/yy', new Date()));

     $("#eHPjoinDate").attr("readOnly", true);



     if($("#eHPmemberType").val() == 2803){

         var spouseCode = "${spouseInfoView[0].memCode}";
         var spouseName = "${spouseInfoView[0].name}";
         var spouseNric = "${spouseInfoView[0].nric}";
         var spouseDob = "${spouseInfoView[0].dob}";
         var spouseTel = "${spouseInfoView[0].telMobile}";

        $("#eHPbranch").find('option').each(function() {
            $(this).remove();
        });
        $("#eHPbranch").append("<option value=''>Choose One</option>");

        $("#eHPmeetingPoint").attr("disabled", false);
        $("#eHPbranch").attr("disabled", true);
        $("#eHPtransportCd").attr("disabled", true);
        $("#eHPapplicationStatus").attr("disabled", true);
        $("#eHPsearchdepartment").attr("disabled", true);
        $("#eHPsearchSubDept").attr("disabled", true);

     }


    var action = value;
    console.log("fn_departmentCode >> " + action)
    switch(action){
       case "1" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CRS%"
        };
           doGetCombo("/organization/selectDeptCodeHp", jsonObj , ''   , 'eHPdeptCd' , 'S', '');
           break;
       case "2" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CCS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'eHPdeptCd' , 'S', '');
           doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'eHPbranch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','eHPtransportCd', 'S' , '');
           break;
       case "3" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CTS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'eHPdeptCd' , 'S', '');
           doGetComboSepa("/common/selectBranchCodeList.do",2 , '-',''   , 'eHPbranch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','eHPtransportCd', 'S' , '');
           break;

       case "4" :
           var jsonObj = {
                memberLvl : 100,
                flag :  "-"
        };
           doGetComboSepa("/common/selectBranchCodeList.do",100 , '-',''   , 'eHPbranch' , 'S', '');
           break;

       case "5" :

           $("#eHPbranch").find('option').each(function() {
               $(this).remove();
           });
           $("#eHPdeptCd").find('option').each(function() {
               $(this).remove();
           });

           $("#eHPtraineeType1").change(function(){

               var traineeType =  $("#eHPtraineeType1").val();

               console.log("fn_departmentCode traineeType>> " + traineeType)

               if( traineeType == '2'){
                    doGetComboSepa("/common/selectBranchCodeList.do",'4' , '-',''   , 'eHPbranch' , 'S', '');

                   $("#eHPbranch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%CCS%",
                               flag2 : "%CM%",
                               branchVal : $("#eHPbranch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'eHPdeptCd' , 'S', '');
                   });

                   //Training Course ajax콜 위치
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

                        $("#eHPcourse").find('option').each(function() {
                            $(this).remove();
                        });
                         console.log("-------------------------" + JSON.stringify(result));
                         if (result!= null) {
                         $("#eHPcourse").append("<option value=''>Choose One</option>");
                            for( var i=0; i< result.length; i++) {
                             $("#eHPcourse").append("<option value="+result[i].codeId+">"+result[i].codeName+"</option>");
                            }
                         }
                     });

               }
               else if(traineeType == '3'){

                   $("#eHPbranch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%CTS%",
                               branchVal : $("#eHPbranch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'eHPdeptCd' , 'S', '');
                   });

                   doGetComboSepa("/common/selectBranchCodeList.do",'5' , '-',''   , 'eHPbranch' , 'S', '');

                   //Training Course ajax콜 위치
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

                        $("#eHPcourse").find('option').each(function() {
                            $(this).remove();
                        });
                         console.log("-------------------------" + JSON.stringify(result));
                         if (result!= null) {
                         $("#eHPcourse").append("<option value=''>Choose One</option>");
                            for( var i=0; i< result.length; i++) {
                             $("#eHPcourse").append("<option value="+result[i].codeId+">"+result[i].codeName+"</option>");
                            }
                         }
                     });
               }   else if(traineeType == '5758'){ // HOMECARE DELIVERY TECHNICIAN -- ADDED BY TOMMY

                   doGetComboSepa("/common/selectBranchCodeList.do",'5758' , '-',''   , 'eHPbranch' , 'S', '');
                   $("#eHPbranch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%DTS%",
                               branchVal : $("#eHPbranch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'eHPdeptCd' , 'S', '');
                   });

                   //Training Course ajax콜 위치
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

                        $("#eHPcourse").find('option').each(function() {
                            $(this).remove();
                        });
                         console.log("-------------------------" + JSON.stringify(result));
                         if (result!= null) {
                         $("#eHPcourse").append("<option value=''>Choose One</option>");
                            for( var i=0; i< result.length; i++) {
                             $("#eHPcourse").append("<option value="+result[i].codeId+">"+result[i].codeName+"</option>");
                            }
                         }
                     });
               } else if( traineeType == '7'){ // HOMECARE -- ADDED BY TOMMY
                    doGetComboSepa("/common/selectBranchCodeList.do",'4' , '-',''   , 'eHPbranch' , 'S', '');

                   $("#eHPbranch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%CHT%",
                               branchVal : $("#eHPbranch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'eHPdeptCd' , 'S', '');
                   });

                   //Training Course ajax콜 위치
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

                        $("#eHPcourse").find('option').each(function() {
                            $(this).remove();
                        });
                         console.log("-------------------------" + JSON.stringify(result));
                         if (result!= null) {
                         $("#eHPcourse").append("<option value=''>Choose One</option>");
                            for( var i=0; i< result.length; i++) {
                             $("#eHPcourse").append("<option value="+result[i].codeId+">"+result[i].codeName+"</option>");
                            }
                         }
                     });

               }
           });

           doGetCombo('/common/selectCodeList.do', '7', '','eHPtransportCd', 'S' , '');
           break;

        case "2803" :

            doGetComboSepa("/common/selectBranchCodeList.do",45 , '-',''   , 'eHPbranch' , 'S', '');

            if ( $("#eHPuserType").val() == "1" ) {

                Common.ajax("GET", "/organization/selectDeptCodeHp", null, function(result) {

                    $("#eHPdeptCd").find('option').each(function() {
                        $(this).remove();
                    });

                    console.log("------selectDeptCodeHp-------------------" + JSON.stringify(result));
                    if (result!= null) {
                       $("#eHPdeptCd").append("<option value="+result[0].codeId+">"+result[0].codeId+"</option>");
                    }

                });


            } else {
               //doGetCombo('/organization/selectDepartmentCode', '', '','deptCd', '' , '');

                Common.ajax("GET", "/organization/selectDepartmentCode", null, function(result) {

                    $("#eHPdeptCd").find('option').each(function() {
                        $(this).remove();
                    });

                   // console.log("------selectDepartmentCode-------------------" + JSON.stringify(result));
                    if (result!= null) {
                       $("#eHPdeptCd").append("<option value="+result[0].codeId+">"+result[0].codeId+"</option>");
                        for(var z=0; z< result.length;z++) {
                            $("#eHPdeptCd").append("<option value="+result[z].codeId+">"+result[z].codeName+"</option>");
                       }
                    }

                });
            }
        break;
    }
}

$(document).ready(function() {
console.log("ready");
$(".join").hide();
    //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','country', 'S', '');

    //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','national', 'S', '');

    //doGetCombo('/sales/customer/getNationList', '338' , '' ,'country' , 'S', '' );
    //doGetCombo('/sales/customer/getNationList', '338' , '' ,'national' , 'S' , '');

    //doGetCombo('/common/selectCodeList.do', '2', '','cmbRace', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '4', '','eHPmarrital', 'S' , 'fn_eHPmarritalCallBack');
    doGetCombo('/common/selectCodeList.do', '3', '','eHPlanguage', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '5', '','eHPeducationLvl', 'S' , '');
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'eHPissuedBank', 'S', '');
    //doGetCombo('/organization/selectCourse.do', '', '','course', 'S' , '');
    doGetCombo('/organization/selectHpMeetPoint.do', '', '', 'eHPmeetingPoint', 'S', '');
    doGetCombo('/organization/selectHpRegistrationOption.do', '', '', 'eHPregOpt', 'S', '');

    $("#orientationTbl").hide();  //20-10-2021 - HLTANG - close for LMS project

    //$("#issuedBank option[value='MBF']").remove();
    //$("#issuedBank option[value='OTH']").remove();

    $("#eHPdeptCd").change(function (){
        //modify hgham 2017-12-25  주석 처리
        //doGetComboSepa("/common/selectBranchCodeList.do",$("#deptCd").val() , '-',''   , 'branch' , 'S', '');
    });

    fn_departmentCode('2');  //modify  hgham 25-12 -2017    as is code  fn_departmentCode();

    $("#eHPstate").change(function (){
        var state = $("#eHPstate").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' ,state ,'eHParea', 'S', '');
    });
    $("#eHParea").change(function (){
        var area = $("#eHParea").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' ,area ,'','eHPpostCode', 'S', '');
    });

    // Member Type 바꾸면 입력한 NRIC 비우기, doc 새로불러오기
    $("#eHPmemberType").change(function (){
        $("#eHPnric").val('');
          if ($("#eHPmemberType").val() == "4") {
              $("#eHPmemberCd").attr("disabled", false);
          } else {
              $("#eHPmemberCd").attr("disabled", true);
          }

    });

    $("#eHPmemberType").click(function (){

    console.log("================" +  $("#eHPmemberType").val());
        var memberType = $("#eHPmemberType").val();

        $('span', '#eHPemailLbl').empty().remove();
        $('span', '#eHPmobileNoLbl').empty().remove();
        $('span', '#eHPmeetingPointLbl').empty().remove();
        $('span', '#eHPcourseLbl').empty().remove();

        if ( memberType ==  "2803") {
            //$('#grid_wrap_doc').attr("hidden", true);

            $('#eHPemail').prop('required', true);
            $('#eHPmobileNo').prop('required', true);
            $('#eHPemailLbl').append("<span class='must'>*</span>");
            $('#eHPmobileNoLbl').append("<span class='must'>*</span>");
            $('#eHPmeetingPointLbl').append("<span class='must'>*</span>");

            $("#eHPapprStusText").attr("disabled", true);
            $("#eHPapprStusCombo").attr("disabled", true);
            $("#eHPreligion").attr("disabled", true);
            $("#eHPcourse").attr("disabled", true);
            $("#eHPtotalVacation").attr("disabled", true);
            $("#eHPapplicationStatus").attr("disabled", true);
            $("#eHPremainVacation").attr("disabled", true);
            $("#eHPsearchdepartment").attr("disabled", true);
            $("#eHPsearchSubDept").attr("disabled", true);
            $("#eHPeducationLvl").attr("disabled", true);
            $("#eHPlanguage").attr("disabled", true);
            $("#eHPtrNo").attr("disabled", true);
            doGetCombo('/organization/selectAccBank.do', '', '', 'eHPissuedBank', 'S', '');
        }
        fn_departmentCode(memberType);
     });

    $("#eHPtraineeType1").click(function(){   // CHECK Trainee Type = Cody then Disable Main & Sub Department selection -- Added by Tommy
        var traineeType = $("#eHPtraineeType1").val();

        $('span', '#eHPcourseLbl').empty().remove();

        if(traineeType == 2803){
            //$('#eHPcourseLbl').append("<span class='must'>*</span>");
            $("#eHPjoinDate").val($.datepicker.formatDate('dd/mm/yy', new Date()));
            $("#eHPjoinDate").attr("readOnly", true);
        }

        if(traineeType == "" || traineeType == null) {
            $('span', '#eHPcourseLbl').empty().remove();
        }

    });

     $("#eHPsearchdepartment").change(function(){

        doGetCombo('/organization/selectSubDept.do',  $("#eHPsearchdepartment").val(), '','eHPsearchSubDept', 'S' ,  '');

     });

    //var nationalStatusCd = "1";
    $("#eHPnational option[value=1]").attr('selected', 'selected');

    //var cmbRacelStatusCd = "10";
    /* $("#cmbRace option[value=10]").attr('selected', 'selected'); */

     if( $("#eHPuserType").val() == "1") {
        $("#eHPmemberType option[value=2803]").attr('selected', 'selected');
        $('#eHPmemberType').attr("disabled", true);

     }

     $('#eHPmemberType').trigger('click');

     $('#eHPnric').blur(function() {
         if ($('#eHPnric').val().length == 12) {
             checkNRIC();
             /* if ($('#nric').val().length == 12) {
                 autofilledbyNRIC();
             } */
         }
     });

     $('#eHPsponsorCd').blur(function() {
         if ($('#eHPsponsorCd').val().length > 0) {
             fn_sponsorCd();
         }
     });

     if ($("#eHPmemberType").val() == "4") {
         $("#eHPmemberCd").attr("disabled", false);
     } else {
         $("#eHPmemberCd").attr("disabled", true);
     }

     $('#eHPbankAccNo').blur(function() {
         if($("#eHPmemberType").val() != "5") {
            console.log("not trainee with -/0")
            fmtNumber("#eHPbankAccNo"); // 2018-06-21 - LaiKW - Added removal of special characters from bank account number
            checkBankAccNo();
         } else if($("#eHPmemberType").val() == "5") {
            console.log("5");
            console.log("bankaccno :: " + $("#eHPbankAccNo").val());
            if($("#eHPbankAccNo").val() != "-"){
                checkBankAccNo();
            }
         }
     });

     $('#eHPemail').blur(function() {
    	 checkEmail();
     });

     $("#eHPmobileNo").blur(function() {
        fmtNumber("#eHPmobileNo"); // 2018-07-06 - LaiKW - Removal of special characters from mobile no
     });

     $("#eHPregOpt").change(function (){
    	 document.getElementById("eHPcollectionBranch").disabled = $("#eHPregOpt").val()==7227 ? true : false;
    	 document.getElementById("eHPcollectionBranch").disabled = $("#eHPregOpt").val()==7227 ? $("#eHPcollectionBranch").val('') : '';
     });

    /* Common.ajax("GET", "/organization/selectHPOrientation.do", "", function(result) { //20-10-2021 - HLTANG - close for LMS project

        $("#course").find('option').each(function() {
            $(this).remove();
        });
        console.log("-------------------------" + JSON.stringify(result));
        if (result!= null) {
            $("#course").append("<option value=''>Choose One</option>");
            for( var i=0; i< result.length; i++) {
                $("#course").append("<option value="+result[i].codeId+">"+result[i].codeName+"</option>");
            }
        }
    }); */

});

// 2018-06-20 - LaiKW - Removal of MBF Bank and Others from Issued Bank drop down box
function onclickIssuedBank() {
    $("#eHPissuedBank > option[value='22']").remove();
    $("#eHPissuedBank > option[value='24']").remove();
    $("#eHPissuedBank > option[value='42']").remove();
    $("#eHPissuedBank > option[value='43']").remove();
}

function onChangeIssuedBank(sel) {
    issuedBankTxt = sel.options[sel.selectedIndex].text;
    console.log("issuedBankTxt :: " + issuedBankTxt);
}


//Validation Check
function fn_saveValidation(){
console.log("validation");
var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if($("#eHPmemberNm").val() == ''){
        Common.alert("Please key  in Member Name");
        return false;
    }

    if($("#eHPjoinDate").val() == ''){
        Common.alert("Please select Joined Date");
        return false;
    }

    if($("#eHPsponsorCd").val() == ''){
        Common.alert("Please select 'Sponsor's Code'");
        return false;
    }

    if($('input[name=gender]:checked', '#eHPmemberAddForm').val() == null){
          Common.alert("Please select Gender");
            return false;
    }


    if($("#eHPBirth").val() == ''){
        Common.alert("Please select Date of Birth");
        return false;
    }

    if($("#eHPcmbRace").val() == ''){
        Common.alert("Please select race");
        return false;
    }

    if($("#eHPnational").val() == ''){
        Common.alert("Please select Nationality");
        return false;
    }

    if($("#eHPnric").val() == ''){
        Common.alert("Please key  in NRIC");
        return false;
    }

    if (  $("#eHPnric").val().length != 12 ) {
        Common.alert("NRIC should be in 12 digit");
        return false;
    }

    if($("#eHPmarrital").val() == ''){
        Common.alert("Please select marrital");
        return false;
    }

    if($("#eHPmarrital").val() == '26'){
        if($("#eHPspouseName").val() == '') {
            Common.alert("Please enter spouse name");
            return false;
        }
        if($("#eHPspouseNric").val() == '') {
            Common.alert("Please enter spouse NRIC/Passport No");
            return false;
        }
        if($("#eHPspouseOcc").val() == '') {
            Common.alert("Please enter spouse occupation");
            return false;
        }
        if($("#eHPspouseDob").val() == '') {
            Common.alert("Please enter spouse date of birth");
            return false;
        }
        if($("#eHPspouseContat").val() == '') {
            Common.alert("Please enter spouse contact");
            return false;
        }
    }

    if($("#eHPissuedBank").val() == ''){
        Common.alert("Please select the issued bank");
        return false;
    }
    if($("#eHPbankAccNo").val() == ''){
        Common.alert("Please key in the bank account no");
        return false;
    }

    if(FormUtil.isEmpty($('#eHPregOpt').val())) {
        Common.alert("Please select Registration Options");
        return false;
    }else{
       if ($("#eHPregOpt").val() !=7227  && FormUtil.isEmpty($('#eHPcollectionBranch').val())){
           Common.alert("Please select Collection branch");
           return false;
       }
    }

    //type 별로 다르게 해야됨
    if($("#eHPdeptCd").val() == ''){
        Common.alert("Please select the department code");
        return false;
    }

    if($("#eHPareaId").val() == ''){
        Common.alert("Please key in the address.");
        return false;
    }

    if($("#eHPaddrDtl").val() == ''){
        Common.alert("Please key in the address detail.");
        return false;
    }

    if($("#eHPmArea").val() == ''){
            Common.alert("Please key in the area.");
            return false;
    }

    if($("#eHPmCity").val() == ''){
        Common.alert("Please key in the city.");
        return false;
    }

    if($("#eHPmPostCd").val() == ''){
        Common.alert("Please key in the postcode.");
        return false;
    }

    if($("#eHPmState").val() == ''){
        Common.alert("Please key in the state.");
        return false;
    }

    if(!fn_validFile()) {
        return false;
    }

    if($("#eHPmemberType").val() == "2803") {
        if($("#eHPmobileNo").val() == '') {
            Common.alert("Please key in Mobile No.");
            return false;
        }else{
            if($("#eHPmobileNo").val().length < 10 || $("#eHPmobileNo").val().length > 12){
                Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLengthMember" />');
                return false;
            }

            if($("#eHPmobileNo").val().substring(0,3) == "015"){
                Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                return false;
            }else if($("#eHPmobileNo").val().substring(0,2) != "01"){
                Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                return false;
            }
        }

        if($("#eHPemail").val() == '') {
            Common.alert("Please key in Email Address");
            return false;
        }

      //region Check Email
        if ((jQuery.trim($("#eHPemail").val())).length>0) //20-10-2021 - HLTANG - valid email validation
        {
            if (!regEmail.test($("#eHPemail").val()))
            {
                Common.alert("Invalid contact person email");
                return false;
            }
        }
        //endregion

        // 2018-07-26 - LaiKW - Added Meeting Point and Branch
        if($('#eHPmeetingPoint').val() == '') {
            Common.alert("Please select Business Area");
            return false;
        }

//         if($("#eHPcollectionBranch").val() == '' ) {
//             Common.alert("Please select Collection branch");
//             return false;
//         }

        /* if($("#course").val() == "") { //20-10-2021 - HLTANG - close for LMS project
            Common.alert("Please select orientation date");
            return false;
        } */

    }

/*     //@AMEER add INCOME TAX
    if($("#eHPincomeTaxNo").val().length > 0 &&  $("#eHPincomeTaxNo").val().length < 10){
        Common.alert("Invalid Income Tax Length");
        return false;
  } */
    var regIncTax = /^[a-zA-Z0-9]*$/;
    if(!regIncTax.test($("#eHPincomeTaxNo").val())){
        Common.alert("Invalid Income Tax Format");
        return false;
    }

    return true;
}

function fn_addrSearch(){
    if($("#eHPsearchSt").val() == ''){
        Common.alert("Please search.");
        return false;
    }
    Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#eHPinsAddressForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
}
function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){

    if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){

        $("#eHPmArea").attr({"disabled" : false  , "class" : "w100p"});
        $("#eHPmCity").attr({"disabled" : false  , "class" : "w100p"});
        $("#eHPmPostCd").attr({"disabled" : false  , "class" : "w100p"});
        $("#eHPmState").attr({"disabled" : false  , "class" : "w100p"});

        //Call Ajax

        CommonCombo.make('eHPmState', "/sales/customer/selectMagicAddressComboList", '' , mstate, optionState);

        var cityJson = {state : mstate}; //Condition
        CommonCombo.make('eHPmCity', "/sales/customer/selectMagicAddressComboList", cityJson, mcity , optionCity);

        var postCodeJson = {state : mstate , city : mcity}; //Condition
        CommonCombo.make('eHPmPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, mpostcode , optionCity);

        var areaJson = {groupCode : mpostcode};
        var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
        CommonCombo.make('eHPmArea', "/sales/customer/selectMagicAddressComboList", areaJson, marea , optionArea);

        $("#eHPareaId").val(areaid);
        $("#_searchDiv").remove();
    }else{
        Common.alert("Please check your address.");
    }
}



function fn_sponsorPop(){
    Common.popupDiv("/organization/sponsorPop.do" , $('#eHPmemberAddForm').serializeJSON(), null , true,  '_searchSponDiv'); //searchSt
}


function fn_addSponsor(msponsorCd, msponsorNm, msponsorNric) {


    $("#eHPsponsorCd").val(msponsorCd);
    $("#eHPsponsorNm").val(msponsorNm);
    $("#eHPsponsorNric").val(msponsorNric);

    $("#_searchSponDiv").remove();

}





//Get Area Id
function fn_getAreaId(){

    var statValue = $("#eHPmState").val();
    var cityValue = $("#eHPmCity").val();
    var postCodeValue = $("#eHPmPostCd").val();
    var areaValue = $("#eHPmArea").val();



    if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){

        var jsonObj = { statValue : statValue ,
                              cityValue : cityValue,
                              postCodeValue : postCodeValue,
                              areaValue : areaValue
                            };
        Common.ajax("GET", "/sales/customer/getAreaId.do", jsonObj, function(result) {

             $("#eHPareaId").val(result.areaId);

        });

    }

}

function fn_selectCity(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){

         $('#eHPmPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
         $('#eHPmPostCd').val('');
         $("#eHPmPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

         $('#eHPmArea').append($('<option>', { value: '', text: '4. Area' }));
         $('#eHPmArea').val('');
         $("#eHPmArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }else{

        $("#eHPmPostCd").attr({"disabled" : false  , "class" : "w100p"});

        $('#eHPmArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#eHPmArea').val('');
        $("#eHPmArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        //Call ajax
        var postCodeJson = {state : $("#eHPmState").val() , city : tempVal}; //Condition
        CommonCombo.make('eHPmPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
    }

}

function fn_selectPostCode(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){

        $('#eHPmArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#eHPmArea').val('');
        $("#eHPmArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }else{

        $("#eHPmArea").attr({"disabled" : false  , "class" : "w100p"});

        //Call ajax
        var areaJson = {state : $("#eHPmState").val(), city : $("#eHPmCity").val() , postcode : tempVal}; //Condition
        CommonCombo.make('eHPmArea', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
    }

}

function fn_selectState(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){
        //전체 초기화
        fn_initAddress();

    }else{

        $("#eHPmCity").attr({"disabled" : false  , "class" : "w100p"});

        $('#eHPmPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
        $('#eHPmPostCd').val('');
        $("#eHPmPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        $('#eHPmArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#eHPmArea').val('');
        $("#eHPmArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        //Call ajax
        var cityJson = {state : tempVal}; //Condition
        CommonCombo.make('eHPmCity', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
    }

}

function fn_sponsorCheck(){
    if(event.keyCode == 13) {
        fn_sponsorCd();
    }
}

function fn_sponsorCd(){
    Common.ajax("GET", "/organization/checkSponsor.do", $("#eHPmemberAddForm").serializeJSON(), function(result) {
        // add jgkim
        console.log("checkSponsor.do Action");
        console.log(result);
        if (result.message != "ok") {
            Common.alert(result.message);
        } else {
            // add jgkim
            $("#eHPsponsorNm").val(result.data.name);
            $("#eHPsponsorNric").val(result.data.nric);
        }
    });
}

function checkNRICEnter(){
    if(event.keyCode == 13) {
        checkNRIC();
    }
}



function checkNRIC(){
    var returnValue;

    var jsonObj = { "nric" : $("#eHPnric").val() };

    isRejoinMem = false;
    $("#isRejoinMem").val(false);
    $("#salOrgRejoin").val('');
    $(".join").hide();

    if ($("#eHPmemberType").val() == '2803' ) {
    	Common.ajax("GET", "/organization/memberRejoinChecking.do", jsonObj, function(result) {
            //Qualified rejoin member
           if (result.message == "pass - rejoin") {
        	   if(result.data.salOrgRejoin == "1"){
        		   isRejoinMem = true;
                   $("#isRejoinMem").val(true);
                   $("#memId").val(result.data.memId);
                   $("#salOrgRejoin").val(result.data.salOrgRejoin);
                   $(".join").show();

                   Common.ajax("GET", "/organization/checkNRIC3.do", jsonObj, function(result) {
                       console.log("data : " + result);
                       if (result.message != "pass") {
                           Common.alert(result.message);
                           $("#eHPnric").val('');
                           returnValue = false;
                           return false;
                       } else {    // 조건3 통과 -> 끝
                        //Common.alert("Available NRIC");
                            autofilledbyNRIC();
                            returnValue = true;
                            return true;
                       }
                   });
        	   }else {
        		   Common.alert("This applicant is not approved to rejoin as HP.");
        	   }

               // new member or member is not in ORG0001D or not apply member rejoin in member eligibility
           } else if (result.message == "pass"){
               Common.ajax("GET", "/organization/checkNRIC2.do", jsonObj, function(result) {
                   console.log("data : " + result);
                   if (result.message != "pass") {
                        Common.alert(result.message);
                        $("#eHPnric").val('');
                        returnValue = false;
                        return false;

                   } else {    // 조건1 통과 -> 조건2 수행
                        Common.ajax("GET", "/organization/checkNRIC1.do", jsonObj, function(result) {
                               console.log("data : " + result);
                               if (result.message != "pass") {
                                   Common.alert(result.message);
                                   $("#eHPnric").val('');
                                   returnValue = false;
                                   return false;
                               } else {    // 조건2 통과 -> 조건3 수행

                                  Common.ajax("GET", "/organization/checkNRIC3.do", jsonObj, function(result) {
                                       console.log("data : " + result);
                                       if (result.message != "pass") {
                                           Common.alert(result.message);
                                           $("#eHPnric").val('');
                                           returnValue = false;
                                           return false;
                                       } else {    // 조건3 통과 -> 끝
                                            //Common.alert("Available NRIC");
                                            autofilledbyNRIC();
                                            returnValue = true;
                                            return true;
                                       }
                                 });
                             }
                        });
                   }
               });

           // Not qualified to rejoin
           } else {
               Common.alert(result.message);
               $("#eHPnric").val('');
               returnValue = false;
               return false;
           }
       });
    } else {
        autofilledbyNRIC();
    }


    return returnValue;

}

function autofilledbyNRIC(){

    //if ($("#memberType").val() == '4') {
        var nric = $("#eHPnric").val().replace('-', '');
        var autoGender = nric.substr(11,1);
        //var autoDOB = nric.substr(0,6);
        var autoDOB_year = nric.substr(0,2);
        var autoDOB_month = nric.substr(2,2);
        var autoDOB_date = nric.substr(4,2);

        if (parseInt(autoGender)%2 == 0) {
            $("input:radio[name='gender']:radio[value='F']").prop("checked", true);
        } else {
            $("input:radio[name='gender']:radio[value='M']").prop("checked", true);
        }

        if (parseInt(autoDOB_year) < 20) {
            $("#eHPBirth").val(autoDOB_date+"/"+autoDOB_month+"/"+"20"+autoDOB_year);
        } else {
            $("#eHPBirth").val(autoDOB_date+"/"+autoDOB_month+"/"+"19"+autoDOB_year);
        }
    //}

}

function fn_autofilledbySpouseNRIC(){

	if(event.keyCode == 13) {
        var nric = $("#eHPspouseNric").val().replace('-', '');
        var autoGender = nric.substr(11,1);
        var autoDOB_year = nric.substr(0,2);
        var autoDOB_month = nric.substr(2,2);
        var autoDOB_date = nric.substr(4,2);

        if (parseInt(autoGender)%2 == 0) {
            $("input:radio[name='gender']:radio[value='F']").prop("checked", true);
        } else {
            $("input:radio[name='gender']:radio[value='M']").prop("checked", true);
        }

        if (parseInt(autoDOB_year) < 20) {
            $("#eHPspouseDob").val(autoDOB_date+"/"+autoDOB_month+"/"+"20"+autoDOB_year);
        } else {
            $("#eHPspouseDob").val(autoDOB_date+"/"+autoDOB_month+"/"+"19"+autoDOB_year);
        }
    }

}

function fn_onchangeMarrital() {
    if($("#eHPmarrital").val() != "26") {
        $("#eHPspouseNameLbl").find("span").remove();
        $("#eHPspouseNricLbl").find("span").remove();
        $("#eHPspouseOccLbl").find("span").remove();
        $("#eHPspouseDobLbl").find("span").remove();
        $("#eHPspouseContatLbl").find("span").remove();
    }

    if($("#eHPmarrital").val() == "26") {
        $("#eHPspouseNameLbl").append("<span class='must'>*</span>");
        $("#eHPspouseNricLbl").append("<span class='must'>*</span>");
        $("#eHPspouseOccLbl").append("<span class='must'>*</span>");
        $("#eHPspouseDobLbl").append("<span class='must'>*</span>");
        $("#eHPspouseContatLbl").append("<span class='must'>*</span>");
    }
}

function fn_checkMobileNo() {
    if(event.keyCode == 13) {
        fmtNumber("#eHPmobileNo");
    }
}

function fmtNumber(field) {
    var fld = $(field).val();
    fld = fld.replace(/[^0-9]/g,"");

    $(field).val(fld);
}

function checkBankAccNoEnter() {
    if(event.keyCode == 13) {
        if($("#eHPmemberType").val() != "5") {
            console.log("not trainee with -/0")
            fmtNumber("#eHPbankAccNo"); // 2018-06-21 - LaiKW - Added removal of special characters from bank account number
            checkBankAccNo();
         } else if($("#eHPmemberType").val() == "5") {
            console.log("bankaccno :: " + $("#eHPbankAccNo").val());
            if($("#eHPbankAccNo").val() != "-"){
                checkBankAccNo();
            }
         }
    }
}

function checkEmailOnEnter() {
    if(event.keyCode == 13) {
    	checkEmail();
    }
}

function checkEmail() {
    var jsonObj = {
            "email" : $("#eHPemail").val()
        };

    Common.ajax("GET", "/organization/checkEmail.do", jsonObj, function(result) {
        console.log("data : " + result);
        if (result.message != "pass") {
            Common.alert(result.message);
            $("#eHPemail").val('');
            returnValue = false;
            return false;
        } else {
             returnValue = true;
             return true;
        }
  });
}

function checkBankAccNo() {
    //var jsonObj = { "bank" : $("#issuedBank").val(), "bankAccNo" : $("#bankAccNo").val() };
    var jsonObj = {
        "bankId" : $("#eHPissuedBank").val(),
        "bankAccNo" : $("#eHPbankAccNo").val(),
        "nric" : $("#eHPnric").val()
    };

    if (!$("#eHPnric").val().trim()) {
    	Common.alert("Kindly keyin NRIC first.")
    	$("#eHPbankAccNo").val("");
    	return
    }

    Common.ajax("GET", "/organization/memberRejoinChecking.do", jsonObj, function(result) {
    	if (result.message == "pass - rejoin" && result.data.salOrgRejoin == "1") {
    		return
    	}
	    if($("#eHPmemberType").val() == "2803") {
	        Common.ajax("GET", "/organization/checkAccLen", jsonObj, function(resultM) {
	            console.log(resultM);

	            if(resultM.message == "F") {
	                Common.alert("Invalid Account Length!");
	                $("#eHPbankAccNo").val("");
	                return false;
	            } else if(resultM.message == "S") {

	                Common.ajax("GET", "/organization/checkBankAcc", jsonObj, function(result) {
	                    console.log(result);
	                    if(result.cnt1 == "0" && result.cnt2 == "0") {
	                        return true;
	                    } else {
	                        Common.alert("Bank account number has been registered.");
	                        //$("#issuedBank").val("");
	                        $("#eHPbankAccNo").val("");
	                        return false;
	                    }
	                });
	            }
	        });
	    } else {
	        Common.ajax("GET", "/organization/checkBankAcc", jsonObj, function(result) {
	            console.log(result);
	            if(result.cnt1 == "0" && result.cnt2 == "0") {
	                return true;
	            } else {
	                Common.alert("Bank account number has been registered.");
	                //$("#issuedBank").val("");
	                $("#eHPbankAccNo").val("");
	                return false;
	            }
	        });
	    }
    })
}

function fn_removeFile(name){
    if(name == "PAY") {
         $("#paymentFile").val("");
         $('#paymentFile').change();
    }else if(name == "OTH"){
        $("#otherFile").val("");
        $('#otherFile').change();
    }else if(name == "OTH2"){
        $("#otherFile2").val("");
        $('#otherFile2').change();
    }else if(name == "TAF") {
        $("#terminateAgreement").val("");
        $('#terminateAgreement').change();
    }
}

function fn_validFile() {
    var isValid = true, msg = "";

    if(FormUtil.isEmpty($('#nricFile').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of NRIC<br>";
    }
    if(FormUtil.isEmpty($('#statementFile').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Bank Passport / Statement<br>";
    }
    if(FormUtil.isEmpty($('#passportFile').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Passport photo<br>";
    }
    if(FormUtil.isEmpty($('#hpAppForm').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of HP Application Form<br>";
    }

    if(isRejoinMem == false){
        if(FormUtil.isNotEmpty($('#terminateAgreement').val().trim())) {
             isValid = false;
             msg += "* Not allowed to upload Termination Agreement<br>";
         }
	 }else {
	     if(FormUtil.isEmpty($('#terminateAgreement').val().trim())) {
	         isValid = false;
	         msg += "* Please upload copy of Termination Agreement<br>";
	     }
	 }

    $.each(myFileCaches, function(i, j) {
        if(myFileCaches[i].file.checkFileValid == false){
            isValid = false;
           msg += myFileCaches[i].file.name + "<br>* File uploaded only allowed for picture format less than 2MB and 30 wordings<br>";
       }
   });

    if(!isValid) Common.alert("Save eHP - Add New Member" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

    return isValid;
}

function fn_eHPmarritalCallBack(){
    var eHPmarritalVal = '';
    var eHPmarritalLen = $('#eHPmarrital option').size();

    for(var i=0; i<eHPmarritalLen; ++i) {
    	eHPmarritalVal = $("#eHPmarrital option:eq("+i+")").val();
        if(eHPmarritalVal == '29') {  // Other
            $("#eHPmarrital option:eq("+i+")").remove();
        }
    }
}


</script>

<!--
****************************************
**************** DESIGN ****************
****************************************
 -->

<form id="eHpForm">
    <div id="popup_wrap" class="popup_wrap">

        <header class="pop_header">
            <h1>eHP - Add New Member</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header>

        <form id="eHPapplicantDtls" method="post">
            <div style="display:none">
                <input type="text" name="eHPaplcntNRIC"  id="eHPaplcntNRIC"/>
                <input type="text" name="eHPaplcntName"  id="eHPaplcntName"/>
                <input type="text" name="eHPaplcntMobile"  id="eHPaplcntMobile"/>
            </div>
        </form>

        <section class="pop_body">
            <form action="#" id="eHPmemberAddForm" method="post">
                <input type="hidden" id="eHPareaId" name="areaId">
                <input type="hidden" id="eHPstreetDtl1" name="streetDtl">
                <input type="hidden" value ="eHPaddrDtl" id="addrDtl1" name="addrDtl">
                <input type="hidden" id="eHPtraineeType" name="traineeType">
                <input type="hidden" id="eHPsubDept" name="subDept">
                <input type="hidden" id="eHPuserType" name="userType" value="${userType}">
                <input type="hidden" id="eHPmemType" name="memType" value="${memType}">
                <input type="hidden" id="isRejoinMem" name="isRejoinMem">
				<input type="hidden" id="memId" name="memId">
				<input type="hidden" id="salOrgRejoin" name="salOrgRejoin">

                <!--<input type="hidden" id = "memberType" name="memberType"> -->
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row">Member Type</th>
                            <td>
                            <select class="w100p" id="eHPmemberType" name="memberType" disabled="disabled">
                                <option value="2803" selected>HP Applicant</option>
                            </select>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <section class="tap_wrap">
                <ul class="tap_type1 num4">
                    <li><a href="#" class="on">Basic Info</a></li>
                    <li><a href="#">Spouse Info</a></li>
                    <li><a href="#">Member Address</a></li>
                    <li><a href="#">Attachment</a></li>
                </ul>

                <article class="tap_area">

                <aside class="title_line">
                    <h2>Basic Information</h2>
                </aside>
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:160px" />
                        <col style="width:*" />
                        <col style="width:180px" />
                        <col style="width:*" />
                        <col style="width:180px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                    <!-- <tr>
                        <th scope="row">Member Code</th>
                        <td colspan="5">
                        <input type="text" title="" id="memberCd" name="memberCd" placeholder="Member Code" class="w100p" disabled="disabled" />
                        </td>
                    </tr> -->
                    <tr>
                        <th scope="row">Member Name<span class="must">*</span></th>
                        <td colspan="3">
                            <input type="text" title="" id="eHPmemberNm" name="memberNm" placeholder="Member Name" class="w100p" />
                        </td>
                        <th scope="row">Joined Date<span class="must">*</span></th>
                        <td>
                            <input type="text" title="Create start Date" id="eHPjoinDate" name="joinDate" placeholder="DD/MM/YYYY" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                       <th scope="row">NRIC (New)<span class="must">*</span></th>
                        <td>
                            <input type="text" title="" placeholder="NRIC (New)" id="eHPnric" name="nric" class="w100p"  maxlength="12" onKeyDown="checkNRICEnter()"
                            onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
                        </td>
                        <th scope="row">Date of Birth<span class="must">*</span></th>
                        <td>
                            <input type="text" title="Create start Date" id="eHPBirth" name="Birth"placeholder="DD/MM/YYYY" class="j_date" />
                        </td>
                        <th scope="row">Race<span class="must">*</span></th>
                        <td>
                            <select class="w100p" id="eHPcmbRace" name="cmbRace">
                                <option value="">Choose One</option>
                                <c:forEach var="list" items="${race}" varStatus="status">
                                    <option value="${list.detailcodeid}">${list.detailcodename } </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Nationality<span class="must">*</span></th>
                        <td>
                        <select class="w100p" id="eHPnational" name="national">
                         <c:forEach var="list" items="${nationality}" varStatus="status">
                                 <option value="${list.countryid}">${list.name } </option>
                            </c:forEach>
                        </select>
                        </td>
                            <th scope="row">Gender<span class="must">*</span></th>
                        <td>
                        <label><input type="radio" name="gender" id="eHPgender" value="M" /><span>Male</span></label>
                        <label><input type="radio" name="gender" id="eHPgender" value="F"/><span>Female</span></label>
                        </td>
                        <th scope="row">Marital Status<span class="must">*</span></th>
                        <td>
                        <select class="w100p" id="eHPmarrital" name="marrital" onchange="javascript : fn_onchangeMarrital()">
                        </select>
                        </td>
                    </tr>

                    <!-- ADDED INCOME TAX NO @AMEER 2021-10-25-->
                <tr>
                    <th scope="row">Income Tax No</th>
                    <td colspan="2">
                    <input type="text" title=""  placeholder="Income Tax No" class="w100p"  id="eHPincomeTaxNo"  name="eHPincomeTaxNo"
                    onkeyup="this.value = this.value.toUpperCase();" style = "IME-MODE:disabled;"/>
                    </td>
                </tr>

                    <tr>
                        <th scope="row" id="eHPemailLbl" name ="emailLbl">Email</th>
                        <td colspan="5">
                        <input type="text" title="" placeholder="Email" class="w100p" id="eHPemail" name="email" onKeyDown="checkEmailOnEnter()"
                    />

                        </td>
                    </tr>
                    <tr>
                        <th scope="row" id="eHPmobileNoLbl" name="mobileNoLbl">Mobile No.</th>
                        <td>
                        <input type="text" title="" placeholder="Numeric Only" class="w100p" id="eHPmobileNo" name="mobileNo" maxlength="11" onKeyDown="fn_checkMobileNo()"
                            onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
                        </td>
                        <th scope="row">Office No.</th>
                        <td>
                        <input type="text" title="" placeholder="Numberic Only" class="w100p"  id="eHPofficeNo" name="officeNo"
                            onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
                        </td>
                        <th scope="row">Residence No.</th>
                        <td>
                        <input type="text" title="" placeholder="Numberic Only" class="w100p" id="eHPresidenceNo"  name="residenceNo"
                            onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Sponsor's Code<span class="must">*</span></th>
                        <td>

                        <div class="search_100p"><!-- search_100p start -->
                        <input type="text" title="" placeholder="Sponsor's Code" class="w100p" id="eHPsponsorCd" name="sponsorCd" onKeyDown="fn_sponsorCheck()"/>
                        <a href="javascript:fn_sponsorPop();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </div><!-- search_100p end -->

                        </td>
                        <th scope="row">Sponsor's Name</th>
                        <td>
                        <input type="text" title="" placeholder="Sponsor's Name" class="w100p"  id="eHPsponsorNm" name="sponsorNm"/>
                        </td>
                        <th scope="row">Sponsor's NRIC</th>
                        <td>
                        <input type="text" title="" placeholder="Sponsor's NRIC" class="w100p" id="eHPsponsorNric" name="sponsorNric"
                            onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Branch<span class="must">*</span></th>
                        <td>
                        <select class="w100p" id="eHPbranch" name="branch">
                        </select>
                        </td>
                        <th scope="row">Department Code<span class="must">*</span></th>
                        <td>
                        <select class="w100p" id="eHPdeptCd" name="deptCd">
                            <c:forEach var="list" items="${DeptCdList}" varStatus="status">
                                <option value="${list.codeId}">${list.codeName } </option>
                            </c:forEach>

                        </select>
                        </td>
                        <th scope="row">Transport Code</th>
                        <td>
                        <select class="w100p"  id="eHPtransportCd" name="transportCd">
                        </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" id="eHPmeetingPointLbl">Business Area</th>
                        <td colspan="5">
                            <select class="w100p" id="eHPmeetingPoint" name="meetingPoint"></select>
                        </td>
                    </tr>
                    <%-- <tr>
                        <th scope="row">e-Approval Status</th>
                        <td colspan="5">
                        <input type="text" id="eHPapprStusText" name="apprStusText" title="" placeholder="e-Approval Status" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Religion</th>
                        <td colspan="2">
                        <select class="w100p" id="eHPreligion" name="religion">
                                <option value="">Choose One</option>
                            <c:forEach var="list" items="${Religion}" varStatus="status">
                                <option value="${list.detailcodeid}">${list.detailcodename } </option>
                            </c:forEach>
                        </select>
                        </td>
                        <th scope="row">e-Approval Status</th>
                        <td colspan="2">
                        <select class="w100p" id="eHPapprStusCombo" name="apprStusCombo">
                           <!--  <option value="">Choose One</option> -->
                            <option value="">Pending</option>
                            <option value="">Approved</option>
                            <option value="">Rejected</option>
                        </select>
                        </td>
                    </tr>
                    <tr>
                        <th id="eHPcourseLbl" scope="row">Training Course</th>
                        <td colspan="2">
                        <select class="w100p" id="eHPcourse" name="course">
                        </select>
                        </td>
                        <th scope="row">Total Vacation</th>
                        <td colspan="2">
                        <input type="text" id="eHPtotalVacation" name="totalVacation" title="" placeholder="Total Vacation" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Application Status</th>
                        <td colspan="2">
                        <select class="w100p" id="eHPapplicationStatus">
                            <option value="">Choose One</option>
                            <option value="">Register</option>
                            <option value="">Training</option>
                            <option value="">Result-fail</option>
                            <option value="">Pass, Absent</option>
                            <option value="">Confirmed</option>
                            <option value="">Cancelled</option>
                        </select>
                        </td>
                        <th scope="row">Remain Vacation</th>
                        <td colspan="2">
                        <input type="text" id="eHPremainVacation" name="remainVacation" title="" placeholder="Remain Vacation" class="w100p" />
                        </td>
                    </tr>
                    <tr id = "eHPtrTrainee" >
                        <th scope="row">Trainee Type </th>
                        <td colspan="2">
                            <select class= "w100p" id="eHPtraineeType1" name="traineeType1">
                            <option value="">Choose One</option>
                            <option value= "2">Cody</option>
                            <option value = "3">CT</option>
                            <option value = "7">HT</option>
                            <option value = "5758">DT</option>
                        </select>
                        </td>
                        <th scope="row"></th>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Main Department</th>
                        <td colspan="2">
                        <select class="w100p" id="eHPsearchdepartment" name="searchdepartment"  >
                                <option value="">Choose One</option>
                             <c:forEach var="list" items="${mainDeptList}" varStatus="status">
                                 <option value="${list.deptId}">${list.deptName } </option>
                            </c:forEach>
                        </select>
                        </td>
                        <th scope="row">Sub Department</th>
                        <td colspan="2">
                        <select class="w100p" id="eHPsearchSubDept" name="searchSubDept">
                                 <option value="">Choose One</option>
                           <c:forEach var="list" items="${subDeptList}" varStatus="status">
                                 <option value="${list.deptId}">${list.deptName} </option>
                            </c:forEach>
                        </select>
                        </td>
                    </tr> --%>
                    </tbody>
                </table><!-- table end -->

                <aside class="title_line">
                <h2>Bank Account Information</h2>
                </aside>

                <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">Issued Bank<span class="must">*</span></th>
                    <td>
                    <select class="w100p" id="eHPissuedBank" name="issuedBank" onClick="javascript : onclickIssuedBank()" onChange="onChangeIssuedBank(this)">
                    </select>
                    </td>
                    <th scope="row">Bank Account No<span class="must">*</span></th>
                    <td>
                    <input type="text" title="" placeholder="Bank Account No" class="w100p" id="eHPbankAccNo"  name="bankAccNo" onKeyDown="checkBankAccNoEnter()"
                    onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
                    </td>
                </tr>

                </tbody>
                </table><!-- table end -->

                <!-- <aside class="title_line">title_line start
                <h2>Language Proficiency</h2>
                </aside>title_line end

                <table class="type1">table start
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">Education Level</th>
                    <td>
                    <select class="w100p" id="eHPeducationLvl" name="educationLvl">
                    </select>
                    </td>
                    <th scope="row">Language</th>
                    <td>
                    <select class="w100p" id="eHPlanguage" name="language">
                    </select>
                    </td>
                </tr>
                </tbody>
                </table>table end -->

                <aside class="title_line">
                <h2>Registration Information</h2>
                </aside>

                <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:160px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">Registration Options<span class="must">*</span></th>
                    <td>
                    <select class="w100p" id="eHPregOpt" name="eHPregOpt">
                    </select>
                    </td>
                </tr>
                </tbody>
                </table>

                <aside class="title_line">
                <h2>Starter Kit & ID Tag</h2>
                </aside>

                <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:160px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">Collection Branch<span class="must">*</span></th>

                      <td colspan="5">
                       <select class="w100p" id="eHPcollectionBranch" name="collectionBranch">
                               <option value="" selected>Select Branch</option>
                        <c:forEach var="list" items="${SOBranch }" varStatus="status">
                           <option value="${list.codeId}">${list.codeName}</option>
                        </c:forEach>
                        </select>
                    </td>

                </tr>
                </tbody>
                </table><!-- table end -->

                <!--
                <aside class="title_line" >
                <h2>Agreement</h2>
                </aside>
                 -->

                <table class="type1" id="eHPhideContent">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row"  class="hideContent">Cody PA Expiry<span class="must">*</span></th>
                    <td  class="hideContent">
                    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="codyPaExpr" name="codyPaExpr"/>
                    </td>
                </tr>
                </tbody>
                </table><!-- table end -->

                <!-- <aside class="title_line"> 20-10-2021 - HLTANG - close for LMS project
                    <h2>Orientation</h2>
                </aside>

                <table class="type1" id="orientationTbl">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row">Orientation</th>
                            <td>
                                <select class="w100p" id="course" name="course">
                            </td>
                        </tr>
                    </tbody>
                </table> -->

                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
                    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_close()">CANCEL</a></p></li>
                </ul>

                </article>

                <article class="tap_area">

                <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:120px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row" id="eHPspouseCodeLbl" name="spouseCodeLbl">MCode</th>
                    <td>
                    <input type="text" title="" placeholder="MCode" class="w100p" id="eHPspouseCode" name="spouseCode" value=""/>
                    </td>
                    <th scope="row" id="eHPspouseNameLbl" name="spouseNameLbl">Spouse Name</th>
                    <td>
                    <input type="text" title="" placeholder="Spouse Nam" class="w100p" id="eHPspouseName" name="spouseName" value=""/>
                    </td>
                    <th scope="row" id="eHPspouseNricLbl" name="eHPspouseNricLbl">NRIC / Passport No.</th>
                    <td>
                    <input type="text" title="" placeholder="NRIC / Passport No." class="w100p" id="eHPspouseNric" name="spouseNric"  value=""
                    onkeydown="fn_autofilledbySpouseNRIC()" onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row" id="eHPspouseOccLbl" name="spouseOccLbl">Occupation</th>
                    <td>
                    <input type="text" title="" placeholder="Occupation" class="w100p" id="eHPspouseOcc" name="spouseOcc" value=""/>
                    </td>
                    <th scope="row" id="eHPspouseDobLbl" name="spouseDobLbl">Date of Birth</th>
                    <td>
                    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date readonly" id="eHPspouseDob" name="spouseDob" value=""/>
                    </td>
                    <th scope="row" id="eHPspouseContatLbl" name="spouseContatLbl">Contact No.</th>
                    <td>
                    <input type="text" title="" placeholder="Contact No. (Numberic Only)" class="w100p readonly" id="eHPspouseContat" name="spouseContat"  value=""/>
                    </td>
                </tr>
                </tbody>
                </table><!-- table end -->

                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
                    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_close()">CANCEL</a></p></li>
                </ul>

                </article>

            </form>
            <article class="tap_area">

            <aside class="title_line">
            <h2>Address</h2>
            </aside>

            <form id="eHPinsAddressForm" name="insAddressForm" method="POST">

                <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:135px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                     <tbody>
                        <tr>
                            <th scope="row">Area search<span class="must">*</span></th>
                            <td colspan="3">
                            <input type="text" title="" id="eHPsearchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" >Address Detail<span class="must">*</span></th>
                            <td colspan="3">
                            <input type="text" title="" id="eHPaddrDtl" name="addrDtl" placeholder="Detail Address" class="w100p"  maxlength="50"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" >Street</th>
                            <td colspan="3">
                            <input type="text" title="" id="eHPstreetDtl" name="streetDtl" placeholder="Street" class="w100p"  maxlength="50"/>
                            </td>
                        </tr>
                        <tr>
                           <th scope="row">Area(4)<span class="must">*</span></th>
                            <td colspan="3">
                            <select class="w100p" id="eHPmArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select>
                            </td>
                        </tr>
                        <tr>
                             <th scope="row">City(2)<span class="must">*</span></th>
                            <td>
                            <select class="w100p" id="eHPmCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
                            </td>
                            <th scope="row">PostCode(3)<span class="must">*</span></th>
                            <td>
                            <select class="w100p" id="eHPmPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">State(1)<span class="must">*</span></th>
                            <td>
                            <select class="w100p" id="eHPmState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
                            </td>
                            <th scope="row">Country<span class="must">*</span></th>
                            <td>
                            <input type="text" title="" id="eHPmCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
            </form>
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
                  <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_close()">CANCEL</a></p></li>
            </ul>
            </article>


            <article class="tap_area">

            <aside class="title_line">
            <h2>Attachment</h2>
            </aside>

            <form id="attachmentForm" name="attachmentForm" method="POST">

            <table class="type1">
            <caption>table</caption>
            <colgroup>
                 <col style="width:30%" />
                <col style="width:*" />

            </colgroup>
            <tbody>
            <tr>
                <th scope="row">NRIC<span class="must">*</span></th>
                <td >
                    <div class="auto_file2">
                        <input type="file" title="file add" id="nricFile" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
                        <label>
                            <input type='text' class='input_text' readonly='readonly' />
                            <span class='label_text'><a href='#'>Upload</a></span>
                        </label>
                    </div>
                </td>
            </tr>

            <tr>
                <th scope="row">Bank Passbook/Statement Copy<span class="must">*</span></th>
                <td >
                    <div class="auto_file2">
                        <input type="file" title="file add" id="statementFile" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
                        <label>
                            <input type='text' class='input_text' readonly='readonly' />
                            <span class='label_text'><a href='#'>Upload</a></span>
                        </label>
                    </div>
                </td>
            </tr>

            <tr>
                <th scope="row">Passport Photo<span class="must">*</span></th>
                <td >
                    <div class="auto_file2">
                        <input type="file" title="file add" id="passportFile" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
                        <label>
                        <input type='text' class='input_text'  />
                        <span class='label_text'><a href='#'>Upload</a></span>
                        </label>
                    </div>
                </td>
            </tr>

            <tr>
                <th scope="row">Payment</th>
                <td >
                    <div class="auto_file2">
                        <input type="file" title="file add" id="paymentFile" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
                        <label>
                            <input type='text' class='input_text'  />
                            <span class='label_text'><a href='#'>Upload</a></span>
                        </label>
                        <span class='label_text'><a href='#' onclick='fn_removeFile("PAY")'>Remove</a></span>
                    </div>
                </td>
            </tr>
            <tr>
                <th scope="row">HP Application Form<span class="must">*</span></th>
                <td >
                    <div class="auto_file2">
                        <input type="file" title="file add" id="hpAppForm" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
                        <label>
                            <input type='text' class='input_text'  id="hpAppFormTxt"/>
                            <span class='label_text'><a href='#'>Upload</a></span>
                        </label>
					</div>
                </td>
            </tr>
            <tr>
                <th scope="row">Declaration letter/Others form</th>
                <td >
                    <div class="auto_file2">
                        <input type="file" title="file add" id="otherFile" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
                        <label>
                            <input type='text' class='input_text'  />
                            <span class='label_text'><a href='#'>Upload</a></span>
                            </label>
                          <span class='label_text'><a href='#' onclick='fn_removeFile("OTH")'>Remove</a></span>
                        </label>
                    </div>
                </td>
            </tr>
            <tr>
                <th scope="row">Declaration letter/Others form 2</th>
                <td >
                    <div class="auto_file2">
                        <input type="file" title="file add" id="otherFile2" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
                        <label>
                            <input type='text' class='input_text'  />
                            <span class='label_text'><a href='#'>Upload</a></span>
                            </label>
                            <span class='label_text'><a href='#' onclick='fn_removeFile("OTH2")'>Remove</a></span>
                        </label>
                    </div>
                </td>
            </tr>
            <tr>
                <th scope="row">Termination Agreement<span class="must join">*</span></th>
                <td >
                    <div class="auto_file2">
                        <input type="file" title="file add" id="terminateAgreement" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
                        <label>
                            <input type='text' class='input_text'  />
                            <span class='label_text'><a href='#'>Upload</a></span>
                            </label>
                            <span class='label_text'><a href='#' onclick='fn_removeFile("TAF")'>Remove</a></span>
                        </label>
                    </div>
                </td>
            </tr>

            <tr>
                <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG, PDF) less than 2 MB.
			    <br>
			    File rename wording no more than 30 alphabet (including spacing, symbol).</span></td>
            </tr>
            </tbody>
            </table>


            </form>

            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
                <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_close()">CANCEL</a></p></li>
            </ul>

            </article>

        </section><!-- tap_wrap end -->
    </div><!-- popup_wrap end -->
</form>