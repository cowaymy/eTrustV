<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
  text-align:right;
}
.aui-grid-left-column {
  text-align:left;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {  
    text-align:right;
    margin-top:-20px;
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

var MonthlyGridID, WeeklyGridID;

$(function() 
{
  // set Year
  fnSelectExcuteYear();
  //stock type
  fnSelectStockTypeComboList('15');   
});

function fnPeriodCbBoxChgEvent(gbn)
{
	if (gbn == "1")
		$("#scmPeriodCbBox").attr("disabled", false);
	else
		$("#scmPeriodCbBox").attr("disabled", true);  
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

function fnChangeEventYear(obj)
{
    if (obj.value == null || obj.value.length == 0 )
    {
      $("#scmMonthCbBox option:eq(0)").attr("selected", "selected");  
    	$("#scmMonthCbBox").attr("disabled", true);
    	fnPeriodCbBoxChgEvent("0");
    }
    else
      $("#scmMonthCbBox").attr("disabled", false);

    $("#selectPlanYear").val($("#scmYearCbBox").val()  );
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
		                   chooseMessage: "All"
		                 }
		               , "");     
}

function fnChangeEventMonth(obj)
{
   if ($("#scmYearCbBox").val().length < 1) 
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
     $("#scmMonthCbBox option:eq(0)").attr("selected", "selected"); 
     CommonCombo.initById("scmPeriodCbBox");  // reset... 
     fnPeriodCbBoxChgEvent("0"); 
     return false;
   }
   
   if (obj.value.length < 1) 
   {
     CommonCombo.initById("scmPeriodCbBox");  // reset... 
     fnPeriodCbBoxChgEvent("0"); 
     return false;
   }

   fnPeriodCbBoxChgEvent("1");
   
   CommonCombo.initById("scmPeriodCbBox");  // reset... 

   $("#selectPlanMonth").val(obj.value);

   console.log("year: " + $("#scmYearCbBox").val() + " /month: " + obj.value);

   if (FormUtil.isNotEmpty(obj.value)) 
   {
	    CommonCombo.make(  "scmPeriodCbBox"
					             , "/scm/selectWeekThSnComboList.do"  
					             , { scmYearCbBox    : $("#scmYearCbBox").val()
					            	  ,selectPlanMonth : obj.value 
					               }       
					             , ""                         
					             , {  
					                 id  : "weekTh",          
					                 name: "weekTh",
					                 chooseMessage: "Select a WEEK"
					               }
					             , ""
				              );
   }
}

function fnChangeEventPeriod(Obj)
{
  console.log("Week: " + Obj.value);
  
  var weekTh = "";
  var years = "";
  var yearVal = $("#selectPlanYear").val();
  var weekThSeq =  Obj.value;
  
  for (var i=1; i<13; i++)
  {
    weekTh = "#" + "weekTh" + (i.toString());
    weekThSeq = (parseInt(weekThSeq) -1);
    years = "#" +  "year" + (i.toString());
    
    if (i == Obj.value)
    {
      weekThSeq = 52;
      yearVal = (parseInt(yearVal) -1) ;
    }
    
    $(weekTh).val(weekThSeq);
    $(years).val(yearVal);

    console.log("weekThSeq: " + weekThSeq + " /year: " + yearVal);
  }

  //console.log("w1: " + $("#weekTh1").val() + " /w12: " + $("#weekTh12").val() + " /year: " + $("#year12").val());
  
}

//행 삭제 메소드
function removeRow() 
{
   console.log("removeRow Method MonthlyGridID ");    
    AUIGrid.removeRow(MonthlyGridID,"selectedIndex");
}

function fnSelectMonthly()
{
  Common.ajax("GET"
            , "/scm/selectOnTimeMonthly.do"
            , $("#MainForm").serialize()
            , function(result) 
              {
                 console.log("성공 fnSearchBtnList: " + result.selectOnTimeMonthlyList.length);
                 
                 AUIGrid.setGridData(MonthlyGridID, result.selectOnTimeMonthlyList);//selectAccuracyWeeklyDetail
                 
                 if(result != null && result.selectOnTimeMonthlyList.length > 0)
                 {
                   console.log("success: " + result.selectOnTimeMonthlyList[0].ScmMonth); 
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

function getTimeStamp() 
{
  function leadingZeros(n, digits) {
      var zero = '';
      n = n.toString();
      if (n.length < digits) {
          for (i = 0; i < digits - n.length; i++)
              zero += '0';
      }
      return zero + n;
  }

  var d = new Date();
  var date = leadingZeros(d.getFullYear(), 4)+ leadingZeros(d.getMonth() + 1, 2)+ leadingZeros(d.getDate(), 2);
  var time = leadingZeros(d.getHours(), 2)+leadingZeros(d.getMinutes(), 2) + leadingZeros(d.getSeconds(), 2);

  return date+"_"+time
}



// excel export
function fnExcelExport(fileNm)
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID

    GridCommon.exportTo("#WeeklyGridDiv", "xlsx", fileNm+'_'+getTimeStamp() ); 
}

function fnWeeklySelectDataList()
{
	Common.ajax("GET"
            , "/scm/selectAccuracyWeeklyDetail.do"
            , $("#MainForm").serialize()
            , function(result) 
              {
                 console.log("성공 fnSearchBtnList: " + result.accuracyWeeklyDetailList.length);
                 
                 if(result.accuracyWeeklyDetailList.length > 0)
                 {
                   console.log("Success_month: " + result.accuracyWeeklyDetailList[0].month);
                   //MainGrid 
                   AUIGrid.setGridData(WeeklyGridID, result.accuracyWeeklyDetailList);
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

// search
function fnSearchBtnClick()
{
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

   if ($("#scmPeriodCbBox").val().length < 1)
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='WEEK' htmlEscape='false'/>");
     return false;
   }

   fnWeeklySelectDataList();

   fnMonthlyCreate();
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


/*************************************
 **********  Grid-LayOut  ************
 *************************************/

var WeeklyGridLayout = 
    [         
      {
           dataField : "month",
           headerText :  "<spring:message code='budget.Month'/>",
           width : "5%",
           editable: false,
           //cellMerge : true,
           
       }
      ,{
          dataField : "week",
          headerText : "<spring:message code='sys.scm.accuracy.Week'/>",
          width : "5%",
          editable: false,
       }
      ,{
          dataField : "stockCtgry",
          headerText : "<spring:message code='sys.scm.salesplan.Category'/>",  
          width : "5%",
          editable: false,
       }
      ,{
          dataField : "stockCode",
          headerText : "<spring:message code='sys.scm.pomngment.stockCode'/>",  
          width : "10%",
          editable: false,
       }
      ,{
          dataField : "stockName",
          headerText : "<spring:message code='sys.scm.poapproval.stockDesc'/>",  
          width : "13%",
          editable: false,
       }
      ,{
          dataField : "stkTypeId",
          headerText : "<spring:message code='sys.scm.inventory.stockTypeId'/>",  
          width : "8%",
          editable: false,
       }
      ,{
          dataField : "team",
          headerText : "<spring:message code='sys.scm.accuracy.SalesOrg'/>",  
          width : "5%",
          editable: false,
       }
      ,{
          dataField : "w12",
          headerText : "<spring:message code='sys.scm.accuracy.W12'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w11",
          headerText : "<spring:message code='sys.scm.accuracy.W11'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w10",
          headerText : "<spring:message code='sys.scm.accuracy.W10'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w9",
          headerText : "<spring:message code='sys.scm.accuracy.W09'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w8",
          headerText : "<spring:message code='sys.scm.accuracy.W08'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w7",
          headerText : "<spring:message code='sys.scm.accuracy.W07'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w6",
          headerText : "<spring:message code='sys.scm.accuracy.W06'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w5",
          headerText : "<spring:message code='sys.scm.accuracy.W05'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w4",
          headerText : "<spring:message code='sys.scm.accuracy.W04'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w3",
          headerText : "<spring:message code='sys.scm.accuracy.W03'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w2",
          headerText : "<spring:message code='sys.scm.accuracy.W02'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "w1",
          headerText : "<spring:message code='sys.scm.accuracy.W01'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "salesOrder",
          headerText : "<spring:message code='sys.scm.accuracy.SalesOrder'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "shortTermAvg",
          headerText : "<spring:message code='sys.scm.accuracy.shortTerm'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "midTermAvg",
          headerText : "<spring:message code='sys.scm.accuracy.midTerm'/>",  
          width : "5%",
          style : "aui-grid-right-column",
          editable: false,
       }
     
    ];


function fnWeeklyGridCreate()
{
	var WeeklyGridOptions = {
            usePaging : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            editable : false,
            headerHeight:33,
            enableCellMerge  : true ,
          };

	// AUIGrid 그리드를 생성합니다.
	WeeklyGridID = GridCommon.createAUIGrid("WeeklyGridDiv", WeeklyGridLayout,"", WeeklyGridOptions);
	
	// 푸터 객체 세팅
	//AUIGrid.setFooter(WeeklyGridID, bizPlanGridFooterLayout); 
	
	// 에디팅 시작 이벤트 바인딩
	AUIGrid.bind(WeeklyGridID, "cellEditBegin", auiCellEditignHandler);
	
	// 에디팅 정상 종료 이벤트 바인딩
	AUIGrid.bind(WeeklyGridID, "cellEditEnd", auiCellEditignHandler);
	
	// 에디팅 취소 이벤트 바인딩
	AUIGrid.bind(WeeklyGridID, "cellEditCancel", auiCellEditignHandler);
	
	// 행 추가 이벤트 바인딩 
	AUIGrid.bind(WeeklyGridID, "addRow", auiAddRowHandler);
	
	// 행 삭제 이벤트 바인딩 
	AUIGrid.bind(WeeklyGridID, "removeRow", auiRemoveRowHandler);
	
	// cellClick event.
	AUIGrid.bind(WeeklyGridID, "cellClick", function( event ) 
	{
	gSelRowIdx = event.rowIndex;
	
	console.log("cellClick_Status: " + AUIGrid.isAddedById(WeeklyGridID,AUIGrid.getCellValue(WeeklyGridID, event.rowIndex, 0)) );
	console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
	});
	
	// 셀 더블클릭 이벤트 바인딩
	AUIGrid.bind(WeeklyGridID, "cellDoubleClick", function(event) 
	{
		  console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
	}); 

}

function fnMonthlyCreate()
{
  var monthlyGridLayout = [];
  var monthlyGridOptions = {}; 

  // 이전에 그리드가 생성되었다면 제거함.
  if(AUIGrid.isCreated(MonthlyGridID)) 
  {
    AUIGrid.destroy(MonthlyGridID);
  }

  var monthlyGridOptions = {
									           usePaging : false,
									           //editable: false,
									           useGroupingPanel : false,
									           showRowNumColumn : false,  // 그리드 넘버링
									           showStateColumn : false, // 행 상태 칼럼 보이기
									           enableRestore : true,
									           softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
									           headerHeight:33,
									         };



  /************************************************************************************************/
  
  console.log("year: " + $('#scmYearCbBox').val() + " /week_th: " + $('#scmPeriodCbBox').val() );
  
  Common.ajax("GET", "/scm/selectAccuracyMonthlyHeaderList.do"
           , $("#MainForm").serialize()
           , function(result) 
           {  
				      if( result.selectWeekThAccuracy == null || result.selectWeekThAccuracy.length < 1) 
				      {
				        Common.alert("<spring:message code='expense.msg.NoData' />");
				           /* if(AUIGrid.isCreated(WeeklyGridID)){
				              AUIGrid.destroy(WeeklyGridID);
				            }
				            if(AUIGrid.isCreated(summaryGridID)){
				               AUIGrid.destroy(summaryGridID);
				            } */ 
				        return false;  
				       } 
	             
			    	   console.log("accuracyHeadCount: " + result.accuracyHeadCount[0].m0TotCnt + " /getField: " + result.selectWeekThAccuracy[0].w1 );
				    	// setting   
	             monthlyGridLayout.push(
	                                       { 
	                                         dataField : "salesOrg"
	                                        ,headerText : "<spring:message code='sys.scm.accuracy.SalesOrg' />"
	                                        ,width : "10%"
	                                        ,editable : false
	                                       }
	                                      ,{ 
	                                         dataField : "term"
	                                        ,headerText : "<spring:message code='sys.scm.accuracy.Term' />"
	                                        ,width : "10%"
	                                        ,editable : false
	                                       }
	                                      ,{ 
	                                         dataField : "monthlyAccuracy"
	                                        ,headerText : "<spring:message code='sys.scm.accuracy.MonthlyAccuracy' />"
	                                        ,width : "10%"     
	                                        ,editable : false
	                                       }
	                                   
	                                     ) //push

	             var iM0TotCnt =   parseInt(result.accuracyHeadCount[0].m0TotCnt);	
	             var iLoopCnt = 1;
               var intToStrFieldCnt ="";
               var fieldStr ="";
	             
               for(var i=0; i<iM0TotCnt ; i++) 
               {
                  intToStrFieldCnt = iLoopCnt.toString();

                  if (i == 4  && result.selectWeekThAccuracy[0].w5 == undefined ) 
                	  continue;
                  else if (i == 5  && result.selectWeekThAccuracy[0].w6 == undefined ) 
                	  continue;
                  else if (i == 6  && result.selectWeekThAccuracy[0].w7 == undefined ) 
                	  continue;
                       
                  fieldStr = "w"+ intToStrFieldCnt;
                  //console.log("dataField: " + fieldStr +" /headerText: "+ result.selectWeekThAccuracy[0][fieldStr]);

                  monthlyGridLayout.push({
                	                         dataField  : fieldStr
                	                        ,headerText : "W"+result.selectWeekThAccuracy[0][fieldStr]
                	                        ,editable : false
                	                        ,width : "7%" 
                	                      });
                 iLoopCnt++; 
               }                                     
	
	       /************************************************************************************************/
	              // MonthlyGridID 그리드를 생성합니다.
	              MonthlyGridID = GridCommon.createAUIGrid("#MonthlyGridDiv", monthlyGridLayout,"", monthlyGridOptions);
	              
	              // 에디팅 시작 이벤트 바인딩
	              AUIGrid.bind(MonthlyGridID, "cellEditBegin", auiCellEditignHandler);
	              
	              // 에디팅 정상 종료 이벤트 바인딩
	              AUIGrid.bind(MonthlyGridID, "cellEditEnd", auiCellEditignHandler);
	              
	              // 에디팅 취소 이벤트 바인딩
	              AUIGrid.bind(MonthlyGridID, "cellEditCancel", auiCellEditignHandler);
	              
	              // 행 추가 이벤트 바인딩 
	              AUIGrid.bind(MonthlyGridID, "addRow", auiAddRowHandler);
	              
	              // 행 삭제 이벤트 바인딩 
	              AUIGrid.bind(MonthlyGridID, "removeRow", auiRemoveRowHandler);
	
	              // cellClick event.
	              AUIGrid.bind(MonthlyGridID, "cellClick", function( event ) 
	              {
	                gSelRowIdx = event.rowIndex;
	              
	                console.log("cellClick_Status: " + AUIGrid.isAddedById(MonthlyGridID,AUIGrid.getCellValue(MonthlyGridID, event.rowIndex, 0)) );
	                console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
	              });
	              
	              // 셀 더블클릭 이벤트 바인딩
	              AUIGrid.bind(MonthlyGridID, "cellDoubleClick", function(event) 
	              {
	                console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
	              });  
	
	             // fnSelectMonthly();
					    	   
           }  //  true
         ,function(jqXHR, textStatus, errorThrown) 
          {
            try 
            {
              console.log("HeaderFail Status : " + jqXHR.status);
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

}  // fnMonthlyCreate



/****************************  Form Ready ******************************************/
$(document).ready(function()
{

  //fnMonthlyCreate();
	fnWeeklyGridCreate();
  
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
<h2>Sales Plan Accuracy</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearchBtnClick();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
  <input type ="hidden" id="selectPlanYear" name="selectPlanYear" value=""/>
  <input type ="hidden" id="selectPlanMonth" name="selectPlanMonth" value=""/>
  <input type ="hidden" id="weekTh1"  name="weekTh1"  value=""/>
  <input type ="hidden" id="weekTh2"  name="weekTh2"  value=""/>
  <input type ="hidden" id="weekTh3"  name="weekTh3"  value=""/>
  <input type ="hidden" id="weekTh4"  name="weekTh4"  value=""/>
  <input type ="hidden" id="weekTh5"  name="weekTh5"  value=""/>
  <input type ="hidden" id="weekTh6"  name="weekTh6"  value=""/>
  <input type ="hidden" id="weekTh7"  name="weekTh7"  value=""/>
  <input type ="hidden" id="weekTh8"  name="weekTh8"  value=""/>
  <input type ="hidden" id="weekTh9"  name="weekTh9"  value=""/>
  <input type ="hidden" id="weekTh10" name="weekTh10"  value=""/>
  <input type ="hidden" id="weekTh11" name="weekTh11"  value=""/>
  <input type ="hidden" id="weekTh12" name="weekTh12"  value=""/>
  
  <input type ="hidden" id="year1"  name="year1"  value=""/>
  <input type ="hidden" id="year2"  name="year2"  value=""/>
  <input type ="hidden" id="year3"  name="year3"  value=""/>
  <input type ="hidden" id="year4"  name="year4"  value=""/>
  <input type ="hidden" id="year5"  name="year5"  value=""/>
  <input type ="hidden" id="year6"  name="year6"  value=""/>
  <input type ="hidden" id="year7"  name="year7"  value=""/>
  <input type ="hidden" id="year8"  name="year8"  value=""/>
  <input type ="hidden" id="year9"  name="year9"  value=""/>
  <input type ="hidden" id="year10" name="year10"  value=""/>
  <input type ="hidden" id="year11" name="year11"  value=""/>
  <input type ="hidden" id="year12" name="year12"  value=""/>

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
	<th scope="row">Year</th>
		<td>
			<select class="w100p" id="scmYearCbBox" name="scmYearCbBox" onchange="fnChangeEventYear(this);">
		  </select>
		</td>
	
	<th scope="row">Month</th>
		<td>
			<select class="w100p" id="scmMonthCbBox" name="scmMonthCbBox" onchange="fnChangeEventMonth(this);" disabled>
		    <option value="" selected>Select Month</option>	
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
		
	<th scope="row">Week</th>
		<td>
		 <select class="w100p" id="scmPeriodCbBox" name="scmPeriodCbBox" onchange="fnChangeEventPeriod(this);" disabled>
	   </select>
		</td>
		
	<!-- Stock Type 추가 -->
  <th scope="row">Stock Type</th>
	  <td>
		  <select class="w100p" id="scmStockType" name="scmStockType"> 
		  </select>
	  </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Monthly Report</h3>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="javascript:void(0);">Download</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="MonthlyGridDiv" style="height:140px;height:250px;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>Weekly Detail</h3>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="javascript:void(0);">Download</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
 <div id="WeeklyGridDiv" style="height:280px;margin:0 auto;"></div>
</article><!-- grid_wrap end -->

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

</section><!-- content end -->