<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
    
    $(document).ready(function() {
    	
    	var selCodeNation = $("#selCodeNation").val();
        var selCodeState = $("#selCodeState").val();
        var selCodeArea = $("#selCodeArea").val();
        var selCodePostCode = $("#selCodePostCode").val();
        
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , selCodeNation , selCodeNation,'cmdNationTypeId', 'S', '');        // Nationality Combo Box
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'state' , selCodeNation , selCodeState,'cmdStateTypeId', 'S', '');        // State Combo Box
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' , selCodeState , selCodeArea,'cmdAreaTypeId', 'S', '');        // State Combo Box
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' , selCodeArea , selCodePostCode, 'cmdPostTypeId', 'S', '');        // State Combo Box
        
        // main 일 경우 delete 버튼 숨기기
        if($("#stusCodeId").val() == 9){
        	$("#_delBtn").css("display", "none" );
        } 
       //Update
       $("#_updBtn").click(function() {
    	   
    	   /* Addr1, Addr2, Addr3 null check */
    	   if(("" == $("#firsAddr").val() || null == $("#firsAddr").val()) && ("" == $("#secdAddr").val() || null == $("#secdAddr").val())
    			   &&  ("" == $("#thirdAddr").val() || null == $("#thirdAddr").val()) ){
    		   Common.alert("* Please key in the address.");
               return;
    	   }
    	   
    	   /* Country */
    	   
    	   //Nation
    	   if("" == $("#cmdNationTypeId").val() || null == $("#cmdNationTypeId").val()){
    		   Common.alert("* Please select the nation.");
               return;
    	   }
    	   if($("#cmdNationTypeId").val()  == 1){ // MALAYSIA code == 1
    		   
    		   //State
               if("" == $("#cmdStateTypeId").val() || null == $("#cmdStateTypeId").val()){
                   Common.alert("* Please select the state.");
                   return;
               }
               //Area
               if("" == $("#cmdAreaTypeId").val() || null == $("#cmdAreaTypeId").val()){
                   Common.alert("* Please select the area.");
                   return;
               }
               //PostCode
               if("" == $("#cmdPostTypeId").val() || null == $("#cmdPostTypeId").val()){
                   Common.alert("* Please select the postcode.");
                   return;
               }
               
    	   }
    	 
    	   // Validation Success
           //Update
    	   fn_customerAddressInfoUpdateAjax();
    	   
	   });
       //Delete
       $("#_delBtn").click(function() {
    	  
    	  Common.confirm("Are you sure want to delete this address ?", fn_deleteAddressAjax);
	   });
       
	}); // Document Ready Func End
	
	
	// Call Ajax - DB Update
    function fn_customerAddressInfoUpdateAjax(){
        Common.ajax("GET", "/sales/customer/updateCustomerAddressInfoAf.do",$("#updForm").serialize(), function(result) {
        	Common.alert(result.message, fn_parentReload);
        });
    }
    
    // Parent Reload Func
    function fn_parentReload() {
    	fn_selectPstRequestDOListAjax(); //parent Method (Reload)
    	$("#_close1").click();
    	$("#_close").click();
    	$("#_selectParam").val('2');
    	Common.popupDiv('/sales/customer/updateCustomerAddressPop.do' , $('#popForm').serializeJSON(), null , true, '_editDiv2'); 
    	Common.popupDiv('/sales/customer/updateCustomerAddressInfoPop.do', $('#editForm').serializeJSON(), null , true, '_editDiv2Pop'); 
    }
	
	//Address Relay -- onchange func
	function fn_addressRelay(id , value){
		
		if(id == 'cmdNationTypeId'){
			doGetComboAddr('/common/selectAddrSelCodeList.do', 'state' , value , '','cmdStateTypeId', 'S', '');// State Combo Box
			doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' , '' , '' ,'cmdAreaTypeId', 'S', '');        // State Combo Box
			doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' , '' , '' , 'cmdPostTypeId', 'S', '');        // State Combo Box
		}
		
		if(id == 'cmdStateTypeId'){
			doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' , value , '' ,'cmdAreaTypeId', 'S', '');        // State Combo Box
			doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' , '' , '' , 'cmdPostTypeId', 'S', '');        // State Combo Box
		}
		
		if(id == 'cmdAreaTypeId'){
			doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' , value , '' , 'cmdPostTypeId', 'S', '');        // State Combo Box
		}
		
	}
	
    /* ####### delete Func ########### */
    //delete call Ajax
    function fn_deleteAddressAjax(){
    	
        Common.ajax("GET", "/sales/customer/deleteCustomerAddress.do", $("#updForm").serialize(), function(result){
            //result alert and closePage
            Common.alert(result.message, fn_closePage);
        });
    }
    
    // Parent Reload And Page Close
    function fn_closePage(){
    	fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('2');
        Common.popupDiv('/sales/customer/updateCustomerAddressPop.do' , $('#popForm').serializeJSON(), null , true, '_editDiv2'); 
    }
    /* ####### delete Func end ########### */
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>PST Request Info</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<!-- move Page Form  -->
<!-- getParams  -->
<input type="hidden" value="${detailaddr.cntyId}" id="selCodeNation">
<input type="hidden" value="${detailaddr.stateId}" id="selCodeState">
<input type="hidden" value="${detailaddr.areaId }" id="selCodeArea">
<input type="hidden" value="${detailaddr.postCodeId }" id="selCodePostCode">
<input type="hidden" value="${detailaddr.stusCodeId}" id="stusCodeId"> 
<section class="pop_body"><!-- pop_body start -->
<form id=updForm><!-- form star -->
<input type="hidden" name="addrCustAddId" value="${detailaddr.custAddId}" id="addrCustAddId">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Status</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p"  value="${detailaddr.name}" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th rowspan="3" scope="row">Address<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p"  value="${detailaddr.add1}" id="firsAddr" name="add1" maxlength="50"/>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" value="${detailaddr.add2}" id="secdAddr" name="add2" maxlength="50"/>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" value="${detailaddr.add3}" id="thirdAddr" name="add3" maxlength="50"/>
    </td>
</tr>
<tr>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmdNationTypeId" onchange="javascript : fn_addressRelay('cmdNationTypeId', this.value)" name="addrCntyId"></select>
    </td>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmdStateTypeId" onchange="javascript : fn_addressRelay('cmdStateTypeId', this.value)" name="addrStateId"></select> 
    </td>
</tr>
<tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmdAreaTypeId" onchange="javascript : fn_addressRelay('cmdAreaTypeId', this.value)" name="addrAreaId"></select>
    </td>
    <th scope="row">Postcode<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmdPostTypeId" name="addrPostCodeId"></select>
    </td>
</tr>
<tr>
    <th scope="row">Reamrk</th>
    <td colspan="3">
    <textarea cols="20" rows="5" placeholder="Address Reamrk" name="addrRem">${detailaddr.rem}</textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form><!-- form end  -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_updBtn">Update</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_delBtn">Delete</a></p></li>
</ul>
</section><!-- pop_body end -->
</div>