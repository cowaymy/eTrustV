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
          {dataField : "trBookNo", headerText : "Book No", width : 150      },
          {dataField : "trBookPrefixNo", headerText : "Prefix", width : 150       },
          {dataField : "trReciptNoStr", headerText : "From", width : 150        },
          {dataField : "trReciptNoEnd", headerText : "To", width : 150        },
          {dataField : "trBookQty", headerText : "Total Sheet(s)", width : 150      },
          {dataField : "code", headerText : "Status", width : 150     }          
          ];
    

    var transitOptions = {
               showStateColumn:false,
               showRowNumColumn    : true,
               usePaging : true,
               editable : false,
               selectionMode : "singleRow"
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
	    $("#subTitle").html("All Transit Book List");
	}else if(str == "Recv"){
        $("#subTitle").html("Received List");
    }else if(str == "NotRecv"){
        $("#subTitle").html("Not Received List");
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
<h1>TR Book Management - Transit Receive View</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form action="#" method="post" id="searchForm" name="searchForm">
	<input type="hidden" id="viewTrnsitId" name="trnsitId" value="${trnsitId }">
	<input type="hidden" id="searchType" name="searchType">
</form>
<aside class="title_line"><!-- title_line start -->
<h2>Transit Information</h2>
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
	<th scope="row">Transit No</th>
	<td>${info.trnsitNo }</td>
	<th scope="row">Transit Date</th>
	<td>${info.trnsitDt }</td>
	<th scope="row">Transit Status</th>
	<td>${info.trnsitStusName}</td>
</tr>
<tr>
	<th scope="row">Transit From</th>
	<td>${info.trnsitFrom} - ${info.trnsitFromName}</td>
	<th scope="row">Transit To</th>
	<td>${info.trnsitTo} - ${info.trnsitToName}</td>
	<th scope="row">Close Date</th>
	<td>${info.trnsitClosDt}</td>
</tr>
<tr>
	<th scope="row">Total Book</th>
	<td>${info.trnsitTotBook}</td>
	<th scope="row">Courier</th>
	<td>${info.trnsitCurier}</td>
	<th scope="row">Creator</th>
	<td>${info.trnsitCurierName}</td>
</tr>
<tr>
	<th scope="row">Total Pending</th>
	<td>${info.pendingCnt }</td>
	<th scope="row">Total Received</th>
	<td>${info.recvCnt }</td>
	<th scope="row">Total Not Received</th>
	<td>${info.notRecvCnt }</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Book Transit</h2>
<ul class="right_btns">
    <li><p class="btn_grid right"><a href="#" onclick="javascript:fn_selectTransitListAjax('All');">All</a></p></li> 
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectTransitListAjax('Recv');">Received</a></p></li>    
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectTransitListAjax('NotRecv');">Not Receive</a></p></li>  
</ul>
</aside><!-- title_line end -->
<div  class="mt10" style="text-align: center;"><span id="subTitle"> </span></div>
<article class="grid_wrap mt5"><!-- grid_wrap start -->
<div id="transitGridID" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<!-- <ul class="lefe_btns mt10">

</ul> -->
<ul class="right_btns">
    <li><span >Pending </span></li>
    <li><span class="green_text">Received</span></li>
    <li><span class="pink_text">Not Receive</span></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->