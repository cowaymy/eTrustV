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
     case 'salesmanInfo' :
       // AUIGrid.resize(salesmanInfoGridID, 942, 380);
       break;
     case 'custInfo' :
       AUIGrid.resize(custInfoGridID, 942, 380);
       break;
    case 'deliveryInfo' :
        AUIGrid.resize(deliveryInfoGridID, 942, 380);
        break;
     case 'payInfo' :
       AUIGrid.resize(payGridID, 942, 380);
         if(AUIGrid.getRowCount(payGridID) <= 0) {
           fn_selectPaymentList();
         }
         break;
     case 'docSubm' :
       AUIGrid.resize(docGridID, 942, 380);
       if(AUIGrid.getRowCount(docGridID) <= 0) {
         fn_selectDocumentList();
       }
       break;
    }
  }
</script>
</head>
<section class="tap_wrap">
  <ul class="tap_type1 num4">
    <li><a id="aTabBI" href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a id="aTabSI" href="#" onClick="javascript:chgTab('salesmanInfo');"><spring:message code="sal.title.text.salesmanInfo" /></a></li>
    <li><a id="aTabCI" href="#" onClick="javascript:chgTab('custInfo');"><spring:message code="sal.title.text.custInfo" /></a></li>
    <li><a id="aTabDI" href="#" onClick="javascript:chgTab('deliveryInfo');"><spring:message code="supplement.title.text.supplementDeliveryInfo" /></a></li>
    <li><a id="aTabPI" href="#" onClick="javascript:chgTab('payInfo');"><spring:message code="supplement.text.paymentInfo" /></a></li>
    <li><a id="aTabDS" href="#" onClick="javascript:chgTab('docSubm');"><spring:message code="sal.title.text.docuSubmission" /></a></li>
  </ul>
  <!------------------------------------------------------------------------------
    BASIC INFO
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/basicInfo.jsp" %>
  <!------------------------------------------------------------------------------

  <!------------------------------------------------------------------------------
    SALESMAN INFO
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/salesmanInfo.jsp" %>
  <!------------------------------------------------------------------------------

  <!------------------------------------------------------------------------------
    CUSTOMER INFO
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/custInfo.jsp" %>
  <!------------------------------------------------------------------------------

  <!------------------------------------------------------------------------------
    DELIVERY INFO
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/deliveryInfo.jsp" %>
  <!------------------------------------------------------------------------------

  <!------------------------------------------------------------------------------
    PAYMENT INFO
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/payList.jsp" %>
  <!------------------------------------------------------------------------------

  <!------------------------------------------------------------------------------
    DOCUMENT SUBMISSION INFO
  ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/supplement/include/docSubmission.jsp" %>
  <!------------------------------------------------------------------------------
</section>
