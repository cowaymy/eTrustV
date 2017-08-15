<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var gSelRowIdx = 0;

var mstColumnLayout = 
    [ 
        {    
            dataField : "codeMasterId",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='MASTER ID' htmlEscape='false'/>",
            width : 120
        }, {
            dataField : "codeMasterName",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='MASTER NAME' htmlEscape='false'/>",
            width : 200
        }, {
            dataField : "codeDesc",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='CODE DESCRIPTION' htmlEscape='false'/>",
            width : 200
        }, {
            dataField : "createName",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='CREATOR' htmlEscape='false'/>",
            width : 200
        }, {
            dataField : "crtDt",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='CREATE DATE' htmlEscape='false'/>",
            dataType : "date",
            formatString : "dd-mmm-yyyy HH:MM:ss",
            width : 200
        }, {
            dataField : "disabled",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='DISABLED' htmlEscape='false'/>",
            width : 120,
            editRenderer : {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                listFunction : function(rowIndex, columnIndex, item, dataField) {
                   var list = getDisibledComboList();
                   return list;                 
                },
                keyField : "id"
            }
        }
    ];

var detailColumnLayout = 
    [ 
        {
            dataField : "detailcodeid",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='CODE ID' htmlEscape='false'/>",
            width : 120
        }, {
            dataField : "detailcode",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='CODE' htmlEscape='false'/>",
            width : 120
        }, {
            dataField : "detailcodename",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='NAME' htmlEscape='false'/>",
            width : 250
        }, {
            dataField : "detailcodedesc",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='DESCRIPTION' htmlEscape='false'/>",
            width : 250
        }, {
            dataField : "detaildisabled",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='DISABLED' htmlEscape='false'/>",
            width : 200,
            editRenderer : 
            {
               type : "ComboBoxRenderer",
               showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
               listFunction : function(rowIndex, columnIndex, item, dataField) {
                  var list = getDisibledComboList();
                  return list;                 
               },
               keyField : "id"
            }
        }, {
            dataField : "codeMasterId",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='CODE MASTER ID' htmlEscape='false'/>",
            width : 200,
            editable : false
        }

    ];


//ajax list 조회.

function fn_getMstCommCdListAjax() 
{        
  Common.ajax("GET", "/general/selectMstCodeList.do"
  	   , $("#MainForm").serialize()
  	   , function(result) 
	     {
	        console.log("성공." + $("#crtDtFrom").val() );
	        console.log("data : " + result);
	        AUIGrid.setGridData(myGridID, result);
	        AUIGrid.clearGridData(detailGridID);
	        
	        if(result != null && result.length > 0)
		      {
	        	fn_getDetailCode(myGridID, 0);
	        }
	     });
}

function fn_DetailGetInfo()
{
   Common.ajax("GET", "/general/selectDetailCodeList.do"
		    , $("#MainForm").serialize()
		    , function(result) 
			   {
			       console.log("성공.");
			       console.log("data : " + result);
			       AUIGrid.setGridData(detailGridID, result);
			   });
}

// 마스터저장 서버 전송.
function fnSaveGridMap() 
{
  Common.ajax("POST", "/general/saveGeneralCode.do"
		    , GridCommon.getEditData(myGridID)
		    , function(result) 
		     {
		        alert(result.data + " Count Save Success!");
		        fn_getMstCommCdListAjax() ;
		        
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

// 상세데이타 서버로 전송.
function fnSaveDetailGridMap() 
{
  Common.ajax("POST", "/general/saveDetailCommCode.do"
	     , GridCommon.getEditData(detailGridID), function(result) 
	       {
          alert("Success!");      
          fn_getMstCommCdListAjax() ;     
          console.log("성공.");
          console.log("data : " + result);
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
  console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
}

// MstGrid 행 추가, 삽입
function addRow() 
{
  var item = new Object();

    item.codeMasterId  ="";
    item.disabled      ="N";
    item.codeMasterName =""  ;
    item.codeDesc       ="";  
    item.createName     ="";
    item.crtDt          ="";
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(myGridID, item, "first");
}

function addRowDetail() 
{
  var item = new Object();

    item.detailcodeid    ="";
    item.detailcode      ="";
    item.detailcodename  ="";
    item.detailcodedesc  ="";
    item.detaildisabled  ="N";  
    item.codeMasterId    = $("#mstCdId").val(); 
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(detailGridID, item, "first");
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) 
{
    console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event) 
{
    console.log (event.type + " 이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

// 행 삭제 메소드
function removeRow() 
{
    console.log("removeRowMst: " + gSelRowIdx);    
    AUIGrid.removeRow(myGridID,gSelRowIdx);
}

//Make Use_yn ComboList, tooltip
function getDisibledComboList()
{     
  var list =  ["N", "Y"];   
  return list;
}

function fn_getDetailCode(myGridID, rowIndex)
{
    fn_setDetail(myGridID, rowIndex);
    fn_DetailGetInfo();
}

//AUIGrid 생성 후 반환 ID
var myGridID, detailGridID;

$(document).ready(function()
{
  
	$("#cdMstId").focus();
	  
  $("#cdMstId").keydown(function(key) 
  {
    if (key.keyCode == 13) 
    {
    	fn_getMstCommCdListAjax();
    }
	});
	
	var options = {
								  usePaging : true,
								  useGroupingPanel : false
								};
    
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", mstColumnLayout,"codeMasterId", options);
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
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        gSelRowIdx = event.rowIndex;
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

        if (AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) == true
        	  || String(event.value).length < 1)
		    {
		            alert("CodeMasterID Confirm!!");
		            return false;
		    } 

        $("#mstCdId").val( event.value);
        
        fn_getDetailCode(myGridID, event.rowIndex);
    });    

/***********************************************[ DETAIL GRID] ************************************************/

    var dtailOptions = 
        {
            usePaging : true,
            useGroupingPanel : false
        };
 
    // detailGrid 생성
    detailGridID = GridCommon.createAUIGrid("detailGrid", detailColumnLayout,"detailcodeid", dtailOptions);

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(detailGridID, "cellEditBegin", auiCellEditignHandler);
    
    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(detailGridID, "cellEditEnd", auiCellEditignHandler);
    
    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(detailGridID, "cellEditCancel", auiCellEditignHandler);
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(detailGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(detailGridID, "removeRow", auiRemoveRowHandlerDetail);
    
    // cellClick event.
    AUIGrid.bind(detailGridID, "cellClick", function( event ) 
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        gSelRowIdx = event.rowIndex;
    });

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
<h2>General Code Management</h2>
<ul class="right_btns">
  <li><p class="btn_blue"><a onclick="fn_getMstCommCdListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="MainForm" method="get" action="">
<section class="search_table"><!-- search_table start -->

<input type ="hidden" id="mstCdId" name="mstCdId" value=""/>
<input type ="hidden" id="mstDisabled" name="mstDisabled" value=""/>
<input type ="hidden" id="tableGbn" name="tableGbn" value=""/>

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

<!-- MstSearch -->

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a onclick="addRow();"><span class="search"></span>ADD</a></p></li>
	<li><p class="btn_grid"><a onclick="fnSaveGridMap();">Save</a></p></li>
</ul>

<article class="grid_wrap">
<!-- grid_wrap start -->
<!-- 그리드 영역1 -->
 <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

<ul class="right_btns">
	<li>
		<span>Disabled</span>
	<select id="dtailDisabled" name="dtailDisabled">
	   <option value="" selected>All</option>
	   <option value="1">Y</option>
	   <option value="0">N</option>
	</select>	
	</li>
	<li><p class="btn_grid"><a onclick="fn_DetailGetInfo();"><span class="search"></span>FILTER</a></p></li>
	<li><p class="btn_grid"><a onclick="addRowDetail();"><span class="search"></span>ADD</a></p></li>   
	<li><p class="btn_grid"><a onclick="fnSaveDetailGridMap();">Save</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!--  그리드 영역2  -->
  <div id="detailGrid"></div> 
</article><!-- grid_wrap end -->


</section><!-- search_result end -->
</form>
<!--  detail Form -->

</section><!-- content end -->
