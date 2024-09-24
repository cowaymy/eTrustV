<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--sw
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 25/02/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 06/03/2019  ONGHC  1.0.1          Remove Installation Status Active
 24/10/2019  ONGHC  1.0.2          Amend Sirim and Serial no checking
 26/02/2020  ONGHC  1.0.3          Add PSI & LPM Field
 10/06/2020  ONGHC  1.0.4          Add PSI & LPM Field onblur Checking
 22/07/2020  FARUQ   1.0.5         Add volt, TDS, roomTemp, WaterSoruceTemp, failParent, failChild, instChkLst
 27/07/2020  FARUQ   1.0.6         Change the label for Failed Reason to Failed Location
 28/08/2020  FARUQ   1.0.7         Add validation feature for Kecik when completed
 07/09/2020  FARUQ   1.0.8         Add validation feature for Kecik when failed
 05/10/2020  FARUQ   1.0.9         Amend the default next call date when failed
 12/03/2021  ALEX      1.0.10       Add Turbidity Level for NEO PLUS involved both COMPLETE and FAIL
 09/04/2021  H.Ding   1.1.0         Add INS AS creation for spare parts/ filters auto charge out
 25/08/2021  YONGJH 1.1.1         Add validation feature for LUCY PLUS when completed, and when failed
 -->
<script type="text/javaScript">
  var myFileCaches = {};
  var installAccTypeId = 582;

  $(document).ready(function() {
  	var today = new Date();
	var minDate = new Date(today.getFullYear(), today.getMonth(), 1);
	var pickerOpts={
	        minDate: minDate,
	        maxDate: today,
	        dateFormat: "dd/mm/yy"
	};
	$(".j_date").datepicker(pickerOpts);

    var myGridID_view;
    var instChkLst_view;
    createInstallationViewAUIGrid();
    createInstallationChkViewAUIGrid();
    createCFilterAUIGrid();
    fn_viewInstallResultSearch();
    fn_viewInstallationChkViewSearch();
    doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
    var callType = "${callType.typeId}";

      if (callType == 0) {
        $(".red_text").text("<spring:message code='service.msg.InstallationInformation'/>");
      } else {
        if (callType == 258) {
          //$(".tap_type1").li[1].text("Product Exchange Info");
        }

        if ("${orderInfo.c9}" == 21) {
          $(".red_text").text("<spring:message code='service.msg.InstallationStatus'/>");
        } else if ("${orderInfo.c9}" == 4) {
          $(".red_text").text("<spring:message code='service.msg.InstallationCompleted'/>");
        }
      }

      console.log("jomTukar: " + $("input[type='radio'][name=jomTukar]:checked").val());

      if($("input[type='radio'][name=jomTukar]:checked").val() == "Y"){
    	  $("input[type='radio'][name=competitor]").removeAttr("disabled");
    	  $("#competitor").val("Y");
    	  $("#competitorHeader").replaceWith("<th scope='row' id='competitorHeader'>Competitor Product<span class='must'>*</span></th>");
      }else{
    	  $("input[type='radio'][name=competitor]").attr('disabled', 'disabled');
    	  $("#competitor").val("");
    	  $("#competitorHeader").replaceWith("<th scope='row' id='competitorHeader'>Competitor Product</th>");
      }

      if ("${stock}" != null) {
        $("#hidActualCTMemCode").val("${stock.memCode}");
        $("#hidActualCTId").val("${stock.movToLocId}");
      } else {
        $("#hidActualCTMemCode").val("0");
        $("#hidActualCTId").val("0");
      }

      if ("${orderInfo.installEntryId}" != null) {
        $("#hidCategoryId").val("${orderInfo.stkCtgryId}");
        if (callType == 258) {
          $("#hidPromotionId").val("${orderInfo.c8}");
          $("#hidPriceId").val("${orderInfo.c11}");
          $("#hiddenOriPriceId").val("${orderInfo.c11}");
          $("#hiddenOriPrice").val("${orderInfo.c12}");
          $("#hiddenOriPV").val("${orderInfo.c13}");
          $("#hiddenProductItem").val("${orderInfo.c7}");
          $("#hidPERentAmt").val("${orderInfo.c17}");
          $("#hidPEDefRentAmt").val("${orderInfo.c18}");
          $("#hidInstallStatusCodeId").val("${orderInfo.c19}");
          $("#hidPEPreviousStatus").val("${orderInfo.c20}");
          $("#hidDocId").val("${orderInfo.docId}");
          $("#hidOldPrice").val("${orderInfo.c15}");
          $("#hidExchangeAppTypeId").val("${orderInfo.c21}");
        } else {
          $("#hidPromotionId").val("${orderInfo.c2 }");
          $("#hidPriceId").val("${orderInfo.itmPrcId}");
          $("#hiddenOriPriceId").val("${orderInfo.itmPrcId}");
          $("#hiddenOriPrice").val("${orderInfo.c5}");
          $("#hiddenOriPV").val("${orderInfo.c6}");
          $("#hiddenCatogory").val("${orderInfo.codename1}");
          $("#hiddenProductItem").val("${orderInfo.stkDesc}");
          $("#hidPERentAmt").val("${orderInfo.c7}");
          $("#hidPEDefRentAmt").val("${orderInfo.c8}");
          $("#hidInstallStatusCodeId").val("${orderInfo.c9}");
        }
      }

      if ($("#addInstallForm #installStatus").val() != "4") {
        $("#addInstallForm #failDeptChk").show();
        $("#addInstallForm #failDeptChkDesc").show();

        $("#addInstallForm #m2").hide();
        $("#addInstallForm #m4").hide();
        $("#addInstallForm #m5").hide();
        $("#addInstallForm #m8").hide();
        $("#addInstallForm #m9").hide();
        $("#addInstallForm #m10").hide();
        $("#addInstallForm #m11").hide();
        $("#addInstallForm #m12").hide();
        $("#addInstallForm #m13").hide();
        $("#addInstallForm #m14").hide();
        $("#addInstallForm #m17").hide();
        $("#addInstallForm #m24").hide();
        $("#addInstallForm #m18").hide();
        $("#addInstallForm #m28").hide();
        $("#addInstallForm #m29").hide();
        $("#ntuCom").attr("disabled", true);
        $("#ntuFail").attr("disabled", true);

        if ("${orderInfo.stkCtgryId}" != "54") {
          $("#addInstallForm #grid_wrap_instChk_view").hide();
          $("#addInstallForm #instChklstCheckBox").hide();
          $("#addInstallForm #instChklstDesc").hide();
        } else {
          $("#addInstallForm #grid_wrap_instChk_view").show();
          $("#addInstallForm #instChklstCheckBox").show();
          $("#addInstallForm #instChklstDesc").show();
        }
      } else {
        $("#addInstallForm #m8").show();
        $("#addInstallForm #m9").show();
        $("#addInstallForm #m10").show();
        $("#addInstallForm #m11").show();
        $("#addInstallForm #m12").show();
        $("#addInstallForm #m13").show();
        $("#addInstallForm #m14").show();
        $("#addInstallForm #m24").hide();
        $("#addInstallForm #m18").show();

        $("#addInstallForm #m6").hide();
        $("#addInstallForm #m7").hide();
        $("#addInstallForm #m15").hide();
        $("#addInstallForm #m16").hide();
        $("#addInstallForm #failDeptChk").hide();
        $("#addInstallForm #failDeptChkDesc").hide();

        console.log("check stkCtgryId : " + "${orderInfo.stkCtgryId}")
        if("${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "54"){ // WP & POE
            $("#addInstallForm #m28").show();
            $("#addInstallForm #m29").hide();
            $("#ntuCom").attr("disabled", false);
            $("#ntuFail").attr("disabled", true);
          }else{
        	  $("#addInstallForm #m28").hide();
              $("#addInstallForm #m29").hide();
              $("#ntuCom").attr("disabled", true);
              $("#ntuFail").attr("disabled", true);
          }

        if ("${orderInfo.stkCtgryId}" != "54") {
          $("#addInstallForm #grid_wrap_instChk_view").hide();
          $("#addInstallForm #instChklstCheckBox").hide();
          $("#addInstallForm #instChklstDesc").hide();
        } else {
          $("#addInstallForm #grid_wrap_instChk_view").show();
          $("#addInstallForm #instChklstCheckBox").show();
          $("#addInstallForm #instChklstDesc").show();
      }
     }

      $("#hiddenCustomerType").val("${customerContractInfo.typeId}");
      $("#checkCommission").prop("checked", true);
      $("#addInstallForm #installStatus").change(
          function() {
            if ($("#addInstallForm #installStatus").val() == 4) {
              $("#checkCommission").prop("checked", true);
            }
            else {
              var currDtt = new Date();
              currDtt.setDate(currDtt.getDate()+1);

              var currDt = new Date(currDtt),
              month = '' + (currDt.getMonth()+1),
              day = '' + (currDt.getDate()),
              year = currDt.getFullYear();

              if (month.length < 2){
                  month = '0' + month;
              }
              if (day.length < 2){
                  day = '0' + day;
              }

              var currentDate =  [day, month, year].join('/');
              $("#nextCallDate").val(currentDate);
              $("#checkCommission").prop("checked", false);
            }
      });

      $("#installDate").change(
        function() {
          var checkMon = $("#installDate").val();

          var day = checkMon.substr(0,2);
          var month = Number(checkMon.substr(3,2));
          var year = checkMon.substr(6);

          var selectedDate = new Date(year,month-1,day);
          var currDate = new Date();

          if(selectedDate > currDate) {
              Common.alert("Installation Date should not be future dates");
              $("#installDate").val('');
              return;
          }

//           Common.ajax("GET", "/services/checkMonth.do?intallDate="+ checkMon, ' ',
//             function(result) {
//               if (result.message == "Please choose this month only") {
//                 Common.alert(result.message);
//                 $("#installDate").val('');
//               }
//             });
       });

 	   $("#failReasonCode").change(
    	function(){
    		if("${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "54"){ // WP & POE
    			if($("#failReasonCode").val() == 8009 ){
    				$("#addInstallForm #m29").show();
    				$("#ntuFail").attr("disabled", false);
    			}else {
    				$("#addInstallForm #m29").hide();
    				$("#ntuFail").attr("disabled", true);
    				$("#ntuFail").val("0");
    			}
    		}

      });

      $("#addInstallForm #installStatus").change(
        function() {
          if ($("#addInstallForm #installStatus").val() == 4) {
            notMandatoryForAP();
            $("#addInstallForm #checkCommission").prop("checked", true);
            $("#addInstallForm #chkInstallAcc").prop("checked", true);
            doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');

            $("#addInstallForm #m6").hide();
            $("#addInstallForm #m7").hide();
            $("#addInstallForm #m15").hide();
            $("#addInstallForm #m16").hide();
            $("#addInstallForm #failDeptChk").hide();
            $("#addInstallForm #failDeptChkDesc").hide();
            $("#addInstallForm #m29").hide();
            $("#ntuFail").attr("disabled", true);
            $("#ntuFail").val("0");
            $("#addInstallForm #m2").show();
            $("#addInstallForm #m4").show();
            $("#addInstallForm #m5").show();
            $("#addInstallForm #m17").show();
            $("#addInstallForm #m18").show();
            if ("${orderInfo.stkCtgryId}" == "54") {
              $("#addInstallForm #grid_wrap_instChk_view").show();
              $("#addInstallForm #instChklstCheckBox").show();
              $("#addInstallForm #instChklstDesc").show();
              $("#addInstallForm #m28").show();
              $("#ntuCom").attr("disabled", false);
            } else if("${orderInfo.stkCtgryId}" == "400"){ // POE
              $("#addInstallForm #m28").show();
              $("#ntuCom").attr("disabled", false);
            } else {
              $("#addInstallForm #grid_wrap_instChk_view").hide();
              $("#addInstallForm #instChklstCheckBox").hide();
              $("#addInstallForm #instChklstDesc").hide();
              $("#addInstallForm #m28").hide();
              $("#ntuCom").attr("disabled", true);
              $("#ntuCom").val("0");
            }
            $("#nextCallDate").val("");

            // Added to enable "Add used parts during installation" check box. Hui Ding, 09-04-2021
            $("#chkCrtAS").prop("disabled", false);

          } else {
            notMandatoryForAP()
            $("#addInstallForm #checkCommission").prop("checked", false);
            $("#addInstallForm #chkInstallAcc").prop("checked", false);
            doGetComboSepa('/common/selectCodeList.do', 0, '', '','installAcc', 'M' , 'f_multiCombo');

            $("#addInstallForm #m2").hide();
            $("#addInstallForm #m4").hide();
            $("#addInstallForm #m5").hide();
            $("#addInstallForm #m8").hide();
            $("#addInstallForm #m9").hide();
            $("#addInstallForm #m10").hide();
            $("#addInstallForm #m11").hide();
            $("#addInstallForm #m12").hide();
            $("#addInstallForm #m13").hide();
            $("#addInstallForm #m14").hide();
            $("#addInstallForm #m17").hide();
            $("#addInstallForm #m24").hide();
            $("#addInstallForm #m18").hide();
            $("#addInstallForm #m28").hide();
            $("#addInstallForm #m29").hide();
            $("#ntuCom").attr("disabled", true);
            $("#ntuFail").attr("disabled", true);
            $("#ntuCom").val("0");
            $("#ntuFail").val("0");

            if ("${orderInfo.stkCtgryId}" == "54") {
              $("#addInstallForm #grid_wrap_instChk_view").hide();
              $("#addInstallForm #instChklstCheckBox").hide();
              $("#addInstallForm #instChklstDesc").hide();
            } else {
              $("#addInstallForm #grid_wrap_instChk_view").hide();
              $("#addInstallForm #instChklstCheckBox").hide();
              $("#addInstallForm #instChklstDesc").hide();
            }

            $("#addInstallForm #m6").show();
            $("#addInstallForm #m7").show();
            $("#addInstallForm #m15").show();
            $("#addInstallForm #m16").show();
            $("#addInstallForm #failDeptChk").show();
            $("#addInstallForm #failDeptChkDesc").show();

            var currDtt = new Date();
            currDtt.setDate(currDtt.getDate()+1);

            var currDt = new Date(currDtt),
            month = '' + (currDt.getMonth()+1),
            day = '' + (currDt.getDate()),
            year = currDt.getFullYear();
            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2)
                day = '0' + day;
            var currentDate =  [day, month, year].join('/');
            $("#nextCallDate").val(currentDate);

            // Added to enable "Add used parts during installation" check box. Hui Ding, 09-04-2021
            $("#chkCrtAS").prop("disabled", true);

          }

          $("#addInstallForm #installDate").val("");

          $("#addInstallForm #psiRcd").val("");
          $("#addInstallForm #lpmRcd").val("");
          $("#addInstallForm #volt").val("");
          $("#addInstallForm #tds").val("");
          $("#addInstallForm #roomTemp").val("");
          $("#addInstallForm #waterSourceTemp").val("");
          $("#addInstallForm #adptUsed").val("");

          $("#addInstallForm #sirimNo").val("");
          $("#addInstallForm #serialNo").val("");
          $("#addInstallForm #serialNo").val("");
          $("#addInstallForm #refNo1").val("");
          $("#addInstallForm #refNo2").val("");
          $("#addInstallForm #checkTrade").prop("checked", false);
          $("#addInstallForm #checkSms").prop("checked", false);
          $("#addInstallForm #instChklstCheckBox").prop("checked", false);
          $("#addInstallForm #failDeptChk").prop("checked", false);
          $("#addInstallForm #msgRemark").val("Remark:");
          $("#addInstallForm #failLocCde").val("");
          $("#addInstallForm #failReasonCode").val("");
          $("#addInstallForm #remark").val("");
        });

      // ONGHC - 20200221 ADD FOR PSI
      // 54 - WP
      // 57 - SOFTENER
      // 58 - BIDET
      // 400 - POE
      if ("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56") {

    	  $("#addInstallForm #m21").show();
          $("#boosterPump").attr("disabled", false);
          $("#addInstallForm #m22").show();
          $("#aftPsi").attr("disabled", false);
          $("#addInstallForm #m23").show();
          $("#aftLpm").attr("disabled", false);


        if ("${orderInfo.stkCtgryId}" != "54") {
          $("#m8").show();
          $("#psiRcd").attr("disabled", false);
          $("#m9").show();
          $("#lpmRcd").attr("disabled", false);
          $("#m10").hide();
          $("#volt").attr("disabled", true);
          $("#m11").hide();
          $("#tds").attr("disabled", true);
          $("#m12").hide();
          $("#roomTemp").attr("disabled", true);
          $("#m13").hide();
          $("#waterSourceTemp").attr("disabled", true);
          $("#m14").hide();
          $("#adptUsed").attr("disabled", true);
          $("#m24").hide();
          $("#turbLvl").attr("disabled", true);

        } else {
          $("#m8").show();
          $("#psiRcd").attr("disabled", false);
          $("#m9").show();
          $("#lpmRcd").attr("disabled", false);
          $("#m10").show();
          $("#volt").attr("disabled", false);
          $("#m11").show();
          $("#tds").attr("disabled", false);
          $("#m12").show();
          $("#roomTemp").attr("disabled", false);
          $("#m13").show();
          $("#waterSourceTemp").attr("disabled", false);
          $("#m14").show();
          $("#adptUsed").attr("disabled", false);
          $("#m24").hide();
          $("#turbLvl").attr("disabled", false);
        }
      } else {
        $("#m8").hide();
        $("#psiRcd").attr("disabled", true);
        $("#m9").hide();
        $("#lpmRcd").attr("disabled", true);
        $("#m10").show();
        $("#volt").attr("disabled", true);
        $("#m11").show();
        $("#tds").attr("disabled", true);
        $("#m12").show();
        $("#roomTemp").attr("disabled", true);
        $("#m13").show();
        $("#waterSourceTemp").attr("disabled", true);
        $("#m14").hide();
        $("#adptUsed").attr("disabled", true);
        $("#m24").hide();
        $("#turbLvl").attr("disabled", true);
      }
      if ("${orderInfo.stkCtgryId}" == "55"){
          notMandatoryForAP();
      }

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
  });

  function notMandatoryForAP(){
      $("#addInstallForm #m8").hide();
      $("#addInstallForm #m9").hide();
      $("#addInstallForm #m10").hide();
      $("#addInstallForm #m11").hide();
      $("#addInstallForm #m12").hide();
      $("#addInstallForm #m13").hide();
      $("#addInstallForm #m14").hide();
      $("#addInstallForm #m24").hide();
      $("#addInstallForm #m28").hide();
      $("#addInstallForm #m29").hide();
  }

  function fn_saveInstall() {

    var msg = "";
    /* var custMobileNo = $("#custMobileNo").val().replace(/[^0-9\.]+/g, "") ;
    var chkMobileNo = custMobileNo.substring(0, 2); */
    var url = "";

    console.log("hidSerialRequireChkYn" + $("#hidSerialRequireChkYn").val());
    if ($("#hidSerialRequireChkYn").val() == 'Y') {
      url = "/services/addInstallationSerial.do";
    } else {
      url = "/services/addInstallation_2.do";
    }

    $("#hiddenFailReasonCode").val( $("#failReasonCode option:selected").text() );

   /*  if (chkMobileNo == '60'){
        custMobileNo = custMobileNo.substring(1);
    } */
    /* $("#custMobileNo").val(custMobileNo); */

    if ($("#addInstallForm #installStatus").val() == 4) {

      // COMPLETED
      if ($("#failLocCde").val() != 0 || $("#failReasonCode").val() != 0 || $("#nextCallDate").val() != "") {
        Common.alert("Not allowed to choose a reason for fail or recall date in complete status");
        return;
      }

       if ($("#addInstallForm #installDate").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Actual Install Date' htmlEscape='false'/> </br>";
      }
      if ($("#addInstallForm #sirimNo").val().trim() == '' || ("#addInstallForm #sirimNo") == null) {
        msg += "* <spring:message code='sys.msg.necessary' arguments='SIRIM No' htmlEscape='false'/> </br>";
      }

      if($("input[type='radio'][name=jomTukar]:checked").val() == "Y"){
    	  if($("input[type='radio'][name=competitor]:checked").val() != "Y"){
    		  msg += "* <spring:message code='sys.msg.necessary' arguments='Competitor Product' htmlEscape='false'/> </br>";
    	  }
      }

      if($("input[type='radio'][name=competitor]:checked").val() == "Y"){
    	  if($("#competitorBrand").val() == ""){
    		  msg += "* <spring:message code='sys.msg.necessary' arguments='Competitor Brand' htmlEscape='false'/> </br>";
    	  }
      }

      // ADDED BOOSTER PUMP
       /*  if ($("#addInstallForm #boosterPump").val().trim() == '' || ("#addInstallForm #boosterPump") == null || $("#addInstallForm #boosterPump").val().trim() == '0') {
          msg += "* <spring:message code='sys.msg.necessary' arguments='Booster Pump' htmlEscape='false'/> </br>";
        }

       if ($("#addInstallForm #boosterPump").val().trim() == '6178' || $("#addInstallForm #boosterPump").val().trim() == '6179' ){

          if ($("#addInstallForm #aftPsi").val().trim() == '' || $("#addInstallForm #aftPsi") == null ){
          msg += "* <spring:message code='sys.msg.necessary' arguments='After Pump PSI' htmlEscape='false'/> </br>";
        }
          if ($("#addInstallForm #aftLpm").val().trim() == '' || $("#addInstallForm #aftLpm") == null ){
          msg += "* <spring:message code='sys.msg.necessary' arguments='After Pump LPM' htmlEscape='false'/> </br>";
        }
      } */

      if ($("#addInstallForm #serialNo").val().trim() == '' || ("#addInstallForm #serialNo") == null) {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
      } else {
        if ($("#addInstallForm #serialNo").val().trim().length < 9) {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Serial No' htmlEscape='false'/> </br>";
        }
      }

      if($("#addInstallForm #serialNo").val().trim() != ""){
          if(!fn_AlphanumericRegexCheck($("#addInstallForm #serialNo").val())){
              msg += "* No Special Character Allowed for Serial No </br>";
          }
      }

      if ( $("#waterSrcType").val() == "") {
          msg += "* <spring:message code='sys.msg.necessary' arguments='Water source type' htmlEscape='false'/> </br>";
        }

      //stkId for kecil = 1735, petit = 298 (for testing in developmennt)
      // PSI CHECKING
      if ( "${orderInfo.appTypeId}" != "144" && (("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56")
          && !(("${installResult.installStkId}" == 1735)  ||  ("${installResult.installStkId}" == 1737)))) {
        if ( $("#psiRcd").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Water Pressure (PSI)' htmlEscape='false'/> </br>";
        }
        if ( $("#lpmRcd").val() == "") {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Liter Per Minute(LPM)' htmlEscape='false'/> </br>";
        }
         if ("${orderInfo.stkCtgryId}" == "54") {
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
          if (!$("#instChklstCheckBox").prop('checked')) {
            msg += "* <spring:message code='sys.msg.tickCheckBox' arguments='Installation Checklist' htmlEscape='false'/> </br>";
          }

          //////////// / Condition for turbLvl - 11/03/2021 - This specific for NEO PLUS installStkId = 1845 OR  STK_CODE = 113149 ///////////892
          if ("${installResult.installStkId}" == 1845) {
        	  if ( $("#turbLvl").val() == "") {
                  msg += "* <spring:message code='sys.msg.invalid' arguments='Turbidity Level' htmlEscape='false'/> </br>";
                }
        	  else {
        	  if (($("#turbLvl").val() < 1 || $("#turbLvl").val() > 5 )) {
        	      msg += "* <spring:message code='sys.msg.range' arguments='TurbidityLevel,1,5' htmlEscape='false'/> </br>";
        	    }
        	  }
          }
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        }

         if ( $("#waterSrcType").val() == "") {
             msg += "* <spring:message code='sys.msg.necessary' arguments='Water source type' htmlEscape='false'/> </br>";
           }
      }

      //stkId for kecil = 1735, petit = 298 (for testing in developmennt)
      if("${installResult.installStkId}" == 1735 && "${orderInfo.appTypeId}" != "144"){
              msg += validationForKecikWhenCompleted();
      }

    //stkId for GLAZE = 1737
      if("${installResult.installStkId}" == 1737 && "${orderInfo.appTypeId}" != "144"){
              msg += validationForGlazeWhenCompleted();
      }

      //stkId for LUCY PLUS = 1907
      if("${installResult.installStkId}" == 1907 && "${orderInfo.appTypeId}" != "144"){
              msg += validationForLucyPlusWhenCompleted();
      }

      var addedRowItems;
      // Added for INS AS filter/ spare part list
      if ($("#chkCrtAS").prop('checked')){
    	  addedRowItems = AUIGrid.getAddedRowItems(myFltGrd10); // Filter or spare part ADD SET

    	  console.log("appointment Dt: " + $("#hidAppntDt").val());
      }

      /* if ($("#custMobileNo").val().trim() == '' && $("#chkSMS").is(":checked")) {
          msg += "* Please fill in customer mobile no </br> Kindly proceed to edit customer contact info </br>";
      } */

      if("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400"){ // WP & POE
      	if (!($("#ntuCom").val() == "" || $("#ntuCom").val() == null )){
      		if(!($("#ntuCom").val() >= 0 && $("#ntuCom").val() <= 10 )){
    	  		msg += "* <spring:message code='sys.msg.range' arguments='NTU,0.00,10.00' htmlEscape='false'/> </br>";
      		}
      	}else{
      		msg += "* <spring:message code='sys.msg.invalid' arguments='NTU' htmlEscape='false'/> </br>";
      	}
      }

      // Installation Accessory checking for Complete status
      if($("#chkInstallAcc").is(":checked") && ($("#installAcc").val() == "" || $("#installAcc").val() == null)){
    	  msg += "* <spring:message code='sys.msg.invalid' arguments='Installation Accessory' htmlEscape='false'/> </br>";
      }

      if (msg != "") {
        Common.alert(msg);
        return;
      }

      var formData = new FormData();
      var fileContentsObj = {};
      var fileContentsArr = [];
      var newfileGrpId = 0;
      var isValid = false;

      $.each(myFileCaches, function(n, v) {
          fileContentsObj = {};
          formData.append(n, v.file);
          formData.append("salesOrdId",$("#hidSalesOrderId").val());
          formData.append("InstallEntryNo",$("#hiddeninstallEntryNo").val());
          formData.append("atchFileGrpId", newfileGrpId);

          fileContentsObj = { seq : n,
                                      contentsType :v.contentsType,
                                      fileName : v.file.name};

          fileContentsArr.push(fileContentsObj);
      });

      if(fileContentsArr.length < 3){
          isValid = false;
      }else{
          isValid = true;
      }

        if(isValid == true)  {
            Common.ajaxFile("/services/attachFileUpload.do", formData, function(result) {
                if(result != 0 && result.code == 00) {
                    var saveForm = {
                              "installForm" : $("#addInstallForm").serializeJSON(),
                              "add" : addedRowItems,
                              "installAccList" : $("#installAcc").val() ,
                              "mobileYn" : "N" ,
                              "fileGroupKey": result.data.fileGroupKey
                    };

                    Common.ajax("POST", url, saveForm, function(result) {
                         Common.alert(result.message, fn_saveclose);
                         $("#popup_wrap").remove();
                         fn_installationListSearch();
                   });
                }else {
                    Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
                }
            }, function(result){
                Common.alert("Upload Failed. Please check with System Administrator.");
            });
          }else{
              Common.alert("Upload Failed. Please upload more than 2 attachment");
          }
    }

    if ($("#addInstallForm #installStatus").val() == 21) { // FAILED

        if ($("#failLocCde").val() == '') {
          msg += "* <spring:message code='sys.msg.necessary' arguments='Failed Location' htmlEscape='false'/> </br>";
        }
        if ($("#failReasonCode").val() == '') {
          msg += "* <spring:message code='sys.msg.necessary' arguments='Failed Reason' htmlEscape='false'/> </br>";
        }
        if ($("#nextCallDate").val() == '') {
          msg += "* <spring:message code='sys.msg.necessary' arguments='Next Call Date' htmlEscape='false'/> </br>";
        }

     // 8000 - Fail at Location
        if ("${orderInfo.appTypeId}" != "144" && $("#failLocCde").val() == 8000 &&("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56")) {

          //stkId for kecil = 1735, petit = 298
          if("${installResult.installStkId}" == 1735){
            msg += validationForKecikWhenFail();
          }

        //stkId for GLAZE = 1737
          if("${installResult.installStkId}" == 1737){
              msg += validationForGlazeWhenFail();
            }

        //stkId for LUCY PLUS = 1907
           if("${installResult.installStkId}" == 1907){
        	  msg += validationForLucyPlusWhenFail();
          }

          if ( $("#psiRcd").val() == "") {
            msg += "* <spring:message code='sys.msg.invalid' arguments='Water Pressure (PSI)' htmlEscape='false'/> </br>";
          }
          if ( $("#lpmRcd").val() == "") {
            msg += "* <spring:message code='sys.msg.invalid' arguments='Liter Per Minute(LPM)' htmlEscape='false'/> </br>";
          }
          if ("${orderInfo.stkCtgryId}" == "54") {
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

///////////// Condition for turbLvl - 11/03/2021 - This specific for NEO PLUS installStkId = 1845 OR  STK_CODE = 113149 ///////////892 FAIL INSTALLATION
            if("${installResult.installStkId}" == 1845){
            	if($("#failReasonCode").val() == 8018){ // IF57
            	      if( !$("#turbLvl").val() == "" ){
            	        if ($("#turbLvl").val() == 4 || $("#turbLvl").val() == 5 ) {
            	        } else{
            	          msg += "* <spring:message code='sys.msg.notInRange' arguments='Turbidity Level' htmlEscape='false'/> </br>";
            	        }
            	      }
            	      if($("#turbLvl").val() == "" ){
            	    	  msg += "* <spring:message code='sys.msg.invalid' arguments='Turbidity Level' htmlEscape='false'/> </br>";
            	      }
            	    }
              }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          }
        }
      /* if ($("#custMobileNo").val().trim() == '' && $("#chkSMS").is(":checked")) {
          msg += "* Please fill in customer mobile no </br> Kindly proceed to edit customer contact info </br>";
      } */

      if("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400"){ // WP & POE
    	if($("#failReasonCode").val() == 8009){
      		if (!($("#ntuFail").val() == "" || $("#ntuFail").val() == null )){
      			if($("#ntuFail").val() > 0 && $("#ntuFail").val() <= 10 ){
    	  			msg += "* <spring:message code='sys.msg.range' arguments='NTU,10.00,99.00' htmlEscape='false'/> </br>";
      			}
      		}else{
      			msg += "* <spring:message code='sys.msg.invalid' arguments='NTU' htmlEscape='false'/> </br>";
      		}
    	}
      }

      if (msg != "") {
        Common.alert(msg);
        return;
      }

      var formData = new FormData();
      var fileContentsObj = {};
      var fileContentsArr = [];
      var newfileGrpId = 0;

      $.each(myFileCaches, function(n, v) {
          fileContentsObj = {};
          formData.append(n, v.file);
          formData.append("salesOrdId",$("#hidSalesOrderId").val());
          formData.append("InstallEntryNo",$("#hiddeninstallEntryNo").val());
          formData.append("atchFileGrpId", newfileGrpId);

          fileContentsObj = { seq : n,
                                      contentsType :v.contentsType,
                                      fileName : v.file.name};

          fileContentsArr.push(fileContentsObj);
      });

      Common.ajaxFile("/services/attachFileUpload.do", formData, function(result) {
          if(result != 0 && result.code == 00) {
              var saveInsFailedForm = {
                        "installForm" : $("#addInstallForm").serializeJSON(),
                        "add" : addedRowItems,
                        "installAccList" : $("#installAcc").val() ,
                        "mobileYn" : "N" ,
                        "fileGroupKey": result.data.fileGroupKey
              };

              Common.ajax("POST", url, saveInsFailedForm, function(result) {
                   Common.alert(result.message, fn_saveclose);
                   $("#popup_wrap").remove();
                   fn_installationListSearch();
             });
          }else {
              Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
          }
      }, function(result){
          Common.alert("Upload Failed. Please check with System Administrator.");
      });
    }
  }

  function fn_saveclose() {
    addInstallationPopupId.remove();
  }

  function fn_viewInstallResultSearch() {
    var jsonObj = {
      installEntryId : $("#installEntryId").val()
    };

    Common.ajax("GET", "/services/viewInstallationSearch.do", jsonObj,
        function(result) {
          AUIGrid.setGridData(myGridID_view, result);
        });
  }

   function fn_viewInstallationChkViewSearch() {

    Common.ajax("GET", "/services/instChkLst.do", "",
        function(result) {
          AUIGrid.setGridData( instChkLst_view, result);
        });
  }

  function validationForKecikWhenCompleted(){
    var msg = "";

    if ( !($("#psiRcd").val() >=7 && $("#psiRcd").val() <=120) ) {
      msg += "* <spring:message code='sys.msg.range' arguments='Water Pressure (PSI),7,120' htmlEscape='false'/> </br>";
    }

    if ( !($("#lpmRcd").val() >=4 && $("#lpmRcd").val() <=63) ) {
      msg += "* <spring:message code='sys.msg.range' arguments='Liter Per Minute(LPM),4,63' htmlEscape='false'/> </br>";
    }

    if ( !($("#volt").val() >=200 && $("#volt").val() <=264) ) {
      msg += "* <spring:message code='sys.msg.range' arguments='Voltage,200,264' htmlEscape='false'/> </br>";
    }

    if ( $("#tds").val() ==0 ) {
      msg += "* <spring:message code='sys.msg.mustMore' arguments='Total Dissolved Solid (TDS),0' htmlEscape='false'/> </br>";
    } else if ( !($("#tds").val() >0 && $("#tds").val() <=300) ) {
      msg += "* <spring:message code='sys.msg.limitMore' arguments='Total Dissolved Solid (TDS),300' htmlEscape='false'/> </br>";
    }

    if (  !($("#roomTemp").val() >=4 && $("#roomTemp").val() <=40)) {
      msg += "* <spring:message code='sys.msg.range' arguments='Room Temperature,4,40' htmlEscape='false'/> </br>";
    }

    if ( !($("#waterSourceTemp").val() >=5 && $("#waterSourceTemp").val() <=35) ) {
      msg += "* <spring:message code='sys.msg.range' arguments='Water Source Temperature,5,35' htmlEscape='false'/> </br>";
    }

    if ( $("#adptUsed").val() == "") {
      msg += "* <spring:message code='sys.msg.invalid' arguments='Adapter Used' htmlEscape='false'/> </br>";
    }

    if (!$("#instChklstCheckBox").prop('checked')) {
      msg += "* <spring:message code='sys.msg.tickCheckBox' arguments='Installation Checklist' htmlEscape='false'/> </br>";
    }

    return msg;
  }

  function validationForGlazeWhenCompleted(){
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
	    if (!$("#instChklstCheckBox").prop('checked')) {
	        msg += "* <spring:message code='sys.msg.tickCheckBox' arguments='Installation Checklist' htmlEscape='false'/> </br>";
	      }
	    return msg;
	  }

  function validationForLucyPlusWhenCompleted() {
	  var msg = "";

	  if ( !($("#psiRcd").val() >=7 && $("#psiRcd").val() <=120) ) {
		    msg += "* <spring:message code='sys.msg.range' arguments='Water Pressure (PSI),7,120' htmlEscape='false'/> </br>";
      }

	  if ( !($("#volt").val() >=187 && $("#volt").val() <=264) ) {
	        msg += "* <spring:message code='sys.msg.range' arguments='Voltage,187,264' htmlEscape='false'/> </br>";
	  }

	  if ( !($("#waterSourceTemp").val() >=5 && $("#waterSourceTemp").val() <=35) ) {
		  msg += "* <spring:message code='sys.msg.range' arguments='Water Source Temperature,5,35' htmlEscape='false'/> </br>";
	  }

	  if ( !($("#roomTemp").val() <=35) ) {
	        msg += "* <spring:message code='sys.msg.LessThnEql' arguments='Room Temperature,35' htmlEscape='false'/> </br>";
	  }

      if( !$("#turbLvl").val() == "" ){
          if ( !($("#turbLvl").val() <= 5) ) {
        	msg += "* <spring:message code='sys.msg.LessThnEql' arguments='Turbidity Level,5' htmlEscape='false'/> </br>";
          }
      } else if ($("#turbLvl").val() == "" ){
            msg += "* <spring:message code='sys.msg.invalid' arguments='Turbidity Level' htmlEscape='false'/> </br>";
      }

	  return msg;
  }

  function validationForKecikWhenFail(){
    var msg = "";

    if( $("#failReasonCode").val() == 8002 || $("#failReasonCode").val() == 250 || $("#failReasonCode").val() == 1790 || $("#failReasonCode").val() == 8011) {
      if( !$("#psiRcd").val() == ""){
        if(($("#psiRcd").val() >=0 && $("#psiRcd").val() <=6 )){
        } else{
          msg += "* <spring:message code='sys.msg.notInRange' arguments='Water Pressure (PSI)' htmlEscape='false'/> </br>";
        }
      }
    }

    if($("#failReasonCode").val() == 8001){
      if( !$("#lpmRcd").val() == ""){
        if( $("#lpmRcd").val() > 63 ){
        }else{
          msg += "* <spring:message code='sys.msg.notInRange' arguments='Liter Per Minute(LPM)' htmlEscape='false'/> </br>";
        }
      }

      if( !$("#psiRcd").val() == "" ){
        if( $("#psiRcd").val() >= 0 && $("#psiRcd").val() <= 6 ){
        } else{
          msg += "* <spring:message code='sys.msg.notInRange' arguments='Water Pressure (PSI)' htmlEscape='false'/> </br>";
        }
      }
    }


    if($("#failReasonCode").val() == 8008){
      if( !$("#volt").val() == "" ){
        if ( (($("#volt").val() >= 0 && $("#volt").val() < 200) || ($("#volt").val() >= 265 && $("#volt").val() <= 299) ) && !$("#volt").val() == "" ) {
        } else{
          msg += "* <spring:message code='sys.msg.notInRange' arguments='Voltage' htmlEscape='false'/> </br>";
        }
      }
    }

    if($("#failReasonCode").val() == 8010){
      if( !$("#tds").val() == "" ){
        if ( $("#tds").val() > 300 && !$("#tds").val() == "" ) {
          } else {
            msg += "* <spring:message code='sys.msg.notInRange' arguments='Total Dissolved Solid (TDS)' htmlEscape='false'/> </br>";
          }
        }
      }

    if($("#failReasonCode").val() == 8003){
      if( !$("#lpmRcd").val() == "" ){
        if($("#lpmRcd").val() > 63 && !$("#lpmRcd").val() == ""){
        } else{
          msg += "* <spring:message code='sys.msg.notInRange' arguments='Liter Per Minute(LPM)' htmlEscape='false'/> </br>";
        }
      }
    }

    return msg;
  }

  function validationForGlazeWhenFail(){
	    var msg = "";

	    if($("#failReasonCode").val() == 8008){
	        if( !$("#volt").val() == "" ){
	          if ( (($("#volt").val() >= 0 && $("#volt").val() <= 206.79) || ($("#volt").val() >= 270) ) && !$("#volt").val() == "" ) {
	          } else{
	            msg += "* <spring:message code='sys.msg.notInRange' arguments='Voltage' htmlEscape='false'/> </br>";
	          }
	        }
	      }

	    return msg;
  }

  function validationForLucyPlusWhenFail() {
	    var msg = "";

	    if( $("#failReasonCode").val() == 8002 || $("#failReasonCode").val() == 250 || $("#failReasonCode").val() == 1790 || $("#failReasonCode").val() == 8001) {
	      if( !$("#psiRcd").val() == ""){
	        if( ($("#psiRcd").val() < 7 || $("#psiRcd").val() > 120) && !$("#psiRcd").val() == "" ){
	        } else{
	          msg += "* <spring:message code='sys.msg.notInRange' arguments='Water Pressure (PSI)' htmlEscape='false'/> </br>";
	        }
	      }
	    }

	    if($("#failReasonCode").val() == 8008){
	      if( !$("#volt").val() == "" ){
	        if ( ($("#volt").val() < 187 || $("#volt").val() > 264) && !$("#volt").val() == "" ) {
	        } else{
	          msg += "* <spring:message code='sys.msg.notInRange' arguments='Voltage' htmlEscape='false'/> </br>";
	        }
	      }
	    }

	    if($("#failReasonCode").val() == 8021) {
	      if( !$("#waterSourceTemp").val() == "" ){
	        if ( ($("#waterSourceTemp").val() < 5 || $("#waterSourceTemp").val() > 35) && !$("#waterSourceTemp").val() == "" ) {
	        } else{
	          msg += "* <spring:message code='sys.msg.notInRange' arguments='Water Source Temperature' htmlEscape='false'/> </br>";
	        }
	      }
	    }

	    if($("#failReasonCode").val() == 8022) {
	      if( !$("#roomTemp").val() == "" ) {
	        if ( $("#roomTemp").val() > 35 && !$("#roomTemp").val() == "" ) {
	        } else{
	          msg += "* <spring:message code='sys.msg.notInRange' arguments='Room Temperature' htmlEscape='false'/> </br>";
	        }
	      }
	    }

	    if($("#failReasonCode").val() == 8009){
	      if( !$("#turbLvl").val() == "" ){
	        if ( $("#turbLvl").val() > 5 && !$("#turbLvl").val() == "") {
	        } else {
	          msg += "* <spring:message code='sys.msg.notInRange' arguments='Turbidity Level' htmlEscape='false'/> </br>";
	        }
	      }
	    }

	    return msg;

  }

  function createInstallationViewAUIGrid() {
    var columnLayout = [ {
      dataField : "resultId",
      //headerText : "ID",
      headerText : '<spring:message code="service.grid.ID" />',
      editable : false,
      width : 130
    }, {
      dataField : "code",
      //headerText : "Status",
      headerText : '<spring:message code="service.grid.Status" />',
      editable : false,
      width : 180
    }, {
      dataField : "installDt",
      //headerText : "Install Date",
      headerText : '<spring:message code="service.grid.InstallDate" />',
      editable : false,
      width : 180
    }, {
      dataField : "memCode",
      //headerText : "CT Code",
      headerText : '<spring:message code="service.grid.CTCode" />',
      editable : false,
      width : 250
    }, {
      dataField : "name",
      //headerText : "CT Name",
      headerText : '<spring:message code="service.grid.CTName" />',
      editable : false,
      width : 180
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      showStateColumn : true,
      displayTreeOpen : true,
      headerHeight : 30,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : false
    };
    myGridID_view = AUIGrid.create("#grid_wrap_view", columnLayout, gridPros);
  }

  function createInstallationChkViewAUIGrid() {
    var columnLayout = [  {
      dataField : "codeDesc",
      //headerText : "Status",
      headerText : '<spring:message code="service.grid.chkLst" />',
      editable : false,
      width : 870
    } ];

    var gridPros = {
      //usePaging : true,
      pageRowCount : 20,
      editable : true,
      //showStateColumn : true,
      displayTreeOpen : true,
      headerHeight : 30,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      height : 165
    };
     instChkLst_view = AUIGrid.create("#grid_wrap_instChk_view", columnLayout, gridPros);
  }

  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false
  };

  function fn_serialSearchPop(){
    $("#pLocationType").val('${installResult.whLocGb}');
    $('#pLocationCode').val('${installResult.ctWhLocId}');
    $("#pItemCodeOrName").val('${orderDetail.basicInfo.stockCode}');
    Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
  }

  function fnSerialSearchResult(data) {
    data.forEach(function(dataRow) {
    $("#addInstallForm #serialNo").val(dataRow.serialNo);
    });
  }

  function validate(evt) {
    var theEvent = evt || window.event;

     // Handle paste
    if (theEvent.type === 'paste') {
      key = event.clipboardData.getData('text/plain');
    }
    else {
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
     }
    else {
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
      if (r.text == '') {
        return o.value.length
      }
      return o.value.lastIndexOf(r.text)
    }
    else{
      return o.selectionStart
    }
  }

  function validate3(a) {
    //if(Math.floor(a.value)==0){
    //  a.value = "0";
    //}
    if(a.value=='.'){
      a.value = "";
    }
    var regex = /^[\d.]+$/;
    if (!regex.test(a.value)) {
    a.value = "";
    }
  }

  function fn_openFailChild(selectedData){
    if(selectedData == "8000"&&("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56")) {
      $("#addInstallForm #m8").show();
      $("#addInstallForm #m9").show();
      if("${orderInfo.stkCtgryId}" == "54") {
        $("#addInstallForm #m10").show();
        $("#addInstallForm #m11").show();
        $("#addInstallForm #m12").show();
        $("#addInstallForm #m13").show();
        $("#addInstallForm #m14").hide();
        $("#addInstallForm #m24").hide();
      }
    }
    else{
      $("#addInstallForm #m8").hide();
      $("#addInstallForm #m9").hide();
      $("#addInstallForm #m10").hide();
      $("#addInstallForm #m11").hide();
      $("#addInstallForm #m12").hide();
      $("#addInstallForm #m13").hide();
      $("#addInstallForm #m14").hide();
      $("#addInstallForm #m24").hide();
    }
    if(selectedData == "8000" || selectedData == "8100"){
    $("#failReasonCode").attr("disabled",false);
    doGetCombo('/services/selectFailChild.do', selectedData, '','failReasonCode', 'S' , '');
    }
  }

  function createCFilterAUIGrid() {
	    var clayout = [
	        {
	          dataField : "filterType",
	          headerText : "<spring:message code='service.grid.ASNo'/>",
	          editable : false
	        }, {
	          dataField : "filterDesc",
	          headerText : "<spring:message code='service.grid.ASFltDesc'/>",
	          editable : false,
	          width : 250
	        }, {
	          dataField : "filterExCode",
	          headerText : "<spring:message code='service.grid.ASFltCde'/>",
	          editable : false,
	          width : 150
	        }, {
	          dataField : "filterQty",
	          headerText : "<spring:message code='service.grid.Quantity'/>",
	          editable : false,
	          width : 100
	        }, {
	          dataField : "filterPrice",
	          headerText : "<spring:message code='service.title.Price'/>",
	          editable : false,
	          width : 100
	        }, {
	          dataField : "filterTotal",
	          headerText : "<spring:message code='sal.title.total'/>",
	          editable : false,
	          width : 150
	        }, {
	          dataField : "filterRemark",
	          headerText : "<spring:message code='service.title.Remark'/>",
	          editable : false,
	          width : 150,
	          editable : false
	        }, {
	          dataField : "srvFilterLastSerial",
	          headerText : "<spring:message code='service.title.SerialNo'/>",
	          editable : false,
	          width : 200,
	          editable : true
	        }, {
	          dataField : "undefined",
	          headerText : " ",
	          width : 110,
	          renderer : {
	            type : "ButtonRenderer",
	            labelText : "<spring:message code='pay.btn.remove'/>",
	            onclick : function(rowIndex, columnIndex, value, item) {
	              AUIGrid.removeRow(myFltGrd10, rowIndex);
	            }
	          }
	        }, {
	          dataField : "filterID",
	          headerText : "<spring:message code='service.grid.FilterId'/>",
	          width : 150,
	          visible : false
	        }, {
              dataField : "stockTypeId",
              headerText : "Stock Type",
              width : 150,
              visible : true
	        } , {
	              dataField : "filterStockCode",
	              headerText : "Stock Code",
	              visible : false
	            } ];

	    var gridPros2 = {
	      usePaging : true,
	      pageRowCount : 20,
	      editable : true,
	      fixedColumnCount : 1,
	      selectionMode : "singleRow",
	      showRowNumColumn : true
	    };

	    myFltGrd10 = GridCommon.createAUIGrid("asfilter_grid_wrap", clayout, "", gridPros2);
	    AUIGrid.resize(myFltGrd10, 890, 200);
	  }


  function fn_chkCrtAS(chk){

	 // doGetComboData('/services/getInsAsFilterSPList.do?groupCode=469&stkCode=' + ${orderInfo.stkCode}, '', 'ddlFilterCode', 'ddlFilterCode', 'S', '');
	  var stkCode = ${orderInfo.stkCode};
	  console.log("chk: " + chk);
	  if (chk.checked){
		    $("#chrFee_div").attr("style", "display:block");
		    doGetComboAndGroup2('/services/getInsAsFilterSPList.do?groupCode=469&stkCode=' + stkCode , '', 'stkId', 'ddlFilterCode', 'S', 'fn_setOptGrpClass');
		    //doGetCombo('/services/getInsAsFilterSPList.do?groupCode=469&stkCode=' + stkCode , '', '', 'ddlFilterCode', 'S', '');
	  } else{
		    $("#chrFee_div").attr("style", "display:none");
		    $("#ddlFilterCode").empty();
	  }
  }

  function fn_setOptGrpClass() {
	    $("optgroup").attr("class" , "optgroup_text");
	  }

  function fn_LabourCharge_CheckedChanged(_obj) {
	    if (_obj.checked) {
	      $("#fcm1").show();
	      $('#cmbLabourChargeAmt').removeAttr("disabled").removeClass("readonly");
	      $("#cmbLabourChargeAmt").val("");
	      $("#txtLabourCharge").val("0.00");
	    } else {
	      $("#fcm1").hide();
	      $("#cmbLabourChargeAmt").val("");
	      $("#cmbLabourChargeAmt").attr("disabled", true);
	      $("#txtLabourCharge").val("0.00");
	    }

	    fn_calculateTotalCharges();
	  }

  function fn_cmbLabourChargeAmt_SelectedIndexChanged() {
	    var v = "0.00";
	    if ($("#cmbLabourChargeAmt").val() != "") {
	      v = $("#cmbLabourChargeAmt option:selected").text();
	    } else {
	      v = "0.00";
	    }
	    $("#txtLabourCharge").val(v);
	    fn_calculateTotalCharges();
  }

  function fn_calculateTotalCharges() {
	    var labourCharges = 0;
	    var filterCharges = 0;
	    var totalCharges = 0;

	    labourCharges = $("#txtLabourCharge").val();
	    filterCharges = $("#txtFilterCharge").val();
	    totalCharges = parseFloat(labourCharges) + parseFloat(filterCharges);

	    $("#txtTotalCharge").val(totalCharges.toFixed(2));
  }

  // Added parts charge out by Hui Ding, 25-03-2021
  function fn_chStock() {
    var ct = "${installResult.ctMemCode}";
    var sk = $("#ddlFilterCode").val();

    var availQty = isstckOk(ct, sk);

    if (availQty == 0) {
      Common.alert("<spring:message code='service.msg.NoStkAvl' arguments='<b>" + $("#ddlFilterCode option:selected").text()  + "</b> ; <b>" + ct + "</b>' htmlEscape='false' argumentSeparator=';' />");
      fn_filterClear();
      return false;
    } else {

      if (availQty < Number($("#ddlFilterQty").val())) {
        Common.alert("<spring:message code='service.msg.lessStkQty' arguments='<b>" + $("#ddlFilterCode option:selected").text() + "</b> ; <b>" + ct + "</b>' htmlEscape='false' argumentSeparator=';' />");
        fn_filterClear();
        return false;
      }

      // KR-OHK Serial Check
      if ($("#hidSerialRequireChkYn").val() == 'Y' && $("#hidSerialChk").val() == 'Y' && $("#ddlFilterQty").val() > 1) {
        Common.alert("For serial check items, only quantity 1 can be entered.");
        $("#ddlFilterQty").val("1");
        return false;
      }
      if ($("#hidSerialRequireChkYn").val() == 'Y' && $("#hidSerialChk").val() == 'Y' && FormUtil.isEmpty($("#ddSrvFilterLastSerial").val())) {
        var arg = "<spring:message code='service.title.SerialNo'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
        return false;
      }

      return true;
    }
  }

  function isstckOk(ct, sk) {
    // COUNT STOCK
    var availQty = 0;

    Common.ajaxSync("GET", "/services/as/getSVC_AVAILABLE_INVENTORY.do", {
      CT_CODE : ct,
      STK_CODE : sk
    }, function(result) {
      // KR-OHK Serial Check
      $("#hidSerialChk").val(result.serialChk);

      // RETURN AVAILABLE STOCK
      availQty = result.availQty;
    });

    return availQty;
  }

  function fn_filterAddVaild() {
	    var msg = "";
	    var text = "";
	    if (FormUtil.checkReqValue($("#ddlFilterCode option:selected"))) {
	      text = "<spring:message code='service.title.FilterCode'/>";
	      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
	    }
	    if (FormUtil.checkReqValue($("#ddlFilterQty option:selected"))) {
	      text = "<spring:message code='service.grid.Quantity'/>";
	      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
	    }
	    if (FormUtil.checkReqValue($("#ddlFilterPayType option:selected"))) {
	      text = "<spring:message code='service.text.asPmtTyp'/>";
	      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
	    }
	   /*  if (FormUtil.checkReqValue($("#ddlFilterExchangeCode option:selected"))) {
	      text = "<spring:message code='service.text.asExcRsn'/>";
	      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
	    } */

	    if ($("#txtLabourch").is(':checked')) {
	      if (FormUtil.checkReqValue($("#cmbLabourChargeAmt option:selected"))) {
	        text = "<spring:message code='service.text.asLbrChr'/>";
	        msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
	      }
	    }

	    if (msg != "") {
	      Common.alert(msg);
	      return false;
	    }
	  }

	  function fn_filterAdd() {
	    // CHECK AVAILABLE STOCK
	    if (fn_chStock() == false) {
	      return;
	    }

	    if (fn_filterAddVaild() == false) {
	      return false;
	    }

	    var fitem = new Object();

	    fitem.filterType = $("#ddlFilterPayType").val();
	    fitem.filterDesc = $("#ddlFilterCode option:selected").text();
	    fitem.filterExCode = 0;
	    fitem.filterQty = $("#ddlFilterQty").val();
	    fitem.filterRemark = $("#txtFilterRemark").val();
	    fitem.filterID = $("#ddlFilterCode").val();
	    fitem.srvFilterLastSerial = $("#ddSrvFilterLastSerial").val();

	    // get material's category
	   // fitem.category = $("#ddlFilterCat").val();

	    var jsonObj = {
	    	stockId : $("#ddlFilterCode").val()
	    };

	    var typeId;
	    var filStockCode;
	    Common.ajaxSync("GET", "/services/getStockCatType.do", jsonObj,
        function(result) {
          if(result != null){
        	  console.log("result.stktypeid: " + result.stktypeid);
        	  console.log("result.stkcode: " + result.stkcode);
        	  typeId = result.stktypeid;
        	  filStockCode = result.stkcode;
          }
        });

	    fitem.stockTypeId = typeId;
	    fitem.filterStockCode = filStockCode;

	    // CHECK PRICE
	    var chargePrice = 0;
	    var chargeTotalPrice = 0;

	    if (fitem.filterType == "CHG") {
	      chargePrice = getASStockPrice(fitem.filterID);
	      if (chargePrice == 0) {
	        Common.alert("<spring:message code='service.msg.stkNoPrice'/>");
	        return;
	      }
	    }

	    fitem.filterPrice = parseInt(chargePrice, 10).toFixed(2);

	    chargeTotalPrice = Number($("#ddlFilterQty").val()) * Number((chargePrice));
	    fitem.filterTotal = Number(chargeTotalPrice).toFixed(2);

	    var v = Number($("#txtFilterCharge").val()) + Number(chargeTotalPrice);
	    $("#txtFilterCharge").val(v.toFixed(2));

	    console.log("stockTypeId: " + fitem.stockTypeId);

	    if (AUIGrid.isUniqueValue(myFltGrd10, "filterID", fitem.filterID)) {
	      fn_addRow(fitem);
	    } else {
	      Common.alert("<spring:message code='service.msg.rcdExist'/>");
	      return;
	    }

	    fn_calculateTotalCharges();
	    fn_filterClear();
	  }

	  function fn_filterClear() {
	    $("#ddlFilterCode").val("");
	    $("#ddlFilterQty").val("");
	    $("#ddlFilterPayType").val("");
	    //$("#ddlFilterCat").val("");
	    //$("#ddlFilterExchangeCode").val("");
	    $("#ddSrvFilterLastSerial").val("");
	    $("#txtFilterRemark").val("");
	  }

	  function fn_setMand(obj) {
		    if (obj.value != "") {
		    	console.log("obj: " + obj.value);

		      $("#fcm3").show();
		      $("#fcm4").show();
		      $("#fcm5").show();

		      $("#ddlFilterQty").val("");
		      $("#ddlFilterPayType").val("");
		      //$("#ddlFilterExchangeCode").val("");
		      $("#ddSrvFilterLastSerial").val("");
		    } else {
		      $("#fcm3").hide();
		      $("#fcm4").hide();
		      $("#fcm5").hide();

		      $("#ddlFilterQty").val("");
		      $("#ddlFilterPayType").val("");
		      //$("#ddlFilterExchangeCode").val("");
		      $("#ddSrvFilterLastSerial").val("");
		    }
	}
	  function getASStockPrice(_PRC_ID) {
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

	}

	function fn_addRow(gItem) {
	    AUIGrid.addRow(myFltGrd10, gItem, "first");
	 }


	function fn_secChk(obj) {

		console.log("obj id: " + obj.id);
		console.log("check? " + $("#chkCrtAS").prop('checked'));

	    if (obj.id == "addOnDt") {
	      if (!$("#chkCrtAS").prop('checked')) {
	        Common.alert("This section only available when \"Add Installation Used Parts option\" is checked.");
	        return;
	      }
	    }
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
	        });
	    });
	}

	  function fn_InstallAcc_CheckedChanged(_obj) {
		    if (_obj.checked) {
		        doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
		    } else {
		        doGetComboSepa('/common/selectCodeList.do', 0, '', '','installAcc', 'M' , 'f_multiCombo');
		    }
		  }

	  function fn_AlphanumericRegexCheck(value){
		  var strRegex = new RegExp(/^[A-Za-z0-9]+$/);
		  return strRegex.test(value);
	  }

	  function fn_competitorBrand(competitorFlg){
		  if(competitorFlg == "Y"){
			  $("#competitorBrand").removeAttr("disabled");
			  //$("#competitorHeader").replaceWith("<th scope='row' id='competitorHeader'>Competitor Product<span class='must'>*</span></th>");
			  $("#competitorBrandHeader").replaceWith("<th scope='row' id='competitorBrandHeader'>Competitor Brand<span class='must'>*</span></th>");
		  }else{
			  $("#competitorBrand").attr('disabled', 'disabled');
			  $("#competitorBrand").val('');
			  //$("#competitorHeader").replaceWith("<th scope='row' id='competitorHeader'>Competitor Product</th>");
			  $("#competitorBrandHeader").replaceWith("<th scope='row' id='competitorBrandHeader'>Competitor Brand</th>");
		  }
	  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>
      <spring:message code='service.title.AddInstallationResult' />
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2">
          <a href="#"><spring:message code='expense.CLOSE' /></a>
        </p></li>
    </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
    <!-- pop_body start -->
    <section class="tap_wrap">
      <!-- tap_wrap start -->
      <ul class="tap_type1">
        <li><a href="#" id="orderInfo" class="on"><spring:message code='sales.tap.order' /></a></li>
        <li><a href="#"><spring:message code='service.title.General' /></a></li>
        <li><a href="#"><spring:message code='sales.tap.customerInfo' /></a></li>
        <li><a href="#"><spring:message code='sales.tap.installationInfo' /></a></li>
        <li><a href="#"><spring:message code='sales.tap.HPInfo' /></a></li>
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
      <article class="tap_area">
        <!-- tap_area start -->
        <aside class="title_line">
          <!-- title_line start -->
          <h2>
            <spring:message code='service.title.OrderInformation' />
          </h2>
        </aside>
        <!-- title_line end -->
        <input type="hidden" value="<c:out value="${installResult.installEntryId}"/>" id="installEntryId" name="installEntryId" />
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 120px" />
            <col style="width: *" />
            <col style="width: 150px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='service.title.Type' /></th>
              <td><span><c:out value="${installResult.codename1}" /></span></td>
              <th scope="row"><spring:message code='service.title.InstallNo' /></th>
              <td><span><c:out value="${installResult.installEntryNo}" /></span></td>
              <th scope="row"><spring:message code='service.title.OrderNo' /></th>
              <td><span><c:out value="${installResult.salesOrdNo}" /></span></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.RefNo' /></th>
              <td><span><c:out value="${installResult.refNo}" /></span></td>
              <th scope="row"><spring:message code='service.title.OrderDate' /></th>
              <td><span><c:out value="${installResult.salesDt}" /></span></td>
              <th scope="row"><spring:message code='service.title.ApplicationType' /></th>
              <c:if test="${installResult.codeid1  == '257' }">
                <td><span><c:out value="${orderInfo.codeName}" /></span></td>
              </c:if>
              <c:if test="${installResult.codeid1  == '258' }">
                <td><span><c:out value="${orderInfo.c5}" /></span></td>
              </c:if>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.Remark' /></th>
              <td colspan="5"><span><c:out value="${orderInfo.rem}" /></span></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.LastUpdatedBy' /></th>
              <td><span><c:out value="${installResult.userName}" /></span></td>
              <th scope="row">Product</th>
              <c:if test="${installResult.codeid1  == '257' }">
                <td><span><c:out value="${orderInfo.stkCode} - ${orderInfo.stkDesc} " /></span></td>
              </c:if>
              <c:if test="${installResult.codeid1  == '258' }">
                <td><span><c:out value="${orderInfo.c6} - ${orderInfo.c7} " /></span></td>
              </c:if>
              <th scope="row"><spring:message code='service.title.Promotion' /></th>
              <c:if test="${installResult.codeid1  == '257' }">
                <td><span><c:out value="${orderInfo.c3} - ${orderInfo.c4} " /></span></td>
              </c:if>
              <c:if test="${installResult.codeid1  == '258' }">
                <td><span><c:out value="${orderInfo.c9} - ${orderInfo.c10} " /></span></td>
              </c:if>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.Price' /></th>
              <c:if test="${installResult.codeid1  == '257' }">
                <td><span><c:out value="${orderInfo.c5}" /></span></td>
              </c:if>
              <c:if test="${installResult.codeid1  == '258' }">
                <td><span><c:out value="${orderInfo.c12}" /></span></td>
              </c:if>
              <th scope="row"><spring:message code='service.title.PV' /></th>
              <c:if test="${installResult.codeid1  == '257' }">
                <td><span><c:out value="${orderInfo.c6}" /></span></td>
              </c:if>
              <c:if test="${installResult.codeid1  == '258' }">
                <td><span><c:out value="${orderInfo.c13}" /></span></td>
              </c:if>
              <th scope="row">Grade</th>
              <td><span> <c:if test="${installResult.grade == null}">A</c:if> <c:if test="${installResult.grade != null}">
                    <c:out value="${installResult.grade}" />
                  </c:if>
              </span></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </article>
      <!-- tap_area end -->
      <article class="tap_area">
        <!-- tap_area start -->
        <aside class="title_line">
          <!-- title_line start -->
          <h2>
            <spring:message code='service.title.CustomerInformation' />
          </h2>
        </aside>
        <!-- title_line end -->
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 140px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='service.title.CustomerName' /></th>
              <td><span><c:out value="${customerInfo.name}" /></span></td>
              <th scope="row"><spring:message code='service.title.CustomerNRIC' /></th>
              <td><span><c:out value="${customerInfo.nric}" /></span></td>
              <th scope="row"><spring:message code='service.title.Gender' /></th>
              <td><span><c:out value="${customerInfo.gender}" /></span></td>
            </tr>
            <tr>
              <th scope="row" rowspan="4"><spring:message code='service.title.MailingAddress' /></th>
              <td colspan="5"><span></span></td>
            </tr>
            <tr>
              <td colspan="5"><span></span></td>
            </tr>
            <tr>
              <td colspan="5"><span></span></td>
            </tr>
            <tr>
              <td colspan="5"><span></span></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.ContactPerson' /></th>
              <td><span><c:out value="${customerContractInfo.name}" /></span></td>
              <th scope="row"><spring:message code='service.title.Gender' /></th>
              <td><span><c:out value="${customerContractInfo.gender}" /></span></td>
              <th scope="row"><spring:message code='service.title.ResidenceNo' /></th>
              <td><span><c:out value="${customerContractInfo.telR}" /></span></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.MobileNo' /></th>
              <td><span><c:out value="${customerContractInfo.telM1}" /></span></td>
              <th scope="row"><spring:message code='service.title.OfficeNo' /></th>
              <td><span><c:out value="${customerContractInfo.telO}" /></span></td>
              <th scope="row"><spring:message code='service.title.OfficeNo' /></th>
              <td><span><c:out value="${customerContractInfo.telF}" /></span></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </article>
      <!-- tap_area end -->
      <article class="tap_area">
        <!-- tap_area start -->
        <aside class="title_line">
          <!-- title_line start -->
          <h2>
            <spring:message code='service.title.InstallationInformation' />
          </h2>
        </aside>
        <!-- title_line end -->
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='service.title.RequestInstallDate' /></th>
              <td><span><c:out value="${installResult.c1}" /></span></td>
              <th scope="row"><spring:message code='service.title.AssignedCT' /></th>
              <td colspan="3"><span><c:out value="(${installResult.ctMemCode}) ${installResult.ctMemName}" /></span></td>
            </tr>
            <tr>
              <th scope="row" rowspan="4"><spring:message code='service.title.InstallationAddress' /></th>
              <td colspan="5"><span><c:out value="${installation.address}" /></span></td>
            </tr>
            <tr>
              <td colspan="5"><span>${installResult.city}</span></td>
            </tr>
            <tr>
              <td colspan="5"><span>${installResult.area}</span></td>
            </tr>
            <tr>
              <td colspan="5"><span>${installResult.country}</span></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.SpecialInstruction' /></th>
              <td><span><c:out value="${installation.instct}" /> </span></td>
              <th scope="row"><spring:message code='service.title.PreferredDate' /></th>
              <td></td>
              <th scope="row"><spring:message code='service.title.PreferredTime' /></th>
              <td></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
        <aside class="title_line">
          <!-- title_line start -->
          <h2>
            <spring:message code='service.title.InstallationContactPerson' />
          </h2>
        </aside>
        <!-- title_line end -->
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='service.title.Name' /></th>
              <td><span><c:out value="${installationContract.name}" /></span></td>
              <th scope="row"><spring:message code='service.title.Gender' /></th>
              <td></td>
              <th scope="row"><spring:message code='service.title.ResidenceNo' /></th>
              <td><span><c:out value="${installationContract.telR}" /></span></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.MobileNo' /></th>
              <td><span><c:out value="${installationContract.telM1}" /></span></td>
              <th scope="row"><spring:message code='service.title.OfficeNo' /></th>
              <td><span><c:out value="${installationContract.telO}" /></span></td>
              <th scope="row"><spring:message code='service.title.FaxNo' /></th>
              <td><span><c:out value="${installationContract.telF}" /></span></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </article>
      <!-- tap_area end -->
      <article class="tap_area">
        <!-- tap_area start -->
        <aside class="title_line">
          <!-- title_line start -->
          <h2>
            <spring:message code='service.title.HPInformation' />
          </h2>
        </aside>
        <!-- title_line end -->
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 135px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='service.title.HP_CodyCode' /></th>
              <td><span><c:out value="${hpMember.memCode}" /></span></td>
              <th scope="row"><spring:message code='service.title.HP_CodyName' /></th>
              <td><span><c:out value="${hpMember.name1}" /></span></td>
              <th scope="row"><spring:message code='service.title.HP_CodyNRIC' /></th>
              <td><span><c:out value="${hpMember.nric}" /></span></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.MobileNo' /></th>
              <td><span><c:out value="${hpMember.telMobile}" /></span></td>
              <th scope="row"><spring:message code='sales.HouseNo' /></th>
              <td><span><c:out value="${hpMember.telHuse}" /></span></td>
              <th scope="row"><spring:message code='service.title.OfficeNo' /></th>
              <td><span><c:out value="${hpMember.telOffice}" /></span></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.DepartmentCode' /></th>
              <td><span><c:out value="${salseOrder.deptCode}" /></span></td>
              <th scope="row"><spring:message code='service.title.GroupCode' /></th>
              <td><span><c:out value="${salseOrder.grpCode}" /></span></td>
              <th scope="row"><spring:message code='service.title.OrganizationCode' /></th>
              <td><span><c:out value="${salseOrder.orgCode}" /></span></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </article>
      <!-- tap_area end -->
    </section>
    <!-- tap_wrap end -->
    <aside class="title_line mt30">
      <!-- title_line start -->
      <h2>
        <spring:message code='service.title.ViewInstallationResult' />
      </h2>
    </aside>
    <!-- title_line end -->
    <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="grid_wrap_view" style="width: 100%;
  height: 100px;
  margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
    <aside class="title_line">
      <!-- title_line start -->
      <h2>
        <spring:message code='service.title.AddInstallationResult' />
      </h2>
    </aside>
    <!-- title_line end -->
    <form id="frmSearchSerial" name="frmSearchSerial" method="post">
      <input id="pGubun" name="pGubun" type="hidden" value="RADIO" /> <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" /> <input id="pLocationType" name="pLocationType" type="hidden" value="" /> <input id="pLocationCode" name="pLocationCode" type="hidden" value="" /> <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" /> <input id="pStatus" name="pStatus" type="hidden" value="" /> <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
    </form>
    <form action="#" id="addInstallForm" method="post">
      <input type="hidden" name="hidStkId" id="hidStkId" value="${installResult.installStkId}">
      <input type="hidden" value="<c:out value="${installResult.installEntryId}"/>" id="installEntryId" name="installEntryId" />
      <input type="hidden" value="${callType.typeId}" id="hidCallType" name="hidCallType" />
      <input type="hidden" value="${installResult.installEntryId}" id="hidEntryId" name="hidEntryId" />
      <input type="hidden" value="${installResult.custId}" id="hidCustomerId" name="hidCustomerId" />
      <input type="hidden" value="${installResult.salesOrdId}" id="hidSalesOrderId" name="hidSalesOrderId" />
      <input type="hidden" value="${installResult.sirimNo}" id="hidSirimNo" name="hidSirimNo" />
      <input type="hidden" value="${installResult.serialNo}" id="hidSerialNo" name="hidSerialNo" />
      <input type="hidden" value="${installResult.isSirim}" id="hidStockIsSirim" name="hidStockIsSirim" />
      <input type="hidden" value="${installResult.stkGrad}" id="hidStockGrade" name="hidStockGrade" />
      <input type="hidden" value="${installResult.stkCtgryId}" id="hidSirimTypeId" name="hidSirimTypeId" />
      <input type="hidden" value="${installResult.codeId}" id="hidAppTypeId" name="hidAppTypeId" />
      <input type="hidden" value="${installResult.installStkId}" id="hidProductId" name="hidProductId" />
      <input type="hidden" value="${installResult.custAddId}" id="hidCustAddressId" name="hidCustAddressId" />
      <input type="hidden" value="${installResult.custCntId}" id="hidCustContactId" name="hidCustContactId" />
      <input type="hidden" value="${installResult.custBillId}" id="hiddenBillId" name="hiddenBillId" />
      <input type="hidden" value="${installResult.codeName}" id="hiddenCustomerPayMode" name="hiddenCustomerPayMode" />
      <input type="hidden" value="${installResult.installEntryNo}" id="hiddeninstallEntryNo" name="hiddeninstallEntryNo" />
      <input type="hidden" value="" id="hidActualCTMemCode" name="hidActualCTMemCode" />
      <input type="hidden" value="" id="hidActualCTId" name="hidActualCTId"/>
      <input type="hidden" value="${installResult.ctWhLocId}" id="hidCtWhLocId" name="hidCtWhLocId" />
      <input type="hidden" value="${sirimLoc.whLocCode}" id="hidSirimLoc" name="hidSirimLoc" />
      <input type="hidden" value="" id="hidCategoryId" name="hidCategoryId" />
      <input type="hidden" value="" id="hidPromotionId" name="hidPromotionId" />
      <input type="hidden" value="" id="hidPriceId" name="hidPriceId" />
      <input type="hidden" value="" id="hiddenOriPriceId" name="hiddenOriPriceId" />
      <input type="hidden" value="${orderInfo.c5}" id="hiddenOriPrice" name="hiddenOriPrice" />
      <input type="hidden" value="" id="hiddenOriPV" name="hiddenOriPV" />
      <input type="hidden" value="" id="hiddenCatogory" name="hiddenCatogory" />
      <input type="hidden" value="" id="hiddenProductItem" name="hiddenProductItem" />
      <input type="hidden" value="" id="hidPERentAmt" name="hidPERentAmt" />
      <input type="hidden" value="" id="hidPEDefRentAmt" name="hidPEDefRentAmt" />
      <input type="hidden" value="" id="hidInstallStatusCodeId" name="hidInstallStatusCodeId" />
      <input type="hidden" value="" id="hidPEPreviousStatus" name="hidPEPreviousStatus"/>
      <input type="hidden" value="" id="hidDocId" name="hidDocId" />
      <input type="hidden" value="" id="hidOldPrice" name="hidOldPrice" />
      <input type="hidden" value="" id="hidExchangeAppTypeId" name="hidExchangeAppTypeId" />
      <input type="hidden" value="" id="hiddenCustomerType" name="hiddenCustomerType" />
      <input type="hidden" value="" id="hiddenPostCode" name="hiddenPostCode" />
      <input type="hidden" value="" id="hiddenCountryName" name="hiddenCountryName" />
      <input type="hidden" value="" id="hiddenStateName" name="hiddenStateName" />
      <input type="hidden" value="${promotionView.promoId}" id="hidPromoId" name="hidPromoId" />
      <input type="hidden" value="${promotionView.promoPrice}" id="hidPromoPrice" name="hidPromoPrice" />
      <input type="hidden" value="${promotionView.promoPV}" id="hidPromoPV" name="hidPromoPV" />
      <input type="hidden" value="${promotionView.swapPromoId}" id="hidSwapPromoId" name="hidSwapPromoId" />
      <input type="hidden" value="${promotionView.swapPormoPrice}" id="hidSwapPromoPrice" name="hidSwapPromoPrice"/>
      <input type="hidden" value="${promotionView.swapPromoPV}" id="hidSwapPromoPV" name="hidSwapPromoPV" />
      <input type="hidden" value="" id="hiddenInstallPostcode" name="hiddenInstallPostcode" />
      <input type="hidden" value="" id="hiddenInstallPostcode" name="hiddenInstallPostcode" />
      <input type="hidden" value="" id="hiddenInstallStateName" name="hiddenInstallStateName" />
      <input type="hidden" value="${customerInfo.name}" id="hidCustomerName" name="hidCustomerName" />
      <input type="hidden" value="${customerContractInfo.telM1}" id="hidCustomerContact" name="hidCustomerContact" />
      <input type="hidden" value="${installResult.salesOrdNo}" id="hidTaxInvDSalesOrderNo" name="hidTaxInvDSalesOrderNo" />
      <input type="hidden" value="${installResult.installEntryNo}" id="hidTradeLedger_InstallNo" name="hidTradeLedger_InstallNo" />
      <c:if test="${installResult.codeid1  == '257' }">
        <input type="hidden" value="${orderInfo.c5}" id="hidOutright_Price" name="hidOutright_Price" />
      </c:if>
      <c:if test="${installResult.codeid1  == '258' }">
        <input type="hidden" value=" ${orderInfo.c12}" id="hidOutright_Price" name="hidOutright_Price" />
      </c:if>
      <input type="hidden" value="${installation.address}" id="hidInstallation_AddDtl" name="hidInstallation_AddDtl" /> <input type="hidden" value="${installation.areaId}" id="hidInstallation_AreaID" name="hidInstallation_AreaID" /> <input type="hidden" value="${customerContractInfo.name}" id="hidInatallation_ContactPerson" name="hidInatallation_ContactPerson" /> <input type="hidden" value="${installResult.rcdTms}" id="rcdTms" name="rcdTms" /> <input type="hidden" value="${installResult.serialRequireChkYn}" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
      <input type="hidden" value="${orderInfo.brnch}" id="hidBrnch" name="hidBrnch" />
      <input type="hidden" value="${installResult.appntDt}" id="hidAppntDt" name="hidAppntDt" />
      <input type="hidden" value="${installResult.appntTm}" id="hidAppntTm" name="hidAppntTm" />
      <input type="hidden" id="insAsItemList" name="insAsItemList"/>
      <input type="hidden" value="${orderDetail.basicInfo.custType}" id="custType" name="custType" />
      <input type="hidden" value="${installResult.salesOrdNo}" id="salesOrdNo" name="salesOrdNo" />


      <table class="type1 mb1m">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 130px" />
          <col style="width: 350px" />
          <col style="width: 170px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='service.title.InstallStatust' /><span name="m1" id="m1" class="must">*</span></th>
            <td><select class="w100p" id="installStatus" name="installStatus">
                <c:forEach var="list" items="${installStatus}" varStatus="status">
                  <c:choose>
                    <c:when test="${list.codeId=='4'}">
                      <option value="${list.codeId}" selected>${list.codeName}</option>
                    </c:when>
                    <c:when test="${list.codeId=='1'}">
                    </c:when>
                    <c:otherwise>
                      <option value="${list.codeId}">${list.codeName}</option>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
            </select>
            <th scope="row"><spring:message code='service.title.ActualInstalledDate' /><span name="m2" id="m2" class="must">*</span></th>
            <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="installDate" name="installDate" /></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.CTCode' /><span name="m3" id="m3" class="must">*</span></th>
            <td colspan="3"><input type="text" title="" value="<c:out value="(${installResult.ctMemCode}) ${installResult.ctMemName}"/>" placeholder="" class="readonly" style="width: 100%;" id="ctCode" readonly="readonly" name="ctCode" /> <input type="hidden" title="" value="${installResult.ctId}" placeholder="" class="" style="width: 200px;" id="CTID" name="CTID" /></td>
          </tr>
          <th scope="row">JomTukar<span class="must">*</span></th>
            <td colspan="3">
                 <label><input type="radio" id="jomTukar" name="jomTukar" <c:if test="${installResult.jomTukarFlag eq 'Y'}">checked</c:if> value="Y" onClick="return false"/><span>Yes</span></label>
                 <label><input type="radio" id="jomTukar" name="jomTukar" <c:if test="${installResult.jomTukarFlag ne 'Y'}">checked</c:if> value="N" onClick="return false"/><span>No</span></label>
            </td>
          </tr>
          <tr>
            <th scope="row" id="competitorHeader">Competitor Product</th>
            <td colspan="3">
                <label><input type="radio" id="competitor" name="competitor" value="Y" onchange="javascript:fn_competitorBrand(this.value)" disabled="disabled"/><span>Yes</span><label>
                <label><input type="radio" id="competitor" name="competitor" value="N" onchange="javascript:fn_competitorBrand(this.value)" disabled="disabled"/><span>No</span></label>
            </td>
          </tr>
          <tr>
            <th scope="row" id="competitorBrandHeader">Competitor Brand</th>
            <td colspan="3">
                <select class="w100p" id="competitorBrand" name="competitorBrand" disabled="disabled" readonly="readonly">
			        <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
			        <c:forEach var="list" items="${competitorBrand}">
			             <option value="${list.codeId}">${list.codeName}</option>
			        </c:forEach>
                </select>
            </td>
          </tr>
          <tr>
          <tr>
            <th scope="row"><spring:message code='service.title.PSIRcd' /><span name="m8" id="m8" class="must">*</span></th>
            <td><input type="text" title="" placeholder="<spring:message code='service.title.PSIRcd' />" class="w100p" id="psiRcd" name="psiRcd" onkeypress='validate(event)' onblur='validate2(this);' /></td>
            <th scope="row"><spring:message code='service.title.lmp' /><span name="m9" id="m9" class="must">*</span></th>
            <td><input type="text" title="" placeholder="<spring:message code='service.title.lmp' />" class="w100p" id="lpmRcd" name="lpmRcd" onkeypress='validate(event)' onblur='validate2(this);' /></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.Volt' /><span name="m10" id="m10" class="must">*</span></th>
            <td><input type="text" title="" placeholder="<spring:message code='service.title.Volt' />" class="w100p" id="volt" name="volt" onkeypress='validate(event)' onblur='validate2(this);' /></td>
            <th scope="row"><spring:message code='service.title.TDS' /><span name="m11" id="m11" class="must">*</span></th>
            <td><input type="text" title="" placeholder="<spring:message code='service.title.TDS' />" class="w100p" id="tds" name="tds" onkeypress='validate(event)' onblur='validate2(this);' /></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.RoomTemp' /><span name="m12" id="m12" class="must">*</span></th>
            <td><input type="text" title="" placeholder="<spring:message code='service.title.RoomTemp' />" class="w100p" id="roomTemp" name="roomTemp" onkeypress='return validateFloatKeyPress(this,event)' onblur='validate3(this);' /></td>
            <th scope="row"><spring:message code='service.title.WaterSourceTemp' /><span name="m13" id="m13" class="must">*</span></th>
            <td><input type="text" title="" placeholder="<spring:message code='service.title.WaterSourceTemp' />" class="w100p" id="waterSourceTemp" name="waterSourceTemp" onkeypress='return validateFloatKeyPress(this,event)' onblur='validate3(this);' /></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.TurbidityLevel' /><span name="m24" id="m24" class="must">*</span> <p class="link_btn"><a href="${pageContext.request.contextPath}/resources/download/service/Turbidity.pptx"> <u>Guideline </u><img src="${pageContext.request.contextPath}/resources/AUIGrid/images/help_ico.png"></a></p></th>
            <td><input type="text" title="" placeholder="<spring:message code='service.title.TurbidityLevel' />" class="w100p" id="turbLvl" name="turbLvl" onkeypress='validate(event)' onblur='validate2(this);' /></td>
            <th scope="row">Water Source Type<span name="m18" id="m18" class="must">*</span></th>
            <td><select class="w100p" id="waterSrcType" name="waterSrcType">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${waterSrcType}" varStatus="status">
                   <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
            </select></td>
          </tr>
          <%-- <tr>
            <th scope="row"><spring:message code='service.title.adptUsed' /><span name="m14" id="m14" class="must">*</span></th>
            <td colspan='3'><select class="w100p" id="adptUsed" name="adptUsed">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${adapterUsed}" varStatus="status">
                  <option value="${list.codeId}" select>${list.codeName}</option>
                </c:forEach>
            </select></td>
          </tr> --%>
          <tr>
            <th scope="row"><spring:message code='service.title.AddUsedParts' /></th>
            <td><label><input type="checkbox" id='chkCrtAS' name='chkCrtAS' onChange="fn_chkCrtAS(this)" /></label></td>
            <th scope="row"></th>
            <td></td>
          <%--   <th scope="row">Mobile</th>
	        <td>
	          <input type="text" title="" value ="${orderDetail.installationInfo.instCntTelM}" placeholder="Mobile No" id="custMobileNo" name="custMobileNo" style="width:50%;"/>
	          <span>SMS</span><input type="checkbox" id="chkSms" name="chkSms" checked>
	        </td> --%>
          </tr>
          <tr>
           <th scope="row"><spring:message code='service.title.ntu'/><span name="m28" id="m28" class="must">*</span></th>
           <td><input type="text" title="NTU" class="w100p" id="ntuCom" name="ntuCom" placeholder="0.00" maxlength="5" onkeypress='return validateFloatKeyPress(this,event)' onblur='validate3(this);' />
           </td>
			<th scope="row"></th>
			<td></td>
          </tr>
          <tr>
          <th scope="row"><spring:message code="service.title.installation.accessories" />
          <input type="checkbox" id="chkInstallAcc" name="chkInstallAcc" onChange="fn_InstallAcc_CheckedChanged(this)" checked/></th>
    		<td colspan="3">
    		<select class="w100p" id="installAcc" name="installAcc">
    		</select>
    		</td>
          </tr>
        </tbody>
      </table>
      <br />
      <!-- table end -->
      <table class="type1" id="completedHide">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 130px" />
          <col style="width: 130px" />
          <col style="width: 110px" />
          <col style="width: 110px" />
          <col style="width: 110px" />
          <col style="width: *" />
          <col style="width: 110px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='service.title.SIRIMNo' /><span name="m4" id="m4" class="must">*</span></th>
            <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.SIRIMNo' />" class="w100p" id="sirimNo" name="sirimNo" /></td>
            <th scope="row"><spring:message code='service.title.SerialNo' /><span name="m5" id="m5" class="must">*</span></th>
            <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.SerialNo' />" class="w100p" id="serialNo" name="serialNo" /> <c:if test="${installResult.serialRequireChkYn == 'Y' }">
                <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop()"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
              </c:if></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.RefNo' />(1)</th>
            <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.RefNo' />(1)" class="w100p" id="refNo1" name="refNo1" /></td>
            <th scope="row"><spring:message code='service.title.RefNo' />(2)</th>
            <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.RefNo' />(2)" class="w100p" id="refNo2" name="refNo2" /></td>
          </tr>
          <tr>
            <td colspan="8"><label><input type="checkbox" id="checkCommission" name="checkCommission" /><span><spring:message code='service.btn.AllowCommission' /> ?</span></label> <label><input type="checkbox" id="checkTrade" name="checkTrade" /><span><spring:message code='service.btn.IsTradeIn' /> ?</span></label><label><input type="checkbox" id="checkSms" name="checkSms" /><span><spring:message code='service.btn.RequireSMS' /> ?</span></label></td>
          </tr>
        </tbody>
      </table>
       <br />

      <!-- Added Used Part. 2021-03-11 by Hui Ding -->
        <article class="acodi_wrap">
          <dl>
            <dt class="click_add_on on" id="addOnDt"  onclick="fn_secChk(this);">
              <a href="#"><spring:message code='service.title.AddUsedParts' /></a>
            </dt>

            <dd id='chrFee_div' style="display: none">
              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 170px" />
                  <col style="width: *" />
                  <col style="width: 140px" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code='service.text.asLbrChr' /></th>
                    <td><label><input type="checkbox" id='txtLabourch' name='txtLabourch' onChange="fn_LabourCharge_CheckedChanged(this)" /></label></td>
                    <th scope="row"><spring:message code='service.text.asLbrChr' /></th>
                    <td><input type="text" id='txtLabourCharge' name='txtLabourCharge' value='0.00' readonly /></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code='service.text.asLbrChr' /> (RM) <span id="fcm1" name="fcm1" class="must" style="display: none">*</span></th>
                    <td><select id='cmbLabourChargeAmt' name='cmbLabourChargeAmt' onChange="fn_cmbLabourChargeAmt_SelectedIndexChanged()" readonly>
                        <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                        <c:forEach var="list" items="${lbrFeeChr}" varStatus="status">
                          <option value="${list.codeId}">${list.codeName}</option>
                        </c:forEach>
                    </select></td>
                    <th scope="row"><spring:message code='service.text.asfltChr' /></th>
                    <td><input type="text" id='txtFilterCharge' name='txtFilterCharge' value='0.00' readonly /></td>
                  </tr>
                  <tr>
                    <th scope="row"></th>
                    <td></td>
                    <th scope="row"><b><spring:message code='service.text.asTtlChr' /></b></th>
                    <td><input type="text" id='txtTotalCharge' name='txtTotalCharge' value='0.00' readonly /></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code='service.grid.FilterCode' /><span id="fcm2" name="fcm2" class="must" style="display: none">*</span></th>
                    <td><select id='ddlFilterCode' name='ddlFilterCode' onchange="fn_setMand(this)"></select></td>
                    <th scope="row"><spring:message code='service.grid.Quantity' /><span id="fcm3" name="fcm3" class="must" style="display: none">*</span></th>
                    <td><select id='ddlFilterQty' name='ddlFilterQty'>
                        <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                        <c:forEach var="list" items="${fltQty}" varStatus="status">
                          <option value="${list.codeId}">${list.codeName}</option>
                        </c:forEach>
                    </select></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code='service.text.asPmtTyp' /><span id="fcm4" name="fcm4" class="must" style="display: none">*</span></th>
                    <td colspan="3"><select id='ddlFilterPayType' name='ddlFilterPayType'>
                        <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                        <c:forEach var="list" items="${fltPmtTyp}" varStatus="status">
                          <option value="${list.codeId}">${list.codeName}</option>
                        </c:forEach>
                    </select></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code='service.title.SerialNo' /><span id="fcm6" name="fcm6" class="must" style="display: none">*</span></th>
                    <td colspan="3"><input type="text" id='ddSrvFilterLastSerial' name='ddSrvFilterLastSerial' /> <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop()" style="display: none"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code='service.title.Remark' /></th>
                    <td colspan="3"><textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />" id='txtFilterRemark' name='txtFilterRemark'></textarea></td>
                  </tr>
                  <tr>
                    <td colspan="4"><span style="color: red; font-style: italic;"><spring:message code='service.msg.msgFltTtlAmt' /></span></td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
              <ul class="center_btns">
                <li><p class="btn_blue2">
                    <a href="#" onclick="fn_filterAdd()"><spring:message code='sys.btn.add' /></a>
                  </p></li>
                <li><p class="btn_blue2">
                    <a href="#" onclick="fn_filterClear()"><spring:message code='sys.btn.clear' /></a>
                  </p></li>
              </ul>
              <article class="grid_wrap">
                <!-- grid_wrap start -->
                <div id="asfilter_grid_wrap" style="width: 100%; height: 250px; margin: 0 auto;"></div>
              </article>
              <!-- grid_wrap end -->
            </dd>
          </dl>
        </article>

      <aside class="title_line"  id="attachmentTitle">
        <h2>
          <spring:message code='service.text.attachment' />
         </h2>
      </aside>
      <table class="type1"  id="attachmentArea">
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
      <aside class="title_line mt30">
        <!-- title_line start -->
        <h2 id="m17" name="m17">
          <spring:message code='service.text.instChkLst' />
        </h2>
      </aside>
      <!-- title_line end -->
      <article class="grid_wrap">
        <!-- grid_wrap start -->
        <div id="grid_wrap_instChk_view" style="width: 100%;  height: 170px;  margin: 90 auto;" class="hide"></div>
      </article>
      <!-- grid_wrap end -->
      <tr>
        <td colspan="8"><label><input type="checkbox" id="instChklstCheckBox" name="instChklstCheckBox" value="Y" class="hide" /><span id="instChklstDesc" name="instChklstDesc" class="hide"><spring:message code='service.btn.instChklst' /> </span></label></td>
      </tr>
      <br></br>
      <!-- table end -->

      <%-- <aside class="title_line" id="completedHide1">
        <!-- title_line start -->
        <h2>
          <spring:message code='service.title.SMSInfo' />
        </h2>
      </aside> --%>
      <!-- title_line end -->
      <%-- <table class="type1" id="completedHide2">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 110px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <td colspan="2"><label><input type="checkbox" id="checkSend" name="checkSend" /><span><spring:message code='service.title.SendSMSToSalesPerson' /></span></label></td>
          </tr>
          <tr>
            <th scope="row" rowspan="2"><spring:message code='service.title.Message' /></th>
            <td><textarea cols="20" rows="5" readonly="readonly" class="readonly" id="msg" name="msg">
                        RM0.00 COWAY DSC
                        Install Status: Completed
                        Order No: ${installResult.salesOrdNo}
                        Name: ${hpMember.name1}
                    </textarea>
             </td>
          </tr>
          <tr>
            <td><input type="text" title="" placeholder="" class="w100p" value="Remark:" id="msgRemark" name="msgRemark" /></td>
          </tr>
        </tbody>
      </table> --%>
      <!-- table end -->
      <table class="type1" id="failHide3">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 110px" />
          <col style="width: 250px" />
          <col style="width: 110px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='service.title.FailedLocation' /><span name="m15" id="m15" class="must">*</span></th>
            <td><select class="w100p" id="failLocCde" name="failLocCde" onchange="fn_openFailChild(this.value)">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failParent}" varStatus="status">
                   <%-- <option value="${list.defectId}">${list.defectDesc}</option> --%>
                   <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
            </select></td>
            <th scope="row"><spring:message code='service.title.FailedReason' /><span name="m16" id="m16" class="must">*</span></th>
            <input type="hidden" value="" id="hiddenFailReasonCode" name="hiddenFailReasonCode" />
            <td><select class="w100p" id="failReasonCode" name="failReasonCode">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failChild}" varStatus="status">
                  <option value="${list.defectId}">${list.defectDesc}</option>
                </c:forEach>
            </select></td>
          </tr>

             <!--  /////////////////////////////////////////////// NEW ADDED COLUMN : BOOSTER PUMP //////////////////////////////////////////////////////// -->

         <%-- <tr>
            <th scope="row"><spring:message code='service.title.BoosterPump' /><span name="m21" id="m21" class="must">*</span></th>
            <td colspan='3'><select class="w100p" id="boosterPump" name="boosterPump">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${boosterUsed}" varStatus="status">
                  <option value="${list.codeId}" select>${list.codeName}</option>
                </c:forEach>
            </select></td>
          </tr> --%>

      <%--           <tr>
             <th scope="row"><spring:message code='service.title.BoosterPump' /><span class="must" id="m21"> *</span></th>
              <td colspan="3">
                <select class="w100p" id="boosterPump" name="boosterPump">
                   <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                  <c:forEach var="list" items="${boosterUsed}" varStatus="status">
                    <option value="${list.codeId}" selected>${list.codeName}</option>
                  </c:forEach>
                       </select>
              </td>
          </tr>  --%>

           <%-- <tr>
              <th scope="row"><spring:message code='service.title.AfterPumpPsi' /><span class="must" id="m22" style="display: none;"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.AfterPumpPsi' />" class="w100p" id="aftPsi" name="aftPsi" value=" <c:out value="${installInfo.aftPsi}"/>"/>
              </td>
              <th scope="row"><spring:message code='service.title.AfterPumpLpm' /><span class="must" id="m23" style="display: none;"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.AfterPumpLpm' />" class="w100p" id="aftLpm" name="aftLpm" value=" <c:out value="${installInfo.aftLpm}"/>"/>
              </td>
            </tr> --%>
          <!--  /////////////////////////////////////////////// NEW ADDED COLUMN : BOOSTER PUMP //////////////////////////////////////////////////////// -->


          <tr>
            <th scope="row"><spring:message code='service.title.NextCallDate' /><span name="m7" id="m7" class="must">*</span></th>
            <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="nextCallDate" name="nextCallDate" /></td>
            <th scope="row"><spring:message code='service.title.ntu'/><span name="m29" id="m29" class="must">*</span></th>
           <td><input type="text" title="NTU" class="w100p" id="ntuFail" name="ntuFail" placeholder="0.00" maxlength="5" onkeypress='return validateFloatKeyPress(this,event)' onblur='validate3(this);' />
           </td>
          </tr>
        </tbody>
      </table>
      <!-- table end -->
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 110px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='service.title.Remark' /></th>
            <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.Remark' />" class="w100p" id="remark" name="remark" /></td>
          </tr>
          <tr>
            <td colspan="4"><label><input type="checkbox" id="failDeptChk" name="failDeptChk" value="Y" /><span id="failDeptChkDesc" name="failDeptChkDesc"><spring:message code='sys.btn.failBfrDepartFromWarehouse' /> </span></label></td>
          </tr>
        </tbody>
      </table>
      <!-- table end -->
    </form>
    <div id='sav_div'>
      <ul class="center_btns">
        <li><p class="btn_blue2">
            <a href="#" onclick="fn_saveInstall()"><spring:message code='service.btn.SaveInstallationResult' /></a>
          </p></li>
      </ul>
    </div>
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
