<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
	$(document).ready(function(){
		doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'account' , 'S', '');
	});
</script>
<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="../images/common/path_home.gif" alt="Home" /></li>
	<li>Payment</li>
	<li>Document Control</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Submission List</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#"><spring:message code='pay.btn.generatePDF'/></a></p></li>
	<li><p class="btn_blue"><a href="#"><spring:message code='pay.btn.generateExcel'/></a></p></li>
	<li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Settlement Account</th>
	<td>
	<select id="account" name="account" class="w100p"></select>
	</td>
	<th scope="row">Complete Date</th>
	<td>
	<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
	</td>
</tr>
</tbody>
</table><!-- table end -->



</form>
</section><!-- search_table end -->

</section><!-- content end -->
		