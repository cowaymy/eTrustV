<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">


var  regGridID;
var  myFltGrd10;

$(document).ready(function(){
    
    createAUIGrid();
    createCFilterAUIGrid() ;

    
    //add_CreateAUIGrid();
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(myFltGrd10, "addRow", auiAddRowHandler);
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(myFltGrd10, "removeRow", auiRemoveRowHandler);
    
    
    fn_getErrMstList('${ORD_NO}');
    
    doGetCombo('/services/as/getASFilterInfo.do?AS_ID='+'${AS_ID}', '', '','ddlFilterCode', 'S' , '');            // Customer Type Combo Box
    doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=336', '', '','ddlFilterExchangeCode', 'S' , '');    
    doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=166', '', '','ddlFailReason', 'S' , '');    
    
   // doGetCombo('/services/as/getASMember.do', '', '','ddlCTCode', 'S' , '');    
    //doGetCombo('/services/as/getBrnchId.do', '', '','ddlDSCCode', 'S' , '');   
    
    doGetCombo('/services/as/inHouseGetProductMasters.do', '', '','productGroup', 'S' , '');         
    
    
    
    fn_getASOrderInfo();
    fn_getASEvntsInfo();
    fn_getASHistoryInfo();
    
    fn_DisablePageControl();
    $("#ddlStatus").attr("disabled", false); 

    AUIGrid.resize(myFltGrd10, 950,200);
    
    
    //get inhouse close data
    if('${REF_REQST}' >0){
        fn_getASRulstSVC0004DInfo();
        fn_getASRulstEditFilterInfo();
        $("#IN_HOUSE_CLOSE").val("Y"); 
        $("#btnSaveDiv").attr("style","display:inline");
    }
    
    //inhouse close of  auto 
    if('${IS_AUTO}' == "true"){
        $("#inHouseRepair_div").attr("style","display:none");
    }
    
    
});



function fn_inHouseAutoClose(){
	if('${IS_AUTO}' == "true"){
		
	    $("#ddlStatus").attr("disabled", false); 
		$('#ddlStatus').val("4");
		fn_doSave();
		setTimeout(function(){ $("#_newASResultDiv1").remove();  }, 2000);
    }
}



function fn_getErrMstList(_ordNo){
	 
     var SALES_ORD_NO = _ordNo ;
     $("#ddlErrorCode option").remove();
     doGetCombo('/services/as/getErrMstList.do?SALES_ORD_NO='+SALES_ORD_NO, '', '','ddlErrorCode', 'S' , '');         
     
   
}



function fn_errMst_SelectedIndexChanged(){
    

     $('#ddlErrorCode').removeAttr("disabled").removeClass("readonly");  
     var DEFECT_TYPE_CODE = $("#ddlErrorCode").val();

     $("#ddlErrorDesc option").remove();
     doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE='+DEFECT_TYPE_CODE, '', '','ddlErrorDesc', 'S' , 'fn_errDetail_SetVal');            
     //$("#ddlErrorCode").attr("disabled", true); 
}


function fn_errDetail_SetVal(){
	 $("#ddlErrorDesc").val( asMalfuncResnId); 
}




function fn_getASRulstEditFilterInfo(){
    Common.ajax("GET", "/services/as/getASRulstEditFilterInfo", {REF_REQST:$('#REF_REQST').val() } , function(result) {
        console.log("fn_getASRulstEditFilterInfo.");
        console.log( result);
        
       if(result != null){
           if(result.length >0 ){
              // console.log(result);
               for( i  in  result){
                   console.log(result[i]);
                   AUIGrid.addRow(myFltGrd10, result[i], "last"); 
               }
           }
       } 
       
    });  
}



function fn_getASRulstSVC0004DInfo(){
    
    Common.ajax("GET", "/services/as/getASRulstSVC0004DInfo", $("#resultASForm").serialize(), function(result) {
        console.log("fn_getASRulstSVC0004DInfo.");
        console.log( result);
        
        if(result !=""){
               fn_setSVC0004dInfo(result);
        }
        
    });
    
}



var productCode ;
var asMalfuncResnId ;
function  fn_setSVC0004dInfo(result){
    
    $("#creator").val( result[0].c28); 
    $("#creatorat").val( result[0].asResultCrtDt); 
    $("#txtResultNo").text( result[0].asResultNo); 
    
    if('${REF_REQST}' >0){
         $("#txtResultNo").text(""); 
    }
    
    $("#ddlStatus").val( result[0].asResultStusId); 
    $("#dpSettleDate").val( result[0].asSetlDt); 
    $("#ddlFailReason").val( result[0].c2); 
    $("#tpSettleTime").val( result[0].asSetlTm); 
    $("#ddlDSCCode").val( result[0].asBrnchId); 
    $("#ddlErrorCode").val( result[0].asMalfuncId); 
    $("#ddlErrorDesc").val( result[0].asMalfuncResnId);
    
    asMalfuncResnId =result[0].asMalfuncResnId;
    
    fn_errMst_SelectedIndexChanged(result[0].asMalfuncResnId);
    
    $("#ddlCTCodeText").val( result[0].c12); 
    $("#ddlCTCode").val( result[0].c11); 
    $("#CTID").val( result[0].c11); 
    
    $("#ddlWarehouse").val( result[0].asWhId); 
    $("#txtRemark").val( result[0].asResultRem); 
    
    if(result[0].c27 =="1"){
            $("#iscommission").attr("checked",true);
    }
    
    $('#def_type') .val( result[0].c16);
    $('#def_type_text') .val( result[0].c17);
    $('#def_type_id') .val( result[0].asDefectTypeId);  
     
    $('#def_code') .val( result[0].c18);
    $('#def_code_text') .val( result[0].c19);
    $('#def_code_id') .val( result[0].asDefectId);
    
    $('#def_def').val( result[0].c22); 
    $('#def_def_text').val( result[0].c23);
    $('#def_def_id').val( result[0].asDefectDtlResnId);     
    
    $('#def_part') .val( result[0].c20);
    $('#def_part_text') .val( result[0].c21);
    $('#def_part_id') .val( result[0].asDefectPartId);
    
    
    $('#solut_code').val( result[0].c25); 
    $('#solut_code_text').val( result[0].c26); 
    $('#solut_code_id').val( result[0].c24); 
    
    $('#asInHouseComDt').val( result[0].asResultDt); 
    
    
    
    if(result[0].c25 =="B8"  ||  result[0].c25 =="B6" ){
        $("#inHouseRepair_div").attr("style" ,"display:inline");
    }
    
    if( result[0].inHuseRepairReplaceYn =="1"){
        $("input:radio[name='replacement']:radio[value='1']").attr('checked', true); // 원하는 값(Y)을 체크
    }else if (result[0].inHuseRepairReplaceYn =="0"){
        $("input:radio[name='replacement']:radio[value='0']").attr('checked', true); // 원하는 값(Y)을 체크
    }
    
        
    $("#promisedDate").val(result[0].inHuseRepairPromisDt);
    $("#productGroup").val( result[0].inHuseRepairGrpCode);
    $("#productCode").val(result[0].inHuseRepairProductCode);
    $("#serialNo").val(result[0].inHuseRepairSerialNo);
    $("#inHouseRemark").val(result[0].inHuseRepairRem);
    $("#APPNT_DT").val(result[0].appntDt);
    $("#asResultCrtDt").val(result[0].asResultCrtDt);
    
    productCode = result[0].inHuseRepairProductCode;
    
    
    if( typeof(productCode) !=  "undefined"){
        doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID='+result[0].inHuseRepairGrpCode, '', '','productCode', 'S' , 'fn_inHouseGetProductDetails');         
    }
    
    $('#txtLabourCharge').val(result[0].asWorkmnsh);
    $('#txtFilterCharge').val(result[0].asFilterAmt);
    $('#txtTotalCharge').val(result[0].asTotAmt);
    
    
    setTimeout(function(){ fn_inHouseAutoClose();  }, 2000);
    
    
}

function fn_inHouseGetProductDetails(){
    $("#productCode").val(productCode);
}



//행 추가 이벤트 핸들러
function auiAddRowHandler(event) {
	//alert('추가');
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {
	
	
//alert('삭제');

}

function createAUIGrid() {
    
    var columnLayout = [
                        {dataField : "asNo",     headerText  : "Type" ,editable       : false  } ,
                        { dataField : "c2", headerText  : "ASR No",  width  : 80 , editable       : false ,dataType : "date", formatString : "dd/mm/yyyy"},
                        { dataField : "code", headerText  : "Status ",  width  : 80 },
                        { dataField : "asCrtDt",       headerText  : "Request Date",  width  : 100 ,editable       : false  ,dataType : "date", formatString : "dd/mm/yyyy"},
                        { dataField : "asStelDt",       headerText  : "Settle Date",  width  : 100 ,editable       : false  ,dataType : "date", formatString : "dd/mm/yyyy"},
                        { dataField : "c3",     headerText  : "Error Code",  width          :150,    editable       : false },
                        { dataField : "c4",     headerText  : "Error Desc",  width          :150,    editable       : false },
                        { dataField : "c5",     headerText  : "CT Code",  width          :150,    editable       : false },
                        { dataField : "c6",     headerText  : "Solution",  width          :150,    editable       : false},
                        { dataField : "c7",     headerText  : "Amount",  width          :150,    dataType:"numeric", formatString : "#,##0.00" ,editable       : false  }
   ];   
   
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true};  
    regGridID= GridCommon.createAUIGrid("reg_grid_wrap", columnLayout  ,"" ,gridPros);
}
   


function createCFilterAUIGrid() {
    
        var  clayout = [
                            {dataField : "filterType",     headerText  : "AS NO" ,editable       : false  } ,
                            { dataField : "filterDesc",      headerText  : "Description",  width  : 80 },
                            { dataField : "filterExCode", headerText  : "Exchange Code ",  width  : 80 },
                            { dataField : "filterQty",       headerText  : "Qty",  width  : 100 },
                            { dataField : "filterPrice",       headerText  : "Price",  width  : 100 },
                            { dataField : "filterTotal",     headerText  : "Total",  width          :150},
                            { dataField : "filterRemark",     headerText  : "Remark",  width          :150,    editable       : false },
                            { dataField : "srvFilterLastSerial",     headerText  : "Serial No",  width          :200,    editable       : true },
                            {
                                dataField : "undefined",
                                headerText : " ",
                                width           : 110,    
                                renderer : {
                                    type : "ButtonRenderer",
                                    labelText : "Remove",
                                    onclick : function(rowIndex, columnIndex, value, item) {
                                         AUIGrid.removeRow(myFltGrd10, rowIndex);
                                    }
                                }
                            },
                            { dataField : "filterID",     headerText  : "filterID",  width          :150,   visible:false}
                            
                            
                            
     ];   

    var gridPros2 = { usePaging : true,  pageRowCount: 20, editable: true, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true};  
    
     myFltGrd10 = GridCommon.createAUIGrid("asfilter_grid_wrap", clayout  ,"" ,gridPros2);
     
     AUIGrid.resize(myFltGrd10, 950,200);  
}

    

function fn_getASOrderInfo(){
        Common.ajax("GET", "/services/as/getASOrderInfo.do", $("#resultASForm").serialize(), function(result) {
            console.log("fn_getASOrderInfo.");
            
            console.log(result);
            
            $("#txtASNo").text($("#AS_NO").val());
            $("#txtOrderNo").text(result[0].ordNo);
            $("#txtAppType").text(result[0].appTypeCode);
            $("#txtCustName").text(result[0].custName);
            $("#txtCustIC").text(result[0].custNric);
            $("#txtContactPerson").text(result[0].instCntName);
            
            $("#txtTelMobile").text(result[0].instCntTelM);
            $("#txtTelResidence").text(result[0].instCntTelR);
            $("#txtTelOffice").text(result[0].instCntTelO);
            $("#txtInstallAddress").text(result[0].instCntName);
            
            $("#txtProductCode").text(result[0].stockCode);
            $("#txtProductName").text(result[0].stockDesc);
            $("#txtSirimNo").text(result[0].lastInstallSirimNo);
            $("#txtSerialNo").text(result[0].lastInstallSerialNo);
            
            $("#txtCategory").text(result[0].c2);
            $("#txtInstallNo").text(result[0].lastInstallNo);
            $("#txtInstallDate").text(result[0].c1);
            $("#txtInstallBy").text(result[0].lastInstallCtCode);
            $("#txtInstruction").text(result[0].instct);
            $("#txtMembership").text(result[0].c5);
            $("#txtExpiredDate").text(result[0].c6);
            
           
            
        });
}


function fn_getASEvntsInfo(){
    Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm").serialize(), function(result) {
        console.log("getASEvntsInfo.");
        console.log( result);
      
        $("#txtASStatus").text(result[0].code);
        $("#txtRequestDate").text(result[0].asReqstDt);
        $("#txtRequestTime").text(result[0].asReqstTm);
        $("#txtMalfunctionCode").text(result[0].asMalfuncId);
        $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);
        $("#txtDSCCode").text(result[0].c7 +"-" +result[0].c8 );
        $("#txtInchargeCT").text(result[0].c10 +"-" +result[0].c11 );
        
        $("#txtRequestor").text(result[0].c3);
        $("#txtASKeyBy").text(result[0].c1);
        $("#txtRequestorContact").text(result[0].asRemReqsterCntc); 
        $("#txtASKeyAt").text(result[0].asCrtDt);
        
        
    });
}


function fn_getASHistoryInfo(){
    
    Common.ajax("GET", "/services/as/getASHistoryInfo.do", $("#resultASForm").serialize(), function(result) {
        console.log("fn_getASHistoryInfo.");
        console.log( result);
        AUIGrid.setGridData(regGridID, result);        
    });
    
}


function fn_getASReasonCode2(_obj , _tobj, _v){
    
    
    //txtDefectType.Text.Trim(), 387
    
    var   reasonCode =$(_obj).val();
    var   reasonTypeId =_v;
    
    Common.ajax("GET", "/services/as/getASReasonCode2.do", {RESN_TYPE_ID: reasonTypeId  ,CODE:reasonCode} , function(result) {
        console.log("fn_getASHistoryInfo.");
        console.log( result);
        
        if(result.length >0 ){
            $("#"+_tobj+"_text").val((result[0].resnDesc.trim()).trim());
            $("#"+_tobj+"_id").val(result[0].resnId);
            
            
                if('337' == _v){
                    if(  result[0].codeId.trim()   =='B8'  ||   result[0].codeId.trim()   =='B6' ) {  //Solution Code  B8인 경우만 가능함 .
    
                        $("#replacement").attr("disabled", false); 
                        $("#promisedDate").attr("disabled", false); 
                        $("#productGroup").attr("disabled", false); 
                        $("#productCode").attr("disabled", false); 
                        $("#serialNo").attr("disabled", false); 
                        $("#inHouseRemark").attr("disabled", false); 
                        
                        $("#inHouseRepair_div").attr("style","display:inline");
                        
                        
                    }else{
    
                        $("#replacement").val("").attr("disabled", true); 
                        $("#promisedDate").val("").attr("disabled", true); 
                        $("#productGroup").val("").attr("disabled", true); 
                        $("#productCode").val("").attr("disabled", true); 
                        $("#serialNo").val("").attr("disabled", true); 
                        $("#inHouseRemark").val("").attr("disabled", true); 
                        
                        $("#inHouseRepair_div").attr("style","display:none");
                        
                    }
                 }
        }else{
            
               $("#"+_tobj+"_text").val("* No such detail of defect found.");
        }
    });
    
}




function getASStockPrice(_PRC_ID){
    
    var ret = 0;
    
    Common.ajaxSync("GET", "/services/as/getASStockPrice.do",{PRC_ID: _PRC_ID}, function(result) {
        console.log("getASStockPrice.");
        console.log( result);
        
        try{
            ret = parseInt( result[0].amt,10);
        }catch(e){
            alert('SAL0016M no data ');
            ret = 0;
        }
    });
    
    return ret;
    
}





function fn_chStock(){
    
    var   ct = $("#ddlCTCodeText").val();
    var   sk = $("#ddlFilterCode").val();


    var  availQty =isstckOk(ct ,sk);

    if(availQty == 0){
        Common.alert('*<b> There are no available stocks.</b>');
        fn_filterClear();
        return  false;
    }else{
        
        if  ( availQty  <  Number($("#ddlFilterQty").val()) ){
            Common.alert('*<b> Not enough available stock to the member.  <br> availQty['+ availQty +'] </b>');
            fn_filterClear();
            return false ;
        }
        return true;
    }
}


function isstckOk(ct , sk){
    
    var availQty = 0;
    
    Common.ajaxSync("GET", "/services/as/getSVC_AVAILABLE_INVENTORY.do",{CT_CODE: ct  , STK_CODE: sk }, function(result) {
            console.log("isstckOk.");
            console.log( result);
            availQty = result.availQty;
    });
    
    
    return availQty;
}



function fn_filterAddVaild(){
	
     if(FormUtil.checkReqValue($("#ddlFilterCode option:selected")) ){    
        return false;
     }
    
     if(FormUtil.checkReqValue($("#ddlFilterQty option:selected")) ){    
         return false;
     }
     
     if(FormUtil.checkReqValue($("#ddlFilterPayType option:selected")) ){    
         return false;
      } 
     
     if(FormUtil.checkReqValue($("#ddlFilterExchangeCode option:selected")) ){    
         return false;
      }
}


function fn_filterAdd(){
    
	if(fn_chStock() ==false){
		   return ;
	}
	
    if(fn_filterAddVaild() ==false){
        Common.alert('*<b>Please fill up the compulsory fields to add the filter.</b>');
        return  false;
    }
    
    
     var  fitem = new Object();
         
        fitem.filterType =$("#ddlFilterPayType").val();
        fitem.filterDesc =$("#ddlFilterCode option:selected").text();
        fitem.filterExCode =$("#ddlFilterExchangeCode").val();
        fitem.filterQty =$("#ddlFilterQty").val();  
        fitem.filterRemark =$("#txtFilterRemark").val();    
        fitem.filterID =$("#ddlFilterCode").val(); 
        //fitem.filterCODE =$("#ddlFilterCode").va();
       fitem.srvFilterLastSerial  =$("#ddSrvFilterLastSerial").val();  
        
        var chargePrice =0;
        if (fitem.filterType  == "CHG") {
            chargePrice  = getASStockPrice(fitem.filterID);        
        }
        
        fitem.filterPrice = Number(chargePrice);
        
        var  chargeTotalPrice = 0;
        
        chargeTotalPrice =  Number($("#ddlFilterQty").val())  *  Number( chargePrice);
        fitem.filterTotal =   Number(chargeTotalPrice);
        
        
        var v =  Number(  $("#txtFilterCharge").val() ) + chargeTotalPrice;
        $("#txtFilterCharge").val( v);
        
        
    if( AUIGrid.isUniqueValue (myFltGrd10,"filterID" ,fitem.filterID )){
         fn_addRow(fitem);
    }else{
        Common.alert("<b>This filter/spart part is existing. </br>");
        return ;
    }
    
    fn_calculateTotalCharges();
}


function fn_filterClear(){
    
    
      $("#ddlFilterCode").val("");
      $("#ddlFilterQty").val("1");
      $("#ddlFilterPayType").val("1");
      $("#ddlFilterExchangeCode").val("");
      $("#ddSrvFilterLastSerial").val("");
      $("#txtFilterRemark").val("");
    
      //AUIGrid.clearGridData(myFltGrd10);
        
}


//행 추가, 삽입
function  fn_addRow(gItem) {      
  AUIGrid.addRow(myFltGrd10, gItem, "first");
}


function fn_LabourCharge_CheckedChanged(_obj){
    
      if(_obj.checked){
          $('#cmbLabourChargeAmt').removeAttr("disabled").removeClass("readonly");     
          $("#cmbLabourChargeAmt").val("50");
          $("#txtLabourCharge").val("50.00");
      }else{
          $("#cmbLabourChargeAmt").val("");
          $("#cmbLabourChargeAmt").attr("disabled", true); 
      }
      
      fn_calculateTotalCharges();
}



function fn_calculateTotalCharges(){
    
    var  labourCharges =0;
    var filterCharges =0; 
    var totalCharges =0;
    
    labourCharges =   $("#txtLabourCharge").val();
    filterCharges   =   $("#txtFilterCharge").val();  
    totalCharges = Number( labourCharges ) + Number( filterCharges);
    
    $("#txtTotalCharge").val(totalCharges);  
    
}


function fn_cmbLabourChargeAmt_SelectedIndexChanged(){
    
    var  v =$("#cmbLabourChargeAmt").val();
    $("#txtLabourCharge").val(v);
    fn_calculateTotalCharges();
}




function fn_ddlStatus_SelectedIndexChanged(){
    
    fn_clearPageField();
    
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    $("#ddlCTCode").val(selectedItems[0].item.asMemId);
    $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
    $("#ddlCTCodeText").val(selectedItems[0].item.memCode);
    $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);
    
    
    switch ($("#ddlStatus").val()) {
        case "4":
            //COMPLETE
            fn_openField_Complete();
            break;
            
        case "1":   //inhouse
            fn_openField_Complete();
            break;
            
        case "10":
            //CANCEL
            fn_openField_Cancel();
            break;
        case "21":
            //FAILED
            fn_openField_Fail();
            break;
        default:
            break;
    }
}



function fn_openField_Complete(){
    
    $("#btnSaveDiv").attr("style","display:inline");
    $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");     
    $('#tpSettleTime').removeAttr("disabled").removeClass("readonly");     
    $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");     
    $('#ddlCTCode').removeAttr("disabled").removeClass("readonly");    
    $('#ddlErrorCode').removeAttr("disabled").removeClass("readonly");     
    $('#ddlErrorDesc').removeAttr("disabled").removeClass("readonly");    
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");  
    $('#iscommission').removeAttr("disabled").removeClass("readonly");  
    $('#def_type').removeAttr("disabled").removeClass("readonly");  
    $('#def_code').removeAttr("disabled").removeClass("readonly");  
    $('#def_part').removeAttr("disabled").removeClass("readonly");  
    $('#solut_code').removeAttr("disabled").removeClass("readonly");  
    $('#def_def').removeAttr("disabled").removeClass("readonly");  
    
    
    $('#def_type_text').removeAttr("disabled").removeClass("readonly");  
    $('#def_code_text').removeAttr("disabled").removeClass("readonly");  
    $('#def_part_text').removeAttr("disabled").removeClass("readonly");  
    $('#solut_code_text').removeAttr("disabled").removeClass("readonly");  
    $('#def_def_text').removeAttr("disabled").removeClass("readonly");  
    
     
    
    $("#txtFilterCharge").attr("disabled", false); 
    $("#txtLabourCharge").attr("disabled", false); 
    $("#cmbLabourChargeAmt").attr("disabled", false); 
    $("#ddlFilterCode").attr("disabled", false); 
    $("#ddlFilterQty").attr("disabled", false); 
    $("#ddlFilterPayType").attr("disabled", false); 
    $("#ddlFilterExchangeCode").attr("disabled", false); 
    $("#txtFilterRemark").attr("disabled", false); 
    fn_clearPanelField_ASChargesFees();
    
    

    $("#ddlFilterQty").val("1"); 
    $("#ddlFilterPayType").val("FOC"); 
    
}

function fn_openField_Cancel(){
    
    $("#btnSaveDiv").attr("style","display:inline");
    $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");  
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");  
}


function fn_openField_Fail(){
    
       $("#btnSaveDiv").attr("style","display:inline");
       $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");  
       $('#txtRemark').removeAttr("disabled").removeClass("readonly");  
}






function fn_clearPageMessage(){
    
}


function fn_clearPageField(){

    $("#btnSaveDiv").attr("style","display:none");
    $('#dpSettleDate').val("").attr("disabled", true); 
    $('#ddlFailReason').val("").attr("disabled", true); 
    $('#tpSettleTime').val("").attr("disabled", true); 
    $('#ddlDSCCode').val("").attr("disabled", true); 
    $('#ddlErrorCode').val("").attr("disabled", true); 
    $('#ddlCTCode').val("").attr("disabled", true); 
    $('#ddlErrorDesc').val("").attr("disabled", true);
    $('#ddlWarehouse').val("").attr("disabled", true); 
    $('#txtRemark').val("").attr("disabled", true); 
    $("#iscommission").attr("disabled", true); 
    
    
    fn_clearPanelField_ASChargesFees();
    $("#ddlFilterCode").val("").attr("disabled", true); 
    $("#ddlFilterQty").val("").attr("disabled", true); 
    $("#ddlFilterPayType").val("").attr("disabled", true); 
    $("#ddlFilterExchangeCode").val("").attr("disabled", true); 
    $("#txtFilterRemark").val("").attr("disabled", true); 
    
    $("#txtLabourCharge").val("0.00").attr("disabled", true); 
    $("#txtFilterCharge").val("0.00").attr("disabled", true); 
    
    
    $("#ddlCTCode").val("");
    $("#ddlDSCCode").val("");
    $("#ddlCTCodeText").val("");
    $("#ddlDSCCodeText").val("");
    
    
}


function fn_doSave(){
    
    if ( ! fn_validRequiredField_Save_ResultInfo()) {
       return ;
    }
    
   if($("#ddlStatus").val()==4  ||  $("#ddlStatus").val()==1   ){
         
         //COMPLETE STATUS
          if (! fn_validRequiredField_Save_DefectiveInfo()) {
                 return ;
          }
       
   }
   
   fn_setSaveFormData();
}


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};



function  fn_setSaveFormData(){
    
    //추가된 행 아이템들(배열)
    var addedRowItems = AUIGrid.getAddedRowItems(myFltGrd10);
        
    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowItems(myFltGrd10); 
       
    //삭제된 행 아이템들(배열)
    var removedRowItems = AUIGrid.getRemovedItems(myFltGrd10);
    
    
    var _AS_DEFECT_TYPE_ID =0;     
    var _AS_DEFECT_GRP_ID=0;       
    var _AS_DEFECT_ID=0;              
    var _AS_DEFECT_PART_GRP_ID=0;   
    var _AS_DEFECT_PART_ID=0;          
    var _AS_DEFECT_DTL_RESN_ID=0;    
    var _AS_SLUTN_RESN_ID=0;        
    
    if( $('#ddlStatus').val()  =='4'  ||  $('#ddlStatus').val() =='1'){
             _AS_DEFECT_TYPE_ID =          $('#def_type_id').val(); 
             _AS_DEFECT_ID=                   $('#def_code_id').val() ;
             _AS_DEFECT_PART_ID=          $('#def_part_id').val(); 
             _AS_DEFECT_DTL_RESN_ID=   $('#def_def_id').val() ; 
             _AS_SLUTN_RESN_ID=           $('#solut_code_id').val(); 
     }
        
    
    var asResultM ={
                   AS_NO:                      "${AS_NO}",
                   AS_ENTRY_ID:              "${AS_ID}",
                   AS_SO_ID:                   $("#ORD_ID").val(),
                   AS_ORD_NO:                $("#ORD_NO").val(),
                   AS_CT_ID:                   $('#ddlCTCode').val(),
                   AS_SETL_DT:               $('#dpSettleDate').val() , 
                   AS_SETL_TM:               $('#tpSettleTime').val(),   
                   AS_RESULT_STUS_ID:    $('#ddlStatus').val(),  
                   AS_FAIL_RESN_ID:         $('#ddlFailReason').val(),  
                   AS_REN_COLCT_ID:        0,
                   AS_CMMS:                   $("#iscommission").prop("checked") ? '1': '0' ,    
                   AS_BRNCH_ID:              $('#ddlDSCCode').val() , 
                   AS_WH_ID:                  $('#ddlWarehouse').val() ,
                   AS_RESULT_REM:          $('#txtRemark').val() ,
                   AS_MALFUNC_ID:          $('#ddlErrorCode').val() ,
                   AS_MALFUNC_RESN_ID:  $('#ddlErrorDesc').val() , 
                    AS_DEFECT_TYPE_ID :_AS_DEFECT_TYPE_ID ,     
                    AS_DEFECT_GRP_ID:_AS_DEFECT_GRP_ID,     
                    AS_DEFECT_ID:_AS_DEFECT_ID,         
                    AS_DEFECT_PART_GRP_ID:_AS_DEFECT_PART_GRP_ID,
                    AS_DEFECT_PART_ID:_AS_DEFECT_PART_ID, 
                    AS_DEFECT_DTL_RESN_ID:_AS_DEFECT_DTL_RESN_ID,
                    AS_SLUTN_RESN_ID:_AS_SLUTN_RESN_ID,
                   AS_WORKMNSH:                  $('#txtLabourCharge').val()  ,
                   AS_FILTER_AMT:                  $('#txtFilterCharge').val()  , 
                   AS_ACSRS_AMT:                 0,
                   AS_TOT_AMT:                    $('#txtTotalCharge').val()  ,   
                   AS_RESULT_IS_SYNCH:        0,
                   AS_RCALL:                         0,
                   AS_RESULT_STOCK_USE:   addedRowItems.length  >0 ? 1:0,//detail 리스트 카운트  
                   AS_RESULT_TYPE_ID:   457,
                   AS_RESULT_IS_CURR: 1,
                   AS_RESULT_MTCH_ID:  0,
                   AS_RESULT_NO_ERR: '',
                   AS_ENTRY_POINT:  0,
                   AS_WORKMNSH_TAX_CODE_ID: 0,
                   AS_WORKMNSH_TXS: 0,
                   AS_RESULT_MOBILE_ID: 0,
                   IN_HUSE_REPAIR_REM: $("#inHouseRemark").val(),
                   IN_HUSE_REPAIR_REPLACE_YN:$("#replacement").val(),
                   IN_HUSE_REPAIR_PROMIS_DT: $("#promisedDate").val(),
                   IN_HUSE_REPAIR_GRP_CODE: $("#productGroup").val(),
                   IN_HUSE_REPAIR_PRODUCT_CODE: $("#productCode").val(),
                   IN_HUSE_REPAIR_SERIAL_NO: $("#serialNo").val(),
                   CHANGBN:'WEB',
                   IN_HOUSE_CLOSE:  $("#IN_HOUSE_CLOSE").val()
    }
    
    var  saveForm ={
            "asResultM": asResultM ,
            "add" : addedRowItems,
            "update" : editedRowItems,
            "remove" : removedRowItems
    }
    
    
    console.log(saveForm);
    
    
    Common.ajax("POST", "/services/as/newASInHouseAdd.do", saveForm, function(result) {
        console.log("newASInHouseAdd.");
        console.log( result);       
        
        if(result.data !=""){
            Common.alert("<b>AS result successfully saved.</b>  New ResultNo["+result.data+"] </b>");
              $("#txtResultNo").html( "<font size='3' color='red'> <b> " +result.data+ " </b></font>");  
              fn_DisablePageControl();
            
        }
    });
    
}



function   fn_clearPanelField_ASChargesFees(){
    
      $('#ddlFilterCode').val("") ;
      $('#ddlFilterQty').val(""); 
      $('#ddlFilterPayType').val("") ;
      $('#ddlFilterExchangeCode').val("") ;
      $('#txtFilterRemark').val("") ;
          
}



function fn_DisablePageControl(){
    
    $("#ddlStatus").attr("disabled", true); 
    $("#dpSettleDate").attr("disabled", true); 
    $("#ddlFailReason").attr("disabled", true); 
    $("#ddlStatus").attr("disabled", true); 
    $("#tpSettleTime").attr("disabled", true); 
    $("#ddlDSCCode").attr("disabled", true); 
    $("#ddlErrorCode").attr("disabled", true); 
    $("#ddlErrorDesc").attr("disabled", true); 
    $("#ddlCTCode").attr("disabled", true); 
    $("#ddlWarehouse").attr("disabled", true); 
    $("#txtRemark").attr("disabled", true); 
    $("#iscommission").attr("disabled", true); 
    
    $("#def_type").attr("disabled", true); 
    $("#def_code").attr("disabled", true); 
    $("#def_def").attr("disabled", true); 
    $("#def_part").attr("disabled", true); 
    $("#solut_code").attr("disabled", true);

    $("#def_type_text").attr("disabled", true); 
    $("#def_code_text").attr("disabled", true); 
    $("#def_def_text").attr("disabled", true); 
    $("#def_part_text").attr("disabled", true); 
    $("#solut_code_text").attr("disabled", true); 
    
    
    $("#ddlWarehouse").attr("disabled", true); 
    
    
    $("#ddlFilterQty").attr("disabled", true); 
    $("#def_code").attr("disabled", true); 
    $("#def_def_id").attr("disabled", true); 
    $("#def_part").attr("disabled", true); 
    $("#solut_code").attr("disabled", true); 
    $("#ddlWarehouse").attr("disabled", true);
    
    
    $("#ddlFilterCode").attr("disabled", true); 
    $("#ddlFilterQty").attr("disabled", true); 
    $("#ddlFilterPayType").attr("disabled", true); 
    $("#ddlFilterExchangeCode").attr("disabled", true); 
    $("#txtFilterRemark").attr("disabled", true); 
    fn_clearPanelField_ASChargesFees();
    
    
    $("#btnSaveDiv").attr("style","display:none");
    
}



function fn_validRequiredField_Save_DefectiveInfo(){
    
       
    var rtnMsg ="";
    var rtnValue =true;
    
    
    if(FormUtil.checkReqValue($("#def_type_id"))){
        rtnMsg  +="Please select the def_type.<br/>" ;
        rtnValue =false; 
    }
    
    
    
    if(FormUtil.checkReqValue($("#def_code_id"))){
        rtnMsg  +="Please select the def_code.<br/>" ;
        rtnValue =false; 
    }
    
    
    if(FormUtil.checkReqValue($("#def_part_id"))){
        rtnMsg  +="Please select the def_part.<br/>" ;
        rtnValue =false; 
    }
    
    if(FormUtil.checkReqValue($("#solut_code_id"))){
        rtnMsg  +="Please select the solut_code.<br/>" ;
        rtnValue =false; 
    }

    if( rtnValue ==false ){
        Common.alert("Some required fields are empty in AS Defective Event." +DEFAULT_DELIMITER +rtnMsg );
    }
    
     return rtnValue;
     
}



function fn_validRequiredField_Save_ResultInfo(){
    
    var rtnMsg ="";
    var rtnValue =true;
    
    if(FormUtil.checkReqValue($("#ddlStatus"))){
        rtnMsg  +="Please select the ddlStatus.<br/>" ;
        rtnValue =false; 
    }else{
        
        if($("#ddlStatus").val()==4   || $("#ddlStatus").val()==1 ){
            
             if(FormUtil.checkReqValue($("#dpSettleDate"))){
                    rtnMsg  +="Please select the dpSettleDate.<br/>" ;
                    rtnValue =false; 
              }else{
                  
                  var asno =$("#txtASNo").val();
                  if(asno.match("AS")){
                         var  nowdate      = $.datepicker.formatDate($.datepicker.ATOM, new Date());
                         var  nowdateArry  =nowdate.split("-");
                                nowdateArry = nowdateArry[0]+""+nowdateArry[1]+""+nowdateArry[2];
                         var  rdateArray   =$("#dpSettleDate").val().split("/");
                         var requestDate  =rdateArray[2]+""+rdateArray[1]+""+rdateArray[0];
                     
                         if((parseInt(requestDate,10)  - parseInt(nowdateArry,10) ) > 14 || (parseInt(nowdateArry,10)  - parseInt(requestDate,10) )   >14){
                            rtnMsg  +="* Request date should not be longer than 14 days from current date.<br />" ;
                            rtnValue =false; 
                        }
                      
                  }               
              }
             
             if(FormUtil.checkReqValue($("#tpSettleTime"))){
                 rtnMsg  +="Please select the tpSettleTime.<br/>" ;
                 rtnValue =false; 
             }
             
             if(FormUtil.checkReqValue($("#ddlDSCCode"))){
                 rtnMsg  +="Please select the ddlDSCCode.<br/>" ;
                 rtnValue =false; 
             }
             
             
              if(FormUtil.checkReqValue($("#ddlErrorCode"))){
                  rtnMsg  +="Please select the ddlErrorCode.<br/>" ;
                  rtnValue =false; 
              }
              
              
              if(FormUtil.checkReqValue($("#ddlCTCode"))){
                  rtnMsg  +="Please select the ddlCTCode.<br/>" ;
                  rtnValue =false; 
              }
        }else{
            
              if(FormUtil.checkReqValue($("#ddlFailReason"))){
                    rtnMsg  +="Please select the ddlFailReason.<br/>" ;
                    rtnValue =false; 
                }
        }
    }
    

    if( rtnValue ==false ){
        Common.alert("Required Fields Missing" +DEFAULT_DELIMITER +rtnMsg );
    }
    
     return rtnValue;
}




$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};




function fn_doClear(){

    $("#ddlStatus").val(""); 
    $("#dpSettleDate").val(""); 
    $("#ddlFailReason").val(""); 
    $("#ddlStatus").val(""); 
    $("#tpSettleTime").val(""); 
    $("#ddlDSCCode").val(""); 
    $("#ddlErrorCode").val(""); 
    $("#ddlErrorDesc").val(""); 
    $("#ddlCTCode").val(""); 
    $("#ddlWarehouse").val(""); 
    $("#txtRemark").val(""); 
    $("#iscommission").val(""); 
    
    $("#def_type").val(""); 
    $("#def_code").val(""); 
    $("#def_def").val(""); 
    $("#def_part").val(""); 
    $("#solut_code").val(""); 

    $("#def_type_id").val(""); 
    $("#def_code_id").val(""); 
    $("#def_def_id").val(""); 
    $("#def_part_id").val(""); 
    $("#solut_code_id").val(""); 
    $("#ddlWarehouse").val(""); 
    
    $("#ddlFilterCode").val(""); 
    $("#ddlFilterQty").val(""); 
    $("#ddlFilterPayType").val("");
    $("#ddlFilterExchangeCode").val(""); 
    $("#txtFilterRemark").val(""); 
    
    AUIGrid.clearGridData(myFltGrd10);
    
}



function fn_chSeriaNo(){
    
    if($("#productGroup option:selected").val() ==""){
        Common.alert("Please select the productGroup.<br/>");
        return ;
    }

    if($("#productCode option:selected").val() ==""){
        Common.alert("Please select the productCode.<br/>");      
        return ;
    }
    
    
    Common.ajax("GET", "/services/as/inHouseIsAbStck.do", {PARTS_SERIAL_NO: $("#serialNo").val()  ,CT_CODE:$("#ddlCTCode").val() } , function(result) {
        console.log("inHouseIsAbStck.");
        console.log( result);
       // var is =false;
         var is =true;
        
        if(result != null){
            //var is =true;
            if(result.isStk  != "0"){
                is= true;
            }
        }
        if(is ==false )   $("#btnSaveDiv").attr("style","display:none");
    });
}


function fn_productGroup_SelectedIndexChanged(){
    
    var STK_CTGRY_ID = $("#productGroup").val();
    
     $("#serialNo").val("");
     $("#productCode option").remove();
    
     doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID='+STK_CTGRY_ID, '', '','productCode', 'S' , '');            
}


</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->


<form id="resultASForm" method="post">
    <div  style="display:none">
            <input type="text" name="ORD_ID"  id="ORD_ID" value="${ORD_ID}"/>  
            <input type="text" name="ORD_NO"   id="ORD_NO"  value="${ORD_NO}"/>
            <input type="text" name="AS_NO"   id="AS_NO"  value="${AS_NO}"/>
            <input type="text" name="AS_ID"   id="AS_ID"  value="${AS_ID}"/>
            <input type="text" name="REF_REQST"   id="REF_REQST"  value="${REF_REQST}"/>
            <input type="text" name="IN_HOUSE_CLOSE"   id="IN_HOUSE_CLOSE" />
    </div>
</form>

<header class="pop_header"><!-- pop_header start -->
<h1>New AS Result Entry</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<form id="resultASAllForm" method="post">
<section class="pop_body"><!-- pop_body start -->
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Product Info</a></li>
    <li><a href="#">AS Events</a></li>
    <li><a href="#" onclick=" javascirpt:AUIGrid.resize(regGridID, 950,300);  ">After Service</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AS No</th>
    <td>
    <span id="txtASNo">AS No</span>
    </td>
    <th scope="row">Order No</th>
    <td>
        <span id="txtOrderNo"></span>
    </td>
    <th scope="row">Application Type</th>
    <td>   
        <span id="txtAppType"></span>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">   <span id="txtCustName"></span> </td>
    <th scope="row">NRIC/Company Np</th>
    <td>   <span id="txtCustIC"></span> </td>
</tr>
<tr>
    <th scope="row">Contact Person</th>
    <td colspan="5">   <span id="txtContactPerson"></span>   </td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td>   <span id="txtTelMobile"></span></td>
    <th scope="row">Tel (Residence)</th>
    <td>   <span id="txtTelResidence"></span> </td>
    <th scope="row">Tel (Office)</th>
    <td>   <span id="txtTelOffice"></span>  </td>
</tr>
<tr>
    <th scope="row">Installation Address</th>
    <td colspan="5">   <span id="txtInstallAddress"></span> </td>
</tr>
<tr>
    <th scope="row">Requestor</th>
    <td colspan="3">   <span id="txtRequestor"></span>  </td>
    <th scope="row">AS Key By</th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Requestor Contact</th>
    <td colspan="3">   <span id="txtRequestorContact"></span>  </td>
    <th scope="row">AS Key At</th>
    <td>   <span id="txtASKeyAt"></span>  </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

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
    <th scope="row">Product Code</th>
    <td>
         <span id="txtProductCode"></span> 
    </td>
    <th scope="row">Product Name</th>
    <td colspan="3">   <span id="txtProductName"></span>   </td>
</tr>
<tr>
    <th scope="row">Sirim No</th>
    <td>   <span id="txtSirimNo"></span> </td>
    <th scope="row">Serial No</th>
    <td>   <span id="txtSerialNo"></span>    </td>
    <th scope="row">Category</th>
    <td>   <span id="txtCategory"></span> </td>
</tr>
<tr>
    <th scope="row">Install No</th>
    <td> <span id="txtInstallNo"></span>   </td>
    <th scope="row">Install Date</th>
    <td><span id="txtInstallDate"></span>  </td>
    <th scope="row">Install By</th>
    <td><span id="txtInstallBy"></span>  </td>
</tr>
<tr>
    <th scope="row">Instruction</th>
    <td colspan="5"><span id="txtInstruction"></span>  </td>
</tr>
<tr>
    <th scope="row">Membership</th>
    <td colspan="3"><span id="txtMembership"></span>  </td>
    <th scope="row">Expired Date</th>
    <td><span id="txtExpiredDate"></span> </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->


<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AS Status</th>
    <td>
    <span id='txtASStatus'></span>
    </td>
    <th scope="row">Request Date</th>
    <td>    <span id='txtRequestDate'></span> </td>
    <th scope="row">Request Time</th>
    <td><span id='txtRequestTime'></span> </td>
</tr>
<tr>
    <th scope="row">Malfunction Code</th>
    <td>
      <span id='txtMalfunctionCode'></span> 
    </td>
    <th scope="row">Malfunction Reason</th>
    <td colspan="3"><span id='txtMalfunctionReason'></span>  </td>
</tr>
<tr>
    <th scope="row">DSC Code</th>
    <td>
     <span id='txtDSCCode'></span> 
    </td>
    <th scope="row">Incharge Technician</th>
    <td colspan="3"><span id='txtInchargeCT'></span> </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="reg_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3 class="red_text">Fill the result at below :</h3>
</aside><!-- title_line end -->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#">AS Result Information</a></dt>
    <dd>
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:110px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Result No</th>
        <td><span  id='txtResultNo'></span> 
        </td>
        <th scope="row">Status <span class="must">*</span> </th>
        <td>
        
            <select class="w100p"  id="ddlStatus" name="ddlStatus"  onChange="fn_ddlStatus_SelectedIndexChanged()">
                 <option value=""></option>
                 <option value="1"> Active</option>
                 <option value="4">Complete</option>
                 <option value="10">Cancel</option>
                 <option value="21">Failure</option>
            </select>
            
        </td>
    </tr>
    <tr>
        <th scope="row">Settle Date <span class="must">*</span> </th>
        <td>
        <input type="text" title="Create start Date"   id='dpSettleDate'  name='dpSettleDate' placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" />
        </td>
        <th scope="row">Fail Reason  </th>
        <td>
          <select  id='ddlFailReason' name='ddlFailReason' disabled="disabled" ></select>
        </td>
    </tr>
    <tr>
        <th scope="row">Settle Time <span class="must">*</span>  </th>
        <td>

        <div class="time_picker"><!-- time_picker start -->
        <input type="text" title="" placeholder=""  id='tpSettleTime' name='tpSettleTime' class="readonly time_date" disabled="disabled" />
        <ul>
            <li>Time Picker</li>
            <li><a href="#">12:00 AM</a></li>
            <li><a href="#">01:00 AM</a></li>
            <li><a href="#">02:00 AM</a></li>
            <li><a href="#">03:00 AM</a></li>
            <li><a href="#">04:00 AM</a></li>
            <li><a href="#">05:00 AM</a></li>
            <li><a href="#">06:00 AM</a></li>
            <li><a href="#">07:00 AM</a></li>
            <li><a href="#">08:00 AM</a></li>
            <li><a href="#">09:00 AM</a></li>
            <li><a href="#">10:00 AM</a></li>
            <li><a href="#">11:00 AM</a></li>
            <li><a href="#">12:00 PM</a></li>
            <li><a href="#">01:00 PM</a></li>
            <li><a href="#">02:00 PM</a></li>
            <li><a href="#">03:00 PM</a></li>
            <li><a href="#">04:00 PM</a></li>
            <li><a href="#">05:00 PM</a></li>
            <li><a href="#">06:00 PM</a></li>
            <li><a href="#">07:00 PM</a></li>
            <li><a href="#">08:00 PM</a></li>
            <li><a href="#">09:00 PM</a></li>
            <li><a href="#">10:00 PM</a></li>
            <li><a href="#">11:00 PM</a></li>
        </ul>
        </div><!-- time_picker end -->

        </td>
        <th scope="row">DSC Code <span class="must">*</span>  </th>
         <td>
        <!--  <select  disabled="disabled" id='ddlDSCCode' name='ddlDSCCode' > -->  
        
         <!-- 
         <input type="hidden" title="" placeholder="" class=""  id='ddlDSCCode' name='ddlDSCCode' value='${BRANCH_ID}'/>
         <input type="text" title=""    placeholder="" class="readonly"   id='ddlDSCCodeText' name='ddlDSCCodeText'  value='${BRANCH_NAME}''/>
          -->
          
          <input type="hidden" title="" placeholder="" class=""  id='ddlDSCCode' name='ddlDSCCode'  />
          <input type="text" title=""    placeholder="" class="readonly"    disabled="disabled"  id='ddlDSCCodeText' name='ddlDSCCodeText'  />
         
        </td>
    </tr>
    <tr>
        <th scope="row">Error Code <span class="must">*</span>  </th>
        <td>   
        
        <select   disabled="disabled" id='ddlErrorCode' name='ddlErrorCode' onChange="fn_errMst_SelectedIndexChanged()">
         </select>
        </td>
        <th scope="row">CT Code <span class="must">*</span>  </th>
        <td>
        
         <input type="hidden" title="" placeholder="" class=""  id='ddlCTCode' name='ddlCTCode' />
         <input type="text" title=""    placeholder=""  disabled="disabled"     id='ddlCTCodeText' name='ddlCTCodeText' />
         
        <!-- 
         <input type="hidden" title="" placeholder="" class=""  id='ddlCTCode' name='ddlCTCode' value='${USER_ID}'/>
         <input type="text" title=""    placeholder="" class="readonly"    id='ddlCTCodeText' name='ddlCTCodeText'  value='${USER_NAME}'/>
          -->
        </td>
    </tr>
    <tr>
        <th scope="row">Error Description <span class="must">*</span>  </th>
        <td>
        <select id='ddlErrorDesc' name='ddlErrorDesc'> </select>
        </td>
        <th scope="row">Warehouse</th>
        <td>
        <select class="disabled" disabled="disabled"  id='ddlWarehouse' name='ddlWarehouse'>
        
    </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan="3">
        <textarea cols="20" rows="5" placeholder=""  id='txtRemark' name='txtRemark'></textarea>
        </td>
    </tr>
    <tr>
        <th scope="row">Commission</th>
        <td colspan="3">
        <label><input type="checkbox" disabled="disabled"  id= 'iscommission' name='iscommission'/><span>Has commission ? </span></label>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
    <dt class="click_add_on"><a href="#">AS Defective Event</a></dt>
    <dd>

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Defect Type <span class="must">*</span>  </th>
        <td>
           <input type="text" title=""  id='def_type' name ='def_type' placeholder="ex) DT3" class=""  onChange="fn_getASReasonCode2(this, 'def_type' ,'387')" />
          <input type="hidden" title=""  id='def_type_id'    name ='def_type_id' placeholder="" class="" />
                     <input type="text" title="" placeholder=""id='def_type_text' name ='def_type_text'   class="" />
          
          
        </td>
    </tr>
    <tr>
        <th scope="row">Defect Code <span class="must">*</span>  </th>
        <td>
            <input type="text" title="" placeholder="ex) FF"  disabled="disabled"  id='def_code' name ='def_code' class=""  onChange="fn_getASReasonCode2(this, 'def_code', '303')"  />
            <input type="hidden" title="" placeholder=""   id='def_code_id' name ='def_code_id' class="" />
             <input type="text" title="" placeholder=""id='def_code_text' name ='def_code_text'   class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Defect Part <span class="must">*</span>  </th>
        <td>
        <input type="text" title="" placeholder="ex) FE12"  disabled="disabled" id='def_part' name ='def_part'   class=""  onChange="fn_getASReasonCode2(this, 'def_part' ,'305')" /> 
          <input type="hidden" title="" placeholder=""id='def_part_id' name ='def_part_id'   class="" />
          <input type="text" title="" placeholder=""id='def_part_text' name ='def_part_text'   class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Detail of Defect <span class="must">*</span>  </th>
        <td>
          <input type="text" title="" placeholder="ex) 18 "  disabled="disabled"  id='def_def' name ='def_def'  class="" onChange="fn_getASReasonCode2(this, 'def_def'  ,'304')"  />
          <input type="hidden" title="" placeholder="" id='def_def_id' name ='def_def_id'  class="" />
          <input type="text" title="" placeholder="" id='def_def_text' name ='def_def_text'  class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Solution Code <span class="must">*</span>  </th>
        <td>
            <input type="text" title="" placeholder="ex) A9" class=""  disabled="disabled"  id='solut_code' name ='solut_code'  onChange="fn_getASReasonCode2(this, 'solut_code'  ,'337')"   />
            <input type="hidden" title="" placeholder="" class=""   id='solut_code_id' name ='solut_code_id'  />
            <input type="text" title="" placeholder="" class=""   id='solut_code_text' name ='solut_code_text'  />
          
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
    
    <dt class="click_add_on"><a href="#">AS Charges Fees</a></dt>
    <dd>
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Labour Charge</th>
        <td>
        <label><input type="checkbox"   id='txtLabourch' name='txtLabourch'  onChange="fn_LabourCharge_CheckedChanged(this)"/></label>
        
        </td>
        <th scope="row">Labour Charge</th>
        <td><input type="text"  id='txtLabourCharge' name='txtLabourCharge'  value='0.00' />
        </td>
    </tr>
    <tr>
        <th scope="row">Labour Charge Amt</th>
        <td>
        <select  id='cmbLabourChargeAmt' name='cmbLabourChargeAmt'  onChange="fn_cmbLabourChargeAmt_SelectedIndexChanged()">
             <option value="50">RM 50.00</option>
             <option value="60">RM 60.00</option>
             <option value="100">RM 100.00</option>
             <option value="120">RM 120.00</option>
        </select>
        </td>
        <th scope="row">Filter Charge</th>
        <td> <input type="text"  id='txtFilterCharge' name='txtFilterCharge'  value='0.00'/>
        </td>
    </tr>
    <tr>
        <th scope="row"></th>
        <td></td>
        <th scope="row">Total Charge</th>
        <td><input type="text"  id='txtTotalCharge' name='txtTotalCharge' value='0.00'/>
        </td>
    </tr>
    <tr>
        <th scope="row">Filter Code</th>
        <td>
        <select  id='ddlFilterCode' name='ddlFilterCode'>
        </select>
        </td>
        <th scope="row">Quantity</th>
        <td>
        <select  id='ddlFilterQty' name='ddlFilterQty'>
            <option value="1" selected>1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
            <option value="6">6</option>
            <option value="7">7</option>
            <option value="8">8</option>
            <option value="9">9</option>
            <option value="10">10</option>
            <option value="11">11</option>
            <option value="12">12</option>
            
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Payment Type</th>
        <td>
        <select  id='ddlFilterPayType' name='ddlFilterPayType'>
              <option value="FOC"  selected>Free of Charge</option>
              <option value="CHG">Charge</option>
        </select>
        </td>
        <th scope="row">Exchange Code</th>
        <td>
        <select   id='ddlFilterExchangeCode' name='ddlFilterExchangeCode'>
        </select>
        </td>
    </tr>
    
    <tr>
        <th scope="row">Serial No</th>
        <td colspan="3">
          <input type="text"  id='ddSrvFilterLastSerial' name='ddSrvFilterLastSerial'  />
        </td>
    </tr>
    
    <tr>
        <th scope="row">Remark</th>
        <td colspan="3">
        <textarea cols="20" rows="5" placeholder=""  id='txtFilterRemark' name='txtFilterRemark'></textarea>
        </td>
    </tr>
    
    
    
    </tbody>
    </table><!-- table end -->

    <ul class="center_btns">
        <li><p class="btn_blue2"><a href="#" onclick="fn_filterAdd()">Add Filter</a></p></li>
        
        <li><p class="btn_blue2"><a href="#" onclick="fn_filterClear()">Clear</a></p></li>
    </ul>
    
    
    
    <article class="grid_wrap"><!-- grid_wrap start -->
          <div id="asfilter_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    
    
    <!-- ////////////////////////////////////////////in house repair////////////////////////////////// -->
    <dt class="click_add_on"  ><a href="#">In-House Repair Entry</a></dt>
    <dd   id='inHouseRepair_div' style="display:none">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Replacement </th>
        <td>
        <label> 
                  <input type="radio"   id='replacement' name='replacement'  value='1'  /> Y
                  <input type="radio"   id='replacement' name='replacement'  value='0'  /> N
        </label>
        
        </td>
        <th scope="row">PromisedDate </th>
        <td> <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="promisedDate"  name="promisedDate"/> </td>
    </tr>
   
    <tr>
        <th scope="row">ProductGroup </th>
        <td>
            <select  id='productGroup' name='productGroup'  onChange="fn_productGroup_SelectedIndexChanged()"> </select>
        </td>
        <th scope="row">ProductCode</th>
        <td> 
                <select  id='productCode' name='productCode'  ></select>
        </td>
    </tr>
    <tr>
        <th scope="row">SerialNo</th>
        <td  colspan="3"><input type="text"  id='serialNo' name='serialNo'  onChange="fn_chSeriaNo()"  />
        </td>
    </tr>
    
    <tr>
        <th scope="row">Remark</th>
        <td colspan="3">
        <textarea cols="20" rows="5" placeholder=""  id='inHouseRemark' name='inHouseRemark'></textarea>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </dd>
      <!-- ////////////////////////////////////////////in house repair////////////////////////////////// -->
    
    
    
    
</dl>
</article><!-- acodi_wrap end -->
<ul class="center_btns mt20" id='btnSaveDiv'>
    <li><p class="btn_blue2 big"><a href="#"   onclick="fn_doSave()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#"    onclick="javascript:$('#resultASAllForm').clearForm();" >Clear</a></p></li>
    <!-- <li><p class="btn_blue2 big"><a href="#"    onClick="fn_doClear()" >Clear</a></p></li> -->
</ul>

</section><!-- content end -->
</form>
</section><!-- content end -->
</div><!-- popup_wrap end -->

<script type="text/javaScript">


</script>


                                