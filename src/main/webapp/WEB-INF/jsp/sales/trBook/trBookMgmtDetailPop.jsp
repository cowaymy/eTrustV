<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
var trDetailGrid;
var detailList;

$(document).ready(function(){
    
    if('${detailList}'=='' || '${detailList}' == null){
    }else{
    	detailList = JSON.parse('${detailList}');         
    	console.log(detailList);
    }   

    //AUIGrid 그리드를 생성합니다.
    creatDetailGrid();
    
});

function creatDetailGrid(){
    var trDColLayout = [ 
         {dataField : "trReciptNo", headerText : "Book No", width : 150      },
         {dataField : "itmStusCode", headerText : "Status", width : 150       },
         {dataField : "itmUpdBy", headerText : "trBookNoStart", width : 150        },
         {dataField : "itmUpdDt", headerText : "Update Date", width : 150        }        
         ];
   

   var trDOptions = {
              showStateColumn:false,
              showRowNumColumn    : true,
              usePaging : true,
              editable : false
        };    

   trDetailGrid = GridCommon.createAUIGrid("#trDetailGrid", trDColLayout, "", trDOptions);
   
   if(detailList != '' ){
       AUIGrid.setGridData(trDetailGrid, detailList);
   } 
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View TR BOOK</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>TR Book Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">TR Book No</th>
	<td>${detailInfo.trBookNo }</td>
	<th scope="row">Prefix No</th>
	<td>${detailInfo.trBookPrefix }</td>
</tr>
<tr>
	<th scope="row">TR No</th>
	<td colspan="3">${detailInfo.trBookNoStart }</td>
</tr>
<tr>
	<th scope="row">Status</th>
	<td>${detailInfo.trBookStusCode }</td>
	<th scope="row">Total Page(s)</th>
	<td>${detailInfo.trBookPge }</td>
</tr>
<tr>
	<th scope="row">Holder Type</th>
	<td>${detailInfo.trHolderType }</td>
	<th scope="row">Create By</th>
	<td>${detailInfo.trBookCrtUserName }</td>
</tr>
<tr>
	<th scope="row">Holder</th>
	<td>${detailInfo.trHolder }</td>
	<th scope="row">Create At</th>
	<td>${detailInfo.trBookCrtDt }</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>TR Receipt Information</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="trDetailGrid" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->