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
var gSelMstRolLvl = "";
var gAuthList =   ["EXT", "INT", "MGR"];
var validFrom;
var validTo;

$(function() 
{
	fnSelectJustRoleListAjax();
});

var MainColumnLayout = 
    [      
        {    
        	  dataField : "roleId",
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleId' />",
            editable : false,
            width : 80
        }, {
        	  dataField : "roleName",
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleName' />",
            style : "aui-grid-left-column",
            editable : false,
            width : 400
        }, {
        	  dataField : "roleLev",
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleLevel' />",
            editable : false,
            width : 70
        },{
            dataField : "hidden",
            headerText : "",
            width : 0
          } 
    ];
    
var AuthColumnLayout = 
    [      
        {    
            dataField : "authCode",
            headerText : "<spring:message code='sys.auth.grid1.Code'/>",
            editable : true,
            editRenderer : {
                type : "DropDownListRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                list : gAuthList
            },
            width : 80
        }, {
            dataField : "authName", 
            headerText : "<spring:message code='sys.auth.grid1.authName'/>",
            width : 200,
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
/*                     switch(rowIndex ) 
                    {
                      case 0:
                        return null;
                        break;
                      case 1:
                        return null;
                        break;
                      default:
                        return "${pageContext.request.contextPath}/resources/images/common/normal_search.png";
                        break;
                    }   */              
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
            dataField : "roleId",   
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleId' />",
            editable : false,
            width : 0,
        }, {
        	  dataField : "roleLvl",   
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleLevel' />",
            editable : false,
            width : 70
        }, {
            dataField : "fromDt",
            headerText : "<spring:message code='sys.authRoleMapping.grid2.ValidDateFrom' />",
            style : "aui-grid-left-column",
            dataType : "date",
            formatString : "dd-mmm-yyyy",
            width:130,
            editable : true,
            editRenderer : {
              type : "CalendarRenderer",
              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
              onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
              showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
            }
        }, {
            dataField : "toDt",
            headerText : "<spring:message code='sys.authRoleMapping.grid2.ValidDateTo' />",
            style : "aui-grid-left-column",
            dataType : "date",
            formatString : "dd-mmm-yyyy",
            width:130,
            editable : true,
            editRenderer : {
              type : "CalendarRenderer",
              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
              onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
              showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
              }
        },{
            dataField : "hidden",
            headerText : "hidden",
            editable   : true,
            width : 0
        } , {     // PK , rowid 용 칼럼
            dataField : "rowId",
            dataType : "string",
            visible : false
        },   
    ];  

// Ajax

function fnSaveRoleAuthCd() 
{
  if (fnValidationCheck() == false)
  {
    return false;
  }
  
  Common.ajax("POST", "/authorization/saveAuthRoleMapping.do"
        , GridCommon.getEditData(AuthGridID)
        , function(result) 
          {
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
            fnSearchBtnClickAjax() ;
            
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

// ROLE JustSearch(Left)
function fnSelectJustRoleListAjax()
{  
   Common.ajax("GET", "/authorization/selectRoleAuthMappingList.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(myGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetroleIdParamSet(searchRoleGridID, 0);
              }
           });
}

//SYS0054M - CellClick
function fnCellClickSelectRoleAuthListAjax()  
{
   Common.ajax("GET", "/authorization/selectRoleAuthMappingAdjustList.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(AuthGridID, result);
              if(result != null && result.length > 0)
              {
            //    fnSetRoleIdLvl(AuthGridID, 0);
            //    gAddRowCnt++;
              }
           });
}
//SYS0054M - search Click
function fnSearchBtnClickAjax()  
{
   Common.ajax("GET", "/authorization/selectSearchBtnList.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(AuthGridID, result);
              if(result != null && result.length > 0)
              {
                if ($("#roleId").val().length > 0)
                {
                  fnCellClickSelectRoleAuthListAjax();
                }
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
      
      if(event.dataField == "fromDt" || event.dataField == "toDt") 
      { 
          // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
         if(AUIGrid.isAddedById(AuthGridID, event.item.rowId) == false && (event.item.rowId =="PkAddNew")  )  // 추가된 행이기 때문에 수정 가능
         { 
            return true; 
         } 
         else if(AUIGrid.isAddedById(AuthGridID, event.item.rowId) == false && (event.item.rowId != "PkAddNew") 
                 && (authCode == "INT" || authCode == "EXT"  || authCode == "MGR") )
         { 
             //Common.alert("Can't Edit Date In 'Base Auth.' ");
             Common.alert("<spring:message code='sys.msg.cannot' arguments='Edit Date ; Base Auth.' htmlEscape='false' argumentSeparator=';'/>");
           return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임) 
         } 
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
        
        if (authSelectList.length > 0)
        {
            if (authSelectList.length = 1)
            {
              var gridAuthCode1 =  AUIGrid.getCellValue(AuthGridID, 0, "hidden");
              var gridAuthCode2 =  "";
              var gridAuthCode3 =  "";

              if (selAuthCode == gridAuthCode1)
              {
                  //Common.alert("이미 등록된 authCode.");
                  Common.alert("<spring:message code='sys.msg.already.Registered' arguments='Auth Code' htmlEscape='false'/>");
                  AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "authCode"] );
                  return false;
              }
                            
            }
            else if (authSelectList.length = 2)
            {
	              var gridAuthCode1 =  AUIGrid.getCellValue(AuthGridID, 0, "hidden");
	              var gridAuthCode2 =  AUIGrid.getCellValue(AuthGridID, 1, "hidden");
	              var gridAuthCode3 = "";
	
	              if (selAuthCode == gridAuthCode1 || selAuthCode == gridAuthCode2)
	              {
	            	  Common.alert("<spring:message code='sys.msg.already.Registered' arguments='Auth Code' htmlEscape='false'/>");
	                AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "authCode"] );
	                return false;
	              }
            }
            else 
            {
                var gridAuthCode1 =  AUIGrid.getCellValue(AuthGridID, 0, "hidden");
                var gridAuthCode2 =  AUIGrid.getCellValue(AuthGridID, 1, "hidden");
                var gridAuthCode3 =  AUIGrid.getCellValue(AuthGridID, 2, "hidden");

                console.log ("0: " + selAuthCode + " 1: "+ gridAuthCode1 + " 2: "+ gridAuthCode2 + " 3: "+ gridAuthCode3);
            
                if (selAuthCode == gridAuthCode1 || selAuthCode == gridAuthCode2 )
                {
                	Common.alert("<spring:message code='sys.msg.already.Registered' arguments='Auth Code' htmlEscape='false'/>");
                  AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "authCode"] );
                  return false;
                }
            }

            // levle-1에서만 base auth를 등록할 수 있다.
            if (selAuthCode == "MGR" || selAuthCode == "EXT" || selAuthCode == "INT")
            {
                if (gSelMstRolLvl != "1")
                {
                    //Level 1 should do.   
                    Common.alert("<spring:message code='sys.msg.Enable' arguments='1' htmlEscape='false'/>");
                    AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "authCode"] );
                    return false;
                } 
            }

            //INT와 EXT는 같이 등록 안됨
            if (selAuthCode == "INT")
            {
		           	if (gridAuthCode1 == "EXT" || gridAuthCode2 == "EXT" )
		             {
		               Common.alert("<spring:message code='sys.msg.already.Registered' arguments='EXT' htmlEscape='false'/>");
		               AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "authCode"] );
		               return false;
		             }
            }
            else if (selAuthCode == "EXT")
            {
		           	if (gridAuthCode1 == "INT" || gridAuthCode2 == "INT" )
		            {
		               Common.alert("<spring:message code='sys.msg.already.Registered' arguments='INT' htmlEscape='false'/>");
		               AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "authCode"] );
		               return false;
		            }
            }
            
            // EXT가 존재하면 MGR은 등록되면 안된다
            if (selAuthCode == "MGR")  
            {
                // INT만이 MGR 등록이 가능하다.
                if (gridAuthCode1 != "INT" && gridAuthCode2 != "INT" )
                {
                	//The {0} Must Exist.
                	Common.alert("<spring:message code='sys.msg.Exists' arguments='INT' htmlEscape='false'/>");
                	AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "authCode"] );
                  return false;
                }                 
            }
            
            // 
            if (selAuthCode == "EXT") 
            {
              AUIGrid.setCellValue(AuthGridID, event.rowIndex, 1, "Base Auth - External");
              AUIGrid.setCellValue(AuthGridID, event.rowIndex, 2,  $("#roleId").val());
            }
            else if (selAuthCode == "MGR") 
            {
            	AUIGrid.setCellValue(AuthGridID, event.rowIndex, 1, "Base Auth - Manager");
            	AUIGrid.setCellValue(AuthGridID, event.rowIndex, 2,  $("#roleId").val());
            }
            else if (selAuthCode == "INT") 
            {
            	AUIGrid.setCellValue(AuthGridID, event.rowIndex, 1, "Base Auth - Intenal");
            	AUIGrid.setCellValue(AuthGridID, event.rowIndex, 2,  $("#roleId").val());
            }
        }

        if ( (event.headerText = "Valid_From" && event.columnIndex == 4)  )
        {
           validFrom =  event.value;
        }
        else if (event.headerText = "Valid_To" && event.columnIndex == 5)
        {
            validTo =  event.value;
        }

        if ( validFrom == undefined || validFrom == "")
        {
        	validFrom = AUIGrid.getCellValue(AuthGridID, event.rowIndex, "fromDt");
        }  
        
        if ( validTo == undefined || validTo == "")
        {
        	validTo = AUIGrid.getCellValue(AuthGridID, event.rowIndex, "toDt");
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
            if (parseInt(validFrom) >= parseInt(validTo) )
            {
               Common.alert("<spring:message code='sys.msg.limitMore' arguments='FROM DATE ; TO DATE.' htmlEscape='false' argumentSeparator=';'/>");
               //AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "fromDt"] );   
               //AUIGrid.restoreEditedCells(AuthGridID, [event.rowIndex, "toDt"] );  
              // AUIGrid.setCellValue(AuthGridID, event.rowIndex, event.columnIndex, "");
               AUIGrid.setCellValue(AuthGridID, event.rowIndex, event.columnIndex, "");
               //validFrom = "";
               validTo = ""; 
               return false;
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
  if( $("#roleId").val().length == 0 )
  {
      Common.alert("<spring:message code='sys.msg.first.Select' arguments='RoleId' htmlEscape='false'/>");
      return false;
  }
	
  var item = new Object();
  
      item.authCode ="";
      item.authName ="";
      item.roleId   ="";
      item.rollvl   ="";
      item.fromDt   ="";
      item.toDt     ="";
      item.hidden   ="";
      item.rowId   ="PkAddNew";
      // parameter
      // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
      // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
      AUIGrid.addRow(AuthGridID, item, "last");
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
   if ($("#roleId").val().length < 1)
	 {
     //Common.alert("Role을 먼저 선택하시기 바랍니다.");
     Common.alert("<spring:message code='sys.msg.first.Select' arguments='Role' htmlEscape='false'/>");
     return false;
	 }
	  
   var popUpObj = Common.popupDiv("/authorization/searchRoleAuthMappingPop.do"
	       , $("#MainForm").serializeJSON()
	       , null
	       , true  
	       , "searchRoleAuthMappingPop"
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
      var roleId    = addList[i].roleId;
      var fromDt    = addList[i].fromDt;
      var toDt      = addList[i].toDt;  
      
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
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth authName' htmlEscape='false'/>");
        break;
      }

      if (fromDt == "" || fromDt == undefined  ) 
      {
        result = false;
        Common.alert("<spring:message code='sys.msg.necessary' arguments='From Date' htmlEscape='false'/>");
        break;
      }        
      
      if (toDt == "" || toDt ==  undefined ) 
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
        var roleId    = udtList[i].roleId;
        var hiddenCode  = udtList[i].hidden;
        var fromDt  = udtList[i].fromDt;
        var toDt    = udtList[i].toDt;  

        if (authCode == "" || authCode.length == 0) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }

        if (hiddenCode == "" || hiddenCode.length == 0) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }
        
        if (hiddenCode != authCode ) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
          break;
        }        
        
        if (fromDt == "" || fromDt.length == 0  ) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='From Date' htmlEscape='false'/>");
          break;
        }        
        
        if (toDt == "" || toDt.length == 0  ) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='To Date' htmlEscape='false'/>");
          break;
        }        
      
        
    }// udtlist

    for (var i = 0; i < delList.length; i++) 
    {
        var authCode  = delList[i].authCode;
        
        if (authCode == "" || authCode.length == 0 ) 
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

function fnAuthMappingGridReset()
{
  gAddRowCnt = 0;
  AUIGrid.clearGridData(AuthGridID);
}


function fnSetRoleIdLvl(myGridID, rowIndex)
{
  $("#roleId").val(AUIGrid.getCellValue(myGridID, rowIndex, "roleId"));

  gSelMstRolLvl = AUIGrid.getCellValue(myGridID, rowIndex, "roleLev");
  
  console.log("search_cell_click: "+ $("#roleId").val() + "CodeMstCd: "+ $("#CodeMasterId").val() +" gSelMstRolLvl: " +  gSelMstRolLvl );     
}



/****************************  Form Ready ******************************************/

var myGridID, AuthGridID;

$(document).ready(function()
{ 
	$("#roleId").focus();
    
  $("#roleId").bind("keyup", function() 
  {
      $(this).val($(this).val().toUpperCase());
  });
 
  $("#roleId").keydown(function(key) 
  {
	  if (key.keyCode == 13) 
    {
		  fnSearchBtnClickAjax();
    } 

  }); 

/***************************************************[ Role Auth Mapping GRID] ***************************************************/    

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
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedAuthId: " + $("#selAuthId").val() );

        gSelMainRowIdx = event.rowIndex;

        fnSetRoleIdLvl(myGridID, event.rowIndex);

        fnCellClickSelectRoleAuthListAjax();
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
    });    


    $("#delCancel").hide();
    
/***************************************************[ Auth GRID] ***************************************************/    

    var AuthGridOptions = {
    		          //rowIdField : "rowId", // PK행 지정
                  usePaging : true,
                  useGroupingPanel : false,
                  selectionMode : "multipleRows",
                  // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
                  rowSelectionWithMerge : true,
                  editable : true,
                  // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
                  enableRestore : true,
                  //editBeginMode : "click", // 편집모드 클릭
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
<h2>Role Authorization Mapping</h2>
<ul class="right_btns">  
  <li><p class="btn_blue"><a onclick="fnSearchBtnClickAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="" onsubmit="return false;">    
  <input type="hidden" id="CodeMasterId" name="CodeMasterId" value="313" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:110px" />
  <col style="width:*" />
  <col style="width:110px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">Role</th>
    <td>
      <input type="text" id="roleId" name="roleId" width="250" title="" placeholder="Role Id" class="" />
    </td>
<!--   <th scope="row"></th>
  <td>
  <input type="text" title="" placeholder="" class="" />
  </td> -->
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

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">

<div class="border_box" style="height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Role Auth Mapping</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

<div style="width:50%;">

<div class="border_box" style="height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Auth Management</h3>
<ul class="right_opt">
  <li><p class="btn_grid"><a onclick="fnAuthGridIDRemoveRow();">Del</a></p></li>
  <li><p class="btn_grid"><a onclick="fnAddRow();">Add</a></p></li>  
  <li><p class="btn_grid"><a onclick="fnSaveRoleAuthCd();">SAVE</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="auth_grid_wrap"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->


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