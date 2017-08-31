<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
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

var gSelMainRowIdx = 0;
var StatusCdList = new Array();

$(function() 
{
  //getStatusComboListAjax();
});

//Make Use_yn ComboList, tooltip
function getDisibledComboList()
{     
  return list =  ["Active", "InActive"];   
}

var MainColumnLayout = 
    [      
        {    
            dataField : "zreExptId",
            headerText : "<spring:message code='sys.gstexportation.grid1.zreexptid'/>",
            editable : false,
            width : "10%",
        }, {
            dataField : "dealerName", 
            headerText : "<spring:message code='sys.gstexportation.grid1.dealername'/>",
            editable : false,
            //style : "aui-grid-left-column",
            width : "45%",
        }, {
            dataField : "codeName",
            headerText : "<spring:message code='sys.gstexportation.grid1.status'/>",
            width : "10%",
            editable : true,
            editRenderer : 
            {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                listFunction : function(rowIndex, columnIndex, item, dataField) {
                	return getDisibledComboList();
                },
                keyField : "id",
                //valueField : "value",
            }
            
        } ,{
            dataField : "zreExptDealerId", 
            headerText : "<spring:message code='sys.gstexportation.grid1.dealerid' />",
            editable : false,
            width : "10%",
        }, {
            dataField : "zreExptStusId",
            headerText : "<spring:message code='sys.gstexportation.grid1.stusid'/>",
            editable : false,
            //style : "aui-grid-left-column",
            width : 0,
        }, {
            dataField : "zreExptRem",
            headerText : "<spring:message code='sys.gstexportation.grid1.remark'/>",
            editable : false,
            //style : "aui-grid-left-column",
            width : "15%",
        }, {
            dataField : "zreExptCrtUserId",
            headerText : "<spring:message code='sys.userexcept.grid1.userId'/>",
            editable : false,
            //style : "aui-grid-left-column",
            width : 0,
        },{
            dataField : "hidden",
            headerText : "hidden",
            width : 0
        }, {     // PK , rowid 용 칼럼
            dataField : "rowId",
            dataType : "string",
            width : 0
        }
    ];

function getStatusComboListAjax(callBack) 
{
    //Common.ajaxSync("GET", "/common/selectCodeList.do"
    Common.ajaxSync("GET", "/status/selectStatusCategoryCdList.do"
                 , $("#MainForm").serialize()
                 , function(result) 
                 {
                    for (var i = 0; i < result.length; i++) 
                    {
                      var list = new Object();
                          list.id = result[i].stusCodeId;
                          list.value = result[i].codeName ;
                          StatusCdList.push(list);
                    }

                    //if you need callBack Function , you can use that function
                    if (callBack) {
                      callBack(StatusCdList);
                    }
                    
                  });
    return StatusCdList;
  }

//AUIGrid 메소드
//컬럼 선택시 상세정보 세팅.
function fnSetSelectedColumn(selGrdidID, rowIdx)  
{     
 $("#selAuthId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "zreExptId"));
  
 console.log("selAuthId: "+ $("#selAuthId").val() + " dealerName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "dealerName") );                
}

function auiCellEditignHandler(event) 
{
  if(event.type == "cellEditBegin") 
  {
      console.log("에디팅 시작(cellEditBegin) : (rowIdx: " + event.rowIndex + ",columnIdx: " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
/*       var authSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, "zreExptId");
      
      if (AUIGrid.isAddedById(myGridID,authSeq) == false && authSeq.indexOf("Input zreExptId") == -1 && event.columnIndex == 0 )// edit
      {
        return false;  // edit모드일 때만 zreExptId를 수정할수 있다.
      } */
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
function fnAddRow() 
{
  var item = new Object();

      item.zreExptId ="";
      item.dealerName ="";
      item.roleId   ="";
      item.roleLvl  ="";
      item.roleId1  ="";
      item.roleId2  ="";
      item.roleId3  ="";
      // parameter
      // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
      // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
      AUIGrid.addRow(myGridID, item, 3);
}

//Make Use_yn ComboList, tooltip


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
function fnRemoveRow() 
{
  console.log("fnRemoveRowMst: " + gSelMainRowIdx);    
  AUIGrid.removeRow(myGridID,"selectedIndex");
}

function fnSearchRolePopUp() 
{
   var popUpObj = Common.popupDiv("/authorization/searchRolePop.do"
       , $("#MainForm").serializeJSON()
       , null
       , true  
       , "SearchRolePop"
       );
        
}

function fnSetParamAuthCd(myGridID, rowIndex)
{
  $("#zreExptId").val(AUIGrid.getCellValue(myGridID, rowIndex, "zreExptId"));
  $("#dealerName").val(AUIGrid.getCellValue(myGridID, rowIndex, "dealerName"));
   
  console.log("zreExptId: "+ $("#zreExptId").val() + "dealerName: "+ $("#dealerName").val() );     
}

function fnSearchBtnList()
{
   Common.ajax("GET", "/common/selectGSTExportationList.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(myGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetSelectedColumn(myGridID, 0);
              }
           });
}

function fnSaveAuthCd() 
{
  if (fnValidationCheck() == false)
  {
    return false;
  }
  
  Common.ajax("POST", "/authorization/saveAuth.do"
        , GridCommon.getEditData(myGridID)
        , function(result) 
          {
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
            fnSearchBtnList() ;
            
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

//삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
function removeAllCancel() 
{
  $("#delCancel").hide();
  
  AUIGrid.restoreSoftRows(myGridID, "all"); 
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
      var zreExptId  = addList[i].zreExptId;
      var dealerName  = addList[i].dealerName;
      var roleId    = addList[i].roleId;
      var roleLvl   = addList[i].lvl;
      var roleId1   = addList[i].role1;
      var roleId2   = addList[i].role2;
      var roleId3   = addList[i].role3;
      
      if (roleId == "" || roleId.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Role Id' htmlEscape='false'/>");
        break;
      }
      
      if (roleLvl == "" || roleLvl.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Role Lvl' htmlEscape='false'/>");
        break;
      }

/*       if (dealerName.indexOf("delimiter") > 0 ) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth dealerName' htmlEscape='false'/>");
        break;
      } */
      
    }  // addlist

     
    for (var i = 0; i < udtList.length; i++) 
    {
        var zreExptId  = udtList[i].zreExptId;
        var dealerName  = udtList[i].dealerName;
        var roleId    = udtList[i].roleId;
        var roleLvl   = udtList[i].roleLvl;
        var roleId1   = udtList[i].roleId1;
        var roleId2   = udtList[i].roleId2;
        var roleId3   = udtList[i].roleId3;

        if (zreExptId == "" || zreExptId.length == 0) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }
        
    }// udtlist

    for (var i = 0; i < delList.length; i++) 
    {
        var zreExptId  = delList[i].zreExptId;
        
        if (zreExptId == "" || zreExptId.length == 0 ) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }
        
     } //delete
    
    return result;
  }

//trim
String.prototype.fnTrim = function() 
{
    return this.replace(/(^\s*)|(\s*$)/gi, "");
}


/****************************  Form Ready ******************************************/

var myGridID;

$(document).ready(function()
{
    $("#zreExptId").focus();
    
    $("#zreExptId").keydown(function(key) 
    {
       if (key.keyCode == 13) 
       {
         fnSearchBtnList();
       }

    });

    $("#zreExptId").bind("keyup", function() 
    {
      $(this).val($(this).val().toUpperCase());
    });
    
    $("#dealerName").keydown(function(key) 
    {
       if (key.keyCode == 13) 
       {
         fnSearchBtnList();
       }
    });

    $("#dealerName").bind("keyup", function() 
    {
      $(this).val($(this).val().toUpperCase());
    });

/***************************************************[ Main GRID] ***************************************************/    

    var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  showRowNumColumn : false, // 순번 칼럼 숨김
                  selectionMode : "multipleRows",
                  // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
                  rowSelectionWithMerge : true,
                  editable : true,
                  // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
                  enableRestore : true,
                  
                  softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제

                  //fixedRowCount :3,
                  
                };
    
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", MainColumnLayout,"zreExptId", options);
    // AUIGrid 그리드를 생성합니다.
    
    // 푸터 객체 세팅
    
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
        
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedAuthId: " + $("#selAuthId").val() );        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
    });    

    $("#delCancel").hide();
    
});   //$(document).ready


</script>
		
<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="javascript:;"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="검색" />
</p>

</form>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="javascript:;">All menu</a></p>
<ul class="inb_menu">
	<li class="active">
	<a href="javascript:;" class="on">menu 1depth</a>

	<ul>
		<li class="active">
		<a href="javascript:;" class="on">menu 2depth</a>

		<ul>
			<li class="active">
			<a href="javascript:;" class="on">menu 3depth</a>
			</li>
			<li>
			<a href="javascript:;">menu 3depth</a>
			</li>
			<li>
			<a href="javascript:;">menu 3depth</a>
			</li>
			<li>
			<a href="javascript:;">menu 3depth</a>
			</li>
			<li>
			<a href="javascript:;">menu 3depth</a>
			</li>
			<li>
			<a href="javascript:;">menu 3depth</a>
			</li>
		</ul>

		</li>
		<li>
		<a href="javascript:;">menu 2depth</a>
		</li>
		<li>
		<a href="javascript:;">menu 2depth</a>
		</li>
		<li>
		<a href="javascript:;">menu 2depth</a>
		</li>
		<li>
		<a href="javascript:;">menu 2depth</a>
		</li>
		<li>
		<a href="javascript:;">menu 2depth</a>
		</li>
	</ul>

	</li>
	<li>
	<a href="javascript:;">menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">menu 1depth</a>
	</li>
</ul>
<p class="click_add_on_solo"><a href="javascript:;"><span></span>My menu</a></p>
<ul class="inb_menu">
	<li>
	<a href="javascript:;">My menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">My menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">My menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">My menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">My menu 1depth</a>
	</li>
	<li>
	<a href="javascript:;">My menu 1depth</a>
	</li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
<h2>GST Zero Rate Exportation Search</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="javascript:;"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">

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
	<th scope="row">Exportation ID</th>
	<td>
	<input type="text" id="zreExptId" name="zreExptId" title="" placeholder="" class="w100p" />
	</td>
	<th scope="row">Dealer Name</th>
	<td>
	<input type="text" id="dealerName" name="dealerName" title="" placeholder="" class="w100p" /> 
	</td>
	<th scope="row">Status</th>
	<td>
	<select id="zreExptStusId" name="zreExptStusId" class="w100p">
    <option value="0">ALL</option>
    <option value="1" selected>Active</option>
    <option value="8">Inactive</option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><%-- <a href="javascript:;"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a> --%></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn"><a href="javascript:;">menu1</a></p></li>
		<li><p class="link_btn"><a href="javascript:;">menu2</a></p></li>
		<li><p class="link_btn"><a href="javascript:;">menu3</a></p></li>
		<li><p class="link_btn"><a href="javascript:;">menu4</a></p></li>
		<li><p class="link_btn"><a href="javascript:;">Search Payment</a></p></li>
		<li><p class="link_btn"><a href="javascript:;">menu6</a></p></li>
		<li><p class="link_btn"><a href="javascript:;">menu7</a></p></li>
		<li><p class="link_btn"><a href="javascript:;">menu8</a></p></li>
	</ul>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="javascript:;">menu1</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:;">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:;">menu3</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:;">menu4</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:;">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:;">menu6</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:;">menu7</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:;">menu8</a></p></li>
	</ul>
	<p class="hide_btn"><a href="javascript:;"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
  <li id="delCancel"><p class="btn_grid"><a onclick="removeAllCancel();">Cancel</a></p></li>
  <li><p class="btn_grid"><a onclick="fnRemoveRow();">DEL</a></p></li>
  <li><p class="btn_grid"><a onclick="fnAddRow();">ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="fnSaveRow();">SAVE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->
		
</section><!-- container end -->