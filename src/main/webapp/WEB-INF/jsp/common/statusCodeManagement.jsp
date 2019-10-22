<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">

var gSelRowIdx = 0;

var statusCategoryLayout =
    [
        {
            dataField : "stusCtgryId",
            headerText : "<spring:message code='sys.status.grid1.CATEGORY_ID' />",
            width : "12%"
        }, {
            dataField : "stusCtgryName",
            headerText : "<spring:message code='sys.status.grid1.CATEGORY_NAME'/>",
            style : "aui-grid-left-column",
            width : "20%"
        }, {
            dataField : "stusCtgryDesc",
            headerText : "<spring:message code='sys.status.grid1.CATEGORY_DESCRIPTION'/>",
            style : "aui-grid-left-column",
            width : "22%"
        }, {
            dataField : "crtUserId",
            headerText : "<spring:message code='sys.status.grid1.CREATE_USER_ID'/>",
            width : "12%"
           ,editable : false
        }, {
            dataField : "updUserId",
            headerText : "<spring:message code='sys.status.grid1.LAST_UPDATE_USER_ID'/>",
            width : "16%"
           ,editable : false
        }, {
            dataField : "updDt",
            headerText : "<spring:message code='sys.status.grid1.LAST_UPDATE'/>",
            dataType : "date",
            formatString : "dd-mmm-yyyy HH:MM:ss",
            width : "18%"
           ,editable : false
        }
    ];


var detailColumnLayout =
    [
        {
            dataField : "stusCodeId",
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_ID'/>",
            width : "15%"
           ,editable : false
        }, {
            dataField : "codeName",
            headerText : "<spring:message code='sys.statuscode.grid1.CODE_NAME'/>",
            style : "aui-grid-left-column",
            width : "55%"
           ,editable : false
        }, {
            dataField : "seqNo",
            headerText : "<spring:message code='sys.statusCdMngment.grid1.seqNo'/>",
            width : "15%"
           ,editable : true
        }, {
            dataField : "codeDisab",
            headerText : "<spring:message code='sys.generalCode.grid1.DISABLED'/>",
            width : "15%",
            visible : true,
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
        }

    ];

var codeIDColumnLayout =
    [
      {
          dataField : "checkFlag",
          headerText : '<input type="checkbox" id="allCheckbox" name="allCheckbox" style="width:15px;height:15px;">',
          width : "10%",
          editable : false,
          renderer :
          {
              type : "CheckBoxEditRenderer",
              showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
              editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
              checkValue : 1, // true, false 인 경우가 기본
              unCheckValue : 0,
              // 체크박스 Visible 함수
              visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
               {
                 if(item.checkFlag == 1)  // 1 이면
                 {
                  return true; // checkbox visible
                 }

                 return true;
               }
          }  //renderer
      },{
            dataField : "stusCodeId",
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_ID'/>",
            width : "20%"
      },{
          dataField : "codeName",
          headerText : "<spring:message code='sys.statuscode.grid1.CODE_NAME'/>",
          style : "aui-grid-left-column",
          width : "50%"
      },{
          dataField : "code",
          headerText : "<spring:message code='sys.account.grid1.CODE'/>",
          width : "20%"
      }

    ];

// AUIGrid 메소드
//컬럼 선택시 상세정보 세팅.
function fnSetCategoryCd(selGrdidID, rowIdx)
{
   $("#selCategoryId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryId"));

  // $("#paramCategoryId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryId"));

   console.log("selCategoryId: "+ $("#selCategoryId").val() + " stusCtgryName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "stusCtgryName") );
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

        if (event.columnIndex == 2 && event.headerText == "SEQ NO") // SEQ NO
        {
            if (parseInt(event.value) < 1)
          {
                //Common.alert("Menu Level is not more than 4. ");
                Common.alert("<spring:message code='sys.msg.mustMore' arguments='SEQ NO ; 0' htmlEscape='false' argumentSeparator=';' />");
                AUIGrid.restoreEditedCells(detailGridID, [event.rowIndex, "seqNo"] );
                return false;
          }
        }

        if (event.columnIndex == 1 && event.headerText == "CATEGORY NAME") // CATEGORY NAME
        {
            if (parseInt(event.value) < 1)
          {
             Common.alert("<spring:message code='sys.msg.necessary' arguments='CATEGORY NAME' htmlEscape='false'/>");
             AUIGrid.restoreEditedCells(myGridID, [event.rowIndex, "stusCtgryName"] );
             return false;
          }
            else
          {
                AUIGrid.setCellValue(myGridID, event.rowIndex, 2, AUIGrid.getCellValue(myGridID, event.rowIndex, "stusCtgryName"));
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

// MstGrid 행 추가, 삽입
function addRowCategory()
{
  var item = new Object();

    item.stusCtgryId   ="";
    item.stusCtgryName ="";
    item.stusCtgryDesc ="";
    item.crtUserId     ="";
    item.updUserId     ="";
    item.updDt         ="";
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
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event)
{
    console.log (event.type + " 삭제이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

// 행 삭제 메소드
function removeRow()
{
    console.log("removeRowMst: " + gSelRowIdx);
    AUIGrid.removeRow(myGridID,"selectedIndex");
}

function removeRowDetail()
{
    console.log("removeRowDetailt: " + gSelRowIdx);
    AUIGrid.removeRow(detailGridID,"selectedIndex");
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

  //alert("checked items: " + str);

}

//AUIGrid 생성 후 반환 ID
var myGridID, detailGridID, statusCodeGridID;

$(document).ready(function()
{
      $("#txtCategoryId").focus();

      $("#txtCategoryId").keydown(function(key)
      {
                if (key.keyCode == 13)
                {
                    fnSelectCategoryListAjax();
                }

        });

      $("#paramCategoryNM").keydown(function(key)
      {
                if (key.keyCode == 13)
                {
                    fnSelectCategoryListAjax();
                }

        });

      $("#paramCreateID").keydown(function(key)
      {
                if (key.keyCode == 13)
                {
                    fnSelectCategoryListAjax();
                }

        });

      var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  showRowNumColumn : false,  // 그리드 넘버링
                  enableRestore : true,
                  softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
                  selectionMode : "multipleRows",
                };

    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", statusCategoryLayout,"stusCtgryId", options);
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
        $("#selCategoryId").val("");
        gSelRowIdx = event.rowIndex;

        console.log("cellClick_Status: " + AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) );

         if (AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) == false)  // 추가된 행이 아니다.
         {
            // Common.alert("<spring:message code='sys.msg.first.Select' arguments='Category ID' htmlEscape='false'/>");
           fnGetCategoryCd(myGridID, event.rowIndex);
         }

        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedCategoryId: " + $("#selCategoryId").val()  );
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event)
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
    });





/***********************************************[ DETAIL GRID] ************************************************/

    var dtailOptions =
        {
            usePaging : false,
            showRowNumColumn : false , // 그리드 넘버링
            useGroupingPanel : false,
            editable : true,
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            selectionMode : "multipleRows",
        };

    // detailGrid 생성
    detailGridID = GridCommon.createAUIGrid("detailGrid", detailColumnLayout,"stusCodeId", dtailOptions);

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




/***********************************************[ CODE_ID GRID] ************************************************/

    var statusCodeOptions =
        {
            usePaging : false,
            useGroupingPanel : false,
            editable : true,
            showRowNumColumn : false  // 그리드 넘버링
        };

    // detailGrid 생성
    statusCodeGridID = GridCommon.createAUIGrid("codeIdGrid", codeIDColumnLayout,"stusCodeId", statusCodeOptions);

    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(statusCodeGridID, "headerClick", headerClickHandler);

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "cellEditBegin", auiCellEditignHandler);

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "cellEditEnd", auiCellEditignHandler);

    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "cellEditCancel", auiCellEditignHandler);

    // 행 추가 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "addRow", auiAddRowHandler);

    // 행 삭제 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "removeRow", auiRemoveRowHandlerDetail);

    // cellClick event.
    AUIGrid.bind(statusCodeGridID, "cellClick", function( event )
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        gSelRowIdx = event.rowIndex;
    });


    // 체크박스 클린 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "rowCheckClick", function( event )
    {
      console.log("rowCheckClick : " + event.rowIndex + ", id : " + event.item.stusCodeId + ", name : " + event.item.codeName + ", checked : " + event.checked);
    });

    // 전체 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(statusCodeGridID, "rowAllChkClick", function( event )
   {
      console.log("rowAllChkClick checked : " + event.checked);
    });


});   //$(document).ready


//ajax list 조회.
function fnSelectCategoryListAjax()
{
  Common.ajax("GET", "/status/selectStatusCategoryList.do"  // selectStatusCategoryList
       , $("#MainForm").serialize()
       , function(result)
       {
          console.log("성공 data : " + result);
          AUIGrid.setGridData(myGridID, result);
          AUIGrid.clearGridData(detailGridID);

          if(result != null && result.length > 0)
          {
            //fnGetCategoryCd(myGridID, 0);
            console.log("UpdCategoryCdYN: " + $("#selCategoryId").val());
            if ($("#selCategoryId").val().length > 0 )
            {
              fnSelectCategoryCdInfo();
            }

            fnSelectStatusCdId();
          }
       });
}

function fnSelectCategoryCdInfo()
{
   Common.ajax("GET", "/status/selectStatusCategoryCdList.do"   // selectStatusCategoryCodeList
        , $("#MainForm").serialize()
        , function(result)
         {
             console.log("성공.");
             console.log("dataDetail : " + result);
             AUIGrid.setGridData(detailGridID, result);

             if(result == null || result.length == 0)
             {
                 console.log("detail No data count");
             }

         });
}

function fnSelectStatusCdId()
{
  Common.ajax("GET", "/status/selectStatusCdIdList.do"   // selectStatusCodeList
       , $("#MainForm").serialize()
       , function(result)
       {
          console.log("성공 data : " + result);
          AUIGrid.setGridData(statusCodeGridID, result);
       });
}
// myGridID, detailGridID, statusCodeGridID;
function fnValidationCheckStatusCode()
{
    var result = true;
    var addList = AUIGrid.getAddedRowItems(statusCodeGridID);
    var udtList = AUIGrid.getEditedRowItems(statusCodeGridID);

    if (addList.length == 0  && udtList.length == 0 )
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++)
    {
      var codeName  = addList[i].codeName;
      var code      = addList[i].code;

      if (codeName == "" || codeName.length == 0)
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='codeName' htmlEscape='false'/>");
        break;
      }
      if (code == "" || code.length == 0)
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='code' htmlEscape='false'/>");
        break;
      }
    }

    for (var i = 0; i < udtList.length; i++)
    {
        var codeName  = udtList[i].codeName;
        var code      = udtList[i].code;

        if (codeName == "" || codeName.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='codeName' htmlEscape='false'/>");
          break;
        }
        if (code == "" || code.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='code' htmlEscape='false'/>");
          break;
        }
    }

    return result;
 }
// myGridID, detailGridID, statusCodeGridID;
function fnValidationStatusCtgoryCode()
{
    var result = true;
    var delList = AUIGrid.getRemovedItems(detailGridID);
    var udtList = AUIGrid.getEditedRowItems(detailGridID);

    if (delList.length == 0  && udtList.length == 0 )
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < delList.length; i++)
    {
      var stusCodeId  = delList[i].stusCodeId;

      if (stusCodeId == "" || stusCodeId.length == 0)
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='code' htmlEscape='false'/>");
        break;
      }
    }

    for (var i = 0; i < udtList.length; i++)
    {
        var stusCodeId  = udtList[i].stusCodeId;

        if (stusCodeId == "" || stusCodeId.length == 0)
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='code' htmlEscape='false'/>");
          break;
        }
    }

    return result;
 }


function saveStatusCode()
{
 if (fnValidationCheckStatusCode() == false)
 {
      return false;
 }

  Common.ajax("POST", "/status/saveStatusCode.do"
             , GridCommon.getEditData(statusCodeGridID)
             , function(result)
               {
                fnSelectCategoryListAjax() ;
                    console.log("saveCategory 성공.");
                    console.log("dataSuccess : " + result.data);
                    Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
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

function fnValidationCheckCategory()
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
      var stusCtgryName  = addList[i].stusCtgryName;

      if (stusCtgryName == "" || stusCtgryName.length == 0)
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Category Name' htmlEscape='false'/>");
        break;
      }
    }

    for (var i = 0; i < udtList.length; i++)
    {
      var stusCtgryName  = udtList[i].stusCtgryName;

      if (stusCtgryName == "" || stusCtgryName.length == 0)
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Category Name' htmlEscape='false'/>");
        break;
      }
    }

    for (var i = 0; i < delList.length; i++)
    {
      var stusCtgryId  = delList[i].stusCtgryId;

      if (stusCtgryId == "" || stusCtgryId.length == 0)
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Category ID' htmlEscape='false'/>");
        break;
      }
    }

    return result;
}

function saveCategory()
{
    if (fnValidationCheckCategory() == false)
  {
          return false;
    }

  Common.ajax("POST", "/status/saveStatusCategory.do"
           , GridCommon.getEditData(myGridID)
           , function(result)
             {
            fnSelectCategoryListAjax() ;
              fnSelectCategoryCdInfo();
              console.log("saveCategory 성공.");
              console.log("dataSuccess : " + result.data);
              Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
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

function insertStatusCatalogDetail()
{
  //getItemsByCheckedField();

  if ($("#selCategoryId").val().length < 1 )
  {
    Common.alert("<spring:message code='sys.msg.first.Select' arguments='Category ID' htmlEscape='false'/>");
    return;
  }

//그리드 데이터에서 checkFlag 필드의 값이 Active 인 행 아이템 모두 반환
  var activeItems = AUIGrid.getItemsByValue(statusCodeGridID, "checkFlag", 1);

  if (activeItems.length < 1)
    {
      Common.alert("<spring:message code='sys.msg.first.Select' arguments='[Status Code ID]' htmlEscape='false'/>");
      return false;
    }

  var formDataParameters =
      {
        gridDataSet   : GridCommon.getEditData(statusCodeGridID),
        commStatusVO  : {
                         catalogId : MainForm.selCategoryId.value,
                         catalogNm : MainForm.selStusCtgryName.value
                        }
      };

  Common.ajax("POST", "/status/insertStatusCatalogDetail.do"
         , formDataParameters
         , function(result)
           {
            fnSelectCategoryListAjax() ;
 /*            console.log("selectCateG_Id: " + $("#selCategoryId").val());
            if ($("#selCategoryId").val().length > 0 )
            {
                fnSelectCategoryCdInfo();
            } */
            console.log("saveCategoryDetail 성공.");
            console.log("dataSuccess : " + result.data);
              Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
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

function fnSaveDetailData()
{
  //getItemsByCheckedField();

  if ($("#selCategoryId").val().length < 1 )
  {
    Common.alert("<spring:message code='sys.msg.first.Select' arguments='Category ID' htmlEscape='false'/>");
    return;
  }

  if (fnValidationStatusCtgoryCode() == false)
  {
       return false;
  }

  var formDataCategoryYN =
        {
            gridDataSet   : GridCommon.getEditData(detailGridID),   // VO에 쓰일 변수명, 일치시킨다.
            commStatusVO  : {
                         catalogId : MainForm.selCategoryId.value,  // 필드명(key)과 매핑시킨다
                         catalogNm : MainForm.selStusCtgryName.value
                        }
      };

  Common.ajax("POST", "/status/UpdCategoryCdYN.do"
           , formDataCategoryYN
           , function(result)
             {
              fnSelectCategoryListAjax() ;

              console.log("UpdSuccess : " + result.data);
              Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");

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
</script>

<section id="content"><!-- content start -->
<ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order</li>
  <li>Order</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Statsus Code Management</h2>
<ul class="right_btns">
  <li><p class="btn_blue"><a onclick="fnSelectCategoryListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="MainForm" method="get" action="">

<input type ="hidden" id="selCategoryId" name="selCategoryId" value=""/>
<input type ="hidden" id="selStusCtgryName" name="selStusCtgryName" value=""/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:150px" />
  <col style="width:*" />
  <col style="width:150px" />
  <col style="width:*" />
  <col style="width:150px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">Category ID</th>
  <td>
   <input type="text" title="" id="txtCategoryId" name="txtCategoryId"  placeholder="Category ID" class="w100p" />
  </td>
  <th scope="row">Category Name</th>
  <td>
  <input type="text" title="" id="paramCategoryNM" name="paramCategoryNM" placeholder="Category Name" class="w100p" />
  </td>
  <th scope="row">Creator ID</th>
  <td>
  <input type="text" title="" id="paramCreateID" name="paramCreateID" placeholder="Creator ID" class="w100p" />
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

<aside class="title_line"><!-- title_line start -->
<h3>Status Category</h3>
<ul class="right_btns">
  <li><p class="btn_grid"><a onclick="removeRow();">DEL</a></p></li>
  <li><p class="btn_grid"><a onclick="addRowCategory();">ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="saveCategory();">SAVE</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역1 -->
 <div id="grid_wrap" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<section class="search_result autoFixArea"><!-- search_result start -->

<div class="divine_auto type2"><!-- divine_auto start -->

<div style="width:45%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Status Code</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:330px;"><!-- border_box start -->


<ul class="right_btns pt0">
  <li><p class="btn_grid"><a onclick="addRowStatusCode();">ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="saveStatusCode();">SAVE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역2 -->
 <div id="codeIdGrid"></div>
</article><!-- grid_wrap end -->

<ul class="btns right-type">
  <li><a onclick="insertStatusCatalogDetail();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
</ul>

</div><!-- border_box end -->

</div><!-- 50% end -->

<div style="width:55%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Status Category Code Management</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:330px;"><!-- border_box start -->

<ul class="right_btns pt0">
  <li><p class="btn_grid"><a onclick="removeRowDetail();">DEL</a></p></li>
  <li><p class="btn_grid"><a onclick="fnSaveDetailData();">SAVE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역3 -->
 <div id="detailGrid"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div><!-- 50% end -->


</div><!-- divine_auto end -->

</section><!-- search_result end -->

</form>
</section><!-- content end -->