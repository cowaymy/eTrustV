<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var myGridID;
//var tmp = 665425;

$(document).ready(function(){
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	$("#grid_wrap").hide();
});

var gridPros = {
		editable: false,
		showStateColumn:false
}

var columnLayout=[
                  {dataField:"rentRunId", headerText:"<spring:message code='pay.head.billId'/>"},
                  {dataField:"rentDocNo", headerText:"<spring:message code='pay.head.billNo'/>"},
                  {dataField:"rentSoId", headerText:"<spring:message code='pay.head.orderId'/>"},
                  {dataField:"rentDocTypeId", headerText:"<spring:message code='pay.head.billType'/>"},
                  {dataField:"rentDateTime", headerText:"<spring:message code='pay.head.billDate'/>", dataType : "date", formatString : "dd-mm-yyyy"},
                  {dataField:"rentAmount", headerText:"<spring:message code='pay.head.billAmount'/>", dataType : "numeric", formatString : "#,##0"},
                  {dataField:"rentInstNo", headerText:"<spring:message code='pay.head.installment'/>"}
];

function fn_orderSearch(){
	 Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "PRODUCT_LOST", indicator : "SearchTrialNo"});
}

function fn_callbackOrder(orderId){
	//orderId = tmp;
	if(orderId != null && orderId != ''){
		   fn_loadBillingSchedule(orderId);
	}
}
function fn_loadBillingSchedule(orderId){
	Common.ajax("GET", "/payment/selectRentalProductLostPenalty.do", {"orderId" : orderId}, function(result) {
		
		if(result != null){
			$("#orderId").val(result.salesOrdId);
	        $("#orderNo").val(result.salesOrdNo);
	        var tmp1;
            var tmp2;
            tmp1=result.salesPrc.toFixed(2).split(".");
            tmp2=commaSeparateNumber(tmp1[0]);
	        $("#price1").val(tmp2+"."+tmp1[1]);
	        $("#price").val(result.salesPrc);
	        tmp1=result.outstanding.toFixed(2).split(".");
            tmp2=commaSeparateNumber(tmp1[0]);
	        $("#outstanding1").val(tmp2+"."+tmp1[1]);
	        $("#outstanding").val(result.outstanding);
	        tmp1=result.billMonth.toFixed(2).split(".");
            tmp2=commaSeparateNumber(tmp1[0]);
	        $("#month1").val(tmp2+"."+tmp1[1]);
	        $("#month").val(result.billMonth);
	        tmp1=result.pnalty.toFixed(2).split(".");
            tmp2=commaSeparateNumber(tmp1[0]);
	        $("#lossFee1").val(tmp2+"."+tmp1[1]);
	        $("#lossFee").val(result.pnalty);
		}
	});
}

function commaSeparateNumber(val){
    while (/(\d+)(\d{3})/.test(val.toString())){
      val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
    }
    return val;
}

var errorMsg = function(){
    var errorMessage = "";
    if($("#orderId").val() == null || $("#orderId").val() == '' ){
        errorMessage = "Select Order First";
    }else{
        if($("#lossFee").val() == null || $("#lossFee").val() == ''){
            errorMessage = "Input Penalty Amount";
        }else{
            if($("#remark").val() == null || $("#remark").val() == ''){
                errorMessage = "Input Remark";
            }
        }
    }
    
    return errorMessage;
}

function fn_createEvent(objId, eventType){
    var e = jQuery.Event(eventType);
    $('#'+objId).trigger(e);
}

function fn_createBills(){
	//$("#orderId").val(tmp);
	var error = errorMsg();
    if(error != ''){
        Common.alert(error);
        return;
    }
    
    
    Common.ajax("GET", "/payment/createBillForProductLost.do", $("#billingForm").serialize(), function(result) {
    	if(result.message != 'Failed To Save'){
    		console.log(result);
    		
    		$("#orderId").val('');
            $("#orderNo").val('');
            $("#price").val('');$("#price1").val('');
            $("#outstanding").val('');$("#outstanding1").val('');
            $("#month").val('');$("#month1").val('');
            $("#lossFee").val('');$("#lossFee1").val('');
            $("#remark").val('');
    		
    		$("#grid_wrap").show();
            AUIGrid.setGridData(myGridID, result.data);
            AUIGrid.resize(myGridID, 1200, 280);
            Common.alert(result.message);
            
    	}
    });
}

function fn_clickViewDetail(){
	var orderId = $("#orderId").val();
	if(orderId != '' && orderId != undefined){
	   Common.popupDiv("/sales/order/orderDetailPop.do", {salesOrderId : orderId});
    }else{
    	Common.alert("SELECT ORDER FIRST");
    }
}
</script>

<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Billing</li>
	    <li>Manual Billing</li>
	</ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Product Lost Fee</h2>
	</aside><!-- title_line end -->
	
	
	<section class="search_table"><!-- search_table start -->
		<form action="#" id="billingForm" name="billingForm" method="post">
		
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:170px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Selected Order No.</th>
					    <td>
					    <input type="hidden" id="orderId" name="orderId" />
					    <input type="text" id="orderNo" name="orderNo" title="" placeholder="" class="readonly" readonly/>
					    <p class="btn_sky"><a href="javascript:fn_orderSearch();"><spring:message code='sys.btn.search'/></a></p>
					    <p class="btn_sky"><a href="javascript:fn_clickViewDetail();"><spring:message code='pay.btn.link.viewDetails'/></a></p>
					    </td>
					</tr>
					</tbody>
					</table><!-- table end -->
					
					<aside class="title_line"><!-- title_line start -->
					<h3>Penalty Bill Info</h3>
					</aside><!-- title_line end -->
					
					<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
					    <col style="width:170px" />
					    <col style="width:*" />
					</colgroup>
					<tbody>
					<tr>
					    <th scope="row">Penalty Type</th>
					    <td>
						    <select>
						        <option value="">Product Lost</option>
						    </select>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Product Price</th>
					    <td>
						    <input type="hidden" id="price" name="price" title="" placeholder="" class="readonly" readonly/>
						    <input type="text" id="price1" title="" placeholder="" class="readonly" readonly/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Total Outstanding</th>
					    <td>
						    <input type="hidden" id="outstanding" name="outstanding" title="" placeholder="" class="readonly" readonly/>
						    <input type="text" id="outstanding1" title="" placeholder="" class="readonly" readonly/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Bill Month</th>
					    <td>
						    <input type="hidden" id="month" name="month" title="" placeholder="" class="readonly" readonly/>
						    <input type="text" id="month1" title="" placeholder="" class="readonly" readonly/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Loss Fee</th>
					    <td>
						    <input type="hidden" id="lossFee" name="lossFee" title="" placeholder="" class="readonly" readonly/>
						    <input type="text" id="lossFee1" title="" placeholder="" class="readonly" readonly/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Remark</th>
					    <td>
					       <textarea id="remark" name="remark" cols="20" rows="5" placeholder=""></textarea>
					    </td>
					</tr>
					<tr>
					    <td colspan="2">
					        <p><span class="red_text">Note:  Please proceed OCR registration after bill generate.</span></p>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		
		<ul class="center_btns">
		    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
		    <li><p class="btn_blue2 big"><a href="javascript:fn_createBills();"><spring:message code='pay.btn.createBills'/></a></p></li>
		    </c:if>
		</ul>
		</form>
	</section><!-- search_table end -->
	 <!-- grid_wrap start -->
	    <article id="grid_wrap" class="grid_wrap"></article>
	 <!-- grid_wrap end -->
</section><!-- content end -->
