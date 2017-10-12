<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Quotation No</th>
    <td><span  id="inc_quotNo" ></span></td>
    <th scope="row">Validity Status</th>
    <td><span id="inc_validStus" ></span></td>
    <th scope="row">Create Date</th>
    <td><span id="inc_crtDts" ></span></td>
</tr>
<tr>
    <th scope="row">Membership Sales</th>
    <td><span id="inc_cnvrMemNo"> </span></td>
    <th scope="row">Valid Date</th>
    <td><span id="inc_validD" ></span></td>
    <th scope="row">Creator</th>
    <td><span  id="inc_crtUserId" ></span></td>
</tr>
<tr>
    <th scope="row">Duration</th>
    <td><span  id="inc_dur">   </span></td>
    <th scope="row">Package</th>
    <td><span id="inc_pacDesc"></span></td>
    <th scope="row">Deactivated by</th>
    <td><span id="inc_pacDeacby" ></span></td>
</tr>
<tr>
    <th scope="row">Total Amount</th>
    <td><span id="inc_totAmt" ></span></td>
    <th scope="row">Package Amount</th>
    <td><span id="inc_pacAmt" >$</span></td>
    <th scope="row">Filter Amount</th>
    <td><span  id="inc_filterAmt"></span></td>
</tr>
<tr>
    <th scope="row">Package Promotion</th>
    <td colspan="5"><span id="inc_pacPromoDesc"></span></td>
</tr>
<tr>
    <th scope="row">Filter Promotion</th>
    <td colspan="3"><span  id="inc_promeCode" > </span></td>
    <th scope="row">BS Frequency</th>
    <td> <span  id="inc_bsFreq" > </span></td>
</tr>
<tr>
    <th scope="row">Sales Person Code</th>
    <td><span  id="inc_memCode"> </span></td>
    <th scope="row">Sales Person Name</th>
    <td colspan="3"><span  id="inc_memName"></span></td>
</tr>
<tr>
    <th scope="row">Reference Number</th>
    <td colspan="5"><span id="inc_refNo"></span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

 
 
 
<script type="text/javascript">

var vQResult; 

function fn_setMRentalQuotationInfoData(_options ){
    
    var ordId;
    
    Common.ajaxSync("GET", "/sales/membershipRental/inc_mRQuotInfoData",{QOTAT_ID: _options.QOTAT_ID }, function(result) {
            console.log(result);
            
            if(result.quotInfo !="" ){
            	vQResult = result.quotInfo;
                  
            	ordId = vQResult.qotatOrdId;
                fn_setMRentalQuoutInfoSet();  
                  
                if(_options.callbackFun !=""){
                      eval(_options.callbackFun);
                } 
            }
     });
    
    return ordId;
}


function fn_setMRentalBillInfoData(srvCntrctId ){
    
    Common.ajaxSync("GET", "/sales/membershipRental/inc_mRPayBillingInfo",{CNTRCT_ID: srvCntrctId}, function(result) {
        console.log(result);
        
        if(result !="" ){
        
             $("#rental_txtOutstandingAmt").html(result.outstandingAmount);
             $("#rental_txtUnbillAmt").html(result.unBillAmount);
             
               /*
               map.put("unBillAmount", unbillAmt);
               map.put("outstandingAmount", outstanding);
               map.put("scheduleNo", currentSchedule);
               map.put("monthlyFee", monthlyFee);*/
               
             
        }
   });
    
}


function fn_setMRentalQuoutInfoSet(){
	
	

if(vQResult.c6 == 'ACT' ){
    
    $("#inc_validStus").html("<font color='green'> Ready to convert </font>");
    $("#inc_pacDeacby").html("-");
    
}else if(vQResult.c6 == 'CON'){
    
    $("#inc_validStus").html("<font color='orange'> Converted to sales </font>");
    $("#inc_pacDeacby").html("-");
    
}else if(vQResult.c6 == 'EXP'){
    
    $("#inc_validStus").html("<font color='red'> Expired </font>");
    $("#inc_pacDeacby").html("-");
    
}else if(vQResult.c6 == 'DEA'){
	
    $("#inc_validStus").html("<font color=brown'> Deactivated </font>");
    $("#inc_pacDeacby").html(vQResult.userName);
}
        
        
        
	 $("#inc_quotNo").html(vQResult.qotatRefNo);  
     $("#inc_crtDts").html(vQResult.qotatCrtDt);  
	 $("#inc_validD").html(vQResult.qotatValIdDt);
	 $("#inc_crtUserId").html(vQResult.userName);
	 $("#inc_dur").html(vQResult.qotatCntrctDur +"month(s)");
	 $("#inc_pacDesc").html(vQResult.srvCntrctPacDesc);
	 $("#inc_totAmt").html(vQResult.qotatRentalAmt);
	 $("#inc_pacAmt").html(vQResult.qotatRentalAmt);
	 $("#inc_filterAmt").html(vQResult.qotatExpFilterAmt);
	 $("#inc_pacPromoDesc").html(vQResult.c1);
	 $("#inc_promeCode").html(vQResult.c2);
	 $("#inc_bsFreq").html(vQResult.qotatCntrctFreq +"month(s)");
	 $("#inc_memCode").html(vQResult.c3);
	 $("#inc_memName").html(vQResult.c4);
	 $("#inc_refNo").html(vQResult.c7); 
	
	 $("#inc_cnvrMemNo").html("");  
}




function fn_setMRentalQuotInfoInit(){
    
    vQResult = {};

}


</script>
