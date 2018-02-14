<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">


var  regGridID;
var  myFltGrd10;

$(document).ready(function(){
	
    createAUIGrid();
  
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(myFltGrd10, "addRow", auiAddRowHandler);
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(myFltGrd10, "removeRow", auiRemoveRowHandler);
    
    //doGetCombo('/services/as/getASFilterInfo.do', '', '','ddlFilterCode', 'S' , '');  // Customer Type Combo Box
    //doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=336', '', '','ddlFilterExchangeCode', 'S' , '');    
    doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=166', '', '','ddlFailReason', 'S' , '');    
    //doGetCombo('/services/as/getASMember.do', '', '','ddlCTCode', 'S' , 'fn_setCTcodeValue');    
   // doGetCombo('/services/as/getBrnchId.do', '', '','ddlDSCCode', 'S' , '');   
    
    doGetCombo('/services/as/inHouseGetProductMasters.do', '', '','productGroup', 'S' , '');         

    
	fn_getASOrderInfo();
	fn_getASEvntsInfo();
	fn_getASHistoryInfo();
	
   
    //fn_getASRulstEditFilterInfo();
	
        	
});




function fn_getErrMstList(_ordNo){
    
     var SALES_ORD_NO = _ordNo ;
     $("#ddlErrorCode option").remove();
     doGetCombo('/services/as/getErrMstList.do?SALES_ORD_NO='+SALES_ORD_NO, '', '','ddlErrorCode', 'S' , '');            
     
     
     fn_getASRulstSVC0004DInfo();
}



function fn_errMst_SelectedIndexChanged(){
    
    var DEFECT_TYPE_CODE = $("#ddlErrorCode").val();
    
     $("#ddlErrorDesc option").remove();
     doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE='+DEFECT_TYPE_CODE, '', '','ddlErrorDesc', 'S' , '');            
}





function fn_setCTcodeValue(){
	 $("#ddlCTCode").val(  $("#CTID").val()); 
}

function fn_getASRulstEditFilterInfo(){
    
    Common.ajax("GET", "/services/as/getASRulstEditFilterInfo", $("#resultASForm").serialize(), function(result) {
        console.log("fn_getASRulstEditFilterInfo.");
        console.log( result);
        AUIGrid.setGridData(myFltGrd10, result);        
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




function fn_callback_ddlErrorDesc(){
	
	$("#ddlErrorDesc").val( asMalfuncResnId); 
}


var productCode ;
var asMalfuncResnId; 


function  fn_setSVC0004dInfo(result){
	
	$("#creator").val( result[0].c28); 
    $("#creatorat").val( result[0].asResultCrtDt); 
    $("#txtResultNo").val( result[0].asResultNo); 
    $("#ddlStatus").val( result[0].asResultStusId); 
    $("#dpSettleDate").val( result[0].asSetlDt); 
    $("#ddlFailReason").val( result[0].c2); 
    $("#tpSettleTime").val( result[0].asSetlTm); 
    $("#ddlErrorCode").val( result[0].asMalfuncId); 
    $("#ddlErrorDesc").val( result[0].asMalfuncResnId); 
    asMalfuncResnId = result[0].asMalfuncResnId;

    if(result[0].asMalfuncId !=""){
        $("#ddlErrorDesc option").remove();
        doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE='+result[0].asMalfuncId  , '', '','ddlErrorDesc', 'S' , 'fn_callback_ddlErrorDesc');       
    }
    
    /*
    $("#ddlDSCCode").val( result[0].asBrnchId); 
    $("#ddlCTCodeText").val( result[0].c12); 
    
    $("#ddlCTCode").val( result[0].c11);
    */
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    $("#ddlCTCode").val(selectedItems[0].item.asMemId);
    $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
    $("#ddlCTCodeText").val(selectedItems[0].item.memCode);
    $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);
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
    
    

    if(result[0].c25 =="B8"  || result[0].c25 =="B6" ){
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
    
    if(result[0].c25 =="B8" ){  //인하우스 데이터만 수정 가능함. 
    	
    }
    
    
}




function fn_inHouseGetProductDetails(){
    $("#productCode").val(productCode);
}




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
                            {dataField : "filterType",     headerText  : "Type" ,editable       : false  } ,
                            { dataField : "filterDesc",      headerText  : "Description",  width  :200 },
                            { dataField : "filterExCode", headerText  : "Exchange Code ",  width  : 80 },
                            { dataField : "filterQty",       headerText  : "Qty",  width  : 80 },
                            { dataField : "filterPrice",       headerText  : "Price",  width  : 80 ,dataType : "number", formatString : "#,000.00"  ,editable : false },
                            { dataField : "filterTotal",     headerText  : "Total",  width          :80 ,dataType : "number", formatString : "#,000.00"  ,editable : false},
                            { dataField : "filterRemark",     headerText  : "Remark",  width          :200,    editable       : false },
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
                            { dataField : "filterID",     headerText  : "filterID",  width          :150,    editable       : false ,   visible:false }

                            
                            
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
            
            
            fn_getErrMstList(result[0].ordNo);
            
        });
}


function fn_getASEvntsInfo(){
    Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm").serialize(), function(result) {
        console.log("getASEvntsInfo.");
        console.log( result);
      
        $("#txtASStatus").text(result[0].code);
        $("#txtRequestDate").text(result[0].asReqstDt);
        $("#txtRequestTime").text(result[0].asReqstTm);
        //$("#txtMalfunctionCode").text('에러코드 정의값');
        //$("#txtMalfunctionReason").text('에러코드 desc');
        
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




function fn_doSave(){
	 
    if($("#ddlErrorCode").val()==""){
        Common.alert("Please select the ErrorCode.<br/>");
        return ;
    }
    
    if($("#ddlErrorDesc").val()=="" ){
        Common.alert("Please select the ErrorDesc.<br/>");
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


function  fn_setSaveFormData(){
	
    //추가된 행 아이템들(배열)
    var addedRowItems = AUIGrid.getAddedRowItems(myFltGrd10);
        
    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowColumnItems(myFltGrd10); 
       
    //삭제된 행 아이템들(배열)
    var removedRowItems = AUIGrid.getRemovedItems(myFltGrd10);
    
	
	var asResultM ={
			       AS_CMMS:                          $("#iscommission").prop("checked") ? '1': '0' ,    
				   AS_RESULT_REM:                 $('#txtRemark').val() ,
				   AS_MALFUNC_ID:                 $('#ddlErrorCode').val() ,
				   AS_MALFUNC_RESN_ID:         $('#ddlErrorDesc').val() , 
				   AS_DEFECT_TYPE_ID:           $('#ddlStatus').val()== 4 ? $('#def_type_id').val() : '0' , 
				   AS_DEFECT_ID:                   $('#ddlStatus').val()== 4 ? $('#def_code_id').val() : '0' , 
				   AS_DEFECT_PART_ID:           $('#ddlStatus').val()== 4 ? $('#def_part_id').val() : '0' , 
				   AS_DEFECT_DTL_RESN_ID:     $('#ddlStatus').val()== 4 ? $('#def_def_id').val() : '0' , 
				   AS_SLUTN_RESN_ID:             $('#ddlStatus').val()== 4 ? $('#solut_code_id').val() : '0' , 
				   AS_RESULT_ID :                   $('#AS_RESULT_ID').val() ,
				   IN_HUSE_REPAIR_REM:           $("#inHouseRemark").val(),
                   IN_HUSE_REPAIR_REPLACE_YN:$("#replacement").val(),
                   IN_HUSE_REPAIR_PROMIS_DT: $("#promisedDate").val(),
                   IN_HUSE_REPAIR_GRP_CODE: $("#productGroup").val(),
                   IN_HUSE_REPAIR_PRODUCT_CODE: $("#productCode").val(),
                   IN_HUSE_REPAIR_SERIAL_NO: $("#serialNo").val(),
                   AS_RESULT_STUS_ID :  $("#ddlStatus").val(),
                   AS_REPLACEMENT :$("#replacement:checked").val()
                   
				   
	}
	
	var  saveForm ={
			"asResultM": asResultM 
	}

	
    Common.ajax("POST", "/services/as/newResultBasicUpdate.do", saveForm, function(result) {
        console.log("newResultAdd.");
        console.log( result);       
        
        if(result.asNo !=""){
            Common.alert("<b>AS result successfully saved.</b>");
            //fn_DisablePageControl();
        }
    });
}





function fn_editBasicPageContral(){
	
    $("#resultEditCreator").attr("style","display:inline");
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
    $('#def_type_id').removeAttr("disabled").removeClass("readonly");  
    $('#def_code_id').removeAttr("disabled").removeClass("readonly");  
    $('#def_part_id').removeAttr("disabled").removeClass("readonly");  
    $('#solut_code_id').removeAttr("disabled").removeClass("readonly");  
    $('#def_def_id').removeAttr("disabled").removeClass("readonly");
    
    
    $('#def_type_text').removeAttr("disabled").removeClass("readonly");  
    $('#def_code_text').removeAttr("disabled").removeClass("readonly");  
    $('#def_part_text').removeAttr("disabled").removeClass("readonly");  
    $('#solut_code_text').removeAttr("disabled").removeClass("readonly");  
    $('#def_def_text').removeAttr("disabled").removeClass("readonly");  
    
    $('#txtLabourch').removeAttr("disabled").removeClass("readonly");  
    $('#txtTotalCharge').removeAttr("disabled").removeClass("readonly");  
    $('#txtFilterCharge').removeAttr("disabled").removeClass("readonly");  
    $('#txtLabourCharge').removeAttr("disabled").removeClass("readonly");  
    $('#cmbLabourChargeAmt').removeAttr("disabled").removeClass("readonly");  
    $('#ddlFilterCode').removeAttr("disabled").removeClass("readonly");  
    $('#ddlFilterQty').removeAttr("disabled").removeClass("readonly");  
    $('#ddlFilterPayType').removeAttr("disabled").removeClass("readonly");  
    $('#ddlFilterExchangeCode').removeAttr("disabled").removeClass("readonly");  
    $('#txtFilterRemark').removeAttr("disabled").removeClass("readonly");  
    
    fn_clearPanelField_ASChargesFees();
	
}


function fn_DisablePageControl(){
	
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
    
    
    
    $("#txtLabourch").attr("disabled", true); 
    $("#txtLabourCharge").attr("disabled", true); 
    $("#cmbLabourChargeAmt").attr("disabled", true); 
    $("#txtFilterCharge").attr("disabled", true); 
    $("#txtTotalCharge").attr("disabled", true); 
    
    $("#btnSaveDiv").attr("style","display:none");
    $("#addDiv").attr("style","display:none");
    
    
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




function fn_productGroup_SelectedIndexChanged(){
    
    var STK_CTGRY_ID = $("#productGroup").val();
    
     $("#serialNo").val("");
     $("#productCode option").remove();
    
     doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID='+STK_CTGRY_ID, '', '','productCode', 'S' , '');            
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
        // if(is ==false )   $("#btnSaveDiv").attr("style","display:none");
    });
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
        <input type="text" name="MOD"   id="MOD"  value="${MOD}"/>
        <input type="text" name="AS_RESULT_NO"   id="AS_RESULT_NO"  value="${AS_RESULT_NO}"/>  
        <input type="text" name="AS_RESULT_ID"   id="AS_RESULT_ID"  value="${AS_RESULT_ID}"/>  
           
    </div>
</form>

<header class="pop_header"><!-- pop_header start -->
<h1> Edit Basic  AS Result Entry</h1>
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
    <span id="txtASNo"></span>
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
    <th scope="row"> Incharge Technician </th>
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
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    
    
    <tr>
        <th scope="row">Result No</th>
        <td>
        <input type="text" title="" placeholder="" class="readonly"   id='txtResultNo' name='txtResultNo'/>
        </td>
        <th scope="row">Status <span class="must">*</span> </th>
        <td>
        
		    <select class="w100p"  id="ddlStatus" name="ddlStatus"  class="readonly"  disabled="disabled"  onChange="fn_ddlStatus_SelectedIndexChanged()">
		         <option value=""></option>
		         
		        <option value="1">Active</option>
		        <option value="4">Complete</option>
		        <option value="10">Cancel</option>
		        <option value="21">Failure</option>
		    </select>
		    
        </td>
    </tr>
    <tr>
        <th scope="row">Settle Date <span class="must">*</span> </th>
        <td>
        <input type="text" title="Create start Date"   class="readonly"   id='dpSettleDate'  name='dpSettleDate' placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" />
        </td>
        <th scope="row">Fail Reason</th>
        <td>
          <select  id='ddlFailReason' name='ddlFailReason' class="readonly" disabled="disabled" ></select>
        </td>
    </tr>
    <tr>
        <th scope="row">Settle Time <span class="must">*</span> </th>
        <td>

        <div class="time_picker"><!-- time_picker start -->
        <input type="text" title="" placeholder=""  id='tpSettleTime'  class="readonly"  name='tpSettleTime' class="readonly time_date" disabled="disabled" />
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
        <th scope="row">DSC Code <span class="must">*</span> </th>
        <td>
       <!-- <select  disabled="disabled" id='ddlDSCCode' name='ddlDSCCode' >  </select>-->
       
       <!--
         <input type="hidden" title="" placeholder="" class=""  id='ddlDSCCode' name='ddlDSCCode' value='${BRANCH_ID}'/>
         <input type="text" title=""    placeholder="" class="readonly"    id='ddlDSCCodeText' name='ddlDSCCodeText'  value='${BRANCH_NAME}'/>
        -->
         <input type="hidden" title="" placeholder="" class=""  id='ddlDSCCode' name='ddlDSCCode' />
         <input type="text" title=""    placeholder="" class="readonly"    id='ddlDSCCodeText' name='ddlDSCCodeText'  />
        </td>
    </tr>
    <tr>
        <th scope="row">Error Code <span class="must">*</span> </th>
        <td>
        <select  id='ddlErrorCode' name='ddlErrorCode' onChange="fn_errMst_SelectedIndexChanged()">
         </select>
        </td>
        <th scope="row">CT Code <span class="must">*</span> </th>
        <td>
        <!-- 
        
         <input type="hidden" title="" placeholder="" class=""  id='ddlCTCode' name='ddlCTCode' />
         <input type="text" title=""   placeholder="" class="readonly"     id='ddlCTCodeText' name='ddlCTCodeText'  />
         
         <input type="hidden" title="" placeholder="" class=""  id='CTID' name='CTID'/>
         -->
        
        
         <input type="hidden" title="" placeholder="" class=""  id='ddlCTCode' name='ddlCTCode' />
         <input type="text" title=""   placeholder="" class="readonly"     id='ddlCTCodeText' name='ddlCTCodeText'  />
         
         <input type="hidden" title="" placeholder="" class=""  id='CTID' name='CTID'/>
         
        </td>
    </tr>
    <tr>
        <th scope="row">Error Description <span class="must">*</span> </th>
        <td>
        <select id='ddlErrorDesc' name='ddlErrorDesc'>
        </select>
        </td>
        <th scope="row">Warehouse</th>
        <td>
        <select class="readonly"  id='ddlWarehouse' name='ddlWarehouse'>
        
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
        <label><input type="checkbox"   id= 'iscommission' name='iscommission'/><span>Has commission ? </span></label>
        </td>
    </tr>
   
    
    <tr>
        <th scope="row">Result Creator</th>
        <td>
                <input type="text" title="" placeholder="" class="disabled"   disabled="disabled" id='creator' name='creator'/>
        </td>
        <th scope="row">Result Create Date </th>
            <td>
                 <input type="text" title="" placeholder="" class="disabled"   disabled="disabled"id='creatorat' name='creatorat'/>
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
        <th scope="row">Defect Type <span class="must">*</span> </th>
        <td>
           <input type="text" title=""  id='def_type'  name ='def_type' placeholder="ex) DT3" class=""  onChange="fn_getASReasonCode2(this, 'def_type' ,'387')" />
           <input type="hidden" title=""  id='def_type_id'    name ='def_type_id' placeholder="" class="" />
           <input type="text" title="" placeholder=""id='def_type_text' name ='def_type_text'   class="" />
          
          
        </td>
    </tr>
    <tr>
        <th scope="row">Defect Code <span class="must">*</span> </th>
        <td>
	        <input type="text" title="" placeholder="ex) FF"   id='def_code' name ='def_code' class=""  onChange="fn_getASReasonCode2(this, 'def_code', '303')"  />
	        <input type="hidden" title="" placeholder=""   id='def_code_id' name ='def_code_id' class="" />
	         <input type="text" title="" placeholder=""id='def_code_text' name ='def_code_text'   class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Defect Part <span class="must">*</span> </th>
        <td>
        <input type="text" title="" placeholder="ex) FE12"   id='def_part' name ='def_part'   class=""  onChange="fn_getASReasonCode2(this, 'def_part' ,'305')" /> 
          <input type="hidden" title="" placeholder=""id='def_part_id' name ='def_part_id'   class="" />
          <input type="text" title="" placeholder=""id='def_part_text' name ='def_part_text'   class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Detail of Defect <span class="must">*</span></th>
        <td>
          <input type="text" title="" placeholder="ex) 18 "   id='def_def' name ='def_def'  class="" onChange="fn_getASReasonCode2(this, 'def_def'  ,'304')"  />
          <input type="hidden" title="" placeholder="" id='def_def_id' name ='def_def_id'  class="" />
          <input type="text" title="" placeholder="" id='def_def_text' name ='def_def_text'  class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Solution Code <span class="must">*</span> </th>
        <td>
	        <input type="text" title="" placeholder="ex) A9" class=""   id='solut_code' name ='solut_code'  onChange="fn_getASReasonCode2(this, 'solut_code'  ,'337')"   />
	        <input type="hidden" title="" placeholder="" class=""   id='solut_code_id' name ='solut_code_id'  />
	        <input type="text" title="" placeholder="" class=""   id='solut_code_text' name ='solut_code_text'  />
          
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </dd>
    
    
    
    <!-- ////////////////////////////////////////////in house repair////////////////////////////////// -->
    <dt class="click_add_on"><a href="#">In-House Repair Entry</a></dt>
    <dd  id='inHouseRepair_div' style="display:none">
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


<ul class="center_btns mt20" >
    <li><p class="btn_blue2 big"><a href="#"   onclick="fn_doSave()">Save</a></p></li>
</ul>

</section><!-- content end -->
</section><!-- content end -->
</div><!-- popup_wrap end -->

<script>
fn_callback_ddlErrorDesc();
</script>