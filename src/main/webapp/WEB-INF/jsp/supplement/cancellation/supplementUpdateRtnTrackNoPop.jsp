<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
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
          var supRefNo = $("#_infoSupRefNo").val();
          var custName = $("#_infoCustName").val();
          var custEmailNm = $("#_infoCustNameEmail").val();
          var custEmail = $("#_infoCustEmail").val();

          if ($("#parcelRtnTrackNo").val() == null || $("#parcelRtnTrackNo").val().trim() == "") {
            var msgLabel = "<spring:message code='supplement.text.supplementPrcRtnTrcNo'/>"
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
            return;
          }

          var param = {
            parcelTrackNo : parcelTrackNo,
            parcelRtnTrackNo : $("#parcelRtnTrackNo").val() ,
            supRefId : supRefId,
            //inputParcelTrackNo : inputParcelTrackNo,
            supRefNo : supRefNo,
            custName : custName,
            custEmail : custEmail,
            canReqId : '${canReqId}'
          };

          Common.ajax( 'GET', "/supplement/cancellation/checkDuplicatedTrackNo", param,
            function(result) {
              if (result.length > 0) {
                Common.alert("<spring:message code='supplement.alert.msg.rtnTckNoExist'/>" + " (" + result[0].supReqCancNo + ")");
                return;
              } else {
                Common.ajax("POST", "/supplement/cancellation/updateRefStgStatus.do", param,
                  function(result) {
                     if (result.code == "00") {
                       Common.alert(" The tracking number for " + '${cancReqNo}' + " has been update successfully.", fn_popClose());
                     } else {
                       Common.alert(result.message, fn_popClose);
                     }
                  });
                }
            });
          });
  });

  function fn_popClose() {
      AUIGrid.clearGridData(supplementGridID);
      AUIGrid.clearGridData(supplementItmGridID);
      fn_getSupplementSubmissionList();
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
      <spring:message code="supplement.title.supplementCancellation" /> - <spring:message code="supplement.title.supplementUpdRtnTrkNo" />
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
    <aside class="title_line">
      <h3><spring:message code="supplement.title.supplementCancDetial" /></h3>
    </aside>
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code="supplement.text.supplementCanReqNo" /></th>
          <td>
            ${cancReqNo}
          </td>
          <th scope="row"><spring:message code="supplement.text.supplementCanDt" /></th>
          <td>
            ${cancReqDt}
          </td>
          <th scope="row"><spring:message code="supplement.text.cancBy" /></th>
          <td>
            ${cancReqBy}
          </td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="sal.title.text.returnStatus" /></th>
          <td>
            ${supRtnStat}
          </td>
          <th scope="row"></th>
          <td>
          </td>
          <th scope="row"></th>
          <td>
          </td>
        </tr>
        </br>
      </tbody>
    </table>

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
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 200px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code="supplement.text.supplementPrcRtnTrcNo" /><span class="must">*</span></th>
          <td colspan='3'>
            <input type="text" title="" class="w100p" name="parcelRtnTrackNo" id="parcelRtnTrackNo" maxlength="20"/>
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