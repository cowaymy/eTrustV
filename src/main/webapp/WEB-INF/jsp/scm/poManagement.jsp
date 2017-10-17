<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
  text-align:right;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {  
    text-align:right;
    margin-top:-20px;
}

.my-backColumn0 {
  background:#73EAA8; 
  color:#000;
}

.my-backColumn1 {
  background:#1E9E9E; 
  color:#000;
}

.my-backColumn2 {
  background:#818284;
  color:#000;
}

.my-backColumn3 {
  background:#a1a2a3;
  color:#000;
}

.my-header {
  background:#828282;
  color:#000;
}

</style>

<script type="text/javaScript">

var gWeekThValue ="";

$(function() 
{
  // set Year
  fnSelectExcuteYear();
  // set PeriodByYear
  fnSelectPeriodReset(); 
  // set CDC
  fnSelectCDC();
  //setting StockCode ComboBox 
  fnSetStockComboBox();   
});

function fnSelectPeriodReset()
{
   CommonCombo.initById("scmPeriodCbBox");  // reset...
   var periodCheckBox = document.getElementById("scmPeriodCbBox");
       periodCheckBox.options[0] = new Option("Select a YEAR","");
         
   CommonCombo.initById("cdcCbBox");  // reset...
   var periodCheckBox = document.getElementById("cdcCbBox");
       periodCheckBox.options[0] = new Option("Select a CDC","");  
}

function fnSelectCDC(selectYear, selectWeekTh)
{
    CommonCombo.make("cdcCbBox"
              , "/scm/selectSupplyCDC.do"  
              , { planYear: selectYear
                 //,planMonth : 1
                 ,planWeek : selectWeekTh
                }       
              , ""                         
              , {  
                  id  : "codeView",   // use By query's parameter values       
                  name: "codeView",
                  chooseMessage: "Select a CDC"
                 }
              , "");     
}

function fnSelectExcuteYear()
{
    // Call Back
    var fnSelectScmPeriodCallBack = function () 
        {
          $('#scmYearCbBox').on("change", function () //  When 'scmYearCbBox' Change Event Excute.
          {
            var $this = $(this);  // selected item , will use scmPeriodCbBox's input-parameter.

            console.log("period_values: " + $this.val());
                
            CommonCombo.initById("scmPeriodCbBox");  // Period reset... 
            CommonCombo.initById("cdcCbBox");  // CDC reset... 

            if (FormUtil.isNotEmpty($this.val())) 
            {
                CommonCombo.make("scmPeriodCbBox"
                        , "/scm/selectPeriodByYear.do"  
                        , { year: $this.val() }       
                        , ""                         
                        , {  
                            id  : "weekTh",          
                            name: "scmPeriod",
                            chooseMessage: "Select a WEEK"
                           }
                        , "");
            }
            else
            { 
              fnSelectPeriodReset();
            }
            
          });
        };
  
    CommonCombo.make("scmYearCbBox"
                   , "/scm/selectExcuteYear.do" // url
                   , ""                         // input Param
                   , ""                         // selectData
                   , {  
                       id  : "year",
                       name: "year",            // option
                       chooseMessage: "Year" 
                     }
                   , fnSelectScmPeriodCallBack); // callback
}

function fnChangeEventPeriod(object)
{
  //alert("Year: " + $("#scmYearCbBox").val() + " /WeekTh: " + object.value   );  
  gWeekThValue = object.value;
  fnSelectCDC( $("#scmYearCbBox").val() , object.value);
}

function fnSetStockComboBox()
{
    CommonCombo.make("stockCodeCbBox"
                   , "/scm/selectStockCode.do"  
                   , ""                         
                   , ""                         
                   , {  
                       id  : "stkCode",          
                       name: "stkDesc",
                       type: "S",
                       chooseMessage: "All"
                     }
                   , "");
}
// excel export
function fnExcelExport()
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName
    GridCommon.exportTo("#dynamic_DetailGrid_wrap", "xlsx", "SupplyPlanSummary_W" +$('#scmPeriodCbBox').val() );
}

// search
function fnSearchBtnList()
{
   Common.ajax("GET", "/scm/selectSupplyPlanCDCSearch.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 fnSearchBtnList: " + result.length);
              AUIGrid.setGridData(myGridID, result.selectSupplyPlanCDCList);
              if(result != null && result.length > 0)
              {
              }
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
  var rowCount = AUIGrid.getRowCount(myGridID);

  if(isChecked)   // checked == true == 1
  {
    for(var i=0; i<rowCount; i++) 
    {
       AUIGrid.updateRow(myGridID, { "checkFlag" : 1 }, i);
    }
  } 
  else   // unchecked == false == 0
  {
    for(var i=0; i<rowCount; i++) 
    {
       AUIGrid.updateRow(myGridID, { "checkFlag" : 0 }, i);
    }
  }
  
  // 헤더 체크 박스 일치시킴.
  document.getElementById("allCheckbox").checked = isChecked;

  getItemsByCheckedField(myGridID);
  
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
      str += "chkRowIdx : " + checkedRowItem.rowIndex ;//+ ", chkId :" + checkedRowItem.stusCodeId + ", chkName : " + checkedRowItem.codeName  + "\n";
  }

  //alert("checked items: " + str);
  
}

//특정 칼럼 값으로 체크하기 (기존 더하기)
function addCheckedRowsByValue(selValue) 
{
  console.log("grouping Checked: " + selValue);
  // rowIdField 와 상관없이 행 아이템의 특정 값에 체크함
  // 행아이템의 code 필드 중 데이타가 selValue 인 것 모두 체크.
  AUIGrid.addCheckedRowsByValue(myGridID, "code", selValue);
  
  // 만약 복수 값(Emma, Steve) 체크 하고자 한다면 다음과 같이 배열로 삽입
  //AUIGrid.addCheckedRowsByValue(myGridID, "name", ["Emma", "Steve"]);
}
//특정 칼럼 값으로 체크 해제 하기
function addUncheckedRowsByValue(selValue) 
{
  console.log("grouping UnChecked: " + selValue);
  // 행아이템의 code 필드 중 데이타가 selValue인 것 모두 체크 해제함
  AUIGrid.addUncheckedRowsByValue(myGridID, "code", selValue);
}

var SCMPrePOViewLayout = 
    [      
        {    
            dataField : "stockCode",
            headerText : "<spring:message code='sys.scm.pomngment.stockCode' />",
            width : "25%"
        }, {
            dataField : "stockName",
            headerText : "<spring:message code='sys.scm.pomngment.stockName'/>",
            width : "40%"
        }, {
            dataField : "planQty",
            headerText : "<spring:message code='sys.scm.pomngment.planQty'/>",
            style : "aui-grid-right-column",
            width : "15%"
        }, {
            dataField : "poQty",
            headerText : "<spring:message code='sys.scm.pomngment.poQty'/>",
            style : "aui-grid-right-column",
            //width : "15%",
            editable : false
        }
    ];


var SCMPrePOViewLayout2 = 
    [  
        {
            dataField : "stockCode",
            headerText : "<spring:message code='sys.scm.pomngment.stockCode' />",
            width : "25%",
            editable : false
        }, {
            dataField : "stockName",
            headerText : "<spring:message code='sys.scm.pomngment.stockName'/>",
            width : "25%",
            editable : false
        }, {
            dataField : "poQty",
            headerText : "<spring:message code='sys.scm.pomngment.poQty'/>",
            style : "aui-grid-right-column",
            width : "15%",
            editable : false
        }, {
            dataField : "fobPrice",
            headerText : "<spring:message code='sys.scm.pomngment.FOBPrice'/>",
            style : "aui-grid-right-column",
            width : "15%",
            editable : false
        }, {
            dataField : "fobAmount",
            headerText : "<spring:message code='sys.scm.pomngment.FobAmount'/>",
            style : "aui-grid-right-column",
            //width : "20%",
            editable : false
        }

    ];
    
var SCMPOViewLayout = 
    [ 
      {
          dataField : "pdf",
          headerText : "<spring:message code='sys.scm.pomngment.pdf'/>",
          width : "7%",
      },{
          dataField : "no",
          headerText : "<spring:message code='sys.scm.pomngment.rowNo'/>",
          width : "5%",
          visible: false
      },{
          dataField : "poNo",
          headerText : "<spring:message code='sys.scm.pomngment.PONO'/>",
          width : "10%"
      },{
          dataField : "poItmNo",
          headerText : "<spring:message code='sys.scm.pomngment.POItem'/>",
          width : "5%"
      },{
          dataField : "estWeek",
          headerText : "<spring:message code='sys.scm.pomngment.EstWeek'/>",
          width : "7%",
      },{
          dataField : "grWeek",
          headerText : "<spring:message code='sys.scm.pomngment.grWeek'/>",
          width : "7%"
      },{
          dataField : "poIssuDt",
          headerText : "<spring:message code='sys.scm.pomngment.poIssueDate'/>",
          width : "7%"
      },{
          dataField : "stockCode",
          headerText : "<spring:message code='sys.scm.pomngment.stockCode'/>",
          width : "7%"
      },{
          dataField : "stockName",
          headerText : "<spring:message code='sys.scm.pomngment.stockName'/>",
          width : "13%",
      },{
          dataField : "qty",
          headerText : "<spring:message code='sys.scm.pomngment.quantity'/>",
          style : "aui-grid-right-column",
          width : "7%"
      },{
          dataField : "fobAmt",
          headerText : "<spring:message code='sys.scm.pomngment.FobAmount'/>",
          style : "aui-grid-right-column",
          width : "7%"
      },{
          dataField : "cdc",
          headerText : "<spring:message code='sys.scm.pomngment.cdc'/>",
          width : "5%"
      },{
          dataField : "rtpgrWeek",
          headerText : "<spring:message code='sys.scm.pomngment.rptGrWeek'/>",
          width : "7%",
      },{
          dataField : "poAppvStus",
          headerText : "<spring:message code='sys.scm.pomngment.poapproval'/>",
          //width : "20%"
      }

    ];

function fnSearchBtnSCMPrePOView()
{
	  if ($("#scmYearCbBox").val().length < 1) 
	  {
	    Common.alert("<spring:message code='sys.msg.necessary' arguments='YEAR' htmlEscape='false'/>");
	    return false;
	  } 

	  if ($("#scmPeriodCbBox").val().length < 1) 
	  {
	    Common.alert("<spring:message code='sys.msg.necessary' arguments='WEEK_TH' htmlEscape='false'/>");
	    return false;
	  }

	  if ($("#cdcCbBox").val().length < 1) 
	  {
	    Common.alert("<spring:message code='sys.msg.necessary' arguments='CDC' htmlEscape='false'/>");
	    return false;
	  }

	   Common.ajax("GET", "/scm/selectScmPrePoItemView.do"
	           , $("#MainForm").serialize()
	           , function(result) 
	           {
	              console.log("성공 fnSearchBtnList: " + result.length);
	              AUIGrid.setGridData(myGridID, result.selectScmPrePoItemViewList);
	              //AUIGrid.setGridData(myGridID2, result.selectScmPrePoItemViewList);
	              AUIGrid.setGridData(SCMPOViewGridID, result.selectScmPoViewList);
	              if(result != null && result.length > 0)
	              {
	              }
	           });	  
}

/****************************  Form Ready ******************************************/

var myGridID , myGridID2 ,SCMPOViewGridID;

$(document).ready(function()
{
	var SCMPrePOViewLayoutOptions = {
            usePaging : false,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
           // selectionMode : "multipleRows",
          };

	// masterGrid 그리드를 생성합니다.
	myGridID = GridCommon.createAUIGrid("SCMPrePOViewGridDiv", SCMPrePOViewLayout,"", SCMPrePOViewLayoutOptions);
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
	  gSelRowIdx = event.rowIndex;
	
	  console.log("cellClick_Status: " + AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) );
	  console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
	});
	
	// 셀 더블클릭 이벤트 바인딩
	AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
	{
	  console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
	});  


	
	/*******************************
	  SCMPrePOViewGridDiv2
	*******************************/  

	var SCMPrePOViewLayoutOptions2 = {
            usePaging : false,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
           // selectionMode : "multipleRows",
          };

  // masterGrid 그리드를 생성합니다.
  myGridID2 = GridCommon.createAUIGrid("SCMPrePOViewGridDiv2", SCMPrePOViewLayout2,"", SCMPrePOViewLayoutOptions2);
  // AUIGrid 그리드를 생성합니다.
  
  // 푸터 객체 세팅
  //AUIGrid.setFooter(myGridID2, footerObject);
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(myGridID2, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(myGridID2, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(myGridID2, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(myGridID2, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(myGridID2, "removeRow", auiRemoveRowHandler);
  
  
  // cellClick event.
  AUIGrid.bind(myGridID2, "cellClick", function( event ) 
  {
    gSelRowIdx = event.rowIndex;
  
    console.log("cellClick_Status: " + AUIGrid.isAddedById(myGridID2,AUIGrid.getCellValue(myGridID2, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(myGridID2, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  }); 

	/*******************************
	  SCMPOViewGridDiv
	*******************************/  

	var SCMPOViewLayoutOptions = {
            usePaging : true,
            useGroupingPanel : false,
            showRowNumColumn : true,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
           // selectionMode : "multipleRows",
          };

  // masterGrid 그리드를 생성합니다.
  SCMPOViewGridID = GridCommon.createAUIGrid("SCMPOViewGridDiv", SCMPOViewLayout,"", SCMPOViewLayoutOptions);
  // AUIGrid 그리드를 생성합니다.
  
  // 푸터 객체 세팅
  //AUIGrid.setFooter(SCMPOViewGridID, footerObject);
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(SCMPOViewGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(SCMPOViewGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(SCMPOViewGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(SCMPOViewGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(SCMPOViewGridID, "removeRow", auiRemoveRowHandler);
  
  
  // cellClick event.
  AUIGrid.bind(SCMPOViewGridID, "cellClick", function( event ) 
  {
    gSelRowIdx = event.rowIndex;
  
    console.log("cellClick_Status: " + AUIGrid.isAddedById(SCMPOViewGridID,AUIGrid.getCellValue(SCMPOViewGridID, event.rowIndex, 0)) );
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex );        
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(SCMPOViewGridID, "cellDoubleClick", function(event) 
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
<h2>PO Issue</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearchBtnSCMPrePOView();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">EST Year &amp; Week</th>
	<td>

	<div class="date_set w100p"><!-- date_set start -->
	<p>
	<!-- <select class="w100p"> -->
	  <select class="w100p" id="scmYearCbBox" name="scmYearCbBox">
	  </select>  
	</p>
	<span>&nbsp;</span>
	<p>
	<!-- <select class="w100p"> -->
    <select class="w100p" id="scmPeriodCbBox" name="scmPeriodCbBox" onchange="fnChangeEventPeriod(this);">
    </select>
	</p>
	</div><!-- date_set end -->

	</td>
	<th scope="row">CDC</th>
	<td>
    <select class="w100p" id="cdcCbBox" name="cdcCbBox">
    </select>
	</td>
</tr>
<tr>
	<th scope="row">Stock</th>
	<td>
    <select class="w100p" id="stockCodeCbBox" name="stockCodeCbBox">
    </select>
	</td>
	<th scope="row">PO Status</th>
	<td>
	<label><input type="checkbox" disabled="disabled" /><span>PO Issue</span></label>
	<label><input type="checkbox" disabled="disabled" /><span>Approval</span></label>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<div class="divine_auto type2 mt30"><!-- divine_auto start -->

	<div style="width:50%;">
		<div class="border_box" style="min-height:150px"><!-- border_box start -->	
			<article class="grid_wrap"><!-- grid_wrap start -->
			  <!-- 그리드 영역1 -->
		   <div id="SCMPrePOViewGridDiv"></div>
		  </article><!-- grid_wrap end -->
		  
	  </div><!-- border_box end -->
	</div>

	<div style="width:50%;">
	  <div class="border_box" style="min-height:150px"><!-- border_box start -->
		 <article class="grid_wrap"><!-- grid_wrap start -->
	    <!-- 그리드 영역2 -->
	      <div id="SCMPrePOViewGridDiv2"></div>
	    </article><!-- grid_wrap end -->
	  
			<ul class="btns">
				<li><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
			</ul>
			
			  <ul class="center_btns">
				 <li>
				   <p class="btn_blue">
			     <!-- 	 <a href="javascript:void(0);">Clear</a> -->
			      <input type='button' id='Clear' value='Clear' disabled />
				   </p>
				 </li>
				 <li>
				   <p class="btn_blue">
				    <!-- <a href="javascript:void(0);">Create PO</a> -->
				     <input type='button' id='Create PO' value='Create PO' disabled />
				  </p>
				 </li>
			  </ul>
	    </div><!-- border_box end -->
	</div><!-- width: 50 -->

</div><!-- divine_auto end -->


<article class="grid_wrap mt30" style=""><!-- grid_wrap start --> 
<!-- 그리드 영역3 -->
  <div id="SCMPOViewGridDiv"></div>
</article><!-- grid_wrap end -->


<ul class="center_btns">
	<li>
	 <p class="btn_blue2 big">
	<!--    <a href="javascript:void(0);">Download Raw Data</a> -->
	 </p>
	</li>
</ul>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
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