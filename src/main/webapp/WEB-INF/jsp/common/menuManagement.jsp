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
var gSelMainRowIdx = 0;
var StatusCdList = new Array();

$(function() 
{
	getStatusComboListAjax();
});

var MainColumnLayout = 
    [      
        {    
            dataField : "div",
            headerText : "<spring:message code='sys.info.grid1.field_0' arguments='Div' htmlEscape='false'/>",
            width : 80
        }, {
            dataField : "menuLvl", 
            headerText : "<spring:message code='sys.info.grid1.field_1' arguments='Lvl' htmlEscape='false'/>",  
            width : 50,
            editRenderer : {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                listFunction : function(rowIndex, columnIndex, item, dataField) {
                	gSelMainRowIdx = rowIndex;
                   return   getMenuLevel();                 
                },
                keyField : "id"
            }
        }, {
            dataField : "upperMenuCode",
            headerText : "<spring:message code='sys.info.grid1.field_2' arguments='UpperMenu' htmlEscape='false'/>", 
            width : 180,
            editable : false,
            style : "aui-grid-left-column",
             renderer : {
                type : "IconRenderer",
                iconWidth : 13, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                iconHeight : 13,
                iconPosition : "aisleRight",
                iconFunction : function(rowIndex, columnIndex, value, item) 
                {
                    switch(item.menuLvl ) 
                    {
                      case "1":
                       return  null; // null 반환하면 아이콘 표시 안함.
                      default:
                       return "${pageContext.request.contextPath}/resources/images/common/normal_search.gif"; 
                    }
                } ,// end of iconFunction                
          
                onclick : function(rowIndex, columnIndex, value, item) 
                         {
				                    console.log("onclick: ( " + rowIndex + ", " + columnIndex + " ) " + item.menuLvl + " POPUP 클릭");
				                    if (item.menuLvl == "1")
				                    {
				                    	//Common.alert("Can't Select UpperMenu In 'Lvl 1.' ");
				                    	Common.alert("<spring:message code='sys.msg.cannot' arguments='Select UpperMenu ; Lvl 1.' htmlEscape='false' argumentSeparator=';'/>");
				                      return false;
				                    }
				                    
				                    gSelMainRowIdx = rowIndex;
				                    fnSearchUpperMenuPopUp(); 
				                  }
                } // IconRenderer
        },{
            dataField : "menuCode", 
            headerText : "<spring:message code='sys.info.grid1.field_3' arguments='MenuId' htmlEscape='false'/>", 
            width : 150
        }, {
            dataField : "menuName",
            headerText : "<spring:message code='sys.info.grid1.field_4' arguments='MenuNm' htmlEscape='false'/>", 
            width : 250
        }, {
            dataField : "pgmCode", 
            headerText : "<spring:message code='sys.info.grid1.field_5' arguments='ProgramId' htmlEscape='false'/>",
            width : 180,
            editable : false,
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
            headerText : "<spring:message code='sys.info.grid1.field_6' arguments='ProgramNm' htmlEscape='false'/>",
            editable : false,
            width : 230
        }, {
            dataField : "menuOrder", 
            headerText : "<spring:message code='sys.info.grid1.field_7' arguments='Order' htmlEscape='false'/>", 
            width : 100
        }, {
            dataField : "statusCode", 
            headerText : "<spring:message code='sys.info.grid1.field_8' arguments='Status' htmlEscape='false'/>", 
            //style : "my-column",
            width : 100,
            editRenderer : {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                listFunction : function(rowIndex, columnIndex, item, dataField) 
                {
                  return StatusCdList;
                },
                keyField : "id",
                valueField : "value",
              }            
        }, {
            dataField : "menuSeq",
            headerText : "",
            width : 0
          }
    ];

function getStatusComboListAjax(callBack) 
{
	  //Common.ajaxSync("GET", "/menu/selectCodeList.do"
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
function fnSetCategoryCd(selGrdidID, rowIdx)  
{     
 $("#selMenuId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "menuCode"));
  
 console.log("selMenuId: "+ $("#selMenuId").val() + " stusCtgryName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryName") );                
}

function auiCellEditignHandler(event) 
{
  if(event.type == "cellEditBegin") 
  {
      console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
      var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 9);
      console.log("menuSeq: " + menuSeq);
/*       if (AUIGrid.isAddedById(myGridID,menuSeq) == false   )// add된게 아니면 수정할수없다.
          {
                  alert("Confirm!!");  
                  return false;
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
function addRowMenu() 
{
  var item = new Object();
  
  item.div      ="Lvl1";
  item.menuLvl  ="1";
  item.menuCode =" Input MenuCode ...";
  item.menuName ="";  
  item.pgmCode  ="";
  item.pgmName  ="";
  item.menuOrder ="";
  item.upperMenuCode ="";
  item.statusCode    ="1";
  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
  AUIGrid.addRow(myGridID, item, "first");
}

//Make Use_yn ComboList, tooltip
function getMenuLevel()
{     
  var list =  ["2", "3", "4"];   
  return list;
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

function fnSearchProgramPopUp() 
{
   var popUpObj = Common.popupDiv("/menu/searchProgramPop.do"
       , $("#MainForm").serializeJSON()
       , null
       , "true"  // true면 close버튼 클릭시 화면 close
       );
        
}
function fnSearchUpperMenuPopUp() 
{
   var popUpObj = Common.popupDiv("/menu/searchUpperMenuPop.do"
       , $("#MainForm").serializeJSON()
       , null
       , "true"  // true면 close버튼 클릭시 화면 close
       );
        
}

function fnSelectMenuListAjax()
{
   Common.ajax("GET", "/menu/selectMenuList.do"
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

function fnSaveMenuCode() 
{
  if (fnValidationCheck() == false)
	{
	  return false;
	}
	
  Common.ajax("POST", "/menu/saveMenuId.do"
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
      var menuCode  = addList[i].menuCode;
      var menuName  = addList[i].menuName;
      var pgmCode   = addList[i].pgmCode;
      var menuLvl   = addList[i].menuLvl;
      var menuOrder = addList[i].menuOrder;
      var statusCode = addList[i].statusCode;
      var upperMenuCode = addList[i].upperMenuCode.fnTrim();
      
      if (menuCode == "" || menuCode.length == 0) 
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Code' htmlEscape='false'/>");
        break;
      }
      
      if (menuCode.length != 9) 
      {
        result = false;
        //Common.alert("Menu Code length must be 9 digits. ");
        Common.alert("<spring:message code='sys.msg.length' arguments='Menu Code ; 9' htmlEscape='false' argumentSeparator=';' />");  
        break;
      }
      
      if (menuName == "" ) 
      {
        result = false;
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Name' htmlEscape='false'/>");
        break;
      }
      
      if (menuLvl == "") 
      {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Level' htmlEscape='false'/>");
          break;
      }

      if (parseInt(menuLvl) > 4) 
      {
          result = false;
          //Common.alert("Menu Level is not more than 4. ");  
          Common.alert("<spring:message code='sys.msg.limitMore' arguments='Menu Level ; 4' htmlEscape='false' argumentSeparator=';' />");
          break;
      }
      
      if (menuLvl != "1" && menuOrder == "") 
      {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Order' htmlEscape='false'/>");
          break;
      }
      
      if (statusCode == "") 
      {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Status Code' htmlEscape='false'/>");
          break;
      }

      if ( menuLvl != "1" && upperMenuCode.length != 0 && menuCode == upperMenuCode)
      {
          result = false;
          //Common.alert(" 'UPPER MENU' and 'MENU CODE' should not be the same.");  
          Common.alert("<spring:message code='sys.msg.different' arguments='UPPER MENU ; MENU CODE' htmlEscape='false' argumentSeparator=';' />");
          break;
      }

      if ( parseInt(menuLvl) > 1 && upperMenuCode.length == 1 )
      {
          result = false;
          //Common.alert(" Pleae Enter 'UPPER MENU' at level 2 or higher.");
          Common.alert("<spring:message code='sys.msg.limit' arguments='UPPER MENU ; at level 2' htmlEscape='false' argumentSeparator=';'/>");
          break;
      }
      
    }  // addlist

     
    for (var i = 0; i < udtList.length; i++) 
    {
        var menuCode  = udtList[i].menuCode;
        var menuName  = udtList[i].menuName;
        var pgmCode   = udtList[i].pgmCode;
        var menuLvl   = udtList[i].menuLvl;
        var menuOrder = udtList[i].menuOrder;
        var statusCode = udtList[i].statusCode;
        var upperMenuCode = udtList[i].upperMenuCode.fnTrim();

        if (menuCode == "" || menuCode.length == 0) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Code' htmlEscape='false'/>");
          break;
        }
        
        if (menuCode.length != 9) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.length' arguments='Menu Code ; 9' htmlEscape='false' argumentSeparator=';' />");
          break;
        }        
        
        if (menuName == "" ) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Name' htmlEscape='false'/>");
          break;
        }
        
        if (menuLvl == "") 
        {
            result = false;
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Level' htmlEscape='false'/>");
            break;
        }
        
        if (menuLvl != "1" && menuOrder == "") 
        {
            result = false;
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Order' htmlEscape='false'/>");
            break;
        }
        
        if (statusCode == "") 
        {
            result = false;
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Status Code' htmlEscape='false'/>");
            break;
        }

        if ( menuLvl != "1" && upperMenuCode.length != 0 && menuCode == upperMenuCode)
        {
            result = false;
            Common.alert("<spring:message code='sys.msg.different' arguments='UPPER MENU and ; MENU CODE' htmlEscape='false' argumentSeparator=';'/>");
            break;
        }

        if ( parseInt(menuLvl) > 1 && upperMenuCode.length == 0 )
        {
            result = false;
            Common.alert("<spring:message code='sys.msg.limit' arguments='UPPER MENU ; at level 2' htmlEscape='false' argumentSeparator=';'/>");
            AUIGrid.restoreEditedCells(myGridID, [gSelMainRowIdx, "menuLvl"] );
            break;
        }        
        
    }// udtlist

    for (var i = 0; i < delList.length; i++) 
    {
        var menuCode  = delList[i].menuCode;
        
        if (menuCode == "" || menuCode.length == 0 || menuCode.length != 9) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Code' htmlEscape='false'/>");
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

var myGridID, transGridID;

$(document).ready(function()
{
    $("#menuCode").focus();
    
    $("#menuCode").keydown(function(key) 
    {
       if (key.keyCode == 13) 
       {
         fnSelectMenuListAjax();
       }

    });

    $("#menuCode").bind("keyup", function() 
	  {
	    $(this).val($(this).val().toUpperCase());
	  });
    
    $("#pgmCode").keydown(function(key) 
    {
       if (key.keyCode == 13) 
       {
         fnSelectMenuListAjax();
       }
    });

    $("#pgmCode").bind("keyup", function() 
    {
      $(this).val($(this).val().toUpperCase());
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
        
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedMenuId: " + $("#selMenuId").val() );        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
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
<!-- <input type ="hidden" id="groupCode" name="groupCode" value="310"/>
<input type ="hidden" id="selMenuId" name="selMenuId" value="310"/> -->
<input type ="hidden" id="selCategoryId" name="selCategoryId" value="7"/>
<input type ="hidden" id="parmDisab" name="parmDisab" value="0"/>

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
	<th scope="row">Menu Id</th>
	<td>
	 <input type="text" id="menuCode" name="menuCode" title="" placeholder="" class="w100p" style="text-transform: uppercase;"/>
	</td>
	<th scope="row">Program Id</th>
	<td>
	 <input type="text" id="pgmCode" name="pgmCode" title="" placeholder="" class="w100p" />
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
	<li><p class="btn_grid"><a onclick="fnSaveMenuCode();">SAVE</a></p></li>
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