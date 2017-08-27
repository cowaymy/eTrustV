<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">

var setMainRowIdx = 0;

function fnSelectBoxChanged()
{
   $("#programCdNm").val("");
   $("#programCdNm").focus();
}

function fnSelectPgmListAjax()
{
  if ($("#programSelectBox").val() == "01")  // program id
	{
	  $("#pgmCode").val($("#programCdNm").val());
	  $("#pgmNm").val("");
	}
  else
	{
	  $("#pgmCode").val("");
	  $("#pgmNm").val($("#programCdNm").val());
	} 
	
   Common.ajax("GET", "/program/selectProgramList.do"
           , $("#SearchForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(searchGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetPgmIdParamSet(searchGridID, 0);
              }
           });
}

var SearchColumnLayout = 
    [      
        {    
            dataField : "pgmCode",
            headerText : "<spring:message code='sys.info.id' />",
            width : "30%"
        },{
            dataField : "pgmName",
            headerText : "<spring:message code='sys.title.name' />",
            style : "aui-grid-left-column",
            width : "70%"
        }
    ];

/***************************************************[ Main GRID] ***************************************************/    
var searchGridID;

$(document).ready(function()
{

    $("#programCdNm").focus();
    
    $("#programCdNm").keydown(function(key) 
    {
          if (key.keyCode == 13) 
          {
            fnSelectPgmListAjax();
          }

    });
	

	var searchOptions = {
	                  usePaging : true,
	                  useGroupingPanel : false,
	                  showRowNumColumn : false, // 순번 칼럼 숨김
	                  editable : false,
	                };
	    
    // AUIGrid 그리드를 생성합니다.
	    searchGridID = GridCommon.createAUIGrid("search_grid_wrap", SearchColumnLayout,null, searchOptions);

	    // cellClick event.
	    AUIGrid.bind(searchGridID, "cellClick", function( event ) 
	    {
	        $("#searchParamPgmId").val("");
	        AUIGrid.clearGridData(transGridID);
	        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedParamPgmId: " + $("#searchParamPgmId").val() +" / "+ $("#searchParamPgmName").val());        
	    });

	 // 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(searchGridID, "cellDoubleClick", function(event) 
	    {
	        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

	        var SerchPgmCode = AUIGrid.getCellValue(searchGridID, event.rowIndex, "pgmCode");
	        var SerchPgmName = AUIGrid.getCellValue(searchGridID, event.rowIndex, "pgmName");
	        	        
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 5, SerchPgmCode);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 6, SerchPgmName);

	        $("#searchProgramPop").remove();
	    }); 
	
});   //$(document).ready


</script>

<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Program Search</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="SearchForm" method="get" action="">
<input type ="hidden" id="pgmCode" name="pgmCode" value=""/>
<input type ="hidden" id="pgmNm" name="pgmNm" value=""/>

<div class="search_100p"><!-- search_100p start -->
<select class="" id="programSelectBox" name="programSelectBox" onchange="fnSelectBoxChanged();">
  <option value="01" selected>Program ID</option>
  <option value="02">Program Name</option>
</select>
<input type="text" id="programCdNm" name="programCdNm" />
<a onclick="fnSelectPgmListAjax();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
</div><!-- search_100p end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- 그리드 영역 1-->
 <div id="search_grid_wrap" style="height:300px;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>