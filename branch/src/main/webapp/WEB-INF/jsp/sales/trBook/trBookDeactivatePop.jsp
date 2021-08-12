<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

$(document).ready(function(){
    
});


function fn_deactivate(){
    Common.ajax("POST", "/sales/trBook/trBookDeactivate", $("#deActForm").serializeJSON(), function(result)    {
    	
        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.cnt);

        $("#deActMsg").attr("style", "color:green");
        $("#deActMsg").html("<spring:message code="sal.msg.deacivated" />");
        $("#btnDeact").hide();
        fn_selectListAjax();
        
     }
     , function(jqXHR, textStatus, errorThrown){
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
         
          $("#deActMsg").attr("style", "color:red");
          $("#deActMsg").html("<spring:message code="sal.msg.failToSave" />");
    });
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.deactivateTrBook" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<div><span id="deActMsg"></span></div>

<form action="#" method="post" id="deActForm" name="deActForm" >

<input type="hidden" id="deActTrBookId" name ="trBookId" value="${detailInfo.trBookId }"> 

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.trBookNo" /></th>
	<td>${detailInfo.trBookNo }</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.trPrefixNo" /></th>
    <td>${detailInfo.trBookPrefix }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.noOfPage" /></th>
	<td>${detailInfo.trBookPge }</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.trNo" /></th>
    <td>${detailInfo.trBookNoStart } to ${detailInfo.trBookNoEnd }</td>    
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.trBookHolder" /></th>
	<td>${detailInfo.trHolder }</td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="btnDeact" onclick="fn_deactivate();"><spring:message code="sal.btn.save" /></a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->