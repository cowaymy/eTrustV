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
		       
		       Common.alert("BATCH DEACTIVATED" + DEFAULT_DELIMITER + "This request batch has been deactivated.");

		  }); 
	});
	
});



</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View TR BULK REQUEST BATCH</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Batch Information</h2>
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
	<th scope="row">Request Number</th>
	<td>${result.reqNo }</td>
	<th scope="row">Status</th>
	<td>${result.name }</td>
	<th scope="row">  Create At </th>
	<td>${result.crtDt }</td>
</tr>
<tr>
	<th scope="row">Request Branch</th>
	<td colspan="3">${result.code1 } - ${result.name1 }</td>
	<th scope="row">Create By</th>
	<td>${result.crtUser }</td>
</tr>
<tr>
	<th scope="row">Prefix</th>
	<td>${result.prefix }</td>
	<th scope="row">Quantity</th>
	<td>${result.qty }</td>
	<th scope="row">Page Per Book</th>
	<td>${result.pgePerBook }</td>
</tr>
<tr>
	<th scope="row">Start TR</th>
	<td>${result.startReciptNo }</td>
	<th scope="row">End TR</th>
	<td>${result.endReciptNo }</td>
	<th scope="row"> Update At </th>
	<td>${result.updDt }</td>
</tr>
<tr>
	<th scope="row">Start Book</th>
	<td>${result.trBookNoStart }</td>
	<th scope="row"> End Book </th>
	<td>${result.trBookNoEnd }</td>
	<th scope="row"> Update By </th>
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