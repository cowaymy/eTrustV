<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns mb10" >
    <li><p class="btn_blue2" id ='viewLederLay'><a href="#" onclick="javascript:fn_goLedgerPopOut()" >View Ledger</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Membership No.</th>
    <td><span id='rental_txtMembershipNo'></span></td>
    <th scope="row">Membership Type</th>
    <td><span id='rental_txtMembershipType'></span></td>
    <th scope="row">Membership Key-In Date</th>
    <td><span id='rental_txtMembeshipCreated'></span></td>
</tr>
<tr>
    <th scope="row">Membership Status</th>
    <td><span id='rental_txtMembershipStatus'></span></td>
    <th scope="row">Rental Status</th>
    <td><span id='rental_txtRentalStatus'></span></td>
    <th scope="row">PO Number</th>
    <td><span id='rental_txtPONo'></span></td>
</tr>
<tr>
   <!--  <th scope="row">Direct Debit Ref No</th>
    <td><span>text</span></td> -->
    <th scope="row">Package</th>
    <td colspan="3"><span id='rental_txtPackage'></span></td>
    <th scope="row">Duration</th>
    <td><span id='rental_txtDuration'></span></td>
</tr>
<tr>
    <th scope="row">Membership Fee</th>
    <td><span id='rental_txtRentalAmt'></span></td>
    <th scope="row">Outstanding Amount</th>
    <td><span id='rental_txtOutstandingAmt'></span></td>
    <th scope="row">Unbill Amount</th>
    <td><span id='rental_txtUnbillAmt'></span></td>
</tr>
<tr>
    <th scope="row">Package Promotion</th>
    <td colspan="5"><span id='rental_txtPacPromo'></span></td>
</tr>
<tr>
    <th scope="row">Filter Promotion</th>
    <td colspan="3"><span id='rental_txtFilPromo'></span></td>
    <th scope="row">BS Frequency</th>
    <td><span id='rental_txtBSFreq'></span></td>
</tr>
<tr>
    <th scope="row">Updator</th>
    <td><span id='rental_txtMembershipUpdator' ></span></td>
    <th scope="row">Updated</th>
    <td><span id='rental_txtMembershipUpdated'></span></td>
    <th scope="row"></th>
    <td><span></span></td>
</tr>
<tr>
    <th scope="row">Membership F/B Code</th>
    <td colspan="5"><span id='rental_txtFeedbackCode' ></span></td>
</tr>
<tr>
    <th scope="row">Membership Remark</th>
    <td colspan="5"><span id='rental_txtMembersipRemark' ></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Sales Person Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Sales Person</th>
    <td><span id='rental_txtSalesPerson' ></span></td>
</tr>
</tbody>
</table><!-- table end -->



<aside class="title_line viewQuotLay"><!-- title_line start -->
<h3>Quotation Information</h3>
</aside><!-- title_line end -->
<div id ="viewQuotLay">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Quotation No</th>
    <td><span id='rental_txtQuotNo' ></span></td>
    <th scope="row">Created</th>
    <td><span id ='rental_txtQuotCreated' ></span></td>
    <th scope="row">Creator</th>
    <td><span id='rental_txtQuotCreate'></span></td>
</tr>
</tbody>
</table><!-- table end -->
</div>
</article><!-- tap_area end -->


<script type="text/javascript">

var vmrMemResultObj;

function fn_setMRentalMembershipInfoData(_options ){
	
	var ordId;
	
	Common.ajaxSync("GET", "/sales/membershipRental/inc_mRMeminfoData",{SRV_CNTRCT_ID: _options.srvCntrctId }, function(result) {
		    console.log(result);
		    
		    if(result.cSalesInfo !="" ){
		    	  vmrMemResultObj = result.cSalesInfo;
		    	  
		    	  ordId = vmrMemResultObj.srvCntrctOrdId;
		    	  
		    	  fn_setMRentalMembershipInfoSet();  
		    	  fn_setMRentalBillInfoData(_options.srvCntrctId);
		    	 
		    	  if(_options.showViewLeder){
                    	  $("#viewLederLay").attr("style","display:inline");
		    	  }else{
		    		     $("#viewLederLay").attr("style","display:none");
		    	  }
		    	  
		    	  if(_options.showQuotationInfo){
//		    		  $(".viewQuotLay").attr("style","display:inline");
		    		  $("#viewQuotLay").show();
		    	  }else{
		    		  //$(".viewQuotLay").attr("style","display:none");
		    		  $("#viewQuotLay").hide();
		    	  }
	    	  
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


function fn_setMRentalMembershipInfoSet(){
	
	$("#rental_txtMembershipNo").html(vmrMemResultObj.srvCntrctRefNo);       
    $("#rental_txtMembershipType").html(vmrMemResultObj.codeName);
    $("#rental_txtMembeshipCreated").html(vmrMemResultObj.srvCntrctCrtDt);
    $("#rental_txtMembershipStatus").html(vmrMemResultObj.code);
    $("#rental_txtRentalStatus").html(vmrMemResultObj.cntrctRentalStus);
    $("#rental_txtPONo").html(vmrMemResultObj.poRefNo);      
    $("#rental_txtPackage").html(vmrMemResultObj.srvCntrctPacDesc);
    $("#rental_txtDuration").html(vmrMemResultObj.qotatCntrctDur  +" month(s)");
    $("#rental_txtRentalAmt").html(vmrMemResultObj.srvCntrctRental);
    $("#rental_txtOutstandingAmt").html("");
    $("#rental_txtUnbillAmt").html("");
    $("#rental_txtPacPromo").html(vmrMemResultObj.c3);
    $("#rental_txtFilPromo").html(vmrMemResultObj.c4);
    $("#rental_txtBSFreq").html(vmrMemResultObj.qotatCntrctFreq);
    $("#rental_txtMembershipUpdator").html(vmrMemResultObj.userName);
    $("#rental_txtMembershipUpdated").html(vmrMemResultObj.c1);
    $("#rental_txtFeedbackCode").html(vmrMemResultObj.resnDesc );
    $("#rental_txtMembersipRemark").html(vmrMemResultObj.cnfmRem);
    $("#rental_txtSalesPerson").html(vmrMemResultObj.memCode +"-"+vmrMemResultObj.name);
    $("#rental_txtQuotNo").html(vmrMemResultObj.qotatRefNo);
    $("#rental_txtQuotCreated").html(vmrMemResultObj.qotatCrtDt);
    $("#rental_txtQuotCreate").html(vmrMemResultObj.userName);
    
}







function fn_setMRentalMembershipInfoInit(){
	
	vmrMemResultObj = {};
	
	$("#rental_txtMembershipNo").html("");
	$("#rental_txtMembershipType").html("");
	$("#rental_txtMembeshipCreated").html("");
	$("#rental_txtMembershipStatus").html("");
	$("#rental_txtRentalStatus").html("");
	$("#rental_txtPONo").html("");
	$("#rental_txtPackage").html("");
	$("#rental_txtDuration").html("");
	$("#rental_txtRentalAmt").html("");
	$("#rental_txtOutstandingAmt").html("");
	$("#rental_txtUnbillAmt").html("");
	$("#rental_txtPacPromo").html("");
	$("#rental_txtFilPromo").html("");
	$("#rental_txtBSFreq").html("");
	$("#rental_txtMembershipUpdator").html("");
	$("#rental_txtMembershipUpdated").html("");
	$("#rental_txtFeedbackCode").html("");
	$("#rental_txtMembersipRemark").html("");
	$("#rental_txtSalesPerson").html("");
	$("#rental_txtQuotNo").html("");
	$("#rental_txtQuotCreated").html("");
	$("#rental_txtQuotCreate").html("");
	
}


function fn_goLedgerPopOut(){
	 var pram  ="?srvCntrctId="+vmrMemResultObj.srvCntrctId+ "&srvCntrctOrdId="+vmrMemResultObj.srvCntrctOrdId; 
     Common.popupDiv("/sales/membershipRental/mRLedgerPop.do"+pram ,null, null , true , '_LedgerDiv1');
}

</script>