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

var today = new Date();
var dd = String(today.getDate()).padStart(2, '0');
var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
var yyyy = today.getFullYear();


  $(document).ready(function() {
    var allcom = ${installInfo.c1};
    var istrdin = ${installInfo.c7};
    var reqsms = ${installInfo.c9};

    if (allcom == 1) {
      $("#allwcom").prop("checked", true);
    }

    if (istrdin == 1) {
      $("#trade").prop("checked", true);
    }

    if (reqsms == 1) {
      $("#reqsms").prop("checked", true);
    }

    doGetCombo('/services/adapterList.do', '', '${installInfo.adptUsed}','adptUsed', 'S' , '');


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

      Common.ajax("GET", "/services/checkMonth.do?intallDate=" + checkMon, ' ', function(result) {
        if (result.message == "Please choose this month only") {
          Common.alert(result.message);
          $("#installdt").val('');
        }
      });
    });

 // ONGHC - 20200221 ADD FOR PSI
    // 54 - WP
    // 57 - SOFTENER
    // 58 - BIDET
    // 400 - POE
    if ("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56") {

    	// ALEX - 20200911 ADD ADDITIONAL COLUMN - boosterPump for all 4 categery

/*     	$("#editInstallForm #m11").show();
        $("#boosterPump").attr("disabled", false);
        $("#editInstallForm #m12").show();
        $("#aftPsi").attr("disabled", false);
        $("#editInstallForm #m13").show();
        $("#aftLpm").attr("disabled", false); */



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

  function fn_openFailChild(selectedData){
	  $("#failReasonCode").attr("disabled",false);
	  doGetCombo('/services/selectFailChild.do', selectedData, '','failReasonCode', 'S' , '');
	  /*   if(selectedData == "8000"&&("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56")) {
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
	    } */
	    if(selectedData == "8000" || selectedData == "8100"){
	    $("#failReasonCode").attr("disabled",false);
	    doGetCombo('/services/selectFailChild.do', selectedData, '','failReasonCode', 'S' , '');
	    }
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

/*     	var todayDD = Number(TODAY_DD.substr(0, 2));
        var todayYY = Number(TODAY_DD.substr(6, 4)); */

       var  dayc = ${installInfo.dayc};
       var  monc = ${installInfo.monc};
       var  yearc = ${installInfo.yearc};

/*         var dd2 = String(crt_date.getDate()).padStart(2, '0');
        var mm2 = String(crt_date.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy2 = crt_date.getFullYear(); */

      //  var todayDD = Number(crt_date.substr(0, 2));
     //   var todayMM = Number(crt_date.substr(6, 3));
      //  var todayYY = Number(crt_date.substr(6, 4));

     	var today = new Date();

    	var dd = String(today.getDate()).padStart(2, '0');
    	var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    	var yyyy = today.getFullYear();

    	console.log ('dd :' + dd);
    	console.log ('mm :' + mm);
    	console.log ('yyyy :' + yyyy);

        console.log ('dayc  :' + dayc );
        console.log ('monc  :' + monc );
     	console.log ('yearc  :' + yearc );

     	var crt_day = (yearc * 12 * 30) +  (monc * 30) + (dayc * 1) ; //727200 + 330 + 19
     	var sys_day = (yyyy * 12 * 30) +  (mm * 30) + ( dd * 1) ;
      	console.log ('crt_day  :' + crt_day );
     	console.log ('sys_day  :' + sys_day );


     	if ( (sys_day - crt_day) > 1000 ) {
     		Common.alert('Fail installation Result only allow within 7 days to edit');
            return;
     	}

        // KR-OHK Serial Check add
        var url = "";

        if ($("#hidSerialRequireChkYn").val() == 'Y') {
            url = "/services/editInstallationSerial.do";
        } else {
            url = "/services/failInstallation.do";
        }

      Common.ajax("POST", url, $("#editInstallForm").serializeJSON(), function(result) {
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

/*      if ($("#editInstallForm #boosterPump").val().trim() == '2' || $("#editInstallForm #boosterPump").val().trim() == '3' ){

        if ($("#editInstallForm #aftPsi").val().trim() == '' || $("#editInstallForm #aftPsi") == null ){
        msg += "* <spring:message code='sys.msg.necessary' arguments='After Pump PSI' htmlEscape='false'/> </br>";
      }
        if ($("#editInstallForm #aftLpm").val().trim() == '' || $("#editInstallForm #aftLpm") == null ){
        msg += "* <spring:message code='sys.msg.necessary' arguments='After Pump LPM' htmlEscape='false'/> </br>";
      }

    } */
  /*   else {
        if ($("#editInstallForm #boosterPump").val().trim() == '0' || ("#editInstallForm #boosterPump").val().trim() == '1') {
        	 msg += "121212";
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

  //stkId for kecil = 1735, petit = 298 (for testing in developmennt)
 // PSI CHECKING
    if ( ("${orderInfo.stkCtgryId}" == "54" || "${orderInfo.stkCtgryId}" == "400" || "${orderInfo.stkCtgryId}" == "57" || "${orderInfo.stkCtgryId}" == "56")
    		//&& !($("#editInstallForm #hidStkId").val()  == 1735)) {
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
    }

  //stkId for kecil = 1735, petit = 298 (for testing in developmennt)
    if($("#editInstallForm #hidStkId").val() == 1735){
        msg += validationForKecik();
    }

  //stkId for GLAZE = 1737
    if($("#editInstallForm #hidStkId").val() == 1737){
        msg += validationForGlaze();
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
          //console.log("serialNo : " + dataRow.serialNo);
      });
  }

</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>
      <spring:message code='service.title.FailInstallationResult' />
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
        <input type="hidden" name="hidStkId" id="hidStkId" value="${installInfo.installStkId}"><input type="hidden" value="<c:out value="${installInfo.resultId}"/>" id="resultId" name="resultId" /> <input type="hidden" value="<c:out value="${installInfo.installEntryId}"/>" id="entryId" name="entryId" /> <input type="hidden" value="<c:out value="${installInfo.serialRequireChkYn}"/>" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" /> <input type="hidden" value="<c:out value="${installInfo.c14}"/>" id="hidInstallEntryNo" name="hidInstallEntryNo" /> <input type="hidden" value="<c:out value="${orderDetail.basicInfo.ordId}"/>" id="hidSalesOrderId" name="hidSalesOrderId" /> <input type="hidden" value="<c:out value="${installInfo.serialNo}"/>" id="hidSerialNo" name="hidSerialNo" />
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
            <tr>
            <th scope="row"><spring:message code='service.title.FailedLocation' /><span name="m15" id="m15" class="must">*</span></th>
            <td><select class="w100p" id="failLocCde" name="failLocCde" onchange="fn_openFailChild(this.value)">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failParent}" varStatus="status">
                  <option value="${list.defectId}">${list.defectDesc}</option>
                </c:forEach></td>
            </select>
            <th scope="row"><spring:message code='service.title.FailedReason' /><span name="m16" id="m16" class="must">*</span></th>
            <td><select class="w100p" id="failReasonCode" name="failReasonCode">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failChild}" varStatus="status">
                  <option value="${list.defectId}">${list.defectDesc}</option>
                </c:forEach>
            </select></td>
            </tr>


             <!--  /////////////////////////////////////////////// NEW ADDED COLUMN : BOOSTER PUMP //////////////////////////////////////////////////////// -->
   <%--           <tr>

             <th scope="row"><spring:message code='service.title.BoosterPump' /><span class="must" id="m11"> *</span></th>
              <td colspan="3">

              <select class="w100p" id="boosterPump" name="boosterPump">
                                    <option value="0">Choose One</option>
                                    <option value="1">No</option>
                                    <option value="2">Coway pump</option>
                                    <option value="3">Customer external pump</option>
                        </select>
              </td>

          </tr>

          <tr>
              <th scope="row"><spring:message code='service.title.AfterPumpPsi' /><span class="must" id="m12" style="display: none;"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.AfterPumpPsi' />" class="w100p" id="aftPsi" name="aftPsi" "/>
              </td>
              <th scope="row"><spring:message code='service.title.AfterPumpLpm' /><span class="must" id="m13" style="display: none;"> *</span></th>
              <td>
                <input type="text" title="" placeholder="<spring:message code='service.title.AfterPumpLpm' />" class="w100p" id="aftLpm" name="aftLpm" "/>
              </td>
            </tr> --%>

          <!--  /////////////////////////////////////////////// NEW ADDED COLUMN : BOOSTER PUMP //////////////////////////////////////////////////////// -->



            <tr>
              <th scope="row"><spring:message code='service.title.Remark' /></th>
              <td colspan="3">
                <textarea id="remark" name="remark" cols="5" rows="5" style="width: 100%;
  height: 100px"><c:out value="${installInfo.rem}" /></textarea>
              </td>
            </tr>
            <tr>
              <td colspan="4">
                <input id="allwcom" name="allwcom" type="checkbox" /> <span><spring:message code='service.btn.AllowCommission' /> ?</span> <input id="trade" name="trade" type="checkbox" /> <span><spring:message code='service.btn.IsTradeIn' /> ?</span> <input id="reqsms" name="reqsms" type="checkbox" /> <span><spring:message code='service.btn.RequiredSMS' /> ?</span>
              </td>
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
</div>
<!-- popup_wrap end -->
