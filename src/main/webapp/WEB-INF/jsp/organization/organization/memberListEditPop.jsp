<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
console.log("memberListEditPop");

var optionState = {chooseMessage: " 1.States "};
var optionCity = {chooseMessage: "2. City"};
var optionPostCode = {chooseMessage: "3. Post Code"};
var optionArea = {chooseMessage: "4. Area"};

var dup = false;

var atchFileGrpId = '';
var atchFileGrpIdNew = '';
var atchFileId = '';
var atchFileIdNew = '';
var myFileCaches = {};
var checkFileValid = true;

var update = new Array();
var remove = new Array();

var codyAppFileId = 0;
var nricCopyFileId = 0;
var driveCopyFileId = 0;
var bankStateCopyFileId = 0;
var vaccDigCertFileId = 0;
var fileNameId = 0;
var codyPaCopyFileId = 0;
var compConsCodyFileId = 0;
var codyExtCheckFileId = 0;
var terminationAgreeFileId = 0;

var codyAppFileName = "";
var nricCopyFileName = "";
var driveCopyFileName = "";
var bankStateCopyFileName = "";
var vaccDigCertFileName = "";
var fileNameName = "";
var codyPaCopyFileName = "";
var compConsCodyFileName = "";
var codyExtCheckFileName = "";
//var jsonObj1;

var fileName = "";

var myGridID_Doc;
function fn_memberSave(){

	if(("${memberView.memType}" == "5" &&  $("#traineeType").val() == "2") || ("${memberView.memType}" == "2")){
		var filecount = 0;
        var formData = new FormData();
        $.each(myFileCaches, function(n, v) {
            console.log("n : " + n + " v.file : " + v.file);
            formData.append(n, v.file);
            filecount++
        });

        var atchFileGrpId = "${memberView.atchFileGrpIdDoc}";
        formData.append("atchFileGrpId", atchFileGrpId);
        formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        if("${memberView.atchFileGrpIdDoc}" == ""){
	        	if(filecount > 0){
		        	Common.ajaxFile("/organization/attachFileMemberUpload.do", formData, function(result) {
		                console.log(result);
		                atchFileGrpIdNew = result.data.fileGroupKey;
		                atchFileIdNew = result.data.atchFileId;

		                $("#atchFileGrpIdNew").val($("#atchFileGrpIdNew").val());

				    $("#memberType").attr("disabled",false);
				    $("#joinDate").attr("disabled",false);
				    $("#nric").attr("disabled",false);
				    $("#areaId").val($("#areaId").val());
				    $("#streetDtl1").val(memberAddForm.streetDtl.value);
				    $("#addrDtl1").val(memberAddForm.addrDtl.value);
				    $("#searchSt1").val(memberAddForm.searchSt.value);
				    $("#traineeType").val(($("#traineeType").value));
				    $("#spouseDob").val($.trim($("#spouseDob").val()));

				    $("#memberType").attr("disabled",false);
				    var jsonObj = GridCommon.getEditData(myGridID_Doc);;

				    if($("#memberType").val() != "4" && $("#memberType").val() != "6185") {
				        jsonObj = GridCommon.getEditData(myGridID_Doc);
				    }
				    // jsonObj.form = $("#memberAddForm").serializeJSON();
				    jsonObj.form = $("#memberUpdForm").serializeJSON();

				    //ADDED BY TOMMY 27/05/2020 FOR HOSPITALISATION CHECKBOX
				    if($("#hsptlzCheck").is(":checked") == true){
				        $.extend(jsonObj, {'hsptlz' : '1'});
				    }else{
				        $.extend(jsonObj, {'hsptlz' : '0'});
				    }

				    $.extend(jsonObj,{'atchFileGrpIdNew':atchFileGrpIdNew});
				    //ADDED INCOME TAX NO @AMEER 2021-11-02
				    if($("#incomeTaxNo").val() != " " || $("#incomeTaxNo").val() != null){
				    	$.extend(jsonObj,{'incomeTaxNo':$("#incomeTaxNo").val() });
				    }

				    $.extend(jsonObj, {'Birth' :$("#Birth").val() });
				    $.extend(jsonObj, {'memberType' : $("#memberType").val()});
				    $.extend(jsonObj, {'areaIdUpd' : $("#areaId").val()});
                    $.extend(jsonObj, {'cmbInitialsUpd' : $("#cmbInitials").val()});
                    $.extend(jsonObj, {'emergencyCntcNmUpd' : $("#emergencyCntcNm").val()});
                    $.extend(jsonObj, {'emergencyCntcNoUpd' : $("#emergencyCntcNo").val()});
                    $.extend(jsonObj, {'emergencyCntcRelationshipUpd' : $("#emergencyCntcRelationship").val()});
                    $.extend(jsonObj, {'businessType' : $("#businessType").val()});
                    //Keyi - bug fix #24033842 - unable update member email
                    $.extend(jsonObj, {'emailUpd' : $("#memEmail").val()});
                    $.extend(jsonObj, {'sponsorCd' : $("#sponsorCd").val()});  // bug fix ticket 24040722

				    console.log(JSON.stringify(jsonObj));
				    Common.ajax("POST", "/organization/memberUpdate",  jsonObj, function(result) {
				        console.log("message : " + result.message );
				        Common.alert(result.message, fn_close);
				    });

				    $("#memberType").attr("disabled",true);
				    $("#joinDate").attr("disabled",true);
				    $("#nric").attr("disabled",true);

					   });
	              }else{
	            	  $("#memberType").attr("disabled",false);
	                  $("#joinDate").attr("disabled",false);
	                  $("#nric").attr("disabled",false);
	                  $("#areaId").val($("#areaId").val());
	                  $("#streetDtl1").val(memberAddForm.streetDtl.value);
	                  $("#addrDtl1").val(memberAddForm.addrDtl.value);
	                  $("#searchSt1").val(memberAddForm.searchSt.value);
	                  $("#traineeType").val(($("#traineeType").value));
	                  $("#spouseDob").val($.trim($("#spouseDob").val()));

	                  $("#memberType").attr("disabled",false);
	                  var jsonObj = GridCommon.getEditData(myGridID_Doc);;

	                  if($("#memberType").val() != "4" && $("#memberType").val() != "6185") {
	                      jsonObj = GridCommon.getEditData(myGridID_Doc);
	                  }
	                  // jsonObj.form = $("#memberAddForm").serializeJSON();
	                  jsonObj.form = $("#memberUpdForm").serializeJSON();

	                  //ADDED BY TOMMY 27/05/2020 FOR HOSPITALISATION CHECKBOX
	                  if($("#hsptlzCheck").is(":checked") == true){
	                      $.extend(jsonObj, {'hsptlz' : '1'});
	                  }else{
	                      $.extend(jsonObj, {'hsptlz' : '0'});
	                  }

	                  $.extend(jsonObj,{'atchFileGrpIdNew':atchFileGrpIdNew});
	                  //ADDED INCOME TAX NO @AMEER 2021-11-02
	                  if($("#incomeTaxNo").val() != " " || $("#incomeTaxNo").val() != null){
	                      $.extend(jsonObj,{'incomeTaxNo':$("#incomeTaxNo").val() });
	                  }

	                  $.extend(jsonObj, {'Birth' :$("#Birth").val() });
	                  $.extend(jsonObj, {'memberType' : $("#memberType").val()});
	                  $.extend(jsonObj, {'areaIdUpd' : $("#areaId").val()});
                      $.extend(jsonObj, {'cmbInitialsUpd' : $("#cmbInitials").val()});
                      $.extend(jsonObj, {'emergencyCntcNmUpd' : $("#emergencyCntcNm").val()});
                      $.extend(jsonObj, {'emergencyCntcNoUpd' : $("#emergencyCntcNo").val()});
                      $.extend(jsonObj, {'emergencyCntcRelationshipUpd' : $("#emergencyCntcRelationship").val()});
                      $.extend(jsonObj, {'businessType' : $("#businessType").val()});
                      //Keyi - bug fix #24033842 - unable update member email
                      $.extend(jsonObj, {'emailUpd' : $("#memEmail").val()});
                      $.extend(jsonObj, {'sponsorCd' : $("#sponsorCd").val()});  // bug fix ticket 24040722

	                  console.log(JSON.stringify(jsonObj));
	                  Common.ajax("POST", "/organization/memberUpdate",  jsonObj, function(result) {
	                      console.log("message : " + result.message );
	                      Common.alert(result.message, fn_close);
	                  });

	                  $("#memberType").attr("disabled",true);
	                  $("#joinDate").attr("disabled",true);
	                  $("#nric").attr("disabled",true);
	              }
		   }else{
			   Common.ajaxFile("/organization/attachFileMemberUpdate.do", formData, function(result) {
	                 console.log(result);
	                 atchFileGrpId = result.data.fileGroupKey;
	                 atchFileId = result.data.atchFileId;

		            $("#memberType").attr("disabled",false);
		            $("#joinDate").attr("disabled",false);
		            $("#nric").attr("disabled",false);
		            $("#areaId").val($("#areaId").val());
		            $("#streetDtl1").val(memberAddForm.streetDtl.value);
		            $("#addrDtl1").val(memberAddForm.addrDtl.value);
		            $("#searchSt1").val(memberAddForm.searchSt.value);
		            $("#traineeType").val(($("#traineeType").value));
		            $("#spouseDob").val($.trim($("#spouseDob").val()));

		            $("#memberType").attr("disabled",false);
		            var jsonObj = GridCommon.getEditData(myGridID_Doc);;

		            if($("#memberType").val() != "4" && $("#memberType").val() != "6185") {
		                jsonObj = GridCommon.getEditData(myGridID_Doc);
		            }
		            // jsonObj.form = $("#memberAddForm").serializeJSON();
		            jsonObj.form = $("#memberUpdForm").serializeJSON();

		            //ADDED BY TOMMY 27/05/2020 FOR HOSPITALISATION CHECKBOX
		            if($("#hsptlzCheck").is(":checked") == true){
		                $.extend(jsonObj, {'hsptlz' : '1'});
		            }else{
		                $.extend(jsonObj, {'hsptlz' : '0'});
		            }

		            //ADDED INCOME TAX NO @AMEER 2021-11-02
		            if($("#incomeTaxNo").val() != " " || $("#incomeTaxNo").val() != null){
		                $.extend(jsonObj,{'incomeTaxNo':$("#incomeTaxNo").val() });
		            }

		            $.extend(jsonObj, {'Birth' :$("#Birth").val() });
		            $.extend(jsonObj, {'memberType' : $("#memberType").val()});
		            $.extend(jsonObj, {'areaIdUpd' : $("#areaId").val()});
		            $.extend(jsonObj, {'cmbInitialsUpd' : $("#cmbInitials").val()});
		            $.extend(jsonObj, {'emergencyCntcNmUpd' : $("#emergencyCntcNm").val()});
		            $.extend(jsonObj, {'emergencyCntcNoUpd' : $("#emergencyCntcNo").val()});
		            $.extend(jsonObj, {'emergencyCntcRelationshipUpd' : $("#emergencyCntcRelationship").val()});
		            $.extend(jsonObj, {'businessType' : $("#businessType").val()});
		            //Keyi - bug fix #24033842 - unable update member email
                    $.extend(jsonObj, {'emailUpd' : $("#memEmail").val()});
                    $.extend(jsonObj, {'sponsorCd' : $("#sponsorCd").val()});  // bug fix ticket 24040722

		            console.log(JSON.stringify(jsonObj));
		            Common.ajax("POST", "/organization/memberUpdate",  jsonObj, function(result) {
		                console.log("message : " + result.message );
		                Common.alert(result.message, fn_close);
		            });

		            $("#memberType").attr("disabled",true);
		            $("#joinDate").attr("disabled",true);
		            $("#nric").attr("disabled",true);

	            });
		   }
	}else{
	      $("#memberType").attr("disabled",false);
	        $("#joinDate").attr("disabled",false);
	        $("#nric").attr("disabled",false);
	        $("#areaId").val($("#areaId").val());
	        $("#streetDtl1").val(memberAddForm.streetDtl.value);
	        $("#addrDtl1").val(memberAddForm.addrDtl.value);
	        $("#searchSt1").val(memberAddForm.searchSt.value);
	        $("#traineeType").val(($("#traineeType").value));
	        $("#spouseDob").val($.trim($("#spouseDob").val()));

	        $("#memberType").attr("disabled",false);
	        var jsonObj = GridCommon.getEditData(myGridID_Doc);;

	        if($("#memberType").val() != "4" && $("#memberType").val() != "6185") {
	            jsonObj = GridCommon.getEditData(myGridID_Doc);
	        }
	        // jsonObj.form = $("#memberAddForm").serializeJSON();
	        jsonObj.form = $("#memberUpdForm").serializeJSON();

	        //ADDED BY TOMMY 27/05/2020 FOR HOSPITALISATION CHECKBOX
	        if($("#hsptlzCheck").is(":checked") == true){
	            $.extend(jsonObj, {'hsptlz' : '1'});
	        }else{
	            $.extend(jsonObj, {'hsptlz' : '0'});
	        }

	        //ADDED INCOME TAX NO @AMEER 2021-11-02
	        if($("#incomeTaxNo").val() != " " || $("#incomeTaxNo").val() != null){
	            $.extend(jsonObj,{'incomeTaxNo':$("#incomeTaxNo").val() });
	        }

	        $.extend(jsonObj, {'Birth' :$("#Birth").val() });
	        $.extend(jsonObj, {'memberType' : $("#memberType").val()});
	        $.extend(jsonObj, {'areaIdUpd' : $("#areaId").val()});
            $.extend(jsonObj, {'cmbInitialsUpd' : $("#cmbInitials").val()});
            $.extend(jsonObj, {'emergencyCntcNmUpd' : $("#emergencyCntcNm").val()});
            $.extend(jsonObj, {'emergencyCntcNoUpd' : $("#emergencyCntcNo").val()});
            $.extend(jsonObj, {'emergencyCntcRelationshipUpd' : $("#emergencyCntcRelationship").val()});
            $.extend(jsonObj, {'businessType' : $("#businessType").val()});
            //Keyi - bug fix #24033842 - unable update member email
            $.extend(jsonObj, {'emailUpd' : $("#memEmail").val()});

	        console.log(JSON.stringify(jsonObj));
	        Common.ajax("POST", "/organization/memberUpdate",  jsonObj, function(result) {
	            console.log("message : " + result.message );
	            Common.alert(result.message, fn_close);
	        });

	        $("#memberType").attr("disabled",true);
	        $("#joinDate").attr("disabled",true);
	        $("#nric").attr("disabled",true);
	}
}
function fn_close(){
	$("#popup_wrap").remove();
}
function fn_saveConfirm(){
	if(fn_saveValidation()){
        Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
        /*
        Common.ajax("GET","/organization/memberListUpdate.do", $("#memberAddForm").serialize(), function(result){
            console.log(result);
            Common.alert("Member Save successfully.",fn_close);

        });
        */

    }
}
function fn_docSubmission(){
    $("#memberType").attr("disabled",false);
    var docMemId=$("#MemberID").val();
    Common.ajax("GET", "/organization/selectHpDocSubmission?memberID=" + docMemId,  $("#memType").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID_Doc, result);
        AUIGrid.resize(myGridID_Doc,1000,400);
        $("#memberType").attr("disabled",true);
    });
}

function fn_departmentCode(value){
	console.log("fn_departmentCode");
	if($("#memberType").val() != 2){
	        $("#hideContent").hide()
	        $("#hideContentTitle").hide()
	    }else{
	    	$("#hideContent").show();
	    	$("#hideContentTitle").show()
	    }
	var action = value;
	switch(action){
	   /* case 1 :
		   $("#groupCode[memberLvl]").val(3);
		   $("#groupCode[flag]").val("%CRS%");
		   var jsonObj = {
	            memberLvl : 3,
	            flag :  "%CRS%"
	    };
		   doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
		   break; */
	   case 2 :
		   $("#groupCode[memberLvl]").val(3);
           $("#groupCode[flag]").val("%CCS%");
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CCS%"
        };
           //doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           //doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;
	   case 3 :
		   $("#groupCode[memberLvl]").val(3);
           $("#groupCode[flag]").val("%CTS%");
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CTS%"
        };
           //doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           //doGetComboSepa("/common/selectBranchCodeList.do",2 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;

	   case 4 :
		   $("#groupCode[memberLvl]").val(100);
           $("#groupCode[flag]").val("-");
           var jsonObj = {
                memberLvl : 100,
                flag :  "-"
        };
           //doGetComboSepa("/common/selectBranchCodeList.do",100 , '-',''   , 'branch' , 'S', '');
           break;

	   case 5 :
		   $("#groupCode[memberLvl]").val(3);
           $("#groupCode[flag]").val("%CCS%");
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CCS%"
        };
           //doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           //doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;
	}
}

/*
$("#cmbRace").load(function() {
	var race = "${memberView.c40}";
    var race_no = "${memberView.c61}";

    alert(race_no);
    $("#cmbRace option[value="+ race_no +"]").attr("selected", true);
    //$("#cmbRace").val(race).attr("selected", true);
    alert($("#cmbRace").val());
});
*/

$(document).ready(function() {

     if(("${memberView.memType}" == "5" &&  $("#traineeType").val() == "2") || ("${memberView.memType}" == "2")){
         $("#attachmentTab").show();
         $('#emergencyTabHeader').show();
         $('#emergencyTabDetails').show();
         if( "${memberView.atchFileGrpIdDoc}" != 0 &&  "${memberView.atchFileGrpIdDoc}" != null){
        	 fn_loadAtchment( "${memberView.atchFileGrpIdDoc}");

      }
     }else{
         if( "${memberView.atchFileGrpIdDoc}" != 0 &&  "${memberView.atchFileGrpIdDoc}" != null){
             fn_loadAtchment( "${memberView.atchFileGrpIdDoc}");
             $("#attachmentTab").show();
         }else {
             $("#attachmentTab").hide();
         }
       $('#emergencyTabHeader').hide();
       $('#emergencyTabDetails').hide();
   }

    doGetCombo('/sales/customer/getNationList', '338' , '' ,'country' , 'S');
    doGetCombo('/sales/customer/getNationList', '338' , '' ,'national' , 'S');
    doGetCombo('/common/selectCodeList.do', '2', '','cmbRace', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '4', '','marrital', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '3', '','language', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '5', '','educationLvl', 'S' , '');
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'issuedBank', 'S', '')
    doGetCombo('/common/selectCodeList.do', '17', '','cmbInitials', 'S' , '');

    /* if($("#traineeType").val() == "2" || $("#traineeType").val() == "3"){ //20-10-2021 - HLTANG - close for LMS project
        var groupCode  = {groupCode : $("#traineeType").val()};
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
        });
    } */

    doGetCombo('/organization/selectBusinessType.do', '', '','businessType', 'S' , '');

    createAUIGridDoc();
    fn_getMemInfo();

    // ADDED BY TOMMY 27/05/2020 ONLY ALLOW CODY AND HT FOR HOSPITALISATION CHECKBOX
    // 20201007 - LaiKW - Added No TBB for HP
    // 20201008 - LaiKW - Amended to cater editing of temporary staff codes details
    $("#editRow1_1").hide();
    $("#hpNoTBB").hide();

    if("${memType}" == "2" || "${memType}" == "7") {
        $("#hsptlzCheck").attr({"disabled" : false });

    } else if("${memType}" == "4" || "${memType}" == "6185") {
        // AUIGrid.destroy(myGridID_Doc);

        // Remove Tabs
        $("#spouseInfoTab").remove();
        $("#spouseInfoDisplay").remove();
        $("#documentSubTab").remove();
        $("#documentSubDisplay").remove();

        // Hide "Basic Info" not required fields
        $("#selectBranchCol").attr('colspan', 5);
        $("#deptCodeLbl").remove();
        $("#deptCode").remove();
        $("#transportCodeLbl").remove();
        $("#transportCd").remove();
        $("#transportCdCol").remove();
        $("#subDeptLbl").remove();
        $("#subDeptLblCol").remove();
        $("#searchdepartmentcol").attr('colspan', 5);

        if("${memType}" == "6185") {
            $("#editRow1_1").show();
        }

        $("#editRow1_7").remove();
        $("#editRow1_9").remove();
        $("#editRow1_10").remove();
        $("#editRow1_11").remove();
        $("#editRow1_12").remove();
        $("#editRow1_13").remove();
        $("#editRow1_15").remove();
        $("#trMobileUseYn").remove();

        $("#languageTitle").remove();
        $("#languageTable").remove();
        $("#trConsignTitle").remove();
        $("#trConsignTable").remove();

    } else if("${memType}" == "1") {
        $("#hpNoTBB").show();
    }

    if("${memType}" != "4" && "${memType}" != "6185") {
        fn_docSubmission();
    }

	$("#convStaff").change(function() {
	    if($("#convStaff").is(":checked")) {
	        console.log("convStaff");

	        Common.ajax("GET", "/organization/checkMemCode.do", {username : $("#memberCode").val()}, function(result) {
	            if(result.code != 99) {
	                $("#convStaffFlgUpd").remove();
	                $("#memberUpdForm").append("<input type='hidden' name='convStaffFlgUpd' id='convStaffFlgUpd'>");
	                $("#convStaffFlgUpd").val("Y");

	                $("#memberCodeUpd").remove();
	                $("#memberUpdForm").append("<input type='hidden' name='memberCodeUpd' id='memberCodeUpd'>");
	                $("#memberCodeUpd").val($("#memberCode").val());

	                $("#usernameUpd").remove();
                    $("#memberUpdForm").append("<input type='hidden' name='usernameUpd' id='usernameUpd'>");
                    $("#usernameUpd").val($("#memberCode").val());
	            } else {
	                $("#memberCodeUpd").remove();
	                $("#convStaff").prop('checked', false);

	                Common.alert("Please check member code.");
	                return false;
	            }
	        });
	    }
	});

	$("#memberCode").change(function() {
	    Common.ajax("GET", "/organization/checkMemCode.do", {username : $("#memberCode").val()}, function(result) {
	        if(result.code != 99) {
	            $("#memberCodeUpd").remove();
                $("#memberUpdForm").append("<input type='hidden' name='memberCodeUpd' id='memberCodeUpd'>");
                $("#memberCodeUpd").val($("#memberCode").val());
	        }
	    });
	});

	$("#noTBBChkbox").change(function() {
	    if($("#noTBBChkbox").is(":checked")) {
	        $("#noTBBChkboxUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='noTBBChkboxUpd' id='noTBBChkboxUpd'>");
            $("#noTBBChkboxUpd").val("1");
	    } else {
	        $("#noTBBChkboxUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='noTBBChkboxUpd' id='noTBBChkboxUpd'>");
            $("#noTBBChkboxUpd").val("0");
	    }
	});

    if("${memType}" == "1" || "${memType}" == "2803") {
         doGetCombo('/organization/selectHpMeetPoint.do', '', '', 'meetingPoint', 'S', '');
         doGetCombo('/organization/selectAccBank.do', '', '', 'issuedBank', 'S', '');
    }

    $("#searchdepartment").change(function(){
        doGetCombo('/organization/selectSubDept.do',  $("#searchdepartment").val(), '','inputSubDept', 'S' ,  '');
    });

    $("#joinDate").attr("disabled", true);

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

    // 2020-02-04 - LaiKW - Added to block CDB Sales admin to self change branch
    if('${userRoleId}' == 256) {
        $("#selectBranch").attr("disabled", true);
    }

    // Basic Info Tab on change append - start
    if($("#memberCodeUpd").length == 0) {
        $("#memberCodeUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='memberCodeUpd' id='memberCodeUpd'>");
        $("#memberCodeUpd").val($("#memCode").val());
    }

    document.getElementById("memberNm").addEventListener("input", function() {
    // $("#memberNm").change(function() {
        $("#memberNmUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='memberNmUpd' id='memberNmUpd'>");
        $("#memberNmUpd").val($("#memberNm").val());
    });

    $("#cmbRace").change(function() {
        $("#cmbRaceUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='cmbRaceUpd' id='cmbRaceUpd'>");
        $("#cmbRaceUpd").val($("#cmbRace").val());
    });

    $('#marrital').change(function() {
        $("#marritalUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='marritalUpd' id='marritalUpd'>");
        $("#marritalUpd").val($("#marrital").val());
    });

    document.getElementById("email").addEventListener("input", function() {
    // $('#email').change(function() {
        $("#emailUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='emailUpd' id='emailUpd'>");
        $("#emailUpd").val($("#memEmail").val());
    });

    //
    document.getElementById("mobileNo").addEventListener("input", function() {
    // $('#mobileNo').change(function() {
        $("#mobileNoUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='mobileNoUpd' id='mobileNoUpd'>");
        $("#mobileNoUpd").val($("#mobileNo").val());
    });

    document.getElementById("officeNo").addEventListener("input", function() {
    // $('#officeNo').change(function() {
        $("#officeNoUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='officeNoUpd' id='officeNoUpd'>");
        $("#officeNoUpd").val($("#officeNo").val());
    });

    document.getElementById("residenceNo").addEventListener("input", function() {
        $("#residenceNoUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='residenceNoUpd' id='residenceNoUpd'>");
        $("#residenceNoUpd").val($("#residenceNo").val());
    });

    //

    //
    $('#selectBranch').change(function() {
        $("#selectBranchUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='selectBranchUpd' id='selectBranchUpd'>");
        $("#selectBranchUpd").val($("#selectBranch").val());

        $("#searchdepartment").empty();
        Common.ajax("GET", "/common/userManagement/getDeptList.do", "branchId=" + $("#selectBranch").val(), function(bData, textStatus, jqXHR) {
            $("#searchdepartment").append("<option value=''>Choose One</option>");

            for(var i = 0; i < bData.length; i++) {
                $("#searchdepartment").append("<option value='"+bData[i].codeId+"'>"+bData[i].codeName+"</option>");
            }
        }, function(jqXHR, textStatus, errorThrown){ // Error
            alert("Fail : " + jqXHR.responseJSON.message);
        })
    });

    $('#transportCd').change(function() {
        $("#transportCdUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='transportCdUpd' id='transportCdUpd'>");
        $("#transportCdUpd").val($("#transportCd").val());
    });
    //

    //
    $('#meetingPoint').change(function() {
        $("#meetingPointUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='meetingPointUpd' id='meetingPointUpd'>");
        $("#meetingPointUpd").val($("#meetingPoint").val());
    });
    //

    //
    $('#religion').change(function() {
        $("#religionUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='religionUpd' id='religionUpd'>");
        $("#religionUpd").val($("#religion").val());
    });
    //

    //20-10-2021 - HLTANG - close for LMS project
    /* $('#course').change(function() {
        $("#courseUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='courseUpd' id='courseUpd'>");
        $("#courseUpd").val($("#course").val());
    }); */
    //

    //
    $('#searchdepartment').change(function() {
        $("#searchdepartmentUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='searchdepartmentUpd' id='searchdepartmentUpd'>");
        $("#searchdepartmentUpd").val($("#searchdepartment").val());
    });

    /*
    $('#inputSubDept').change(function() {
        $("#inputSubDeptUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='inputSubDeptUpd' id='inputSubDeptUpd'>");
        $("#inputSubDeptUpd").val($("#inputSubDept").val());
    });
    */
    //

    //
    $('#mobileUseYn').change(function() {
        $("#mobileUseYnUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='mobileUseYnUpd' id='mobileUseYnUpd'>");
        $("#mobileUseYnUpd").val($("#mobileUseYn").val());
    });
    //

    //
    $('#issuedBank').change(function() {
        $("#issuedBankUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='issuedBankUpd' id='issuedBankUpd'>");
        $("#issuedBankUpd").val($("#issuedBank").val());
    });

    document.getElementById("bankAccNo").addEventListener("input", function() {
    // $('#bankAccNo').change(function() {
        $("#bankAccNoUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='bankAccNoUpd' id='bankAccNoUpd'>");
        $("#bankAccNoUpd").val($("#bankAccNo").val());
    });
    //

    //
    $('#educationLvl').change(function() {
        $("#educationLvlUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='educationLvlUpd' id='educationLvlUpd'>");
        $("#educationLvlUpd").val($("#educationLvl").val());
    });

    $('#language').change(function() {
        $("#languageUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='languageUpd' id='languageUpd'>");
        $("#languageUpd").val($("#language").val());
    });
    //
    // Basic Info Tab on change append - end

    if("${memType}" != "4" && "${memType}" != "6185") {
        // Basic Info Tab on change append - Start
        document.getElementById("trNo").addEventListener("input", function() {
            // $('#trNo').change(function() {
            $("#trNoUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='trNoUpd' id='trNoUpd'>");
            $("#trNoUpd").val($("#trNo").val());
        });

        $('#codyPaExpr').change(function() {
            $("#codyPaExprUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='codyPaExprUpd' id='codyPaExprUpd'>");
            $("#codyPaExprUpd").val($("#codyPaExpr").val());
        });
        // Basic Info Tab on change append - End

        // Spouse Tab on change append - start
        document.getElementById("spouseCode").addEventListener("input", function() {
        // $('#spouseCode').change(function() {
            $("#spouseCodeUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='spouseCodeUpd' id='spouseCodeUpd'>");
            $("#spouseCodeUpd").val($("#spouseCode").val());
        });

        document.getElementById("spouseName").addEventListener("input", function() {
        // $('#spouseName').change(function() {
            $("#spouseNameUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='spouseNameUpd' id='spouseNameUpd'>");
            $("#spouseNameUpd").val($("#spouseName").val());
        });

        document.getElementById("spouseNric").addEventListener("input", function() {
        // $('#spouseNric').change(function() {
            $("#spouseNricUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='spouseNricUpd' id='spouseNricUpd'>");
            $("#spouseNricUpd").val($("#spouseNric").val());
        });

        document.getElementById("spouseOcc").addEventListener("input", function() {
        // $('#spouseOcc').change(function() {
            $("#spouseOccUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='spouseOccUpd' id='spouseOccUpd'>");
            $("#spouseOccUpd").val($("#spouseOcc").val());
        });

        document.getElementById("spouseDob").addEventListener("input", function() {
        // $('#spouseDob').change(function() {
            $("#spouseDobUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='spouseDobUpd' id='spouseDobUpd'>");
            $("#spouseDobUpd").val($("#spouseDob").val());
        });

        document.getElementById("spouseContat").addEventListener("input", function() {
        // $('#spouseContat').change(function() {
            $("#spouseContatUpd").remove();
            $("#memberUpdForm").append("<input type='hidden' name='spouseContatUpd' id='spouseContatUpd'>");
            $("#spouseContatUpd").val($("#spouseContat").val());
        });
        // Spouse Tab on change append - end

        $("#hsptlzCheck").change(function() {
        	if($("#hsptlzCheck").is(":checked") == true){
        		$('input:radio[name="mobileUseYn"][value="N"]').prop('checked', true);
        		$('#mobileUseYn').val("N");
        		$('#mobileUseYn').change();
            }else{
                $('input:radio[name="mobileUseYn"][value="Y"]').prop('checked', true);
                $('#mobileUseYn').val("Y");
                $('#mobileUseYn').change();
            }
        });
    }

    // Address Tab on change append - start
    $('#areaId').change(function() {
        $("#areaIdUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='areaIdUpd' id='areaIdUpd'>");
        $("#areaIdUpd").val($("#areaId").val());
    });

    $('#addrDtl').change(function() {
        $("#addrDtlUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='addrDtlUpd' id='addrDtlUpd'>");
        $("#addrDtlUpd").val($("#addrDtl").val());
    });

    $('#streetDtl').change(function() {
        $("#streetDtlUpd").remove();
        $("#memberUpdForm").append("<input type='hidden' name='streetDtlUpd' id='streetDtlUpd'>");
        $("#streetDtlUpd").val($("#streetDtl").val());
    });
    // AddressTab on change append - end

});

function fn_getMemInfo(){
	$("#memberType").attr("disabled",false);
    Common.ajax("GET", "/organization/getMemberListMemberView", $("#memberAddForm").serialize(), function(result) {
        console.log("fn_setMemInfo.");
        console.log(result);
        if(result != null ){
        	fn_setMemInfo(result[0]);
        	console.log(result[0]);
        }else{
        	console.log("========result null=========");
        }
    });
    $("#memberType").attr("disabled",true);
}

function fn_setMemInfo(data){
	console.log("fn_setMemInfo");

	// Not HP
	if(data.isHP == "NO"){
		$("#memberType option[value="+ data.memType +"]").attr("selected", true);
		console.log("1 : " +data.memType);
		fn_departmentCode(data.memType);

		var jsonObj;
		if(data.memType != "4" && data.memType != "6185") {
		    jsonObj = GridCommon.getEditData(myGridID_Doc);
		}

		if(data.gender=="F"){
	        $("#gender_f").prop("checked", true)
	    }
	    if(data.gender=="M"){
	        $("#gender_m").prop("checked", true)
	    }

	    $("#cmbInitials").val(data.emrgcyCntcInit);

	    $("#cmbRace option[value="+ data.c61 +"]").attr("selected", true);

	    $("#nric").val(data.nric);

	    $("#fullName").val(data.c65);

	    $("#marrital option[value="+ data.c27 +"]").attr("selected", true);

	    $("#memEmail").val(data.email);

	    $("#mobileNo").val(data.telMobile);

	    $("#officeNo").val(data.telOffice);

	    $("#residenceNo").val(data.telHuse);

	    $("#sponsorCd").val(data.c51);

	    $("#sponsorNm").val(data.c52);

	    $("#sponsorNric").val(data.c53);
	    //alert(data.c68);
	    $("#searchSt").val(data.area);

	    $("#areaId").val(data.areaId);

	    if(data.areaId!=null&&jQuery.trim(data.areaId).length>0){
	    	Common.ajax("GET", "/organization/selectAreaInfo.do", {areaId : data.areaId}, function(result) {

	            fn_addMaddr(result.area, result.city, result.postcode, result.state, result.areaId, result.iso);

	       });
	    }

	    /*
	    if(data.c4!=null&&jQuery.trim(data.c4).length>0){
	        $("#branch option[value="+ data.c4 +"]").attr("selected", true);
	    }
	    */
	    if(data.c41!=null&&jQuery.trim(data.c41).length>0){
	        $("#deptCd option[value="+ data.c41 +"]").attr("selected", true);
	    }

	    if(data.c62!=null&&jQuery.trim(data.c62).length>0){
	        //$("#transportCd option[value="+ data.c62 +"]").attr("selected", true);
	        doGetCombo('/common/selectCodeList.do', '7', data.c62,'transportCd', 'S' , '');
	    }

	    if(data.bank!=null&&jQuery.trim(data.bank).length>0){
	        $("#issuedBank option[value="+ data.bank +"]").attr("selected", true);
	    }

	    $("#bankAccNo").val(data.bankAccNo);

	    if(data.c8!=null&&jQuery.trim(data.c8).length>0){
	        $("#educationLvl option[value="+ data.c8 +"]").attr("selected", true);
	    }

	    if(data.c10!=null&&jQuery.trim(data.c10).length>0){
	        $("#language option[value="+ data.c10 +"]").attr("selected", true);
	    }

	    if(data.religion!=null&&jQuery.trim(data.religion).length>0){
	        $("#religion option[value="+ data.religion +"]").attr("selected", true);
	    }

	    $("#trNo").val(data.trNo);

	    $("#userId").val(data.c64);

	    //$("#searchdepartment option[value='"+ data.mainDept +"']").attr("selected", true);

	    //$("#inputSubDept option[value='"+ data.subDept +"']").attr("selected", true);

	    //$("#course option[value='"+ data.course +"']").attr("selected", true); //20-10-2021 - HLTANG - close for LMS project

	    $("#selectBranch option[value='"+ data.c3 +"']").attr("selected", true);

	    // If member type = staff/temporary staff code
	    if("${memType}" == "4" || "${memType}" == "6185") {
	        $("#searchdepartment").empty();
	        $("#searchdepartmentLbl").append("<span class='must'>*</span>");

	        $("#inputSubDept").empty();
	        $("#inputSubDept").remove();

	        Common.ajax("GET", "/common/userManagement/getDeptList.do", "branchId=" + data.c3, function(bData, textStatus, jqXHR) {
	            $("#searchdepartment").append("<option value=''>Choose One</option>");
	            console.log("getDeptList");

	            for(var i = 0; i < bData.length; i++) {
	                if(data.deptId == bData[i].codeId) {
	                    $("#searchdepartment").append("<option value='"+bData[i].codeId+"' selected>" + bData[i].codeName + "</option>");
	                } else {
	                    $("#searchdepartment").append("<option value='"+bData[i].codeId+"'>" + bData[i].codeName + "</option>");
	                }
	            }
	        }, function(jqXHR, textStatus, errorThrown) { // Error
	            alert("Fail : " + jqXHR.responseJSON.message);
	        });
	    }

	    $("#meetingPoint option[value=" + data.meetpointId +"]").attr("selected", true);

	    // Cody organization & trainee check for invalid empty email - Enhancement Cody Support : Mandatory Email Address Key In
	    if("${memType}" == "2" || "${memType}" == "5") {

          $('#emailLbl').append("<span class='must'>*</span>");
	    }

    }
	else{
		  $("#memberType option[value="+ data.memType +"]").attr("selected", true);
	        console.log("1 : " +data.memType);
	        fn_departmentCode(data.memType);

	        $("#memberNm").val(data.memName);
	        $("#nric").val(data.nric);

	        if(data.gender=="F"){
	            $("#gender_f").prop("checked", true)
	        }
	        if(data.gender=="M"){
	            $("#gender_m").prop("checked", true)
	        }

	        $("#memEmail").val(data.email);

	        $("#mobileNo").val(data.telMobile);

	        $("#officeNo").val(data.telOffice);

	        $("#sponsorCd").val(data.sponCd);

	        $("#residenceNo").val(data.telHuse);

	        if(data.bank !=null){
	            $("#issuedBank option[value="+ data.bank +"]").attr("selected", true);
	            $("#issuedBank").val(data.bank);
	         }

	        $("#marrital option[value="+ data.marrital +"]").attr("selected", true);
	        $("#cmbRace").val(data.aplicntRace);
	        $("#bankAccNo").val(data.bankAccNo);
	        $("#statusID").val(data.stusId);

	}

    //doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');

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

    }

    ];
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

    usePaging : true, // 페이징 사용
    pageRowCount : 20, // 한 화면에 출력되는 행 개수 20(기본값:20)
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true, // 그룹핑 패널 사용
    skipReadonlyColumns : true, // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    wrapSelectionMove : true, // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    showRowNumColumn : false, // 줄번호 칼럼 렌더러 출력

};

//Validation Check
function fn_saveValidation(){
	var message = "";
	var action = $("#memType").val();
	var valid = true;
	var defaultDate = new Date("01/01/1900");
	var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

	//region Check Basic Info
	/*
    if (dpUserValidDate.SelectedDate < DateTime.Now.Date)
    {
        valid = false;
        message += "* Please select equal or bigger than today date.<br />";
    }
	*/
	$("#memberTypeUpd").remove();
    $("#memberUpdForm").append("<input type='hidden' name='memberTypeUpd' id='memberTypeUpd'>");
    $("#memberTypeUpd").val($("#memberType").val());

    $("#MemberIDUpd").remove();
    $("#memberUpdForm").append("<input type='hidden' name='MemberIDUpd' id='MemberIDUpd'>");
    $("#MemberIDUpd").val($("#MemberID").val());

	if($("#joinDate").val() == ''){
        valid = false;
        message += "* Please select joined date.<br/>";
    }
	if($("#memberNm").val() == ''){
        valid = false;
        message += "* Please key in member name.<br/>";
    }
	if($("#national").val() == ''){
        valid = false;
        message += "* Please select the nationality.<br/>";
    }
	/* if($("#nric").val() == ''){
        valid = false;
        message += "* Please key in the NRIC.<br/> ";
    } */
    //else
    //{
    //    if (this.IsExistingMember())
    //    {
    //        valid = false;
    //        message += "* This is existing member.<br/>";
    //    }
    //}
	if($('input[name=gender]:checked', '#memberAddForm').val() == null){
        valid = false;
        message += "* Please select gender.<br/> ";
    }
	if($("#cmbRace").val() == ''){
        valid = false;
        message += "* Please select race.<br/> ";
    }
	//if($("#marrital").index(this) <=-1){
	if($("#marrital").val()==""){
        valid = false;
        message += "* Please select marrital.<br/> ";
    }
    if ($("#Birth").val() == ""){
        valid = false;
        message += "* Please select DOB.<br/>";
    }
    else
    {
        var DOBDate = new Date();
        var d = new Date();
        DOBDate = $("#Birth").val() == "" ? defaultDate : new Date($("#Birth").val());
        if ($("#Birth").val() == "")
        {
            var Age = d.getFullYear() - DOBDate.getFullYear();
            if (Age < 18)
            {
                valid = false;
                message += "* Member must 18 years old and above.<br/>";
            }
            if (DOBDate==$("#nric").val().substring(0, 6))
            {
                valid = false;
                message += "* The NRIC is mismatch with member's DOB.<br/>";
            }
        }
    }
    //endregion

    //region Check Address
    /*
    if (string.IsNullOrEmpty(txtMemAdd1.Text.Trim()) &&
        string.IsNullOrEmpty(txtMemAdd2.Text.Trim()) &&
        string.IsNullOrEmpty(txtMemAdd3.Text.Trim()))
    {
        valid = false;
        message += "* Please key in the address.<br />";
    }
    */
    if ($("#mCountry").val() == "")
    {
        valid = false;
        message += "* Please select the country.<br/>";
    }
    else
    {
    	if ($("#mCountry").val() != "")  //mState
        {
    		if ($("#mState").val() == "") //mArea
            {
    			valid = false;
                message += "* Please select the state.<br/>";
            }
    		if ($("#mArea").val() == "")  //mPostCd
            {
                valid = false;
                message += "* Please select the area.<br/>";
            }
    		if ($("#mPostCd").val() == "")
            {
                valid = false;
                message += "* Please select the postcode.<br/>";
            }
        }
    }

    if($("#areaId").val() == ''){
        message += "* Please key in the address.<br/>";
        valid = false;
    }
    //endregion

    //region Check Phone No
    if (!(jQuery.trim($("#mobileNo").val()).length>0) &&
        !(jQuery.trim($("#officeNo").val()).length>0) &&
        !(jQuery.trim($("#residenceNo").val()).length>0))
    {
        valid = false;
        message += "* Please key in the at least one contact no.<br/>";
    }
    else
    {
        if (jQuery.trim($("#officeNo").val()).length>0)
        {

            if(!jQuery.isNumeric(jQuery.trim($("#mobileNo").val())))
            {
                valid = false;
                message += "* Invalid telephone number (Mobile).<br/>";
            }
        }
        if ((jQuery.trim($("#officeNo").val())).length>0)
        {
        	if(!jQuery.isNumeric(jQuery.trim($("#officeNo").val())))
            {
                valid = false;
                message += "* Invalid telephone number (Office).<br/>";
            }
        }
        if ((jQuery.trim($("#residenceNo").val())).length>0)
        {
        	if(!jQuery.isNumeric(jQuery.trim($("#residenceNo").val())))
            {
                valid = false;
                message += "* Invalid telephone number (Residence).<br/>";
            }
        }
    }

    if ((jQuery.trim($("#spouseContat").val())).length>0)
    {
    	if(!jQuery.isNumeric(jQuery.trim($("#spouseContat").val())))
        {
            valid = false;
            message += "* Invalid spouse contant number.<br/>";
        }
    }
    //endregion

    //region Check Email
    if ((jQuery.trim($("#memEmail").val())).length>0)
    {
        if (!regEmail.test($("#memEmail").val()))
        {
            valid = false;
            message += "* Invalid contact person email.<br/>";
        }
    }
    //endregion

    if($("#issuedBank").val()=="")
    {
        valid = false;
        message += "* Please select the issued bank.<br/>";
    }

    if (!(jQuery.trim($("#bankAccNo").val())).length>0)
    {
        valid = false;
        message += "* Please key in the bank account no.<br/>";
    }

    //region Check Bank Account && Department && Branch && Transport
    //issuedBank
    //switch (action)
    //{
        //case "1":
        	//if($("#issuedBank").val()=="")
            //{
                //valid = false;
                //message += "* Please select the issued bank.<br/>";
            //}
            //if (!(jQuery.trim($("#bankAccNo").val())).length>0)
            //{
                //valid = false;
                //message += "* Please key in the bank account no.<br/>";
            //}

            //if (cmbMemDepCode.SelectedIndex <= -1)
            //{
            //    valid = false;
            //    message += "* Please select the department code.<br />";
            //}
            //break;
        //case "2":
        	//if($("#issuedBank").val()=="")
            //{
                //valid = false;
                //message += "* Please select the issued bank.<br/>";
            //}
        	//if (!(jQuery.trim($("#bankAccNo").val())).length>0)
            //{
                //valid = false;
                //message += "* Please key in the bank account no.<br/>";
            //}
        	/* if($("#transportCd").val()=="")
            {
                valid = false;
                message += "* Please select the transport code. \n ";
            } */

            //if (cmbMemDepCode.SelectedIndex <= -1)
            //{
            //    valid = false;
            //    message += "* Please select the department code.<br />";
            //}
            //break;
        //case "3":

            //if (cmbMemDepCode.SelectedIndex <= -1)
            //{
            //    valid = false;
            //    message += "* Please select the department code.<br />";
            //}
            //break;
        //case "4":


            //break;
        //default:
            //break;
    //}
    //endregion

    //region Document Submission
    /*
    if(action !="1"){

    }else
    {
        RadNumericTextBox RadNumtxt = new RadNumericTextBox();
        List<CodeDetail> DocSubmission = new List<CodeDetail>();
        int i = 0;
        foreach (GridDataItem dataItem in this.RadGrid_Document.MasterTableView.Items)
        {
            if ((dataItem.FindControl("chkSubmission") as RadButton).Checked)
            {
                RadNumtxt = dataItem.FindControl("txtQty") as RadNumericTextBox;
                if (RadNumtxt.Text.Trim().Equals("0") || RadNumtxt.Text.Trim().Equals(string.Empty))
                {
                    i++;
                }
            }
            else
            {
                RadNumtxt = dataItem.FindControl("txtQty") as RadNumericTextBox;
                if (RadNumtxt.Text.Trim() != "0")
                {
                    i++;
                }
            }
        }
        if (i > 0)
        {
            valid = false;
            message += "* Document submission quantity invalid. <br/>";
        }
    }
    */
    //endregion

    //region Check Cody PA Date  codyPaExpr
    if(action == "2") { //cyc 01/03/2017
    	if((jQuery.trim($("#codyPaExpr").val())).length<0) {
            valid = false;
            message = "Cody agreement PA date are compulsory";
        }

        if($("#selectBranch").val() == "" || $("#selectBranch").val() == "0") {
            valid = false;
            message = "Branch selection is compulsory";
        }
    }
    //endregion

    if(action == "4" || action == "6185") {
        if(action == "6185") {
            if($("#convStaff").is(":checked")) {
                if($("#memberCode").val() == "") {
                    valid = false;
                    message = "Staff code is required"
                }
            }
        }

        if($("#searchdepartment").val() == "") {
            valid = false;
            message = "Main department is required";
        }
    }

    // Cody organization & trainee check for invalid empty email - Enhancement Cody Support : Mandatory Email Address Key In
    if($("#memberType").val() == '2' || $("#memberType").val() == "5") {
    	if($("#memEmail").val() == "" || $("#memEmail").val() == null) {
            valid = false;
            message = "Please key in email address";
        }
    }

/*     //@AMEER add INCOME TAX
    if($("#incomeTaxNo").val().length > 0 &&  $("#incomeTaxNo").val().length < 10){
        valid = false;
        message += "* Invalid Income Tax Length.<br/>";
   } */
    var regIncTax = /^[a-zA-Z0-9]*$/;
    if (!regIncTax.test($("#incomeTaxNo").val())){
        valid = false;
        message += "* Invalid Income Tax Format.<br/>";
    }

    //Display Message
    if (!valid)
    {
        //RadWindowManager1.RadAlert("<b>" + message + "</b>", 450, 160, "Save Member Summary", "callBackFn", null);
        Common.alert(message);
    }

	return valid;
}

function fn_addrSearch(){
    if($("#searchSt").val() == ''){
        Common.alert("Please search.");
        return false;
    }
    // VER NBL [S] Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
    Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#memberAddForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
    //VER NBL [E]
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

        if($("#areaIdUpd").length > 0) {
            $("#areaIdUpd").remove();
        }

        //$("#memberUpdForm").append("<input type='hidden' name='areaIdUpd' id='areaIdUpd'>");
        //$("#areaIdUpd").val(areaid);

        $("#_searchDiv").remove();
    }else{
        Common.alert("Please check your address.");
    }
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
            console.log("getAreaId");

            $("#areaId").val(result.areaId);

            if($("#areaIdUpd").length > 0) {
                $("#areaIdUpd").remove();
            }

            $("#memberUpdForm").append("<input type='hidden' name='areaIdUpd' id='areaIdUpd'>");
            $("#areaIdUpd").val(result.areaId);

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



function fn_sponsorPop(){
    Common.popupDiv("/organization/sponsorPop.do" , $('#memberAddForm').serializeJSON(), null , true,  '_searchSponDiv'); //searchSt
}


function fn_addSponsor(msponsorCd, msponsorNm, msponsorNric) {


    $("#sponsorCd").val(msponsorCd);
    $("#sponsorNm").val(msponsorNm);
    $("#sponsorNric").val(msponsorNric);

    $("#_searchSponDiv").remove();

}

function fn_checkMobileNo() {
    if(event.keyCode == 13) {
        fmtNumber("#mobileNo");
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

    if($("#memberType").val() == "2803" || $("#memberType").val() == "1") {
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

function fn_loadAtchment(atchFileGrpId) {
    console.log("atchFileGrpId : " + atchFileGrpId);
     Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
        console.log(result);
       if(result) {
            if(result.length > 0) {
                $("#attachTd").html("");
                for ( var i = 0 ; i < result.length ; i++ ) {
                    switch (result[i].fileKeySeq){
                    case '1':
                        codyAppFileId = result[i].atchFileId;
                        codyAppFileName = result[i].atchFileName;
                        $(".input_text[id='codyAppFileTxt']").val(codyAppFileName);
                        break;
                    case '2':
                        nricCopyFileId = result[i].atchFileId;
                        nricCopyFileName = result[i].atchFileName;
                        $(".input_text[id='nricCopyFileTxt']").val(nricCopyFileName);
                        break;
                    case '3':
                        driveCopyFileId = result[i].atchFileId;
                        driveCopyFileName = result[i].atchFileName;
                        $(".input_text[id='driveCopyFileTxt']").val(driveCopyFileName);
                        break;
                    case '4':
                        bankStateCopyFileId = result[i].atchFileId;
                        bankStateCopyFileName = result[i].atchFileName;
                        $(".input_text[id='bankStateCopyFileTxt']").val(bankStateCopyFileName);
                        break;
                    case '5':
                        vaccDigCertFileId = result[i].atchFileId;
                        vaccDigCertFileName = result[i].atchFileName;
                        $(".input_text[id='vaccDigCertFileTxt']").val(vaccDigCertFileName);
                        break;
                    case '6':
                        fileNameId = result[i].atchFileId;
                        fileNameName = result[i].atchFileName;
                        $(".input_text[id='fileNameTxt']").val(fileNameName);
                        break;
                    case '7':
                        codyPaCopyFileId = result[i].atchFileId;
                        codyPaCopyFileName = result[i].atchFileName;
                        $(".input_text[id='codyPaCopyFileTxt']").val(codyPaCopyFileName);
                        break;
                    case '8':
                        compConsCodyFileId = result[i].atchFileId;
                        compConsCodyFileName = result[i].atchFileName;
                        $(".input_text[id='compConsCodyFileTxt']").val(compConsCodyFileName);
                        break;
                    case '9':
                        codyExtCheckFileId = result[i].atchFileId;
                        codyExtCheckFileName = result[i].atchFileName;
                        $(".input_text[id='codyExtCheckFileTxt']").val(codyExtCheckFileName);
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

            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);

    });
}

$(function(){
    $('#codyAppFile').change(function(evt) {
        var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(codyAppFileId);
        }else if(file.name != codyAppFileName){
            myFileCaches[1] = {file:file};
            if(codyAppFileName != ""){
                update.push(codyAppFileId);
            }
        }

        if(file != null) {
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
        }

    });

    $('#nricCopyFile').change(function(evt) {

        var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(nricCopyFileId);
        }else if(file.name != nricCopyFileName){
            myFileCaches[2] = {file:file};
            if(nricCopyFileName != ""){
                update.push(nricCopyFileId);
            }
        }

        if(file != null) {
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
        }


    });
    $('#driveCopyFile').change(function(evt) {

    	var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(driveCopyFileId);
        }else if(file.name != driveCopyFileName){
            myFileCaches[3] = {file:file};
            if(driveCopyFileName != ""){
                update.push(driveCopyFileId);
            }
        }

        if(file != null) {
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
        }

    });
    $('#bankStateCopyFile').change(function(evt) {

        var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(bankStateCopyFileId);
        }else if(file.name != bankStateCopyFileName){
            myFileCaches[4] = {file:file};
            if(bankStateCopyFileName != ""){
                update.push(bankStateCopyFileId);
            }
        }

        if(file != null) {
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
        }

    });
    $('#vaccDigCertFile').change(function(evt) {
    	var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(vaccDigCertFileId);
        }else if(file.name != vaccDigCertFileName){
            myFileCaches[5] = {file:file};
            if(vaccDigCertFileName != ""){
                update.push(vaccDigCertFileId);
            }
        }

        if(file != null) {

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
        }

    });
    $('#fileName').change(function(evt) {
        var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(fileNameId);
        }else if(file.name != fileNameName){
            myFileCaches[6] = {file:file};
            if(fileNameName != ""){
                update.push(fileNameId);
            }
        }

        if(file != null) {
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
        }

    });
    $('#codyPaCopyFile').change(function(evt) {

        var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(codyPaCopyFileId);
        }else if(file.name != codyPaCopyFileName){
            myFileCaches[7] = {file:file};
            if(codyPaCopyFileName != ""){
                update.push(codyPaCopyFileId);
            }
        }

    });
    $('#compConsCodyFile').change(function(evt) {
        var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(compConsCodyFileId);
        }else if(file.name != compConsCodyFileName){
            myFileCaches[8] = {file:file};
            if(compConsCodyFileName != ""){
                update.push(compConsCodyFileId);
            }
        }

    });
    $('#codyExtCheckFile').change(function(evt) {
        var msg = '';
        var file = evt.target.files[0];
        if(file == null) {
            remove.push(codyExtCheckFileId);
        }else if(file.name != codyExtCheckFileName){
            myFileCaches[9] = {file:file};
            if(codyExtCheckFileName != ""){
                update.push(codyExtCheckFileId);
            }
        }

    });
});

function fn_removeFile(name){
    if(name == "CAF") {
         $("#codyAppFile").val("");
         //$(".input_text[id='codyAppFileTxt']").val("");
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
    }else if(name == "CEC") {
        $("#codyExtCheckFile").val("");
        $('#codyExtCheckFile').change();
    }
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Member List - Edit Member</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form action="#" id="memberUpdForm" method="post"></form>

        <form action="#" id="memberAddForm" method="post">
            <input type="hidden" id="areaId" name="areaId" value="${memberView.areaId}">
            <input type="hidden" id="searchSt1" name="searchSt1">
            <input type="hidden" id="streetDtl1" name="streetDtl1">
            <input type="hidden" id="addrDtl1" name="addrDtl1">
            <input type="hidden" id="traineeType" name="traineeType" value="${memberView.traineeType}">
            <input type="hidden" id="memType" name="memType" value="${memType}">
            <input type="hidden"id="MemberID" name="MemberID" value="${memId}">
			<input type="hidden" id="atchFileGrpId" name="atchFileGrpId">
			<input type="hidden" id="atchFileGrpIdNew" name="atchFileGrpIdNew">
			<input type="hidden" id="atchFileId" name="atchFileId">
			<input type="hidden" id="atchFileIdNew" name="atchFileIdNew">

            <input type="hidden" value="<c:out value="${memberView.gender}"/> "  id="gender" name="gender"/>
            <input type="hidden" value="<c:out value="${memberView.memCode}"/> "  id="memCode" name="memCode"/>
            <input type="hidden" value="<c:out value="${memberView.c64}"/> "  id="userId" name="userId"/>
            <input type="hidden" value="<c:out value="${memberView.rank}"/> "  id="rank" name="rank"/>
            <input type="hidden" value="<c:out value="${memberView.c65}"/> "  id="fullName" name="fullName"/>
            <input type="hidden" value="<c:out value="${memberView.c66}"/> "  id="agrmntNo" name="agrmntNo"/>
            <input type="hidden" value="<c:out value="${memberView.c67}"/> "  id="syncChk" name="syncChk"/>
            <input type="hidden" value="<c:out value="${memberView.c35}"/> "  id="national" name="national"/>
            <input type="hidden" value="<c:out value="${memberView.c3} " /> "  id="branch" name="branch"/>
            <input type="hidden"   id="groupCode[memberLvl]" name="groupCode[memberLvl]"/>
            <input type="hidden"   id="groupCode[flag]" name="groupCode[flag]"/>

            <!-- Member Type -->
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
                            <select class="w100p" id="memberType" name="memberType">
                                <option value="1">Health Planner (HP)</option>
                                <option value="2">Coway Lady (Cody)</option>
                                <option value="3">Coway Technician (CT)</option>
                                <option value="4">Coway Staff (Staff)</option>
                                <option value="5">Trainee</option>
                                <option value="2803">HP Applicant</option>
                                <option value="7">Homecare Technician (HT)</option>
                                <option value="5758">Homecare Delivery Technician (DT)</option>
                                <option value="6185">Temporary Staff Code</option>
                                <option value="6672">Logistics Technician</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->

            <section class="tap_wrap"><!-- tap_wrap start -->
                <ul class="tap_type1 num4">
                    <li><a href="#" class="on">Basic Info</a></li>
                    <li id="spouseInfoTab"><a href="#">Spouse Info</a></li>
                    <li><a href="#">Member Address</a></li>
                    <li id="documentSubTab"><a href="#">Document Submission</a></li>
                    <li id="attachmentTab" style="display:none"><a href="#">Attachment</a></li>

                </ul>

                <!-- Basic Info -->
                <article class="tap_area">
                <!-- tap_area start -->

                    <!-- title_line start -->
                    <aside class="title_line">
                        <h2>Basic Information</h2>
                        <div id="hpNoTBB" class="right_chk">
                            <label for="noTBB">No TBB</label>
                            <input type="checkbox" id="noTBBChkbox" name="noTBBChkbox" <c:if test="${memberView.noTbb eq '1'}">checked</c:if>>
                        </div>
                    </aside>
                    <!-- title_line end -->

                    <!-- table start -->
                    <table class="type1">
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
                            <tr id="editRow1_1">
                                <th scope="row">Member Code</th>
                                <td colspan="3">
                                    <input type="text" title="" id="memberCode" placeHolder="Member Code" class="w100p" value="<c:out value="${memberView.memCode}"/>" />
                                </td>
                                <th scope="row">Convert Staff</th>
                                <td>
                                    <input type="checkbox" id="convStaff" name="convStaff" />
                                </td>
                            </tr>
                            <tr id="editRow1_2">
                                <th scope="row">Member Name<span class="must">*</span></th>
                                <td colspan="3">
                                   <input type="text" title="" id="memberNm" name="memberNm" placeholder="Member Name" class="w100p"  value="<c:out value="${memberView.name1}"/>"/>
                                </td>
                                <th scope="row">Joined Date<span class="must">*</span></th>
                                <td>
                                   <input type="text" title="Create start Date" id="joinDate" name="joinDate" placeholder="DD/MM/YYYY" class="j_date"  disabled="disabled"  value="<c:out value="${memberView.c30}"/>"/>
                                </td>
                            </tr>
                            <tr id="editRow1_3">
                                <th scope="row">Gender<span class="must">*</span></th>
                                <td>
                                    <label><input type="radio" name="gender" id="gender_m" value="M" disabled="true" /><span>Male</span></label>
                                    <label><input type="radio" name="gender" id="gender_f" value="F" disabled="true" /><span>Female</span></label>
                                </td>
                                <th scope="row">Date of Birth<span class="must">*</span></th>
                                <td>
                                   <input type="text" title="Create start Date" id="Birth" name="Birth"placeholder="DD/MM/YYYY" class="j_date" value="<c:out value="${memberView.c29}"/>" />
                                </td>
                                <th scope="row">Race<span class="must">*</span></th>
                                <td>
                                   <select class="w100p" id="cmbRace" name="cmbRace"></select>
                                </td>
                            </tr>
                            <tr id="editRow1_4">
                                <th scope="row">Nationality<span class="must">*</span></th>
                                <td>
                                    <span><c:out value="${memberView.c36} " /></span>
                                    <!--
                                    <select class="w100p" id="national" name="national"></select>
                                     -->
                                </td>
                                <th scope="row">NRIC (New)<span class="must">*</span></th>
                                <td>
                                    <input type="text" title="" placeholder="NRIC (New)" id="nric" name="nric" class="w100p" disabled="true"/>
                                </td>
                                <th scope="row">Marital Status<span class="must">*</span></th>
                                <td>
                                    <select class="w100p" id="marrital" name="marrital"></select>
                                </td>
                            </tr>

                            <!-- ADDED INCOME TAX NO @AMEER 2021-11-02 -->
                             <tr>
                                <th scope="row">Income Tax No</th>
                                <td colspan="5">
                                <input type="text" title="" placeholder="Income Tax No" class="w100p" id="incomeTaxNo"  name="incomeTaxNo"
                                onkeyup="this.value = this.value.toUpperCase();" style = "IME-MODE:disabled;" value="<c:out value="${memberView.incTax}"/>"/>
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
                            <tr id="editRow1_5">
                                <th scope="row" id="emailLbl" name="emailLbl">Email</th>
                                <td colspan="5">
                                   <input type="text" title="" placeholder="Email" class="w100p" id="memEmail" name="email" />
                                </td>
                            </tr>
                            <tr id="editRow1_6">
                                <th scope="row">Mobile No.</th>
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
                            <tr id="editRow1_7">
                                <th scope="row">Sponsor's Code</th>
                                <td>
                                   <div class="search_100p"><!-- search_100p start -->
                                       <input type="text" title="" placeholder="Sponsor's Code" class="w100p" id="sponsorCd" name="sponsorCd"/>
                                       <a href="javascript:fn_sponsorPop();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                                   </div><!-- search_100p end -->
                                </td>
                                <th scope="row">Sponsor's Name</th>
                                <td>
                                   <input type="text" title="" placeholder="Sponsor's Name" class="w100p"  id="sponsorNm" name="sponsorNm"/>
                                </td>
                                <th scope="row">Sponsor's NRIC</th>
                                <td>
                                   <input type="text" title="" placeholder="Sponsor's NRIC" class="w100p" id="sponsorNric" name="sponsorNric"/>
                                </td>
                            </tr>
                            <tr id="editRow1_8">
                                <th scope="row">Branch</th>
                                <td id="selectBranchCol">
                                    <!-- <span><c:out value="${memberView.c4} - ${memberView.c5} " /></span>-->
                                    <select class="w100p"  id="selectBranch" name="selectBranch">
                                    <option value="0">Choose One</option>
                                        <c:forEach var="list" items="${branch}" varStatus="status">
                                           <option value="${list.brnchId}">${list.branchCode} - ${list.branchName}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <!--
                                <td>
                                <select class="w100p" id="branch" name="branch">
                                </select>
                                </td>
                                -->
                                <th scope="row" id="deptCodeLbl">Department Code<span class="must">*</span></th>
                                <td id="deptCode">
                                    <%-- <c:choose>
                                        <c:when test = "${memberView.memType =='2803'}">
                                            <select class="w100p" id="deptCd" name="deptCd">
                                        </c:when>
                                        <c:otherwise>
                                            <span><c:out value="${memberView.c41}"/></span>
                                        </c:otherwise>
                                    </c:choose> --%>
                                    <span><c:out value="${memberView.c41}"/></span>
                                    <!-- <span><c:out value="${memberView.c41} - ${memberView.c22} - ${memberView.c23} "/></span> -->
                                </td>
                                <!--
                                <td>
                                <select class="w100p" id="deptCd" name="deptCd">
                                </select>
                                </td>
                                -->
                                <th scope="row" id="transportCodeLbl">Transport Code</th>
                                <td id="transportCdCol">
                                    <select class="w100p"  id="transportCd" name="transportCd"></select>
                                </td>
                            </tr>
                            <tr id="editRow1_9">
                                <th scope="row" id="meetingPointLbl">Business Area</th>
                                <td colspan="5">
                                    <select class="w100p" id="meetingPoint" name="meetingPoint"></select>
                                </td>
                            </tr>
                            <tr id="editRow1_10">
                                <th scope="row">e-Approval Status</th>
                                <td colspan="5">
                                    <input type="text" title="" placeholder="e-Approval Status" class="w100p" />
                                </td>
                            </tr>
                            <tr id="editRow1_11">
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
                                    <select class="w100p" id=statusID name=statusID>
                                        <option value="1">Active</option>
                                        <option value="44">Pending</option>
                                        <option value="5">Approved</option>
                                        <option value="6">Rejected</option>
                                    </select>
                                </td>
                            </tr>
                            <tr id="editRow1_12">
                                <!-- <th scope="row">Training Course</th> 20-10-2021 - HLTANG - close for LMS project
                                <td colspan="2">
                                    <select class="w100p" id="course" name="course">
                                </select>
                                </td> -->
                                <th scope="row">Total Vacation</th>
                                <td colspan="2">
                                    <input type="text" title="" placeholder="Total Vacation" class="w100p" />
                                </td>
                            </tr>
                            <tr id="editRow1_13">
                                <th scope="row">Application Status</th>
                                <td colspan="2">
                                    <select class="w100p">
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
                                    <input type="text" title="" placeholder="Remain Vacation" class="w100p" />
                                </td>
                            </tr>
                            <tr id="editRow1_14">
                                <th scope="row" id="searchdepartmentLbl">Main Department</th>
                                <td id="searchdepartmentcol" colspan="2">
                                    <select class="w100p" id="searchdepartment" name="searchdepartment"  >
                                        <option selected>Choose One</option>
                                        <c:forEach var="list" items="${mainDeptList}" varStatus="status">
                                            <option value="${list.deptId}">${list.deptName } </option>
                                        </c:forEach>
                                </select>
                                </td>
                                <!--
                                <th scope="row" id="subDeptLbl">Sub Department</th>
                                <td id="subDeptLblCol" colspan="2">
                                    <select class="w100p" id="inputSubDept" name="inputSubDept">
                                        <option selected>Choose One</option>
                                        <c:forEach var="list" items="${subDeptList}" varStatus="status">
                                            <option value="${list.codeId}">${list.codeName } </option>
                                        </c:forEach>
                                    </select>
                                </td>
                                 -->
                            </tr>
                            <tr id="editRow1_15">
                                <th scope="row">Businesses Type</th>
                                <td>
                                    <select class="w100p" id="businessType" name="businessType"></select>
                                </td>
                                <th scope="row">Hospitalization</th>
                                <td>
                                    <span><input type="checkbox" id="hsptlzCheck" name="hsptlzCheck" disabled = "disabled"
                                        <c:if test="${memberView.hsptlz eq '1'}">checked</c:if>/>
                                    </span>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr id="trMobileUseYn">
                                <th scope="row">Mobile App</th>
                                <td colspan="4">
                                    <label><input type="radio" name="mobileUseYn" id="mobileUseYn" value="Y" <c:if test="${memberView.mobileUseYn eq 'Y'}">checked</c:if>/><span>Use</span></label>
                                    <label><input type="radio" name="mobileUseYn" id="mobileUseYn" value="N" <c:if test="${memberView.mobileUseYn eq 'N'}">checked</c:if>/><span>Unused</span></label>
                                </td>
                            </tr>
                        </tbody>
                    </table><!-- table end -->

                    <!-- title_line start -->
                    <aside class="title_line">
                        <h2>Bank Account Information</h2>
                    </aside>
                    <!-- title_line end -->

                    <!-- table start -->
                    <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:150px" />
                            <col style="width:*" />
                            <col style="width:180px" />
                            <col style="width:*" />
                        </colgroup>
                        <tbody>
                            <tr id="editRow1_16">
                                <th scope="row">Issued Bank<span class="must">*</span></th>
                                <td>
                                    <select class="w100p" id="issuedBank" name="issuedBank"></select>
                                </td>
                                <th scope="row">Bank Account No<span class="must">*</span></th>
                                <td>
                                    <input type="text" title="" placeholder="Bank Account No" class="w100p" id="bankAccNo"  name="bankAccNo" onKeyDown="checkBankAccNoEnter()"
                                     onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                    <!-- table end -->

                    <!-- title_line start -->
                    <aside id="languageTitle" class="title_line">
                        <h2>Language Proficiency</h2>
                    </aside>
                    <!-- title_line end -->

                    <!-- table start -->
                    <table id="languageTable" class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:150px" />
                            <col style="width:*" />
                            <col style="width:180px" />
                            <col style="width:*" />
                        </colgroup>
                        <tbody>
                            <tr id="editRow1_17">
                                <th scope="row">Education Level</th>
                                <td>
                                   <select class="w100p" id="educationLvl" name="educationLvl"></select>
                                </td>
                                <th scope="row">Language</th>
                                <td>
                                   <select class="w100p" id="language" name="language"></select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->

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
					    <th scope="row"><spring:message code="sal.text.initial"/></th>
					    <td colspan="3">
					        <select class="w100p" id="cmbInitials" name="cmbInitials"></select>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Name</th>
					    <td colspan="3">
					        <input type="text" title="" id="emergencyCntcNm" name="emergencyCntcNm" placeholder="Emergency Contact Name" class="w100p" value="<c:out value="${memberView.emrgcyCntcName}"/>"  />
					    </td>
					</tr>
					<tr>
					    <th scope="row">Contact No</th>
					    <td>
					        <input type="text" title="" placeholder="Numeric Only" class="w100p" id="emergencyCntcNo" name="emergencyCntcNo" maxlength="11" onKeyDown="fn_checkEmergencyCntcNo()"
					        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;" value="<c:out value="${memberView.emrgcyCntcNo}"/>"/>
					    </td>
					    <th scope="row">Relationship</th>
					    <td>
					        <input type="text" title="" id="emergencyCntcRelationship" name="emergencyCntcRelationship" placeholder="Relationship" class="w100p" value="<c:out value="${memberView.emrgcyCntcRltshp}"/>"/>
					    </td>
					</tr>
					</tbody>
					</table><!-- table end -->

                    <!-- title_line start -->
                    <aside id="trConsignTitle" class="title_line">
                        <h2>First TR Consign</h2>
                    </aside>
                    <!-- title_line end -->

                    <!-- table start -->
                    <table id="trConsignTable" class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:150px" />
                            <col style="width:*" />
                        </colgroup>
                        <tbody>
                            <tr id="editRow1_18">
                                <th scope="row">TR No.</th>
                                <td>
                                    <input type="text" title="" placeholder="TR No." class="w100p" id="trNo" name="trNo"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->

                    <!-- title_line start -->
                    <aside class="title_line" id="hideContentTitle">
                        <h2>Agreement</h2>
                    </aside>
                    <!-- title_line end -->

                    <!-- table start -->
                    <table class="type1" id="hideContent">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:150px" />
                            <col style="width:*" />
                        </colgroup>
                        <tbody>
                        <tr>
                            <th scope="row"  class="hideContent">Cody PA Expiry<span class="must">*</span></th>
                            <td  class="hideContent">
                               <%-- <span><span><c:out value="${PAExpired.agExprDt}"/></span></span>  --%>
                               <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="codyPaExpr" name="codyPaExpr"  value="${PAExpired.agExprDt}"/>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                    <!-- table end -->

                    <ul class="center_btns">
                        <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
                        <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
                    </ul>

                </article>
                <!-- tap_area end -->

                <!-- ================================================================ -->

                <!-- Spouse Info -->
                <!-- tap_area start -->
                <article id="spouseInfoDisplay" class="tap_area">

                    <!-- table start -->
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
                                <th scope="row">MCode</th>
                                <td>
                                    <input type="text" title="" placeholder="MCode" class="w100p" id="spouseCode" name="spouseCode"  value="<c:out value="${memberView.spouseCode}"/>"/>
                                </td>
                                <th scope="row">Spouse Name</th>
                                <td>
                                    <input type="text" title="" placeholder="Spouse Nam" class="w100p" id="spouseName" name="spouseName" value="<c:out value="${memberView.spouseName}"/>"/>
                                </td>
                                <th scope="row">NRIC / Passport No.</th>
                                <td>
                                    <input type="text" title="" placeholder="NRIC / Passport No." class="w100p" id="spouseNric" name="spouseNric" value="<c:out value="${memberView.spouseNric}"/>" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Occupation</th>
                                <td>
                                    <input type="text" title="" placeholder="Occupation" class="w100p" id="spouseOcc" value="<c:out value="${memberView.spouseOcpat}"/>" />
                                </td>
                                <th scope="row">Date of Birth</th>
                                <td>
                                    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="spouseDob" name="spouseDob" value="<c:out value="${memberView.c58}"/>" />
                                </td>
                                <th scope="row">Contact No.</th>
                                <td>
                                    <input type="text" title="" placeholder="Contact No. (Numberic Only)" class="w100p" id="spouseContat" name="spouseContat" value="<c:out value="${memberView.spouseTelCntc}"/>" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->

                    <ul class="center_btns">
                        <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
                        <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
                    </ul>

                </article>
                <!-- tap_area end -->

                <!-- ================================================================ -->

        <!-- tap_area start -->
        <article class="tap_area">
            <!-- title_line start -->
            <aside class="title_line">
               <h2>Residential Address</h2>
            </aside>
            <!-- title_line end -->

            <form id="insAddressForm" name="insAddressForm" method="POST">

                <!-- table start -->
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
                               <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" value="<c:out value="${memberView.area}"/> "/><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" >Address Detail<span class="must">*</span></th>
                            <td colspan="3">
                               <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p" value="<c:out value="${memberView.addrDtl}"/>"  maxlength="50"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" >Street</th>
                            <td colspan="3">
                               <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Address" class="w100p" value="<c:out value="${memberView.street}"/>"  maxlength="50"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Area(4)<span class="must">*</span></th>
                            <td colspan="3">
                               <select class="w100p" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">City(2)<span class="must">*</span></th>
                            <td>
                               <select class="w100p" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
                            </td>
                            <th scope="row">PostCode(3)<span class="must">*</span></th>
                            <td>
                               <select class="w100p" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">State(1)<span class="must">*</span></th>
                            <td>
                               <select class="w100p" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
                            </td>
                            <th scope="row">Country<span class="must">*</span></th>
                            <td>
                               <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
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

                <!-- ================================================================ -->

                <!-- Document Submission -->
                <!-- tap_area start -->
                <article id="documentSubDisplay" class="tap_area">
                    <div id="grid_wrap_doc" style="width: 100%; height:430px; margin: 0 auto;"></div>

                    <ul class="center_btns">
                        <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
                        <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
                    </ul>
                </article>
                <!-- tap_area end -->

               <!-- ================================================================ -->

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
				<tr><th scope="row"></th>
				    <td  id="attachTd">
				    </td>
				</tr>
				<tr>
				    <th scope="row">Cody Application Form</th>
				    <td colspan="3" id="attachTd">
                        <div class="auto_file2">
                             <input type="file" title="file add" id="codyAppFile" accept="application/pdf"/>
                            <label>
                                <input type='text' class='input_text'  readonly='readonly' id="codyAppFileTxt"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                </label>
                              <span class='label_text'><a href='#' onclick='fn_removeFile("CAF")'>Remove</a></span>
                            </label>
                        </div>
                    </td>
				</tr>
				<tr>
				    <th scope="row">NRIC Copy</th>
				    <td colspan="3" id="attachTd">
                        <div class="auto_file2">
                             <input type="file" title="file add" id="nricCopyFile" accept="image/jpg, image/jpeg, image/png,application/pdf"/>
                            <label>
                                <input type='text' class='input_text'  readonly='readonly' id="nricCopyFileTxt"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                </label>
                              <span class='label_text'><a href='#' onclick='fn_removeFile("NRIC")'>Remove</a></span>
                            </label>
                        </div>
                    </td>
				</tr>
				<tr>
				    <th scope="row">Driving License Copy</th>
				    <td colspan="3" id="attachTd">
                        <div class="auto_file2">
                             <input type="file" title="file add" id="driveCopyFile" accept="image/jpg, image/jpeg, image/png,application/pdf"/>
                            <label>
                                <input type='text' class='input_text'  readonly='readonly' id="driveCopyFileTxt"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                </label>
                              <span class='label_text'><a href='#' onclick='fn_removeFile("DLC")'>Remove</a></span>
                            </label>
                        </div>
                    </td>
				</tr>
				<tr>
				    <th scope="row">Bank Passbook / Statement Copy</th>
				    <td colspan="3" id="attachTd">
                        <div class="auto_file2">
                             <input type="file" title="file add" id="bankStateCopyFile" accept="image/jpg, image/jpeg, image/png,application/pdf"/>
                            <label>
                                <input type='text' class='input_text'  readonly='readonly' id="bankStateCopyFileTxt"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                </label>
                              <span class='label_text'><a href='#' onclick='fn_removeFile("BPSC")'>Remove</a></span>
                            </label>
                        </div>
                    </td>
				</tr>
				<tr>
				    <th scope="row">Vaccination Digital Certificate</th>
				    <td colspan="3" id="attachTd">
                        <div class="auto_file2">
                             <input type="file" title="file add" id="vaccDigCertFile" accept="application/pdf" />
                            <label>
                                <input type='text' class='input_text'  readonly='readonly' id="vaccDigCertFileTxt"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                </label>
                              <span class='label_text'><a href='#' onclick='fn_removeFile("VDC")'>Remove</a></span>
                            </label>
                        </div>
                    </td>
				</tr>
				<tr>
				    <th scope="row">Passport Size Photo (white background)</th>
				    <td colspan="3" id="attachTd">
                        <div class="auto_file2">
                             <input type="file" title="file add" id="fileName" accept="image/jpg, image/jpeg"/>
                            <label>
                                <input type='text' class='input_text'  readonly='readonly' id="fileNameTxt"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                </label>
                              <span class='label_text'><a href='#' onclick='fn_removeFile("PSP")'>Remove</a></span>
                            </label>
                        </div>
                    </td>
				</tr>
				<tr>
				    <th scope="row">Cody PA Copy</th>
				    <td colspan="3" id="attachTd">
                        <div class="auto_file2">
                             <input type="file" title="file add" id="codyPaCopyFile"/>
                            <label>
                                <input type='text' class='input_text'  readonly='readonly' id="codyPaCopyFileTxt"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                </label>
                              <span class='label_text'><a href='#' onclick='fn_removeFile("CPC")'>Remove</a></span>
                            </label>
                        </div>
                    </td>
				</tr>
				<tr>
				    <th scope="row">Company Consigment Cody Item, Tools, Filter Stock, Spare part</th>
                    <td colspan="3" id="attachTd">
                        <div class="auto_file2">
                             <input type="file" title="file add" id="compConsCodyFile"/>
                            <label>
                                <input type='text' class='input_text'  readonly='readonly' id="compConsCodyFileTxt"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                </label>
                              <span class='label_text'><a href='#' onclick='fn_removeFile("CCCI")'>Remove</a></span>
                            </label>
                        </div>
                    </td>
				</tr>
				<tr>
				    <th scope="row">Cody Exit Checklist</th>
				    <td colspan="3" id="attachTd">
	                    <div class="auto_file2">
	                         <input type="file" title="file add" id="codyExtCheckFile"/>
	                        <label>
	                            <input type='text' class='input_text'  readonly='readonly' id="codyExtCheckFileTxt"/>
	                            <span class='label_text'><a href='#'>Upload</a></span>
	                            </label>
	                          <span class='label_text'><a href='#' onclick='fn_removeFile("CEC")'>Remove</a></span>
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
