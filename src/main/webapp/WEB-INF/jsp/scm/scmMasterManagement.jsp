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

.my-backColumn0 {
  background:#73EAA8; 
  color:#000;
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

</style>

<script type="text/javaScript">

$(function() 
{
  //fnSelectTargetDateComboList('351');
  //fnSelectInterFaceTypeComboList('352');
	//setting StockCategoryCode ComboBox 
	 fnSetStockCategoryComboBox(); 
	//setting StockCode ComboBox 
	 fnSetStockComboBox();   
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

function fnSelectTargetDateComboList(codeId)
{
  CommonCombo.initById("targetDateCbBox");  // reset...
  CommonCombo.make("targetDateCbBox"
            , "/scm/selectComboInterfaceDate.do"  
            , { codeMasterId: codeId }       
            , ""                         
            , {  
                id  : "code",      //value    
                name: "codeName",  //view
                chooseMessage: "Select Target Date"
               }
            , "");     
}

function fnSelectInterFaceTypeComboList(codeId)
{
  CommonCombo.initById("intfTypeCbBox");  // reset...

   // Call Back
    var fnSelectIntfTypeCallback = function () 
        {
         $("#intfTypeCbBox>option:eq(1)").prop("selected",true);
        }
  
  CommonCombo.make("intfTypeCbBox"
            , "/scm/selectComboInterfaceDate.do"  
            , { codeMasterId: codeId }       
            , ""                         
            , {  
                id  : "code",      //value    
                name: "codeName",  //view
                chooseMessage: "Select Interface Type"
               }
            , fnSelectIntfTypeCallback);     
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

   console.log( "selectBox: " + $("#statusSelBox").val() 
       + " // Index: " + $("#statusSelBox option").index($("#statusSelBox option:selected")));

   Common.ajax("GET"
             , "/scm/selectOtdStatusViewSearch.do"
             , $("#MainForm").serialize()
             , function(result) 
               {
                  console.log("성공 fnSearchBtnList: " + result.selectOtdStatusViewList.length);
                  AUIGrid.setGridData(myGridID, result.selectOtdStatusViewList);
                  if(result != null && result.selectOtdStatusViewList.length > 0)
                  {
                      console.log("success: " + result.selectOtdStatusViewList[0].poNo); 
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

function fnOTDDetailPopUP(poNo)
{
   if (poNo.length < 1)
   {
     Common.alert("<spring:message code='sys.msg.first.Select' arguments='PO NO' htmlEscape='false'/>");
     return false;
   } 

   $("#poNo").val(poNo);

   var popUpObj = Common.popupDiv("/scm/otdDetailPop.do"
         , $("#MainForm").serializeJSON()
         , null
         , false // when doble click , Not close
         , "otdDetailPop"  
         );  

}

/*************************************
 **********  Grid-LayOut  ************
 *************************************/

var OTDViewerLayout = 
    [         
      {  //PO
        headerText : "<spring:message code='sys.scm.otdview.PO'/>",
        children   : [ 
                         {
                            dataField : "poNo",
                            headerText : "<spring:message code='sys.scm.pomngment.rowNo'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "issueDate",
                            headerText : "<spring:message code='sys.scm.otdview.IssueDate'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "stkCode",
                            headerText : "<spring:message code='sys.scm.otdview.StkCode'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "stkDesc",
                            headerText : "<spring:message code='sys.scm.otdview.StkDesc'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "grDt",
                            headerText : "<spring:message code='sys.scm.otdview.GRDate'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "poQty",
                            headerText : "<spring:message code='sys.scm.otdview.QTY'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "poStus",
                            headerText : "<spring:message code='sys.menumanagement.grid1.Status'/>",
                            cellMerge: true,
                            renderer : { // HTML 템플릿 렌더러 사용
                                type : "TemplateRenderer"
                              },
                              // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
                              labelFunction : function (rowIndex, columnIndex, value, headerText, item ) 
                              { // HTML 템플릿 작성
                                //console.log("Renderer: ( " + rowIndex + ", " + columnIndex + " ) " + "item.poStus: " + item.poStus + " /value: " + value);
                                if (item.poStus == "Approved" )
                                {
                                  var template = "<div class='closeDiv'>";
                                  template += "<span id='closeSpan'>";
                                  template += "●";
                                  template += "</span>";
                                  return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
                                }
                                else if (item.poStus == "Active" )
                                {
                                  var template = "<div class='openDiv'>";
                                      template += "<span id='openDiv'>";
                                      template += "●";
                                      template += "</span>";
                                      return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
                                }
                                else
                                    return null;
                             }
                        
                         }
                        
                     ]
      } 
     ,{  //SO
          headerText : "<spring:message code='sys.scm.otdview.SO'/>",
          children   : [ 
                           {
                              dataField : "soQty",
                              headerText : "<spring:message code='sys.scm.otdview.QTY'/>",
                              cellMerge: true,
                           }
                          ,{
                              dataField : "soDt",
                              headerText : "<spring:message code='sys.scm.otdview.DATE'/>",
                              cellMerge: true,
                           }
                          
                       ]
      }       
     ,{  //PP
          headerText : "<spring:message code='sys.scm.otdview.PP'/>",
          children   : [ 
                           {
                              dataField : "ppQtyPlan",
                              headerText : "<spring:message code='sys.scm.otdview.planQty'/>",
                              cellMerge: true,
                           }
                          ,{
                              dataField : "ppQtyResult",
                              headerText : "<spring:message code='sys.scm.otdview.prodQty'/>",
                              cellMerge: true,
                           }
                          ,{
                              dataField : "ppDtProductStart",
                              headerText : "<spring:message code='sys.scm.otdview.prodStart'/>",
                              cellMerge: true,
                           }
                          ,{
                              dataField : "ppDtProductEnd",
                              headerText : "<spring:message code='sys.scm.otdview.prodEnd'/>",
                              cellMerge: true,
                           }
                          
                       ]
      }       
     ,{  //GI
          headerText : "<spring:message code='sys.scm.otdview.GI'/>",
          children   : [ 
                           {
                              dataField : "giQty",
                              headerText : "<spring:message code='sys.scm.otdview.QTY'/>",
                              cellMerge: true,
                           }
                          ,{
                               dataField : "giDt",
                               headerText : "<spring:message code='sys.scm.otdview.DATE'/>",
                               cellMerge: true,
                           }
                          
                       ]
      }       
     ,{  //SBO
          headerText : "<spring:message code='sys.scm.otdview.SBO'/>",
          children   : [ 
                           {
                              dataField : "sboPoQty",
                              headerText : "<spring:message code='sys.scm.otdview.poQty'/>",
                              cellMerge: true,
                           }
                          ,{
                              dataField : "apQty",
                              headerText : "<spring:message code='sys.scm.otdview.apQty'/>",
                              cellMerge: true,
                           }
                          ,{
                              dataField : "grQty",
                              headerText : "<spring:message code='sys.scm.otdview.gr'/>",
                              cellMerge: true,
                           }
                          
                       ]
      }       
    ];

/****************************  Form Ready ******************************************/

var myGridID

$(document).ready(function()
{

  var otdViewerLayoutOptions = {
            usePaging : true,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            fixedColumnCount    : 7, 
          };

  // masterGrid 그리드를 생성합니다.
  myGridID = GridCommon.createAUIGrid("OTDStatusViewDiv", OTDViewerLayout,"", otdViewerLayoutOptions);
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

    gPoNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "poNo");

    fnOTDDetailPopUP(gPoNo);    
    
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
	<li><p class="btn_blue"><a href="javascript:void(0);"><span class="search"></span>Search</a></p></li>
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
	<select>
		<option value="">11</option>
		<option value="">22</option>
		<option value="">33</option>
	</select>
	</td>
	<th scope="row">Stock</th>
	<td>
	<select>
		<option value="">11</option>
		<option value="">22</option>
		<option value="">33</option>
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
	<li><p class="btn_grid"><a href="javascript:void(0);">Add New</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
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
