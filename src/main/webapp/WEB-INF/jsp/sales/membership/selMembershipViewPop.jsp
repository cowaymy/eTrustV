<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

  <script type="text/javascript">
    var quot = $("#QUOT_ID").val();

    if(quot >0){
       fn_getMembershipQuotInfoAjax();
       fn_getMembershipQuotInfoFilterAjax();
    }
  </script>

  <form id="getParamForm" method="get">
    <input type="hidden" name="QUOT_ID"  id="QUOT_ID" value="${membershipInfoTab.quotId}"/>
  </form>

  <div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
      <h1><spring:message code="sal.page.title.membershipManagementView" /></h1>
      <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
      </ul>
    </header>

    <section class="pop_body">
      <section class="tap_wrap">
        <ul class="tap_type1">
          <li><a href="#" class="on"><spring:message code="sal.tap.title.membershipInfo" /></a></li>
          <li><a href="#"><spring:message code="sal.tap.title.ordInfo" /></a></li>
          <li><a href="#"><spring:message code="sal.tap.title.contactInfo" /></a></li>
          <li><a href="#" ><spring:message code="sal.tap.title.filterChargeInfo" /></a></li>
        </ul>

        <!-- inc_membershipInfo  tab  start...-->
          <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_membershipInfo.do'/>
        <!--  inc_membershipInfotab  end...-->

        <!-- oder info tab  start...-->
          <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_orderInfo.do'/>
        <!-- oder info tab  end...-->

        <!-- person info tab  start...-->
          <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_contactPersonInfo.do'/>
        <!-- oder info tab  end...-->

        <!-- person info tab  start...-->
          <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_quotFilterInfo.do'/>
        <!-- oder info tab  end...-->
      </section>
      <!-- tap_wrap end -->
    </section>
    <!-- pop_body end -->
  </div>
  <!-- popup_wrap end -->

  <!-- <script>

  </script> -->
