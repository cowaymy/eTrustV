<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

    $(function(){
        $('#btnLedger1').click(function() {
            //Common.popupDiv("/sales/order/orderLedgerViewPop.do", {ordId : '${orderDetail.basicInfo.ordId}'});
            Common.popupWin("frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        });
        $('#btnLedger2').click(function() {
            //Common.popupDiv("/sales/order/orderLedger2ViewPop.do", {ordId : '${orderDetail.basicInfo.ordId}'});
            Common.popupWin("frmLedger", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        });
        $('#btnOrdDtlClose').click(function() {
            $('#_divIdOrdDtl').remove();
        });
        $('#btnPrint').click(function() {

        	Common.report("printForm");
        });
        $('#btnSedaReceipt').click(function() {

        	Common.report("sedaReceiptForm");
        });

        var option1 = {
                winName : "popup",
                width : "1200px",   // 창 가로 크기
                height : "540px",    // 창 세로 크기
                resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
                scrollbars : "no" // 스크롤바. (yes/no)(default : yes)
        };

        $('#btnOrderSerialNoHistory').click(function() {
            //Common.popupDiv("/sales/order/orderLedger2ViewPop.do", {ordId : '${orderDetail.basicInfo.ordId}'});
        	Common.popupWin('serialNoHistoryParam', "/logistics/serialHistory/serialNoHistoryPop.do", option1);
        });
    });

</script>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.ordView" /></h1>
<ul class="right_opt">
<c:if test="${orderDetail.seda4promo.sedaFlag == 'Y' && orderDetail.basicInfo.ordStusId == '4'}">
    <li><p class="btn_blue2"><a id="btnSedaReceipt" href="#">Generate Receipt</a></p></li>
</c:if>
	<li><p class="btn_blue2"><a id="btnOrderSerialNoHistory" href="#">Order Serial No. History</a></p></li>
	<!-- <li><p class="btn_blue2"><a id="btnPrint" href="#">Customer Score Card</a></p></li> -->
	<li><p class="btn_blue2"><a id="btnLedger1" href="#"><spring:message code="sal.btn.ledger" />(1)</a></p></li>
	<li><p class="btn_blue2"><a id="btnLedger2" href="#"><spring:message code="sal.btn.ledger" />(2)</a></p></li>
	<li><p class="btn_blue2"><a id="btnOrdDtlClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="frmLedger" name="frmLedger" action="#" method="post">
    <input id="ordId" name="ordId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
</form>
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
  <form id="printForm" name="printForm">
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_ORDERID" name="V_ORDERID" value="${orderDetail.basicInfo.ordId}"/>
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/customerScoreCard.rpt" /><br />
  </form>
  <form id="serialNoHistoryParam" name="serialNoHistoryParam" method="POST">
    <input type="hidden" id="ordNo" name="ordNo" value="${orderDetail.basicInfo.ordNo }">
    <input type="hidden" id="refDocNo" name="refDocNo" value="">
</form>
<form id="sedaReceiptForm" name="sedaReceiptForm">
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_ORDID" name="V_ORDID" value="${orderDetail.basicInfo.ordId}"/>
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/OrderSeda4Receipt.rpt" /><br />

    <input type="hidden" id="sedaFlag" name="sedaFlag" value="${orderDetail.seda4promo.sedaFlag}"/>
    <input type="hidden" id="ordStusId" name="ordStusId" value="${orderDetail.basicInfo.ordStusId}"/>
  </form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>