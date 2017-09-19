<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Payment Mode</th>
    <td><span id='rP_txtPayMode'></span></td>
    <th scope="row">Name On Card</th>
    <td colspan="3"><span id='rP_txtCrcName'></span></td>
</tr>
<tr>
    <th scope="row">Credit Card No.</th>
    <td><span id='rP_txtCrcNo'></span></td>
    <th scope="row">Card Type</th>
    <td><span id='rP_txtCrcCardType'></span></td>
    <th scope="row">Expiry Date</th>
    <td><span id='rP_txtCrcExpiry'></span></td>
</tr>
<tr>
    <th scope="row">Bank Acc No.</th>
    <td><span id='rP_txtBankAccNo'></span></td>
    <th scope="row">Issue Bank</th>
    <td><span id='rP_txtIssueBank'></span></td>
    <th scope="row">Account Name</th>
    <td><span id='rP_txtAccName'></span></td>
</tr>
<tr>
    <th scope="row">Pay By Third Party</th>
    <td><span id='rP_txtPTD'></span></td>
    <th scope="row">Third Party ID</th>
    <td><span id='rP_txtPTID'>text</span></td>
    <th scope="row">Third Party Type</th>
    <td><span id='rP_txtPTType'></span></td>
</tr>
<tr>
    <th scope="row">Third Party Name</th>
    <td colspan="3"><span id='rP_txtPTName'></span></td>
    <th scope="row">Third Party NRIC</th>
    <td><span id='rP_txtPTDNRIC'></span></td>
</tr>
<tr>
    <th scope="row">Apply Date</th>
    <td><span id='rP_txtApplyDate'></span></td>
    <th scope="row">Submit Date</th>
    <td><span id='rP_txtSubmitDate'></span></td>
    <th scope="row">Start Date</th>
    <td><span id='rP_txtStartDate'></span></td>
</tr>
<tr>
    <th scope="row">Reject Date</th>
    <td><span id='rP_txtRejectDate'></span></td>
    <th scope="row">Reject Code</th>
    <td><span  id='rP_txtRejectCode'></span></td>
    <th scope="row">Payment Term</th>
    <td><span  id='rP_txtPayTerm'></span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->


<script type="text/javascript">

var vmrPayResultObj;

function fn_setMRentalPayInfoData(options){
    
	
	 Common.ajax("GET", "/sales/membershipRental/inc_mRPayListInfoData",{ORD_ID:options.ORD_ID , 
		                                                                                             SRV_CNTRCT_ID:options.SRV_CNTRCT_ID}, function(result) {
	        
		    console.log(result);
	        
	        if(result.paysetInfo !="" ){
	        	vmrPayResultObj = result;
	              fn_setMRentalPayInfoSet();
	        }
	    
	 });
}





function fn_setMRentalPayThirdPartyInfoData(){
    
     Common.ajax("GET", "/sales/membershipRental/inc_mRPayThirdPartyInfoData",{CUST_ID:vmrPayResultObj.paysetInfo.custCrcId}, function(result) {
            console.log(result);
            
            if(result.paysetThirdPartyInfo !="null"   ||  result.paysetThirdPartyInfo !=null ){
            	/*
                $("#rP_txtPTDNRIC").html(result.paysetThirdPartyInfo.custNRIC);
                $("#rP_txtPTID").html(result.paysetThirdPartyInfo.custName);
                $("#rP_txtPTType").html(result.paysetThirdPartyInfo.customerId);
                $("#rP_txtPTName").html(result.paysetThirdPartyInfo.custType);
                */
            }
     });
}



function fn_setMRentalPayInfoSet(){
	

    $("#rP_txtPayMode").html(vmrPayResultObj.paysetInfo.codeDesc);  
    $("#rP_txtCrcName").html(vmrPayResultObj.paysetInfo.custCrcOwner);   
    $("#rP_txtCrcNo").html(vmrPayResultObj.paysetInfo.custCrcNo);         
    $("#rP_txtCrcCardType").html(vmrPayResultObj.paysetInfo.codeName); 
    $("#rP_txtCrcExpiry").html(vmrPayResultObj.paysetInfo.custCrcExpr);     
    $("#rP_txtBankAccNo").html(vmrPayResultObj.paysetInfo.custAccNo);  
    $("#rP_txtIssueBank").html(vmrPayResultObj.paysetInfo.c10);  
    $("#rP_txtAccName").html(vmrPayResultObj.paysetInfo.custAccOwner);  
    $("#rP_txtApplyDate").html(vmrPayResultObj.paysetInfo.ddApplyDt);     
    $("#rP_txtSubmitDate").html(vmrPayResultObj.paysetInfo.ddSubmitDt);   
    $("#rP_txtStartDate").html(vmrPayResultObj.paysetInfo.ddStartDt);     
    $("#rP_txtRejectDate").html(vmrPayResultObj.paysetInfo.ddRejctDt);    
    $("#rP_txtRejectCode").html(vmrPayResultObj.paysetInfo.codeDesc); 
    $("#rP_txtPayTerm").html(vmrPayResultObj.paysetInfo.payTrm +" month(s)");        
    
    if(  vmrPayResultObj.paysetInfo.is3rdParty >0){
        $("#rP_txtPTD").html("YES");       
        fn_setMRentalPayThirdPartyInfoData();
        
    } else{
    	$("#rP_txtPTD").html("NO");   
    	$("#rP_txtPTDNRIC").html("-");
    }
    
}



function fn_setMRentalPayInfoInit(){
	
	vmrPayResultObj ={};
	
	$("#rP_txtPayMode").html("");
	$("#rP_txtCrcName").html("");
	$("#rP_txtCrcNo").html("");
	$("#rP_txtCrcCardType").html("");
	$("#rP_txtCrcExpiry").html("");
	$("#rP_txtBankAccNo").html("");
	$("#rP_txtIssueBank").html("");
	$("#rP_txtAccName").html("");
	$("#rP_txtPTD").html("");
	$("#rP_txtPTID").html("");
	$("#rP_txtPTType").html("");
	$("#rP_txtPTName").html("");
	$("#rP_txtPTDNRIC").html("");
	$("#rP_txtApplyDate").html("");
	$("#rP_txtSubmitDate").html("");
	$("#rP_txtStartDate").html("");
	$("#rP_txtRejectDate").html("");
	$("#rP_txtRejectCode").html("");
	$("#rP_txtPayTerm").html("");
}

</script>
