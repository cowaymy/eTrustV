<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

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

var MainColumnLayout =
    [

        {
            dataField : "div",
            headerText : "<spring:message code='sys.menumanagement.grid1.Div' />",
            editable: false,
            width : "5%"
        }, {
            dataField : "menuLvl",
            headerText : "<spring:message code='sys.menumanagement.grid1.Lvl' />",
            headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
            editable: true,
            width : "4%",
            editRenderer : {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                listFunction : function(rowIndex, columnIndex, item, dataField)
                {
            //    	if( FormUtil.isEmpty( item.menuCode ) ){
	                    gSelMainRowIdx = rowIndex;
	                    return   getMenuLevel();
             //   	}
                },
                descendants : [ "upperMenuCode" ], // 자손 필드들
                descendantDefaultValues : [ "" ], // 변경 시 자손들에게 기본값 지정
                keyField : "id"
            }




        }, {
            dataField : "upperMenuCode",
            headerText : "<spring:message code='sys.menumanagement.grid1.UpperMenu' />",
            width : "13%",
            editable : false,
            style : "aui-grid-left-column",
            renderer :
            {
                type : "IconRenderer",
                iconWidth : 24, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                iconHeight : 24,
                iconPosition : "aisleRight",
                iconFunction : function(rowIndex, columnIndex, value, item)
                {
                	/* if( FormUtil.isEmpty( item.menuCode ) ){
	                    switch(item.menuLvl )
	                    {
	                      case "1":
	                       return  null; // null 반환하면 아이콘 표시 안함.
	                      default:
	                       return "${pageContext.request.contextPath}/resources/images/common/normal_search.png";
	                    }
                    } */
                	return "${pageContext.request.contextPath}/resources/images/common/normal_search.png";
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
        }, {
            dataField : "menuOrder",
            headerText : "<spring:message code='sys.menumanagement.grid1.Order'/>",
            headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
            width : "8%",
            editable : true,
        }, {
            dataField : "menuCode",
            headerText : "<spring:message code='sys.menumanagement.grid1.MenuId'/>",
            editable : false, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
            width : "10%"
        }, {
            dataField : "menuName",
            headerText : "<spring:message code='sys.menumanagement.grid1.MenuNm' />",
            headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
            editable : true, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
            style : "aui-grid-left-column",
            width : "22%"
        }, {
            dataField : "pgmCode",
            headerText : "<spring:message code='sys.menumanagement.grid1.ProgramId'/>",
            editable : true, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
            width : "10%"
        }, {
            dataField : "pgmName",
            headerText : "<spring:message code='sys.menumanagement.grid1.ProgramNm' />",
            editable : true, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
            style : "aui-grid-left-column",
            width : "22%"
        }, {
            dataField : "pagePath",
            headerText : "<spring:message code='sys.menumanagement.grid1.pagePath' />",
            headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
            style : "aui-grid-left-column",
            width : "22%",
            editable : true
        }, {
            dataField : "menuIconNm",
            headerText : "<spring:message code='sys.menumanagement.grid1.icon' />",
            headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
            style : "aui-grid-left-column ",
            headerStyle : "",
            width : "12%",
            editable : true
        }, {
            dataField : "useYn",
            headerText : "<spring:message code='sys.menumanagement.grid1.useYn' />",
            headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
            width : "8%",
            editRenderer : {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                listFunction : function(rowIndex, columnIndex, item, dataField)
                {
                    gSelMainRowIdx = rowIndex;
                    return   getUseYn();
                },
                keyField : "id"
            }
        }, {
            dataField : "updUserNm",
            headerText : "<spring:message code='pay.head.updateUser' />",
            width : "10%",
            editable : false
        }, {
            dataField : "updDt",
            headerText :  "<spring:message code='pay.head.updateDate' />",
            width : "10%",
            editable : false
        }, {
            dataField : "menuSeq",
            headerText : "",
            visible : false
       }
    ];

//AUIGrid 메소드

function auiCellEditignHandler(event)
{
  if(event.type == "cellEditBegin")
  {
      console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
      //var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 11);

      if(event.dataField == "menuCode")
      {
          // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
         if(AUIGrid.isAddedById(myGridID, event.item.rowId) == false && (event.item.rowId =="PkAddNew") )  //추가된 Row
         {
              return true; // 수정가능
         }
         else
         {
            return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
         }
      }
      else if(event.dataField == "menuLvl")
      {

      }
      else
      {
           return true; // 다른 필드들은 편집 허용
      }

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

  item.div        ="Lvl1";
  item.menuLvl    ="1";
  item.upperMenuCode ="";
  item.menuCode   ="";
  item.menuName   ="";
  item.pgmCode    ="";
  item.pgmName    ="";
  item.useYn        ="Y";
  item.menuSeq    ="";
  item.rowId      ="PkAddNew";
  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
  AUIGrid.addRow(myGridID, item, "first");
}

//Make Use_yn ComboList, tooltip
function getMenuLevel()
{
  return  ["1", "2"];
}

//Make Use_yn ComboList, tooltip
function getUseYn()
{
  return  ["Y", "N"];
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

function fnSearchUpperMenuPopUp()
{
   var popUpObj = Common.popupDiv("/mobileMenu/searchMobileMenuPop.do"
       , $("#MainForm").serializeJSON()
       , null
       , true  // true면 더블클릭시 close
       , "searchMenuPop"
       );
}

function fnSelectMenuListAjax()
{
      if ($("#txtMenuCode").val().length > 0)
        {
          $("#menuCode").val($("#txtMenuCode").val());
        }
      else
    {
        $("#menuCode").val("");
    }

   Common.ajax("GET", "/mobileMenu/selectMobileMenuList.do"
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

// 저장
function fnSaveMenuCode()
{
   if (fnValidationCheck() == false)
    {
      return false;
    }

  Common.ajax("POST", "/mobileMenu/saveMobileMenuId.do"
        , GridCommon.getEditData(myGridID)
        , function(result)
          {
            //alert(result.data + " Count Save Success!");
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
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

              Common.alert("Fail : " + jqXHR.responseJSON.message);

          });
  }

//삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
function removeAllCancel()
{
  $("#delCancel").hide();

  AUIGrid.restoreSoftRows(myGridID, "all");
}

function fnClear(){
    $("#MainForm")[0].reset();
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
      var menuLvl  = addList[i].menuLvl;
      var upperMenuCode  = addList[i].upperMenuCode;
      var menuOrder  = addList[i].menuOrder;
      var menuCode  = addList[i].menuCode;
      var menuName  = addList[i].menuName;

      if (FormUtil.isEmpty(menuLvl))
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Lvl' htmlEscape='false'/>");
        break;
      }

    /*   if (FormUtil.isEmpty(upperMenuCode))
      {
        result = false;
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Upper Menu Code' htmlEscape='false'/>");
        break;
      } */

      if (FormUtil.isEmpty(menuOrder))
      {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Order' htmlEscape='false'/>");
          break;
      }

      if (FormUtil.isEmpty(menuName))
      {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Name' htmlEscape='false'/>");
          break;
      }

      if ( parseInt(menuLvl) > 1 && FormUtil.isEmpty(upperMenuCode) )
      {
          result = false;
          //Common.alert(" Pleae Enter 'UPPER MENU' at level 2 or higher.");
          Common.alert("<spring:message code='sys.msg.limit' arguments='UPPER MENU ; at level 2' htmlEscape='false' argumentSeparator=';'/>");
          break;
      }

    }  // addlist


    for (var i = 0; i < udtList.length; i++)
    {
        var menuLvl  = udtList[i].menuLvl;
        var upperMenuCode  = udtList[i].upperMenuCode;
        var menuOrder  = udtList[i].menuOrder;
        var menuName  = udtList[i].menuName;
        var menuIconNm  = udtList[i].menuIconNm;

        if( menuLvl == "2" )
        {
        	var iValue = -1;
        	if( !FormUtil.isEmpty(menuIconNm) ){
        		 iValue = menuIconNm.indexOf("icon");
        	}


            if( iValue > -1 )
            {
            	result = false;
            	Common.alert("'iocn' cannot be entered at level 2 or above.");
                break;
            }
        }

        if (FormUtil.isEmpty(menuLvl))
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Lvl' htmlEscape='false'/>");
          break;
        }

        /* if (FormUtil.isEmpty(upperMenuCode))
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Upper Menu Code' htmlEscape='false'/>");
          break;
        } */

        if (FormUtil.isEmpty(menuOrder))
        {
            result = false;
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Order' htmlEscape='false'/>");
            break;
        }

      /*   if (FormUtil.isEmpty(menuCode))
        {
            result = false;
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Code' htmlEscape='false'/>");
            break;
        } */

        if (FormUtil.isEmpty(menuName))
        {
            result = false;
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Name' htmlEscape='false'/>");
            break;
        }

        if ( parseInt(menuLvl) > 1 && upperMenuCode.length == 1 )
        {
            result = false;
            //Common.alert(" Pleae Enter 'UPPER MENU' at level 2 or higher.");
            Common.alert("<spring:message code='sys.msg.limit' arguments='UPPER MENU ; at level 2' htmlEscape='false' argumentSeparator=';'/>");
            break;
        }

    }// udtlist

    for (var i = 0; i < delList.length; i++)
    {
    	 var menuCode  = delList[i].menuCode;

    	 if (FormUtil.isEmpty(menuCode))
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
    $("#txtMenuCode").focus();

    $("#txtMenuCode").keydown(function(key)
    {
       if (key.keyCode == 13)
       {
         fnSelectMenuListAjax();
       }

    });

    $("#txtMenuCode").bind("keyup", function()
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
                      //rowIdField : "rowId", // PK행 지정
                  usePaging : false,
                  // 한 화면에 출력되는 행 개수 20개로 지정
                  //pageRowCount : 20,
                  useGroupingPanel : false,
                  selectionMode : "multipleRows",
                  showRowNumColumn : false, // 순번 칼럼 숨김
                  // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
                  rowSelectionWithMerge : true,
                  //editable : true,
                  // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
                  enableRestore : true,
                  softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제

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

        $("#menuCode").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "menuCode"));

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
<h2>Mobile Menu Management</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a onclick="fnSelectMenuListAjax();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a onclick="fnClear();" ><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
    </c:if>
<!--    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
    <input type ="hidden" id="menuCode" name="menuCode" value=""/>
    <input type ="hidden" id="selCategoryId" name="selCategoryId" value="1"/>
    <input type ="hidden" id="parmDisab" name="parmDisab" value="0"/>
    <input type ="hidden" id="groupCode" name="groupCode" value="345"/>
    <input type ="hidden" id="menuLvl" name="menuLvl" value="2"/>
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
         <input type="text" id="txtMenuCode" name="txtMenuCode" title="" placeholder="Menu Id or Name" class="w100p" style="text-transform: uppercase;"/>
        </td>
        <th scope="row">Program</th>
        <td>
         <input type="text" id="pgmCode" name="pgmCode" title="" placeholder="Program Id or Name" class="w100p" />
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn">
  <%-- <a href="javascript:;">
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

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Mobile Menu Management</h3>
<ul class="right_opt">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li id="delCancel"><p class="btn_grid"><a onclick="removeAllCancel();">Cancel</a></p></li>
    <li><p class="btn_grid"><a onclick="removeRow();">DEL</a></p></li>
    <li><p class="btn_grid"><a onclick="addRowMenu();">ADD</a></p></li>
    <li><p class="btn_grid"><a onclick="fnSaveMenuCode();">SAVE</a></p></li>
    </c:if>
</ul>

</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="grid_wrap" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
