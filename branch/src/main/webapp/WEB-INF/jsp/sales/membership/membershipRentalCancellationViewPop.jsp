<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="salse.title.mRCancellView" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
	<li><a href="#" class="on"><spring:message code="salse.tap.cancell" /></a></li>
	<li><a href="#"><spring:message code="sales.tap.member" /></a></li>
	<li><a href="#"><spring:message code="sales.tap.order" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sales.CancellationRefNo" /></th>
    <td><span id= "textTrmnatRefNo"></span></td>
    <th scope="row"><spring:message code="sales.RequestedDate" /></th>
    <td><span id="textTrmnatCrtDt"></span></td>
    <th scope="row"><spring:message code="sales.Creator" /></th>
    <td><span id="textUserName"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.TotalUsedMonth" /></th>
    <td><span id="textTrmnatCntrctSubPriod"></span></td>
    <th scope="row"><spring:message code="sales.ObligationPeriod" /></th>
    <td><span id="textTrmnatObligtPriod"></span></td>
    <th scope="row"><spring:message code="sales.PenaltyCharge" /></th>
    <td><span id="textTrmnatPnalty"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.Requestor" /></th>
    <td colspan="3"><span id="textCodeName"></span></td>
    <th scope="row"><spring:message code="sales.PenaltyInvoice" /></th>
    <td><span id="textTaxInvcRefNo"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.Reason" /></th>
    <td colspan="5"><span id="textResnDesc"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.Remark" /></th>
    <td colspan="5"><span id="textTrmnatRem"></span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<!-- inc_membershipInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRMerInfo.do'/>   
<!--  inc_membershipInfotab  end...-->

<!-- oder info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mROrderInfo.do'/> 
<!-- oder info tab  end...--> 

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<script  type="text/javascript">
 $(document).ready(function(){
    fn_selectCancellationInfoAjax();
});

//리스트 조회.
function fn_selectCancellationInfoAjax() {
   
  Common.ajax("GET", "/sales/membership/selectCancellationInfo", {trmnatId : "${trmnatId}"}, function(result) {
      
       console.log("성공.");
       console.log( result);
       
       $("#textTrmnatRefNo").html(result.trmnatRefNo);  
       $("#textTrmnatCrtDt").html(result.trmnatCrtDt);  
       $("#textUserName").html(result.userName);  
       $("#textTrmnatCntrctSubPriod").html(result.trmnatCntrctSubPriod);  
       $("#textTrmnatObligtPriod").html(result.trmnatObligtPriod);  
       $("#textTrmnatPnalty").html(result.trmnatPnalty);  
       $("#textCodeName").html(result.codeName);  
       $("#textTaxInvcRefNo").html(result.taxInvcRefNo);  
       $("#textResnDesc").html(result.resnDesc);  
       $("#textTrmnatRem").html(result.trmnatRem);   
       
       var ord_id;
       var moption = {
//                 srvCntrctId :result.srvCntrctId,
                 srvCntrctId :result.trmnatCntrctId,
                 callbackFun : 'fn_setMRentalOrderInfoData(vmrMemResultObj.srvCntrctOrdId)',
                 showViewLeder : true,
                 showQuotationInfo:true
       };                     

       ord_id = fn_setMRentalMembershipInfoData(moption);

       console.log("======>ord_id========>"+ord_id);
               
   /*     var poption = {
               SRV_CNTRCT_ID :'${srvCntrctId}',
               ORD_ID : ord_id
       };  */
      
  });
}



//fn_setMRentalPayInfoData(poption);
//fn_getmRPayGridAjax (poption);
//fn_getmRCallLogGridAjax(poption);

</script>