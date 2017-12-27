<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!-- char js -->
<link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>

<style type="text/css">
/* 커스텀 summary total  스타일 */
.aui-grid-my-footer-sum-total {
  font-weight:bold;
  color:#4374D9;
  text-align:right;
}

.my-count-cell-style div{
  text-align:right;
  color : red;
}

.aui-grid-right-column {
  text-align:right;
}

/* 커스텀 summary total  스타일 */
.aui-grid-my-footer-sum-total {
  font-weight:bold;
  color:#4374D9;
  text-align:right;
}
.aui-grid-my-footer-sum-total2 {
  text-align:right;
}

/* HTML 템플릿에서 사용할 스타일 정의*/
.closeDiv span{
  color: red; 
  vertical-align:middle;
  font-size: 12pt;
}
.openDiv span{
  color: blue; 
  vertical-align:middle;
  font-size: 12pt;
}

/* 커스텀 칼럼 스타일 정의*/
.myLinkStyle {
    text-decoration: underline;
    color:#4374D9;
}
.myLinkStyle :hover{
  color:#FF0000;
}

</style>

<script type="text/javaScript">
var gAmtQtyFlag = "";
var ComplexChartData;
var gChartGridID, gInventoryRPTStatusGridID, gMainAmountGridID, gMainQuantityGridID, gDetailAmountGridID, gDetailQuantityGridID;
var gPrevMonth, gCurrentMonth;

$(function() 
{
   // set Year
    fnSelectExcuteYear();
    fnSelectStockTypeComboList('15');
});


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

function fnSelectStockTypeComboList(codeId)
{
    CommonCombo.make("scmStockType"
              , "/scm/selectComboSupplyCDC.do"  
              , { codeMasterId: codeId }       
              , ""                         
              , {  
                  id  : "codeName",     // use By query's parameter values                
                  name: "codeName",
                  type: "M",
                  chooseMessage: "All"
                 }
              , "");     
}


function fnChangeEventYear(object)
{
  $("#paramChartExt").val("0");
}

function fnChangeEventStockType(object)
{
  $("#paramStockType").val(object.value);
}

// excel export
function fnExcelExport()
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName
    GridCommon.exportTo("#StockPlanGridDiv", "xlsx", "BizPlanManagement" );
}

function fnComplexChartDraw(chartData)
{

	var columns = ["DAY_IN_INVENTORY", "TOT_STOCK_AMT", "AGING_AMT"];
	var arrayLabels = [];
	var dayInInventoryArray = [];
	var totStockAmtArray = [];
	var agingAmtArray = [];

	// 가로축 라벨데이타.(1 ~ 12)
  for (var i = 0; i < chartData.length; i++) 
	{ 
	   /*       console.log("label: " + chartData[i].trgetMonth + " /Line: " + chartData[i].dayInInventory+ " /totStockAmt: " + chartData[i].totStockAmt
	                 + " /agingAmt: " + chartData[i].agingAmt);
     */      
    arrayLabels.push(chartData[i].trgetMonth);
  }

  //가로축  해당하는 데이타.
  for (var i = 0; i < chartData.length; i++) 
  {
    dayInInventoryArray.push(chartData[i].dayInInventory * 1000000);  // line
    totStockAmtArray.push(chartData[i].totStockAmt);    // vertical_1
    agingAmtArray.push(chartData[i].agingAmt);          // vertical_2
  }

	var chartData = {
				            labels: arrayLabels
				            
				           ,datasets: [{
									                type: 'line',
									                label: columns[0],
									                borderColor: '#ff6384',
									                borderWidth: 2,
									                fill: false,
									                data: dayInInventoryArray
									             }
				                     , {
									                type: 'bar',
									                label: columns[1],
									                backgroundColor: '#36a2eb',
									                data: totStockAmtArray,
									                borderColor: 'white',
									                borderWidth: 2
									             }
						                 , {
									                type: 'bar',
									                label: columns[2],
									                backgroundColor: '#cc65fe',
									                data: agingAmtArray
				                       }]
				          };

	var chartID = document.getElementById("ChartCanvasID").getContext("2d");
	
    ComplexChartData = new Chart(chartID
    	                         , {
																   type: 'bar'
																  ,data: chartData
																  ,options: 
																	 {
																	    responsive: true
																	   ,title: 
																		  {
																	       display: true,
																	     //text: 'Chart.js Combo Bar Line Chart'
																      }
	                                   ,tooltips: 
	                                    {
																	      mode: 'index',
																	      intersect: true,
																	      callbacks: 
																		    {
																	        label:function(tooltipItem, data)
																	              {
																	                //console.log("tooltip: " + JSON.stringify(tooltipItem));
																	                var retVal = tooltipItem.yLabel;
																	                
																	                if(tooltipItem.datasetIndex == 0){
																	                	retVal = tooltipItem.yLabel / 1000000;
																		              }
																	                return retVal;
																	              }
																	      }
																	    }
																   }
	   
																 });
}  //fnComplexChartDraw

// search
function fnSearchBtnList()
{
   console.log( "Year: " + $("#scmYearCbBox").val() );

   if ($("#scmYearCbBox").val().length < 1)
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
     return false;
   }

   if ($("#scmMonthCbBox").val().length < 1)
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='MONTH' htmlEscape='false'/>");
     return false;
   }

   // 이전에 그리드가 생성되었다면 제거함.
    if(AUIGrid.isCreated(gChartGridID)) {
     AUIGrid.destroy(gChartGridID);
   }

   if(AUIGrid.isCreated(gInventoryRPTStatusGridID)) {
     AUIGrid.destroy(gInventoryRPTStatusGridID);
   }

   if(AUIGrid.isCreated(gMainAmountGridID)) {
     AUIGrid.destroy(gMainAmountGridID);
   }
   
   if(AUIGrid.isCreated(gMainQuantityGridID)) {
     AUIGrid.destroy(gMainQuantityGridID);
   }
   
   if(AUIGrid.isCreated(gDetailAmountGridID)) {
     AUIGrid.destroy(gDetailAmountGridID);
   } 
   
   if(AUIGrid.isCreated(gDetailQuantityGridID)) {
     AUIGrid.destroy(gDetailQuantityGridID);
   } 

   var params = {
		              scmStockTypes : $('#scmStockType').multipleSelect('getSelects')
		            };

	 params = $.extend($("#MainForm").serializeJSON(), params);
	             
   Common.ajax("POST"
             , "/scm/selectInvenRPTSearch.do"
             , params
             , function(result) 
               {
                  console.log("성공 fnSearchBtnList: " + result.selectInvenRptTotalStatusList.length
                               + "PREV_MONTH: " + result.selectPreviosMonth[0].previousMonth
                               + "CURR_MONTH: " + result.selectPreviosMonth[0].currentMonth         
                            );

                  gAmtQtyFlag ="";
                  
                  if (result.selectInvenRptTotalStatusList.length == 0)
                  {
                    Common.alert("<spring:message code='expense.msg.NoData'  htmlEscape='false'/>");
                    return true;
                  }  

                  if (result.selectPreviosMonth.length > 0)
                  {
                	  gPrevMonth = result.selectPreviosMonth[0].previousMonth;
                	  gCurrentMonth = result.selectPreviosMonth[0].currentMonth;
                  }                    
                  
                  // GridLayout Create  
                  fnDaysInventoryGridCreate(); 
                  fnMainAmountGridCreate();
                  fnDetailAmountGridCreate();
                                 
                  if(result != null && result.selectInvenRptTotalStatusList.length > 0)
                  {
                    console.log("success: " + result.selectInvenRptTotalStatusList[0].trgetYear);

                    // Status Grid-Setting.
                    AUIGrid.setGridData(gInventoryRPTStatusGridID, result.selectInvenRptTotalStatusList);
                    // Main Amount Grid-Setting.
                    AUIGrid.setGridData(gMainAmountGridID, result.selectInvenMainAmountList);
                    // Detail Amount Grid-Setting
                    AUIGrid.setGridData(gDetailAmountGridID, result.selectInvenDetailAmountList); 
                    
                    // Chart Create
                    fnComplexChartDraw(result.selectInvenRptTotalStatusList);

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

function fnDetailView(flag)
{
	console.log("fnDetailView_falg: " + flag + "  aa :" + $("#MainAmountGridDiv").width());
 
    if ($("#scmYearCbBox").val().length < 1)
    {
      Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
      return false;
    }

    if ($("#scmMonthCbBox").val().length < 1)
    {
      Common.alert("<spring:message code='sys.msg.necessary' arguments='MONTH' htmlEscape='false'/>");
      return false;
    }

	if (gAmtQtyFlag.length == 0){
    if( !AUIGrid.isCreated(gDetailAmountGridID) && ( !AUIGrid.isCreated(gDetailQuantityGridID)) ) {
    	  Common.alert("<spring:message code='sys.scm.inventory.chooseDetailData'  htmlEscape='false'/>");
        return false;
     } 
	}

    if(AUIGrid.isCreated(gDetailAmountGridID)) {
        AUIGrid.destroy(gDetailAmountGridID);
     } 

    if(AUIGrid.isCreated(gDetailQuantityGridID)) {
        AUIGrid.destroy(gDetailQuantityGridID);
      }  

	// detail Amount
 	if (flag == 'amount')
    {
        if(!AUIGrid.isCreated(gDetailAmountGridID)) 
        {
          Common.ajax("GET"
                     , "/scm/selectDetailAmountList.do"
                     , $("#MainForm").serialize()
                     , function(result) 
                       {
                         if(result != null )
                         {                            
                        	 //DetailAmountGrid Setting
                        	 fnDetailAmountGridCreate();
                           AUIGrid.setGridData(gDetailAmountGridID, result.selectDetailAmountList); 
                           AUIGrid.resize(gDetailAmountGridID, $("#DetailAmountGridDiv").width(), $("#DetailAmountGridDiv").height());
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
    }
    else  
    {   // detail Quantity
          if(!AUIGrid.isCreated(gDetailQuantityGridID)) 
          {
            Common.ajax("GET"
                       , "/scm/selectDetailQuantityList.do"
                       , $("#MainForm").serialize()
                       , function(result) 
                         {
                           if (result != null )
                           {
                             if(result.selectDetailQuantityList.length > 0)
                             {
                            	//DetailQuantityGrid Setting
                                fnDetailQuantityGridCreate();
                                AUIGrid.setGridData(gDetailQuantityGridID, result.selectDetailQuantityList); 
                                AUIGrid.resize(gDetailQuantityGridID, $("#DetailQuantityGridDiv").width(), $("#DetailQuantityGridDiv").height());
                             }

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
    } 
}

function fnSelectDetailViewGrid(gubun, stockType)
{
    if(AUIGrid.isCreated(gDetailAmountGridID)) {
        AUIGrid.destroy(gDetailAmountGridID);
     } 

    if(AUIGrid.isCreated(gDetailQuantityGridID)) {
        AUIGrid.destroy(gDetailQuantityGridID);
      } 

    $("#paramStockType").val(stockType);
    gAmtQtyFlag = gubun;
   // fnDetailView(gubun);  // amount.quantity

   
  // detail Amount
    if (gubun == 'amount')
    {
        if(!AUIGrid.isCreated(gDetailAmountGridID)) 
        {
          Common.ajax("GET"
                     , "/scm/selectDetailAmountList.do"
                     , $("#MainForm").serialize()
                     , function(result) 
                       {
                         if(result != null )
                         {                            
                           //DetailAmountGrid Setting
                           fnDetailAmountGridCreate();
                           AUIGrid.setGridData(gDetailAmountGridID, result.selectDetailAmountList); 
                           AUIGrid.resize(gDetailAmountGridID, $("#DetailAmountGridDiv").width(), $("#DetailAmountGridDiv").height());
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
    }
    else  
    {   // detail Quantity
          if(!AUIGrid.isCreated(gDetailQuantityGridID)) 
          {
            Common.ajax("GET"
                       , "/scm/selectDetailQuantityList.do"
                       , $("#MainForm").serialize()
                       , function(result) 
                         {
                           if (result != null )
                           {
                             if(result.selectDetailQuantityList.length > 0)
                             {
                              //DetailQuantityGrid Setting
                                fnDetailQuantityGridCreate();
                                AUIGrid.setGridData(gDetailQuantityGridID, result.selectDetailQuantityList); 
                                AUIGrid.resize(gDetailQuantityGridID, $("#DetailQuantityGridDiv").width(), $("#DetailQuantityGridDiv").height());
                             }

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
    }
    
}

function fnTabClick(flag)
{
    console.log("tabClick: " + flag + " /gAmtQtyFlag: " + gAmtQtyFlag + "  aa :" + $("#MainAmountGridDiv").width());
    //fnMonthlyGridCreate(MainAmountGridIDLayout,MainAmountGridFooterLayout,MainAmountGridLayoutOptions);
    //AUIGrid.setGridData(gMainQuantityGridID, gDashListData); 
    //AUIGrid.resize(gMainQuantityGridID, $("#MainAmountGridDiv").width(), $("#MainAmountGridDiv").height());
    
     if(AUIGrid.isCreated(gDetailAmountGridID)) {
            AUIGrid.destroy(gDetailAmountGridID);
    }

    if(AUIGrid.isCreated(gDetailQuantityGridID)) {
        AUIGrid.destroy(gDetailQuantityGridID);
      }  

     
      if ($("#scmYearCbBox").val().length < 1)
      {
        Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
        return false;
      }

      if ($("#scmMonthCbBox").val().length < 1)
      {
        Common.alert("<spring:message code='sys.msg.necessary' arguments='MONTH' htmlEscape='false'/>");
        return false;
      }

   if(!AUIGrid.isCreated(gMainAmountGridID)) 
   {
	   Common.alert("<spring:message code='expense.msg.NoData'  htmlEscape='false'/>");
     return true;
   }


   
   
   if (flag == 'amount')
   {
       if(!AUIGrid.isCreated(gMainAmountGridID)) 
       {
         Common.ajax("GET"
                    , "/scm/selectInvenMainAmountList.do"
                    , $("#MainForm").serialize()
                    , function(result) 
                      {
                   	   fnMainAmountGridCreate();
                                         
                        if(result != null && result.selectInvenMainAmountList.length > 0)
                        {
                          //quarter or monthly 
                          AUIGrid.setGridData(gMainAmountGridID, result.selectInvenMainAmountList); 
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
    }
    else  //qtty
    {
        // quantity
          if(!AUIGrid.isCreated(gMainQuantityGridID)) 
          {
            Common.ajax("GET"
                       , "/scm/selectInvenMainQtyList.do"
                       , $("#MainForm").serialize()
                       , function(result) 
                         {
                    	     fnMainQuantityGridCreate();

                    	     if (result != null )
                        	 {
	
	                           if (result.selectPreviosMonth.length > 0)
	                           {
	                             gPrevMonth = result.selectPreviosMonth[0].previousMonth;
	                             gCurrentMonth = result.selectPreviosMonth[0].currentMonth;
	                           }  
	                    	     
	                           if(result.selectInvenMainQtyList.length > 0)
	                           {
	                              //quarter or monthly 
	                              AUIGrid.setGridData(gMainQuantityGridID, result.selectInvenMainQtyList); 
	                           }

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
    }
    
    
}

/*************************************
 *********  Status Grid *********
**************************************/

function fnDaysInventoryGridCreate()
{
  /***** inventoryRPTGridLayout Create *****/

var inventoryRPTGridLayout = 
    [         
      {
         dataField : "trgetYear",
         headerText : "<spring:message code='budget.Year'/>",
         editable : false,
         width : "10%",
      }
     ,{
         dataField : "trgetMonth",
         headerText : "<spring:message code='budget.Month'/>",
         editable : false,
         width : "10%",
      }
     ,{
         dataField : "totStockAmt",
         headerText : "<spring:message code='sys.scm.inventory.TotalStock'/>",
         editable : false,
         dataType : "numeric",
         width : "30%",
         style : "aui-grid-right-column",         
         formatString : "#,##0.00"
      }
     ,{
         dataField : "dayInInventory",
         headerText : "<spring:message code='sys.scm.inventory.DaysInInventory'/>",
         editable : false,
         dataType : "numeric",
         width : "20%",         
         style : "aui-grid-right-column",
         formatString : "#,##0.0" 
      }
     ,{
         dataField : "agingAmt",
         headerText : "<spring:message code='sys.scm.inventory.totalAging'/>",
         editable : false,
         dataType : "numeric",
         width : "30%",
         style : "aui-grid-right-column",         
         formatString : "#,##0.00"
      }
    
    ];
// inventoryRPTGridLayout 

// footer
var inventoryRPTGridFooterLayout = [
                                 {
                                	    labelText : "∑",
                                      positionField : "trgetYear" 
                                 }
                               , {  
                                    dataField : "totStockAmt",
                                    positionField : "totStockAmt",
                                    operation : "SUM",
                                    style : "aui-grid-right-column",
                                    formatString : "#,##0.00"
                                 }
                               , {  
                                    dataField : "dayInInventory",
                                    positionField : "dayInInventory",
                                    operation : "SUM",
                                    style : "aui-grid-right-column",
                                    formatString : "#,##0.0"
                                 }
                               , {  
                                    dataField : "agingAmt",
                                    positionField : "agingAmt",
                                    operation : "SUM",
                                    style : "aui-grid-right-column",
                                    formatString : "#,##0.00"
                                 }
                                    
                           ]  

  
  var InventoryRPTGridOptions = {
                                showFooter : true, 
                                usePaging  : false,
                                showRowNumColumn : false,  // 그리드 넘버링
                                showStateColumn  : true, // 행 상태 칼럼 보이기
                                softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
                              };
  
  
  // AUIGrid 그리드를 생성합니다.
  gInventoryRPTStatusGridID = GridCommon.createAUIGrid("InventoryRPTStatusGridDiv", inventoryRPTGridLayout,"", InventoryRPTGridOptions);
  
  // 푸터 객체 세팅
  AUIGrid.setFooter(gInventoryRPTStatusGridID, inventoryRPTGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gInventoryRPTStatusGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gInventoryRPTStatusGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gInventoryRPTStatusGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gInventoryRPTStatusGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gInventoryRPTStatusGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gInventoryRPTStatusGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gInventoryRPTStatusGridID,AUIGrid.getCellValue(gInventoryRPTStatusGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gInventoryRPTStatusGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  
}



/*************************************
 *********  MainAmount Grid *********
**************************************/
function fnMainAmountGridCreate()
{
  /***** MainAmountGridIDLayout Create *****/
  
   var MainAmountGridIDLayout = 
                        [
                           {
                               dataField : "stockType",
                               headerText : "<spring:message code='sys.scm.interface.stockType'/>",
                               editable : false,
                            }
                           ,{
                               dataField : "viewDetail",
                               headerText : "<spring:message code='sys.scm.inventory.ViewDetail'/>",
                               editable : false,
                               style : "myLinkStyle",
                               // LinkRenderer 를 활용하여 javascript 함수 호출로 사용하고자 하는 경우
                               renderer : 
                                          {
                                             type : "LinkRenderer",
                                             baseUrl : "javascript", // 자바스크립 함수 호출로 사용하고자 하는 경우에 baseUrl 에 "javascript" 로 설정
                                             // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
                                             jsCallback : function(rowIndex, columnIndex, value, item) 
                                                          {
                                            	              var scmStockType = AUIGrid.getCellValue(gMainAmountGridID, rowIndex, 0);
                                                            fnSelectDetailViewGrid('amount',scmStockType);
                                                          }
                                          }
                               
                            }
                            //TOTAL STOCK 
                           ,{  
                               headerText : "<spring:message code='sys.scm.inventory.totalStock'/>",   
                               children   : [ 
                                               {
                                                   dataField : "totalAmtPrevious",
                                                   headerText : gPrevMonth,
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "totalAmtCurrent",
                                                   headerText : gCurrentMonth,
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "totalAmtGap",
                                                   headerText : "<spring:message code='sys.scm.inventory.gap'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               
                                            ]
                             } 
                           // IN TRANSIT 
                            ,{
                               headerText : "<spring:message code='sys.scm.inventory.InTransit'/>", 
                               children   : 
                                           [
                                              { 
                                                  dataField : "inTransitPrevious",
                                                  headerText : gPrevMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "inTransitCurrent",
                                                  headerText : gCurrentMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "totalAmtGap",
                                                  headerText : "<spring:message code='sys.scm.inventory.gap'/>",
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                           ] // chilren
                             }
                            //ON HAND
                            ,{
                                headerText : "<spring:message code='sys.scm.inventory.OnHand'/>", 
                                children   : 
                                            [
																							{ 
																							    dataField : "onHandPrevious",
																							    headerText : gPrevMonth,
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0.00",
																							    editable : false,
																							 }
																							,{
																							    dataField : "onHandCurrent",
																							    headerText : gCurrentMonth,
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0.00",
																							    editable : false,
																							 }
																							,{
																							    dataField : "onHandGap",
																							    headerText : "<spring:message code='sys.scm.inventory.gap'/>",
																							    dataType : "numeric",
																							    style : "aui-grid-right-column",
																							    formatString : "#,##0.00",
																							    editable : false,
																							 }

                                            ]
                                  
                             }
                          
                        // STOCK B
                           ,{  
                               headerText : "<spring:message code='sys.scm.inventory.STOCKB'/>",  
                               children   : [ 
                                              { 
                                                  dataField : "stockbPrevious",
                                                  headerText : gPrevMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "stockbCurrent",
                                                  headerText : gCurrentMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "stockbGap",
                                                  headerText : "<spring:message code='sys.scm.inventory.gap'/>",
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                            ]
                             }   
                           //Days In Inventory                            
                            ,{
                               headerText : "<spring:message code='sys.scm.inventory.DaysInInventory'/>", 
                               children   : [ 
                                               { 
                                                  dataField : "diiPrevious",
                                                  headerText : gPrevMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "diiCurrent",
                                                  headerText : gCurrentMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "diiGap",
                                                  headerText : "<spring:message code='sys.scm.inventory.gap'/>",
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }  
                                            ]
                                   }                                  
                                // Aging                                           
                                  ,{
                                     headerText : "<spring:message code='sys.scm.inventory.Aging'/>",
                                      children   : [ 
																											{ 
																											    dataField : "agingAmtPrev",
																											    headerText : gPrevMonth,
																											    style : "aui-grid-right-column",
																											    dataType : "numeric",
																											    formatString : "#,##0.00",
																											    editable : false,
																											 }
																											,{
																											    dataField : "agingAmtCurr",
																											    headerText : gCurrentMonth,
																											    style : "aui-grid-right-column",
																											    dataType : "numeric",
																											    formatString : "#,##0.00",
																											    editable : false,
																											 }
																											,{
																											    dataField : "agingAmtGap",
																											    headerText : "<spring:message code='sys.scm.inventory.gap'/>",
																											    dataType : "numeric",
																											    style : "aui-grid-right-column",
																											    formatString : "#,##0.00",
																											    editable : false,
																											 }  
																									 ]
                                   }
                        ];
   // MainAmountGridIDLayout 
   
   var MainAmountGridLayoutOptions = {
            usePaging : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            // 그룹핑 후 셀 병함 실행
            enableCellMerge : true, 
            // 그룹핑 패널 사용
            useGroupingPanel : false,
         };
  
  
  // AUIGrid 그리드를 생성합니다.
  gMainAmountGridID = GridCommon.createAUIGrid("MainAmountGridDiv", MainAmountGridIDLayout,"", MainAmountGridLayoutOptions);
  
  // 푸터 객체 세팅
  //AUIGrid.setFooter(gMainAmountGridID, MainAmountGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gMainAmountGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gMainAmountGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gMainAmountGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gMainAmountGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gMainAmountGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gMainAmountGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gMainAmountGridID,AUIGrid.getCellValue(gMainAmountGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gMainAmountGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  
  
}

/*************************************
 *********  MainQuantity Grid *********
**************************************/
function fnMainQuantityGridCreate()
{
  /***** MainQuantityGridIDLayout Create *****/
  
   var MainQuantityGridIDLayout = 
                        [
                           {
                               dataField : "stockType",
                               headerText : "<spring:message code='sys.scm.interface.stockType'/>",
                               editable : false,
                            }
                           ,{
                               dataField : "viewDetail",
                               headerText : "<spring:message code='sys.scm.inventory.ViewDetail'/>",
                               editable : false,
                               style : "myLinkStyle",
                               // LinkRenderer 를 활용하여 javascript 함수 호출로 사용하고자 하는 경우
                               renderer : 
                                          {
                                             type : "LinkRenderer",
                                             baseUrl : "javascript", // 자바스크립 함수 호출로 사용하고자 하는 경우에 baseUrl 에 "javascript" 로 설정
                                             // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
                                             jsCallback : function(rowIndex, columnIndex, value, item) 
                                                          {
                                            	              var scmStockType = AUIGrid.getCellValue(gMainQuantityGridID, rowIndex, 0);
                                                            fnSelectDetailViewGrid('quantity',scmStockType);
                                                          }
                                          }
                               
                            }
                            //TOTAL STOCK 
                           ,{  
                               headerText : "<spring:message code='sys.scm.inventory.totalStock'/>",   
                               children   : [ 
                                               {
                                                   dataField : "totalQtyPrevious",
                                                   headerText : gPrevMonth,
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "totalQtyCurrent",
                                                   headerText : gCurrentMonth,
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "totalQtyGap",
                                                   headerText : "<spring:message code='sys.scm.inventory.gap'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               
                                            ]
                             } 
                           // IN TRANSIT 
                            ,{
                               headerText : "<spring:message code='sys.scm.inventory.InTransit'/>", 
                               children   : 
                                           [
                                              { 
                                                  dataField : "inTransitQtyPrevious",
                                                  headerText : gPrevMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "inTransitQtyCurrent",
                                                  headerText : gCurrentMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "inTransitQtyGap",
                                                  headerText : "<spring:message code='sys.scm.inventory.gap'/>",
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                           ] // chilren
                             }
                            //ON HAND
                            ,{
                                headerText : "<spring:message code='sys.scm.inventory.OnHand'/>", 
                                children   : 
                                            [
																							{ 
																							    dataField : "onHandQtyPrevious",
																							    headerText : gPrevMonth,
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0.00",
																							    editable : false,
																							 }
																							,{
																							    dataField : "onHandQtyCurrent",
																							    headerText : gCurrentMonth,
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0.00",
																							    editable : false,
																							 }
																							,{
																							    dataField : "onHandQtyGap",
																							    headerText : "<spring:message code='sys.scm.inventory.gap'/>",
																							    dataType : "numeric",
																							    style : "aui-grid-right-column",
																							    formatString : "#,##0.00",
																							    editable : false,
																							 }

                                            ]
                                  
                             }
                          
                        // STOCK B
                           ,{  
                               headerText : "<spring:message code='sys.scm.inventory.STOCKB'/>",  
                               children   : [ 
                                              { 
                                                  dataField : "stockbQtyPrevious",
                                                  headerText : gPrevMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "stockbQtyCurrent",
                                                  headerText : gCurrentMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "stockbQtyGap",
                                                  headerText : "<spring:message code='sys.scm.inventory.gap'/>",
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                            ]
                             }   
                           //Days In Inventory                            
                            ,{
                               headerText : "<spring:message code='sys.scm.inventory.DaysInInventory'/>", 
                               children   : [ 
                                               { 
                                                  dataField : "diiQtyPrevious",
                                                  headerText : gPrevMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "diiQtyCurrent",
                                                  headerText : gCurrentMonth,
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "diiQtyGap",
                                                  headerText : "<spring:message code='sys.scm.inventory.gap'/>",
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  formatString : "#,##0.00",
                                                  editable : false,
                                               }  
                                            ]
                                   }                                  
                                // Aging                                           
                                  ,{
                                     headerText : "<spring:message code='sys.scm.inventory.Aging'/>",
                                      children   : [ 
																											{ 
																											    dataField : "agingQtyPrevious",
																											    headerText : gPrevMonth,
																											    style : "aui-grid-right-column",
																											    dataType : "numeric",
																											    formatString : "#,##0.00",
																											    editable : false,
																											 }
																											,{
																											    dataField : "agingQtyCurrent",
																											    headerText : gCurrentMonth,
																											    style : "aui-grid-right-column",
																											    dataType : "numeric",
																											    formatString : "#,##0.00",
																											    editable : false,
																											 }
																											,{
																											    dataField : "agingQtyGap",
																											    headerText : "<spring:message code='sys.scm.inventory.gap'/>",
																											    dataType : "numeric",
																											    style : "aui-grid-right-column",
																											    formatString : "#,##0.00",
																											    editable : false,
																											 }  
																									 ]
                                   }
                        ];
   // MainQuantityGridIDLayout 
   
   var MainQuantityGridLayoutOptions = {
            usePaging : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            // 그룹핑 후 셀 병함 실행
            enableCellMerge : true, 
            // 그룹핑 패널 사용
            useGroupingPanel : false,
         };
  
  
  // AUIGrid 그리드를 생성합니다.
  gMainQuantityGridID = GridCommon.createAUIGrid("MainQtyGridDiv", MainQuantityGridIDLayout,"", MainQuantityGridLayoutOptions);
  
  // 푸터 객체 세팅
  //AUIGrid.setFooter(gMainQuantityGridID, MainAmountGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gMainQuantityGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gMainQuantityGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gMainQuantityGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gMainQuantityGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gMainQuantityGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gMainQuantityGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gMainQuantityGridID,AUIGrid.getCellValue(gMainQuantityGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gMainQuantityGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  
  
}


/*************************************
 *********  DetailAmount Grid *********
**************************************/
function fnDetailAmountGridCreate()
{
  /***** fnDetailAmountGridCreate Create *****/
  
   var fnDetailAmountGridLayout = 
                        [
                           {
                               dataField : "stockType",
                               headerText : "<spring:message code='sys.scm.interface.stockType'/>",
                               editable : false,
                            }
                           ,{
                               dataField : "stockCode",
                               headerText : "<spring:message code='sys.scm.pomngment.stockCode'/>",
                               editable : false,
                            }
                           ,{
                               dataField : "stockName",
                               headerText : "<spring:message code='sys.scm.pomngment.stockName'/>",
                               editable : false,
                            }
                            //Current Month
                           ,{  
                               headerText : "<spring:message code='sys.scm.inventory.CurrentMonth'/>",   
                               children   : [ 
                                               {
                                                   dataField : "currentTotalStock",
                                                   headerText : "<spring:message code='sys.scm.inventory.totalStock'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "isAmtCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.InTransit'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "ohAmtCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.OnHand'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "dyasInCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.DaysInInventory'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "agingAmtCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.Aging'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "sbAmtCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.STOCKB'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                           // Issued(M-3)
                                              ,{
                                                   dataField : "m3AmtCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.IssuedM3'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                              ,{
                                                   dataField : "m2AmtCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.IssuedM2'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                              ,{
                                                   dataField : "m1AmtCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.IssuedM1'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                              ,{
                                                   dataField : "m0AmtCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.IssuedM0'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               
                                            ]
                             } 
                           // Previous Month
                            ,{
                               headerText : "<spring:message code='sys.scm.inventory.PreviousMonth'/>", 
                               children   : 
                                           [
                                               {
                                                   dataField : "previousTotalStock",
                                                   headerText : "<spring:message code='sys.scm.inventory.totalStock'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "isAmtPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.InTransit'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "ohAmtPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.OnHand'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "dyasInPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.DaysInInventory'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "agingAmtPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.Aging'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "sbAmtPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.STOCKB'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                           ] // chilren
                             }
                            
                        ];
   // fnDetailAmountGridCreate 
   
   var DetailAmountGridLayoutOptions = {
            usePaging : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            // 그룹핑 후 셀 병함 실행
            enableCellMerge : true, 
            // 그룹핑 패널 사용
            useGroupingPanel : false,
         };
  
  
  // AUIGrid 그리드를 생성합니다.
  gDetailAmountGridID = GridCommon.createAUIGrid("DetailAmountGridDiv", fnDetailAmountGridLayout,"", DetailAmountGridLayoutOptions);
  
  // 푸터 객체 세팅
  //AUIGrid.setFooter(gDetailAmountGridID, MainAmountGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gDetailAmountGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gDetailAmountGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gDetailAmountGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gDetailAmountGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gDetailAmountGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gDetailAmountGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gDetailAmountGridID,AUIGrid.getCellValue(gDetailAmountGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gDetailAmountGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  

  
}// DetailAmount Grid 

/*************************************
 *********  DetailQuantity Grid *********
**************************************/
function fnDetailQuantityGridCreate()
{
  /***** fnDetailQuantityGridCreate Create *****/
  
   var fnDetailQuantityGridLayout = 
                        [
                           {
                               dataField : "stockType",
                               headerText : "<spring:message code='sys.scm.interface.stockType'/>",
                               editable : false,
                            }
                           ,{
                               dataField : "stockCode",
                               headerText : "<spring:message code='sys.scm.pomngment.stockCode'/>",
                               editable : false,
                            }
                           ,{
                               dataField : "stockName",
                               headerText : "<spring:message code='sys.scm.pomngment.stockName'/>",
                               editable : false,
                            }
                            //Current Month
                           ,{  
                               headerText : "<spring:message code='sys.scm.inventory.CurrentMonth'/>",   
                               children   : [ 
                                               {
                                                   dataField : "currentQtyTotalStock",
                                                   headerText : "<spring:message code='sys.scm.inventory.totalStock'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "isQtyCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.InTransit'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "ohQtyCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.OnHand'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "dyasInQtyCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.DaysInInventory'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "agingQtyCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.Aging'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "sbQtyCurr",
                                                   headerText : "<spring:message code='sys.scm.inventory.STOCKB'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                            // Issued(M-3)
                                               ,{
                                                    dataField : "m3QtyCurr",
                                                    headerText : "<spring:message code='sys.scm.inventory.IssuedM3'/>",
                                                    dataType : "numeric",
                                                    style : "aui-grid-right-column",
                                                    formatString : "#,##0.00",
                                                    editable : false,
                                                }
                                               ,{
                                                    dataField : "m2QtyCurr",
                                                    headerText : "<spring:message code='sys.scm.inventory.IssuedM2'/>",
                                                    dataType : "numeric",
                                                    style : "aui-grid-right-column",
                                                    formatString : "#,##0.00",
                                                    editable : false,
                                                 }
                                               ,{
                                                    dataField : "m1QtyCurr",
                                                    headerText : "<spring:message code='sys.scm.inventory.IssuedM1'/>",
                                                    dataType : "numeric",
                                                    style : "aui-grid-right-column",
                                                    formatString : "#,##0.00",
                                                    editable : false,
                                                 }
                                               ,{
                                                    dataField : "m0QtyCurr",
                                                    headerText : "<spring:message code='sys.scm.inventory.IssuedM0'/>",
                                                    dataType : "numeric",
                                                    style : "aui-grid-right-column",
                                                    formatString : "#,##0.00",
                                                    editable : false,
                                                 }                                               
                                               
                                            ]
                             } 
                           // Previous Month
                            ,{
                               headerText : "<spring:message code='sys.scm.inventory.PreviousMonth'/>", 
                               children   : 
                                           [
                                               {
                                                   dataField : "previousQtyTotalMonth",
                                                   headerText : "<spring:message code='sys.scm.inventory.totalStock'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "isQtyPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.InTransit'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "ohQtyPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.OnHand'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "dyasInQtyPrevious",
                                                   headerText : "<spring:message code='sys.scm.inventory.DaysInInventory'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "agingQtyPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.Aging'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "sbQtyPrev",
                                                   headerText : "<spring:message code='sys.scm.inventory.STOCKB'/>",
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   formatString : "#,##0.00",
                                                   editable : false,
                                                }
                                           ] // chilren
                             }
                            
                        ];
   // fnDetailQuantityGridCreate 
   
   var DetailQuantityGridLayoutOptions = {
            usePaging : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            // 그룹핑 후 셀 병함 실행
            enableCellMerge : true, 
            // 그룹핑 패널 사용
            useGroupingPanel : false,
         };
  
  
  // AUIGrid 그리드를 생성합니다.
  gDetailQuantityGridID = GridCommon.createAUIGrid("DetailQuantityGridDiv", fnDetailQuantityGridLayout,"", DetailQuantityGridLayoutOptions);
  
  // 푸터 객체 세팅
  //AUIGrid.setFooter(gDetailQuantityGridID, MainAmountGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gDetailQuantityGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gDetailQuantityGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gDetailQuantityGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gDetailQuantityGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gDetailQuantityGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gDetailQuantityGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gDetailQuantityGridID,AUIGrid.getCellValue(gDetailQuantityGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gDetailQuantityGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  

  
}// DetailQuantity Grid 


/*************************************
 ********* Chart Grid *********
**************************************/


/****************************  Form Ready ******************************************/

$(document).ready(function()
{
	/* $(".tap_type1[data-group='test1']>li:eq(0)>a").trigger("click");
	   $(".tap_type1[data-group='test2']>li:eq(0)>a").trigger("click"); 
	   $( ".tap_type1>li:eq(0)>a" ).trigger( "click" );
	   $( ".tap_type1>li:eq(1)>a" ).trigger( "click" );
	*/
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
<h2>Inventory Report</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
  <input type ="hidden" id="paramStockType" name="paramStockType"/>
	<input type ="hidden" id="paramChartExt" name="paramChartExt" />
	<input type ="hidden" id="paramGrp" name="paramGrp" value=""/>
	
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
		<col style="width:130px" />
		<col style="width:*" />
    <col style="width:130px" />
    <col style="width:500px" />
	</colgroup>
	<tbody>
	<tr>
		<th scope="row">Year</th>
		<td>
		  <select id="scmYearCbBox" name="scmYearCbBox" onchange="fnChangeEventYear(this);">
		  </select>
		  
			<select class="ml10" id="scmMonthCbBox" name="scmMonthCbBox">
	      <option value="" selected>Month</option>
	      <option value="1">1</option>
	      <option value="2">2</option>
	      <option value="3">3</option>
	      <option value="4">4</option>
	      <option value="5">5</option>
	      <option value="6">6</option>
	      <option value="7">7</option>
	      <option value="8">8</option>
	      <option value="9">9</option>
	      <option value="10">10</option>
	      <option value="11">11</option>
	      <option value="12">12</option>		
			</select>
		</td>
    <th scope="row">Stock Type</th>
    <td>
      <select id="scmStockType" multiple="multiple" name="scmStockType" onchange="fnChangeEventStockType(this);" class="w100p">
      </select>
    </td>
	</tr>
	</tbody>
	</table><!-- table end -->
	
	<div class="divine_auto"><!-- divine_auto start -->
	
		<div style="width:50%;">
		
			<div class="border_box" style="height:390px;"><!-- border_box start -->
		  <!-- 챠트 그리드 영역 1-->
		    <div class="chart-container">
		         <canvas id="ChartCanvasID"></canvas>
		    </div>
			</div><!-- border_box end -->
		
		</div>
		
		<div style="width:50%;">
		
			<div class="border_box" style="height:390px;"><!-- border_box start -->
				<article class="grid_wrap"><!-- grid_wrap start -->
				<!-- 그리드 영역 2-->
				 <div id="InventoryRPTStatusGridDiv" style="height:380px"></div>
				</article><!-- grid_wrap end -->
			</div><!-- border_box end -->
		
		</div>
	
	</div><!-- divine_auto end -->
	
	
	<section class="tap_wrap"><!-- tap_wrap start -->
	<ul class="tap_type1" data-group="test1">
		<li><a onclick="fnTabClick('amount');" class="on">Amount(MYR)</a></li>
		<li><a onclick="fnTabClick('quantity');" >Quantity(EA)</a></li>
	</ul>
	
	<article class="tap_area"><!-- tap_area start -->
	
		<article class="grid_wrap"><!-- grid_wrap start -->
		<!-- 그리드 영역 3-->
		 <div id="MainAmountGridDiv"></div>
		</article><!-- grid_wrap end -->
	
	</article><!-- tap_area end -->
	
	<article class="tap_area"><!-- tap_area start -->
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	  <!-- 그리드 영역 3_1-->
	   <div id="MainQtyGridDiv" style="width:100%"></div>
	</article><!-- grid_wrap end -->
	
	</article><!-- tap_area end -->
	
	</section><!-- tap_wrap end -->
	
	<section class="tap_wrap"><!-- tap_wrap start -->
	<ul class="tap_type1" data-group="test2">
		<li><a onclick="fnDetailView('amount');" class="on">Amount(MYR)</a></li>
		<li><a onclick="fnDetailView('quantity');" >Quantity(EA)</a></li>
	</ul>
	
	<article class="tap_area"><!-- tap_area start -->
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	  <!-- 그리드 영역 4-->
	   <div id="DetailAmountGridDiv"></div>
	</article><!-- grid_wrap end -->
	
	</article><!-- tap_area end -->
	
	<article class="tap_area"><!-- tap_area start -->
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	  <!-- 그리드 영역 4_1-->
	   <div id=DetailQuantityGridDiv></div>
	</article><!-- grid_wrap end -->
	
	</article><!-- tap_area end -->
	
	</section><!-- tap_wrap end -->
	
	<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
	<p class="show_btn">
	<%--  <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a> --%>
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

</section><!-- content end -->