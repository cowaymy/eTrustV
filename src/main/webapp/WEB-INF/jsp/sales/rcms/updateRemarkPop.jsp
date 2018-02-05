<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">


var packageInfo={};

$(document).ready(function(){
    $("#sensitiveFg").val("0");

    fn_selectAjax();
   
});

//리스트 조회.
function fn_selectAjax() {       
	
	Common.ajax("GET", "/sales/rcms/selectRcmsInfo", {orderNo: $("#orderNo").val() }, function(result) {
		
	     console.log(result);
	     
	     $("#remark").val(result.data.rem);  
	     $("#popOrderNo").val(result.data.salesOrdNo);  
	     $("#popOrdId").val(result.data.salesOrdId);
	     
	     if(result.data.sensitiveFg == "1"){
             $("#sensitiveFg").val(result.data.sensitiveFg);
             $("#chkSensitiveFg").attr("checked","checked");
         }

	});
}


function fn_chk(){
	if($("input:checkbox[id='chkSensitiveFg']").is(":checked")){
		$("#sensitiveFg").val("1");
	}else{
        $("#sensitiveFg").val("0");
	}
}

function fn_save(){
		
    Common.ajax("POST", "/sales/rcms/updateRemark", $("#saveForm").serializeJSON(), function(result) {
        
           Common.alert('<spring:message code="sal.alert.msg.successToSaved" />'+DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.rcmsItemSuccessSaved" />');

           $("#updateRemarkPop").remove();
           
           fn_selectListAjax();
           
       }, function(jqXHR, textStatus, errorThrown) {
    	   
           console.log("실패하였습니다.");
           console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
           
           Common.alert('<spring:message code="sal.alert.title.saveFail" />'+DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.saveFail" />');

           console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
           
       }); 
	
}

</script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.editRcmsRem" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="saveForm" name="saveForm">
    <input type="hidden" id="popOrdId" name="salesOrdId" />
    <input type="hidden" id="sensitiveFg" name="sensitiveFg" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>         
<tr>
	<th scope="row"><spring:message code="sal.title.text.ordNop" /></th>
	<td><input type="text" title="" class="readonly" readonly="readonly" style="width: 100%" id="popOrderNo"  name="popOrderNo"/></td>
	<th scope="row"><spring:message code="sal.title.text.sensitive" /><span class="must"></span></th>
	<td><input type="checkbox"  id="chkSensitiveFg"  name="chkSensitiveFg" onclick="fn_chk()"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td colspan="3"> <textarea cols="20" rows="5" id='remark'  name='remark' placeholder="Remark" name='remark'></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id='savebt'   onclick="javascript:fn_save()"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->