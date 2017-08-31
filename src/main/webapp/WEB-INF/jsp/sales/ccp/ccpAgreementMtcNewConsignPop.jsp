<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>ADD NEW CONSIGNMENT</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:210px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Courier Method.</th>
    <td colspan="3">
    <label><input type="radio" name="courier" /><span>By Hand</span></label>
    <label><input type="radio" name="courier" /><span>Courier</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Courier Consignment No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Courier</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Cosign Method</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">AGM Requestor</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">Clear</a></p></li>
</ul>
</section><!-- pop_body end -->
</div>