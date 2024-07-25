<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
  .aui-grid-user-custom-left {
    text-align: left;
  }

  .aui-grid-user-custom-right {
    text-align: right;
  }
</style>

<script type="text/javascript">
  var confirmGridID;
  var detId = 0;
  var confirmColumnLayout = [ { dataField : "detId",
                                              visible : false
                                            }, {
                                              dataField : "validStusId",
                                              headerText : "<spring:message code='supplement.head.validStatus'/>"
                                            }, {
                                              dataField : "validRem",
                                              headerText : "<spring:message code='supplement.head.validRemark'/>",
                                              style : "aui-grid-user-custom-left"
                                            }, {
                                              dataField : "salesOrdNo",
                                              headerText : "<spring:message code='supplement.head.orderNo'/>"
                                            }, {
                                              dataField : "worNo",
                                              headerText : "<spring:message code='supplement.head.worNo'/>"
                                            }, {
                                              dataField : "amt",
                                              headerText : "<spring:message code='supplement.head.amount'/>",
                                              style : "aui-grid-user-custom-right",
                                              dataType : "numeric",
                                              formatString : "#,##0.00"
                                            }, {
                                              dataField : "bankAcc",
                                              headerText : "<spring:message code='supplement.head.bankAcc'/>",
                                              style : "aui-grid-user-custom-left"
                                            }, {
                                              dataField : "refNo",
                                              headerText : "<spring:message code='supplement.head.refNo'/>"
                                            }, {
                                              dataField : "chqNo",
                                              headerText : "<spring:message code='supplement.head.chqNo'/>"
                                            }, {
                                              dataField : "name",
                                              headerText : "<spring:message code='supplement.head.issueBank'/>",
                                              style : "aui-grid-user-custom-left"
                                            }, {
                                              dataField : "refDtMonth",
                                              headerText : "<spring:message code='supplement.head.refDateMonth'/>"
                                            }, {
                                              dataField : "refDtDay",
                                              headerText : "<spring:message code='supplement.head.refDateDay'/>"
                                            }, {
                                              dataField : "refDtYear",
                                              headerText : "<spring:message code='supplement.head.refDateYear'/>"
                                            } ];

  var confirmGridPros = { usePaging : true,
                                    pageRowCount : 20,
                                    headerHeight : 40,
                                    height : 240,
                                    enableFilter : true,
                                    selectionMode : "multipleCells"
  };

  $(document).ready(
    function() {
      confirmGridID = AUIGrid.create("#bRefund_confirm_grid_wrap", confirmColumnLayout, confirmGridPros);

      $("#close_btn").click(fn_closePop);
      $("#allItem_btn").click(function() {
        setFilterByValues(0);
      });
      $("#validItem_btn").click(function() {
        setFilterByValues(4);
      });
      $("#invalidItem_btn").click(function() {
        setFilterByValues(21);
      });

      $("#deactivate_btn").click(fn_deactivate);
      $("#pConfirm_btn").click(fn_confirm);
      $("#remove_btn").click(fn_bRefundItemDisab);

      var str = "" + Number('${bRefundInfo.totalValidAmt}').toFixed(2);

      var str2 = str.split(".");

      if (str2.length == 1) {
        str2[1] = "00";
      }

      str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "." + str2[1];

      $("#totAmt").text(str);

      AUIGrid.setGridData(confirmGridID, $.parseJSON('${bRefundItem}'));

      AUIGrid.bind(confirmGridID, "cellClick", function(event) {
        // TODO pettyCash Expense Info GET
        detId = event.item.detId;
      });

      $("#refundInfo").trigger("click");
  });

  function fn_closePop() {
    $("#bRefundConfirmPop").remove();
  }

  function setFilterByValues(validStusId) {
    // 4 : valid, 21 : invalid
    if (validStusId == 4) {
      AUIGrid.setFilterByValues(confirmGridID, "validStusId", [ 4 ]);
    } else if (validStusId == 21) {
      AUIGrid.setFilterByValues(confirmGridID, "validStusId", [ 21 ]);
    } else {
      AUIGrid.clearFilterAll(confirmGridID);
    }
  }

  function fn_deactivate() {
    Common.confirm("<spring:message code='supplement.alert.deactivateRefundBatch'/>",
      function() {
        Common.ajax("GET", "/supplement/payment/batchRefundDeactivate.do", $("#form_bRefundConfirm").serialize(), function(result) {
          Common.alert(result.message);
          fn_closePop();
          fn_selectBatchRefundList();
        });
      });
  }

  function fn_confirm() {
    Common.confirm("<spring:message code='supplement.alert.confRefundBatch'/>",
      function() {
        if (Number($("#totInvalidCount").text()) > 0) {
          Common.alert('<spring:message code="supplement.alert.invalidItemExist"/>');
        } else {
           if (Number($("#totValidCount").text()) > 0) {
             Common.ajax("GET", "/supplement/payment/batchRefundConfirm.do", $("#form_bRefundConfirm").serialize(),
               function(result) {
                 Common.alert(result.message);
                 fn_closePop();
                 fn_selectBatchRefundList();
             });
           } else {
             Common.alert('<spring:message code="supplement.alert.noValidItem"/>');
           }
         }
     });
  }

  function fn_bRefundItemDisab() {
    if (detId > 0) {
      Common.ajax("GET", "/supplement/payment/batchRefundItemDisab.do", { detId : detId, batchId : $("#pBatchId").val() },
      function(result) {
        Common.alert(result.message);

        $("#tBatchId").text(result.data.batchId);
        $("#tBatchStus").text(result.data.name);
        $("#tCnfmStus").text(result.data.name1);
        $("#tPayMode").text(result.data.codeName);
        $("#tUploadBy").text(result.data.username1);
        $("#tUploadAt").text(result.data.updDt);
        $("#tCnfmBy").text(result.data.c1);
        $("#tCnfmAt").text(result.data.cnfmDt);
        $("#tCnvtBy").text(result.data.c2);
        $("#tCnvtAt").text(result.data.cnvrDt);
        var totAmt = result.data.totalValidAmt;
        var str = "" + totAmt.toFixed(2);
        var str2 = str.split(".");

        if (str2.length == 1) {
          str2[1] = "00";
        }

        str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "." + str2[1];
        $("#totAmt").text(str);
        $("#totItemCount").text(result.data.totalItem);
        $("#totValidCount").text(result.data.totalValid);
        $("#totInvalidCount").text(result.data.totalInvalid);

        if (result.data.bRefundItem) {
          AUIGrid.setGridData(confirmGridID, result.data.bRefundItem);
        }

        detId = 0;
      });
    } else {
      Common.alert("<spring:message code='supplement.alert.noItem'/>");
    }
  }
</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1>
      <spring:message code='supplement.title.batchRefundConfirmation' />
    </h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="#" id="close_btn"><spring:message code='sys.btn.close' /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <section class="tap_wrap">
      <ul class="tap_type1">
        <li>
          <a href="#" class="on" id="refundInfo"><spring:message code='supplement.text.generalInfo' /></a>
        </li>
        <li>
          <a href="#"><spring:message code='supplement.text.batRfndDtlLst' /></a>
        </li>
      </ul>
      <article class="tap_area">
        <form action="#" id="form_bRefundConfirm">
          <input type="hidden" id="pBatchId" name="batchId" value="${bRefundInfo.batchId}">
          <table class="type1">
            <caption>table</caption>
            <colgroup>
              <col style="width: 140px" />
              <col style="width: *" />
              <col style="width: 130px" />
              <col style="width: *" />
              <col style="width: 170px" />
              <col style="width: *" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row"><spring:message code='supplement.head.batchId' /></th>
                <td id="tBatchId">${bRefundInfo.batchId}</td>
                <th scope="row"><spring:message code='supplement.head.batchStatus' /></th>
                <td id="tBatchStus">${bRefundInfo.name}</td>
                <th scope="row"><spring:message code='supplement.head.confirmStatus' /></th>
                <td id="tCnfmStus">${bRefundInfo.name1}</td>
              </tr>
              <tr>
                <th scope="row"><spring:message code='supplement.head.paymode' /></th>
                <td id="tPayMode">${bRefundInfo.codeName}</td>
                <th scope="row"><spring:message code='supplement.head.uploadBy' /></th>
                <td id="tUploadBy">${bRefundInfo.username1}</td>
                <th scope="row"><spring:message code='supplement.head.uploadAt' /></th>
                <td id="tUploadAt">${bRefundInfo.updDt}</td>
              </tr>
              <tr>
                <th scope="row"><spring:message code='supplement.head.confirmBy' /></th>
                <td id="tCnfmBy">${bRefundInfo.c1}</td>
                <th scope="row"><spring:message code='supplement.head.confirmAt' /></th>
                <td id="tCnfmAt">${bRefundInfo.cnfmDt}</td>
                <th scope="row"></th>
                <td></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code='supplement.head.convertBy' /></th>
                <td id="tCnvtBy">${bRefundInfo.c2}</td>
                <th scope="row"><spring:message code='supplement.head.convertAt' /></th>
                <td id="tCnvtAt">${bRefundInfo.cnvrDt}</td>
                <th scope="row"><spring:message code='supplement.head.totAmtValid' /></th>
                <td id="totAmt"></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code='supplement.head.totItm' /></th>
                <td id="totItemCount">${bRefundInfo.totalItem}</td>
                <th scope="row"><spring:message code='supplement.head.totValid' /></th>
                <td id="totValidCount">${bRefundInfo.totalValid}</td>
                <th scope="row"><spring:message code='supplement.head.totInvalid' /></th>
                <td id="totInvalidCount">${bRefundInfo.totalInvalid}</td>
              </tr>
            </tbody>
          </table>
        </form>
      </article>
      <article class="tap_area">
        <aside class="title_line">
          <ul class="right_btns">
            <c:if test="${bRefundInfo.batchStusId ne 4 && bRefundInfo.cnfmStusId ne 77}">
              <li>
                <p class="btn_grid">
                  <a href="#" id="remove_btn"><spring:message code='supplement.btn.remove' /></a>
                </p>
              </li>
            </c:if>
            <li>
              <p class="btn_grid">
                <a href="#" id="allItem_btn"><spring:message code='supplement.btn.allItems' /></a>
              </p>
            </li>
            <li>
              <p class="btn_grid">
                <a href="#" id="validItem_btn"><spring:message code='supplement.btn.validItems' /></a>
              </p>
            </li>
            <li>
              <p class="btn_grid">
                <a href="#" id="invalidItem_btn"><spring:message code='supplement.btn.invalidItems' /></a>
              </p>
            </li>
          </ul>
        </aside>
        <section class="search_result">
          <article class="grid_wrap">
            <div id="bRefund_confirm_grid_wrap"
              style="width: 100%; margin: 0 auto;"></div>
          </article>
        </section>
      </article>
      <br />
      <c:if test="${bRefundInfo.batchStusId ne 4 && bRefundInfo.cnfmStusId ne 77}">
        <ul class="center_btns">
          <li>
            <p class="btn_blue2 big">
              <a href="#" id="pConfirm_btn"><spring:message code='supplement.btn.confirm' /></a>
            </p>
          </li>
          <li>
            <p class="btn_blue2 big">
              <a href="#" id="deactivate_btn"><spring:message code='supplement.btn.deactivate' /></a>
            </p>
          </li>
        </ul>
      </c:if>
    </section>
  </section>
</div>
