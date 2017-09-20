<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

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
                  {dataField:"rentRunId", headerText:"Bill ID"},
                  {dataField:"rentDocNo", headerText:"Bill No"},
                  {dataField:"rentSoId", headerText:"Order ID"},
                  {dataField:"rentDocTypeId", headerText:"Bill Type"},
                  {dataField:"rentDateTime", headerText:"Bill Date"},
                  {dataField:"rentAmount", headerText:"Bill Amount"},
                  {dataField:"rentInstNo", headerText:"Installment"}
];

function fn_orderSearch(){
	 Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "PRODUCT_LOST", indicator : "SearchTrialNo"});
}

function fn_callbackOrder(orderId){
	//orderId = tmp;
	console.log("orderId : " + orderId);
	if(orderId != null && orderId != ''){
		   fn_loadBillingSchedule(orderId);
	}
}
function fn_loadBillingSchedule(orderId){
	Common.ajax("GET", "/payment/selectRentalProductLostPenalty.do", {"orderId" : orderId}, function(result) {
		console.log(result);
		if(result != null){
			$("#orderId").val(result.salesOrdId);
	        $("#orderNo").val(result.salesOrdNo);
	        $("#price").val(result.salesPrc);
	        $("#outstanding").val(result.outstanding);
	        $("#month").val(result.billMonth);
	        $("#lossFee").val(result.pnalty);
		}
	});
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
            $("#price").val('');
            $("#outstanding").val('');
            $("#month").val('');
            $("#lossFee").val('');
            $("#remark").val('');
    		
    		$("#grid_wrap").show();
            AUIGrid.setGridData(myGridID, result.data);
            
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
    <input type="hidden" id="orderNo" name="orderNo" />
    <input type="text" id="orderId" name="orderId" title="" placeholder="" class="" />
    <p class="btn_sky"><a href="javascript:fn_orderSearch();">Search</a></p>
    <p class="btn_sky"><a href="javascript:fn_clickViewDetail();">View Details</a></p>
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
    <input type="text" id="price" name="price" title="" placeholder="" class="" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Total Outstanding</th>
    <td>
    <input type="text" id="outstanding" name="outstanding" title="" placeholder="" class="" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Bill Month</th>
    <td>
    <input type="text" id="month" name="month" title="" placeholder="" class="" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Loss Fee</th>
    <td>
    <input type="text" id="lossFee" name="lossFee" title="" placeholder="" class="" readonly/>
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
    <li><p class="btn_blue2 big"><a href="javascript:fn_createBills();">Create Bills</a></p></li>
</ul>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->
 <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
 <!-- grid_wrap end -->
</section><!-- content end -->
