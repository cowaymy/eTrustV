<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right{
    text-align:right;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>

<script type="text/javaScript">
var myGridID;

var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 15, usePaging : true, useGroupingPanel : false };

$(document).ready(function(){
	var surl = "${url.sUrl }";
    var col;
    var gb = "${url.isgubun }";
    console.log("${url}")
    if (gb == "item"){
        col  = itemLayout;
    }else if(gb == "stock"){
        col  = stockLayout;
    }else if(gb == "stocklist"){
    	gridoptions = {showRowCheckColumn : true, selectionMode : "multipleCells", showStateColumn : false , editable : false, pageRowCount : 15, usePaging : true, useGroupingPanel : false };
        col  = stockLayout;
    }else if(gb == "location"){ 
    	$("#srchCdTh").text("Search WH_Code");
    	$("#srchNmTh").text("Search WH_Description");
    	col= locLayout;
    }else{
        gb="item";
        col  = itemLayout;
    }
    $("#gubun").val(gb);
    $("#scode").val("${url.svalue }");
    
    myGridID = GridCommon.createAUIGrid("grid_wrap", col, null, gridoptions);
    
    fn_SearchList(surl);
    //fn_getSampleListAjax();
    
    // 셀 더블클릭 이벤트 바인딩
    if(gb == "location" || gb == "stock" ){
    	AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    	        {
    	       var selectedItems = AUIGrid.getSelectedItems(myGridID);
    	        opener.fn_itempopList(selectedItems);
    	            self.close();
    	        });
        
    } else {
    	if (gb != "stocklist"){
	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
	    {
	    	
	    	opener.fn_itempop(AUIGrid.getCellValue(myGridID , event.rowIndex , "itemcode") , AUIGrid.getCellValue(myGridID , event.rowIndex , "itemname") , 
	                          AUIGrid.getCellValue(myGridID , event.rowIndex , "cateid") , AUIGrid.getCellValue(myGridID , event.rowIndex , "typeid"));
	    	self.close();
	    });
	    	}
    }
});

$(function(){
	$('#search').click(function() {
        fn_SearchList("${url.sUrl }");
    });
    $('#transfer').click(function(){
    	var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    	opener.fn_itempopList(selectedItems);
    })
});

//AUIGrid 칼럼 설정
// 데이터 형태는 다음과 같은 형태임,
//[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
var itemLayout = [ { dataField : "itemid",     headerText : "itemid",      width : 120, visible:false }, 
                     { dataField : "itemcode",   headerText : "Code",        width : 200, visible:true  },
                     { dataField : "itemname",   headerText : "Name",        width : 200, visible:true  },
                     { dataField : "description",headerText : "Description", width : 250, visible:true  },
                     { dataField : "cateid",     headerText : "Category", width : 250, visible:false  },
                     { dataField : "catename",   headerText : "Category", width : 250, visible:true  }];
                     
var stockLayout = [ { dataField : "itemid",     headerText : "itemid",      width : 120, visible:false }, 
                   { dataField : "itemcode",   headerText : "Code",        width : 200, visible:true  },
                   { dataField : "itemname",   headerText : "Name",        width : 200, visible:true  },
                   { dataField : "catename",headerText : "Category", width : 120, visible:true  },
                   { dataField : "typename",headerText : "Type", width : 120, visible:true  },
                   { dataField : "cateid",headerText : "Category", width : 120, visible:false  },
                   { dataField : "typeid",headerText : "Type", width : 120, visible:false  }];     

var locLayout = [
	                     {dataField:"locid"      ,headerText:"WH_Id"          ,width:120  ,height:30 , visible:false},
		                 {dataField:"loccd"      ,headerText:"WH_Code"        ,width:"15%" ,height:30 , visible:true},
		                 {dataField:"locdesc"    ,headerText:"WH_Description" ,width:"45%" ,height:30 , visible:true,style :"aui-grid-user-custom-left"},
		                 {dataField:"locgb"      ,headerText:"locgb"          ,width:120 ,height:30 , visible:false},
		                 {dataField:"locaddr2"   ,headerText:"locaddr2"       ,width:140 ,height:30 , visible:false},
		                 {dataField:"locaddr3"   ,headerText:"locaddr3"       ,width:120 ,height:30 , visible:false},
		                 {dataField:"locarea"    ,headerText:"locarea"        ,width:120 ,height:30 , visible:false},
		                 {dataField:"locpost"    ,headerText:"locpost"        ,width:120 ,height:30 , visible:false},
		                 {dataField:"locstat"    ,headerText:"locstat"        ,width:120 ,height:30 , visible:false},
		                 {dataField:"loccnty"    ,headerText:"loccnty"        ,width:90  ,height:30 , visible:false},
		                 {dataField:"loctel1"    ,headerText:"loctel1"        ,width:90  ,height:30 , visible:false},
		                 {dataField:"loctel2"    ,headerText:"loctel2"        ,width:120 ,height:30 , visible:false},
		                 {dataField:"locBranch"  ,headerText:"loc_branch"     ,width:100 ,height:30 , visible:false},
		                 {dataField:"loctype"    ,headerText:"loctype"        ,width:100 ,height:30 , visible:false},
		                 {dataField:"locgrad"    ,headerText:"locgrad"        ,width:100 ,height:30 , visible:false},
		                 {dataField:"locuserid"  ,headerText:"locuserid"      ,width:100 ,height:30 , visible:false},
		                 {dataField:"locupddt"   ,headerText:"locupddt"       ,width:100 ,height:30 , visible:false},
		                 {dataField:"code2"      ,headerText:"code2"          ,width:100 ,height:30 , visible:false},
		                 {dataField:"desc2"      ,headerText:"desc2"          ,width:100 ,height:30 , visible:false},
		                 {dataField:"areanm"     ,headerText:"areanm"         ,width:100 ,height:30 , visible:false},
		                 {dataField:"postcd"     ,headerText:"postcd"         ,width:100 ,height:30 , visible:false},
		                 {dataField:"code"       ,headerText:"code"           ,width:100 ,height:30 , visible:false},
		                 {dataField:"name"       ,headerText:"name"           ,width:100 ,height:30 , visible:false},
		                 {dataField:"countrynm"  ,headerText:"countrynm"      ,width:100 ,height:30 , visible:false},
		                 {dataField:"branchcd"   ,headerText:"branchcd"       ,width:100 ,height:30 , visible:false},
		                 {dataField:"branchnm"   ,headerText:"Branch"         ,width:"15%" ,height:30 , visible:true,style :"aui-grid-user-custom-left"},
		                 {dataField:"dcode"      ,headerText:"dcode"          ,width:100 ,height:30 , visible:false},
		                 {dataField:"descr"      ,headerText:"descr"          ,width:100 ,height:30 , visible:false},
		                 {dataField:"codenm"     ,headerText:"Type"           ,width:"15%" ,height:30 , visible:true},
		                 {dataField:"statnm"     ,headerText:"Status"         ,width:"10%" ,height:30 , visible:true},
		                 {dataField:"locstus"    ,headerText:"locstus"        ,width:100 ,height:30 , visible:false},
		                 {dataField:"user_name"  ,headerText:"nser_name"      ,width:100 ,height:30 , visible:false}
	                 ]; 


function fn_SearchList(url) {
   // f_showModal();
    var param = $('#searchForm').serializeJSON();
    
    Common.ajax("POST" , url , param , function(data){
    	console.log(data.data);
    	AUIGrid.setGridData(myGridID, data.data);
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Training</li>
    <li>Course</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2>Search Help</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="transfer"><span class="search"></span>transfer</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" method="post">
<input type="hidden" id="gubun" name="gubun"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />    
    <col style="width:140px" />
    <col style="width:*" />    
</colgroup>
<tbody>
<tr>
    <th scope="row" id="srchCdTh">Search Code</th>
    <td>
    <input type="text" id="scode" name="scode" placeholder="Search Code" class="w100p" />
    </td>
    <th scope="row" id="srchNmTh">Search Name</th>
    <td>
    <input type="text" id="sname" name="sname" placeholder="Search Name" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->


<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

        
