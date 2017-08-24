<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript" language="javascript">
	$(function() {

	});

	function fn_report() {

	    // viewType : WINDOW 인 경우 popupWin 옵션 사용 가능.
	    /*
        var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            width : "1024px", // 창 가로 크기
            height : "768px" // 창 세로 크기
        };

        Common.report("dataForm", option);
		*/

	    ////////////////////////////////////////////////////////////////////////////////////////

	    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
		var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
		};

        Common.report("dataForm", option);

        ////////////////////////////////////////////////////////////////////////////////////////

        // 프로시져 아닌 경우 아래만 호출.
        //Common.report("dataForm");
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
					<a href="javascript:void(0);" onclick="javascript:fn_report();"><span
						class="clear"></span>리포트 팝업</a>
				</p></li>
		</ul>
	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="dataForm">
			/etrust/src/main/webapp/resources/report 이후 경로를 보내 줘야 함. :<br /><br />
			<!--
                        <input type="text" id="reportFileName" name="reportFileName" value="/sample/CowayDailySalesStatusHP.rpt" /><br />
                        <input type="text" id="reportFileName" name="reportFileName" value="/sample/CustOwnOrderList.rpt" /><br />
                        <input type="text" id="reportFileName" name="reportFileName" value="/payment/PaymentListing_Excel.rpt" /><br />
             -->
<!-- ### 필수 파라미터 start ### -->
			<!-- 리포트 파일명 -->
			리포트 파일명(필수 : reportFileName) :
			<input type="text" id="reportFileName" name="reportFileName" value="/sample/PaymentListing_Excel.rpt" /><br /><br />

			<!-- view type
			WINDOW : window popup
			PDF : PDF 다운로드
			EXCEL : EXCEL 다운로드
			CVS : CVS 다운로드
			-->
			viewType(필수 : viewType) : <input type="text" id="viewType" name="viewType" value="PDF" /><br /><br />
<!-- ### 필수 파라미터 end ### -->

			<!-- 다운로드될 파일명 지정 -->
			다운로드될 파일명 지정(옵션 : reportDownFileName) : <input type="text" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" /><br /><br />

			<!-- 리포트에서 사용할 파라미터 start-->
			리포트 파일에 전달될 파라미터 설정 : <br/>
			<input type="text" id="V_WHERESQL" name="V_WHERESQL" value="and pm.OR_NO = 'OR312430'" /><br />
			<input type="text" id="@WhereSQL" name="@WhereSQL" value="and pm.OR_NO = 'OR312430'" /><br /><!-- AS-IS 파라미터로 설정된 값 -->
			<!-- 리포트에서 사용할 파라미터 end-->
		</form>
	</section>
	<!-- search_table end -->

</section>
<!-- content end -->

