<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><span id='rO_txtOrderNo'></span></td>
    <th scope="row"><spring:message code="sales.ordDt" /></th>
    <td><span id='rO_txtOrderDate'></span></td>
    <th scope="row"><spring:message code="sales.ordStus" /></th>
    <td><span id='rO_txtOrderStatus' ></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.ProductCategory" /></th>
    <td colspan="3"><span id='rO_txtProductCategory'></span></td>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td><span id='rO_txtAppType' ></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.productCode" /></th>
    <td><span id='rO_txtProductCode'></span></td>
    <th scope="row"><spring:message code="sal.text.productName" /></th>
    <td colspan="3"><span id='rO_txtProductName'></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span id='rO_txtCustID'></span></td>
    <th scope="row"><spring:message code="sales.NRIC" />/<spring:message code="sales.CompanyNo" /></th>
    <td colspan="3"><span id='rO_txtCustIC'></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.cusName" /></th>
    <td colspan="5"><span id='rO_txtCustName'></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.lastMem" /></th>
    <td colspan="3"><span id='rO_txtLastMembership'></span></td>
    <th scope="row"><spring:message code="sales.ExpireDate" /></th>
    <td><span id='rO_txtLastExpireDate'></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.insAddr" /></th>
    <td colspan="5"><span id='rO_txtInstAddress' ></span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->



<script type="text/javascript">

var vmrOrderResultObj;


function fn_setMRentalOrderInfoData(_pram ,V){

	Common.ajax("GET", "/sales/membershipRental/inc_mROrderInfoData",{ORD_ID:_pram }, function(result) {
        console.log(result);
        
        if(result.orderInfo !="" ){
        	vmrOrderResultObj = result;
            fn_setMRentalOrderInfoSet();
            
            if(V=="B"){
                
            	fn_getDataCPerson(vmrOrderResultObj.orderInfo.custId);   // custId inc_mRContactPersonPop.jsp 조회 호출 
            }
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
