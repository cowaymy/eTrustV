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
    
    doGetCombo('/services/as/getASFilterInfo.do', '', '','ddlFilterCode', 'S' , '');            // Customer Type Combo Box
    doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=336', '', '','ddlFilterExchangeCode', 'S' , '');    
    doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=116', '', '','ddlFailReason', 'S' , '');    

    
    
    
    
    doGetCombo('/services/as/getASMember.do', '', '','ddlCTCode', 'S' , '');    
    doGetCombo('/services/as/getBrnchId.do', '', '','ddlDSCCode', 'S' , '');   
    
    
	fn_getASOrderInfo();
	fn_getASEvntsInfo();
	fn_getASHistoryInfo();
	
	fn_DisablePageControl();
    $("#ddlStatus").attr("disabled", false); 

	
});



//행 추가 이벤트 핸들러
function auiAddRowHandler(event) {
 
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {

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
            $("#txtOrderNo").text(result[0].ordId);
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
        $("#txtMalfunctionCode").text('에러코드 정의값');
        $("#txtMalfunctionReason").text('에러코드 desc');
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
	    
	    var chargePrice =0;
	    if (fitem.filterType  == "CHG") {
	    	chargePrice  = getASStockPrice(fitem.filterID);        
	    }
	    
	    fitem.filterPrice = parseInt(chargePrice,10);
        
	    var  chargeTotalPrice = 0;
	    
	    chargeTotalPrice =  parseInt($("#ddlFilterQty").val(),10)  *  parseInt( chargePrice,10);
	    fitem.filterTotal =   parseInt(chargeTotalPrice,10);
	    
	    
	    var v =  parseInt(  $("#txtFilterCharge").val() ,10) + chargeTotalPrice;
	    $("#txtFilterCharge").val( v);
	    
	    
    if( AUIGrid.isUniqueValue (myFltGrd10,"filterID" ,fitem.filterID )){
         fn_addRow(fitem);
    }else{
        Common.alert("<b>This filter/spart part is existing. </br>");
        return ;
    }
    
    fn_calculateTotalCharges();
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
    totalCharges = parseInt( labourCharges ,10)+ parseInt( filterCharges,10);
    
    $("#txtTotalCharge").val(totalCharges);  
    
}


function fn_cmbLabourChargeAmt_SelectedIndexChanged(){
	
	var  v =$("#cmbLabourChargeAmt").val();
	$("#txtLabourCharge").val(v);
	fn_calculateTotalCharges();
}




function fn_ddlStatus_SelectedIndexChanged(){
	
	fn_clearPageField();
	
    switch ($("#ddlStatus").val()) {
        case "4":
            //COMPLETE
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
    
}


function fn_doSave(){
	
	if ( ! fn_validRequiredField_Save_ResultInfo()) {
       return ;
    }
	
   if($("#ddlStatus").val()==4){
	     
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
    var editedRowItems = AUIGrid.getEditedRowColumnItems(myFltGrd10); 
       
    //삭제된 행 아이템들(배열)
    var removedRowItems = AUIGrid.getRemovedItems(myFltGrd10);
    
	
	var asResultM ={
			       AS_ENTRY_ID:              $("#AS_ID").val(),
				   AS_SO_ID:                   $("#ORD_ID").val(),
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
				   AS_DEFECT_TYPE_ID:    $('#ddlStatus').val()== 4 ? $('#def_type_id').val() : '0' , 
				   AS_DEFECT_GRP_ID:             0,  
				   AS_DEFECT_ID:                   $('#ddlStatus').val()== 4 ? $('#def_code_id').val() : '0' , 
				   AS_DEFECT_PART_GRP_ID:    0 , 
				   AS_DEFECT_PART_ID:          $('#ddlStatus').val()== 4 ? $('#def_part_id').val() : '0' , 
				   AS_DEFECT_DTL_RESN_ID:    $('#ddlStatus').val()== 4 ? $('#def_def_id').val() : '0' , 
				   AS_SLUTN_RESN_ID:            $('#ddlStatus').val()== 4 ? $('#solut_code_id').val() : '0' , 
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
				   AS_RESULT_MOBILE_ID: 0
	}
	
	var  saveForm ={
			"asResultM": asResultM ,
		    "add" : addedRowItems,
	        "update" : editedRowItems,
	        "remove" : removedRowItems
	}
	
	

    Common.ajax("POST", "/services/as/newResultAdd.do", saveForm, function(result) {
        console.log("newResultAdd.");
        console.log( result);       
        
        if(result.asNo !=""){
            Common.alert("<b>AS result successfully saved.</b>");
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
    	
    	if($("#ddlStatus").val()==4){
    		
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




</script>



<div id="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->


<form id="resultASForm" method="post">
    <div  style="display:none">
        <input type="text" name="ORD_ID"  id="ORD_ID" value="${ORD_ID}"/>  
        <input type="text" name="ORD_NO"   id="AS_NO"  value="${ORD_NO}"/>
        <input type="text" name="AS_NO"   id="AS_NO"  value="${AS_NO}"/>
        <input type="text" name="AS_ID"   id="AS_ID"  value="${AS_ID}"/>
    </div>
</form>

<header class="pop_header"><!-- pop_header start -->
<h1>New AS Result Entry</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
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
        <td>
        <input type="text" title="" placeholder="" class=""  id='txtResultNo' name='txtResultNo'/>
        </td>
        <th scope="row">Status</th>
        <td>
        
		    <select class="w100p"  id="ddlStatus" name="ddlStatus"  onChange="fn_ddlStatus_SelectedIndexChanged()">
		         <option value=""></option>
		        <option value="4">Complete</option>
		        <option value="10">Cancel</option>
		        <option value="21">Failure</option>
		    </select>
		    
        </td>
    </tr>
    <tr>
        <th scope="row">Settle Date</th>
        <td>
        <input type="text" title="Create start Date"   id='dpSettleDate'  name='dpSettleDate' placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" />
        </td>
        <th scope="row">Fail Reason</th>
        <td>
          <select  id='ddlFailReason' name='ddlFailReason' disabled="disabled" ></select>
        </td>
    </tr>
    <tr>
        <th scope="row">Settle Time</th>
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
        <th scope="row">DSC Code</th>
        <td>
        <select  disabled="disabled" id='ddlDSCCode' name='ddlDSCCode' >
        
    </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Error Code</th>
        <td>
        <select   disabled="disabled" id='ddlErrorCode' name='ddlErrorCode'>
                     <option value="9999">에러코드</option>
         </select>
        </td>
        <th scope="row">CT Code</th>
        <td>
        <select  disabled="disabled" id='ddlCTCode' name='ddlCTCode'>
        <input type="hidden" title="" placeholder="" class=""  id='HiddenCTID' name='HiddenCTID'/>
        
        
    </select> 
        </td>
    </tr>
    <tr>
        <th scope="row">Error Description</th>
        <td>
        <select id='ddlErrorDesc' name='ddlErrorDesc'>
             <option value="9999">에러코드 신규정의 필요 </option>
        </select>
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
        <th scope="row">Defect Type</th>
        <td>
           <input type="text" title=""  id='def_type' disabled="disabled" name ='def_type' placeholder="ex) DT3" class=""  onChange="fn_getASReasonCode2(this, 'def_type' ,'387')" />
          <input type="hidden" title=""  id='def_type_id'    name ='def_type_id' placeholder="" class="" />
                     <input type="text" title="" placeholder=""id='def_type_text' name ='def_type_text'   class="" />
          
          
        </td>
    </tr>
    <tr>
        <th scope="row">Defect Code</th>
        <td>
	        <input type="text" title="" placeholder="ex) FF"  disabled="disabled"  id='def_code' name ='def_code' class=""  onChange="fn_getASReasonCode2(this, 'def_code', '303')"  />
	        <input type="hidden" title="" placeholder=""   id='def_code_id' name ='def_code_id' class="" />
	         <input type="text" title="" placeholder=""id='def_code_text' name ='def_code_text'   class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Defect Part</th>
        <td>
        <input type="text" title="" placeholder="ex) FE12"  disabled="disabled" id='def_part' name ='def_part'   class=""  onChange="fn_getASReasonCode2(this, 'def_part' ,'305')" /> 
          <input type="hidden" title="" placeholder=""id='def_part_id' name ='def_part_id'   class="" />
          <input type="text" title="" placeholder=""id='def_part_text' name ='def_part_text'   class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Detail of Defect</th>
        <td>
          <input type="text" title="" placeholder="ex) 18 "  disabled="disabled"  id='def_def' name ='def_def'  class="" onChange="fn_getASReasonCode2(this, 'def_def'  ,'304')"  />
          <input type="hidden" title="" placeholder="" id='def_def_id' name ='def_def_id'  class="" />
          <input type="text" title="" placeholder="" id='def_def_text' name ='def_def_text'  class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Solution Code</th>
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
        <label><input type="checkbox"   id='txtLabourch' name='txtLabourch''  onChange="fn_LabourCharge_CheckedChanged(this)"/></label>
        
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
            <option value="1">1</option>
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
              <option value="FOC">Free of Charge</option>
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
        <th scope="row">Remark</th>
        <td colspan="3">
        <textarea cols="20" rows="5" placeholder=""  id='txtFilterRemark' name='txtFilterRemark'></textarea>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <ul class="center_btns">
        <li><p class="btn_blue2"><a href="#" onclick="fn_filterAdd()">Add Filter</a></p></li>
        
        <li><p class="btn_blue2"><a href="#">Clear</a></p></li>
    </ul>
    
    <article class="grid_wrap"><!-- grid_wrap start -->
          <div id="asfilter_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
</dl>
</article><!-- acodi_wrap end -->
<ul class="center_btns mt20" id='btnSaveDiv'>
    <li><p class="btn_blue2 big"><a href="#"   onclick="fn_doSave()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#"    onClick="fn_doClear()" >Clear</a></p></li>
</ul>

</section><!-- content end -->
</section><!-- content end -->
</div><!-- popup_wrap end -->