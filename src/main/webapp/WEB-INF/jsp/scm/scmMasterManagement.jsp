<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
  text-align:right;
}
.aui-grid-left-column {
  text-align:right;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {  
    text-align:right;
    margin-top:-20px;
}

</style>

<script type="text/javaScript">

var keyValueList = new Array();

$(function() 
{
	//setting StockCategoryCode ComboBox 
	 fnSetStockCategoryComboBox(); 
	//setting StockCode ComboBox 
	 fnSetStockComboBox();  
	//setting DropDownList  
	//keyValueList = $.parseJSON('${selectStockCodeList}');   
	fnSetStockDropDownList();  
});

function fnClick()
{
  $('#btn11').removeClass("btn_disabled");
  //$('#btn11').addClass("btn_disabled");
}

function fnCallInterface()
{
  $("#intfTypeCbBox option:eq(1)").prop("selected",true);
}

function fnSetStockComboBox()
{
  CommonCombo.make("stockCodeCbBox"
                , "/scm/selectStockCode.do"  
                , ""                         
                , ""                         
                , {  
                    id  : "stkId",   //value        
                    name: "stkDesc", //view
                    type: "S"
                  }
                , "");
}

function fnSetStockDropDownList(callBack)
{
    Common.ajaxSync("GET","/scm/selectStockCode.do"  
                 , $("#MainForm").serialize()
                 , function(result)
                 {

                   
        
                   //keyValueList.push({id:"" ,value:""});
                    for (var i = 0; i < result.length; i++)
                    {
                      var list = new Object();
                          list.id = result[i].stkDesc ;  // display 
                          list.value = result[i].stkDesc;  // true value
                          keyValueList.push(list);
                    }

                    console.log("keyValueList_length: " + keyValueList.length);
                    console.log("keyValueList_sktCode: " + keyValueList[0]["id"] );  // view
                    
                    //if you need callBack Function , you can use that function
                    /* if (callBack) {
                      callBack(keyValueList);
                    } */

                  });
    return keyValueList;
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
                              , { codeId: $this.val() }       
                              , ""                         
                              , {  
                                  id  : "stkId",    //value         
                                  name: "stkDesc",  //view
                                  type: "S"
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
                 , { chooseMessage: "ALL" }  
                 , stockCodeCallBack  
                  );  
}

// excel export
function fnExcelExport()
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName
    GridCommon.exportTo("#masterManagerDiv", "xlsx", "SupplyPlanSummary_W" +$('#scmPeriodCbBox').val() );
}

// search
function fnSearchBtnList()
{
   console.log( "selectBox: " + $("#stockCategoryCbBox").val() 
       + " // Index: " + $("#stockCategoryCbBox option").index($("#stockCategoryCbBox option:selected")));

   Common.ajax("GET"
             , "/scm/selectMasterMngmentSerch.do"
             , $("#MainForm").serialize()
             , function(result) 
               {
                  console.log("성공 fnSearchBtnList: " + result.scmMasterMngMentServiceList.length);
                  AUIGrid.setGridData(myGridID, result.scmMasterMngMentServiceList);
                  if(result != null && result.scmMasterMngMentServiceList.length > 0)
                  {
                	  console.log("success_stkCtgryCode: " + result.scmMasterMngMentServiceList[0].stkCtgryCode); 
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


/*************************************
 **********  Grid-LayOut  ************
 *************************************/

var masterManagerLayout = 
    [         
      {  //Stock
        headerText : "<spring:message code='sys.scm.mastermanager.Stock'/>",
        width : "45%",
        children   : [ 
                         {
                            dataField : "stkCtgryCode",
                            headerText : "<spring:message code='sys.scm.salesplan.Category'/>",
                         }
                        ,{
                            dataField : "stockCode",
                            headerText : "<spring:message code='sys.scm.salesplan.Code'/>",
                         }
                        ,{
                            dataField : "stockDesc",
                            headerText : "<spring:message code='sys.progmanagement.grid1.Description'/>",
                         }
                        ,{
                            dataField : "defautStockName",
                            headerText : "<spring:message code='sys.scm.mastermanager.DefaultStock'/>",
                            renderer :
		                        {
		                            type : "DropDownListRenderer",
		                            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
		                            
		                            listFunction : function(rowIndex, columnIndex, item, dataField)
		                            {
		                              return keyValueList;
		                            },
		                            keyField : "id",       
	                              valueField : "value",  

		                            //keyField : "id",       // sktDesc == display
	                              //valueField : "value",  // stkCode == true value

		                            
		                            //list.id = result[i].stkDesc ;  // display 
		                            //list.value = result[i].stkCode;  // true value
		                        },
		                        labelFunction : function(  rowIndex, columnIndex, value, headerText, item )
	                            {  // as click excute.
	                               var retStr = value;
	                               var iCnt = keyValueList.length;
	                               console.log("label_func: " + value)  // view == value(display).
	                               console.log("ID[0] : " + keyValueList[0]["id"])  // id == value(display) == view.
	                               console.log("value[0] : " + keyValueList[0]["value"])  // 실질적인 값
	                               
	                               for(var iLoop = 0; iLoop < iCnt; iLoop++)
	                               {
	                                 if(keyValueList[iLoop]["id"] == value)
	                                 {
	                                   console.log("Loop_ID[0] : " + keyValueList[iLoop]["id"])  // id == value(display) == view.
	                                   console.log("Loop_value[0] : " + keyValueList[iLoop]["value"])  // 실질적인 값
	                                     
	                                   retStr = keyValueList[iLoop]["value"]; // 실질적인값.
	                                   console.log("Break__: " + retStr);
	                                   break;
	                                 }
	                               }
	                               console.log("retStrL " + retStr);
	                               return retStr;
	                            } 
                         }
                     ]
      } 
     ,{  //Sales Plan
          headerText : "<spring:message code='sys.scm.mastermanager.SalesPlan'/>",
          width : "20%",
          children   : [ 
                           {
                              dataField : "isTrget",
                              headerText : "<spring:message code='sys.scm.mastermanager.Target'/>",
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
                                   if(item.isTarget == true)  // if 1 then
                                     return true; // CheckBox is Checked
                                                                            
                                   return true;  // just CheckBox Visible But Not Checked.
                                 }
                              } // renderer
                           }
                          ,{
                              dataField : "memo",
                              headerText : "<spring:message code='sys.scm.mastermanager.Memo'/>",
                           }
                          ,{
                              dataField : "startDt",
                              headerText : "<spring:message code='sys.scm.mastermanager.Start'/>",
                              dataType : "date",
                              formatString : "dd-mm-yyyy",
                              editRenderer : {
                                  type : "CalendarRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                  onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                  showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                  }   
                           }
                          ,{
                              dataField : "endDt",
                              headerText : "<spring:message code='sys.scm.mastermanager.End'/>",
                              dataType : "date",
                              formatString : "dd-mm-yyyy",
                              editRenderer : {
                                type : "CalendarRenderer",
                                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                }                             
                           }
                          
                       ]
      }       
     ,{  //Supply Plan
          headerText : "<spring:message code='sys.scm.mastermanager.SupplyPlan'/>",
          //width : "45%",
          children   : [ 
                           {    //Supply Plan Target    
                              headerText : "<spring:message code='sys.scm.mastermanager.SupplyPlanTarget'/>",
                              
                              children : [
	                                          {
	                                            dataField : "klTarget",
	                                            headerText : "<spring:message code='sys.scm.mastermanager.KL'/>",
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
	                                                 if(item.klTarget == true)  // if 1 then
	                                                   return true; // CheckBox is Checked
	                                                                                          
	                                                 return true;  // just CheckBox Visible But Not Checked.
	                                               }
	                                            } // renderer                                              
	                                          }
	                                         ,{
	                                            dataField : "kkTarget",
	                                            headerText : "<spring:message code='sys.scm.mastermanager.KK'/>",
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
                                                   if(item.kkTarget == true)  // if 1 then
                                                     return true; // CheckBox is Checked
                                                                                            
                                                   return true;  // just CheckBox Visible But Not Checked.
                                                 }
                                              } // renderer     	                                                                                          
	                                          }
                                           ,{
                                              dataField : "jbTarget",
                                              headerText : "<spring:message code='sys.scm.mastermanager.JB'/>",   
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
                                                   if(item.jbTarget == true)  // if 1 then
                                                     return true; // CheckBox is Checked
                                                                                            
                                                   return true;  // just CheckBox Visible But Not Checked.
                                                 }
                                              } // renderer                                                                                             
                                            }
                                           ,{
                                              dataField : "pnTarget",
                                              headerText : "<spring:message code='sys.scm.mastermanager.PN'/>",    
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
                                                   if(item.pnTarget == true)  // if 1 then
                                                     return true; // CheckBox is Checked
                                                                                            
                                                   return true;  // just CheckBox Visible But Not Checked.
                                                 }
                                              } // renderer                                                                                            
                                            }
                                           ,{
                                              dataField : "kcTarget",
                                              headerText : "<spring:message code='sys.scm.mastermanager.KC'/>",    
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
                                                   if(item.kcTarget == true)  // if 1 then
                                                     return true; // CheckBox is Checked
                                                                                            
                                                   return true;  // just CheckBox Visible But Not Checked.
                                                 }
                                              } // renderer    
                                                                                        
                                            }
                                         ]
                           }
                         , {    //MOQ
                              headerText : "<spring:message code='sys.scm.mastermanager.MOQ'/>",
                              
                              children : [
                                            {
                                              dataField : "klMoq",
                                              headerText : "<spring:message code='sys.scm.mastermanager.KL'/>",                                              
                                            }
                                           ,{
                                              dataField : "kkMoq",
                                              headerText : "<spring:message code='sys.scm.mastermanager.KK'/>",                                              
                                            }
                                           ,{
                                              dataField : "jbMoq",
                                              headerText : "<spring:message code='sys.scm.mastermanager.JB'/>",                                              
                                            }
                                           ,{
                                              dataField : "pnMoq",
                                              headerText : "<spring:message code='sys.scm.mastermanager.PN'/>",                                              
                                            }
                                           ,{
                                              dataField : "kcMoq",
                                              headerText : "<spring:message code='sys.scm.mastermanager.KC'/>",                                              
                                            }
                                         ]
                           }
                          ,{  //S.Stk      
                              dataField : "safetyStock",
                              headerText : "<spring:message code='sys.scm.mastermanager.SStk'/>",
                           }
                          ,{
                              dataField : "leadTm",
                              headerText : "<spring:message code='sys.scm.mastermanager.LTime'/>",
                           }
                          ,{
                              dataField : "loadingQty",
                              headerText : "<spring:message code='sys.scm.mastermanager.LQty'/>",
                           }
                          
                       ]
      } //Supply Plan      
    ];

/****************************  Form Ready ******************************************/

var myGridID

$(document).ready(function()
{

   var masterManagerOptions = {
            usePaging : true,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : true, // 행 상태 칼럼 보이기
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            // 한 화면에 출력되는 행 개수 30개로 지정
            pageRowCount : 20,
            fixedColumnCount    : 4, 
          };

  // masterGrid 그리드를 생성합니다.
  myGridID = GridCommon.createAUIGrid("#masterManagerDiv", masterManagerLayout,"", masterManagerOptions);
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

    //gPoNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "poNo");
    
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
<h2>SCM Master Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
  <input type ="hidden" id="planMasterId" name="planMasterId" value=""/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Stock Category</th>
	<td>
  <select id="stockCategoryCbBox" name="stockCategoryCbBox">
  </select>
	</td>
	<th scope="row">Stock</th>
	<td>
  <select id="stockCodeCbBox" name="stockCodeCbBox">
  </select>
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

<ul class="right_btns">
	<li><p class="btn_grid btn_disabled"><a href="javascript:void(0);">Add New</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="masterManagerDiv" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li>
	 <p class="btn_blue2 big">
	   <!-- <a href="javascript:void(0);">Download Raw Data</a> -->
	 </p>
	</li>
</ul>

</section><!-- search_result end -->

</section><!-- content end -->
