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
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
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
			<!-- 	<input type="text" id="reportFileName" name="reportFileName" value="/sample/PaymentListing_Excel.rpt" /><br /><br />-->
			<!-- <input type="" id="reportFileName" name="reportFileName" value="/membership/MembershipInvoice.rpt" />-->
			<!-- <input type="" id="reportFileName" name="reportFileName" value="/sales/POSReceipt_New.rpt" />-->
			<!-- <input type="text" id="reportFileName" name="reportFileName" value="/sample/CustOwnOrderList.rpt" /><br /> -->

			<!--

			2017-11-17 17:31:01,105 DEBUG [com.coway.trust.web.common.ReportController]  k : reportFileName, V : /sales/CCPSummary_CcpAdminProductivity.rpt
2017-11-17 17:31:01,105 DEBUG [com.coway.trust.web.common.ReportController]  k : viewType, V : PDF
2017-11-17 17:31:01,105 DEBUG [com.coway.trust.web.common.ReportController]  k : reportDownFileName, V : CCPDailyProductivity_17112017
2017-11-17 17:31:01,105 DEBUG [com.coway.trust.web.common.ReportController]  k : V_ORDERDATEFR, V : 2017-11-06 00:00:00
2017-11-17 17:31:01,105 ERROR [com.coway.trust.web.common.ReportController] com.coway.trust.cmmn.exception.ApplicationException: 매개 변수 필드 형식과 매개 변수 필드 현재 값 형식이 호환되지 않습니다.
	at com.coway.trust.web.common.ReportController.lambda$4(ReportController.java:349)
			-->

			<input type="text" id="reportFileName" name="reportFileName" value="/sales/CCPSummary_CcpAdminProductivity.rpt" /><br />


			<!-- view type
			WINDOW : window popup
			PDF : PDF 다운로드
			EXCEL : EXCEL 다운로드 (데이터만)
			EXCEL_FULL : 리포트 그대로 엑셀로 저장.
			CVS : CVS 다운로드
			MAIL_PDF, MAIL_EXCEL, MAIL_CVS:  이메일 전송
			-->
			viewType(필수 : viewType) : <input type="text" id="viewType" name="viewType" value="WINDOW" /><br /><br />
<!-- ### 필수 파라미터 end ### -->

			<!-- 다운로드될 파일명 지정 -->
			다운로드될 파일명 지정(옵션 : reportDownFileName) : <input type="text" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" /><br /><br />

			<!-- 이메일 전송인 경우 모두 필수-->
			email subject : <input type="text" id="emailSubject" name="emailSubject" value="[제목]리포트 엑셀 메일 전송 테스트" /><br />
			email text : <input type="text" id="emailText" name="emailText" value="[내용]리포트 엑셀 메일 전송 테스트" /><br />
			email to [구분자 = |!| : var.jsp =>  DEFAULT_DELIMITER 참고] : <input type="text" id="emailTo" name="emailTo" value="t1706042@partner.coway.co.kr|!|t1706036@partner.coway.co.kr" /><br />

			<!-- 리포트에서 사용할 파라미터 start-->
			리포트 파일에 전달될 파라미터 설정 : <br/>

			<input type="text" id="V_WHERESQL" name="V_WHERESQL" value="AND ROWNUM <= 10" /><br />
			<input type="text" id="V_ORDERDATEFR" name="V_ORDERDATEFR" value="2017-10-01 00:00:00" /><br />
			<input type="text" id="V_ORDERDATETO" name="V_ORDERDATETO" value="2017-10-30 00:00:00" /><br />

			<!--
			<input type="text" id="V_REFNO" name="V_REFNO" value="1111111" /><br />
			<input type="text" id="@WhereSQL" name="@WhereSQL" value="and pm.OR_NO = 'OR312430'" /><br /><!-- AS-IS 파라미터로 설정된 값 -->
			<!--
			<input type="text" id="V_POSREFNO" name="V_POSREFNO" value="PSN0005181" /><br />
			<input type="text" id="V_POSMODULETYPEID" name="V_POSMODULETYPEID" value="1343" /><br />
			-->

			<!-- 리포트에서 사용할 파라미터 end-->
		</form>
	</section>
	<!-- search_table end -->

</section>
<!-- content end -->

