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

function fnRoleAuthMappingPopSearch()
{	
   Common.ajax("GET", "/authorization/selectRoleAuthMappingPopUpList.do"
           , $("#SearchForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(searchPopAuthGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetroleIdParamSet(searchPopAuthGridID, 0);
              }
           });
}


var SearchRoleColumnLayout = 
    [      
        {       
            dataField : "authCode",
            headerText : "<spring:message code='sys.auth.grid1.AuthCode' />",
            editable : false,
            width : "20%"
        },{
            dataField : "roleId",
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleId' />",
            editable : false,
            width : "15%"
        },{
            dataField : "authName",
            headerText : "<spring:message code='sys.auth.grid1.authName' />",           
            style : "aui-grid-left-column",
            editable : false,
            width : "65%"
        }
    ];

/***************************************************[ Main GRID] ***************************************************/    
var searchPopAuthGridID;

$(document).ready(function()
{
    $("#AuthIdNm").focus();
    
    $("#AuthIdNm").keydown(function(key) 
    {
          if (key.keyCode == 13) 
          {
        	  fnRoleAuthMappingPopSearch();
          }

    });
	

	var searchOptions = {
	                  usePaging : false,
	                  useGroupingPanel : false,
	                  showRowNumColumn : false, // 순번 칼럼 숨김
	                  editable : true,
	                  enableRestore : true,
	                  softRemovePolicy : "exceptNew",
	                };
	    
    // AUIGrid 그리드를 생성합니다.
	    searchPopAuthGridID = GridCommon.createAUIGrid("search_grid_wrap", SearchRoleColumnLayout,"roleId", searchOptions);

	    // cellClick event.
	    AUIGrid.bind(searchPopAuthGridID, "cellClick", function( event ) 
	    {
	        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " event_value: " + event.value );
	    });

	 // 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(searchPopAuthGridID, "cellDoubleClick", function(event) 
	    {
	        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

	        fnGetToday();

	        var SerchAuthCd = AUIGrid.getCellValue(searchPopAuthGridID, event.rowIndex, "authCode");
	        var SerchAuthId = AUIGrid.getCellValue(searchPopAuthGridID, event.rowIndex, "roleId");
	        var SerchAuthName = AUIGrid.getCellValue(searchPopAuthGridID, event.rowIndex, "authName");
	        var SerchAuthLev = AUIGrid.getCellValue(searchPopAuthGridID, event.rowIndex, "roleLvl");

	        AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 0, SerchAuthCd);
	        AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 1, SerchAuthName);
	        AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 2, fnGetToday());
	        if (AUIGrid.getCellValue(AuthGridID, gSelMainRowIdx, "validDtTo") == null)
		      {
	          AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 3, "");
			    }
	        AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 4, $("#userId").val());

	        $("#searchAuthUserExceptMappingPop").remove();
	    }); 
	
});   //$(document).ready


function fnSelectBoxOnChange()
{
	  $("#AuthIdNm").val("");
	  AUIGrid.clearGridData(searchPopAuthGridID);  //grid data clear
}

function fnGetToday()
{
   var date = new Date();

   var year  = date.getFullYear();
   var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
   var day   = date.getDate();

   if (("" + month).length == 1) { month = "0" + month; }
   if (("" + day).length   == 1) { day   = "0" + day;   }
  
  return ("" + year + month + day);  
       
}
</script>

<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Auth Search</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="SearchForm" method="get" action="">

<div class="search_100p"><!-- search_100p start -->
<select class="" id="authSelectBox" name="authSelectBox" onchange="fnSelectBoxOnChange();">
  <option value="01" selected>Auth Code</option>
  <option value="02">Auth Name</option>
</select>
<input type="text" id="AuthIdNm" name="AuthIdNm" />
<a onclick="fnRoleAuthMappingPopSearch();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
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