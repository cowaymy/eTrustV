<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  //AUIGrid 생성 후 반환 ID
  var ordLedgerGridID;
  var agreGridID;
  var orderLdgrList;
  var agreList;

  $(document).ready(function() {
    if ('${orderLdgrList}' == '' || '${orderLdgrList}' == null) {
    } else {
      orderLdgrList = JSON.parse('${orderLdgrList}');
    }

    createAUIGrid();

    fn_maskingData('_addr1', '${orderInfo.addressLine1}');
    fn_maskingData('_addr2', '${orderInfo.addressLine2}');
    fn_maskingDataSmp('_mbNo', '${orderInfo.custMobileNo}');
    fn_maskingDataSmp('_resNo', '${orderInfo.custResidentNo}');
    fn_maskingDataSmp('_offNo', '${orderInfo.custOfficeNo}');
    fn_maskingDataSmp('_faxNo', '${orderInfo.custFaxNo}');
    fn_maskingDataSmp('_email', '${orderInfo.custEmail}');
  });

  function createAUIGrid() {
    var ordLedgerLayout = [ {
      dataField : "docdate",
      headerText : '<spring:message code="sys.label.date" />',
      width : "10%"
    }, {
      dataField : "doctype",
      headerText :  '<spring:message code="sal.title.type" />',
      width : "10%"
    }, {
      dataField : "docNo",
      headerText : '<spring:message code="sal.title.docNo" />',
      width : "10%"
    }, {
      dataField : "adjreason",
      headerText : '<spring:message code="sal.title.adjReason" />',
      width : "10%"
    }, {
      dataField : "payMode",
      headerText : '<spring:message code="sal.title.adjReason" />',
      width : "10%"
    }, {
      dataField : "refDt",
      headerText : '<spring:message code="sal.title.text.refDate" />',
      width : "10%"
    }, {
      dataField : "refNo",
      headerText : '<spring:message code="sal.title.text.refDate" />',
      width : "10%"
    }, {
      dataField : "accCode",
      headerText : '<spring:message code="pay.head.accountCode" />',
      width : "10%"
    }, {
      dataField : "debitamt",
      headerText : '<spring:message code="sal.title.debit" />',
      width : "10%",
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "creditamt",
      headerText : '<spring:message code="sal.title.credit" />',
      width : "10%",
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "balanceamt",
      headerText : '<spring:message code="sal.title.balance" />',
      width : "10%",
      dataType : "numeric",
      formatString : "#,##0.00"
    } ];

    var ordLedgerGridPros = {
      usePaging : false,
      pageRowCount : 10,
      editable : false,
      showStateColumn : false,
      showRowNumColumn : false,
      headerHeight : 30
    };

    ordLedgerGridID = GridCommon.createAUIGrid("ord_ledger_grid", ordLedgerLayout, "", ordLedgerGridPros);

    if (orderLdgrList != '') {
      AUIGrid.setGridData(ordLedgerGridID, orderLdgrList);
    }
  }

  function fn_report1() {
    //CURRENT DATE
    var date = new Date().getDate();
    var mon = new Date().getMonth() + 1;

    if (date.toString().length == 1) {
      date = "0" + date;
    }

    if (mon.toString().length == 1) {
      mon = "0" + mon;
    }

    var inputDate = dataForm.cutOffDate.value;

    if ($("#cutOffDate").val() == "") {
      $("#V_CUTOFFDATE").val('01/01/1900');
    } else {
      $("#V_CUTOFFDATE").val(
          '01/' + inputDate.substring(0, 2) + '/'
              + inputDate.substring(3, 7));
    }

    $("#reportDownFileName").val(
        $("#V_ORDERNO").val() + "_" + date + mon
            + new Date().getFullYear());

    var option = {
      isProcedure : true
    };

    Common.report("dataForm", option);
  }

  function fn_maskingData(ind, obj) {
    var maskedVal = (obj).substr(-10).padStart((obj).length, '*');
      $("#span" + ind).html(maskedVal);
      $("#span" + ind).hover(function() {
          $("#span" + ind).html(obj);
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
      $("#imgHover" + ind).hover(function() {
          $("#span" + ind).html(obj);
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
  }

  function fn_maskingDataSmp(ind, obj) {
    var maskedVal = (obj).substr(-4).padStart((obj).length, '*');
      $("#span" + ind).html(maskedVal);
      $("#span" + ind).hover(function() {
          $("#span" + ind).html(obj);
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
      $("#imgHover" + ind).hover(function() {
          $("#span" + ind).html(obj);
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
  }
</script>
<div id="popup_wrap" class="popup_wrap pop_win">
  <header class="pop_header">
    <h1><spring:message code="sal.btn.ledger" /></h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="#" onclick="window.close()"><spring:message code="sys.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <aside class="title_line">
      <!-- title_line start -->
      <h1>${orderInfo.custName}</h1>
    </aside>
    <br/>
    <form id="dataForm" name="dataForm">
      <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/OrderLedger.rpt" />
      <input type="hidden" id="viewType" name="viewType" value="PDF" />
      <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
      <input type="hidden" id="V_ORDERID" name="V_ORDERID" value="${orderInfo.ordId}" />
      <input type="hidden" id="V_ORDERNO" name="V_ORDERNO" value="${orderInfo.ordNo}" />
      <input type="hidden" id="V_PAYREFNO" name="V_PAYREFNO" value="${orderInfo.jomPayRef}" />
      <input type="hidden" id="V_CUSTTYPE" name="V_CUSTTYPE" value="${orderInfo.custType}" />
      <input type="hidden" id="V_CUTOFFDATE" name="V_CUTOFFDATE" />

      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
            <td colspan="5"><span>${orderInfo.supRefNo}</span></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="log.head.deliverydate" /></th>
            <td colspan="5"><span>${orderInfo.supRefDelDt}</span></td>
          </tr>
        </tbody>
      </table>
      </br>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
            <td colspan="5">
              <table>
                <tr>
                  <td width="95%"><span id='span_addr1'></span></td>
                  <td width="5">
                    <a href="#" class="search_btn" id="imgHover_addr1">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                    </a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.text.street" /></th>
            <td colspan="5">
              <table>
                <tr>
                  <td width="95%"><span id='span_addr2'></span></td>
                  <td width="5">
                    <a href="#" class="search_btn" id="imgHover_addr2">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                    </a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="service.title.Area" /></th>
            <td><span>${orderInfo.area}</span></td>
            <th scope="row"><spring:message code="sal.text.city" /></th>
            <td><span>${orderInfo.city}</span></td>
            <th scope="row"><spring:message code="sys.title.postcode" /></th>
            <td><span>${orderInfo.postcode}</span></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="service.title.State" /></th>
            <td><span>${orderInfo.state}</span></td>
            <th scope="row"><spring:message code="sys.country" /></th>
            <td><span>${orderInfo.country}</span></td>
            <th></th>
            <td></td>
          </tr>
        </tbody>
      </table>
      </br>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="sales.MobileNo" /></th>
            <td>
              <table>
                <tr>
                  <td width="90%"><span id='span_mbNo'></span></td>
                  <td width="10%">
                    <a href="#" class="search_btn" id="imgHover_mbNo">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                    </a>
                  </td>
                </tr>
              </table>
            </td>
            <th scope="row"><spring:message code="supplement.title.text.ResidentNo" /></th>
            <td>
              <table>
                <tr>
                  <td width="90%"><span id='span_resNo'></span></td>
                  <td width="10%">
                    <a href="#" class="search_btn" id="imgHover_resNo">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                    </a>
                  </td>
                </tr>
              </table>
            </td>
            <th scope="row"><spring:message code="sales.OfficeNo" /></th>
            <td>
              <table>
                <tr>
                  <td width="90%"><span id='span_offNo'></span></td>
                  <td width="10%">
                    <a href="#" class="search_btn" id="imgHover_offNo">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                    </a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="service.title.FaxNo" /></th>
            <td>
              <table>
                <tr>
                  <td width="90%"><span id='span_faxNo'></span></td>
                  <td width="10%">
                    <a href="#" class="search_btn" id="imgHover_faxNo">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                    </a>
                  </td>
                </tr>
              </table>
            </td>
            <th scope="row"><spring:message code="sal.text.email" /></th>
            <td>
              <table>
                <tr>
                  <td width="90%"><span id='span_email'></span></td>
                  <td width="10%">
                    <a href="#" class="search_btn" id="imgHover_email">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                    </a>
                  </td>
                </tr>
              </table>
            </td>
            <th></th>
            <td></td>
          </tr>
        </tbody>
      </table>
      </br>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="sal.title.text.totOutstanding" /></th>
            <td><span>${ordOutInfo.ordTotOtstnd}</span></td>
            <th scope="row"><spring:message code="sal.title.text.outstandingMonth" /></th>
            <td><span>${ordOutInfo.ordOtstndMth}</span></td>
            <th scope="row"><spring:message code="sal.title.text.unbillAmt" /></th>
            <td><span>${ordOutInfo.ordUnbillAmt}</span></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.title.text.penaltyCharges" /></th>
            <td><span>${ordOutInfo.ordTotOtstnd}</span></td>
            <th scope="row"><spring:message code="sal.title.text.penaltyPaid" /></th>
            <td><span>${ordOutInfo.ordOtstndMth}</span></td>
            <th scope="row"><spring:message code="sal.title.text.penaltyAdjmt" /></th>
            <td><span>${ordOutInfo.ordUnbillAmt}</span></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.text.balancePenalty" /></th>
            <td><span>${ordOutInfo.totPnaltyChrg}</span></td>
            <th></th>
            <td></td>
            <th></th>
            <td></td>
          </tr>
        </tbody>
      </table>
      <ul class="right_btns mt20">
        <li><p><spring:message code="sal.text.transactionDate" /></p></li>
        <li><input type="text" id="cutOffDate" name="cutOffDate" class="j_date2" /></li>
        <li><p class="btn_blue">
            <a href="#" onclick="fn_report1()"><spring:message code="sys.progmanagement.grid1.PRINT" /></a>
          </p></li>
      </ul>
    </form>
    <article class="grid_wrap">
      <div id="ord_ledger_grid" style="width: 100%; height: 230px; margin: 0 auto;"></div>
    </article>
  </section>
</div>

