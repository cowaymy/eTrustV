<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">


var  regGridID;

$(document).ready(function(){
    
    createAUIGrid();
    
    fn_getASOrderInfo();
    fn_getASEvntsInfo();
    fn_getASHistoryInfo();
    
    doGetCombo('/services/as/getASMember.do', '', '','ddlCTCode', 'S' , '');    
    //doGetCombo('/services/as/getBrnchId.do', '', '','ddlDSCCode', 'S' , '');   
    doGetCombo('/services/as/inHouseGetProductMasters.do', '', '','productGroup', 'S' , '');         
    
    $("#inHousebtnSaveDiv").attr("style","display:none");
    $("#replacement").attr("disabled", true); 
    $("#promisedDate").attr("disabled", true); 
    $("#productGroup").attr("disabled", true); 
    $("#productCode").attr("disabled", true); 
    $("#serialNo").attr("disabled", true); 
    $("#remark").attr("disabled", true); 
    $("#ddlCTCode").attr("disabled", true); 


        
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
        $("#txtMalfunctionCode").text(result[0].asMalfuncId);
        $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);
        
       // $("#txtMalfunctionCode").text('에러코드 정의값');
       // $("#txtMalfunctionReason").text('에러코드 desc');
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
            
            if('337' == _v){
               if(	result[0].codeId.trim()   =='B8' ) {  //Solution Code  B8인 경우만 가능함 .

                   $("#replacement").attr("disabled", false); 
                   $("#promisedDate").attr("disabled", false); 
                   $("#productGroup").attr("disabled", false); 
                   $("#productCode").attr("disabled", false); 
                   $("#serialNo").attr("disabled", false); 
                   $("#remark").attr("disabled", false); 
                   $("#ddlCTCode").attr("disabled", false); 
                   $("#inHousebtnSaveDiv").attr("style","display:inline");
                   
               }else{

                   $("#replacement").attr("disabled", true); 
                   $("#promisedDate").attr("disabled", true); 
                   $("#productGroup").attr("disabled", true); 
                   $("#productCode").attr("disabled", true); 
                   $("#serialNo").attr("disabled", true); 
                   $("#remark").attr("disabled", true); 
                   $("#ddlCTCode").attr("disabled", true); 
                   
                   $("#inHousebtnSaveDiv").attr("style","display:none");
               }
            }
            
        }else{
               $("#"+_tobj+"_text").val("* No such detail of defect found.");
        }
    });
    
}



function fn_save(){
	
	if(fn_validRequiredField_Save_DefectiveInfo() == false) return ;
	
	var saveFom ={
			
			 AS_ID     : $("#AS_ID").val(),
			 AS_NO    : $("#AS_NO").val(),
			 ORD_NO  : $("#ORD_NO").val(),
			 ORD_ID   : $("#ORD_ID").val(),
			 AS_CT_ID:  $("#ddlCTCode").val(),
			 AS_DEFECT_TYPE_ID: $('#def_type_id').val(), 
             AS_DEFECT_GRP_ID: 0,  
             AS_DEFECT_ID:$('#def_code_id').val() , 
             AS_DEFECT_PART_GRP_ID:0 , 
             AS_DEFECT_PART_ID:$('#def_part_id').val() , 
             AS_DEFECT_DTL_RESN_ID:$('#def_def_id').val() , 
             AS_SLUTN_RESN_ID:$('#solut_code_id').val() ,  
			 IN_HUSE_REPAIR_REM: $("#remark").val(),
			 IN_HUSE_REPAIR_REPLACE_YN: $("#replacement").val(),
			 IN_HUSE_REPAIR_PROMIS_DT: $("#promisedDate").val(),
			 IN_HUSE_REPAIR_GRP_CODE: $("#productGroup").val(),
			 IN_HUSE_REPAIR_PRODUCT_CODE: $("#productCode").val(),
			 IN_HUSE_REPAIR_SERIAL_NO: $("#serialNo").val()
	 }
	

    Common.ajax("POST", "/services/as/newASInHouseAdd.do", saveFom, function(result) {
        console.log("newASInHouseAdd.");
        console.log( result);       
        
        if(result.asNo !=""){
            Common.alert("<b>AS result successfully saved.</b>");
           // fn_DisablePageControl();
        }
    });
    
	
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
        
        if(result != null){
        	//var is =false;
        	var is =true;
            if(result.isStk  != "0"){
        		is= true;
        	}
        }
        if(is) $("#inHousebtnSaveDiv").attr("style","display:inline");
    });
}


function fn_productGroup_SelectedIndexChanged(){
	
	var STK_CTGRY_ID = $("#productGroup").val();
	
	 $("#serialNo").val("");
	 $("#productCode option").remove();
	
     doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID='+STK_CTGRY_ID, '', '','productCode', 'S' , '');            
}

</script>



<div id="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->


<form id="resultASForm" method="post">
    <div  style="display:inline">
        <input type="text" name="ORD_ID"  id="ORD_ID"   value="${ORD_ID}"/>  
        <input type="text" name="ORD_NO" id="ORD_NO"  value="${ORD_NO}"/>
        <input type="text" name="AS_NO"   id="AS_NO"    value="${AS_NO}"/>
        <input type="text" name="AS_ID"   id="AS_ID"      value="${AS_ID}"/>
    </div>
</form>

<header class="pop_header"><!-- pop_header start -->
<h1>New AS In-House Repair Entry</h1>
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

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>

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
           <input type="text" title=""  id='def_type'   name ='def_type' placeholder="ex) DT3" class=""  onChange="fn_getASReasonCode2(this, 'def_type' ,'387')" />
          <input type="hidden" title=""  id='def_type_id'    name ='def_type_id' placeholder="" class="" />
                     <input type="text" title="" placeholder=""id='def_type_text' name ='def_type_text'   class="" />
          
          
        </td>
    </tr>
    <tr>
        <th scope="row">Defect Code</th>
        <td>
            <input type="text" title="" placeholder="ex) FF"    id='def_code' name ='def_code' class=""  onChange="fn_getASReasonCode2(this, 'def_code', '303')"  />
            <input type="hidden" title="" placeholder=""   id='def_code_id' name ='def_code_id' class="" />
             <input type="text" title="" placeholder=""id='def_code_text' name ='def_code_text'   class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Defect Part</th>
        <td>
        <input type="text" title="" placeholder="ex) FE12"   id='def_part' name ='def_part'   class=""  onChange="fn_getASReasonCode2(this, 'def_part' ,'305')" /> 
          <input type="hidden" title="" placeholder=""id='def_part_id' name ='def_part_id'   class="" />
          <input type="text" title="" placeholder=""id='def_part_text' name ='def_part_text'   class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Detail of Defect</th>
        <td>
          <input type="text" title="" placeholder="ex) 18 "    id='def_def' name ='def_def'    onChange="fn_getASReasonCode2(this, 'def_def'  ,'304')"  />
          <input type="hidden" title="" placeholder="" id='def_def_id' name ='def_def_id'  class="" />
          <input type="text" title="" placeholder="" id='def_def_text' name ='def_def_text'  class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Solution Code</th>
        <td>
            <input type="text" title="" placeholder="ex) A9"   id='solut_code' name ='solut_code'  onChange="fn_getASReasonCode2(this, 'solut_code'  ,'337')"   />
            <input type="hidden" title="" placeholder="" class=""   id='solut_code_id' name ='solut_code_id'  />
            <input type="text" title="" placeholder="" class=""   id='solut_code_text' name ='solut_code_text'  />
          
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </dd>
    
    
    
    
    <dt class="click_add_on"><a href="#">In-House Repair Entry</a></dt>
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
      <!-- 
	        <th scope="row">DSC Code</th>
	        <td>
	        <select   id='ddlDSCCode' name='ddlDSCCode' > </select>
            </td>
        -->            
             <th scope="row">CT Code</th>
            <td colspan="3">
            <select   id='ddlCTCode' name='ddlCTCode' > </select>
            </td>
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
        <textarea cols="20" rows="5" placeholder=""  id='remark' name='remark'></textarea>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <ul class="center_btns" mt20" id='inHousebtnSaveDiv'>
        <li><p class="btn_blue2"><a href="#" onclick="fn_save()">Save</a></p></li>
        
        <li><p class="btn_blue2"><a href="#" onClick="fn_doClear()" >Clear</a></p></li>
    </ul>
    
    </dd>

</dl>
</article><!-- acodi_wrap end -->


</section><!-- content end -->
</form>
</section><!-- content end -->
</div><!-- popup_wrap end -->