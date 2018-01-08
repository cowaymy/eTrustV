<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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
    <th scope="row"><spring:message code="sal.text.quotationNo" /></th>
    <td><span  id="inc_quotNo" ></span></td>
    <th scope="row"><spring:message code="sal.text.validityStatus" /></th>
    <td><span id="inc_validStus" ></span></td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td><span id="inc_crtDts" ></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.memSales" /></th>
    <td><span id="inc_cnvrMemNo"> </span></td>
    <th scope="row"><spring:message code="sal.text.validDate" /></th>
    <td><span id="inc_validD" ></span></td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td><span  id="inc_crtUserId" ></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.Duration" /></th>
    <td><span  id="inc_dur">   </span></td>
    <th scope="row"><spring:message code="sales.Package" /></th>
    <td><span id="inc_pacDesc"></span></td>
    <th scope="row"><spring:message code="sal.text.deactivatedby" /></th>
    <td><span id="inc_pacDeacby" ></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.totAmt" /></th>
    <td><span id="inc_totAmt" ></span></td>
    <th scope="row"><spring:message code="sal.text.pacAmt" /></th>
    <td><span id="inc_pacAmt" ></span></td>
    <th scope="row"><spring:message code="sal.text.filAmt" /></th>
    <td><span  id="inc_filterAmt"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.pakPro" /></th>
    <td colspan="5"><span id="inc_pacPromoDesc"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.filterPro" /></th>
    <td colspan="3"><span  id="inc_promeCode" > </span></td>
    <th scope="row"><spring:message code="sales.bsFre" /></th>
    <td> <span  id="inc_bsFreq" > </span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.salPersonCode" /></th>
    <td><span  id="inc_memCode"> </span></td>
    <th scope="row"><spring:message code="sal.text.salPersonName" /></th>
    <td colspan="3"><span  id="inc_memName"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.refNum" /></th>
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
  
	var msg;
	var month = "<spring:message code="sales.month" />";
	
	if('${quotInfo.validStus}' == 'ACT' ){
	    msg = "<spring:message code="sal.text.readyToConvert" />";
	    
	    $("#inc_validStus").html("<font color='green'>" +msg+ "</font>");
	    $("#inc_pacDeacby").html("-");
	    
	}else if('${quotInfo.validStus}' == 'CON'){
	    msg ="<spring:message code="sal.text.convertedTosales" />";
	    
	    $("#inc_validStus").html("<font color='orange'>"+msg+"</font>");
	    $("#inc_pacDeacby").html("-");
	    
	}else if('${quotInfo.validStus}' == 'EXP'){
	    msg ="<spring:message code="sal.text.expired" />";
	    
	    $("#inc_validStus").html("<font color='red'>"+msg+"</font>");
	    $("#inc_pacDeacby").html("-");
	    
	}else if('${quotInfo.validStus}' == 'DEA'){
	    msg ="<spring:message code="sal.text.deacivated" />";
	    
	    $("#inc_validStus").html("<font color=brown'>"+msg+"</font>");
	    $("#inc_pacDeacby").html("${quotInfo.updUserId}");
	} 
	
	
        
	 $("#inc_quotNo").html(vQResult.qotatRefNo);  
     $("#inc_crtDts").html(vQResult.qotatCrtDt);  
	 $("#inc_validD").html(vQResult.qotatValIdDt);
	 $("#inc_crtUserId").html(vQResult.userName);
	 $("#inc_dur").html(vQResult.qotatCntrctDur + " "+month);
	 $("#inc_pacDesc").html(vQResult.srvCntrctPacDesc);
	 $("#inc_totAmt").html(vQResult.qotatRentalAmt);
	 $("#inc_pacAmt").html(vQResult.qotatRentalAmt);
	 $("#inc_filterAmt").html(vQResult.qotatExpFilterAmt);
	 $("#inc_pacPromoDesc").html(vQResult.c1);
	 $("#inc_promeCode").html(vQResult.c2);
	 $("#inc_bsFreq").html(vQResult.qotatCntrctFreq +" "+ month);
	 $("#inc_memCode").html(vQResult.c3);
	 $("#inc_memName").html(vQResult.c4);
	 $("#inc_refNo").html(vQResult.c7); 
	
	 $("#inc_cnvrMemNo").html("");  
}




function fn_setMRentalQuotInfoInit(){
    
    vQResult = {};

}


</script>
