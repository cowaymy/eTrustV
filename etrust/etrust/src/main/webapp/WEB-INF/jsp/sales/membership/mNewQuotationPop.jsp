
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<style>

/* 커스텀 행 스타일 */
.my-row-style {
    background:#FFB2D9;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javaScript" language="javascript">

var oListGridID;
var bsHistoryGridID;

var resultBasicObject;
var resultSrvconfigObject;


$(document).ready(function(){
    
    createAUIGridHList();
    createAUIGridOList();
    
    $("#rbt").attr("style","display:none");
    $("#ORD_NO_RESULT").attr("style","display:none");
    
    
    $("#ORD_NO").keydown(function(key)  {
  	        if (key.keyCode == 13) {
  	        	fn_doConfirm();
  	        }
     });
    
});




function fn_doConfirm (){
    Common.ajax("GET", "/sales/membership/selectMembershipFreeConF", $("#sForm").serialize(), function(result) {
         console.log( result);
         
         if(result.length == 0)  {
            
             $("#cbt").attr("style","display:inline");
             $("#ORD_NO").attr("style","display:inline");
             $("#sbt").attr("style","display:inline");
             $("#rbt").attr("style","display:none");
             $("#ORD_NO_RESULT").attr("style","display:none");
             
             $("#resultcontens").attr("style","display:none");
              
             Common.alert(" No order found or this order is not under complete status. ");
             return ;
             
         }else{
             
        	 
        	 if(fn_isActiveMembershipQuotationInfoByOrderNo()){
        		 return ;
        	 }
        	 
             $("#ORD_ID").val( result[0].ordId);
             $("#ORD_NO_RESULT").val( result[0].ordNo);
             
             $("#cbt").attr("style","display:none");
             $("#ORD_NO").attr("style","display:none");
             $("#sbt").attr("style","display:none");

             $("#rbt").attr("style","display:inline");
             $("#ORD_NO_RESULT").attr("style","display:inline");
             $("#resultcontens").attr("style","display:inline");
             
             
             fn_getDataInfo();
             fn_outspro();
             
         }
   });
}



function  fn_isActiveMembershipQuotationInfoByOrderNo(){
	var rtnVAL= false;
	 Common.ajaxSync("GET", "/sales/membership/mActiveQuoOrder", {ORD_NO: $("#ORD_NO").val()}, function(result) {
         console.log( result);
        
         if(result.length > 0 ){
        	 rtnVAL =true;
        	 Common.alert(" <b>This order already has an active quotation.<br />Quotation number : [" + result[0].srvMemQuotNo +"]</b>");
        	 return true; 
         }
    });
	 
	 return rtnVAL;
}

function fn_getDataInfo (){
    Common.ajax("GET", "/sales/membership/selectMembershipFreeDataInfo", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         setText(result);
         setPackgCombo();
    });
 }



function fn_outspro (){
    Common.ajax("GET", "/sales/membership/callOutOutsProcedure", $("#getDataForm").serialize(), function(result) {
        console.log(result);
        
        if(result.outSuts.length >0 ){
        	$("#ordoutstanding").html(result.outSuts[0].ordOtstnd);
        	$("#asoutstanding").html(result.outSuts[0].asOtstnd);
        }
    });
 }
 

function setText(result){
	
	resultBasicObject = result.basic;
	resultSrvconfigObject = result.srvconfig;
	
	
	$("#ordNo").html(result.basic.ordNo);
    $("#ordDt").html(result.basic.ordDt);
    $("#ORD_DATE").html(result.basic.orgOrdDt);
    $("#InstallmentPeriod").html(result.basic.InstallmentPeriod);
    $("#ordStusName").html(result.basic.ordStusName);
    $("#rentalStus").html(result.basic.rentalStus);
    $("#appTypeDesc").html(result.basic.appTypeDesc);
    $("#ordRefNo").html(result.basic.ordRefNo);
    $("#stockCode").html(result.basic.stockCode);
    $("#stockDesc").html(result.basic.stockDesc);
    $("#custId").html(result.basic.custId);
    $("#custName").html(result.basic.custName);
    $("#custNric").html(result.basic.custNric);
    $("#custType").html(result.basic.custType);
    
    $("#CUST_ID").val( result.basic.custId);
    $("#STOCK_ID").val( result.basic.stockId);
    
    $("#SAVE_SRV_CONFIG_ID").val(result.srvconfig.configId);
    $("#coolingOffPeriod").html(result.basic.coolOffPriod);
      
    
   
    
    var address  =  result.installation.instAddr1 +" "+  
                            result.installation.instAddr2 +" "+
                            result.installation.instAddr3 +" "+
                            result.installation.instPostCode +" "+
                            result.installation.instArea+" "+ 
                            result.installation.instState +" "+ 
                            result.installation. instCnty;
                        
    $("#address").html(address);
    
    $("#installNo").html(result.installation.lastInstallNo);
    $("#installDate").html(result.installation.lastInstallDt);
    
    
    if(result.basic.appTypeCode =="INS"){
            $("#InstallmentPeriod").html(result.basic.InstallmentPeriod);
    }else{
            $("#InstallmentPeriod").html("-");
    }
    
    if(result.basic.appTypeCode =="REN"){
            $("#rentalStus").html(result.basic.rentalStus );
    }else{
            $("#rentalStus").html("-");
    }
    
    $("#TO_YYYYMM").val( result.srvconfig.add12todate);
    $("#EX_YYYYMM").val( result.srvconfig.add12expiredate);
    
    $("#expire").html( result.srvconfig.lastSrvMemExprDate);
    
   // $("#CVT_LAST_SRV_MEM_EXPR_DATE").val(result.srvconfig.cvtLastSrvMemExprDate);
  //  $("#CVT_NOW_DATE").val(result.srvconfig.cvtNowDate);
    
    
    
    fn_newGetExpDate(result);
    fn_setTerm();
    fn_getDataCPerson();
    fn_getDatabsHistory();
    fn_getDatabsOList();
}



function  fn_goCustSearch(){
    Common.alert(" 차후 오더 조회  공통팝업 호출[미 개발] !!!  ");
}


function fn_doReset() {
    $("#sForm").attr({"target" :"_self" , "action" : "/sales/membership/mNewQuotation.do" }).submit();
}



function fn_setTerm(){
	$("#term").html();
	$("#isCharge").html();
}




function  fn_goContactPersonPop(){
    Common.popupDiv("/sales/membership/memberFreeContactPop.do");
}


function  fn_goNewContactPersonPop(){
    Common.popupDiv("/sales/membership/memberFreeNewContactPop.do");
}




function fn_addContactPersonInfo(objInfo){
          console.log(objInfo);       
          
          fn_doClearPersion();
          
          $("#name").html(objInfo.name);
          $("#gender").html(objInfo.gender);
          $("#nric").html(objInfo.nric);
          $("#codename1").html(objInfo.codename1);
          $("#telM1").html(objInfo.telM1);
          $("#telO").html(objInfo.telO);
          $("#telR").html(objInfo.telR);
          $("#telf").html(objInfo.telf);
          $("#email").html(objInfo.email);
          $("#SAVE_CUST_CNTC_ID").val(objInfo.custCntcId);
          
          
}


function fn_doClearPersion(){
    
    $("#name").html("");
    $("#gender").html("");
    $("#nric").html("");
    $("#codename1").html("");
    $("#telM1").html("");
    $("#telO").html("");
    $("#telR").html("");
    $("#telf").html("");
    $("#email").html("");
    $("#SAVE_CUST_CNTC_ID").val("");
}
 
 
 

/*cPerson*/ 
function fn_getDataCPerson (){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_cPerson", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         //custCntc_Id     custInitial    codeName     nameName    dob    gender     raceId     codename1     telM1     telM2     telO     telR     telf     nric     pos     email     dept     stusCodeId     updUserId     updDt     idOld     dcm     crtUserId     crtDt   
        //set 1ros
        
        fn_doClearPersion();
         
        $("#name").html(result[0].name);
        $("#gender").html(result[0].gender);
        $("#nric").html(result[0].nric);
        $("#codename1").html(result[0].codename1);
        $("#telM1").html(result[0].telM1);
        $("#telO").html(result[0].telO);
        $("#telR").html(result[0].telR);
        $("#telf").html(result[0].telf);
        $("#email").html(result[0].email);
        $("#SAVE_CUST_CNTC_ID").val(result[0].custCntcId);
        
         
    });
  }
  


/*bs_history*/ 
function fn_getDatabsHistory(){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_bs", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         
         AUIGrid.setGridData(bsHistoryGridID, result);
         AUIGrid.resize(bsHistoryGridID, 1120,250);  
         
    });
 }
 
 

/*newGetExpDate*/ 
function fn_newGetExpDate(old_result){
    Common.ajax("GET", "/sales/membership/newGetExpDate", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         
         if(result.expDate.expint <= 0){
        	 $("#HiddenIsCharge").val(0);
        	 $("#isCharge").html("No");
        	 $("#term").html("<font color='green'> Under membership </font>");
        	 
         }else if(result.expDate.expint > 0 && old_result.basic.coolOffPriod >= result.expDate.expint){
        	 
        	   $("#HiddenIsCharge").val(0);
               $("#isCharge").html("No");
               $("#term").html("<font color='brown'> Under cooling off period </font>");
               
         }else{
        	  $("#HiddenIsCharge").val(1);
              $("#isCharge").html("YES");
              $("#term").html("<font color='red'> Passed cooling off period </font>");
         }
         
    });
 }
 
/*oList*/ 
function fn_getDatabsOList (){
   Common.ajax("GET", "/sales/membership/newOListuotationList", $("#getDataForm").serialize(), function(result) {
        console.log( result);
        
        AUIGrid.setGridData(oListGridID, result);
        AUIGrid.resize(oListGridID, 1120,250);  
        
        if( $("#HiddenIsCharge").val() =="0"){ return ;}
        
        changeRowStyleFunction();
        
      
   });
 }
 

function setPackgCombo(){
    doGetCombo('/sales/membership/getSrvMemCode', '', '','cTPackage', 'S' , 'f_multiCombo');            // Customer Type Combo Box
}



function f_multiCombo(){
	
	 $(function() {
	 
	         $('#cTPackage').change(function() {
	        	 $("#cYear").removeAttr("disabled");
	         });
	         
	        $('#cYear').change(function() {
	        	
	        	 //set clear 
	        	 fn_SubscriptionYear_initEvt();
	            
	        	 $("#SELPACKAGE_ID").val($('#cTPackage').val());
	             $("#DUR").val($(this).val().trim());
	             
	             //set getMembershipPackageInfo
                 fn_getMembershipPackageInfo($(this).val().trim());
	             
	           
	             // set Filter Price
	             // fn_getFilterCharge();
	             
	            
	             
	            
	             
	         });
     });
	
}


function f_multiCombo2(){
     $(function() {
    	 
                $('#cPromotionpac').change(function() {
                	
                	$('#txtPackagePrice').html($('#hiddenPacOriPrice').val());
                	
                	if($(this).val().trim() >0)  {
                		
	                		var isProc  =true;
	                		
	                		if($(this).val() == 542){
	                			
	                			  var CVT_LAST_SRV_MEM_EXPR_DATE  =  parseInt(resultSrvconfigObject.cvtLastSrvMemExprDate,10);  
	                              var CVT_NOW_DATE  =  parseInt(resultSrvconfigObject.cvtNowDate ,10);
	                              
	                              if (CVT_LAST_SRV_MEM_EXPR_DATE >= CVT_NOW_DATE){
	                            	  
	                            	  isProc =true;
	                            	  
	                              }else{
	                            	  isProc =false;
	                              }
	                		}
	                		
	                		
	                		if(isProc){
	                			
	                			 var  cPromotion =0;
	                		     if(null == $(this).val().trim() || ""== $(this).val().trim() ) {
	                		         cPromotion =0;
	                		     } else {cPromotion = $(this).val().trim();}
	                		     
	                		     $("#PROMO_ID").val($(this).val().trim());
	                		     
	                			  Common.ajax("GET", "/sales/membership/getPromoPricePercent", $("#getDataForm").serialize(), function(result) {
	                                 console.log( result);
	                                 
	                                 if(result.length>0){
	                                        var oriprice      =   parseInt($("#hiddenPacOriPrice").val(),10) ;
	                                        var promoPrcPrcnt =   parseInt(result[0].promoPrcPrcnt,10) ;
	                                        $("#txtPackagePrice").html( Math.floor( (oriprice * ((100 - promoPrcPrcnt) / 100)) ));
	                                 }
	                            });
	                			
	                		}else {
	                			Common.alert(   "Promotion Not Entitled"+DEFAULT_DELIMITER+" This order is not entitled in this promotion.");
	                		}
                	}
                	
                	
                    // set Filter Price
                	//fn_getFilterCharge();
         });
     });
}





function  f_multiCombo3(){

    
    $('#cPromo').change(function() {
        fn_LoadMembershipFilter($(this).val().trim());
    });
    
}



/*fn_getMembershipPackageInfo*/ 
function fn_getMembershipPackageInfo(_id){
	
    Common.ajax("GET", "/sales/membership/mPackageInfo", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         
         if( result.packageInfo ==null  ||  result.packageInfo ==""){

        	 $("#HiddenHasPackage").val(0);
             $("#txtBSFreq").html("");
             $("#txtPackagePrice").html("0.00");
             $("#hiddenPacOriPrice").val(0);
             
         }else{
        	 
              var   pacYear   =  parseInt($("#DUR").val() ,10) / 12;
              var   pacPrice =  Math.round((result.packageInfo.srvMemItmPrc * pacYear));
              
             
        	   $("#HiddenHasPackage").val(1);
        	   $("#txtBSFreq").html(result.packageInfo.srvMemItmPriod +" month(s)");
        	   $("#hiddentxtBSFreq").val(result.packageInfo.srvMemItmPriod );
        	   
        	   $("#txtPackagePrice").html(pacPrice);
        	   $("#hiddenPacOriPrice").val(pacPrice);
       }
         
         
         if ( $("#HiddenHasFilterCharge") .val() == "1") {
        	 
        	 fn_getFilterCharge(_id);
        	 fn_LoadMembershipPromotion();
             $("#btnViewFilterCharge").attr("style" ,"display:inline");
        	 
         } else{
        	 $("#txtFilterCharge").html("0.00");
         }
         
         $("#packpro").removeAttr("disabled");
         
         
         //set packagePromotion combox 
         fn_PacPromotionCode();
         
    });
 }
 
 
 
function fn_doPackagePro(v){
   if(v.checked){
	   fn_PacPromotionCode();
	   
	   $("#cPromotionpac").removeAttr("disabled");
	   $("#cPromotionpac").attr("class" ,"");
	}else{
		 $("#cPromotionpac").attr("disabled" ,"disabled");
	}
}

function fn_doPromoCombox(v){
	   if(v.checked){
	       
		   $("#cPromo").removeAttr("disabled");
           $("#cPromo").attr("class" ,"");
		   
	    }else{
	        $("#cPromo").attr("disabled" ,"disabled");
	    }
}




function  fn_PacPromotionCode(){
	
	$('#cPromotionpac option').remove();
	
	doGetCombo('/sales/membership/getPromotionCode', '', '','cPromotionpac', 'S' , 'f_multiCombo2');          
	$("#cPromotionpac").removeAttr("disabled");
	
	var  _valid  = true ;
	var  _sVale = $('#cYear').val();
	var  _orderDate  =$('#ORD_DATE').val();
	var _cutOffDate ="20160927";
	
	if(! _valid  || _sVale != 12  || _orderDate <_cutOffDate ) {
		  $("#cPromotionpac option[value='31408']").remove();
	}
	
}





function fn_LoadMembershipPromotion(){

    $('#cPromo option').remove();
	doGetCombo('/sales/membership/getFilterPromotionCode', '', '','cPromo', 'S' , 'f_multiCombo3');            // Customer Type Combo Box
	$("#cPromo").removeAttr("disabled");
	
	
	//cbPromo.Enabled = true;
	
	
	/*
	   
private void LoadMembershipPromotion(int PackageID,int StkID)
{
    ddlPromotion.Items.Clear();
    MembershipManager mm = new MembershipManager();
    List<MembershipPromotionInfo> ls = mm.GetMembershipPromotion(PackageID, StkID);
    if (ls.Count > 0)
    {
        cbPromo.Enabled = true;
        ddlPromotion.DataTextField = "PromoCodeName";
        ddlPromotion.DataValueField = "PromoID";
        ddlPromotion.DataSource = ls;
        ddlPromotion.DataBind();
        ddlPromotion.ClearSelection();
        ddlPromotion.Text = string.Empty;
    }

    //Ben - 2016/09/30 - Validate eligibility for Early Bird Promotion
    MembershipManager oo = new MembershipManager();
    
}
	
	*/
}


 
 
 function   fn_LoadMembershipFilter(_cPromotion){
	 
	 var  cPromotion = _cPromotion;
	 
	 if(null ==cPromotion  || ""== cPromotion ) {
		 cPromotion =0;
	 } 
	 
	 $("#PROMO_ID").val(cPromotion);

	 
	 $("#_editDiv1").remove();
	 $("#_popupDiv").remove();
	 Common.popupDiv("/sales/membership/mFilterChargePop.do" , $("#getDataForm").serializeJSON(), null , true , '_editDiv1');
 }
 
 
 
 function fn_back(){
	 $("#_NewQuotDiv1").remove();
} 



function fn_getFilterCharge(_cPromotion){
	
	   var  cPromotion = _cPromotion;
     
     if(null ==cPromotion  || ""== cPromotion ) {
         cPromotion =0;
     } 
     
    
    $("#PROMO_ID").val(cPromotion);
    
   Common.ajax("GET", "/sales/membership/getFilterCharge", $("#getDataForm").serialize(), function(result) {
	   console.log( "======fn_getFilterCharge========>"); 
	   console.log( result);

        
          if( result.outSuts.length >0 ){
        	     var prc =0 ;
                 for ( i  in  result.outSuts){
                     prc += parseInt( result.outSuts[i].prc,10);
                 }
                 
                console.log(prc);
        	    $("#txtFilterCharge").html(prc);
        	   
           }else{
        	   $("#txtFilterCharge").html("0.00");
           }
        
           if( $("#cPromotionpac").val() > 0){
        	   $("#FCPOPTITLE").val("Filter Charge Details - Promotion Applied");
           }else{
        	  $("#FCPOPTITLE").val("Filter Charge Details - No Promotion"); 
           }
        
        /*
        if (ls.Count > 0)
        {
            RadGrid_FilterCharge.DataSource = ls;
            RadGrid_FilterCharge.DataBind();
            GridFooterItem footer = (GridFooterItem)RadGrid_FilterCharge.MasterTableView.GetItems(GridItemType.Footer)[0];
            string TotalPrice = footer["ChargePrice"].Text.Split(':')[1];
            txtFilterCharge.Text = string.Format("{0:C}", TotalPrice.ToString()).Replace("$", "").Replace(",", "").Replace("RM", "");
        }
        else
        {
            txtFilterCharge.Text = "0.00";
        }
      
        if (PromoID > 0)
        {
        	
        	 
            RadWindow_FilterCharge.Title = "Filter Charge Details - Promotion Applied";
        }
        else
        {
            RadWindow_FilterCharge.Title = "Filter Charge Details - No Promotion";
        }
        
        */
   });
 }

function changeRowStyleFunction() {
	
    // row Styling 함수를 다른 함수로 변경
    AUIGrid.setProp(oListGridID, "rowStyleFunction", function(rowIndex, item) {
    	

        var  lifePeriod = parseInt(item.srvFilterPriod ,10);
        var expInt     = parseInt(item.expint ,10);
         
        if (lifePeriod > 0){
        	
            if(expInt > lifePeriod  ){
            	
                  $("#HiddenHasFilterCharge").val(1);
                  return "my-row-style";
                  
            }else{
            	return "";
            }
            
            /*
             DateTime LastChangeDate = CommonFunction.ConvertDateDMYToMDY(item["FilterLastChange"].Text.Trim());
             DateTime todayDate = CommonFunction.GetFirstDayOfMonth(DateTime.Now.Date);
             
             int expireDateInt = (LastChangeDate.Year * 12) + LastChangeDate.Month;
             int todayDateInt = (todayDate.Year * 12) + todayDate.Month;
             int expInt = todayDateInt - expireDateInt;
             if (expInt > lifePeriod)
             {
                 e.Item.BackColor = System.Drawing.Color.Pink;
                 HiddenField hf = (HiddenField)item.FindControl("HiddenFilterCharge");
                 hf.Value = "1";
                 HiddenHasFilterCharge.Value = "1";
             }
             */
        
        }   
    });
    
    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
    AUIGrid.update(oListGridID);
};




function fn_goSalesConfirm(){
    
       if($("#SALES_PERSON").val() =="") {
                
                Common.alert("Please Key-In Sales Person Code. ");
                return ;
        }
            
            
        Common.ajax("GET", "/sales/membership/paymentColleConfirm", { COLL_MEM_CODE:   $("#SALES_PERSON").val() } , function(result) {
                 console.log( result);
                 
                 if(result.length > 0){
                     
                     $("#SALES_PERSON").val(result[0].memCode);
                     $("#SALES_PERSON_DESC").html(result[0].name);
                     $("#hiddenSalesPersonID").val(result[0].memId);
                     
                     
                     $("#sale_confirmbt").attr("style" ,"display:none");
                     $("#sale_searchbt").attr("style" ,"display:none");
                     $("#sale_resetbt").attr("style" ,"display:inline");
                     $("#SALES_PERSON").attr("class","readonly");
                     
                 }else {
                     
                     $("#SALES_PERSON_DESC").html("");
                     Common.alert(" Unable to find [" +$("#SALES_PERSON").val() +"] in system. <br>  Please ensure you key in the correct member code.   ");
                     return ;
                 }
                 
         });
} 

function  fn_goSalesPerson(){
    
      Common.popupDiv("/sales/membership/paymentCollecter.do?resultFun=S");
} 


function fn_goSalesPersonReset(){

    $("#sale_confirmbt").attr("style" ,"display:inline");
    $("#sale_searchbt").attr("style" ,"display:inline");
    $("#sale_resetbt").attr("style" ,"display:none");
    $("#SALES_PERSON").attr("class","");
    $("#SALES_PERSON_DESC").html("");
    $("#hiddenSalesPersonID").val("");
    
    
}


function fn_doSalesResult(item){
       
    if (typeof (item) != "undefined"){
            
           $("#SALES_PERSON").val(item.memCode);
           $("#SALES_PERSON_DESC").html(item.name);
           $("#hiddenSalesPersonID").val(item.memId);
           $("#sale_confirmbt").attr("style" ,"display:none");
           $("#sale_searchbt").attr("style" ,"display:none");
           $("#sale_resetbt").attr("style" ,"display:inline");
           $("#SALES_PERSON").attr("class","readonly");
           
    }else{
           $("#SALES_PERSON").val("");
           $("#SALES_PERSON_DESC").html("");
           $("#SALES_PERSON").attr("class","");
    }
}


function    fn_SubscriptionYear_initEvt(){
		
	  console.log( "-----fn_SubscriptionYear_initEvt ---- ");

	 $("#cPromotionpac").val();
	 $("#cPromoe").val();
	 $("#cPromotionpac").attr("disabled" ,"disabled");
	 $("#cPromoe").attr("disabled" ,"disabled");
	 $("#packpro").attr("checked",false);
	 $("#cPromoCombox").attr("checked",false);
	 $("#packpro").attr("disabled" ,"disabled");
	 $("#cPromoCombox").attr("disabled" ,"disabled");
	 $("#txtBSFreq").html("");
	 $("#txtPackagePrice").html("-");
	 $("#hiddenPacOriPrice").val("");
	 $("#txtFilterCharge").val("");
	 $("#btnViewFilterCharge").attr("style" ,"display:none");
	
}



function getOrderCurrentBillMonth (){   
   var billMonth =0;
   
   Common.ajaxSync("GET", "/sales/membership/getOrderCurrentBillMonth", { ORD_ID: $("#ORD_ID").val() } , function(result) {
        console.log( result);
        
        if(result.length > 0 ){
	          if(	parseInt( result[0].nowDate ,10) > parseInt( result[0].rentInstDt ,10)   ){
	        	  
	        	  billMonth =61;
	        	  console.log( "==========billMonth============"+billMonth);
	        	  
	        	  return billMonth ;
	        	  
	          }else{
	        	  Common.ajaxSync("GET", "/sales/membership/getOrderCurrentBillMonth",{ ORD_ID: $("#ORD_ID").val() , RENT_INST_DT : 'SYSDATE'  }  , function(_result) {
	        		  
	        		  console.log( "==========2============");
	        		  console.log( _result);
	        		  
	        		  if(_result.length > 0 ){
	        			  billMonth = _result[0].rentInstNo;
	        		  }
	        		 
	        		  console.log( "==========2 end ============["+billMonth+"]");
	        		  
	        	  });
	          }
        }
   });
   
   return billMonth;
 }
 
 
 
function fn_save(){
	
	 var billMonth = getOrderCurrentBillMonth();
	 
	 if(fn_CheckRentalOrder(billMonth)){
		  if (fn_CheckSalesPersonCode()){
			  fn_unconfirmSalesPerson();
		  }
	 }
}



function  fn_validRequiredField_Save(){
	
	var rtnMsg ="";
	var rtnValue=true ;
	
	
	if(FormUtil.checkReqValue($("#cPromotionpac"))){
		   rtnMsg  +="Please select the type of package <br>" ;
	       rtnValue =false; 
	}
	
	
	if(FormUtil.checkReqValue($("#cYear"))){
		rtnMsg += "Please select the subscription year.";
	    rtnValue =false; 
     }else{
    	    if($("#cYear").val() =="12" 
    	    	   && $("#cPromotionpac").val() =="544" ){
    	    	
    	     	  rtnMsg += "Not allow to choose 2 Years Advance Promotion (10% Discount) Promotion. <br>" ;
    	    	 rtnValue =false; 
    	    }
    }
	
	
	if($("#packpro").prop("checked")){
		 
		    var expDate   =  resultSrvconfigObject.cvtLastSrvMemExprDate.substring(0,6) ;
            var nowDate   =  resultSrvconfigObject.cvtNowDate.substring(0,6) ;
  
           
			 if ($("#cPromotionpac").val() == "649"){
							 
						 /* 
						     DateTime ExpDate = DateTime.Parse(hiddenExpireDate.Value);
				             int expiryYear = ExpDate.Year;
				             int curYear = DateTime.Now.Year;
				             int expiryMonth = ExpDate.Month;
				             int curMonth = DateTime.Now.Month;
			
				             int month = ((curYear - expiryYear) * 12) + curMonth - expiryMonth;
						 */
						 var month =  parseInt(nowDate ,10)   -   parseInt(expDate ,10);
						 
						 if(month > 0){
							  rtnMsg += "Membership is expired. Not allow to choose Early Bird Promotion.<br>";
							  rtnValue =false; 
						 }
						 
						 
	         }else if($("#cPromotionpac").val() == "650"){
	        	 
	        	     var month =  parseInt(nowDate ,10)   -   parseInt(expDate ,10);
	        	     
	        	     var  ful_exdate   =resultSrvconfigObject.cvtLastSrvMemExprDate;
	        	     var  ful_nowdate =resultSrvconfigObject.cvtNowDate;
	        	     
	        	    
	        	     if(parseInt(ful_exdate ,10) <  parseInt(ful_nowdate ,10)  ){
	
	        	    	 if( resultBasicObject.stkCategoryId == 54){
	        	    		 if(month > 7 ){
	        	    			  rtnMsg +="Membership is expired over 7 month. Not allow to choose Fresh Expired Promotion.<br>";
	        	    			  rtnValue =false; 
	        	    		 }
	        	    	 } else {
	                        if(month > 5){
	                        	 rtnMsg +="Membership is expired over 5 month. Not allow to choose Fresh Expired Promotion.<br>";
	                             rtnValue =false; 
	                        }
	        	    	 }
	        	    	 
	        	    	 
	        	     }else{
	        	    	 rtnMsg +="Membership is haven't expired. Not allow to choose Fresh Expired Promotion.<br>";
	        	         rtnValue =false; 
	        	     }        	
	       }
	 }
	
	
	
	 if ($("#cPromoCombox").prop("checked")){
           if(FormUtil.checkReqValue($("#packpro"))){
                rtnMsg +="Please select the promotion <br>";
                rtnValue =false; 
           }
      }
      
      
      if( rtnValue ==false ){
          Common.alert("Save Quotation Summary" +DEFAULT_DELIMITER +rtnMsg );
      }
      
      return  rtnValue;
}


function fn_CheckRentalOrder(billMonth){
	
	var rtnMsg ="";
	var rtnValue=true ;
	    
	if(resultBasicObject.appTypeId ==66 ){
		
		if( $("#rentalStus").text() == "REG" ||$("#rentalStus").text() == "INV" ){
		
		    if(billMonth > 60){
				    	Common.ajaxSync("GET", "/sales/membership/getOderOutsInfo", $("#getDataForm").serialize(), function(result) {
		                    console.log( "==========3===");
		                    console.log(result);
		                    if(result.outsInfo.length >0 ){
		                        if(result.outsInfo.Order_TotalOutstanding >0){
		                             rtnMsg += "Not allow to choose 2 Years Advance Promotion (10% Discount) Promotion. <br>" ;
		                             rtnValue =false; 
		                        }
		                    }
		                    
		                }, function(jqXHR, textStatus, errorThrown) {
			                    try {
			                        console.log("status : " + jqXHR.status);
			                        console.log("code : " + jqXHR.responseJSON.code);
			                        console.log("message : " + jqXHR.responseJSON.message);
			                        console.log("detailMessage : "+ jqXHR.responseJSON.detailMessage);
			                    } catch (e) {
			                        console.log(e);
			                    }
	
			                    rtnMsg += jqXHR.responseJSON.message;
			                    rtnValue =false; 
		                });
		    }
		          
		          
		}else {
			 rtnMsg += "Only [REG] or [INV] rental order is allowed to purchase membership.<br>";
			 rtnValue =false; 
		}
	}
	
    
    if( rtnValue ==false ){
        Common.alert("Rental Order Validation" +DEFAULT_DELIMITER +rtnMsg );
    }
    
    return  rtnValue;
}



function fn_CheckSalesPersonCode(){
	
    if($("#SALES_PERSON").val() =="") {
    	
             Common.alert("Please Key-In Sales Person Code. ");
             return   false;
     }
     return true;
}


function fn_unconfirmSalesPerson(){
	
	if($("#hiddenSalesPersonID").val() =="") {
		 Common.alert("Sales Person Confirmation" +DEFAULT_DELIMITER+"You must confirm the sales person since you have key-in sales person code.");
         return   false;
	
	}else{
		 Common.popupDiv("/sales/membership/mNewQuotationSavePop.do" , $("#getDataForm").serializeJSON(), null , true , '_saveDiv1'); 
	}
}




function  fn_SaveProcess_Click(_saveOption){
	
	
	
	/*
	if(_saveOption == "1"){
		
		 //SAVE & PROCEED TO PAYMEMT
        this.DisablePageControl_Page();
        RadWindowManager1.RadAlert("<b>Quotation successfully saved.<br />Quotation number : " + retQuot.SrvMemQuotNo + "<br />System will auto redirect to payment process after 3 seconds.</b>", 450, 160, "Quotation Saved & Proceed To Payment", "callBackFn", null);
        hiddenQuotID.Value = retQuot.SrvMemQuotID.ToString();
        Timer1.Enabled = true;
        
	}else if(_saveOption == "2"){
		 //SAVE QUOTATION ONLY
        this.DisablePageControl_Page();
        RadWindowManager1.RadAlert("<b>Quotation successfully saved.<br />Quotation number : " + retQuot.SrvMemQuotNo + "</b>", 450, 160, "Quotation Saved", "callBackFn", null);
        
	}else {
		 RadWindowManager1.RadAlert("<b>Failed to save. Please try again later.</b>", 450, 160, "Failed To Save", "callBackFn", null);
	}*/
}

function  fn_DoSaveProcess(_saveOption){
	
	$("#srvMemQuotId").val(0);
	$("#srvSalesOrderId").val($("#ORD_ID").val());
	$("#srvMemQuotNo").val("");
	$("#srvMemPacId").val($("#cTPackage").val());
	$("#srvMemPacAmt").val($("#txtPackagePrice").text());
	$("#srvMemBSAmt").val($("#txtFilterCharge").text());
	$("#srvMemPv").val(0);
	$("#srvDuration").val($("#cYear").val());
	$("#srvRemark").val($("#txtRemark").val());

	$("#srvQuotStatusId").val(1);
	
	$("#srvMemBS12Amt").val(0);

	if($("#cPromotionpac").val() > 0 ) $("#srvPacPromoId").val( $("#cPromotionpac").val());
	else  $("#srvPacPromoId").val(0);


	if($("#cPromo").val() >0 )  $("#srvPromoId").val( $("#cPromo").val()); 
	else $("#srvPromoId").val(0);


    $("#srvQuotCustCntId").val( $("SAVE_CUST_CNTC_ID").val());
    $("#srvMemQty").val(1);
	$("#srvSalesMemId").val(  $("#hiddenSalesPersonID").val() );
	$("#srvMemId").val(0);
	$("#srvOrderStkId").val(  $("#STOCK_ID").val());
	$("#srvFreq").val($("#hiddentxtBSFreq").val());
	
	$("#empChk").val($("#cEmplo").val());
	

    
    if($("#HiddenIsCharge").val() =="1"){
    	$("#isFilterCharge").val("TRUE");
    }else{
    	$("#isFilterCharge").val("FALSE");
    }
    
    Common.ajax("GET", "/sales/membership/mNewQuotationSave", $("#save_Form").serialize(), function(result) {
         console.log( result);
         
         if(result.code =="00"){
        	 
        	 if(_saveOption == "1"){
        		 
        		  Common.alert("Quotation Saved & Proceed To Payment" +DEFAULT_DELIMITER+" <b> Quotation successfully saved.<br/> Quotation number : " + result.data + "<br/> System will auto redirect to payment process after 3 seconds. ");

        		  setTimeout(function(){ fn_saveResultTrans(result.data) ;}, 3000); 
        		  
        	 }else{
        		  Common.alert("Quotation Saved" +DEFAULT_DELIMITER+" <b> Quotation successfully saved.<br /> Quotation number : " + result.data + "<br /> ");
        	 }
        	 
         }else{
        	  Common.alert("Failed To Save" +DEFAULT_DELIMITER+" b>Failed to save. Please try again later.</b> ");
         }
    });
}




function fn_saveResultTrans(quot_id){
	$("#_alertOk").click();
	$("#_NewQuotDiv1").remove();
    Common.popupDiv("/sales/membership/mAutoConvSale.do" ,{QUOT_ID : quot_id}, null , true , '_transDiv1');
}


/*
private Boolean CheckRentalOrder()
{
    Boolean valid = true;
    string message = "";
    int OrderID = int.Parse(hiddenOrderID.Value);

    if (int.Parse(hiddenAppTypeID.Value) == 66)
    {
        if (txtRentStatus.Text.Trim() == "REG" || txtRentStatus.Text.Trim() == "INV")
        {
            Sales.Orders oo = new Sales.Orders();
            int CurrentBillMth = oo.GetOrderCurrentBillMonth(OrderID);
            if (CurrentBillMth > 60)
            {
                Data.spGetOrderOutstandingInfo_Result oi = new Data.spGetOrderOutstandingInfo_Result();
                oi = oo.GetOrderOutstandingInfo(int.Parse(hiddenOrderID.Value));
                if (oi.Order_TotalOutstanding > 0)
                {
                    valid = false;
                    message += "* This order has outstanding. Membership purchase is disallowed.<br />";
                }
            }
        }
        else
        {
            valid = false;
            message += "* Only [REG] or [INV] rental order is allowed to purchase membership.<br />";
        }
    }
    if (!valid)
        RadWindowManager1.RadAlert("<b>" + message + "</b>", 450, 160, "Rental Order Validation", "callBackFn", null);

    return valid;

}
*/


function createAUIGridHList() {
    
    //AUIGrid 칼럼 설정
    var columnLayout = [
                        {     dataField     : "no",                 
                               headerText  : "BS No",  
                               width          : 150,               
                               editable       : false
                        }, 
                        {     dataField     : "month",          
                               headerText  : "BS Month",           
                               width          : 100,                
                               editable       : false
                        }, 
                        {     dataField     : "code",                     
                               headerText  : "Type",           
                               width          : 100,                 
                               editable       : false
                        }, 
                        {      dataField     : "code1",                
                                headerText  : "Status",           
                                width          :100,                 
                                editable       : false
                        }, 
                        {      dataField       : "no1",      
                            headerText   : "BSR No",           
                            width           : 150,                 
                            editable        : false
                     },
                    {      dataField       : "c1",      
                                headerText   : "Settle Date",           
                                width           : 200,                 
                                editable        : false
                         }, 
                         {      dataField       : "memCode",      
                             headerText   : "Cody Code",           
                             width           : 100,                 
                             editable        : false
                      }, 
                      {      dataField       : "code3",      
                          headerText   : "Fail Reason",           
                          width           :100,                 
                          editable        : false
                   }, 
                   {      dataField       : "code2",      
                       headerText   : "Collection Reason",           
                       width           : 150,                 
                       editable        : false
                }
                        
   ];

    //그리드 속성 설정
    var gridPros = {           
   	    usePaging           : true,             //페이징 사용
   	    pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)           
        editable                : false,            
        fixedColumnCount    : 1,      
        selectionMode       : "singleRow",  //"multipleCells",    
        showRowNumColumn    : true         //줄번호 칼럼 렌더러 출력    
       
    };
    
    bsHistoryGridID = GridCommon.createAUIGrid("hList_grid_wrap", columnLayout, "", gridPros);
}





function createAUIGridOList() {
    
    //AUIGrid 칼럼 설정
    var columnLayout = [
                        {     dataField     : "stkCode",                 
                               headerText  : "Code",  
                               width          : "10%",               
                               editable       : false
                        }, 
                        {     dataField     : "stkDesc",          
                               headerText  : "Name",           
                               width          : "50%",                
                               editable       : false,     
                               style           : 'left_style'
                        }, 
                        {     dataField     : "code",                     
                               headerText  : "Type",           
                               width          : "10%",                 
                               editable       : false
                        }, 
                        {      dataField     : "srvFilterPriod",                
                                headerText  : "Change Period",           
                                width          : "10%",                 
                                editable       : false
                        }, 
                    {      dataField       : "srvFilterPrvChgDt",      
                                headerText   : "Last Change",           
                                width           : "10%",                 
                                editable        : false
                         }
                        
   ];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,             //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        editable                : false,            
        fixedColumnCount    : 1,            
        showStateColumn     : true,             
        displayTreeOpen     : false,            
        selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,
        
        
        // row Styling 함수
        rowStyleFunction : function(rowIndex, item) {
         
            return "";
        }
    };
    
    oListGridID = GridCommon.createAUIGrid("oList_grid_wrap", columnLayout, "", gridPros);
}


</script>



<form id="getDataForm" method="post">
<div style="display:none">
    <input type="text" name="ORD_ID"     id="ORD_ID"/>  
    <input type="text" name="CUST_ID"    id="CUST_ID"/>  
    <input type="text" name="IS_EXPIRE"  id="IS_EXPIRE"/>  
    <input type="text" name="STOCK_ID"  id="STOCK_ID"/>  
    <input type="text" name="PAC_ID"  id="PAC_ID"/>  
    <input type="text" name="TO_YYYYMM"  id="TO_YYYYMM" />  
    <input type="text" name="EX_YYYYMM"  id="EX_YYYYMM"/>  
    <input type="text" name="PROMO_ID"  id="PROMO_ID"/>   
    <input type="text" name="ORD_DATE"  id="ORD_DATE"/>  
    
    
    <!--Type of Package  -->
    <input type="text" name="SELPACKAGE_ID"  id="SELPACKAGE_ID"/>  
    <!--Subscription Year  -->
    <input type="text" name="DUR"  id="DUR"/>  
          
    <!--FilterChargePOPUP.Title -->
    <input type="text" name="FCPOPTITLE"  id="FCPOPTITLE"/>   
          
    
    
</div>
</form>

<form id="oListDataHiddenForm" method="post">
<div style="display:none">
    <input type="text" name="HiddenHasFilterCharge"  id="HiddenHasFilterCharge"/>  
    <input type="text" name="HiddenIsCharge"  id="HiddenIsCharge"/>  
    <input type="text" name="HiddenHasPackage"  id="HiddenHasPackage"/> 
    <input type="text" name="hiddenPacOriPrice"  id="hiddenPacOriPrice"/> 
    <input type="text" name="hiddenSalesPersonID"  id="hiddenSalesPersonID"/> 
    <input type="text" name="hiddentxtBSFreq"  id="hiddentxtBSFreq"/> 
</div>
</form>


<form  id="save_Form" method="post">
	<div style="display:none">
			<input type="text" name="srvMemQuotId" id="srvMemQuotId" />
			<input type="text" name="srvSalesOrderId" id="srvSalesOrderId" />
			<input type="text" name="srvMemQuotNo" id="srvMemQuotNo" />
			<input type="text" name="srvMemPacId" id="srvMemPacId" />
			<input type="text" name="srvMemPacNetAmt" id="srvMemPacNetAmt" />
			<input type="text" name="srvMemPacTaxes" id="srvMemPacTaxes" />
			<input type="text" name="srvMemPacAmt" id="srvMemPacAmt" />
			<input type="text" name="srvMemBSNetAmt" id="srvMemBSNetAmt" />
			<input type="text" name="srvMemBSTaxes" id="srvMemBSTaxes" />
			<input type="text" name="srvMemBSAmt" id="srvMemBSAmt" />
			<input type="text" name="srvMemPv" id="srvMemPv" />
			<input type="text" name="srvDuration" id="srvDuration" />
			<input type="text" name="srvRemark" id="srvRemark" />
			<input type="text" name="srvQuotValid" id="srvQuotValid" />
			<input type="text" name="srvCreateAt" id="srvCreateAt" />
			<input type="text" name="srvCreateBy" id="srvCreateBy" />
			<input type="text" name="srvQuotStatusId" id="srvQuotStatusId" />
			<input type="text" name="srvUpdateBy" id="srvUpdateBy" />
			<input type="text" name="srvUpdateAt" id="srvUpdateAt" />
			<input type="text" name="srvMemBS12Amt" id="srvMemBS12Amt" />
			<input type="text" name="srvQuotCustCntId" id="srvQuotCustCntId" />
			<input type="text" name="srvMemQty" id="srvMemQty" />
			<input type="text" name="srvPromoId" id="srvPromoId" />
			<input type="text" name="srvSalesMemId" id="srvSalesMemId" />
			<input type="text" name="srvMemId" id="srvMemId" />
			<input type="text" name="srvOrderStkId" id="srvOrderStkId" />
			<input type="text" name="srvFreq" id="srvFreq" />
			<input type="text" name="srvPacPromoId" id="srvPacPromoId" />
			<input type="text" name="isFilterCharge" id="isFilterCharge" />
			<input type="text" name="empChk" id="empChk" />
			
			
	</div>
</form>



<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Management -New Quotation  </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="nc_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="height:450px"><!-- pop_body start -->


<section id="content"><!-- content start -->


<section class="search_table"><!-- search_table start -->
<form action="#"   id="sForm"  name="sForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Order No</th>
	<td>
	       <input type="text" title="" id="ORD_NO" name="ORD_NO" placeholder="" class="" /><p class="btn_sky"  id='cbt'> <a href="#" onclick="javascript: fn_doConfirm()"> Confirm</a></p>   <p class="btn_sky" id='sbt'><a href="#" onclick="javascript: fn_goCustSearch()">Search</a></p>
           <input type="text" title="" id="ORD_NO_RESULT" name="ORD_NO_RESULT"   placeholder="" class="readonly " readonly="readonly" /><p class="btn_sky" id="rbt"> <a href="#" onclick="javascript :fn_doReset()">Reselect</a></p>
 	</td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section>
<div  id="resultcontens"  style="display:none">

		
		<section class="tap_wrap"><!-- tap_wrap start -->
		<ul class="tap_type1">
		    <li><a href="#" class="on"  >Order Info</a></li>
		    <li><a href="#">Contact Person</a></li>
		    <li><a href="#" onclick="javascript:AUIGrid.resize(bsHistoryGridID, 1100,380);">BS History</a></li>
		    <li><a href="#"  onclick="javascript:AUIGrid.resize(oListGridID, 1100,380);">Order Product Filter</a></li>
		</ul>
		
		<article class="tap_area"><!-- tap_area start -->
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:130px" />
		    <col style="width:*" />
		    <col style="width:130px" />
		    <col style="width:*" />
		    <col style="width:130px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">Order No</th>
		    <td><span id='ordNo' ></span></td>
		    <th scope="row">Order Date</th>
		    <td><span id='ordDt'></span></td>
		    <th scope="row">Installment Period</th>
		    <td><span id='InstallmentPeriod'></span></td>
		</tr>
		<tr>
		    <th scope="row">Order Status</th>
		    <td><span id='ordStusName'></span></td>
		    <th scope="row">Rental Status</th>
		    <td><span id='rentalStus'></span></td>
		    <th scope="row">Install No</th>
		    <td><span id='installNo'></span></td>
		</tr>
		<tr>
		    <th scope="row">Application Type</th>
		    <td><span id='appTypeDesc'></span></td>
		    <th scope="row">Reference No</th>
		    <td><span id='ordRefNo'></span></td>
		    <th scope="row">Install Date</th>
		    <td><span id='installDate'></span></td>
		</tr>
		<tr>
		    <th scope="row">Stock Code</th>
		    <td><span id='stockCode'></span></td>
		    <th scope="row">Stock Name</th>
		    <td colspan="3" id='stockDesc'><span></span></td>
		</tr>
		<tr>
		    <th scope="row">Cooling Off Period</th>
		    <td><span id='coolingOffPeriod'>text</span></td>
		    <th scope="row">Term</th>
		    <td><span id='term'></span></td>
		    <th scope="row">Is Charge</th>
		    <td><span id='isCharge'></span></td>
		</tr>
		<tr>
		    <th scope="row" rowspan="3">Instalation Address</th>
		    <td rowspan="3" colspan="3" id='address'><span></span></td>
		    <th scope="row">Order Outstanding</th>
		    <td><span id='ordoutstanding'></span></td>
		</tr>
		<tr>
		    <th scope="row">AS Outstanding</th>
		    <td><span id='asoutstanding'></span></td>
		</tr>
		<tr>
		    <th scope="row">Membership Expire</th>
		    <td><span id='expire'></span></td>
		</tr>
	
		<tr>
		    <th scope="row">Customer ID</th>
		    <td><span id='custId'></span></td>
		    <th scope="row">Customer Type</th>
		    <td colspan="3" id='custType'><span></span></td>
		</tr>
		<tr>
		    <th scope="row">Customer Name</th>
		    <td colspan="5" id='custName'><span></span></td>
		</tr>
		<tr>
		    <th scope="row">NRIC/Company No</th>
		    <td colspan="5" id='custNric' ><span></span></td>
		</tr>
		</tbody>
		</table><!-- table end -->
		<p class="brown_text mt10">(Is Charge = Yes : Filter service charges is depends on the filter expiration date)</p>
		</article><!-- tap_area end -->
		
		<article class="tap_area"><!-- tap_area start -->
		
		<ul class="left_btns mb10">
		    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_goContactPersonPop()">Other Contact Person</a></p></li>
           <li><p class="btn_blue2"><a href="#" onclick="fn_goNewContactPersonPop()">New Contact Person</a></p></li>
		</ul>
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:130px" />
		    <col style="width:*" />
		    <col style="width:130px" />
		    <col style="width:*" />
		    <col style="width:130px" />
		    <col style="width:*" />
		    <col style="width:130px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
			     <tr>
				    <th scope="row">Name</th>
				    <td colspan="5" id="name"><span></span></td>
				    <th scope="row"></th>
				    <td><span id="gender"></span></td>
				</tr>
				<tr>
				    <th scope="row">NRIC</th>
				    <td colspan="5" id="nric"><span></span></td>
				    <th scope="row">Race</th>
				    <td><span id="codename1"></span></td>
				</tr>
				<tr>
				    <th scope="row">Mobile No</th>
				    <td><span id="telM1"></span></td>
				    <th scope="row">Office No</th>
				    <td><span id="telO"></span></td>
				    <th scope="row">Residence No</th>
				    <td><span id="telR" ></span></td>
				    <th scope="row">Fax No</th>
				    <td><span id="telf"></span></td>
				</tr>
				<tr>
				    <th scope="row">Email</th>
				    <td colspan="7" id="email"><span></span></td>
				</tr>
		</tbody>
		</table><!-- table end -->
		</article><!-- tap_area end -->
		
		
		
		<article class="tap_area"><!-- tap_area start -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		   <div id="hList_grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->
       </article><!-- tap_area end -->
		
		
		
		<article class="tap_area"><!-- tap_area start -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		   <div id="oList_grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->
		
		</article><!-- tap_area end -->
		
		</section><!-- tap_wrap end -->
		
		<aside class="title_line"><!-- title_line start -->
		<h3>Membership Information</h3>
		</aside><!-- title_line end -->
		
		<section class="search_table"><!-- search_table start -->
		<form action="#" method="post"  id='collForm' name ='collForm'>
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:130px" />
		    <col style="width:*" />  
		    <col style="width:120px" />
		    <col style="width:100px" />
		    <col style="width:100px" />
            <col style="width:100px" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">Type of Package</th>
		    <td>
		    <select class="w100p" id='cTPackage' name='cTPackage'></select>
		    </td>
		    <th scope="row">Subscription Year</th>
		    <td width='80px'>
		    <select  id="cYear"   style="width:80px"  disabled="disabled"  >
		        <option value="12" >1</option>
		        <option value="24">2</option>
		        <option value="36">3</option>
		        <option value="48">4</option>
		    </select>
		    </td>
		    
		      <th scope="row">Employee </th>
	            <td>
	            <select  style="width:80px"  id="cEmplo" >
	                <option value="1">Y</option>
	                <option value="0">N</option>
	            </select>
	            </td>
	            
	            
		</tr>
		<tr>
		    <th scope="row">Package Promotion</th>
		    <td>
		    <label><input type="checkbox" disabled="disabled"  id="packpro"   name="packpro" onclick="fn_doPackagePro(this)" /><span></span></label>
		            <select class="disabled" disabled="disabled"  id="cPromotionpac" name="cPromotionpac" > </select>
		    </td>
		    <th scope="row">Package Price</th>
		    <td  colspan="3"><span id='txtPackagePrice'></span></td>
		</tr>
		<tr>
		    <th scope="row">Filter Promotion</th>
		    <td>
		    <label><input type="checkbox" disabled="disabled"  id="cPromoCombox"   name="cPromoCombox" onclick="fn_doPromoCombox(this)" /><span></span></label>
		    <select class="disabled " disabled="disabled" id="cPromo" name='cPromo'></select>
		    </td>
		    <th scope="row">Filter Price</th>
		    <td colspan="2">
		          <span id="txtFilterCharge"></span>
		     </td>
		    <td>
                  <div  id="btnViewFilterCharge" class="right_btns"  style="display:none" >  
                        <p class="btn_sky"><a href="#" onclick="javascript:fn_LoadMembershipFilter()">Detail</a></p>
                   </div>
		</tr>
		
		<tr>
		    <th scope="row">Sales Person Code</th>
		    <td><input type="text" title="" placeholder="" class=""  style="width:100px" id="SALES_PERSON" name="SALES_PERSON"  />
		        <p class="btn_sky"  id="sale_confirmbt" ><a href="#" onclick="javascript:fn_goSalesConfirm()">Confirm</a></p>    
		        <p class="btn_sky"  id="sale_searchbt"><a href="#" onclick="javascript:fn_goSalesPerson()" >Search</a></p>  
		        <p class="btn_sky"  id="sale_resetbt" style="display:none"><a href="#" onclick="javascript:fn_goSalesPersonReset()" >Reset</a></p>
		    </td>
		    <th scope="row">Sales Person Code</th>
		    <td colspan="3"><span id="SALES_PERSON_DESC"  name="SALES_PERSON_DESC"></span></td>
		</tr>
		<tr>
		    <th scope="row">Remark</th>
		    <td><textarea cols="20" rows="5" id='txtRemark' name=''></textarea></td>
		    <th scope="row">BS Frequency</th>
		    <td colspan="3" ><span id='txtBSFreq'></span></td>
		</tr>
		</tbody>
		</table><!-- table end -->
		</form>
		</section><!-- search_table end -->
		

		<ul class="center_btns">
		    <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_save()">Save</a></p></li>
		    <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_back()">Back</a></p></li>
		  
		 <!--  <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_saveResultTrans()">test</a></p></li> -->
		</ul>

</div>
</section>

</section><!-- content end -->


</section>

</div>
