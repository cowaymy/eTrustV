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
	    headerText : '<spring:message code="expense.GLAccount" />'
	}, {
	    dataField : "glAccDesc",
	    headerText : '<spring:message code="expense.GLAccountName" />',
	    style : "aui-grid-user-custom-left"
	}];
    
    glCodeGridID = GridCommon.createAUIGrid("#glCodeGrid", glCodecolumnLayout, "budgetCode", {editable:false});
        
     // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(glCodeGridID, "cellDoubleClick", function(event){
         
         /* $("#pGlAccCode").val(AUIGrid.getCellValue(glCodeGridID , event.rowIndex , "glAccCode"));
         $("#pGlAccCodeName").val( AUIGrid.getCellValue(glCodeGridID , event.rowIndex , "glAccDesc"));
                  
         if("${pop}" == "pop"){
             fn_setPopGlData();
         }else{
             fn_setGlData();
         } */
         
         AUIGrid.setCellValue(newGridID , "${rowIndex}" , "glAccCode", AUIGrid.getCellValue(glCodeGridID , event.rowIndex , "glAccCode"));
         AUIGrid.setCellValue(newGridID , "${rowIndex}" , "glAccCodeName",  AUIGrid.getCellValue(glCodeGridID , event.rowIndex , "glAccDesc"));
         
         $("#glAccountSearchPop").remove();
    }); 
    
});

//리스트 조회.
function fn_selectGlListAjax() {        
    Common.ajax("GET", "/eAccounting/webInvoice/selectGlCodeList", $("#glSForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
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
	<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_selectGlListAjax();"><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" id="glSForm" name="glSForm" method="post">
<input type="hidden" name="costCentrName" value="${costCentrName}">
<input type="hidden" name="costCentr" value="${costCentr}">
<input type="hidden" name="budgetCodeName" value="${budgetCodeName}">
<input type="hidden" name="budgetCode" value="${budgetCode}">

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
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
    <td><input type="text" placeholder="" class="readonly w100p" readonly="readonly" value="${costCentr}"/></td>
	<th scope="row"><spring:message code="expense.Activity" /></th>
    <td><input type="text" placeholder="" class="readonly w100p" readonly="readonly" value="${budgetCode}"/></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap" id="glCodeGrid"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->