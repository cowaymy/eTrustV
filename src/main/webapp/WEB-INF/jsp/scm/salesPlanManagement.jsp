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

.my-backColumn1 {
  text-align:right;
  background:#818284;
  color:#000;
}

.my-backColumn2 {
  text-align:right;
  background:#a1a2a3;
  color:#000;
}

.my-editable {
  background:#A9BCF5;
  color:#000;
}

.Atag-Disabled {
   pointer-events: none;
   cursor: default;
}

</style>

<script type="text/javaScript">

var gSelMainRowIdx = 0;
var gSelMstRolLvl = "";
var dealerComboBoxList = new Array();
var gPlanId = "";
var gWeekThValue ="";
var gplanDtlId = "";  // seq
var gplanMasterId = "";
var insertVisibleFields = ["scmGrYear","scmGrWeek","preM3AvgOrded","preM3AvgIssu","newStockCode","m1Ord", "m2Ord"  ,"m3Ord" ,"m33" ,"m22",  "m11" ,"m0Plan"  ,"m0Ord" ] ;
var gAddrowCnt = 0;

$(function() 
{
 //stock type
	fnSelectStockTypeComboList('15');
 // set Year
  fnSelectExcuteYear();
 // set PeriodByYear
  fnSelectPeriodReset();
 //setting scm teamCode ComboBox
	fnSetSCMTeamComboBox();
 //setting StockCategoryCode ComboBox	
	fnSetStockCategoryComboBox(); 
 //setting StockCode ComboBox	
	fnSetStockComboBox(); 

});

/*********************************/
 var mstColumnLayout = 
    [ 
        {    
            dataField : "codeMasterId",
            headerText : "<spring:message code='sys.generalCode.grid1.MASTER_ID' />",
            width : "8%",
        }, {
            dataField : "codeMasterName", 
            headerText : "<spring:message code='sys.generalCode.grid1.MASTER_NAME' />",
            style : "aui-grid-left-column",
            width : "25%",
        }, {
            dataField : "codeDesc",
            headerText : "<spring:message code='sys.generalCode.grid1.CODE_DESCRIPTION' />",
            style : "aui-grid-left-column",
            width : "30%",
        }, {
            dataField : "createName",
            headerText : "<spring:message code='sys.generalCode.grid1.CREATOR' />",
            style : "aui-grid-left-column",
            width : "13%",
        }, {
            dataField : "crtDt",
            headerText : "<spring:message code='sys.generalCode.grid1.CREATE_DATE' />",
            dataType : "date",
            formatString : "dd-mmm-yyyy HH:MM:ss",
            width : "15%",
        }, {
            dataField : "disabled",
            headerText : "<spring:message code='sys.generalCode.grid1.DISABLED' />",
            width : "9%",
            editRenderer : {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                listFunction : function(rowIndex, columnIndex, item, dataField) {
                   var list = getDisibledComboList();
                   return list;                 
                },
                keyField : "id"
            }
        }
    ];


//
function fnInsertGridCreate()
{
var options = {
                  usePaging : true,
                  useGroupingPanel : false,
                  showRowNumColumn : false, // 순번 칼럼 숨김
                };
    
    // masterGrid 그리드를 생성합니다.
    gInsertGridID = GridCommon.createAUIGrid("insertGridDivID", mstColumnLayout,"codeMasterId", options);
    // AUIGrid 그리드를 생성합니다.
    

    // 푸터 객체 세팅
    //AUIGrid.setFooter(myGridID, footerObject);
    
    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(gInsertGridID, "cellEditBegin", auiCellEditignHandler);
    
    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(gInsertGridID, "cellEditEnd", auiCellEditignHandler);
    
    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(gInsertGridID, "cellEditCancel", auiCellEditignHandler);
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(gInsertGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(gInsertGridID, "removeRow", auiRemoveRowHandler);


    // cellClick event.
    AUIGrid.bind(gInsertGridID, "cellClick", function( event ) 
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        gSelRowIdx = event.rowIndex;

        if (AUIGrid.isAddedById(gInsertGridID ,AUIGrid.getCellValue(gInsertGridID, event.rowIndex, 0)) == true
                || String(event.value).length < 1)
            {
                    return false;
            } 

            $("#mstCdId").val( event.value);
            
            fn_getDetailCode(gInsertGridID, event.rowIndex);
        
    });

 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(gInsertGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

    });   


    /**********************/
}

function fnShowGrid()
{
  $("#dynamic_DetailGrid_wrap").hide();
  fnInsertGridCreate();
  $("#insertGridDivID").show();
}
function fnHideGrid()
{
  if(AUIGrid.isCreated(gInsertGridID)){
      AUIGrid.destroy(gInsertGridID);
  }
  $("#insertGridDivID").hide();
  $("#dynamic_DetailGrid_wrap").show();
}
 
/********************************/

function fnSelectPeriodReset()
{
   CommonCombo.initById("scmPeriodCbBox");  // reset...
   var periodCheckBox = document.getElementById("scmPeriodCbBox");
       periodCheckBox.options[0] = new Option("Select a YEAR","");  
}

function fnConfirm(flag)
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

	  if ($("#scmTeamCbBox").val().length < 1) 
	  {
	    Common.alert("<spring:message code='sys.msg.necessary' arguments='TEAM' htmlEscape='false'/>");
	    return false;
	  }
    
	  Common.ajax("POST"
			        , "/scm/updateSalesPlanConfirm.do"
	            , $("#MainForm").serializeJSON()    
	            , function(result) 
	              {
	                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	                fnSearchBtnList();
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

function fnUnConfirm(obj)
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

	  if ($("#scmTeamCbBox").val().length < 1) 
	  {
	    Common.alert("<spring:message code='sys.msg.necessary' arguments='TEAM' htmlEscape='false'/>");
	    return false;
	  }
	    
	  Common.ajax("POST"
			        , "/scm/updateSalesPlanUnConfirm.do"
	            , $("#MainForm").serializeJSON()    
	            , function(result) 
	              {
	                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	                fnSearchBtnList();
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


function fnDelete(obj)
{
	  var data = {};
	  var checkedItemsList = AUIGrid.getCheckedRowItemsAll(myGridID); // 접혀진 자식들이 체크된 경우 모두 얻기

	  console.log("chkList: " + checkedItemsList.length);

	  if(checkedItemsList.length <= 0) 
	  {
	    Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
	    return false;
	  }

	  if (checkedItemsList.length > 0)
	  {
	    for (var icnt = 0; icnt < checkedItemsList.length; icnt++)
	      console.log("code: " + checkedItemsList[icnt].code + " /team: "+ checkedItemsList[icnt].team+ " /PLAN_MASTER_ID: "+ checkedItemsList[icnt].planMasterId );

	    data.checked = checkedItemsList;

	    Common.ajax("POST"
	               ,"/scm/deleteStockCodeList.do"
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

function fnCreate(obj)
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

  if ($("#scmTeamCbBox").val().length < 1) 
  {
    Common.alert("<spring:message code='sys.msg.necessary' arguments='TEAM' htmlEscape='false'/>");
    return false;
  }
	  
	Common.ajax("POST", "/scm/insertSalesPlanMaster.do"
	          , $("#MainForm").serializeJSON()    
	          , function(result) 
	           {
	              Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	              fnSettiingHeader();
	              
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



function fnNumberCheck(inputs)
{
		if(/[^0123456789]/g.test(inputs)) 
		{
		  Common.alert("<spring:message code='sys.common.alert.validationNumber' />");  
		  inputs = "";
		  return false;
		}
		else
			return true;
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
function fnExcelExport(Obj,fileNm)
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID
   if ($(Obj).parents().hasClass("btn_disabled") == true)
     return false;
   
   GridCommon.exportTo("#dynamic_DetailGrid_wrap", "xlsx", fileNm+'_'+getTimeStamp() ); 
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

function fnSetSCMTeamComboBox()
{
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

function fnSetStockComboBox()
{
    CommonCombo.make("stockCodeCbBox"
                   , "/scm/selectStockCode.do"  
                   , ""                         
                   , ""                         
                   , {  
                       id  : "stkCode",          
                       name: "stkDesc",
                       type: "M"
                     }
                   , "");
}

function fnSetStockCategoryComboBox()
{
	  // Call Back
    var stockCodeCallBack = function () 
        {
        
    	    $('#stockCategoryCbBox').on("change", function () 
          {
            var $this = $(this);

            console.log("values: " + $this.val());
    	          
            CommonCombo.initById("stockCodeCbBox");

            if (FormUtil.isNotEmpty($this.val())) 
            {
                CommonCombo.make("stockCodeCbBox"
				                        , "/scm/selectStockCode.do"  
				                        , { codeIds: $this.val() + "" }  //       
				                        , ""                         
				                        , {  
				                        	  id  : "stkCode",          
									                  name: "stkDesc",  
									                  type: "M"
									                }
						                    , "");
            }
            else
            { // ALL
            	fnSetStockComboBox();
            }
            
          });
        };
        
    CommonCombo.make("stockCategoryCbBox"
    	             , "/scm/selectStockCategoryCode.do"
    	             , "" 
    	             , "" 
    	             , { 
                         id  : "codeId",          
                         name: "codeName",  
                         type: "M"
        	           }  
				           , stockCodeCallBack  // callback
				            );  
}

function getDealerComboListAjax(callBack) 
{
    Common.ajaxSync("GET", "/common/selectGSTExportDealerList.do"
                 , $("#MainForm").serialize()
                 , function(result) 
                 {
                    for (var i = 0; i < result.length; i++) 
                    {
                      var list = new Object();
                          list.id = result[i].dealerId;
                          list.value = result[i].dealerName ;

                          dealerComboBoxList.push(list);
                    }

                    //if you need callBack Function , you can use that function
                    if (callBack) 
                    {
                      callBack(dealerComboBoxList);
                    }
                    
                  });
    return dealerComboBoxList;
  }

//AUIGrid 메소드
//컬럼 선택시 상세정보 세팅.
function fnSetSelectedColumn(selGrdidID, rowIdx)  
{     
 $("#selAuthId").val(AUIGrid.getCellValue(selGrdidID, rowIdx, "zreExptId"));
  
 console.log("selAuthId: "+ $("#selAuthId").val() + " dealerName: " + AUIGrid.getCellValue(selGrdidID, rowIdx, "dealerName") );                
}

function auiCellEditignHandler(event) 
{
  if(event.type == "cellEditBegin") 
  {
      console.log("에디팅 시작(cellEditBegin) : (rowIdx: " + event.rowIndex + ",columnIdx: " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
  } 
  else if(event.type == "cellEditEnd") 
  {
      console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value );
      
      if (fnNumberCheck(event.value) == false)
      AUIGrid.setCellValue(myGridID, event.rowIndex , event.columnIndex, "");
          
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

function fnCancel(Obj)
{
	if ($(Obj).parents().hasClass("btn_disabled") == true)
	  return false;
	
	AUIGrid.hideColumnByDataField(myGridID, insertVisibleFields );
	fnSearchBtnList();
}

//MstGrid 행 추가, 삽입
function fnInsertAddRow(Obj) 
{
	if ($(Obj).parents().hasClass("btn_disabled") == true)
	  return false;
	    
  if (gAddrowCnt >= 1)
  {
	  Common.alert("<spring:message code='sys.msg.limitMore' arguments='AddRowCount ; 1' htmlEscape='false' argumentSeparator=';'/>");
	  return false;
  }

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

  if ($("#scmTeamCbBox").val().length < 1) 
  {
    Common.alert("<spring:message code='sys.msg.necessary' arguments='TEAM' htmlEscape='false'/>");
    return false;
  }

  if ($("#stockCategoryCbBox").val().length < 1) 
  {
    Common.alert("<spring:message code='sys.msg.necessary' arguments='Stock Category' htmlEscape='false'/>");
    return false;
  }


  console.log($("#stockCategoryCbBox").val() + " /stockCodeCbBox: " + $("#stockCodeCbBox").val() + " /StockType: " + $("#scmStockType").val() );
	
	
	//AUIGrid.hideColumnByDataField(myGridID, "team" );
  AUIGrid.showColumnByDataField(myGridID, insertVisibleFields );
	
	var addStockCode = $("#stockCodeCbBox").val();   
	//fnGetDetailAndSeqMstId();
	
  var item = new Object();
  
  item.scmGrYear     = $("#scmYearCbBox").val() ; /*not null   searchbtndata_dtlseq : 8194 */  
  item.scmGrWeek     = $("#scmPeriodCbBox").val() ; /*pk 174  */   
  item.team            = $("#scmTeamCbBox").val() ; /*pk*/
  item.code            = "" ; //String(addStockCode);  /*pk*/

  item.category        = "" ;  
  
  item.preM3AvgOrded   ="" ;
  item.preM3AvgIssu    ="" ;
  item.newStockCode    = "";
  
  item.m1Ord          ="0" ;   /* default 0 */
  item.m2Ord          ="" ;
  item.m3Ord          ="" ;
  item.m3             ="" ;
  item.m2             ="" ;
  item.m1             ="" ;
  item.m0Plan         ="" ;
  item.m0Ord          ="" ;
  item.m1             ="" ;
  item.m2             ="" ;
  item.m3             ="" ;
  item.m4             ="" ;

  item.w00            ="" ;
  item.w01            ="" ;
  item.w02            ="" ;
  item.w03            ="" ;
  item.w04            ="" ;
  item.w05            ="" ;
  item.w06            ="" ;
  item.w07            ="" ;
  item.w08            ="" ;
  item.w09            ="" ;
  item.w10            ="" ;
  item.w11            ="" ;
  item.w12            ="" ;
  item.w13            ="" ;
  item.w14            ="" ;
  item.w15            ="" ;
  item.w16            ="" ;
  item.w17            ="" ;
  item.w18            ="" ;
  item.w19            ="" ;
  item.w20            ="" ;
  item.w21            ="" ;
  item.w22            ="" ;
  item.w23            ="" ;
  item.w24            ="" ;
  item.w25            ="" ;
  item.w26            ="" ;
  item.w27            ="" ;
  item.w28            ="" ;
  item.w29            ="" ;
  item.w30            ="" ;

  item.ws1            ="" ;
  item.ws2            ="" ;
  item.ws3            ="" ;
  item.ws4            ="" ;
  item.ws5            ="" ;

  // parameter
  // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
  // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
  AUIGrid.addRow(myGridID, item, "first");

  $('#btnCancel').removeClass("btn_disabled");
  $('#btnUpdate').removeClass("btn_disabled");
  $('#btnInsert').removeClass("btn_disabled");


  gAddrowCnt++;

}

//Make Use_yn ComboList, tooltip


//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) 
{
  console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
  gAddrowCnt = 0;
  //$("#delCancel").show();
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandlerDetail(event) 
{
  console.log (event.type + " 이벤트상세 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
  gAddrowCnt = 0;
}

//행 삭제 메소드
function fnRemoveRow() 
{
  console.log("fnRemoveRowMst: " + gSelMainRowIdx);    
  AUIGrid.removeRow(myGridID,"selectedIndex");
}

function fnSearchRolePopUp() 
{
   var popUpObj = Common.popupDiv("/authorization/searchRolePop.do"
       , $("#MainForm").serializeJSON()
       , null
       , true  
       , "SearchRolePop"
       );
        
}

function fnSetParamAuthCd(myGridID, rowIndex)
{
  $("#zreExptId").val(AUIGrid.getCellValue(myGridID, rowIndex, "zreExptId"));
  $("#dealerName").val(AUIGrid.getCellValue(myGridID, rowIndex, "dealerName"));
   
  console.log("zreExptId: "+ $("#zreExptId").val() + "dealerName: "+ $("#dealerName").val() );     
}

function fnSelectSummaryHeadList(summaryHeadList, summaryHeadList2)
{
  var dynamicSummaryLayout = [];
  var dynamicSummaryOption = {}; 
  var dynamicSummaryFooterLayout = [];
  var dynamicSummaryHeadList = {};
  var dynamicSummaryHeadList2 = {};

	// 이전에 그리드가 생성되었다면 제거함.
  if(AUIGrid.isCreated(summaryGridID)) 
	{
      AUIGrid.destroy(summaryGridID);
  }

  dynamicSummaryHeadList = summaryHeadList; 
  dynamicSummaryHeadList2 = summaryHeadList2; 

	dynamicSummaryOption = {
										       // 푸터 보이게 설정
							             showFooter : true,            
									         showRowNumColumn : false, //순번 칼럼 숨김
							             // editable : true,
							             showStateColumn : false, // 행 상태 칼럼 보이기
							             showEditedCellMarker : false,                  // 셀 병합 실행
							             enableCellMerge : false,
							             selectionMode       : "singleRow",  //"multipleCells",    
							             fixedColumnCount    : 1, 
							             headerHeight : 35
	                       };


    // footer
   dynamicSummaryFooterLayout= [ {
																   labelText : "∑",
																   positionField : dynamicSummaryHeadList.categoryH1 
		                             }
														   , {  // m+1
														        dataField : dynamicSummaryHeadList.m1H2,
														        positionField : dynamicSummaryHeadList.m1H2,
														        operation : "SUM",
														        formatString : "#,##0",
                                    dataType : "numeric",
                                    style : "my-column", 
														     }
														   , {  // m+2
														        dataField : dynamicSummaryHeadList.m2H2,
														        positionField : dynamicSummaryHeadList.m2H2,
														        operation : "SUM",
														        formatString : "#,##0",
                                    dataType : "numeric",
                                    style : "my-column", 														        
														     }
														   , {  // m+3
														        dataField : dynamicSummaryHeadList.m3H3,
														        positionField : dynamicSummaryHeadList.m3H3,
														        operation : "SUM",
														        formatString : "#,##0",
														        dataType : "numeric",
							                      style : "my-column",
														     }
														   , {  // m+4
														        dataField : dynamicSummaryHeadList.m4H4,
														        positionField : dynamicSummaryHeadList.m4H4,
														        operation : "SUM",
														        formatString : "#,##0",
														        dataType : "numeric",
							                      style : "my-column",
														     }
														     
                                ]  
   var iSummaryLoopCnt = 1;
   var iSummaryLoopFieldCnt = 0;
   var intToStrSummaryFieldCnt ="";
   
   for (var i=0; i < 31; i++) 
   {
	   intToStrSummaryFieldCnt = iSummaryLoopFieldCnt.toString();
     
     if (intToStrSummaryFieldCnt.length == 1)
     {
    	 intToStrSummaryFieldCnt =  "0" + iSummaryLoopFieldCnt;
     }
      
     dynamicSummaryFooterLayout.push({
			                                   dataField : "w"+intToStrSummaryFieldCnt,
			                                   positionField : "w"+intToStrSummaryFieldCnt,
			                                   operation : "SUM",
			                                   formatString : "#,##0",
			                                   dataType : "numeric",
			                                   style : "my-column",
			                                }); 
     iSummaryLoopCnt++;
     iSummaryLoopFieldCnt++;
   }

	  if(dynamicSummaryHeadList != null )
    {
        dynamicSummaryLayout.push(  {                            
	                                    dataField : dynamicSummaryHeadList.categoryH1  // category
	                                    ,headerText : "<spring:message code='sys.scm.salesplan.Category' />"
	                                    ,editable : true
	                                  }
	                                 ,{                            
	                                     dataField : dynamicSummaryHeadList.isuueorderH
	                                     ,headerText : "<spring:message code='sys.scm.salesplan.M3_AVG_IssueOrder' />"
	                                     ,editable : true
	                                  }
	                                , {     //m1_Issue_Order   
	                                    dataField : dynamicSummaryHeadList.beforeDayH2
	                                    ,headerText : "<spring:message code='sys.scm.salesplan.M1_issue_IssueOrder_summery' />"   
	                                    ,editable : true
	                                  }
	                                , {                            
	                                    dataField : dynamicSummaryHeadList.todayH2
	                                    ,headerText : "<spring:message code='sys.scm.salesplan.M0_PLN_ORD' />"
	                                    ,editable : true
	                                  }
	
	                                , {                            
	                                    dataField : dynamicSummaryHeadList.m1H2
	                                    ,headerText : "<spring:message code='sys.scm.salesplan.M1' />" 
	                                    ,dataType : "numeric"
	                                    ,formatString : "#,##0"
		                                  ,style : "my-column"
	                                    ,editable : true
	                                  }
	                                , {                            
	                                    dataField : dynamicSummaryHeadList.m2H2
	                                    ,headerText : "<spring:message code='sys.scm.salesplan.M2' />" 
	                                    ,dataType : "numeric"
	                                    ,formatString : "#,##0"
	                                    ,style : "my-column"
	                                    ,editable : true
	                                  }
	                                , {                            
	                                    dataField : dynamicSummaryHeadList.m3H3
	                                    ,headerText : "<spring:message code='sys.scm.salesplan.M3' />"
	                                    ,dataType : "numeric"
	                                    ,formatString : "#,##0"
	                                    ,style : "my-column"                                        
	                                    ,editable : true
	                                  }
	                                , {                            
	                                    dataField : dynamicSummaryHeadList.m4H4
	                                    ,headerText : "<spring:message code='sys.scm.salesplan.M4' />"
	                                    ,dataType : "numeric"
	                                    ,formatString : "#,##0"
		                                  ,style : "my-column"                                        
	                                    ,editable : true
	                                  }
                                ) //push
                                
        var iLootCnt = 1;
        var iLootCnt2 = 1;
        var nextRowFlag = "";
        var fieldStr = "";
        var iLootDataFieldCnt = 0;
        var intToStrFieldCnt ="";
        
        
        for (var i=0; i < 31; i++) 
        {
          //2016 41 DST WP
           
          if (nextRowFlag == "R2")
			    {
            fieldStr = "w" + iLootCnt2 + "WeekSeq";  //w1WeekSeq   result.header[0].w1WeekSeq 
            
            intToStrFieldCnt = iLootDataFieldCnt.toString();
            
            if (intToStrFieldCnt.length == 1)
            {
              intToStrFieldCnt =  "0" + intToStrFieldCnt;
            }

           // console.log("summary_fieldStr222222: " + fieldStr + " /headerText: " + dynamicSummaryHeadList2[fieldStr]  +" /dataField: " + "w"+intToStrFieldCnt);            
			    
        	  dynamicSummaryLayout.push({
                  dataField : "w"+intToStrFieldCnt,   
                  headerText : dynamicSummaryHeadList2[fieldStr],  // "w00"
                  editable: false,
                  dataType : "numeric",
                  formatString : "#,##0",
                  style : "my-column"   
              }); 
              
			      iLootCnt2++;                  
			    }
			    else 
          {

            fieldStr = "w" + iLootCnt + "WeekSeq";  //w1WeekSeq   result.header[0].w1WeekSeq 
            
            intToStrFieldCnt = iLootDataFieldCnt.toString();
            
            if (intToStrFieldCnt.length == 1)
            {
              intToStrFieldCnt =  "0" + intToStrFieldCnt;
            }
		                   
            dynamicSummaryLayout.push({
				                                  dataField : "w"+intToStrFieldCnt,   
				                                  headerText : dynamicSummaryHeadList[fieldStr],  // "w00"
				                                  editable: false,
			                                    dataType : "numeric",
			                                    formatString : "#,##0",  
                                          style : "my-column"
				                              }); 

           iLootCnt++;
          }
           
          if (dynamicSummaryHeadList[fieldStr] == "W52")
          {
               console.log("<<<summary Header W52>>>>");
               nextRowFlag = "R2";
          }

           iLootDataFieldCnt++;
        }
        
        //Dynamic Grid Event Biding
        summaryGridID = AUIGrid.create("#dynamic_SummaryGrid_wrap", dynamicSummaryLayout,dynamicSummaryOption);

        // 푸터 객체 세팅
        AUIGrid.setFooter(summaryGridID, dynamicSummaryFooterLayout);
                       
    }// if 

       
}  // fnSelectSummaryHeadList

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
	                  usePaging : true,
	                  useGroupingPanel : false,
	                  showRowNumColumn : false, //순번 칼럼 숨김
	                  editable : true,
	                  showStateColumn : true, // 행 상태 칼럼 보이기
	                  showEditedCellMarker : true, // 셀 병합 실행
	                  enableCellMerge : true,
	                  // 고정칼럼 카운트 지정
	                  fixedColumnCount : 8,
	                  enableRestore : true,
	                  softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
	                  // 체크박스 표시 설정
	                  showRowCheckColumn : true,              
	                  // 전체 선택 체크박스가 독립적인 역할을 할지 여부
	                  independentAllCheckBox : false,  
	                  rowCheckDisabledFunction : function(rowIndex, isChecked, item) 
	                  {
	                    if(item.checkFlag == "0") { // 이름이 Anna 인 경우 사용자 체크 못하게 함.
	                       return false; // false 반환하면 disabled 처리됨
	                     }
	                     return true;
	                  }                
		              };

  console.log("year: " + $('#scmYearCbBox').val() + " /week_th: " + $('#scmPeriodCbBox').val() + " /team: " + $('#scmTeamCbBox').val());
  Common.ajax("POST", "/scm/selectCalendarHeader.do"
           , $("#MainForm").serializeJSON()
           , function(result) 
           {     
	           if(result.planInfo != null && result.planInfo.length > 0)
		         {
	              $("#planYear").text(result.planInfo[0].planYear);
	              $("#planMonth").text(result.planInfo[0].planMonth);
	              $("#planWeek").text(result.planInfo[0].planWeek);
	              $("#planTeam").text(result.planInfo[0].team);
	              $("#planStatus").text(result.planInfo[0].planStusNm);
	              $("#planCreatedAt").text(result.planInfo[0].crtDt);
			       }

	          // console.log("seperaionInfo: " + result.seperaionInfo.length + " /getChildField: " + result.getChildField.length );

             if( (result.planInfo == null || result.planInfo.length < 1)
                || (result.seperaionInfo == null || result.seperaionInfo.length < 1) 
                || (result.getChildField == null || result.getChildField.length < 1))
             {
            	 Common.alert("<spring:message code='expense.msg.NoData' />");

            	 if(AUIGrid.isCreated(myGridID)){
            		  AUIGrid.destroy(myGridID);
            	 }
            	 if(AUIGrid.isCreated(summaryGridID)){
            		  AUIGrid.destroy(summaryGridID);
            	 }

           	   $("#planYear").text("");
           	   $("#planMonth").text("");
           	   $("#planWeek").text("");
           	   $("#planTeam").text("");
           	   $("#planStatus").text("");
           	   $("#planCreatedAt").text(""); 

            	 return false;  
             }

            //  AUIGrid.setGridData(myGridID, result);
              if(result.header != null && result.header.length > 0)
              {
		            	  dynamicLayout.push({ 
		                			                 headerText : "Stock"
		                			               , children : [
																													{ 
																													    dataField : result.header[0].planMasterIdH
																													   ,headerText :"<spring:message code='sys.scm.salesplan.PlanMasterId' />"
																													   ,editable : true
																													   ,visible : true
																													   ,width : 0
																													  } 
																													, { 
																													    dataField : result.header[0].checkFlag 
																													   ,headerText : "chk"
																													   ,editable : true
																													   ,visible : false
	                                                           
																													  }
																													, { 
																													    dataField : result.header[0].teamH1
																													   ,headerText : "<spring:message code='sys.scm.salesplan.Team' />"
																													   ,editable : true
	                                                           
																													  }
																													, { 
																													    dataField : result.header[0].stkTypeIdH1
																													   ,headerText : "<spring:message code='sys.scm.interface.stockType' />"
																													   ,editable : true
																													  } 
																													, {                            
																													    dataField : result.header[0].categoryH1
																													    ,headerText : "<spring:message code='sys.scm.salesplan.Category' />"
																													    ,editable : true
																													  }
																													, {                            
																													    dataField : result.header[0].codeH1
																													    ,headerText : "<spring:message code='sys.scm.salesplan.Code' />" 
																													    ,editable : true
																													  }
																													, {                            
																													    dataField : result.header[0].nameH1
																													    ,headerText : "<spring:message code='sys.scm.salesplan.Name' />"
																													    ,editable : true
																													  }
		
		                              			              ]
		                        			       }
		                        			       // M-3 AVG Issue/Order
		       			                        ,{                            
		                                          dataField : result.header[0].isuueorderH
		                                          ,headerText : "<spring:message code='sys.scm.salesplan.M3_AVG_IssueOrder' />"
		                                          ,editable : false
		                                     }
		                                            
		                                  // Monthly
		                                   , { 
		                                       headerText : "Monthly"
			                                  // , width : 15
		                                     , children : [
		      		                                     // for insert  
		                                                     {                            
		                                                        dataField : "scmGrYear"
		                                                        ,headerText : "<spring:message code='budget.Year' />"   
		                                                        ,editable : false
		                                                        ,width : 0
		                                                        ,visible: false
		                                                      }
		                                                    , {                            
		                                                        dataField : "scmGrWeek"
		                                                        ,headerText : "<spring:message code='sys.scm.pomngment.EstWeek' />"   
		                                                        ,editable : false
		                                                        ,width : 0
		                                                        ,visible: false
		                                                      }
		                                                    , {                            
		                                                        dataField : "preM3AvgOrded"
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.preM3AvgOrded' />"   
		                                                        ,editable : true
		                                                        ,width : "13%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }
		                                                    , {                            
		                                                        dataField : "preM3AvgIssu"
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.preM3AvgIssu' />"
		                                                        ,editable : true
		                                                        ,width : "13%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }  
		                                                    , {                            
		                                                        dataField : "newStockCode"
		                                                        ,headerText : "NEW_STOCK_CODE"
		                                                        ,editable : true
		                                                        ,width : "13%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }  
		                                                    , {                            
		                                                        dataField : "m1Ord"
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.m1Ord' />"
		                                                        ,editable : true
		                                                        ,width : "5%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 		                                                        
		                                                      }  
		                                                    , {                            
		                                                        dataField : "m2Ord"
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.m2Ord' />"
		                                                        ,editable : true
		                                                        ,width : "5%"
		                                                        ,visible: false  
		                                                        ,style : "my-editable"     
		                                                      }  
		                                                    , {                            
		                                                        dataField : "m3Ord"
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.m3Ord' />"
		                                                        ,editable : true
		                                                        ,width : "5%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }  
		                                                    , {                            
		                                                        dataField : "m33"  //M_3
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.m33' />"
		                                                        ,editable : true
		                                                        ,width : "5%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }  
		                                                    , {                            
		                                                        dataField : "m22"  //M_2
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.m22' />"
		                                                        ,editable : true
		                                                        ,width : "5%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }  
		                                                    , {                            
		                                                        dataField : "m11"  //M_1
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.m11' />"
		                                                        ,editable : true
		                                                        ,width : "5%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }  
		                                                    , {                            
		                                                        dataField : "m0Plan"
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.m0Plan' />"
		                                                        ,editable : true
		                                                        ,width : "5%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }  
		                                                    , {                            
		                                                        dataField : "m0Ord"
		                                                        ,headerText : "<spring:message code='sys.scm.salesplan.m0Ord' />"
		                                                        ,editable : true
		                                                        ,width : "5%"
		                                                        ,visible: false
		                                                        ,style : "my-editable" 
		                                                      }  
		                                                // for insert end. 
		                                                
		                                                    , {                            
		                                                         dataField : result.header[0].beforeDayH2
		                                                         ,headerText : "<spring:message code='sys.scm.salesplan.M1_issue_IssueOrder' />"   
		                                                         ,editable : false
		                                                       }
		                                                     , {                            
		                                                         dataField : result.header[0].todayH2
		                                                         ,headerText : "<spring:message code='sys.scm.salesplan.M0_PLN_ORD' />"
		                                                         ,editable : false
		                                                       }
		                                                     , {                            
		                                                         dataField : result.header[0].m1H2
		                                                         ,headerText : "<spring:message code='sys.scm.salesplan.M1' />" 
		                                                         ,editable : true
		                                                       }
		                                                     , {                            
		                                                         dataField : result.header[0].m2H2
		                                                         ,headerText : "<spring:message code='sys.scm.salesplan.M2' />" 
		                                                         ,editable : true
		                                                       }
		                                                     , {                            
		                                                         dataField : result.header[0].m3H3
		                                                         ,headerText : "<spring:message code='sys.scm.salesplan.M3' />"
		                                                         ,editable : true
		                                                       }
		                                                     , {                            
		                                                         dataField : result.header[0].m4H4
		                                                         ,headerText : "<spring:message code='sys.scm.salesplan.M4' />"
		                                                         ,editable : true
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
							      var iLootCnt2 = 1; //Next Year
							      var nextRowFlag = "";
							      var iLootDataFieldCnt = 0;
										var intToStrFieldCnt ="";
										var fieldStr ="";
										var strWeekTh = "W"
				
				            // M+0   : 당월    remainCnt
		                var groupM_0 = {
		                   headerText : "<spring:message code='sys.scm.salesplan.M0' />",
		                   children : []
		                }
		                
		               for(var i=0; i < 5; i++) 
		               {
		                  /* console.log("loop_i_value: " + i  +" M0_TotCnt: " + iM0TotCnt
		                             +" / fieldStr: " +  fieldStr  
		                             +" / field_Name_with: " +  result.header[0][fieldStr]  
		                             +" / field_name_sel: " + "w0"+result.getChildField[i].weekTh +'-'+ result.getChildField[i].weekThSn  // == result.header[0].w1WeekSeq
		                             +" / WEEK_TH: " + result.getChildField[i].weekTh);  // == result.header[0].w1WeekSeq
		                  */
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
														                     dataType : "numeric",
							                                   formatString : "#,##0",
														                     editable: false,
														                     style : "my-backColumn1"
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
									                                  dataType : "numeric",
									                                  formatString : "#,##0",
									                                  editable: false,
									                                  style : "my-backColumn2"   
									                               });

	                         iLootCnt2++;
				                }
		                	  else
			                	{
		                		  fieldStr = "w" + iLootCnt + "WeekSeq";  //w1WeekSeq   result.header[0].w1WeekSeq 
		                		  
                          groupM_0.children.push({
								                                    dataField : "w" + intToStrFieldCnt,   // "w00"
								                                    headerText :result.header[0][fieldStr],
								                                    dataType : "numeric", 
								                                    formatString : "#,##0",
								                                    editable: false,
								                                    style : "my-backColumn2"  
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
										                               headerText :result.header[1][fieldStr] ,
										                               dataType : "numeric",
										                               formatString : "#,##0",
										                               style : "my-column",
										                             });

                           iLootCnt2++;
                        }
                        else
				                {
                        	fieldStr = "w" + iLootCnt + "WeekSeq";  //w1WeekSeq   result.header[0].w1WeekSeq 

                          groupM_0.children.push({
														                       dataField : "w" + intToStrFieldCnt,   // "w00"
														                       headerText :result.header[0][fieldStr],
														                       dataType : "numeric",
														                       formatString : "#,##0",
														                       style : "my-column", 
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
		
		  /*               // Grid Child_Field Insert
		           for(var i=0; i < (iM0LoopCnt + 1); i++)
		                {
		          	     groupM_0.children.splice(0+i , 0, {                            
		                                     dataField : "salesCnt"//result.add[i].month
		                                    ,headerText : "w"+(i+1) //+ result.add[i].month
		                                    ,editable : true
		                                    //,width : "5%"
		                                   }); 
		                
		               } */

	                 /////////////////////////////////
			             
		                // M+1
		               var groupM_1 = {
		                   headerText : "M+1",
		                   children : []
		               }
		
		               for(var i=0; i<iM1TotCnt ; i++) 
		               {
		                  //M+1_header_Push: w03 /fieldStr: W48-2
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
									                                dataType : "numeric",
									                                formatString : "#,##0",
									                                style : "my-column",
									                             });   
                        iLootCnt2 ++;                  
                      }
		                  else
			                {

		                    fieldStr = "w" + iLootCnt + "WeekSeq";  
				                
		                    groupM_1.children.push({
														                   dataField : "w" + intToStrFieldCnt,
														                   headerText :  result.header[0][fieldStr],
														                   dataType : "numeric",
														                   formatString : "#,##0",
														                   style : "my-column", 
														                  });

		                    iLootCnt ++;
			                }

		                /*   console.log("M+1_header_DataField: " + "w" + intToStrFieldCnt + " /fieldStr: " + fieldStr
		                             +" /Main_Result.header: " + result.header[0][fieldStr]); */

                      if (result.header[0][fieldStr] == "W52")
                      {
                          console.log("M+1..W52..START");
                          nextRowFlag = "R2";
                      }
		                 
		                  iLootDataFieldCnt++;
		                }
		                dynamicLayout.push(groupM_1);
		

                    /////////////////////////////////
		                
		                // M+2
		                var groupM_2 = {
		                   headerText : "M+2",
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
											                          dataType : "numeric",
											                          formatString : "#,##0",
											                          style : "my-column",
                          });   
                       
                       iLootCnt2 ++;                  
	                   }
	                   else
		                 {
	                	   fieldStr = "w" + iLootCnt + "WeekSeq";  
	                	   
		                   groupM_2.children.push({
											                          dataField : "w" + intToStrFieldCnt,
											                          headerText :  result.header[0][fieldStr],
											                          dataType : "numeric",
											                          formatString : "#,##0",
											                          style : "my-column", 
														                 });
		                   iLootCnt++;
		                 }

                     if (result.header[0][fieldStr] == "W52")
                     {
                      // console.log("M+2..W52..START");
                       nextRowFlag = "R2";
                     }
		                 
		                 iLootDataFieldCnt++;
		              }
		               dynamicLayout.push(groupM_2);

	                /////////////////////////////////
		
		               // M+3
		               var groupM_3 = {
		                  headerText : "M+3",
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
											                           dataType : "numeric",
											                           formatString : "#,##0",
											                           style : "my-column", 
											                         });   
	                       
	                      iLootCnt2 ++;                  
	                    }
	                    else
		                  {
	                    	 fieldStr = "w" + iLootCnt + "WeekSeq";  
	                    	
	                       groupM_3.children.push({
									                                dataField : "w" + intToStrFieldCnt,
									                                headerText :  result.header[0][fieldStr],
									                                dataType : "numeric",
									                                formatString : "#,##0",
									                                style : "my-column",
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
		         	        gSelMainRowIdx = event.rowIndex;
		         	        
		         	        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedAuthId: " + $("#selAuthId").val() );        
		         	    });
		
		         	 // 셀 더블클릭 이벤트 바인딩
		         	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
		         	    {
		         	        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
		         	    });   
		
			            fnSearchBtnList();
		              // summaryHead Setting.
		         	    fnSelectSummaryHeadList(result.header[0], result.header[1]);
		              // summary Data Select
		         	    selectStockCtgrySummaryList();
		         	  
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

function fnInsertSave(Obj)
{
	 if ($(Obj).parents().hasClass("btn_disabled") == true)
	   return false;
	
   if (fnValidationCheck("Add") == false)
   {
     return false;
   } 

   Common.ajax("POST"
	        , "/scm/saveInsScmSalesPlan.do"
	        , GridCommon.getEditData(myGridID)
	       
	        , function(result) 
	          {
	            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	            
	            AUIGrid.hideColumnByDataField(myGridID, insertVisibleFields );
	            AUIGrid.clearGridData(myGridID);
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

function fnSaveScmSalesPlan(Obj) 
{
	//console.log($(Obj).parents().hasClass("btn_disabled"))
	
	if ($(Obj).parents().hasClass("btn_disabled") == true)
    return false;
	
  if (fnValidationCheck("Upd") == false)
  {
    return false;
  } 
  
/*
  // Team으로 Master정보 조회
  if ($("#scmTeamCbBox").val().length != 0)
	{  
	  fnCheckPlanMsterInfoByTeam();

	  if (gPlanId == null )  // 생성일정이 없다면 
		{  
		  //   테스트할 수 있는 데이타 필요.
      //  int mid = this.CreateSalesPlan(year, week, team, month);
	    //  spc.UpdateDetailSummaries(mid);
	    //  spc.UpdateInstallSummary(mid);
	    //  spc.UpdatePreM3AvgOrder(mid);
	    //  spc.UpdateM0Data(mid); 
	    Common.alert( "<spring:message code='sys.scm.salesplanMnge.notSaveExistsTeam'/>");
		  return false;
		}
	  else
		{
		  if (gPlanId == "4" || $("#scmYearCbBox").val().length == 0 || $("#scmPeriodCbBox").val().length == "0" 
			    || $("#scmTeamCbBox").val().length != 0)  
			{
	           //ConfirmButton.Enabled = false;
	           //UnconfirmButton.Enabled = false;
		      Common.alert( "<spring:message code='sys.scm.salesplanMnge.cannotupdateconfirm'/>");
		      return false;
			}

		}
  }
  else
	{
	  Common.alert( "<spring:message code='sys.scm.salesplanMnge.notSaveExistsTeam'/>");
	  return false;
	}
*/
  Common.ajax("POST"
		    , "/scm/saveScmSalesPlan.do"
		    , GridCommon.getEditData(myGridID)
		   
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

//삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
function removeAllCancel() 
{
  $("#delCancel").hide();
  
  AUIGrid.restoreSoftRows(myGridID, "all"); 
}

function fnValidationCheck(params) 
{
    var result = true;
   
   // var delList = AUIGrid.getRemovedItems(myGridID);
   
   if (params == "Add")
	 {
	   var addList = AUIGrid.getAddedRowItems(myGridID);
	   if (addList.length == 0   )  
	   {
	     Common.alert("No Change");
	     return false;
	   }

	   for (var i = 0; i < addList.length; i++) 
	   {  
	      var newStockCode      = addList[i].newStockCode;  
	      var team              = addList[i].team;

	      if (newStockCode == "" || newStockCode.length == 0) 
	      {
	        result = false;
	        // {0} is required.
	        Common.alert("<spring:message code='sys.msg.necessary' arguments='NEW_STOCK_CODE' htmlEscape='false'/>");
	        break;
	      }

	      if (fnSelectStockIdByStCode(newStockCode).length == 0 )
	      {
	          result = false;
	          // {0} is required.
	          Common.alert("<spring:message code='sys.msg.necessary' arguments='Corrected STOCK_CODE' htmlEscape='false'/>");
	          break;
	      }
	      

	      if (team == "" || team.length == 0) 
	      {
	        result = false;
	        // {0} is required.
	        Common.alert("<spring:message code='sys.msg.necessary' arguments='TEAM' htmlEscape='false'/>");
	        break;
	      }
	      
	   }  // addlist
	   
	 }
   else if (params == "Upd")
	 {
	   var udtList = AUIGrid.getEditedRowItems(myGridID);

	   if (udtList.length == 0 ) //&& delList.length == 0) 
     {
      Common.alert("No Change");
      return false;
     }
	    
	 }
   
    

  /*   
    for (var i = 0; i < udtList.length; i++) 
    {
        var zreExptId  = udtList[i].zreExptId;

        if (zreExptId == "" || zreExptId.length == 0) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='zreExptId' htmlEscape='false'/>");
          break;
        }
        
    }// udtlist

    for (var i = 0; i < delList.length; i++) 
    {
        var zreExptId  = delList[i].zreExptId;
        
        if (zreExptId == "" || zreExptId.length == 0 ) 
        {
          result = false;
          Common.alert("<spring:message code='sys.msg.necessary' arguments='zreExptId' htmlEscape='false'/>");
          break;
        }
        
     } //delete
     */
    return result;
  }

//trim
String.prototype.fnTrim = function() 
{
    return this.replace(/(^\s*)|(\s*$)/gi, "");
}

function fnSelectStockIdByStCode(paramStockCode)
{
	var stkId = "";
	
   Common.ajaxSync("GET", "/scm/selectStockIdByStCode.do"
           , {newStockCode : paramStockCode}
           , function(result) 
           {
              console.log("fnSelectStockIdByStCode_Length : " + result.selectStockIdByStCode.length);
              //AUIGrid.setGridData(myGridID, result);
              if(result.selectStockIdByStCode.length > 0)
              {
            	  stkId = String(result.selectStockIdByStCode[0].stkId); 
                console.log("성공 getStkId : " + stkId);
              }
              
           });

   console.log("성공 return_getStkId : " + stkId);

   return stkId;
}

function fnGetDetailAndSeqMstId()
{
   Common.ajax("GET", "/scm/selectPlanMstIdDetailSeqForIns.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              var gplanDtlIdSeq = parseInt(result.selectPlanDetailIdSeq[0].scm0002dPlanDtlIdSeq);  // seq
              var gplanMasterId = parseInt(result.selectPlanMasterId[0].planMasterId);
              console.log("성공 SearchBtnData_dtlSeq : " + gplanDtlIdSeq);
              console.log("성공 SearchBtnData_planId : " + gplanMasterId);
              //AUIGrid.setGridData(myGridID, result);
              if(result != null && result.length > 0)
              {
              }
           });
}

function fnGetMonthInfo()
{
   Common.ajax("GET", "/scm/selectPlanId.do"
           , $("#MainForm").serialize()
           , function(result) 
           {
              console.log("성공 SearchBtnData_planId : " + result.planMonth);
              //AUIGrid.setGridData(myGridID, result);
              if(result != null && result.length > 0)
              {
               $("#selectPlanMonth").val(result.planMonth);
               //gPlanId = result[0].planId;
               console.log("select Plan Month: " +  $("#selectPlanMonth").val() );
              }
           });
}


function selectStockCtgrySummaryList()
{
	  var params = {
		      stkCategories : $('#stockCategoryCbBox').multipleSelect('getSelects'),
		      scmStockTypes : $('#scmStockType').multipleSelect('getSelects'),
		      stkCodes : $('#stockCodeCbBox').multipleSelect('getSelects')
		      };

	 params = $.extend($("#MainForm").serializeJSON(), params);
		  
   Common.ajax("POST"
			       , "/scm/selectStockCtgrySummary.do"
	           , params
	           , function(result) 
	           {
	              console.log("성공 selectStockCtgrySummary: " + result.selectSalesSummaryList);
	              AUIGrid.setGridData(summaryGridID, result.selectSalesSummaryList);
	              if(result != null && result.length > 0)
	              {
	              }
	           });
   
}

function fnSearchBtnList()
{
	var params = {
			stkCategories : $('#stockCategoryCbBox').multipleSelect('getSelects'),
			scmStockTypes : $('#scmStockType').multipleSelect('getSelects'),
			stkCodes : $('#stockCodeCbBox').multipleSelect('getSelects')
			};

	params = $.extend($("#MainForm").serializeJSON(), params);

  Common.ajax("POST", "/scm/selectSalesPlanMngmentSearch.do"
	           , params
	           , function(result) 
	           {
	              console.log("성공 fnSearchBtnList: " + result.length);
	              AUIGrid.setGridData(myGridID, result.salesPlanMainList);
	              if(result != null && result.salesPlanMainList.length > 0)
	              {
	            	  $('#btnAddrow').removeClass("btn_disabled");
	            	  $('#btnExcel').removeClass("btn_disabled");
	            	  $('#btnUpdate').removeClass("btn_disabled");
	            	  $('#btnDelete').removeClass("btn_disabled");
	            	  $('#btnCancel').addClass("btn_disabled");
	            	  $('#btnInsert').addClass("btn_disabled");
	              }
	              else if (result.salesPlanMainList.length == 0)
	              {
	            	  $('#btnAddrow').addClass("btn_disabled");
	            	  $('#btnExcel').addClass("btn_disabled");
	            	  $('#btnCancel').addClass("btn_disabled");
	            	  $('#btnUpdate').addClass("btn_disabled");
	            	  $('#btnInsert').addClass("btn_disabled");
	            	  $('#btnDelete').addClass("btn_disabled");
	              }
	
	              gAddrowCnt = 0;
	                  
	           });
   
}

function fnSelectSalesCnt(inputCode)
{
   Common.ajax("GET", "/scm/selectSalesCnt.do"
           , { stockCode: inputCode }  
           , function(result) 
           {
              console.log("성공 selectSalesCnt: " + result[0].saleCnt );
              if(result != null && result.length > 0)
              {
              }
           });
}

function fnChangeEventPeriod(object)
{
	gWeekThValue = object.value;
	console.log("gWeekThValue: " + gWeekThValue);
}


/****************************  Form Ready ******************************************/

var myGridID , summaryGridID;

$(document).ready(function()
{
    $("#zreExptId").focus();
    
    $("#zreExptId").keydown(function(key) 
    {
       if (key.keyCode == 13) 
       {
         fnSearchBtnList();
       }

    });

    $("#zreExptId").bind("keyup", function() 
    {
      $(this).val($(this).val().toUpperCase());
    });
    
    $("#dealerName").keydown(function(key) 
    {
       if (key.keyCode == 13) 
       {
         fnSearchBtnList();
       }
    });

    $("#dealerName").bind("keyup", function() 
    {
      $(this).val($(this).val().toUpperCase());
    });


    /********************/

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
<h2>Sales Plan Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSettiingHeader();"><span class="search"></span>Search</a></p></li> 
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
  <input type ="hidden" id="planMasterId" name="planMasterId" value=""/>
  <input type ="hidden" id="selectPlanMonth" name="selectPlanMonth" value=""/>
  
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<!-- <col style="width:160px" />
	<col style="width:*" />
	<col style="width:90px" />
	<col style="width:*" /> -->
	<col style="width:140px" />
  <col style="width:*" />
  <col style="width:70px" />
  <col style="width:*" />
  <col style="width:100px" />
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
	<th scope="row">Team</th>
	<!-- <td> -->
	<td colspan="3">
	<select class="w100p" id="scmTeamCbBox" name="scmTeamCbBox">
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Stock Category</th>
	<td>
	<select class="w100p" id="stockCategoryCbBox" multiple="multiple" name="stockCategoryCbBox">
	</select>
	</td>
	<th scope="row">Stock</th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="stockCodeCbBox" name="stockCodeCbBox">
	</select>
	</td>
	<!-- Stock Type 추가 -->
  <th scope="row">Stock Type</th>
  <td>
  <select class="w100p" multiple="multiple" id="scmStockType" name="scmStockType"> 
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
	<li>
	 <p class="btn_grid">
	  <a onclick="fnCreate(this);">Create</a>
	 </p>
	</li>
<!-- 	<li>
	 <p class="btn_grid">
	  <a onclick="fnDelete(this);">Delete</a>
	 </p>
	</li> -->
	
	<li>
	 <p class="btn_grid">
	 <a onclick="fnConfirm(this);">Confirm</a>
	 </p>
	</li>
	
	<li>
	 <p class="btn_grid">
	   <a onclick="fnUnConfirm(this);">UnConfirm</a> 
	 </p>
	</li>
	
	<li>
	 <p class="btn_grid">
	   <!-- <a href="javascript:void(0);">Update M0 Data</a> -->
     <!-- 	<input type='button' id='CreatePlanBtn' value='Create Plan' disabled /> -->
	 </p>
	</li>
</ul>

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:90px" />
	<col style="width:*" />
	<col style="width:60px" />
	<col style="width:*" />
	<col style="width:60px" />
	<col style="width:*" />
	<col style="width:60px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:90px" />
	<col style="width:160px" />
	<col style="width:150px" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Year</th>
	<td>
	 <span id="planYear"></span>
	</td>
	<th scope="row">Month</th>
	<td>
	 <span id="planMonth"></span>
	</td>
	<th scope="row">Week</th>
	<td>
   <span id="planWeek"></span>	
	</td>
	<th scope="row">Team</th>
	<td>
   <span id="planTeam"></span>	
	</td>	
	<th scope="row">Status</th>
	<td id="planStatus">
	</td>	
	<th scope="row">Created At</th>
	<td id="planCreatedAt">	
	</td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="dynamic_SummaryGrid_wrap" style="height:230px;"></div>
</article><!-- grid_wrap end -->
<div class="side_btns">
  <ul class="right_btns">
  <!--   <li><p id='show'   class="btn_grid "><a onclick="fnShowGrid();">show</a></p></li> -->
    <li><p id='btnDelete' class="btn_grid btn_disabled"><a onclick="fnDelete(this)">Delete</a></p></li> 
    <li><p id='btnUpdate' class="btn_grid btn_disabled"><a onclick="fnSaveScmSalesPlan(this);">Update</a></p></li>
    <li><p id='btnAddrow' class="btn_grid btn_disabled"><a onclick="fnInsertAddRow(this);">AddRow</a></p></li>
    <li><p id='btnInsert' class="btn_grid btn_disabled"><a onclick="fnInsertSave(this);">Insert</a></p></li>
    <li><p id='btnCancel' class="btn_grid btn_disabled"><a onclick="fnCancel(this);">Cancel</a></p></li> 
    <li><p id='btnExcel'  class="btn_grid btn_disabled"><a onclick="fnExcelExport(this,'SalesPlanManagement');">Download</a></p>
    </li>
  </ul>
</div>

<br/>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="dynamic_DetailGrid_wrap" style="height:280px;"></div> 
</article><!-- grid_wrap end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 입력을위한 그리드 -->
 <div id="insertGridDivID" style="height:280px;"></div> 
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><!-- <a href="javascript:void(0);">Download Raw Data</a> --></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- content end -->
