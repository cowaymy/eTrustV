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
  text-align:right;
}

.my-backColumn1 {
  background:#1E9E9E; 
  color:#000;
  text-align:right;
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
  //setting StockCode ComboBox 
  fnSetStockComboBox();   
  // set StockType
  fnSelectStockTypeComboList('15');
});

function fnSelectPeriodReset()
{
   CommonCombo.initById("scmPeriodCbBox");  // reset...
   var periodCheckBox = document.getElementById("scmPeriodCbBox");
       periodCheckBox.options[0] = new Option("Select a YEAR","");  
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
                
            CommonCombo.initById("scmPeriodCbBox");  // reset... 

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
  gWeekThValue = object.value
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

function fnSelectStockTypeComboList(codeId)
{
    CommonCombo.make("scmStockType"
              , "/scm/selectComboSupplyCDC.do"  
              , { codeMasterId: codeId }       
              , ""                         
              , {  
                  id  : "codeId",     // use By query's parameter values                
                  name: "codeName",
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
   Common.ajax("GET", "/scm/selectSupplyCorpListSearch.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 fnSearchBtnList: " + result.length);
              AUIGrid.setGridData(myGridID, result.selectSupplyCorpList);
              if(result != null && result.length > 0)
              {
              }
           });
   
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
                    showStateColumn : false, // 행 상태 칼럼 보이기
                    showEditedCellMarker : false, // 셀 병합 실행
                    //enableCellMerge : true,
                    // 고정칼럼 카운트 지정
                    fixedColumnCount : 5               
                  };

  console.log("year: " + $('#scmYearCbBox').val() + " /week_th: " + $('#scmPeriodCbBox').val() + " /stock: " + $('#stockCodeCbBox').val());  
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
              
              return false;  
            }
                            
           //  AUIGrid.setGridData(myGridID, result);
             if(result.header != null && result.header.length > 0)
             {
                   dynamicLayout.push( 
                                        { 
                                          headerText : "Stock"
                                        , style : "my-header" 
                                        , children : [
                                                          
                                                          {                            
                                                             dataField : result.header[0].categoryH1
                                                             ,headerText : "<spring:message code='sys.scm.salesplan.Category' />"
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
                                                             ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                              {
                                                                if(item.divOdd == "0") 
                                                                  return "my-backColumn0";
                                                                else 
                                                                  return "my-backColumn1";
                                                              } 
                                                           }
                                                         , {                            
                                                             dataField : result.header[0].stkTypeIdH1 //stkTypeId
                                                             ,headerText : "<spring:message code='sys.scm.inventory.stockType' />"
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
                                                            ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
                                                             {
                                                               if(item.divOdd == "0") 
                                                                 return "my-backColumn0";
                                                               else 
                                                                 return "my-backColumn1";
                                                             } 
                                                           } 
   
                                                     ]
                                        }   
                                        
                                    
                                /****** Monthly *****/
                                       ,{                            
                                            headerText : "Monthly"
                                          , style : "my-header" 
                                        //	, width : 7
                                          , children : [
																												  {                            
																													   dataField : result.header[0].todayH2  // m0
																													  ,headerText : "<spring:message code='sys.scm.salesplan.M0' />"
	                                                          ,styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
	                                                           {
	                                                             if(item.divOdd == "0") 
	                                                               return "my-backColumn0";
	                                                             else 
	                                                               return "my-backColumn1";
	                                                           } 
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
	                                                        }
                                                       ] // children                     
                                        } 
       
                                     ) //push
                                   ;

                    
                   var iM0TotCnt =   parseInt(result.seperaionInfo[0].m0TotCnt);   
                   var iM1TotCnt =   parseInt(result.seperaionInfo[0].m1TotCnt);   
                   var iM2TotCnt =   parseInt(result.seperaionInfo[0].m2TotCnt);   
                   var iM3TotCnt =   parseInt(result.seperaionInfo[0].m3TotCnt);   
                   
                   var iLootCnt = 1;
                   var iLootCnt2 = 1; //Next Year
                   var nextRowFlag = "";
                   var iLootDataFieldCnt = 0;
                   var intToStrFieldCnt ="";
                   var fieldStr ="";
                   var strWeekTh = "W"
       
                   // M+0   : 당월    remainCnt
                   var groupM_0 = {
                      headerText : "<spring:message code='sys.scm.salesplan.M0' />",
                      style : "my-header", 
                      children : []
                   }
                   
                  for(var i=0; i < 5; i++) 
                  {
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
                            
                       groupM_0.children.push({
										                            dataField :  sumWeekThStr,   // bef1WeekTh
										                            headerText : strWeekTh + result.getChildField[i].weekTh,
										                            editable: false,
										                            styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
										                            {
										                              if(item.divOdd == "0") 
										                                return "my-backColumn0";
										                              else 
										                                return "my-backColumn1";
										                            } 
										                            // result.getChildField[i].weekTh +'-'+ result.getChildField[i].weekThSn // w1WeekSeq  == W02-1  
										                       }); 
    
                       continue;
                     }
                     else if (parseInt(result.getChildField[i].weekTh) ==  parseInt(gWeekThValue))
                     {

                       if (nextRowFlag == "R2")
                       {
                          fieldStr = "w" + iLootCnt2 + "WeekSeq";
                         
                          groupM_0.children.push({
											                              dataField : "w" + intToStrFieldCnt,   // "w00"
											                              headerText :result.header[1][fieldStr], 
											                              editable: false,
								                                    formatString : "#,##0",
								                                    dataType : "numeric",
											                              styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
											                              {
											                                if(item.divOdd == "0") 
											                                  return "my-backColumn0";
											                                else 
											                                  return "my-backColumn1";
											                              } 
											                            });

                          iLootCnt2++;
                       }
                       else
                       {
                    	    fieldStr = "w" + iLootCnt + "WeekSeq"; 
                    	    
                          groupM_0.children.push({
										                               dataField : "w" + intToStrFieldCnt,   // "w00"
										                               headerText :result.header[0][fieldStr], 
										                               editable: false,
                                                   formatString : "#,##0",
                                                   dataType : "numeric",
										                               styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
										                               {
										                                 if(item.divOdd == "0") 
										                                   return "my-backColumn0";
										                                 else 
										                                   return "my-backColumn1";
										                               } 
										                             });

                           iLootCnt++;
                       }    

                     }
                     else 
                     { 
                        if (nextRowFlag == "R2")
                        {
                           fieldStr = "w" + iLootCnt2 + "WeekSeq";
                          
                           groupM_0.children.push({
											                               dataField : "w" + intToStrFieldCnt,   // "w00"
											                               headerText :result.header[1][fieldStr], 
	                                                   formatString : "#,##0",
	                                                   dataType : "numeric",
											                               styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
											                               {
											                                 if(item.divOdd == "0") 
											                                   return "my-backColumn0";
											                                 else 
											                                   return "my-backColumn1";
											                               } 
											                             });

                           iLootCnt2++;
                        }
                        else
                        {
                        	 fieldStr = "w" + iLootCnt + "WeekSeq";  //w1WeekSeq   result.header[0].w1WeekSeq 
                        	
                           groupM_0.children.push({
										                                dataField : "w" + intToStrFieldCnt,   // "w00"
										                                headerText :result.header[0][fieldStr], 
	                                                  formatString : "#,##0",
	                                                  dataType : "numeric",
										                                styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
										                                {
										                                  if(item.divOdd == "0") 
										                                    return "my-backColumn0";
										                                  else 
										                                    return "my-backColumn1";
										                                } 
										                             });

                           iLootCnt++;

                        }
                     }

                     if (result.header[0][fieldStr] == "W52")
                     {
                       console.log("M+0..W52..START");
                       nextRowFlag = "R2";
                     } 

                     iLootDataFieldCnt++;
                  }
                  dynamicLayout.push(groupM_0);

                  
                   //////////////////////////////////////////                
                   // M+1
                   /////////////////////////////////////////
                  var groupM_1 = {
                      headerText : "M+1",
                      style : "my-header", 
                      children : []
                  }
   
                  for(var i=0; i<iM1TotCnt ; i++) 
                  {
                     intToStrFieldCnt = iLootDataFieldCnt.toString();
                       
                     if (intToStrFieldCnt.length == 1)
                     {
                       intToStrFieldCnt =  "0" + intToStrFieldCnt;
                     }

                     if (nextRowFlag == "R2")
                     {
                       fieldStr = "w" + iLootCnt2 + "WeekSeq";  
                       
                       groupM_1.children.push({
											                           dataField : "w" + intToStrFieldCnt,
											                           headerText :  result.header[1][fieldStr],
                                                 formatString : "#,##0",
                                                 dataType : "numeric",
											                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
											                           {
											                             if(item.divOdd == "0") 
											                               return "my-backColumn0";
											                             else 
											                               return "my-backColumn1";
											                           } 
											                          }); 
                         
                       iLootCnt2 ++;                  
                     }
                     else
                     {
                    	  fieldStr = "w" + iLootCnt + "WeekSeq";  
                    	 
                        groupM_1.children.push({
											                            dataField : "w" + intToStrFieldCnt,
											                            headerText :  result.header[0][fieldStr],
                                                  formatString : "#,##0",
                                                  dataType : "numeric",
											                            styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
											                            {
											                              if(item.divOdd == "0") 
											                                return "my-backColumn0";
											                              else 
											                                return "my-backColumn1";
											                            } 
											                          }); 
                         iLootCnt ++;
                     }

                     if (result.header[0][fieldStr] == "W52")
                     {
                         console.log("M+1..W52..START");
                         nextRowFlag = "R2";
                     }

                     iLootDataFieldCnt++;
                   }
                   dynamicLayout.push(groupM_1);
   

                   /////////////////////////////////////
                   // M+2
                   /////////////////////////////////////
                   var groupM_2 = {
                      headerText : "M+2",
                      style : "my-header", 
                      children : []
                   }
                   
                  for(var i=0; i<iM2TotCnt ; i++) 
                  {
                    intToStrFieldCnt = iLootDataFieldCnt.toString();
                       
                    if (intToStrFieldCnt.length == 1)
                    {
                      intToStrFieldCnt =  "0" + intToStrFieldCnt;
                    }

                    if (nextRowFlag == "R2")
                    {
                      fieldStr = "w" + iLootCnt2 + "WeekSeq";
                      
                      groupM_2.children.push({
											                          dataField : "w" + intToStrFieldCnt,
											                          headerText :  result.header[1][fieldStr],
                                                formatString : "#,##0",
                                                dataType : "numeric",
											                          styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
											                          {
											                            if(item.divOdd == "0") 
											                              return "my-backColumn0";
											                            else 
											                              return "my-backColumn1";
											                          } 
										                         });  
                      
                      iLootCnt2 ++;                  
                    }
                    else                    
                    {
                      fieldStr = "w" + iLootCnt + "WeekSeq"; 
                        
	                    groupM_2.children.push({
	                                             dataField : "w" + intToStrFieldCnt,
	                                             headerText :  result.header[0][fieldStr],
                                               formatString : "#,##0",
                                               dataType : "numeric",
	                                             styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
	                                             {
	                                               if(item.divOdd == "0") 
	                                                 return "my-backColumn0";
	                                               else 
	                                                 return "my-backColumn1";
	                                             } 
	                                            });
	   
	                    iLootCnt ++;
                    }

                    if (result.header[0][fieldStr] == "W52")
                    {
                      console.log("M+2..W52..START");
                      nextRowFlag = "R2";
                    }
                    
                    iLootDataFieldCnt++;
                 }
                  dynamicLayout.push(groupM_2);


                  //////////////////////////////////////
                  // M+3
                  //////////////////////////////////////
                  var groupM_3 = {
                     headerText : "M+3",
                     style : "my-header",
                     children : []
                  }
                  
                  for(var i=0; i< iM3TotCnt ; i++) 
                  {
	                   intToStrFieldCnt = iLootDataFieldCnt.toString();
	                       
	                   if (intToStrFieldCnt.length == 1)
	                   {
	                     intToStrFieldCnt =  "0" + intToStrFieldCnt;
	                   }
	
	                   if (nextRowFlag == "R2")
	                   {
	                     fieldStr = "w" + iLootCnt2 + "WeekSeq";
	                     
	                     groupM_3.children.push({
												                         dataField : "w" + intToStrFieldCnt,
												                         headerText :  result.header[1][fieldStr],
                                                 formatString : "#,##0",
                                                 dataType : "numeric",
												                         styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
												                         {
												                           if(item.divOdd == "0") 
												                             return "my-backColumn0";
												                           else 
												                             return "my-backColumn1";
												                         } 
												                      }); 
	                      
	                     iLootCnt2 ++;                  
	                   }
	                   else
	                   {
	                	    fieldStr = "w" + iLootCnt + "WeekSeq"; 
	                	   
			                  groupM_3.children.push({
			                                           dataField : "w" + intToStrFieldCnt,
			                                           headerText :  result.header[0][fieldStr],
                                                 formatString : "#,##0",
                                                 dataType : "numeric",
			                                           styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField)
			                                           {
			                                             if(item.divOdd == "0") 
			                                               return "my-backColumn0";
			                                             else 
			                                               return "my-backColumn1";
			                                           } 
			                                         });
			   
			                  iLootCnt ++;
	                   }
	
	                   if (result.header[0][fieldStr] == "W52")
	                   {
	                     console.log("M+3..W52..START");
	                     nextRowFlag = "R2";
	                   }                     
	                    
	                   iLootDataFieldCnt++;                                   
                  }
 
                  dynamicLayout.push(groupM_3);
   
                 //Dynamic Grid Event Biding
                 myGridID = AUIGrid.create("#dynamic_DetailGrid_wrap", dynamicLayout, dynamicOption);
   
                 // 에디팅 시작 이벤트 바인딩
                 //AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditignHandler);
                 
                 // 에디팅 정상 종료 이벤트 바인딩
                 //AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditignHandler);
                 
                 // 에디팅 취소 이벤트 바인딩
                 //AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditignHandler);
                 
                 // 행 추가 이벤트 바인딩 
                 //AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);
                 
                 // 행 삭제 이벤트 바인딩 
                 //AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);
   
   
                 // cellClick event.
                 AUIGrid.bind(myGridID, "cellClick", function( event ) 
                 {
                     gSelMainRowIdx = event.rowIndex;
                     
                     console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedAuthId: " + $("#selAuthId").val() );        
                 });
   
              // 셀 더블클릭 이벤트 바인딩
                 AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
                 {
                     console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
                 });   
   
               ////////////////////////////////////
               //Data Search
               ////////////////////////////////////
               
               fnSearchBtnList();
                               
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

var myGridID ;

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
<h2>Supply Plan Summary View</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSettiingHeader();"><span class="search"></span>Search</a></p></li> 
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
		<!-- <col style="width:160px" />
		<col style="width:*" />
		<col style="width:90px" />
		<col style="width:*" /> -->
		<col style="width:160px" />
    <col style="width:*" />
    <col style="width:90px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
	</colgroup>
	<tbody>
	<tr>
		<th scope="row">EST Year &amp; Week</th>
		<td>
		  <div class="date_set w100p"><!-- date_set start -->
        <select class="sel_year" id="scmYearCbBox" name="scmYearCbBox">
        </select>
			
			  <select class="sel_date" id="scmPeriodCbBox" name="scmPeriodCbBox" onchange="fnChangeEventPeriod(this);">
		    </select>
		  </div><!-- date_set end -->
	
		</td>
		<th scope="row">Stock</th>
		<td>
		<select class="w100p" id="stockCodeCbBox" name="stockCodeCbBox">
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

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a onclick="fnExcelExport();">EXCEL</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 -->
 <div id="dynamic_DetailGrid_wrap" style="height:350px;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li>
	 <p class="btn_blue2 big">
	 <!--   <a href="javascript:void(0);">Download Raw Data</a> -->
	 </p>
	</li>
</ul>

</section><!-- search_result end -->

</section><!-- content end -->