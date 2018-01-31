<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//get Order Id
$(document).ready(function() {
    
    //confirm click
    $("#_confirm").click(function() {
        
    	fn_searchNewOrderPop();
        
    });
    
    //Order No Search
    $("#_ordSearch").click(function() {
        Common.popupDiv('/sales/ccp/searchOrderNoPop.do' , $('#_searchForm_').serializeJSON(), null , true, '_searchDiv');
    });
    
    
    //Enter Event
    $('#_salesOrderNo').keydown(function (event) {  
        if (event.which === 13) {    //enter  
        	fn_searchNewOrderPop();
        }  
    });
});

/* function fn_getOrderId(ordNum){
    
    $.ajax({
        
        type : "GET",
        url : getContextPath() + "/sales/ccp/getOrderId",
        contentType: "application/json;charset=UTF-8",
        crossDomain: true,
        data: {salesOrderNo : ordNum},
        dataType: "json",
        success : function (data) {
            
            var ordId = data.ordId;
            
            $("#salesOrderId").val(ordId);
            
            //$("#_searchForm_").attr({"target": "_self" , "action" : getContextPath()+"/sales/ccp/getOrderDetailInfo.do" }).submit();
            
            
            
        },
        error : function (data) {
            Common.removeLoader();
            if(data == null){               //error
                Common.alert("fail to Load DB");
            }else{                            // No data
                Common.alert("No order found or this order.");
            }
            
            
        }
    });
} */


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
    Common.ajax("GET", "/sales/ccp/getOrderId", ordParam, function(result){
        
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
    	Common.popupDiv("/sales/ccp/newCcpAgreementSearchResultPop.do", $("#_searchForm_").serializeJSON(), null , true , '_newInsDiv');	
    }
    
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ccpAgrNewSrch" /></h1>
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
