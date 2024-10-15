<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  var cmbOrdDtlResultGridID;

  function createAUIGrid() {
          var cmbOrdDtlLstGridPros = {
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

            var colLayout = [
                        {
                           dataField : "aircondBulkOrderNo",
                           headerText : "<spring:message code='sal.text.aircondBulkOrdNo'/>",
                           width : 300,
                           editable : false
                       }, {
                         dataField : "orderDate",
                         headerText : "<spring:message code='sales.ordDt'/>",
                         width : 300,
                         editable : false
                       },{
                         dataField : "orderStatus",
                         headerText : "<spring:message code='sal.text.orderStatus'/>",
                         width : 280,
                         editable : false
                       }
             ];
             cmbOrdDtlResultGridID = GridCommon.createAUIGrid("cmbOrdDtlResult_grid_wrap", colLayout, "", cmbOrdDtlLstGridPros);

             Common.ajax("GET", "/homecare/sales/selectHcAcBulkOrderDtlList", $("#popSearchComboForm").serialize(), function(result) {
            	 AUIGrid.setGridData(cmbOrdDtlResultGridID, result);
             });

  }

  $(document).ready(function() {
      createAUIGrid();
    });

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='sal.title.text.aircondBulkOrder' />
  </h1>
  <ul class="right_opt">
   <li>
      <p class="btn_blue2">
            <a href="#"><spring:message code='sys.btn.close' /></a>
      </p>
    </li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <form id="popSearchComboForm" name="popSearchComboForm" action="#" method="post">
     <input id="ordId" name="ordId" value="${ordId}" type="hidden" />
     <input id="pckBindingId" name="pckBindingId" value="${pckBindingId}" type="hidden" />
  </form>
  <article class="grid_wrap" >
       <div id="cmbOrdDtlResult_grid_wrap" style="width: 100%; height: 200px; margin: 0 auto;"></div>
  </article>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
