<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>
<script type="text/javaScript">

  $(document).ready(function() {
    var allcom = ${installInfo.c1};
    var istrdin = ${installInfo.c7};
    var reqsms = ${installInfo.c9};
    var dispComm = ${installInfo.dispComm};

    if (allcom == 1) {
      $("#allwcom").prop("checked", true);
    }

    if (istrdin == 1) {
      $("#trade").prop("checked", true);
    }

    if (reqsms == 1) {
      $("#reqsms").prop("checked", true);
    }

    if(dispComm == 1){
		$('#dispCommYes').prop("checked", true);
    }else{
    	$('#dispCommNo').prop("checked", true);
    }

 	// Old Mattress Disposal - only for Mattress , disabled for other category
 	console.log('ordCtgryCd ' + $("#ordCtgryCd").val() );
    if($("#ordCtgryCd").val() == "MAT"){
    	$('[name="dispComm"]').prop("disabled", false);
    	$("#oldMatDispLbl").append('<span class="must">*</span>');

    }else{
        $('[name="dispComm"]').prop("disabled", true);
		$("#oldMatDispLbl").find("span").remove();
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

    console.log($("#hidFrmOrdNo").val());
    if(js.String.isEmpty( $("#hidFrmOrdNo").val() )){
        $(".frmS1").hide();
    }else{
        $(".frmS1").show();
    }

    if(js.String.strNvl($("#hidFrmSerialChkYn").val()) == "Y"){
        $("#frm2").show();
        $("#frmSerialNo").removeAttr("disabled").removeClass("readonly");
    }else{
        $("#frm2").hide();
        $("#frmSerialNo").attr("disabled", true).addClass("readonly");
    }

    doGetCombo('/services/parentList.do', '', '${installInfo.failLoc}','failLoc', 'S' , '');
    doGetCombo('/services/selectFailChild.do', '${installInfo.failLoc}', '${installInfo.c5}','failReason', 'S' , '');

});

  function fn_saveInstall() {
	    if (fn_validate()) {

	       var  dayc = ${installInfo.dayc};
	       var  monc = ${installInfo.monc};
	       var  yearc = ${installInfo.yearc};

	        var today = new Date();

	        var dd = String(today.getDate()).padStart(2, '0');
	        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
	        var yyyy = today.getFullYear();

	        var crt_day = (yearc * 12 * 30) +  (monc * 30) + (dayc * 1) ;
	        var sys_day = (yyyy * 12 * 30) +  (mm * 30) + ( dd * 1) ;

	         if ( (sys_day - crt_day) > 10 ) {
	            Common.alert('Fail installation Result only allow within 7 days to edit');
	            return;
	        }

	      // KR-OHK Serial Check add
	      Common.ajax("POST", "/homecare/services/install/hcFailInstallation.do", $("#editInstallForm").serializeJSON(), function(result) {
	        Common.alert(result.message);
	        if (result.message == "Installation result successfully updated.") {
	          $("#popup_wrap").remove();
	          fn_installationListSearch();
	        }
	      });
	    }
  }

  function fn_openFailChild(selectedData){
      console.log("selectedData::" + selectedData);
     // $("#failReasonCode").attr("disabled",false);
      doGetCombo('/services/selectFailChild.do', selectedData, '','failReason', 'S' , '');
  }

  function fn_validate() {
    var msg = "";

    if ($("#editInstallForm #installdt").val() == '') {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Actual Install Date' htmlEscape='false'/> </br>";
    }
    if ($("#editInstallForm #sirimNo").val().trim() == '' || ("#editInstallForm #sirimNo") == null) {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Sirim No' htmlEscape='false'/> </br>";
    }
    if ($("#editInstallForm #failLoc").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Failed Location' htmlEscape='false'/> </br>";
     }
    if ($("#editInstallForm #failReason").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Failed Reason' htmlEscape='false'/> </br>";
     }

    if ($("#editInstallForm #serialNo").val().trim() == '' || ("#editInstallForm #serialNo") == null) {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
    }
    else {
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

    if (msg != "") {
      Common.alert(msg);
      return false;
    }
    return true;
  }

  function fn_serialSearchPop(){
	  if( $("#frmSerialNo").hasClass("readonly") == true ){
          return;
      }
      serialGubun = "2";

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

  function fn_serialSearchPop1(){
      serialGubun = "1";

      $("#pLocationType").val('${installInfo.whLocGb}');
      $('#pLocationCode').val('${installInfo.ctWhLocId}');
      $("#pItemCodeOrName").val('${orderDetail.basicInfo.stockCode}');

      Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
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
        <input id="pGubun" name="pGubun" type="hidden" value="RADIO" />
        <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
        <input id="pLocationType" name="pLocationType" type="hidden" value="" />
        <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
        <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
        <input id="pStatus" name="pStatus" type="hidden" value="" />
        <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
    </form>
      <br />
      <form action="#" id="editInstallForm" method="post">
        <input type="hidden" value="<c:out value="${installInfo.resultId}"/>" id="resultId" name="resultId" />
	    <input type="hidden" value="<c:out value="${installInfo.installEntryId}"/>" id="entryId" name="entryId" />
	    <input type="hidden" value="<c:out value="${installInfo.serialRequireChkYn}"/>" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
	    <input type="hidden" value="<c:out value="${installInfo.c14}"/>" id="hidInstallEntryNo" name="hidInstallEntryNo" />
	    <input type="hidden" value="<c:out value="${orderDetail.basicInfo.ordId}"/>" id="hidSalesOrderId" name="hidSalesOrderId" />
	    <input type="hidden" value="<c:out value="${orderDetail.basicInfo.ordNo}"/>" id="hidSalesOrderNo" name="hidSalesOrderNo" />
	    <input type="hidden" value="<c:out value="${installInfo.serialNo}"/>" id="hidSerialNo" name="hidSerialNo" />
		<input type="hidden" value="<c:out value="${orderDetail.basicInfo.ordCtgryCd}"/>" id="ordCtgryCd" name="ordCtgryCd" />
	    <input type="hidden" value="<c:out value="${frameInfo.serialChk}"/>" id="hidFrmSerialChkYn" name="hidFrmSerialChkYn" />
	    <input type="hidden" value="<c:out value="${frameInfo.salesOrdId}"/>" id="hidFrmOrdId" name="hidFrmOrdId" />
	    <input type="hidden" value="<c:out value="${frameInfo.salesOrdNo}"/>" id="hidFrmOrdNo" name="hidFrmOrdNo" />
	    <input type="hidden" value="<c:out value="${frameInfo.frmSerial}"/>" id="hidFrmSerialNo" name="hidFrmSerialNo" />

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
       <th scope="row"><spring:message code='service.title.SirimNo' /><span class="must"> *</span></th>
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
       <th id="oldMatDispLbl" scope="row"><spring:message code='service.title.oldMattressDisposal'/></th>
    		<td><input id="dispCommYes" name="dispComm" type="radio" value="1" /><span><spring:message code='sal.title.text.yes'/></span>
        	<input id="dispCommNo" name="dispComm" type="radio" value="0" /><span><spring:message code='sal.title.text.no'/></span>
    		</td>
      </tr>
            <tr>
            <th scope="row"><spring:message code='service.title.FailedLocation' /><span name="m15" id="m15" class="must">*</span></th>
            <td><select class="w100p" id="failLoc" name="failLoc"  onchange="fn_openFailChild(this.value)" >
                <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failParent}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach></td>
            </select>
            <th scope="row"><spring:message code='service.title.FailedReason' /><span name="m6" id="m6" class="must">*</span></th>
		      <td><select class="w100p" id="failReason" name="failReason">
		        <option value="0">Failed Reason</option>
		        <c:forEach var="list" items="${failReason}" varStatus="status">
		         <option value="${list.resnId}">${list.c1}</option>
		        </c:forEach>
		      </select></td>
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
      </form>
      <br />
      <ul class="center_btns">
        <li><p class="btn_blue2"><a href="#" onclick="fn_saveInstall()"><spring:message code='service.btn.SaveInstallationResult' /></a></p></li>
      </ul>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
