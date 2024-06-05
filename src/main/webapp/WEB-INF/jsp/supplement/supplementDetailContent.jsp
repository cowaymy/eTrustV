<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    $(document).ready(function(){

    });

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
        editable            : false,
        fixedColumnCount    : 0,
        showStateColumn     : false,
        displayTreeOpen     : false,
      //selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        noDataMessage       : '<spring:message code="sales.msg.noOrdNo" />',
        groupingMessage     : "Here groupping"
    };

    function chgTab(tabNm) {
    	switch(tabNm) {
	        case 'salesmanInfo' :
	            AUIGrid.resize(salesmanInfoGridID, 942, 380);
	            break;

	        case 'custInfo' :
                AUIGrid.resize(custInfoGridID, 942, 380);
                break;

	        case 'deliveryInfo' :
                AUIGrid.resize(deliveryInfoGridID, 942, 380);
                break;

	        case 'paymentInfo' :
	        	 AUIGrid.resize(payGridID, 942, 380);
	                if(AUIGrid.getRowCount(payGridID) <= 0) {
	                    fn_selectPaymentList();
	                }
	                break;

	        case 'DocumentSubmission' :
                AUIGrid.resize(docGridID, 942, 380);
                if(AUIGrid.getRowCount(docGridID) <= 0) {
                    fn_selectDocumentList();
                }
              break;

	        case 'ledger' :
                AUIGrid.resize(ordLedgerGridID, 942, 380);
                if(AUIGrid.getRowCount(docGridID) <= 0) {
                    fn_selectDocumentList();
                }
              break;

	    /*     case 'DocumentSubmission' :
                AUIGrid.resize(DocumentSubmissionGridID, 942, 380);
                break; */
        };
    }
</script>
</head>

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
	<li><a id="aTabBI" href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a id="aTabSI" href="#" onClick="javascript:chgTab('salesmanInfo');"><spring:message code="sal.title.text.salesmanInfo" /></a></li>
    <li><a id="aTabCI" href="#" onClick="javascript:chgTab('custInfo');"><spring:message code="sal.title.text.custInfo" /></a></li>
    <li><a id="aTabDI" href="#" onClick="javascript:chgTab('deliveryInfo');"><spring:message code="supplement.title.text.supplementDeliveryInfo" /></a></li>
    <li><a id="aTabPI" href="#" onClick="javascript:chgTab('paymentInfo');"><spring:message code="supplement.text.paymentInfo" /></a></li>
    <li><a id="aTabDS" href="#" onClick="javascript:chgTab('DocumentSubmission');"><spring:message code="sal.title.text.docuSubmission" /></a></li>

</ul>
<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/include/basicInfo.jsp" %>
<!------------------------------------------------------------------------------

<!------------------------------------------------------------------------------
    salesman Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/include/salesmanInfo.jsp" %>
<!------------------------------------------------------------------------------

<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/include/custInfo.jsp" %>
<!------------------------------------------------------------------------------

<!------------------------------------------------------------------------------
    Delivery Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/include/deliveryInfo.jsp" %>
<!------------------------------------------------------------------------------

<!------------------------------------------------------------------------------
    Pay Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/include/payList.jsp" %>
<!------------------------------------------------------------------------------

<!------------------------------------------------------------------------------
    Doc Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------

<%-- <%@ include file="/WEB-INF/jsp/supplement/orderLedgerPop.jsp" %> --%>
</section><!-- tap_wrap end -->

