<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  var TAB_NM = "${eRequestDetail.typeId}";
  var ORD_ID = "${orderDetail.basicInfo.ordId}";
  var ORD_NO = "${orderDetail.basicInfo.ordNo}";
  var AUX_ORD_ID = "${orderDetail.basicInfo.auxSalesOrdId}";
  var AUX_ORD_NO = "${orderDetail.basicInfo.auxSalesOrdNo}";

  var rqstId = "${eRequestDetail.rqstId}";
  var stusId = "${eRequestDetail.stusCodeId}";
  var rqstDataFr = "${eRequestDetail.rqstDataFr}";
  var rqstDataTo = "${eRequestDetail.rqstDataTo}";
  var rqstDataRem = "${eRequestDetail.rqstRem}";

  var isHomecare= '${orderDetail.basicInfo.bndlId}' > 0 ? "Y" : "N";

  var _approvalMsg = "Another order :  " + AUX_ORD_NO + "<br/>is also approved together.<br/><br/>";
  var filterGridID;

  $(document).ready(function() {

    if (FormUtil.isNotEmpty(TAB_NM)) {
      fn_changeTab(TAB_NM);
    }
    doGetCombo('/common/selectCodeList.do', '455', TAB_NM, 'ordReqType', 'S'); //Order Edit Type

    if('${SESSION_INFO.userTypeId}' == 1 || '${SESSION_INFO.userTypeId}' == 2 || '${SESSION_INFO.userTypeId}' == 7){
    	if ("${SESSION_INFO.memberLevel}" == "4") {
    		$('#frmCnctAppr').find("input,textarea,button,select").attr("disabled",true);
            $('#frmCnctAppr').hide();
            $("#btnSaveCnct").hide();
            $('#frmInstAddrAppr').hide();
            $("#btnSaveInstAddr").hide();
    	}else if ("${SESSION_INFO.memberLevel}" < "4" && stusId == 1){
    		$("#frmCnctAppr #reqStusId").addClass("disabled");
    		$("#frmCnctAppr #reqStusId option[value='5']").remove();
    		$("#frmInstAddrAppr #reqStusId").addClass("disabled");
            $("#frmInstAddrAppr #reqStusId option[value='5']").remove();
    	}

    }
  });

  $(function() {
    $('#btnEditType').click(function() {
      var tabNm = $('#ordReqType').val();
      fn_changeTab(tabNm);
    });

    $('#btnReqCntc').click(function() {
        //if (fn_validReqCanc())
          fn_doSaveReqCnct();
      });

    $('#btnReqInstAddr').click(function() {
        //if (fn_validReqCanc())
          fn_doSaveReqInstAddr();
      });

    $('#btnSaveCnct').click(function(){

    	if($("#modRemCntc").val() == ""){
            Common.alert("Please fill in update reason<br/>");
            return;
        }

    	Common.confirm("<spring:message code="sys.common.alert.save" />",function(){
    		Common.ajax("GET", "/sales/order/selectRequestApprovalList.do", {rqstId : rqstId}, function(request) {
    			console.log($('#frmCnctAppr').serializeJSON());
    			if(request[0].stus == "Active"){
    				Common.ajax("POST","/sales/order/saveApprovalCnct.do",$('#frmCnctAppr').serializeJSON(),function(result) {
                        if(result.code == "00")
                            Common.alert("eRequest approval saved<br>",fn_selfClose());
                        else
                            Common.alert("Failed to save.<br>",fn_selfClose());
    				});
    			}else{
    				Common.alert("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
    			}
    		});
    	},function(){fn_selfClose()});
    });

    $('#btnSaveInstAddr').click(function(){
    	if($("#modRemInstAddr").val() == ""){
            Common.alert("Please fill in update reason<br/>");
            return;
        }

    	Common.confirm("<spring:message code="sys.common.alert.save" />",function(){
    		Common.ajax("GET", "/sales/order/selectRequestApprovalList.do", {rqstId : rqstId}, function(request) {
    			if(request[0].stus == "Active"){
    				Common.ajax("POST","/sales/order/saveApprovalInstAddr.do",$('#frmInstAddrAppr').serializeJSON(),function(result) {
    					if(result.code == "00")
    						Common.alert("eRequest approval saved<br>",fn_selfClose());
                        else
                            Common.alert("Failed to save.<br>",fn_selfClose());
    				});
    			}else{
    				Common.alert("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
    			}
    		});
    	},function(){fn_selfClose()});
    });

  });

  function fn_changeTab(tabNm) {

    var vTit = '<spring:message code="sal.page.title.ordReq" />';

    if($("#ordReqType option:selected").index() > 0) {
    	   vTit += ' - '+$('#ordReqType option:selected').text();
     }

    $('#hTitle').text(vTit);

    if(tabNm == 5969){
    	fn_loadCntcPerson(rqstDataFr,rqstDataTo);
    	$('#scCP').removeClass("blind");
    	$('#aTabIns').click();

    	if(stusId != 1){
    		$('#frmCnctAppr').find("input,textarea,button,select").attr("disabled",true);
    		$("#btnSaveCnct").hide();
    	}
    }else{
    	$('#scCP').addClass("blind");
    }

    if(tabNm == 5970){
    	fn_loadInstallAddrInfoNew(rqstDataFr,rqstDataTo);
    	$('#scIN').removeClass("blind");
    	$('#aTabIns').click();

    	if(stusId != 1){
    		$('#frmInstAddrAppr').find("input,textarea,button,select").attr("disabled",true);
            $("#btnSaveInstAddr").hide();
        }
    }else{
    	$('#scIN').addClass("blind");
    }

  }

  function fn_selfClose() {
	  $('#btnCloseReq').click();
	  fn_requestApprovalListAjax();
  }

  function fn_loadInstallAddrInfoNew(custAddIdOld,custAddIdNew) {
	  var brnchIdOld,brnchIdNew;
	  console.log(isHomecare);

	    Common.ajaxSync("GET", "/sales/order/selectInstallAddrInfo.do", {custAddId : custAddIdOld, isHomecare : isHomecare}, function(addrInfo) {

	      if (addrInfo != null) {
	        $("#modInstAddrDtlOld").text(addrInfo.addrDtl);
	        $("#modInstStreetOld").text(addrInfo.street);
	        $("#modInstAreaOld").text(addrInfo.area);
	        $("#modInstCityOld").text(addrInfo.city);
	        $("#modInstPostCdOld").text(addrInfo.postcode);
	        $("#modInstStateOld").text(addrInfo.city);
	        $("#modInstCntyOld").text(addrInfo.country);

	        doGetComboSepa('/common/selectBranchCodeList.do', '3', '-', addrInfo.brnchId , 'modDscBrnchIdOld', 'S'); //Branch Code
	      }
	    });

	     Common.ajaxSync("GET", "/sales/order/selectInstallAddrInfo.do", {custAddId : custAddIdNew, isHomecare : isHomecare}, function(addrInfo) {

	     if (addrInfo != null) {
	       $("#modInstAddrDtlNew").text(addrInfo.addrDtl);
           $("#modInstStreetNew").text(addrInfo.street);
	       $("#modInstAreaNew").text(addrInfo.area);
	       $("#modInstCityNew").text(addrInfo.city);
	       $("#modInstPostCdNew").text(addrInfo.postcode);
	       $("#modInstStateNew").text(addrInfo.city);
	       $("#modInstCntyNew").text(addrInfo.country);

	       $("#dscBrnchId").val(addrInfo.brnchId);
	       doGetComboSepa('/common/selectBranchCodeList.do', '3', '-', addrInfo.brnchId, 'modDscBrnchIdNew', 'S'); //Branch Code
	      }
	    });

	  }

  function fn_loadCntcPerson(custCntcIdOld, custCntcIdNew) {
	Common.ajaxSync("GET","/sales/order/selectCustCntcJsonInfo.do",{custCntcId : custCntcIdOld},function(custCntcInfo) {
		if (custCntcInfo != null) {
			var vInit = FormUtil.isEmpty(custCntcInfo.code) ? "" : custCntcInfo.code;
			$("#modCntcPersonOld").text(vInit + ' ' + custCntcInfo.name1);
			$("#modCntcMobNoOld").text(custCntcInfo.telM1);
			$("#modCntcResNoOld").text(custCntcInfo.telR);
			$("#modCntcOffNoOld").text(custCntcInfo.telO);
			$("#modCntcFaxNoOld").text(custCntcInfo.telf);
		}
		});

	Common.ajaxSync("GET","/sales/order/selectCustCntcJsonInfo.do",{custCntcId : custCntcIdNew},function(custCntcInfo) {
        if (custCntcInfo != null) {
            var vInit = FormUtil.isEmpty(custCntcInfo.code) ? "" : custCntcInfo.code;
            $("#modCntcPersonNew").text(vInit + ' ' + custCntcInfo.name1);
            $("#modCntcMobNoNew").text(custCntcInfo.telM1);
            $("#modCntcResNoNew").text(custCntcInfo.telR);
            $("#modCntcOffNoNew").text(custCntcInfo.telO);
            $("#modCntcFaxNoNew").text(custCntcInfo.telf);
        }
        });

	}

</script>
<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1 id="hTitle">
      <spring:message code="sal.page.title.ordReq" />
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2">
          <a id="btnCloseReq" href="#"> <spring:message code="sal.btn.close" /></a>
        </p></li>
    </ul>
  </header>
  <section class="pop_body">
    <section class="search_table">
      <form action="#" method="post">
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 110px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code="sal.text.editType" /></th>
              <td><select id="ordReqType" class="mr5" disabled></select></td>
            </tr>
          </tbody>
        </table>
      </form>
    </section>
<section id="scCP" class="pop_body blind"><!-- pop_body start -->
    <article class="acodi_wrap"><!-- acodi_wrap start -->
    <dl >
        <dt class="click_add_on"><a href="#"><spring:message code="sal.title.text.orderFullDetails" /></a></dt>
        <dd>
            <section class="tap_wrap mt0"><!-- tap_wrap start -->
                <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
            </section><!-- tap_wrap end -->
        </dd>
        <dt class="click_add_on on"><a href="#"><spring:message code="sal.page.title.custContact" /> - CURRENT </a></dt>
        <dd>
            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:130px" />
                <col style="width:*" />
                <col style="width:130px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code="sal.text.name" /></th>
                <td colspan="3"><span id="modCntcPersonOld"></td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.mobNumber" /></th>
                <td><span id="modCntcMobNoOld"></span></td>
                <th scope="row"><spring:message code="sal.title.text.officeNumber" /></th>
                <td><span id="modCntcOffNoOld"></span></td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.residenceNumber" /></th>
                <td><span id="modCntcResNoOld"></span></td>
                <th scope="row"><spring:message code="sal.title.text.faxNumber" /></th>
                <td><span id="modCntcFaxNoOld"></span></td>
            </tr>
        </tbody>
        </table><!-- table end -->
        <dt class="click_add_on on"><a href="#"><spring:message code="sal.page.title.custContact" /> - NEW </a></dt>
        <dd>
            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:130px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row"><spring:message code="sal.text.name" /></th>
                <td colspan="3"><span id="modCntcPersonNew"></td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.mobNumber" /></th>
                <td><span id="modCntcMobNoNew"></span></td>
                <th scope="row"><spring:message code="sal.title.text.officeNumber" /></th>
                <td><span id="modCntcOffNoNew"></span></td>
             </tr>
             <tr>
                <th scope="row"><spring:message code="sal.title.text.residenceNumber" /></th>
                <td><span id="modCntcResNoNew"></span></td>
                <th scope="row"><spring:message code="sal.title.text.faxNumber" /></th>
                <td><span id="modCntcFaxNoNew"></span></td>
             </tr>
             <tr>
              <th scope="row"><spring:message code="sal.text.remark" /></th>
              <td colspan="3">${eRequestDetail.rqstRem}</td>
        </tr>
        </tbody>
        </table><!-- table end -->

    </dd>

    <dt class="click_add_on on"><a href="#"><spring:message code="sales.title.eReqAppr" /></a></dt>
    <dd>
    <section class="search_table">
      <form id="frmCnctAppr" action="#" method="post">
      <input id="rqstId" name="rqstId" type="hidden" value="${eRequestDetail.rqstId}" />
      <input id="salesOrdId" name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
      <input id="custCntcId" name="custCntcId" type="hidden" value="${eRequestDetail.rqstDataTo}" />
      <input id="auxRqstId" name="auxRqstId" type="hidden" value="${eRequestAux.rqstId}" />
      <input id="auxOrdId" name="auxOrdId" type="hidden" value="${eRequestAux.salesOrdId}" />
          <table class="type1">
          <caption>table</caption>
          <colgroup>
              <col style="width: 160px" />
              <col style="width: *" />
          </colgroup>
          <tbody>
          <tr>
              <th scope="row"><spring:message code="sal.title.text.requestStatus" /></th>
              <td>
                  <select id="reqStusId" name="reqStusId" class="w100p">
                      <option value="5"><spring:message code="sal.combo.text.approv" /></option>
                      <option value="6"><spring:message code="sal.combo.text.rej" /></option>
                  </select>
              </td>
          </tr>
          <tr>
              <th scope="row"><spring:message code="sal.text.remark" /><span class="must">*</span></th>
              <td><textarea id="modRemCntc" name="modRemCntc" cols="20" rows="5">${eRequestDetail.rem}</textarea></td>
           </tr>
           </tbody>
           </table>
       </form>
     </section>

     <ul class="center_btns">
        <li><p class="btn_blue2"><a id="btnSaveCnct" href="#"><spring:message code="sales.btn.save" /></a></p></li>
     </ul>
    </dd>
</dl>
</article><!-- acodi_wrap end -->

</section><!-- pop_body end -->

<section id="scIN" class="pop_body blind"><!-- pop_body start -->
<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl >
    <dt class="click_add_on"><a href="#"><spring:message code="sal.title.text.orderFullDetails" /></a></dt>
    <dd>
        <section class="tap_wrap mt0"><!-- tap_wrap start -->
            <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
        </section><!-- tap_wrap end -->
    </dd>

    <dt class="click_add_on on"><a href="#"><spring:message code="sal.page.title.custAddr" /> - CURRENT </a></dt>
    <dd>
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
            <td colspan="3"><span id="modInstAddrDtlOld"></span></td>
            <th scope="row"><spring:message code="sal.text.postCode" /></th>
            <td><span id="modInstPostCdOld"></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.street" /></th>
            <td colspan="3"><span id="modInstStreetOld"></span></td>
            <th scope="row"><spring:message code="sal.text.city" /></th>
            <td><span id="modInstCityOld"></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.area" /></th>
            <td colspan="3"><span id="modInstAreaOld"></span></td>
            <th scope="row"><spring:message code="sal.text.state" /></th>
            <td><span id="modInstStateOld"></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
            <td colspan="3"><select id="modDscBrnchIdOld" name="modDscBrnchIdOld" class="w100p" disabled></select></td>
            <th scope="row"><spring:message code="sal.text.country" /></th>
            <td ><span id="modInstCntyOld"></span></td>
        </tr>
    </tbody>
    </table><!-- table end -->

    <dt class="click_add_on on"><a href="#"><spring:message code="sal.page.title.custAddr" /> - NEW </a></dt>
    <dd>
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
            <td colspan="3"><span id="modInstAddrDtlNew"></span></td>
            <th scope="row"><spring:message code="sal.text.postCode" /></th>
            <td><span id="modInstPostCdNew"></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.street" /></th>
            <td colspan="3"><span id="modInstStreetNew"></span></td>
            <th scope="row"><spring:message code="sal.text.city" /></th>
            <td><span id="modInstCityNew"></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.area" /></th>
            <td colspan="3"><span id="modInstAreaNew"></span></td>
            <th scope="row"><spring:message code="sal.text.state" /></th>
            <td><span id="modInstStateNew"></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
            <td colspan="3"><select id="modDscBrnchIdNew" name="modDscBrnchIdNew" class="w100p" disabled></select></td>
            <th scope="row"><spring:message code="sal.text.country" /></th>
            <td ><span id="modInstCntyNew"></span></td>
        </tr>
        <tr>
              <th scope="row"><spring:message code="sal.text.remark" /></th>
              <td colspan="5">${eRequestDetail.rqstRem}</td>
        </tr>
    </tbody>
    </table><!-- table end -->

    </dd>

    <dt class="click_add_on on"><a href="#"><spring:message code="sales.title.eReqAppr" /></a></dt>
    <dd>
    <section class="search_table">
      <form id="frmInstAddrAppr" action="#" method="post">
        <input id="rqstId" name="rqstId" type="hidden" value="${eRequestDetail.rqstId}" />
        <input id="salesOrdId" name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
        <input id="custAddrId" name="custAddrId" type="hidden" value="${eRequestDetail.rqstDataTo}" />
        <input id="auxRqstId" name="auxRqstId" type="hidden" value="${eRequestAux.rqstId}" />
        <input id="auxOrdId" name="auxOrdId" type="hidden" value="${eRequestAux.salesOrdId}" />
        <input id="dscBrnchId" name="dscBrnchId" type="hidden"/>
          <table class="type1">
          <caption>table</caption>
          <colgroup>
              <col style="width: 160px" />
              <col style="width: *" />
          </colgroup>
          <tbody>
          <tr>
              <th scope="row"><spring:message code="sal.title.text.requestStatus" /></th>
              <td>
                  <select id="reqStusId" name="reqStusId" class="w100p">
                      <option value="5"><spring:message code="sal.combo.text.approv" /></option>
                      <option value="6"><spring:message code="sal.combo.text.rej" /></option>
                  </select>
              </td>
          </tr>
          <tr>
              <th scope="row"><spring:message code="sal.text.remark" /><span class="must">*</span></th>
              <td><textarea id="modRemInstAddr" name="modRemInstAddr" cols="20" rows="5">${eRequestDetail.rem}</textarea></td>
           </tr>
           </tbody>
           </table>
       </form>
     </section>
            <!-- search_table end -->
            <ul class="center_btns">
              <li><p class="btn_blue2"><a id="btnSaveInstAddr" href="#"><spring:message code="sales.btn.save" /></a></p></li>
            </ul>
    </dd>
</dl>
</article><!-- acodi_wrap end -->

</section><!-- pop_body end -->
</div>