<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    let summaryGridID;

    let summaryGridPros = {
        usePaging: true,
        pageRowCount: 20,
        editable: false,
        headerHeight: 60,
        showRowNumColumn: true,
        wordWrap: true,
        showStateColumn: false
    };

    let summaryLayout = [
       {
          dataField : "salesOrdNo",
          headerText : "Order No",
          editable : false,
          width : "20%"
       },
       {
          dataField : "paymentMode",
          headerText : "Payment Mode",
          editable : false,
          width : "20%"
       },
       {
          dataField : "outstandingAmt",
          headerText : "Outstanding Amount",
          editable : false,
          width : "20%"
       },
       {
           dataField : "unbillAmt",
           headerText : "Unbill Amount",
           editable : false,
           width : "20%"
       },
       {
           dataField : "rentStus",
           headerText : "Rental Status",
           editable : false,
           width : "20%"
        },
    ];

  $(document).ready(function() {
      summaryGrid();
  });

  function summaryGrid() {
      summaryGridID = AUIGrid.create("#grid_wrap_summary", summaryLayout, summaryGridPros);
      Common.ajax("GET", "/sales/ccp/searchOrderSummaryList.do", {custId: "${custId}"}, function(result) {
    	  AUIGrid.setGridData(summaryGridID, result);
      });
  }

   function fn_reload(){
       location.reload();
   }
</script>

<div id="popup_wrap_result" class="popup_wrap">
  <header class="pop_header">
        <h1>Order Summary</h1>
         <ul class="right_opt">
                <li><p class="btn_blue2"><a id="btnPopResultClose" href="fn_reload()"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
  </header>

  <div id="grid_wrap_summary" style="width: 100%; height: 500px; margin: 0 auto;"></div>


</div>