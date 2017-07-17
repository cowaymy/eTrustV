<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript" language="javascript">
	$(function() {

	});

	function fn_openWinPop() {

		var option = {
	            width : "1024px", // 창 가로 크기
	            height : "768px" // 창 세로 크기
	        };
		
		var reportViewUrl = "/report/view.do"; // report를 보기 위한 uri 
		Common.popupWin("dataForm", reportViewUrl, option);
	}
</script>



<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Training</li>
		<li>Course</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Course</h2>
		<ul class="right_btns">
			<li><p class="btn_blue">
					<a href="javascript:void(0);" onclick="javascript:fn_openWinPop();"><span
						class="clear"></span>리포트 팝업</a>
				</p></li>
		</ul>
	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="dataForm">
			/etrust/src/main/webapp/resources/report 이후 경로를 보내 줘야 함.(name 을 반드시 reportFileName 전송해야 함.) : 
<!--        
            <input type="text" id="reportFileName" name="reportFileName" value="/sample/CowayDailySalesStatusHP.rpt" /><br />
 -->
			<input type="text" id="reportFileName" name="reportFileName" value="/sample/CustOwnOrderList.rpt" /><br />
		</form>
	</section>
	<!-- search_table end -->

</section>
<!-- content end -->

