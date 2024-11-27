<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//get Order Id
$(document).ready(function() {

	console.log("cpeRequestNewSearchPop");
    //confirm click
    $("#_confirm").click(function() {
    	checkCpeRequestExistStatus();
    });

    //Order No Search
    $("#_ordSearch").click(function() {
        Common.popupDiv('/services/ecom/searchOrderNoPop.do' , $('#_searchForm_').serializeJSON(), null , true, '_searchDiv');
    });


    //Enter Event
    $('#_salesOrderNo').keydown(function (event) {
        if (event.which === 13) {    //enter
            fn_searchNewOrderPop();
        }
    });

});

function fn_searchNewOrderPop(){
     //   Common.showLoader();
    var inputNum = $("#_salesOrderNo").val();

    if(inputNum == null || inputNum == '' ){
        Common.alert('<spring:message code="sal.alert.msg.plzKeyinOrdNo" />');
        return;
    }
  //  fn_getOrderId(inputNum);
    var ordParam = {salesOrderNo : inputNum};
    var ajaxOpt = {
            async : false
    };

    var isRtn = false;
    Common.ajax("GET", "/services/ecom/getOrderId", ordParam, function(result){

        if(result != null){
            var ordId = result.ordId;
            $("#salesOrderId").val(ordId);
            isRtn = true;
        }else{
            isRtn = false;
            Common.alert('<spring:message code="sal.alert.msg.noRodFound" />');
        }
    },'',ajaxOpt);


    if(isRtn == true){
        Common.popupDiv("/services/ecom/eCpeNewSearchResultPop.do", $("#_searchForm_").serializeJSON(), null , true , 'eCpeNewSearchResultPop');
    }

}

function checkCpeRequestExistStatus(){
	 Common.ajax("GET", "/services/ecom/checkEcpeRequestStatus",$("#_searchForm_").serialize(), function(result) {
		 console.log(result);
		 var existStatus = result.status;
		 if(existStatus == 'true'){
				  Common.alert('Status of CPE request is still Active. <br>Request CPE is disallowed.');
		 }
		 else{
			  Common.ajax("GET", "/services/ecom/checkResultStatus.do",$("#_searchForm_").serialize(), function(result) {
    			         console.log(result);
    			         var ccpResult = result.ccpStatus;
    			         var installStatus = result.requestStage;

    			         if(installStatus == 'Before Install'){
    			        	 if(ccpResult == 'CCP Result'){
    	                          Common.alert('Order under CCP Result. <br>Request CPE is disallowed.');
    	                     }else if(ccpResult == 'Order Cancel/Terminate'){
                                 Common.alert('The order has benn Cancelled/Terminated. <br>Request CPE is disallowed.');
                             }else{
    	                    	 fn_searchNewOrderPop();
    	                     }

    			         }
    			         else if(installStatus == 'After Install'){

    			        	  if(ccpResult == 'Suspend Result'){
    		                        Common.alert('Order under Suspend Result. <br>Request CPE is disallowed.');
    		                  }
    			        	  else if(ccpResult == 'Investigate Result'){
    			        		    Common.alert('Order under Investigate Result. <br>Request CPE is disallowed.');
    		                  }
    			        	  else if(ccpResult == 'Order Cancel/Terminate'){
    		                        Common.alert('The order has benn Cancelled/Terminated. <br>Request CPE is disallowed.');
    		                  }
    			        	  else{
    			        		  fn_searchNewOrderPop();
    			        	  }

    			         }

    			  });
			    }
	 });
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.cpeNewSrch" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form  method="post" id="_searchForm_" onsubmit="retun false;">
<input id="salesOrderId" name="salesOrderId" type="hidden" >
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>
        <input type="text" style="display: none;" >
        <input type="text" title="" placeholder="" class="" id="_salesOrderNo" name="salesOrderNo" />
        <p class="btn_sky">
            <a  id="_confirm"><spring:message code="sal.btn.confirm" /></a>
        </p>
        <p class="btn_sky">
            <a  id="_ordSearch"><spring:message code="sal.btn.search" /></a>
        </p>
    </td>
</tr>

</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

</section><!-- content end -->

<hr />

</div><!-- popup_wrap end -->
