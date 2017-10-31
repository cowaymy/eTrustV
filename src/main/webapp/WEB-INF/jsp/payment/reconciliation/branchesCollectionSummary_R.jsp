<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javaScript">
	$(document).ready(function(){
		doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'' , 'branchId' , 'S', ''); //key-in Branch 생성
	});
</script>
<section id="content"><!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Payment</li>
		<li>Branches Collection Report</li>
	</ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2> Branches Collection Report</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a href="#">Generate PDF</a></p></li>
			<li><p class="btn_blue"><a href="#">Generate Excel</a></p></li>
			<li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
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
	                    <th scope="row">Branch</th>
	                    <td colspan="3">
	                       <select id="branchId" name="branchId" class="w100p"></select>
	                    </td>
	                    
	                </tr>
	                <tr>
	                    <th scope="row">Date</th>
	                    <td colspan="3">
	                        <div class="date_set"><!-- date_set start -->
	                        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="fromUploadDate"/></p>
	                        <span>To</span>
	                        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="toUploadDate"/></p>
	                        </div><!-- date_set end -->
	                    </td>
	                </tr>
	            </tbody>
	        </table><!-- table end -->
	    </form>
	</section><!-- search_table end -->

</section><!-- content end -->
		