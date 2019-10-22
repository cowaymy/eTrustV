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
var validFrom;
var validTo;

$(function()
{
    fnSearchBtnClickAjax();
});

var MainColumnLayout =
    [
        {
            dataField : "userId",
            headerText : "<spring:message code='sys.userexcept.grid1.userId' />",
            editable : false,
            width : "30%"
        }, {
            dataField : "userName",
            headerText : "<spring:message code='sys.userexcept.grid1.userName' />",
            editable : false,
            width : "70%"
        }, {
            dataField : "hidden",
            headerText : "",
            width : 0,
            visible:false
          }
    ];

var AuthColumnLayout =
    [
        {
            dataField : "authCode",
            headerText : "<spring:message code='sys.auth.grid1.AuthCode'/>",
            editable : false,
            width : "20%"
        }, {
            dataField : "authName",
            headerText : "<spring:message code='sys.auth.grid1.authName'/>",
            width : "30%",
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

                            fnSearchAuthRoleMappingPopUp();
                          }
            } // IconRenderer
        }, {
            dataField : "validDtFrom",
            headerText : "<spring:message code='sys.authRoleMapping.grid2.ValidDateFrom' />",
            dataType : "date",
            formatString : "dd-mmm-yyyy",
            width:"25%",
            editable : true,
            editRenderer : {
              type : "CalendarRenderer",
              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
              onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
              showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
            }
        }, {
            dataField : "validDtTo",
            headerText : "<spring:message code='sys.authRoleMapping.grid2.ValidDateTo' />",
            dataType : "date",
            formatString : "dd-mmm-yyyy",
            width:"25%",
            editable : true,
            editRenderer : {
              type : "CalendarRenderer",
              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
              onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
              showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
              }
        },{
              dataField : "userId",
            headerText : "<spring:message code='sys.userexcept.grid1.userId' />",
            editable   : false,
            width : 0
        } , {     // PK , rowid 용 칼럼
            dataField : "rowId",
            dataType : "string",
            visible : false
        }, {
            dataField : "oldFromDt",
            headerText : "<spring:message code='sys.authRoleMapping.grid2.ValidDateFrom'/>",
            editable : false,
            width : 0
        }, {
            dataField : "oldAuthCode",
            headerText : "<spring:message code='sys.auth.grid1.AuthCode'/>",
            editable : false,
            width : 0
        }
    ];

// Ajax

function fnSaveRoleAuthCd()
{
  if ( fnValidationCheck() == false )
  {
    return false;
  }

  Common.ajax("POST", "/authorization/saveUserExceptAuthMapping.do"
        , GridCommon.getEditData(AuthGridID)
        , function(result)
          {
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
            fnCellClickSelectUserExceptListAjax() ;

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

// User Info(Left)
function fnSelectUserInfoListAjax()
{
   Common.ajax("GET", "/authorization/selectUserInfoList.do"
           , $("#MainForm").serialize()
           , function(result)
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(myGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetuserIdParamSet(searchRoleGridID, 0);
              }
           });
}

//SYS0055M - search Click
function fnSearchBtnClickAjax()
{
   Common.ajax("GET", "/authorization/selectUserInfoList.do"
           , $("#MainForm").serialize()
           , function(result)
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(myGridID, result);
           });
}

// cell Clisk
function fnCellClickSelectUserExceptListAjax()
{
   Common.ajax("GET", "/authorization/selectUserExceptAdjustList.do"
           , $("#MainForm").serialize()
           , function(result)
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(AuthGridID, result);
              if(result != null && result.length > 0)
              {
              }
           });
}


//AUIGrid 메소드
//컬럼 선택시 상세정보 세팅.
function fnSetSelectedColumn(selGrdidID, rowIdx)
{
  $("#selAuthId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "roleCode"));

  console.log("selAuthId: "+ $("#selAuthId").val() + " authName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "authName") );
}

function auiCellEditignHandler(event)
{
  if(event.type == "cellEditBegin")
  {
      console.log("에디팅 시작(cellEditBegin) : (rowIdx: " + event.rowIndex + ",columnIdx: " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
      var authCode = AUIGrid.getCellValue(AuthGridID, event.rowIndex, "authCode");

      if(event.dataField == "validDtFrom" )  // validDtFrom는 신규일때만 허용되고 수정은 할 수 없다.
      {
          // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
         if(AUIGrid.isAddedById(AuthGridID, event.item.rowId) == false && (event.item.rowId =="PkAddNew")  )  // 추가된 행이기 때문에 수정 가능
         {
            return true;
         }
/*          else if(AUIGrid.isAddedById(AuthGridID, event.item.rowId) == false && (event.item.rowId != "PkAddNew"))
         {
             //Common.alert("Can't Edit Date In 'Base Auth.' "); sys.msg.cannot  Can not {0} In {1}
           Common.alert("<spring:message code='sys.msg.cannot' arguments='EDIT ; Valid_From Field.' htmlEscape='false' argumentSeparator=';'/>");
           return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
         }  */
      }
      else
      {
          return true; // 다른 필드들은 편집 허용
      }

  }
  else if(event.type == "cellEditEnd")
  {
      console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value + ", Field: " + event.dataField);

        var authSelectList =   AUIGrid.getGridData(AuthGridID);
        var selAuthCode  =  event.value;

        if ( event.headerText == "Valid_From" && event.columnIndex == 2)
        {
           validFrom =  event.value;
        }
        else if (event.headerText == "Valid_To" && event.columnIndex == 3)
        {
           validTo =  event.value;
        }

        if ( validFrom == undefined || validFrom == "")
        {
          validFrom = AUIGrid.getCellValue(AuthGridID, event.rowIndex, "validDtFrom");
        }

        if ( validTo == undefined || validTo == "")
        {
          validTo = AUIGrid.getCellValue(AuthGridID, event.rowIndex, "validDtTo");
        }

        if (validFrom != "")
        {
          validFrom = validFrom.split("/").join("");
        }

        if (validTo != "")
        {
          validTo = validTo.split("/").join("");
        }

        if ( (validFrom != undefined && validTo != undefined ) || (validFrom != "" && validTo != "") )
        {
            if (parseInt(validFrom) > parseInt(validTo) )
            {
               Common.alert("<spring:message code='sys.msg.limitMore' arguments='FROM DATE ; TO DATE.' htmlEscape='false' argumentSeparator=';'/>");
               //AUIGrid.setCellValue(AuthGridID, event.rowIndex, event.columnIndex, "");
               //validFrom = "";
               AUIGrid.setCellValue(AuthGridID, event.rowIndex, event.columnIndex, "");
               validTo = "";
               return false;
            }
            else
            {
               AUIGrid.setCellValue(AuthGridID, event.rowIndex, 2, validFrom);
               AUIGrid.setCellValue(AuthGridID, event.rowIndex, 3, validTo);
            }
        }

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
  if( $("#userId").val().length == 0 )
  {
      Common.alert("<spring:message code='sys.msg.first.Select' arguments='USER ID' htmlEscape='false'/>");
      return false;
  }

  var item = new Object();

      item.authCode    ="";
      item.authName    ="";
      item.validDtFrom ="";
      item.validDtTo   ="";
      item.userId      ="";
      item.rowId       ="PkAddNew";
      item.oldFromDt   ="";
      item.oldAuthCode ="";
      // parameter
      // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
      // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
      AUIGrid.addRow(AuthGridID, item, "first");
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
function fnAuthGridIDRemoveRow()
{
  console.log("fnRemoveRowMst: " + gSelMainRowIdx);
  AUIGrid.removeRow(AuthGridID,"selectedIndex");
}

function fnSearchAuthRoleMappingPopUp()
{
    if ($("#userId").val().length < 1)
   {
     //Common.alert("Role을 먼저 선택하시기 바랍니다.");
     Common.alert("<spring:message code='sys.msg.first.Select' arguments='USER ID' htmlEscape='false'/>");
     return false;
   }

   var popUpObj = Common.popupDiv("/authorization/searchAuthUserExceptMappingPop.do"
         , $("#MainForm").serializeJSON()
         , null
         , true
         , "searchAuthUserExceptMappingPop"
         );

}

function fnSetParamAuthCd(myGridID, rowIndex)
{
  $("#roleCode").val(AUIGrid.getCellValue(myGridID, rowIndex, "roleCode"));
  $("#authName").val(AUIGrid.getCellValue(myGridID, rowIndex, "authName"));

  console.log("roleCode: "+ $("#roleCode").val() + "authName: "+ $("#authName").val() );
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
    var addList = AUIGrid.getAddedRowItems(AuthGridID);
    var udtList = AUIGrid.getEditedRowItems(AuthGridID);
    var delList = AUIGrid.getRemovedItems(AuthGridID);

    if (addList.length == 0  && udtList.length == 0 && delList.length == 0)
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++)
    {
      var authCode  = addList[i].authCode;
      var authName  = addList[i].authName;
      var userId    = addList[i].userId;
      var validDtFrom  = addList[i].validDtFrom;
      var validDtTo    = addList[i].validDtTo;

      if (authCode == "" || authCode.length == 0)
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
        break;
      }

      if (authName == "" || authName.length == 0)
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Name' htmlEscape='false'/>");
        break;
      }

      if (validDtFrom == "" || validDtFrom == undefined  )
      {
        result = false;
        Common.alert("<spring:message code='sys.msg.necessary' arguments='From Date' htmlEscape='false'/>");
        break;
      }

      if (validDtTo == "" || validDtTo ==  undefined )
      {
        result = false;
        Common.alert("<spring:message code='sys.msg.necessary' arguments='To Date' htmlEscape='false'/>");
        break;
      }


    }  // addlist


    for (var i = 0; i < udtList.length; i++)
    {
        var authCode  = udtList[i].authCode;
        var authName  = udtList[i].authName;
        var userId    = udtList[i].userId;
        var validDtFrom  = udtList[i].validDtFrom;
        var validDtTo    = udtList[i].validDtTo;

        if (authCode == "" || authCode.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }

        if (authName == "" || authName.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Name' htmlEscape='false'/>");
          break;
        }

        if (userId == "" || userId.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='USER ID' htmlEscape='false'/>");
          break;
        }

        if (validDtFrom == "" || validDtFrom.length == 0  )
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='From Date' htmlEscape='false'/>");
          break;
        }

        if (validDtTo == "" || validDtTo.length == 0  )
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='To Date' htmlEscape='false'/>");
          break;
        }


    }// udtlist

    for (var i = 0; i < delList.length; i++)
    {
        var authCode  = delList[i].authCode;
        var userId    = delList[i].userId;
        var validDtFrom    = delList[i].validDtFrom;
        var validDtTo      = delList[i].validDtTo;

        if (authCode == "" || authCode.length == 0 )
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }

        if (userId == "" || userId.length == 0)
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='USER ID' htmlEscape='false'/>");
          break;
        }

        if (validDtFrom == "" || validDtFrom.length == 0  )
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='From Date' htmlEscape='false'/>");
          break;
        }

        if (validDtTo == "" || validDtTo.length == 0  )
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='To Date' htmlEscape='false'/>");
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

function fnAuthMappingGridReset()
{
  gAddRowCnt = 0;
  AUIGrid.clearGridData(AuthGridID);
}


function fnSetUserId(myGridID, rowIndex)
{
  $("#userId").val(AUIGrid.getCellValue(myGridID, rowIndex, "userId"));

  console.log("search_cell_click: "+ $("#userId").val() );
}



/****************************  Form Ready ******************************************/

var myGridID, AuthGridID;

$(document).ready(function()
{
  $("#txtUserId").focus();

  $("#txtUserId").bind("keyup", function()
  {
      $(this).val($(this).val().toUpperCase());
  });

  $("#txtUserId").keydown(function(key)
  {
    if (key.keyCode == 13)
    {
      fnSearchBtnClickAjax();
    }

  });

/***************************************************[ Role Auth Mapping GRID] ***************************************************/

    var options = {
                  usePaging : true,
               // 페이징을 간단한 유형으로 나오도록 설정
                  pagingMode : "simple",
                  useGroupingPanel : false,
                  showRowNumColumn : false, // 순번 칼럼 숨김
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
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedAuthId: " + $("#selAuthId").val() );

        gSelMainRowIdx = event.rowIndex;

        fnSetUserId(myGridID, event.rowIndex);

        fnCellClickSelectUserExceptListAjax();
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event)
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
    });


    $("#delCancel").hide();

/***************************************************[ Auth GRID] ***************************************************/

    var AuthGridOptions = {
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
                };

    // masterGrid 그리드를 생성합니다.
    AuthGridID = GridCommon.createAUIGrid("auth_grid_wrap", AuthColumnLayout,"", AuthGridOptions);
    // AUIGrid 그리드를 생성합니다.

    // 푸터 객체 세팅

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(AuthGridID, "cellEditBegin", auiCellEditignHandler);

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(AuthGridID, "cellEditEnd", auiCellEditignHandler);

    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(AuthGridID, "cellEditCancel", auiCellEditignHandler);

    // 행 추가 이벤트 바인딩
    AUIGrid.bind(AuthGridID, "addRow", auiAddRowHandler);

    // 행 삭제 이벤트 바인딩
    AUIGrid.bind(AuthGridID, "fnAuthGridIDRemoveRow", auiRemoveRowHandler);


    // cellClick event.
    AUIGrid.bind(AuthGridID, "cellClick", function( event )
    {
        gSelMainRowIdx = event.rowIndex;

        console.log("CellClick rowIndex2 : " + event.rowIndex + ", columnIndex : " + event.columnIndex );
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(AuthGridID, "cellDoubleClick", function(event)
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
<h2>User Exceptional Auth Mapping</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
  <li><p class="btn_blue"><a onclick="fnSearchBtnClickAjax();"><span class="search"></span>Search</a></p></li>
  </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="" onsubmit="return false;">
<input type="hidden" id="userId" name="userId" value="" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:110px" />
  <col style="width:*" />
<!--   <col style="width:110px" />
  <col style="width:*" /> -->
</colgroup>
<tbody>
 <tr>
    <th scope="row">USER</th>
     <td>
       <input type="text" id="txtUserId" name="txtUserId" title=""      placeholder="User Id or Name" class="" />
    </td>
<!--    <th scope="row">USER Name</th>
     <td><input type="text" id="userNm" name="userNm" title=""      placeholder="" class="" />
    </td> -->
 </tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn">
<%--    <a href="javascript:;">
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

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:30%;">

<div><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">User Auth Mapping</h3>
</aside><!-- title_line end -->

<article class="grid_wrap" ><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="grid_wrap" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

<div style="width:70%;">

<div><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Auth Management</h3>
<ul class="right_opt">
  <li><p class="btn_grid"><a onclick="fnAuthGridIDRemoveRow();">Del</a></p></li>
  <li><p class="btn_grid"><a onclick="fnAddRow();">Add</a></p></li>
  <li><p class="btn_grid"><a onclick="fnSaveRoleAuthCd();">SAVE</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" ><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="auth_grid_wrap" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->

<!--
<aside class="bottom_msg_box">bottom_msg_box start
<p>Information Message Area</p>
</aside>bottom_msg_box end

</section>container end
<hr />

</div>wrap end
</body>
</html>
-->