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
var PSDChatData;
var gChartGridID, gRateGridID, gQuarterGridID, gMonthlyGridID;
var arrayQT1 = ["m1BizPlan", "m1SalesPlan"  ,"m1Orded" ,"m1Rate" ,"m2BizPlan",  "m2SalesPlan"  ,"m2Orded"  ,"m2Rate"  ,"m3BizPlan"  ,"m3SalesPlan"  ,"m3Orded"  ,"m3Rate"] ;
var arrayQT2 = ["m4BizPlan", "m4SalesPlan"  ,"m4Orded" ,"m4Rate" ,"m5BizPlan",  "m5SalesPlan"  ,"m5Orded"  ,"m5Rate"  ,"m6BizPlan"  ,"m6SalesPlan"  ,"m6Orded"  ,"m6Rate"] ;
var arrayQT3 = ["m7BizPlan", "m7SalesPlan"  ,"m7Orded" ,"m7Rate" ,"m8BizPlan",  "m8SalesPlan"  ,"m8Orded"  ,"m8Rate"  ,"m9BizPlan"  ,"m9SalesPlan"  ,"m9Orded"  ,"m9Rate"] ;
var arrayQT4 = ["m10BizPlan","m10SalesPlan" ,"m10Orded","m10Rate","m11BizPlan", "m11SalesPlan" ,"m11Orded" ,"m11Rate" ,"m12BizPlan" ,"m12SalesPlan" ,"m12Orded" ,"m12Rate"] ;

$(function() 
{
   // set Year
    fnSelectExcuteYear();
   //stock type
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


function fnChangeEventYear(object)
{
	$("#paramChartExt").val("0");
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

function fnQtMonthlyGridVisible()
{
    if ($("#paramScmQuarter").val() == "4")
    {
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT1 );
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT2 );
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT3 );
      AUIGrid.showColumnByDataField(gQuarterGridID, arrayQT4 );
    }
    else if ($("#paramScmQuarter").val() == "3")
    {
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT1 );
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT2 );
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT4 );
      AUIGrid.showColumnByDataField(gQuarterGridID, arrayQT3 );
    }
    else if ($("#paramScmQuarter").val() == "2")
    {
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT1 );
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT3 );
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT4 );
      AUIGrid.showColumnByDataField(gQuarterGridID, arrayQT2 );
    }
    else if ($("#paramScmQuarter").val() == "1")
    {
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT2 );
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT3 );
      AUIGrid.hideColumnByDataField(gQuarterGridID, arrayQT4 );
      AUIGrid.showColumnByDataField(gQuarterGridID, arrayQT1 );
    }
    else
    {
      AUIGrid.showColumnByDataField(gQuarterGridID, arrayQT1 );
      AUIGrid.showColumnByDataField(gQuarterGridID, arrayQT2 );
      AUIGrid.showColumnByDataField(gQuarterGridID, arrayQT3 );
      AUIGrid.showColumnByDataField(gQuarterGridID, arrayQT4 );        
    }
}


// excel export
function fnExcelExport()
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName
    GridCommon.exportTo("#StockPlanGridDiv", "xlsx", "BizPlanManagement" );
}

function fnDrawChart(data) {

    var BizPlan = "Biz Plan";
    var ActualSales = "Actual Sales";

    var columns = [BizPlan, ActualSales];
    var labels = [];
    var dataSets = [];
    var bizPlanOutrgt = [];
    var actualSalesOutrgt = [];

    for (var i = 0; i < data.length; i++) {
        labels.push(data[i].scmMonth);
    }

    for (var i = 0; i < data.length; i++) {
        bizPlanOutrgt.push(data[i].bizPlan);
        actualSalesOutrgt.push(data[i].actualSales);
    }

    for (var i = 0; i < columns.length; i++) 
    {
        var dataArray = [];
        var color;

        switch (columns[i]) 
        {
            case BizPlan:
                dataArray = bizPlanOutrgt;
                color = '#ff6384';
                break;
            case ActualSales:
                dataArray = actualSalesOutrgt;
                color = '#36a2eb';
                break;
            default:
                dataArray = [];
                break;
        }

        var PSDashChartData = {
                                  label: columns[i],
                                  backgroundColor: color,
                                  fill: false,
                                  data: dataArray
                                };

        dataSets.push(PSDashChartData);
    }

    var ctx = $("#netSalesChartID");
    var chartOption = {
                          type: 'line'
                         ,data: {
                                  labels: labels
                                 ,datasets: dataSets
                                }
                         ,options: {
                                      responsive: true
                                     ,hoverMode: 'index'
                                     ,stacked: false
                                     ,title: {
                                                  display: true,
                                                  text: 'Plan&Sales Chart'
                                              }
                            
                                     ,scales: {
                                                 xAxes: [{
                                                          display: true,
                                                          scaleLabel: {
                                                                        display: true,
                                                                        fontSize: 13,
                                                                        labelString: 'Month'
                                                                      }
                                                        }]
                                     
                                                ,yAxes: [{
                                                          display: true,
                                                          scaleLabel: {
                                                                          display: true,
                                                                          fontSize: 13,
                                                                          labelString: 'Quantity'
                                                                      }
                                                       }]
                                              }
                                   }
                      };


    if (PSDChatData) {
        PSDChatData.destroy();
    }

    PSDChatData = new Chart(ctx, chartOption);

    // Define a plugin to provide data labels
    Chart.plugins.register({
        afterDatasetsDraw: function(chart, easing) {
            // To only draw at the end of animation, check for easing === 1
            var ctx = chart.ctx;

            chart.data.datasets.forEach(function (dataset, i) {
                var meta = chart.getDatasetMeta(i);
                if (!meta.hidden) {
                    meta.data.forEach(function(element, index) {
                        // Draw the text in black, with the specified font
                        ctx.fillStyle = "#7f7f7f";

                        var fontSize = 12;
                        var fontStyle = Chart.defaults.global.defaultFontStyle;
                        var fontFamily = Chart.defaults.global.defaultFontFamily;
                        ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);

                        // Just naively convert to string for now
                        var dataString = dataset.data[index].toString();

                        // Make sure alignment settings are correct
                        ctx.textAlign = 'center';
                        ctx.textBaseline = 'middle';

                        var padding = 5;
                        var position = element.tooltipPosition();
                        ctx.fillText(dataString, position.x, position.y - (fontSize / 2) - padding);
                    });
                }
            });
        }
    });

}

function fn_closeNetSalesCharPop()
{
  if (PSDChatData) 
	{
    PSDChatData.destroy();
    console.log("fn_closeNetSalesCharPop : PSDChatData destroy......");
  }
}

// search
function fnSearchBtnList()
{
   if ($("#scmYearCbBox").val().length < 1)
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
     return false;
   }

   // 이전에 그리드가 생성되었다면 제거함.
   if(AUIGrid.isCreated(gChartGridID)) {
     AUIGrid.destroy(gChartGridID);
   }

   fn_closeNetSalesCharPop();
   
   if(AUIGrid.isCreated(gRateGridID)) {
     AUIGrid.destroy(gRateGridID);
   }
   if(AUIGrid.isCreated(gQuarterGridID)) {
     AUIGrid.destroy(gQuarterGridID);
   }
   if(AUIGrid.isCreated(gMonthlyGridID)) {
     AUIGrid.destroy(gMonthlyGridID);
   }

   var params = {
		              scmStockTypes : $('#scmStockType').multipleSelect('getSelects')
		            };

	 params = $.extend($("#MainForm").serializeJSON(), params);

	 Common.ajax("POST"
             , "/scm/selectPSDashSearchBtnList.do"
             , params
             , function(result) 
               {
                  console.log("성공 fnSearchBtnList: " + result.selectChartDataList.length);

                  if (result.selectChartDataList.length == 0)
                  {
                	  Common.alert("<spring:message code='expense.msg.NoData'  htmlEscape='false'/>");
                	  return true;
                  }  
                  
                  // GridLayout Create
                  fnRateGridCreate(); 
                  fnQuarterGridCreate();
                                  
                  if(result != null && result.selectQuarterRateList.length > 0)
                  {
                    console.log("success: " + result.selectQuarterRateList[0].bizPlan);

                    // Data Grid-Setting.
                    AUIGrid.setGridData(gRateGridID, result.selectQuarterRateList);
                    
                    // Chart Create
                  	fnDrawChart(result.selectChartDataList);
              	  
                    //quarter or monthly 
                    AUIGrid.setGridData(gQuarterGridID, result.selectPSDashList); 

                    $("#paramScmQuarter").val("1");
                    fnQtMonthlyGridVisible();
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

function fnSelectQtMonthlyGrid(quarterNo)
{
	  $("#paramScmQuarter").val(quarterNo);
	  $( ".tap_type1>li:eq(0)>a" ).trigger( "click" );
	  fnQtMonthlyGridVisible();
}

function fnTabClick(flag)
{   
	  if (flag == 'monthly')
		{
			  if(!AUIGrid.isCreated(gMonthlyGridID)) 
				{
				  Common.ajax("POST"
			               , "/scm/selectPSDashSearchBtnList.do"
			               , $("#MainForm").serializeJSON()
			               , function(result) 
			                 {
			                    fnMonthlyGridCreate();
			                                    
			                    if(result != null && result.selectPSDashList.length > 0)
			                    {
			                      //quarter or monthly 
			                      AUIGrid.setGridData(gMonthlyGridID, result.selectPSDashList); 
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
		{   // quarter
	        if(!AUIGrid.isCreated(gQuarterGridID)) 
	        {
	          Common.ajax("POST"
	                     , "/scm/selectPSDashSearchBtnList.do"
	                     , $("#MainForm").serializeJSON()
	                     , function(result) 
	                       {
	                    	   fnQuarterGridCreate();
	                                          
                           if(result != null && result.selectPSDashList.length > 0)
                           {
                              //quarter or monthly 
                              AUIGrid.setGridData(gQuarterGridID, result.selectPSDashList); 
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
 *********  Rate Grid *********
**************************************/

function fnRateGridCreate()
{
  /***** rateGridIDLayout Create *****/
         
var rateGridIDLayout = 
    [         
      {
         dataField : "scmQuarter",
         headerText : "<spring:message code='sys.scm.PSDashBoard.Quarter'/>",
         editable : false,
      }
     ,{
         dataField : "bizPlan",
         headerText : "<spring:message code='sys.scm.PSDashBoard.BizPlan'/>",
         editable : false,
         dataType : "numeric",
         formatString : "#,##0"
      }
     ,{
         dataField : "salesPlan",
         headerText : "<spring:message code='sys.scm.PSDashBoard.salesPlan'/>",
         editable : false,
         dataType : "numeric",
         formatString : "#,##0"
      }
     ,{
         dataField : "actualSales",
         headerText : "<spring:message code='sys.scm.PSDashBoard.actualSales'/>",
         editable : false,
         dataType : "numeric",
         formatString : "#,##0"
      }
     ,{
         dataField : "rating",
         headerText : "<spring:message code='sys.scm.PSDashBoard.Rating'/>",
         editable : false,
         dataType : "numeric",
         postfix : "%",
      }
     ,{
         dataField : "viewDetail",
         headerText : " ",
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
						                          var scmQuarter = AUIGrid.getCellValue(gRateGridID, rowIndex, 0);
						                          fnSelectQtMonthlyGrid(scmQuarter);
						                        }
                    }
         
      }
    
    ];
// rateGridIDLayout 

// footer
var rateGridFooterLayout = [
                                 {
                                      labelText : "",
                                      positionField : "scmQuarter" 
                                 }
                               , {  
                                    dataField : "bizPlan",
                                    positionField : "bizPlan",
                                    operation : "SUM",
                                    formatString : "#,##0"
                                 }
                               , {  
                                    dataField : "salesPlan",
                                    positionField : "salesPlan",
                                    operation : "SUM",
                                    formatString : "#,##0"
                                 }
                               , {  
                                    dataField : "actualSales",
                                    positionField : "actualSales",
                                    operation : "SUM",
                                    formatString : "#,##0"
                                 }
                               , {  
                                    dataField : "rating",
                                    positionField : "rating",
                                    operation : "AVG", 
                                    postfix : "%",
                                    labelFunction : function(value, columnValues, footerValues) 
                                                    { 
                                                        return value.toFixed(2) ; 
                                                    } 
 
                                 }
                                    
                           ]  

  
  var rateGridLayoutOptions = {
                                showFooter : true, 
                                usePaging  : false,
                                showRowNumColumn : false,  // 그리드 넘버링
                                showStateColumn  : true, // 행 상태 칼럼 보이기
                                softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
                              };
  
  
  // AUIGrid 그리드를 생성합니다.
  gRateGridID = GridCommon.createAUIGrid("RateGridDiv", rateGridIDLayout,"", rateGridLayoutOptions);
  
  // 푸터 객체 세팅
  AUIGrid.setFooter(gRateGridID, rateGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gRateGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gRateGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gRateGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gRateGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gRateGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gRateGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gRateGridID,AUIGrid.getCellValue(gRateGridID, event.rowIndex, 0)) );
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gRateGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  
}



/*************************************
 *********  Quarter Grid *********
**************************************/
function fnQuarterGridCreate()
{
  /***** QuarterGridIDLayout Create *****/
  
   var QuarterGridIDLayout = 
                        [
                           {
                               dataField : "grp",
                               headerText : " " ,
                               editable : false,
                            }
                           ,{
                               dataField : "stockCtgry",
                               headerText : " ",
                               editable : false,
                            }
                                    
                           ,{  //1-4Q:1~,3
                               headerText : "1",
                               children   : [ 
	                                             {
	                                                 dataField : "m1BizPlan",
	                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
	                                                 style : "aui-grid-right-column",
	                                                 dataType : "numeric",
	                                                 formatString : "#,##0",
	                                                 editable : false,
	                                              }
	                                             ,{
	                                                 dataField : "m1SalesPlan",
	                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
	                                                 style : "aui-grid-right-column",
	                                                 dataType : "numeric",
	                                                 formatString : "#,##0",
	                                                 editable : false,
	                                              }
	                                             ,{
	                                                 dataField : "m1Orded",
	                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
	                                                 style : "aui-grid-right-column",
	                                                 dataType : "numeric",
	                                                 formatString : "#,##0",
	                                                 editable : false,
	                                              }
	                                             ,{
	                                                 dataField : "m1Rate",
	                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
	                                                 dataType : "numeric",
	                                                 style : "aui-grid-right-column",
	                                                 disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
	                                                 labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
	                                                 {
                                                     if(!item) return value + "%";     
	                                                     
	                                                   // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
	                                                   if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
	                                                     
	                                                   // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
	                                                   return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
	                                                 },
	                                              }
	                                          ]
                             }  
                            ,{
                          	   headerText : "2",
                               children   : 
						                               [
						                                  { 
							                                    dataField : "m2BizPlan",
							                                    headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
							                                    style : "aui-grid-right-column",
							                                    dataType : "numeric",
							                                    formatString : "#,##0",
							                                    editable : false,
							                                 }
							                                ,{
							                                    dataField : "m2SalesPlan",
							                                    headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
							                                    style : "aui-grid-right-column",
							                                    dataType : "numeric",
							                                    formatString : "#,##0",
							                                    editable : false,
							                                 }
							                                ,{
							                                    dataField : "m2Orded",
							                                    headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
							                                    style : "aui-grid-right-column",
							                                    dataType : "numeric",
							                                    formatString : "#,##0",
							                                    editable : false,
							                                 }
							                                ,{
							                                    dataField : "m2Rate",
							                                    headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
							                                    dataType : "numeric",
							                                    style : "aui-grid-right-column",
                                                  disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                      
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
							                                 }  
						                               ] // chilren
                            
                             }
                            ,{
                             	  headerText : "3",
                                children   : 
                                	          [
								                               { 
								                                  dataField : "m3BizPlan",
								                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
								                                  style : "aui-grid-right-column",
								                                  dataType : "numeric",
								                                  formatString : "#,##0",
								                                  editable : false,
								                               }
								                              ,{
								                                  dataField : "m3SalesPlan",
								                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
								                                  style : "aui-grid-right-column",
								                                  dataType : "numeric",
								                                  formatString : "#,##0",
								                                  editable : false,
								                               }
								                              ,{
								                                  dataField : "m3Orded",
								                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
								                                  style : "aui-grid-right-column",
								                                  dataType : "numeric",
								                                  formatString : "#,##0",
								                                  editable : false,
								                               }
								                              ,{
								                                  dataField : "m3Rate",
								                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
								                                  dataType : "numeric",
								                                  style : "aui-grid-right-column",
                                                  disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                      
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
								                               }

                                            ]
                                  
                            }
                          
                        //2-4Q
                           ,{  
                               headerText : "4",
                               children   : [ 
																							{
																							    dataField : "m4BizPlan",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m4SalesPlan",
																							   headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m4Orded",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m4Rate",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
																							    dataType : "numeric",
																							    style : "aui-grid-right-column",
                                                  disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                      
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
																							 }
																						]
                             }	                             
														,{
															 headerText : "5",
								               children   : [ 
																	             {
																							    dataField : "m5BizPlan",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m5SalesPlan",
																							   headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m5Orded",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m5Rate",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
																							    dataType : "numeric",
																							    style : "aui-grid-right-column",
                                                  disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                      
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
																							 }  
																						]
																	 }			                            
																							                             
																	,{
																		 headerText : "6",
                                      children   : [ 
		                                                   {
																											    dataField : "m6BizPlan",
																											    headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
																											    style : "aui-grid-right-column",
																											    dataType : "numeric",
																											    formatString : "#,##0",
																											    editable : false,
																											 }
																											,{
																											    dataField : "m6SalesPlan",
																											   headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
																											    style : "aui-grid-right-column",
																											    dataType : "numeric",
																											    formatString : "#,##0",
																											    editable : false,
																											 }
																											,{
																											    dataField : "m6Orded",
																											    headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
																											    style : "aui-grid-right-column",
																											    dataType : "numeric",
																											    formatString : "#,##0",
																											    editable : false,
																											 }
																											,{
																											    dataField : "m6Rate",
																											    headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
																											    dataType : "numeric",
																											    style : "aui-grid-right-column",
				                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
				                                                  {
				                                                    if(!item) return value + "%";     
				                                                      
				                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
				                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
				                                                      
				                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
				                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
				                                                  },
																											 }  
                                                   ]
                                   }
                                           
                           //3-4Q
                                  ,{  
			                               headerText : "7",
			                               children   : [
				                                             {
				                                                 dataField : "m7BizPlan",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m7SalesPlan",
				                                                headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m7Orded",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m7Rate",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
				                                                 dataType : "numeric",
				                                                 style : "aui-grid-right-column",
			                                                   labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
			                                                   {
			                                                     if(!item) return value + "%";     
			                                                      
			                                                     // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
			                                                     if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
			                                                      
			                                                     // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
			                                                     return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
			                                                   },
				                                              } 
				                                           ] 
                                         }                           
                                  ,{
                                   	  headerText : "8",
                                      children   : [
                                                      {
				                                                 dataField : "m8BizPlan",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m8SalesPlan",
				                                                headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m8Orded",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m8Rate",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
				                                                 dataType : "numeric",
				                                                 style : "aui-grid-right-column",
                                                         labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                         {
                                                           if(!item) return value + "%";     
                                                            
                                                           // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                           if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                            
                                                           // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                           return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                         },
				                                              } 
                                                  ]
                                    }                                
				                           ,{
                                     	headerText : "9",
                                      children   : [
                                                      {
				                                                 dataField : "m9BizPlan",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m9SalesPlan",
				                                                headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m9Orded",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
				                                                 style : "aui-grid-right-column",
				                                                 dataType : "numeric",
				                                                 formatString : "#,##0",
				                                                 editable : false,
				                                              }
				                                             ,{
				                                                 dataField : "m9Rate",
				                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
				                                                 dataType : "numeric",
				                                                 style : "aui-grid-right-column",
                                                         labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                         {
                                                           if(!item) return value + "%";     
                                                            
                                                           // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                           if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                            
                                                           // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                           return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                         },
				                                              } 
			                                             
			                                            ]
                           } 
                           
                           //4-4Q                                                     
                           ,{
                        	     headerText : "10",
                               children   : [
																							{
																							    dataField : "m10BizPlan",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m10SalesPlan",
																							   headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m10Orded",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m10Rate",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
																							    dataType : "numeric",
																							    style : "aui-grid-right-column",
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                     
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                     
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
																							 }
                                           ]
                            }
												 	 ,{ 
														  headerText : "11",
							                children   : [
							                                {
																							    dataField : "m11BizPlan",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m11SalesPlan",
																							   headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m11Orded",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m11Rate",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
																							    dataType : "numeric",
																							    style : "aui-grid-right-column",
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                     if(!item) return value + "%";     
                                                      
                                                     // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                     if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                     // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                     return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
																							 } 
																					 ]
												 	  }	
												 	 ,{
												 		  headerText : "12",
							                children   : [
							                                {
																							    dataField : "m12BizPlan",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m12SalesPlan",
																							   headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m12Orded",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
																							    style : "aui-grid-right-column",
																							    dataType : "numeric",
																							    formatString : "#,##0",
																							    editable : false,
																							 }
																							,{
																							    dataField : "m12Rate",
																							    headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
																							    dataType : "numeric",
																							    style : "aui-grid-right-column",
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                     
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                     
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
																							 } 

                                           ]
                            }
                           
                          ];
   // QuarterGridIDLayout 
   
   
// footer
   var QuarterGridFooterLayout = [
                                 {
                                      labelText : "∑",
                                      positionField : "scmQuarter" 
                                 }
                                    
                           ]     
  
   var QuarterGridLayoutOptions = {
            showFooter : true, 
            usePaging : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            fixedColumnCount : 2  ,

            // 그룹핑 후 셀 병함 실행
            enableCellMerge : true, 
            // 그룹핑, 셀머지 사용 시 브랜치에 해당되는 행 표시 안함.
            showBranchOnGrouping : false, 
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            
            // 차례로 country, product, 순으로 그룹핑을 합니다.
            // 즉, 각 나라별, 각 제품으로 그룹핑
            groupingFields : ["grp"],
            
            // 그룹핑 후 합계필드를 출력하도록 설정합니다.
            groupingSummary : {
                // 합계 필드는 price, quantity, totalPrice 3개에 대하여 실시 합니다.(totalPrice 는 expFunction 으로 구해진 필드임)
                dataFields : [ "m1BizPlan", "m1SalesPlan",  "m1Orded", "m1Rate" 
                              ,"m2BizPlan", "m2SalesPlan",  "m2Orded", "m2Rate"
                              ,"m3BizPlan", "m3SalesPlan",  "m3Orded", "m3Rate"
                              
                              ,"m4BizPlan", "m4SalesPlan",  "m4Orded", "m4Rate"
                              ,"m5BizPlan", "m5SalesPlan",  "m5Orded", "m5Rate"
                              ,"m6BizPlan", "m6SalesPlan",  "m6Orded", "m6Rate"
                              
                              ,"m7BizPlan", "m7SalesPlan",  "m7Orded", "m7Rate"
                              ,"m8BizPlan", "m8SalesPlan",  "m8Orded", "m8Rate"
                              ,"m9BizPlan", "m9SalesPlan",  "m9Orded", "m9Rate"
                              
                              ,"m10BizPlan", "m10SalesPlan",  "m10Orded", "m10Rate"
                              ,"m11BizPlan", "m11SalesPlan",  "m11Orded", "m11Rate"
                              ,"m12BizPlan", "m12SalesPlan",  "m12Orded", "m12Rate"
                             ],
                
                // "country", "product",  순으로 그룹핑을 했을 때 해당 항목 아래에 출력되는 텍스트 지정
                //labelTexts : ["∑" ]
            },
         // 최초 보여질 때 모두 열린 상태로 출력 여부
            displayTreeOpen : true,
            summaryText : "Total",

            // 그리드 ROW 스타일 함수 정의
            rowStyleFunction : function(rowIndex, item) {
              
              if(item._$isGroupSumField) { // 그룹핑으로 만들어진 합계 필드인지 여부
                  return "my-count-cell-style";
              }
              
              return null;
            }
            
         };
  
  
  // AUIGrid 그리드를 생성합니다.
  gQuarterGridID = GridCommon.createAUIGrid("QuarterGridDiv", QuarterGridIDLayout,"", QuarterGridLayoutOptions);
  
  // 푸터 객체 세팅
  AUIGrid.setFooter(gQuarterGridID, QuarterGridFooterLayout); 

  // grouping 이벤트 바인딩
  AUIGrid.bind(gQuarterGridID, "grouping", function(event) {

    // 그룹핑 해제된 경우
    if(event.groupingFields.length == 0) {
      tempGridData = null;
      AUIGrid.update(gQuarterGridID);
      return;
    }
    tempGridData = AUIGrid.getGridData(gQuarterGridID);
    
    // 그룹핑 된 경우, 다시 업데이트 ( 평균 구하기 위함 )
    AUIGrid.update(gQuarterGridID); 
  });
  
  // 정렬을 사용할 때, 순서가 바뀌므로 평균 다시 구하기 위한 바인딩
  AUIGrid.bind(gQuarterGridID, "sorting", function(event) {
    var groupingFields = AUIGrid.getProp(gQuarterGridID, "groupingFields");
    if(groupingFields.length > 0) { // 그룹핑 된 경우만 업데이트
      tempGridData = AUIGrid.getGridData(gQuarterGridID);
      
      // 그룹핑 된 경우, 다시 업데이트 ( 평균 구하기 위함 )
      AUIGrid.update(gQuarterGridID);
    }
  });
  
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gQuarterGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gQuarterGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gQuarterGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gQuarterGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gQuarterGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gQuarterGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gQuarterGridID,AUIGrid.getCellValue(gQuarterGridID, event.rowIndex, 0)) );
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gQuarterGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  

  
}

//임시 그리드 데이터
var tempGridData = null;

//주어진 rowIndex 위로 평균 구하여 반환
function getMyAvgValue(dataField, rowIndex, ownDepth)
{
  var item;
  var sum = 0;
  var count = 0;

  if(tempGridData === null) {
    return 0;
  }
  
  for(var i=rowIndex-1; i>=0; i--) 
	{
    item = tempGridData[i];

    console.log("item: " + item +" /item._$depth: " + item._$depth);
    
    if(item._$isGroupSumField && (ownDepth >= item._$depth)) {
      break;
    }
    
    if(!item._$isGroupSumField) 
    {
      sum += item[dataField];
      count++;
    }
  }
  
  return AUIGrid.formatNumber((sum / count), "#,##0.##");
}

//주어진 rowIndex 위로 개수 구하여 반환
function getMyCntValue(dataField, rowIndex, ownDepth) {
  var item;
  var count = 0;
  
  if(tempGridData === null) {
    return 0;
  }
  
  for(var i=rowIndex-1; i>=0; i--) {
    item = tempGridData[i];
    
    if(item._$isGroupSumField && (ownDepth >= item._$depth)) {
      break;
    }
    
    if(!item._$isGroupSumField) {
      count++;
    }
  }
  
  return count;
}

/*************************************
 ********* Monthly Grid **************   
**************************************/
function fnMonthlyGridCreate()
{
  /***** MonthlyGridIDLayout Create *****/
 var MonthlyGridIDLayout = 
                        [
                           {
                               dataField : "grp",
                               headerText : " " ,
                               editable : false,
                            }
                           ,{
                               dataField : "stockCtgry",
                               headerText : " ",
                               editable : false,
                            }
                                    
                           ,{  //1-4Q:1~,3
                               headerText : "1",
                               children   : [ 
                                               {
                                                   dataField : "m1BizPlan",
                                                   headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                   style : "aui-grid-right-column",
                                                   dataType : "numeric",
                                                   formatString : "#,##0",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "m1SalesPlan",
                                                   headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                   style : "aui-grid-right-column",
                                                   dataType : "numeric",
                                                   formatString : "#,##0",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "m1Orded",
                                                   headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                   style : "aui-grid-right-column",
                                                   dataType : "numeric",
                                                   formatString : "#,##0",
                                                   editable : false,
                                                }
                                               ,{
                                                   dataField : "m1Rate",
                                                   headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                   dataType : "numeric",
                                                   style : "aui-grid-right-column",
                                                   disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                   labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                   {
                                                     if(!item) return value + "%";     
                                                       
                                                     // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                     if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                       
                                                     // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                     return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                   },
                                                }
                                            ]
                             }  
                            ,{
                               headerText : "2",
                               children   : 
                                           [
                                              { 
                                                  dataField : "m2BizPlan",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m2SalesPlan",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m2Orded",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m2Rate",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                      
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
                                               }  
                                           ] // chilren
                            
                             }
                            ,{
                                headerText : "3",
                                children   : 
                                            [
                                               { 
                                                  dataField : "m3BizPlan",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m3SalesPlan",
                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m3Orded",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m3Rate",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                      
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
                                               }

                                            ]
                                  
                            }
                          
                        //2-4Q
                           ,{  
                               headerText : "4",
                               children   : [ 
                                              {
                                                  dataField : "m4BizPlan",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m4SalesPlan",
                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m4Orded",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m4Rate",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                      
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
                                               }
                                            ]
                             }                               
                            ,{
                               headerText : "5",
                               children   : [ 
                                               {
                                                  dataField : "m5BizPlan",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m5SalesPlan",
                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m5Orded",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m5Rate",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  disableGrouping : true, // 직접적인 그룹핑 필드 대상이 될 수 없음.
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                      
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
                                               }  
                                            ]
                                   }                                  
                                                                           
                                  ,{
                                     headerText : "6",
                                      children   : [ 
                                                       {
                                                          dataField : "m6BizPlan",
                                                          headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                          style : "aui-grid-right-column",
                                                          dataType : "numeric",
                                                          formatString : "#,##0",
                                                          editable : false,
                                                       }
                                                      ,{
                                                          dataField : "m6SalesPlan",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                          style : "aui-grid-right-column",
                                                          dataType : "numeric",
                                                          formatString : "#,##0",
                                                          editable : false,
                                                       }
                                                      ,{
                                                          dataField : "m6Orded",
                                                          headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                          style : "aui-grid-right-column",
                                                          dataType : "numeric",
                                                          formatString : "#,##0",
                                                          editable : false,
                                                       }
                                                      ,{
                                                          dataField : "m6Rate",
                                                          headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                          dataType : "numeric",
                                                          style : "aui-grid-right-column",
                                                          labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                          {
                                                            if(!item) return value + "%";     
                                                              
                                                            // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                            if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                              
                                                            // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                            return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                          },
                                                       }  
                                                   ]
                                   }
                                           
                           //3-4Q
                                  ,{  
                                     headerText : "7",
                                     children   : [
                                                     {
                                                         dataField : "m7BizPlan",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m7SalesPlan",
                                                        headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m7Orded",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m7Rate",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                         dataType : "numeric",
                                                         style : "aui-grid-right-column",
                                                         labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                         {
                                                           if(!item) return value + "%";     
                                                            
                                                           // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                           if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                            
                                                           // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                           return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                         },
                                                      } 
                                                   ] 
                                         }                           
                                  ,{
                                      headerText : "8",
                                      children   : [
                                                      {
                                                         dataField : "m8BizPlan",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m8SalesPlan",
                                                        headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m8Orded",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m8Rate",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                         dataType : "numeric",
                                                         style : "aui-grid-right-column",
                                                         labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                         {
                                                           if(!item) return value + "%";     
                                                            
                                                           // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                           if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                            
                                                           // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                           return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                         },
                                                      } 
                                                  ]
                                    }                                
                                   ,{
                                      headerText : "9",
                                      children   : [
                                                      {
                                                         dataField : "m9BizPlan",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m9SalesPlan",
                                                        headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m9Orded",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                         style : "aui-grid-right-column",
                                                         dataType : "numeric",
                                                         formatString : "#,##0",
                                                         editable : false,
                                                      }
                                                     ,{
                                                         dataField : "m9Rate",
                                                         headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                         dataType : "numeric",
                                                         style : "aui-grid-right-column",
                                                         labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                         {
                                                           if(!item) return value + "%";     
                                                            
                                                           // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                           if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                            
                                                           // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                           return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                         },
                                                      } 
                                                   
                                                  ]
                           } 
                           
                           //4-4Q                                                     
                           ,{
                               headerText : "10",
                               children   : [
                                              {
                                                  dataField : "m10BizPlan",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m10SalesPlan",
                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m10Orded",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m10Rate",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                     
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                     
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
                                               }
                                           ]
                            }
                           ,{ 
                              headerText : "11",
                              children   : [
                                              {
                                                  dataField : "m11BizPlan",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m11SalesPlan",
                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m11Orded",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m11Rate",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                     if(!item) return value + "%";     
                                                      
                                                     // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                     if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                      
                                                     // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                     return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
                                               } 
                                           ]
                            } 
                           ,{
                              headerText : "12",
                              children   : [
                                              {
                                                  dataField : "m12BizPlan",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Biz'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m12SalesPlan",
                                                 headerText : "<spring:message code='sys.scm.PSDashBoard.Sales'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m12Orded",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Actual'/>",
                                                  style : "aui-grid-right-column",
                                                  dataType : "numeric",
                                                  formatString : "#,##0",
                                                  editable : false,
                                               }
                                              ,{
                                                  dataField : "m12Rate",
                                                  headerText : "<spring:message code='sys.scm.PSDashBoard.Rate'/>", 
                                                  dataType : "numeric",
                                                  style : "aui-grid-right-column",
                                                  labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField) 
                                                  {
                                                    if(!item) return value + "%";     
                                                     
                                                    // 그룹핑 행이 아닌 경우, 기본 value 출력 시킴
                                                    if(!item._$isGroupSumField) return AUIGrid.formatNumber(value, "#,##0")+ "%";     
                                                     
                                                    // 그룹핑 행인 경우, 그에 맞는 평균 구해서 반환.
                                                    return getMyAvgValue(dataField, rowIndex, item._$depth) + "%";     
                                                  },
                                               } 

                                           ]
                            }
                           
                          ];
   // MonthlyGridIDLayout 
   
   
// footer
   var MonthlyGridFooterLayout = [
                                 {
                                      labelText : "∑",
                                      positionField : "scmQuarter" 
                                 }
                                    
                           ]     
  
   var MonthlyGridLayoutOptions = {
            showFooter : true, 
            usePaging : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            fixedColumnCount : 2  ,

            // 그룹핑 후 셀 병함 실행
            enableCellMerge : true, 
            // 그룹핑, 셀머지 사용 시 브랜치에 해당되는 행 표시 안함.
            showBranchOnGrouping : false, 
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            
            // 즉, 각 나라별, 각 제품으로 그룹핑
            groupingFields : ["grp"],
            
            // 그룹핑 후 합계필드를 출력하도록 설정합니다.
            groupingSummary : {
                // 합계 필드는 price, quantity, totalPrice 3개에 대하여 실시 합니다.(totalPrice 는 expFunction 으로 구해진 필드임)
                dataFields : [ "m1BizPlan", "m1SalesPlan",  "m1Orded", "m1Rate" 
                              ,"m2BizPlan", "m2SalesPlan",  "m2Orded", "m2Rate"
                              ,"m3BizPlan", "m3SalesPlan",  "m3Orded", "m3Rate"
                              
                              ,"m4BizPlan", "m4SalesPlan",  "m4Orded", "m4Rate"
                              ,"m5BizPlan", "m5SalesPlan",  "m5Orded", "m5Rate"
                              ,"m6BizPlan", "m6SalesPlan",  "m6Orded", "m6Rate"
                              
                              ,"m7BizPlan", "m7SalesPlan",  "m7Orded", "m7Rate"
                              ,"m8BizPlan", "m8SalesPlan",  "m8Orded", "m8Rate"
                              ,"m9BizPlan", "m9SalesPlan",  "m9Orded", "m9Rate"
                              
                              ,"m10BizPlan", "m10SalesPlan",  "m10Orded", "m10Rate"
                              ,"m11BizPlan", "m11SalesPlan",  "m11Orded", "m11Rate"
                              ,"m12BizPlan", "m12SalesPlan",  "m12Orded", "m12Rate"
                             ],
                
            },
         // 최초 보여질 때 모두 열린 상태로 출력 여부
            displayTreeOpen : true,
            summaryText : "Total",

            // 그리드 ROW 스타일 함수 정의
            rowStyleFunction : function(rowIndex, item) {
              
              if(item._$isGroupSumField) { // 그룹핑으로 만들어진 합계 필드인지 여부
                  return "my-count-cell-style";
              }
              
              return null;
            }
            
         };


  
  
  // AUIGrid 그리드를 생성합니다.
  gMonthlyGridID = GridCommon.createAUIGrid("MonthlyGridDiv", MonthlyGridIDLayout,"", MonthlyGridLayoutOptions);
  
  // 푸터 객체 세팅
  AUIGrid.setFooter(gMonthlyGridID, MonthlyGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gMonthlyGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gMonthlyGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gMonthlyGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gMonthlyGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gMonthlyGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gMonthlyGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gMonthlyGridID,AUIGrid.getCellValue(gMonthlyGridID, event.rowIndex, 0)) );
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gMonthlyGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  

  
}

/*************************************
 ********* Chart Grid *********
**************************************/
function fnChartGridCreate()
{
  /***** ChartGridIDLayout Create *****/
  var ChartGridIDLayout = 
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
   // ChartGridIDLayout 
   
  
  var ChartGridLayoutOptions = {
            showFooter : true, 
            usePaging : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
         };
  
  
  // AUIGrid 그리드를 생성합니다.
  gChartGridID = GridCommon.createAUIGrid("ChartGridDiv", ChartGridIDLayout,"", ChartGridLayoutOptions);
  
  // 푸터 객체 세팅
  AUIGrid.setFooter(gChartGridID, bizPlanStockGridFooterLayout); 
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(gChartGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(gChartGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(gChartGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(gChartGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(gChartGridID, "removeRow", auiRemoveRowHandler);
  
  // cellClick event.
  AUIGrid.bind(gChartGridID, "cellClick", function( event ) 
  {
    console.log("cellClick_Status: " + AUIGrid.isAddedById(gChartGridID,AUIGrid.getCellValue(gChartGridID, event.rowIndex, 0)) );
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(gChartGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  

  
}


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

$(document).ready(function()
{

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
<h2>Plan &amp Sales Dashboard</h2>
<ul class="right_btns">
  <li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
  <!-- <li><p class="btn_blue"><a href="javascript:void(0);"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
  <input type ="hidden" id="paramScmQuarter" name="paramScmQuarter" value="1"/>
  <input type ="hidden" id="paramChartExt" name="paramChartExt" value="0"/>
  <input type ="hidden" id="paramGrp" name="paramGrp" value=""/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:110px" />
  <col style="width:245px" />
  <col style="width:110px" />
  <col style="width:245px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">Year</th>
  <td>
	  <select id="scmYearCbBox" name="scmYearCbBox" onchange="fnChangeEventYear(this);" class="w100p">
	  </select>
  </td>
  <!-- Stock Type 추가 -->
  <th scope="row">Stock Type</th>
  <td>
	  <select class="w100p" multiple="multiple" id="scmStockType" name="scmStockType"> 
	  </select>
  </td> 
  <td></td>
</tr>
</tbody>
</table><!-- table end -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">
  <div class="border_box" style="height: 343px;"><!-- border_box start -->
  <!-- 챠트 그리드 영역 1-->
    <div class="chart-container">
         <canvas id="netSalesChartID"></canvas>
    </div>
  </div><!-- border_box end -->
</div>

<div style="width:50%;">

<div class="border_box" style="height: 343px;"><!-- border_box start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="RateGridDiv"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
  <li><a onclick="fnTabClick('quarter');" class="on">Quarterly</a></li>
  <li><a onclick="fnTabClick('monthly');" >Monthly</a></li>
</ul>


<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 3-->
 <div id="QuarterGridDiv"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 4-->
 <div id="MonthlyGridDiv"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn">
  <%-- <a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a> --%>
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

</section><!-- content end -->