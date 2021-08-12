<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
    $(document).ready(function() {
    	   
    	//Call Curier List
        doGetCombo("/sales/ccp/selectCurierListJsonList", '', '', '_updCourierSelect', 'S', '');
    	
    	//init
    	fn_updConInit();
    	
    	
    	//Consign Method Change Func
    	$("input[name='updCourier']").click(function() {
    		
    		//init Func
    		fn_updConInit();
    		
    		var mthVal = $("input[name='updCourier']:checked").val();
    		
    		//method Value == C  ... by Courier
    	    if(mthVal == 'C'){
    	    	//Consignment Number and CourierList
                $("#_updConsignmentNo").attr({"disabled" : false , "class" : "wp100"});
                $("#_updCourierSelect").attr({"disabled" : false , "class" : "wp100"});
            }
    		
		});
    	
    	//Consign Save
    	$("#_conSaveBtn").click(function() {
    		   
    		//Validation
    		var isConResult = false;
    		isConResult = fn_consingAddValidation();
    		
    		if(isConResult == false){
    			return;
    		}
    		
    		//Save(Validation Pass)
    		Common.ajax("GET", "/sales/ccp/updateNewConsignment.do", $("#_conSaveForm").serialize(),function(result) {
    			Common.alert(result.message, fn_reloadPage);
    		});
    		
		});//conSave End
    	
    	//Clear
    	$("#_conClear").click(function() {
			$("input[name='updCourier']").prop("checked" , false);
    		fn_updConInit();
    		
		});
    	
	});
    
    function fn_reloadPage(){
    	
    	fn_selectCcpAgreementListAjax(); //parent Method (Reload)
    	$("#_conClose").click();
    	$("#_close").click();
    	Common.popupDiv("/sales/ccp/selectAgreementMtcViewEditPop.do", $("#popForm").serializeJSON(), null , true , '_viewEditDiv');
    	//Common.popupDiv("/sales/ccp/addNewConsign.do", $("#_saveForm").serializeJSON(), null , true , '_consignDiv');
    	//$("input[name='conAgrId']").val($("#_govAgId").val());
    	
    }
    
    function fn_consingAddValidation(){
    	
    	//라디오 버튼 체크 안했을 때
    	if($("input[name='updCourier']:checked").val() == '' || $("input[name='updCourier']:checked").val() == null){
    		Common.alert('<spring:message code="sal.alert.msg.plzSelectCourierMethod" />');
    		return false;
    	}else{ // 체크 했을때 (else)      
            // 1. check 값이 Courier 일 때 
            if($("input[name='updCourier']:checked").val() == 'C'){
            	
            	//Consign Number 널체크
                if($("#_updConsignmentNo").val() == '' ||$("#_updConsignmentNo").val() == null ){
                	
                	Common.alert('<spring:message code="sal.alert.msg.plzKeyinCourierConsNo" />');
                	return false;
                	
                }
            	
                //배송회사 널체크
                if($("#_updCourierSelect").val() == '' || $("#_updCourierSelect").val() == null ){  
                	Common.alert('<spring:message code="sal.alert.msg.plzSelectCourier" />');
                    return false;
                }
            }
    	}
        
        // 리퀘스터  널 체크
        if($("#_updAgmReq").val() == '' || $("#_updAgmReq").val() == null){
        	Common.alert('<spring:message code="sal.alert.msg.plzSelectAgmReq" />');
        	return false;
        }
        
        //method 널 체크 (리시브 / 센드)
        if($("#_updConsignMethod").val() == '' || $("#_updConsignMethod").val() == null){
        	
        	Common.alert('<spring:message code="sal.alert.msg.plzSelectConsignMethod" />');
        	return false;
        	
        }else{ //method 선택 했을 때
        	
        	//선택 한 값이 1236 이면 (Send)
        	if('1236' == $("#_updConsignMethod").val()){
        		//Send Date 널 체크
        		if('' == $("#_updConSendDate").val() || null == $("#_updConSendDate").val()){
        			Common.alert('<spring:message code="sal.alert.msg.plzKeyinConsignSendDate" />');
        			return false;
        		}
        	}
        
        	// 선택 한 값이 1237 이면(Receive)
            if('1237' == $("#_updConsignMethod").val()){
            	// Receive Date 널 체크
            	if('' == $("#_updConReceiveDate").val() || null == $("#_updConReceiveDate").val()){
                    Common.alert('<spring:message code="sal.alert.msg.plzKeyinConsignEndDate" />');
                    return false;
                }
            }
        }
        
        return true;
    }
    
    function fn_updConInit(){
    	
    	//Date Display
    	$(".consignSendDate").css("display" , "none");
        $(".consignReceiveDate").css("display" , "none");
        
        //Consignment Number and CourierList
        $("#_updConsignmentNo").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});
        $("#_updCourierSelect").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});
        
        //Field Init
        $("#_updConsignMethod").val('');
        $("#_updConsignmentNo").val('');
        $("#_updCourierSelect").val('');
        $("#_updConSendDate").val('');
        $("#_updConReceiveDate").val('');
    }
    
    function fn_changeDateForm(changeVal){
    	
    	var temVal = changeVal;
    	
    	//Field Init
    	$("#_updConSendDate").val('');
        $("#_updConReceiveDate").val('');
    	
    	//Receive
    	if(temVal == '1237' ){
    		
    		$(".consignSendDate").css("display" , "none");
            $(".consignReceiveDate").css("display" , "");
    	}
    	
    	//Send
        if(temVal == '1236' ){
            
        	$(".consignSendDate").css("display" , "");
            $(".consignReceiveDate").css("display" , "none");
        }
    	
    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.addNewConsignment" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_conClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="_conSaveForm">
<input type="hidden" name="conAgrId" value="${updAgrId}">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:210px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.courierMethod" /></th>
    <td colspan="3">
    <label><input type="radio" name="updCourier" value="H"/><span><spring:message code="sal.combo.text.byHand" /></span></label>
    <label><input type="radio" name="updCourier" value="C"/><span><spring:message code="sal.text.courier" /></span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.courierConsNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" name="updConsignmentNo"  id="_updConsignmentNo"/></td> 
    <th scope="row"><spring:message code="sal.text.courier" /></th>
    <td>
    <select class="w100p" name="updCourierSelect" id="_updCourierSelect" ></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.consignMethod" /></th> 
    <td>
    <select class="w100p" name="updConsignMethod" id="_updConsignMethod" onchange="javascript : fn_changeDateForm(this.value)">
        <option value="1237"><spring:message code="sal.combo.text.recv" /></option>
        <option value="1236"><spring:message code="sal.combo.texxt.send" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agmReqstor" /></th>
    <td>
    <select class="w100p" name="updAgmReq" id="_updAgmReq">
        <option value="1"><spring:message code="sal.title.text.hp" /></option>
        <option value="2"><spring:message code="sal.title.text.cody" /></option>
        <option value="1234"><spring:message code="sal.title.text.customer" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row" class="consignSendDate"><spring:message code="sal.title.text.consignSendDate" /></th>
    <td class="consignSendDate">
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  name="updConSendDate" id="_updConSendDate"/>
    </td>
    <th scope="row" class="consignReceiveDate" ><spring:message code="sal.title.text.consignRecvDate" /></th>
    <td class="consignReceiveDate">
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  name="updConReceiveDate" id="_updConReceiveDate"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_conSaveBtn"><spring:message code="sal.btn.save" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_conClear"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</section><!-- pop_body end -->
</div>