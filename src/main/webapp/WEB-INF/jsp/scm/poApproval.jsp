<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
  text-align:right;
}

/* 엑스트라 체크박스 사용자 선택 못하는 표시 스타일 */
.disable-check-style {
  color:#d3825c;
}

</style>

<script type="text/javaScript">

var gWeekThValue ="";
var SummaryGridID , MainGridID ;
var hiddenField_KL = ["klQty", "klFobAmt"] ;
var hiddenField_KK = ["kkQty", "kkFobAmt"] ;
var hiddenField_JB = ["jbQty", "jbFobAmt"] ;
var hiddenField_PN = ["pnQty", "pnFobAmt"] ;
var hiddenField_KC = ["kcQty", "kcFobAmt"] ;

$(function() 
{
   // set Year
  fnSelectExcuteYear();
  // set PeriodByYear
  fnSelectPeriodReset(); 
  //stock type
  fnSelectStockTypeComboList('15');    
});

function fnSelectPeriodReset()
{
   CommonCombo.initById("scmPeriodCbBox");  // reset...
   var periodCheckBox = document.getElementById("scmPeriodCbBox");
       periodCheckBox.options[0] = new Option("Select a YEAR","");
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

function fnSelectCDC(selectYear, selectWeekTh)
{
    CommonCombo.make("cdcCbBox"
              , "/scm/selectComboSupplyCDC.do"  
              , { planYear: selectYear
                 ,planWeek : selectWeekTh
                }       
              , ""                         
              , {  
                  id  : "codeValue",  // use By query's parameter values             
                  name: "codeView",
                  chooseMessage: "Select a CDC"
                 }
              , "");     
}

function fnSelectCDCComboList(codeId)
{
    CommonCombo.make("cdcCbBox"
              , "/scm/selectComboSupplyCDC.do"  
              , { codeMasterId: codeId }       
              , ""                         
              , {  
                  id  : "code",     // use By query's parameter values                
                  name: "codeName",
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
  gWeekThValue = object.value;
}

String.prototype.fnTrim = function()
{
    return this.replace(/(^\s*)|(\s*$)/gi, "");
}

function fnSummaryHidden(paramHiddenListObj)
{

  for (var i = 0; i < paramHiddenListObj.length; i++)
	{
	  if (paramHiddenListObj[i].code.trim() == null)
		  continue;
	  
	  if(paramHiddenListObj[i].code == "KL")
    	 AUIGrid.hideColumnByDataField(SummaryGridID, hiddenField_KL );
    else if(paramHiddenListObj[i].code == "KK")
       AUIGrid.hideColumnByDataField(SummaryGridID, hiddenField_KK );
    else if(paramHiddenListObj[i].code == "KC")
       AUIGrid.hideColumnByDataField(SummaryGridID, hiddenField_KC );
    else if(paramHiddenListObj[i].code == "JB")
       AUIGrid.hideColumnByDataField(SummaryGridID, hiddenField_JB );
    else if(paramHiddenListObj[i].code == "PN")
       AUIGrid.hideColumnByDataField(SummaryGridID, hiddenField_PN );
	}
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

//excel export
function fnExcelExport(fileNm)
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID

    GridCommon.exportTo("#MainGrid_DIV", "xlsx", fileNm+'_'+getTimeStamp() ); 
}

// search
function fnSearchBtnList()
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

   var params = {
		              scmStockTypes : $('#scmStockType').multipleSelect('getSelects')
		            };

		   params = $.extend($("#MainForm").serializeJSON(), params);

   Common.ajax("POST"
             , "/scm/selectPoApprovalSearchBtn.do"
             , params
             , function(result) 
               {
                 // GridLayout Create
                 fnSummaryGridCreate(); 
                 fnMainGridCreate(); 
                 
                  if (result.selectPoApprovalSummaryList.length == 0)
                  {
                    Common.alert("<spring:message code='expense.msg.NoData'  htmlEscape='false'/>");
                    return true;
                  }  

            
                  if(result != null && result.selectPoApprovalMainListList.length > 0)
                  {
                     // SummaryGrid-Setting.
                    AUIGrid.setGridData(SummaryGridID, result.selectPoApprovalSummaryList);
                  
                    // MainGrid setting
                    AUIGrid.setGridData(MainGridID, result.selectPoApprovalMainListList); 

                    if (result.selectPoApprovalSummaryHiddenList.length > 0)
                     fnSummaryHidden(result.selectPoApprovalSummaryHiddenList);
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

function getItemsByCheckedField(selectedGrid) 
{
  // 체크된 item 반환
  var activeItems = AUIGrid.getItemsByValue(selectedGrid, "checkFlag", true);
  var checkedRowItem = [];
  var str = "";
  
  for(var i=0, len = activeItems.length; i<len; i++) 
  {
      checkedRowItem = activeItems[i];
      str += "chkRowIdx : " + checkedRowItem.rowIndex ;
  }
}

//전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) 
{
  var rowCount = AUIGrid.getRowCount(MainGridID);

  if(isChecked)   // checked == true == 1
  {
    for(var i=0; i<rowCount; i++) 
    {
       AUIGrid.updateRow(MainGridID, { "checkFlag" : 1 }, i);
    }
  } 
  else   // unchecked == false == 0
  {
    for(var i=0; i<rowCount; i++) 
    {
       AUIGrid.updateRow(MainGridID, { "checkFlag" : 0 }, i);
    }
  }
  
  // 헤더 체크 박스 일치시킴.
  document.getElementById("allCheckbox").checked = isChecked;

  getItemsByCheckedField(MainGridID);
  
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

//특정 칼럼 값으로 체크하기 (기존 더하기)
function addCheckedRowsByValue(selValue) 
{
  console.log("grouping Checked: " + selValue);
  // rowIdField 와 상관없이 행 아이템의 특정 값에 체크함
  // 행아이템의 code 필드 중 데이타가 selValue 인 것 모두 체크.
  AUIGrid.addCheckedRowsByValue(MainGridID, "checkFlag", selValue);
  
  // 만약 복수 값(Emma, Steve) 체크 하고자 한다면 다음과 같이 배열로 삽입
  //AUIGrid.addCheckedRowsByValue(SummaryGridID, "name", ["Emma", "Steve"]);
}
//특정 칼럼 값으로 체크 해제 하기
function addUncheckedRowsByValue(selValue) 
{
  console.log("grouping UnChecked: " + selValue);
  // 행아이템의 code 필드 중 데이타가 selValue인 것 모두 체크 해제함
  AUIGrid.addUncheckedRowsByValue(MainGridID, "checkFlag", selValue);
}



function fnChkApprovalUpdINF()
{
  var data = {};
  var checkedItemsList = AUIGrid.getCheckedRowItemsAll(MainGridID); // 접혀진 자식들이 체크된 경우 모두 얻기

  console.log("chkList: " + checkedItemsList.length);

  if(checkedItemsList.length <= 0) 
  {
    Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
    return false;
  }

  if (checkedItemsList.length > 0)
  {
    for (var icnt = 0; icnt < checkedItemsList.length; icnt++)
      console.log("poNo: " + checkedItemsList[icnt].poNo + " /poItmNo: "+ checkedItemsList[icnt].poItmNo+ " /stockCode: "+ checkedItemsList[icnt].stockCode );

    data.checked = checkedItemsList;

    Common.ajax("POST"
               ,"/scm/updatePoApprovalDetail.do"
               , data
               , function(result) 
                 {
                   Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                   fnSearchBtnList() ;
                     
                   console.log("성공." + JSON.stringify(result));
                   console.log("data : " + result.data);
                 } 
              ,  function(jqXHR, textStatus, errorThrown) 
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
                })
  }
}

/*************************************
 **********  Grid-LayOut  ************
 *************************************/

var SummaryGridLayout = 
    [      
        {   dataField : "stockCtgry",    
            headerText : "<spring:message code='sys.scm.poApproval.stockCategory' />",
            width : "10%"
        }
      , {  // JB
           headerText : "<spring:message code='sys.scm.poApproval.JB'/>",
           width : "10%",
           children   : [ 
                          {  
                              dataField : "jbQty",
                              headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
                              style : "aui-grid-right-column",
                              dataType : "numeric",
                              formatString : "#,##0",
                              editable : false,
                          }
                        , {  
                             dataField : "jbFobAmt",
                             headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
                             style : "aui-grid-right-column",
                             dataType : "numeric",
                             formatString : "#,##0.00",
                             editable : false,
                          }
                        ]
        }
      , {  // KC
           headerText : "<spring:message code='sys.scm.poApproval.KC'/>",
           width : "10%",
           children   : [ 
                          {  
                              dataField : "kcQty",
                              headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
                              style : "aui-grid-right-column",
                              dataType : "numeric",
                              formatString : "#,##0",
                              editable : false,
                          }
                        , {  
                             dataField : "kcFobAmt",
                             headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
                             style : "aui-grid-right-column",
                             dataType : "numeric",
                             formatString : "#,##0.00",
                             editable : false,
                          }
                        ]
        }
      , {  // KK
           headerText : "<spring:message code='sys.scm.poApproval.KK'/>",
           width : "10%",
           children   : [ 
                          {  
                              dataField : "kkQty",
                              headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
                              style : "aui-grid-right-column",
                              dataType : "numeric",
                              formatString : "#,##0",
                              editable : false,
                          }
                        , {  
                             dataField : "kkFobAmt",
                             headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
                             style : "aui-grid-right-column",
                             dataType : "numeric",
                             formatString : "#,##0.00",
                             editable : false,
                          }
                        ]
        }
      , {  // KL
           headerText : "<spring:message code='sys.scm.poApproval.KL'/>",
           width : "10%",
           children   : [ 
                          {  
                              dataField : "klQty",
                              headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
                              style : "aui-grid-right-column",
                              dataType : "numeric",
                              formatString : "#,##0",
                              editable : false,
                          }
                        , {  
                             dataField : "klFobAmt",
                             headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
                             style : "aui-grid-right-column",
                             dataType : "numeric",
                             formatString : "#,##0.00",
                             editable : false,
                          }
                        ]
        }
      , {  // PN
           headerText : "<spring:message code='sys.scm.poApproval.PN'/>",
           width : "10%",
           children   : [ 
                          {  
                              dataField : "pnQty",
                              headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
                              style : "aui-grid-right-column",
                              dataType : "numeric",
                              formatString : "#,##0.00",
                              editable : false,
                          }
                        , {  
                             dataField : "pnFobAmt",
                             headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
                             style : "aui-grid-right-column",
                             dataType : "numeric",
                             formatString : "#,##0.00",
                             editable : false,
                          }
                        ]
        }
      // Total Sum of Quantity
      , {  
          dataField : "allSumQty",
          headerText : "<spring:message code='sys.scm.poApproval.totSumOfQty'/>",
          style : "aui-grid-right-column",
          dataType : "numeric",
          formatString : "#,##0",
          editable : false,
       }
      // Total Sum of FOBAmount
     , {  
          dataField : "allSumFobAmt",
          headerText : "<spring:message code='sys.scm.poApproval.totSumOfFobAmt'/>",
          style : "aui-grid-right-column",
          dataType : "numeric",
          formatString : "#,##0.00",
          editable : false,
       }
      
    ];


var MainGridLayout = 
    [  
       {
            dataField : "poItmAppvStus",
            headerText : "<spring:message code='sys.scm.poApproval.ApprStatus' />",
            width : "7%",
            editable : false,
            styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                if(value == "Approved") {
                  return "disable-check-style";
                }
                return null;
              }
        }, {
            dataField : "stkTypeId",
            headerText : "<spring:message code='sys.scm.inventory.stockType'/>",
            width : "7%",
            editable : false
        }, {
            dataField : "poNo",
            headerText : "<spring:message code='sys.scm.pomngment.PONO'/>",
            width : "10%"
        },{
            dataField : "poItmNo",
            headerText : "<spring:message code='sys.scm.onTimeDelivery.poitem'/>",
            style : "aui-grid-right-column",
            width : "5%",
            editable : false
        }, {
            dataField : "eccPoNo", 
            headerText : "<spring:message code='sys.scm.poapproval.eccPoNo'/>",
            formatString : "dd-mm-yyyy",
            width : "10%",
            editable : false
        }, {
            dataField : "grWeek",
            headerText : "<spring:message code='sys.scm.pomngment.grWeek'/>",
            style : "aui-grid-right-column",
            width : "5%",
            editable : false
        }, {
            dataField : "poIssuDt",
            headerText : "<spring:message code='sys.scm.poapproval.PoIssueWeek'/>",
            formatString : "dd-mm-yyyy",
            width : "10%",
            editable : false
        }, {
            dataField : "stockCtgry",
            headerText : "<spring:message code='sys.scm.poApproval.stockCategory'/>",
            width : "10%",
            editable : false
        },{
            dataField : "stockCode",
            headerText : "<spring:message code='sys.scm.pomngment.stockCode'/>",
            width : "7%",
            editable : false
        }, {
            dataField : "stkDesc",
            headerText : "<spring:message code='sys.scm.poapproval.stockDesc'/>",
            width : "15%",
            editable : false
        }, {
            dataField : "qty",
            headerText : "<spring:message code='sys.scm.pomngment.quantity'/>",
            style : "aui-grid-right-column",
            dataType : "numeric",
            formatString : "#,##0.00",
            width : "7%",
            editable : false
        },{
            dataField : "fobAmt",
            headerText : "<spring:message code='sys.scm.pomngment.FobAmount'/>",
            style : "aui-grid-right-column",
            dataType : "numeric",
            formatString : "#,##0.00",
            width : "7%",
            editable : false
        }, {
            dataField : "cdc",
            headerText : "<spring:message code='sys.scm.pomngment.cdc'/>",
            width : "4%",
            editable : false
        }, {
            dataField : "ifDt",
            headerText : "<spring:message code='sys.scm.poapproval.sboINFDate'/>",
            formatString : "dd-mm-yyyy",
            width : "10%",
            editable : false
        }

    ];
//footer
var SummaryGridFooterLayout = 
    [
        {
             labelText : "Grand Total",
             positionField : "stockCtgry" 
        }
      , {  
           dataField : "klQty",
           positionField : "klQty",
           operation : "SUM",
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "klFobAmt",
           positionField : "klFobAmt",
           operation : "SUM",
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "kkQty",
           positionField : "kkQty",
           operation : "SUM",
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "kkFobAmt",
           positionField : "kkFobAmt",
           operation : "SUM", 
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "jbQty",
           positionField : "jbQty",
           operation : "SUM",
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "jbFobAmt",
           positionField : "jbFobAmt",
           operation : "SUM",
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "pnQty",
           positionField : "pnQty",
           operation : "SUM",
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "pnFobAmt",
           positionField : "pnFobAmt",
           operation : "SUM", 
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "kcQty",
           positionField : "kcQty",
           operation : "SUM",
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "kcFobAmt",
           positionField : "kcFobAmt",
           operation : "SUM", 
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {      
           dataField : "allSumQty",
           positionField : "allSumQty",
           operation : "SUM",
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
      , {  
           dataField : "allSumFobAmt",
           positionField : "allSumFobAmt",
           operation : "SUM", 
           style : "aui-grid-right-column",
           formatString : "#,##0"
        }
           
  ] 

function fnSummaryGridCreate()
{

  if(AUIGrid.isCreated(SummaryGridID)) {
      AUIGrid.destroy(SummaryGridID);
  }
	   
  var SummaryGridLayoutOptions = {
            showFooter : true, 
            usePaging  : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn  : true, // 행 상태 칼럼 보이기
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            usePaging : false,
            useGroupingPanel : false,
            editable : false,
            headerHeight : 35
          };

  // masterGrid 그리드를 생성합니다.
   SummaryGridID = GridCommon.createAUIGrid("SummaryGrid_DIV", SummaryGridLayout,"", SummaryGridLayoutOptions);
  // AUIGrid 그리드를 생성합니다.
  
  // 푸터 객체 세팅
  AUIGrid.setFooter(SummaryGridID, SummaryGridFooterLayout);
  
  // 에디팅 시작 이벤트 바인딩
  AUIGrid.bind(SummaryGridID, "cellEditBegin", auiCellEditignHandler);
  
  // 에디팅 정상 종료 이벤트 바인딩
  AUIGrid.bind(SummaryGridID, "cellEditEnd", auiCellEditignHandler);
  
  // 에디팅 취소 이벤트 바인딩
  AUIGrid.bind(SummaryGridID, "cellEditCancel", auiCellEditignHandler);
  
  // 행 추가 이벤트 바인딩 
  AUIGrid.bind(SummaryGridID, "addRow", auiAddRowHandler);
  
  // 행 삭제 이벤트 바인딩 
  AUIGrid.bind(SummaryGridID, "removeRow", auiRemoveRowHandler);

  // cellClick event.
  AUIGrid.bind(SummaryGridID, "cellClick", function( event ) 
  {
    gSelRowIdx = event.rowIndex;  
    console.log("cellClick_Status: " + AUIGrid.isAddedById(SummaryGridID,AUIGrid.getCellValue(SummaryGridID, event.rowIndex, 0)) );
  });
  
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(SummaryGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  });  

}

function fnMainGridCreate()
{
  /*******************************
    MainGrid_DIV
  *******************************/  

  if(AUIGrid.isCreated(MainGridID)) {
      AUIGrid.destroy(MainGridID);
  }  

  var MainGridLayoutOptions = {
            usePaging : false,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : true, // 행 상태 칼럼 보이기
            enableRestore : true,
          
            // 체크박스 표시 설정
            showRowCheckColumn : true,              
            // 전체 선택 체크박스가 독립적인 역할을 할지 여부
            independentAllCheckBox : true,   

            // rowCheckDisabledFunction 으로 비활성화된 체크박스는 체크 반응이 일어나지 않습니다.(rowCheckableFunction 불필요)
            rowCheckDisabledFunction : function(rowIndex, isChecked, item) 
            {
              if(item.cbBoxFlag == 5) { //5(Approved) 면 false고 disabled 처리됨
                return false; 
              }
              return true;
            }

					 ,rowCheckDisabledFunction : function(rowIndex, isChecked, item) 
					  {
					    if(item.cbBoxFlag == 5) { //5(Approved) 면 false고 disabled 처리됨
					       return false; 
					    }
					    
					    return true;
					  }  
            
    };

  // masterGrid 그리드를 생성합니다.
  MainGridID = GridCommon.createAUIGrid("MainGrid_DIV", MainGridLayout,"", MainGridLayoutOptions);
  
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

  // 전체 체크박스 클릭 이벤트 바인딩
  AUIGrid.bind(MainGridID, "rowAllChkClick", function( event ) 
  {
    if(event.checked )
      AUIGrid.setCheckedRowsByValue(event.pid, "cbBoxFlag",1);
    else 
      AUIGrid.setCheckedRowsByValue(event.pid, "cbBoxFlag",0);
  });
  
  
  // cellClick event.
  AUIGrid.bind(MainGridID, "cellClick", function( event ) 
  {
    gSelRowIdx = event.rowIndex;
    console.log("cellClick_Status: " + AUIGrid.isAddedById(MainGridID,AUIGrid.getCellValue(MainGridID, event.rowIndex, 0)) );
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

  fnSummaryGridCreate(); 

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
<h2>PO Approval</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
  <col style="width:160px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">EST Year &amp; Week</th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p>
	 <select class="w100p" id="scmYearCbBox" name="scmYearCbBox">
   </select>
	</p>
	<span>&nbsp;</span>
	<p>
	 <select class="sel_date" id="scmPeriodCbBox" name="scmPeriodCbBox" onchange="fnChangeEventPeriod(this);">
   </select>
	</p>
	</div><!-- date_set end -->

	</td>
  <!-- Stock Type 추가 -->
  <th scope="row">Stock Type</th>
  <td>
    <select id="scmStockType" name="scmStockType" multiple="multiple" >
    </select>
  </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap mt10"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="SummaryGrid_DIV" style="height:230px;"></div>
</article><!-- grid_wrap end -->

<ul class="right_btns">
  <li><p class="btn_grid"><a onclick="fnExcelExport('PO Approval');">EXCEL DOWN</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="MainGrid_DIV"></div> 
</article><!-- grid_wrap end -->

<ul class="center_btns">
  <li><p class="btn_blue"><a onclick="fnChkApprovalUpdINF();">APPROVE SELECTED PO(s)</a></p></li>
</ul>

<ul class="center_btns">
	<li>
	 <p class="btn_blue2 big">
<!-- 	   <a href="javascript:void(0);">Download Raw Data</a> -->
	 </p>
	</li>
</ul>

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

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
		
</section><!-- container end -->
<hr />

</div><!-- wrap end -->
</body>
</html>