<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

$(document).ready(function() {
  $("#btnLedger").click(function() {
    Common.popupDiv("/supplement/orderLedgerViewPop.do", '', null , true , '_insDiv');
  });
});

  function fn_popClose(){
    $("#_systemClose").click();
  }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
  <input type="hidden" id="_memBrnch" value="${userBr}">
  <header class="pop_header">
  <h1>Supplement Order Details</h1>
  <ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a></p></li>
    <li><p class="btn_blue2"><a id="_systemClose"><spring:message code="sal.btn.close" /></a></p></li>
  </ul>
  </header>
  <section class="pop_body">
    <section class="tap_wrap">
    <!------------------------------------------------------------------------------
      Supplement Detail Page Include START
    ------------------------------------------------------------------------------->
    <%@ include file="/WEB-INF/jsp/supplement/supplementDetailContent.jsp" %>
    <!------------------------------------------------------------------------------
      Supplement Detail Page Include END
    ------------------------------------------------------------------------------->
    </section>
    <br/>
  </section>
</div>