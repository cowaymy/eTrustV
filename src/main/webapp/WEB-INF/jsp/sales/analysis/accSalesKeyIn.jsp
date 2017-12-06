<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

/* $(document).ready(function() {
	
	//init
	fn_report();	
}); */


function fn_report(){
	
	var option = {
            isProcedure : true 
    };
	Common.report("dataForm", option);
	
}
</script>


<form id="dataForm">
<input type="hidden" id="reportFileName" name="reportFileName" value="/sales/CowayDailySalesStatusHP_Adv.rpt" /><!-- Report Name  -->
<input type="hidden" id="viewType" name="viewType" value="WINDOW" /><!-- View Type  -->
</form>

<section id="content"><!-- content start -->
<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Analysis - Accumulated Sales Key-In</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<a href="javascript:void(0);" onclick="javascript:fn_report();"><span class="clear"></span>리포트 팝업</a>
<object width="100%" height="300" data="">
     <param name="" value=""></param>
</object>


</section><!-- content end -->
