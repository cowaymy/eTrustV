<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
    <th scope="row">Order No</th>
    <td><span id='rO_txtOrderNo'></span></td>
    <th scope="row">Order Date</th>
    <td><span id='rO_txtOrderDate'></span></td>
    <th scope="row">Order Status</th>
    <td><span id='rO_txtOrderStatus' ></span></td>
</tr>
<tr>
    <th scope="row">Product Category</th>
    <td colspan="3"><span id='rO_txtProductCategory'></span></td>
    <th scope="row">Application Type</th>
    <td><span id='rO_txtAppType' ></span></td>
</tr>
<tr>
    <th scope="row">Product Code</th>
    <td><span id='rO_txtProductCode'></span></td>
    <th scope="row">Product Name</th>
    <td colspan="3"><span id='rO_txtProductName'></span></td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><span id='rO_txtCustID'></span></td>
    <th scope="row">NRIC/Company No</th>
    <td colspan="3"><span id='rO_txtCustIC'></span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="5"><span id='rO_txtCustName'></span></td>
</tr>
<tr>
    <th scope="row">Last Nembership</th>
    <td colspan="3"><span id='rO_txtLastMembership'></span></td>
    <th scope="row">Expire Date</th>
    <td><span id='rO_txtLastExpireDate'></span></td>
</tr>
<tr>
    <th scope="row">Install Address</th>
    <td colspan="5"><span id='rO_txtInstAddress' >text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->



<script type="text/javascript">

var vmrOrderResultObj;


function fn_setMRentalOrderInfoData(_pram){

	Common.ajax("GET", "/sales/membershipRental/inc_mROrderInfoData",{ORD_ID:_pram }, function(result) {
        console.log(result);
        
        if(result.orderInfo !="" ){
        	vmrOrderResultObj = result;
            fn_setMRentalOrderInfoSet();
        }
 });
    
}



function fn_setMRentalOrderInfoSet(){
    

    $("#rO_txtOrderNo").html(vmrOrderResultObj.orderInfo.ordNo);
    $("#rO_txtOrderDate").html(vmrOrderResultObj.orderInfo.ordDt);
    $("#rO_txtOrderStatus").html(vmrOrderResultObj.orderInfo.ordStusName);
    $("#rO_txtAppType").html(vmrOrderResultObj.orderInfo.appTypeCode);
    $("#rO_txtProductCode").html(vmrOrderResultObj.orderInfo.stockCode);
    $("#rO_txtProductName").html(vmrOrderResultObj.orderInfo.stockDesc);
    $("#rO_txtCustID").html(vmrOrderResultObj.orderInfo.custId);
    $("#rO_txtCustIC").html(vmrOrderResultObj.orderInfo.custNric);
    $("#rO_txtCustName").html(vmrOrderResultObj.orderInfo.custName);
    $("#rO_txtLastMembership").html(vmrOrderResultObj.configInfo.c1);
    $("#rO_txtLastExpireDate").html(vmrOrderResultObj.configInfo.srvPrdExprDt);
    
    $("#rO_txtInstAddress").html("rO_txtInstAddress");
    $("#rO_txtProductCategory").html(vmrOrderResultObj.orderInfo.stkCtgryName );
    
}



function fn_setMRentalOrderInfoInit(){
	
	vmrOrderResultObj ={};
	
	$("#rO_txtOrderNo").html("");
	$("#rO_txtOrderDate").html("");
	$("#rO_txtOrderStatus").html("");
	$("#rO_txtProductCategory").html("");
	$("#rO_txtAppType").html("");
	$("#rO_txtProductCode").html("");
	$("#rO_txtProductName").html("");
	$("#rO_txtCustID").html("");
	$("#rO_txtCustIC").html("");
	$("#rO_txtCustName").html("");
	$("#rO_txtLastMembership").html("");
	$("#rO_txtLastExpireDate").html("");
	$("#rO_txtInstAddress").html("");
	
}


</script>
