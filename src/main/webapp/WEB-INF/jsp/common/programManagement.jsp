<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}

.write-active-style {
  background:#ddedde;
}
.my-inactive-style {
  background:#efcefc;
}

</style>
<script type="text/javaScript">
var gAddRowCnt = 0;
var gOrgList =   ["ORG", "LOG","SAL", "PAY", "SVC", "CCR", "CMM", "SYS", "MIS"];

var MainColumnLayout = 
    [      
        {    
            dataField : "pgmCode",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Id' htmlEscape='false'/>",
            editable : false,
            width : 150
        }, {
            dataField : "orgCode",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='OrgCode' htmlEscape='false'/>",
            visible : false,
            editRenderer : {
                type : "DropDownListRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                list : gOrgList
            },
            width : 100
        },{
            dataField : "pgmName",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Name' htmlEscape='false'/>",
            width : 250
        }, {
            dataField : "pgmPath",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Path' htmlEscape='false'/>",
            styleFunction : cellStyleFunction,
            width : 450
        }, {
            dataField : "pgmDesc",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='Description' htmlEscape='false'/>",
            width : 400
        }
    ];

var TransColumnLayout = 
    [      
        {    
            dataField : "funcView",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='VIEW' htmlEscape='false'/>",
            width : 70,
            renderer : 
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "Y", // true, false 인 경우가 기본
                unCheckValue : "N",
                // 체크박스 Visible 함수
                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                 {
                   if(item.funcView == "Y")  
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            },  //renderer

        }, {
            dataField : "funcChng",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='CHANGE' htmlEscape='false'/>",
            width : 70,
            editable : true,
            renderer : 
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "Y", // true, false 인 경우가 기본
                unCheckValue : "N",
                // 체크박스 Visible 함수
                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                 {
                   if(item.funcChng == "Y")  
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            }  //renderer            
        }, {
            dataField : "funcPrt",
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='PRINT' htmlEscape='false'/>",
            width : 70,
            editable : true,
            renderer : 
            {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "Y", // true, false 인 경우가 기본
                unCheckValue : "N",
                // 체크박스 Visible 함수
                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                 {
                   if(item.funcPrt == "Y")  
                   {
                    return true; // checkbox visible
                   }

                   return true;
                 }
            }  //renderer            
        }, {
            headerText : "<spring:message code='sys.grid.headerTxt' arguments='User Defined #1' htmlEscape='false'/>",
              children : [ {
                              dataField : "funcUserDfn1",
                              headerText : "<spring:message code='sys.grid.headerTxt' arguments='Checked' htmlEscape='false'/>",
                              editable : true,
                              renderer : 
                              {
                                  type : "CheckBoxEditRenderer",
                                  showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                  editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                  checkValue : "Y", // true, false 인 경우가 기본
                                  unCheckValue : "N",
                                  // 체크박스 Visible 함수
                                  visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                                   {
                                     if(item.funcUserDfn1 == "Y")  
                                     {
                                      return true; // checkbox visible
                                     }
                                     return true;
                                   }
                              }  //renderer
                            }, {
                              dataField : "descUserDfn1",
                              headerText : "<spring:message code='sys.grid.headerTxt' arguments='Desc1' htmlEscape='false'/>",
                              cellMerge: true,                              
                            } 
                         ]
          } , {
              headerText : "<spring:message code='sys.grid.headerTxt' arguments='User Defined #2' htmlEscape='false'/>",
                children : [ {
                                dataField : "funcUserDfn2",
                                headerText : "<spring:message code='sys.grid.headerTxt' arguments='Checked' htmlEscape='false'/>",
                                editable : true,
                                renderer : 
                                {
                                    type : "CheckBoxEditRenderer",
                                    showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                    editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                    checkValue : "Y", // true, false 인 경우가 기본
                                    unCheckValue : "N",
                                    // 체크박스 Visible 함수
                                    visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                                     {
                                       if(item.funcUserDfn2 == "Y")  
                                       {
                                        return true; // checkbox visible
                                       }

                                       return true;
                                     }
                                }  //renderer
                              }, {
                                dataField : "descUserDfn2",
                                headerText : "<spring:message code='sys.grid.headerTxt' arguments='Desc2' htmlEscape='false'/>",
                              } 
                           ]
            }, {
                headerText : "<spring:message code='sys.grid.headerTxt' arguments='User Defined #3' htmlEscape='false'/>",
                  children : [ {
                                  dataField : "funcUserDfn3",
                                  headerText : "<spring:message code='sys.grid.headerTxt' arguments='Checked' htmlEscape='false'/>",
                                  editable : true,
                                  renderer : 
                                  {
                                      type : "CheckBoxEditRenderer",
                                      showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                      editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                      checkValue : "Y", // true, false 인 경우가 기본
                                      unCheckValue : "N",
                                      // 체크박스 Visible 함수
                                      visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                                       {
                                         if(item.funcUserDfn3 == "Y")  
                                         {
                                          return true; // checkbox visible
                                         }

                                         return true;
                                       }
                                  }  //renderer
                                }, {
                                  dataField : "descUserDfn3",
                                  headerText : "<spring:message code='sys.grid.headerTxt' arguments='Desc3' htmlEscape='false'/>",
                                } 
                             ]
              }, {
                  headerText : "<spring:message code='sys.grid.headerTxt' arguments='User Defined #4' htmlEscape='false'/>",
                    children : [ {
                                    dataField : "funcUserDfn4",
                                    headerText : "<spring:message code='sys.grid.headerTxt' arguments='Checked' htmlEscape='false'/>",
                                    editable : true,
                                    renderer : 
                                    {
                                        type : "CheckBoxEditRenderer",
                                        showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                        checkValue : "Y", // true, false 인 경우가 기본
                                        unCheckValue : "N",
                                        // 체크박스 Visible 함수
                                        visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                                         {
                                           if(item.funcUserDfn4 == "Y")  
                                           {
                                            return true; // checkbox visible
                                           }

                                           return true;
                                         }
                                    }  //renderer
                                  }, {
                                    dataField : "descUserDfn4",
                                    headerText : "<spring:message code='sys.grid.headerTxt' arguments='Desc4' htmlEscape='false'/>",
                                  } 
                               ]
                }, {
                    headerText : "<spring:message code='sys.grid.headerTxt' arguments='User Defined #5' htmlEscape='false'/>",
                      children : [ {
                                      dataField : "funcUserDfn5",
                                      headerText : "<spring:message code='sys.grid.headerTxt' arguments='Checked' htmlEscape='false'/>",
                                      editable : true,
                                      renderer : 
                                      {
                                          type : "CheckBoxEditRenderer",
                                          showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                          editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                          checkValue : "Y", // true, false 인 경우가 기본
                                          unCheckValue : "N",
                                          // 체크박스 Visible 함수
                                          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
                                           {
                                             if(item.funcUserDfn5 == "Y")  
                                             {
                                              return true; // checkbox visible
                                             }

                                             return true;
                                           }
                                      }  //renderer
                                    }
                                  , {
                                      dataField : "descUserDfn5",
                                      headerText : "<spring:message code='sys.grid.headerTxt' arguments='Desc5' htmlEscape='false'/>",
                                    } 
                                 ]
                  }
                , {    
                    dataField : "pgmCode",
                    headerText : "<spring:message code='sys.grid.headerTxt' arguments='Id' htmlEscape='false'/>",
                    editable : false,
                    visible : false,
                    width : 150
                }  
    ];


//AUIGrid 메소드

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
    gAddRowCnt = gAddRowCnt + event.items.length ; 
	  console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length );
}

//Main 행 추가, 삽입
function fnAddRowPgmId() 
{
  checkboxPgmIdChangeHandler("hide");
  
  var item = new Object(); 
  item.pgmCode ="";
  item.pgmName ="";
  item.pgmPath ="";  
  item.pgmDesc ="";
  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
  
  AUIGrid.addRow(myGridID, item, "first");
}

//Sub
function fnAddRowTrans() 
{
  if ($("#paramPgmId").val().length == 0)
	{
	   alert("choose the programID");
	   return false;
	}

  gAddRowCnt = gAddRowCnt +1;
  
  if ( gAddRowCnt > 1)
  {
    alert("Only One Add..." );
    return false;
  }
	
	var item = new Object();
	item.funcView  = "N";
	item.funcChng  = "N";
	item.funcPrt   = "N";
	item.funcUserDfn1 ="N";
	item.descUserDfn1 ="";
	item.funcUserDfn2 ="N";
	item.descUserDfn2 ="";
	item.funcUserDfn3 ="N";
	item.descUserDfn3 ="";
	item.funcUserDfn4 ="N";
	item.descUserDfn4 ="";
	item.funcUserDfn5 ="N";
	item.descUserDfn5 ="";
  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
  AUIGrid.addRow(transGridID, item, "first");
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

//행 삭제 메소드
function removeRow() 
{
  AUIGrid.removeRow(myGridID,"selectedIndex");
}

//Make Use_yn ComboList, tooltip
function getOrgDropList()
{     
	var list =  ["ORG", "LOG","SAL", "PAY", "SVC", "CCR", "CMM", "SYS", "MIS"];   
	return list;
}

function fnSetPgmIdParamSet(myGridID, rowIndex)
{
	$("#paramPgmId").val(AUIGrid.getCellValue(myGridID, rowIndex, "pgmCode"));
	$("#pgmId").val(AUIGrid.getCellValue(myGridID, rowIndex, "pgmCode"));
	 
	console.log("paramPgmId: "+ $("#paramPgmId").val() + "pgmId: "+ $("#pgmId").val() );     
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


function fnSelectPgmListAjax()
{
	 fnTransGridReset();	 
	 Common.ajax("GET", "/program/selectProgramList.do"
		       , $("#MainForm").serialize()
		       , function(result) 
		       {
		          console.log("성공 data : " + result);
		          checkboxPgmIdChangeHandler("show");
		          AUIGrid.setGridData(myGridID, result);
		          if(result != null && result.length > 0)
		          {
		            fnSetPgmIdParamSet(myGridID, 0);
		          }
		       });
}

function fnSelectPgmTransListAjax()
{
	 fnTransGridReset();  
	 Common.ajax("GET", "/program/selectPgmTranList.do"
		       , $("#MainForm").serialize()
		       , function(result) 
		       {
		          console.log("성공 data : " + result);
		          //checkboxPgmIdChangeHandler("show");
		          AUIGrid.setGridData(transGridID, result);
		          if(result != null && result.length > 0)
		          {
		            fnSetPgmIdParamSet(transGridID, 0);
		            gAddRowCnt++;
		          }
		       });
}

function fnSavePgmId() 
{
	fnTransGridReset();
  Common.ajax("POST", "/program/saveProgramId.do"
        , GridCommon.getEditData(myGridID)
        , function(result) 
         {
            alert(result.data + " Count Save Success!");
            fnSelectPgmListAjax() ;
            
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

function fnUpdateTrans() 
{
	 gAddRowCnt = 0;
	 Common.ajax("POST", "/program/updateTrans.do"
        , GridCommon.getEditData(transGridID)
        , function(result) 
         {
            alert(result.data + " Count Save Success!");
            fnSelectPgmListAjax() ;
            fnSelectPgmTransListAjax();
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

//셀스타일 함수 정의
function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField) 
{
	if(value != null)
	{
	  return "aui-grid-left-column";
	}
	else
	{
		return null;
	}
}

//칼럼 숨김/해제 체크박스 핸들러
function checkboxPgmIdChangeHandler(event) 
{
  if (event == "show")
  {
	  AUIGrid.showColumnByDataField(myGridID, "pgmCode");  
	  AUIGrid.hideColumnByDataField(myGridID, "orgCode");
  }
  else  // hide
  {
	  AUIGrid.hideColumnByDataField(myGridID, "pgmCode");
	  AUIGrid.showColumnByDataField(myGridID, "orgCode");  
  }

}

function fnTransGridReset()
{
	gAddRowCnt = 0;
  AUIGrid.clearGridData(transGridID);
}

// 삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
function removeAllCancel() 
{
	$("#delCancel").hide();
	
	AUIGrid.restoreSoftRows(myGridID, "all"); 
}


function fnClear()
{ 
/* 	alert('bax');
	AUIGrid.restoreEditedCells(transGridID, 'xxxxxxxxx' ); */
}

function fnSelectTransGrid(tGrid, mGrid, evntRowIdx)
{
    var  jcnt = 5;  //view start.

    for (var icnt = 0 ; icnt < 14; icnt++)
    {
      AUIGrid.setCellValue(tGrid, 0, icnt, AUIGrid.getCellValue(mGrid, evntRowIdx, jcnt));
      if (icnt == 13)
      {
          AUIGrid.setCellValue(tGrid, 0, icnt, AUIGrid.getCellValue(mGrid, evntRowIdx, 0))
      }
      jcnt++ ;
    } 
}

var myGridID, transGridID;

$(document).ready(function()
{
    $("#pgmId").focus();
    
    $("#pgmId").keydown(function(key) 
    {
          if (key.keyCode == 13) 
          {
            fnSelectPgmListAjax();
          }

    });

/***************************************************[ Main GRID] ***************************************************/    

    var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  // 셀 병합 실행
                  enableCellMerge : true,
                  selectionMode : "multipleRows",
                  // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
                  rowSelectionWithMerge : true,
                  editable : true
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
        $("#paramPgmId").val("");
        AUIGrid.clearGridData(transGridID);
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedParamPgmId: " + $("#paramPgmId").val() +" / "+ $("#paramPgmName").val());        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
        fnTransGridReset();
        
        if (AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) == true
            || String(event.value).length < 1)
        {
                alert("Program ID Confirm!!");
                $("#paramPgmId").val("");
                return false;
        } 

        fnSetPgmIdParamSet(myGridID, event.rowIndex);
        fnSelectPgmTransListAjax();
         
    });    


/***************************************************[ Trans GRID] ***************************************************/

    var transOptions = 
        {
            usePaging : false,
            editable : true, 
         // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
            enableRestore : true,

            //툴팁 출력 지정
            showTooltip : true,
            //툴팁 마우스 대면 바로 나오도록 (0), 500mms 이후에 툴립출력(500)
            tooltipSensitivity : 0,
            softRemovePolicy : "exceptNew"            
        };
 
    // detailGrid 생성
    transGridID = GridCommon.createAUIGrid("transGrid", TransColumnLayout,"", transOptions);

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(transGridID, "cellEditBegin", auiCellEditignHandler);
    
    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(transGridID, "cellEditEnd", auiCellEditignHandler);
    
    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(transGridID, "cellEditCancel", auiCellEditignHandler);
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(transGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(transGridID, "removeRow", auiRemoveRowHandlerDetail);
    
    // cellClick event.
    AUIGrid.bind(transGridID, "cellClick", function( event ) 
    {
        console.log("transGridID CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " event_value: " + event.value +" header: " + event.headerText  ); 
        
        if (event.columnIndex == 3 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn1"] );
        }
        else if (event.columnIndex == 3 &&  event.value == "N")
        {
            AUIGrid.setCellValue(transGridID, 0, 4, "");
        }
        
        if (event.columnIndex == 5 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn2"] );
        }
        else if (event.columnIndex == 5 &&  event.value == "N")
        {
            AUIGrid.setCellValue(transGridID, 0, 6, "");
        }
        
        if (event.columnIndex == 7 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn3"] );
        }
        else if (event.columnIndex == 7 &&  event.value == "N")
        {
            AUIGrid.setCellValue(transGridID, 0, 8, "");
        }
        
        if (event.columnIndex == 9 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn4"] );
        }
        else if (event.columnIndex == 9 &&  event.value == "N")
        {
            AUIGrid.setCellValue(transGridID, 0, 10, "");
        }
        
        if (event.columnIndex == 11 &&  event.value == "Y")
        {
            AUIGrid.restoreEditedCells(transGridID, [0, "descUserDfn5"] );
        }
        else if (event.columnIndex == 11 &&  event.value == "N")
        {
            AUIGrid.setCellValue(transGridID, 0, 12, "");
        }          
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
<h2>Program Management</h2>
<ul class="right_btns">
  <li><p class="btn_blue"><a onclick="fnSelectPgmListAjax();"><span class="search"></span>Search</a></p></li>
  <!-- <li><p class="btn_blue"><a onclick="fnClear();"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
<input type ="hidden" id="paramPgmId" name="paramPgmId" value=""/>
<input type ="hidden" id="paramPgmName" name="paramPgmName" value=""/>


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
  <th scope="row">ID</th>
  <td>
  <input type="text" title="" id="pgmCode" name="pgmCode" placeholder="program id" class="w100p" />
  </td>
  <th scope="row">Name</th>
  <td>
  <input type="text" title="" id="pgmNm" name="pgmNm" placeholder="program name" class="w100p" />
  </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"></p>
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
<h3 class="pt0">Program List</h3>
<ul class="right_opt">
  <li id="delCancel"><p class="btn_grid"><a onclick="removeAllCancel();">Cancel</a></p></li>
  <li><p class="btn_grid"><a onclick="removeRow();">DEL</a></p></li>
  <li><p class="btn_grid"><a onclick="fnAddRowPgmId();">ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="fnSavePgmId();">SAVE</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="grid_wrap" style="height:650px";></div>
</article><!-- grid_wrap end -->


<aside class="title_line mt20"><!-- title_line start -->
<h3 class="pt0">Transaction</h3>
<ul class="right_opt">
  <li><p class="btn_grid"><a onclick="fnAddRowTrans();">ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="fnUpdateTrans();">SAVE</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역2 -->
 <div id="transGrid" style="height:150px";></div>
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