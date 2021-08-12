<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
  text-align: left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
  text-align: right;
}
</style>

<script type="text/javascript">
  var gridDataLength = 0;
  var myGridID;
  var myExcelID;
  var refundColumnLayout = [ { dataField : "mobTicketNo",
                                             width : 80,
                                             headerText : "<spring:message code='pay.title.ticketNo'/>"
                                           }, {
                                             dataField : "reqDt",
                                             width : 100,
                                             headerText : "<spring:message code='pay.head.requestDate'/>"
                                           }, {
                                             dataField : "ticketStusNm",
                                             width : 100,
                                             headerText : "<spring:message code='pay.head.Status'/>",
                                             style : "aui-grid-user-custom-left"
                                           }, {
                                             dataField : "curOrdNo",
                                             width : 140,
                                             headerText : "<spring:message code='pay.head.curOrdNo'/>"
                                           }, {
                                             dataField : "curCustId",
                                             width : 140,
                                             headerText : "<spring:message code='pay.head.curCustID'/>"
                                           }, {
                                             dataField : "curCustName",
                                             width : 200,
                                             headerText : "<spring:message code='pay.head.curCustName'/>",
                                             style : "aui-grid-user-custom-left"
                                           }, {
                                             dataField : "curWorNo",
                                             width : 120,
                                             headerText : "<spring:message code='pay.head.worNo'/>"
                                           }, {
                                             dataField : "curAmt",
                                             width : 100,
                                             headerText : "<spring:message code='pay.head.amount'/>",
                                             dataType : "numeric",
                                             style : "aui-grid-user-custom-right",
                                             formatString : "#,##0.00"
                                           }, {
                                             dataField : "newOrdNo",
                                             width : 140,
                                             headerText : "<spring:message code='pay.head.newOrdNo'/>"
                                           }, {
                                             dataField : "newCustId",
                                             width : 140,
                                             headerText : "<spring:message code='pay.head.newCusoomerID'/>"
                                           }, {
                                             dataField : "newCustName",
                                             width : 200,
                                             headerText : "<spring:message code='pay.head.newCusoomerName'/>",
                                             style : "aui-grid-user-custom-left"
                                           }, {
                                             dataField : "ftResnName",
                                             width : 140,
                                             headerText : "<spring:message code='pay.head.reason'/>",
                                             style : "aui-grid-user-custom-left"
                                           }, {
                                             dataField : "ftAttchImgUrl",
                                             cellMerge : true,
                                             mergeRef : "mobTicketNo",
                                             mergePolicy : "restrict",
                                             width : 100,
                                             headerText : "<spring:message code='pay.head.pOAttach'/>",
                                             renderer : {
                                               type : "ImageRenderer",
                                               width : 20,
                                               height : 20,
                                               imgTableRef : {
                                                 "DOWN" : "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
                                               }
                                             }
                                           }, {
                                             dataField : "ftRem",
                                             width : 100,
                                             headerText : "<spring:message code='pay.head.remark'/>",
                                             style : "aui-grid-user-custom-left"
                                           }, {
                                             dataField : "brnchCode",
                                             width : 100,
                                             headerText : "<spring:message code='log.head.branchcode'/>"
                                           }, {
                                             dataField : "memCode",
                                             width : 100,
                                             headerText : "<spring:message code='pay.head.memberCode'/>"
                                           }, {
                                             dataField : "updDt",
                                             width : 160,
                                             headerText : "<spring:message code='pay.head.updateDate'/>"
                                           }, {
                                             dataField : "updUserId",
                                             width : 140,
                                             headerText : "<spring:message code='pay.head.updateUser'/>",
                                             style : "aui-grid-user-custom-left"
                                           }, {
                                             dataField : "ftReqId",
                                             visible : false
                                           }, {
                                             dataField : "ftStusId",
                                             visible : false
                                           }, {
                                             dataField : "ticketStusId",
                                             visible : false
                                           }, {
                                             dataField : "newAmt",
                                             visible : false
                                           }, {
                                             dataField : "ftResn",
                                             visible : false
                                           }, {
                                             dataField : "refAttchImg",
                                             visible : false
                                           }, {
                                             dataField : "atchFileName",
                                             visible : false
                                           }, {
                                             dataField : "physiclFileName",
                                             visible : false
                                    } ];

  $(document).ready(
    function() {
      fn_setToDay();

      CommonCombo.make("ticketStusId", "/payment/requestFundTransfer/selectTicketStatusCode.do", null, "", { id : "code",
                                                                                                                                                           name : "codeName",
                                                                                                                                                           type : "S"
                                                                                                                                                         });

      var refundGridPros = {
        selectionMode : "singleRow"//셀 선택모드를 지정합니다. 유효 속성값은 다음과 같습니다.
      };

      myGridID = AUIGrid.create("#grid_wrap", refundColumnLayout, refundGridPros); //List
      myExcelID = AUIGrid.create("#grid_excel_wrap", refundColumnLayout, refundGridPros); //Excel

      AUIGrid.bind(myGridID, "pageChange", function(event) {
        fn_searchPage(event.currentPage);
      });

      AUIGrid.bind(myGridID, "cellClick", function(event) {
        if (event.dataField == "ftAttchImgUrl") {
          if (FormUtil.isEmpty(event.value) == false) {
            var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
            if (FormUtil.isEmpty(rowVal.atchFileName) == false && FormUtil.isEmpty(rowVal.physiclFileName) == false) {
              window.open("/file/fileDownWasMobile.do?subPath="
                                    + rowVal.fileSubPath
                                    + "&fileName="
                                    + rowVal.physiclFileName
                                    + "&orignlFileNm="
                                    + rowVal.atchFileName);
            }
          }
        }
      });
    });

  function fn_setToDay() {
    var today = new Date();

    today.setMonth(today.getMonth() - 1);
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();

    if (dd < 10) {
      dd = "0" + dd;
    }
    if (mm < 10) {
      mm = "0" + mm;
    }
    var fromReqDt = dd + "/" + mm + "/" + yyyy;
    $("#fromReqDt").val(fromReqDt);

    today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    if (dd < 10) {
      dd = "0" + dd;
    }
    if (mm < 10) {
      mm = "0" + mm;
    }
    var toReqDt = dd + "/" + mm + "/" + yyyy;
    $("#toReqDt").val(toReqDt);
  }

  function fn_search() {
    fn_searchPage(1);
  }

  function fn_searchPage(pageNo) {
    Common.ajax("POST", "/payment/requestFundTransfer/selectRequestFundTransferList.do", $.extend($("#searchForm").serializeObject(), {
      "pageNo" : pageNo,
      "pageSize" : 20,
      "gu" : "LIST"
    }), function(result) {
      GridCommon.createExtPagingNavigator(pageNo,
                                                             result.total, { funcName : 'fn_searchPage' });
      AUIGrid.setGridData(myGridID, result.dataList);
    });
  }

  function fn_clear() {
    $("#searchForm").each(function() {
      this.reset();
    });
    fn_setToDay();
  }

  function fn_excel() {
    Common.ajax("POST", "/payment/requestFundTransfer/selectRequestFundTransferList.do", $.extend($("#searchForm").serializeObject(), { "gu" : "EXCEL" }), function(result) {
      AUIGrid.setGridData(myExcelID, result.dataList);
      GridCommon.exportTo("#grid_excel_wrap", 'xlsx', 'Request Fund Transfer');
    })
  }

  function fn_approve() {
    var indexArr = AUIGrid.getSelectedIndex(myGridID);
    if (indexArr[0] == -1) {
      Common.alert("<spring:message code='pay.check.noRowsSelected'/>");
    } else {
      var ticketStusId = AUIGrid.getCellValue(myGridID, indexArr[0], "ticketStusId");
      if (ticketStusId != 1) {
        Common.alert("<spring:message code='pay.check.ticketStusId'/>");
      } else {
        var selectedItems = AUIGrid.getSelectedItems(myGridID);
        Common.ajax("POST", "/payment/requestFundTransfer/selectOutstandingAmount.do", { "ftReqId" : selectedItems[0].item.ftReqId },
        function(result) {
          var selectedItems = AUIGrid.getSelectedItems(myGridID);
          var popCurAmt = Number(selectedItems[0].item.curAmt);
          var outAmt = Number(result.data[0].outstandingAmt);

          var popAdvanceAmount = popCurAmt + outAmt;
          if (popAdvanceAmount <= 0) {
            popAdvanceAmount = 0;
            $("#popAdvanceMonth").addClass("disabled");
            $("#popAdvanceMonth").attr("disabled", "disabled");
          } else {
            popAdvanceAmount = $.number(popAdvanceAmount, 2);
            $("#popAdvanceMonth").removeClass("disabled");
            $("#popAdvanceMonth").removeAttr("disabled");
          }

           $("#popNewOrdNo").val(selectedItems[0].item.newOrdNo);
           $("#popNewPaymentType").val(result.data[0].ledgerType);
           $("#popCurAmt").val($.number(popCurAmt, 2));
           $("#popOutAmt").val($.number(outAmt, 2));
           $("#popAdvanceAmount").val(popAdvanceAmount);
           $("#editWindow").show();
         });
      }
    }
  }

  function saveApproveFundTransfer() {
    Common.confirm("<spring:message code='pay.confirm.approve'/>",
    function() {
      var selectedItems = AUIGrid.getSelectedItems(myGridID);
      var saveData = new Object();
      saveData.ftReqId = selectedItems[0].item.ftReqId;
      saveData.newOrdOutAmt = $("#popOutAmt").val();
      saveData.advAmt = $("#popAdvanceAmount").val();
      saveData.advMonth = $("#popAdvanceMonth").val();
      saveData.mobTicketNo = selectedItems[0].item.mobTicketNo;
      /* var saveData = { ftReqId : selectedItems[0].item.ftReqId, newOrdOutAmt : $("#popOutAmt").val(), advAmt : $("#popAdvanceAmount").val(), advMonth : $("#popAdvanceMonth").val()} */
      Common.ajaxSync("POST", "/payment/requestFundTransfer/saveRequestFundTransferArrpove.do", saveData,
      function(result) {
        if (result != "" && null != result) {
          Common.alert("<spring:message code='pay.alert.approve'/>",
            function() { $("#editWindow").hide();
                             fn_search(1);
                            });
          }
      });
    });
  }

  function fn_rejcet() {
    var indexArr = AUIGrid.getSelectedIndex(myGridID);
    if (indexArr[0] == -1) {
      Common.alert("<spring:message code='pay.check.noRowsSelected'/>");
    } else {
      var ticketStusId = AUIGrid.getCellValue(myGridID, indexArr[0], "ticketStusId");
      if (ticketStusId != 1) {
        Common.alert("<spring:message code='pay.check.ticketStusId'/>");
      } else {
        Common.prompt("<spring:message code='pay.prompt.reject'/>", "",
        function() {
          if (FormUtil.isEmpty($("#promptText").val())) {
            Common.alert("<spring:message code='pay.check.rejectReason'/>");
          } else {
            var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;
            rejectData.ftRem = $("#promptText").val();
            Common.ajaxSync("POST", "/payment/requestFundTransfer/saveRequestFundTransferReject.do", rejectData,
            function(result) {
              if (result != ""  && null != result) {
                Common.alert("<spring:message code='pay.alert.reject'/>", function() { fn_search(1); });
              }
            });
          }
        });
      }
    }
  }
</script>

<section id="content">
  <ul class="path">
    <li><img
      src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
      alt="Home" /></li>
  </ul>

  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on"><spring:message
          code='pay.text.myMenu' /></a>
    </p>
    <h2>Request Fund Transfer</h2>
    <ul class="right_btns">
      <li>
        <p class="btn_blue">
          <a href="#" onclick="javascript:fn_search()"> <span
            class="search"></span> <spring:message code='sys.btn.search' />
          </a>
        </p>
      </li>
      <li>
        <p class="btn_blue">
          <a href="#" onclick="javascript:fn_clear()"> <span
            class="clear"></span> <spring:message code='sys.btn.clear' />
          </a>
        </p>
      </li>
    </ul>
  </aside>

  <section class="search_table">
    <form id="searchForm" method="post" onsubmit="return false;">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 180px" />
          <col style="width: *" />
          <col style="width: 180px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <!--[1.Start]  -->
          <tr>
            <th scope="row">Ticket No.</th>
            <td><input type="text" title="Ticket No."
              placeholder="Ticket No." class="w100p" id="mobTicketNo"
              name="mobTicketNo" /></td>

            <th scope="row">Ticket Request Date</th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input type="text" title="Ticket Request Date"
                    placeholder="DD/MM/YYYY" class="j_date" id="fromReqDt"
                    name="fromReqDt" />
                </p>
                <span>To</span>
                <p>
                  <input type="text" title="Ticket Request Date"
                    placeholder="DD/MM/YYYY" class="j_date" id="toReqDt"
                    name="toReqDt" />
                </p>
              </div>
            </td>
          </tr>
          <!--[1.End]  -->
          <!--[2.Start]  -->
          <tr>
            <th scope="row">Order No.</th>
            <td><input type="text" title="Order No."
              placeholder="Order No." class="w100p" id="curOrdNo"
              name="curOrdNo" /></td>

            <th scope="row">Ticket Status</th>
            <td><select class="w100p" id="ticketStusId"
              name="ticketStusId"></select></td>
          </tr>
          <!--[2.End]  -->
          <!--[3.Start]  -->
          <tr>
            <th scope="row">Branch Code</th>
            <td><input type="text" title="Branch Code"
              placeholder="Branch Code" class="w100p" id="brnchCode"
              name="brnchCode" /></td>

            <th scope="row">Member Code</th>
            <td><input type="text" title="Member Code"
              placeholder="Member Code" class="w100p" id="memCode"
              name="memCode" /></td>
          </tr>
          <!--[3.End]  -->
        </tbody>
      </table>
    </form>
  </section>

  <ul class="right_btns">
    <li>
      <p class="btn_grid">
        <a href="#" onclick="javascript:fn_excel()"> <spring:message
            code='pay.btn.exceldw' />
        </a>
      </p>
    </li>
    <li>
      <p class="btn_grid">
        <a href="#" onclick="javascript:fn_approve()"> <spring:message
            code='pay.btn.approve' />
        </a>
      </p>
    </li>
    <li>
      <p class="btn_grid">
        <a href="#" onclick="javascript:fn_rejcet()"> <spring:message
            code='budget.Reject' />
        </a>
      </p>
    </li>
  </ul>

  <section class="grid_wrap">
    <article class="grid_wrap">
      <div class="autoGridHeight" style="width: 100%; margin: 0 auto;"
        id="grid_wrap"></div>
    </article>
    <article class="grid_wrap" id="grid_excel_wrap" style="display: none;"></article>
  </section>

  <!--[START_POPUP] ▣ Approve Fund Transfer -->
  <div id="editWindow" class="popup_wrap" style="display: none;">
    <header class="pop_header">
      <h1>Approve Fund Transfer</h1>
      <ul class="right_opt">
        <li>
          <p class="btn_blue2">
            <a href="#"><spring:message code='sys.btn.close' /></a>
          </p>
        </li>
      </ul>
    </header>
    <section class="pop_body">
      <form id="fromApproveFundTransfer" action="#" method="post">
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 140px" />
            <col style="width: 180px" />
            <col style="width: 180px" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row">Order No (New)<span class="must">*</span></th>
              <td colspan="2"><input type="text" id="popNewOrdNo"
                name="popNewOrdNo" class="w100p readonly" readonly="readonly" />
              </td>
            </tr>
            <tr>
              <th scope="row">Payment Type<span class="must">*</span></th>
              <td colspan="2"><input type="text" id="popNewPaymentType"
                name="popNewPaymentType" class="w100p readonly"
                readonly="readonly" /></td>
            </tr>
            <tr>
              <th scope="row">Transfer Amount<span class="must">*</span></th>
              <td colspan="2"><input type="text" id="popCurAmt"
                name="popCurAmt" class="w100p readonly" readonly="readonly" /></td>
            </tr>
            <tr>
              <th scope="row">Outstanding Amount<span class="must">*</span></th>
              <td colspan="2"><input type="text" id="popOutAmt"
                name="popOutAmt" class="w100p readonly" readonly="readonly" /></td>
            </tr>
            <tr>
              <th scope="row">Advance Amount & Month<span class="must">*</span></th>
              <td><input type="text" id="popAdvanceAmount"
                name="popAdvanceAmount" class="w100p readonly"
                readonly="readonly" /></td>
              <td><select id="popAdvanceMonth" name="popAdvanceMonth"
                class="w100p disabled" disabled="disabled">
                  <c:forEach var="i" begin="0" end="24" step="1">
                    <option value="${i}">${i}</option>
                  </c:forEach>
              </select></td>
            </tr>
          </tbody>
        </table>
      </form>
      <ul class="center_btns">
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
          <li>
            <p class="btn_blue2 big">
              <a id="cardSave" href="javascript:saveApproveFundTransfer();"><spring:message
                  code='sys.btn.save' /></a>
            </p>
          </li>
        </c:if>
      </ul>
    </section>
  </div>
  <!--[END_POPUP] ▣ Approve Fund Transfer -->
</section>