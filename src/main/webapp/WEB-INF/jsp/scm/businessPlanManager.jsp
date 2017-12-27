<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
  text-align:right;
}
.aui-grid-left-column {
  text-align:right;
}

</style>

<script type="text/javaScript">
var gWeekThValue = "";

$(function() 
{
	 // set Year
	  fnSelectExcuteYear();
	 // set PeriodByYear
	  fnSelectPeriodReset();
	  //setting scm teamCode ComboBox
	  fnSetSCMTeamComboBox(); 
    //stock type
	  fnSelectStockTypeComboList('15');  	  
});

function fnCallInterface()
{
  $("#intfTypeCbBox option:eq(1)").prop("selected",true);
}

function fnSelectStockTypeComboList(codeId)
{
    CommonCombo.make("scmStockType"
              , "/scm/selectComboSupplyCDC.do"  
              , { codeMasterId: codeId }       
              , ""                         
              , {  
                  id  : "codeId",     // use By query's parameter values(real value)               
                  name: "codeName",   // display
                  type: "M",
                  chooseMessage: "All"
                 }
              , "");     
}

function fnSelectExcuteYear()
{
  CommonCombo.make("scmYearCbBox"
                   , "/scm/selectExcuteYear.do" // url
                   , ""                         // input Param
                   , ""                         // selectData
                   , {  
                       id  : "year",
                       name: "year",            // option
                       chooseMessage: "Year" 
                     }
                   , ""); // callback
}

function fnSelectPeriodReset()
{
   CommonCombo.initById("scmPeriodCbBox");  // reset...
   var periodCheckBox = document.getElementById("scmPeriodCbBox");
       periodCheckBox.options[0] = new Option("Select Year And Team","");  
}

function fnChangeEventPeriod(object)
{
  console.log("version: " + object.value);
	gWeekThValue = object.value;
}

function fnChangeEventTeam(object)
{
  console.log("team: "+  object.value);  //object.length

  CommonCombo.initById("scmPeriodCbBox");  // reset... 
  
  CommonCombo.make("scmPeriodCbBox"
          , "/scm/selectVersionCbList.do"  // return value should be list..
          , $("#MainForm").serialize()  // input parameter
          , ""                         
          , {  
              id  : "ver",          
              name: "excuteDate",
              type: "S",
              chooseMessage: "Select a Version"
             }
          , "");// callBack
}

function fnSetSCMTeamComboBox()
{
	 CommonCombo.initById("scmTeamCbBox");  // reset... 
	
   CommonCombo.make("scmTeamCbBox"
                  , "/scm/selectScmTeamCode.do"
                  , {codeMasterId: 337}
                  , "" 
                  , {  
                      id  : "code",
                      name: "codeName",
                      chooseMessage: "ALL"  
                    }
                  , "");  
}

function fnValidationCheck(flag) 
{
	if (flag == "INS")
	{   //scmYearCbBox=2016, scmTeamCbBox=DST, scmPeriodCbBox=11

		 if ($("#scmYearCbBox").val().length < 1)
		 {
		   Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
		   return false;
		 }

		 if ($("#scmTeamCbBox").val().length < 1)
		 {
		   Common.alert("<spring:message code='sys.msg.necessary' arguments='TEAM' htmlEscape='false'/>");
		   return false;
		 }

	   if ($("#scmPeriodCbBox").val().length < 1) 
	   {
	     Common.alert("<spring:message code='sys.msg.necessary' arguments='VERSION' htmlEscape='false'/>");
	     return false;
	   }		 

	}
	
}

function fnSaveUpd()
{
	  Common.ajax("POST", "/scm/saveBizPlanStockGrid.do"
	        , GridCommon.getEditData(stockGridID)
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

function fnSaveAsIns()
{
    if (fnValidationCheck("INS") == false)
	  {
	    return false;
	  } 

	  Common.ajax("POST", "/scm/insertBizPlanMaster.do"
	        , $("#MainForm").serializeJSON()    
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

function fnChangeEventYear()
{
	fnSelectPeriodReset();
	fnSetSCMTeamComboBox();
}

function fn_uploadFile() 
{
   var formData = new FormData();
   //console.log("read_file: " + $("input[name=uploadfile]")[0].files[0]);
   
   formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
   formData.append("paramYear", $("#scmYearCbBox").val() );
   formData.append("paramTeam", $("#scmTeamCbBox").val() );
   formData.append("paramVer",  $("#scmPeriodCbBox").val() );

   //alert('read');

   Common.ajaxFile("/scm/excel/upload"
		             , formData
		             , function (result) 
		              {
		            	   Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                  });

}


// excel export
function fnExcelExport()
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName
    GridCommon.exportTo("#StockPlanGridDiv", "xlsx", "BizPlanManagement" );
}

// search
function fnSearchBtnList()
{

   console.log( "Year: " + $("#scmYearCbBox").val() +" /Team: " + $("#scmTeamCbBox").val() +" /Version: " + $("#scmPeriodCbBox").val()
       + " // Index: " + $("#scmPeriodCbBox option").index($("#scmPeriodCbBox option:selected")));

   if (fnValidationCheck("INS") == false)
   {
     return false;
   }

   var params = {
		              scmStockTypes : $('#scmStockType').multipleSelect('getSelects')
		            };

	 params = $.extend($("#MainForm").serializeJSON(), params);

   Common.ajax("POST"
             , "/scm/selectBizPlanMngerSearch.do"
             , params
             , function(result) 
               {
                  console.log("성공 fnSearchBtnList: " + result.selectBizPlanMngerList.length);
                  
                  AUIGrid.setGridData(myGridID, result.selectBizPlanMngerList);    //bizPlanManager
                  AUIGrid.setGridData(stockGridID, result.selectBizPlanStockList); //bizPlanstock
                  
                  if(result != null && result.selectBizPlanMngerList.length > 0)
                  {
                      console.log("success: " + result.selectBizPlanMngerList[0].stockCtgry); 
                  }
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
                AUIGrid.restoreEditedCells(myGridID, [event.rowIndex, "seqNo"] );
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

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) 
{
    console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

/******************************************
 **********  bizPlanGridLayout ************
 ******************************************/

var bizPlanGridLayout = 
										    [         
										      {
										         dataField : "stockCtgry",
										         headerText : "<spring:message code='sys.scm.salesplan.Category'/>",
										         cellMerge: true,
										      }
										     ,{
										         dataField : "jan",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.jan'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "feb",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.feb'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "mar",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.mar'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "apr",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.apr'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "may",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.may'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     
										     ,{
										         dataField : "jun",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.jun'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "jul",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.jul'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "agu",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.agu'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "sep",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.sep'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "oct",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.oct'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "nov",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.nov'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "dec",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.dec'/>",
					                   dataType : "numeric",
					                   formatString : "#,##0" 
										      }
										     ,{
										         dataField : "total",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.SUM'/>",
										         dataType : "numeric",
										         formatString : "#,##0" 
										      }
										    
										    ];

// footer
var bizPlanGridFooterLayout = 
				                      [ {
			                                labelText : "∑",
			                                positionField : "stockCtgry" 
			                           }
			                         , {  
			                              dataField : "jan",
			                              positionField : "jan",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "feb",
			                              positionField : "feb",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "mar",
			                              positionField : "mar",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "apr",
			                              positionField : "apr",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "may",
			                              positionField : "may",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         
			                         , {  
			                              dataField : "jun",
			                              positionField : "jun",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "jul",
			                              positionField : "jul",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "agu",
			                              positionField : "agu",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "sep",
			                              positionField : "sep",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         
			                         , {  
			                              dataField : "oct",
			                              positionField : "oct",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "nov",
			                              positionField : "nov",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "dec",
			                              positionField : "dec",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                         , {  
			                              dataField : "total",
			                              positionField : "total",
			                              operation : "SUM",
			                              formatString : "#,##0"
			                           }
			                              
			                         ]  


/******************************************
 **********  bizPlanStockGridLayout ************
 ******************************************/

var bizPlanStockGridLayout = 
										    [         
										      {
										         dataField : "planId",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.PlanID'/>",
										         editable : false,
										      }
										     ,{
										         dataField : "team",
										         headerText : "<spring:message code='sys.scm.salesplan.Team'/>",
						                 editable : false,
										      }
										     ,{
										         dataField : "stockCtgry",
										         headerText : "<spring:message code='sys.scm.salesplan.Category'/>",
										         editable : false,
										      }
                         ,{
                             dataField : "stkTypeId",
                             headerText : "<spring:message code='sys.scm.inventory.stockTypeId'/>",
                             cellMerge: true,
                          }										      
										     ,{
										         dataField : "stockCode",
										         headerText : "<spring:message code='sys.scm.salesplan.Code'/>",
										         editable : false,
										      }
										     ,{
										         dataField : "stockName",
										         headerText : "<spring:message code='sys.scm.salesplan.Name'/>",
										         style : "aui-grid-left-column",
										         editable : false,
										      }
										     ,{
										         dataField : "jan",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.jan'/>",
					                   dataType : "numeric",
					                   formatString : "#,##0"
										      }
										     ,{
										         dataField : "feb",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.feb'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "mar",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.mar'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "apr",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.apr'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "may",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.may'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     
										     ,{
										         dataField : "jun",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.jun'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "jul",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.jul'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "agu",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.agu'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "sep",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.sep'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "oct",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.oct'/>",
	                           dataType : "numeric",
	                           formatString : "#,##0"
										      }
										     ,{
										         dataField : "nov",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.nov'/>",
	                           dataType : "numeric",
	                           formatString : "#,##0"
										      }
										     ,{
										         dataField : "dec",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.dec'/>",
                             dataType : "numeric",
                             formatString : "#,##0"
										      }
										     ,{
										         dataField : "total",
										         headerText : "<spring:message code='sys.scm.bizplanmanager.SUM'/>",
										         editable : false,
										         dataType : "numeric",
										         formatString : "#,##0"
										      }
										     ,{
										         dataField : "yyyy",
										         headerText : "<spring:message code='sys.info.grid.calendar.formatYearString'/>",
										         width      : 0
										      }
										    
										    ];

// footer
var bizPlanStockGridFooterLayout = 
	                      [ {
                                labelText : "∑",
                                positionField : "stockName" 
                           }
                         , {  
                              dataField : "jan",
                              positionField : "jan",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "feb",
                              positionField : "feb",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "mar",
                              positionField : "mar",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "apr",
                              positionField : "apr",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "may",
                              positionField : "may",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         
                         , {  
                              dataField : "jun",
                              positionField : "jun",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "jul",
                              positionField : "jul",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "agu",
                              positionField : "agu",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "sep",
                              positionField : "sep",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         
                         , {  
                              dataField : "oct",
                              positionField : "oct",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "nov",
                              positionField : "nov",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "dec",
                              positionField : "dec",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                         , {  
                              dataField : "total",
                              positionField : "total",
                              operation : "SUM",
                              formatString : "#,##0"
                           }
                              
                         ]  

/****************************  Form Ready ******************************************/

var myGridID, stockGridID;

$(document).ready(function()
{
  /**********************************
   ******** Biz Plan Manager ********
  ***********************************/
  
  var bizPlanGridLayoutOptions = {
											             showFooter : true, 
											             usePaging : false,
											             showRowNumColumn : false,  // 그리드 넘버링
											             showStateColumn : false, // 행 상태 칼럼 보이기
											             softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
											             editable : false
											           };

											 
  // AUIGrid 그리드를 생성합니다.
   myGridID = GridCommon.createAUIGrid("bizPlanGridDiv", bizPlanGridLayout,"", bizPlanGridLayoutOptions);
  
  // 푸터 객체 세팅
   AUIGrid.setFooter(myGridID, bizPlanGridFooterLayout); 
  
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
    gSelRowIdx = event.rowIndex;
  
    console.log("cellClick_Status: " + AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  }); 

   
  /**********************************
   ********* Biz Plan Stock *********
  ***********************************/
  
  var bizPlanStockGridLayoutOptions = {
														             showFooter : true, 
														             usePaging : false,
														             showRowNumColumn : false,  // 그리드 넘버링
														             showStateColumn : true, // 행 상태 칼럼 보이기
														             softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
														          };

											 
  // AUIGrid 그리드를 생성합니다.
   stockGridID = GridCommon.createAUIGrid("StockPlanGridDiv", bizPlanStockGridLayout,"", bizPlanStockGridLayoutOptions);
  
  // 푸터 객체 세팅
   AUIGrid.setFooter(stockGridID, bizPlanStockGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(stockGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(stockGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(stockGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(stockGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(stockGridID, "removeRow", auiRemoveRowHandler);

  // cellClick event.
  AUIGrid.bind(stockGridID, "cellClick", function( event ) 
  {
    gSelRowIdx = event.rowIndex;
  
    console.log("cellClick_Status: " + AUIGrid.isAddedById(stockGridID,AUIGrid.getCellValue(stockGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(stockGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
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
<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
<h2>Business Plan Manager</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
  <input type ="hidden" id="planMasterId" name="planMasterId" value=""/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Year</th>
	<td>
	<select class="w100p" id="scmYearCbBox" name="scmYearCbBox" onchange="fnChangeEventYear(this);">
	</select>
	</td>
	<th scope="row">Team</th>
	<td>
  <select class="w100p" id="scmTeamCbBox" name="scmTeamCbBox" onchange="fnChangeEventTeam(this);">
  </select>
	</td>
	<th scope="row">Version</th>
	<td>
	<select class="w100p" id="scmPeriodCbBox" name="scmPeriodCbBox" onchange="fnChangeEventPeriod(this);">
	</select>
	</td>
</tr>
<!-- Stock Type 줄 추가 -->
<tr>
  <th scope="row">Stock Type</th>
  <td>
    <select class="w100p" multiple="multiple" id="scmStockType" name="scmStockType">
    </select>
  </td>
  <td colspan="4"></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn">
<%--   <a href="javascript:void(0);">
    <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" />
  </a> --%>
</p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn"><a href="javascript:void(0);">menu1</a></p></li>
		<li><p class="link_btn"><a href="javascript:void(0);">menu2</a></p></li>
		<li><p class="link_btn"><a href="javascript:void(0);">menu3</a></p></li>
		<li><p class="link_btn"><a href="javascript:void(0);">menu4</a></p></li>
		<li><p class="link_btn"><a href="javascript:void(0);">Search Payment</a></p></li>
		<li><p class="link_btn"><a href="javascript:void(0);">menu6</a></p></li>
		<li><p class="link_btn"><a href="javascript:void(0);">menu7</a></p></li>
		<li><p class="link_btn"><a href="javascript:void(0);">menu8</a></p></li>
	</ul>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="javascript:void(0);">menu1</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:void(0);">menu3</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:void(0);">menu4</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:void(0);">menu6</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:void(0);">menu7</a></p></li>
		<li><p class="link_btn type2"><a href="javascript:void(0);">menu8</a></p></li>
	</ul>
	<p class="hide_btn"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="bizPlanGridDiv"></div>
</article><!-- grid_wrap end -->

<ul class="right_btns">
<!-- 	<li><p class="btn_blue"><a href="javascript:void(0);">Create New Plan</a></p></li> -->
	<li><p class="btn_blue"><a onclick="fnSaveUpd();">Save</a></p></li>
	<li><p class="btn_blue"><a onclick="fnSaveAsIns();">Save As New Plan</a></p></li>
	<li><p class="btn_blue"><a onclick="fnExcelExport();">Download Form</a></p></li>  
</ul>
<ul class="right_btns mt10">
	<li>
	<div class="auto_file"><!-- auto_file start -->
	<input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".xlsx"/>
	</div><!-- auto_file end -->
	</li>
</ul>
<ul class="right_btns mt10">
	<li><p class="btn_blue"><a onclick="fn_uploadFile();">ExcelUpload</a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="StockPlanGridDiv"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->