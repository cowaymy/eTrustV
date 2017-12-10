

<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

function fn_doback(){
    
    $("#_ViewSVMDetailsDiv1").remove();
}
</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Rental Membership Sales View </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"  ><!-- pop_body start -->


<section class="tap_wrap"><!-- tap_wrap start -->

<ul class="tap_type1">
    <li><a href="#" class="on">Membership Info</a></li>
    <li><a href="#">Order Info</a></li>
    <li><a href="#">Payment Channel</a></li>
    <li><a href="#">Payment List</a></li>
    <li><a href="#">Call Log List</a></li>
</ul>



<!-- inc_membershipInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRMerInfo.do'/> 
<!--  inc_membershipInfotab  end...-->


<!-- inc_orderInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mROrderInfo.do'/> 
<!--  inc_orderInfo  end...-->



<!-- inc_paymemtInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRPayInfo.do'/> 
<!--  inc_paymemtInfo  end...-->



<!-- inc_paymemtListInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRPayListInfo.do'/> 
<!--  inc_paymemtInfo  end...-->



<!-- inc_callLogListInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRCallLogInfo.do'/> 
<!--  inc_callLogListInfo  end...-->

</section><!-- tap_wrap end -->





<!-- 

<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_doback()">Back</a></p></li>
</ul>
 -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<script>
        
          var ord_id;
          var moption = {
                    srvCntrctId :'${srvCntrctId}',
                    callbackFun : 'fn_setMRentalOrderInfoData(vmrMemResultObj.srvCntrctOrdId)',
                    showViewLeder : true,
                    showQuotationInfo:true
          };                     
         
          ord_id = fn_setMRentalMembershipInfoData(moption);
          
          console.log("======>ord_id========>"+ord_id);
                  
          var poption = {
                  SRV_CNTRCT_ID :'${srvCntrctId}',
                  ORD_ID : ord_id
          }; 
          
          fn_setMRentalPayInfoData(poption);
          fn_getmRPayGridAjax (poption);
          fn_getmRCallLogGridAjax(poption);
          
          
          
</script>
