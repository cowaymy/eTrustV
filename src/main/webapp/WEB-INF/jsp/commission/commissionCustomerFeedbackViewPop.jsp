<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
	var viewGridID;

	$(document).ready(function() {
	    createAUIGrid();
	    fn_itemDetailSearch('0');
	});

	function createAUIGrid() {
	    var columnLayout = [{
	        dataField : "userMemCode",
	        headerText : "<spring:message code='commission.text.search.memCode'/>",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "codeNm",
	        headerText : "<spring:message code='commission.text.search.type'/>",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "memNm",
	        headerText : "<spring:message code='commission.text.grid.memberName'/>",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "code",
	        headerText : "<spring:message code='commission.text.search.status'/>",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "validRem",
	        headerText : "<spring:message code='commission.text.grid.remark'/>",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "userCffMark",
	        headerText : "<spring:message code='commission.text.grid.mark'/>",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "uploadDetId",
	        style : "my-column",
	        visible : false,
	        editable : false
	    }];

	    var gridPros = {
	        usePaging : true,
	        pageRowCount : 20,
	        skipReadonlyColumns : true,
	        wrapSelectionMove : true,
	        showRowNumColumn : true

	    };

	    itemGridID = AUIGrid.create("#grid_wrap_view", columnLayout,gridPros);
	}

	function fn_itemDetailSearch(val){
	    var uploadId = $('#uploadUserId').val();

	    if(val == "0"){
	        var valTemp = {"uploadId" : uploadId};
	        Common.ajax("GET", "/commission/calculation/cffItemList", valTemp, function(result) {
	            AUIGrid.setGridData(itemGridID, result);
	        });
	    }else{
	        var valTemp = {"uploadId" : uploadId, "vStusId":val};
	        Common.ajax("GET", "/commission/calculation/cffItemList", valTemp, function(result) {
	            AUIGrid.setGridData(itemGridID, result);
	        });
	    }
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='commission.title.pop.head.cffView'/></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code='commission.text.search.batchId'/></th>
	<td>${detail.UPLOAD_ID }</td>
	<th scope="row"><spring:message code='commission.text.search.uploadBy'/></th>
	<td>${detail.CRT_USER_NAME } (${detail.CRT_DT} )</td>
</tr>
<tr>
	<th scope="row"><spring:message code='commission.text.search.status'/></th>
	<td>${detail.NAME }</td>
	<th scope="row"><spring:message code='commission.text.search.updateBy'/></th>
	<td>${detail.UPD_USER_NAME } (${detail.UPD_DT })</td>
</tr>
<tr>
    <th scope="row"><spring:message code='commission.text.search.orgType'/></th>
    <td>${detail.CODENAME1 }</td>
	<th scope="row"><spring:message code='commission.text.search.targetMonth'/></th>
	<td>${detail.ACTN_DT }</td>
</tr>
<tr>
	<th scope="row"><spring:message code='commission.text.search.totalItem'/></th>
	<td>${totalCnt }</td>
	<th scope="row"><spring:message code='commission.text.search.totalVaild'/></th>
	<td>${totalValid } / ${totalInvalid }</td>
</tr>
</tbody>
</table><!-- table end -->

<input type="hidden" name="uploadId" id="uploadUserId" value="${uploadId }">

<ul class="right_btns">
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('0');"><spring:message code='commission.button.allItem'/></a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('4');"><spring:message code='commission.button.viildItem'/></a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('21');"><spring:message code='commission.button.invaildItem'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_view" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->