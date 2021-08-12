<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
$(document).ready(function(){      
	
	CommonCombo.make("tranBranch", "/sales/trBook/selectBranch", "", "", {
        id: "code",
        name: "name"
    });
	
	CommonCombo.make("tranCourier", "/sales/trBook/selectCourier", "", "", {
        id: "curierCode",
        name: "curierName"
    });
});


function fn_tranSingleSave(){
	
     if ($("#tranBranch").val() == "" || $("#tranCourier").val() == "")
     {
    	 $("#msg").html("* Some required fields are empty.");
    	 $("#msg").attr("style", "color:red");
    	 return false;
     }
     
     Common.ajax("POST", "/sales/trBook/saveTranSingle", $("#saveTranSingleForm").serializeJSON(), function(result) {
         
         console.log("성공.");
         console.log( result);        

         if(result.saveYn == "N"){

             $("#msg").attr("style", "color:red");
         }else{

             $("#msg").attr("style", "color:green");
         }
         $("#msg").html("* This book has successfully transfer out to courier.");
         $("#btnTranSingleSave").hide();
         
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
        // alert("Fail : " + jqXHR.responseJSON.message);

         $("#msg").attr("style", "color:red");
         $("#msg").html("* Failed to save. Please try again later.");
     });
          
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.transferTrBook" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post" id="saveTranSingleForm" name="saveTranSingleForm">
<input type="hidden" id="tranTrBookId" name="tranTrBookId" value="${trBookId}">
<input type="hidden" id="tranHolder" name="tranHolder" value="${detailInfo.trHolder}">
<span id="msg"> </span>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.title.text.trBookNo" /></th>
	<td>${detailInfo.trBookNo}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.trPrefixNo" /></th>
	<td>${detailInfo.trBookPrefix}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.noOfPages" /></th>
	<td>${detailInfo.trBookPge}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.trNo" /></th>
	<td>${detailInfo.trBookNoStart} To ${detailInfo.trBookNoEnd}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.trBookHolder" /></th>
	<td> ${detailInfo.trHolder}</td>
</tr>
<tr>
	<th scope="row"><span class="must">*</span><spring:message code="sal.alert.msg.transferTo" /></th>
    <td>
        <select class=" w100p"  id="tranBranch" name="branch">
        </select>
    </td>
</tr>
<tr>
	<th scope="row"><span class="must">*</span><spring:message code="sal.text.courier" /></th>
    <td>
        <select class=" w100p"  id="tranCourier" name="courier">
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id="btnTranSingleSave" onclick="javascript:fn_tranSingleSave();"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->