<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Holiday List Search</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Holiday List Search</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
    <th scope="row">Holiday Type</th>
    <td>
        <select class="w100p">
            <option value="1">Public</option>
            <option value="2">State</option>
        </select>
    </td>
    <th scope="row">State</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
    </td>
    <th scope="row">Holiday</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
    <th scope="row">Assign Status</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
    </td>
    <th scope="row">Branch</th>
    <td>
        <div class="search_100p">
            <input type="text" title="" placeholder="" class="w100p" /><a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a>
        </div>
    </td>
    <th></th>
    <td></td>
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

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td>
    <label><input type="radio" name="name" checked="checked" /><span>Holiday List Display</span></label>
    <label><input type="radio" name="name" /><span>Replacement CT Assign Status</span></label>
    </td>
</tr>
</tbody>
</table>

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">SAVE</a></p></li>
    <li><p class="btn_grid"><a href="#">Replacement CT Entry</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
