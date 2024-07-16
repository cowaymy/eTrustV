<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  var rtnItmDetailGridID;
  $(document).ready(
    function() {
      createSubItmDetailGrid();
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

          /*if ($("#rtnGoodCond").val() == null || $("#rtnGoodCond").val().trim() == "") {
            var msgLabel = "<spring:message code='supplement.text.supplementTtlRtnGoodCondQty'/>"
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
            return;
          }

          if ($("#rtnDefectCond").val() == null || $("#rtnDefectCond").val().trim() == "") {
            var msgLabel = "<spring:message code='supplement.text.supplementTtlRtnDefectCondQty'/>"
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
            return;
          }

          if ($("#rtnMissCond").val() == null || $("#rtnMissCond").val().trim() == "") {
            var msgLabel = "<spring:message code='supplement.text.supplementTtlRtnMissCondQty'/>"
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
            return;
          }

          var ttlQty = Number($("#rtnGoodCond").val()) + Number($("#rtnDefectCond").val()) + Number($("#rtnMissCond").val());
          if (ttlQty != Number($("#ttlGoodQty").val())) {
            Common.alert("<spring:message code='supplement.alert.msg.rtnQtyNoSame' arguments='"+ ttlQty + ";" + $("#ttlGoodQty").val() +"' htmlEscape='false' argumentSeparator=';'/>");
            return;
          }*/

          if (!verifyReturnQty()) {
            return;
          }

          var rtnItmList = AUIGrid.getGridData(rtnItmDetailGridID);
          var param = {
            parcelTrackNo : parcelTrackNo,
            supRefId : supRefId,
            supRefNo : supRefNo,
            custName : custName,
            custEmail : custEmail,
            canReqId : '${canReqId}',
            supRtnId : '${supRtnId}',
            rtnGoodCondQty : $("#rtnGoodCond").val(),
            rtnDefectCondQty : $("#rtnDefectCond").val() ,
            rtnMissCond : $("#rtnMissCond").val(),
            rtnItmList : rtnItmList
          };

          Common.ajax("POST", "/supplement/cancellation/updateReturnGoodsQty.do", param,
            function(result) {
              if (result.code == "00") {
                Common.alert(" Return quantity for " + '${cancReqNo}' + " has been update successfully.", fn_popClose());
              } else {
                Common.alert(result.message, fn_popClose);
              }
            });
      });

      $('#rtnGoodCond').on('keypress', function(e) {
          if (!/\d/.test(String.fromCharCode(e.which))) {
              e.preventDefault();
          }
      });

      $('#rtnDefectCond').on('keypress', function(e) {
          if (!/\d/.test(String.fromCharCode(e.which))) {
              e.preventDefault();
          }
      });

      $('#rtnMissCond').on('keypress', function(e) {
          if (!/\d/.test(String.fromCharCode(e.which))) {
              e.preventDefault();
          }
      });

      $('#rtnGoodCond').on('blur', function() {
          var value = $(this).val();

          value = value.replace(/[^0-9]/g, '');

          var numberValue = parseInt(value, 10);

          if (isNaN(numberValue)) {
              $(this).val('');
          } else {
              $(this).val(numberValue);
          }
      });

      $('#rtnDefectCond').on('blur', function() {
          var value = $(this).val();

          value = value.replace(/[^0-9]/g, '');

          var numberValue = parseInt(value, 10);

          if (isNaN(numberValue)) {
              $(this).val('');
          } else {
              $(this).val(numberValue);
          }
      });

      $('#rtnMissCond').on('blur', function() {
          var value = $(this).val();

          value = value.replace(/[^0-9]/g, '');

          var numberValue = parseInt(value, 10);

          if (isNaN(numberValue)) {
              $(this).val('');
          } else {
              $(this).val(numberValue);
          }
      });

      var supRefId = '${orderInfo.supRefId}';
      var param = {supRefId : supRefId };
      Common.ajax("GET", "/supplement/cancellation/getSupplementRtnItmDetailList", param, function(result) {
        AUIGrid.setGridData(rtnItmDetailGridID, result);
      })
  });

  function verifyReturnQty() {
    var rowCount = AUIGrid.getRowCount(rtnItmDetailGridID);
    if(rowCount == null || rowCount < 1){
      Common.alert('<spring:message code="sal.alert.msg.selectItm" />');
      return;
    }

    for (var a=0; a<rowCount; a++) {
      var itm = AUIGrid.getColumnValues(rtnItmDetailGridID, 'itemDesc');
      var itmQty = AUIGrid.getColumnValues(rtnItmDetailGridID, 'quantity');
      var itmGoodCondQty = AUIGrid.getColumnValues(rtnItmDetailGridID, 'ttlGoodCond');
      var itmDefectCondQty = AUIGrid.getColumnValues(rtnItmDetailGridID, 'ttlDefectCond');
      var itmMiaCondQty = AUIGrid.getColumnValues(rtnItmDetailGridID, 'ttlMiaCond');

      var insertQty = Number(itmGoodCondQty[a]) + Number(itmDefectCondQty[a]) + Number(itmMiaCondQty[a]);
      if (itmQty[a] != insertQty) {
        Common.alert("<spring:message code='supplement.alert.msg.rtnQtyNoSame' arguments='"+ insertQty + ";" + itmQty[a] + " (" + itm[a] + ")" +"' htmlEscape='false' argumentSeparator=';'/>");
        return false;
      }
    }
    return true;
  }

  function fn_popClose() {
      AUIGrid.clearGridData(supplementGridID);
      AUIGrid.clearGridData(supplementItmGridID);
      fn_getSupplementSubmissionList();
    $("#_systemClose").click();
  }

  function createSubItmDetailGrid() {
      var columnLayout = [ {
          dataField : "itemCode",
          headerText : "<spring:message code='log.head.itemcode'/>",
          width : '10%',
          editable : false,
          visible : false
      }, {
          dataField : "itemDesc",
          headerText : "<spring:message code='log.head.itemdescription'/>",
          width : '30%',
          editable : false
      }, {
          dataField : "quantity",
          headerText : "<spring:message code='pay.head.quantity'/>",
          width : '10%',
          editable : false
      }, {
          dataField : "ttlGoodCond",
          headerText : "<spring:message code='supplement.text.supplementTtlRtnGoodCondQty'/>",
          width : '25%',
          editable : true,
          dataType : "numeric"
      }, {
          dataField : "ttlDefectCond",
          headerText : "<spring:message code='supplement.text.supplementTtlRtnDefectCondQty'/>",
          width : '25%',
          editable : true,
          dataType : "numeric"
      }, {
          dataField : "ttlMiaCond",
          headerText : "<spring:message code='supplement.text.supplementTtlRtnMissCondQty'/>",
          width : '25%',
          editable : true,
          dataType : "numeric"
      } ];

      var rtnItmGridPros = {
          showFooter : true,
          usePaging : true,
          pageRowCount : 10,
          fixedColumnCount : 1,
          showStateColumn : true,
          displayTreeOpen : false,
          headerHeight : 30,
          useGroupingPanel : false,
          skipReadonlyColumns : true,
          wrapSelectionMove : true,
          showRowNumColumn : true
      };

      rtnItmDetailGridID = GridCommon.createAUIGrid("rtn_itm_detail_grid_wrap", columnLayout, "", rtnItmGridPros);
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
      <spring:message code="supplement.title.supplementCancellation" /> - <spring:message code="supplement.title.supplementUpdateRetQty" />
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
          <th scope="row"><spring:message code="supplement.text.supplementTtlGoodQty" /></th>
          <td colspan='3'>
            <input type="hidden" title="" class="w100p" name="ttlGoodQty" id="ttlGoodQty" value='${ttlGoodsQty.ttlQty}' />
            <span style="width:5%;text-align:center" >${ttlGoodsQty.ttlQty}</span> <span style="color:red;font-size:10px">Qty.</span>
          </td>
        </tr>
        <!-- <tr>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnGoodCondQty" /><span class="must">*</span></th>
          <td>
            <input type="text" title="" style="width:85%" name="rtnGoodCond" id="rtnGoodCond" value="0"/><span style="color:red;font-size:10px">Qty.</span>
          </td>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnDefectCondQty" /><span class="must">*</span></th>
          <td>
            <input type="text" title="" style="width:85%" name="rtnDefectCond" id="rtnDefectCond" value="0"/><span style="color:red;font-size:10px">Qty.</span>
          </td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnMissCondQty" /><span class="must">*</span></th>
          <td>
            <input type="text" title="" style="width:85%" name="rtnMissCond" id="rtnMissCond" value="0"/><span style="color:red;font-size:10px">Qty.</span>
          </td>
          <th scope="row"></th>
          <td>
          </td>
        </tr> -->
        </br>
      </tbody>
    </table>

    <aside class="title_line">
      <!-- <h3><spring:message code="sal.title.itmList" /></h3> -->
    </aside>
    <article class="tap_area">
      <article class="grid_wrap">
        <div id="rtn_itm_detail_grid_wrap" style="width: 100%; height: 200px; margin: 0 auto;"></div>
      </article>
    </article>

    <ul class="center_btns">
      <li><p class="btn_blue2">
          <a id="_saveBtn"><spring:message code="sal.btn.save" /></a>
        </p></li>
    </ul>
  </section>
</div>