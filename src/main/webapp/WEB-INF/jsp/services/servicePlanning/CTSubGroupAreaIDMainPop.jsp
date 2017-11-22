<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
</script>
<div id="popup_wrap" class="popup_wrap">
<section id="content"><!-- content start -->
<!-- <ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>CT Sub Group Search</li>
</ul> -->
<header class="pop_header"><!-- pop_header start -->
<h1>CT Sub Group Search</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<!-- <aside class="title_line">title_line start
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>CT Sub Group Search</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside>title_line end -->
<section class="pop_body"><!-- pop_body start -->
<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="areaMainForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">DSC Branch</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
    </td>
    <th scope="row">CTM</th>
    <td><input type="text" title="" placeholder="Martin" class="w100p" /></td>
    <th scope="row">CT Sub Group</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
    </td>
    <th scope="row">Postal Code From</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Postal Code To</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">Magic Address Download</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h4>Area ID – CT Sub Group</h4>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">Edit</a></p></li>
    <li><p class="btn_grid"><a href="#">Save</a></p></li>
    <li><p class="btn_grid"><a href="#">Display</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
</section>
</div>