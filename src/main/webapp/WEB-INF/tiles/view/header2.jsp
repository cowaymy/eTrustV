<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<div id="_loading" class="prog" style="display:none;"><!-- prog start -->
	<p>
		<span><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway2.png" alt="Coway" /></span>
		<span><img src="${pageContext.request.contextPath}/resources/images/common/proge.gif" alt="loding...." /></span>
		<a href="javascript:void(0);"></a>
	</p>
</div><!-- prog end -->

<script type="text/javascript">
   $(function() {

	   // 20190903 KR-OHK :  default date setting( from~to date)
	   var fromFieldNm = $("#FROM_FIELD_NM").val();
       var toFieldNm = $("#TO_FIELD_NM").val();

	   $("#" + fromFieldNm).val($("#FROM_DT").val());
       $("#" + toFieldNm).val($("#TO_DT").val());

	   // draw menu path.
		var $menuPathObj = $("#content > ul:first-child");

		if($menuPathObj.hasClass("path")){
		    var pathStr = '<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>';

			var pathVal = $("#CURRENT_MENU_FULL_PATH_NAME").val();
			//var pathVal = $(top.document).find("#CURRENT_MENU_FULL_PATH_NAME").val();
			//console.log("[header2.jsp] pathVal : " + pathVal);

			if(FormUtil.isNotEmpty(pathVal)){
                var splitPath = pathVal.split(DEFAULT_DELIMITER);

                if(splitPath.length > 1){
					$.each(splitPath, function(idx, value) {
                            pathStr += '<li>' + value + '</li>';
					});

                    $menuPathObj.html(pathStr);
                }else{
                    console.log("[header2.jsp] splitPath.length is 0....");
                }
            }else{
			    console.log("[header2.jsp] pathVal is empty....");
            }
		}else{
            console.log("[header2.jsp] path class is not found...");
        }

	   $(".fav a").bind("click",function(){
		   if($(".fav a").attr("class")=="on"){
			   var closeTag = false;
		        Common.ajax(
		                "POST",
		                "/common/savetMyMenuProgrmList.do",
		                {add:[],update:[],remove:[{menuCode:$("input[name=CURRENT_MENU_CODE]").attr("value")}]},
		                function(data, textStatus, jqXHR){ // Success
		                	$(".fav a").removeClass("on");
		                	alert("Removed menu.");
		                	closeTag = true;
		                },
		                function(jqXHR, textStatus, errorThrown){ // Error
		                    alert("Fail : " + jqXHR.responseJSON.message);
		                }
		        )
		        if(closeTag) mymenuPop.remove();
		   }else{
			   var popUpObj = Common.popupDiv
               (
                    "/common/mymenuPop.do"
                    , ""
                    , null
                    , "false"
                    , "mymenuPop"
               );
		   }
	   });
   });


   function mymenuPopSelect(_mymenuCode){
	   var closeTag = false;
	   Common.ajax(
               "POST",
               "/common/savetMyMenuProgrmList.do",
               {add:[{mymenuCode:_mymenuCode,menuCode:$("input[name=CURRENT_MENU_CODE]").attr("value")}],update:[],remove:[]},
               function(data, textStatus, jqXHR){ // Success
            	   $(".fav a").addClass("on");
            	   alert("Registered menu.");
            	   mymenuPop.remove();
               },
               function(jqXHR, textStatus, errorThrown){ // Error
                   alert("Fail : " + jqXHR.responseJSON.message);
               }
       );

   };
</script>

<form id="_frameMenuForm">
    <c:choose>
        <c:when test="${empty param.CURRENT_MENU_CODE}">
            <input type="hidden" id="CURRENT_MENU_CODE" name="CURRENT_MENU_CODE" value="${CURRENT_MENU_CODE}"/>
        </c:when>
        <c:otherwise>
            <input type="hidden" id="CURRENT_MENU_CODE" name="CURRENT_MENU_CODE" value="${param.CURRENT_MENU_CODE}"/>
        </c:otherwise>
    </c:choose>
    <input type="hidden" id="CURRENT_MENU_FULL_PATH_NAME" name="CURRENT_MENU_FULL_PATH_NAME" value="${param.CURRENT_MENU_FULL_PATH_NAME}"/>
    <input type="hidden" id="CURRENT_GROUP_MY_MENU_CODE" name="CURRENT_GROUP_MY_MENU_CODE" value="${param.CURRENT_GROUP_MY_MENU_CODE}"/>
    <input type="hidden" id="CURRENT_MENU_TYPE" name="CURRENT_MENU_TYPE" value="${param.CURRENT_MENU_TYPE}"/>
    <!--  20190903 KR-OHK :  default date setting( from~to date) -->
    <input type="hidden" id="FROM_DT" name="FROM_DT" value="${param.FROM_DT}"/>
    <input type="hidden" id="FROM_FIELD_NM" name="FROM_FIELD_NM" value="${param.FROM_FIELD_NM}"/>
    <input type="hidden" id="TO_DT" name="TO_DT" value="${param.TO_DT}"/>
    <input type="hidden" id="TO_FIELD_NM" name="TO_FIELD_NM" value="${param.TO_FIELD_NM}"/>
</form>

<%-- <div id="_tempPath">${param.CURRENT_MENU_PATH}</div> --%>