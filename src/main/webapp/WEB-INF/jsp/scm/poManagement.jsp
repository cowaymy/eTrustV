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

.my_div_btn {
    color: #fff !important;
    background-color: #2a2d33;
    line-height:2em;
    cursor: pointer;
}
.my_div_btn2 {
    color: #fff !important;
    background-color: #ee5315;
    line-height:2em;   
    cursor: pointer;
}

</style>

<script type="text/javaScript">

var gMovingStockCode ="";
var gMyGridSelRowIdx ="";
var gWeekThValue ="";
var gScmMonth = 0; 
var gSumAmount = 0; 

$(function() 
{
  // set Year
  fnSelectExcuteYear();
  // set PeriodByYear
  fnSelectPeriodReset(); 
  // set CDC
  fnSelectCDCComboList('349');
  //setting StockCode ComboBox 
  fnSetStockComboBox();   
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

  Common.ajax("GET", "/scm/selectMonthCombo.do"
	       ,  { scmYearCbBox: $("#scmYearCbBox").val(),
	            scmPeriodCbBox: $("#scmPeriodCbBox").val()
            }     
	       , function(result) 
	       {
			     console.log("성공." + JSON.stringify(result));
			     gScmMonth = 0;
		       if(result != null && result.length > 0)
           {
        	   console.log("data : " + result[0].scmMonth);
        	   gScmMonth = result[0].scmMonth;
	         }
	       });

  
}

function fnClearDataSet()
{
	gSumAmount = 0;	
  AUIGrid.clearGridData(myGridID2);
}

function fnUpdSaveCall() 
{
	Common.ajax( "POST"
			       , "/scm/savePOIssuItem.do"
	           , GridCommon.getEditData(myGridID2)
	           , function(result) 
	             {
			    	      AUIGrid.clearGridData(myGridID);
			    	      AUIGrid.clearGridData(myGridID2);
			    	      AUIGrid.clearGridData(SCMPOViewGridID);
			    	      gSumAmount = 0;
			    	      gMyGridSelRowIdx = "";
		              fnSearchBtnSCMPrePOView() ; 
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

function fnCreatePO()
{
  var rowCount = AUIGrid.getRowCount(myGridID2);

	//for(var i=0; i<rowCount; i++)
	//  AUIGrid.updateRow(myGridID2, { "checkFlag" : 1 }, i);

	if ( parseInt(AUIGrid.getCellValue(myGridID2, 0, "fobAmount")) > 500000 
			&&  parseInt(AUIGrid.getCellValue(myGridID2, 0, "vendor")) == 20000000 )
	{
	   Common.alert("<spring:message code='sys.scm.planByCdc.amountExceeds'/> ");
	   return false;  
	}   
	
  var udtList = AUIGrid.getEditedRowItems(myGridID2);
  var addList = AUIGrid.getAddedRowItems(myGridID2);
  
	if (addList.length > 0 || udtList.length > 0 )
	{
		fnUpdSaveCall();
	}
	else
	{
	 Common.alert("<spring:message code='pay.alert.noItem'/> ");
   return false;
	}
		
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
                       type: "M",
                       chooseMessage: "All"
                     }
                   , "");
}

function fnCheckedDelete(Obj) 
{
  if ($(Obj).parents().hasClass("btn_disabled") == true)
    return false;

  var checkedItemsList = AUIGrid.getCheckedRowItemsAll(SCMPOViewGridID); // 접혀진 자식들이 체크된 경우 모두 얻기

  if(checkedItemsList.length < 1) 
  {
    Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
    return false;
  }

  if (checkedItemsList.length > 0)
  {
	  var data = {};
	  
    for (var icnt = 0; icnt < checkedItemsList.length; icnt++)
      console.log("poNo: " + checkedItemsList[icnt].poNo + " /poItmNo: "+ checkedItemsList[icnt].poItmNo+ " /estWeek: "+ checkedItemsList[icnt].estWeek );

    data.checked = checkedItemsList;

    Common.ajax("POST"
            ,"/scm/deletePOMaster.do"
            , data
            , function(result) 
              {
                Common.alert("Save " + "<spring:message code='sys.msg.success'/>");  
                fnSearchBtnSCMPrePOView() ;
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

    GridCommon.exportTo("#dynamic_DetailGrid_wrap", "xlsx", fileNm+'_'+getTimeStamp() ); 
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
        
        var fobPrice   = AUIGrid.getCellValue(myGridID2, event.rowIndex, "fobPrice");
        var editPoQty  = parseInt(event.value);
        if (editPoQty <= 0)
        	editPoQty = 0;
    	   
        var editPlanQty = parseInt($("#inPlanQty").val());
        var newPoQty =   Math.ceil( editPoQty );  // 소수점이하 올림

        $("#inRoundUpPoQty").val(newPoQty); 
        
        //console.log("edit_poQty: "+ editPoQty + " /editPlanQty: "+ editPlanQty +" /newPoQty: "+ newPoQty);
        //console.log("New_RoundUpMoq: "+ $("#inRoundUpPoQty").val() +" /fobPrice: " + fobPrice + " /fobAmount: " + (newPoQty * fobPrice) );
        
        var calculPoQty = newPoQty ;
        var lastAmount = (calculPoQty * fobPrice);
        AUIGrid.setCellValue(myGridID2, event.rowIndex, 4, editPoQty);  // price
        AUIGrid.setCellValue(myGridID2, event.rowIndex, 6, lastAmount);// FOB AMOUNT
        
        
    } 
    else if(event.type == "cellEditCancel") 
    {
        console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    }
}

function fnMoveRight()
{
	if (gMyGridSelRowIdx.length == 0)
	{
    Common.alert("<spring:message code='expense.msg.NoData'/> ");
	  return false;
	}

/*  	if (parseInt(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "fobPrice")) <= 0)
	{
		Common.alert("<spring:message code='sys.scm.poIssue.AllPlannedQty'/> ");
    return false;  
	}   */

  if(addMoveChecked(gMovingStockCode) == false)
	{
	  Common.alert("<spring:message code='sys.msg.already.Registered' arguments='Stock Code' htmlEscape='false'/>");
	  return false;
	}
  
	
/*      console.log("inStockCode: " + AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "stockCode")
            +" inStkCtgryId: " + AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "stkCtgryId")
            +" inStkTypeId: " + AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "stkTypeId")
            +" inPlanQty: " + AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "planQty")
            +" inPoQty: " + AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "poQty")
            +" inMoq: " + AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "moq")
            +" roundUpMoq: " + Math.ceil((parseInt($("#inPlanQty").val()) - parseInt($("#inPoQty").val())) / $("#inMoq").val() )
            );   */

	     $("#inStockCode").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "stockCode"));
	     $("#inStkCtgryId").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "stkCtgryId"));
	     $("#inPlanQty").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "planQty"));
	     $("#inPoQty").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "poQty"));
	     $("#inStkTypeId").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "stkTypeId"));
	     $("#inMoq").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "moq"));
	     $("#inPreCdc").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "preCdc"));
	     $("#inPreYear").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "preYear"));
	     $("#inPreWeekTh").val(AUIGrid.getCellValue(myGridID, gMyGridSelRowIdx, "preWeekTh"));

	     $("#inRoundUpPoQty").val( ( parseInt($("#inPlanQty").val()) - parseInt($("#inPoQty").val()))); 

 	     if ( $("#inMoq").val() <= 0)
	     {
	       Common.alert("<spring:message code='sys.scm.poissue.zeroDivisible'/> ");
	       return false;
	     } 
	
	   Common.ajax("GET"
	             , "/scm/selectPoRightMove.do"
	             , {
	                 scmPeriodCbBox : $('#scmPeriodCbBox').val(),
	                 inStockCode : $("#inStockCode").val(),
	                 inStkCtgryId: $("#inStkCtgryId").val(),
	                 inPlanQty : $("#inPlanQty").val(),
	                 inPoQty : $("#inPoQty").val(),
	                 inStkTypeId : $("#inStkTypeId").val(),
	                 inMoq : $("#inMoq").val(),
	                 inPreCdc : $("#inPreCdc").val(),
	                 inPreYear : $("#inPreYear").val(),
	                 inPreWeekTh : $("#inPreWeekTh").val(),
	                 inRoundUpPoQty : $("#inRoundUpPoQty").val() 	                 
	               }
	             , function(result) 
	               {
	                  console.log("성공: " + result.selectPoRightMoveList.length);
	                  
	                  AUIGrid.addRow(myGridID2, result.selectPoRightMoveList, "last");

	                  if (result.selectPoRightMoveList.length > 0 )
	                  {
	                      $('#clearBtn').removeClass("btn_disabled");
	                      $('#createPoBtn').removeClass("btn_disabled");
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

//MstGrid 행 추가, 삽입
function addRow(selFieldObj) 
{
  var newFieldObj = new Object();

    newFieldObj.checkFlag  = 0;
    newFieldObj.stockCode  = selFieldObj.stockCode;
    newFieldObj.stockName  = selFieldObj.stockName;
    newFieldObj.stkTypeId  = selFieldObj.stkTypeId;
    newFieldObj.poQty      = selFieldObj.poQty;  
    newFieldObj.fobPrice   = selFieldObj.unitPrice;
    newFieldObj.fobAmount  = selFieldObj.fobAmount;
    // add Parameters
    newFieldObj.planQty    = selFieldObj.planQty;
    newFieldObj.preYear    = $("#scmYearCbBox").val();
    newFieldObj.preMonth   = gScmMonth;
    newFieldObj.preWeekTh  = gWeekThValue;
    newFieldObj.preCdc     = $("#cdcCbBox").val();

    AUIGrid.addRow(myGridID2, newFieldObj, "last");
}

function addMoveChecked(moveStockCode)
{
  var rowCnt = AUIGrid.getRowCount(myGridID2);
  var rtBooled = true;
  
   if(rowCnt > 0)
	 {
     for(i = 0 ; i < rowCnt ; i++)
	   {
       var AddedStockCode = AUIGrid.getCellValue(myGridID2, i ,"stockCode");
       if(AddedStockCode.length > 0)
	     {
          if (moveStockCode == AddedStockCode)
	        {
            console.log(AddedStockCode + " / " + moveStockCode + "Already Exists...");
            rtBooled =  false;
		      }
        }
      }
   }

	 return rtBooled
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

//적용 버턴 클릭 핸들러
function fnExportPDF(index, flag) 
{
  $("#viewType").val("PDF");
  $("#reportDownFileName").val(flag);
  $("#V_PO_NO").val(flag);
  $("#reportFileName").val("/scm/PO_management.rpt");

  console.log( "Export to PDF RowIndex: "+ index + " /PoNo: " + flag 
		          +" /viewType: " + $("#viewType").val()
		          +" /reportDownFileName: " + $("#reportDownFileName").val()
		          +" /V_PO_NO: " + $("#V_PO_NO").val()
             );
  
  Common.report("reportDataForm");
  
};

//팝업 버턴 클릭 핸들러
function fnExportExcel(index, value) 
{
  $("#viewType").val("EXCEL_FULL");
  $("#reportDownFileName").val(value);
  $("#V_PO_NO").val(value);
  $("#reportFileName").val("/scm/PO_management.rpt");

  console.log( "Export to Excel RowIndex: "+ index + " /PoNo: " + value 
		          +" /viewType: " + $("#viewType").val()
		          +" /reportDownFileName: " + $("#reportDownFileName").val()
		          +" /V_PO_NO: " + $("#V_PO_NO").val()
             );

  Common.report("reportDataForm");
  
}

/*************************************
 **********  Grid-LayOut  ************
 *************************************/

var SCMPrePOViewLayout = 
    [      
        {    
            dataField : "stockCode",
            headerText : "<spring:message code='sys.scm.pomngment.stockCode' />",
            width : "22%"
        }, {
            dataField : "stockName",
            headerText : "<spring:message code='sys.scm.pomngment.stockName'/>",
            width : "33%"
        }, {
            dataField : "stkTypeName",
            headerText : "<spring:message code='sys.scm.inventory.stockType'/>",
            visible  : true,
            width : "16%"
        }, {
            dataField : "planQty",
            headerText : "<spring:message code='sys.scm.pomngment.planQty'/>",
            style : "aui-grid-right-column",
            width : "13%"
        }, {
            dataField : "poQty",
            headerText : "<spring:message code='sys.scm.pomngment.poQty'/>",
            style : "aui-grid-right-column",
            //width : "15%",
            editable : false
        }, {
            dataField : "moq",
            headerText : "<spring:message code='sys.scm.mastermanager.MOQ'/>",
            style : "aui-grid-right-column",
            editable : false,
            visible  : false,
        }, {
            dataField : "stkCtgryId",
            headerText :  "<spring:message code='sys.scm.poApproval.stockCategory'/>",   
            editable : false,
            visible  : false,
        }, {
            dataField : "preYear",
            headerText :  "preYear",   
            editable : false,
            visible  : false,
        }, {
            dataField : "preCdc",
            headerText : "preCdc",   
            editable : false,
            visible  : false,
        }, {
            dataField : "preWeekTh",
            headerText : "preWeekTh",   
            editable : false,
            visible  : false,
        }, {
            dataField : "stkTypeId",
            headerText : "<spring:message code='sys.scm.inventory.stockType'/>",
            editable : false,
            visible  : false,
        }
    ];


var SCMPrePOViewLayout2 = 
    [  
        {
          dataField : "checkFlag",
          headerText : '<input type="checkbox" id="allCheckbox" name="allCheckbox" style="width:0px;height:0px;">',
          width : "5%",
          editable : false,
          visible  : false,
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
            dataField : "stockCode",
            headerText : "<spring:message code='sys.scm.pomngment.stockCode' />",
            width : "15%",
            editable : false
        }, {
            dataField : "stockName",
            headerText : "<spring:message code='sys.scm.pomngment.stockName'/>",
            width : "15%",
            editable : false
        }, {
            dataField : "stockType",
            headerText : "<spring:message code='sys.scm.inventory.stockType'/>",
            visible  : false,
            width : "10%"
        }, {
            dataField : "poQty",
            headerText : "<spring:message code='sys.scm.pomngment.poQty'/>",
            style : "aui-grid-right-column",
            width : "10%",
            editable : true
        }, {
            dataField : "fobPrice",
            headerText : "<spring:message code='sys.scm.pomngment.FOBPrice'/>",
            style : "aui-grid-right-column",
            width : "15%",
            editable : false
        }
        // for Save temporaryDataField
        , {
            dataField : "fobAmount",
            headerText : "<spring:message code='sys.scm.pomngment.FobAmount'/>",
            style : "aui-grid-right-column",
            visible  : true,
            width : "20%",
            editable : false
        }, {
            dataField : "currency",  
            headerText : "<spring:message code='log.head.currency'/>",
            visible  : true,
            width : "10%",
        }, {
            dataField : "vendor",
            headerText : "<spring:message code='log.head.vendor'/>",  
            visible  : true,
            width : "10%",
            editable : false
        }, {
            dataField : "vendorTxt",
            headerText : "<spring:message code='log.head.vendortext'/>", 
            visible  : true,
            width : "10%",
            editable : false
        },{
            dataField : "reqDate",
            headerText : "<spring:message code='log.head.requestdate'/>",   
            visible  : true,
            width : "13%",
            editable : false
        },{
            dataField : "stockCategory",
            headerText : "<spring:message code='sys.scm.poApproval.stockCategory'/>",   
            visible  : true,
            width : "13%",
            editable : false
        },{
            dataField : "moq",
            headerText : "<spring:message code='sys.scm.mastermanager.MOQ'/>",
            style : "aui-grid-right-column",
            width : "10%",
            editable : false
        },{
            dataField : "preYear",
            headerText : "preYear",
            visible  : false,
            width :"5%",
            editable : false
        },{
            dataField : "preCdc",
            headerText : "preCdc", 
            visible  : false,
            width : "5%",
            editable : false
        },{
            dataField : "preWeekTh",
            headerText : "preWeekTh", 
            visible  : false,
            width : "5%",
            editable : false
        },{
            dataField : "roundUpMoq",
            headerText : "roundUpMoq", 
            visible  : false,
            width : "5%",
            editable : false
        },

    ];

//footer
var SCMPrePOViewFooterLayout = 
                              [ {
                                   labelText : "SUM:",
                                   positionField : "fobPrice" 
                                 }
                               , {  
                                   dataField : "fobAmount",
                                   positionField : "fobAmount",
                                   operation : "SUM",
                                   formatString : "#,##0.0000",
                                   width : 200
                                   
                                 }
                               ];
    
var SCMPOViewLayout = 
    [ 
      {
          //dataField : "pdf",
          headerText : "<spring:message code='sys.scm.pomngment.pdf'/>",
          width : "7%",
          renderer : 
				        	  { // HTML 템플릿 렌더러 사용
				              type : "TemplateRenderer"
				            },
            // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
          labelFunction : function (rowIndex, columnIndex, value, headerText, item ) 
								                 { // HTML 템플릿 작성
											              var template = '<div>';
											              
											              template += '<span class="my_div_btn" onclick="javascript:fnExportPDF(' + rowIndex + ', \''+item.poNo+'\');">PDF</span>';
											              template += '&nbsp;';
											              template += '<span class="my_div_btn2" onclick="javascript:fnExportExcel(' + rowIndex + ', \''+item.poNo+'\');">EXCEL</span>';
											              template += '</div>';
											              return template;
								                 }
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
          dataField : "stkTypeId",
          headerText : "<spring:message code='sys.scm.inventory.stockType'/>",
          width : "7%",
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
      },{
          dataField : "cbBoxFlag",
          headerText : "cbBoxFlag",
          visible : false
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

	  AUIGrid.clearGridData(myGridID);
	  AUIGrid.clearGridData(myGridID2);
	  AUIGrid.clearGridData(SCMPOViewGridID);
	  gSumAmount = 0;
	  gMyGridSelRowIdx = "";

	  var params = {
		      scmStockTypes : $('#scmStockType').multipleSelect('getSelects'),
		      stkCodes : $('#stockCodeCbBox').multipleSelect('getSelects')
		      };

	  params = $.extend($("#MainForm").serializeJSON(), params);
		  
	  Common.ajax("POST", "/scm/selectScmPrePoItemView.do"
	          , params
	          , function(result) 
	          {
              //console.log("성공 selectScmPoViewList: " + result.selectScmPoViewList.length);
              //console.log("성공 prePoitemCnt:    " + result.selectScmPoStatusCntList[0].prePoitemCnt);

              AUIGrid.setGridData(myGridID, result.selectScmPrePoItemViewList);
              AUIGrid.setGridData(SCMPOViewGridID, result.selectScmPoViewList);
              	              
              if(result != null)
              { 
           	    if (result.selectScmPoViewList.length == 0
   	             && result.selectScmPoStatusCntList[0].prePoitemCnt == 0 
            	   && result.selectScmPoStatusCntList[0].scmpomasterCnt == 0 )
             	   {
	                 $("#po_issue").attr('class','circle circle_grey');
	                 $("#appRoval").attr('class','circle circle_grey');
			           } 
	            	 else  
	               {  // 2016 11 KL
               	   if (result.selectScmPoStatusCntList[0].prePoitemCnt < 1)  //notIssue
              		   $("#po_issue").attr('class','circle circle_blue');
                   else
                	   $("#po_issue").attr('class','circle circle_red');
                  
               	   if (result.selectScmPoStatusCntList[0].scmpomasterCnt < 1)  //pomaster
               		   $("#appRoval").attr('class','circle circle_blue');
               	   else
               		   $("#appRoval").attr('class','circle circle_red');

                 	 $('#delBtn').removeClass("btn_disabled");
               	 
	                }
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
            editable : false,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            selectionMode : "singleRow"  
          };

	// masterGrid 그리드를 생성합니다.
	myGridID = GridCommon.createAUIGrid("SCMPrePOViewGridDiv", SCMPrePOViewLayout,"", SCMPrePOViewLayoutOptions);
		
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
		gMyGridSelRowIdx = event.rowIndex;	
	  gMovingStockCode = AUIGrid.getCellValue(myGridID, event.rowIndex, 0);        
	});
	
	// 셀 더블클릭 이벤트 바인딩
	AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
	{
	  console.log("myGridID_DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
	  gMovingStockCode = AUIGrid.getCellValue(myGridID, event.rowIndex, 0);
	  fnMoveRight();
	});  

	/*******************************
	  SCMPrePOViewGridDiv2
	*******************************/  

	var SCMPrePOViewLayoutOptions2 = {
			      showFooter : true, 
            usePaging : false,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : true, // 행 상태 칼럼 보이기
            enableRestore : true,
            editable : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            selectionMode : "singleRow"  
          };

  // masterGrid 그리드를 생성합니다.
  myGridID2 = GridCommon.createAUIGrid("SCMPrePOViewGridDiv2", SCMPrePOViewLayout2,"", SCMPrePOViewLayoutOptions2);
  // AUIGrid 그리드를 생성합니다.
  
  // 푸터 객체 세팅
  AUIGrid.setFooter(myGridID2, SCMPrePOViewFooterLayout);
  
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
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + ", value : " + event.value);  
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
            editable : false,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제

            // 체크박스 표시 설정
            showRowCheckColumn : true,              
            // 전체 선택 체크박스가 독립적인 역할을 할지 여부
            independentAllCheckBox : true,   

            // rowCheckDisabledFunction 으로 비활성화된 체크박스는 체크 반응이 일어나지 않습니다.(rowCheckableFunction 불필요)
            rowCheckDisabledFunction : function(rowIndex, isChecked, item) 
            {
              if(item.cbBoxFlag == 5) { // Approve시 disabled
                return false; // false 반환하면 disabled 처리됨
              }
              
              return true;
            }

           ,rowCheckDisabledFunction : function(rowIndex, isChecked, item) 
            {
              if(item.cbBoxFlag == 5) { // Approve시 disabled
                 return false; // false 반환하면 disabled 처리됨
              }
              
              return true;
            } 
            
          };

  // masterGrid 그리드를 생성합니다.
  SCMPOViewGridID = GridCommon.createAUIGrid("SCMPOViewGridDiv", SCMPOViewLayout,"", SCMPOViewLayoutOptions);
  
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
  });
   
  // 셀 더블클릭 이벤트 바인딩
  AUIGrid.bind(SCMPOViewGridID, "cellDoubleClick", function(event) 
  {
    console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
  }); 


  // 전체 체크박스 클릭 이벤트 바인딩
  AUIGrid.bind(SCMPOViewGridID, "rowAllChkClick", function( event ) 
  {
    if(event.checked ) {  // name 의 값들 얻기  Active(1)/Approved(5)
      AUIGrid.setCheckedRowsByValue(event.pid, "cbBoxFlag",1); 
    } else {
      AUIGrid.setCheckedRowsByValue(event.pid, "cbBoxFlag",0);
    }

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

<form id="reportDataForm" action="">
  <input type ="hidden" id="reportFileName" name="reportFileName" value=""/>
  <input type ="hidden" id="viewType" name="viewType" value=""/>
  <input type ="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
  <input type ="hidden" id="V_PO_NO" name="V_PO_NO" value="" />
  

</form>      
 
<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">
  <input type ="hidden" id="inStockCode"  name="inStockCode" value=""/>
  <input type ="hidden" id="inStkCtgryId" name="inStkCtgryId" value=""/>
  <input type ="hidden" id="inPlanQty"    name="inPlanQty" value="" />
  <input type ="hidden" id="inPoQty"      name="inPoQty" value="" />
  <input type ="hidden" id="inMoq"        name="inMoq" value=""/>
  <input type ="hidden" id="inStkTypeId"  name="inStkTypeId" value=""/>
  <input type ="hidden" id="inRoundUpPoQty"  name="inRoundUpPoQty" value=""/>
  <input type ="hidden" id="inPreCdc"        name="inPreCdc" value=""/>
  <input type ="hidden" id="inPreYear"    name="inPreYear" value=""/>  
  <input type ="hidden" id="inPreWeekTh"    name="inPreWeekTh" value=""/>  
  
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <!-- <col style="width:160px" />
  <col style="width:*" />
  <col style="width:160px" />
  <col style="width:*" /> -->
	<col style="width:160px" />
	<col style="width:*" />
  <col style="width:160px" />
  <col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">EST Year &amp; Week</th>
	<!-- <td> -->
	<td colspan="3">

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
	<th scope="row">Mat.Code</th>
	<td>
    <select class="w100p" multiple="multiple" id="stockCodeCbBox" name="stockCodeCbBox">
    </select>
	</td>
	<!-- Stock Type 추가 -->
  <th scope="row">Stock Type</th>
  <td>
    <select class="w100p" multiple="multiple" id="scmStockType" name="scmStockType">
    </select>
  </td>
	<th scope="row">PO Status</th>
	<td>
	 <div class="status_result">
	  <p><span id ="po_issue" class="circle circle_grey"></span> PO Issue</p>    
    <p><span id ="appRoval" class="circle circle_grey"></span> Approval</p>
   </div>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<div class="divine_auto type2 mt30"><!-- divine_auto start -->

	<div style="width:40%;">
		<div class="border_box" style="min-height:150px"><!-- border_box start -->	
			<article class="grid_wrap"><!-- grid_wrap start -->
			  <!-- 그리드 영역1 -->
		   <div id="SCMPrePOViewGridDiv"></div>
		  </article><!-- grid_wrap end -->
		  
	  </div><!-- border_box end -->
	</div>

	<div style="width:60%;">
	  <div class="border_box" style="min-height:150px"><!-- border_box start -->
		 <article class="grid_wrap"><!-- grid_wrap start -->
	    <!-- 그리드 영역2 -->
	      <div id="SCMPrePOViewGridDiv2"></div>
	    </article><!-- grid_wrap end -->
	  
			<ul class="btns">
				<li><a onclick="fnMoveRight();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
			</ul>
			
			  <ul class="center_btns">
				 <li>
				   <p id="clearBtn" class="btn_blue btn_disabled">
			      	 <a onclick="fnClearDataSet();">Clear</a> 
				   </p>
				 </li>
				 <li>
				   <p id="createPoBtn" class="btn_blue btn_disabled">
				     <a onclick="fnCreatePO();">Create PO</a>
				  </p>
				 </li>
			  </ul>
	    </div><!-- border_box end -->
	</div><!-- width: 50 -->

</div><!-- divine_auto end -->


<article class="grid_wrap mt30" style=""><!-- grid_wrap start --> 
<ul class="right_btns">
  <li><p id='delBtn' class="btn_blue btn_disabled"><a onclick="fnCheckedDelete(this);">DELETE</a></p></li>
</ul>
<!-- 그리드 영역3 -->
  <div id="SCMPOViewGridDiv"></div>
</article><!-- grid_wrap end -->


<ul class="center_btns">
	<li>
	 <p class="btn_blue2 big">
	<!--    <a href="javascript:void(0);">Download Raw Data</a> <a onclick="fnExcelExport('PO ISSUE');">Download</a>-->
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