<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
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
  fnSelectCDCComboList('349');
  //setting StockCode ComboBox 
  fnSetStockComboBox();   
});

function fnSelectPeriodReset()
{
   CommonCombo.initById("scmPeriodCbBox");  // reset...
   var periodCheckBox = document.getElementById("scmPeriodCbBox");
       periodCheckBox.options[0] = new Option("Select a WEEK","");
         
  /*  CommonCombo.initById("cdcCbBox");  // reset...
   var periodCheckBox = document.getElementById("cdcCbBox");
       periodCheckBox.options[0] = new Option("Select a CDC",""); */  
}

function fnSelectCDC(selectYear, selectWeekTh)
{
	  CommonCombo.make("cdcCbBox"
              , "/scm/selectComboSupplyCDC.do"  
              , { planYear: selectYear
                 //,planMonth : 1
                 ,planWeek : selectWeekTh
                }       
              , ""                         
              , {  
                  id  : "codeValue",          
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
                  id  : "code",          
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
            //CommonCombo.initById("cdcCbBox");  // CDC reset... 

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
  //fnSelectCDC( $("#scmYearCbBox").val() , object.value);
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
              console.log("성공 fnSearchBtnList: " + result.selectSupplyPlanCDCList.length);
              console.log("성공 selectSupplyCdcSaveFlag: " + result.selectSupplyCdcSaveFlag[0].saveFlag);
              console.log("성공 selectSalesPlanMasterList_Length: " + result.selectSalesPlanMasterList.length);
              console.log("성공 selectSupplyPlanMasterList_Length: " + result.selectSupplyPlanMasterList.length
                          +"plan status: " +  result.selectSupplyPlanMasterList[0].planStus );
              
              AUIGrid.setGridData(myGridID, result.selectSupplyPlanCDCList);
              if ( result != null)
              {
                 //save
	              if(result.selectSupplyCdcSaveFlag.length > 0 )
	              {
	                  if (result.selectSupplyCdcSaveFlag[0].saveFlag == "B")
	                  {
	            	      $("#cir_save").attr('class','circle circle_blue');

	            	      if (result.selectSupplyPlanMasterList[0].planStus == 4) 
	            	    	  $("#ConfirmBtn").attr("disabled",true)     //disabled
	                    else $("#ConfirmBtn").attr("disabled",false) //enabled

	                  }
	                  else if (result.selectSupplyCdcSaveFlag[0].saveFlag == "R")
	                  {
	                	  $("#cir_save").attr('class','circle circle_red');
	                  }
	                  else
	                  {
	                	  $("#cir_save").attr('class','circle circle_grey');
	                  }
	                  
	                 // $("#cir_cinfirm").attr('class','circle circle_blue');
	              }

	              // salses
	              if (result.selectSalesPlanMasterList.length >= 2)
	              {
	            	  $("#cir_sales").attr('class','circle circle_blue');
	              }
	              else
	              {
	            	  $("#cir_sales").attr('class','circle circle_red');
	              }

	              //confirm
                if (result.selectSupplyPlanMasterList.length > 0 && result.selectSupplyPlanMasterList[0].planStus == 4)
                {
                  $("#cir_cinfirm").attr('class','circle circle_blue');
                }
                else
                {
                  $("#cir_cinfirm").attr('class','circle circle_red');
                }
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

function fnSettiingHeader()
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

  var dynamicLayout = [];
  var dynamicOption = {}; 

 // 이전에 그리드가 생성되었다면 제거함.
  if(AUIGrid.isCreated(myGridID)) {
    AUIGrid.destroy(myGridID);
  }

  dynamicOption = {
                    usePaging : false,
                    useGroupingPanel : false,
                    showRowNumColumn : false, //순번 칼럼 숨김
                    editable : false,
                    showStateColumn : true, // 행 상태 칼럼 보이기
                    showEditedCellMarker : true, // 셀 병합 실행
                    enableCellMerge : true,
                    // 고정칼럼 카운트 지정
                    fixedColumnCount : 5  , 

                    softRemoveRowMode : false,
                    // 체크박스 표시 설정
                    showRowCheckColumn : true,
                    // 전체 체크박스 표시 설정
                    showRowAllCheckBox : true,    

                    // 엑스트라 체크박스 체커블 함수
                    // 이 함수는 사용자가 체크박스를 클릭 할 때 1번 호출됩니다.
                    rowCheckableFunction : function(rowIndex, isChecked, item) 
                    {
                    	console.log ("isChecked: " + isChecked + " /Checked value: " + AUIGrid.getCellValue(myGridID, rowIndex, "code"));
                    	
                    	if (isChecked == false) // for Checked 
                      {
                    	 addCheckedRowsByValue(AUIGrid.getCellValue(myGridID, rowIndex, "code"));
                      }
                    	else
                      {
                    	 addUncheckedRowsByValue(AUIGrid.getCellValue(myGridID, rowIndex, "code"));
                      }
                          
                      return true;
                    },

                            
                  };

  console.log("year: " + $('#scmYearCbBox').val() + " /week_th: " + $('#scmPeriodCbBox').val() + " /stock: " + $('#stockCodeCbBox').val()
		         +"cdc: " + $('#cdcCbBox').val() );  
  
  Common.ajax("GET", "/scm/selectCalendarHeader.do"
          , $("#MainForm").serialize()
          , function(result) 
          {     

            if( (result.seperaionInfo == null || result.seperaionInfo.length < 1) 
               || (result.getChildField == null || result.getChildField.length < 1))
            {
              Common.alert("<spring:message code='expense.msg.NoData' />");

              if(AUIGrid.isCreated(myGridID)){
                 AUIGrid.destroy(myGridID);
              }
              if(AUIGrid.isCreated(summaryGridID)){
                 AUIGrid.destroy(summaryGridID);
              }

              return false;  
            }
                            
           //  AUIGrid.setGridData(myGridID, result);
             if(result.header != null && result.header.length > 0)
             {
               dynamicLayout.push( 
                                   { 
                                      headerText : "Stock"
                                     ,style : "my-header" 
                                    // , width : 13
                                     ,children : [
                                                    {                            
                                                      dataField : result.header[0].isSaved
                                                     ,headerText : "<spring:message code='sys.scm.salescdc.IsSaved' />"
                                                     ,editable : false
                                                     ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                      {
                                                  	    if(item.divOdd == "0") 
                                                          return "my-backColumn0";
                                                        else 
                                                          return "my-backColumn1";
                                                      } 
                                                       //,width : "5%"
                                                     ,renderer : 
																			                {
	                                                      type : "CheckBoxEditRenderer"
																						            ,showLabel  : false // 참, 거짓 텍스트 출력여부( 기본값 false )
																						            ,editable   : false // 체크박스 편집 활성화 여부(기본값 : false)
																						            ,checkValue : true // true, false 인 경우가 기본
																						            ,unCheckValue : false
																						                
																						               // 체크박스 Visible 함수
																						            ,visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) 
																				                 {
																						               if(item.isSaved == true)  // if 1 then
																				                     return true; // CheckBox is Checked
																				                   																					
																				                   return true;  // just CheckBox Visible But Not Checked.
																				                 }
																						          } // renderer
                                                    }
                                                  , {                            
                                                        dataField : result.header[0].categoryH1
                                                        ,headerText : "<spring:message code='sys.scm.salesplan.Category' />"
                                                        ,editable : true
                                                        ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                         {
                                                           if(item.divOdd == "0") 
                                                             return "my-backColumn0";
                                                           else 
                                                             return "my-backColumn1";
                                                         }
                                                     }
                                                   , {                            
                                                        dataField : result.header[0].codeH1
                                                       ,headerText : "<spring:message code='sys.scm.salesplan.Code' />" 
                                                       ,editable : true
                                                       ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                        {
                                                          if(item.divOdd == "0") 
                                                            return "my-backColumn0";
                                                          else 
                                                            return "my-backColumn1";
                                                        }
                                                     }
                                                   , {                            
                                                        dataField : result.header[0].nameH1
                                                       ,headerText : "<spring:message code='sys.scm.salesplan.Name' />"
                                                       ,editable : true
                                                       ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                        {
                                                          if(item.divOdd == "0") 
                                                            return "my-backColumn0";
                                                          else 
                                                            return "my-backColumn1";
                                                        }
                                                     }
                                                   , { 
                                                       dataField : result.header[0].supplyCorpHPsi
                                                      ,headerText : "<spring:message code='sys.scm.supplyCorp.psi' />"
                                                      ,editable : true
                                                      ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                       {
                                                         if(item.divOdd == "0") 
                                                           return "my-backColumn0";
                                                         else 
                                                           return "my-backColumn1";
                                                       }
                                                       //,width : "5%"
                                                     }
                                                     
                                                  ]// children
                                   } // Uppder Group   

                                   
                                   /***** Monthly  *****/
                                   ,{                            
                                      headerText : "Monthly"
                                     ,style : "my-header" 
                                     //, width : 7
                                     ,children : [
                                                    {                            
                                                       dataField : result.header[0].todayH2  // m0 == M0_PLAN_ORDER
                                                      ,headerText : "<spring:message code='sys.scm.salesplan.M0' />"
                                                      ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                       {
                                                         if(item.divOdd == "0") 
                                                           return "my-backColumn0";
                                                         else 
                                                           return "my-backColumn1";
                                                       } 
                                                        //,width : "5%"
                                                    }
                                                  , {                            
                                                       dataField : result.header[0].m1H2
                                                      ,headerText : "<spring:message code='sys.scm.salesplan.M1' />"
                                                      ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                       {
                                                         if(item.divOdd == "0") 
                                                           return "my-backColumn0";
                                                         else 
                                                           return "my-backColumn1";
                                                       } 
                                                      //,width : "5%"
                                                    }
                                                  , {                            
                                                       dataField : result.header[0].m2H2
                                                      ,headerText : "<spring:message code='sys.scm.salesplan.M2' />" 
                                                      ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                       {
                                                         if(item.divOdd == "0") 
                                                           return "my-backColumn0";
                                                         else 
                                                           return "my-backColumn1";
                                                       } 
                                                        //,width : "5%"
                                                    }
                                                  , {                            
                                                       dataField : result.header[0].m3H3
                                                      ,headerText : "<spring:message code='sys.scm.salesplan.M3' />"
                                                      ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                       {
                                                         if(item.divOdd == "0") 
                                                           return "my-backColumn0";
                                                         else 
                                                           return "my-backColumn1";
                                                       } 
                                                        //,width : "5%"
                                                    }
                                                  , {                            
                                                       dataField : result.header[0].m4H4
                                                      ,headerText : "<spring:message code='sys.scm.salesplan.M4' />"
                                                      ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                       {
                                                         if(item.divOdd == "0") 
                                                           return "my-backColumn0";
                                                         else 
                                                           return "my-backColumn1";
                                                       } 
                                                        //,width : "5%"
                                                    }
                                                  , {                            
                                                       dataField : result.header[0].supplyCorpHOverdue
                                                      ,headerText : "<spring:message code='sys.scm.supplyCorp.Overdue' />"
                                                      ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                       {
                                                         if(item.divOdd == "0") 
                                                           return "my-backColumn0";
                                                         else 
                                                           return "my-backColumn1";
                                                       } 
                                                        //,width : "5%"
                                                    }
                                                 ] // child                     
                                    } 
                                 ) //push
                               ;

                  var iM0TotCnt =   parseInt(result.seperaionInfo[0].m0TotCnt);   
                  var iM1TotCnt =   parseInt(result.seperaionInfo[0].m1TotCnt);   
                  var iM2TotCnt =   parseInt(result.seperaionInfo[0].m2TotCnt);   
                  var iM3TotCnt =   parseInt(result.seperaionInfo[0].m3TotCnt);   
                  
                  var iLootCnt = 1;
                  var iLootDataFieldCnt = 0;
                  var intToStrFieldCnt ="";
                  var fieldStr ="";
                  var strWeekTh = "W"
      
                  // M+0   : 당월    remainCnt
                  var groupM_0 = {
                     headerText : "<spring:message code='sys.scm.salesplan.M0' />",
                     style : "my-header", 
                    // width : 20, 
                     children : []
                  }
                  
                 for(var i=0; i < 5; i++) 
                 {
                    fieldStr = "w" + iLootCnt + "WeekSeq";  //w1WeekSeq   result.header[0].w1WeekSeq 
                    // console.log("loop_i_value: " + i  +" M0_TotCnt: " + iM0TotCnt
                    //           +" / fieldStr: " +  fieldStr  
                    //           +" / field_Name_with: " +  result.header[0][fieldStr]  
                    //           +" / field_name_sel: " + "w0"+result.getChildField[i].weekTh +'-'+ result.getChildField[i].weekThSn  // == result.header[0].w1WeekSeq
                    //           +" / WEEK_TH: " + result.getChildField[i].weekTh);  // == result.header[0].w1WeekSeq
                    
                    intToStrFieldCnt = iLootDataFieldCnt.toString();
                             
                    if (intToStrFieldCnt.length == 1)
                    {
                     intToStrFieldCnt =  "0" + intToStrFieldCnt;
                    }
  
                    if (parseInt(result.getChildField[i].weekTh) <  parseInt(gWeekThValue))
                    {
                      if (result.getChildField[i].weekTh.toString().length < 2)
                      {
                        strWeekTh = "W0"
                      }
                      else
                      {
                        strWeekTh = "W"
                      }

                      sumWeekThStr = "bef" + (i+1) + "WeekTh";  //w1WeekSeq   result.header[0].w1WeekSeq 

                      console.log("sumWeekThStr: " + sumWeekThStr);
                           
                      groupM_0.children.push(
                      {
                           dataField :  sumWeekThStr,   // bef1WeekTh
                           headerText : strWeekTh + result.getChildField[i].weekTh,
                           editable: false,
                           style : "my-backColumn2"  
                           // result.getChildField[i].weekTh +'-'+ result.getChildField[i].weekThSn // w1WeekSeq  == W02-1  
                      }); 
   
                      continue;
                    }
                    else if (parseInt(result.getChildField[i].weekTh) ==  parseInt(gWeekThValue))
                    {
                      groupM_0.children.push(
                                              {
                                                 dataField : "w" + intToStrFieldCnt,   // "w00"
                                                 headerText :result.header[0][fieldStr], 
                                                 editable: false,
                                                 style : "my-backColumn3"  
                                              });
                    }
                    else 
                    { 
                      groupM_0.children.push(
                                              {
                                                 dataField : "w" + intToStrFieldCnt,   // "w00"
                                                 headerText :result.header[0][fieldStr], 
                                                 style : "my-backColumn3"
                                              });
                    }
                    
                    iLootCnt++;
                    iLootDataFieldCnt++;
                 }
                 dynamicLayout.push(groupM_0);
               
                  // M+1
                 var groupM_1 = {
                     headerText : "M+1",
                     style : "my-header", 
                   //  width : 20,
                     children : []
                 }
  
                 for(var i=0; i<iM1TotCnt ; i++) 
                 {
                    fieldStr = "w" + iLootCnt + "WeekSeq";  
                    
                    intToStrFieldCnt = iLootDataFieldCnt.toString();
                      
                    if (intToStrFieldCnt.length == 1)
                    {
                      intToStrFieldCnt =  "0" + intToStrFieldCnt;
                    }
   
                    groupM_1.children.push(
                                            {
                                             dataField : "w" + intToStrFieldCnt,
                                             headerText :  result.header[0][fieldStr], 
                                             style : "my-backColumn3"
                                            }); 
  
                    iLootCnt ++;
                    iLootDataFieldCnt++;
                  }
                  dynamicLayout.push(groupM_1);
  
                  
                  // M+2
                  var groupM_2 = {
                     headerText : "M+2",
                     style : "my-header", 
                 //    width : 20,
                     children : []
                  }
                  
                 for(var i=0; i<iM2TotCnt ; i++) 
                 {
                   fieldStr = "w" + iLootCnt + "WeekSeq";  
  
                   intToStrFieldCnt = iLootDataFieldCnt.toString();
                      
                   if (intToStrFieldCnt.length == 1)
                   {
                     intToStrFieldCnt =  "0" + intToStrFieldCnt;
                   }
  
                   groupM_2.children.push(
                                           {
                                                    dataField : "w" + intToStrFieldCnt,
                                                    headerText :  result.header[0][fieldStr],
                                                    style : "my-backColumn1"
                                           });
  
                   iLootCnt ++;
                   iLootDataFieldCnt++;
                }
                 dynamicLayout.push(groupM_2);
               
  
                 // M+3
                 var groupM_3 = {
                    headerText : "M+3",
                    style : "my-header",
                 //   width : 20,
                    children : []
                 }
                 
                  for(var i=0; i< iM3TotCnt ; i++) 
                 {
                    fieldStr = "w" + iLootCnt + "WeekSeq";  
                    
                  intToStrFieldCnt = iLootDataFieldCnt.toString();
                      
                  if (intToStrFieldCnt.length == 1)
                  {
                    intToStrFieldCnt =  "0" + intToStrFieldCnt;
                  }
                   
                  groupM_3.children.push(
                                          {
                                              dataField : "w" + intToStrFieldCnt,
                                              headerText :  result.header[0][fieldStr],
                                              style : "my-backColumn1"
                                          });
  
                  iLootCnt ++;
                  iLootDataFieldCnt++;                                   
                 }

                 dynamicLayout.push(groupM_3);
  
                //Dynamic Grid Event Biding
                myGridID = AUIGrid.create("#dynamic_DetailGrid_wrap", dynamicLayout, dynamicOption);

                // 헤더 클릭 핸들러 바인딩
                AUIGrid.bind(myGridID, "headerClick", headerClickHandler);  
  
                // 에디팅 시작 이벤트 바인딩
                AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditignHandler);
                
                // 에디팅 정상 종료 이벤트 바인딩
                AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditignHandler);
                
                // 에디팅 취소 이벤트 바인딩
                AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditignHandler);
                
                // 행 추가 이벤트 바인딩 
                //AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);
                
                // 행 삭제 이벤트 바인딩 
                //AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);
  
                // cellClick event.
                AUIGrid.bind(myGridID, "cellClick", function( event ) 
                {
                  var selGridCode = AUIGrid.getCellValue(myGridID, event.rowIndex, "code");
               	                      
                  console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " eventValue: " + event.value
                          + " code: " + selGridCode + " headerText: " + event.headerText); 
                });
  
             // 셀 더블클릭 이벤트 바인딩
                AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
                {
                  console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
                });   
  

              fnSearchBtnList();
               // summaryHead Setting.
               // fnSelectSummaryHeadList(result.header[0]);
               // summary Data Select
               // selectStockCtgrySummaryList();
              
            }
          }
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
}

/****************************  Form Ready ******************************************/

var myGridID , summaryGridID;

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
<h2>Supply Plan By CDC</h2>
<ul class="right_btns">
	<li>
	 <p class="btn_blue">
	   <a onclick="fnSettiingHeader();">
	     <span class="search"></span>Search
	   </a>
	 </p>
 </li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->

<form id="MainForm" method="post" action="">

	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
		<col style="width:160px" />
		<col style="width:*" />
		<col style="width:150px" />
		<col style="width:*" />
	</colgroup>
	<tbody>
	<tr>
		<th scope="row">EST Year &amp; Week</th>
		<td>
	
    <div class="date_set w100p"><!-- date_set start -->
     <select class="sel_year" id="scmYearCbBox" name="scmYearCbBox">
	   </select>  
	  <select class="sel_date"  id="scmPeriodCbBox" name="scmPeriodCbBox" onchange="fnChangeEventPeriod(this);">
	  </select>
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
		<th scope="row">Planning Status</th>
		<td>
		  <div class="status_result">
		  <!-- circle_red, circle_blue, circle_grey -->
	      <p><span id ="cir_sales" class="circle circle_grey"></span> Sales</p>    
	      <p><span id ="cir_save" class="circle circle_grey"></span> Plan Save</p>
	      <p><span id ="cir_cinfirm" class="circle circle_grey"></span> Confirm</p>
    </div>
		</td>
	</tr>
	</tbody>
	</table><!-- table end -->
	
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

<section class="search_result"><!-- search_result start -->

<div class="side_btns"><!-- side_btns start -->
<ul class="left_btns">
	<li>
	 <p class="btn_grid">
	   <!-- <a href="javascript:void(0);">Change Selected Items' Status To Saved</a> -->
	     <input type='button' id='SaveBtn' value="Change Selected Items' Status To Saved" disabled />
	 </p>
	</li>
	
	<li>
	 <p class="btn_grid">
	  <!--  <a href="javascript:void(0);">Confirm</a> -->
	   <input type='button' id='ConfirmBtn' name='ConfirmBtn' value='Confirm' disabled />
	 </p>
	</li>
	
	<li>
	 <p class="btn_grid">
	   <!-- <a href="javascript:void(0);">Update M0 Data</a> -->
	   <input type='button' id='UpdateBtn' name='UpdateBtn' value='Update M0 Data' disabled />
	 </p>
	</li>
</ul>

<ul class="right_btns">
	<li>
	 <p class="btn_grid">
	   <!-- <a href="javascript:void(0);">Re-Calculate</a> -->
	   <input type='button' id='Re-CalculateBtn' name='Re-CalculateBtn' value='Re-Calculate' disabled />
	 </p>
	</li>
	<li>
	 <p class="btn_grid">
   <!-- <a href="javascript:void(0);">Test</a> -->
   <input type='button' id='Test' name='Test' value='Test' disabled />
	 </p></li>
</ul>
</div><!-- side_btns end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 -->
 <div id="dynamic_DetailGrid_wrap" style="height:350px;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li>
	 <p class="btn_blue2 big">
<!-- 	   <a href="javascript:void(0);">Download Raw Data</a> -->
	 </p>
	</li>
</ul>

</section><!-- search_result end -->

</section><!-- content end -->