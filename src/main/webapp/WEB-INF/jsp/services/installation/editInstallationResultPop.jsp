<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 24/10/2019  ONGHC  1.0.0          AMEND LAYOUT
 13/02/2020  ONGHC  1.0.1          ADD PSI FIELD
 26/02/2020  ONGHC  1.0.2          ADD LPM FIELD
 10/06/2020  ONGHC  1.0.3          Add PSI & LPM Field onblur Checking
 27/07/2020  ONGHC  1.0.4          Amend Design
 28/08/2020  FARUQ   1.0.5         Remove installation status active, add psi,lpm, volt, tds, room temp, water source temp, failParent, failChild, instChkLst
 -->
<script type="text/javaScript">

var myFileCaches = {};

var update = new Array();
var remove = new Array();
var photo1ID = 0;
var photo1Name = "";
var fileGroupKey ="";
var installAccTypeId = 582;
var installAccValues = JSON.parse("${installAccValues}");

  $(document).ready(function() {
	var today = new Date();
	var minDate = new Date(today.getFullYear(), today.getMonth(), 1);
	var pickerOpts={
	        minDate: minDate,
	        maxDate: today,
	        dateFormat: "dd/mm/yy"
	};
	$(".j_date").datepicker(pickerOpts);
	checkInstallDateDisable();

    var allcom = ${installInfo.c1};
    var istrdin = ${installInfo.c7};
    var reqsms = ${installInfo.c9};
    var stusId = ${installInfo.stusCodeId};

    if (allcom == 1) {
      $("#allwcom").prop("checked", true);
    }

    if (istrdin == 1) {
      $("#trade").prop("checked", true);
    }

    if (reqsms == 1) {
      $("#reqsms").prop("checked", true);
    }

    if (stusId == 4){
      	$("#chkInstallAcc").prop("checked", true);
      	doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
    }else{
    	$("#chkInstallAcc").prop("checked", false);
        doGetComboSepa('/common/selectCodeList.do', 0, '', '','installAcc', 'M' , 'f_multiCombo');
    }

    if("${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "54"){ // WP & POE
        $("#addInstallForm #m28").show();
        $("#ntuCom").attr("disabled", false);
    }else{
    	$("#addInstallForm #m28").hide();
        $("#ntuCom").attr("disabled", true);
    }
    doGetCombo('/services/adapterList.do', '', '${installInfo.adptUsed}','adptUsed', 'S' , '');
    doGetCombo('/services/boosterList.do', '', '${installInfo.boosterPump}','boosterPump', 'S' , '');
    doGetCombo('/services/waterSrcTypeList.do', '', '${installInfo.waterSrcType}','waterSrcType', 'S' , '');

     /*  $("#boosterPump").change(function() {
        val = $(this).val();
        //var $boosterPump = $("#boosterPump")[0];
        //$($boosterPump).empty(); //remove children
        //$("#cowayPump").hide(); //stat
        //$("#customerExternalPump").hide(); //stat
        if (val == "1") { //CodyComm_PDF.rpt
           // $("#searchForm #confirmChk").val("N");
        	$("#editInstallForm #aftPsi").hide();
            $("#editInstallForm #m12").attr("disabled", true);
        	$("#editInstallForm #aftLpm").hide();
            $("#editInstallForm #m13").attr("disabled", true);
        }
              else {
            	 $("#editInstallForm #aftPsi").show();
            	 $("#editInstallForm #m12").attr("disabled", false);
            	 $("#editInstallForm #aftLpm").show();
                 $("#editInstallForm #m13").attr("disabled", false);
            }
    }); */


    $("#installdt").change( function() {
      var checkMon = $("#installdt").val();

      var day = checkMon.substr(0,2);
      var month = Number(checkMon.substr(3,2));
      var year = checkMon.substr(6);

      var selectedDate = new Date(year,month-1,day);
      var currDate = new Date();

      if(selectedDate > currDate) {
          Common.alert("Installation Date should not be future dates");
          $("#installdt").val('');
          return;
      }

//       Common.ajax("GET", "/services/checkMonth.do?intallDate=" + checkMon, ' ', function(result) {
//         if (result.message == "Please choose this month only") {
//           Common.alert(result.message);
//           $("#installdt").val('');
//         }
//       });
    });

 // Attachment picture
    $('#attch1').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[1] != null){
            delete myFileCaches[1];
        }else if(file != null){
          myFileCaches[1] = {file:file, contentsType:"attch1"};
        }
        console.log(myFileCaches);
      });

      $('#attch2').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[2] != null){
            delete myFileCaches[2];
        }else if(file != null){
          myFileCaches[2] = {file:file, contentsType:"attch2"};
        }
        console.log(myFileCaches);
      });

      $('#attch3').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[3] != null){
            delete myFileCaches[3];
        }else if(file != null){
          myFileCaches[3] = {file:file, contentsType:"attch3"};
        }
        console.log(myFileCaches);
      });

      $('#attch4').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[4] != null){
            delete myFileCaches[4];
        }else if(file != null){
          myFileCaches[4] = {file:file, contentsType:"attch4"};
        }
        console.log(myFileCaches);
      });

      $('#attch5').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[5] != null){
            delete myFileCaches[5];
        }else if(file != null){
          myFileCaches[5] = {file:file, contentsType:"attch5"};
        }
        console.log(myFileCaches);
      });

      $('#attch6').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[6] != null){
            delete myFileCaches[6];
        }else if(file != null){
          myFileCaches[6] = {file:file, contentsType:"attch6"};
        }
        console.log(myFileCaches);
      });

      $('#attch7').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[7] != null){
            delete myFileCaches[7];
        }else if(file != null){
          myFileCaches[7] = {file:file, contentsType:"attch7"};
        }
        console.log(myFileCaches);
      });

      $('#attch8').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[8] != null){
            delete myFileCaches[8];
        }else if(file != null){
          myFileCaches[8] = {file:file, contentsType:"attch8"};
        }
        console.log(myFileCaches);
      });

      $('#attch9').change(function(evt) {
          var file = evt.target.files[0];
          if(file == null && myFileCaches[9] != null){
              delete myFileCaches[9];
          }else if(file != null){
            myFileCaches[9] = {file:file, contentsType:"attch9"};
          }
          console.log(myFileCaches);
        });

 // ONGHC - 20200221 ADD FOR PSI
    // 54 - WP
    // 57 - SOFTENER
    // 58 - BIDET
    // 400 - POE
    if ("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56") {

    	// ALEX - 20200911 ADD ADDITIONAL COLUMN - boosterPump for all 4 categery

    	$("#editInstallForm #m11").show();
        $("#boosterPump").attr("disabled", false);
        $("#editInstallForm #m12").show();
        $("#aftPsi").attr("disabled", false);
        $("#editInstallForm #m13").show();
        $("#aftLpm").attr("disabled", false);


    	if ("${orderInfo.stkCtgryId}" != "54") {
        $("#editInstallForm #m4").show();
        $("#psiRcd").attr("disabled", false);
        $("#m5").show();
        $("#lpmRcd").attr("disabled", false);
        $("#m6").hide();
        $("#volt").attr("disabled", true);
        $("#m7").hide();
        $("#tds").attr("disabled", true);
        $("#m8").hide();
        $("#roomTemp").attr("disabled", true);
        $("#m9").hide();
        $("#waterSourceTemp").attr("disabled", true);
        $("#m10").hide();
        $("#adptUsed").attr("disabled", true);
      } else {
        $("#editInstallForm #m4").show();
        $("#editInstallForm #psiRcd").attr("disabled", false);
        $("#editInstallForm #m5").show();
        $("#editInstallForm #lpmRcd").attr("disabled", false);
        $("#editInstallForm #m6").show();
        $("#editInstallForm #volt").attr("disabled", false);
        $("#editInstallForm #m7").show();
        $("#editInstallForm #tds").attr("disabled", false);
        $("#editInstallForm #m8").show();
        $("#editInstallForm #roomTemp").attr("disabled", false);
        $("#editInstallForm #m9").show();
        $("#editInstallForm #waterSourceTemp").attr("disabled", false);
        $("#editInstallForm #m10").show();
        $("#editInstallForm #adptUsed").attr("disabled", false);
      }
    } else {
      $("#editInstallForm #m4").hide();
      $("#editInstallForm #psiRcd").attr("disabled", true);
      $("#editInstallForm #m5").hide();
      $("#editInstallForm #lpmRcd").attr("disabled", true);
      $("#editInstallForm #m6").show();
      $("#editInstallForm #volt").attr("disabled", true);
      $("#editInstallForm #m7").show();
      $("#editInstallForm #tds").attr("disabled", true);
      $("#editInstallForm #m8").show();
      $("#editInstallForm #roomTemp").attr("disabled", true);
      $("#editInstallForm #m9").show();
      $("#editInstallForm #waterSourceTemp").attr("disabled", true);
      $("#editInstallForm #m10").hide();
      $("#editInstallForm #adptUsed").attr("disabled", true);
    }
    if ("${orderInfo.stkCtgryId}" == "55"){
        notMandatoryForAP();
    }
});

function notMandatoryForAP(){
    $("#editInstallForm #m4").hide();
    $("#editInstallForm #m5").hide();
    $("#editInstallForm #m6").hide();
    $("#editInstallForm #m7").hide();
    $("#editInstallForm #m8").hide();
    $("#editInstallForm #m9").hide();
    $("#editInstallForm #m10").hide();
    $("#editInstallForm #m28").hide();
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
    var regex = /[0-9]/;
    if( !regex.test(key) ) {
      theEvent.returnValue = false;
      if(theEvent.preventDefault) theEvent.preventDefault();
    }
  }

  function validateDecimal(evt) {
     var theEvent = evt || window.event;

     // Handle paste
     if (theEvent.type === 'paste') {
         key = event.clipboardData.getData('text/plain');
     } else {
     // Handle key press
         var key = theEvent.keyCode || theEvent.which;
         key = String.fromCharCode(key);
     }
     var regex = /[0-9.]/;
     if( !regex.test(key) ) {
       theEvent.returnValue = false;
       if(theEvent.preventDefault) theEvent.preventDefault();
     }
   }

   function validate2(a) {
    var regex = /^\d+$/;
    if (!regex.test(a.value)) {
      a.value = "";
    }
   }

   function validateFloatKeyPress(el, evt) {
      var charCode = (evt.which) ? evt.which : event.keyCode;
      var number = el.value.split('.');

      if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
      }

      if(number.length>1 && charCode == 46){
        return false;
      }
      var caratPos = getSelectionStart(el);
      var dotPos = el.value.indexOf(".");
      if( caratPos > dotPos && dotPos>-1 && (number[1].length > 1)){
        return false;
      }
      return true;
  }

  function getSelectionStart(o) {
    if (o.createTextRange) {
      var r = document.selection.createRange().duplicate()
      r.moveEnd('character', o.value.length)
      if (r.text == '') return o.value.length
        return o.value.lastIndexOf(r.text)
     } else return o.selectionStart
  }

  function validate3(a) {
    // if(Math.floor(a.value)==0){
    //     a.value = "";
    //}
    if(a.value=='.'){
     a.value = "";
    }
    var regex = /^[\d.]+$/;
      if (!regex.test(a.value)) {
        a.value = "";
      }
  }

  function fn_saveInstall() {
    if (fn_validate()) {
    	 var fileGrpId = '${installInfo.atchFileGrpId}' == "" ? 0 : '${installInfo.atchFileGrpId}';
    	 console.log("fileGrpId :: " + fileGrpId);
    	 var orderVO = {
                 SalesOrderId        :  $('#hidSalesOrderId').val(),
                 hidStkId               : $('#editInstallForm #hidStkId').val().trim(),
                 resultId                :  $("#editInstallForm #resultId").val().trim(),
                 atchFileGrpId        :  fileGrpId,
                 installdt               :  $('#editInstallForm #installdt').val(),
                 installEntryId        : $('#entryId').val(),
                 InstallEntryNo       :'${installInfo.c14}'
        };

    	var formData = new FormData();

        $.each(myFileCaches, function(n, v) {
             formData.append(n, v.file);
             formData.append("atchFileGrpId", fileGrpId);
             formData.append("InstallEntryNo", '${installInfo.c14}');
             formData.append("salesOrdId", $('#hidSalesOrderId').val());
             formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
             formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        });

        Common.ajaxFile("/services/attachFileUploadEdit.do", formData, function(result) {
            var resultId = ${installInfo.resultId};
            fileGroupKey = result.data.fileGroupKey;

            $("#editInstallForm #resultId").val(resultId);
            $("#editInstallForm #fileGroupKey").val(fileGroupKey);

            if(result != 0 && result.code == 00){
                Common.ajax("POST", "/services/updateFileKey.do", orderVO, function(result) {
                        Common.alert(result.message);
                },
                function(jqXHR, textStatus, errorThrown) {
                      try {
                          Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.</b>");
                          Common.removeLoader();
                      }
                      catch (e) {
                          console.log(e);
                      }
                  });
            }else{
                  Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
           }
        },function(result){
            Common.alert("Upload Failed. Please check with System Administrator.");
        });

        // KR-OHK Serial Check add
        var url = "";

        if ($("#hidSerialRequireChkYn").val() == 'Y') {
            url = "/services/editInstallationSerial.do";
        } else {
            url = "/services/editInstallation.do";
        }

        if ($('#installdt').is(':disabled')) {
          $("#installdt").attr("disabled", false);
        }

        var saveForm = $("#editInstallForm").serializeJSON();
        saveForm.installAccList = $("#installAcc").val();

      Common.ajax("POST", url, saveForm, function(result) {
        Common.alert(result.message);
        if (result.message == "Installation result successfully updated.") {
            $("#popup_wrap").remove();
            fn_installationListSearch();
          }
      });
    }
  }

  function fn_validate() {
    var msg = "";
    if ($("#editInstallForm #installdt").val() == '') {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Actual Install Date' htmlEscape='false'/> </br>";
    }
    if ($("#editInstallForm #sirimNo").val().trim() == '' || ("#editInstallForm #sirimNo") == null) {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Sirim No' htmlEscape='false'/> </br>";
    }
    // ADDED BOOSTER PUMP
    /* if ($("#editInstallForm #boosterPump").val().trim() == '' || ("#editInstallForm #boosterPump") == null || $("#editInstallForm #boosterPump").val().trim() == '0') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Booster Pump' htmlEscape='false'/> </br>";
      }

     if ($("#editInstallForm #boosterPump").val().trim() == '6178' || $("#editInstallForm #boosterPump").val().trim() == '6179' ){

        if ($("#editInstallForm #aftPsi").val().trim() == '' || $("#editInstallForm #aftPsi") == null ){
        msg += "* <spring:message code='sys.msg.necessary' arguments='After Pump PSI' htmlEscape='false'/> </br>";
      }
        if ($("#editInstallForm #aftLpm").val().trim() == '' || $("#editInstallForm #aftLpm") == null ){
        msg += "* <spring:message code='sys.msg.necessary' arguments='After Pump LPM' htmlEscape='false'/> </br>";
      }
    } */


    if ($("#editInstallForm #serialNo").val().trim() == '' || ("#editInstallForm #serialNo") == null) {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
    }
    else {
      if ($("#editInstallForm #serialNo").val().trim().length < 9) {
        msg += "* <spring:message code='sys.msg.invalid' arguments='Serial No' htmlEscape='false'/> </br>";
      }
    }

    if($("#editInstallForm #serialNo").val().trim() != ''){
        if(!fn_AlphanumericRegexCheck($("#editInstallForm #serialNo").val())){
            msg += "* No Special Character Allowed for Serial No </br>";
        }
    }
  //stkId for kecil = 1735, petit = 298 (for testing in developmennt)
 // PSI CHECKING

/*     if ( ("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56")
    	    && !(("${installResult.installStkId}" == 1735)  ||  ("${installResult.installStkId}" == 1737))) {
       if ( $("#psiRcd").val() == "") {
        msg += "* <spring:message code='sys.msg.invalid' arguments='Water Pressure (PSI)' htmlEscape='false'/> </br>";
      }
      if ( $("#lpmRcd").val() == "") {
        msg += "* <spring:message code='sys.msg.invalid' arguments='Liter Per Minute(LPM)' htmlEscape='false'/> </br>";
      }
      if ("${orderInfo.stkCtgryId}" == "54" ){
  	   if ( $("#volt").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Voltage' htmlEscape='false'/> </br>";
        }
        if ( $("#tds").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Total Dissolved Solid (TDS)' htmlEscape='false'/> </br>";
        }
       if ( $("#roomTemp").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Room Temperature' htmlEscape='false'/> </br>";
        }
       if ( $("#waterSourceTemp").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Water Source Temperature' htmlEscape='false'/> </br>";
        }
        if ( $("#adptUsed").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Adapter Used' htmlEscape='false'/> </br>";
        }
      }
    } */

  //stkId for kecil = 1735, petit = 298 (for testing in developmennt)
    if($("#editInstallForm #hidStkId").val() == 1735){
        msg += validationForKecik();
    }

  //stkId for GLAZE = 1737
    if($("#editInstallForm #hidStkId").val() == 1737){
        msg += validationForGlaze();
    }

    if("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400"){ // WP & POE
  		if (!($("#ntuCom").val() == "" ) && !($("#ntuCom").val() > 0 && $("#ntuCom").val() <= 10 )){
  	  		msg += "* <spring:message code='sys.msg.range' arguments='NTU,0.00,10.00' htmlEscape='false'/> </br>";
    	}
    }

 // Installation Accessory checking for Complete status
    if($("#chkInstallAcc").is(":checked") && ($("#installAcc").val() == "" || $("#installAcc").val() == null)){
  	  msg += "* <spring:message code='sys.msg.invalid' arguments='Installation Accessory' htmlEscape='false'/> </br>";
    }


    if (msg != "") {
      Common.alert(msg);
      return false;
    }
    return true;
  }

  function validationForKecik(){
      var msg = "";

      if ( !($("#psiRcd").val() >=7 && $("#psiRcd").val() <=120) ) {
          msg += "* <spring:message code='sys.msg.range' arguments='Water Pressure (PSI),7,120' htmlEscape='false'/> </br>";
        }
      if (!($("#lpmRcd").val() >= 4 && $("#lpmRcd").val() <= 63)) {
        msg += "* <spring:message code='sys.msg.range' arguments='Liter Per Minute(LPM),4,63' htmlEscape='false'/> </br>";
      }
      if ( !($("#volt").val() >=200 && $("#volt").val() <=264) ) {
          msg += "* <spring:message code='sys.msg.range' arguments='Voltage,200,264' htmlEscape='false'/> </br>";
        }
      if ( $("#tds").val() ==0 ) {
          msg += "* <spring:message code='sys.msg.mustMore' arguments='Total Dissolved Solid (TDS),0' htmlEscape='false'/> </br>";
        }
      else if ( !($("#tds").val() >0 && $("#tds").val() <=300) ) {
            msg += "* <spring:message code='sys.msg.limitMore' arguments='Total Dissolved Solid (TDS),300' htmlEscape='false'/> </br>";
        }
      if (!($("#roomTemp").val() >= 4 && $("#roomTemp").val() <= 40)) {
        msg += "* <spring:message code='sys.msg.range' arguments='Room Temperature,4,40' htmlEscape='false'/> </br>";
      }
      if ( !($("#waterSourceTemp").val() >=5 && $("#waterSourceTemp").val() <=35) ) {
          msg += "* <spring:message code='sys.msg.range' arguments='Water Source Temperature,5,35' htmlEscape='false'/> </br>";
        }

      if ( $("#adptUsed").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Adapter Used' htmlEscape='false'/> </br>";
        }
      return msg;
  }

  function validationForGlaze(){
      var msg = "";

      if ( !($("#volt").val() >=206.8 && $("#volt").val() <=270) ) {
          msg += "* <spring:message code='sys.msg.range' arguments='Voltage,206.8,270' htmlEscape='false'/> </br>";
        }
      if ( $("#psiRcd").val() == "") {
            msg += "* <spring:message code='sys.msg.invalid' arguments='Water Pressure (PSI)' htmlEscape='false'/> </br>";
          }
      if ( $("#lpmRcd").val() == "") {
            msg += "* <spring:message code='sys.msg.invalid' arguments='Liter Per Minute(LPM)' htmlEscape='false'/> </br>";
          }
      if ( $("#tds").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Total Dissolved Solid (TDS)' htmlEscape='false'/> </br>";
        }
       if ( $("#roomTemp").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Room Temperature' htmlEscape='false'/> </br>";
        }
       if ( $("#waterSourceTemp").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Water Source Temperature' htmlEscape='false'/> </br>";
        }
      if ( $("#adptUsed").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Adapter Used' htmlEscape='false'/> </br>";
        }

      return msg;
    }

  function fn_serialSearchPop(){

	  $("#pLocationType").val('${installInfo.whLocGb}');
      $('#pLocationCode').val('${installInfo.ctWhLocId}');
      $("#pItemCodeOrName").val('${orderDetail.basicInfo.stockCode}');

      Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
  }

  function fnSerialSearchResult(data) {
      data.forEach(function(dataRow) {
          $("#editInstallForm #serialNo").val(dataRow.serialNo);
      });
  }

  function fn_removeFile(name){
      if(name == "attch1") {
         $("#attch1").val("");
         $('#attch1').change();
      }else if(name == "attch2"){
          $("#attch2").val("");
          $('#attch2').change();
      }else if(name == "attch3"){
          $("#attch3").val("");
          $('#attch3').change();
      }else if(name == "attch4"){
          $("#attch4").val("");
          $('#attch4').change();
      }else if(name == "attch5"){
          $("#attch5").val("");
          $('#attch5').change();
      }else if(name == "attch6"){
          $("#attch6").val("");
          $('#attch6').change();
      }else if(name == "attch7"){
          $("#attch7").val("");
          $('#attch7').change();
      }else if(name == "attch8"){
          $("#attch8").val("");
          $('#attch8').change();
      }else if(name == "attch9"){
          $("#attch9").val("");
          $('#attch9').change();
      }
   }

  function f_multiCombo(){
	    $(function() {
	        $('#installAcc').change(function() {
	        }).multipleSelect({
	            selectAll: false, // 전체선택
	            width: '80%'
	        }).multipleSelect("setSelects", installAccValues);
	    });
	}

  function fn_InstallAcc_CheckedChanged(_obj) {
	    if (_obj.checked) {
	        doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
	    } else {
	        doGetComboSepa('/common/selectCodeList.do', 0, '', '','installAcc', 'M' , 'f_multiCombo');
	    }
	  }

  function checkInstallDateDisable() {
	  var currentDt = new Date();
      var installDt = $("#installdt").val();

      var day = installDt.substr(0,2);
      var month = Number(installDt.substr(3,2));
      var year = installDt.substr(6);

      var currStartMonth = new Date(currentDt.getFullYear(),currentDt.getMonth(),1);
      var currSelectedDate = new Date(year,month-1,day);

      if(currSelectedDate < currStartMonth) {
    	  $("#installdt").attr("disabled", true);
      }
      else{
    	  $("#installdt").attr("disabled", false);
      }
  }

  function fn_AlphanumericRegexCheck(value){
	  var strRegex = new RegExp(/^[A-Za-z0-9]+$/);
	  return strRegex.test(value);
  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>
      <spring:message code='service.title.EditInstallationResult' />
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE' /></a></p></li>
    </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
    <!-- pop_body start -->
    <section class="tap_wrap">
      <!-- tap_wrap start -->
      <ul class="tap_type1">
        <li><a href="#" id="orderInfo" class="on"><spring:message code='sales.tap.order' /></a></li>
      </ul>
      <!-- Order Information Start -->
      <article class="tap_area">
        <!-- tap_area start -->
        <!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
        <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
        <!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
      </article>
      <!-- tap_area end -->
      <!-- Order Information End -->
      <form id="frmSearchSerial" name="frmSearchSerial" method="post">
        <input id="pGubun" name="pGubun" type="hidden" value="RADIO" /> <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" /> <input id="pLocationType" name="pLocationType" type="hidden" value="" /> <input id="pLocationCode" name="pLocationCode" type="hidden" value="" /> <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" /> <input id="pStatus" name="pStatus" type="hidden" value="" /> <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
      </form>
      <br />
      <form action="#" id="editInstallForm" method="post">
        <input type="hidden" name="hidStkId" id="hidStkId" value="${installInfo.installStkId}">
        <input type="hidden" value="<c:out value="${installInfo.resultId}"/>" id="resultId" name="resultId" />
        <input type="hidden" value="<c:out value="${installInfo.installEntryId}"/>" id="entryId" name="entryId" />
        <input type="hidden" value="<c:out value="${installInfo.serialRequireChkYn}"/>" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
        <input type="hidden" value="<c:out value="${installInfo.c14}"/>" id="hidInstallEntryNo" name="hidInstallEntryNo" />
        <input type="hidden" value="<c:out value="${orderDetail.basicInfo.ordId}"/>" id="hidSalesOrderId" name="hidSalesOrderId" />
        <input type="hidden" value="<c:out value="${installInfo.serialNo}"/>" id="hidSerialNo" name="hidSerialNo" />
        <input type="hidden" value="<c:out value="${installInfo.atchFileGrpId}"/>" id="atchFileGrpId" name="atchFileGrpId" />
        <table class="type1 mb1m">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 160px" />
            <col style="width: 350px" />
            <col style="width: 170px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='service.title.InstallationNo' /></th>
              <td>
                <span><c:out value="${installInfo.c14}" /></span>
              </td>
              <th scope="row"><spring:message code='service.title.InstallationStatus' /></th>
              <td>
                <span><c:out value="${installInfo.name}" /></span>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.Creator' /></th>
              <td>
                <span><c:out value="${installInfo.c2}" /></span>
              </td>
              <th scope="row"><spring:message code='service.title.CreateDate' /></th>
              <td>
                <span><c:out value="${installInfo.crtDt}" /></span>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.ActionCT' /></th>
              <td>
                <span><c:out value="${installInfo.c3} - ${installInfo.c4}" /></span>
              </td>
              <c:if test="${codeId == '258'}">
                <th scope="row">Before Serial</th>
                <td>
                  <span><c:out value="${orderDetail.basicInfo.exchReturnSerialNo}" /></span>
                </td>
              </c:if>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.SirimNo' /><span class="must" id="m1"> *</span></th>
              <td>
                <input type="text" id="sirimNo" name="sirimNo" class='w100p' value="<c:out value="${installInfo.sirimNo}"/>" />
              </td>
              <th scope="row"><spring:message code='service.title.SerialNo' /><span class="must" id="m2"> *</span></th>
              <td>
                <input type="text" id="serialNo" name="serialNo" class='w100p' value="<c:out value="${installInfo.serialNo}" />" />
                <c:if test="${installInfo.serialRequireChkYn == 'Y' }">
                  <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop()"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </c:if>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.RefNo' /> (1)</th>
              <td>
                <input type="text" id="refNo1" name="refNo1" class='w100p' value="<c:out value="${installInfo.docRefNo1}" />" />
              </td>
              <th scope="row"><spring:message code='service.title.RefNo' /> (2)</th>
              <td>
                <input type="text" id="refNo2" name="refNo2" class='w100p' value="<c:out value="${installInfo.docRefNo2}" />" />
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.ActualInstalledDate' /><span class="must" id="m3"> *</span></th>
              <td>
                <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" title="Create start Date" placeholder="DD/MM/YYYY" id="installdt" name="installdt" value="<c:out value="${installInfo.installDt}" />" />
              </td>
              <th scope="row"></th>
              <td></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.PSIRcd' /><span class="must" id="m4"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.PSIRcd' />" class="w100p" id="psiRcd" name="psiRcd" onkeypress='validate(event)' onblur="validate2(this)" value="<c:out value="${installInfo.psi}"/>" />
              </td>
              <th scope="row"><spring:message code='service.title.lmp' /><span class="must" id="m5"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.lmp' />" class="w100p" id="lpmRcd" name="lpmRcd" onkeypress='validate(event)' onblur="validate2(this)" value="<c:out value="${installInfo.lpm}"/>" />
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.Volt' /><span class="must" id="m6"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.Volt' />" class="w100p" id="volt" name="volt" onkeypress='validate(event)' onblur="validate2(this)" value="<c:out value="${installInfo.volt}"/>" />
              </td>
              <th scope="row"><spring:message code='service.title.TDS' /><span class="must" id="m7"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.TDS' />" class="w100p" id="tds" name="tds" onkeypress='validate(event)' onblur="validate2(this)" value="<c:out value="${installInfo.tds}"/>" />
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.RoomTemp' /><span class="must" id="m8"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.RoomTemp' />" class="w100p" id="roomTemp" name="roomTemp" onkeypress='return validateFloatKeyPress(this,event)' onblur="validate3(this)" value="<c:out value="${installInfo.roomTemp}"/>" />
              </td>
              <th scope="row"><spring:message code='service.title.WaterSourceTemp' /><span class="must" id="m9"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.WaterSourceTemp' />" class="w100p" id="waterSourceTemp" name="waterSourceTemp" onkeypress='return validateFloatKeyPress(this,event)' onblur="validate3(this)" value="<c:out value="${installInfo.waterSrcTemp}"/>" />
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.adptUsed' /><span name="m10" id="m10" class="must">*</span></th>
              <td colspan="3">
                <select class="w100p" id="adptUsed" name="adptUsed">
                  <c:forEach var="list" items="${adapterUsed}" varStatus="status">
                    <option value="${list.codeId}" selected>${list.codeName}</option>
                  </c:forEach>
                </select>
            </tr>


             <!--  /////////////////////////////////////////////// NEW ADDED COLUMN : BOOSTER PUMP //////////////////////////////////////////////////////// -->
              <tr>

             <th scope="row"><spring:message code='service.title.BoosterPump' /><span class="must" id="m11"> *</span></th>
              <td colspan="3">
                <select class="w100p" id="boosterPump" name="boosterPump">
                  <c:forEach var="list" items="${boosterUsed}" varStatus="status">
                    <option value="${list.codeId}" selected>${list.codeName}</option>
                  </c:forEach>
                       </select>
              </td>

          </tr>

          <tr>
              <th scope="row"><spring:message code='service.title.AfterPumpPsi' /><span class="must" id="m12" style="display: none;"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.AfterPumpPsi' />" class="w100p" id="aftPsi" name="aftPsi" value="<c:out value="${installInfo.aftPsi}"/>"/>
              </td>
              <th scope="row"><spring:message code='service.title.AfterPumpLpm' /><span class="must" id="m13" style="display: none;"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.AfterPumpLpm' />" class="w100p" id="aftLpm" name="aftLpm" value="<c:out value="${installInfo.aftLpm}"/>"/>
              </td>
            </tr>

            <tr>
            <th scope="row">Water Source Type<span name="m18" id="m18" class="must">*</span></th>
            <td><select class="w100p" id="waterSrcType" name="waterSrcType">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${waterSrcType}" varStatus="status">
                   <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
            </select></td>
             <th scope="row"><spring:message code='service.title.ntu'/><span id="m28" class="must">*</span></th>
           <td><input type="text" title="NTU" class="w100p" id="ntuCom" name="ntuCom" placeholder="0.00" maxlength="5" onkeypress='return validateFloatKeyPress(this,event)' onblur='validate3(this);' value="<c:out value="${installInfo.ntu}"/>" />
           </td>
          </tr>
          <tr>
           <th scope="row"><spring:message code="service.title.installation.accessories" />
          <input type="checkbox" id="chkInstallAcc" name="chkInstallAcc" onChange="fn_InstallAcc_CheckedChanged(this)"/></th>
    		<td colspan="3">
    		<select class="w100p" id="installAcc" name="installAcc">
    		</select>
    		</td>
          </tr>

          <!--  /////////////////////////////////////////////// NEW ADDED COLUMN : BOOSTER PUMP //////////////////////////////////////////////////////// -->

    <%--<tr>
            <th scope="row">Attach Picture</th>
            <td>
                <div class="auto_file2 auto_file3">
                    <input type="file" title="file add" id="photo1" accept="image/*"/>
                        <label>
                            <input type='text' class='input_text' readonly='readonly' id='photo1Txt'  value=" <c:out value="${installInfo.atchFileGrpId}"/>"/>
                            <span class='label_text'><a href='#'>Upload</a></span>
                            <!-- <span class='label_text'><a href='#' onclick='fn_removeFile("MSOFTNC")'>Remove</a></span>ATCH_FILE_GRP_ID -->
                        </label>
                </div>
            </td>
            </tr>
            <tr>
            <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span></td>
            </tr>--%>
            <tr>
              <th scope="row"><spring:message code='service.title.Remark' /></th>
              <td colspan="3">
                <textarea id="remark" name="remark" cols="5" rows="5" style="width: 100%; height: 100px"><c:out value="${installInfo.rem}" /></textarea>
              </td>
            </tr>
            <tr>
              <td colspan="4">
                <input id="allwcom" name="allwcom" type="checkbox" /> <span><spring:message code='service.btn.AllowCommission' /> ?</span> <input id="trade" name="trade" type="checkbox" /> <span><spring:message code='service.btn.IsTradeIn' /> ?</span> <input id="reqsms" name="reqsms" type="checkbox" /> <span><spring:message code='service.btn.RequiredSMS' /> ?</span>
              </td>
            </tr>
          </tbody>
        </table>

      <aside class="title_line">
        <h2>
          <spring:message code='service.text.attachment' />
         </h2>
      </aside>
      <table class="type1" id="completedHide3">
        <caption>table</caption>
        <colgroup>
          <col style="width: 130px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #1</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch1" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch1")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #2</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch2" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch2")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #3</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch3" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch3")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #4</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch4" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch4")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #5</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch5" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch5")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #6</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch6" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch6")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
            <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #7</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch7" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch7")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
            <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #8</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch8" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch8")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.text.attachment' /> #9</th>
            <td>
              <div class="auto_file2">
                <input type="file" title="" id="attch9" accept="image/*" />
                <label>
                  <input type='text' class='input_text' readonly='readonly' />
                  <span class='label_text'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch9")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
          </tr>
          <tr>
            <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span></td>
          </tr>
        </tbody>
      </table>
        <!-- table end -->
      </form>
      <br />
      <ul class="center_btns">
        <li><p class="btn_blue2"><a href="#" onclick="fn_saveInstall()"><spring:message code='service.btn.SaveInstallationResult' /></a></p></li>
      </ul>
    </section>
    <!-- pop_body end -->
    </section>
</div>
<!-- popup_wrap end -->
