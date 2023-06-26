<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">

var billingscheduleGridId;
var ordId = "${ordId}";

var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        showStateColumn : false,
        pageRowCount : 61
        };

var billingscheduleLayout = [
                             {
                                 dataField : "salesOrdNo",
                                 headerText : "<spring:message code='pay.head.orderNo'/>",
                                 editable : false
                             }, {
                                 dataField : "installment",
                                 headerText : "<spring:message code='pay.head.installment'/>",
                                 editable : false,
                             }, {
                                 dataField : "schdulDt",
                                 headerText : "<spring:message code='pay.head.scheduleDate'/>",
                                 editable : false,
                                 width: 100
                             }, {
                                 dataField : "billType",
                                 headerText : "<spring:message code='pay.head.type'/>",
                                 editable : false,
                                 width: 100
                             }, {
                                 dataField : "billAmt",
                                 headerText : "<spring:message code='pay.head.amount'/>",
                                 editable : false
                             }, {
                                 dataField : "billingStus",
                                 headerText : "<spring:message code='pay.head.billingStatus'/>",
                                 editable : false
                             }, {
                                 dataField : "rentInstId",
                                 headerText : "<spring:message code='pay.head.rentInstId'/>",
                                 editable : false,
                                 visible : false
                             },{
                                 dataField : "salesOrdId",
                                 headerText : "<spring:message code='pay.head.orderId'/>",
                                 editable : false,
                                 visible : false
                             }];

$(document).ready(function(){
    Common.ajax("GET","/payment/selectRentalBillingSchedule.do", {"salesOrdId" : ordId}, function(result){

        billingscheduleGridId = GridCommon.createAUIGrid("grid_wrap", billingscheduleLayout,"",gridPros2);
        AUIGrid.setGridData(billingscheduleGridId, result.data.billingScheduleList);

    });
});

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Billing Schedule</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->
<article id="grid_wrap" class="grid_wrap"></article>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

