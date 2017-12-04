<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align:right;
    margin-top:-20px;
}

</style>

<script type="text/javaScript">

var gSelRowIdx = 0;

var mstColumnLayout = 
    [ 
        {    
            dataField : "codeMasterId",
            headerText : "<spring:message code='sys.generalCode.grid1.MASTER_ID' />",
            width : "8%",
        }, {
            dataField : "codeMasterName", 
            headerText : "<spring:message code='sys.generalCode.grid1.MASTER_NAME' />",
            style : "aui-grid-left-column",
            width : "25%",
        }, {
            dataField : "codeDesc",
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_DESCRIPTION' />",
            style : "aui-grid-left-column",
            width : "30%",
        }, {
            dataField : "createName",
            headerText : "<spring:message code='sys.generalCode.grid1.CREATOR' />",
            style : "aui-grid-left-column",
            width : "13%",
        }, {
            dataField : "crtDt",
            headerText : "<spring:message code='sys.generalCode.grid1.CREATE_DATE' />",
            dataType : "date",
            formatString : "dd-mmm-yyyy HH:MM:ss",
            width : "15%",
        }, {
            dataField : "disabled",
            headerText : "<spring:message code='sys.generalCode.grid1.DISABLED' />",
            width : "9%",
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
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_ID' />",
            width : "8%"
        }, {
            dataField : "detailcode",
            headerText : "<spring:message code='sys.account.grid1.CODE' />",
            width : "11%"
        }, {
            dataField : "detailcodename",
            headerText : "<spring:message code='sys.generalCode.grid1.NAME'/>",
            style : "aui-grid-left-column",
            width : "28%"
        }, {
            dataField : "detailcodedesc",
            headerText : "<spring:message code='sys.account.grid1.DESCRIPTION'/>",
            style : "aui-grid-left-column",
            width : "28%"
        }, {
            dataField : "detaildisabled",
            headerText : "<spring:message code='sys.generalCode.grid1.DISABLED'/>",
            width : "10%",
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
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_MASTER_ID'/>",
            width : "15%",
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
	        	//fn_getDetailCode(myGridID, 0);
	        	//fn_setDetail(myGridID, 0);
	        	fn_DetailGetInfo();
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

function fnValidationDetailCheck()
{
    var result = true;
    var addList = AUIGrid.getAddedRowItems(detailGridID);
    var udtList = AUIGrid.getEditedRowItems(detailGridID);
    var delList = AUIGrid.getRemovedItems(detailGridID);
        
    if (addList.length == 0  && udtList.length == 0 && delList.length == 0) 
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++) 
    {
      var detailcode      = addList[i].detailcode;
      var codeMasterId    = addList[i].codeMasterId;
      var detailcodename  = addList[i].detailcodename;
      
      if (detailcode == "" || detailcode.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail Code' htmlEscape='false'/>");
        break;
      }
      
      if (codeMasterId == "" || codeMasterId.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail Code Master' htmlEscape='false'/>");
        break;
      }
      
      if (detailcodename == "" || detailcodename.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail CodeName' htmlEscape='false'/>");
        break;
      }
    }

    for (var i = 0; i < udtList.length; i++) 
    {
      var codeMasterId  = udtList[i].codeMasterId;
      var detailcode    = udtList[i].detailcode;
      
      if (codeMasterId == "" || codeMasterId.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Code Master Id' htmlEscape='false'/>");
        break;
      }
      
      if (detailcode == "" || detailcode.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail Code' htmlEscape='false'/>");
        break;
      }

    }

    return result;
}

function fnValidationCheck() 
{
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID);
    var udtList = AUIGrid.getEditedRowItems(myGridID);
    var delList = AUIGrid.getRemovedItems(myGridID);
        
    if (addList.length == 0  && udtList.length == 0 && delList.length == 0) 
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++) 
    {
      var codeMasterName  = addList[i].codeMasterName;
      
	    if (codeMasterName == "" || codeMasterName.length == 0) 
	    {
	      result = false;
	      // {0} is required.
	      Common.alert("<spring:message code='sys.msg.necessary' arguments='Code Master Name' htmlEscape='false'/>");
	      break;
	    }
    }

    for (var i = 0; i < udtList.length; i++) 
    {
      var codeMasterName  = udtList[i].codeMasterName;
      
	    if (codeMasterName == "" || codeMasterName.length == 0) 
	    {
	      result = false;
	      // {0} is required.
	      Common.alert("<spring:message code='sys.msg.necessary' arguments='Code Master Name' htmlEscape='false'/>");
	      break;
	    }
    }

    for (var i = 0; i < delList.length; i++) 
    {
      var codeMasterName  = delList[i].codeMasterName;
      
	    if (codeMasterName == "" || codeMasterName.length == 0) 
	    {
	      result = false;
	      // {0} is required.
	      Common.alert("<spring:message code='sys.msg.necessary' arguments='Code Master Name' htmlEscape='false'/>");
	      break;
	    }
    }

    return result;

}


// 마스터저장 서버 전송.
function fnSaveGridMap() 
{
  if (fnValidationCheck() == false)
  {
    return false;
  }
	
  Common.ajax("POST", "/general/saveGeneralCode.do"
		    , GridCommon.getEditData(myGridID)
		    , function(result) 
		     {
		        Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
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
		      Common.alert("Fail : " + jqXHR.responseJSON.message);
	      }); 
}

// 상세데이타 서버로 전송.
function fnSaveDetailGridMap() 
{
  if (fnValidationDetailCheck() == false)
  {
    return false;
  }
	
  Common.ajax("POST", "/general/saveDetailCommCode.do"
	     , GridCommon.getEditData(detailGridID), function(result) 
	       {
	        Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
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
         
	          Common.alert("Fail : " + jqXHR.responseJSON.message);
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
	  
  $("#cdMstNm").keydown(function(key) 
  {
    if (key.keyCode == 13) 
    {
    	fn_getMstCommCdListAjax();
    }
	});
	  
  $("#cdMstDesc").keydown(function(key) 
  {
    if (key.keyCode == 13) 
    {
    	fn_getMstCommCdListAjax();
    }
	});
	  
  $("#createID").keydown(function(key) 
  {
    if (key.keyCode == 13) 
    {
    	fn_getMstCommCdListAjax();
    }
	});
	
	var options = {
								  usePaging : true,
								  useGroupingPanel : false,
								  showRowNumColumn : false, // 순번 칼럼 숨김
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

        if (AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) == true
                || String(event.value).length < 1)
            {
                    return false;
            } 

            $("#mstCdId").val( event.value);
            
            fn_getDetailCode(myGridID, event.rowIndex);

        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );


    });    

/***********************************************[ DETAIL GRID] ************************************************/

    var dtailOptions = 
        {
            usePaging : true,
            useGroupingPanel : false,
            showRowNumColumn : false, // 순번 칼럼 숨김
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

	<div class="date_set w100p"><!-- date_set start -->
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

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn">
<%--   <a href="javascript:;">
    <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" />
  </a> --%>
</p>
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
<!-- MstSearch -->

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<aside class="title_line"><!-- title_line start -->
<h3>Master</h3>

<ul class="right_btns">
    <li><p class="btn_grid"><a onclick="addRow();">Add</a></p></li>
    <li><p class="btn_grid"><a onclick="fnSaveGridMap();">Save</a></p></li>
</ul>

</aside><!-- title_line end -->

<article class="grid_wrap">
<!-- grid_wrap start -->
<!-- 그리드 영역1 -->
 <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>Detail</h3>

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
    <li><p class="btn_grid"><a onclick="addRowDetail();">Add</a></p></li>   
    <li><p class="btn_grid"><a onclick="fnSaveDetailGridMap();">Save</a></p></li>
</ul>

</aside><!-- title_line end -->

<article class="grid_wrap" style="height:200px;"><!-- grid_wrap start -->
<!--  그리드 영역2  -->
  <div id="detailGrid"></div> 
</article><!-- grid_wrap end -->


</section><!-- search_result end -->
</form>
<!--  detail Form -->

</section><!-- content end -->
