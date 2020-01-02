<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/02/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 -->

<script type="text/javaScript">
  $(document).ready(
    function() {
      $("#status").change(function() {
        $("#installDate").val("");
        $("#sirimNo").val("");
        $("#serialNo").val("");
        $("#refNo1").val("");
        $("#refNo2").val("");
        $("#checkCommission").prop("checked", false);
        $("#checkTrade").prop("checked", false);
        $("#checkSms").prop("checked", false);
        $("#msgRemark").val("");
        $("#failReason").val("0");
        $("#nextCallDate").val("");
        $("#remark").val("");
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
        $("#addInstallForm #m2").hide();
        $("#addInstallForm #m4").hide();
        $("#addInstallForm #m5").hide();
      } else {
        $("#addInstallForm #m6").hide();
        $("#addInstallForm #m7").hide();
      }

      $("#hiddenCustomerType").val("${customerContractInfo.typeId}");
      /*
        ("#hiddenPostCode").val("${customerAddress.typeId}");
        ("#hiddenStateName").val("${customerAddress.typeId}");
        ("#hiddenCountryName").val("${customerAddress.typeId}");
      */
      $("#checkCommission").prop("checked", true);
      $("#addInstallForm #installStatus").change(
        function() {
          if ($("#addInstallForm #installStatus").val() == 4) {
            $("#addInstallForm #checkCommission").prop("checked", true);

            $("#addInstallForm #m6").hide();
            $("#addInstallForm #m7").hide();

            $("#addInstallForm #m2").show();
            $("#addInstallForm #m4").show();
            $("#addInstallForm #m5").show();

          } else {
            $("#addInstallForm #checkCommission").prop("checked", false);

            $("#addInstallForm #m2").hide();
            $("#addInstallForm #m4").hide();
            $("#addInstallForm #m5").hide();

            $("#addInstallForm #m6").show();
            $("#addInstallForm #m7").show();
          }

          $("#addInstallForm #installDate").val("");
          $("#addInstallForm #sirimNo").val("");
          $("#addInstallForm #serialNo").val("");
          $("#addInstallForm #refNo1").val("");
          $("#addInstallForm #refNo2").val("");
          $("#addInstallForm #checkTrade").prop("checked", false);
          $("#addInstallForm #checkSms").prop("checked", false);
          $("#addInstallForm #msgRemark").val("Remark:");
          $("#addInstallForm #failReason").val("0");
          $("#addInstallForm #nextCallDate").val("");
          $("#addInstallForm #remark").val("");
        });

        // KR-OHK Serial Check
        if( $("#hidSerialRequireChkYn").val() == 'Y' ) {
        	$("#btnSerialEdit").attr("style", "");
        }
  });

  function fn_installProductExchangeSave() {
    Common.ajax("POST", "/services/saveInstallationProductExchange.do", $("#insertPopupForm").serializeJSON(), function(result) {
      Common.alert("Saved", fn_saveDetailclose);
    });
  }

  function fn_saveInstall() {
    var msg = "";
    if ($("#addInstallForm #installStatus").val() == 4) { // COMPLETED
      if ($("#failReason").val() != 0 || $("#nextCallDate").val() != '') {
        Common.alert("Not allowed to choose a reason for fail or recall date in complete status");
        return;
      }

      if ($("#addInstallForm #installDate").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Actual Install Date' htmlEscape='false'/> </br>";
      }
      if ($("#addInstallForm #sirimNo").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='SIRIM No' htmlEscape='false'/> </br>";
      }
      if ($("#addInstallForm #serialNo").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
      }

      if (msg != "") {
        Common.alert(msg);
        return;
      }
    }

    if ($("#addInstallForm #installStatus").val() == 21) { // FAILED
      if ($("#failReason").val() == 0) {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Failed Reason' htmlEscape='false'/> </br>";
      }

      if ($("#nextCallDate").val() == '') {
        msg += "* <spring:message code='sys.msg.necessary' arguments='Next Call Date' htmlEscape='false'/> </br>";
      }

      if (msg != "") {
        Common.alert(msg);
        return;
      }
    }

    // KR-OHK Serial Check add
    var url = "";

    //if ($("#hidSerialRequireChkYn").val() == 'Y') {
    //    url = "/services/addInstallationSerial.do";
    //} else {
    //    url = "/services/addInstallation_2.do";
    //}

    // Common.ajax("POST", "/services/addInstallation.do",
    Common.ajax("POST", "/homecare/services/install/hcAddInstallationSerial.do",
        $("#addInstallForm").serializeJSON(), function(result) {
          Common.alert(result.message, fn_saveDetailclose);

          $("#popup_wrap").remove();
          fn_installationListSearch();
          /* if (result.code == 'Y') {
              $("#popup_wrap").remove();
              fn_installationListSearch();
          } */
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
        <td><span><c:out value="${viewDetail.installationInfo.codename1}" /></span></td>
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
        <td><span><fmt:formatDate
           value="${viewDetail.exchangeInfo.soExchgCrtDt}"
           pattern="dd-MM-yyyy hh:mm a " /></span></td>
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

  <aside class="title_line">
   <!-- title_line start -->
   <h2>
    <spring:message code='service.title.AddInstallationResult' />
   </h2>
  </aside>
  <!-- title_line end -->
  <form action="#" id="addInstallForm" method="post">
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
   <input type="hidden"
    value="${installResult.custAddId}" id="hidCustAddressId"
    name="hidCustAddressId" /> <input type="hidden"
    value="${installResult.custCntId}" id="hidCustContactId"
    name="hidCustContactId" /> <input type="hidden"
    value="${installResult.custBillId}" id="hiddenBillId"
    name="hiddenBillId" /> <input type="hidden"
    value="${installResult.codeName}" id="hiddenCustomerPayMode"
    name="hiddenCustomerPayMode" /> <input type="hidden"
    value="${installResult.installEntryNo}" id="hiddeninstallEntryNo"
    name="hiddeninstallEntryNo" /> <input type="hidden" value=""
    id="hidActualCTMemCode" name="hidActualCTMemCode" /> <input
    type="hidden" value="" id="hidActualCTId" name="hidActualCTId" /> <input
    type="hidden" value="${sirimLoc.whLocCode}" id="hidSirimLoc"
    name="hidSirimLoc" /> <input type="hidden" value=""
    id="hidCategoryId" name="hidCategoryId" /> <input type="hidden"
    value="" id="hidPromotionId" name="hidPromotionId" /> <input
    type="hidden" value="" id="hidPriceId" name="hidPriceId" /> <input
    type="hidden" value="" id="hiddenOriPriceId" name="hiddenOriPriceId" />
   <input type="hidden" value="${orderInfo.c5}" id="hiddenOriPrice"
    name="hiddenOriPrice" /> <input type="hidden" value=""
    id="hiddenOriPV" name="hiddenOriPV" /> <input type="hidden"
    value="" id="hiddenCatogory" name="hiddenCatogory" /> <input
    type="hidden" value="" id="hiddenProductItem"
    name="hiddenProductItem" /> <input type="hidden" value=""
    id="hidPERentAmt" name="hidPERentAmt" /> <input type="hidden"
    value="" id="hidPEDefRentAmt" name="hidPEDefRentAmt" /> <input
    type="hidden" value="" id="hidInstallStatusCodeId"
    name="hidInstallStatusCodeId" /> <input type="hidden" value=""
    id="hidPEPreviousStatus" name="hidPEPreviousStatus" /> <input
    type="hidden" value="" id="hidDocId" name="hidDocId" /> <input
    type="hidden" value="" id="hidOldPrice" name="hidOldPrice" /> <input
    type="hidden" value="" id="hidExchangeAppTypeId"
    name="hidExchangeAppTypeId" /> <input type="hidden" value=""
    id="hiddenCustomerType" name="hiddenCustomerType" /> <input
    type="hidden" value="" id="hiddenPostCode" name="hiddenPostCode" />
   <input type="hidden" value="" id="hiddenCountryName"
    name="hiddenCountryName" /> <input type="hidden" value=""
    id="hiddenStateName" name="hiddenStateName" /> <input type="hidden"
    value="${promotionView.promoId}" id="hidPromoId" name="hidPromoId" />
   <input type="hidden" value="${promotionView.promoPrice}"
    id="hidPromoPrice" name="hidPromoPrice" /> <input type="hidden"
    value="${promotionView.promoPV}" id="hidPromoPV" name="hidPromoPV" />
   <input type="hidden" value="${promotionView.swapPromoId}"
    id="hidSwapPromoId" name="hidSwapPromoId" /> <input type="hidden"
    value="${promotionView.swapPormoPrice}" id="hidSwapPromoPrice"
    name="hidSwapPromoPrice" /> <input type="hidden"
    value="${promotionView.swapPromoPV}" id="hidSwapPromoPV"
    name="hidSwapPromoPV" /> <input type="hidden" value=""
    id="hiddenInstallPostcode" name="hiddenInstallPostcode" /> <input
    type="hidden" value="" id="hiddenInstallPostcode"
    name="hiddenInstallPostcode" /> <input type="hidden" value=""
    id="hiddenInstallStateName" name="hiddenInstallStateName" /> <input
    type="hidden" value="${customerInfo.name}" id="hidCustomerName"
    name="hidCustomerName" /> <input type="hidden"
    value="${customerContractInfo.telM1}" id="hidCustomerContact"
    name="hidCustomerContact" /> <input type="hidden"
    value="${installResult.salesOrdNo}" id="hidTaxInvDSalesOrderNo"
    name="hidTaxInvDSalesOrderNo" /> <input type="hidden"
    value="${installResult.installEntryNo}"
    id="hidTradeLedger_InstallNo" name="hidTradeLedger_InstallNo" />
   <c:if test="${installResult.codeid1  == '257' }">
    <input type="hidden" value="${orderInfo.c5}" id="hidOutright_Price"
     name="hidOutright_Price" />
   </c:if>
   <c:if test="${installResult.codeid1  == '258' }">
    <input type="hidden" value=" ${orderInfo.c12}"
     id="hidOutright_Price" name="hidOutright_Price" />
   </c:if>
   <input type="hidden" value="${installation.Address}"
    id="hidInstallation_AddDtl" name="hidInstallation_AddDtl" /> <input
    type="hidden" value="${installation.areaId}"
    id="hidInstallation_AreaID" name="hidInstallation_AreaID" /> <input
    type="hidden" value="${customerContractInfo.name}"
    id="hidInatallation_ContactPerson"
    name="hidInatallation_ContactPerson" />
    <input type="hidden"
    value="${installResult.rcdTms}"
    id="rcdTms" name="rcdTms" />
    <input type="hidden" value="${installResult.serialRequireChkYn}" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
    <input type="hidden" id='hidStockSerialNo' name='hidStockSerialNo' />

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
        <c:forEach var="list" items="${installStatus }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message code='service.title.ActualInstalledDate' /><span name="m2" id="m2" class="must">*</span></th>
      <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="installDate" name="installDate" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='home.lbl.dtCode' /><span name="m3" id="m3" class="must">*</span></th>
      <td colspan="3">
        <input type="text" title="" value="<c:out value="(${installResult.ctMemCode}) ${installResult.ctMemName}"/>" placeholder="" class="readonly" style="width: 100%;" id="ctCode" readonly="readonly" name="ctCode" />
        <input type="hidden" title="" value="${installResult.ctId}" placeholder="" class="" style="width: 200px;" id="CTID" name="CTID" />
        <!-- <p class="btn_sky"><a href="#">Search</a></p></td> -->
        <%-- <th scope="row"><spring:message code='service.title.CTName' /></th>
              <td><input type="text" title="" placeholder=""
                class="readonly w100p" readonly="readonly" id="ctName"
                name="ctName" /></td> --%>
      </td>
     </tr>
    </tbody>
   </table>
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
      <td colspan="8">
        <label>
            <input type="checkbox" id="checkCommission" name="checkCommission" />
            <span><spring:message code='service.btn.AllowCommission' /> ?</span></label>
        <label>
            <input type="checkbox" id="checkTrade" name="checkTrade" />
            <span><spring:message code='service.btn.IsTradeIn' /> ?</span>
        </label>
        <label>
            <input type="checkbox" id="checkSms" name="checkSms" />
            <span><spring:message code='service.btn.RequireSMS' /> ?</span>
        </label>
      </td>
     </tr>
    </tbody>
   </table>
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
      <td colspan="2">
        <label>
            <input type="checkbox" id="checkSend" name="checkSend" />
            <span><spring:message code='service.title.SendSMSToSalesPerson' /></span>
        </label>
      </td>
     </tr>
     <tr>
      <th scope="row" rowspan="2">
        <spring:message code='service.title.Message' />
      </th>
      <td>
        <textarea cols="20" rows="5" readonly="readonly" class="readonly" id="msg" name="msg">RM0.00 COWAY DSC
Install Status: Completed
Order No: ${viewDetail.exchangeInfo.salesOrdNo}
Name: ${orderInfo.name2}</textarea>
      </td>
     </tr>
     <tr>
      <td><input type="text" title="" placeholder="Remark" class="w100p"
       value="Remark:" id="msgRemark" name="msgRemark" /></td>
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
      <th scope="row">
        <spring:message code='service.title.FailedReason' /><span name="m6" id="m6" class="must">*</span>
      </th>
      <td>
        <select class="w100p" id="failReason" name="failReason">
         <option value="0">Failed Reason</option>
        <c:forEach var="list" items="${failReason }" varStatus="status">
         <option value="${list.resnId}">${list.c1}</option>
        </c:forEach>
        </select>
      </td>
      <th scope="row"><spring:message code='service.title.NextCallDate' /><span name="m7" id="m7" class="must">*</span>
      </th>
      <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="nextCallDate" name="nextCallDate" />
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
      <td>
        <input type="text" title="" placeholder="<spring:message code='service.title.Remark' />" class="w100p" id="remark" name="remark" />
      </td>
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