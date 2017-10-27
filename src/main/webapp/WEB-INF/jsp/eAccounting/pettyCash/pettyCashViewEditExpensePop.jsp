<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View / Edit Petty Cash Expense</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#">Approval Line</a></p></li>
	<li><p class="btn_blue2"><a href="#">Request</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Cost Center</th>
	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Creator</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" /></td>
</tr>
<tr>
	<th scope="row">Custodian</th>
	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">IC No / Passport No</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" /></td>
</tr>
<tr>
	<th scope="row">Bank</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" /></td>
	<th scope="row">Bank Account</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" /></td>
</tr>
<tr>
	<th scope="row">Claim Month</th>
	<td colspan="3"><input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Invoice Date</th>
	<td colspan="3"><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
	<th scope="row">Expense Type</th>
	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Invoice Type</th>
	<td>
	<select class="w100p">
		<option value="">Full Tax invoice</option>
		<option value="">Simplified Tax invoice</option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Supplier</th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">GST Registration No</th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Tax Code</th>
	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Invoice No</th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Approved cash amount (RM)</th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">GST (RM)</th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row"></th>
	<td></td>
	<th scope="row">Total Amount</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" /></td>
</tr>
<tr>
	<th scope="row">Attachment</th>
	<td colspan="3">
	<div class="auto_file2"><!-- auto_file start -->
	<input type="file" title="file add" />
	</div><!-- auto_file end -->
	</td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="3"><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#">Add</a></p></li>
	<li><p class="btn_blue2"><a href="#">Clear</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text">Total Amount:<span>10000</span></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->