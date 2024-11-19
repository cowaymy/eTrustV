<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<div id="_loading" class="prog" style="display:none;"><!-- prog start -->
	<p>
		<span><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway2.png" alt="Coway" /></span>
		<span><img src="${pageContext.request.contextPath}/resources/images/common/proge.gif" alt="loding...." /></span>
		<a href="javascript:void(0);"></a>
	</p>
</div><!-- prog end -->

	<!-- main 업무 팝업인 경우 class="solo"로 top, left 안보이게 처리 -->
	<div id="wrap" <c:if test="${param.isPop}"> class="solo" </c:if>><!-- wrap start -->

	<header id="header"><!-- header start -->
	<c:choose>
		<c:when test="${SESSION_INFO.userIsPartTime == '1'}">
		</c:when>
		<c:when test="${SESSION_INFO.userIsExternal == '1'}">
		</c:when>
		<c:otherwise>
		<ul class="left_opt">
        <li><a href="javascript:void(0);"><span id="header_refresh"><img src="${pageContext.request.contextPath}/resources/images/common/icon_refresh.png" alt="Refresh" /></span></a></li>
        <!--  <li>Neo(Key-in): <a href="javascript:void(0);"><span id="header_neo">-</span></a></li> -->
        <!-- <li>Kecil : <a href="javascript:void(0);"><span id="header_kecil">-</span></a></li> -->
        <!-- <li>Sales(Key In): <a href="javascript:void(0);"><span id="header_sales">-</span></a></li> -->
        <!--   <li>Net Qty[<a href="javascript:void(0);"><span id="header_netQty"></span></a></li> -->
        <!-- <li>Net Qty [Outright : <a href="javascript:void(0);"><span id="header_outRight">-</span></a></li> -->
        <!-- <li>Instalment: <a href="javascript:void(0);"><span id="header_installment">-</span></a></li> -->
        <!-- <li>Rental: <a href="javascript:void(0);"><span id="header_rental">-</span></a></li> -->
        <!-- <li>Total: <a href="javascript:void(0);"><span id="header_total">-</span></a>]</li> -->
        <!-- <li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
        <!-- <li><span >Accumulated Account:</span> <a href="javascript:void(0);"><span class="red_text" id="header_acc_act_account">-</span></a></li> -->
        <li style="display:none;"><span>WP Sales Key In </span><img id="header_wpFigure" src="${pageContext.request.contextPath}/resources/images/common/icon_grid_detail.png" /></a></li>
        <li><span >Notification:</span> <a href="${pageContext.request.contextPath}/notice/notification.do"><span id="header_notification">-</span></a></li>
        </ul>
		</c:otherwise>
	</c:choose>

	<ul class="right_opt">
	    <li>Login as <span>${SESSION_INFO.userName}</span></li>
	    <li><a href="${pageContext.request.contextPath}/login/logout.do" class="logout">Logout</a></li>

	    <c:choose>
	       <c:when test="${SESSION_INFO.userIsPartTime == '1'}">
	       <li><a href="${pageContext.request.contextPath}/common/mainExternal.do"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
	       </c:when>
	       <c:when test="${SESSION_INFO.userIsExternal == '1'}">
           <li><a href="${pageContext.request.contextPath}/common/mainExternal.do"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
           </c:when>
           <c:otherwise>
           <li><a href="${pageContext.request.contextPath}/common/main.do"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
           </c:otherwise>
	    </c:choose>

	    <li><a href="javascript:fn_userSetting();"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_set.gif" alt="Setting" /></a></li>
	    <li id="menuLinkHelp"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_help.gif" alt="Help" /></a></li>

	    <li id="menuLinkHelpDesk"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/login_hyp_icon.png"  height="28" alt="TrustDesk" /></a></li>

	</ul>
	</header><!-- header end -->

	<hr />

<script type="text/javascript">
    function selectDailyCount(isRemoveCache) {
        if(isRemoveCache){
            Common.ajax("DELETE", "/common/removeCache.do"
                , null
                , function (result) {
                    fn_selectDailyCount();
                }, null, {
                    isShowLoader : false
                });

		}else{
            fn_selectDailyCount();
		}

      /*  $("#header_wpFigure").on("click", function() {
            Common.popupDiv("/chart/wpSalesFigurePop.do", null, null, true, "wpSalesFigurePop");
        });*/


/*
        $("#header_neo").on("click", function(){
            Common.alert("구현중...");
        });

        $("#header_sales").on("click", function(){
            Common.alert("구현중...");
        });

        $("#header_outRight").on("click", function(){
            Common.alert("구현중...");
        });

        $("#header_installment").on("click", function(){
            Common.alert("구현중...");
        });

        $("#header_rental").on("click", function(){
            //Common.alert("구현중...");
            Common.popupDiv("/chart/netSalesChartPop.do", null, null, true, "netSalesChartDivPop");
        });

        $("#header_total").on("click", function(){
            Common.popupDiv("/chart/salesKeyInAnalysisPop.do", null, null, true, "salesKeyInAnalysisDivPop");
        });
*/
    }

    function fn_selectDailyCount(){
        var inintV = "-";
        $("#header_neo").text(inintV);
        $("#header_sales").text(inintV);
        $("#header_outRight").text(inintV);
        $("#header_installment").text(inintV);
        $("#header_rental").text(inintV);
        $("#header_total").text(inintV);
        $("#header_acc_act_account").text(inintV);
        $("#header_notification").text(inintV);

        Common.ajax("GET", "/common/selectDailyCount.do"
            , null
            , function (result) {
                if (result != null && result.length > 0) {
                    //$("#header_neo").text(result[0].neoSales);
                    $("#header_kecil").text(result[0].kecil);
                    $("#header_sales").text(result[0].sales);

                    /*$("#header_netQty").text(result[0].netQty);
                     netQty : outRight + installment + rental*/
                    $("#header_outRight").text(result[0].outRight);
                    $("#header_installment").text(result[0].installment);
                    $("#header_rental").text(result[0].rental);

                    $("#header_total").text(result[0].total);
                    $("#header_acc_act_account").text(result[0].accActAccount);

                    $("#header_notification").text(result[0].ntfCnt)
                    if(result[0].ntfCnt > 0) {
                        $("#header_notification").addClass("red_text");
                    }
                }
            }, null, {
                isShowLoader : false
            });
	}

   $(function() {
	   $("#header_wpFigure").hide();
       selectDailyCount(false);
       fn_selectMyMenuProgrmList();

       // 20190903 KR-OHK :  default date setting( from~to date)
       var fromFieldNm = $("#FROM_FIELD_NM1").val();
       var toFieldNm = $("#TO_FIELD_NM1").val();

       $("#" + fromFieldNm).val($("#FROM_DT1").val());
       $("#" + toFieldNm).val($("#TO_DT1").val());

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

        $("#header_refresh").on("click", function(){
            selectDailyCount(true);
		});

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

		$("#menuLinkHelp").on("click", function(){
		    var menuCode = $("#CURRENT_MENU_CODE").val();

		    if(FormUtil.isNotEmpty(menuCode)){
		        window.open(DEFAULT_HELP_FILE + "/" + menuCode.substr(0, 3) + "/" + menuCode + ".pdf", 'blank', 'width=1024,height=768');
			}
		});

		$("#menuLinkHelpDesk").on("click", function(){
            window.open("http://trustdesk.coway.com.my/", 'blank');
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

function fn_userSetting() {
    var popUpObj = Common.popupDiv
    (
         "/login/userSettingPop.do"
         , ""
         , null
         , "false"
         , "userSettingPop"
    );
}
</script>
<form id="_frameMenuForm">
<!--  20190903 KR-OHK :  default date setting( from~to date) -->
    <input type="hidden" id="FROM_DT1" name="FROM_DT1" value="${param.FROM_DT}"/>
    <input type="hidden" id="FROM_FIELD_NM1" name="FROM_FIELD_NM1" value="${param.FROM_FIELD_NM}"/>
    <input type="hidden" id="TO_DT1" name="TO_DT1" value="${param.TO_DT}"/>
    <input type="hidden" id="TO_FIELD_NM1" name="TO_FIELD_NM1" value="${param.TO_FIELD_NM}"/>
</form>
