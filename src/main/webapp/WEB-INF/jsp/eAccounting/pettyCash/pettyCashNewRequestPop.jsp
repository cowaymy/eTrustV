<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var callType = "${callType}";
//file action list
var update = new Array();
var remove = new Array();
$(document).ready(function () {
    setInputFile2();
    
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);
    $("#tempSave_btn").click(fn_tempSave);
    $("#request_btn").click(fn_reqstApproveLinePop);
    
    $("#reqstAmt").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   });
   
   $("#reqstAmt").click(function () { 
       var str = $("#reqstAmt").val().replace(/,/gi, "");
       $("#reqstAmt").val(str);      
  });
   $("#reqstAmt").blur(function () { 
       var str = $("#reqstAmt").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       $("#reqstAmt").val(str);      
  });
   
    $("#reqstAmt").change(function(){
       var str =""+ Math.floor($("#reqstAmt").val() * 100)/100;
       
       var str2 = str.split(".");
      
       if(str2.length == 1){
           str2[1] = "00";
       }
       
       if(str2[0].length > 11){
           Common.alert('<spring:message code="pettyCashNewCustdn.Amt.msg" />');
           str = "";
       }else{
           str = str2[0].substr(0, 11)+"."+str2[1];
       }
       
       if(Number(str) > Number($("#appvCashAmt").val().replace(/,/gi, ""))) {
    	   Common.alert('<spring:message code="pettyCashNewRqst.appvAmt.msg" />');
           str = "";
       }
       str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       
       
       $("#reqstAmt").val(str);
   }); 
    
    fn_setCostCenterEvent();
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_tempSave() {
	if(fn_checkEmpty()) {
		fn_saveNewRequest(callType);
	}
}

function fn_saveNewRequest(st) {
    if(fn_checkEmpty()){
        var formData = Common.getFormData("form_newReqst");
        var obj = $("#form_newReqst").serializeJSON();
        $.each(obj, function(key, value) {
            if(key == "custdnNric") {
                formData.append(key, value.replace(/\-/gi, ''));
                console.log(value.replace(/\-/gi, ''));
            } else if(key == "appvCashAmt") {
                formData.append(key, value.replace(/,/gi, ''));
                console.log(value.replace(/,/gi, ''));
            } else if(key == "reqstAmt"){
            	formData.append(key, value.replace(/,/gi, ''));
                console.log(value.replace(/,/gi, ''));
            } else {
            	formData.append(key, value);
            }
        });
        Common.ajaxFile("/eAccounting/pettyCash/insertPettyCashReqst.do", formData, function(result) {
            console.log(result);
            // tempSave가 아닌 바로 submit인 경우 대비
            $("#clmNo").val(result.data.clmNo);
            $("#atchFileGrpId").val(result.data.atchFileGrpId);
            if(st == "new") {
            	Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
            	$("#newRequestPop").remove();
            }
            fn_selectRequestList();
        });
    }
}

function fn_saveUpdateRequest(st) {
    if(fn_checkEmpty()){
        var formData = Common.getFormData("form_newReqst");
        var obj = $("#form_newReqst").serializeJSON();
        $.each(obj, function(key, value) {
            if(key == "custdnNric") {
                formData.append(key, value.replace(/\-/gi, ''));
                console.log(value.replace(/\-/gi, ''));
            } else if(key == "appvCashAmt") {
                formData.append(key, value.replace(/,/gi, ''));
                console.log(value.replace(/,/gi, ''));
            } else if(key == "reqstAmt"){
                formData.append(key, value.replace(/,/gi, ''));
                console.log(value.replace(/,/gi, ''));
            } else {
                formData.append(key, value);
            }
        });
        formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        Common.ajaxFile("/eAccounting/pettyCash/updatePettyCashReqst.do", formData, function(result) {
            console.log(result);
            if(st == "view") {
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#viewRequestPop").remove();
            }
            fn_selectRequestList();
        });
    }
}

function fn_reqstApproveLinePop() {
    var checkResult = fn_checkEmpty();
    
    if(!checkResult){
        return false;
    }
    
    // tempSave를 하지 않고 바로 submit인 경우
    if(FormUtil.isEmpty($("#clmNo").val())) {
        fn_saveNewRequest("");
    } else {
    	// 바로 submit 후에 appvLinePop을 닫고 재수정 대비
        fn_saveUpdateRequest("");
    }
    
    Common.popupDiv("/eAccounting/pettyCash/reqstApproveLinePop.do", null, null, true, "approveLineSearchPop");
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="pettyCashNewRqst.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" enctype="multipart/form-data" id="form_newReqst">
<input type="hidden" id="newCrtUserId" name="crtUserId" value="${userId}">
<input type="hidden" id="clmNo" name="clmNo">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId">
<input type="hidden" id="newCostCenterText" name="costCentrName">
<input type="hidden" id="newMemAccName" name="memAccName">
<input type="hidden" id="bankCode" name="bankCode">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr" /><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="pettyCashCustdn.creator" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="newCrtUserName" name="crtUserName" value="${userName}"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="pettyCashCustdn.custdn" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="newMemAccId" name="memAccId"/></td>
	<th scope="row"><spring:message code="pettyCashNewCustdn.icNoPassNo" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="custdnNric" name="custdnNric"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bank" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName" name="bankName"/></td>
	<th scope="row"><spring:message code="pettyCashNewCustdn.bankAccNo" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="pettyCashNewCustdn.appvCashAmt" /></th>
	<td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="appvCashAmt" name="appvCashAmt"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="pettyCashNewRqst.rqstAmt" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="reqstAmt" name="reqstAmt"/></td>
	<th scope="row"><spring:message code="pettyCashNewRqst.payDt" /></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="payDueDt" name="payDueDt"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
	<td colspan="3">
	<div class="auto_file2"><!-- auto_file start -->
	<input type="file" title="file add" />
	</div><!-- auto_file end -->
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.remark" /></th>
	<td colspan="3"><textarea cols="20" rows="5" id="reqstRem" name="reqstRem"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="request_btn"><spring:message code="webInvoice.select.request" /></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->