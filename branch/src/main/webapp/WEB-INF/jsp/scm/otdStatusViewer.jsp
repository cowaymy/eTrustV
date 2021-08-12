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

$(function() 
{
	//stock type
  fnSelectStockTypeComboList('15');
});

function fnCallInterface()
{
  $("#intfTypeCbBox option:eq(1)").prop("selected",true);
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

function fnSetInitDatePicker()
{
  /* Input에 초기값(today) 출력*/
    var d = new Date();
    var month = d.getMonth()+1;
    var day = d.getDate();

    var output = (day<10 ? '0' : '') + day + '/' +
        (month<10 ? '0' : '') + month + '/' +
        d.getFullYear() ;
    $(".j_date").val(output);
}

function fnGetDateGap(val1, val2)
{
    var FORMAT = "\/";

    if (val1.length != 10 || val2.length != 10)
        return null;

    if (val1.indexOf(FORMAT) < 0 || val2.indexOf(FORMAT) < 0)
        return null;

    var start_dt = val1.split(FORMAT);
    var end_dt = val2.split(FORMAT);

    // Number()를 이용하여 10진수(08,09)로 인식하게 함.
    start_dt[1] = (Number(start_dt[1]) - 1) + "";
    end_dt[1] = (Number(end_dt[1]) - 1) + "";

    var from_dt = new Date(start_dt[2], start_dt[1], start_dt[0] );
    var to_dt   = new Date(end_dt[2]  , end_dt[1]  , end_dt[0]);

    return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
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

// search
function fnSearchBtnList()
{

	//	 SAP에서 ITF0151M Insert 후, TRIGGER 통해 SCM0039M에 INSERT...

   var startDT = $("#startDate").val();
   var endDT = $("#endDate").val();

   if (fnGetDateGap(startDT ,endDT) < 0 )
	 {
	   Common.alert("<spring:message code='sys.msg.limitMore' arguments='FROM DATE ; TO DATE.' htmlEscape='false' argumentSeparator=';'/>");
	   return false;
	 }

   var params = {
		              scmStockTypes : $('#scmStockType').multipleSelect('getSelects')
		            };

	 params = $.extend($("#MainForm").serializeJSON(), params);
		  
   Common.ajax("POST"
             , "/scm/selectOtdStatusViewSearch.do"
             , params
             , function(result) 
               {
                  AUIGrid.setGridData(myGridID, result.selectOtdStatusViewList);
                  if(result != null && result.selectOtdStatusViewList.length > 0)
                  {
                    console.log("success: " + result.selectOtdStatusViewList.length + " /PoNo: " + result.selectOtdStatusViewList[0].poNo); 
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
                            style : "myLinkStyle",
                            width : "8%",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "poIssueDt",
                            headerText : "<spring:message code='sys.scm.otdview.IssueDate'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "stockCode",
                            headerText : "<spring:message code='sys.scm.otdview.StkCode'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "stockType",
                            headerText : "<spring:message code='sys.scm.inventory.stockType'/>",
                            cellMerge: true,
                         }
                        ,{
                            dataField : "stockDesc",
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
                            dataType : "numeric",
                            style : "aui-grid-right-column",         
                            formatString : "#,##0"
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
                              { 
                            	  if (item.poStus == "Approved" )  // Completed == 1
                                {
	                                var template = "<div class='closeDiv'>";
	                                template += "<span id='closeSpan'>";
	                                template += "●";
	                                template += "</span>";
	                                return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
                                }
                            	  else if (item.poStus == "Active" )  // == 0
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
                              dataType : "numeric",
                              style : "aui-grid-right-column",         
                              formatString : "#,##0"
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
                              dataField : "ppPlanQty",
                              headerText : "<spring:message code='sys.scm.otdview.planQty'/>",
                              cellMerge: true,
                              dataType : "numeric",
                              style : "aui-grid-right-column",         
                              formatString : "#,##0"
                           }
                          ,{
                              dataField : "ppProdQty",
                              headerText : "<spring:message code='sys.scm.otdview.prodQty'/>",
                              cellMerge: true,
                              dataType : "numeric",
                              style : "aui-grid-right-column",         
                              formatString : "#,##0"
                           }
                          ,{
                              dataField : "ppProdStartDt",
                              headerText : "<spring:message code='sys.scm.otdview.prodStart'/>",
                              cellMerge: true,
                           }
                          ,{
                              dataField : "ppProdEndDt",
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
                              dataType : "numeric",
                              style : "aui-grid-right-column",         
                              formatString : "#,##0"
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
                              dataType : "numeric",
                              style : "aui-grid-right-column",         
                              formatString : "#,##0"
                           }
                          ,{
                              dataField : "sboApQty",
                              headerText : "<spring:message code='sys.scm.otdview.apQty'/>",
                              cellMerge: true,
                              dataType : "numeric",
                              style : "aui-grid-right-column",         
                              formatString : "#,##0"
                           }
                          ,{
                              dataField : "sboGrQty",
                              headerText : "<spring:message code='sys.scm.otdview.gr'/>",
                              cellMerge: true,
                              dataType : "numeric",
                              style : "aui-grid-right-column",         
                              formatString : "#,##0"
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
<h2>OTD Status Viewer</h2>
<ul class="right_btns">
  <li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">
  <input type="hidden" id="poNo" name="poNo" />
  <input type="hidden" id="detailGbn" name="detailGbn" />
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
  <th scope="row">PO Issue Date</th>
  <td>

  <div class="date_set w100p"><!-- date_set start -->
  <p>
   <input type="text" id="startDate" name="startDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
  <span>To</span>
  <p>
   <input type="text" id="endDate" name="endDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
  </div><!-- date_set end -->

  </td>
  <th scope="row">PO Status</th>
  <td>
  <select id="statusSelBox" name="statusSelBox" class="w100p">
    <option value="" selected>All</option>
    <option value="0">OPEN</option>   <!-- active -->
    <option value="1">CLOSED</option> <!-- approved -->
  </select>
                            
  </td>
  <th scope="row">PO NO</th>
  <td>
  <input type="text" id="poNoTxt" name="poNoTxt" title="" placeholder="" class="w100p" />
  </td>
</tr>
<!-- Stock Type 줄 추가 -->
<tr>
  <th scope="row">Stock Type</th>
  <td>
    <select class="w100p" multiple="multiple" id="scmStockType" name="scmStockType">
    </select>
  </td>
  <td colspan="4"></td>
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
  <!-- <li><input id="inputTxtPoNo" name="inputTxtPoNo" type="text" title="" placeholder="Enter PO Number" disabled /><li>
  <li class="ml10"><p class="btn_blue3 btn_disabled"><a href="javascript:void(0);">Update OTD Status</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
   <!-- 그리드 영역1 -->
  <div id="OTDStatusViewDiv"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
  <li>
   <p class="btn_blue2 big">
  <!--    <a href="javascript:void(0);">Download Raw Data</a> <a onclick="fnExcelExport('OTD Status Viewer');">Download</a> -->
   </p>
  </li>
</ul>

</section><!-- search_result end -->

</section><!-- content end -->