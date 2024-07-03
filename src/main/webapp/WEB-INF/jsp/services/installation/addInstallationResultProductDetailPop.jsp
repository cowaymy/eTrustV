<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/02/2019  ONGHC  1.0.0      RE-STRUCTURE JSP.
 18/08/2020  FARUQ  1.0.1       remove installation status active & add psi, lpm, volt, tds, room temp, water source temp, failParent, failChild, instChkLst
 28/08/2020  FARUQ  1.0.2       Add validation feature for Kecik when completed
 07/09/2020  FARUQ  1.0.3       Add validation feature for Kecik when failed
 -->

<script type="text/javaScript">
var myFileCaches = {};
var installAccTypeId = 582;

  $(document).ready(
    function() {
      var instChkLst_view;
      createInstallationChkViewAUIGrid();
      fn_viewInstallationChkViewSearch();

      if ("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400") {
          $("#addInstallForm #m28").show();
          $("#addInstallForm #m29").hide();
          $("#ntuCom").attr("disabled", false);
          $("#ntuFail").attr("disabled", true);
        } else {
          $("#addInstallForm #m28").hide();
          $("#addInstallForm #m29").hide();
          $("#ntuCom").attr("disabled", true);
          $("#ntuFail").attr("disabled", true);
          $("#ntuCom").val("0");
          $("#ntuFail").val("0");
        }

      doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');

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

            $("#addInstallForm #m2").show();
            $("#addInstallForm #m4").show();
            $("#addInstallForm #m5").show();

            $("#addInstallForm #m29").hide();
            $("#ntuFail").attr("disabled", true);
            $("#ntuFail").val("0");

            if ("${orderInfo.stkCtgryId}" == "54") {
              $("#addInstallForm #m17").show();
              $("#addInstallForm #grid_wrap_instChk_view").show();
              $("#addInstallForm #instChklstCheckBox").show();
              $("#addInstallForm #instChklstDesc").show();
              $("#addInstallForm #m28").show();
              $("#ntuCom").attr("disabled", false);
            } else if("${orderInfo.stkCtgryId}" == "400"){ // POE
            	$("#addInstallForm #m28").show();
                $("#ntuCom").attr("disabled", false);
            } else {
              $("#addInstallForm #m17").hide();
              $("#addInstallForm #grid_wrap_instChk_view").hide();
              $("#addInstallForm #instChklstCheckBox").hide();
              $("#addInstallForm #instChklstDesc").hide();
              $("#addInstallForm #m28").hide();
              $("#ntuCom").attr("disabled", true);
              $("#ntuCom").val("0");

            }
            $("#nextCallDate").val("");
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

            var currDt = new Date(),
            month = '' + (currDt.getMonth()+1),
            day = '' + (currDt.getDate()+1),
            year = currDt.getFullYear();

            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2)
                day = '0' + day;
            var currentDate =  [day, month, year].join('/');
            $("#nextCallDate").val(currentDate);
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

      var callType = "${callType.typeId}";

      if (callType == 0) {
        // * Installation information data error. Please contact to IT Department.
        $(".red_text").text("<spring:message code='service.msg.InstallationInformation'/>");
      } else {
        if (callType == 258) {
          //$(".tap_type1").li[1].text("Product Exchange Info");
        }

        if ("${orderInfo.c9}" == 21) {
          // * This installation status is failed. Please do the call log process again.
          $(".red_text").text("<spring:message code='service.msg.InstallationStatus'/>");
        } else if ("${orderInfo.c9}" == 4) {
          // * This installation status is completed.<br />  To reverse this order installation result, please proceed to order installation result reverse.
          $(".red_text").text("<spring:message code='service.msg.InstallationCompleted'/>");
        }
      }

      if ("${stock}" != null) {
        $("#hidActualCTMemCode").val("${stock.memCode}");
        $("#hidActualCTId").val("${stock.movToLocId}");
      } else {
        $("#hidActualCTMemCode").val("0");
        $("#hidActualCTId").val("0");
      }

      if ("${orderInfo}" != null) {
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
        $("#addInstallForm #m18").hide();
        if ("${orderInfo.stkCtgryId}" != "54") {
          $("#addInstallForm #m17").hide();
          $("#addInstallForm #grid_wrap_instChk_view").hide();
          $("#addInstallForm #instChklstCheckBox").hide();
          $("#addInstallForm #instChklstDesc").hide();
        } else {
          $("#addInstallForm #m17").show();
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
        $("#addInstallForm #m18").show();

        $("#addInstallForm #m6").hide();
        $("#addInstallForm #m7").hide();
        $("#addInstallForm #m15").hide();
        $("#addInstallForm #m16").hide();
        $("#addInstallForm #failDeptChk").hide();
        $("#addInstallForm #failDeptChkDesc").hide();

        if ("${orderInfo.stkCtgryId}" != "54") {
          $("#addInstallForm #m17").hide();
          $("#addInstallForm #grid_wrap_instChk_view").hide();
          $("#addInstallForm #instChklstCheckBox").hide();
          $("#addInstallForm #instChklstDesc").hide();
        } else {
          $("#addInstallForm #m17").show();
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
              $("#addInstallForm #m18").show();
            }
            else {
              var currDt = new Date(),
              month = '' + (currDt.getMonth()+1),
              day = '' + (currDt.getDate()+1),
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
              $("#addInstallForm #m18").hide();
            }
      });

      $("#installDate").change(
        function() {
          var checkMon = $("#installDate").val();

          Common.ajax("GET", "/services/checkMonth.do?intallDate="+ checkMon, ' ',
            function(result) {
              if (result.message == "Please choose this month only") {
                Common.alert(result.message);
                $("#installDate").val('');
              }
            });
       });

      $("#addInstallForm #installStatus").change(
         function() {
           if ($("#addInstallForm #installStatus").val() == 4) {
             notMandatoryForAP();
             $("#addInstallForm #checkCommission").prop("checked", true);

             $("#addInstallForm #m6").hide();
             $("#addInstallForm #m7").hide();
             $("#addInstallForm #m15").hide();
             $("#addInstallForm #m16").hide();
             $("#addInstallForm #failDeptChk").hide();
             $("#addInstallForm #failDeptChkDesc").hide();

             $("#addInstallForm #m2").show();
             $("#addInstallForm #m4").show();
             $("#addInstallForm #m5").show();
             $("#addInstallForm #m29").hide();
             $("#ntuFail").attr("disabled", true);
             $("#ntuFail").val("0");

             if ("${orderInfo.stkCtgryId}" == "54") {
               $("#addInstallForm #m17").show();
               $("#addInstallForm #grid_wrap_instChk_view").show();
               $("#addInstallForm #instChklstCheckBox").show();
               $("#addInstallForm #instChklstDesc").show();
               $("#addInstallForm #m28").show();
               $("#ntuCom").attr("disabled", false);
             } else if("${orderInfo.stkCtgryId}" == "400"){ // POE
                 $("#addInstallForm #m28").show();
                 $("#ntuCom").attr("disabled", false);
             }else {
               $("#addInstallForm #m17").hide();
               $("#addInstallForm #grid_wrap_instChk_view").hide();
               $("#addInstallForm #instChklstCheckBox").hide();
               $("#addInstallForm #instChklstDesc").hide();
               $("#addInstallForm #m28").hide();
               $("#ntuCom").attr("disabled", true);
               $("#ntuCom").val("0");
             }
             $("#nextCallDate").val("");

           } else {
             notMandatoryForAP()
             $("#addInstallForm #checkCommission").prop("checked", false);

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
             $("#ntuCom").attr("disabled", true);
             $("#ntuFail").attr("disabled", true);
             $("#ntuCom").val("0");
             $("#ntuFail").val("0");

             if ("${orderInfo.stkCtgryId}" == "54") {
               $("#addInstallForm #m17").hide();
               $("#addInstallForm #grid_wrap_instChk_view").hide();
               $("#addInstallForm #instChklstCheckBox").hide();
               $("#addInstallForm #instChklstDesc").hide();
             } else {
               $("#addInstallForm #m17").hide();
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

             var currDt = new Date(),
             month = '' + (currDt.getMonth()+1),
             day = '' + (currDt.getDate()+1),
             year = currDt.getFullYear();

             if (month.length < 2)
                 month = '0' + month;
             if (day.length < 2)
                 day = '0' + day;
             var currentDate =  [day, month, year].join('/');
             $("#nextCallDate").val(currentDate);
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

        // KR-OHK Serial Check
        if( $("#hidSerialRequireChkYn").val() == 'Y' ) {
        	$("#btnSerialEdit").attr("style", "");
        }

        // 54 - WP
        // 57 - SOFTENER
        // 58 - BIDET
        // 400 - POE
        if ("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56") {
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
    $("#addInstallForm #m28").hide();
    $("#addInstallForm #m29").hide();
}

  function fn_installProductExchangeSave() {
    Common.ajax("POST", "/services/saveInstallationProductExchange.do", $("#insertPopupForm").serializeJSON(), function(result) {
      Common.alert("Saved", fn_saveDetailclose);
    });
  }

  function fn_saveInstall() {
    console.log("addInstallationResultProductDetailPop :: fn_saveInstall");
    var msg = "";
    var custMobileNo = $("#custMobileNo").val().replace(/[^0-9\.]+/g, "") ;
    var chkMobileNo = custMobileNo.substring(0, 2);
    var addedRowItems;
    // KR-OHK Serial Check add
    var url = "";

    if ($("#hidSerialRequireChkYn").val() == 'Y') {
      url = "/services/addInstallationSerial.do";
    } else {
      url = "/services/addInstallation_2.do";
    }

    if (chkMobileNo == '60'){
        custMobileNo = custMobileNo.substring(1);
    }
    $("#custMobileNo").val(custMobileNo);

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
      if ($("#addInstallForm #serialNo").val().trim() == '' || ("#addInstallForm #serialNo") == null) {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
      } else {
        if ($("#addInstallForm #serialNo").val().trim().length < 9) {
          msg += "* <spring:message code='sys.msg.invalid' arguments='Serial No' htmlEscape='false'/> </br>";
        }
      }

      //stkId for kecil = 1735, petit = 298 (for testing in developmennt)
      // PSI CHECKING
      if ( "${orderInfo.appTypeId}" != "144" && (("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56")
          //&& !("${installResult.installStkId}" == 1735) ) {
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

      if ($("#custMobileNo").val().trim() == '' && $("#chkSMS").is(":checked")) {
          msg += "* Please fill in customer mobile no </br> Kindly proceed to edit customer contact info </br>";
      }

      if (!($("#ntuCom").val() == "" ) && !($("#ntuCom").val() > 0 && $("#ntuCom").val() <= 10 )){
    	  msg += "* <spring:message code='sys.msg.range' arguments='NTU,0.00,10.00' htmlEscape='false'/> </br>";
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

      if(isValid == true){
          Common.ajaxFile("/services/attachFileUpload.do", formData, function(result) {
              console.log("[Save] Upload result :: " + JSON.stringify(result));
              if(result != 0 && result.code == 00) {
                  var saveForm = {
                            "installForm" : $("#addInstallForm").serializeJSON(),
                            "add" : addedRowItems,
                            "installAccList" : $("#installAcc").val() ,
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
          }
        }

      if ($("#custMobileNo").val().trim() == '' && $("#chkSMS").is(":checked")) {
          msg += "* Please fill in customer mobile no </br> Kindly proceed to edit customer contact info </br>";
      }

	// NTU Checking for Failed status
      if("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400"){ // WP & POE
    	if($("#failReasonCode").val() == 8009){
      		if (!($("#ntuFail").val() == "" ) && ($("#ntuFail").val() > 0 && $("#ntuFail").val() <= 10 )){
    	  		msg += "* <spring:message code='sys.msg.range' arguments='NTU,10.00,99.00' htmlEscape='false'/> </br>";
      		}else if ($("#ntuFail").val() == "" || $("#ntuFail").val() < 0 ){
      			msg += "* <spring:message code='sys.msg.range' arguments='NTU,10.00,99.00' htmlEscape='false'/> </br>";
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
          console.log("[Save] Upload result :: " + JSON.stringify(result));
          if(result != 0 && result.code == 00) {
              var saveInsFailedForm = {
                        "installForm" : $("#addInstallForm").serializeJSON(),
                        "add" : addedRowItems,
                        "installAccList" : $("#installAcc").val() ,
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


  function validationForKecikWhenCompleted() {
    var msg = "";

    if (!($("#psiRcd").val() >= 7 && $("#psiRcd").val() <= 120)) {
      msg += "* <spring:message code='sys.msg.range' arguments='Water Pressure (PSI),7,120' htmlEscape='false'/> </br>";
    }
    if (!($("#lpmRcd").val() >= 4 && $("#lpmRcd").val() <= 63)) {
      msg += "* <spring:message code='sys.msg.range' arguments='Liter Per Minute(LPM),4,63' htmlEscape='false'/> </br>";
    }
    if (!($("#volt").val() >= 200 && $("#volt").val() <= 264)) {
      msg += "* <spring:message code='sys.msg.range' arguments='Voltage,200,264' htmlEscape='false'/> </br>";
    }
    if ($("#tds").val() == 0) {
      msg += "* <spring:message code='sys.msg.mustMore' arguments='Total Dissolved Solid (TDS),0' htmlEscape='false'/> </br>";
    } else if (!($("#tds").val() > 0 && $("#tds").val() <= 300)) {
      msg += "* <spring:message code='sys.msg.limitMore' arguments='Total Dissolved Solid (TDS),300' htmlEscape='false'/> </br>";
    }
    if (!($("#roomTemp").val() >= 4 && $("#roomTemp").val() <= 40)) {
      msg += "* <spring:message code='sys.msg.range' arguments='Room Temperature,4,40' htmlEscape='false'/> </br>";
    }
    if (!($("#waterSourceTemp").val() >= 5 && $("#waterSourceTemp").val() <= 35)) {
      msg += "* <spring:message code='sys.msg.range' arguments='Water Source Temperature,5,35' htmlEscape='false'/> </br>";
    }

    if ($("#adptUsed").val() == "") {
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

  function fn_viewInstallationChkViewSearch() {

    Common.ajax("GET", "/services/instChkLst.do", "",
        function(result) {
          AUIGrid.setGridData( instChkLst_view, result);
        });
  }

  function fn_saveDetailclose() {
    addinstallationResultProductDetailPopId.remove();
  }

  function fn_serialModifyPop(){
	  $("#serialNoChangeForm #pSerialNo").val( $("#stockSerialNo").val() ); // Serial No
      $("#serialNoChangeForm #pSalesOrdId").val( $("#hidSalesOrderId").val() ); // 주문 ID
      $("#serialNoChangeForm #pSalesOrdNo").val( $("#hidTaxInvDSalesOrderNo").val() ); // 주문 번호
      $("#serialNoChangeForm #pRefDocNo").val( $("#hiddeninstallEntryNo").val() ); //
      $("#serialNoChangeForm #pItmCode").val( '${viewDetail.exchangeInfo.c10}' ); // 제품 ID
      $("#serialNoChangeForm #pCallGbn").val( "EXCH_RETURN" );
      $("#serialNoChangeForm #pMobileYn").val( "N"  );

      if(Common.checkPlatformType() == "mobile") {
          popupObj = Common.popupWin("serialNoChangeForm", "/logistics/serialChange/serialNoChangePop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
      } else{
          Common.popupDiv("/logistics/serialChange/serialNoChangePop.do", $("#serialNoChangeForm").serializeJSON(), null, true, '_serialNoChangePop');
      }
  }

  function fn_PopSerialChangeClose(obj){

      console.log("++++ obj.asIsSerialNo ::" + obj.asIsSerialNo +", obj.beforeSerialNo ::"+ obj.beforeSerialNo);

      $("#stockSerialNo").val(obj.asIsSerialNo);
      $("#hidStockSerialNo").val(obj.beforeSerialNo);

      if(popupObj!=null) popupObj.close();
      //fn_viewInstallResultSearch(); //조회
  }

  //팝업에서 호출하는 조회 함수
  function SearchListAjax(obj){

    console.log("++++ obj.asIsSerialNo ::" + obj.asIsSerialNo +", obj.beforeSerialNo ::"+ obj.beforeSerialNo);

    $("#stockSerialNo").val(obj.asIsSerialNo);
    $("#hidStockSerialNo").val(obj.beforeSerialNo);

    //fn_viewInstallResultSearch(); //조회
  }

  function fn_serialSearchPop(){

	  $("#pLocationType").val('${installResult.whLocGb}');
      $('#pLocationCode').val('${installResult.ctWhLocId}');
      $("#pItemCodeOrName").val('${viewDetail.installationInfo.stkCode}');

      Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
  }

  function fnSerialSearchResult(data) {
      data.forEach(function(dataRow) {
          $("#addInstallForm #serialNo").val(dataRow.serialNo);
          //console.log("serialNo : " + dataRow.serialNo);
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
    }
    if(selectedData == "8000" || selectedData == "8100"){
    $("#failReasonCode").attr("disabled",false);
    doGetCombo('/services/selectFailChild.do', selectedData, '','failReasonCode', 'S' , '');
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

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>Installation Result - Product Exchange</h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#">CLOSE</a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
    <form id="frmSearchSerial" name="frmSearchSerial" method="post">
        <input id="pGubun" name="pGubun" type="hidden" value="RADIO" />
        <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
        <input id="pLocationType" name="pLocationType" type="hidden" value="" />
        <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
        <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
        <input id="pStatus" name="pStatus" type="hidden" value="" />
        <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
    </form>
    <form id="serialNoChangeForm" name="serialNoChangeForm" method="POST">
	    <input type="hidden" name="pSerialNo" id="pSerialNo"/>
	    <input type="hidden" name="pSalesOrdId"  id="pSalesOrdId"/>
	    <input type="hidden" name="pSalesOrdNo"  id="pSalesOrdNo"/>
	    <input type="hidden" name="pRefDocNo" id="pRefDocNo"/>
	    <input type="hidden" name="pItmCode" id="pItmCode"/>
	    <input type="hidden" name="pCallGbn" id="pCallGbn"/>
	    <input type="hidden" name="pMobileYn" id="pMobileYn"/>

  </form>
  <form id="insertPopupForm" method="post">
   <section class="tap_wrap">
    <!-- tap_wrap start -->
    <ul class="tap_type1">
     <li><a href="#" class="on">Installation Info</a></li>
     <li><a href="#">Exchange Info</a></li>
     <li><a href="#">Order Info</a></li>
    </ul>

    <article class="tap_area">
     <!-- tap_area start -->
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 140px" />
       <col style="width: *" />
       <col style="width: 110px" />
       <col style="width: *" />
       <col style="width: 140px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row">Install Type</th>
        <td><span><c:out value="${viewDetail.installationInfo.codeName}" /></span></td>
        <th scope="row">Install Number</th>
        <td><span><c:out value="${viewDetail.installationInfo.installEntryNo}" /></span></td>
        <th scope="row">Request Install Date</th>
        <td><span><fmt:formatDate value="${viewDetail.installationInfo.installDt}" pattern="dd-MM-yyyy " /></span></td>
       </tr>
       <tr>
        <th scope="row">Assigned Technician</th>
        <td colspan="3"><span><c:out value=" (${installResult.ctMemCode}) ${installResult.ctMemName}" /></span></td>
        <th scope="row">Result Status</th>
        <td><span><c:out value="${viewDetail.installationInfo.name}" /></span></td>
       </tr>
       <tr>
        <th scope="row">Stock Category</th>
        <td><span><c:out
           value="${viewDetail.installationInfo.codename1}" /></span></td>
        <th scope="row">Install Stock</th>
        <td colspan="3"><span><c:out value="( ${viewDetail.installationInfo.stkCode} ) ${viewDetail.installationInfo.stkDesc}" /></span></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </article>
    <!-- tap_area end -->
    <article class="tap_area">
     <!-- tap_area start -->
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 140px" />
       <col style="width: *" />
       <col style="width: 110px" />
       <col style="width: *" />
       <col style="width: 140px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row">Type</th>
        <td><span><c:out
           value="${viewDetail.exchangeInfo.codeName}" /></span></td>
        <th scope="row">Creator</th>
        <td><span><c:out
           value="${viewDetail.exchangeInfo.c1}" /></span></td>
        <th scope="row">Create Date</th>
        <td><span><fmt:formatDate value="${viewDetail.exchangeInfo.soExchgCrtDt}" pattern="dd-MM-yyyy hh:mm a " /></span></td>
       </tr>
       <tr>
        <th scope="row">Order Number</th>
        <td><span><c:out
           value="${viewDetail.exchangeInfo.salesOrdNo}" /></span></td>
        <th scope="row">Request Status</th>
        <td><span><c:out
           value="${viewDetail.exchangeInfo.name2}" /></span></td>
        <th scope="row">Request Stage</th>
        <td><span><c:out
           value="${viewDetail.exchangeInfo.name1}" /></span></td>
       </tr>
       <tr>
        <th scope="row">Reason</th>
        <td colspan="5"><span><c:out
           value="${viewDetail.exchangeInfo.c2} - ${viewDetail.exchangeInfo.c3} " /></span></td>
       </tr>
       <tr>
        <th scope="row">Product (From)</th>
        <td colspan="5"><span><c:out
           value="${viewDetail.exchangeInfo.c10} - ${viewDetail.exchangeInfo.c11} " /></span>

        </td>
       </tr>
       <tr>
        <th scope="row">Product (To)</th>
        <td colspan="5"><span><c:out
           value="${viewDetail.exchangeInfo.c5} - ${viewDetail.exchangeInfo.c6} " /></span></td>
       </tr>
       <tr>
        <th scope="row">Price / RPF (From)</th>
        <td><span><fmt:formatNumber
           value="${viewDetail.exchangeInfo.soExchgOldPrc}"
           type="number" pattern=".00" /></span></td>
        <th scope="row">PV (From)</th>
        <td><span><fmt:formatNumber
           value="${viewDetail.exchangeInfo.soExchgOldPv}" pattern=".00" /></span></td>
        <th scope="row">Rental Fees (From)</th>
        <td><span><fmt:formatNumber
           value="${viewDetail.exchangeInfo.soExchgOldRentAmt}"
           pattern=".00" /></span></td>
       </tr>
       <tr>
        <th scope="row">Price / RPF (To)</th>
        <td><span><fmt:formatNumber
           value="${viewDetail.exchangeInfo.soExchgNwPrc}" pattern=".00" /></span></td>
        <th scope="row">PV (To)</th>
        <td><span><fmt:formatNumber
           value="${viewDetail.exchangeInfo.soExchgNwPv}" pattern=".00" /></span></td>
        <th scope="row">Rental Fees (To)</th>
        <td><span><fmt:formatNumber
           value="${viewDetail.exchangeInfo.soExchgNwRentAmt}"
           pattern=".00" /></span></td>
       </tr>
       <tr>
        <th scope="row">Promotion (From)</th>
        <td colspan="5"><span><c:out
           value="${viewDetail.exchangeInfo.c7} - ${viewDetail.exchangeInfo.c8} " /></span></td>
       </tr>
       <tr>
        <th scope="row">Promotion (To)</th>
        <td colspan="5"><span><c:out
           value="${viewDetail.exchangeInfo.c12} - ${viewDetail.exchangeInfo.c13} " /></span></td>
       </tr>
       <tr>
        <th scope="row">Remark</th>
        <td colspan="5"><c:out
          value="${viewDetail.exchangeInfo.c15}" /></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </article>
    <!-- tap_area end -->
    <article class="tap_area">
     <!-- tap_area start -->
     <!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
     <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
     <!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
     <%--
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">HP / Cody</a></li>
    <li><a href="#">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a href="#">Mailling Info</a></li>
    <li><a href="#">Rental Pay Setting</a></li>
    <li><a href="#">Membership Info</a></li>
    <li><a href="#">Document Submission</a></li>
    <li><a href="#">Call Log</a></li>
    <li><a href="#">Guarantee Info</a></li>
    <li><a href="#">Payment Listing</a></li>
    <li><a href="#">Last 6 Months Transaction</a></li>
    <li><a href="#">Order Configuration</a></li>
    <li><a href="#">Auto Debit Result</a></li>
    <li><a href="#">Relief Certificate</a></li>
    <li><a href="#">Discount</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Progress Status</th>
    <td><span><c:out value="${viewDetail.progressInfo.prgrs}"/></span></td>
    <th scope="row">Agreement No</th>
    <td><span><c:out value="${viewDetail.progressInfo.prgrs}"/></span></td>
    <th scope="row">Agreement Expiry</th>
    <td><span><c:out value="${viewDetail.progressInfo.prgrs}"/></span></td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordNo}"/></span></td>
    <th scope="row">Order Date</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordDt}"/></span></td>
    <th scope="row">Status</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordStusName}"/></span></td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td><span><c:out value="${viewDetail.basicInfo.appTypeDesc}"/></span></td>
    <th scope="row">Reference No</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordRefNo}"/></span></td>
    <th scope="row">Key At(By)</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordCrtDt} (${viewDetail.basicInfo.ordCrtUserId})"/></span></td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td><span><c:out value="${viewDetail.basicInfo.stockDesc}"/></span></td>
    <th scope="row">PO Number</th>
    <td><span><c:out value="${viewDetail.basicInfo.stockDesc}"/></span></td>
    <th scope="row">Key-inBranch</th>
    <td><span><c:out value="(${viewDetail.basicInfo.keyinBrnchCode}) ${viewDetail.basicInfo.keyinBrnchName}"/></span></td>
</tr>
<tr>
    <th scope="row">PV</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordPv}"/></span></td>
    <th scope="row">Price/RPF</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordAmt}"/></span></td>
    <th scope="row">Rental Fees</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordMthRental}"/></span></td>
</tr>
<tr>
    <th scope="row">Installment Duration</th>
    <td></td>
    <th scope="row">PV Month(Month/Year)</th>
    <td><span><c:out value="${viewDetail.basicInfo.ordPvMonth}/${viewDetail.basicInfo.ordPvYear}"/></span></td>
    <th scope="row">Rental Status</th>
    <td><span><c:out value="${viewDetail.basicInfo.rentalStus}"/></span></td>
</tr>
<tr>
    <th scope="row">Promotion</th>
    <td colspan="3"><span><c:out value="(${viewDetail.basicInfo.ordPromoCode}) ${viewDetail.basicInfo.ordPromoDesc}"/></span></td>
    <th scope="row">Related No</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Serial Number</th>
    <td><span><c:out value="${viewDetail.tabInstallationInfo.lastInstallSerialNo}"/></span></td>
    <th scope="row">Sirim Number</th>
    <td><span><c:out value="${viewDetail.tabInstallationInfo.lastInstallSirimNo}"/></span></td>
    <th scope="row">Update At(By)</th>
    <td><span><c:out value="${viewDetail.basicInfo.updDt} (${viewDetail.basicInfo.updUserId})"/></span></td>
</tr>
<tr>
    <th scope="row">Obligation Period</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">CCP Remark</th>
    <td colspan="5"></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="divine2"><!-- divine3 start -->

<article>
<h3>Salesman Info</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Order Made By</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

<article>
<h3>Cody Info</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Service By</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody Code</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody Name</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody NRIC</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

</section><!-- divine2 start -->


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><span><c:out value="${viewDetail.basicInfo.custId}"/></span></td>
    <th scope="row">Customer Name</th>
    <td colspan="3"><span><c:out value="${viewDetail.basicInfo.custName}"/></span></td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
    <td><span><c:out value="${viewDetail.basicInfo.custType}"/></span></td>
    <th scope="row">NRIC/Company No</th>
    <td><span><c:out value="${viewDetail.basicInfo.custNric}"/></span></td>
    <th scope="row">JomPay Ref-1</th>
    <td><span><c:out value="${viewDetail.basicInfo.jomPayRef}"/></span></td>
</tr>
<tr>
    <th scope="row">Nationality</th>
    <c:if test="${viewDetail.basicInfo.custNation  != '' }">
    <td><span><c:out value="${viewDetail.basicInfo.custNation}"/></span></td>
    </c:if>
    <c:if test="${viewDetail.basicInfo.custNation  == '' }">
    <td><span>-</span></td>
    </c:if>
    <th scope="row">Gender</th>
    <c:if test="${viewDetail.basicInfo.custGender  == 'F' }">
    <td><span>Female</span></td>
    </c:if>
    <c:if test="${viewDetail.basicInfo.custGender  == 'M' }">
    <td><span>Male</span></td>
    </c:if>
    <th scope="row">Race</th>
    <c:if test="${viewDetail.basicInfo.custRace  != '' }">
    <td><span><c:out value="${viewDetail.basicInfo.custRace}"/></span></td>
    </c:if>
    <c:if test="${viewDetail.basicInfo.custRace  == '' }">
    <td><span>-</span></td>
    </c:if>
</tr>
<tr>
    <th scope="row">VA Number</th>
    <td><span><c:out value="${viewDetail.basicInfo.custVaNo}"/></span></td>
    <th scope="row">Passport Exprire</th>
    <td><span><c:out value="${viewDetail.basicInfo.custPassportExpr}"/></span></td>
    <th scope="row">Visa Exprire</th>
    <td><span><c:out value="${viewDetail.basicInfo.custVisaExpr}"/></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Same Rental Group Order(s)</h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Installation Address</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Country</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">State</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Area</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Prefer Install Date</th>
    <td><span>text</span></td>
    <th scope="row">Prefer Install Time</th>
    <td><span>text</span></td>
    <th scope="row">Postcode</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Instruction</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">DSC Verification Remark</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Installed Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td><span>text</span></td>
    <th scope="row">CT Name</th>
    <td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span><c:out value="${viewDetail.basicInfo.custVisaExpr}"/></span></td>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span><c:out value="${viewDetail.basicInfo.custVisaExpr}"/></span></td>
    <th scope="row">Email</th>
    <td><span>text</span></td>
    <th scope="row">Fax No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>text</span></td>
    <th scope="row">Department</th>
    <td><span>text</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Mailing Address</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Country</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">State</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Area</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Billing Group</th>
    <td><span>text</span></td>
    <th scope="row">Billing Type</th>
    <td>
    <label><input type="checkbox" /><span>SMS</span></label>
    <label><input type="checkbox" /><span>Post</span></label>
    <label><input type="checkbox" /><span>E-statement</span></label>
    </td>
    <th scope="row">Postcode</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>text</span></td>
    <th scope="row">Email</th>
    <td><span>text</span></td>
    <th scope="row">Fax No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>text</span></td>
    <th scope="row">Departiment</th>
    <td><span>text</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Guarantee Status</th>
    <td colspan="3"><span>text</span></td>
</tr>
<tr>
    <th scope="row">HP Code</th>
    <td><span>text</span></td>
    <th scope="row">HP Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">HM Code</th>
    <td><span>text</span></td>
    <th scope="row">HM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">SM Code</th>
    <td><span>text</span></td>
    <th scope="row">SM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">GM Code</th>
    <td><span>text</span></td>
    <th scope="row">GM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">BS Availability</th>
    <td><span>text</span></td>
    <th scope="row">BS Frequency</th>
    <td><span>text</span></td>
    <th scope="row">Last BS Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">BS Cody Code</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Config Remark</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Happy Call Service</th>
    <td colspan="5">
    <label><input type="checkbox" /><span>Installation Type</span></label>
    <label><input type="checkbox" /><span>BS Type</span></label>
    <label><input type="checkbox" /><span>AS Type</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Prefer BS Week</th>
    <td colspan="5">
    <label><input type="radio" name="week" /><span>None</span></label>
    <label><input type="radio" name="week" /><span>Week1</span></label>
    <label><input type="radio" name="week" /><span>Week2</span></label>
    <label><input type="radio" name="week" /><span>Week3</span></label>
    <label><input type="radio" name="week" /><span>Week4</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reference No</th>
    <td><span>text</span></td>
    <th scope="row">Certificate Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">GST Registration No</th>
    <td colspan="3"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end --> --%>
    </article>
    <!-- tap_area end -->
   </section>
  </form>
  <!-- tap_wrap end -->
  <!--  180125 입력 폼 변경 -->
  <%-- <aside class="title_line"><!-- title_line start -->
<h3>Installation Result</h3>
</aside><!-- title_line end -->

<input type="hidden" value="${viewDetail.installationInfo.c2}" id="hiddenAssignCTMemId" name="hiddenAssignCTMemId"/>
<input type="hidden" value="${viewDetail.installationInfo.c5}" id="hiddenAssignCTWHId" name="hiddenAssignCTWHId"/>
<input type="hidden" value="${viewDetail.installationInfo.installStkId}" id="hiddenInstallStkId" name="hiddenInstallStkId"/>
<input type="hidden" value="${viewDetail.installationInfo.c8}" id="hiddenInstallStkCategoryId" name="hiddenInstallStkCategoryId"/>
<input type="hidden" value="${viewDetail.installationInfo.c6}" id="hiddenDSCBranchId" name="hiddenDSCBranchId"/>
<input type="hidden" value="${viewDetail.installationInfo.c10}" id="hiddenDOWarehouseCode" name="hiddenDOWarehouseCode"/>
<input type="hidden" value="${viewDetail.installationInfo.c9}" id="hiddenDOWarehouseId" name="hiddenDOWarehouseId"/>
<input type="hidden" value="${viewDetail.basicInfo.ordId}" id="hiddenOrderId" name="hiddenOrderId"/>
<input type="hidden" value="${viewDetail.basicInfo.ordStusId}" id="hiddenOrderStatusId" name="hiddenOrderStatusId"/>
<input type="hidden" value="${viewDetail.basicInfo.appTypeCode}" id="hiddenAppTypeCode" name="hiddenAppTypeCode"/>
<input type="hidden" value="${viewDetail.installationInfo.installEntryNo}" id="hiddenInstallNo" name="hiddenInstallNo"/>
<input type="hidden" value="${viewDetail.installationInfo.installEntryId}" id="hiddenInstallEntryId" name="hiddenInstallEntryId"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" id="status" name="status">
        <c:forEach var="list" items="${viewDetail.installStatus}" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Actual Install Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="acInstallDate" name="acInstallDate" /></td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td><input type="text" title="" placeholder="" class="" id="CTCode" name="CTCode"/><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    <input type="hidden" title="" placeholder="" class="" id="CTID" name="CTID"/>
    </td>
    <th scope="row">CT Name</th>
    <td><input type="text" title="" placeholder="" class="" id="CTName" name="CTName"/></td>
</tr>
<tr>
    <th scope="row">Sirim Number</th>
    <td><input type="text" title="" placeholder="" class="" id="sirimNo" name="sirimNo"/></td>
    <th scope="row">Serial Number</th>
    <td><input type="text" title="" placeholder="" class="" id="serialNo" name="serialNo"/></td>
</tr>
 <tr>
    <th scope="row">Ref Number (1)</th>
    <td><input type="text" title="" placeholder="" class="" id="refNo1" name="refNo1"/></td>
    <th scope="row">Ref Number (2)</th>
    <td><input type="text" title="" placeholder="" class="" id="refNo2" name="refNo2"/></td>
</tr>
<tr>
    <th scope="row">Failed Reason</th>
    <td><input type="text" title="" placeholder="" class="" id="failReason" name="failReason"/></td>
    <th scope="row">Next Call Date</th>
    <td><input type="text" title="" placeholder="" class="" id="nextCallDate" name="nextCallDate"/></td>
</tr>
<tr>
    <td colspan="4">
    <label><input type="checkbox" id="checkCommission" name="checkCommission"/><span>Allow Commission ?</span></label>
    <label><input type="checkbox" id="reqSms" name="reqSms"/><span>Require SMS ?</span></label>
    <label><input type="checkbox" id="checkTrade" name="checkTrade"/><span>Is trade in ?</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea cols="20" rows="5" placeholder="" id="remark" name="remark"></textarea></td>
</tr>
</tbody>
</table><!-- table end --> --%>
  <aside class="title_line">
   <!-- title_line start -->
   <h2>
    <spring:message code='service.title.AddInstallationResult' />
   </h2>
  </aside>
  <!-- title_line end -->
  <form action="#" id="addInstallForm" method="post">
   <input type="hidden" name="hidStkId" id="hidStkId" value="${installResult.installStkId}">
   <input type="hidden"  value="<c:out value="${installResult.installEntryId}"/>" id="installEntryId" name="installEntryId" />
   <input type="hidden"  value="${callType.typeId}" id="hidCallType" name="hidCallType" />
   <input type="hidden"  value="${installResult.installEntryId}" id="hidEntryId" name="hidEntryId" />
   <input type="hidden"  value="${installResult.custId}" id="hidCustomerId" name="hidCustomerId" />
   <input type="hidden"  value="${installResult.salesOrdId}" id="hidSalesOrderId" name="hidSalesOrderId" />
   <input type="hidden"  value="${installResult.sirimNo}" id="hidSirimNo" name="hidSirimNo" />
   <input type="hidden"  value="${installResult.serialNo}" id="hidSerialNo" name="hidSerialNo" />
   <input type="hidden"  value="${installResult.isSirim}" id="hidStockIsSirim" name="hidStockIsSirim" />
   <input type="hidden"  value="${installResult.stkGrad}" id="hidStockGrade" name="hidStockGrade" />
   <input type="hidden"  value="${installResult.stkCtgryId}" id="hidSirimTypeId" name="hidSirimTypeId" />
   <input type="hidden"  value="${installResult.codeId}" id="hidAppTypeId" name="hidAppTypeId" />
   <input type="hidden"  value="${installResult.installStkId}" id="hidProductId" name="hidProductId" />
   <input type="hidden"  value="${installResult.custAddId}" id="hidCustAddressId" name="hidCustAddressId" />
   <input type="hidden"  value="${installResult.custCntId}" id="hidCustContactId"  name="hidCustContactId" />
   <input type="hidden"  value="${installResult.custBillId}" id="hiddenBillId" name="hiddenBillId" />
   <input type="hidden"  value="${installResult.codeName}" id="hiddenCustomerPayMode" name="hiddenCustomerPayMode" />
   <input type="hidden"  value="${installResult.installEntryNo}" id="hiddeninstallEntryNo"  name="hiddeninstallEntryNo" />
   <input type="hidden" value="" id="hidActualCTMemCode" name="hidActualCTMemCode" />
   <input type="hidden" value="" id="hidActualCTId" name="hidActualCTId" />
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
   <input type="hidden" value="" id="hidPEPreviousStatus" name="hidPEPreviousStatus" />
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
   <input type="hidden" value="${promotionView.swapPormoPrice}" id="hidSwapPromoPrice" name="hidSwapPromoPrice" />
   <input type="hidden" value="${promotionView.swapPromoPV}" id="hidSwapPromoPV" name="hidSwapPromoPV" />
   <input type="hidden" value="" id="hiddenInstallPostcode" name="hiddenInstallPostcode" />
   <input type="hidden" value="" id="hiddenInstallPostcode" name="hiddenInstallPostcode" />
   <input type="hidden" value="" id="hiddenInstallStateName" name="hiddenInstallStateName" />
   <input type="hidden" value="${customerInfo.name}" id="hidCustomerName"  name="hidCustomerName" />
   <input type="hidden" value="${customerContractInfo.telM1}" id="hidCustomerContact"  name="hidCustomerContact" />
   <input type="hidden" value="${installResult.salesOrdNo}" id="hidTaxInvDSalesOrderNo" name="hidTaxInvDSalesOrderNo" />
   <input type="hidden" value="${installResult.installEntryNo}" id="hidTradeLedger_InstallNo" name="hidTradeLedger_InstallNo" />
   <c:if test="${installResult.codeid1  == '257' }">
    <input type="hidden" value="${orderInfo.c5}" id="hidOutright_Price" name="hidOutright_Price" />
   </c:if>
   <c:if test="${installResult.codeid1  == '258' }">
    <input type="hidden" value=" ${orderInfo.c12}" id="hidOutright_Price" name="hidOutright_Price" />
   </c:if>
   <input type="hidden" value="${installation.Address}" id="hidInstallation_AddDtl" name="hidInstallation_AddDtl" />
   <input type="hidden" value="${installation.areaId}"  id="hidInstallation_AreaID" name="hidInstallation_AreaID" />
   <input type="hidden" value="${customerContractInfo.name}" id="hidInatallation_ContactPerson" name="hidInatallation_ContactPerson" />
    <input type="hidden" value="${installResult.rcdTms}" id="rcdTms" name="rcdTms" />
    <input type="hidden" value="${installResult.serialRequireChkYn}" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
    <input type="hidden" id='hidStockSerialNo' name='hidStockSerialNo' />
    <input type="hidden" value="${viewDetail.basicInfo.custType}" id="custType" name="custType" />
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
        <th scope="row">Before Stock</th>
        <td colspan="3"><span><c:out value="${viewDetail.exchangeInfo.c10} - ${viewDetail.exchangeInfo.c11} " /></span>
           <input type="text" id='stockSerialNo' name='stockSerialNo' value="${orderDetail.basicInfo.exchReturnSerialNo}" class="readonly" readonly/>
            <p class="btn_grid" style="display:none" id="btnSerialEdit"><a href="#" onClick="fn_serialModifyPop()">EDIT</a></p>
        </td>
       </tr>
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
      </select></td>
      <th scope="row"><spring:message
        code='service.title.ActualInstalledDate' /><span name="m2" id="m2" class="must">*</span></th>
      <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="installDate" name="installDate" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.CTCode' /><span name="m3" id="m3" class="must">*</span></th>
      <td colspan="3"><input type="text" title="" value="<c:out value="(${installResult.ctMemCode}) ${installResult.ctMemName}"/>"
       placeholder="" class="readonly" style="width: 100%;" id="ctCode" readonly="readonly" name="ctCode" />
       <input type="hidden" title="" value="${installResult.ctId}" placeholder="" class="" style="width: 200px;" id="CTID" name="CTID" />
       <!-- <p class="btn_sky"><a href="#">Search</a></p></td> -->
       <%-- <th scope="row"><spring:message code='service.title.CTName' /></th>
              <td><input type="text" title="" placeholder=""
                class="readonly w100p" readonly="readonly" id="ctName"
                name="ctName" /></td> --%>
     </tr>
     <tr>
            <th scope="row"><spring:message code='service.title.PSIRcd' /><span name="m8" id="m8" class="must">*</span></th>
            <td>
              <input type="text" title="" placeholder="<spring:message code='service.title.PSIRcd' />" class="w100p" id="psiRcd" name="psiRcd" onkeypress='validate(event)' onblur='validate2(this);' />
            </td>
            <th scope="row"><spring:message code='service.title.lmp' /><span name="m9" id="m9" class="must">*</span></th>
            <td>
              <input type="text" title="" placeholder="<spring:message code='service.title.lmp' />" class="w100p" id="lpmRcd" name="lpmRcd" onkeypress='validate(event)' onblur='validate2(this);' />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.Volt' /><span name="m10" id="m10" class="must">*</span></th>
            <td>
              <input type="text" title="" placeholder="<spring:message code='service.title.Volt' />" class="w100p" id="volt" name="volt" onkeypress='validate(event)' onblur='validate2(this);' />
            </td>
            <th scope="row"><spring:message code='service.title.TDS' /><span name="m11" id="m11" class="must">*</span></th>
            <td>
              <input type="text" title="" placeholder="<spring:message code='service.title.TDS' />" class="w100p" id="tds" name="tds" onkeypress='validate(event)' onblur='validate2(this);' />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.RoomTemp' /><span name="m12" id="m12" class="must">*</span></th>
            <td>
              <input type="text" title="" placeholder="<spring:message code='service.title.RoomTemp' />" class="w100p" id="roomTemp" name="roomTemp" onkeypress='return validateFloatKeyPress(this,event)' onblur='validate3(this);' />
            </td>
            <th scope="row"><spring:message code='service.title.WaterSourceTemp' /><span name="m13" id="m13" class="must">*</span></th>
            <td>
              <input type="text" title="" placeholder="<spring:message code='service.title.WaterSourceTemp' />" class="w100p" id="waterSourceTemp" name="waterSourceTemp" onkeypress='return validateFloatKeyPress(this,event)' onblur='validate3(this);' />
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
             <th scope="row"><spring:message code='service.title.ntu'/><span name="m28" id="m28" class="must">*</span></th>
           <td><input type="text" title="NTU" class="w100p" id="ntuCom" name="ntuCom" placeholder="0.00" maxlength="5" onkeypress='return validateFloatKeyPress(this,event)' onblur='validate3(this);' />
           </td>
          </tr>
           <tr>
          <th scope="row"><spring:message code="service.title.installation.accessories" />
          <input type="checkbox" id="chkInstallAcc" name="chkInstallAcc" onChange="fn_InstallAcc_CheckedChanged(this)" checked/></th>
    		<td colspan="3">
    		<select class="w100p" id="installAcc" name="installAcc">
    		</select>
    		</td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.adptUsed' /><span name="m14" id="m14" class="must">*</span></th>
            <td colspan='3'>
              <select class="w100p" id="adptUsed" name="adptUsed">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${adapterUsed}" varStatus="status">
                  <option value="${list.codeId}" select>${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row">Mobile</th>
            <td>
              <input type="text" title="" value ="${orderDetail.installationInfo.instCntTelM}" placeholder="Mobile No" id="custMobileNo" name="custMobileNo" style="width:50%;"/>
              <span>SMS</span><input type="checkbox" id="chkSms" name="chkSms" checked>
            </td>
          </tr>
    </tbody>
   </table>
   <br/>
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
      <td  colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.SIRIMNo' />" class="w100p"
       id="sirimNo" name="sirimNo" /></td>
      <th scope="row"><spring:message code='service.title.SerialNo' /><span name="m5" id="m5" class="must">*</span></th>
      <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.SerialNo' />" class="w50p"
       id="serialNo" name="serialNo" />
       <c:if test="${installResult.serialRequireChkYn == 'Y' }">
       <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop()" ><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
       </c:if>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.RefNo' />(1)</th>
      <td  colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.RefNo' />(1)" class="w100p"
       id="refNo1" name="refNo1" /></td>
      <th scope="row"><spring:message code='service.title.RefNo' />(2)</th>
      <td  colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.RefNo' />(2)" class="w100p"
       id="refNo2" name="refNo2" /></td>
     </tr>
     <tr>
      <td colspan="8"><label><input type="checkbox"
        id="checkCommission" name="checkCommission" /><span><spring:message
          code='service.btn.AllowCommission' /> ?</span></label> <label><input
        type="checkbox" id="checkTrade" name="checkTrade" /><span><spring:message
          code='service.btn.IsTradeIn' /> ?</span></label> <label><input
        type="checkbox" id="checkSms" name="checkSms" /><span><spring:message
          code='service.btn.RequireSMS' /> ?</span></label></td>
     </tr>
    </tbody>
   </table>
      <aside class="title_line"  id="attachmentTitle">
        <h2>
          <spring:message code='service.text.attachment' />
         </h2>
      </aside>
      <table class="type1" id="attachmentArea">
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
        <div id="grid_wrap_instChk_view" style="width: 100%; height: 170px;  margin: 90 auto;" class="hide"></div>
      </article>
      <!-- grid_wrap end -->
      <tr>
        <td colspan="8">
          <label><input type="checkbox" id="instChklstCheckBox" name="instChklstCheckBox" value="Y" class="hide" /><span id="instChklstDesc" name="instChklstDesc" class="hide"><spring:message code='service.btn.instChklst' /> </span></label>
        </td>
      </tr>
   <!-- table end -->
   <aside class="title_line" id="completedHide1">
    <!-- title_line start -->
    <h2>
     <spring:message code='service.title.SMSInfo' />
    </h2>
   </aside>
   <!-- title_line end -->
   <table class="type1" id="completedHide2">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 110px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <td colspan="2"><label><input type="checkbox"  id="checkSend" name="checkSend" /><span><spring:message code='service.title.SendSMSToSalesPerson' /></span></label></td>
     </tr>
     <tr>
      <th scope="row" rowspan="2"><spring:message
        code='service.title.Message' /></th>
      <td>
        <textarea cols="20" rows="5" readonly="readonly" class="readonly" id="msg" name="msg">
                  RM0.00 COWAY DSC
                  Install Status: Completed
                  Order No: ${viewDetail.exchangeInfo.salesOrdNo}
                  Name: ${orderInfo.name2}
        </textarea>
        </td>
     </tr>
     <tr>
      <td><input type="text" title="" placeholder="Remark" class="w100p" value="Remark:" id="msgRemark" name="msgRemark" /></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <table class="type1" id="failHide3">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 110px" />
     <col style="width: *" />
    </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='service.title.FailedLocation' /><span name="m15" id="m15" class="must">*</span></th>
            <td>
              <select class="w100p" id="failLocCde" name="failLocCde" onchange="fn_openFailChild(this.value)">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failParent}" varStatus="status">
                  <%-- <option value="${list.defectId}">${list.defectDesc}</option> --%>
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
            </select></td>
            <th scope="row"><spring:message code='service.title.FailedReason' /><span name="m16" id="m16" class="must">*</span></th>
            <td>
              <select class="w100p" id="failReasonCode" name="failReasonCode">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failChild}" varStatus="status">
                  <option value="${list.defectId}">${list.defectDesc}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='service.title.NextCallDate' /><span name="m7" id="m7" class="must">*</span></th>
            <td>
              <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="nextCallDate" name="nextCallDate" />
            </td>
            <th scope="row"><spring:message code='service.title.ntu'/><span id="m29" class="must">*</span></th>
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
      <td><input type="text" title="" placeholder="<spring:message code='service.title.Remark' />" class="w100p"
       id="remark" name="remark" /></td>
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
  <!-- <ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_installProductExchangeSave()">Save</a></p></li>
</ul> -->
  <!-- </form> -->
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->