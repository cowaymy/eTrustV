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
					{dataField: "orignlfilenm",headerText :"<spring:message code='log.head.filename'/>" ,width: "30%"   ,visible:true },                
					{dataField: "updDt",headerText :"<spring:message code='log.head.writetime'/>"   ,width: "30%"   , dataType :    "date"    ,formatString :     "yyyy. mm. dd hh:MM TT"    ,visible:true },  
					{dataField: "filesize",headerText :"<spring:message code='log.head.filesize'/>" ,width: "30%"   ,postfix :  "bytes"   ,dataType :    "numeric" ,visible:true},  
                    {
                        dataField : "",
                        headerText : "",
                        renderer : {
                            type : "ButtonRenderer",
                            labelText : "Download",
                            onclick : function(rowIndex, columnIndex, value, item) {
                              fileDown(rowIndex,"PB");
                            }
                        }
                    , editable : false
                    },
                    {dataField: "subpath",headerText :"<spring:message code='log.head.subpath'/>",width:120    ,height:30 , visible:false},                         
                    {dataField: "filename",headerText :"<spring:message code='log.head.filename'/>",width:120    ,height:30 , visible:false},                               
                    {dataField: "fileEt",headerText :"<spring:message code='log.head.fileet'/>",width:120    ,height:30 , visible:false}  
                    ];
                    
var columnLayout2 = [
					{dataField: "orignlfilenm",headerText :"<spring:message code='log.head.filename'/>" ,width: "30%"   ,visible:true },                
					{dataField: "updDt",headerText :"<spring:message code='log.head.writetime'/>"   ,width: "30%"   , dataType :     "date"     ,formatString :     "yyyy. mm. dd hh:MM TT"    ,visible:true },  
					{dataField: "filesize",headerText :"<spring:message code='log.head.filesize'/>" ,width: "30%"   ,postfix :  "bytes"   ,dataType :     "numeric" ,visible:true},  
                    {
                        dataField : "",
                        headerText : "",
                        renderer : {
                            type : "ButtonRenderer",
                            labelText : "Download",
                            onclick : function(rowIndex, columnIndex, value, item) {
                              fileDown(rowIndex,"P&C");
                            }
                        }
                    , editable : false
                    },
                    {dataField: "subpath",headerText :"<spring:message code='log.head.subpath'/>",width:120    ,height:30 , visible:false},                         
                    {dataField: "filename",headerText :"<spring:message code='log.head.filename'/>",width:120    ,height:30 , visible:false},                               
                    {dataField: "fileEt",headerText :"<spring:message code='log.head.fileet'/>",width:120    ,height:30 , visible:false}  
                    ];                    



                                    
var gridoptions = {
        showStateColumn : false , 
        editable : false, 
        pageRowCount : 10, 
        usePaging : true, 
        useGroupingPanel : false,
        noDataMessage :  "<spring:message code='sys.info.grid.noDataMessage' />"
        };
        
        
var paramdata;

$(document).ready(function(){

    rawFileGrid1 = AUIGrid.create("#grid_wrap1", columnLayout1, gridoptions);
    rawFileGrid2 = AUIGrid.create("#grid_wrap2", columnLayout2, gridoptions);
    
    
    doGetCombo('/logistics/file/checkDirectory.do', 'PB', '','spublic', 'S' , ''); //File Type 리스트 조회
    doGetCombo('/logistics/file/checkDirectory.do', 'PR', '','scpublic', 'S' , ''); //File Type 리스트 조회
    
 
});


//btn clickevent
$(function(){
	
	$("#grid_wrap1").hide();
	$("#grid_wrap2").hide();
	
 $('#spublic').change(function() {
	 var div= $('#spublic').val();
	 $("#grid_wrap1").show();
	   SearchListAjax1(div);
 
});
 
 $('#scpublic').change(function() {
	 var div= $('#scpublic').val();
	 $("#grid_wrap2").show();
	 SearchListAjax2(div);
	 
	});
	
   
   
});


function SearchListAjax1(str) {
    var url = "/logistics/file/rawdataList.do";
    var param = {type :"Public/"+str};
    Common.ajax("GET" , url , param , function(data){
    	console.log(data);
    	AUIGrid.clearGridData(rawFileGrid1);
        AUIGrid.setGridData(rawFileGrid1, data);
        var sortingInfo = [];
        // 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
        sortingInfo[0] = { dataField : "updDt", sortType : -1 };
        AUIGrid.setSorting(rawFileGrid1, sortingInfo);
        
    });
}
function SearchListAjax2(str) {
    var url = "/logistics/file/rawdataList.do";
    var param = {type :"Privacy/"+str};
    Common.ajax("GET" , url , param , function(data){
    	console.log(data);
    	AUIGrid.clearGridData(rawFileGrid2);
        AUIGrid.setGridData(rawFileGrid2, data);
        var sortingInfo = [];
        // 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
        sortingInfo[0] = { dataField : "updDt", sortType : -1 };
        AUIGrid.setSorting(rawFileGrid2, sortingInfo);
        
    });
}

function fileDown(rowIndex,str){
	    var subPath;
	    var fileName;
	    var orignlFileNm;
	if("PB"==str){
	    subPath = "/resources/WebShare/RawData/Public/"+$('#spublic').val();
	    orignlFileNm = AUIGrid.getCellValue(rawFileGrid1,  rowIndex, "orignlfilenm");
	}else{
	    subPath = "/resources/WebShare/RawData/Privacy/"+$('#scpublic').val();
	    orignlFileNm = AUIGrid.getCellValue(rawFileGrid2 ,  rowIndex, "orignlfilenm");
	}
	
  window.open("${pageContext.request.contextPath}"+subPath + "/" + orignlFileNm);
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
                alt="Home" /></li>
    <li>File</li>
    <li>RawData list</li>
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

