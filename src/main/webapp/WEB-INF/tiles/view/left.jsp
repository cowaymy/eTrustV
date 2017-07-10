<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div id="container"><!-- container start -->

<div class="lnb_wrap"><!-- lnb_wrap start -->

<div class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="#"><img src="${pageContext.request.contextPath}/resources/image/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/image/icon_lnb_search.gif" alt="검색" />
</p>

</form>
</div><!-- lnb_header end -->

<div class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu">
    <li class="on">
    <a href="#">menu 1depth</a>

    <ul>
        <li class="on">
        <a href="#">menu 2depth</a>

        <ul>
            <li class="on">
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
        </ul>

        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
    </ul>

    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
</ul>
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
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
    <li>
    <a href="#">My menu 1depth</a>
    </li>
</ul>
</div><!-- lnb_con end -->

</div><!-- lnb_wrap end -->


