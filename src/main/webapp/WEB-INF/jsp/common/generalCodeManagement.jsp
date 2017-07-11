<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javaScript">

var gSelRowIdx = 0;

$(function(){
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
    
    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo'); 
});

//AUIGrid 칼럼 설정
// 데이터 형태는 다음과 같은 형태임,
//[{codeMasterId=86, codeMasterName=Adjustment Category, codeDesc=Adjustment Category, crtDt=2014-04-22 18:23:19.0, crtUserId=206, userName=JYTAY, disabled=0, updDt=2014-04-22 18:23:19.0, updUserId=206}]
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
	        dataField : "userName",
	        headerText : "CREATOR",
	        width : 200
	    }, {
	        dataField : "crtDt",
	        headerText : "CREATE DATE",
	        width : 200
	    }
    ];

//[{codeId=886, codeMasterId=86, code=ADJ001, codeName=Rental Processing Fees Adjustment, codeDesc=oracle.sql.CLOB@76982a1, crtDt=2014-04-22 18:24:06.0, crtUserId=206, disab=0, updDt=2014-04-22 18:24:06.0, updUserId=206}, 
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
	    }
    ];


function fn_multiCombo(){
    $('#cmbCategory').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택 
        width: '100%'
    });            
}

// ajax list 조회.

function fn_getMstCommCdListAjax() {        
    Common.ajax("GET", "/common/selectMstCodeList.do", $("#MainForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_DetailGetInfo()
{
    Common.ajax("GET", "/common/selectDetailCodeList.do", $("#MainForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(detailGridID, result);
    });
}


// 컬럼 선택시 상세정보 세팅.
function fn_setDetail(selGrdidID, rowIdx)
{     
   $("#mstCdId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "codeMasterId"));
   $("#mstDisabled").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "disabled"));    
  // alert($("#mstCdId").val() + " : " + $("#disab").val() + " : " + AUIGrid.getCellValue(selGrdidID, rowIdx, "codeMasterName") );                
}

var countries = ["Korea", "USA",  "UK", "Japan", "China", "France", "Italy", "Singapore", "Ireland", "Taiwan"];
var products = new Array("IPhone 5S", "Galaxy S5", "IPad Air", "Galaxy Note3", "LG G3", "Nexus 10");
var colors = new Array("Blue", "Gray", "Green", "Orange", "Pink", "Violet", "Yellow", "Red");

var cnt = 0;

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

// 행 추가 이벤트 핸들러
function auiAddRowHandler(event) {
 alert(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
 //document.getElementById("rowInfo").innerHTML = (event.type + " 이벤트 :  " + "삽입된 행 인덱스 : " + event.rowIndex + ", 삽입된 행 개수 : " + event.items.length);
}

// 행 추가, 삽입
function addRow() {
    
    //var rowPos = document.getElementById("addSelect").value;
    alert("addrow!");
    var item = new Object();
/*     item.name = "AUI-" + (++cnt),
    //item.aaa = "aaa",  // 서버에서 VO로 처리시 VO 에 정의 되지 않은 값을 넘긴다면 에러 발생, 맵은 상관없음.
    item.color = colors[cnt % colors.length],
    item.product = products[cnt % products.length],
    item.price = Math.floor(Math.random() * 1000000),
    item.date = "2015/03/05" */

    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(myGridID, item, "first");
}


// 행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {
    alert (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

// 행 삭제
function removeRow() {
    alert("removeRow: " + gSelRowIdx);    
    AUIGrid.removeRow(myGridID,gSelRowIdx);
}


//푸터 설정
var footerObject = [ {
     labelText : "∑",
     positionField : "#base"
 }, {
     dataField : "price",
     positionField : "price",
     operation : "SUM",
     formatString : "#,##0",
     style : "aui-grid-my-footer-sum-total"
 }, {
     dataField : "price",
     positionField : "date",
     operation : "COUNT",
     style : "aui-grid-my-footer-sum-total2"
 }, {
     labelText : "Count=>",
     positionField : "phone",
     style : "aui-grid-my-footer-sum-total2"
 }];  


// AUIGrid 생성 후 반환 ID
var myGridID, detailGridID;

$(document).ready(function(){
    
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", mstColumnLayout,"codeMasterId");
    // AUIGrid 그리드를 생성합니다.
    

	// 푸터 객체 세팅
	AUIGrid.setFooter(myGridID, footerObject);
	
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
    AUIGrid.bind(myGridID, "cellClick", function( event ) {
        console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        gSelRowIdx = event.rowIndex;
       // fn_setDetail(myGridID, event.rowIndex);
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        console.log(" ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + event.value + " double clicked!!");

        fn_setDetail(myGridID, event.rowIndex);
        fn_DetailGetInfo();
    });
    
   // fn_getSampleListAjax();

 

});

</script>

<div id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<div class="title_line"><!-- title_line start -->
<p class="fav"><img src="${pageContext.request.contextPath}/resources/image/icon_star.gif" alt="즐겨찾기" /></p>
<h2>General Code Management</h2>
<ul class="right_opt">
	<li><p class="btn_blue"><a href="#">Save</a></p></li>
</ul>
</div><!-- title_line end -->

<div class="search_table"><!-- search_table start -->

<form id="MainForm" method="get" action="">

<input type ="hidden" id="mstCdId" name="mstCdId" value=""/>
<input type ="hidden" id="mstDisabled" name="mstDisabled" value=""/>

<table summary="search table" class="type1"><!-- table start -->
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
	<td><input type="text" id="cdMstId" name="cdMstId" title="Master ID" placeholder="Master ID" class="w100p" /></td>
	<th scope="row">Name</th>
	<td><input type="text"  id="cdMstNm" name="cdMstNm" title="Name" placeholder="Name" class="w100p" /></td>
	<th scope="row">Description</th>
	<td><input type="text"  id="cdMstDesc" name="cdMstDesc" title="Description" placeholder="Description" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Creator</th>
	<td><input type="text" id="userId" name="userId"  title="Creator" placeholder="Creator Username" class="w100p" /></td>
	<th scope="row">Create Date</th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p><input type="text" id="crtDtFrom" name="crtDtFrom"  title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input type="text" id="crtDtTo" name="crtDtTo"  title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->

	</td>
	<th scope="row">Disabled</th>
	<td><input type="text" id="cdMstDisabled" name="cdMstDisabled" title="Disabled" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
	   <li><p class="btn_gray"><a onclick="fn_getMstCommCdListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</form>
</div><!-- search_table end -->

<div class="search_result"><!-- search_result start -->
<ul class="right_btns">
<!-- 	<li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li> -->
	<li><p class="btn_grid"><a onclick="removeRow();"><span class="search"></span>DEL</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
	<li><p class="btn_grid"><a onclick="addRow();"><span class="search"></span>ADD</a></p></li>
</ul>

<div class="grid_wrap h220"><!-- grid_wrap start -->
	    <!-- masterGrid. -->
    <div id="grid_wrap"></div>
</div><!-- grid_wrap end -->
</div>


<div class="search_result"><!-- search_result start -->
<ul class="right_btns">
<!-- 	<li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li> -->
	<li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>ADD</a></p></li>
</ul>

<div class="grid_wrap h220"><!-- grid_wrap start -->
    <div id="detailGrid"></div>
</div><!-- grid_wrap end -->

</div><!-- search_result end -->

</div><!-- content end -->
	