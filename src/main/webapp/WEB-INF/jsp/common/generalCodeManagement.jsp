<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<div id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<div class="title_line"><!-- title_line start -->
<p class="fav"><img src="${pageContext.request.contextPath}/resources/image/icon_star.gif" alt="즐겨찾기" /></p>
<h2>General Code Management</h2>
<ul class="right_opt">
	<li><p class="btn_blue"><a href="#">Save</a></p></li>
</ul>
</div><!-- title_line end -->

<div class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table summary="search table" class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Master ID</th>
	<td><input type="text" title="Master ID" placeholder="Master ID" class="w100p" /></td>
	<th scope="row">Name</th>
	<td><input type="text" title="Name" placeholder="Name" class="w100p" /></td>
	<th scope="row">Description</th>
	<td><input type="text" title="Description" placeholder="Description" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Creator</th>
	<td><input type="text" title="Creator" placeholder="Creator Username" class="w100p" /></td>
	<th scope="row">Create Date</th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->

	</td>
	<th scope="row">Disabled</th>
	<td><input type="text" title="Disabled" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
	<li><p class="btn_gray"><a href="#"><span class="search"></span>Search</a></p></li>
</ul>
</form>
</div><!-- search_table end -->

<div class="search_result"><!-- search_result start -->
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>ADD</a></p></li>
</ul>

<div class="grid_wrap h220"><!-- grid_wrap start -->
그리드 영역
</div><!-- grid_wrap end -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
	<li><p class="btn_grid"><a href="#"><span class="search"></span>ADD</a></p></li>
</ul>

<div class="grid_wrap h220"><!-- grid_wrap start -->
그리드 영역
</div><!-- grid_wrap end -->

</div><!-- search_result end -->

</div><!-- content end -->
	