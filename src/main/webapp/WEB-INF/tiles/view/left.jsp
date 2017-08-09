<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="검색" />
</p>

</form>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu" id="leftMenu">

<c:set var="cnt" value="0" />
<c:set var="preMenuCode" value="" />
<c:set var="preMenuLvl" value="" />
<c:set var="preIsLeaf" value="" />

<c:forEach var="list" items="${MENU_KEY}">


    <c:choose>
        <c:when test="${preMenuLvl == list.menuLvl}">
            </li>
        </c:when>
        <c:when test="${preMenuLvl > list.menuLvl}">
            <c:forEach var="i" begin="1" end="${preMenuLvl - list.menuLvl}" step="1">
                    </li>
                </ul>
            </c:forEach>
        </c:when>
        <c:otherwise>

        </c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${ list.menuLvl == '1'}">
        <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}">
            <a id="a_${list.menuCode}" href="javascript:fn_menu('${list.menuCode}', '${list.pgmPath}');">${list.menuName}(LVL : ${list.menuLvl})</a>
        </c:when>
        <c:otherwise>

            <c:choose>
                <c:when test="${preMenuCode != '' && ( list.menuLvl != '1' && preMenuLvl < list.menuLvl)}">
                <ul>
                    <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}">
                        <a id="a_${list.menuCode}" href="javascript:fn_menu('${list.menuCode}', '${list.pgmPath}');">${list.menuName}(LVL : ${list.menuLvl})</a>
                </c:when>
                <c:otherwise>
                    <li id="li_${list.menuCode}" upper_menu_code="${list.upperMenuCode}" menu_level="${list.menuLvl}">
                    <a id="a_${list.menuCode}" href="javascript:fn_menu('${list.menuCode}', '${list.pgmPath}');">${list.menuName}(LVL : ${list.menuLvl})</a>
                </c:otherwise>
            </c:choose>

        </c:otherwise>
    </c:choose>

    <!-- set pre Menu info -->
    <c:set var="preMenuCode" value="${list.menuCode}" />
    <c:set var="preMenuLvl" value="${list.menuLvl}" />
    <c:set var="preIsLeaf" value="${list.isLeaf}" />
    <c:set var="cnt" value="${cnt + 1}" />

    <c:if test="${fn:length(MENU_KEY) == cnt }">
        </li>
    </c:if>

</c:forEach>
</ul>

<!-- MY MENU -->
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
    <li>
    <a href="#">My menu 1depth</a>
        <ul class="inb_menu">
            <li>
                <a href="#">My menu 1depth</a>
            </li>
        </ul>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

<form id="_menuForm">
    <input type="hidden11" id="CURRENT_MENU_CODE" name="CURRENT_MENU_CODE" value="${CURRENT_MENU_CODE}"/>
</form>

<script type="text/javaScript">

$(function() {
    if(FormUtil.isNotEmpty($("#CURRENT_MENU_CODE").val())){
        fn_addClass($("#CURRENT_MENU_CODE").val());
    }
});

// 현재 메뉴 표시.
function fn_addClass(currentMenuCode){
    var $currentLitag = $("#li_" + currentMenuCode);
    var $currentAtag = $("#a_" + currentMenuCode);
    var menuLevel = $currentLitag.attr("menu_level");

    $currentLitag.addClass("active");
    $currentAtag.addClass("on");

    var $parentLiTag = $("#li_" + $currentLitag.attr("upper_menu_code"));

    $parentLiTag.addClass("active");
    $("#a_" + $currentLitag.attr("upper_menu_code")).addClass("on");

    if(menuLevel>= 3){
        fn_addClass($parentLiTag.attr("upper_menu_code"));
    }
}

// 선택한 메뉴화면으로 이동.
function fn_menu(menuCode, menuPath){
    $("#CURRENT_MENU_CODE").val(menuCode);

    $("#_menuForm").attr({
        action : getContextPath() + menuPath,
        method : "POST"
    }).submit();
}
</script>