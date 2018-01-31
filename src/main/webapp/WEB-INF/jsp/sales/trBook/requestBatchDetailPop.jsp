<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

$(document).ready(function(){

	$("#btnDeactive").on("click" , function(){
		 Common.ajax("GET", "/sales/trBook/updateBkReqStus", {reqId : "${result.reqId}"}, function(result) {
		      
		       console.log("성공.");
		       console.log( result);
		       
		       $("#requestBatchDetailPop").remove();
		       fn_selectReqBatchList();
		       
		       Common.alert("<spring:message code="sal.alert.title.batchDeactivated" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.batchDeactivated" />");

		  }); 
	});
	
});



</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.viewTrBulkRequestBatch" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.subtitle.batchInformation" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.requestNumber" /></th>
	<td>${result.reqNo }</td>
	<th scope="row"><spring:message code="sal.text.status" /></th>
	<td>${result.name }</td>
	<th scope="row">  <spring:message code="sal.text.createAt" /> </th>
	<td>${result.crtDt }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.requestBranch" /></th>
	<td colspan="3">${result.code1 } - ${result.name1 }</td>
	<th scope="row"><spring:message code="sal.text.createBy" /></th>
	<td>${result.crtUser }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.prefix" /></th>
	<td>${result.prefix }</td>
	<th scope="row"><spring:message code="sal.text.quantity" /></th>
	<td>${result.qty }</td>
	<th scope="row"><spring:message code="sal.text.pagePerBook" /></th>
	<td>${result.pgePerBook }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.startTr" /></th>
	<td>${result.startReciptNo }</td>
	<th scope="row"><spring:message code="sal.text.endTr" /></th>
	<td>${result.endReciptNo }</td>
	<th scope="row"> <spring:message code="sal.text.updateAt" /> </th>
	<td>${result.updDt }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.startBook" /></th>
	<td>${result.trBookNoStart }</td>
	<th scope="row"> <spring:message code="sal.text.endBook" /> </th>
	<td>${result.trBookNoEnd }</td>
	<th scope="row"> <spring:message code="sal.text.updateBy" /> </th>
	<td>${result.updUser }</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
<c:if test="${result.code == 'ACT' }">
<li><p class="btn_grid"><a href="#" id="btnDeactive" ><spring:message code="sal.btn.deactive" /></a></p></li>
</c:if>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->