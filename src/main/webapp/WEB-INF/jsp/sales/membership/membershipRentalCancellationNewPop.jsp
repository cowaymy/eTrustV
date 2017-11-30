<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script  type="text/javascript">

var reqInfoGrid;

$(document).ready(function(){
    creatReqInfoGrid();

    $("#searchText").html("<spring:message code="sales.MembershipNo" />");
    
    $("#searchType").on("change", function(){

        if($("#searchType").val() == "ORDER"){
            $("#searchText").html("<spring:message code="sales.OrderNo" />");
        }else{
            $("#searchText").html("<spring:message code="sales.MembershipNo" />");
        }
    });
    
//    fn_keyEvent();
    
});

/* function fn_keyEvent(){
	  $("#searchNo").keydown(function(key)  {
		    if (key.keyCode == 13) {
		    	fn_selectCancellReqInfoAjax();
		    }
	  });
} */

function creatReqInfoGrid(){
    
    var reqColLayout = [ {
        dataField : "srvCntrctId",
        visible :false,
        headerText : '',
        width : 150
    },{
        dataField : "srvCntrctOrdId",
        visible :false,
        headerText : '',
        width : 150
    },{
        dataField : "salesOrdNo",
        headerText : '<spring:message code="sales.OrderNo" />',
        width : 150
    },{
        dataField : "srvCntrctRefNo",
        headerText : '<spring:message code="sales.MembershipNo" />',
        width : 200   
    },{
        dataField : "status",
        headerText : '<spring:message code="sales.Status" />',
        width : 120
    },{
        dataField : "cntrctRentalStus",
        headerText : '<spring:message code="sales.RentStatus" />',
        width : 160
    },{
        dataField : "srvPrdStartDt",
        headerText : '<spring:message code="sales.StartDate" />',
        width : 160
    }, {
        dataField : "srvPrdExprDt",
        headerText : '<spring:message code="sales.ExpireDate" />',
        width : 160
    }];
    

    var reqOptions = {
               showStateColumn:false,
               showRowNumColumn    : false,
               usePaging : false,
               editable : false
         }; 
    
    reqInfoGrid = GridCommon.createAUIGrid("#reqInfoGrid", reqColLayout, "", reqOptions); 
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(reqInfoGrid, "cellDoubleClick", function(event){

        $("#srvCntrctId").val(AUIGrid.getCellValue(reqInfoGrid , event.rowIndex , "srvCntrctId"));
        $("#srvCntrctOrdId").val(AUIGrid.getCellValue(reqInfoGrid , event.rowIndex , "srvCntrctOrdId"));
        fn_saveViewPop();
    });
}

//리스트 조회.
function fn_selectCancellReqInfoAjax() {  
       
    if($("#searchNo").val() ==""){
    	var msg;
    	if($("#searchType").val() == "ORDER"){
    		msg = "<spring:message code="sales.OrderNo" />";
        }else{
        	msg = "<spring:message code="sales.MembershipNo" />";
        }
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
		    $("#searchNo").focus();
		});
		return;
    }
    
    Common.ajax("GET", "/sales/membership/selectCancellReqInfo", $("#reqForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
        AUIGrid.setGridData(reqInfoGrid, result);
    
    });
}

//view 화면 호출.
function fn_saveViewPop() {     
    Common.popupDiv("/sales/membership/cancellationSaveViewPop.do", $("#reqForm").serializeJSON(), null, true, "cancellationSaveViewPop");
    
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sales.title.cancellRep" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="reqForm" name="reqForm">

<input type="hidden" id = "srvCntrctId" name="srvCntrctId">
<input type="hidden" id = "srvCntrctOrdId" name="srvCntrctOrdId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:250px" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.SelectType" /></th>
	<td>
	<select class="w100p" id="searchType" name="searchType">
		<option value="ORDER"><spring:message code="sales.OrderNo" /></option>
		<option value="RSVM" selected="selected"><spring:message code="sales.MembershipNo" /></option>
	</select>
	</td>
	<th scope="row" id="searchText"></th>
	<td>
		<input type="text" id="searchNo" name="searchNo" title="" placeholder="" class="" />
		<input type="text" style="display: none;" title="" placeholder="" class="" />
		<p class="btn_sky"><a href="#" onclick="javascript:fn_selectCancellReqInfoAjax();"><spring:message code="sales.Search" /></a></p>
		<%-- <p class="btn_sky"><a href="#"><spring:message code="sales.Clear" /></a></p> --%>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="reqInfoGrid" style="width:100%; height:100px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->