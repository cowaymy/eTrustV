<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

    /* 커스텀 스타일 정의 */
    .auto_file2 {
        width:100%!important;
    }
    .auto_file2 > label {
        width:100%!important;
    }
   .auto_file2 label input[type=text]{width:40%!important; float:left}

</style>
<script type="text/javaScript">
var optionState = {chooseMessage: " 1.States "};
var optionCity = {chooseMessage: "2. City"};
var optionPostCode = {chooseMessage: "3. Post Code"};
var optionArea = {chooseMessage: "4. Area"};
var myFileCaches = {};
var atchFileGrpId = '';
var atchFileId = '';
var issuedBankTxt;
var checkFileValid = true;
var isRejoinMem =  $("#isRejoinMem").val();

var myGridID_Doc;

function fn_memberSave(){


	 if($("#memberType").val() == "5" && $("#traineeType1").val() == "2" || isRejoinMem == true) { //if cody trainee only need attachment
			   var formData = new FormData();
			    $.each(myFileCaches, function(n, v) {
			        console.log("n : " + n + " v.file : " + v.file);
			        formData.append(n, v.file);
			    });

		        formData.append("memType", $("#memberType").val());
		        formData.append("traineeType", $("#traineeType1").val());

			        Common.ajaxFile("/organization/attachFileMemberUpload.do", formData, function(result) {
			            console.log(result);
			            atchFileGrpId = result.data.fileGroupKey;
			            atchFileId = result.data.atchFileId;
			            isAttach = 'Yes';

		                $("#atchFileGrpId").val(atchFileGrpId);
		                $("#atchFileId").val(atchFileId);

                        if( $("#userType").val() == "1") {
                            $('#memberType').attr("disabled", false);
                            $('#searchdepartment').attr("disabled", false);
                            $('#searchSubDept').attr("disabled", false);
                        }

                        $("#streetDtl1").val(memberAddForm.streetDtl.value);
                        $("#addrDtl1").val(memberAddForm.addrDtl.value);
                        $("#traineeType").val(($("#traineeType1").value));
                        $("#subDept").val(($("#searchSubDept").value));

                        var jsonObj =  GridCommon.getEditData(myGridID_Doc);

                        jsonObj.form = $("#memberAddForm").serializeJSON();

                        console.log("-------------------------" + JSON.stringify(jsonObj));
                        Common.ajax("POST", "/organization/memberSave",  jsonObj, function(result) {
                            console.log("message : " + result.message );

                            if(result.message == "Email has been used"){
                                Common.alert(result.message);
                            }else{
                                // Only applicable to HP Applicant
                                if($("#memberType").val() == "2803") {
                                    $("#aplcntNRIC").val($("#nric").val());
                                    $("#aplcntName").val($("#memberNm").val());
                                    $("#aplcntMobile").val($("#mobileNo").val());

                                    console.log("NRIC :: " + $("#aplcntNRIC").val());
                                    console.log("Name :: " + $("#aplcntName").val());
                                    console.log("Mobile :: " + $("#aplcntMobile").val());

                                    // Get ID and identification
                                    Common.ajax("GET", "/organization/getApplicantInfo", $("#applicantDtls").serialize(), function(result) {
                                        console.log("saving member details");
                                        console.log(result);

                                        var aplcntId = result.id;
                                        var idntfc = result.idntfc;

                                        // Construct Agreement URL via SMS
                                        /* VER NBL [S] var cnfmSms = " COWAY: COMPULSORY click " +
                                                             "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + idntfc + aplcntId +
                                                             " for confirmation of HP agreement. TQ!"; */
                                        var cnfmSms = " COWAY: HP Application successful. Click " +
                                                              "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + idntfc + aplcntId +
                                                              " to accept T&C." + "Password: " + "${pdfPwd}";
                                        /* VER NBL [E] */

                                        if($("#mobileNo").val() != "") {
                                            var rTelNo = $("#mobileNo").val();

                                            Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:rTelNo , msg :cnfmSms} , function(result) {
                                                console.log("sms.");
                                                console.log( result);
                                            });
                                        }

                                        if($("#email").val() != "") {
                                            var recipient = $("#email").val();

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
          });
	 }else{
		 //others than cody trainee no need attachment
		 if( $("#userType").val() == "1") {
             $('#memberType').attr("disabled", false);
             $('#searchdepartment').attr("disabled", false);
             $('#searchSubDept').attr("disabled", false);
         }

         $("#streetDtl1").val(memberAddForm.streetDtl.value);
         $("#addrDtl1").val(memberAddForm.addrDtl.value);
         $("#traineeType").val(($("#traineeType1").value));
         $("#subDept").val(($("#searchSubDept").value));

         var jsonObj =  GridCommon.getEditData(myGridID_Doc);

         jsonObj.form = $("#memberAddForm").serializeJSON();

         console.log("-------------------------" + JSON.stringify(jsonObj));
         Common.ajax("POST", "/organization/memberSave",  jsonObj, function(result) {
             console.log("message : " + result.message );

             if(result.message == "Email has been used"){
                 Common.alert(result.message);
             }else{
                 // Only applicable to HP Applicant
                 if($("#memberType").val() == "2803") {
                     $("#aplcntNRIC").val($("#nric").val());
                     $("#aplcntName").val($("#memberNm").val());
                     $("#aplcntMobile").val($("#mobileNo").val());

                     console.log("NRIC :: " + $("#aplcntNRIC").val());
                     console.log("Name :: " + $("#aplcntName").val());
                     console.log("Mobile :: " + $("#aplcntMobile").val());

                     // Get ID and identification
                     Common.ajax("GET", "/organization/getApplicantInfo", $("#applicantDtls").serialize(), function(result) {
                         console.log("saving member details");
                         console.log(result);

                         var aplcntId = result.id;
                         var idntfc = result.idntfc;

                         // Construct Agreement URL via SMS
                         /* VER NBL [S] var cnfmSms = " COWAY: COMPULSORY click " +
                                              "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + idntfc + aplcntId +
                                              " for confirmation of HP agreement. TQ!"; */
                         var cnfmSms = " COWAY: HP Application successful. Click " +
                                               "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + idntfc + aplcntId +
                                               " to accept T&C." + "Password: " + "${pdfPwd}";
                         /* VER NBL [E]*/


                         if($("#mobileNo").val() != "") {
                             var rTelNo = $("#mobileNo").val();

                             Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:rTelNo , msg :cnfmSms} , function(result) {
                                 console.log("sms.");
                                 console.log( result);
                             });
                         }

                         if($("#email").val() != "") {
                             var recipient = $("#email").val();

                             var url = "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + idntfc + aplcntId;

                             // Send Email file, recipient
                             Common.ajax("GET", "/organization/sendEmail.do", {url:url, recipient:recipient, password:'true'}, function(result) {
                                 console.log("email.");
                                 console.log(result);
                             })
                         }

                     });
                 /*}else if($("#memberType").val() == "5") {
                     if($("#email").val() != "") {
                         var recipient = $("#email").val();

                         var url = "http://etrust.my.coway.com/";

                         // Send Email file, recipient
                         Common.ajax("GET", "/organization/sendEmail.do", {url:url, recipient:recipient}, function(result) {
                             console.log("email.");
                             console.log(result);
                         })
                     }*/
                 }
                 Common.alert(result.message,fn_close);
             }
    });

	 }
}

function fn_close(){
    $("#popup_wrap").remove();
}
function fn_saveConfirm(){
    if(isRejoinMem == true){
   	   if($("#memberType").val() == "5" && $("#traineeType1").val() == "2") {
	   		 if(fn_validFile()) {
   			     if(fn_saveValidation()){
                        Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
                }
	        }
   	   }else{
	   		 if(fn_validTerminateFile()) {
	             if(fn_saveValidation()){
	                    Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
	            }
	        }
   	   }
     } else {

    	    if($("#memberType").val() == "5" && $("#traineeType1").val() == "2") {
    	        if(fn_validFile()) {
                      if(fn_saveValidation()){
                             Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
                     }
    	        }
    	    }else{

                 if(fn_saveValidation()){
                     if($("#memberType").val() == 2803){
                         Common.confirm($("#memberNm").val() + "</br>" +
                                                $("#nric").val() + "</br>" +
                                                issuedBankTxt + "</br>" +
                                                "A/C : " + $("#bankAccNo").val() + "</br></br>" +
                                                "Do you want to save with above information (for commission purpose)?", fn_memberSave);
                     } else {
                         Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
                     }
                 }
    	    }
     }
}
function fn_docSubmission(){
        Common.ajax("GET", "/organization/selectHpDocSubmission", { memType : $("#memberType").serialize() , trainType : $("#traineeType1").val()}, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID_Doc, result);
        AUIGrid.resize(myGridID_Doc,1000,400);
    });
}

function fn_departmentCode(value){
     if($("#memberType").val() != 2){
            $("#hideContent").hide();
        }else{
            $("#hideContent").show();
        }
     if($("#memberType").val() == 5){
          $("#trTrainee").show();
     }else{
        $("#trTrainee").hide();
     }

     $("#joinDate").val($.datepicker.formatDate('dd/mm/yy', new Date()));

     $("#joinDate").attr("readOnly", true);



     if($("#memberType").val() == 2803){

         var spouseCode = "${spouseInfoView[0].memCode}";
         var spouseName = "${spouseInfoView[0].name}";
         var spouseNric = "${spouseInfoView[0].nric}";
         var spouseDob = "${spouseInfoView[0].dob}";
         var spouseTel = "${spouseInfoView[0].telMobile}";

        /* $('#sponsorCd').val(spouseCode);
        $('#sponsorNm').val(spouseName);
        $('#sponsorNric').val(spouseNric);  */

        $("#branch").find('option').each(function() {
            $(this).remove();
        });
        $("#branch").append("<option value=''>Choose One</option>");

        $("#meetingPoint").attr("disabled", false);
        $("#branch").attr("disabled", true);
        $("#transportCd").attr("disabled", true);
        $("#applicationStatus").attr("disabled", true);
        $("#searchdepartment").attr("disabled", true);
        $("#searchSubDept").attr("disabled", true);

        /*
        $('#spouseCode').val(spouseCode);
        $('#spouseName').val(spouseName);
        $('#spouseNRIC').val(spouseNric);
        $('#spouseDOB').val(spouseDob);
        $('#spouseContat').val(spouseTel);

        $('#spouseCode', '#memberAddForm').attr("readonly", true );
        $('#spouseName', '#memberAddForm').attr("readonly",  true );
        $('#spouseNRIC', '#memberAddForm').attr("readonly", true );
        $('#spouseDOB', '#memberAddForm').attr("readonly", true );
        $('#spouseContat', '#memberAddForm').attr("readonly",  true );

        $('#spouseCode', '#memberAddForm').attr('class','w100p readonly ');
        $('#spouseName', '#memberAddForm').attr('class','w100p readonly ');
        $('#spouseNRIC', '#memberAddForm').attr('class','w100p readonly ');
        $('#spouseDOB', '#memberAddForm').attr('class','w100p readonly ');
        $('#spouseContat', '#memberAddForm').attr('class','w100p readonly ');
        */
     } else {
        $('#spouseCode').val('');
        $('#spouseName').val('');
        $('#spouseNric').val('');
        $('#spouseDob').val('');
        $('#spouseContat').val('');

        $('#spouseCode', '#memberAddForm').attr("readonly", false);
        $('#spouseName', '#memberAddForm').attr("readonly", false);
        $('#spouseNric', '#memberAddForm').attr("readonly", false);
        $('#spouseDob', '#memberAddForm').attr("readonly", false);
        $('#spouseContat', '#memberAddForm').attr("readonly", false);

        $('#spouseCode', '#memberAddForm').attr('class','w100p  ');
        $('#spouseName', '#memberAddForm').attr('class','w100p  ');
        $('#spouseNric', '#memberAddForm').attr('class','w100p  ');
        $('#spouseDob', '#memberAddForm').attr('class','w100p  ');
        $('#spouseContat', '#memberAddForm').attr('class','w100p  ');

        $("#meetingPoint").attr("disabled", true);
        $("#branch").attr("disabled", false);
        $("#transportCd").attr("disabled", false);
        $("#applicationStatus").attr("disabled", false);
        $("#searchdepartment").attr("disabled", false);
        $("#searchSubDept").attr("disabled", false);



     }


    var action = value;
    console.log("fn_departmentCode >> " + action)
    switch(action){
       case "1" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CRS%"
        };
           doGetCombo("/organization/selectDeptCodeHp", jsonObj , ''   , 'deptCd' , 'S', '');
           break;
       case "2" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CCS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;
       case "3" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CTS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           doGetComboSepa("/common/selectBranchCodeList.do",2 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;

       case "4" :
           var jsonObj = {
                memberLvl : 100,
                flag :  "-"
        };
           doGetComboSepa("/common/selectBranchCodeList.do",100 , '-',''   , 'branch' , 'S', '');
           break;

       case "5" :

           $("#branch").find('option').each(function() {
               $(this).remove();
           });
           $("#deptCd").find('option').each(function() {
               $(this).remove();
           });

           $("#traineeType1").change(function(){

               var traineeType =  $("#traineeType1").val();

               fn_docSubmission()
               console.log("fn_departmentCode traineeType>> " + traineeType)

               if( traineeType == '2'){
                    doGetComboSepa("/common/selectBranchCodeList.do",'4' , '-',''   , 'branch' , 'S', '');

                   $("#branch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%CCS%",
                               flag2 : "%CM%",
                               branchVal : $("#branch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
                   });

                   //Training Course ajax콜 위치 20-10-2021 - HLTANG - close for LMS project
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   /* var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

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

               }
               else if(traineeType == '3'){

                   $("#branch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%CTS%",
                               branchVal : $("#branch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
                   });

                   doGetComboSepa("/common/selectBranchCodeList.do",'5' , '-',''   , 'branch' , 'S', '');

                   //Training  ajax콜 위치 20-10-2021 - HLTANG - close for LMS project
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   /* var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

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
               }   else if(traineeType == '5758'){ // HOMECARE DELIVERY TECHNICIAN -- ADDED BY TOMMY

                   doGetComboSepa("/common/selectBranchCodeList.do",'5758' , '-',''   , 'branch' , 'S', '');
                   $("#branch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%DTS%",
                               branchVal : $("#branch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
                   });

                   //Training Course ajax콜 위치 20-10-2021 - HLTANG - close for LMS project
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   /* var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

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
               } else if( traineeType == '7'){ // HOMECARE -- ADDED BY TOMMY
                    doGetComboSepa("/common/selectBranchCodeList.do",'48' , '-',''   , 'branch' , 'S', '');

                   $("#branch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%CHT%",
                               branchVal : $("#branch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
                   });

                   //Training Course ajax콜 위치 20-10-2021 - HLTANG - close for LMS project
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   /* var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

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

               } else if( traineeType == '6672'){ // LT - ADDED BY KEYI
                    doGetComboSepa("/common/selectBranchCodeList.do",'6672' , '-',''   , 'branch' , 'S', '');

                   $("#branch").change(function(){
                       var jsonObj = {
                               memberLvl : 3,
                               flag :  "%DTS%",
                               branchVal : $("#branch").val()
                       };

                       doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
                   });

                   //Training Course ajax콜 위치 20-10-2021 - HLTANG - close for LMS project
                   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   /* var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

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

               }

           });

           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;

        case "2803" :

            doGetComboSepa("/common/selectBranchCodeList.do",45 , '-',''   , 'branch' , 'S', '');

            if ( $("#userType").val() == "1" ) {

                Common.ajax("GET", "/organization/selectDeptCodeHp", null, function(result) {

                    $("#deptCd").find('option').each(function() {
                        $(this).remove();
                    });

                    console.log("------selectDeptCodeHp-------------------" + JSON.stringify(result));
                    if (result!= null) {
                       $("#deptCd").append("<option value="+result[0].codeId+">"+result[0].codeId+"</option>");
                    }

                });


            } else {
               //doGetCombo('/organization/selectDepartmentCode', '', '','deptCd', '' , '');

                Common.ajax("GET", "/organization/selectDepartmentCode", null, function(result) {

                    $("#deptCd").find('option').each(function() {
                        $(this).remove();
                    });

                    console.log("------selectDepartmentCode-------------------" + JSON.stringify(result));
                    if (result!= null) {
                       $("#deptCd").append("<option value="+result[0].codeId+">"+result[0].codeId+"</option>");
                        for(var z=0; z< result.length;z++) {
                            $("#deptCd").append("<option value="+result[z].codeId+">"+result[z].codeName+"</option>");
                       }
                    }

                });
            }

            /*
            $("#branch").find('option').each(function() {
                    $(this).remove();
                });

                //branch combo 다시 그림.
                //doGetCombo('/organization/selectBranchCode', '', '','branch', '' , '');

                Common.ajax("GET", "/organization/selectBranchCode", null, function(result) {

                    console.log("-----selectBranchCode--------------------" +result.length + JSON.stringify(result));
                    if (result!= null) {
                        for(var z=0; z< result.length;z++) {
                            $("#branch").append("<option value="+result[z].codeId+">"+result[z].codeName+"</option>");
                       }
                    }

                });
               */
        break;

    /*     case "2803" :   // this is temp code  that   add by hgham

                 $("#deptCd option").remove();
                 $("#deptCd option").remove();
                 $("#deptCd").append("<option value='CRS3001'>CRS3001</option>");
            break; */
    }


}
$(document).ready(function() {
console.log("ready");
    //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','country', 'S', '');

    //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','national', 'S', '');

    //doGetCombo('/sales/customer/getNationList', '338' , '' ,'country' , 'S', '' );
    //doGetCombo('/sales/customer/getNationList', '338' , '' ,'national' , 'S' , '');

    //doGetCombo('/common/selectCodeList.do', '2', '','cmbRace', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '4', '','marrital', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '3', '','language', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '5', '','educationLvl', 'S' , '');
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'issuedBank', 'S', '');
    //doGetCombo('/organization/selectCourse.do', '', '','course', 'S' , '');
    doGetCombo('/organization/selectHpMeetPoint.do', '', '', 'meetingPoint', 'S', '');
    doGetCombo('/common/selectCodeList.do', '17', '','_cmbInitials_', 'S' , '');                             // Initials Combo Box

    //$("#issuedBank option[value='MBF']").remove();
    //$("#issuedBank option[value='OTH']").remove();

    setInputFile2();

    $("#deptCd").change(function (){
        //modify hgham 2017-12-25  주석 처리
        //doGetComboSepa("/common/selectBranchCodeList.do",$("#deptCd").val() , '-',''   , 'branch' , 'S', '');
    });
    createAUIGridDoc();
    fn_docSubmission();
    fn_departmentCode('2');  //modify  hgham 25-12 -2017    as is code  fn_departmentCode();
    fn_changeDetails();

    $("#state").change(function (){
        var state = $("#state").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' ,state ,'area', 'S', '');
    });
    $("#area").change(function (){
        var area = $("#area").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' ,area ,'','postCode', 'S', '');
    });

    // Member Type 바꾸면 입력한 NRIC 비우기, doc 새로불러오기
    $("#memberType").change(function (){
        $("#nric").val('');
          fn_docSubmission();
          if ($("#memberType").val() == "4") {
              $("#memberCd").attr("disabled", false);
          } else {
              $("#memberCd").attr("disabled", true);
          }

    });

    $("#memberType").click(function (){

    console.log("================" +  $("#memberType").val());
        var memberType = $("#memberType").val();

        $('span', '#emailLbl').empty().remove();
        $('span', '#mobileNoLbl').empty().remove();
        $('span', '#meetingPointLbl').empty().remove();
        //$('span', '#courseLbl').empty().remove(); //20-10-2021 - HLTANG - close for LMS project

        if ( memberType ==  "2803") {
            //$('#grid_wrap_doc').attr("hidden", true);

            //$('#course').attr("disabled", true); //20-10-2021 - HLTANG - close for LMS project
            $('#email').prop('required', true);
            $('#mobileNo').prop('required', true);
            $('#emailLbl').append("<span class='must'>*</span>");
            $('#mobileNoLbl').append("<span class='must'>*</span>");
            $('#meetingPointLbl').append("<span class='must'>*</span>");

            $("#apprStusText").attr("disabled", true);
            $("#apprStusCombo").attr("disabled", true);
            $("#religion").attr("disabled", true);
            //$("#course").attr("disabled", true); //20-10-2021 - HLTANG - close for LMS project
            $("#totalVacation").attr("disabled", true);
            $("#applicationStatus").attr("disabled", true);
            $("#remainVacation").attr("disabled", true);
            $("#searchdepartment").attr("disabled", true);
            $("#searchSubDept").attr("disabled", true);
            $("#educationLvl").attr("disabled", true);
            $("#language").attr("disabled", true);
            $("#trNo").attr("disabled", true);
            doGetCombo('/organization/selectAccBank.do', '', '', 'issuedBank', 'S', '');
        } else if(memberType ==  "5") {
            $('#email').prop('required', true); // LMS - Added email as mandatory for Trainee & HP Applicant. Hui Ding, 2021-10-08
            $('#emailLbl').append("<span class='must'>*</span>");
            $('#mobileNo').prop('required', true);
            $('#mobileNoLbl').append("<span class='must'>*</span>");
        } else {
            //$('#course').removeAttr('disabled'); //20-10-2021 - HLTANG - close for LMS project
        }
        fn_departmentCode(memberType);
     });

    $("#traineeType1").click(function(){   // CHECK Trainee Type = Cody then Disable Main & Sub Department selection -- Added by Tommy
        var traineeType = $("#traineeType1").val();

        //$('span', '#courseLbl').empty().remove(); //20-10-2021 - HLTANG - close for LMS project

        if(traineeType == 2){
            //$('#courseLbl').append("<span class='must'>*</span>"); //20-10-2021 - HLTANG - close for LMS project
            $("#searchdepartment").attr("disabled", true);
            $("#searchSubDept").attr("disabled", true);
            $("#joinDate").val($.datepicker.formatDate('dd/mm/yy', new Date()));
            $("#joinDate").attr("readOnly", true);

        }else if(traineeType == 7 ||  traineeType == 5758){
            //$('#courseLbl').append("<span class='must'>*</span>"); //20-10-2021 - HLTANG - close for LMS project
            $("#searchdepartment").attr("disabled", true);
            $("#searchSubDept").attr("disabled", true);
            $("#transportCd option[value=253]").attr('selected', 'selected');
            $("#joinDate").attr("readOnly", false);

        }else{
            //$('#courseLbl').append("<span class='must'>*</span>"); //20-10-2021 - HLTANG - close for LMS project
            $("#searchdepartment").attr("disabled", false);
            $("#searchSubDept").attr("disabled", false);
            $("#joinDate").val($.datepicker.formatDate('dd/mm/yy', new Date()));
            $("#joinDate").attr("readOnly", true);
        }

        /* if(traineeType == "" || traineeType == null) { //20-10-2021 - HLTANG - close for LMS project
            $('span', '#courseLbl').empty().remove();
        } */

    });

     $("#searchdepartment").change(function(){

        doGetCombo('/organization/selectSubDept.do',  $("#searchdepartment").val(), '','searchSubDept', 'S' ,  '');

     });

    //var nationalStatusCd = "1";
    $("#national option[value=1]").attr('selected', 'selected');

    //var cmbRacelStatusCd = "10";
    /* $("#cmbRace option[value=10]").attr('selected', 'selected'); */

     if( $("#userType").val() == "1") {
        $("#memberType option[value=2803]").attr('selected', 'selected');
        $('#memberType').attr("disabled", true);

        $('#grid_wrap_doc').attr("hidden", true);
     }

     $('#memberType').trigger('click');

     $('#nric').blur(function() {
         if ($('#nric').val().length == 12) {
             checkNRIC();
             /* if ($('#nric').val().length == 12) {
                 autofilledbyNRIC();
             } */
         }
     });

     $('#email', '#memberAddForm').blur(function() {
    	 checkEmail();
     });

     $('#sponsorCd').blur(function() {
         if ($('#sponsorCd').val().length > 0) {
             fn_sponsorCd();
         }
     });

     if ($("#memberType").val() == "4") {
         $("#memberCd").attr("disabled", false);
     } else {
         $("#memberCd").attr("disabled", true);
     }

     $('#bankAccNo').blur(function() {
         if($("#memberType").val() != "5") {
            console.log("not trainee with -/0")
            fmtNumber("#bankAccNo"); // 2018-06-21 - LaiKW - Added removal of special characters from bank account number
            checkBankAccNo();
         } else if($("#memberType").val() == "5") {
            console.log("5");
            console.log("bankaccno :: " + $("#bankAccNo").val());
            if($("#bankAccNo").val() != "-"){
                if(isNaN($("#bankAccNo").val())){  // validation the value of bank account number is numeric
                    Common.alert("Bank account number must be numeric.");
                    $("#bankAccNo").val("");
                    return false;
                }else{
                     checkBankAccNo();
                }
            }
         }
     });

     $("#mobileNo").blur(function() {
        fmtNumber("#mobileNo"); // 2018-07-06 - LaiKW - Removal of special characters from mobile no
     });

     if( $("#userType").val() == "2" || $("#userType").val() == "7") {
         $("#traineeType1").val($("#userType").val());
         $("#traineeType1").trigger("change");
         $("#traineeType1").trigger("click");
         fn_changeDetails();
     }
});

function setInputFile2(){//인풋파일 세팅하기
    //$(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

// 2018-06-20 - LaiKW - Removal of MBF Bank and Others from Issued Bank drop down box
function onclickIssuedBank() {
    $("#issuedBank > option[value='22']").remove();
    $("#issuedBank > option[value='24']").remove();
    $("#issuedBank > option[value='42']").remove();
    $("#issuedBank > option[value='43']").remove();
}

function onChangeIssuedBank(sel) {
    issuedBankTxt = sel.options[sel.selectedIndex].text;
    console.log("issuedBankTxt :: " + issuedBankTxt);
}

function createAUIGridDoc() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
        {
            dataField : "codeId",
            headerText : "DocumentId",
            editable : false,
            width : 0
        }
       ,{
        dataField : "codeName",
        headerText : "Document",
        editable : false,
        width : 220
    }, {
        dataField : "submission",
        headerText : "Submission",
        editable : false,
        width : 130,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0",
         // 체크박스 Visible 함수
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                if(item.docQty == 0){
                    AUIGrid.updateRow(myGridID_Doc, {
                         "docQty" : "1"

                        }, rowIndex);
                }
                return true;
            }

        }
    }, {
        dataField : "docQty",
        headerText : "Qty",
        dataType : "numeric",
        editRenderer : {
            type : "NumberStepRenderer",
            min : 0,
            max : 10,
            step : 1,
            textEditable : true
        },
        width : 130,
        checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
            if(item.docQty != 0){
                AUIGrid.updateRow(myGridID_Doc, {
                      "submission" : "1"

                    }, rowIndex);
            }else{
                AUIGrid.updateRow(myGridID_Doc, {
                    "submission" : "0"
                  }, rowIndex);
            }
            return true;
        }

    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : false,

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_Doc = AUIGrid.create("#grid_wrap_doc", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

};

//Validation Check
function fn_saveValidation(){

var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if($("#memberNm").val() == ''){
        Common.alert("Please key  in Member Name");
        return false;
    }

    if($("#joinDate").val() == ''){
        Common.alert("Please select Joined Date");
        return false;
    }

    if($("#sponsorCd").val() == ''){
        Common.alert("Please select 'Sponsor's Code'");
        return false;
    }

    if($('input[name=gender]:checked', '#memberAddForm').val() == null){
          Common.alert("Please select Gender");
            return false;
    }

/*  if($("#memberType").val() == 5){
        if($("#traineeType").val() == 0){
              common.alert("Please select Trainee Type");
              return false;
        }
    }*/
    /* if(!$("#gender").is(":radio")){

    } */

    if($("#Birth").val() == ''){
        Common.alert("Please select Date of Birth");
        return false;
    }

    if($("#cmbRace").val() == ''){
        Common.alert("Please select race");
        return false;
    }

    if($("#national").val() == ''){
        Common.alert("Please select Nationality");
        return false;
    }

    if($("#nric").val() == ''){
        Common.alert("Please key  in NRIC");
        return false;
    }

    if (  $("#nric").val().length != 12 ) {
        Common.alert("NRIC should be in 12 digit");
        return false;
    }

    if($("#marrital").val() == ''){
        Common.alert("Please select marrital");
        return false;
    }

    if($("#marrital").val() == '26'){
        if($("#spouseName").val() == '') {
            Common.alert("Please enter spouse name");
            return false;
        }
        if($("#spouseNric").val() == '') {
            Common.alert("Please enter spouse NRIC/Passport No");
            return false;
        }
        if($("#spouseOcc").val() == '') {
            Common.alert("Please enter spouse occupation");
            return false;
        }
        if($("#spouseDob").val() == '') {
            Common.alert("Please enter spouse date of birth");
            return false;
        }
        if($("#spouseContat").val() == '') {
            Common.alert("Please enter spouse contact");
            return false;
        }
    }

    if($("#issuedBank").val() == ''){
        Common.alert("Please select the issued bank");
        return false;
    }

    if($("#bankAccNo").val() == ''){
        Common.alert("Please key in the bank account no");
        return false;
    }
  //Wawa 5/10/23 add branch validation
    if($("#branch").val() == ''){
        Common.alert("Please select the branch");
        return false;
    }
    //type 별로 다르게 해야됨
    if($("#deptCd").val() == ''){
        Common.alert("Please select the department code");
        return false;
    }

    if($("#areaId").val() == ''){
        Common.alert("Please key in the address.");
        return false;
    }

    if($("#addrDtl").val() == ''){
        Common.alert("Please key in the address detail.");
        return false;
    }

    if($("#streetDtl").val() == ''){
        Common.alert("Please key in the street detail.");
        return false;
    }

    if($("#mArea").val() == ''){
            Common.alert("Please key in the area.");
            return false;
    }

    if($("#mCity").val() == ''){
        Common.alert("Please key in the city.");
        return false;
    }

    if($("#mPostCd").val() == ''){
        Common.alert("Please key in the postcode.");
        return false;
    }

    if($("#mState").val() == ''){
        Common.alert("Please key in the state.");
        return false;
    }

    if($("#memberType").val() == "2803" || $("#memberType").val() == "5") {
        if($("#mobileNo").val() == '') {
            Common.alert("Please key in Mobile No.");
            return false;
        }else{
            if($("#mobileNo").val().length < 10 || $("#mobileNo").val().length > 12){
                Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLengthMember" />');
                return false;
            }

            if($("#mobileNo").val().substring(0,3) == "015"){
                Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                return false;
            }else if($("#mobileNo").val().substring(0,2) != "01"){
                Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                return false;
            }
        }


        if($("#memberType").val() == "2803"){
             if($("#email").val() == '') {
                 Common.alert("Please key in Email Address");
                 return false;
             }
             if($("#memberType").val() == "2803") {
                 // 2018-07-26 - LaiKW - Added Meeting Point and Branch
                 if($('#meetingPoint').val() == '') {
                     Common.alert("Please select Business Area");
                     return false;
                 }
             }
        }

        // LMS - Change to check email as mandatory for HP Applicant, trainee. Hui Ding, 2021-10-08
        if($("#memberType").val() =='5'){
            if($("#traineeType1").val() ==''){
                   Common.alert("Please key in Trainee type");
                   return false;
            }

            if($("#email").val() == '') {
                Common.alert("Please key in Email Address");
                return false;
            }

          //region Check Email
            if ((jQuery.trim($("#email").val())).length>0) //20-10-2021 - HLTANG - valid email validation
            {
                if (!regEmail.test($("#email").val()))
                {
                    Common.alert("Invalid contact person email");
                    return false;
                }
            }
            //endregion

            /* if($("#course").val() == ''){ //20-10-2021 - HLTANG - close for LMS project
                Common.alert("Please key  in Training Course");
                return false;
            } */
        }
    }

/*     //@AMEER add INCOME TAX
    if($("#incomeTaxNo").val().length > 0 &&  $("#incomeTaxNo").val().length < 10){
         Common.alert("Invalid Income Tax Length");
         return false;
   } */
    var regIncTax = /^[a-zA-Z0-9]*$/;
    if(!regIncTax.test($("#incomeTaxNo").val())){
        Common.alert("Invalid Income Tax Format");
        return false;
    }

    if($("#memberType").val() == "5" && $("#traineeType1").val() == "2") {

    	if($("#uniformSize").val() == ''){
            Common.alert("Please select Uniform Size");
            return false;
        }

        if($('input[name=gender]:checked', '#memberAddForm').val() ==  "F" && $("#cmbRace").val() == "10" ) {

        	 if($('input[name=muslimahScarft]:checked', '#memberAddForm').val() == null){
                Common.alert("Please select Scarft");
                return false;
            }

            if($("#innerType").val() == ''){
                Common.alert("Please select Inner Type");
                return false;
            }
        }

        if($("#cmbInitials").val() == ''){
            Common.alert("Please select  Emergency Contact Initial");
            return false;
        }

        if($("#emergencyCntcNm").val() == ''){
            Common.alert("Please key  in Emergency Contact Name");
            return false;
        }

        if($("#emergencyCntcRelationship").val() == ''){
            Common.alert("Please key  in Emergency Contact Relationship");
            return false;
        }

   	  var regIncEmerngcyCntcNo = /^[0-9]*$/;

   	  if($("#emergencyCntcNo").val() == '') {
             Common.alert("Please key in Emergency Contact No.");
             return false;
         }else{
       	  if(!regIncEmerngcyCntcNo.test($("#emergencyCntcNo").val())){
       	        Common.alert("Invalid Emergency Contact No Number");
       	        return false;
       	    }
             if($("#emergencyCntcNo").val().length < 10 || $("#emergencyCntcNo").val().length > 12){
                 Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLengthMember" />');
                 return false;
             }
             if($("#emergencyCntcNo").val().substring(0,3) == "015"){
                 Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                 return false;
             }else if($("#emergencyCntcNo").val().substring(0,2) != "01"){
                 Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                 return false;
             }
         }
    }

    if($("#salOrgRejoin").val() != "" && $("#salOrgRejoin").val() != null){
    	if($("#salOrgRejoin").val() != $("#traineeType1").val()){
    		  Common.alert("Please select the correct organization that is approved to rejoin.");
    	        return false;
    	}
    }

    return true;
}

function fn_addrSearch(){
    if($("#searchSt").val() == ''){
        Common.alert("Please search.");
        return false;
    }
    Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#memberAddForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
}
function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){

    if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){

        $("#mArea").attr({"disabled" : false  , "class" : "w100p"});
        $("#mCity").attr({"disabled" : false  , "class" : "w100p"});
        $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
        $("#mState").attr({"disabled" : false  , "class" : "w100p"});

        //Call Ajax

        CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , mstate, optionState);

        var cityJson = {state : mstate}; //Condition
        CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, mcity , optionCity);

        var postCodeJson = {state : mstate , city : mcity}; //Condition
        CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, mpostcode , optionCity);

        var areaJson = {groupCode : mpostcode};
        var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
        CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, marea , optionArea);

        $("#areaId").val(areaid);
        $("#_searchDiv").remove();
    }else{
        Common.alert("Please check your address.");
    }
}



function fn_sponsorPop(){
    Common.popupDiv("/organization/sponsorPop.do" , $('#memberAddForm').serializeJSON(), null , true,  '_searchSponDiv'); //searchSt
}


function fn_addSponsor(msponsorCd, msponsorNm, msponsorNric) {


    $("#sponsorCd").val(msponsorCd);
    $("#sponsorNm").val(msponsorNm);
    $("#sponsorNric").val(msponsorNric);

    $("#_searchSponDiv").remove();

}





//Get Area Id
function fn_getAreaId(){

    var statValue = $("#mState").val();
    var cityValue = $("#mCity").val();
    var postCodeValue = $("#mPostCd").val();
    var areaValue = $("#mArea").val();



    if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){

        var jsonObj = { statValue : statValue ,
                              cityValue : cityValue,
                              postCodeValue : postCodeValue,
                              areaValue : areaValue
                            };
        Common.ajax("GET", "/sales/customer/getAreaId.do", jsonObj, function(result) {

             $("#areaId").val(result.areaId);

        });

    }

}

function fn_selectCity(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){

         $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
         $('#mPostCd').val('');
         $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

         $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
         $('#mArea').val('');
         $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }else{

        $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});

        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        //Call ajax
        var postCodeJson = {state : $("#mState").val() , city : tempVal}; //Condition
        CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
    }

}

function fn_selectPostCode(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){

        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }else{

        $("#mArea").attr({"disabled" : false  , "class" : "w100p"});

        //Call ajax
        var areaJson = {state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
        CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
    }

}

function fn_selectState(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){
        //전체 초기화
        fn_initAddress();

    }else{

        $("#mCity").attr({"disabled" : false  , "class" : "w100p"});

        $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
        $('#mPostCd').val('');
        $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        //Call ajax
        var cityJson = {state : tempVal}; //Condition
        CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
    }

}

function fn_sponsorCheck(){
    if(event.keyCode == 13) {
        fn_sponsorCd();
    }
}

function fn_sponsorCd(){
    Common.ajax("GET", "/organization/checkSponsor.do", $("#memberAddForm").serializeJSON(), function(result) {
        // add jgkim
        console.log("checkSponsor.do Action");
        console.log(result);
        if (result.message != "ok") {
            Common.alert(result.message);
        } else {
            // add jgkim
            $("#sponsorNm").val(result.data.name);
            $("#sponsorNric").val(result.data.nric);
        }
    });
}

function checkNRICEnter(){
    if(event.keyCode == 13) {
        checkNRIC();
    }
}

function checkEmailOnEnter() {
    if(event.keyCode == 13) {
        checkEmail();
    }
}

function checkEmail() {
    var jsonObj = {
            "email" : $('#email', '#memberAddForm').val()
        };

    Common.ajax("GET", "/organization/checkEmail.do", jsonObj, function(result) {
        console.log("data : " + result);
        if (result.message != "pass") {
            Common.alert(result.message);
            $('#email', '#memberAddForm').val('');
            returnValue = false;
            return false;
        } else {
        	 $("#email").val($('#email', '#memberAddForm').val());
             returnValue = true;
             return true;
        }
  });
}


function fn_requiredfield(){
	if(isRejoinMem == true){
		$(".commonRequired").hide();
	    $(".join").show();
	    if($("#memberType").val() == "5" && $("#traineeType1").val() == "2") {
	    	 $(".commonRequired").show();
	    }
	}else{
		$(".commonRequired").show();
	    $(".join").hide();
	}
}

function checkNRIC(){
    var returnValue;
    var jsonObj = { "nric" : $("#nric").val() };

    isRejoinMem = false;
    $("#isRejoinMem").val(false);
    $("#salOrgRejoin").val('');
    $("#traineeType1").val('');
    $("#attachmentTab").hide();
    myFileCaches = {};
    fn_requiredfield();
    fn_changeDetails();

    if ($("#memberType").val() == '2803' || $("#memberType").val() == '4' || $("#memberType").val() == '5' || $("#memberType").val() == '7' || $("#memberType").val() == '5758' ) {
                    Common.ajax("GET", "/organization/memberRejoinChecking.do", jsonObj, function(result) {
                         //Qualified rejoin member
                        if (result.message == "pass - rejoin") {
                            if(result.data.salOrgRejoin != "1"){
                                isRejoinMem = true;
                                $("#isRejoinMem").val(true);
                                $("#memId").val(result.data.memId);
                                $("#salOrgRejoin").val(result.data.salOrgRejoin);
                                $("#attachmentTab").show();
                                fn_requiredfield();

                                Common.ajax("GET", "/organization/checkNRIC3.do", jsonObj, function(result) {
                                    console.log("data : " + result);
                                    if (result.message != "pass") {
                                        Common.alert(result.message);
                                        $("#nric").val('');
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
                            	  Common.alert("This applicant approved to rejoin as HP.");
                            }

                            // new member or member is not in ORG0001D or not apply member rejoin in member eligibility
                        } else if (result.message == "pass"){
                        	Common.ajax("GET", "/organization/checkNRIC2.do", jsonObj, function(result) {
                                console.log("data : " + result);
                                if (result.message != "pass") {
	                                 Common.alert(result.message);
	                                 $("#nric").val('');
	                                 returnValue = false;
	                                 return false;

                                } else {    // 조건1 통과 -> 조건2 수행
	                                 Common.ajax("GET", "/organization/checkNRIC1.do", jsonObj, function(result) {
	                                        console.log("data : " + result);
	                                        if (result.message != "pass") {
	                                            Common.alert(result.message);
	                                            $("#nric").val('');
	                                            returnValue = false;
	                                            return false;
	                                        } else {    // 조건2 통과 -> 조건3 수행

                                        	   Common.ajax("GET", "/organization/checkNRIC3.do", jsonObj, function(result) {
	                                                console.log("data : " + result);
	                                                if (result.message != "pass") {
	                                                    Common.alert(result.message);
	                                                    $("#nric").val('');
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
                            $("#nric").val('');
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
        var nric = $("#nric").val().replace('-', '');
        var autoGender = nric.substr(11,1);
        //var autoDOB = nric.substr(0,6);
        var autoDOB_year = nric.substr(0,2);
        var autoDOB_month = nric.substr(2,2);
        var autoDOB_date = nric.substr(4,2);

        if (parseInt(autoGender)%2 == 0) {
            $("input:radio[name='gender']:radio[value='F']").prop("checked", true);
            $('.chkScarft').show();
            $('#muslimahScarftLbl').show();
            $('#innerType').show();
            $('#innerTypeLbl').show();
        } else {
            $("input:radio[name='gender']:radio[value='M']").prop("checked", true);
             $('.chkScarft').hide();
            $('#muslimahScarftLbl').hide();
            $('#innerType').hide();
            $('#innerTypeLbl').hide();
        }

        if (parseInt(autoDOB_year) < 20) {
            $("#Birth").val(autoDOB_date+"/"+autoDOB_month+"/"+"20"+autoDOB_year);
        } else {
            $("#Birth").val(autoDOB_date+"/"+autoDOB_month+"/"+"19"+autoDOB_year);
        }
    //}

}

function fn_onchangeMarrital() {
    if($("#marrital").val() != "26") {
        $("#spouseNameLbl").find("span").remove();
        $("#spouseNricLbl").find("span").remove();
        $("#spouseOccLbl").find("span").remove();
        $("#spouseDobLbl").find("span").remove();
        $("#spouseContatLbl").find("span").remove();
    }

    if($("#marrital").val() == "26") {
        $("#spouseNameLbl").append("<span class='must'>*</span>");
        $("#spouseNricLbl").append("<span class='must'>*</span>");
        $("#spouseOccLbl").append("<span class='must'>*</span>");
        $("#spouseDobLbl").append("<span class='must'>*</span>");
        $("#spouseContatLbl").append("<span class='must'>*</span>");
    }
}

function fn_checkMobileNo() {
    if(event.keyCode == 13) {
        fmtNumber("#mobileNo");
    }
}

function fn_checkEmergencyCntcNo() {
    if(event.keyCode == 13) {
        fmtNumber("#emergencyCntcNo");
    }
}

function fmtNumber(field) {
    var fld = $(field).val();
    fld = fld.replace(/[^0-9]/g,"");

    $(field).val(fld);
}

function checkBankAccNoEnter() {
    if(event.keyCode == 13) {
        if($("#memberType").val() != "5") {
            console.log("not trainee with -/0")
            fmtNumber("#bankAccNo"); // 2018-06-21 - LaiKW - Added removal of special characters from bank account number
            checkBankAccNo();
         } else if($("#memberType").val() == "5") {
             console.log("bankaccno :: " + $("#bankAccNo").val());
             if($("#bankAccNo").val() != "-"){
                 if(isNaN($("#bankAccNo").val())){  // validation the value of bank account number is numeric
                     Common.alert("Bank account number must be numeric.");
                     $("#bankAccNo").val("");
                     return false;
                 }else{
                      checkBankAccNo();
                 }
             }
         }
    }
}

function checkBankAccNo() {
    //var jsonObj = { "bank" : $("#issuedBank").val(), "bankAccNo" : $("#bankAccNo").val() };
    var jsonObj = {
        "bankId" : $("#issuedBank").val(),
        "bankAccNo" : $("#bankAccNo").val()
    };

    if($("#memberType").val() == "2803") {
        Common.ajax("GET", "/organization/checkAccLen", jsonObj, function(resultM) {
            console.log(resultM);

            if(resultM.message == "F") {
                Common.alert("Invalid Account Length!");
                $("#bankAccNo").val("");
                return false;
            } else if(resultM.message == "S") {
                Common.ajax("GET", "/organization/checkBankAcc", jsonObj, function(result) {
                    console.log(result);
                    if(result.cnt1 == "0" && result.cnt2 == "0") {
                        return true;
                    } else {
                		   Common.alert("Bank account number has been registered.");
                           //$("#issuedBank").val("");
                           $("#bankAccNo").val("");
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
                      $("#bankAccNo").val("");
                      return false;
                }
            });
    }
}

function fn_clear() {
    $('#uniformSize').hide();
    $('#uniformSizeLbl').hide();
    $('.chkScarft').hide();
    $('#muslimahScarftLbl').hide();
    $('#innerType').hide();
    $('#innerTypeLbl').hide();
    $('#emergencyTabHeader').hide();
    $('#emergencyTabDetails').hide();
    document.getElementById("memberAddForm").reset();
}

function fn_changeDetails(){

	 if($("#memberType").val() == "5") {
		if($("#traineeType1").val() == "2" || $("#traineeType1").val() == "7") {

			if ( $("#nric").val() != "" && $("#traineeType1").val() != ""){
			    var data = {
			    		nric : $("#nric").val()
			    };

			   Common.ajax("GET", "/organization/getOwnPurcOtstndInfo.do", data, function(result) {
			       if(result > 499.99){
			    	   Common.alert("<span style='color:red;font-size:18px'>Alert !</span> <br> High own pruchase outstanding");
			    	   if(result > 1999.99){
			    		   fn_clear();
			    		   return;
			    	   }
			       }

			   });
		   }
		}
	 }
    var uniformSizeId;
    var muslimahScarftId;
    var innerTypeId;

    if($("#memberType").val() == "5" && $("#traineeType1").val() == "2") {

    	 if($('input[name=gender]:checked', '#memberAddForm').val() ==  "F" ) {
    		 if($("#cmbRace").val() == "10"){
    		        innerTypeId = 524 ;
    		        uniformSizeId = 522 ;
    		 }
    		 uniformSizeId = 522 ;

    	 }else{
    		 uniformSizeId = 523 ;
    	 }

    }

    CommonCombo.make("uniformSize", "/common/selectUniformSizeList.do", {groupCode : uniformSizeId}, "", {
        id: "codeId",
        name: "codeName",
        type:"S"
    });

    CommonCombo.make("innerType", "/common/selectInnerTypeList.do", {groupCode : innerTypeId}, "", {
        id: "codeId",
        name: "codeName",
        type:"S"
    });

     if($("#memberType").val() == "5" && $("#traineeType1").val() == "2") {
	    	$('#uniformSize').show();
	    	$('#uniformSizeLbl').show();
	    	$('#emergencyTabHeader').show();
	    	$('#emergencyTabDetails').show();
	    	$("#attachmentTab").show();
	    	$('.chkScarft').show();
            $('#muslimahScarftLbl').hide();
            $('#innerType').hide();
            $('#innerTypeLbl').hide();
            fn_requiredfield();

        if($('input[name=gender]:checked', '#memberAddForm').val() ==  "F" && $("#cmbRace").val() == "10" ) {
	        $('.chkScarft').show();
	        $('#muslimahScarftLbl').show();
	        $('#innerType').show();
	        $('#innerTypeLbl').show();
            }else
                {
	            	$('#innerType').hide();
	                $('#innerTypeLbl').hide();
	                $('.chkScarft').hide();
	                $('#muslimahScarftLbl').hide();
            	}
        }else
            {
	            if(isRejoinMem == true){
	                $("#attachmentTab").show();
	                fn_requiredfield();
		         } else {
		                $("#attachmentTab").hide();
		                myFileCaches = {};
		         }

	        	$('#uniformSize').hide();
	            $('#uniformSizeLbl').hide();
	            $('.chkScarft').hide();
	            $('#muslimahScarftLbl').hide();
	            $('#innerType').hide();
	            $('#innerTypeLbl').hide();
	            $('#emergencyTabHeader').hide();
	            $('#emergencyTabDetails').hide();
            }
}

$(function(){
    $('#codyAppFile').change(function(evt) {

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
        if(fileType[1] != 'pdf'){
            msg += "*Only allow attachment format (PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[1].file['checkFileValid'] = false;
            delete myFileCaches[1];
            $('#codyAppFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[1].file['checkFileValid'] = true;
        }
    });

    $('#nricCopyFile').change(function(evt) {

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
            msg += "*Only allow attachment format (JPG, PNG, JPEG,PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[2].file['checkFileValid'] = false;
            delete myFileCaches[2];
            $('#nricCopyFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[2].file['checkFileValid'] = true;
        }

    });
    $('#driveCopyFile').change(function(evt) {

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
            msg += "*Only allow attachment format (JPG, PNG, JPEG,PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[3].file['checkFileValid'] = false;
            delete myFileCaches[3];
            $('#driveCopyFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[3].file['checkFileValid'] = true;
        }

    });
    $('#bankStateCopyFile').change(function(evt) {

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
            msg += "*Only allow attachment format (JPG, PNG, JPEG,PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[4].file['checkFileValid'] = false;
            delete myFileCaches[4];
            $('#bankStateCopyFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[4].file['checkFileValid'] = true;
        }
    });
    $('#vaccDigCertFile').change(function(evt) {

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
        if(fileType[1] != 'pdf'){
            msg += "*Only allow attachment format (PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[5].file['checkFileValid'] = false;
            delete myFileCaches[5];
            $('#vaccDigCertFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[5].file['checkFileValid'] = true;
        }
    });
    $('#fileName').change(function(evt) {

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
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg'){
            msg += "*Only allow attachment format (JPG, JPEG).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[6].file['checkFileValid'] = false;
            delete myFileCaches[6];
            $('#fileName').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[6].file['checkFileValid'] = true;
        }
    });
    $('#codyPaCopyFile').change(function(evt) {
    	var msg = '';
        var file = evt.target.files[0];
        if(file == null && myFileCaches[7] != null){
        	msg += "*Not Allowed to Upload.<br>";
        }else if(file != null){
        	myFileCaches[7] = {file:file};
        }

        if(msg != null && msg != ''){
        	myFileCaches[7].file['checkFileValid'] = false;
            delete myFileCaches[7];
            $('#codyPaCopyFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[7].file['checkFileValid'] = true;
        }

    });
    $('#compConsCodyFile').change(function(evt) {
    	var msg = '';
        var file = evt.target.files[0];
        if(file == null && myFileCaches[8] != null){
            msg += "*Not Allowed to Upload.<br>";
        }else if(file != null){
            myFileCaches[8] = {file:file};
            msg += "*Not Allowed to Upload.<br>";
        }

        if(msg != null && msg != ''){
        	myFileCaches[8].file['checkFileValid'] = false;
            delete myFileCaches[8];
            $('#compConsCodyFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[8].file['checkFileValid'] = true;
        }

    });
    $('#codyAgreementFile').change(function(evt) {

        var file = evt.target.files[0];
        if(file == null && myFileCaches[9] != null){
            delete myFileCaches[9];
        }else if(file != null){
            myFileCaches[9] = {file:file};
        }

        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'pdf'){
            msg += "*Only allow attachment format (PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[9].file['checkFileValid'] = false;
            delete myFileCaches[9];
            $('#codyAgreementFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[9].file['checkFileValid'] = true;
        }
    });
    $('#endOfCntNoticeFile').change(function(evt) {

        var file = evt.target.files[0];
        if(file == null && myFileCaches[10] != null){
            delete myFileCaches[10];
        }else if(file != null){
            myFileCaches[10] = {file:file};
        }

        var msg = '';
        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'pdf'){
            msg += "*Only allow attachment format (PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[10].file['checkFileValid'] = false;
            delete myFileCaches[10];
            $('#endOfCntNoticeFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[10].file['checkFileValid'] = true;
        }
    });
    $('#codyExtCheckFile').change(function(evt) {
    	var msg = '';
        var file = evt.target.files[0];
        if(file == null && myFileCaches[11] != null){
            msg += "*Not Allowed to Upload.<br>";
        }else if(file != null){
            myFileCaches[11] = {file:file};
            msg += "*Not Allowed to Upload.<br>";
        }

        if(msg != null && msg != ''){
            myFileCaches[11].file['checkFileValid'] = false;
            delete myFileCaches[11];
            $('#codyExtCheckFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[11].file['checkFileValid'] = true;
        }
    });
    $('#terminationAgreeFile').change(function(evt) {
        var msg = '';
        var file = evt.target.files[0];
        if(file == null && myFileCaches[12] != null){
            delete myFileCaches[12];
        }else if(file != null){
            myFileCaches[12] = {file:file};
        }

        if(file.name.length > 30){
            msg += "*File name wording should be not more than 30 alphabet.<br>";
        }

        var fileType = file.type.split('/');
        if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
            msg += "*Only allow attachment format (JPG, PNG, JPEG,PDF).<br>";
        }

        if(file.size > 2000000){
            msg += "*Only allow attachment with less than 2MB.<br>";
        }
        if(msg != null && msg != ''){
            myFileCaches[12].file['checkFileValid'] = false;
            delete myFileCaches[12];
            $('#nricCopyFile').val("");
            Common.alert(msg);
        }
        else{
            myFileCaches[12].file['checkFileValid'] = true;
        }

    });
});

function fn_removeFile(name){
    if(name == "CAF") {
         $("#codyAppFile").val("");
         $('#codyAppFile').change();
	}else if(name == "NRIC") {
	    $("#nricCopyFile").val("");
	    $('#nricCopyFile').change();
	}else if(name == "DLC") {
	   $("#driveCopyFile").val("");
	   $('#driveCopyFile').change();
	}else if(name == "BPSC") {
	   $("#bankStateCopyFile").val("");
	   $('#bankStateCopyFile').change();
	}else if(name == "VDC") {
	   $("#vaccDigCertFile").val("");
	   $('#vaccDigCertFile').change();
	}else if(name == "PSP") {
	    $("#fileName").val("");
	    $('#fileName').change();
	}else if(name == "CPC") {
	    $("#codyPaCopyFile").val("");
	    $('#codyPaCopyFile').change();
	}else if(name == "CCCI") {
	    $("#compConsCodyFile").val("");
	    $('#compConsCodyFile').change();
	}else if(name == "CA") {
        $("#codyAgreementFile").val("");
        $('#codyAgreementFile').change();
    }else if(name == "EOCN") {
        $("#endOfCntNoticeFile").val("");
        $('#endOfCntNoticeFile').change();
    }else if(name == "CEC") {
	    $("#codyExtCheckFile").val("");
	    $('#codyExtCheckFile').change();
	}else if(name == "TAF") {
        $("#terminationAgreeFile").val("");
        $('#terminationAgreeFile').change();
    }
}

function fn_validFile() {
    var isValid = true, msg = "";
    if(FormUtil.isEmpty($('#codyAppFile').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Cody Application File<br>";
    }
    if(FormUtil.isEmpty($('#nricCopyFile').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of NRIC<br>";
    }
    if(FormUtil.isEmpty($('#driveCopyFile').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Driving License<br>";
    }
    if(FormUtil.isEmpty($('#bankStateCopyFile').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Bank Passbook/Statement<br>";
    }
    if(FormUtil.isEmpty($('#vaccDigCertFile').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Vaccination Digital Certificate<br>";
    }
    if(FormUtil.isEmpty($('#fileName').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Passport Size Photo<br>";
    }
    if(FormUtil.isNotEmpty($('#codyPaCopyFile').val().trim())) {
        isValid = false;
        msg += "* Not allowed to upload Cody PA<br>";
    }
    if(FormUtil.isNotEmpty($('#compConsCodyFile').val().trim())) {
        isValid = false;
        msg += "* Not allowed to upload Cody Consignment<br>";
    }
    /* if(FormUtil.isNotEmpty($('#codyAgreementFile').val().trim())) {
        isValid = false;
        msg += "* Not allowed to upload Cody Agreement<br>";
    }
    if(FormUtil.isNotEmpty($('#endOfCntNoticeFile').val().trim())) {
        isValid = false;
        msg += "* Not allowed to upload End Of Contract Notice<br>";
    } */
    if(FormUtil.isNotEmpty($('#codyExtCheckFile').val().trim())) {
        isValid = false;
        msg += "* Not allowed to upload Cody Exist Checklist<br>";
    }
    if(isRejoinMem == false){
    	   if(FormUtil.isNotEmpty($('#terminationAgreeFile').val().trim())) {
    	        isValid = false;
    	        msg += "* Not allowed to upload Termination Agreement<br>";
    	    }
    }else {
        if(FormUtil.isEmpty($('#terminationAgreeFile').val().trim())) {
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

    if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

    return isValid;
}

function fn_validTerminateFile() {
      var isValid = true, msg = "";

	  if(isRejoinMem == false){
	          if(FormUtil.isNotEmpty($('#terminationAgreeFile').val().trim())) {
	               isValid = false;
	               msg += "* Not allowed to upload Termination Agreement<br>";
	           }
	   }else {
	       if(FormUtil.isEmpty($('#terminationAgreeFile').val().trim())) {
	           isValid = false;
	           msg += "* Please upload copy of Termination Agreement<br>";
	       }
    }
    if(isRejoinMem == false){
    	   if(FormUtil.isNotEmpty($('#terminationAgreeFile').val().trim())) {
    	        isValid = false;
    	        msg += "* Not allowed to upload Termination Agreement<br>";
    	    }
    }else {
        if(FormUtil.isEmpty($('#terminationAgreeFile').val().trim())) {
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

	 if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

    return isValid;
}

function fn_validTerminateFile() {
      var isValid = true, msg = "";

	  if(isRejoinMem == false){
	          if(FormUtil.isNotEmpty($('#terminationAgreeFile').val().trim())) {
	               isValid = false;
	               msg += "* Not allowed to upload Termination Agreement<br>";
	           }
	   }else {
	       if(FormUtil.isEmpty($('#terminationAgreeFile').val().trim())) {
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

	 if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

	 return isValid;
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member List - Add New Member</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<form id="applicantDtls" method="post">
    <div style="display:none">
        <input type="text" name="aplcntNRIC"  id="aplcntNRIC"/>
        <input type="text" name="aplcntName"  id="aplcntName"/>
        <input type="text" name="aplcntMobile"  id="aplcntMobile"/>
    </div>
</form>

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="memberAddForm" method="post">
<input type="hidden" id="areaId" name="areaId">
<input type="hidden" id="streetDtl1" name="streetDtl">
<input type="hidden" value ="addrDtl" id="addrDtl1" name="addrDtl">
<input type="hidden" id="traineeType" name="traineeType">
<input type="hidden" id="subDept" name="subDept">
<input type="hidden" id="userType" name="userType" value="${userType}">
<input type="hidden" id="memType" name="memType" value="${memType}">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId">
<input type="hidden" id="atchFileId" name="atchFileId">
<input type="hidden" id="isRejoinMem" name="isRejoinMem">
<input type="hidden" id="memId" name="memId">
<input type="hidden" id="salOrgRejoin" name="salOrgRejoin">
<!--<input type="hidden" id = "memberType" name="memberType"> -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" id="memberType" name="memberType" onchange = "fn_changeDetails()">
        <!-- <option value="1">Health Planner (HP)</option> -->
     <%--    <option value="2">Coway Lady (Cody)</option>
        <option value="3">Coway Technician (CT)</option>--%>
        <option value="4">Coway Staff (Staff)</option>
        <option value="5" selected="selected">Trainee</option>
        <option value="2803">HP Applicant</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Spouse Info</a></li>
    <li><a href="#">Member Address</a></li>
    <li><a href="#">Document Submission</a></li>
    <li id="attachmentTab" style="display:none;"><a href="#">Attachment</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Basic Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
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
    <input type="text" title="" id="memberNm" name="memberNm" placeholder="Member Name" class="w100p" />
    </td>
    <th scope="row">Joined Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="joinDate" name="joinDate" placeholder="DD/MM/YYYY" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Gender<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="gender" id="gender" value="M" onchange = "fn_changeDetails()" /><span>Male</span></label>
    <label><input type="radio" name="gender" id="gender" value="F" onchange = "fn_changeDetails()" /><span>Female</span></label>
    </td>
    <th scope="row">Date of Birth<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="Birth" name="Birth"placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <th scope="row">Race<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmbRace" name="cmbRace"  onchange = "fn_changeDetails()">
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
    <select class="w100p" id="national" name="national">
     <c:forEach var="list" items="${nationality}" varStatus="status">
             <option value="${list.countryid}">${list.name } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">NRIC (New)<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="NRIC (New)" id="nric" name="nric" class="w100p"  maxlength="12" onKeyDown="checkNRICEnter()"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Marital Status<span class="must">*</span></th>
    <td>
    <select class="w100p" id="marrital" name="marrital" onchange="javascript : fn_onchangeMarrital()">
    </select>
    </td>
</tr>
<%-- <tr>
    <th scope="row" rowspan="3">Address<span class="must">*</span></th>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(1)" class="w100p" id="address1" name="address1"/>
    </td>
</tr>
<tr>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(2)" class="w100p" id="address2" name="address2"/>
    </td>
</tr>
<tr>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(3)" class="w100p" id="address3" name="address3"/>
    </td>
</tr>
<tr>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <select class="w100p" id="country" name="country">
    </select>
    </td>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <select class="w100p" id="state" name="state">
        <c:forEach var="list" items="${state }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <select class="w100p" id="area" name="area">

    </select>
    </td>
</tr>
<tr>
    <th scope="row">Postcode<span class="must">*</span></th>
    <td>
    <select class="w100p" id="postCode" name="postCode">
    </select>
    </td>
    <th scope="row">Email</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Email" class="w100p" id="email" name="email"/>
    </td>
</tr> --%>
<tr>
    <th scope="row" id="emailLbl" name="emailLbl">Email</th>
    <td colspan="5">
    <input type="text" title="" placeholder="Email" class="w100p" id="email" name="email"  onKeyDown="checkEmailOnEnter()"/></td>
</tr>
<!-- ADDED INCOME TAX NO @AMEER 2021-09-27-->
    <th scope="row">Income Tax No</th>
    <td colspan="5">
    <input type="text" title="" placeholder="Income Tax No" class="w100p"  id="incomeTaxNo"  name="incomeTaxNo"
    onkeyup="this.value = this.value.toUpperCase();" style = "IME-MODE:disabled;"/>
    </td>
</tr>
<tr>
    <th scope="row" id="mobileNoLbl" name="mobileNoLbl">Mobile No.</th>
    <td>
    <input type="text" title="" placeholder="Numeric Only" class="w100p" id="mobileNo" name="mobileNo" maxlength="11" onKeyDown="fn_checkMobileNo()"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p"  id="officeNo" name="officeNo"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" id="residenceNo"  name="residenceNo"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
</tr>
<tr>
    <th scope="row">Sponsor's Code<span class="must">*</span></th>
    <td>

    <div class="search_100p"><!-- search_100p start -->
    <input type="text" title="" placeholder="Sponsor's Code" class="w100p" id="sponsorCd" name="sponsorCd" onKeyDown="fn_sponsorCheck()"/>
    <a href="javascript:fn_sponsorPop();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </div><!-- search_100p end -->

    </td>
    <th scope="row">Sponsor's Name</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's Name" class="w100p"  id="sponsorNm" name="sponsorNm"/>
    </td>
    <th scope="row">Sponsor's NRIC</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's NRIC" class="w100p" id="sponsorNric" name="sponsorNric"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
</tr>
<tr>
    <th scope="row">Branch<span class="must">*</span></th>
    <td>
    <select class="w100p" id="branch" name="branch">
    </select>
    </td>
    <th scope="row">Department Code<span class="must">*</span></th>
    <td>
    <select class="w100p" id="deptCd" name="deptCd">
        <c:forEach var="list" items="${DeptCdList}" varStatus="status">
            <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>

    </select>
    </td>
    <th scope="row">Transport Code</th>
    <td>
    <select class="w100p"  id="transportCd" name="transportCd">
    </select>
    </td>
</tr>
<tr>
    <th scope="row" id="meetingPointLbl">Business Area</th>
    <td colspan="5">
        <select class="w100p" id="meetingPoint" name="meetingPoint"></select>
    </td>
</tr>
<tr>
    <th scope="row">e-Approval Status</th>
    <td colspan="5">
    <input type="text" id="apprStusText" name="apprStusText" title="" placeholder="e-Approval Status" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Religion</th>
    <td colspan="2">
    <select class="w100p" id="religion" name="religion">
            <option value="">Choose One</option>
        <c:forEach var="list" items="${Religion}" varStatus="status">
            <option value="${list.detailcodeid}">${list.detailcodename } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">e-Approval Status</th>
    <td colspan="2">
    <select class="w100p" id="apprStusCombo" name="apprStusCombo">
       <!--  <option value="">Choose One</option> -->
        <option value="">Pending</option>
        <option value="">Approved</option>
        <option value="">Rejected</option>
    </select>
    </td>
</tr>
<tr>
    <!-- <th id="courseLbl" scope="row">Training Course</th>  20-10-2021 - HLTANG - close for LMS project
    <td colspan="2">
    <select class="w100p" id="course" name="course">
    </select>
    </td> -->
    <th scope="row">Total Vacation</th>
    <td colspan="2">
    <input type="text" id="totalVacation" name="totalVacation" title="" placeholder="Total Vacation" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Application Status</th>
    <td colspan="2">
    <select class="w100p" id="applicationStatus">
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
    <input type="text" id="remainVacation" name="remainVacation" title="" placeholder="Remain Vacation" class="w100p" />
    </td>
</tr>
<tr id = "trTrainee" >
    <th scope="row">Trainee Type </th>
    <td colspan="2">
        <select class= "w100p" id="traineeType1" name="traineeType1" onchange = "fn_changeDetails()">
        <option value="">Choose One</option>
        <option value= "2">Cody/Service Technician</option>
        <option value = "3">CT</option>
        <option value = "7">HT</option>
        <option value = "5758">DT</option>
        <option value = "6672">LT</option>
    </select>
    </td>
    <th scope="row"></th>
    <td colspan="2">
    </td>
</tr>
<tr>
    <th scope="row">Main Department</th>
    <td colspan="2">
    <select class="w100p" id="searchdepartment" name="searchdepartment"  >
            <option value="">Choose One</option>
         <c:forEach var="list" items="${mainDeptList}" varStatus="status">
             <option value="${list.deptId}">${list.deptName } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Sub Department</th>
    <td colspan="2">
    <select class="w100p" id="searchSubDept" name="searchSubDept">
             <option value="">Choose One</option>
       <%-- <c:forEach var="list" items="${subDeptList}" varStatus="status">
             <option value="${list.deptId}">${list.deptName} </option>
        </c:forEach>  --%>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"  id = "uniformSizeLbl">Uniform Size<span class="must">*</span></th>
    <td colspan="2">
    <select class="w100p" id="uniformSize" name="uniformSize"  >
            <option value="">Choose One</option>
    </select>
    </td>
    <th scope="row" id = "muslimahScarftLbl">Muslimah Scarft<span class="must">*</span></th>
   <td colspan="2">
        <label class="chkScarft"><input type="radio" id="muslimahScarftYes" name="muslimahScarft" value="Y"/><span>Y</span></label>
        <label class="chkScarft"><input type="radio" id="muslimahScarftNo" name="muslimahScarft" value="N"/><span>N</span></label>
   </td>
</tr>
<tr>
<th scope="row"></th>
   <td colspan="2">
   </td>
<th scope="row" id = "innerTypeLbl">Inner<span class="must">*</span></th>
   <td colspan="2">
    <select class="w100p" id="innerType" name="innerType">
             <option value="">Choose One</option>
    </select>
   </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Bank Account Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Issued Bank<span class="must">*</span></th>
    <td>
    <select class="w100p" id="issuedBank" name="issuedBank" onClick="javascript : onclickIssuedBank()" onChange="onChangeIssuedBank(this)">
    </select>
    </td>
    <th scope="row">Bank Account No<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Bank Account No" class="w100p" id="bankAccNo"  name="bankAccNo" onKeyDown="checkBankAccNoEnter()"
   />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Language Proficiency</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Education Level</th>
    <td>
    <select class="w100p" id="educationLvl" name="educationLvl">
    </select>
    </td>
    <th scope="row">Language</th>
    <td>
    <select class="w100p" id="language" name="language">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line" id="emergencyTabHeader"><!-- title_line start -->
<h2>Emergency Contact</h2>
</aside><!-- title_line end -->

<table class="type1" id="emergencyTabDetails"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.initial"/><span class="must">*</span></th>
    <td colspan="3">
        <select class="w100p" id="_cmbInitials_" name="cmbInitials"></select>
    </td>
</tr>
<tr>
    <th scope="row">Name<span class="must">*</span></th>
    <td colspan="3">
        <input type="text" title="" id="emergencyCntcNm" name="emergencyCntcNm" placeholder="Emergency Contact Name" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Contact No<span class="must">*</span></th>
    <td>
        <input type="text" title="" placeholder="Numeric Only" class="w100p" id="emergencyCntcNo" name="emergencyCntcNo" maxlength="11" onKeyDown="fn_checkEmergencyCntcNo()"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Relationship<span class="must">*</span></th>
    <td>
        <input type="text" title="" id="emergencyCntcRelationship" name="emergencyCntcRelationship" placeholder="Relationship" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>First TR Consign</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">TR No.</th>
    <td>
    <input type="text" title="" placeholder="TR No." class="w100p" id="trNo" name="trNo"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line" ><!-- title_line start -->
<h2>Agreement</h2>
</aside><!-- title_line end -->

<table class="type1" id="hideContent"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
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

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
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
    <th scope="row" id="spouseCodeLbl" name="spouseCodeLbl">MCode</th>
    <td>
    <input type="text" title="" placeholder="MCode" class="w100p" id="spouseCode" name="spouseCode" value=""/>
    </td>
    <th scope="row" id="spouseNameLbl" name="spouseNameLbl">Spouse Name</th>
    <td>
    <input type="text" title="" placeholder="Spouse Nam" class="w100p" id="spouseName" name="spouseName" value=""/>
    </td>
    <th scope="row" id="spouseNricLbl" name="spouseNricLbl">NRIC / Passport No.</th>
    <td>
    <input type="text" title="" placeholder="NRIC / Passport No." class="w100p" id="spouseNric" name="spouseNric"  value=""/>
    </td>
</tr>
<tr>
    <th scope="row" id="spouseOccLbl" name="spouseOccLbl">Occupation</th>
    <td>
    <input type="text" title="" placeholder="Occupation" class="w100p" id="spouseOcc" name="spouseOcc" value=""/>
    </td>
    <th scope="row" id="spouseDobLbl" name="spouseDobLbl">Date of Birth</th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date readonly" id="spouseDob" name="spouseDob" value=""/>
    </td>
    <th scope="row" id="spouseContatLbl" name="spouseContatLbl">Contact No.</th>
    <td>
    <input type="text" title="" placeholder="Contact No. (Numberic Only)" class="w100p readonly" id="spouseContat" name="spouseContat"  value=""/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Residential Address</h2>
</aside><!-- title_line end -->

<form id="insAddressForm" name="insAddressForm" method="POST">

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:135px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
         <tbody>
            <tr>
                <th scope="row" >Address Line 1<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p"  maxlength="50"/>
                </td>
            </tr>
            <tr>
                <th scope="row" >Address Line 2<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p" maxlength="50"/>
                </td>
            </tr>
            <tr>
                <th scope="row">State(1)<span class="must">*</span></th>
                <td>
                <select class="w100p" id="mState"  name="mState" placeholder="eg. SABAH" onchange="javascript : fn_selectState(this.value)"></select>
                </td>
                <th scope="row">Country<span class="must">*</span></th>
                <td>
                <input type="text" title="" id="mCountry" name="mCountry" placeholder="eg. MALAYSIA" class="w100p readonly" readonly="readonly" value="Malaysia"/>
                </td>
            </tr>

            <tr>
                 <th scope="row">City(2)<span class="must">*</span></th>
                <td>
                <select class="w100p" id="mCity"  name="mCity" placeholder="eg. KOTA KINABALU" onchange="javascript : fn_selectCity(this.value)"></select>
                </td>
                <th scope="row">PostCode(3)<span class="must">*</span></th>
                <td>
                <select class="w100p" id="mPostCd"  name="mPostCd" placeholder="eg. 88450" onchange="javascript : fn_selectPostCode(this.value)"></select>
                </td>
            </tr>
            <tr>
                <th scope="row">Area search<span class="must">*</span></th>
                <td >
                <input type="text" title="" id="searchSt" name="searchSt" placeholder="eg. TAMAN RIMBA" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
               <th scope="row">Area(4)<span class="must">*</span></th>
                <td >
                <select class="w100p" id="mArea"  name="mArea" placeholder="eg. TAMAN RIMBA" onchange="javascript : fn_getAreaId()"></select>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<div id="grid_wrap_doc" style="width: 100%; height:430px; margin: 0 auto;"></div>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<h2>Attachment</h2>
<table class="type1 mt10" id="attachmentDiv"><!-- table start -->
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Cody Application Form<span class="must commonRequired">*</span></th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="codyAppFile" accept="application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("CAF")'>Remove</a></span>
            </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">NRIC Copy<span class="must commonRequired">*</span></th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="nricCopyFile" accept="image/jpeg/application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("NRIC")'>Remove</a></span>
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Driving License Copy<span class="must commonRequired">*</span></th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="driveCopyFile" accept="image/jpg/application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("DLC")'>Remove</a></span>
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Bank Passbook / Statement Copy<span class="must commonRequired">*</span></th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="bankStateCopyFile" accept="image/jpeg/application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("BPSC")'>Remove</a></span>
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Vaccination Digital Certificate<span class="must commonRequired">*</span></th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2 ">
            <input type="file" title="file add" id="vaccDigCertFile"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' accept="application/pdf"/>
                <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("VDC")'>Remove</a></span>
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Passport Size Photo (white background)<span class="must commonRequired">*</span></th>
    <td colspan="3" id="attachTd">
    <div class="auto_file2" >
    <input type="file" title="file add" id="fileName" accept="image/jpg"/>
        <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("PSP")'>Remove</a></span>
        </label>
    </div>
    </td>
</tr>
<tr>
    <th scope="row">Cody PA Copy</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="codyPaCopyFile" accept="image/jpeg/application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("CPC")'>Remove</a></span>
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Company Consigment Cody Item, Tools, Filter Stock, Spare part</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="compConsCodyFile" accept="image/jpeg/application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text' cursor='default'><a href='#'>Upload</a></span>
                <span class='label_text' cursor='default'><a href='#' onclick='fn_removeFile("CCCI")'>Remove</a></span>
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Cody Agreement</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="codyAgreementFile" accept="application/pdf"/>
            <label>
                <input type='text' class='input_text'  readonly='readonly' id="codyAgreementFileTxt"/>
                <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("CA")'>Remove</a></span>
            </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">End Of Contract Notice</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="endOfCntNoticeFile" accept="application/pdf"/>
            <label>
                <input type='text' class='input_text'  readonly='readonly' id="endOfCntNoticeFileTxt"/>
                <span class='label_text'><a href='#'>Upload</a></span>
              <span class='label_text'><a href='#' onclick='fn_removeFile("EOCN")'>Remove</a></span>
            </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Cody Exit Checklist</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="codyExtCheckFile" accept="image/jpeg/application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text' disabled="disabled"><a href='#'>Upload</a></span>
                <span class='label_text' disabled="disabled"><a href='#' onclick='fn_removeFile("CEC")'>Remove</a></span>
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Termination Agreement<span class="must join">*</span></th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="terminationAgreeFile" accept="image/jpg, image/jpeg,application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text' disabled="disabled"><a href='#'>Upload</a></span>
                <span class='label_text' disabled="disabled"><a href='#' onclick='fn_removeFile("TAF")'>Remove</a></span>
             </label>
        </div>
    </td>
</tr>
</tbody>
</table><!-- table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->

</form>

</section><!-- tap_wrap end -->


</div><!-- popup_wrap end -->
