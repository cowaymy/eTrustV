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

function fnSelectRoleListAjax()
{
  if ($("#roleSelectBox").val() == "01")  // role id
	{
	  $("#roleId").val($("#roleIdNm").val());
	  $("#roleNm").val("");
	}
  else
	{
	  $("#roleId").val("");
	  $("#roleNm").val($("#roleIdNm").val());
	}

   Common.ajax("GET", "/authorization/selectRoleList.do"
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

function fnSelectBoxChanged()
{
   $("#roleIdNm").val("");
   $("#roleIdNm").focus();
}

var SearchRoleColumnLayout =
    [
        {
            dataField : "roleId",
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleId' />",
            width : "15%"
        },{
            dataField : "roleName",
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleName' />",
            style : "aui-grid-left-column",
            width : "70%"
        },{
            dataField : "roleLev",
            headerText : "<spring:message code='sys.authRolePop.grid1.RoleLevel' />",
            width : "15%"
        },{
            dataField : "role1",
            headerText : "role1",
            width : 0
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
            fnSelectRoleListAjax();
          }

    });


	var searchOptions = {
	                  usePaging : false,
	                  useGroupingPanel : false,
	                  editable : false,
	                  showRowNumColumn : false  // 그리드 넘버링
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

	        var SerchRoleId = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "roleId");
	        var SerchRoleName = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "roleName");
	        var SerchRoleLev = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "roleLev");
	        var SerchRoleCd1 = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "role1");
	        var SerchRoleCd2 = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "role2");
	        var SerchRoleCd3 = AUIGrid.getCellValue(searchRoleGridID, event.rowIndex, "role3");

          var strRoleSplit = SerchRoleName.split(" > ");
          var role_1 =  String(strRoleSplit[0]).fnTrim();
          var role_2 =  String(strRoleSplit[1]).fnTrim();
          var role_3 =  String(strRoleSplit[2]).fnTrim();

          //value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){

          if (role_1 == 'undefined')
          {
              role_1 ="";
          }
          if (role_2 == 'undefined')
          {
              role_2 ="";
          }
          if (role_3 == 'undefined')
          {
    	      role_3 ="";
          }
           if (SerchRoleCd1 == undefined)
          {
        	  SerchRoleCd1 ="";
          }
          if (SerchRoleCd2 == undefined)
          {
        	  SerchRoleCd2 ="";
          }
          if (SerchRoleCd3 == undefined)
          {
        	  SerchRoleCd3 ="";
          }

         /*  var hiddenRoleCode = SerchRoleCd1+","+SerchRoleCd2+","+SerchRoleCd3+",";
          console.log ("RoleCodeConCat: " + hiddenRoleCode); */

	        console.log("SerchRoleId: " + SerchRoleId +" / SerchRoleName: " + SerchRoleName +" / SerchRoleLev1: " + role_1
	                   +" / SerchRoleLev2: " + role_2+" / SerchRoleLev3: " + role_3  );

	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 2, SerchRoleName);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 3, SerchRoleId);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 4, SerchRoleLev);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 5, role_1);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 6, role_2);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 7, role_3);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 8, '');
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 9, SerchRoleCd1);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 10, SerchRoleCd2);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 11, SerchRoleCd3);

	        $("#SearchRolePop").remove();
	    });

});   //$(document).ready


</script>

<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Role Search</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="SearchForm" method="get" action="">
<input type ="hidden" id="roleId" name="roleId" value=""/>
<input type ="hidden" id="roleNm" name="roleNm" value=""/>

<div class="search_100p"><!-- search_100p start -->
<select class="" id="roleSelectBox" name="roleSelectBox" onchange="fnSelectBoxChanged();">
  <option value="01" selected>Role ID</option>
  <option value="02">Role Name</option>
</select>
<input type="text" id="roleIdNm" name="roleIdNm" />
<a onclick="fnSelectRoleListAjax();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
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