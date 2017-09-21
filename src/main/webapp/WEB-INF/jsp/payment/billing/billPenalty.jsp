<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;
//var tmp = 165801;

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
	 Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "EARLY_TERMINATION_BILLING", indicator : "SearchTrialNo"});
}

function fn_callbackOrder(orderId){
	//orderId = tmp;
	console.log("orderId : " + orderId);
	fn_validRequiredField(orderId);
}

function fn_validRequiredField(orderId){
	var valid = true;
	var message = "";
	Common.ajax("GET", "/payment/checkExistOrderCancellationList.do", {"orderId" : orderId}, function(canResult) {
		Common.ajax("GET", "/payment/checkExistPenaltyBill.do", {"orderId" : orderId}, function(penResult) {
			  if(canResult == false){
				  valid = false;
				  message += "* Please register for order cancellation before bill generate.<br />";
			  }else{
				  if(penResult == true){
					  valid = false;
					  message += "* Early Termination Bill was generated.<br />";
				  }
			  }
			  
			  if(!valid)
				  Common.alert(message);
			  else
				  fn_loadBillingSchedule(orderId);
		});
	});

}

function fn_loadBillingSchedule(orderId){
	Common.ajax("GET", "/payment/selectRentalProductEarlyTerminationPenalty.do", {"orderId" : orderId}, function(result) {
		   console.log(result);
		   if(result != null){
			   var tmp1;
			   var tmp2;
			   $("#orderId").val(result.salesOrdId);
			   $("#orderNo").val(result.salesOrdNo);
			   tmp1=result.soReqCurrAmt.toFixed(2).split(".");
			   tmp2=commaSeparateNumber(tmp1[0]);
			   $("#rental1").val(tmp2+"."+tmp1[1]);
			   $("#rental").val(result.soReqCurrAmt);
			   tmp1=result.unbillMonth.toFixed(2).split(".");
			   tmp2=commaSeparateNumber(tmp1[0]);
			   $("#unbillMonth1").val(tmp2+"."+tmp1[1]);
			   $("#unbillMonth").val(result.unbillMonth);
			   tmp1=result.soReqCanclPnaltyAmt.toFixed(2).split(".");
			   tmp2=commaSeparateNumber(tmp1[0]);
			   $("#amount1").val(tmp2+"."+tmp1[1]);
			   $("#amount").val(result.soReqCanclPnaltyAmt);
		   }
	});
}

function commaSeparateNumber(val){
    while (/(\d+)(\d{3})/.test(val.toString())){
      val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
    }
    return val;
}

function fn_createEvent(objId, eventType){
    var e = jQuery.Event(eventType);
    $('#'+objId).trigger(e);
}

function fn_createBills(){
	var error = errorMsg();
	if(error != ''){
		Common.alert(error);
		return;
	}

	
	Common.ajax("GET", "/payment/createBillsForEarlyTermination.do", $("#billingForm").serialize(), function(result) {
		console.log(result);
		if(result.message != ''){
			$("#orderNo").val('');
			$("#orderId").val('');
			$("#rental").val('');$("#rental1").val('');
			$("#unbillMonth").val('');$("#unbillMonth1").val('');
			$("#amount").val('');$("#amount1").val('');
			$("#remark").val('');
			
			if(result.data != null){
				$("#grid_wrap").show();
				AUIGrid.setGridData(myGridID, result.data);
			}
			Common.alert(result.message);
		}
	});
}

var errorMsg = function(){
	var errorMessage = "";
    if($("#orderId").val() == null || $("#orderId").val() == '' ){
        errorMessage = "Select Order First";
    }else{
        if($("#amount").val() == null || $("#amount").val() == ''){
            errorMessage = "Input Penalty Amount";
        }else{
            if($("#remark").val() == null || $("#remark").val() == ''){
                errorMessage = "Input Remark";
            }
        }
    }
    
    return errorMessage;
}

function fn_clickViewDetail(){
	alert("!!!");
    var orderId = $("#orderId").val();
    console.log("viewDetail , orderID : " + orderId);
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
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Product Early Termination</h2>
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
    <p class="btn_sky"><a href="javascript:fn_orderSearch();">Search</a></p>
    <p class="btn_sky"><a href="javascript:fn_clickViewDetail()">View Details</a></p>
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
    <select class="readonly">
        <option value="">Early Termination Fees</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Mothly Rental</th>
    <td>
    <input type="hidden" id="rental" name="rental" title="" placeholder="" class="readonly" readonly/>
    <input type="text" id="rental1" title="" placeholder="" class="readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Unbill Month</th>
    <td>
    <input type="hidden" id="unbillMonth" name="unbillMonth" title="" placeholder="" class="readonly" readonly/>
    <input type="text" id="unbillMonth1" title="" placeholder="" class="readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Termination Fee</th>
    <td>
    <input type="hidden" id="amount" name="amount" title="" placeholder="" class="readonly" readonly/>
    <input type="text" id="amount1" title="" placeholder="" class="readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>
    <textarea id="remark" name="remark" cols="20" rows="5" placeholder=""></textarea>
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
