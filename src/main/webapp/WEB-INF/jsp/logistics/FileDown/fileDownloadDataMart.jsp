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
var dataMartFileGrid1;

var columnLayout1 = [
					{dataField: "orignlfilenm" ,headerText: "<spring:message code='log.head.filename'/>"  ,width: "30%" ,visible:  true },
					{dataField: "updDt"        ,headerText: "<spring:message code='log.head.writetime'/>" ,width: "30%" ,dataType: "date"  ,formatString: "yyyy. mm. dd hh:MM TT" ,visible:true},
					{dataField: "filesize"     ,headerText: "<spring:message code='log.head.filesize'/>"  ,width: "30%" ,postfix:  "bytes" ,dataType:     "numeric"               ,visible:true},
                    {dataField: ""             ,headerText: "" ,
                        renderer: {
                        	type: "ButtonRenderer" ,labelText: "Download" ,onclick: function(rowIndex, columnIndex, value, item){
//                               fileDownload(rowIndex,"BI");
                            }
                        }
                    , editable : false
                    },
                    {dataField: "subpath"      ,headerText: "<spring:message code='log.head.subpath'/>"   ,width:120    ,height:30         ,visible:false},
                    {dataField: "filename"     ,headerText: "<spring:message code='log.head.filename'/>"  ,width:120    ,height:30         ,visible:false},
                    {dataField: "fileEt"       ,headerText: "<spring:message code='log.head.fileet'/>"    ,width:120    ,height:30         ,visible:false}
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
    dataMartFileGrid1 = AUIGrid.create("#grid_wrap1", columnLayout1, gridoptions);
     doGetCombo('/logistics/file/checkDirectoryDataMart.do', '', '','dataMartList', 'S' , ''); //File Type 리스트 조회
});


//btn clickevent
$(function(){
	$("#grid_wrap1").hide();
	var userId = '${SESSION_INFO.userId}' ;
	$('#dataMartList').change(function() {
	var div= $('#dataMartList').val();
	console.log('div : ' + div);

	$("#grid_wrap1").show();
		SearchListAjax1(div);
	});
});


function SearchListAjax1(str) {
    var url = "/logistics/file/dataMartList.do";
    var param = {type :str};
    Common.ajax("GET" , url , param, function(data){
    	console.log(data);
    	AUIGrid.clearGridData(dataMartFileGrid1);
        AUIGrid.setGridData(dataMartFileGrid1, data);
        var sortingInfo = [];
        // 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
        sortingInfo[0] = { dataField : "updDt", sortType : -1 };
        AUIGrid.setSorting(dataMartFileGrid1, sortingInfo);

        AUIGrid.resize(dataMartFileGrid1);
    });
}

function fileDownload(rowIndex,str){
	var subPath;
	var fileName;
	var orignlFileNm;
 	subPath = "/resources/WebShare/DataMart/"+$('#dataMartList').val();
    orignlFileNm = AUIGrid.getCellValue(dataMartFileGrid1,  rowIndex, "orignlfilenm");
    window.open("${pageContext.request.contextPath}"+subPath + "/" + orignlFileNm);
}
</script>

<section id="content">
    <!-- content start -->
    <ul class="path">
        <li>
            <img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/>
        </li>
        <li>File</li>
        <li>Data Mart list</li>
    </ul>
    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>Data Mart File Download</h2>
    </aside>
    <!-- title_line end -->
    <section class="search_table">
        <!-- search_table start -->
        <form action="#" method="post">
            <aside class="title_line">
                <!-- title_line start -->
                <h3>Data Mart File(s)</h3>
            </aside>
            <!-- title_line end -->
            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Data Mart Type</th>
                        <td>
                            <select class="w100p" id="dataMartList" name="dataMartList"></select>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
            <article class="grid_wrap">
                <!-- grid_wrap start -->
                <div id="grid_wrap1" style="width:100%; height:290px; margin:0 auto;"/>
            </article>
            <!-- grid_wrap end -->
        </form>
    </section>
    <!-- search_table end -->
</section>
<!-- content end -->