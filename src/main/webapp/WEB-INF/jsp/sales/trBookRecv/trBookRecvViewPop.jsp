<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-green {
    background:#B9F3B9;
   /*  font-weight:bold; */
    color:#000000;
}

/* 커스텀 행 스타일 */
.my-row-pink {
    background:#F9CAE6;
    /* font-weight:bold; */
    color:#000000;
}
</style>
<script  type="text/javascript">
var transitGridID;
var infoList;

$(document).ready(function(){

    if('${infoList}'=='' || '${infoList}' == null){
   }else{
       infoList = JSON.parse('${infoList}');
   }  
    
    creatTransitGrid();
    
    $("#subTitle").html("All Transit Book List");
    
});

function creatTransitGrid(){

    var transitColLayout = [ 
          {dataField : "trBookId", headerText : "", width : 140  , visible:false   },
          {dataField : "trTrnsitResultStusId", headerText : "", width : 140  , visible:false   },
          {dataField : "trBookNo", headerText : "<spring:message code="sal.title.bookNo" />", width : 150      },
          {dataField : "trBookPrefixNo", headerText : "<spring:message code="sal.title.prefix" />", width : 150       },
          {dataField : "trReciptNoStr", headerText : "<spring:message code="sal.title.from" />", width : 150        },
          {dataField : "trReciptNoEnd", headerText : "<spring:message code="sal.title.to" />", width : 150        },
          {dataField : "trBookQty", headerText : "<spring:message code="sal.title.sheet" />", width : 150      },
          {dataField : "code", headerText : "<spring:message code="sal.title.status" />", width : 150     }          
          ];
    

    var transitOptions = {
               showStateColumn:false,
               showRowNumColumn    : true,
               usePaging : true,
               editable : false//,
               //selectionMode : "singleRow"
         }; 
    
    transitGridID = GridCommon.createAUIGrid("#transitGridID", transitColLayout, "", transitOptions);
    
    
    if(infoList != '' ){
        AUIGrid.setGridData(transitGridID, infoList);
        
        fn_gridSetColor();
        
    } 
    
    // 셀 더블클릭 이벤트 바인딩
     AUIGrid.bind(transitGridID, "cellDoubleClick", function(event){
         
          $("#trBookId").val(AUIGrid.getCellValue(transitGridID , event.rowIndex , "trBookId"));
         
          Common.popupDiv("/sales/trBook/trBookMgmtDetailPop.do",$("#listSForm").serializeJSON(), null, true, "trBookMgmtDetailPop");
          
     });
    // 셀 더블클릭 이벤트 바인딩
     AUIGrid.bind(transitGridID, "cellClick", function(event){
         
          $("#trBookId").val(AUIGrid.getCellValue(transitGridID , event.rowIndex , "trBookId"));
              
     });
}

function fn_gridSetColor(){
	
	AUIGrid.setProp(transitGridID, "rowStyleFunction", function(rowIndex, item) {
        if(item.trTrnsitResultStusId == "4") {
            return "my-row-green";                   
        }else if(item.trTrnsitResultStusId == "50"){
            return "my-row-pink";
        }else{
            return "";
        }

     }); 

     // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
     AUIGrid.update(transitGridID);
}

//리스트 조회.
function fn_selectTransitListAjax(str) {
  
	$("#searchType").val(str);
	
	if(str == "All"){
	    $("#subTitle").html("<spring:message code="sal.page.subTitle.allList" />");
	}else if(str == "Recv"){
        $("#subTitle").html("<spring:message code="sal.page.subTitle.recvList" />");
    }else if(str == "NotRecv"){
        $("#subTitle").html("<spring:message code="sal.page.subTitle.notRecvList" />");
    }
	
	Common.ajax("GET", "/sales/trBookRecv/selectTransitList", $("#searchForm").serializeJSON(), function(result) {
	    
	     console.log("성공.");
	     console.log( result);
	     
	    AUIGrid.setGridData(transitGridID, result);
	    
	    fn_gridSetColor();
	
	});
} 



</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.trBooktTranRecvView" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form action="#" method="post" id="searchForm" name="searchForm">
	<input type="hidden" id="viewTrnsitId" name="trnsitId" value="${trnsitId }">
	<input type="hidden" id="searchType" name="searchType">
</form>
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.subTitle.transitInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.transitNo" /></th>
	<td>${info.trnsitNo }</td>
	<th scope="row"><spring:message code="sal.text.transitDate" /></th>
	<td>${info.trnsitDt }</td>
	<th scope="row"><spring:message code="sal.text.transitStatus" /></th>
	<td>${info.trnsitStusName}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.transitFrom" /></th>
	<td>${info.trnsitFrom} - ${info.trnsitFromName}</td>
	<th scope="row"><spring:message code="sal.text.transitTo" /></th>
	<td>${info.trnsitTo} - ${info.trnsitToName}</td>
	<th scope="row"><spring:message code="sal.text.closeDate" /></th>
	<td>${info.trnsitClosDt}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.totalBook" /></th>
	<td>${info.trnsitTotBook}</td>
	<th scope="row"><spring:message code="sal.text.courier" /></th>
	<td>${info.trnsitCurier}</td>
	<th scope="row"><spring:message code="sal.text.creator" /></th>
	<td>${info.trnsitCurierName}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.totalPending" /></th>
	<td>${info.pendingCnt }</td>
	<th scope="row"><spring:message code="sal.text.totalReceived" /></th>
	<td>${info.recvCnt }</td>
	<th scope="row"><spring:message code="sal.text.totalNotReceived" /></th>
	<td>${info.notRecvCnt }</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Book Transit</h2>
<ul class="right_btns">
    <li><p class="btn_grid right"><a href="#" onclick="javascript:fn_selectTransitListAjax('All');"><spring:message code="sal.btn.all" /></a></p></li> 
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectTransitListAjax('Recv');"><spring:message code="sal.btn.recv" /></a></p></li>    
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectTransitListAjax('NotRecv');"><spring:message code="sal.btn.notRecv" /></a></p></li>  
</ul>
</aside><!-- title_line end -->
<div  class="mt10" style="text-align: center;"><span id="subTitle"> </span></div>
<article class="grid_wrap mt5"><!-- grid_wrap start -->
<div id="transitGridID" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<!-- <ul class="lefe_btns mt10">

</ul> -->
<ul class="right_btns">
    <li><span ><spring:message code="sal.text.pending" /> </span></li>
    <li><span class="green_text"><spring:message code="sal.text.received" /></span></li>
    <li><span class="pink_text"><spring:message code="sal.text.notReceived" /></span></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->