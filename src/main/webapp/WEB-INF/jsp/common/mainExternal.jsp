<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">




<style type="text/css">
    /* 커스텀 칼럼 스타일 정의 */
    .aui-grid-user-custom-left {
        text-align:left;
    }
    .aui-grid-user-custom-right {
        text-align:right;
    }
    .gray-field {
        background : #eeeeee;
        color:#000;
    }

    .button {
        background-color: #06a7e2;
        color: #FFFFFF;
        text-align: left;
        font-size: 50px;
        padding: 10px;
        border-radius: 10px;
        -moz-border-radius: 10px;
        -webkit-border-radius: 10px;
        margin:10px
    }

    .button2 {
        background-color: #0c3a65;
        color: #FFFFFF;
        text-align: left;
        font-size: 50px;
        padding: 10px;
        border-radius: 10px;
        -moz-border-radius: 10px;
        -webkit-border-radius: 10px;
        margin:10px
    }

    .small-btn {
        width: 50px;
        height: 25px;
    }

    .medium-btn {
        width: 70px;
        height: 30px;
    }

    .big-btn {
        width: 700px;
        height: 120px;
    }

        #tabs { margin-top: 1em; }
    #tabs li .ui-icon-close { float: left; margin: 0.4em 0.2em 0 0; cursor: pointer; }
    #add_tab { cursor: pointer; }
</style>






<script type="text/javaScript">
    $(document).ready(function () {
        $(".bottom_msg_box").attr("style","display:none");

        $.each($("#mobileMenu li"), function(index){
        	var pgm_path = $(this).attr("pgm_path");
        	if( pgm_path == "/homecare/po/hcDeliveryGr.do" ){
        		var btnStr = "";
        		btnStr += '<button class="button2 big-btn" id="btnCreateGr">';
        		btnStr += 'Create GR';
        		btnStr += '</button>';
        		$(this).closest("#mobileMenu").prepend(btnStr);
        	}
        });



        $("#btnCreateGr").bind("click", function(){
        	if(Common.checkPlatformType() == "mobile") {
        		popupObj = Common.popupWin("frmNew", "/homecare/po/hcDeliveryGr/hcDeliveryGrPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
            } else{
                Common.popupDiv("/homecare/po/hcDeliveryGr/hcDeliveryGrPop.do", null, null, true, '_divDeliveryGrPop', function(){$(".popup_wrap").css("width", '550px');});
            }
        });


        //  [Woongjin Jun] Tab
        tabs = $("#mainTabs").tabs();

        tabs.on("click", "span.ui-icon-close", function() {
            var panelId = $(this).closest("li").remove().attr("aria-controls");
            $("#" + panelId).remove();
            tabs.tabs("refresh");

            totTabCount--;

            if (totTabCount == 0) {
                $("#content2").hide();
                $("#content").show();
            }
        });

        $("#btnTabPrev").on("click", function() {
            if ($("#mainTabs").tabs("option", "active") > 0) {
                $("#mainTabs").tabs("option", "active", ($("#mainTabs").tabs("option", "active") - 1));
            }
        });

        $("#btnTabNext").on("click", function() {
            if ($("#mainTabs").tabs("option", "active") < ($("#mainTabs").find("li").length - 1)) {
                $("#mainTabs").tabs("option", "active", ($("#mainTabs").tabs("option", "active") + 1));
            }
        });

        $("#btnTabAllClose").on("click", function() {
            $("#mainTabs").find("li").each(function() {
                var panelId = $(this).closest("li").remove().attr("aria-controls");
                $("#" + panelId).remove();
                tabs.tabs("refresh");
            });

            totTabCount = 0;

            $("#content2").hide();
            $("#content").show();
        });
        // [Woongjin Jun] Tab
    });



    function fn_menuMobile(obj, menuCode, menuPath, fullPath, myMenuGroupCode, fromDtType, fromDtFieldNm, fromDtVal, toDtType, toDtFieldNm, toDtVal){
        if(FormUtil.isEmpty(menuPath) || $(obj).hasClass("disabled")){
            return;
        }

        // 20190903 KR-OHK : default date setting( from~to date)
        fn_setDefaultDate(fromDtType, fromDtFieldNm, fromDtVal, toDtType, toDtFieldNm, toDtVal);

        if (Common.checkPlatformType() == "mobile" && menuPath.indexOf("serialScanningGRList.do") != -1) { // pc, mobile
        	$("#serialScanningGR #GR_FROM_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setFromYY, setFromMM, setFromDD)));
            $("#serialScanningGR #GR_TO_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setToYY, setToMM, setToDD)));

            popupObj = Common.popupWin("serialScanningGR", "/logistics/SerialMgmt/serialScanningGRList.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        }
        else if (Common.checkPlatformType() == "mobile" && menuPath.indexOf("serialScanningGISTOList.do") != -1) {
        	$("#serialScanningGISTO #GR_FROM_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setFromYY, setFromMM, setFromDD)));
            $("#serialScanningGISTO #GR_TO_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setToYY, setToMM, setToDD)));

            popupObj = Common.popupWin("serialScanningGISTO", "/logistics/SerialMgmt/serialScanningGISTOList.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        }
        else if (Common.checkPlatformType() == "mobile" && menuPath.indexOf("serialScanningGISMOList.do") != -1) {
        	$("#serialScanningGISMO #GR_FROM_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setFromYY, setFromMM, setFromDD)));
            $("#serialScanningGISMO #GR_TO_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setToYY, setToMM, setToDD)));

            popupObj = Common.popupWin("serialScanningGISMO", "/logistics/SerialMgmt/serialScanningGISMOList.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        }
        else {

	        $("#CURRENT_MENU_CODE").val(menuCode);

	        if($("#_myMenu").hasClass("on")){
	            $("#CURRENT_MENU_TYPE").val("MY_MENU");
	            $("#CURRENT_GROUP_MY_MENU_CODE").val(myMenuGroupCode);
	        }else{
	            $("#CURRENT_MENU_TYPE").val("LEFT_MENU");
	        }

	        $("#CURRENT_MENU_FULL_PATH_NAME").val(fullPath);

	       /*  $("#_menuForm").attr({
	            action : getContextPath() + menuPath,
	            method : "POST"
	        }).submit(); */

	           //  [Woongjin Jun] Tab
           /*  tabs = $("#mainTabs").tabs();

            tabs.on("click", "span.ui-icon-close", function() {
                var panelId = $(this).closest("li").remove().attr("aria-controls");
                $("#" + panelId).remove();
                tabs.tabs("refresh");

                totTabCount--;

                if (totTabCount == 0) {
                    $("#content2").hide();
                    $("#content").show();
                }
            });

            $("#btnTabPrev").on("click", function() {
                if ($("#mainTabs").tabs("option", "active") > 0) {
                    $("#mainTabs").tabs("option", "active", ($("#mainTabs").tabs("option", "active") - 1));
                }
            });

            $("#btnTabNext").on("click", function() {
                if ($("#mainTabs").tabs("option", "active") < ($("#mainTabs").find("li").length - 1)) {
                    $("#mainTabs").tabs("option", "active", ($("#mainTabs").tabs("option", "active") + 1));
                }
            });

            $("#btnTabAllClose").on("click", function() {
                $("#mainTabs").find("li").each(function() {
                    var panelId = $(this).closest("li").remove().attr("aria-controls");
                    $("#" + panelId).remove();
                    tabs.tabs("refresh");
                });

                totTabCount = 0;

                $("#content2").hide();
                $("#content").show();
            }); */
            // [Woongjin Jun] Tab
        }
    }
</script>



<!-- [Woongjin Jun] Tab -->
<section id="content2" style="width: 100%; height: 1000; border: 1px; color: black; display: none; overflow-x: hidden; overflow-y: auto;">
    <div id="mainTabs" style="width: 100%; height: 1000; border: 1px; color: black;">
        <ul id="mainTabTitle" style="padding-right: 130px;">
            <div style="position: absolute; top: 15px; right: 120px;"><a href="javascript:;" id="btnTabPrev">&lt;</a></div>
            <div style="position: absolute; top: 15px; right: 100px;"><a href="javascript:;" id="btnTabNext">&gt;</a></div>
            <div style="position: absolute; top: 15px; right: 15px;"><a href="javascript:;" id="btnTabAllClose">Close All X</a></div>
        </ul>
    </div>
</section>
<!-- [Woongjin Jun] Tab -->

<!-- [Woongjin Jun] Tab Style Display -->

<section id="content"><!-- content start -->
    <aside class="title_line main_title"><!-- title_line start -->
        <h2>Welcome to eTRUST System.</h2>
    </aside><!-- title_line end -->
        <section class="lnb_con"><!-- lnb_con start -->
            <ul class="inb_menu" id="mobileMenu">
                <c:set var="cnt" value="0" />
                <c:set var="preMenuCode" value="" />
                <c:set var="preMenuLvl" value="" />
                <c:set var="preIsLeaf" value="" />
                <c:set var="menuStatusClass" value="" />



                <c:forEach var="list" items="${MENU_KEY}"  varStatus="status">



                    <c:if test="${list.pgmPath ne null}">



                        <c:choose>
                            <c:when test="${list.statusCode == '1'}">
                                <c:set var="menuStatusClass" value="status_new" />
                            </c:when>
                            <c:when test="${list.statusCode == '2'}">
                                <c:set var="menuStatusClass" value="status_dev" />
                            </c:when>
                            <c:when test="${list.statusCode == '3'}">
                                <c:set var="menuStatusClass" value="status_upd" />
                            </c:when>
                            <c:when test="${list.statusCode == '4'}">
                                <c:set var="menuStatusClass" value="disabled" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="menuStatusClass" value="" />
                            </c:otherwise>
                        </c:choose>



                        <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}" pgm_path="${list.pgmPath}">
                            <button class="button big-btn">
                                <a  style ="color:#FFFFFF; text-align: left; font-size: 50px;"
                                    id="a_${list.menuCode}"
                                    href="javascript:void(0);"
                                    onClick="javascript : fn_menuMobile(        this
                                                                            ,   '${list.menuCode}'
                                                                            ,   '${list.pgmPath}'
                                                                            ,   '${list.pathName}'
                                                                            ,   ''
                                                                            ,   '${list.fromDtType}'
                                                                            ,   '${list.fromDtFieldNm}'
                                                                            ,   '${list.fromDtVal}'
                                                                            ,   '${list.toDtType}'
                                                                            ,   '${list.toDtFieldNm}'
                                                                            ,   '${list.toDtVal}');"
                                    class="${menuStatusClass}"
                                    >
                                        ${list.menuName}
                                </a>
                            </button>
                        </li>



                        <!-- set pre Menu info -->
                        <c:set var="preMenuCode" value="${list.menuCode}" />
                        <c:set var="preMenuLvl" value="${list.menuLvl}" />
                        <c:set var="preIsLeaf" value="${list.isLeaf}" />
                    </c:if>
                </c:forEach>
            </ul>
        </section><!-- lnb_con end -->
    </aside><!-- lnb_wrap end -->
</section>
<form id="frmNew" name="frmNew" action="#" method="post"></form>
<form id="serialScanningGR" name="serialScanningGR" action="#" method="post">
     <input type="hidden" id="GR_FROM_DT" name="GR_FROM_DT" value=""/>
     <input type="hidden" id="GR_TO_DT" name="GR_TO_DT" value=""/>
 </form>
 <form id="serialScanningGISTO" name="serialScanningGISTO" action="#" method="post">
     <input type="hidden" id="GR_FROM_DT" name="GR_FROM_DT" value=""/>
     <input type="hidden" id="GR_TO_DT" name="GR_TO_DT" value=""/>
  </form>
 <form id="serialScanningGISMO" name="serialScanningGISMO" action="#" method="post">
     <input type="hidden" id="GR_FROM_DT" name="GR_FROM_DT" value=""/>
     <input type="hidden" id="GR_TO_DT" name="GR_TO_DT" value=""/>
 </form>
<!-- container end -->
