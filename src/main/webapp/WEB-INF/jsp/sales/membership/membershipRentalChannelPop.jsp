<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript" language="javascript">


var  channelGridID;
var  resultPaysetInfo;
var  resultCustBasicinfo;
var  resultCardInfo; 
var  resultBankAccInfo; 

$(document).ready(function(){
	
	  $("#Third_Party").attr("style" ,"display:none");
	  $("#Credit_Card").attr("style" ,"display:none");
	  $("#Direct_Debit").attr("style" ,"display:none");
	  
	  
	  doGetCombo('/common/selectCodeList.do', '19', '','cmbRentPaymode', 'S' , 'f_ComboAct');  
	  fn_selectPatsetListAjax();
	  
	  
});





function f_ComboAct(){
	
    $(function() {
        $('#cmbRentPaymode').change(function() {
        	fn_cmbRentPaymodeEvt();
        });
        
    });
}








function  fn_selectCustomerCreditCardJsonList(_custId) {        //SCS00000003 
    Common.ajax("GET", "/sales/customer/selectCustomerCreditCardJsonList",{  custId:_custId}, function(result) {
	
    console.log("fn_selectCustomerCreditCardJsonList start...==>");
    console.log(result);
    console.log("fn_selectCustomerCreditCardJsonList end...==>");
    
    if( result !=null ){
    	
    	    resultCardInfo ={};
    	    resultCardInfo = result[0];
    	    
    	    $("#txtRentPayCRCNo").val(resultCardInfo.custCrcNo);
    	    $("#txtRentPayCRCType").val(resultCardInfo.codeName1);
    	    $("#txtRentPayCRCName").val(resultCardInfo.custCrcOwner);
    	    $("#txtRentPayCRCExpiry").val(resultCardInfo.custCrcExpr);
    	    $("#txtRentPayCRCBank").val(resultCardInfo.bankCode +" - "+resultCardInfo.bankName);
    	    $("#txtRentPayCRCCardType").val(resultCardInfo.codeName);
    }
   
    
});
}



function  fn_selectCustomerBankAccJsonList(_custId) {        //SCS00000039 
Common.ajax("GET", "/sales/customer/selectCustomerBankAccJsonList",{  custId:_custId}, function(result) {
	console.log("fn_selectCustomerBankAccJsonList start...==>");
    console.log(result);
     console.log("fn_selectCustomerBankAccJsonList end...==>");
     
	resultBankAccInfo ={};
	
	if( result != null){
		resultBankAccInfo = result[0];

		$("#txtRentPayBankAccNo").val(resultBankAccInfo.custAccNo);
		$("#txtRentPayBankAccType").val(resultBankAccInfo.codeName);
		$("#txtRentPayBankAccName").val( resultBankAccInfo.custAccOwner);
		$("#txtRentPayBankAccBankBranch").val(resultBankAccInfo.custAccBankBrnch);
		$("#txtRentPayBankAccBank").val(resultBankAccInfo.bankCode + " - " + resultBankAccInfo.bankName);
	    
	}
 
    
});
}



//리스트 조회.
function fn_selectPatsetListAjax() {        
Common.ajax("GET", "/sales/membershipRentalChannel/selectPatsetInfo", {  SRV_CNTRCT_ID:'${srvCntrctId}'   ,   ORD_ID:'${srvCntrctOrdId}' } , function(result) {
	console.log(result);
	
	resultPaysetInfo={};
	resultCustBasicinfo ={};
	
	if( result.paysetInfo  != null){
		   resultPaysetInfo = result.paysetInfo;
		
		   if(resultPaysetInfo.is3rdParty !=0 ){
				resultCustBasicinfo = result.custBasicinfo;

                $("#Third_Party").attr("style" ,"display:inline"); 
                $("#Credit_Card").attr("style" ,"display:none");
                $("#Direct_Debit").attr("style" ,"display:none");
				$("#paybyCk").attr("checked" ,"true"); 
				
	            fn_custInit( 1);
	            
           }
		
		  $("#cmbRentPaymode").val(resultPaysetInfo.modeId);
		
		  if(null != resultPaysetInfo.nricOld)
			    $("#txtRentPayIC").val(resultPaysetInfo.nricOld);
         
	      if(resultPaysetInfo.modeId == '131'){

              $("#Third_Party").attr("style" ,"display:none"); 
              $("#Credit_Card").attr("style" ,"display:inline");
              $("#Direct_Debit").attr("style" ,"display:none");
              
              fn_selectCustomerCreditCardJsonList(resultPaysetInfo.custId);
	              
	      }else if(resultPaysetInfo.modeId == '132'){
	                

              $("#Third_Party").attr("style" ,"display:none"); 
              $("#Credit_Card").attr("style" ,"display:none");
              $("#Direct_Debit").attr("style" ,"display:inline");
              
	          fn_selectCustomerBankAccJsonList (resultPaysetInfo.custId);
	      }
	      
		
	      var defaultDate ='19000101';
	      
          
	      if(resultPaysetInfo.cvDdApplyDt > defaultDate ){
	    	    $("#dpApplyDate").val(resultPaysetInfo.ddApplyDt); 
	      }
	      
	      if(resultPaysetInfo.cvDdSubmitDt > defaultDate ){
	    	  $("#dpSubmitDate").val(resultPaysetInfo.ddSubmitDt);
          }
		
	      if(resultPaysetInfo.cvDdStartDt > defaultDate ){
	    	  $("#dpStartDate").val(resultPaysetInfo.ddStartDt);
          }
	      
	      if(resultPaysetInfo.cvDdRejctDt > defaultDate ){
	    	   $("#dpRejectDate").val(resultPaysetInfo.ddRejctDt);
	    	   $("#dpRejectDate").attr("class","");
	    	   
	    	   $("#dpStartDate").attr("disabled" ,"disabled");
	    	  // this.lblRentPayCompulsory6.Visible = true;
              //this.lblRentPayCompulsory7.Visible = true;
              
              $("#cmbRejectReason").removeAttr("disabled");
          }
	    
	      $("#cmbPayTerm").val(resultPaysetInfo.payTerm == "" ? resultPaysetInfo.payTerm  :0);
	      fn_LoadRejectReasonList(resultPaysetInfo.modeId ,  resultPaysetInfo.failResnId);
	}
});
}



function fn_LoadRejectReasonList( paymodeID,  failReasonID ){
	
	var typeId  = 0 ;
	  
    if (paymodeID == 131){
    	typeId = 168;
    }else if (paymodeID == 132){
    	typeId = 170;
    }
    
    doGetComboAddr('/sales/membershipRentalChannel/getLoadRejectReasonList', {RESN_TYPE_ID: typeId, RESN_ID : failReasonID}, '','cmbRejectReason', 'S' , 'fn_cmbRejectReasonEvt');     
}


function  fn_cmbRejectReasonEvt (){}


function fn_custInit(method ){
	
	 if( resultCustBasicinfo  !=null ){
		 
		 $("#hiddenThirdPartyID").val(resultCustBasicinfo.custId);  //custId
         $("#txtThirdPartyID").val(resultCustBasicinfo.custId);
         $("#txtThirdPartyType").val(resultCustBasicinfo.codeName1);
         $("#txtThirdPartyName").val(resultCustBasicinfo.name);
         $("#txtThirdPartyNRIC").val(resultCustBasicinfo.nric);
     }else{
          if (method == 2)  {
        	  Common.alert("Third Party Not Found "+DEFAULT_DELIMITER+"<b>Third party not found.<br /> " + "Your input third party ID : " + resultCustBasicinfo.custId+ "</b>");
          }
     }
}



function fn_ClearField_RentPaySet_CRC(){
	  $("#Credit_Card").attr("style" ,"display:none");
	  $("#txtRentPayCRCNo").val("");
	  $("#txtRentPayCRCType").val("");
	  $("#txtRentPayCRCName").val("");
	  $("#txtRentPayCRCExpiry").val("");
	  $("#txtRentPayCRCBank").val("");
	  $("#txtRentPayCRCCardType").val("");
}



function fn_ClearField_RentPaySet_ThirdParty(){
	
    $("#Third_Party").attr("style" ,"display:none");
	$("#txtThirdPartyID").val("");
    $("#hiddenThirdPartyID").val("");
    $("#txtThirdPartyType").val("");
    $("#txtThirdPartyName").val("");
    $("#txtThirdPartyNRIC").val("");
}



function fn_ClearField_RentPaySet_DD(){
    $("#Direct_Debit").attr("style" ,"display:none");
    $("#txtRentPayBankAccNo").val("");
    $("#hiddenRentPayDDID").val("");
    $("#txtRentPayBankAccType").val("");
    $("#txtRentPayBankAccName").val("");
    $("#txtRentPayBankAccBankBranch").val("");
    $("#txtRentPayBankAccBank").val("");
    
}

function fn_ClearField_Reject(){
	
	//$("#rejectChbox").attr("checked" ,"false"); 
	
	$("#dpStartDate").val("");
	$("#dpStartDate").removeAttr("disabled");
	$("#dpStartDate").attr("class" ,"j_date w100p");
	
	$("#dpRejectDate").val("");
	$("#dpRejectDate").attr("disabled" ,"disabled");
	
	$("#cmbRejectReason").val("");
	$("#cmbRejectReason").attr("disabled" ,"disabled");
	
}


function  fn_cmbRentPaymodeEvt(){
	
	fn_ClearField_RentPaySet_CRC();
	fn_ClearField_RentPaySet_DD();
	fn_ClearField_Reject();
	
    doSysdate(0 , 'dpApplyDate');
    $("#dpSubmitDate").val("");
    $("#dpStartDate").val("");
    
    if($("#cmbRentPaymode").val() !=""){
    	
    	
    	var sText    = $("#cmbRentPaymode option:selected").text();
    	
    	if($("#cmbRentPaymode").val() =='133'  || $("#cmbRentPaymode").val() =='134'  ){
            Common.alert("Rental Paymode Restriction  "+DEFAULT_DELIMITER+"<b>Currently we are not provide [" + sText + "] service.</b>");
            $("#cmbRentPaymode").val("");
    	}else {
    		
    		 if($("#cmbRentPaymode").val() =='131' ){ //card 
    			 
    			 if($('#paybyCk').is(':checked')){
    				 if( null == resultCustBasicinfo.custId  ||  ""== resultCustBasicinfo.custId   || null ==resultCustBasicinfo  ){
    					 Common.alert("<b> Third Party Required </b>"+DEFAULT_DELIMITER+"<b>Please select the third party first..</b>");
    				 }else{
    					 $("#Credit_Card").attr("style" ,"display:inline");
    				 }
    				 
    			 }else{
    				 $("#Credit_Card").attr("style" ,"display:inline");
    			 }
    			 
    		 }else if($("#cmbRentPaymode").val() =='132' ){  //Direct Debit
    			 
    			 
    		     if($('#paybyCk').is(':checked')){
    		    	 
    		    	 if( null == resultCustBasicinfo.custId  ||  ""==  resultCustBasicinfo.custId   || null ==resultCustBasicinfo  ){
                         Common.alert("<b> Third Party Required </b>"+ DEFAULT_DELIMITER +"<b>Please select the third party first..</b>");
                     }else{
                         $("#Direct_Debit").attr("style" ,"display:inline");
                     }
    		    	 
    		     }else{
    	              $("#Direct_Debit").attr("style" ,"display:inline");
    		     }
    		 }
    		 fn_LoadRejectReasonList($("#cmbRentPaymode").val(), 0);
    	}
    }
}


function fn_isPanelThirdPartyEvt(v){
	
	
	fn_ClearField_RentPaySet_CRC();
	fn_ClearField_RentPaySet_ThirdParty();
	fn_ClearField_RentPaySet_DD();
	fn_ClearField_Reject();
	doSysdate(0 , 'dpApplyDate');
	$("#dpSubmitDate").val("");
	$("#dpStartDate").val("");

   if(v.checked){
       $("#Third_Party").attr("style" ,"display:inline");
       
    }else{
    	$("#Third_Party").attr("style" ,"display:none");
    }
   
}

function fn_rejectCkEvt(v){
	
	 fn_ClearField_Reject();
	 
	 if(v.checked){
          
		  if($("#cmbRentPaymode").val() ==""){
	          $("#rejectChbox").attr("checked" ,"false"); 
	          Common.alert("Rental Paymode Required "+DEFAULT_DELIMITER+"<b>Please select the rental payment mode first.</b>");
	          return ;
	     }else{
	    	 
	     }
		  
		  /*this.lblRentPayCompulsory6.Visible = true;
          this.lblRentPayCompulsory7.Visible = true;
          this.dpStartDate.Enabled = false;
          this.dpRejectDate.Enabled = true;
          this.cmbRejectReason.Enabled = true;
          */
          $("#dpStartDate").attr("disabled" ,"disabled");
          
          $("#dpRejectDate").attr("class","j_date w100p");
          $("#dpRejectDate").removeAttr("disabled");
          
          $("#cmbRejectReason").attr("class","");
          $("#cmbRejectReason").removeAttr("disabled");
          
     }
}



function fn_doViewHistory_Click(){
	
	 var SRV_CNTRCT_ID= '${srvCntrctId}'   ;
	 var ORD_ID ='${srvCntrctOrdId}' ;
	 
	 var pram  ="?srvCntrctId="+SRV_CNTRCT_ID+"&ordId="+ORD_ID; 
	 
	 Common.popupDiv("/sales/membershipRental/paymentViewHistoryPop.do"+pram ,null, null , true , '_ViewHistoryDiv1');
	      
}


function fn_doAddThirdParty_Click(){
     Common.popupDiv("/sales/customer/customerRegistPop.do" ,null, null , true , '_AddThirdPartyDiv1');
}



function fn_doCustSearch_Click(){
    Common.popupDiv("/common/customerPop.do", {callPrgm : 'fn_custResult'}, null, true ,'_CustSearchDiv1');
}



function fn_doAddNewCard_Click(){
	
	var _custId; 
    if($('#paybyCk').is(':checked')){
    	_custId = $("#hiddenThirdPartyID").val();
    }else{
        _custId = $("#txtThirdPartyID").val();
    }
    Common.popupDiv('/sales/customer/updateCustomerNewCardPop.do', {custId:_custId}, null , true ,'_AddNewCardDiv1');
}



function fn_doSelectCard_Click(){
    
    var _custId; 
    if($('#paybyCk').is(':checked')){
    	_custId = $("#hiddenThirdPartyID").val();
    }else{
    	_custId = $("#txtThirdPartyID").val();
    }
    
    Common.popupDiv("/sales/customer/customerCreditCardSearchPop.do", {custId : _custId, callPrgm : "ORD_REQUEST_PAY"}, null, true ,'_SelectCardDiv1');
}


function fn_loadCreditCard(custCrcId, custOriCrcNo, custCrcNo, codeName1, custCrcOwner, custCrcExpr, bankName, custCrcBankId, codeName){
	
	$("#txtRentPayCRCNo") .val(custCrcNo);
	$("#txtRentPayCRCType").val(codeName1);
	$("#txtRentPayCRCName").val(custCrcOwner);
	$("#txtRentPayCRCExpiry").val(custCrcExpr);
	$("#txtRentPayCRCBank").val(bankName);
	$("#txtRentPayCRCCardType").val(codeName);
	$("#_custOriCrcNo").val(custOriCrcNo);
	
}



function fn_doAddNewBank_Click(){
    
    var _custId; 
    if($('#paybyCk').is(':checked')){
        _custId = $("#hiddenThirdPartyID").val();
    }else{
        _custId = $("#txtThirdPartyID").val();
    }
    Common.popupDiv('/sales/customer/customerAddBankAccountPop.do', {custId:_custId}, null , true ,'_AddNewBankDiv1');
}



function fn_doSelectBank_Click(){
    
    var _custId; 
    if($('#paybyCk').is(':checked')){
        _custId = $("#hiddenThirdPartyID").val();
    }else{
        _custId = $("#txtThirdPartyID").val();
    }

    //Common.popupDiv("/sales/customer/customer/customerAddBankAccountPop.do", {custId : _custId}, null, true ,'_SelectCardDiv1');
    Common.popupDiv("/sales/customer/customerBankAccountSearchPop.do", {custId : _custId, callPrgm : "ORD_REGISTER_BANK_ACC"});
}

function fn_loadBankAccountPop(bankAccId) {
//  fn_clearRentPaySetDD();

  fn_loadBankAccount(bankAccId);
  
  $('#sctDirectDebit').removeClass("blind");

  if(!FormUtil.IsValidBankAccount($('#hiddenRentPayBankAccID').val(), $('#txtRentPayBankAccNo').val())) {
//      fn_clearRentPaySetDD();
      $('#sctDirectDebit').removeClass("blind");
      Common.alert("Invalid Bank Account" + DEFAULT_DELIMITER + "<b>Invalid account for auto debit.</b>");
  }
}

function fn_loadBankAccount(bankAccId) {
  console.log("fn_loadBankAccount START");
  
  Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {getparam : bankAccId}, function(rsltInfo) {

      if(rsltInfo != null) {
          console.log("fn_loadBankAccount Setting");
          
          $("#hiddenRentPayBankAccID").val(rsltInfo.custAccId);
          $("#txtRentPayBankAccNo").val(rsltInfo.custAccNo);
//          $("#rentPayBankAccNoEncrypt").val(rsltInfo.custEncryptAccNo);
          $("#txtRentPayBankAccType").val(rsltInfo.codeName);
          $("#txtRentPayBankAccName ").val(rsltInfo.custAccOwner);
          $("#txtRentPayBankAccBankBranch").val(rsltInfo.custAccBankBrnch);
          $("#hiddenAccBankId").val(rsltInfo.custAccBankId);
          $("#txtRentPayBankAccBank").val(rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
      }
  });
}

function fn_loadBankCard(){
    
    
}


function fn_custResult(item){
	console.log(item);
	
    $("#txtThirdPartyNRIC").val(item.nric);
	$("#txtThirdPartyName").val(item.name);
	$("#txtThirdPartyType").val(item.codeName1);
	$("#txtThirdPartyID").val(item.custId);
	
	
}



function fn_createEvent(objId, eventType) {
    var e = jQuery.Event(eventType);
    $('#'+objId).trigger(e);
}


function fn_doSave(){
	

	
	if(fn_ValidRequiredField()){
	    fn_setSaveForm();	
	}
	
}


function fn_setSaveForm(){
	
	var defaultDate  ="01/01/1900";
	
	var _bankID =0;
	var _custCRCID=0;
	var _custAccID=0;
	var _issuedNRIC=0;
	
	if($("#cmbRentPaymode").val()  == 131 ){
		_bankID = resulresultCardInfo.custAccId ;  
		_custCRCID = resulresultCardInfo.custCrcId;
	}else if($("#cmbRentPaymode").val()  == 132 ){
		 _bankID = resultBankAccInfo.custAccBankId;
	}
	
	if($("#txtRentPayIC").val() !="" ){
		if( $('#paybyCk').is(':checked')){
			_issuedNRIC =	$("#txtRentPayIC").val();
		}else {
			_issuedNRIC = vmrOrderResultObj.orderInfo.custNric;
		}
	}
	
	var rentalChannelSaveForm ={
			salesOrderID:'${srvCntrctOrdId}' ,
		    modeID:$("#cmbRentPaymode").val(),
		    custCRCID:_custCRCID,
		    bankID:_bankID,
		    custAccID :  _custAccID,
		    ddApplyDate :$("#dpApplyDate").val()!= ""?$("#dpApplyDate").val():defaultDate,
		    ddSubmitDate:$("#dpSubmitDate").val() != "" ?$("#dpSubmitDate").val()  : defaultDate,
		    ddStartDate:$("#dpStartDate").val() != ""?$("#dpStartDate").val()  : defaultDate,
		    ddRejectDate:$("#dpRejectDate").val() != ""?$("#dpRejectDate").val()  : defaultDate,
		    statusCodeID:1,
		    is3rdParty:$('#paybyCk').is(':checked')?1 : 0 ,
		    customerID:$('#paybyCk').is(':checked')?$("#hiddenThirdPartyID").val() :$("#txtThirdPartyID").val()  , 
		    editTypeID:0,     // what is this?
		    nRICOld:$("#txtRentPayIC").val()!=""?$("#txtRentPayIC").val()   : "" ,
		    failReasonID:$('#rejectChbox').is(':checked')?$("#cmbRentPaymode").val()  : 0,
		    issuedNRIC:_issuedNRIC,
		    aeonConvert:false,    // What is this?
		    remark :  "",     //remark 없음
		    payTerm : $("#cmbPayTerm").val(),
		    serviceContractID :  '${srvCntrctId}'  
		     
	};
	
   Common.ajax("POST", "/sales/membershipRentalChannel/insertRentalChannel.do", rentalChannelSaveForm, function(result) {
	   
          Common.alert(result.message);
          fn_selectListAjax();

//         $("# _PayChannelDiv1").remove();
          
          
      }, function(jqXHR, textStatus, errorThrown) {
          Common.alert("실패하였습니다.");
          console.log("실패하였습니다.");
          console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
          
          alert(jqXHR.responseJSON.message);
          console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
          
      });
  
	   
	console.log(rentalChannelSaveForm);
}


function fn_ValidRequiredField(){
	
	var   rV=true;
	var   rMessage="";
	
	
	   
    /********************/
    /*    paybyCk     */
    /********************/
	
	if( $('#paybyCk').is(':checked')){
		if($("#txtRentPayIC").val() =="" ){
			rV = false;
		    rMessage += "* Please select the third party.<br />";
		}
	}
	
	
	
	/********************/
	/*    cmbRentPaymode     */
	/********************/
//	var idx    = $("#cmbRentPaymode").val();

	if ($("#cmbRentPaymode").val() == "" ){
		rV = false;
        rMessage += "* Please select the rental paymode.<br />";
//        return false;
        
    } else {
    	 if ($("#cmbRentPaymode").val() == "131") {              //Credit Car
    		 console.log(" 131  CreditCredit valid  start...===>");
    	 
    	     if( null  == resulresultCardInfo){
    	    	   rV = false;
                   rMessage += "* Please select a credit card.<br />";
    	     } 
    		 
             
             console.log(" resulresultCardInfo.custCrcId ["+resulresultCardInfo.custCrcId +"]");
             console.log(" resulresultCardInfo.custCrcBankId["+resulresultCardInfo.custCrcBankId+"]");
             
    		  
	    		 if (resulresultCardInfo.custCrcId  ==""   ||  resulresultCardInfo.custCrcId == null  ||  resulresultCardInfo.custCrcId == 0 ) {
	    			   rV = false;
		               rMessage += "* Please select a credit card.<br />";
	             }else {
	                 if (resulresultCardInfo.custCrcBankId  ==""  || resulresultCardInfo.custCrcBankId == null || resulresultCardInfo.custCrcBankId ==0 )   {
	                	 rV = false;
	                     rMessage += "* Invalid credit card issue bank.<br />";
	                 }
	             }
    		 
	    		 
	    	 console.log(" 131  Direct Debit  valid  end ...===>");
    		 
    	 }else if($("#cmbRentPaymode").val() == "132"){       //Direct Debit
    		 
    		 console.log(" 132  Direct Debit  valid  start...===>");
    	     if( null  == resultBankAccInfo){
                 rV = false;
                 rMessage += "* Please select a credit card.<br />";
           } 
    	     
    		 console.log(" resultBankAccInfo.custAccId["+resultBankAccInfo.custAccId+"]");
    		 console.log(" resultBankAccInfo.custAccBankId["+resultBankAccInfo.custAccBankId+"]");
    		
    		 if (resultBankAccInfo.custAccId   ==""   ||  resultBankAccInfo.custAccId == null  ||  resultBankAccInfo.custAccId  == 0 ) {
                 rV = false;
                 rMessage += "* Please select a bank account.<br />";
	         }else {
	               if (resultBankAccInfo.custAccBankId  ==""  || resultBankAccInfo.custAccBankId == null || resultBankAccInfo.custAccBankId ==0 )   {
	                   rV = false;
	                   rMessage += "* Invalid credit card issue bank.<br />";
	               }
	         }
    		 
    		 console.log(" 132  Direct Debit  valid  end ...===>");
    	 }
    }
	

    /********************/
    /*    dpApplyDate            */ 
    /********************/
    console.log(" dpApplyDate valid  start...===>");
    console.log(" dpApplyDate ["+FormUtil.isEmpty($('#dpApplyDate').val())+"] val["+$('#dpApplyDate').val()+"]");
   if(FormUtil.isEmpty($('#dpApplyDate').val())) {
		   rV = false;
		   rMessage += "* Apply date is required.<br />";
     
    }else {
    	
        console.log("{}"+$('#dpSubmitDate').val());
    	if($('#dpSubmitDate').val()  != ""){
    		
            
    		var  dpSubmitDateCVTArry =   $('#dpSubmitDate').val().split("/");
    		var  dpSubmitDateCVT = dpSubmitDateCVTArry[2]+""+dpSubmitDateCVTArry[1]+""+dpSubmitDateCVTArry[0]; 
    		var  dpApplyDateCVTArry =   $('#dpApplyDate').val().split("/");
            var  dpApplyDateCVT = dpApplyDateCVTArry[2]+""+dpApplyDateCVTArry[1]+""+dpApplyDateCVTArry[0]; 
            

            console.log(" dpSubmitDateCVT ["+dpSubmitDateCVT+"]");
            console.log(" dpApplyDateCVT["+dpApplyDateCVT+"]");
            

            if( parseInt(dpSubmitDateCVT,10 )  < parseInt(dpApplyDateCVT,10 )){
            	rV = false;
            	rMessage += "* Submit date must later than apply date.<br />";
            }

            console.log(" dpApplyDate valid  end...===>");
    	}  
    }
    
   /********************/
   /*    dpStartDate            */ 
   /********************/
   if( $('#dpSubmitDate').val() !="" ){
	   
	   if( $('#dpSubmitDate').val() ==""){
		   rV = false;
		   rMessage += "* Submit date is required.<br />";
		   
	   } else{
		   
           console.log(" dpStartDate valid  start...===>");
           
           
		   var  dpStartDateCVTArry =   $('#dpStartDate').val().split("/");
           var  dpStartDateCVT = dpStartDateCVTArry[2]+""+dpStartDateCVTArry[1]+""+dpStartDateCVTArry[0]; 
           
           var  dpSubmitDateCVTArry =   $('#dpSubmitDate').val().split("/");
           var  dpSubmitDateCVT = dpSubmitDateCVTArry[2]+""+dpSubmitDateCVTArry[1]+""+dpSubmitDateCVTArry[0]; 


           console.log(" dpStartDateCVT ["+dpStartDateCVT+"]");
           console.log(" dpSubmitDateCVT["+dpSubmitDateCVT+"]");
           
           if( parseInt(dpStartDateCVT,10 )  < parseInt(dpSubmitDateCVT,10 )){
               rV = false;
               rMessage += "*Start date must later than submit date.<br />";
           }
           
           console.log(" dpStartDate valid  end...===>");
       }
   }



   /********************/
   /*    rejectChbox            */ 
   /********************/
    if( $('#rejectChbox').is(':checked')){
    	
    	  if( $('#dpRejectDate').val() =="" ){
    		  
    		  rV = false;
    		  rMessage += "* Reject date is required.<br />";
              
    	  }else {
    		  if($('#dpSubmitDate').val() ==""){
    			  rV = false;
    			  rMessage += "* Submit date is required.<br />";
    		  }else{
    			  

    	            console.log(" dpRejectDate valid  start...===>");
    	            
    			  var  dpRejectDateCVTArry =   $('#dpRejectDate').val().split("/");
    	          var dpRejectDateCVT = dpRejectDateCVTArry[2]+""+dpRejectDateCVTArry[1]+""+dpRejectDateCVTArry[0]; 
    			  var  dpSubmitDateCVTArry =   $('#dpSubmitDate').val().split("/");
    	          var  dpSubmitDateCVT = dpSubmitDateCVTArry[2]+""+dpSubmitDateCVTArry[1]+""+dpSubmitDateCVTArry[0]; 

                  console.log(" dpRejectDateCVT ["+dpRejectDateCVT+"]");
                  console.log(" dpSubmitDateCVT["+dpSubmitDateCVT+"]");
                  
    	          if( parseInt(dpRejectDateCVT,10 )  < parseInt(dpSubmitDateCVT,10 )){
    	               rV = false;
    	               rMessage += "*Reject date must later than submit date.<br />";
    	          }
    	          
    	          console.log(" dpRejectDate valid  end...===>");
    		  }
    	  }
    	  if (idx <= -1  ){
    	        rV = false;
    	        rMessage += "* Reject select the reject reason.<br />";
    	 }
    }
   
   
	if( rV==false)
        Common.alert("Rent Pay Setting Update Summary "+DEFAULT_DELIMITER + rMessage);

	
	return rV;
}



function  fn_DisableControl(){
	    
	    $("#txtThirdPartyID").attr("disabled" ,"disabled");
	    $("#paybyCk").attr("disabled" ,"disabled");
	    $("#btnAddThirdParty").attr("disabled" ,"disabled");
	    $("#btnSelectCRC").attr("disabled" ,"disabled");
	    $("#btnAddBankAccount").attr("disabled" ,"disabled");
	    $("#btnSelectBankAccount").attr("disabled" ,"disabled");
	    $("#cmbRentPaymode").attr("disabled" ,"disabled");
	    $("#txtRentPayIC").attr("disabled" ,"disabled");
	    $("#dpApplyDate").attr("disabled" ,"disabled");
	    $("#dpSubmitDate").attr("disabled" ,"disabled");
	    $("#dpStartDate").attr("disabled" ,"disabled");

        $("#btnReject").attr("disabled" ,"disabled");
	    $("#cmbPayTerm").attr("disabled" ,"disabled");
	    $("#cmbRejectReason").attr("disabled" ,"disabled");
	    $("#save_bt").attr("disabled" ,"disabled");
	    
}


//function fn_loadCreditCard2(){
//	$("#_close1").click();
//}

</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->




<form  id='hForm' name='hForm'>
<div style="display:none"> 
    <input type="text" name='hiddenThirdPartyID' id='hiddenThirdPartyID' >
    <input type="text" name='custOriCrcNo' id='_custOriCrcNo' >
    
    
</div>
</form>


<header class="pop_header"><!-- pop_header start -->
<h1>Edit - Rental Membership Payment Channel</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
	<li><a href="#" class="on">Membership Info</a></li>
	<li><a href="#">Order Info</a></li>
</ul>




<!-- inc_membershipInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mRMerInfo.do'/> 
<!--  inc_membershipInfotab  end...-->


<!-- inc_orderInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membershipRental/inc_mROrderInfo.do'/> 
<!--  inc_orderInfo  end...-->


</section><!-- tap_wrap end -->





<section class="search_table"><!-- search_table start -->
	<form action="#" method="post">
	
	<aside class="title_line"><!-- title_line start -->
	<h2>Payment Channel</h2>
	<ul class="right_btns mb10">
	    <li><p class="btn_blue2"><a href="#"  onclick="fn_doViewHistory_Click()">View History</a></p></li>
	</ul>
	</aside><!-- title_line end -->
	
	
	
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:180px" />
	    <col style="width:*" />
	</colgroup>
	<tbody>
	<tr>
	    <th scope="row">Pay By Third Party</th>
	    <td>
	    <label><input type="checkbox"  id='paybyCk' name='paybyCk' onchange="fn_isPanelThirdPartyEvt(this)" /><span></span></label>
	    </td>
	</tr>
	</tbody>
	</table><!-- table end -->
	</form>
</section><!-- search_table end -->


<form action="#" method="post">
	
<section class="search_table"><!-- search_table start -->
	
	
	<div  id="Third_Party">
	<aside class="title_line"><!-- title_line start -->
    <h2>Third Party</h2>
    <ul class="right_btns mb10">
        <li><p class="btn_blue2"><a href="#"  id='btnAddThirdParty'  onclick="javascript:fn_doAddThirdParty_Click()">Add New Third Party</a></p></li>
    </ul>
    </aside><!-- title_line end -->
    
	
	
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:120px" />
	    <col style="width:*" />
	    <col style="width:150px" />
	    <col style="width:*" />
	</colgroup>
	<tbody>
	    <th scope="row">Customer ID<span class="must">*</span></th>
	    <td><input type="text" title="" placeholder="Third Party ID" class=""  id="txtThirdPartyID" name="txtThirdPartyID" /><a href="#"  onclick="javascript:fn_doCustSearch_Click()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	    <th scope="row">Type</th>
	    <td><input type="text" title="" placeholder="Customer Type" class="w100p"  readonly  id='txtThirdPartyType' name='txtThirdPartyType' /></td>
	</tr>
	<tr>
	    <th scope="row">Name</th>
	    <td><input type="text" title="" placeholder="Customer Name" class="w100p" readonly id='txtThirdPartyName' name='txtThirdPartyName'  /></td>
	    <th scope="row">NRIC / Company No.</th>
	    <td><input type="text" title="" placeholder="NRIC / Company No" class="w100p" readonly id='txtThirdPartyNRIC' name='txtThirdPartyNRIC' /></td>
	</tr>
	</tbody>
	</table><!-- table end -->
</div>
</section>


<section class="search_table"><!-- search_table start -->
<table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:120px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Rental Paymode<span class="must">*</span></th>
        <td>
        <select class="w100p"  id='cmbRentPaymode' name='cmbRentPaymode'  >
        </select>
        </td>
        <th scope="row">NRIC on DD/Passbook</th>
        <td><input type="text" title="" placeholder="" class="w100p"  id='txtRentPayIC' name='txtRentPayIC' /></td>
    </tr>
    </tbody>
    </table><!-- table end -->
</section>
    

<section class="search_table"><!-- search_table start --> 
<div  id="Credit_Card">
<aside class="title_line"><!-- title_line start -->
<h2>Credit Card</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_blue2"><a href="#"  id ='btnAddCRC' onclick="javascript:fn_doAddNewCard_Click()">Add New Credit Card</a></p></li>
    <li><p class="btn_blue2"><a href="#" id='btnSelectCRC'  onclick="javascript:fn_doSelectCard_Click()" >Select Another Credit Card</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr> 

    <th scope="row">Credit Card Number<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Credit Card Number" readonly class="w100p" id='txtRentPayCRCNo' name='txtRentPayCRCNo' /></td>
    <th scope="row">Credit Card Type</th>
    <td><input type="text" title="" placeholder= " Credit Card Type" readonly class="w100p" id='txtRentPayCRCType' name='txtRentPayCRCType' /></td>
</tr>
<tr>
    <th scope="row">Name On Card</th>
    <td><input type="text" title="" placeholder="Name On Card" readonly class="w100p" id='txtRentPayCRCName' name='txtRentPayCRCName' /></td>
    <th scope="row">Expiry</th>
    <td><input type="text" title="" placeholder="Credit Card Expiry "  readonly class="w100p" id='txtRentPayCRCExpiry' name='txtRentPayCRCExpiry' /></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td><input type="text" title="Issue Ban " placeholder="" readonly class="w100p" id='txtRentPayCRCBank'  /></td>
    <th scope="row">Card Type</th>
    <td><input type="text" title="" placeholder="Card Type"  readonly class="w100p" id='txtRentPayCRCCardType' /></td>
</tr>
</tbody>
</table><!-- table end -->
</div>
</section>


<section class="search_table"><!-- search_table start --> 
<div id="Direct_Debit">
        <aside class="title_line"><!-- title_line start -->
		<h2>Direct Debit</h2>
		</aside><!-- title_line end -->
		
		<ul class="right_btns mb10">
		    <li><p class="btn_blue2"><a href="#"  id='btnAddBankAccount' onclick ="javascript:fn_doAddNewBank_Click()" >Add New Bank Account</a></p></li>
		    <li><p class="btn_blue2"><a href="#"  id ='btnSelectBankAccount' onclick ="javascript:fn_doSelectBank_Click()">Select Another Bank Account</a></p></li>
		</ul>
		
		
		
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:140px" />
		    <col style="width:*" />
		    <col style="width:160px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		
		<tr>
		    <th scope="row">Account Number<span class="must">*</span></th>
		    <td><input type="text" title="" placeholder= "Bank Account Number " readonly class="w100p"  id='txtRentPayBankAccNo' name='txtRentPayBankAccNo'/>
		          <input id="hiddenRentPayBankAccID" name="hiddenRentPayBankAccID" type="hidden" /></td>
		    </td>
		    <th scope="row">Account Type</th>
		    <td><input type="text" title="" placeholder="Bank Account Type" readonly class="w100p"  id='txtRentPayBankAccType'  name='txtRentPayBankAccType' /></td>
		</tr>
		<tr>
		    <th scope="row">Account Holder</th>
		    <td><input type="text" title="" placeholder=" Bank Account Holder " readonly class="w100p" id='txtRentPayBankAccName' /></td>
		    <th scope="row">Issue Bank Branch</th>
		    <td><input type="text" title="" placeholder="Issue Bank Branch" readonly  class="w100p"  id='txtRentPayBankAccBankBranch' /></td>
		</tr>
		<tr>
		    <th scope="row">Issue Bank</th>
		    <td colspan="3"><input type="text" title="" readonly  placeholder="Issue Bank" class="w100p"  id='txtRentPayBankAccBank'  /></td>
		</tr>
		</tbody>
		</table><!-- table end -->
<div>
</section>

<section class="search_table"><!-- search_table start --> 
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Apply Date<span class="must">*</span></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id='dpApplyDate' name='dpApplyDate' /></td>
    <th scope="row">Submit Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id='dpSubmitDate' name='dpSubmitDate'/></td>
</tr>
<tr>
    <th scope="row">Start Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id='dpStartDate' name='dpStartDate' /></td>
    <td><label><input type="checkbox" id='rejectChbox'   onclick="fn_rejectCkEvt(this)"/><span>Reject Date</span></label></td>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id='dpRejectDate' name='dpRejectDate'/></td>
</tr>
<tr>
    <th scope="row">Pay Term</th>
    <td>
    <select class="w100p" id='cmbPayTerm' name ='cmbPayTerm'>
        <option value="0" selected>No Term</option>
        <option value="1">1 Month</option>
        <option value="2">2 Month</option>
        <option value="3">3 Month</option>
        <option value="4">4 Month</option>
        <option value="5">5 Month</option>
        <option value="6">6 Month</option>
    </select>
    </td>
    <th scope="row">Reject Reason</th>
    <td>
    <select class="disabled w100p" disabled="disabled" id='cmbRejectReason'  name='cmbRejectReason'>
     
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#"  id='save_bt' onclick="javascript:fn_doSave()" >SAVE</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->



<script>
        
          var ord_id;
          var moption = {
                    srvCntrctId :'${srvCntrctId}',
                    callbackFun : 'fn_setMRentalOrderInfoData(vmrMemResultObj.srvCntrctOrdId)',
                    showViewLeder : false,
                    showQuotationInfo:false
          };                     
         
         ord_id = fn_setMRentalMembershipInfoData(moption);
          
          
         if(ord_id !=""){
        	 setTimeout(function(){ 
        		 $("#txtThirdPartyID").val(vmrOrderResultObj.orderInfo.custId);
        	 }, 2000);
         }
        	 
          
          
          
</script>
