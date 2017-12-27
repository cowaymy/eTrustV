<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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
                  {dataField:"rentRunId", headerText:"<spring:message code='pay.head.billId'/>"},
                  {dataField:"rentDocNo", headerText:"<spring:message code='pay.head.billNo'/>"},
                  {dataField:"rentSoId", headerText:"<spring:message code='pay.head.orderId'/>"},
                  {dataField:"rentDocTypeId", headerText:"<spring:message code='pay.head.billType'/>"},
                  {dataField:"rentDateTime", headerText:"<spring:message code='pay.head.billDate'/>", dataType : "date", formatString : "dd-mm-yyyy"},
                  {dataField:"rentAmount", headerText:"<spring:message code='pay.head.billAmount'/>", dataType : "numeric", formatString : "#,##0"},
                  {dataField:"rentInstNo", headerText:"<spring:message code='pay.head.installment'/>"}
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
			console.log("canResult :" +canResult + ", penResult : " + penResult);
			  if(canResult == false){
				  
				  valid = false;
				  message += "<spring:message code='pay.alert.orderCancelGenerate'/>";
			  }else{
				  if(penResult == true){
					  valid = false;
					  message += "<spring:message code='pay.alert.earlyTerminationBillGenerated'/>";
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
        errorMessage = "<spring:message code='pay.alert.selectOrderFirst'/>";
    }else{
        if($("#amount").val() == null || $("#amount").val() == ''){
            errorMessage = "<spring:message code='pay.alert.inputPenaltyAmount'/>";
        }else{
            if($("#remark").val() == null || $("#remark").val() == ''){
                errorMessage = "<spring:message code='pay.alert.inputRemark'/>";
            }
        }
    }
    
    return errorMessage;
}

function fn_clickViewDetail(){
    var orderId = $("#orderId").val();
    console.log("viewDetail , orderID : " + orderId);
    if(orderId != '' && orderId != undefined){
    	 Common.popupDiv("/sales/order/orderDetailPop.do", {salesOrderId : orderId});
    }else{
        Common.alert("<spring:message code='pay.alert.selectOrderFirst'/>");
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
						    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
						    <p class="btn_sky"><a href="javascript:fn_orderSearch();"><spring:message code='sys.btn.search'/></a></p>
						    <p class="btn_sky"><a href="javascript:fn_clickViewDetail()"><spring:message code='pay.btn.link.viewDetails'/></a></p>
						    </c:if>
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
