<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 24/10/2019  ONGHC  1.0.0          AMEND LAYOUT
 13/02/2020  ONGHC  1.0.1          ADD PSI FIELD
 26/02/2020  ONGHC  1.0.2          ADD LPM FIELD
 10/06/2020  ONGHC  1.0.3          Add PSI & LPM Field onblur Checking
 -->

<script type="text/javaScript">
  $(document).ready(
    function() {
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
      $("#m4").show();
      $("#psiRcd").attr("disabled", false);
      $("#m5").show();
      $("#lpmRcd").attr("disabled", false);
    } else {
      $("#m4").hide();
      $("#psiRcd").attr("disabled", true);
      $("#m5").hide();
      $("#lpmRcd").attr("disabled", true);
    }

  });

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

  function fn_saveInstall() {
    if (fn_validate()) {

        // KR-OHK Serial Check add
        var url = "";

        if ($("#hidSerialRequireChkYn").val() == 'Y') {
            url = "/services/editInstallationSerial.do";
        } else {
            url = "/services/editInstallation.do";
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
    if ($("#editInstallForm #serialNo").val().trim() == '' || ("#editInstallForm #serialNo") == null) {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
    } else {
      if ($("#editInstallForm #serialNo").val().trim().length < 9) {
        msg += "* <spring:message code='sys.msg.invalid' arguments='Serial No' htmlEscape='false'/> </br>";
      }
    }

    if (msg != "") {
      Common.alert(msg);
      return false;
    }
    return true;
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

  function validate2(a) {
    var regex = /^\d+$/;
    if (!regex.test(a.value)) {
      a.value = "";
    }
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
     <li><a href="#" id="orderInfo" class="on"><spring:message
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
    <input type="hidden" value="<c:out value="${installInfo.serialNo}"/>" id="hidSerialNo" name="hidSerialNo" />

    <table class="type1 mb1m">
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
       <td><span><c:out value="${installInfo.c3} - ${installInfo.c4}" /></span></td>
       <c:if test="${codeId == '258'}">
           <th scope="row">Before Serial</th>
           <td ><span><c:out value="${orderDetail.basicInfo.exchReturnSerialNo}" /></span></td>
       </c:if>
      </tr>
	  <tr>
       <th scope="row"><spring:message code='service.title.SirimNo' /><span class="must" id="m1"> *</span></th>
       <td><input type="text" id="sirimNo" name="sirimNo" class='w100p' value="<c:out value="${installInfo.sirimNo}"/>" /></td>
       <th scope="row"><spring:message code='service.title.SerialNo' /><span class="must" id="m2"> *</span></th>
       <td><input type="text" id="serialNo" name="serialNo" class='w50p' value="<c:out value="${installInfo.serialNo}" />" />
       <c:if test="${installInfo.serialRequireChkYn == 'Y' }">
       <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop()" ><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
       </c:if>
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
       <th scope="row"><spring:message code='service.title.ActualInstalledDate' /><span class="must" id="m3"> *</span></th>
       <td>
         <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"
          title="Create start Date" placeholder="DD/MM/YYYY"
          id="installdt" name="installdt"
          value="<c:out value="${installInfo.installDt}" />" />
       </td>
       <th scope="row"><spring:message code='service.title.PSIRcd' /><span class="must" id="m4"> *</span></th>
       <td><input type="text" title="" placeholder="<spring:message code='service.title.PSIRcd' />" class="w100p" id="psiRcd" name="psiRcd" onkeypress='validate(event)' onblur="validate2(this)" value="<c:out value="${installInfo.psi}"/>" /></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.lmp' /><span class="must" id="m5"> *</span></th>
       <td ><input type="text" title="" placeholder="<spring:message code='service.title.lmp' />" class="w100p" id="lpmRcd" name="lpmRcd" onkeypress='validate(event)' onblur="validate2(this)" value="<c:out value="${installInfo.lpm}"/>" /></td>
       <th scope="row"></th>
       <td ></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.Remark' /></th>
       <td colspan="3">
        <textarea id="remark" name="remark" cols="5" rows="5" style="width: 100%; height: 100px">
         <c:out value="${installInfo.rem}" />
        </textarea>
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
   </form>
   <br/>
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a href="#" onclick="fn_saveInstall()"><spring:message code='service.btn.SaveInstallationResult' /></a>
     </p></li>
   </ul>
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
