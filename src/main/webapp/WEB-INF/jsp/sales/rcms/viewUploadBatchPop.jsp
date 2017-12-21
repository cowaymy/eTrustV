<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>ORDER REMARK UPLOAD - VIEW UPLOAD BATCH</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h3>Order Remark Batch Info</h3>
<%-- <c:if test="${cnvrInfo.code eq 'ACT'}">
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="fn_confirm()">Confirm</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="fn_deactivate()">Deactivate</a></p></li>
</ul>
</c:if> --%>
</aside><!-- title_line end -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Batch ID</th>
    <td><span>${infoMap.uploadMid}</span></td>
    <th scope="row">Status</th>
    <td><span>${infoMap.name}</span></td>
</tr>
<tr>
    <th scope="row">Upload By</th>
    <td><span>${infoMap.updUserName}</span></td>
    <th scope="row">Update By</th>
    <td><span>${infoMap.updDt}</span></td>
</tr>
<tr>
    <th scope="row">Total Item</th>
    <td><span>${cnvrInfo.rsCnvrCnfmDt }</span></td>
    <th scope="row">Total Valid / Invalid</th>
    <td><span>${cnvrInfo.rsCnvrCnfmUserName }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Batch Item</h3>
</aside><!-- title_line end -->

<ul class="left_btns">
    <li><p class="btn_grid"><a href="#" onclick="fn_all()">All Item</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="fn_valid()">Valid Item</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="fn_invalid()">Invalid Item</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="dt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end-->
