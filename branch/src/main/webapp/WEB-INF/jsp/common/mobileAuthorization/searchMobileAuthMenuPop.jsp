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
var authCode;

function fnSelectBoxChanged()
{
   $("#menuCdNm").val("");
   $("#menuCdNm").focus();
}

function fnSelectUpperMenuListAjax()
{
  /* if ($("#menuSelectBox").val() == "01")  // Menu id
	{
	  $("#menuCode").val($("#menuCdNm").val());
	  $("#menuNm").val("");
	}
  else
	{
	  $("#menuCode").val("");
	  $("#menuNm").val($("#menuCdNm").val());
	} */

	$("#authCd").val(authCode);

   Common.ajax("GET", "/mobileMenu/selectMobileMenuPopList.do"
           , $("#SearchForm").serialize()
           , function(result)
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(searchUpperGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetmenuIdParamSet(searchUpperGridID, 0);
              }
           });
}

var SearchUpperColumnLayout =
    [
        {
            dataField : "menuCode",
            headerText : "Id",
            headerText : "<spring:message code='sys.info.id' />",
            width : "30%",
        },{
            dataField : "menuName",
            headerText : "<spring:message code='sys.title.name' />",
            style : "aui-grid-left-column",
            width : "70%"
        }, {
            dataField : "pgmCode",
            dataType : "string",
            visible : false
        }, {
            dataField : "pgmName",
            dataType : "string",
            visible : false
        }, {
            dataField : "menuLvl",
            dataType : "string",
            visible : false
        }
    ];

/***************************************************[ Main GRID] ***************************************************/
var searchUpperGridID;

$(document).ready(function()
{

	authCode = "${authCode}";

    $("#menuCdNm").focus();

    $("#menuCdNm").bind("keyup", function()
    {
    	$(this).val($(this).val().toUpperCase());

    });

    $("#menuCdNm").keydown(function(key)
    {
        if (key.keyCode == 13)
        {
          fnSelectUpperMenuListAjax();
        }

    });


	var searchOptions = {
	                  usePaging : true,
	                  useGroupingPanel : false,
	                  editable : false,
	                  showRowNumColumn : false  // 그리드 넘버링
	                };

    // AUIGrid 그리드를 생성합니다.
	    searchUpperGridID = GridCommon.createAUIGrid("search_grid_wrap", SearchUpperColumnLayout,"menuCode", searchOptions);

	    // cellClick event.
	    AUIGrid.bind(searchUpperGridID, "cellClick", function( event )
	    {
	        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedParammenuId: " + $("#searchParamMenuId").val() +" / "+ $("#searchParammenuName").val());
	    });

	 // 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(searchUpperGridID, "cellDoubleClick", function(event)
	    {
	        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

	        var SerchmenuCode = AUIGrid.getCellValue(searchUpperGridID, event.rowIndex, "menuCode");
	        var SerchmenuName = AUIGrid.getCellValue(searchUpperGridID, event.rowIndex, "menuName");
	        var SerchpgmCode = AUIGrid.getCellValue(searchUpperGridID, event.rowIndex, "pgmCode");
	        var SerchpgmName = AUIGrid.getCellValue(searchUpperGridID, event.rowIndex, "pgmName");
	        var SerchmenuLvl = AUIGrid.getCellValue(searchUpperGridID, event.rowIndex, "menuLvl");

	        AUIGrid.setCellValue(grdMenuMapping, gSelMainRowIdx, 0, SerchmenuLvl);
	        AUIGrid.setCellValue(grdMenuMapping, gSelMainRowIdx, 1, SerchmenuCode);
	        AUIGrid.setCellValue(grdMenuMapping, gSelMainRowIdx, 2, SerchmenuName);
	        AUIGrid.setCellValue(grdMenuMapping, gSelMainRowIdx, 3, SerchpgmCode);
	        AUIGrid.setCellValue(grdMenuMapping, gSelMainRowIdx, 4, SerchpgmName);


	        $("#searchMenuPop").remove();
	    });

});   //$(document).ready


</script>

<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Mobile Menu Search</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="SearchForm" method="get" action="">
	<input type ="hidden" id="menuCode" name="menuCode" />
	<input type ="hidden" id="menuNm" name="menuNm" />
	<input type ="hidden" id="authCd" name="authCd"  value="" />

	<div class="search_100p"><!-- search_100p start -->
	<select class="" id="menuSelectBox" name="menuSelectBox" onchange="fnSelectBoxChanged();">
	  <option value="01" selected>Menu ID</option>
	  <option value="02">Menu Name</option>
	</select>
	<input type="text" id="menuCdNm" name="menuCdNm" />
	<a onclick="fnSelectUpperMenuListAjax();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
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