<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">
var detailGridID;
$(document).ready(function(){

    creatGrid();
    fn_selectDetailListAjax();
});

function creatGrid(){

    var detailColLayout = [ {
        dataField : "rsItmCntrctNo",
        headerText : '<spring:message code="sales.MembershipNo" />',
        width : 150
    },{
        dataField : "rsItmOrdNo",
        headerText : '<spring:message code="sales.OrderNo" />',
        visible : false
    },{
        dataField : "validStus",
        headerText : '<spring:message code="sales.Status" />',
        width : 150
    },{
        dataField : "appType",
        headerText : '<spring:message code="sales.AppType" />',
        width : 100
    }, {
        dataField : "rsSysRentalStus",
        headerText : '<spring:message code="sales.RentalStatus" />',
        width : 100
    },{
        dataField : "crtUserName",
        headerText : '<spring:message code="sales.Creator" />',
        width : 100
    },{
        dataField : "rsItmCrtDt",
        headerText : '<spring:message code="sales.CreateDate" />',
        width : 150
    }];
    

    var detailOptions = {
               showStateColumn:false,
               showRowNumColumn    : true,
               usePaging : true,
               editable : false
         }; 
    
    detailGridID = GridCommon.createAUIGrid("#detailGridID", detailColLayout, "", detailOptions);
    
 
}


//리스트 조회.
function fn_selectDetailListAjax() {        
	
	
Common.ajax("GET", "/sales/membership/selectCnvrDetailList", {"sRsStusId":$("#sRsStusId").val(), "sRsCnvrId" :$("#sRsCnvrId").val()}, function(result) {
    
     console.log("성공.");
     console.log( result);
     
    AUIGrid.setGridData(detailGridID, result.cnvrDetailList);
    
    $("#pRsCnvrNo").html(result.cnvrDetail.rsCnvrNo);  
    $("#pRsCnvrCrtDt").html(result.cnvrDetail.rsCnvrCrtDt);  
    $("#pCrtUserName").html(result.cnvrDetail.crtUserName);  
    $("#pRsStusName").html(result.cnvrDetail.rsStusName);  
    $("#pRsCnvrStusFrom").html(result.cnvrDetail.rsCnvrStusFrom);  
    $("#pRsCnvrStusTo").html(result.cnvrDetail.rsCnvrStusTo);  
    $("#pTotalCnt").html(result.totalCnt);  
    $("#pRsCnvrCnfmDt").html(result.cnvrDetail.rsCnvrCnfmDt);  
    $("#pCnfmUserName").html(result.cnvrDetail.cnfmUserName);  
    $("#pCnvrStusCodeName").html(result.cnvrDetail.cnvrStusCodeName);  
    $("#pRsCnvrDt").html(result.cnvrDetail.rsCnvrDt);  
    $("#pUserName").html(result.cnvrDetail.userName);  
    $("#pRsCnvrRem").html(result.cnvrDetail.rsCnvrRem);  
    
    if(result.cnvrDetail.rsStusName != "Active"){
    	$("#btns").hide();
    }

});
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sales.viewTitle" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sales.ConversionBatchInfo" /></h3>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.ConvertNo" /></th>
	<td><span id="pRsCnvrNo"></span></td>
	<th scope="row"><spring:message code="sales.CreateAt" /></th>
	<td><span id="pRsCnvrCrtDt"></span></td>
	<th scope="row"><spring:message code="sales.CreateBy" /></th>
	<td><span id="pCrtUserName"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.BatchStatus" /></th>
	<td><span id="pRsStusName"></span></td>
	<th scope="row"><spring:message code="sales.StatusFrom" /></th>
	<td><span id="pRsCnvrStusFrom"></span></td>
	<th scope="row"><spring:message code="sales.StatusTo" /></th>
	<td><span id="pRsCnvrStusTo"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.TotalItem" /></th>
	<td><span id="pTotalCnt"></span></td>
	<th scope="row"><spring:message code="sales.ComfirmAt" /></th>
	<td><span id="pRsCnvrCnfmDt"></span></td>
	<th scope="row"><spring:message code="sales.ConfirmBy" /></th>
	<td><span id="pCnfmUserName"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.ConvertStatus" /></th>
	<td><span id="pCnvrStusCodeName"></span></td>
	<th scope="row"><spring:message code="sales.ConvertAt" /></th>
	<td><span id="pRsCnvrDt"></span></td>
	<th scope="row"><spring:message code="sales.ConvertBy" /></th>
	<td><span id="pUserName"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.Remark" /></th>
	<td colspan="5"><span id="pRsCnvrRem"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="detailGridID" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section>
<ul class="center_btns" id="btns">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sales.Confirm" /></a></p></li>
    <li><p class="btn_blue2"><a href="#"><spring:message code="sales.Deactivate" /></a></p></li>
</ul>

</div><!-- popup_wrap end -->
