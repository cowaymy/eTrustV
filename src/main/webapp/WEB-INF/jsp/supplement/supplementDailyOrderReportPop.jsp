<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  var orderGridID;
  var excelListGridID;

  $(document).ready(function() {
    createAUIGrid();
    createExcelAUIGrid();
  });

  $(function() {
    $('#btnExcelDown').click(
      function() {
        var excelProps = { fileName : "Daily Order Report",
                                   exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
        };
        AUIGrid.exportToXlsx(excelListGridID, excelProps);
    });

    $('#_btnDailyOrderReportSearch').click(function() {
      if (FormUtil.isEmpty($('#paymentStartDt').val()) && FormUtil.isEmpty($('#paymentEndDt').val())) {
        var label = '<spring:message code="sal.title.payDate" />';
        Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ label + "' htmlEscape='false'/>");
        return;
      }

      if ((!FormUtil.isEmpty($('#paymentStartDt').val()) && FormUtil.isEmpty($('#paymentEndDt').val()))
           || (FormUtil.isEmpty($('#paymentStartDt').val()) && !FormUtil.isEmpty($('#paymentEndDt').val()))) {
        var label = '<spring:message code="sal.title.payDate" />';
        Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ label + "' htmlEscape='false'/>");
        return;
      } else {
        var sDate = $('#paymentStartDt').val();
        var eDate = $('#paymentEndDt').val();

        var dd = "";
        var mm = "";
        var yyyy = "";

        var dateArr;
        dateArr = sDate.split("/");
        var sDt = new Date(Number(dateArr[2]), Number(dateArr[1]) - 1, Number(dateArr[0]));

        dateArr = eDate.split("/");
        var eDt = new Date(Number(dateArr[2]), Number(dateArr[1]) - 1, Number(dateArr[0]));

        var dtDiff = new Date(eDt - sDt);
        var days = dtDiff / 1000 / 60 / 60 / 24;

        if (days > 31) {
          Common.alert("Payment Date range cannot be greater than 31 days.");
          return false;
        } else {
          fn_getSupplementDailyOrderReportList();
        }
      }
    });
  });

  function createAUIGrid() {
    var orderColumnLayout = [ {
      dataField : "supRefNo",
      headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
      width : '20%'
    }, {
      dataField : "stkDesc",
      headerText : '<spring:message code="log.head.item" />' + "(s)",
      width : '15%'
    }, {
      dataField : "stkCde",
      headerText : '<spring:message code="sal.title.productCode" />',
      width : '15%'
    }, {
      dataField : "supRefStus",
      headerText : '<spring:message code="supplement.text.supplementReferenceStatus" />',
      width : '20%'
    }, {
      dataField : "supRefStg",
      headerText : '<spring:message code="supplement.text.supplementReferenceStage" />',
      width : '15%'
    }, {
      dataField : "custName",
      headerText : '<spring:message code="sal.title.custName" />',
      width : '15%'
    }, {
      dataField : "supRefDt",
      headerText : '<spring:message code="sal.text.createDate" />',
      width : '18%'
    }, {
      dataField : "payDt",
      headerText : '<spring:message code="sal.title.payDate" />',
      width : '15%'
    }, {
      dataField : "orNo",
      headerText : 'Offical Receipt No',
      width : '15%'
    }, {
      dataField : "supItmQty",
      headerText : '<spring:message code="sal.text.quantity" />',
      width : '15%'
    }, {
      dataField : "addrDtl",
      headerText : '<spring:message code="sal.text.addressDetail" />',
      width : '15%'
    }, {
      dataField : "street",
      headerText : '<spring:message code="sal.text.street" />',
      width : '15%'
    }, {
      dataField : "city",
      headerText : '<spring:message code="sal.text.city" />',
      width : '15%'
    }, {
      dataField : "state",
      headerText : '<spring:message code="sal.title.state" />',
      width : '15%'
    }, {
      dataField : "postcode",
      headerText : '<spring:message code="sys.title.post.code" />',
      width : '15%'
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      fixedColumnCount : 3,
      showStateColumn : true,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : false
    };

    orderGridID = GridCommon.createAUIGrid("#dailyOrderReport_wrap", orderColumnLayout, '', gridPros);
  }

  function createExcelAUIGrid() {
    var excelColumnLayout = [ {
      dataField : "supRefNo",
      headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
    }, {
      dataField : "stkDesc",
      headerText : '<spring:message code="log.head.item" />' + "(s)",
    }, {
      dataField : "stkCde",
      headerText : '<spring:message code="sal.title.productCode" />',
    }, {
      dataField : "supRefStus",
      headerText : '<spring:message code="supplement.text.supplementReferenceStatus" />',
    }, {
      dataField : "supRefStg",
      headerText : '<spring:message code="supplement.text.supplementReferenceStage" />',
    }, {
      dataField : "custName",
      headerText : '<spring:message code="sal.title.custName" />',
    }, {
      dataField : "supRefDt",
      headerText : '<spring:message code="sal.text.createDate" />',
    }, {
      dataField : "payDt",
      headerText : '<spring:message code="sal.title.payDate" />',
    }, {
      dataField : "orNo",
      headerText : 'Offical Receipt No'
    }, {
      dataField : "supItmQty",
      headerText : '<spring:message code="sal.text.quantity" />',
    }, {
      dataField : "addrDtl",
      headerText : '<spring:message code="sal.text.addressDetail" />',
    }, {
      dataField : "street",
      headerText : '<spring:message code="sal.text.street" />',
    }, {
      dataField : "city",
      headerText : '<spring:message code="sal.text.city" />',
    }, {
      dataField : "state",
      headerText : '<spring:message code="sal.title.state" />',
    }, {
      dataField : "postcode",
      headerText : '<spring:message code="sys.title.post.code" />',
    } ];

    var excelGridPros = {
      enterKeyColumnBase : true,
      useContextMenu : true,
      enableFilter : true,
      showStateColumn : true,
      displayTreeOpen : true,
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
      exportURL : "/common/exportGrid.do"
    };

    excelListGridID = GridCommon.createAUIGrid("excel_list_wrap", excelColumnLayout, "", excelGridPros);
  }

  function fn_getSupplementDailyOrderReportList() {
    Common.ajax("GET","/supplement/selectSupplementDailyOrderReportList.do", $("#_dailyOrderReportForm").serialize(),
      function(result) {
        AUIGrid.setGridData(orderGridID, result);
        AUIGrid.setGridData(excelListGridID, result);
      });
  }
</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1>
      <spring:message code="supplement.btn.dailyReportOrder" />
    </h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="#none" id="_closeOrdPop"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <ul class="right_btns mb10">
      <li>
        <p class="btn_blue">
          <span class="search"></span>
          <a href="#none" id="_btnDailyOrderReportSearch"><spring:message code="sal.btn.search" /></a>
        </p>
      </li>
      <!-- <li>
        <p class="btn_blue">
          <span class="clear"></span>
          <a href="#none" onclick="javascript:$('#_dailyOrderReportForm').clearForm();"><spring:message code="sal.btn.clear" /></a>
        </p>
      </li> -->
    </ul>
    <form id="_dailyOrderReportForm" method="get">
      <input id="ind" name="ind" type="hidden" value="${ind}" />
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="sal.title.payDate" /><span class="must">**</span></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input id="paymentStartDt" name="paymentStartDt" type="text" value="${bfDay}" title="Create Start Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
                <span><spring:message code="supplement.text.to" /></span>
                <p>
                  <input id="paymentEndDt" name="paymentEndDt" type="text" value="${toDay}" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
              </div>
              <th></th>
              <td></td>
          </tr>
        </tbody>
      </table>
      <section class="search_result">
        <ul class="right_btns">
          <li>
            <p class="btn_grid">
              <a href="#" id="btnExcelDown"><spring:message code='service.btn.Generate' /></a>
            </p>
          </li>
        </ul>
        <article class="grid_wrap">
          <div id="dailyOrderReport_wrap" style="width: 100%; height: 580px; margin: 0 auto;"></div>
          <div id="excel_list_wrap" style="display: none;"></div>
        </article>
      </section>
    </form>
  </section>
</div>
