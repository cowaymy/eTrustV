<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javaScript">

var gSelRowIdx = 0;

$(function()
 {
    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo'); 
 }
);

var mstColumnLayout = 
    [ 
        {    
            dataField : "codeMasterId",
            headerText : "MASTER",
            width : 120,
            style : "aui-grid-user-custom-left"
        }, {
            dataField : "disabled",
            headerText : "DISABLED",
            width : 120
        }, {
            dataField : "codeMasterName",
            headerText : "MASTER NAME",
            width : 200
        }, {
            dataField : "createName",
            headerText : "CREATOR",
            width : 200
        }, {
            dataField : "crtDt",
            headerText : "CREATE DATE",
            width : 200
        }
    ];


var detailColumnLayout = 
    [ 
        {
            dataField : "codeId",
            headerText : "CODE ID",
            width : 120
        }, {
            dataField : "code",
            headerText : "CODE",
            width : 120
        }, {
            dataField : "codeName",
            headerText : "NAME",
            width : 250
        }, {
            dataField : "codeDesc",
            headerText : "DESCRIPTION",
            width : 250
        }, {
            dataField : "disab",
            headerText : "DISABLED",
            width : 200
        }
    ];


function fn_multiCombo()
{
    $('#cmbCategory').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택 
        width: '100%'
    });            
}

//ajax list 조회.

function fn_getMstCommCdListAjax() 
{        
    Common.ajax("GET", "/common/selectMstCodeList.do", $("#MainForm").serialize(), function(result) 
    {
        console.log("성공." + $("#crtDtFrom").val() );
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_DetailGetInfo()
{
   Common.ajax("GET", "/common/selectDetailCodeList.do", $("#MainForm").serialize(), function(result) 
   {
       console.log("성공.");
       console.log("data : " + result);
       AUIGrid.setGridData(detailGridID, result);
   });
}

//컬럼 선택시 상세정보 세팅.
function fn_setDetail(selGrdidID, rowIdx)  //cdMstId
{     
   $("#mstCdId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "codeMasterId"));
   $("#mstDisabled").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "disabled"));    

   console.log("mstCdId: "+ $("#mstCdId").val() + " mstDisabled: " + $("#mstDisabled").val() + " codeMasterName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "codeMasterName") );                
}

function auiCellEditignHandler(event) 
{
    if(event.type == "cellEditBegin") 
    {
        console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    } 
    else if(event.type == "cellEditEnd") 
    {
        console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    } 
    else if(event.type == "cellEditCancel") 
    {
        console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    }
}

//행 추가 이벤트 핸들러
function auiAddRowHandler(event) 
{
 alert(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
}

// 행 추가, 삽입
function addRow() 
{
    alert("addrow!");
    var item = new Object();
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(myGridID, item, "first");
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) 
{
    alert (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

// 행 삭제 메소드
function removeRow() 
{
    alert("removeRow: " + gSelRowIdx);    
    AUIGrid.removeRow(myGridID,gSelRowIdx);
}

//AUIGrid 생성 후 반환 ID
var myGridID, detailGridID;

$(document).ready(function(){
    
    // masterGrid 그리드를 생성합니다.
    myGridID = createAUIGrid(mstColumnLayout,"codeMasterId");
    // AUIGrid 그리드를 생성합니다.
    

    // 푸터 객체 세팅
    //AUIGrid.setFooter(myGridID, footerObject);
    
    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditignHandler);
    
    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditignHandler);
    
    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditignHandler);
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);
 
    // detailGrid 생성
    detailGridID = GridCommon.createAUIGrid("detailGrid", detailColumnLayout,"codeId");
    
    // cellClick event.
    AUIGrid.bind(myGridID, "cellClick", function( event ) 
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        gSelRowIdx = event.rowIndex;
       // fn_setDetail(myGridID, event.rowIndex);
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

        fn_setDetail(myGridID, event.rowIndex);
        fn_DetailGetInfo();
    });
    
   // fn_getSampleListAjax();

});

function createAUIGrid(mstColumnLayout,_sRowIdField) {

    // 그리드 속성 설정
    var gridPros = {
        // 페이지 설정
        usePaging : true,               
        pageRowCount : 30,              
        fixedColumnCount : 1,
        // 편집 가능 여부 (기본값 : false)
        editable : true,                
        // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
        enterKeyColumnBase : true,                
        // 셀 선택모드 (기본값: singleCell)
        selectionMode : "multipleCells",                
        // 컨텍스트 메뉴 사용 여부 (기본값 : false)
        useContextMenu : true,                
        // 필터 사용 여부 (기본값 : false)
        enableFilter : true,            
        // 그룹핑 패널 사용
        useGroupingPanel : false,  
        rowIdField : _sRowIdField,              
        // 상태 칼럼 사용
        showStateColumn : true,                
        // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
        displayTreeOpen : false,                
        noDataMessage : "출력할 데이터가 없습니다.",                
        groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",                
        //selectionMode : "multipleCells",
        //rowIdField : "stkid",
        enableSorting : true

    };

    // 실제로 #grid_wrap 에 그리드 생성
    myGridID = AUIGrid.create("#grid_wrap", mstColumnLayout, gridPros);

}
</script>


<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>General Code Management</h2>
<ul class="right_opt">
	<li><p class="btn_blue"><a href="#">Save</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">

<input type ="hidden" id="mstCdId" name="mstCdId" value=""/>
<input type ="hidden" id="mstDisabled" name="mstDisabled" value=""/>

<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Master ID</th>
	<td><input type="text" title="Master ID" placeholder="Master ID" id="cdMstId" name="cdMstId" class="w100p" /></td>
	<th scope="row">Name</th>
	<td><input type="text" id="cdMstNm" name="cdMstNm" title="Name" placeholder="Name" class="w100p" /></td>
	<th scope="row">Description</th>
	<td><input type="text" id="cdMstDesc" name="cdMstDesc" title="Description" placeholder="Description" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Creator</th> 
	<td><input type="text" id="createID" name="createID" title="Creator" placeholder="Creator Username" class="w100p" /></td>
	<th scope="row">Create Date</th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p><input type="text" id="crtDtFrom" name="crtDtFrom" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>   
	<span>To</span>
	<p><input type="text" id="crtDtTo" name="crtDtTo" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->

	</td>
	<th scope="row">Disabled</th>
	<td>
	<select class="w100p" id="cdMstDisabled" name="cdMstDisabled">
	   <option value="" selected>All</option>
	   <option value="1">Y</option>
	   <option value="0">N</option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<!-- search -->
<ul class="right_btns">
	<li><p class="btn_gray"><a onclick="fn_getMstCommCdListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</form>


</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a onclick="removeRow();"><span class="search"></span>DEL</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
	<li><p class="btn_grid"><a onclick="addRow();"><span class="search"></span>ADD</a></p></li>
</ul>


<article class="grid_wrap" style="height:350px;">
<!-- grid_wrap start -->
<!-- 그리드 영역1 -->
 <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

<form id="dtailForm" method="get" action="">

<input type ="hidden" id="mstCdId" name="mstCdId" value=""/>
<input type ="hidden" id="mstDisabled" name="mstDisabled" value=""/>

<ul class="right_btns">
	<li>
		<span>Disabled</span>
	<select id="dtailDisabled" name="dtailDisabled">
	   <option value="" selected>All</option>
	   <option value="1">Y</option>
	   <option value="1">N</option>
	</select>	
	</li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>SEARCH</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>ADD</a></p></li>
</ul>

</form>
<!--  detail Form -->

<article class="grid_wrap" style="height:350px;"><!-- grid_wrap start -->
<!--  그리드 영역2  -->
  <div id="detailGrid"></div> 
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
