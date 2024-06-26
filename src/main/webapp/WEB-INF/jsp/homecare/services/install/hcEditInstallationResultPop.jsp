<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 24/10/2019  ONGHC  1.0.0          AMEND LAYOUT
 -->

<script type="text/javaScript">

var myFileCaches = {};

var update = new Array();
var remove = new Array();
var fileGroupKey ="";
var installAccTypeId = 583;
var installAccValues = JSON.parse("${installAccValues}");

  $(document).ready(
    function() {
   	var today = new Date();
   	var minDate = new Date(today.getFullYear(), today.getMonth(), 1);
   	var pickerOpts={
   	        minDate: minDate,
   	        maxDate: today,
   	        dateFormat: "dd/mm/yy"
   	};
   	$(".j_dateHc").datepicker(pickerOpts);
   	checkInstallDateDisable();

    var allcom = ${installInfo.c1};
    var istrdin = ${installInfo.c7};
    var reqsms = ${installInfo.c9};
    var dismantle = ${installInfo.dismantle};
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

    if (dismantle == 1) {
    	$('input:radio[name=dismantle][value="1"]').attr('checked', true);
      }else{
    	  $('input:radio[name=dismantle][value="0"]').attr('checked', true);
      }

    if (stusId == 4){
      	$("#chkInstallAcc").prop("checked", true);
      	doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
    }else{
    	$("#chkInstallAcc").prop("checked", false);
        doGetComboSepa('/common/selectCodeList.do', 0, '', '','installAcc', 'M' , 'f_multiCombo');
    }

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

    if(js.String.isEmpty( $("#hidFrmOrdNo").val() )){
        $(".frmS1").hide();
    }else{
        $(".frmS1").show();
    }

    if(js.String.strNvl($("#hidFrmSerialChkYn").val()) == "Y"){
        $("#frm2").show();
        $("#frmSerialNo").removeAttr("disabled").removeClass("readonly");
        if($("#ordCtgryCd").val() == "ACI"){
            $(".airconm").show();
        }
    }else{

        if($("#ordCtgryCd").val() == "ACI"){
            $("#frm2").show();
            $("#frmSerialNo").removeAttr("disabled").removeClass("readonly");
            $(".airconm").show();
        }else{
        	$("#frm2").hide();
        	$("#frmSerialNo").attr("disabled", true).addClass("readonly");
        }

    }

    $("#hidCategoryId").val("${orderDetail.basicInfo.stkCtgryId}");
    $("#hidStockCode").val("${orderDetail.basicInfo.stockCode}");//aircon
    $("#hidFrmStockCode").val("${frameInfo.stockCode}");//aircon

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

  function fn_saveInstall() {
	var totalUpdPhoto = 0;
    if (fn_validate()) {
    	var hidDismantle = $("input[type=radio][name=dismantle]:checked").val();
        $("#hidDismantle").val(hidDismantle);

        var fileGrpId = '${installInfo.atchFileGrpId}' == "" ? 0 : '${installInfo.atchFileGrpId}';

        var orderVO = {
                SalesOrderNo       :  $('#hidSalesOrderNo').val(),
                //hidStkId               : $('#editInstallForm #hidStkId').val().trim(),
                resultId               : $("#editInstallForm #resultId").val().trim(),
                atchFileGrpId        : fileGrpId,
                installdt              : $('#editInstallForm #installdt').val(),
                installEntryId        : $('#entryId').val(),
                InstallEntryNo       :'${installInfo.c14}'
            }

    	var formData = new FormData();
        console.log("[hcEditInstallationResultPop - fn_saveInstall] orderVO :: {}", orderVO);
        console.log("[hcEditInstallationResultPop - fn_saveInstall] orderVO.atchFileGrpId :: {}", '${installInfo.atchFileGrpId}');

        $.each(myFileCaches, function(n, v) {
            formData.append(n, v.file);
            formData.append("atchFileGrpId", fileGrpId);
            formData.append("InstallEntryNo", '${installInfo.c14}');
            formData.append("salesOrdId", $('#hidSalesOrderId').val());
            formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

          /*  if (v.file > 0 || v.file != null) {
            fn_doSaveHCAttachment();
            }*/

        });

        Common.ajaxFile("/homecare/services/install/attachFileUploadEdit.do", formData, function(result) {
            var resultId = ${installInfo.resultId};
            fileGroupKey = result.data.fileGroupKey;

            $("#editInstallForm #resultId").val(resultId);
            $("#editInstallForm #fileGroupKey").val(fileGroupKey);

            if(result != 0 && result.code == 00){
                Common.ajax("POST", "/homecare/services/install/updateFileKey.do", orderVO, function(result) {
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

        if ($('#installdt').is(':disabled')) {
            $("#installdt").attr("disabled", false);
          }

        var saveForm = $("#editInstallForm").serializeJSON();
        saveForm.installAccList = $("#installAcc").val();

      // KR-OHK Serial Check add
      Common.ajax("POST", "/homecare/services/install/hceditInstallationSerial.do", saveForm, function(result) {
        Common.alert(result.message);
        if (result.message == "Installation result successfully updated.") {
          $("#popup_wrap").remove();
          fn_installationListSearch();
        }
      });
    }
  }

/*  function fn_doSaveHCAttachment() {

      var orderVO = {
              SalesOrderNo       :  $('#hidSalesOrderNo').val(),
              //hidStkId               : $('#editInstallForm #hidStkId').val().trim(),
              resultId               : $("#editInstallForm #resultId").val().trim(),
              atchFileGrpId        : '${installInfo.atchFileGrpId}',
              installdt              : $('#editInstallForm #installdt').val(),
              installEntryId        : $('#entryId').val()
          };

            var formData = new FormData();
            formData.append("atchFileGrpId", '${installInfo.atchFileGrpId}');
            formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

            $.each(myFileCaches, function(n, v) {
                console.log(v.file);
                formData.append(n, v.file);
            });

            Common.ajaxFile("/homecare/services/install/attachFileUploadEdit.do", formData, function(result) {


            var resultId = ${installInfo.resultId}
            fileGroupKey = result.data.fileGroupKey

            console.log ("resultId value :" + resultId );
            console.log ("fileGroupKey value :" + fileGroupKey );

            $("#editInstallForm #resultId").val(resultId);
            $("#editInstallForm #fileGroupKey").val(fileGroupKey);

            if(result != 0 && result.code == 00){

                Common.ajax("POST", "/homecare/services/install/updateFileKey.do", orderVO, function(result) {

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
        }*/

  function fn_validate() {
    var msg = "";
    if ($("#editInstallForm #installdt").val() == '') {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Actual Install Date' htmlEscape='false'/> </br>";
    }
//     if ($("#editInstallForm #sirimNo").val().trim() == '' || ("#editInstallForm #sirimNo") == null) {
//       msg += "* <spring:message code='sys.msg.necessary' arguments='Sirim No' htmlEscape='false'/> </br>";
//     }
    if ($("#editInstallForm #serialNo").val().trim() == '' || ("#editInstallForm #serialNo") == null) {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
    } else {
      if ($("#editInstallForm #serialNo").val().trim().length < 9) {
        msg += "* <spring:message code='sys.msg.invalid' arguments='Serial No' htmlEscape='false'/> </br>";
      }
    }

    if ($("#frmSerialNo").hasClass("readonly") == false
            && ($("#editInstallForm #frmSerialNo").val().trim() == '' || ("#editInstallForm #frmSerialNo") == null)) {
          msg += "* <spring:message code='sys.msg.necessary' arguments='Frame Serial No' htmlEscape='false'/> </br>";
      }else{
          if ($("#frmSerialNo").hasClass("readonly") == false && $("#editInstallForm #frmSerialNo").val().trim().length < 18) {
              msg += "* <spring:message code='sys.msg.invalid' arguments='Frame Serial No' htmlEscape='false'/> </br>";
          }
      }

    if(!fn_AlphanumericRegexCheck($("#editInstallForm #serialNo").val())){
        msg += "* No Special Character Allowed for Serial No </br>";
    }

    if(!fn_AlphanumericRegexCheck($("#editInstallForm #frmSerialNo").val())){
        msg += "* No Special Character Allowed for Frame Serial No </br>";
    }

    //validate aircon serial
    if($("#ordCtgryCd").val() == "ACI"){
        var stockCode = "";
        stockCode = (js.String.roughScale($("#editInstallForm #serialNo").val().trim().substr(3,5), 36)).toString();

         if(stockCode != "0" && $("#hidStockCode").val() != stockCode){
             msg += "* Serial Number NOT match with stock [" + $("#hidStockCode").val() +"] </br>";
         }

         console.log("stockCode " + stockCode);

        var frmStockCode = "";
        frmStockCode = (js.String.roughScale($("#editInstallForm #frmSerialNo").val().trim().substr(3,5), 36)).toString();

        console.log("frmStockCode " + frmStockCode);

        if(frmStockCode != "0" && $("#hidFrmStockCode").val() != frmStockCode){
            msg += "* Serial Number NOT match with stock [" + $("#hidFrmStockCode").val() +"] </br>";
        }

//         if ($("input[type=radio][name=dismantle]:checked").val() == '' || $("input[type=radio][name=dismantle]:checked").val() == null) {
//             msg += "* <spring:message code='sys.msg.necessary' arguments='Dismantle' htmlEscape='false'/> </br>";
//         }

//         if ($("#totalPipe").val() == '' || $("#totalPipe").val() == null) {
//             msg += "* <spring:message code='sys.msg.necessary' arguments='Total Copper Wire' htmlEscape='false'/> </br>";
//         }

//         if ($("#totalWire").val() == '' || $("#totalWire").val() == null) {
//             msg += "* <spring:message code='sys.msg.necessary' arguments='Total Wire' htmlEscape='false'/> </br>";
//         }

//         if ($("#gaspreBefIns").val() == '' || $("#gaspreBefIns").val() == null) {
//             msg += "* <spring:message code='sys.msg.necessary' arguments='Gas pressure before install' htmlEscape='false'/> </br>";
//         }

//         if ($("#gaspreAftIns").val() == '' || $("#gaspreAftIns").val() == null) {
//             msg += "* <spring:message code='sys.msg.necessary' arguments='Gas pressure after install' htmlEscape='false'/> </br>";
//         }
    }
    //validate aircon serial

 // Installation Accessory checking for Complete status
    if($("#chkInstallAcc").is(":checked") && $("#installAcc").val == ""){
  	  msg += "* <spring:message code='sys.msg.invalid' arguments='Installation Accessory' htmlEscape='false'/> </br>";
    }

    if (msg != "") {
      Common.alert(msg);
      return false;
    }
    return true;
  }


  function fn_serialSearchPop1(){
	  serialGubun = "1";

      $("#pLocationType").val('${installInfo.whLocGb}');
      $('#pLocationCode').val('${installInfo.ctWhLocId}');
      $("#pItemCodeOrName").val('${orderDetail.basicInfo.stockCode}');

      Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
  }

  function fnSerialSearchResult(data) {
      data.forEach(function(dataRow) {
    	  if(serialGubun == "1"){
	          $("#editInstallForm #serialNo").val(dataRow.serialNo);
	          //console.log("serialNo : " + dataRow.serialNo);
    	  }else{
              $("#editInstallForm #frmSerialNo").val(dataRow.serialNo);
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

 /* $('#photo1').change(function(evt) {
      var file = evt.target.files[0];
      console.log("file:::" + file);
      if(file == null && myFileCaches[1] != null){
          delete myFileCaches[1];
      }else if(file != null){
          myFileCaches[1] = {file:file};
      }
      console.log(myFileCaches);
  });*/

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
    <form id="frmSearchSerial" name="frmSearchSerial" method="post">
        <input id="pGubun" name="pGubun" type="hidden" value="RADIO" />
        <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
        <input id="pLocationType" name="pLocationType" type="hidden" value="" />
        <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
        <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
        <input id="pStatus" name="pStatus" type="hidden" value="" />
        <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
    </form>

   <form action="#" id="editInstallForm" method="post">
    <input type="hidden" value="<c:out value="${installInfo.resultId}"/>" id="resultId" name="resultId" />
    <input type="hidden" value="<c:out value="${installInfo.installEntryId}"/>" id="entryId" name="entryId" />
    <input type="hidden" value="<c:out value="${installInfo.serialRequireChkYn}"/>" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
    <input type="hidden" value="<c:out value="${installInfo.c14}"/>" id="hidInstallEntryNo" name="hidInstallEntryNo" />
    <input type="hidden" value="<c:out value="${orderDetail.basicInfo.ordId}"/>" id="hidSalesOrderId" name="hidSalesOrderId" />
    <input type="hidden" value="<c:out value="${orderDetail.basicInfo.ordNo}"/>" id="hidSalesOrderNo" name="hidSalesOrderNo" />
    <input type="hidden" value="<c:out value="${installInfo.serialNo}"/>" id="hidSerialNo" name="hidSerialNo" />
    <input type="hidden" value="<c:out value="${frameInfo.serialChk}"/>" id="hidFrmSerialChkYn" name="hidFrmSerialChkYn" />
    <input type="hidden" value="<c:out value="${frameInfo.salesOrdId}"/>" id="hidFrmOrdId" name="hidFrmOrdId" />
    <input type="hidden" value="<c:out value="${frameInfo.salesOrdNo}"/>" id="hidFrmOrdNo" name="hidFrmOrdNo" />
    <input type="hidden" value="<c:out value="${frameInfo.frmSerial}"/>" id="hidFrmSerialNo" name="hidFrmSerialNo" />
    <input type="hidden" value="${orderDetail.basicInfo.ordCtgryCd}" id="ordCtgryCd" name="ordCtgryCd" />
    <input type="hidden" value="<c:out value="${installInfo.atchFileGrpId}"/>" id="atchFileGrpId" name="atchFileGrpId" />
    <input type="hidden" value="" id="hidCategoryId" name="hidCategoryId" />
   <input type="hidden" value="" id="hidStockCode" name="hidStockCode" />
   <input type="hidden" value="" id="hidFrmStockCode" name="hidFrmStockCode" />
   <input type="hidden" value="" id="hidDismantle" name="hidDismantle" />

    <table class="type1 mb1m">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 160px" />
      <col style="width: 310px" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message
         code='service.title.InstallationNo' /></th>
       <td><span><c:out value="${installInfo.c14}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.InstallationStatus' /></th>
       <td><span><c:out value="${installInfo.name}" /></span></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.Creator' /></th>
       <td><span><c:out value="${installInfo.c2}" /></span></td>
       <th scope="row"><spring:message code='service.title.CreateDate' /></th>
       <td><span><c:out value="${installInfo.crtDt}" /></span></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.ActionCT' /></th>
       <td colspan="3"><span><c:out value="${installInfo.c3} - ${installInfo.c4}" /></span></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.SirimNo' />
       <td><input type="text" id="sirimNo" name="sirimNo" class='w100p' value="<c:out value="${installInfo.sirimNo}"/>" /></td>
       <th scope="row"><spring:message code='service.title.SerialNo' /><span class="must"> *</span></th>
       <td>
         <input type="text" id="serialNo" name="serialNo" class='w50p' value="<c:out value="${installInfo.serialNo}" />" />
         <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop1()" ><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
       </td>
      </tr>
      <tr class="frmS1" style="display:none;">
       <th scope="row"></th>
       <td></td>
       <th scope="row">Frame Serial No<span id="frm2" class="must" style="display:none">*</span></th>
       <td>
         <input type="text" id="frmSerialNo" name="frmSerialNo" placeholder="Frame Serial No" class="w50p" value="<c:out value="${frameInfo.frmSerial}"/>" />
         <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop2()" ><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
       </td>
     </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.RefNo' />
        (1)</th>
       <td><input type="text" id="refNo1" name="refNo1" class='w100p'
        value="<c:out value="${installInfo.docRefNo1}" />" /></td>
       <th scope="row"><spring:message code='service.title.RefNo' /> (2)</th>
       <td><input type="text" id="refNo2" name="refNo2" class='w100p' value="<c:out value="${installInfo.docRefNo2}" />" /></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.ActualInstalledDate' /><span class="must"> *</span></th>
       <td>
         <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc w100p"
          title="Create start Date" placeholder="DD/MM/YYYY"
          id="installdt" name="installdt"
          value="<c:out value="${installInfo.installDt}" />" />
       </td>
       <th scope="row"></th>
       <td></td>
      </tr>
<%--<tr>
      <th scope="row">Attach Picture</th>
            <td>
                <div class="auto_file2 auto_file3 w50p" >
                    <input type="file" title="file add" id="photo1" accept="image/*"/>
                        <label>
                            <input type='text' class='input_text' readonly='readonly' id='photo1Txt'  value=" <c:out value="${installInfo.atchFileGrpId}"/>"/>
                            <span class='label_text'><a href='#'>Upload</a></span>
                            <!-- <span class='label_text'><a href='#' onclick='fn_removeFile("MSOFTNC")'>Remove</a></span>ATCH_FILE_GRP_ID -->
                        </label>
                </div>
            </td>
      </tr>--%>
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
         <input type="text" title="" placeholder="Total Copper Pipe" class="" id="totalPipe" name="totalPipe" style="width:90%;" type="number"
         value="<c:out value="${installInfo.totPipe}"/>" />
         <span>ft</span>
       </td>
       <th scope="row" rowspan="2">Gas Pressue <br/>Before Installation<br/>After Installation
       </th>

       <td rowspan="1">
         <input type="text" title="" placeholder="Before Installation" class="" id="gaspreBefIns" name="gaspreBefIns" value="<c:out value="${installInfo.gasPresBef}"/>" />
         <span>PSI</span>
       </td>
     </tr>
     <tr>
       <th scope="row">Total Wire</th>
       <td>
         <input type="text" title="" placeholder="Total Wire" class="" id="totalWire" name="totalWire"  style="width:90%;" value="<c:out value="${installInfo.totWire}"/>" />
         <span>ft</span>
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
       <th scope="row"><spring:message code='service.title.Remark' /></th>
       <td colspan="3">
        <textarea id="remark" name="remark" cols="5" rows="5" style="width: 100%; height: 100px"><c:out value="${installInfo.rem}" /></textarea>
       </td>
      </tr>
      <tr>
       <td colspan="4">
        <input id="allwcom" name="allwcom" type="checkbox" />
        <span><spring:message code='service.btn.AllowCommission' /> ?</span>
        <input id="trade" name="trade" type="checkbox" />
        <span><spring:message code='service.btn.IsTradeIn' /> ?</span>
        <input id="reqsms" name="reqsms" type="checkbox" />
        <span><spring:message code='service.btn.RequiredSMS' /> ?</span></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
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
   </form>
   <br/>
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a href="#none" onclick="fn_saveInstall()"><spring:message code='service.btn.SaveInstallationResult' /></a>
     </p></li>
   </ul>
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
