<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">
var recvGridID;

$(document).ready(function(){

    creatGrid();
     
});


function creatGrid(){

        var recvColLayout = [ 
              {dataField : "trnsitId", headerText : "", width : 140  , visible:false   },
              {dataField : "trnsitNo", headerText : "Transit No", width : 150      },
              {dataField : "trnsitDt", headerText : "Date", width : 150       },
              {dataField : "trnsitFrom", headerText : "From", width : 130        },
              {dataField : "trnsitTo", headerText : "To", width : 130        },
              {dataField : "trnsitStusCode", headerText : "Status", width : 150      },
              {dataField : "trnsitCrtUserId", headerText : "By", width : 150     },
              {dataField : "trnsitTotBook", headerText : "Total Book", width : 140       }             
              ];
        

        var recvOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : false,
                   usePaging : true,
                   editable : false,
                   selectionMode : "singleRow"
             }; 
        
        recvGridID = GridCommon.createAUIGrid("#recvGridID", recvColLayout, "", recvOptions);
        
        // 셀 더블클릭 이벤트 바인딩
         AUIGrid.bind(recvGridID, "cellDoubleClick", function(event){
             
              $("#trnsitId").val(AUIGrid.getCellValue(recvGridID , event.rowIndex , "trnsitId"));
             
              Common.popupDiv("/sales/trBookRecv/trBookRecvViewPop.do",$("#listSForm").serializeJSON(), null, true, "trBookRecvViewPop");
              
         });
}

//리스트 조회.
function fn_selectListAjax() {
    
  Common.ajax("GET", "/sales/trBookRecv/selectTrBookRecvList", $("#listSForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(recvGridID, result);

  });
}

function fn_clear(){
    $("#listSForm")[0].reset();
}


function fn_trBookAddSingle(){
    Common.popupDiv("/sales/trBook/trBookRecvViewPop.do",$("#listSForm").serializeJSON(), null, true, "trBookAddSinglePop");
}

</script>
<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>TR Book</li>
	<li>TR Book Management</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>TR Book Management TR Book receive</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#">Update receive</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<form action="#" method="post" id="listSForm" name="listSForm">
<input type="hidden" id="trnsitId" name="trnsitId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Transit No</th>
	<td>
	<input type="text" title="" placeholder="Transit No" class="w100p" id="trnsitNo" name="trnsitNo"/>
	</td>
	<th scope="row">Book No</th>
	<td>
	<input type="text" title="" placeholder="Book No" class="w100p" id="trBookNo" name="trBookNo"/>
	</td>
	<th scope="row">Create Date</th>
	<td>
		<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="trnsitDt" name="trnsitDt"/>
	</td>
</tr>
<tr>
	<th scope="row">Create By</th>
	<td>
	<input type="text" title="" placeholder="Create By" class="w100p" id="crtuserId" name="crtuserId"/>
	</td>
	<th scope="row">Status</th>
	<td>
		<select class="w100p" id="trnsitStusId" name="trnsitStusId">
			<option value="1">Active/Pending</option>
			<option value="36">Closed</option>
		</select>
	</td>
	<td colspan="2"></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn"><a href="#">TR Book Summary</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->
</form>
<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="recvGridID" style="width:100%; height:400px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->