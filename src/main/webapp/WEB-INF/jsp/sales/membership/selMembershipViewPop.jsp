<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">


</script>


<!-- get param Form  -->
<form id="getParamForm" method="get">
    <input type="hidden" name="QUOT_ID"  id="QUOT_ID" value="${membershipInfoTab.quotId}"/>
</form>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Management - View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Membership Info</a></li>
    <li><a href="#">Order Info</a></li>
    <li><a href="#">Contact Info</a></li>
    <li><a href="#" > Filter Charge Info</a></li>
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



</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<script> 
    var quot = $("#QUOT_ID").val();
    console.log(quot);
    
    if(quot >0){ 
         fn_getMembershipQuotInfoAjax(); 
         fn_getMembershipQuotInfoFilterAjax();
    }
</script>
