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

</style>

<script type="text/javaScript">

$(function() 
{
	fnSelectTargetDateComboList('351');
	fnSelectInterFaceTypeComboList('352');
  //stock type
  fnSelectStockTypeComboList('15');  
});

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

    GridCommon.exportTo("#interface", "xlsx", fileNm+'_'+getTimeStamp() ); 
}

// search
function fnSearchBtnList()
{
    
   if ($("#intfTypeCbBox").val().length < 1) 
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='Interface Type' htmlEscape='false'/>");
     return false;
   } 

   if ($("#targetDateCbBox").val().length < 1) 
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='Target Date' htmlEscape='false'/>");
     return false;
   }

   $("#spanText").text(""); 

   var params = {
		              scmStockTypes : $('#scmStockType').multipleSelect('getSelects')
					      };

   params = $.extend($("#MainForm").serializeJSON(), params);

   Common.ajax("POST"
		         , "/scm/selectInterfaceSearch.do"
	           , params
	           , function(result) 
		           {
		              console.log("성공 fnSearchBtnList: " + result.selectInterfaceList.length);
		              AUIGrid.setGridData(myGridID, result.selectInterfaceList);
		              if(result != null && result.selectInterfaceLastState.length > 0)
		              {
		                  $("#spanText").text(result.selectInterfaceLastState[0].lastState); 
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

        if (event.columnIndex == 2 && event.headerText == "SEQ NO")
        {
          if (parseInt(event.value) < 1)
          {
            Common.alert("<spring:message code='sys.msg.mustMore' arguments='SEQ NO ; 0' htmlEscape='false' argumentSeparator=';' />");
            AUIGrid.restoreEditedCells(myGridID, [event.rowIndex, "seqNo"] );
            return false;
          }  
        }

        if (event.columnIndex == 1 && event.headerText == "CATEGORY NAME")
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

function fnLastStateChange() 
{
    var element = document.getElementById("span1");
    element.style.fontSize = "10pt";
    element.style.color = "#f00";
    element.style.fontWeight = "bold";
}


/*************************************
 **********  Grid-LayOut  ************
 *************************************/

var InterfaceLayout = 
    [      
        {    
            dataField : "spmon",
            headerText : "<spring:message code='sys.scm.interface.spmon' />",
            width : "7%"
        }, {
            dataField : "matnr",
            headerText : "<spring:message code='sys.scm.interface.matnr'/>",
            width : "7%"
        }, {
            dataField : "matnrNm",
            headerText : "<spring:message code='sys.scm.interface.matnrNm'/>",
            style : "aui-grid-left-column",
            width : "7%"
        }, {
            dataField : "stockType",
            headerText : "<spring:message code='sys.scm.interface.stockType'/>",
            width : "10%",
        }, {
            dataField : "stkTypeId",
            headerText : "<spring:message code='sys.scm.inventory.stockTypeId'/>",
            width : "10%",
        },{
            dataField : "ctgry",
            headerText : "<spring:message code='sys.scm.interface.ctgry'/>",
            width : "7%"
        }, {
            dataField : "measure",
            headerText : "<spring:message code='sys.scm.interface.measure'/>",
            width : "7%"
        }, {
            dataField : "amtK",
            headerText : "<spring:message code='sys.scm.interface.matnrNm'/>",
            width : "7%"
        }, {
            dataField : "waersKrw",
            headerText : "<spring:message code='sys.scm.interface.waersKrw'/>",
            width : "10%"
        }, {
            dataField : "amtSub",
            headerText : "<spring:message code='sys.scm.interface.amtSub'/>",
            style : "aui-grid-right-column",
            width : "7%"
        }, {
            dataField : "waersSub",
            headerText : "<spring:message code='sys.scm.interface.waersSub'/>",
            width : "10%"
        }, {
            dataField : "cnt",
            headerText : "<spring:message code='sys.scm.interface.cnt'/>",
            style : "aui-grid-right-column",
            width : "7%"
        }, {
            dataField : "meins",
            headerText : "<spring:message code='sys.scm.interface.meins'/>",
            width : "7%"
        }, {
            dataField : "amtUsd",
            headerText : "<spring:message code='sys.scm.interface.amtUsd'/>",
            width : "7%",
            visible : false
        }, {
            dataField : "waersUsd",
            headerText : "<spring:message code='sys.scm.interface.waersUsd'/>",
            width : "7%",
            visible : false
        }
    ];




/****************************  Form Ready ******************************************/

var myGridID

$(document).ready(function()
{
  var InterfaceLayoutOptions = {
            usePaging : true,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : false, // 행 상태 칼럼 보이기
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
           // selectionMode : "multipleRows",
          };

  // AUIGrid 그리드를 생성합니다.
  myGridID = GridCommon.createAUIGrid("InterfaceGridDiv", InterfaceLayout,"", InterfaceLayoutOptions);
  
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
<h2>Interface</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<!-- <col style="width:110px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" /> -->
  <col style="width:110px" />
  <col style="width:*" />
  <col style="width:110px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Interface Type</th>
	<td>
    <select id="intfTypeCbBox" name="intfTypeCbBox" class="w100p">
    </select>
	</td>
	<th scope="row">Target Date</th>
	<td>
    <select id="targetDateCbBox" name="targetDateCbBox" class="w100p">
    </select>
	</td>
	 <!-- <th scope="row">Last Interface</th> 
	<td>
	 <span id="spanText" style="font-size:9pt;color:#FF0000"></span>
	</td> -->
</tr>
<tr>
  <th scope="row">Stock Type</th>
  <td>
    <select class="w100p" multiple="multiple" id="scmStockType" name="scmStockType">
    </select>
  </td>
  <th scope="row">Last Interface</th> 
  <td>
   <span id="spanText" style="font-size:9pt;color:#FF0000"></span>
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
<!-- 	<li><p class="btn_grid"><a href="javascript:void(0);">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="javascript:void(0);">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="javascript:void(0);">DEL</a></p></li>
	<li><p class="btn_grid"><a href="javascript:void(0);">INS</a></p></li> 
-->
	<li><p id='btn11' class="btn_grid btn_disabled"><a onclick="fnCallInterface();">DO INTERFACE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start --> 
   <!-- 그리드 영역1 -->
  <div id="InterfaceGridDiv"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->