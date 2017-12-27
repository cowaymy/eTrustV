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

var MonthlyGridID, WeeklyGridID, MainGridID;

$(function() 
{
	// set Year
  fnSelectExcuteYear();

  $("#scmMonthCbBox").attr("disabled", "disabled");

  //stock type
  fnSelectStockTypeComboList('15');   
});

function fnChangeEventStockType(object)
{
  $("#paramStockType").val(object.value);
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
	   $("#scmMonthCbBox").attr("disabled", false);
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

//행 삭제 메소드
function removeRow() 
{
    console.log("removeRow Method MonthlyGridID ");    
    AUIGrid.removeRow(MonthlyGridID,"selectedIndex");
}

function fnSetWeeklyGridCreate(DynamicFieldNameSetData, DynamicWeeklyListDataList)
{
	  console.log("fieldSetNameData: " + DynamicFieldNameSetData.headCnt + " /FIRST_VAL: " + DynamicFieldNameSetData.firstVal);

	  // 이전에 그리드가 생성되었다면 제거함.
	  if(AUIGrid.isCreated(WeeklyGridID)) 
	  {
	      AUIGrid.destroy(WeeklyGridID);
	  }
	  

	  var WeeklyGridLayoutOptions = {
	            usePaging : false,
	            editable: false,
	            useGroupingPanel : false,
	            showRowNumColumn : false,  // 그리드 넘버링
	            showStateColumn : false, // 행 상태 칼럼 보이기
	            enableRestore : true,
	            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
	          };

	    var DynamicWeeklyGridLayout = [];

	       DynamicWeeklyGridLayout.push(
                   {
                       dataField : "dtType",   //W1~
                       headerText : " ",  
                       style : "aui-grid-left-column",
                       editable: false,
                      
                   }); 
	    
	    for (var i=0; i < DynamicFieldNameSetData.headCnt; i++) 
	    {
	      dataFieldName = (Number(DynamicFieldNameSetData.firstVal) + i).toString();

	      DynamicWeeklyGridLayout.push(
	                                    {
	                                        dataField : "w"+dataFieldName,   //W1~
	                                        headerText : "W"+dataFieldName,  
	                                        editable: false,
	                                        dataType : "numeric",
	                                        formatString : "#,##0",
	                                        style : "aui-grid-right-column"  
	                                    }); 
	    }

	    

	  // WeeklyGridID 그리드를 생성합니다.
	  WeeklyGridID = GridCommon.createAUIGrid("WeeklyGridDiv", DynamicWeeklyGridLayout,"", WeeklyGridLayoutOptions);
	  
	  // 푸터 객체 세팅
	  //AUIGrid.setFooter(WeeklyGridID, footerObject);
	  
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

	  // dataSetting

	  AUIGrid.setGridData(WeeklyGridID, DynamicWeeklyListDataList);
	  
}

function fnSelectMonthly()
{
	Common.ajax("GET"
            , "/scm/selectOnTimeMonthly.do"
            , $("#MainForm").serialize()
            , function(result) 
              {
                 console.log("성공 fnSearchBtnList: " + result.selectOnTimeMonthlyList.length);
                 
                 AUIGrid.setGridData(MonthlyGridID, result.selectOnTimeMonthlyList);//selectOnTimeWeeklyStartPoint
                 
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

    GridCommon.exportTo("#MainGridDiv", "xlsx", fileNm+'_'+getTimeStamp() ); 
}

// search
function fnSearchBtnList()
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

   var dynamicWeeklyHeadStartPoint = {};
   var dynamicWeeklyHeadDataList = {};

   var params = {
					        scmStockTypes : $('#scmStockType').multipleSelect('getSelects')
					      };

   params = $.extend($("#MainForm").serializeJSON(), params);
    
   Common.ajax("POST"
             , "/scm/selectOnTimeDeliverySearch.do"
             , params
             , function(result) 
               {
                  console.log("성공 fnSearchBtnList: " + result.selectOnTimeWeeklyStartPoint.length);
                  
                  if(result != null && result.selectOnTimeWeeklyStartPoint.length > 0)
                  {
                    console.log("Success_HeadCnt: " + result.selectOnTimeWeeklyStartPoint[0].headCnt);
                    console.log("Success_Calcul: " + result.selectOnTimeCalculStatusList[0].completeCnt);
                    
                    dynamicWeeklyHeadStartPoint = result.selectOnTimeWeeklyStartPoint[0];
                    dynamicWeeklyHeadDataList = result.selectOnTimeWeeklyList;
                    fnSetWeeklyGridCreate(dynamicWeeklyHeadStartPoint, dynamicWeeklyHeadDataList); 

                    
                    $("#issuedPO").text(result.selectOnTimeCalculStatusList[0].totalCnt);   // Issued PO count
                    $("#onTime").text(result.selectOnTimeCalculStatusList[0].completeCnt);     // complete Count
                    $("#onTimeDelivery").text(result.selectOnTimeCalculStatusList[0].rating + "%");  // on-time

                    //MainGrid
                    fnMainGridCreate();
                    AUIGrid.setGridData(MainGridID, result.selectOnTimeDeliveryList);
                    
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


/*************************************
 **********  Grid-LayOut  ************
 *************************************/

var MonthlyGridLayout = 
    [         
      {
           dataField : "dtType",
           headerText : " ", 
           style : "aui-grid-left-column",
           width : "11%",
           editable: false,
           
       }
      ,{
          dataField : "m1",
          headerText : "1",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m2",
          headerText : "2",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m3",
          headerText : "3",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m4",
          headerText : "4",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m5",
          headerText : "5",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m6",
          headerText : "6",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m7",
          headerText : "7",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m8",
          headerText : "8",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m9",
          headerText : "9",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m10",
          headerText : "10",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m11",
          headerText : "11",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
      ,{
          dataField : "m12",
          headerText : "12",
          width : "7%",
          style : "aui-grid-right-column",
          editable: false,
       }
     
    ];


function fnMonthlyCreate()
{
	var MonthlyGridLayoutOptions = {
            usePaging : false,
            //editable: false,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
          };

  // MonthlyGridID 그리드를 생성합니다.
  MonthlyGridID = GridCommon.createAUIGrid("MonthlyGridDiv", MonthlyGridLayout,"", MonthlyGridLayoutOptions);
  
  // 푸터 객체 세팅
 // AUIGrid.setFooter(MonthlyGridID, MonthlyGridFooterLayout);
  
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

  fnSelectMonthly();
}


function fnMainGridCreate()
{
   // 이전에 그리드가 생성되었다면 제거함.
   if(AUIGrid.isCreated(MainGridID)) 
   {
       AUIGrid.destroy(MainGridID);
   }

   var MainGridLayout = 
	    [         
	      {
	           dataField : "poNo",
	           headerText :  "<spring:message code='sys.scm.pomngment.PONO'/>",
	           width : "10%",
	           editable: false,
	           
	       }
	      ,{
	          dataField : "poItmNo",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.poitem'/>",  
	          width : "5%",
	          editable: false,
	       }
	      ,{
	          dataField : "stkTypeId",
	          headerText : "<spring:message code='sys.scm.interface.stockType'/>",  
	          width : "5%",
	          editable: false,
	       }
	      ,{
	          dataField : "stockCode",
	          headerText : "<spring:message code='sys.scm.pomngment.stockCode'/>",
	          width : "7%",
	          editable: false,
	       }
	      ,{
	          dataField : "stockName",
	          headerText : "<spring:message code='budget.Description'/>",  // descript
	          width : "13%",
	          editable: false,
	       }
	      ,{
	          dataField : "poIssuDt",
	          headerText : "<spring:message code='sys.scm.otdview.poIssueDate'/>",
	          dataType : "date",
	          formatString : "dd-mm-yyyy",	          
	          width : "8%",
	          editable: false,
	       }
	      ,{
	          dataField : "delvryWeek",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.deliveryWeek'/>",
	          width : "5%",
	          editable: false,
	       }
	      ,{
	          dataField : "delvryDt",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.deliveryDate'/>",
            dataType : "date",
            formatString : "dd-mm-yyyy",
	          width : "7%",
	          editable: false,
	       }      
	      ,{
	          dataField : "firstGrDt",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.grDate1st'/>",
            dataType : "date",
            formatString : "dd-mm-yyyy",
	          width : "9%",
	          editable: false,
	       }
	      ,{
	          dataField : "lastGrDt",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.delvryGrdLast'/>",
            dataType : "date",
            formatString : "dd-mm-yyyy",
	          width : "9%",
	          editable: false,
	       }
	      ,{
	          dataField : "poQty",
	          headerText : "<spring:message code='sys.scm.pomngment.poQty'/>",
	          width : "4%",
	          style : "aui-grid-right-column",
	          dataType : "numeric",
	          formatString : "#,##0",
	          editable: false,
	       }
	      ,{
	          dataField : "grQty",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.grTotal'/>",
	          width : "5%",
	          style : "aui-grid-right-column",
	          dataType : "numeric",
	          formatString : "#,##0",
	          editable: false,
	       }
	      ,{
	          dataField : "onTmDelvryQty",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.onTimeGrQty'/>",
	          width : "8%",
	          style : "aui-grid-right-column",
	          dataType : "numeric",
	          formatString : "#,##0",
	          editable: false,
	       }
	      ,{
	          dataField : "isCmpltOnTm",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.onTime'/>",
	          width : "5%",
	          editable: false,
	          renderer : 
	          {
	             type : "CheckBoxEditRenderer"
	            ,showLabel  : false // 참, 거짓 텍스트 출력여부( 기본값 false )
	            ,editable   : false // 체크박스 편집 활성화 여부(기본값 : false)
	            ,checkValue : true // true, false 인 경우가 기본
	            ,unCheckValue : false
	                
	            // 체크박스 Visible 함수
	            ,visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
	             {
	               if(item.isCmpltOnTm == true)  // if 1 then
	                 return true; // CheckBox is Checked
	                                                        
	               return true;  // just CheckBox Visible But Not Checked.
	             }
	          } // renderer
	       }
	      ,{
	          dataField : "etc",
	          headerText : "<spring:message code='sys.scm.onTimeDelivery.Etc'/>",
	          editable: false,
	       }
	     
	    ];

	//footer
	var MainGridFooterLayout = 
	                              [ 
	                                   {
	                                        labelText : "∑",
	                                        positionField : "lastGrDt" 
	                                   }
	                                 , {  
	                                      dataField : "poQty",
	                                      positionField : "poQty",
	                                      operation : "SUM",
	                                      style : "aui-grid-right-column",
	                                      formatString : "#,##0"
	                                   }
	                                 , {  
	                                      dataField : "grQty",
	                                      positionField : "grQty",
	                                      operation : "SUM",
	                                      style : "aui-grid-right-column",
	                                      formatString : "#,##0"
	                                   }
	                                 , {  
	                                      dataField : "onTmDelvryQty",
	                                      positionField : "onTmDelvryQty",
	                                      operation : "SUM",
	                                      style : "aui-grid-right-column",
	                                      formatString : "#,##0"
	                                   }
	                                    
	                               ] 
   
	
	var MainGridLayoutOptions = {
            usePaging : false,
            showFooter : true, 
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
          };

  // MainGridID 그리드를 생성합니다.
  MainGridID = GridCommon.createAUIGrid("MainGridDiv", MainGridLayout,"", MainGridLayoutOptions);
  
  // 푸터 객체 세팅
  AUIGrid.setFooter(MainGridID, MainGridFooterLayout);
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(MainGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(MainGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(MainGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(MainGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(MainGridID, "removeRow", auiRemoveRowHandler);

  // cellClick event.
  AUIGrid.bind(MainGridID, "cellClick", function( event ) 
  {
    gSelRowIdx = event.rowIndex;
  
    console.log("cellClick_Status: " + AUIGrid.isAddedById(MainGridID,AUIGrid.getCellValue(MainGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(MainGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  

  
}

/****************************  Form Ready ******************************************/
$(document).ready(function()
{

	fnMonthlyCreate();
  
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
<h2>On-Time Delivery</h2>
</aside><!-- title_line end -->

  <ul class="right_btns">
  <li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
</ul>



<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="" >
  <input type ="hidden" id="paramStockType" name="paramStockType" value=""/>
  
<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
  <!-- <col style="width:95px" />
  <col style="width:150px" />
  <col style="width:150px" />
  <col style="width:*" />
  <col style="width:75px" />
  <col style="width:*" />
  <col style="width:160px" />
  <col style="width:*" />
  <col style="width:60px" />
  <col style="width:180px" /> -->
  <col style="width:105px" />
  <col style="width:*" />
  <col style="width:150px" />
  <col style="width:*" />
  <col style="width:180px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row">Year/Month</th>
  <td>
    <select id="scmYearCbBox" name="scmYearCbBox" onchange="fnChangeEventYear(this);" class="wAuto">
    </select> 
  
    <select class="ml5 wAuto" id="scmMonthCbBox" name="scmMonthCbBox">
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
  <th scope="row"> Issued PO(Line item)</th>
  <td>
  <span id="issuedPO"></span>
  </td>
  <th scope="row">View</th>
  <td>
    <div class="w100p">
    <select id="viewCbBox" name="viewCbBox" class="wAuto fl_left">
      <option value="" selected>All</option>
      <option value="1">On-time</option>
      <option value="0">Delayed</option>
    </select>
    <p class="btn_sky ml10 fl_left"><a onclick="fnExcelExport('oneTimeDelivery');">Download</a></p>
    </div>
  </td>
</tr>
<tr>
  <th scope="row">Stock Type</th>
  <td>
      <select id="scmStockType" name="scmStockType" multiple="multiple" onchange="fnChangeEventStockType(this);">
      </select>
  </td>
  <th scope="row">On-time</th>
  <td>
  <span id="onTime"></span>
  </td>
  <th scope="row">On-time Delivery rate</th>
  <td>
  <span id="onTimeDelivery"></span>
  </td>
</tr>
<tr>
</tr>
</tbody>
</table><!-- table end -->

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

<div class="divine_auto mt10"><!-- divine_auto start -->

<div style="width:55%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Monthly</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="MonthlyGridDiv" style="height:140px;margin:0 auto;"></div>
</article>

</div><!-- border_box end -->

</div>

<div style="width:45%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Weekly</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="WeeklyGridDiv" style="height:140px;margin:0 auto;"></div>  
</article>

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 3-->
 <div id="MainGridDiv"  style="width:100%; height:450px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->