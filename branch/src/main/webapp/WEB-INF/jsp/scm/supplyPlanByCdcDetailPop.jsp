<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}
.aui-grid-right-column {
  text-align:right;
}
</style>

<script type="text/javaScript">

$(function() 
{

});

function fnClose()
{
  $("#supplyPlanByCdcDetailPop").remove();
}

function fnSelectCdcDetailInfoData()
{
     Common.ajax("POST"
               , "/scm/selectSupplyCdcPop.do"
               , { paramStockCode : gParamStockCode
            	    ,paramYear : $("#scmYearCbBox").val()
                  ,paramWeekTh : $("#scmPeriodCbBox").val()
                  ,paramCdc : $("#cdcCbBox").val()
                 }
               , function(result) 
                 {
                    AUIGrid.setGridData(PopUpGridID, result.selectSupplyCdcPopList);
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

var popUpGridLayout = 
    [      
        {       
            dataField : "stockCode",
            headerText : "<spring:message code='sys.scm.pomngment.stockCode' />",
            width : "10%",
        },{
            dataField : "stockName",
            headerText : "<spring:message code='sys.scm.pomngment.stockName' />",
            width : "20%",
        },{
            dataField : "cdc",
            headerText : "<spring:message code='sys.scm.pomngment.cdc' />",
            width : "6%",
        },{
            dataField : "m3",
            headerText : "<spring:message code='sys.scm.salesplan.m33' />",
            style : "aui-grid-right-column",
            width : "10%",
        },{
            dataField : "m2",
            headerText : "<spring:message code='sys.scm.salesplan.m22' />",
            style : "aui-grid-right-column",
            width : "10%",
        },{
            dataField : "m1",
            headerText : "<spring:message code='sys.scm.salesplan.m11' />",
            style : "aui-grid-right-column",
            width : "10%",
        },{
            dataField : "avg",
            headerText : "<spring:message code='sys.scm.planByCdc.Avg' />",
            style : "aui-grid-right-column",
            width : "12%",
        },{
            dataField : "rating",
            headerText : "<spring:message code='sys.scm.planByCdc.rate' />",
            style : "aui-grid-right-column",
            width : "12%",
        }
    ];

var popUpGridOptions = {
		    usePaging : false,
        useGroupingPanel : false,
        editable : false,
        showStateColumn : false, // 행 상태 칼럼 보이기
        showRowNumColumn : false  // 그리드 넘버링
      };


/***************************************************[ Main GRID] ***************************************************/    
var PopUpGridID;

$(document).ready(function()
{

    // AUIGrid 그리드를 생성합니다.
    PopUpGridID = GridCommon.createAUIGrid("popUpGridDiv", popUpGridLayout,"", popUpGridOptions);

    // cellClick event.
    AUIGrid.bind(PopUpGridID, "cellClick", function( event ) 
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + "event_value: " + event.value );        
    });

    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(PopUpGridID, "cellDoubleClick", function(event) 
    {
        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
    }); 

    fnSelectCdcDetailInfoData();
    
});   //$(document).ready


</script>

<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1></h1>
<ul class="right_opt">
	<!-- <li><p class="btn_blue2"><a onclick="fnClose();">CLOSE</a></p></li>  -->
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
  <form id="PopForm" method="get" action="" onsubmit="return false;">  
    <input type ="hidden" id="stkId" name="stkId" value=""/>
		<div class="divine_auto"><!-- divine_auto start -->
		
		<div style="width:100%;">
			<div class="border_box"><!-- border_box start -->
			
			<article class="grid_wrap"><!-- grid_wrap start -->
	    <!-- 그리드 영역 1-->
	     <div id="popUpGridDiv" style="height:200px;"></div>
	    </article><!-- grid_wrap end -->
			
			<ul class="center_btns">
				<li><p class="btn_blue2 big"><a onclick="fnClose();">Close</a></p></li>
			</ul>
			
			</div><!-- border_box end -->
		
		</div>
		
		</div><!-- divine_auto end -->
  </form> 
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>