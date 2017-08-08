<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">
var gSelMainRowIdx = 0;

var MainColumnLayout = 
    [      
        {    
            dataField : "div",
            headerText : "Div",
            width : 80
        }, {
            dataField : "menuLvl",
            headerText : "Lvl",
            width : 50
        }, {
            dataField : "menuCode",
            headerText : "MenuId",
            width : 200
        }, {
            dataField : "menuName",
            headerText : "MenuNm",
            width : 250
        }, {
            dataField : "pgmCode",
            headerText : "ProgramId",
            width : 100,
            style : "aui-grid-left-column",
            renderer : {
                type : "IconRenderer",
                iconWidth : 13, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                iconHeight : 13,
                iconPosition : "aisleRight",
                iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                  "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.gif" // 
                },
                onclick : function(rowIndex, columnIndex, value, item) {
                    console.log("onclick: ( " + rowIndex + ", " + columnIndex + " ) " + item.pgmCode + " POPUP 클릭");
                    //setPopAcctSrchList(rowIndex);
                   gSelMainRowIdx = rowIndex;
                	fnSearchProgramPopUp(); 
                  }
            }
            
        }, {
            dataField : "pgmName",
            headerText : "ProgramNm",
            width : 250
        }, {
            dataField : "menuOrder",
            headerText : "Order",
            width : 100
        }, {
            dataField : "upperMenuCode",
            headerText : "UpperMenu",
            width : 100
        }, {
            dataField : "statusCode",
            headerText : "Status",
            width : 100
        }
    ];


//AUIGrid 메소드
//컬럼 선택시 상세정보 세팅.
function fnSetCategoryCd(selGrdidID, rowIdx)  
{     
 $("#selCategoryId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryId"));
 
 $("#paramCategoryId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryId"));
 
 console.log("selCategoryId: "+ $("#selCategoryId").val() + "paramCategoryId: "+ $("#paramCategoryId").val() + " stusCtgryName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryName") );                
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
console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
}

//MstGrid 행 추가, 삽입
function addRowMenu() 
{
  var item = new Object();
  
  item.div      ="";
  item.menuLvl  ="";
  item.menuCode ="";
  item.menuName ="";  
  item.pgmCode  ="";
  item.pgmName  ="";
  item.menuOrder ="";
  item.upperMenuCode ="";
  item.statusCode    ="";
  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
  AUIGrid.addRow(myGridID, item, "first");
}

function addRowStatusCode() 
{
var item = new Object();
item.checkFlag   = 0;
item.stusCodeId  ="";
item.codeName    ="";
item.code        ="-";
  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
  AUIGrid.addRow(statusCodeGridID, item, "first");
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) 
{
  console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
  //$("#delCancel").show();
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event) 
{
  console.log (event.type + " 이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

//행 삭제 메소드
function removeRow() 
{
  console.log("removeRowMst: " + gSelMainRowIdx);    
  AUIGrid.removeRow(myGridID,"selectedIndex");
}

//Make Use_yn ComboList, tooltip
function getDisibledComboList()
{     
var list =  ["N", "Y"];   
return list;
}

function fnGetCategoryCd(myGridID, rowIndex)
{
  fnSetCategoryCd(myGridID, rowIndex);
  fnSelectCategoryCdInfo();
}

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) 
{
  // checkFlag 칼럼 클릭 한 경우
  if(event.dataField == "checkFlag") 
  {
    if(event.orgEvent.target.id == "allCheckbox") 
    { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
      var  isChecked = document.getElementById("allCheckbox").checked;
      checkAll(isChecked);
    }
    return false;
  }
}

//전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) 
{
  var rowCount = AUIGrid.getRowCount(statusCodeGridID);
  
  if(isChecked)   // checked == true == 1
  {
    for(var i=0; i<rowCount; i++) 
    {
       AUIGrid.updateRow(statusCodeGridID, { "checkFlag" : 1 }, i);
    }
  } 
  else   // unchecked == false == 0
  {
    for(var i=0; i<rowCount; i++) 
    {
       AUIGrid.updateRow(statusCodeGridID, { "checkFlag" : 0 }, i);
    }
  }
  
  // 헤더 체크 박스 일치시킴.
  document.getElementById("allCheckbox").checked = isChecked;
  
  getItemsByCheckedField(statusCodeGridID);

}

function getItemsByCheckedField(selectedGrid) 
{
  // 체크된 item 반환
  var activeItems = AUIGrid.getItemsByValue(selectedGrid, "checkFlag", true);
  var checkedRowItem = [];
  var str = "";
  
  for(var i=0, len = activeItems.length; i<len; i++) 
  {
      checkedRowItem = activeItems[i];
      str += "chkRowIdx : " + checkedRowItem.rowIndex + ", chkId :" + checkedRowItem.stusCodeId + ", chkName : " + checkedRowItem.codeName  + "\n";
  }
}

function fnSearchProgramPopUp() 
{
 	    var popUpObj = Common.popupDiv("/common/searchProgramPop.do"
          , $("#MainForm").serializeJSON()
          , null
          , "true"  // true면 close버튼 클릭시 화면 close
          );
        
}

function fnSelectMenuListAjax()
{
   Common.ajax("GET", "/common/selectMenuList.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(myGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetPgmIdParamSet(myGridID, 0);
              }
           });
}

function fnSavePgmId() 
{
  Common.ajax("POST", "/common/saveMenuId.do"
        , GridCommon.getEditData(myGridID)
        , function(result) 
         {
            alert(result.data + " Count Save Success!");
            fnSelectMenuListAjax() ;
            
            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
         } 
       , function(jqXHR, textStatus, errorThrown) 
        {
          try 
          {
            console.log("Fail Status : " + jqXHR.status);
            console.log("code : "        + jqXHR.responseJSON.code);
            console.log("message : "     + jqXHR.responseJSON.message);
            console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
          } 
          catch (e) 
          {
            console.log(e);
          }
          alert("Fail : " + jqXHR.responseJSON.message);
        }); 
}

//삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
function removeAllCancel() 
{
  $("#delCancel").hide();
  
  AUIGrid.restoreSoftRows(myGridID, "all"); 
}

var myGridID, transGridID, statusCodeGridID;

$(document).ready(function()
{
    $("#programId").focus();
    
    $("#programId").keydown(function(key) 
        {
          if (key.keyCode == 13) 
          {
            fnSelectMenuListAjax();
          }

        });

/***************************************************[ Main GRID] ***************************************************/    

    var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  selectionMode : "multipleRows",
                  // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
                  rowSelectionWithMerge : true,
                  editable : true,
                  // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
                  enableRestore : true,
                };
    
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", MainColumnLayout,"", options);
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


    // cellClick event.
    AUIGrid.bind(myGridID, "cellClick", function( event ) 
    {
        gSelMainRowIdx = event.rowIndex;
        
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedCategoryId: " + $("#selCategoryId").val() +" / "+ $("#paramCategoryId").val());        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

        //fnGetCategoryCd(myGridID, event.rowIndex);
    });    


    $("#delCancel").hide();
    

});   //$(document).ready


</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Menu Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSelectMenuListAjax();"><span class="search"></span>Search</a></p></li>
<!-- 	<li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Menu</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p" />
	</td>
	<th scope="row">Program</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><%-- <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a> --%></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn"><a href="#">menu1</a></p></li>
		<li><p class="link_btn"><a href="#">menu2</a></p></li>
		<li><p class="link_btn"><a href="#">menu3</a></p></li>
		<li><p class="link_btn"><a href="#">menu4</a></p></li>
		<li><p class="link_btn"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn"><a href="#">menu6</a></p></li>
		<li><p class="link_btn"><a href="#">menu7</a></p></li>
		<li><p class="link_btn"><a href="#">menu8</a></p></li>
	</ul>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="#">menu1</a></p></li>
		<li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu3</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu4</a></p></li>
		<li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu6</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu7</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu8</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Menu Management</h3>
<ul class="right_opt">
  <li id="delCancel"><p class="btn_grid"><a onclick="removeAllCancel();">Cancel</a></p></li>
	<li><p class="btn_grid"><a onclick="removeRow();">DEL</a></p></li>
	<li><p class="btn_grid"><a onclick="addRowMenu();">ADD</a></p></li>
	<li><p class="btn_grid"><a onclick="fnSavePgmId();">SAVE</a></p></li>
</ul>

</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
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
</body>
</html>