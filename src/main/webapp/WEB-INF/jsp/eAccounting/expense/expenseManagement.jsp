<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
</script>

<div id="wrap"><!-- wrap start -->
		
<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="../images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>E-Accounting - Expense Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Claim Type</th>
	<td>
	<select class="multy_select w100p" multiple="multiple">
		<option value="2">Web Invoice</option>
		<option value="3">Petty Cash</option>
		<option value="4">Credit Card Expense</option>
		<option value="5">Staff Claim</option>
		<option value="6">SCM Activity Fund</option>
		<option value="7">SM/GM Claim</option>
		<option value="8">Cody Claim</option>
		<option value="9">CT Claim</option>
	</select>
	</td>
	<th scope="row">Expense Type</th>
	<td>
	<select class="multy_select w100p" multiple="multiple">
		<option value="1">11</option>
		<option value="2">22</option>
		<option value="3">33</option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">Add Expense Type</a></p></li>
	<li><p class="btn_grid"><a href="#">Edit</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
		
</div><!-- wrap end -->