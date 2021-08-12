<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  var popOrderGridID;
  $(document).ready(
    function() {
      createAUIGrid();

      AUIGrid.bind(popOrderGridID, "cellDoubleClick",
        function(event) {
          fn_setData(AUIGrid.getCellValue(popOrderGridID, event.rowIndex, "ordNo"), AUIGrid.getCellValue(popOrderGridID, event.rowIndex, "ordId"))
          $('#custPopCloseBtn').click();
      });

      fn_selectListAjaxPop();
    });

  function fn_setData(ordNo, ordId) {
    fn_setBindComboOrd(ordNo, ordId);
  }

  function createAUIGrid() {

    //AUIGrid 칼럼 설정
    var columnLayout = [ {
      dataField : "ordNo",
      headerText : "<spring:message code='sales.OrderNo'/>",
      width : 80,
      editable : false,
      style : 'left_style'
    }, {
      dataField : "refNo",
      headerText : "<spring:message code='sales.refNo2'/>",
      width : 120,
      editable : false,
      style : 'left_style'
    }, {
      dataField : "ordDt",
      headerText : "<spring:message code='sales.ordDt'/>",
      width : 100,
      editable : false,
      style : 'left_style'
    }, {
      dataField : "appType",
      headerText : "<spring:message code='sales.AppType'/>",
      width : 80,
      editable : false,
      style : 'left_style'
    }, {
      dataField : "prod",
      headerText : "<spring:message code='sales.prod'/>",
      width : 170,
      editable : false,
      style : 'left_style'
    }, {
      dataField : "promoCde",
      headerText : "<spring:message code='sales.promoCd'/>",
      width : 300,
      editable : false
    }, {
      dataField : "custId",
      headerText : "<spring:message code='sales.cusName'/>",
      editable : false,
      style : 'left_style'
    }, {
      dataField : "maxLink",
      headerText : "<spring:message code='sal.title.text.maxCboLinkage'/>",
      editable : false,
      style : 'left_style'
    }, {
      dataField : "cnt",
      headerText : "<spring:message code='sal.title.text.crntCboLinkage'/>",
      editable : false,
      style : 'left_style'
    }, {
      dataField : "ordId",
      visible : false
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      fixedColumnCount : 1,
      showStateColumn : false,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping"
    };

    popOrderGridID = GridCommon.createAUIGrid("pop_ord_grid_wrap", columnLayout, "", gridPros);
  }

  function fn_selectListAjaxPop() {
    if ($('#ordIdPop_1').val() != null && $('#ordIdPop_1').val() != "") {
      Common.ajax("GET", "/sales/order/selectComboOrderJsonList_2", $("#popSearchComboForm").serialize(), function(result) {
        AUIGrid.setGridData(popOrderGridID, result);
      });
    } else {
      Common.ajax("GET", "/sales/order/selectComboOrderJsonList", $("#popSearchComboForm").serialize(), function(result) {
        AUIGrid.setGridData(popOrderGridID, result);
      });
    }
  }
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='sales.title.searchOrder' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a id="custPopCloseBtn" href="#"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <form id="popSearchComboForm" name="popSearchComboForm" action="#" method="post">
   <input id="promoNo" name="promoNo" value="${promoNo}" type="hidden" />
   <input id="prod" name="prod" value="${prod}" type="hidden" />
   <input id="custId" name="custId" value="${custId}" type="hidden" />
   <input id="ordIdPop_1" name="ordIdPop_1" value="${ordId}" type="hidden" />

  </form>
  <article class="grid_wrap mt30">
   <!-- grid_wrap start -->
   <div id="pop_ord_grid_wrap"
    style="width: 100%; height: 480px; margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
