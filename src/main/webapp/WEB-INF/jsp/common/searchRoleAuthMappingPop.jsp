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

  $("#popUpRoleId").val( $("#roleIdNm").val() );
	
   Common.ajax("GET", "/authorization/selectRoleAuthMappingPopUpList.do"
           , $("#SearchForm").serialize()
           , function(result) 
           {
              console.log("성공 data : " + result);
              AUIGrid.setGridData(searchRoleGridID, result);
              if(result != null && result.length > 0)
              {
                //fnSetroleIdParamSet(searchRoleGridID, 0);
              }
           });
}


var SearchRoleColumnLayout = 
    [      
        {       
            dataField : "authCode",
            headerText : "<spring:message code='sys.auth.grid1.AuthCode' />",
            width : 100
        },{
            dataField : "roleId",
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleId' />",
            width : 100
        },{
            dataField : "authName",
            headerText : "<spring:message code='sys.auth.grid1.authName' />",           
            style : "aui-grid-left-column",
            width : 250
        },{
            dataField : "roleLvl",
            headerText :"<spring:message code='sys.authRolePop.grid1.RoleLevel' />",
            width : 100
        },{
            dataField : "role2",
            headerText : "role2",
            width : 0
        },{
            dataField : "role3",
            headerText : "role3",
            width : 0
        }
    ];

/***************************************************[ Main GRID] ***************************************************/    
var searchRoleGridID;

$(document).ready(function()
{
    $("#roleIdNm").focus();
    
    $("#roleIdNm").keydown(function(key) 
    {
          if (key.keyCode == 13) 
          {
        	  fnRoleAuthMappingPopSearch();
          }

    });
	

	var searchOptions = {
	                  usePaging : false,
	                  useGroupingPanel : false,
	                  editable : true,
	                  enableRestore : true,
	                  softRemovePolicy : "exceptNew",
	                };
	    
    // AUIGrid 그리드를 생성합니다.
	    searchRoleGridID = GridCommon.createAUIGrid("search_grid_wrap", SearchRoleColumnLayout,"roleId", searchOptions);

	    // cellClick event.
	    AUIGrid.bind(searchRoleGridID, "cellClick", function( event ) 
	    {
	        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " event_value: " + event.value );
	    });

	 // 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(searchRoleGridID, "cellDoubleClick", function(event) 
	    {
	        console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );

	        var SerchAuthCd = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "authCode");
	        var SerchAuthId = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "roleId");
	        var SerchAuthName = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "authName");
	        var SerchAuthLev = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "roleLvl");
	        
	        if (gSelMstRolLvl !=  SerchAuthLev )
		      {
	        	//Common.alert("Can not be modified. Not at the same level");
            Common.alert("<spring:message code='sys.msg.cannot' arguments='Modified ; Different Levels.' htmlEscape='false' argumentSeparator=';'/>");
	        	return false;
		      }

	        AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 0, SerchAuthCd);
	        AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 1, SerchAuthName);
	        AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 2, SerchAuthId);
	        AUIGrid.setCellValue(AuthGridID, gSelMainRowIdx, 3, SerchAuthLev);

	        $("#searchRoleAuthMappingPop").remove();
	    }); 
	
});   //$(document).ready


</script>

<body>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Auth Search</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="SearchForm" method="get" action="">
<input type ="hidden" id="popUpRoleId" name="popUpRoleId" value=""/>
<input type ="hidden" id="roleNm" name="roleNm" value=""/>

<div class="search_100p"><!-- search_100p start -->
<select class="" id="roleSelectBox" name="roleSelectBox">
  <option value="01" selected>Role ID</option>
  <option value="02">Auth Name</option>
</select>
<input type="text" id="roleIdNm" name="roleIdNm" />
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