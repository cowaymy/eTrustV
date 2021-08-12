<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/02/2019  ONGHC  1.0.0       CREATE INSTALLATION/AS PSI VIEWER
 19/02/2019  ONGHC  1.0.1       ADD LMP COLUMN
 26/02/2019  ONGHC  1.0.2       ADD Additional COLUMN
 -->

<script type="text/javaScript">
  var myGridID1;
  $(document).ready(
    function() {
      //$('.multy_select').on("change", function() {
      //}).multipleSelect({});

      //doGetCombo('/common/selectCodeList.do', '10', '', 'appliType', 'M', 'f_multiCombo');
      //doGetComboSepa('/common/selectBranchCodeList.do', '5', '-', '', 'branch', 'M', 'f_multiCombo1');
      //doGetProductCombo('/common/selectProductCodeListM.do', '', '', 'productLst', 'M', 'f_multiCombo2'); //Product Code
      fn_noteListingGrid();

      fn_searchView();
    }
  );

  function fn_noteListingGrid() {
    var columnLayout = [ {
      dataField : "orderno",
      headerText : '<spring:message code="service.grid.OrderNo" />',
      editable : false,
      width : 130
    }, {
      dataField : "id",
      headerText : '<spring:message code="sys.info.id" />',
      editable : false,
      width : 130
    }, {
      dataField : "rid",
      headerText : '<spring:message code="service.grid.ResultNo" />',
      editable : false,
      width : 130
    }, {
      dataField : "completeDt",
      headerText : '<spring:message code="service.grid.CompDt" />',
      editable : false,
      width : 130
    }, {
      dataField : "volt",
      headerText : '<spring:message code="service.title.Volt" />',
      editable : false,
      width : 130
    }, {
      dataField : "psi",
      headerText : '<spring:message code="service.title.PSIRcd" />',
      editable : false,
      width : 130
    }, {
      dataField : "lpm",
      headerText : '<spring:message code="service.title.lmp" />',
      editable : false,
      width : 130
    }, {
      dataField : "tds",
      headerText : '<spring:message code="service.title.TDS" />',
      editable : false,
      width : 130
    }, {
      dataField : "roomTemp",
      headerText : '<spring:message code="service.title.RoomTemp" />',
      editable : false,
      width : 130
    }, {
      dataField : "waterSourceTemp",
      headerText : '<spring:message code="service.title.WaterSourceTemp" />',
      editable : false,
      width : 130
    }, {
      dataField : "adptUsed",
      headerText : '<spring:message code="service.title.adptUsed" />',
      editable : false,
      width : 130
    }, {
      dataField : "brCde",
      headerText : '<spring:message code="service.title.DSCBranch" />',
      editable : false,
      width : 130
    }, {
      dataField : "br",
      headerText : '<spring:message code="service.title.DSCBranch" />',
      editable : false,
      width : 130
    }, {
      dataField : "ctCde",
      headerText : '<spring:message code="service.grid.CTCode" />',
      editable : false,
      width : 130
    }, {
      dataField : "ctNm",
      headerText : '<spring:message code="service.grid.CTName" />',
      editable : false,
      width : 130
    }, {
      dataField : "ctHp",
      headerText : '<spring:message code="sal.text.ctHp" />',
      editable : false,
      width : 130
    }, {
      dataField : "instArea",
      headerText : '<spring:message code="sal.title.area" />',
      editable : false,
      width : 130
    }, {
      dataField : "instCity",
      headerText : '<spring:message code="sal.text.city" />',
      editable : false,
      width : 130
    }, {
      dataField : "instPstcde",
      headerText : '<spring:message code="sys.title.post.code" />',
      editable : false,
      width : 130
    }, {
      dataField : "instState",
      headerText : '<spring:message code="sal.text.state" />',
      editable : false,
      width : 130
    } ];

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

    myGridID1 = AUIGrid.create("#grid_wrap_noteListing", columnLayout, gridPros);
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
    Common.ajax("GET", "/sales/order/getInstAsPSIData.do", {ordNo : $("#ordNo").val()}, function(result) {
      AUIGrid.setGridData(myGridID1, result);
    });
  }

  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_noteListing", "xlsx", "Water Pressure (PSI) History Log");
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='service.title.PSILMPRcd' />
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
        <!-- <div class="date_set">
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="appStrDate"
           name="appStrDate" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="appEndDate"
           name="appEndDate" />
         </p>
        </div> -->
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
   <div id="grid_wrap_noteListing"
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
