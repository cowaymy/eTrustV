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
                    {dataField:"orignlfilenm",headerText:"Filename",width:"30%",visible:true },
                    {dataField:"updDt",headerText:"Write Time",width:"30%",visible:true },
                    {dataField:"filesize",headerText:"File Size",width:"30%",postfix : "bytes",dataType : "numeric",visible:true},
                    {
                        dataField : "",
                        headerText : "",
                        renderer : {
                            type : "ButtonRenderer",
                            labelText : "Download",
                            onclick : function(rowIndex, columnIndex, value, item) {
                              // removeRow(rowIndex, gridNm,chkNum);
                              fileDown(rowIndex,"PR");
                            }
                        }
                    , editable : false
                    },
                    {dataField:"subpath"         ,headerText:"subpath"                      ,width:120    ,height:30 , visible:false},
                    {dataField:"filename"         ,headerText:"filename"                      ,width:120    ,height:30 , visible:false},     
                    {dataField:"fileEt"         ,headerText:"fileEt"                      ,width:120    ,height:30 , visible:false}     
                    ];
                    
var columnLayout2 = [
                    {dataField:"orignlfilenm",headerText:"Filename",width:"30%",visible:true },
                    {dataField:"updDt",headerText:"Write Time",width:"30%",visible:true },
                    {dataField:"filesize",headerText:"File Size",width:"30%",postfix : "bytes",dataType : "numeric",visible:true},
                    {
                        dataField : "",
                        headerText : "",
                        renderer : {
                            type : "ButtonRenderer",
                            labelText : "Download",
                            onclick : function(rowIndex, columnIndex, value, item) {
                              // removeRow(rowIndex, gridNm,chkNum);
                              fileDown(rowIndex,"P&C");
                            }
                        }
                    , editable : false
                    },
                    {dataField:"subpath"         ,headerText:"subpath"                      ,width:120    ,height:30 , visible:false},
                    {dataField:"filename"         ,headerText:"filename"                      ,width:120    ,height:30 , visible:false},     
                    {dataField:"fileEt"         ,headerText:"fileEt"                      ,width:120    ,height:30 , visible:false}     
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

	/* 최악의 변환 작업...
	2017-12-04 대상 테이블 확인 받음 PAY0061D(로컬에서 로그 조회가 안됨... 하 그래서 상상코딩함)
	TODO LIST
	1. 셀렉트 박스 조회 조건 확인 및 쿼리 확인 필요 * 현재 확인 불가 상황이라 FILEDOWNLOAD로 세팅해서 그리드 데이터 세팅됨.
	2. 그리드 세팅될 값 확인 필요함. 
	3. 파일 다운로드 경로 달라서 파일 다운 로드 불가 * 서버에 파일도 없음  > 파일 다운 로드 테스트 필요
	*/
    rawFileGrid1 = AUIGrid.create("#grid_wrap1", columnLayout1, gridoptions);
    rawFileGrid2 = AUIGrid.create("#grid_wrap2", columnLayout2, gridoptions);
    
    
    doGetCombo('/common/selectCodeList.do', '70', '','spublic', 'S' , ''); //File Type 리스트 조회
    
    doGetCombo('/common/selectCodeList.do', '70', '','scpublic', 'S' , ''); //File Type 리스트 조회
 
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
    var param = {type :str};
    Common.ajax("GET" , url , param , function(data){
    	console.log(data);
    	AUIGrid.clearGridData(rawFileGrid1);
        AUIGrid.setGridData(rawFileGrid1, data.data);
        
    });
}
function SearchListAjax2(str) {
    var url = "/logistics/file/rawdataList.do";
    var param = {type :str};
    Common.ajax("GET" , url , param , function(data){
    	console.log(data);
    	AUIGrid.clearGridData(rawFileGrid2);
        AUIGrid.setGridData(rawFileGrid2, data.data);
        
    });
}

function fileDown(rowIndex,str){
	    var subPath;
	    var fileName;
	    var orignlFileNm;
	if("PR"==str){
	   // subPath = AUIGrid.getCellValue(rawFileGrid1,  rowIndex, "subpath");
	    subPath = "/RawData/Public/";
	    fileName = AUIGrid.getCellValue(rawFileGrid1,  rowIndex, "filename");
	    //orignlFileNm = AUIGrid.getCellValue(rawFileGrid1,  rowIndex, "fileName")+AUIGrid.getCellValue(rawFileGrid1,  rowIndex, "fileEt");
	    orignlFileNm = AUIGrid.getCellValue(rawFileGrid1,  rowIndex, "orignlfilenm");
	}else{
	    //subPath = AUIGrid.getCellValue(rawFileGrid2 ,  rowIndex, "subpath");
	    subPath = "/RawData/Privacy/";
	    fileName = AUIGrid.getCellValue(rawFileGrid2 ,  rowIndex, "filename");
	    //orignlFileNm = AUIGrid.getCellValue(rawFileGrid2 ,  rowIndex, "fileName")+AUIGrid.getCellValue(rawFileGrid1,  rowIndex, "fileEt");
	    orignlFileNm = AUIGrid.getCellValue(rawFileGrid2 ,  rowIndex, "orignlfilenm");
	}
	
 if(""==fileName || null==fileName ){
     Common.alert("File is not exist.");
     return false;
 }
  window.open("<c:url value='/file/fileDown.do?subPath=" + subPath
          + "&fileName=" + fileName + "&orignlFileNm=" + orignlFileNm
          + "'/>");
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

