
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

function fn_doBack(){
	$("#_ViewQuotDiv1").remove();
}
</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Rental Membership View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->


<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Package Info</a></li>
    <li><a href="#">Order Info</a></li>
    <li><a href="#">Contact Info</a></li>
    <li><a href="#">Filter Charge Info</a></li>
</ul>


<!-- oder info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRQuotInfo.do'/> 
<!-- oder info tab  end...--> 

<!-- oder info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mROrderInfo.do'/> 
<!-- oder info tab  end...-->

<!-- person info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRConPerInfo.do'/> 
<!-- oder info tab  end...-->

<!-- person info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRQFilterInfo.do'/> 
<!-- oder info tab  end...-->


</section><!-- tap_wrap end -->

<!-- <ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_doBack()">Back</a></p></li>
</ul> -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->




<script> 
		 
		var ord_id;
		var qoption = {
			      QOTAT_ID :'${QUOT_ID}' ,
                  callbackFun : 'fn_setMRentalOrderInfoData(vQResult.qotatOrdId , "B")'
        };                     
		
		ord_id = fn_setMRentalQuotationInfoData(qoption);
		console.log("======>ord_id========>"+ord_id);
		fn_getMembershipQuotInfoFilterAjax('${QUOT_ID}');
		
	
</script>























