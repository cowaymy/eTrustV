<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

.edit-column {
  visibility: hidden;
}
</style>
<script type="text/javascript">
  var viewHistGridID;

  $(document).ready(function() {
    createAUIGrid();
    fn_instAddrViewHistAjax();
  });

  function createAUIGrid() {
    var columnLayout;
    if ($("#ind").val() == "M") {
      columnLayout = [{
        dataField : "histCrtDt",
        headerText : "<spring:message code="sal.title.updateDate" />",
        width : 100,
        editable : false
      }, {
        dataField : "histCrtTm",
        headerText : "<spring:message code="sal.title.text.updateTime" />",
        width : 100,
        editable : false
      }, {
        dataField : "userName",
        headerText : "<spring:message code="sal.title.text.updateUser" />",
        width : 100,
        editable : false
      }, {
        dataField : "userHistRem",
        headerText : "<spring:message code="sales.reason" />",
        editable : false
      }];
    } else {
      columnLayout = [{
        dataField : "updDt",
        headerText : "<spring:message code="sal.title.updateDate" />",
        width : 100,
        editable : false
      }, {
        dataField : "updTm",
        headerText : "<spring:message code="sal.title.text.updateTime" />",
        width : 100,
        editable : false
      }, {
        dataField : "userName",
        headerText : "<spring:message code="sal.title.text.updateUser" />",
        width : 100,
        editable : false
      }, {
        dataField : "addrDtl",
        headerText : "<spring:message code="sal.text.address" />",
        width : 100,
        editable : false
      }, {
        dataField : "street",
        headerText : "<spring:message code="sal.text.street" />",
        width : 100,
        editable : false
      }, {
        dataField : "area",
        headerText : "<spring:message code="sal.text.area" />",
        width : 100,
        editable : false
      }, {
        dataField : "city",
        headerText : "<spring:message code="sal.text.city" />",
        width : 100,
        editable : false
      }, {
        dataField : "state",
        headerText : "<spring:message code="sales.State" />",
        width : 100,
        editable : false
      }, {
        dataField : "postcode",
        headerText : "<spring:message code="sys.postcode" />",
        width : 100,
        editable : false
      }, {
        dataField : "country",
        headerText : "<spring:message code="sal.text.country" />",
        width : 100,
        editable : false
      }, {
        dataField : "name",
        headerText : "<spring:message code="sales.cusName" />",
        width : 100,
        editable : false
      }, {
        dataField : "code",
        headerText : "<spring:message code="sales.dscBranch" />",
        width : 100,
        editable : false
      }, {
        dataField : "preDt",
        headerText : "<spring:message code="sal.title.text.perferInstDate" />",
        width : 100,
        editable : false
      }, {
        dataField : "preTm",
        headerText : "<spring:message code="sal.title.text.perferInstTime" />",
        width : 100,
        editable : false
      }, {
        dataField : "instct",
        headerText : "<spring:message code="sal.title.text.specialInstruction" />",
        width : 100,
        editable : false
      }];
    }

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      fixedColumnCount : 3,
      showStateColumn : false,
      displayTreeOpen : true,
      selectionMode : "multipleCells",
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };

    viewHistGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
  }

  function fn_instAddrViewHistAjax() {
    if ($("#ind").val() == "M") {
      Common.ajax("GET", "/sales/order/mailAddrViewHistoryAjax", $("#historyForm").serialize(), function(result) {
        AUIGrid.setGridData(viewHistGridID, result);
      });
    } else {
      Common.ajax("GET", "/sales/order/instAddrViewHistoryAjax", $("#historyForm").serialize(), function(result) {
        AUIGrid.setGridData(viewHistGridID, result);
      });
    }
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <c:if test="${ind == 'M'}">
    <spring:message code="sal.page.title.ordMailAddrHist" />
   </c:if>
   <c:if test="${ind == 'I'}">
     <spring:message code="sal.page.title.ordInstAddrHist" />
   </c:if>
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#" id="histClose"><spring:message code="sal.btn.close" /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <form id="historyForm" name="historyForm" method="POST">
   <input type="hidden" id="prm" name="prm" value="${prm}">
   <input type="hidden" id="ind" name="ind" value="${ind}">
  </form>
  <article class="grid_wrap">
   <!-- grid_wrap start -->
   <div id="grid_wrap"
    style="width: 100%; height: 480px; margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
 <!-- content end -->
 <hr />
</div>
<!-- popup_wrap end -->
