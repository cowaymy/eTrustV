<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<!-- get param Form  -->
<form id="getParamForm" method="get">
	<div style="display:none">
		<input type="text" name="QUOT_ID"       id="QUOT_ID" value="${QUOT_ID}"/>
		<input type="text" name="inc_ORD_ID"    id="inc_ORD_ID" value="${ORD_ID}"/>
		<input type="text" name="inc_CNT_ID"    id="inc_QUOT_ID" value="${CNT_ID}"/>
		<input type="text" name="inc_MBRSH_ID"    id="inc_MBRSH_ID" value="${MBRSH_ID}"/>
	</div>
</form>

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.membershipManagementQuotation" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.qutationInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.ordInfo" /></a></li>
   <!-- <li><a href="#"><spring:message code="sal.tap.title.contactInfo" /></a></li>-->
    <li><a href="#"><spring:message code="sal.tap.title.filterChargeInfo" /></a></li>
</ul>

<!-- oder info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_quotInfo.do'/>
<!-- oder info tab  end...-->


<!-- oder info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_orderInfo.do'/>
<!-- oder info tab  end...-->

<!-- person info tab  start...-->
<!--    <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_contactPersonInfo.do?MBRSH_ID=${MBRSH_ID}'/>
<!-- oder info tab  end...-->

<!-- person info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_quotFilterInfo.do'/>
<!-- oder info tab  end...-->

</section><!-- tap_wrap end -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<script>
    var quot = $("#QUOT_ID").val();
    console.log(quot);

    if(quot >0){
         fn_getMembershipQuotInfoAjax();
         fn_getMembershipQuotInfoFilterAjax(quot);
    }
</script>