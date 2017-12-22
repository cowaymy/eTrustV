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
	        headerText : "Member Code",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "codeNm",
	        headerText : "Type",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "memNm",
	        headerText : "Member Name",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "code",
	        headerText : "Status",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "validRem",
	        headerText : "Remark",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "userTrgetAmt",
	        headerText : "Target AMT",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "userRefCode",
	        headerText : "Ref Code",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "userRefLvl",
	        headerText : "Lvl",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "uploadDetId",
	        style : "my-column",
	        visible : false,
	        editable : false
	    }];
	    // 그리드 속성 설정
	    var gridPros = {
	        // 페이징 사용       
	        usePaging : true,
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 20,
	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,
	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,
	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : true
	        
	    };
	    
	    itemGridID = AUIGrid.create("#grid_wrap_view", columnLayout,gridPros);
	}
	
	function fn_itemDetailSearch(val){
	    var uploadId = $('#uploadUserId').val();
	    
	    if(val == "0"){
	        var valTemp = {"uploadId" : uploadId};
	        Common.ajax("GET", "/commission/calculation/incentiveItemList", valTemp, function(result) {
	            AUIGrid.setGridData(itemGridID, result);
	        });
	    }else{
	        var valTemp = {"uploadId" : uploadId, "vStusId":val};
	        Common.ajax("GET", "/commission/calculation/incentiveItemList", valTemp, function(result) {
	            AUIGrid.setGridData(itemGridID, result);
	        });
	    }
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='commission.title.pop.head.incentiveView'/></h1>
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
	<th scope="row"><spring:message code='commission.text.search.uploadType'/></th>
	<td>${detail.CODE_NAME }</td>
	<th scope="row"><spring:message code='commission.text.search.targetMonth'/></th>
	<td>${detail.ACTN_DT }</td>
</tr>
<tr>
	<th scope="row"><spring:message code='commission.text.search.totalItem'/></th>
	<td>${totalCnt }</td>
	<th scope="row"><spring:message code='commission.text.search.totalVaild'/></th>
	<td>${totalValid } / ${totalInvalid }</td>
</tr>
<tr>
	<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
	<td colspan="3">${detail.CODENAME1 }</td>
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