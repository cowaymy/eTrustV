<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<script type="text/javaScript">
    var serialGubun = "1";
    var myFileCaches = {};
    var installAccTypeId = 583;

    $(document).ready(function() {
    	var today = new Date();
    	var minDate = new Date(today.getFullYear(), today.getMonth(), 1);
    	var pickerOpts={
    	        minDate: minDate,
    	        maxDate: today,
    	        dateFormat: "dd/mm/yy"
    	};
    	$(".j_dateHc").datepicker(pickerOpts);

        var myGridID_view;
        var callType = "${callType.typeId}";
        doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
        if("${installResult.preinstalltionStus}"){
            $("#addInstallForm #serialNo").val("${installResult.preinstallationSerialNo}");
            $("#addInstallForm #frmSerialNo").val("${installResult.preinstallationSerialNo2}");
            $("#addInstallForm #installStatus").val("${installResult.preinstalltionStus}");
            $("#addInstallForm #remark").val("${installResult.preinstallationRemark}");
            $("#addInstallForm #failLocCde").val("${installResult.preinstallationFalLoc}");
            $("#failReasonCode").attr("disabled",false);
            doGetCombo('/services/selectFailChild.do', "${installResult.preinstallationFalLoc}", '','failReasonCode', 'S' , `(() => {
                $("#addInstallForm #failReasonCode").val("${installResult.preinstallationFalRsn}");
            })`);
            document.getElementById("preinstallationImg").style.display="";
       }


        createInstallationViewAUIGrid();
        fn_viewInstallResultSearch();

        $("#hpMsg").val("COWAY: Order No: " + "${installResult.salesOrdNo}" + " \nName: " + "${hpMember.name1}"
                + " \nInstall Status: Completed");

        if (callType == 0) {
    	   $(".red_text").text("<spring:message code='service.msg.InstallationInformation'/>");
    	} else {
    	    if ("${orderInfo.c9}" == 21) {
    	        $(".red_text").text("<spring:message code='service.msg.InstallationStatus'/>");
    	    } else if ("${orderInfo.c9}" == 4) {
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

        if ("${orderInfo.installEntryId}" != null) {
            $("#hidCategoryId").val("${orderInfo.stkCtgryId}");
            $("#hidStockCode").val("${orderInfo.stkCode}");//aircon
            $("#hidFrmStockCode").val("${frameInfo.stockCode}");//aircon

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
            $("#addInstallForm #m2").hide();
            $("#addInstallForm #m4").hide();
            $("#addInstallForm #m5").hide();
        } else {
            $("#addInstallForm #m6").hide();
            $("#addInstallForm #m7").hide();
            $("#addInstallForm #m8").hide();
        }

        $("#hiddenCustomerType").val("${customerContractInfo.typeId}");
        $("#checkCommission").prop("checked", true);

        $("#addInstallForm #installStatus").change(function() {
            if ($("#addInstallForm #installStatus").val() == 4) {
                $("#checkCommission").prop("checked", true);
                $("#hpMsg").val("COWAY: Order No: " + "${installResult.salesOrdNo}" + " \nName: " + "${hpMember.name1}"
                		+ " \nInstall Status: Completed");
            } else {
                $("#checkCommission").prop("checked", false);
                $("#hpMsg").val("COWAY: Order No: " + "${installResult.salesOrdNo}" + " \nName: " + "${hpMember.name1}"
                        + " \nInstall Status: Failed");
            }
        });

        $("#failReasonCode").change(function() {
        	if ($("#addInstallForm #installStatus").val() != 4) {
        		var msg = $("#hpMsg").val();
        		var failReasonText = this.options[this.selectedIndex].text;
        		var failReasonSlice = failReasonText.slice(7);
                msg += "\nFailed Reason: " + failReasonSlice;
                $("#hpMsg").val(msg);
        	}
        });

        $("#installDate").change(function() {
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

//             Common.ajax("GET", "/services/checkMonth.do?intallDate="+ checkMon, ' ', function(result) {
//                 if (result.message == "Please choose this month only") {
//                     Common.alert(result.message);
//                     $("#installDate").val('');
//                 }
//             });
        });

        $("#addInstallForm #installStatus").change(function() {
            if ($("#addInstallForm #installStatus").val() == 4) {
                $("#addInstallForm #checkCommission").prop("checked", true);
                $("#addInstallForm #m6").hide();
                $("#addInstallForm #m7").hide();
                $("#addInstallForm #m8").hide();
                $("#addInstallForm #m2").show();
                $("#addInstallForm #m4").show();
                $("#addInstallForm #m5").show();
                $("#addInstallForm #chkInstallAcc").prop("checked", true);
                doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
            } else {
                $("#addInstallForm #checkCommission").prop("checked", false);
                $("#addInstallForm #m2").hide();
                $("#addInstallForm #m4").hide();
                $("#addInstallForm #m5").hide();
                $("#addInstallForm #m6").show();
                $("#addInstallForm #m7").show();
                $("#addInstallForm #m8").show();

                $("#addInstallForm #chkInstallAcc").prop("checked", false);
                doGetComboSepa('/common/selectCodeList.do', 0, '', '','installAcc', 'M' , 'f_multiCombo');
            }

            $("#addInstallForm #installDate").val("");
            $("#addInstallForm #sirimNo").val("");
            $("#addInstallForm #serialNo").val("");
            $("#addInstallForm #refNo1").val("");
            $("#addInstallForm #refNo2").val("");
            $("#addInstallForm #checkTrade").prop("checked", false);
            $("#addInstallForm #checkSms").prop("checked", false);
            $("#addInstallForm #msgRemark").val("Remark:");
            $("#addInstallForm #failLocCde").val("");
            $("#addInstallForm #failReason").val("0");
            $("#addInstallForm #nextCallDate").val("");
            $("#addInstallForm #remark").val("");
        });

        if(js.String.isEmpty( $("#hidFrmOrdNo").val() )){
        	$(".frmS1").hide();
        	$(".frmS3").hide();
        }else{
        	$(".frmS1").show();
        	$(".frmS3").show();
        }

        if(js.String.strNvl($("#hidFrmSerialChkYn").val()) == "Y"){
        	$("#frm2").show();
            $("#frmSerialNo").removeAttr("disabled").removeClass("readonly");
            if($("#ordCtgryCd").val() == "ACI"){
            	$(".airconm").show();
            }
        }else{
        	$("#frm2").hide();
        	if($("#ordCtgryCd").val() == "ACI"){
        		$("#frm2").show();
        		$("#frmSerialNo").removeAttr("disabled").removeClass("readonly");
        		$(".airconm").show();
        	}else{
        		$("#frmSerialNo").attr("disabled", true).addClass("readonly");
        	}
        }

        // ADIB - Hide DT PAIR For Aircond
        if($("#ordCtgryCd").val() == "ACI"){
            $(".dtPair1").hide();
            $(".dtPair2").hide();
            $(".dtPair3").show();
            $(".dtPair4").show();
        }
        else {
            $(".dtPair1").show();
            $(".dtPair2").show();
            $(".dtPair3").hide();
            $(".dtPair4").hide();
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

    function onchangeStatus(){

    }


    function fn_saveInstall() {
	    var msg = "";
	    var custMobileNo = $("#custMobileNo").val().replace(/[^0-9\.]+/g, "") ;
	    var chkMobileNo = custMobileNo.substring(0, 2);
	    if (chkMobileNo == '60'){
	        custMobileNo = custMobileNo.substring(1);
	    }
	    $("#custMobileNo").val(custMobileNo);

	    var hpPhoneNo = $("#hpPhoneNo").val().replace(/[^0-9\.]+/g, "") ;
        var chkHpPhoneNo = hpPhoneNo.substring(0, 2);
        if (chkHpPhoneNo == '60'){
        	hpPhoneNo = hpPhoneNo.substring(1);
        }
        $("#hpPhoneNo").val(hpPhoneNo);

	    if ($("#addInstallForm #installStatus").val() == 4) { // COMPLETED

	     if ($("#failLocCde").val() != 0 || $("#failReasonCode").val() != 0 || $("#nextCallDate").val() != "") {
	    	  Common.alert("Not allowed to choose a reason for fail or recall date in complete status");
	    	  return;
	     }

/* 	     if (($("#dtPairCode").val() == 0 || $("#dtPairCode").val() == "") && $("#ordCtgryCd").val() != "ACI") {
	    	 Common.alert("Please choose a DT Pair");
	         return;
	     } */

	     /*  if ($("#failReason").val() != 0 || $("#nextCallDate").val() != '') {
	    	        Common.alert("Not allowed to choose a reason for fail or recall date in complete status");
	        return;
	      } */

	      if ($("#addInstallForm #installDate").val() == '') {
	        msg += "* <spring:message code='sys.msg.necessary' arguments='Actual Install Date' htmlEscape='false'/> </br>";
	      }
// 	      if ($("#addInstallForm #sirimNo").val().trim() == '' || ("#addInstallForm #sirimNo") == null) {
// 	        msg += "* <spring:message code='sys.msg.necessary' arguments='SIRIM No' htmlEscape='false'/> </br>";
// 	      }
	      if ($("#addInstallForm #serialNo").val().trim() == '' || ("#addInstallForm #serialNo") == null) {
	        msg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
	      } else {
	        if ($("#addInstallForm #serialNo").val().trim().length < 18) {
	          msg += "* <spring:message code='sys.msg.invalid' arguments='Serial No' htmlEscape='false'/> </br>";
	        }
	      }

	      if($("#addInstallForm #serialNo").val().trim() != ""){
		      if(!fn_AlphanumericRegexCheck($("#addInstallForm #serialNo").val())){
		          msg += "* No Special Character Allowed for Serial No </br>";
		      }
	      }

	      if($("#addInstallForm #frmSerialNo").val().trim() != ""){
		      if(!fn_AlphanumericRegexCheck($("#addInstallForm #frmSerialNo").val())){
		          msg += "* No Special Character Allowed for Frame Serial No </br>";
		      }
	      }

	      if ($("#frmSerialNo").hasClass("readonly") == false
	    		&& ($("#addInstallForm #frmSerialNo").val().trim() == '' || ("#addInstallForm #frmSerialNo") == null)) {
	    	  msg += "* <spring:message code='sys.msg.necessary' arguments='Frame Serial No' htmlEscape='false'/> </br>";
	      }else{
	    	  if ($("#frmSerialNo").hasClass("readonly") == false && $("#addInstallForm #frmSerialNo").val().trim().length < 18) {
	    		  msg += "* <spring:message code='sys.msg.invalid' arguments='Frame Serial No' htmlEscape='false'/> </br>";
	    	  }
	      }

	      //validate aircon serial
	      if($("#ordCtgryCd").val() == "ACI"){
	    	  var stockCode = "";

	    	  console.log($("#addInstallForm #serialNo").val().trim().substr(3,5));
	          stockCode = (js.String.roughScale($("#addInstallForm #serialNo").val().trim().substr(3,5), 36)).toString();
	           if(stockCode != "0" && $("#hidStockCode").val() != stockCode){
	               msg += "* Serial Number NOT match with stock [" + $("#hidStockCode").val() +"] </br>";
	           }

	           console.log("stockCode " + stockCode);

	          var frmStockCode = "";
	          frmStockCode = (js.String.roughScale($("#addInstallForm #frmSerialNo").val().trim().substr(3,5), 36)).toString();

	          console.log("frmStockCode " + frmStockCode);

	          if(frmStockCode != "0" && $("#hidFrmStockCode").val() != frmStockCode){
	              msg += "* Serial Number NOT match with stock [" + $("#hidFrmStockCode").val() +"] </br>";
	          }

// 	          if ($("input[type=radio][name=dismantle]:checked").val() == '' || $("input[type=radio][name=dismantle]:checked").val() == null) {
// 	        	  msg += "* <spring:message code='sys.msg.necessary' arguments='Dismantle' htmlEscape='false'/> </br>";
// 	          }

// 	          if ($("#totalPipe").val() == '' || $("#totalPipe").val() == null) {
//                   msg += "* <spring:message code='sys.msg.necessary' arguments='Total Copper Wire' htmlEscape='false'/> </br>";
//               }

// 	          if ($("#totalWire").val() == '' || $("#totalWire").val() == null) {
//                   msg += "* <spring:message code='sys.msg.necessary' arguments='Total Wire' htmlEscape='false'/> </br>";
//               }

// 	          if ($("#gaspreBefIns").val() == '' || $("#gaspreBefIns").val() == null) {
//                   msg += "* <spring:message code='sys.msg.necessary' arguments='Gas pressure before install' htmlEscape='false'/> </br>";
//               }

// 	          if ($("#gaspreAftIns").val() == '' || $("#gaspreAftIns").val() == null) {
//                   msg += "* <spring:message code='sys.msg.necessary' arguments='Gas pressure after install' htmlEscape='false'/> </br>";
//               }
	      }
         //validate aircon serial

        var hidDismantle = $("input[type=radio][name=dismantle]:checked").val();
        $("#hidDismantle").val(hidDismantle);

	      if ($("#custMobileNo").val().trim() == '' && $("#chkSMS").is(":checked")) {
	          msg += "* Please fill in customer mobile no </br> Kindly proceed to edit customer contact info </br>";
	      }

	   // Installation Accessory checking for Complete status
	      if($("#addInstallForm #chkInstallAcc").is(":checked") && ($("#installAcc").val() == "" || $("#installAcc").val() == null)){
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

	        if ("${installResult.preinstalltionStus}") {
	          isValid = true;
	        } else {
	            if(fileContentsArr.length < 3){
	                 isValid = false;
	             }else{
	                 isValid = true;
	             }
	        }

	        if(isValid == true)  {
	             Common.ajaxFile("/homecare/services/install/attachFileUpload.do", formData, function(result) {
	                if(result != 0 && result.code == 00) {
	                      // KR-OHK Serial Check add
	                      console.log($("#addInstallForm").serializeJSON());
	                  var saveForm = {
	                          "installForm" : $("#addInstallForm").serializeJSON(),
	                          "installAccList" : $("#installAcc").val() ,
	                          "fileGroupKey": result.data.fileGroupKey
	                    };

	                    Common.ajax("POST", "/homecare/services/install/hcAddInstallationSerial.do", saveForm, function(result) {
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
	      if ($("#failReason").val() == 0) {
	        msg += "* <spring:message code='sys.msg.necessary' arguments='Failed Reason' htmlEscape='false'/> </br>";
	      }

	      if ($("#nextCallDate").val() == '') {
	        msg += "* <spring:message code='sys.msg.necessary' arguments='Next Call Date' htmlEscape='false'/> </br>";
	      }

/* 	      if (($("#dtPairCode").val() == 0 || $("#dtPairCode").val() == "") && $("#ordCtgryCd").val() != "ACI") {
	    	msg += "Please choose a DT Pair";
	      } */

	      if ($("#custMobileNo").val().trim() == '' && $("#chkSMS").is(":checked")) {
	          msg += "* Please fill in customer mobile no </br> Kindly proceed to edit customer contact info </br>";
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

          Common.ajaxFile("/homecare/services/install/attachFileUpload.do", formData, function(result) {
              if(result != 0 && result.code == 00) {
                    // KR-OHK Serial Check add
                var saveInsFailedForm = {
                        "installForm" : $("#addInstallForm").serializeJSON(),
                        "installAccList" : $("#installAcc").val() ,
                        "mobileYn" : "N" ,
                        "fileGroupKey": result.data.fileGroupKey
                  };

                  Common.ajax("POST", "/homecare/services/install/hcAddInstallationSerial.do", saveInsFailedForm, function(result) {
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
      headerText : "DT Code",
      editable : false,
      width : 250
    }, {
      dataField : "name",
      headerText : "DT Name",
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

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_view = AUIGrid.create("#grid_wrap_view", columnLayout, gridPros);
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


   function fn_serialSearchPop1(){
	   serialGubun = "1";

       $("#pLocationType").val('${installResult.whLocGb}');
       $('#pLocationCode').val('${installResult.ctWhLocId}');
	   $("#pItemCodeOrName").val('${orderDetail.basicInfo.stockCode}');

       Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
   }

   function fnSerialSearchResult(data) {
       data.forEach(function(dataRow) {

    	   if(serialGubun == "1"){
	    	   $("#addInstallForm #serialNo").val(dataRow.serialNo);
	    	   //console.log("serialNo : " + dataRow.serialNo);
    	   }else{
    		   $("#addInstallForm #frmSerialNo").val(dataRow.serialNo);
               //console.log("serialNo : " + dataRow.serialNo);
    	   }
       });
   }

   function fn_serialSearchPop2(){
       if( $("#frmSerialNo").hasClass("readonly") == true ){
    	   return;
       }
	   serialGubun = "2";

       $("#pLocationType").val('${frameInfo.whLocGb}');
       $('#pLocationCode').val('${frameInfo.ctWhLocId}');
       $("#pItemCodeOrName").val('${frameInfo.stockCode}');

       Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
   }

   function fn_openFailChild(selectedData){
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
   <spring:message code='service.title.AddInstallationResult' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#none"><spring:message code='expense.CLOSE' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="tap_wrap">
   <!-- tap_wrap start -->
   <ul class="tap_type1">
     <li><a href="#none" id="orderInfo" class="on"><spring:message
       code='sales.tap.order' /></a></li>
     <li><a href="#none"><spring:message
       code='service.title.General' /></a></li>
    <li><a href="#none"><spring:message
       code='sales.tap.customerInfo' /></a></li>
    <li><a href="#none"><spring:message
       code='sales.tap.installationInfo' /></a></li>
    <li><a href="#none"><spring:message code='sales.tap.HPInfo' /></a></li>
   </ul>

   <!-- Order Information Start -->
<article class="tap_area"><!-- tap_area start -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->


</article><!-- tap_area end -->
<!-- Order Information End -->


   <article class="tap_area">
    <!-- tap_area start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h2><spring:message code='service.title.OrderInformation' /></h2>
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
       <td><span><c:out value="${installResult.codename1}" /></span>
       </td>
       <th scope="row"><spring:message
         code='service.title.InstallNo' /></th>
       <td><span><c:out
          value="${installResult.installEntryNo}" /></span></td>
       <th scope="row"><spring:message code='service.title.OrderNo' /></th>
       <td><span><c:out value="${installResult.salesOrdNo}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.RefNo' /></th>
       <td><span><c:out value="${installResult.refNo}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.OrderDate' /></th>
       <td><span><c:out value="${installResult.salesDt}" /></span>
       </td>
       <th scope="row"><spring:message
         code='service.title.ApplicationType' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out value="${orderInfo.codeName}" /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out value="${orderInfo.c5}" /></span></td>
       </c:if>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.Remark' /></th>
       <td colspan="5"><span><c:out value="${orderInfo.rem}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.LastUpdatedBy' /></th>
       <td><span><c:out value="${installResult.userName}" /></span>
       </td>
       <th scope="row">Product</th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out
           value="${orderInfo.stkCode} - ${orderInfo.stkDesc} " /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out
           value="${orderInfo.c6} - ${orderInfo.c7} " /></span></td>
       </c:if>
       <th scope="row"><spring:message
         code='service.title.Promotion' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out
           value="${orderInfo.c3} - ${orderInfo.c4} " /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out
           value="${orderInfo.c9} - ${orderInfo.c10} " /></span></td>
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
       <td><span> <c:if
          test="${installResult.grade == null}">A</c:if> <c:if
          test="${installResult.grade != null}">
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
       <th scope="row"><spring:message
         code='service.title.CustomerName' /></th>
       <td><span><c:out value="${customerInfo.name}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.CustomerNRIC' /></th>
       <td><span><c:out value="${customerInfo.nric}" /></span></td>
       <th scope="row"><spring:message code='service.title.Gender' /></th>
       <td><span><c:out value="${customerInfo.gender}" /></span></td>
      </tr>
      <tr>
       <th scope="row" rowspan="4"><spring:message
         code='service.title.MailingAddress' /></th>
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
       <th scope="row"><spring:message
         code='service.title.ContactPerson' /></th>
       <td><span><c:out value="${customerContractInfo.name}" /></span>
       </td>
       <th scope="row"><spring:message code='service.title.Gender' /></th>
       <td><span><c:out
          value="${customerContractInfo.gender}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.ResidenceNo' /></th>
       <td><span><c:out value="${customerContractInfo.telR}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.MobileNo' /></th>
       <td><span><c:out
          value="${customerContractInfo.telM1}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.OfficeNo' /></th>
       <td><span><c:out value="${customerContractInfo.telO}" /></span>
       </td>
       <th scope="row"><spring:message
         code='service.title.OfficeNo' /></th>
       <td><span><c:out value="${customerContractInfo.telF}" /></span>
       </td>
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
       <th scope="row"><spring:message
         code='service.title.RequestInstallDate' /></th>
       <td><span><c:out value="${installResult.c1}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.AssignedCT' /></th>
       <td colspan="3"><span><c:out
          value="(${installResult.ctMemCode}) ${installResult.ctMemName}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row" rowspan="4"><spring:message
         code='service.title.InstallationAddress' /></th>
       <td colspan="5"><span><c:out
          value="${installation.address}" /></span></td>
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
       <th scope="row"><spring:message
         code='service.title.SpecialInstruction' /></th>
       <td><span><c:out value="${installation.instct}" /> </span></td>
       <th scope="row"><spring:message
         code='service.title.PreferredDate' /></th>
       <td></td>
       <th scope="row"><spring:message
         code='service.title.PreferredTime' /></th>
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
       <td><span><c:out value="${installationContract.name}" /></span>
       </td>
       <th scope="row"><spring:message code='service.title.Gender' /></th>
       <td></td>
       <th scope="row"><spring:message
         code='service.title.ResidenceNo' /></th>
       <td><span><c:out value="${installationContract.telR}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.MobileNo' /></th>
       <td><span><c:out
          value="${installationContract.telM1}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.OfficeNo' /></th>
       <td><span><c:out value="${installationContract.telO}" /></span>
       </td>
       <th scope="row"><spring:message code='service.title.FaxNo' /></th>
       <td><span><c:out value="${installationContract.telF}" /></span>
       </td>
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
   <div id="grid_wrap_view"
    style="width: 100%; height: 100px; margin: 0 auto;"></div>
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
        <input id="pGubun" name="pGubun" type="hidden" value="RADIO" />
        <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
        <input id="pLocationType" name="pLocationType" type="hidden" value="" />
        <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
        <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
        <input id="pStatus" name="pStatus" type="hidden" value="" />
        <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
    </form>
  <form action="#" id="addInstallForm" method="post">
<!--   test -->
   <input type="hidden" value="${installResult.installEntryId}" id="installEntryId" name="installEntryId" />
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
   <input type="hidden" value="" id="hidActualCTId" name="hidActualCTId" />
   <input type="hidden" value="${sirimLoc.whLocCode}" id="hidSirimLoc" name="hidSirimLoc" />
   <input type="hidden" value="" id="hidCategoryId" name="hidCategoryId" />
   <input type="hidden" value="" id="hidStockCode" name="hidStockCode" />
   <input type="hidden" value="" id="hidFrmStockCode" name="hidFrmStockCode" />
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
   <input type="hidden" value="${installation.address}" id="hidInstallation_AddDtl" name="hidInstallation_AddDtl" />
   <input type="hidden" value="${installation.areaId}" id="hidInstallation_AreaID" name="hidInstallation_AreaID" />
   <input type="hidden" value="${customerContractInfo.name}" id="hidInatallation_ContactPerson" name="hidInatallation_ContactPerson" />
   <input type="hidden" value="${installResult.rcdTms}" id="rcdTms" name="rcdTms" />
   <input type="hidden" value="${installResult.serialRequireChkYn}" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
   <input type="hidden" value="${frameInfo.serialChk}" id="hidFrmSerialChkYn" name="hidFrmSerialChkYn" />
   <input type="hidden" value="${frameInfo.salesOrdId}" id="hidFrmOrdId" name="hidFrmOrdId" />
   <input type="hidden" value="${frameInfo.salesOrdNo}" id="hidFrmOrdNo" name="hidFrmOrdNo" />
    <input type="hidden" value="" id="failDeptChk" name="failDeptChk" />
    <input type="hidden" value="${orderDetail.basicInfo.custType}" id="custType" name="custType" />
    <input type="hidden" value="${orderDetail.salesmanInfo.telMobile}" id="hpPhoneNo" name="hpPhoneNo" />
    <input type="hidden" value="${orderDetail.salesmanInfo.memId}" id="hpMemId" name="hpMemId" />
    <input type="hidden" value="${orderDetail.basicInfo.ordCtgryCd}" id="ordCtgryCd" name="ordCtgryCd" />

    <input type="hidden" value="" id="hidDismantle" name="hidDismantle" />

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
    <tr id="preinstallationImg" style="display:none;">
            <th scope="row">Pre-Installation Images:</th>
            <td colspan="">
                <ul class="btns">
                  <li>
                    <p class="btn_grid"><a href="#" onClick="{Common.popupDiv('/sales/order/getInstImg.do', { insNo : '${installResult.installEntryNo}' , type : 'preInstallation' }, null , true);}"><spring:message code='sys.btn.view' /></a></p>
                   </li>
               </ul>
            </td>
            <th>Pre-Installation Remarks:</th>
            <td>${installResult.preinstallationAddRemark}</td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.InstallStatust' /><span name="m1" id="m1" class="must">*</span></th>
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
      <th scope="row"><spring:message
        code='service.title.ActualInstalledDate' /><span name="m2" id="m2" class="must">*</span></th>
      <td><input type="text" title="Create start Date"
       placeholder="DD/MM/YYYY" class="j_dateHc w100p" id="installDate"
       name="installDate" /></td>
     </tr>
     <tr>
      <th scope="row">DT Code<span name="m3" id="m3" class="must">*</span></th>
      <td colspan="3"><input type="text" title=""
       value="<c:out value="(${installResult.ctMemCode}) ${installResult.ctMemName}"/>"
       placeholder="" class="readonly" style="width: 100%;" id="ctCode"
       readonly="readonly" name="ctCode" /> <input type="hidden"
       title="" value="${installResult.ctId}" placeholder="" class=""
       style="width: 200px;" id="CTID" name="CTID" /> <!-- <p class="btn_sky"><a href="#none">Search</a></p></td> -->
       <%-- <th scope="row"><spring:message code='service.title.CTName'/></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="ctName" name="ctName"/></td> --%>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <table class="type1" id="completedHide">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 130px" />
     <col style="width: 350px" />
     <col style="width: 150px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
       <th scope="row">
         <spring:message code='service.title.SIRIMNo' />
       </th>
       <td>
         <input type="text" title="" placeholder="<spring:message code='service.title.SIRIMNo' />" class="w100p" id="sirimNo" name="sirimNo" />
       </td>
       <th scope="row">
         <spring:message code='service.title.SerialNo' /><span name="m5" id="m5" class="must">*</span>
       </th>
       <td>
         <input type="text" title="" placeholder="<spring:message code='service.title.SerialNo' />" class="w50p" id="serialNo" name="serialNo" />
         <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop1()" ><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
       </td>
     </tr>
     <tr>
       <th scope="row">Mobile</th>
       <td>
         <input type="text" title="" value ="${orderDetail.installationInfo.instCntTelM}" placeholder="Mobile No" id="custMobileNo" name="custMobileNo" style="width:50%;"/>
         <span>SMS</span><input type="checkbox" id="chkSms" name="chkSms" checked>
       </td>
       <div class="frmS1" style="display:none;">
       <th scope="row">Frame Serial No<span id="frm2" class="must" style="display:none">*</span></th>
       <td></td></tr>
       </div>
     <tr>
      <th class="dtPair1" scope="row">DT Pair</th>
      <td class="dtPair2"><select class="w100p" id="dtPairCode" name="dtPairCode">
        <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
            <c:forEach var="list" items="${dtPairList}">
                <option value="${list.dtId}">${list.dtMemCode}</option>
        </c:forEach>
        </select></td>
        <th class="dtPair3" scope="row"></th>
        <td class="dtPair4"></td>
       <th class="frmS1" scope="row">Frame Serial No<span id="frm2" class="must" style="display:none">*</span></th>
       <td class="frmS3">
	     <input type="text" title="" placeholder="Frame Serial No" class="w50p" id="frmSerialNo" name="frmSerialNo" />
	     <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop2()" ><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
       </td>
     </tr>
     <tr>
       <th scope="row">
         <spring:message code='service.title.RefNo' />(1)
       </th>
       <td>
         <input type="text" title="" placeholder="<spring:message code='service.title.RefNo' />(1)" class="w100p" id="refNo1" name="refNo1" />
       </td>
       <th scope="row">
         <spring:message code='service.title.RefNo' />(2)
       </th>
       <td>
         <input type="text" title="" placeholder="<spring:message code='service.title.RefNo' />(2)" class="w100p" id="refNo2" name="refNo2" />
       </td>
     </tr>
     <tr>
       <th scope="row">Dismantle</th>
       <td colspan="1">
		    <label><input type="radio" name="dismantle"  value="1"/><span>Yes</span></label>
		    <label><input type="radio" name="dismantle"  value="0"/><span>No</span></label>
    </td>
       <th scope="row"></th><td></td>
     </tr>
     <tr>
       <th scope="row">Total Copper Pipe</th>
       <td>
         <input type="text" title="" placeholder="Total Copper Pipe" class="" id="totalPipe" name="totalPipe" style="width:90%;" type="number"/><span>ft</span>
       </td>
       <th scope="row" rowspan="2">Gas Pressue <br/>Before Installation<br/>After Installation
       </th>

       <td rowspan="1">
         <input type="text" title="" placeholder="Before Installation" class="" id="gaspreBefIns" name="gaspreBefIns" /><span>PSI</span>
       </td>
     </tr>
     <tr>
       <th scope="row">Total Wire</th>
       <td>
         <input type="text" title="" placeholder="Total Wire" class="" id="totalWire" name="totalWire"  style="width:90%;"/><span>ft</span>
       </td>
       <td rowspan="1">
         <input type="text" title="" placeholder="After Installation" class="" id="gaspreAftIns" name="gaspreAftIns" value="<c:out value="${installInfo.gasPresAft}"/>" />
         <span>PSI</span>
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
     <tr>
       <td colspan="4">
         <label>
           <input type="checkbox" id="checkCommission" name="checkCommission" /><span><spring:message code='service.btn.AllowCommission' /> ?</span>
         </label>
         <label>
           <input type="checkbox" id="checkTrade" name="checkTrade" /><span><spring:message code='service.btn.IsTradeIn' /> ?</span>
         </label>
         <label>
           <input type="checkbox" id="checkSms" name="checkSms" /><span><spring:message code='service.btn.RequireSMS' /> ?</span>
         </label>
       </td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->

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
      <td colspan="2"><label><input type="checkbox" id="checkSend" name="checkSend" checked/>
      <span><spring:message code='service.title.SendSMSToSalesPerson' /></span></label></td>
     </tr>
     <tr>
      <th scope="row" rowspan="2"><spring:message code='service.title.Message' /></th>
         <td><textarea cols="20" rows="5" readonly="readonly" class="readonly" id="hpMsg" name="hpMsg"></textarea>
	     </td>
     </tr>
     <tr>
      <td><input type="text" title="" placeholder="" class="w100p" value="Remark:" id="msgRemark" name="msgRemark" /></td>
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
     <th scope="row"><spring:message code='service.title.FailedLocation' /><span name="m8" id="m8" class="must">*</span></th>
     <td><select class="w100p" id="failLocCde" name="failLocCde" onchange="fn_openFailChild(this.value)">
        <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
            <c:forEach var="list" items="${failParent}" varStatus="status">
                <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message code='service.title.FailedReason' /><span name="m6" id="m6" class="must">*</span></th>
      <input type="hidden" value="" id="hiddenFailReasonCode" name="hiddenFailReasonCode" />
      <td><select class="w100p" id=failReasonCode name="failReasonCode">
        <option value="0">Failed Reason</option>
        <c:forEach var="list" items="${failReason }" varStatus="status">
         <option value="${list.resnId}">${list.c1}</option>
        </c:forEach>
      </select></td>
       <tr>
      <tr>
      <th scope="row"><spring:message code='service.title.NextCallDate' /><span name="m7" id="m7" class="must">*</span></th>
      <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc w100p" id="nextCallDate" name="nextCallDate" /></td>
      <th scope="row"></th>
      <td></td>
      </tr>
     <tr>
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
       <th scope="row" ><spring:message code='service.title.Remark' /></th>
       <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.title.Remark' />" class="w100p"
        id="remark" name="remark" /></td>
     </tr>
     <tr>
       <td colspan="4"><label><input type="checkbox" id="failDeptChk" name="failDeptChk" /><span id="failDeptChkDesc" name="failDeptChkDesc"><spring:message code='sys.btn.failBfrDepartFromWarehouse' /> </span></label> </td>
     </td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
  <div id='sav_div'>
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a href="#none" onclick="fn_saveInstall()"><spring:message code='service.btn.SaveInstallationResult' /></a>
     </p></li>
   </ul>
  </div>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
