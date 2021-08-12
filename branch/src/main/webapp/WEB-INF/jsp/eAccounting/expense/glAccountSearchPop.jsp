<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script  type="text/javascript">
var glCodeGridID;

$(document).ready(function() {
	
	//아이템 AUIGrid 칼럼 설정
	var glCodecolumnLayout = [ {
	    dataField : "glAccCode",
	    headerText : '<spring:message code="expense.GLAccount" />',
	    width : 150
	}, {
	    dataField : "glAccDesc",
	    headerText : '<spring:message code="expense.GLAccountName" />',
	    style : "aui-grid-user-custom-left",
	    width : 300
	}];
    
    glCodeGridID = GridCommon.createAUIGrid("#glCodeGrid", glCodecolumnLayout, "budgetCode", {editable:false});
        
     // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(glCodeGridID, "cellDoubleClick", function(event){
         
         $("#pGlAccCode").val(AUIGrid.getCellValue(glCodeGridID , event.rowIndex , "glAccCode"));
         $("#pGlAccCodeName").val( AUIGrid.getCellValue(glCodeGridID , event.rowIndex , "glAccDesc"));
                  
         if("${pop}" == "pop"){
             fn_setPopGlData();
         }else{
             fn_setGlData();
         }
         $("#glAccountSearchPop").remove();
    }); 
     
    // add jgkim
    if("${call}" == "budgetAdj") {
        $("#search_btn").click(fn_selectAdjustmentCBG);
    } else {
        $("#search_btn").click(fn_selectGlListAjax);
    }
    
});

//리스트 조회.
function fn_selectGlListAjax() {        
    Common.ajax("GET", "/eAccounting/expense/selectGlCodeList?_cacheId=" + Math.random(), $("#glSForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
        AUIGrid.setGridData(glCodeGridID, result);
    });
}

//add jgkim
function fn_selectAdjustmentCBG() {
    Common.ajax("GET", "/eAccounting/budget/selectAdjustmentCBG.do?_cacheId=" + Math.random(), $("#bgSForm").serializeJSON(), function(result) {
        console.log(result);
        AUIGrid.setGridData(glCodeGridID, result);
    });
}
</script>
<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="expense.GlAccountSearch" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue"><a href="#" id="search_btn"><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" id="glSForm" name="glSForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td><input id="glAccCode" name="glAccCode" type="text" title='<spring:message code="expense.GLAccount" />' placeholder="" class="w100p" /></td>
	<th scope="row"><spring:message code="expense.GLAccountName" /></th>
	<td><input  id="glAccCodeDesc" name="glAccCodeDesc" type="text" title='<spring:message code="expense.GLAccountName" />' placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="glCodeGrid" style="width:100%; height:350px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->