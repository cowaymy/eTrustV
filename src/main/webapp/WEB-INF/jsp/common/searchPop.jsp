<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

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
    if (gb != "stocklist"){
	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
	    {
	    	opener.fn_itempop(AUIGrid.getCellValue(myGridID , event.rowIndex , "itemcode") , AUIGrid.getCellValue(myGridID , event.rowIndex , "itemname") , 
	                          AUIGrid.getCellValue(myGridID , event.rowIndex , "cateid") , AUIGrid.getCellValue(myGridID , event.rowIndex , "typeid"));
	        self.close();
	    });
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
    <col style="width:130px" />
    <col style="width:*" />    
    <col style="width:130px" />
    <col style="width:*" />    
</colgroup>
<tbody>
<tr>
    <th scope="row">Search Code</th>
    <td>
    <input type="text" id="scode" name="scode" placeholder="Search Code" class="w100p" />
    </td>
    <th scope="row">Search Name</th>
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

        
