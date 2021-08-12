<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
$(document).ready(function(){      
	
//	fn_memberTypeChn("1");

	//Member Search Popup
	$('#memBtn').click(function() {
	    Common.popupDiv("/common/memberPop.do", {"callPrgm":"TR_BOOK_ASSIGN"}, null, true);
	});
	
	if ("${detailInfo.trHolderType}" != "Branch")
    {
        $("#trBookAssignPop").remove();
	    Common.alert("<spring:message code="sal.alert.title.trBookInfo" />" + DEFAULT_DELIMITER + "[ ${detailInfo.trBookNo} ] <spring:message code="sal.alert.msg.isHoldingBy" /> [ ${detailInfo.trHolder} ]. <spring:message code="sal.alert.msg.bookAssignIsDisallowed" /></b>");
    }
});

function fn_memberTypeChn(val){
	
    CommonCombo.initById("member");    
    CommonCombo.make("member", "/sales/trBook/selectMember", {"memberType" : val}, "", {
        id: "memCode",
        name: "name"
    });

}

function fn_loadOrderSalesman(typeId, text, memId, memCode, name) {
	$("#memTypeId").val(typeId);
	$("#memTypeText").val(text);
	$("#assignMemId").val(memId);
	$("#assignMemCode").val(memCode);
	$("#assignMemName").val(name);
	
}

function fn_assignSave(){
	
     if ($("#assignMemCode").val() == "")
     {
    	 $("#msg").html("<spring:message code="sal.msg.requiredEmpty" />");
    	 $("#msg").attr("style", "color:red");
    	 return false;
     }
     Common.ajax("POST", "/sales/trBook/saveAssign", $("#saveAssignForm").serializeJSON(), function(result) {
         
         console.log("성공.");
         console.log( result);        

         if(result.saveYn == "N"){

             $("#msg").attr("style", "color:red");
         }else{
             $("#msg").attr("style", "color:green");
             $("#memBtn").hide();
             $("#btnAssignSave").hide();
             fn_selectListAjax();
         }
         $("#msg").html(result.msg);
         
    },
    function(jqXHR, textStatus, errorThrown){
         try {
             console.log("Fail Status : " + jqXHR.status);
             console.log("code : "        + jqXHR.responseJSON.code);
             console.log("message : "     + jqXHR.responseJSON.message);
             console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
             }
         catch (e)
         {
           console.log(e);
         }
         alert("Fail : " + jqXHR.responseJSON.message);

         $("#msg").attr("style", "color:red");
         $("#msg").html("<spring:message code="sal.msg.failToSave" />");
     });
          
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Assign</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post" id="saveAssignForm" name="saveAssignForm">
<input type="hidden" id="assignHTrBookId" name="assignHTrBookId" value="${trBookId}">
<input type="hidden" id="memTypeId" name="memTypeId">
<input type="hidden" id="memTypeText" name="memTypeText">
<input type="hidden" id="assingHolder" name="assingHolder" value="${detailInfo.trHolder}">
<span id="msg"> </span>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.trBookNo" /></th>
	<td>${detailInfo.trBookNo}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.trPrefixNo" /></th>
	<td>${detailInfo.trBookPrefix}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.noOfPage" /></th>
	<td>${detailInfo.trBookPge}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.trNo" /></th>
	<td>${detailInfo.trBookNoStart} To ${detailInfo.trBookNoEnd}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.trBookHolder" /></th>
	<td> ${detailInfo.trHolder}</td>
</tr>
<!-- <tr>
	<th scope="row">Assign Member Type</th>
	<td>
		<select class="" id="memberType" name="memberType" onchange="javascript:fn_memberTypeChn(this.value);">
			<option value="" selected="selected">Member Type</option>
			<option value="1">Health Planner</option>
			<option value="2">Cody</option>
			<option value="3">Coway Technician</option>
			<option value="4">Staff</option>
		</select>
	</td>
</tr> -->
<tr>
	<th scope="row"><spring:message code="sal.text.assignMember" /></th>
	<td>
	<input type="hidden" id="assignMemId" name="assignMemId"/>
	<input type="hidden" id="assignMemCode" name="assignMemCode"/>
	<input type="text" id="assignMemName" name="assignMemName" readonly="readonly"/>
	<a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id="btnAssignSave" onclick="javascript:fn_assignSave();"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->