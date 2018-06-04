
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

    $("#cPromo").prop("disabled", true);
    $("#cPromo").attr("class", "disabled");

    $("#rbt").attr("style","display:none");
    $("#ORD_NO_RESULT").attr("style","display:none");


    $("#ORD_NO_P").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_doConfirm();
            }
     });

});




function fn_doConfirm (){
    Common.ajax("GET", "/sales/membershipRentalQut/newConfirm", {ORD_NO : $("#ORD_NO_P").val()}, function(result) {
         console.log( result);

         if(result.length == 0)  {

             $("#cbt").attr("style","display:inline");
             $("#ORD_NO_P").attr("style","display:inline");
             $("#sbt").attr("style","display:inline");
             $("#rbt").attr("style","display:none");
             $("#ORD_NO_RESULT").attr("style","display:none");

             $("#resultcontens").attr("style","display:none");

             Common.alert("No order found or this order is not under complete status or activation status.");
             return ;

         }else{


             if(fn_isActiveMembershipQuotationInfoByOrderNo()){
                 return ;
             }

             $("#ORD_NO_RESULT").val( result[0].salesOrdNo);
             $("#ORD_ID").val( result[0].salesOrdId);


             fn_getDataInfo(result[0].salesOrdId);
             fn_outspro(result[0].salesOrdId);

         }
   });
}



function  fn_isActiveMembershipQuotationInfoByOrderNo(){
    var rtnVAL= false;
     Common.ajaxSync("GET", "/sales/membershipRentalQut/mActiveQuoOrder", {ORD_NO: $("#ORD_NO_P").val()}, function(result) {
         console.log( result);

         if(result.length > 0 ){
             rtnVAL =true;
/*              Common.alert(" <b>This order already has an active quotation.<br />Quotation number : [" + result[0].srvMemQuotNo +"]</b>"); */
             Common.alert(" <b>This order already has an active quotation.<br />Quotation number : [" + result[0].qotatRefNo +"]</b>");
             return true;
         }
    });

     return rtnVAL;
}

function fn_getDataInfo (_ordid){
    Common.ajax("GET", "/sales/membership/selectMembershipFreeDataInfo",    {ORD_ID : _ordid }, function(result) {
        console.log( "fn_getDataInfo===>"+result);
        console.log( result);

        if(FormUtil.isNotEmpty(result.installation.areaId)){

            if("DM" == result.installation.areaId.substring(0,2)){

                Common.alert("The customer address of Order is the old address.<br/>Change to the new address in the Customer Management.");

                return;

            }else{

                resultBasicObject = result.basic;
		        var billMonth = getOrderCurrentBillMonth();

                if(fn_CheckRentalOrder(billMonth)){
                    $("#cbt").attr("style","display:none");
                    $("#ORD_NO_P").attr("style","display:none");
                    $("#sbt").attr("style","display:none");
                    $("#rbt").attr("style","display:inline");
                    $("#ORD_NO_RESULT").attr("style","display:inline");
                    $("#resultcontens").attr("style","display:inline");

                    setText(result);
                    setPackgCombo();
                }

            }
        }
    });
 }



function fn_outspro (_ordid){
    Common.ajax("GET", "/sales/membership/callOutOutsProcedure", {ORD_ID : _ordid }, function(result) {
        console.log("fn_outspro===>" +result);
        console.log(result);

        if(result.outSuts.length >0 ){
            $("#ordoutstanding").html(result.ordOtstnd);
            $("#asoutstanding").html(result.asOtstnd);
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

    //$("#address").html(address);

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


    fn_newGetExpDate(result);
    fn_setTerm();


    var options ={
            CUST_ID : result.basic.custId ,
            ORD_ID:  result.basic.ordId
    };

    fn_getDataCPerson(options);
    fn_getDatabsHistory(options);
    fn_getDatabsOList(options);
    if( fn_selCheckExpService(options)){

        /*
        if (this.CheckRentalOrderOutstanding(int.Parse(this.hiddenOrderID.Value))){
            if (this.CheckRentalSVMOutstanding(int.Parse(this.hiddenOrderID.Value)))
            {
                this.btnSave.Enabled = true;
            }
        }
        */
    }

    /*
    if(this.CheckExpService(int.Parse(this.hiddenOrderID.Value)))
    {
        if (this.CheckRentalOrderOutstanding(int.Parse(this.hiddenOrderID.Value)))
        {
            if (this.CheckRentalSVMOutstanding(int.Parse(this.hiddenOrderID.Value)))
            {
                this.btnSave.Enabled = true;
            }
        }
    }
    */

}





function fn_selCheckExpService (o){

    Common.ajaxSync("GET", "/sales/membershipRentalQut/selCheckExpService", {ORD_ID : o.ORD_ID}, function(result) {
        console.log("fn_outspro===>" +result);
        console.log(result);

        if(result.length >0 ){

               var   expiryYear = parseInt(result[0].EXPR_YYYY ,10);
                var  curYear = parseInt(result[0].now_YYYY ,10);
                var  expiryMonth = parseInt(result[0].EXPR_mm ,10);
                var  curMonth = parseInt(result[0].now_mm ,10);

                var  month = ((expiryYear - curYear) * 12) + expiryMonth - curMonth;

                var expDate = parseInt(expiryYear+""+expiryMonth,10 );
                var today = parseInt(curYear+""+curMonth,10 );

                if (expDate> today)  {
                    if (month > 1) // only allow 1 (before 1 month) or within that month
                    {
                        Common.alert(" This order is under membership. <br />Rental membership purchase is disallowed. <br />");
                        return false;
                    }
                }
                return true;
          }
    });

    return true;
 }


function  fn_goCustSearch(){
    Common.popupDiv('/sales/ccp/searchOrderNoPop.do' , null, null , true, '_searchDiv');
}


function fn_callbackOrdSearchFunciton(item){
    console.log(item);
    $("#ORD_NO_P").val(item.ordNo);
    fn_doConfirm();

}




function fn_doReset() {
    $("#_NewQuotDiv1").remove();
    fn_goNewQuotation();
   // $("#sForm").attr({"target" :"_self" , "action" : "/sales/membershipRentalQut/mNewQuotation.do" }).submit();
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
function fn_getDataCPerson (o){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_cPerson", {CUST_ID:o.CUST_ID}, function(result) {
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
function fn_getDatabsHistory(o){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_bs", {ORD_ID :o.ORD_ID}, function(result) {
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

         if($("#HiddenIsCharge").val() != "0"){
             $("#cPromo").prop("disabled", false);
             $("#cPromo").attr("class", "");
         }

    });
 }

/*oList*/
function fn_getDatabsOList (o){
   Common.ajax("GET", "/sales/membership/newOListuotationList", {ORD_ID : o.ORD_ID}, function(result) {
        console.log( result);

        AUIGrid.setGridData(oListGridID, result);
        AUIGrid.resize(oListGridID, 1120,250);

        if( $("#HiddenIsCharge").val() =="0"){ return ;}

        changeRowStyleFunction();


   });
 }


function setPackgCombo(){
    doGetCombo('/sales/membershipRentalQut/getSrvMemCode?SALES_ORD_ID='+$("#ORD_ID").val(), '', '','cTPackage', 'S' , '');            // Customer Type Combo Box
}





function fn_getFilterChargeList(){

    $("#txtFilterCharge").val("");

    if($("#HiddenIsCharge").val() != "0"){

       	 if($('#cTPackage').val() != ""){

       		 Common.ajax("GET", "/sales/membershipRentalQut/getFilterChargeListSum.do",{
                    SALES_ORD_NO : $("#ORD_NO_P").val(),
                    ORD_ID : $("#ORD_ID").val(),
                    PROMO_ID: $('#cPromo').val() ,
                    SRV_PAC_ID :$('#cTPackage').val(),
                    zeroRatYn :$("#zeroRatYn").val(),
                    eurCertYn :$("#eurCertYn").val()
                }, function(result) {
                     console.log( result);

                    if(null != result){

                        /* if(result[0] !=null){

                            if($("#zeroRatYn").val() == "N" || $("#eurCertYn").val() == "N"){

                                $("#txtFilterCharge").val( Math.floor(result[0].amt * 100 / 106));
                            }else{

                                $("#txtFilterCharge").val( result[0].amt);
                            }
                        }*/
                    	$("#txtFilterCharge").val( result);
                    }
                });
       	 }
    }
}




function fn_InintMembershipPackageInfo_backup(){


    $("#cPromotionpac").val("");
    $("#cPromoe").val("");

    $("#packpro").attr("checked",false);
    $("#packpro").attr("disabled" ,"disabled");
    $("#cPromotionpac").attr("disabled" ,"disabled");
    $("#cPromotionpac").val("");


    $("#cPromoCombox").attr("checked",false);
    $("#PromoCombox").attr("disabled" ,"disabled");
    $("#cPromo").prop("disabled", true);
    $("#cPromo").attr("class", "disabled");
    $("#cPromo").val("");

    $("#txtBSFreq").html("");
    $("#txtMonthlyFee").val("");
    $("#txtFilterCharge").val("");
    $("#btnViewFilterCharge").attr("style" ,"display:none");
}










 function   fn_LoadMembershipFilter(_cPromotion){

     var  cPromotion = _cPromotion;

     if(null ==cPromotion  || ""== cPromotion ) {
         cPromotion =0;
     }

     $("#PROMO_ID").val(cPromotion);
     $("#_editDiv1").remove();
     $("#_popupDiv").remove();


     Common.popupDiv("/sales/membershipRentalQut/mRFilterChargePop.do" , $("#getDataForm").serializeJSON(), null , true , '_editDiv1');
 }



 function fn_back(){
     $("#_NewQuotDiv1").remove();
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




function fn_save(){

    if(fn_validRequiredField_Save() ==false ) return ;
    fn_unconfirmSalesPerson();

}



function  fn_validRequiredField_Save(){

    var rtnMsg ="";
    var rtnValue=true ;


    if(FormUtil.checkReqValue($("#cTPackage"))){
           rtnMsg  +="* Please select the type of package.<br />" ;
           rtnValue =false;
    }


/*
    if($("#packpro").prop("checked")){
          if(FormUtil.checkReqValue($("#cPromotionpac"))){
               rtnMsg  +=" Please select the package promotion.<br />" ;
               rtnValue =false;
        }
     }



     //if ($("#cPromoCombox").prop("checked")){
    //       if(FormUtil.checkReqValue($("#cPromo"))){
               // rtnMsg +="Please select the promotion.<br>";
                //rtnValue =false;
     //      }
    //  }

     */

    if( ! FormUtil.checkReqValue($("#SALES_PERSON"))){
        if($("#hiddenSalesPersonID").val() ==""){
               rtnMsg  +="* You must confirm the sales person since you have key-in sales person code.<br />" ;
               rtnValue =false;
        }
    }

     if( rtnValue ==false ){
         Common.alert("Save Quotation Summary" +DEFAULT_DELIMITER +rtnMsg );
     }

     return  rtnValue;
}

function getOrderCurrentBillMonth (){
	   var billMonth =0;

	   Common.ajaxSync("GET", "/sales/membership/getOrderCurrentBillMonth", { ORD_ID: $("#ORD_ID").val() } , function(result) {
	        console.log( result);

	        if(result.length > 0 ){
	              if(   parseInt( result[0].nowDate ,10) > parseInt( result[0].rentInstDt ,10)   ){

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


function fn_CheckRentalOrder(billMonth){

    var rtnMsg ="";
    var rtnValue=true ;

    if(resultBasicObject.appTypeId == 66 ){

        if(resultBasicObject.rentalStus == "REG" ||resultBasicObject.rentalStus == "INV" ){

            if(billMonth > 60){
                        Common.ajaxSync("GET", "/sales/membership/getOderOutsInfo", $("#getDataForm").serialize(), function(result) {
                            console.log( "==========3===");
                            console.log(result);
                            if(result != null ){
                                if(result.ordTotOtstnd  >0){
                                     rtnMsg += "* This order has outstanding. Membership purchase is disallowed.<br/>" ;
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
         Common.popupDiv("/sales/membership/mNewQuotationSavePop.do" ,null ,null , true , '_saveDiv1');
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


    var sData = {
                qotatRefNo : "" ,  //Update later
                qotatOrdId : resultBasicObject.ordId  ,
                qotatRem : $("#txtRemark").val(),
                qotatStusId : "1",
                qotatPacPromoId: $("#cPromotionpac").val()  == "null" ? "0" : $("#cPromotionpac").val(),
                qotatFilPromoId : $("#cPromo").val()  == "null" ? "0" : $("#cPromo").val(),
                qotatPckgId  : $("#cTPackage").val(),
                qotatProductId  :resultBasicObject.stockId,
                qotatRentalAmt  : $("#txtMonthlyFee").val(),
                qotatExpFilterAmt  : $("#txtFilterCharge").val(),
                qotatCntrctDur   : "24",
                qotatCntrctFreq : $("#hiddentxtBSFreq").val() =="" ? "0" :$("#hiddentxtBSFreq").val() ,
                qotatSalesmanId : $("#hiddenSalesPersonID").val(),
                //qotatGstRate   :"6", -- without GST 6% edited by TPY 01/06/2018
                qotatGstRate   :"0",
                empChk : $("#cEmplo").val() =="" ? "0" :$("#cEmplo").val()
    }

    var saveForm ={
                "saveData" : sData,
                "isFilterChange" : $("#HiddenHasFilterCharge").val() =="1" ? "true" : "false"
    }

    Common.ajax("POST", "/sales/membershipRentalQut/mNewQuotationSave.do",saveForm , function(result) {

        console.log( "mNewQuotationSave.do====>");
        console.log( result);

         if(result.code =="00"){
             if(_saveOption == "1"){
                  Common.alert("Quotation Saved & Proceed To Payment" +DEFAULT_DELIMITER+" <b> Quotation successfully saved.<br/> Quotation number : " + result.data.qotatRefNo + "<br/> System will auto redirect to payment process after 3 seconds. ");
                   setTimeout(function(){ fn_saveResultTrans(result.data.qotatId) ;}, 3000);
                  $("#_NewQuotDiv1").remove();

             }else{
                  Common.alert("Quotation Saved" +DEFAULT_DELIMITER+" <b> Quotation successfully saved.<br /> Quotation number : " + result.data.qotatRefNo + "<br /> ");

                  $("#_NewQuotDiv1").remove();
                  fn_selectListAjax();
             }
         }else{
              Common.alert("Failed To Save" +DEFAULT_DELIMITER+" b>Failed to save. Please try again later.</b> ");
              $("#_NewQuotDiv1").remove();
         }
    });
}




function fn_saveResultTrans(quot_id){
    $("#_alertOk").click();
    $("#_NewQuotDiv1").remove();

    Common.popupDiv("/sales/membershipRentalQut/mRentalQuotConvSalePop.do" ,{QUOT_ID : quot_id}, null , true , '_mConvSaleDiv1');

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
                               width          : 90,
                               editable       : false
                        },
                        {     dataField     : "month",
                               headerText  : "BS Month",
                               width          : 80,
                               editable       : false
                        },
                        {     dataField     : "code",
                               headerText  : "Type",
                               width          : 70,
                               editable       : false
                        },
                        {      dataField     : "code1",
                                headerText  : "Status",
                                width          :70,
                                editable       : false
                        },
                        {      dataField       : "no1",
                            headerText   : "BSR No",
                            width           : 100,
                            editable        : false
                     },
                    {      dataField       : "c1",
                                headerText   : "Settle Date",
                                width           : 170,
                                editable        : false
                         },
                         {      dataField       : "memCode",
                             headerText   : "Cody Code",
                             width           : 90,
                             editable        : false
                      },
                      {      dataField       : "code3",
                          headerText   : "Fail Reason",
                          width           :105,
                          editable        : false
                   },
                   {      dataField       : "code2",
                       headerText   : "Collection<br/> Reason",
                       width           : 100,
                       editable        : false
                }

   ];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,             //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
        editable                : false,
        fixedColumnCount    : 1,
        headerHeight        : 30,
        //selectionMode       : "singleRow",  //"multipleCells",
        showRowNumColumn    : true         //줄번호 칼럼 렌더러 출력

    };

    bsHistoryGridID = GridCommon.createAUIGrid("hList_grid_wrap", columnLayout, "", gridPros);
}





function createAUIGridOList() {

    //AUIGrid 칼럼 설정
    var columnLayout = [
                        {     dataField     : "stkCode",
                               headerText  : "Code",
                               width          : "12%",
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
                               width          : "12%",
                               editable       : false
                        },
                        {      dataField     : "srvFilterPriod",
                                headerText  : "Change Period",
                                width          : "12%",
                                editable       : false
                        },
                    {      dataField       : "srvFilterPrvChgDt",
                                headerText   : "Last Change",
                                width           : "12%",
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
        //selectionMode       : "singleRow",  //"multipleCells",
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




function fn_cPromotionpacChgEvt(){

      $("#txtMonthlyFee").val($("#hiddenOriFees").val());

      Common.ajax("GET", "/sales/membership/getPromoPricePercent",{PROMO_ID: $("#cPromotionpac").val() }, function(result) {
         console.log( result);

         if(result.length>0){

	            // var oriprice                 = Number($("#hiddenOriFees").val()) ;
	             var oriprice                 = Number($("#hiddenNomalFees").val()) ;
	             var promoPrcPrcnt       = Number( result[0]. promoPrcPrcnt) ;
	             var promoAddDiscPrc   = Number( result[0]. promoAddDiscPrc) ;

                 $("#txtMonthlyFee").val("");
	             if(result[0].promoDiscType =="0"){       //%

                      /*  var t1=    oriprice -( oriprice * ( promoPrcPrcnt /100 ) );
                       var t2=    t1 -  promoAddDiscPrc;
                       var t3 = Math.floor( t2);
                       $("#txtMonthlyFee").val(t3);  */

                       var t1 = oriprice - ( oriprice * ( promoPrcPrcnt /100 ) );
                       var t2 = 0;
                       if($("#eurCertYn").val() == "N"){
                           //t2 =    (t1 -  promoAddDiscPrc) * 100 /106; -- without GST 6% edited by TPY 01/06/2018
                    	   t2 =    (t1 -  promoAddDiscPrc);
                       }else{
                           t2 = t1 -  promoAddDiscPrc;
                       }
                       var t3 = Math.floor( t2);
                       $("#txtMonthlyFee").val( Number(t3));


                 }else if(result[0].promoDiscType =="1"){  //amt
                     /* $("#txtMonthlyFee").val(   Math.floor(   ( oriprice - promoPrcPrcnt) -promoAddDiscPrc  ));  */

                     var t1 =  ( oriprice - promoPrcPrcnt) -promoAddDiscPrc;
                     var t2 = 0;

                     if($("#eurCertYn").val() == "N"){
                         //t2 = t1 *100 / 106; -- without GST 6% edited by TPY 01/06/2018
                    	 t2 = t1;
                     }else{
                         t2 = t1;
                     }
                     var t3 = Math.floor( t2);

                     $("#txtMonthlyFee").val( Number(t3));

                 }else{
                     Common.alert('promoDiscType err ');
                     return ;
                 }
         }
      });



}



function   fn_getMembershipPackageFilterInfo(){

    $('#txtFilterCharge').html("");
    $("#cPromoCombox").attr("checked",false);

    //TODO
    if($("#HiddenIsCharge").val() != "0"){
        $("#cPromo").prop("disabled", false);
        $("#cPromo").attr("class", "");
    }


    $("#cPromoCombox").removeAttr("disabled");


    $("#cPromo").val("");

    var SRV_MEM_PAC_ID = $("#cTPackage").val();
    doGetCombo('/sales/membershipRentalQut/getFilterPromotionCode?PROMO_SRV_MEM_PAC_ID='+SRV_MEM_PAC_ID+"&E_YN="+ $("#cEmplo").val(), '', '','cPromo', 'S' , '');            // Customer Type Combo Box



}



function fn_InintMembershipPackageInfo(){



    $("#cPromotionpac").val("");

    var SALES_ORD_ID = $("#ORD_ID").val() ;
    var SRV_MEM_PAC_ID = $("#cTPackage").val();
    var E_YN = $("#cEmplo").val();

    var pram = "?SALES_ORD_ID="+SALES_ORD_ID+"&SRV_MEM_PAC_ID="+SRV_MEM_PAC_ID+"&E_YN="+E_YN;


     doGetCombo('/sales/membershipRentalQut/getPromotionCode'+pram, '', '','cPromotionpac', 'S' , '');



}

function   fn_LoadRentalSVMPackage(_packId){

    var vstkId  = resultBasicObject.stockId;
    var vpackId = _packId;
    var SALES_ORD_ID = $("#ORD_ID").val() ;

     Common.ajax("GET", "/sales/membershipRentalQut/mRPackageInfo",{ packId : vpackId  , stockId: vstkId, SALES_ORD_ID: SALES_ORD_ID}, function(result) {

         console.log("fn_LoadRentalSVMPackage");
         console.log(result);


         //if(result !=null){

         if( result.packageInfo.srvCntrctPacId !=null  ||  result.packageInfo.srvCntrctPacId !=""){

             $("#hiddenNomalFees").val(result.packageInfo.srvPacItmRental);
             $("#txtBSFreq").text(result.packageInfo.c1 +"month(s)");

             $("#zeroRatYn").val(result.packageInfo.zeroRatYn);
             $("#eurCertYn").val(result.packageInfo.eurCertYn);

        	 if($("#eurCertYn").val() == "N"){
                 $("#hiddenOriFees").val(Math.floor(result.packageInfo.srvPacItmRental *100 /106));
                 $("#txtMonthlyFee").val(Math.floor(result.packageInfo.srvPacItmRental *100 /106));
        	 }else{
                 $("#hiddenOriFees").val(result.packageInfo.srvPacItmRental);
                 $("#txtMonthlyFee").val( result.packageInfo.srvPacItmRental);
        	 }
         }else{
             $("#txtBSFreq").text("");
             $("#txtMonthlyFee").val("00");
         }


         $("#packpro").attr("checked",true);
         $("#cPromotionpac").removeAttr("disabled");
         $("#cPromotionpac").attr("class" ,"");

         if ($("#HiddenHasFilterCharge") .val() == "1") {
             $("#btnViewFilterCharge").attr("style","display:inline");
         }

         fn_getFilterChargeList();
     });
}


function fn_getFilterPromotionAmt(){

	 if($("#HiddenIsCharge").val() != "0"){
	    Common.ajax("GET", "/sales/membershipRentalQut/getFilterPromotionAmt.do", {SALES_ORD_NO: resultBasicObject.ordNo ,SRV_PAC_ID :$('#cTPackage').val() }, function(result) {
	         console.log( result);

	         if(null != result){
	             $("#txtFilterCharge").val(result.normaAmt );

	         }

	    });
	 }
}








function fn_cTPackageChanged(){

	 if($('#cTPackage').val().trim() > 0)  {

	     $("#txtFilterCharge").val("");
	     $("#txtMonthlyFee").val("" );


         fn_InintMembershipPackageInfo();
         fn_LoadRentalSVMPackage($('#cTPackage').val().trim());

         //fn_getFilterPromotionAmt();
         //fn_getFilterChargeList();


         fn_getMembershipPackageFilterInfo();
     }

}


</script>



<form id="getDataForm" method="post">
<div style="display:inline">


    <input type="text" name="ORD_ID"     id="ORD_ID"/>
    <input type="text" name="CUST_ID"    id="CUST_ID"/>
    <input type="text" name="IS_EXPIRE"  id="IS_EXPIRE"/>
    <input type="text" name="STOCK_ID"  id="STOCK_ID"/>
    <input type="text" name="PAC_ID"  id="PAC_ID"/>
    <input type="text" name="TO_YYYYMM"  id="TO_YYYYMM" />
    <input type="text" name="EX_YYYYMM"  id="EX_YYYYMM"/>
    <input type="text" name="PROMO_ID"  id="PROMO_ID"/>
    <input type="text" name="ORD_DATE"  id="ORD_DATE"/>
    <input type="text" name="zeroRatYn" id="zeroRatYn" />
    <input type="text" name="eurCertYn" id="eurCertYn" />


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
    <input type="text" name="hiddenOriFees"  id="hiddenOriFees"/>
    <input type="text" name="hiddenNomalFees"  id="hiddenNomalFees"/>

</div>
</form>




<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Rental Membership -New Quotation  </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="nc_close"><spring:message code="sal.btn.close" /></a></p></li>
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
           <input type="text" title="" id="ORD_NO_P" name="ORD_NO_P" placeholder="" class="" /><p class="btn_sky"  id='cbt'> <a href="#" onclick="javascript: fn_doConfirm()"> Confirm</a></p>   <p class="btn_sky" id='sbt'><a href="#" onclick="javascript: fn_goCustSearch()">Search</a></p>
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
            <li><a href="#" onclick="javascript:AUIGrid.resize(bsHistoryGridID, 950,380);">BS History</a></li>
            <li><a href="#"  onclick="javascript:AUIGrid.resize(oListGridID, 950,380);">Order Product Filter</a></li>
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
        </tbody>
        </table><!-- table end -->


        <aside class="title_line"><!-- title_line start -->
        <h2>Installation Info</h2>
        </aside><!-- title_line end -->

        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:180px" />
            <col style="width:*" />
        </colgroup>
        <tr>
            <th scope="row">Instalation Address</th>
            <td><span id='address'></span></td>
        </tr>
        </tbody>
        </table><!-- table end -->




        <aside class="title_line"><!-- title_line start -->
        <h2>Outstanding Info</h2>
        </aside><!-- title_line end -->

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
        <tr>
            <th scope="row">Order Outstanding</th>
            <td><span id='ordoutstanding'></span></td>
            <th scope="row">AS Outstanding</th>
            <td><span id='asoutstanding'></span></td>
            <th scope="row">Membership Outstanding</th>
            <td><span id='memoutstanding'></span></td>
        </tr>
        </tbody>
        </table><!-- table end -->




        <aside class="title_line"><!-- title_line start -->
        <h2>Latest Membership Info</h2>
        </aside><!-- title_line end -->

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
        <tr>
            <th scope="row">Membership Package</th>
            <td colspan="3"><span></span></td>
            <th scope="row">Membership Expire</th>
            <td><span id='expire'> </span></td>
        </tr>
        </tbody>
        </table><!-- table end -->




        <aside class="title_line"><!-- title_line start -->
        <h2>Customer Info</h2>
        </aside><!-- title_line end -->

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
        <tr>
            <th scope="row">Customer ID</th>
            <td><span  id='custId'> </span></td>
            <th scope="row">Customer Type</th>
            <td colspan="3"><span  id='custType'> </span></td>
        </tr>
        <tr>
            <th scope="row">Customer Name</th>
            <td colspan="5"><span id='custName'></span></td>
        </tr>
        <tr>
            <th scope="row">NRIC/Company No</th>
            <td colspan="5"><span id='custNric'> </span></td>
        </tr>
        </tbody>
        </table><!-- table end -->


        <p class="brown_text mt10">(Is Charge = Yes : Filter service charges is depends on the filter expiration date)</p>
        </article><!-- tap_area end -->

        <article class="tap_area"><!-- tap_area start -->
        <!--
        <ul class="left_btns mb10">
            <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_goContactPersonPop()">Other Contact Person</a></p></li>
           <li><p class="btn_blue2"><a href="#" onclick="fn_goNewContactPersonPop()">New Contact Person</a></p></li>
        </ul>
         -->
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
            <select class="w100p" id='cTPackage' name='cTPackage'   onchange="fn_cTPackageChanged()"></select>
            </td>

             <th scope="row">Employee </th>
                <td>
                <select  style="width:80px"  id="cEmplo"    onchange="fn_cTPackageChanged()">
                    <option value="1">Y</option>
                    <option selected="selected" value="0">N</option>
                </select>
                </td>


            <th ></th>
            <td width='80px'> </td>
        </tr>
        <tr>
            <th scope="row">Package Promotion</th>
            <td>
                    <div  style="display:none"> <label><input type="checkbox" disabled="disabled"  id="packpro"   name="packpro" onclick="fn_doPackagePro(this)" /><span></span></label> </div>
                    <select   id="cPromotionpac" name="cPromotionpac"   onchange="fn_cPromotionpacChgEvt()"> </select>
            </td>
            <th scope="row">Monthly Fee</th>
            <td  colspan="3"> <input type="text" title="" placeholder="" class="readonly"  style="width:100px" id="txtMonthlyFee" name="txtMonthlyFee"  /> </td>
        </tr>
        <tr>
            <th scope="row">Filter Promotion</th>
            <td>
         <div  style="display:none">   <label><input type="checkbox" disabled="disabled"  id="cPromoCombox"   name="cPromoCombox" onclick="fn_doPromoCombox(this)" /><span></span></label></div>
            <select   id="cPromo" name='cPromo' onchange="fn_getFilterChargeList()"></select>
            </td>
            <th scope="row">Filter Price</th>
            <td colspan="2"> <input type="text" title="" placeholder="" class="readonly"  style="width:100px" id="txtFilterCharge" name="txtFilterCharge"  />
             </td>
            <td>
                  <div  id="btnViewFilterCharge" class="right_btns"  style="display:none" >
                        <p class="btn_sky"><a href="#" onclick="javascript:fn_LoadMembershipFilter()">Detail</a></p>
                   </div>
        </tr>


        <tr>
             <th scope="row">BS Frequency</th>
            <td colspan="5" ><span id='txtBSFreq'></span></td>
        </tr>


        <tr>
            <th scope="row">Sales Person Code</th>
            <td><input type="text" title="" placeholder="" class=""  style="width:100px" id="SALES_PERSON" name="SALES_PERSON"  />
                <p class="btn_sky"  id="sale_confirmbt" ><a href="#" onclick="javascript:fn_goSalesConfirm()">Confirm</a></p>
                <p class="btn_sky"  id="sale_searchbt"><a href="#" onclick="javascript:fn_goSalesPerson()" >Search</a></p>
                <p class="btn_sky"  id="sale_resetbt" style="display:none"><a href="#" onclick="javascript:fn_goSalesPersonReset()" >Reset</a></p>
            </td>
            <th scope="row">Sales Person Code</th>
            <td colspan="3">
                  <span id="SALES_PERSON_DESC"  name="SALES_PERSON_DESC"></span>   </td>
        </tr>
        <tr>
            <th scope="row">Remark</th>
            <td colspan="5" ><textarea cols="20" rows="5" id='txtRemark' name=''></textarea></td>
        </tr>
        </tbody>
        </table><!-- table end -->
        </form>
        </section><!-- search_table end -->


        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_save()">Save</a></p></li>
            <!-- <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_back()">Back</a></p></li>

          <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_saveResultTrans()">test</a></p></li> -->
        </ul>

</div>
</section>

</section><!-- content end -->


</section>

</div>
