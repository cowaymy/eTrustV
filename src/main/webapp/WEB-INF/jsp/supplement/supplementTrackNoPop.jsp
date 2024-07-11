<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  //var purchaseGridID;
  //var serialTempGridID;
  //var memGridID;
  //var paymentGridID;

  $(document).ready(
    function() {
      $('#btnLedger').click(function() {
        Common.popupWin("frmLedger", "/supplement/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
      });

      $("#_saveBtn").click(
        function() {
          var parcelTrackNo = $("#_infoParcelTrackNo").val();
          var supRefStus = $("#_infoSupRefStus").val();
          var supRefStg = $("#_infoSupRefStgId").val();
          var supRefId = $("#_infoSupRefId").val();
          var inputParcelTrackNo = $("#parcelTrackNo").val();
          var supRefNo = $("#_infoSupRefNo").val();
          var custName = $("#_infoCustName").val();
          var custEmailNm = $("#_infoCustNameEmail").val();
          var custEmail = $("#_infoCustEmail").val();

          if ($("#parcelTrackNo").val() == null || $("#parcelTrackNo").val().trim() == "") {
            Common.alert('Parcel tracking number is required.');
            return;
          }

          var param = {
            parcelTrackNo : parcelTrackNo,
            supRefId : supRefId,
            inputParcelTrackNo : inputParcelTrackNo,
            supRefNo : supRefNo,
            custName : custName,
            custEmail : custEmail
          };

          Common.ajax( 'GET', "/supplement/checkDuplicatedTrackNo", param,
            function(result) {
              if (result.length > 0) {
                Common.alert("Parcel tracking number already exist!");
                return;
              } else {
                Common.ajax("POST", "/supplement/updateRefStgStatus.do", param,
                  function(result) {
                     if (result.code == "00") {
                       Common.alert(" The tracking number for " + supRefNo + " has been update successfully.", fn_popClose());
                     } else {
                       Common.alert(result.message, fn_popClose);
                     }
                  });
                }
            });
          });
  });

  function fn_popClose() {
      AUIGrid.clearGridData(supOrdGridID);
      AUIGrid.clearGridData(supItmDetailGridID);
      fn_getSubListAjax();
    $("#_systemClose").click();
  }

</script>
<div id="popup_wrap" class="popup_wrap">
  <input type="hidden" id="_infoParcelTrackNo" value="${orderInfo.parcelTrackNo}">
  <input type="hidden" id="_infoSupRefStus" value="${orderInfo.supRefStusId}">
  <input type="hidden" id="_infoSupRefStg" value="${orderInfo.supRefStgId}">
  <input type="hidden" id="_infoSupRefId" value="${orderInfo.supRefId}">
  <input type="hidden" id="_infoSupRefNo" value="${orderInfo.supRefNo}">
  <input type="hidden" id="_infoCustName" value="${orderInfo.custName}">
  <input type="hidden" id="_infoCustNameEmail" value="${orderInfo.custEmailNm}">
  <input type="hidden" id="_infoCustEmail" value="${orderInfo.custEmail}">
  <form id="frmLedger" name="frmLedger" action="#" method="post">
    <input id="supRefId" name="supRefId" type="hidden" value="${orderInfo.supRefId}" />
  </form>
  <header class="pop_header">
    <h1>
      <spring:message code="supplement.title.parcelTrackingNo" />
    </h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a id="_systemClose"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <section class="tap_wrap">
      <!------------------------------------------------------------------------------
        Supplement Detail Page Include START
      ------------------------------------------------------------------------------->
      <%@ include
        file="/WEB-INF/jsp/supplement/supplementDetailContent.jsp"%>
      <!------------------------------------------------------------------------------
        Supplement Detail Page Include END
      ------------------------------------------------------------------------------->
    </section>
    <br />
    <!-- <aside class="title_line">
      <h2>
        <spring:message code="supplement.text.parcelTrackingNo" />
      </h2>
    </aside> -->
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code="supplement.text.parcelTrackingNo" /><span class="must">*</span></th>
          <td colspan='3'>
            <input type="text" title="" class="w100p" name="parcelTrackNo" id="parcelTrackNo" />
          </td>
        </tr>
        </br>
      </tbody>
    </table>
    <ul class="center_btns">
      <li><p class="btn_blue2">
          <a id="_saveBtn"><spring:message code="sal.btn.save" /></a>
        </p></li>
    </ul>
  </section>
</div>