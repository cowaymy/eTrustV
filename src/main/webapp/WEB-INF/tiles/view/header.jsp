<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<!-- main 업무 팝업인 경우 class="solo"로 top, left 안보이게 처리 -->
	<div id="wrap" <c:if test="${param.isPop}"> class="solo" </c:if>><!-- wrap start -->

	<header id="header"><!-- header start -->
	<ul class="left_opt">  
	    <li>Neo(Mega Deal): <span id="header_neo"></span></li> 
	    <li>Sales(Key In): <span id="header_sales"></span></li> 
	    <li>Net Qty[ <span id="header_netQty"></span></li>
	    <li>Outright : <span id="header_outRight"></span></li>
	    <li>Installment: <span id="header_installment"></span></li>
	    <li>Rental: <span id="header_rental"></span> ]</li>
	    <li>Total: <span id="header_total"></span></li>
	</ul>
	<ul class="right_opt">
	    <li>Login as <span>KRHQ9001-HQ</span></li>
	    <li><a href="/login/logout.do" class="logout">Logout</a></li>
	    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
	    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_set.gif" alt="Setting" /></a></li>
	</ul>
	</header><!-- header end -->
	
	<hr />

<script type="text/javascript">
    function selectDailyCount() {
        Common.ajax("GET", "/common/selectDailyCount.do"
            , null
            , function (result) {
                if (result != null && result.length > 0) {
                    $("#header_neo").text(result[0].neoSales);
                    $("#header_sales").text(result[0].sales);

                    /*$("#header_netQty").text(result[0].netQty);
                     netQty : outRight + installment + rental*/
                    $("#header_outRight").text(result[0].outRight);
                    $("#header_installment").text(result[0].installment);
                    $("#header_rental").text(result[0].rental);
                    
                    $("#header_total").text(result[0].total);
                }
            }, null, {
                isShowLoader : false
            });
        

    }

   $(function() {
	   selectDailyCount();
       fn_selectMyMenuProgrmList();
	   
       // draw menu path.
		var $menuPathObj = $("#content > ul:first-child");
		if($menuPathObj.hasClass("path")){

		    var pathStr =
        		'<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>';

			var pathVal = $("#CURRENT_MENU_FULL_PATH_NAME").val();

			if(FormUtil.isNotEmpty(pathVal)){
                var splitPath = pathVal.split(DEFAULT_DELIMITER);

                if(splitPath.length > 1){
					$.each(splitPath, function(idx, value) {
                            pathStr += '<li>' + value + '</li>';
					});

                    $menuPathObj.html(pathStr);
                }else{
                    console.log("[header.jsp] splitPath.length is 0....");
                }
            }else{
			    console.log("[header.jsp] pathVal is empty....");
            }
		}else{
            console.log("[header.jsp] path class is not found...");
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
	   })	   	  
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

function fn_selectMyMenuProgrmList() {
    Common.ajax(
        "GET",
        "/common/selectMyMenuProgrmList.do",
        "menuCode=" + $("input[name=CURRENT_MENU_CODE]").attr("value"),
        function (data, textStatus, jqXHR) { // Success
            $(".fav a").removeClass("click_add_on");
            if (data.length > 0) {
                $(".fav a").addClass("on");
            }
        },
        function (jqXHR, textStatus, errorThrown) { // Error
            alert("Fail : " + jqXHR.responseJSON.message);
        }
    )
}
</script>
    
    

