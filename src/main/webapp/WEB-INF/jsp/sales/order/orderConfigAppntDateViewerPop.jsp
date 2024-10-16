<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------

 -->

<script type="text/javaScript">
  var myGridID1;
  $(document).ready(
    function() {
      fn_hsAppntDateListGrid();
      fn_searchView();
    }
  );

  function fn_hsAppntDateListGrid() {
    var columnLayout = [ {
      dataField : "hsNo",
      headerText : '<spring:message code="service.title.HSOrder" />',
      editable : false,
      width : 200
    }, {
        dataField : "stusCode",
        headerText : '<spring:message code="service.title.Status" />',
        editable : false,
        width : 200
    }, {
      dataField : "nextAppntDt",
      headerText : '<spring:message code="service.title.AppointmentDate" />',
      editable : false,
      width : 200
    }, {
      dataField : "nextAppntTm",
      headerText : '<spring:message code="sal.title.text.time" />',
      editable : false,
      width : 200
    }];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      fixedColumnCount : 2,
      showStateColumn : false,
      displayTreeOpen : false,
      selectionMode : "singleRow",
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
    };

    myGridID1 = AUIGrid.create("#grid_wrap_hsAppntDate", columnLayout, gridPros);
  }

  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false
  };

  function fn_searchView() {
    Common.ajax("GET", "/sales/order/getHsAppntDateInfo.do", {ordNo : $("#ordNo").val()}, function(result) {
      AUIGrid.setGridData(myGridID1, result);
    });
  }

  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_hsAppntDate", "xlsx", "HS Appointment Date List");
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='service.title.HsAppointmentDate' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='expense.CLOSE' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" id="reportForm">
    <input type="hidden" id="ordNo" name="ordNo" value="${ordNo}"/>
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 160px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.grid.OrderNo' /></th>
       <td><input type="text" title="" placeholder="<spring:message code='service.grid.OrderNo' />" class="w100p" id="ordNoDisp" name="ordNoDisp" value="${ordNo}" disabled /></td>
       <th scope="row"></th>
       <td>
       </td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <article class="grid_wrap">
   <!-- grid_wrap start -->
   <ul class="right_btns">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
      </p></li>
   </ul><br/>
   <div id="grid_wrap_hsAppntDate"
    style="width: 100%; height: 300px; margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#" onclick="fn_searchView()"><spring:message
       code="sys.label.search"/></a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
