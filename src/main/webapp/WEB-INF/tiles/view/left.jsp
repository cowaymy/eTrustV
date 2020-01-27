<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<style type="text/css" >

.ui-tabs .ui-tabs-panel {
    display: block;
    border-width: 0;
    padding: 1em 1.2em 1em 0.7em !important;
    background: none;
}
</style>
<script type="text/javaScript">

    $(function() {
        if($("#_leftMenu").hasClass("on") && FormUtil.isNotEmpty($("#CURRENT_MENU_CODE").val())){
            fn_addClassLeftMenu($("#CURRENT_MENU_CODE").val());
        }else{
            fn_addClassMyMenu($("#CURRENT_MENU_CODE").val(), $("#CURRENT_GROUP_MY_MENU_CODE").val());
        }


        // Applies only if the menu path exists.
        var menuTags = new Array();
        var itemValue = {};

        <c:forEach var="item" items="${MENU_KEY}">
            <c:if test="${not empty item.pgmPath}">
            itemValue = {};
            itemValue.value = "${item.menuCode}";
            itemValue.label = "${item.menuName}" ;
            menuTags.push(itemValue);
            </c:if>
        </c:forEach>

        $( "#_leftSearch" ).autocomplete({
            source: menuTags,
            select: function( e, ui ) {
                if(FormUtil.isNotEmpty(ui.item.value)){
                    $("#a_" + ui.item.value).click();
                }
                return false;
            },
            focus: function(event, ui) {
                $(this).val(ui.item.label);
                return false;
            }
        });

        $( "#_leftSearchImg" ).on("click", function (e) {
            var selectedMenuCode = $(".ui-helper-hidden-accessible").text();
            if(FormUtil.isNotEmpty(selectedMenuCode)){
                $("#a_" + selectedMenuCode).click();
            }
            return false;
        });

        // [Woongjin Jun] Toggle Button
        if (Common.checkPlatformType() == "mobile") { // pc, mobile
            $("#leftMenuToggle").show();

            $(document).on('click', '.js-adminmenu-toggle', function (e) {
                if (!$('#container > .js-adminmenu-toggle').length) {
                    $('#container').prepend($(this).clone().addClass('active'));
                    $("#container").css("padding", "32px 0 0 0");
                    $(".lnb_wrap").hide(200);
                } else {
                    $('#container > .js-adminmenu-toggle').remove();
                    $("#container").css("padding", "32px 0 0 215px");
                    $(".lnb_wrap").show(200);
                }
            });

            //$(".js-adminmenu-toggle").click();
        }
        // [Woongjin Jun] Toggle Button

        if( '${SESSION_INFO.userIsExternal}' == "1" ) {
            $("a[name=mainGo]").attr("href", "${pageContext.request.contextPath}/common/mainExternal.do")
        }else{
            $("a[name=mainGo]").attr("href", "${pageContext.request.contextPath}/common/main.do")
        }
    });

    // 현재 메뉴 표시.
    function fn_addClassLeftMenu(currentMenuCode){
        var $currentLitag = $("#li_" + currentMenuCode);
        var $currentAtag = $("#a_" + currentMenuCode);
        var menuLevel = $currentLitag.attr("menu_level");

        $currentLitag.addClass("active");
        $currentAtag.addClass("on");

        var $parentLiTag = $("#li_" + $currentLitag.attr("upper_menu_code"));

        $parentLiTag.addClass("active");
        $("#a_" + $currentLitag.attr("upper_menu_code")).addClass("on");

        if(FormUtil.isNotEmpty(menuLevel) && menuLevel>= 3){
            fn_addClassLeftMenu($parentLiTag.attr("upper_menu_code"));
        }
    }

    // 현재 마이메뉴 표시.
    function fn_addClassMyMenu(currentMenuCode, groupMenuCode){
        var $currentLitag = $("#li_" + currentMenuCode + groupMenuCode);
        var $currentAtag = $("#a_" + currentMenuCode + groupMenuCode);

        $currentLitag.addClass("active");
        $currentAtag.addClass("on");

        var $parentLiTag = $("#li_" + $currentLitag.attr("group_my_menu_code"));
        var $parentATag = $("#a_" + $currentLitag.attr("group_my_menu_code"));

        $parentLiTag.addClass("active");
        $parentATag.addClass("on");
    }

    // 선택한 메뉴화면으로 이동.
    function fn_menu(obj, menuCode, menuPath, fullPath, myMenuGroupCode, mnName, fromDtType, fromDtFieldNm, fromDtVal, toDtType, toDtFieldNm, toDtVal){ // [Woongjin Jun] Tab
        if(FormUtil.isEmpty(menuPath) || $(obj).hasClass("disabled")){
            return;
        }

        // 20190903 KR-OHK : default date setting( from~to date)
        fn_setDefaultDate(fromDtType, fromDtFieldNm, fromDtVal, toDtType, toDtFieldNm, toDtVal);

        // [Woongjin Jun] Mobile Popup
        if (Common.checkPlatformType() == "mobile" && menuPath.indexOf("serialScanningGRList.do") != -1) { // pc, mobile
            popupObj = Common.popupWin("serialScanningGR", "/logistics/SerialMgmt/serialScanningGRList.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        }
        else if (Common.checkPlatformType() == "mobile" && menuPath.indexOf("serialScanningGISTOList.do") != -1) {
            popupObj = Common.popupWin("serialScanningGISTO", "/logistics/SerialMgmt/serialScanningGISTOList.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        }
        else if (Common.checkPlatformType() == "mobile" && menuPath.indexOf("serialScanningGISMOList.do") != -1) {
            popupObj = Common.popupWin("serialScanningGISMO", "/logistics/SerialMgmt/serialScanningGISMOList.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        }
        else {
            // [Woongjin Jun] Toggle Button
            if (Common.checkPlatformType() == "mobile") { // pc, mobile
                if (menuPath.indexOf("serialScanningGRList.do") != -1) {
                    $(".js-adminmenu-toggle").click();

                    $("#wrap").css("min-width", "100%"); //1200px
                    $("#container").css("min-width", "100%"); //1200px
                    $("#header").css("min-width", "100%"); //1200px
                }
                else {
                    $("#wrap").css("min-width", "1200px");
                    $("#container").css("min-width", "1200px");
                    $("#header").css("min-width", "1200px");
                }
                if (menuCode == "tttttt") {
                 $(".js-adminmenu-toggle").click();
                }
            }
            // [Woongjin Jun] Toggle Button

            // [Woongjin Jun] Tab
            if ($("#mainTabs").find("li").length > 0 && $("#mainTabs").find("li").length >= 7 && $("#mainTabs ul").find("li[aria-controls=tabs-" + menuCode + "]").length == 0 ) {
            	alert("Max 7 Screen");
                return;
            }
            // [Woongjin Jun] Tab

            $("#CURRENT_MENU_PATH").val(menuPath);
            $("#CURRENT_MENU_CODE").val(menuCode);

            if($("#_myMenu").hasClass("on")){
                $("#CURRENT_MENU_TYPE").val("MY_MENU");
                $("#CURRENT_GROUP_MY_MENU_CODE").val(myMenuGroupCode);
            }else{
                $("#CURRENT_MENU_TYPE").val("LEFT_MENU");
            }

            $("#CURRENT_MENU_FULL_PATH_NAME").val(fullPath);

            // [Woongjin Jun] Tab
            if ($("#mainTabs ul").find("li[aria-controls=tabs-" + menuCode + "]").length > 0) {
                $("#mainTabs").tabs("option", "active", id2Index("#mainTabs", "#tabs-" + menuCode));
            }
            else {
                var tg = addTab(mnName, getContextPath() + menuPath, menuCode);

                $("#_menuForm").attr({
                    action : getContextPath() + menuPath,
                    method : "POST",
                    target : tg
                }).submit();
            }

            $(".inb_menu li").children().removeClass("on");

            if($("#_leftMenu").hasClass("on") && FormUtil.isNotEmpty(menuCode)){
                fn_addClassLeftMenu(menuCode);
            }else{
                fn_addClassMyMenu(menuCode, myMenuGroupCode);
            }
            // [Woongjin Jun] Tab
        }
    }

    // [Woongjin Jun] Tab
    var tabTemplate = "<li><a href='\#{href}'>\#{label}</a><span class='ui-icon ui-icon-close' role='presentation'>Remove Tab</span></li>";
    var totTabCount = 0;
    var tabs;
    var menuLoadingCount = 0;

    function addTab(nm, url, menuCode) {
        if (totTabCount == 0) {
            $("#content").hide();
            $("#content2").show();
        }

        console.log("addTab1 : " + nm);
        console.log("addTab2 : " + url);
        console.log("addTab3 : " + menuCode);

        var id = "tabs-" + menuCode;
        var li = $(tabTemplate.replace(/#\{href}/g, "#" + id).replace(/#\{label}/g, nm));
        var frameId = "frame-" + menuCode;
        //var tabContentHtml = "<iframe id='" + frameId + "' name='" + frameId + "' width='100%' onload='resizeIframe(this)' class='iframetab' scrolling='no'></iframe>";
        // 20190911 KR-MIN : for grid resizing
        var tabContentHtml = "<iframe id='" + frameId + "' name='" + frameId + "' width='100%' onload='resizeIframe(this)' class='iframetab'  scrolling='no' ></iframe>";

        tabs.find("#mainTabTitle").append(li);
        tabs.append("<div id='" + id + "' style='overflow-x: hidden; overflow-y: auto;'><p>" + tabContentHtml + "</p></div>");
        tabs.tabs("refresh").tabs("option", "active", totTabCount);

        if (FormUtil.isNotEmpty($("#_loading").html())) {
            //$("#_loading").show();
        } else {
            $("body").append(Common.getLoadingObj());
        }

        menuLoadingCount = 1;

        totTabCount++;

        return frameId;
    }

    function addTabLink(nm, url) {
        var frameId = addTab(nm, url);
        $("#" + frameId).attr("src", url);
    }

    function resizeIframe(obj) {
        /*
        //console.log("offsetHeight : " + obj.contentWindow.document.body.offsetHeight);
        //console.log("scrollHeight : " + obj.contentWindow.document.body.scrollHeight);
        console.log("windowHeight1 : " + $(window).height());
        var windowHeight = $(window).height() - 100;
        console.log("windowHeight2 : " + windowHeight);
        var iframeHeight = obj.contentWindow.document.body.scrollHeight + 15;
        if (windowHeight > iframeHeight) {
            iframeHeight = windowHeight;
        }
        $(obj).animate({height: iframeHeight + 'px'}, 500);

         if(menuLoadingCount == 1){
             $("#_loading").hide();
         }
         */
        // 20190911 KR-MIN : for grid resizing
        //var iframeHeight = $(window).height() - $(obj).offset().top;
        var iframeHeight = $(window).height() - 95;
        //console.log(">>>>>>>>>>" +$(window).height() + "," + iframeHeight);
        $(obj).height(iframeHeight + "px");

         if(menuLoadingCount == 1){
             $("#_loading").hide();
         }
    }


    // 20190911 KR-MIN : for grid resizing
    // iframe resizing
    $(window).resize(function () {
        $(".iframetab").each(function( index ) {
            //alert(this)
            resizeIframe(this);
        });

    });

    function resizeIframeCall() {
        return;
        /*
        var activeTabId = $(document).find("#mainTabs > ul > .ui-tabs-active").attr("aria-controls");
        var activeFrameId = activeTabId.replace("tabs-", "frame-");

        //var iframeHeight = $(window).height();
        //console.log("html : " + $("#" + activeFrameId).contents().find("html").text());
        var iframeHeight = $("#" + activeFrameId).contents().find("html").height();
        //console.log("TestHeight1 : " + $(window).height());
        //console.log("offsetHeight111 : " + iframeHeight);
        //console.log("offsetHeight222 : " + $("#" + frameId).contents().find("html").height());
        //console.log("offsetHeight333 : " + $("#" + frameId).contents().height());
        $("#" + activeFrameId).animate({height: iframeHeight + 'px'}, 500);
        */
    }

    function id2Index(tabsId, srcId) {
        var index = -1;
        var i = 0;
        var tbH = $(tabsId).find("li a");
        var lntb = tbH.length;
        if (lntb > 0) {
            for (i = 0; i < lntb; i++) {
                o = tbH[i];
                if (o.href.search(srcId)>0) {
                    index = i;
                }
            }
        }
        return index;
    }
    // [Woongjin Jun] Tab

 // 20190903 KR-OHK : default date setting( from~to date)
    function fn_setDefaultDate (fromDtType, fromDtFieldNm, fromDtVal, toDtType, toDtFieldNm, toDtVal) {

        var fromDtType =fromDtType;
        var fromDtFieldNm =fromDtFieldNm;
        var fromDtVal = FormUtil.isEmpty(fromDtVal)?Number("0"):Number(fromDtVal);
        var toDtType = toDtType;
        var toDtFieldNm =toDtFieldNm;
        var toDtVal = FormUtil.isEmpty(toDtVal)?Number("0"):Number(toDtVal);

        if(FormUtil.isNotEmpty(fromDtType) && FormUtil.isNotEmpty(toDtType) && FormUtil.isNotEmpty(fromDtFieldNm) && FormUtil.isNotEmpty(toDtFieldNm)) {
            var currDt = new Date();
            var currYear  = currDt.getFullYear();
            var currMonth = currDt.getMonth();
            var fromDay =  currDt.getDate() + fromDtVal;
            var toDay = currDt.getDate() + toDtVal;

            var dt = new Date();
            var firstDt = new Date( dt.getFullYear(), dt.getMonth() , 1 );
            var lastDtOfPreMonth = new Date ( firstDt.setDate( firstDt.getDate() - 1 ) );
            var preYear = lastDtOfPreMonth.getFullYear();
            var preMonth = lastDtOfPreMonth.getMonth();

            var setFromDt = "";
            var setToDt = "";

            if(fromDtType == "D1") {             // Today
                setFromYY = currYear;
                setFromMM = currMonth;
                setFromDD = fromDay;
            } else if(fromDtType == "M1") {   // First day of This Month
                 setFromYY = currYear;
                 setFromMM = currMonth;
                 setFromDD = "1";
            } else if(fromDtType == "M2") {   // First day of Pre Month
                setFromYY = preYear;
                setFromMM = preMonth;
                setFromDD = "1";
            } else if(fromDtType == "Y1") {   // January 1st of This Year
                setFromYY = currYear;
                setFromMM = "0";
                setFromDD = "1";
            } else {
                setFromYY = currYear;
                setFromMM = currMonth;
                setFromDD = fromDay;
            }

            if(toDtType == "D1") {              // Today
                setToYY = currYear;
                setToMM = currMonth;
                setToDD = toDay;
            } else if(toDtType == "M1") {   // First day of This Month
                setToYY = currYear;
                setToMM = currMonth;
                setToDD = "1";
            } else if(toDtType == "M2") {   // First day of Pre Month
                setToYY = preYear;
                setToMM = preMonth;
                setToDD = "1";
            } else if(toDtType == "Y1") {   // January 1st of This Year
                setToYY = currYear;
                setToMM = "0";
                setToDD = "1";
            } else {
                setToYY = currYear;
                setToMM = currMonth;
                setToDD = toDay;
            }

            $("#FROM_FIELD_NM").val(fromDtFieldNm);
            $("#TO_FIELD_NM").val(toDtFieldNm);
            $("#FROM_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setFromYY, setFromMM, setFromDD)));
            $("#TO_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setToYY, setToMM, setToDD)));

            $("#serialScanningGR #GR_FROM_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setFromYY, setFromMM, setFromDD)));
            $("#serialScanningGR #GR_TO_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setToYY, setToMM, setToDD)));

            $("#serialScanningGISTO #GR_FROM_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setFromYY, setFromMM, setFromDD)));
            $("#serialScanningGISTO #GR_TO_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setToYY, setToMM, setToDD)));

            $("#serialScanningGISMO #GR_FROM_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setFromYY, setFromMM, setFromDD)));
            $("#serialScanningGISMO #GR_TO_DT").val($.datepicker.formatDate('dd/mm/yy', new Date(setToYY, setToMM, setToDD)));

        }
    }

    // new browser tab
    function fn_menuNew(obj, menuCode, menuPath, fullPath, myMenuGroupCode, mnName, fromDtType, fromDtFieldNm, fromDtVal, toDtType, toDtFieldNm, toDtVal){ // [Woongjin Jun] Tab
        var option = {
                width: "1000px", // 창 가로 크기
                height: "520px" // 창 세로 크기
                 }
         var win = window.open(menuPath, '_blank');
          win.focus();
    }
</script>
<!-- [Woongjin Jun] Tab -->
<style type="text/css">
    .iframetab {
        width: 100%;
        height: 200px;
        border: 0px;
        margin: 0px;
    }
</style>
<!-- [Woongjin Jun] Tab -->

<section id="container"><!-- container start -->

    <aside class="lnb_wrap"><!-- lnb_wrap start -->
        <!-- [Woongjin Jun] Toggle Button -->
        <div id="leftMenuToggle" class="js-adminmenu-toggle" style="display:none;"></div>
        <!-- [Woongjin Jun] Toggle Button -->

        <header class="lnb_header"><!-- lnb_header start -->
            <form method="post">
                <h1 class="logo_type">
                    <a href="${pageContext.request.contextPath}/common/main.do"><img src="${pageContext.request.contextPath}/resources/images/common/CowayLeftLogo.png" alt="COWAY" /></a>
                    <a href="${pageContext.request.contextPath}/common/main.do"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a>
                </h1>
                <p class="search">
                    <input type="text" id="_leftSearch" name="_leftSearch" title="Enter search term" onkeyPress="if (event.keyCode==13){return false;}" />
                    <input type="image" id="_leftSearchImg" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="Search" />
                </p>
            </form>
        </header><!-- lnb_header end -->

        <section class="lnb_con"><!-- lnb_con start -->
            <p id="_leftMenu" class="click_add_on_solo<c:if test="${param.CURRENT_MENU_TYPE != 'MY_MENU'}"> on</c:if>"><a href="#">All menu</a></p>
            <ul class="inb_menu" id="leftMenu">

                <c:set var="cnt" value="0" />
                <c:set var="preMenuCode" value="" />
                <c:set var="preMenuLvl" value="" />
                <c:set var="preIsLeaf" value="" />
                <c:set var="menuStatusClass" value="" />

                <c:forEach var="list" items="${MENU_KEY}"  varStatus="status">

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


                <c:choose>
                    <c:when test="${preMenuLvl == list.menuLvl}">
                        </li>
                    </c:when>
                    <c:when test="${preMenuLvl != '' && preMenuLvl > list.menuLvl}">
                        <c:forEach var="i" begin="1" end="${preMenuLvl - list.menuLvl}" step="1">
                            </li>
                        </ul>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>

                    </c:otherwise>
                </c:choose>

            <c:choose>
            <c:when test="${ list.menuLvl == 1}">
            <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}">
                <!-- [Woongjin Jun] Tab -->
                <a id="a_${list.menuCode}" href="javascript:void(0);" onClick="javascript:fn_menu(this, '${list.menuCode}', '${list.pgmPath}', '${list.pathName}', '', '${list.menuName}', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');" class="${menuStatusClass}">${list.menuName}</a>
                <!-- [Woongjin Jun] Tab -->
                </c:when>
                <c:otherwise>

                <c:choose>
                <c:when test="${preMenuCode != '' && preMenuLvl < list.menuLvl}">
                <ul>
                    <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}">
                        <!-- [Woongjin Jun] Tab -->
                        <a id="a_${list.menuCode}" href="javascript:void(0);" onClick="javascript:fn_menu(this, '${list.menuCode}', '${list.pgmPath}', '${list.pathName}', '', '${list.menuName}', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');" class="${menuStatusClass}">${list.menuName}
                        <c:if test="${list.pgmPath == '/sales/ccp/selectCalCcpList.do'}">
                        <img src="${pageContext.request.contextPath}/resources/images/common/btn_plus.gif" alt="New Tab" onClick="javascript:fn_menuNew(this, '${list.menuCode}', '${list.pgmPath}', '${list.pathName}', '', '${list.menuName}', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');" />
                        </c:if>
                        </a>
                        <!-- [Woongjin Jun] Tab -->
                        </c:when>
                        <c:otherwise>
                    <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}">
                        <!-- [Woongjin Jun] Tab -->
                        <a id="a_${list.menuCode}" href="javascript:void(0);" onClick="javascript:fn_menu(this, '${list.menuCode}', '${list.pgmPath}', '${list.pathName}', '', '${list.menuName}', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');" class="${menuStatusClass}">${list.menuName}
                        <c:if test="${list.pgmPath == '/sales/ccp/selectCalCcpList.do'}">
                        <img src="${pageContext.request.contextPath}/resources/images/common/btn_plus.gif" alt="New Tab" onClick="javascript:fn_menuNew(this, '${list.menuCode}', '${list.pgmPath}', '${list.pathName}', '', '${list.menuName}', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');" />
                        </c:if>
                        </a>
                        <!-- [Woongjin Jun] Tab -->
                        </c:otherwise>
                        </c:choose>

                        </c:otherwise>
                        </c:choose>

                        <!-- set pre Menu info -->
                        <c:set var="preMenuCode" value="${list.menuCode}" />
                        <c:set var="preMenuLvl" value="${list.menuLvl}" />
                        <c:set var="preIsLeaf" value="${list.isLeaf}" />
                        <c:set var="cnt" value="${cnt + 1}" />

                        <c:if test="${status.last}">
                            <c:if test="${list.menuLvl == 1}">
                            </li>
                            </c:if>

                            <c:if test="${list.menuLvl > 1}">
                                <c:forEach var="i" begin="1" end="${list.menuLvl}" step="1">
                                    </li>
                                </ul>
                                </c:forEach>
                            </c:if>
                        </c:if>

                </c:forEach>

                </ul>

                <!-- MY MENU -->
                <p id="_myMenu" class="click_add_on_solo<c:if test="${param.CURRENT_MENU_TYPE == 'MY_MENU'}"> on</c:if>"><a href="javascript:void(0);"><span></span>My menu</a></p>
                <ul class="inb_menu">

                    <c:set var="preMyMenuCode" value="" />

                    <c:forEach var="groupList" items="${MENU_FAVORITES}">

                        <c:if test="${preMyMenuCode != groupList.mymenuCode}">
                            <li id="li_${groupList.mymenuCode}">
                            <a id="a_${groupList.mymenuCode}" href="javascript:void(0);">${groupList.mymenuName}</a>

                            <c:set var="groupPerMenuCnt" value="0" />
                            <c:set var="isBreak" value="0" />

                            <c:forEach var="menuList" items="${MENU_FAVORITES}" varStatus="status">
                                <c:if test="${isBreak == 0}">
                                    <c:choose>
                                        <c:when test="${groupList.mymenuCode == menuList.mymenuCode}">
                                            <c:if test="${groupPerMenuCnt == 0}">
                                                <ul>
                                            </c:if>
                                            <li  id="li_${menuList.menuCode}${groupList.mymenuCode}" group_my_menu_code="${groupList.mymenuCode}">
                                                <!-- [Woongjin Jun] Tab -->
                                                <a id="a_${menuList.menuCode}${groupList.mymenuCode}" href="javascript:void(0);" onClick="javascript:fn_menu(this, '${menuList.menuCode}', '${menuList.pgmPath}', '${menuList.pathName}', '${groupList.mymenuCode}', '${menuList.menuName}', '${menuList.fromDtType}', '${menuList.fromDtFieldNm}', '${menuList.fromDtVal}', '${menuList.toDtType}', '${menuList.toDtFieldNm}', '${menuList.toDtVal}');">${menuList.menuName}</a>
                                                <!-- [Woongjin Jun] Tab -->
                                            </li>
                                            <c:set var="groupPerMenuCnt" value="${groupPerMenuCnt + 1}" />
                                        </c:when>
                                        <c:when test="${groupPerMenuCnt > 0}">
                                            </ul>
                                            <c:set var="isBreak" value="1" />
                                        </c:when>
                                    </c:choose>
                                </c:if>
                            </c:forEach>
                        </c:if>

                        </li>

                        <c:set var="preMyMenuCode" value="${groupList.mymenuCode}" />
                    </c:forEach>
                </ul>
        </section><!-- lnb_con end -->

    </aside><!-- lnb_wrap end -->

    <form id="_menuForm">

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
        <input type="hidden" id="CURRENT_MENU_PATH" name="CURRENT_MENU_PATH" value=""/>
        <!--  20190903 KR-OHK :  default date setting( from~to date) -->
        <input type="hidden" id="FROM_DT" name="FROM_DT"/>
        <input type="hidden" id="FROM_FIELD_NM" name="FROM_FIELD_NM"/>
        <input type="hidden" id="TO_DT" name="TO_DT"/>
        <input type="hidden" id="TO_FIELD_NM" name="TO_FIELD_NM"/>
    </form>

    <!-- [Woongjin Jun] Mobile Popup -->
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
