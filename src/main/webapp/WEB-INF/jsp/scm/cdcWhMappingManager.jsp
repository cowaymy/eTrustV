<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
  text-align:right;
}
.aui-grid-left-column {
  text-align:left;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {  
    text-align:right;
    margin-top:-20px;
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

var cdcCodeList = new Array();

$(function() 
{
	  // set CDC
	  fnSetGridComboList();
	  fnSelectCDCComboList('349');  
	  fnSearchBtnList();
});

function fnOnchanged(obj)
{
  fnSearchBtnList();
}

function fnRefresh()
{
	fnSearchBtnList();
}

//행 삭제 메소드
function removeRow() 
{
    console.log("removeRow Method myGridID ");    
    AUIGrid.removeRow(myGridID,"selectedIndex");
}

function fnSetGridComboList()
{
    Common.ajaxSync("GET", "/scm/selectComboSupplyCDC.do"  
    		        , { codeMasterId: "349" }    
                 , function(result)
                 {
                    for (var i = 0; i < result.length; i++)
                    {
                      var list = new Object();
                          list.id = result[i].code;
                          list.value = result[i].codeName ;
                          cdcCodeList.push(list);
                    }

                  });

    return cdcCodeList;
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

function fnValidationCheck(chkGridId) 
{
    var result = true;
    var addList = AUIGrid.getAddedRowItems(chkGridId);
    var udtList = AUIGrid.getEditedRowItems(chkGridId);
    var delList = AUIGrid.getRemovedItems(chkGridId);
        
    if (addList.length == 0  && udtList.length == 0 && delList.length == 0) 
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++) 
    {
      var whId  = addList[i].whId;
      
      if (whId == "" || whId.length == 0) 
      {
        result = false;
        Common.alert("<spring:message code='sys.msg.necessary' arguments='WH_ID' htmlEscape='false'/>");
        break;
      }
    }

    for (var i = 0; i < udtList.length; i++) 
    {
      var whId  = udtList[i].whId;
      
      if (whId == "" || whId.length == 0) 
      {
        result = false;
        Common.alert("<spring:message code='sys.msg.necessary' arguments='WH_ID' htmlEscape='false'/>");
        break;
      }
    }

    for (var i = 0; i < delList.length; i++) 
    {
      var whId  = delList[i].whId;
      
      if (whId == "" || whId.length == 0) 
      {
        result = false;
        Common.alert("<spring:message code='sys.msg.necessary' arguments='WH_ID' htmlEscape='false'/>");
        break;
      }
    }

    return result;

}

function fnSaveGridMap() 
{
  if (fnValidationCheck(locGridId) == false)
  {
    return false;
  }
  
  Common.ajax("POST", "/scm/saveCdcWhMappingList.do"
        , GridCommon.getEditData(locGridId)
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

function fnDelGridMap() 
{
  if (fnValidationCheck(myGridID) == false)
  {
    return false;
  }
  
  Common.ajax("POST", "/scm/saveCdcWhMappingList.do"
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

// excel export
function fnExcelExport(fileNm)
{   // 1. grid ID 
    // 2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    // 3. exprot ExcelFileName  myGridID, locGridId
   if (fileNm == "Mapped_Warehouses")
    GridCommon.exportTo("#MasterGridDiv", "xlsx", fileNm );
   else
	  GridCommon.exportTo("#LocationGridDiv", "xlsx", fileNm ); 
}

// search
function fnSearchBtnList()
{
   Common.ajax("GET"
             , "/scm/selectWHouseMappingSerch.do"
             , $("#MainForm").serialize()
             , function(result) 
               {
                  console.log("성공 fnSearchBtnList: " + result.selectCdcWareMappingListList.length);
                  
                  AUIGrid.setGridData(myGridID, result.selectCdcWareMappingListList);
                  AUIGrid.setGridData(locGridId, result.selectWhLocationMappingList);
                  
                  if(result != null && result.selectWhLocationMappingList.length > 0)
                  {
                	  console.log("success: " + result.selectWhLocationMappingList[0].whId); 
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


/*************************************
 **********  Grid-LayOut  ************
 *************************************/

var MstGridLayout = 
    [         
      {
           dataField : "flag",
           headerText : "", 
           style : "myLinkStyle",
           editable: false,
           
           // LinkRenderer 를 활용하여 javascript 함수 호출로 사용하고자 하는 경우
           renderer : 
					            {
					               type : "LinkRenderer",
					               baseUrl : "javascript", 
					               // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
					               jsCallback : function(rowIndex, columnIndex, value, item) 
				                 {
				                	 removeRow();
				                 }
					            }
       }
      ,{
          dataField : "cdc",
          headerText : "<spring:message code='sys.scm.pomngment.cdc'/>",
          editable: false,
       }
      ,{
          dataField : "whCode",
          headerText : "<spring:message code='sys.scm.whousemapping.whCode'/>",
          editable: false,
       }
      ,{
          dataField : "whName",
          headerText : "<spring:message code='sys.scm.whousemapping.whName'/>",
          style : "aui-grid-left-column",
          editable: false,
       }
    ];

var LocationGridLayout = 
    [         
      {
           dataField : "cdc",
           headerText : "<spring:message code='sys.scm.pomngment.cdc'/>",
           editRenderer :
           {
               type : "ComboBoxRenderer",
               showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
               listFunction : function(rowIndex, columnIndex, item, dataField)
               {
                 return cdcCodeList;
               },
               keyField : "id",
               valueField : "value",
           }

          ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item )
           {
             var retStr = value;
             var iCnt = cdcCodeList.length;

             for(var iLoop = 0; iLoop < iCnt; iLoop++)
             {
               if(cdcCodeList[iLoop]["id"] == value)
               {
                 retStr = cdcCodeList[iLoop]["value"];
                 break;
               }
             }
             return retStr;
           }
       }
      ,{
          dataField : "whId",
          headerText : "<spring:message code='sys.scm.whousemapping.whId'/>",
          editable: false,
       }
      ,{
          dataField : "whCode",
          headerText : "<spring:message code='sys.scm.whousemapping.whCode'/>",
          editable: false,
       }
      ,{
          dataField : "whName",
          headerText : "<spring:message code='sys.scm.whousemapping.whName'/>",
          style : "aui-grid-left-column",
          editable: false,
       }
    ];

/****************************  Form Ready ******************************************/

var myGridID, locGridId

$(document).ready(function()
{

  var MstGridLayoutOptions = {
            usePaging : true,
            //editable: false,
            useGroupingPanel : false,
            showRowNumColumn : false,  // 그리드 넘버링
            showStateColumn : true, // 행 상태 칼럼 보이기
            enableRestore : true,
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
          };

  // masterGrid 그리드를 생성합니다.
  myGridID = GridCommon.createAUIGrid("MasterGridDiv", MstGridLayout,"", MstGridLayoutOptions);
  
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


  /*****************************************
   *********** Location Grid ***************
  ******************************************/

	// masterGrid 그리드를 생성합니다.
	locGridId = GridCommon.createAUIGrid("LocationGridDiv", LocationGridLayout,"", MstGridLayoutOptions);
	// AUIGrid 그리드를 생성합니다.
	
	// 푸터 객체 세팅
	//AUIGrid.setFooter(locGridId, footerObject);
	
	// 에디팅 시작 이벤트 바인딩
	AUIGrid.bind(locGridId, "cellEditBegin", auiCellEditignHandler);
	
	// 에디팅 정상 종료 이벤트 바인딩
	AUIGrid.bind(locGridId, "cellEditEnd", auiCellEditignHandler);
	
	// 에디팅 취소 이벤트 바인딩
	AUIGrid.bind(locGridId, "cellEditCancel", auiCellEditignHandler);
	
	// 행 추가 이벤트 바인딩 
	AUIGrid.bind(locGridId, "addRow", auiAddRowHandler);
	
	// 행 삭제 이벤트 바인딩 
	AUIGrid.bind(locGridId, "removeRow", auiRemoveRowHandler);
	
	// cellClick event.
	AUIGrid.bind(locGridId, "cellClick", function( event ) 
	{
	  gSelRowIdx = event.rowIndex;
	
	  console.log("cellClick_Status: " + AUIGrid.isAddedById(locGridId,AUIGrid.getCellValue(locGridId, event.rowIndex, 0)) );
	  console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );        
	});
	
	// 셀 더블클릭 이벤트 바인딩
	AUIGrid.bind(locGridId, "cellDoubleClick", function(event) 
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
<h2>CDC vs Warehouse Mapping</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="" onsubmit="return false;">
  <input type ="hidden" id="planMasterId" name="planMasterId" value=""/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">CDC</th>
	<td>
     <select id="cdcCbBox" name="cdcCbBox" onChange="fnOnchanged(this);">
     </select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<div class="divine_auto mt30"><!-- divine_auto start -->

<div style="width:50%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Mapped Warehouses</h3>
</aside><!-- title_line end -->

<ul class="right_btns">
  <li><p class="btn_grid"><a onclick="fnDelGridMap();">Save Changes</a></p></li>
  <li><p class="btn_grid"><a onclick="fnRefresh();">Refresh</a></p></li>
  <li><p class="btn_grid"><a onclick="fnExcelExport('Mapped_Warehouses');">EXCEL</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="MasterGridDiv" style="width:100%; height:350px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

<div style="width:50%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Unmapped Warehouses</h3>
</aside><!-- title_line end -->

<ul class="right_btns">
  <li><p class="btn_grid"><a onclick="fnSaveGridMap();">Save Changes</a></p></li>
<!--   <li><p class="btn_grid"><a href="javascript:void(0);">Cancel Changes</a></p></li> -->
  <li><p class="btn_grid"><a onclick="fnRefresh();">Refresh</a></p></li>
  <li><p class="btn_grid"><a onclick="fnExcelExport('UnMapped_Warehouses');">EXCEL</a></p></li>  
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 2-->
 <div id="LocationGridDiv" style="width:100%; height:350px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->

<ul class="center_btns">
  <li>
   <p class="btn_blue2 big">
     <!-- <a href="javascript:void(0);">Download Raw Data</a> -->
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
