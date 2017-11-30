<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var rawFileGrid1;
var rawFileGrid2;
                      
var columnLayout1 = [
                    {dataField:"",headerText:"Filename",width:"30%",visible:true },
                    {dataField:"",headerText:"Write Time",width:"30%",visible:true },
                    {dataField:"",headerText:"File Size",width:"30%",visible:true},
                    {dataField:"",headerText:"",width:"10%",visible:true },       
                    ];
                    
var columnLayout2 = [
                    {dataField:"",headerText:"Filename",width:"30%",visible:true },
                    {dataField:"",headerText:"Write Time",width:"30%",visible:true },
                    {dataField:"",headerText:"File Size",width:"30%",visible:true},
                    {dataField:"",headerText:"",width:"10%",visible:true },       
                    ];                    



                                    
//var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {
        showStateColumn : false , 
        editable : false, 
        pageRowCount : 30, 
        usePaging : true, 
        useGroupingPanel : false,
        };
        
        
var paramdata;

$(document).ready(function(){

    rawFileGrid1 = AUIGrid.create("#grid_wrap1", columnLayout1, gridoptions);
    rawFileGrid2 = AUIGrid.create("#grid_wrap2", columnLayout2, gridoptions);
    
 
});


//btn clickevent
$(function(){
	
	$("#grid_wrap1").hide();
	$("#grid_wrap2").hide();
	
 $('#spublic').change(function() {
	 var div="P"
     alert("윗줄 서치!!!!!");
	 $("#grid_wrap1").show();
	  //SearchListAjax(div);
 
});
 
 $('#scpublic').change(function() {
	 var div="C"
	 alert("아랫줄 서치!!!!!");
	 $("#grid_wrap2").show();
	 //SearchListAjax(div);
	 
	});
	
   
   
});


function SearchListAjax() {
    var url = "/logistics/file/fileDownloadList.do";
    var param = $('#searchForm').serialize();
    Common.ajax("GET" , url , param , function(data){
    	console.log(data);
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}



</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2> File Download</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<aside class="title_line"><!-- title_line start -->
<h3>Public Raw File(s)</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Raw Type</th>
    <td>
    <select class="w100p" id="spublic" name="spublic">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap1"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>P&C Raw File(s)</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Raw Type</th>
    <td>
    <select class="w100p" id="scpublic" name="scpublic">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap2"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->

