<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


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

        if(Common.checkPlatformType() == "mobile" && '${SESSION_INFO.userIsExternal}' == "1") {
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
    function fn_menu(obj, menuCode, menuPath, fullPath, myMenuGroupCode, fromDtType, fromDtFieldNm, fromDtVal, toDtType, toDtFieldNm, toDtVal){

        if(FormUtil.isEmpty(menuPath) || $(obj).hasClass("disabled")){
            return;
        }

        // 20190903 KR-OHK : default date setting( from~to date)
        fn_setDefaultDate(fromDtType, fromDtFieldNm, fromDtVal, toDtType, toDtFieldNm, toDtVal);

        $("#CURRENT_MENU_CODE").val(menuCode);

        if($("#_myMenu").hasClass("on")){
            $("#CURRENT_MENU_TYPE").val("MY_MENU");
            $("#CURRENT_GROUP_MY_MENU_CODE").val(myMenuGroupCode);
        }else{
            $("#CURRENT_MENU_TYPE").val("LEFT_MENU");
        }

        $("#CURRENT_MENU_FULL_PATH_NAME").val(fullPath);

        $("#_menuForm").attr({
            action : getContextPath() + menuPath,
            method : "POST"
        }).submit();
    }

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

        }
    }
</script>


<section id="container"><!-- container start -->

    <aside class="lnb_wrap"><!-- lnb_wrap start -->

        <header class="lnb_header"><!-- lnb_header start -->
            <form method="post">
                <h1 class="logo_type">
                    <a name="mainGo" href="${pageContext.request.contextPath}/common/main.do"><img src="${pageContext.request.contextPath}/resources/images/common/CowayLeftLogo.png" alt="COWAY" /></a>
                    <a name="mainGo" href="${pageContext.request.contextPath}/common/main.do"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a>
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
                <a id="a_${list.menuCode}" href="javascript:void(0);" onClick="javascript:fn_menu(this, '${list.menuCode}', '${list.pgmPath}', '${list.pathName}', '', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');" class="${menuStatusClass}">${list.menuName}</a>
                </c:when>
                <c:otherwise>

                <c:choose>
                <c:when test="${preMenuCode != '' && preMenuLvl < list.menuLvl}">
                <ul>
                    <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}">
                        <a id="a_${list.menuCode}" href="javascript:void(0);" onClick="javascript:fn_menu(this, '${list.menuCode}', '${list.pgmPath}', '${list.pathName}', '', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');" class="${menuStatusClass}">${list.menuName}</a>
                        </c:when>
                        <c:otherwise>
                    <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}">
                        <a id="a_${list.menuCode}" href="javascript:void(0);" onClick="javascript:fn_menu(this, '${list.menuCode}', '${list.pgmPath}', '${list.pathName}', '', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');" class="${menuStatusClass}">${list.menuName}</a>
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
                                                <a id="a_${menuList.menuCode}${groupList.mymenuCode}" href="javascript:void(0);" onClick="javascript:fn_menu(this, '${menuList.menuCode}', '${menuList.pgmPath}', '${menuList.pathName}', '${groupList.mymenuCode}', '${list.fromDtType}', '${list.fromDtFieldNm}', '${list.fromDtVal}', '${list.toDtType}', '${list.toDtFieldNm}', '${list.toDtVal}');">${menuList.menuName}</a>
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
        <!--  20190903 KR-OHK :  default date setting( from~to date) -->
        <input type="hidden" id="FROM_DT" name="FROM_DT"/>
        <input type="hidden" id="FROM_FIELD_NM" name="FROM_FIELD_NM"/>
        <input type="hidden" id="TO_DT" name="TO_DT"/>
        <input type="hidden" id="TO_FIELD_NM" name="TO_FIELD_NM"/>
    </form>
