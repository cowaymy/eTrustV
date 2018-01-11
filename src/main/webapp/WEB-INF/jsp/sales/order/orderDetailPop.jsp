<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

    $(function(){
        $('#btnLedger1').click(function() {
            //Common.popupDiv("/sales/order/orderLedgerViewPop.do", {ordId : '${orderDetail.basicInfo.ordId}'});
            Common.popupWin("frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "780", resizable: "no", scrollbars: "no"});
        });
        $('#btnLedger2').click(function() {
            //Common.popupDiv("/sales/order/orderLedger2ViewPop.do", {ordId : '${orderDetail.basicInfo.ordId}'});
            Common.popupWin("frmLedger", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "780", resizable: "no", scrollbars: "no"});
        });
        $('#btnOrdDtlClose').click(function() {
            $('#_divIdOrdDtl').remove();
        });
    });
    
</script>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order View</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="btnLedger1" href="#">Order Ledger(1)</a></p></li>
	<li><p class="btn_blue2"><a id="btnLedger2" href="#">Order Ledger(2)</a></p></li>
	<li><p class="btn_blue2"><a id="btnOrdDtlClose" href="#">CLOSE</a></p></li>
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
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>