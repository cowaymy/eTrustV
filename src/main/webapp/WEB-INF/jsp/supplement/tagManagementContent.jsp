<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">
  $(document).ready(function(){
  });

  var gridPros = {
    usePaging : true,
    pageRowCount : 10,
    editable : false,
    fixedColumnCount : 0,
    showStateColumn : false,
    displayTreeOpen : false,
    headerHeight : 30,
    useGroupingPanel : false,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : true,
    noDataMessage : '<spring:message code="sales.msg.noOrdNo" />',
    groupingMessage : "Here groupping"
  };

  function chgTab(tabNm) {
    switch(tabNm) {
     case 'responseDetail' :
        AUIGrid.resize(docGridID, 942, 380);
       break;
     case 'referenceDetail' :
       //AUIGrid.resize(custInfoGridID, 942, 380);
       break;
    }
  }
</script>
</head>
<section class="tap_wrap">
  <ul class="tap_type1 num4">
    <li><a id="aTabBI" href="#" class="on">Tag Detail</a></li>
    <li><a id="aTabSI" href="#" onClick="javascript:chgTab('responseDetail');">Response Detail</a></li>
    <li><a id="aTabCI" href="#" onClick="javascript:chgTab('referenceDetail');">Reference Detail</a></li>

  </ul>
  <!------------------------------------------------------------------------------
    tagDetail
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/tagDetail.jsp" %>
  <!------------------------------------------------------------------------------

  <!------------------------------------------------------------------------------
    responseDetail
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/responseDetail.jsp" %>
  <!------------------------------------------------------------------------------

  <!------------------------------------------------------------------------------
    referenceDetail
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/referenceDetail.jsp" %>
  <!------------------------------------------------------------------------------



<%-- <%@ include file="/WEB-INF/jsp/supplement/orderLedgerPop.jsp" %> --%>
</section>=

