<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  $(document).ready(
    function() {
      $('#btnLedger').click(function() {
        Common.popupWin("frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
      });

  });

  function fn_popClose() {
    $("#_systemClose").click();
  }

</script>
<div id="popup_wrap" class="popup_wrap">
  <form id="frmLedger" name="frmLedger" action="#" method="post">
    <input id="ordId" name="ordId" type="hidden" value="${basicinfo.salesOrdId}" />
  </form>
  <header class="pop_header">
    <h1>
      <spring:message code="service.ss.title.selfServiceManagement" /> - <spring:message code="sys.scm.inventory.ViewDetail" />
    </h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a id="_systemClose"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <aside class="title_line">
      <h3><spring:message code="service.ss.text.selfServiceInformation" /></h3>
    </aside>
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 120px" />
        <col style="width: *" />
        <col style="width: 120px" />
        <col style="width: *" />
        <col style="width: 120px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
      <tr>
    	<th scope="row"><spring:message code="service.grid.HSNo" /></th>
    	<td><span><c:out value="${basicinfo.no}"/></span></td>
    	<th scope="row"><spring:message code="service.ss.title.ssPeriod" /></th>
    	<td><span><c:out value="${basicinfo.monthy}"/></span></td>
    	<th scope="row"><spring:message code="sal.text.bsType" /></th>
    	<td><span><c:out value="${basicinfo.codeName}"/></span></td>
		</tr>
      </tbody>
    </table>

    <section class="tap_wrap">
      <!------------------------------------------------------------------------------
        Detail Page Include START
      ------------------------------------------------------------------------------->
      <%@ include
        file="/WEB-INF/jsp/services/ss/selfServiceDetailContent.jsp"%>
      <!------------------------------------------------------------------------------
        Detail Page Include END
      ------------------------------------------------------------------------------->
    </section>
    <br />
  </section>
</div>