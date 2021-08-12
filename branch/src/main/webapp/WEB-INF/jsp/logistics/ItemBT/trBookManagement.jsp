<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var myGridID;


var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "36","codeName": "Close"},{"codeId": "67","codeName": "Lost"}];
var columnLayout = [
					{dataField: "boxId",headerText :"<spring:message code='log.head.boxid'/>"   ,width:100,visible:false,style :    "aui-grid-user-custom-left"  },                 
					{dataField: "boxNo",headerText :"<spring:message code='log.head.boxno'/>"   ,width:100,visible:false ,style :   "aui-grid-user-custom-left" },                  
					{dataField: "trBookNo",headerText :"<spring:message code='log.head.bookno'/>"   ,width:195 ,style : "aui-grid-user-custom-left" },                  
					{dataField: "trBookPrefix",headerText :"<spring:message code='log.head.prefix'/>"   ,width:195 ,style : "aui-grid-user-custom-left" },                  
					{dataField: "trBookCrtDt",headerText :"<spring:message code='log.head.trbookcrtdt'/>"   ,width:100,visible:false  ,style :  "aui-grid-user-custom-left" },                  
					{dataField: "trBookCrtUserId",headerText :"<spring:message code='log.head.trbookcrtuserid'/>"   ,width:100,visible:false  ,style :  "aui-grid-user-custom-left" },                  
					{dataField: "trBookCrtUserName",headerText :"<spring:message code='log.head.trbookcrtusername'/>"   ,width:100,visible:false ,style :   "aui-grid-user-custom-left" },                  
					{dataField: "trBookId",headerText :"<spring:message code='log.head.trbookid'/>" ,width:100,visible:false  ,style :  "aui-grid-user-custom-left" },                  
					{dataField: "trBookNoStart",headerText :"<spring:message code='log.head.from'/>"    ,width:195,style :  "aui-grid-user-custom-left"  },                 
					{dataField: "trBookNoEnd",headerText :"<spring:message code='log.head.to'/>"    ,width:195,style :  "aui-grid-user-custom-left"  },                 
					{dataField: "trBookPge",headerText :"<spring:message code='log.head.totalsheet(s)'/>"   ,width:195 ,style : "aui-grid-user-custom-left" },                  
					{dataField: "trBookStusId",headerText :"<spring:message code='log.head.trbookstusid'/>" ,width:100,visible:false  ,style :  "aui-grid-user-custom-left" },                  
					{dataField: "trBookStusCode",headerText :"<spring:message code='log.head.status'/>" ,width:195 ,style : "aui-grid-user-custom-left"  },                 
					{dataField: "trHolder",headerText :"<spring:message code='log.head.holder'/>"   ,width:195 ,style : "aui-grid-user-custom-left" },                  
					{dataField: "trHolderType",headerText :"<spring:message code='log.head.holdertype'/>"   ,width:195 ,style : "aui-grid-user-custom-left" } 
                    ];
// 그리드 속성 설정
var gridPros = {
    // 페이지 설정
    usePaging : true,               
    pageRowCount : 10,              
    //fixedColumnCount : 1,
    // 편집 가능 여부 (기본값 : false)
    editable : false,                
    // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
    enterKeyColumnBase : true,                
    // 셀 선택모드 (기본값: singleCell)
    //selectionMode : "multipleCells",                
    // 컨텍스트 메뉴 사용 여부 (기본값 : false)
    useContextMenu : true,                
    // 필터 사용 여부 (기본값 : false)
    enableFilter : true,            
    // 그룹핑 패널 사용
    //useGroupingPanel : true,                
    // 상태 칼럼 사용
    showStateColumn : true,                
    // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
    displayTreeOpen : true,                
    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",                
    groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",                
    //selectionMode : "multipleCells",
    //rowIdField : "stkid",
    enableSorting : true,
    //showRowCheckColumn : true,

};

$(document).ready(function(){
	doDefCombo(comboData, '' ,'ddlBookStatus', 'M', 'f_multiCombo');
	$("#ddlBookStatus option:eq(0)").prop("selected", true);
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridPros);
	
	$(function(){
		$("#search").click(function(){
			searchAjax();
		});
		
	});
})
   function searchAjax() {
        //f_showModal();
        var url = "/logistic/TRBook/searchTRBookManagement.do";
        var param = $('#searchForm').serializeJSON();
        Common.ajax("POST" , url , param , function(data){
            
           
            AUIGrid.setGridData(myGridID, data.dataList);
           // hideModal();
        });
    }                    
             

//멀티 셀렉트 세팅 함수들    
function f_multiCombo() {
    
    $(function() {
        $('#ddlBookStatus').change(function() {

        }).multipleSelect({
            selectAll : true, // 전체선택 
            width : '80%'
        });       
    });
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>MISC</li>
    <li>TR Book</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>TR Book Management</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"  id="search"><span class="search"></span>Search</a></p></li>
<!--     <li><p class="btn_blue"><a href="#"  id="clear"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Book No</th>
    <td>
    <input type="text" title="" placeholder="Book No" class="w100p" id="txtTRBookNo" name="txtTRBookNo" />
    </td>
    <th scope="row">TR No</th>
    <td>
    <input type="text" title="" placeholder="TR No" class="w100p"  id="txtTRNo" name="txtTRNo" />
    </td>
    <th scope="row">Create Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"   id="dpCreateDate" name="dpCreateDate" />
    </td>
</tr>
<tr>
    <th scope="row">Create By</th>
    <td>
    <input type="text" title="" placeholder="Create By" class="w100p"   id="txtCreateBy" name="txtCreateBy" />
    </td>
    <th scope="row">Book Holder</th>
    <td>
    <input type="text" title="" placeholder="Book Holder" class="w100p"   id="txtTRBookHolder" name="txtTRBookHolder" />
    </td>
    <th scope="row">Holder Type</th>
    <td>
    <select class="w100p"  id="ddlHolderType" name="ddlHolderType" >
        <option value="Branch">Branch</option>
        <option value="Member">Member</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" multiple="multiple" id="ddlBookStatus" name="ddlBookStatus[]">
    </select>
    </td>
    <td colspan="4"></td>
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

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
        
</section><!-- container end -->
<hr />

</div><!-- wrap end -->
