<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">
	$(document).ready(function(){

	});

	 //그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
        editable            : false,
        fixedColumnCount    : 0,
        showStateColumn     : false,
        displayTreeOpen     : false,
      //selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        noDataMessage       : '<spring:message code="sales.msg.noOrdNo" />',
        groupingMessage     : "Here groupping"
    };

    function chgTab(tabNm) {
        switch(tabNm) {
            case 'custInfo' :
                AUIGrid.resize(custInfoGridID, 942, 380);
                break;
            case 'memInfo' :
                AUIGrid.resize(memInfoGridID, 942, 380);
                break;
            case 'docInfo' :
                AUIGrid.resize(docGridID, 942, 380);
                if(AUIGrid.getRowCount(docGridID) <= 0) {
                    fn_selectDocumentList();
                }
                break;
            case 'callLogInfo' :
                AUIGrid.resize(callLogGridID, 942, 380);
                if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                    fn_selectCallLogList();
                }
                break;
        };
    }
</script>
</head>

<section class="tap_wrap"><!-- tap_wrap start -->
	<ul class="tap_type1 num4">
	    <li><a id="aTabBI" href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
	    <li><a href="#"><spring:message code="sal.title.text.hpCody" /></a></li>
	    <li><a id="aTabCI" href="#" onClick="javascript:chgTab('custInfo');"><spring:message code="sal.title.text.custInfo" /></a></li>
	    <li><a id="aTabIns" href="#"><spring:message code="sal.title.text.installInfo" /></a></li>
<%-- 	    <li><a id="aTabMA" href="#"><spring:message code="sal.title.text.maillingInfo" /></a></li>
	    <li><a id="aTabMI" href="#" onClick="javascript:chgTab('memInfo');"><spring:message code="sal.title.text.memshipInfo" /></a></li> --%>
	    <li><a id="aTabDS" href="#" onClick="javascript:chgTab('docInfo');"><spring:message code="sal.title.text.docuSubmission" /></a></li>
	    <li><a href="#" onClick="javascript:chgTab('callLogInfo');"><spring:message code="sal.title.text.callLog" /></a></li>
	    <li><a id="aTabGC"href="#"><spring:message code="sal.title.text.reliefCertificate" /></a></li>
	    <li><a href="#" onClick="javascript:chgTab('gstRebateInfo');"><spring:message code="sal.title.text.gstRebate" /></a></li>
	</ul>

<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/services/onLoan/include/basicInfo.jsp" %>
<!------------------------------------------------------------------------------
    HP / Cody
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/services/onLoan/include/hpCody.jsp" %>
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/services/onLoan/include/custInfo.jsp" %>
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/services/onLoan/include/installInfo.jsp" %>
<!------------------------------------------------------------------------------
    Mailling Info
-----------------------------------------------------------------------------
<%-- <%@ include file="/WEB-INF/jsp/services/onLoan/include/mailInfo.jsp" %> --%>
<!------------------------------------------------------------------------------
    Membership Info
------------------------------------------------------------------------------->
<%-- <%@ include file="/WEB-INF/jsp/services/onLoan/include/membershipInfo.jsp" %> --%>
<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/services/onLoan/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------
    Call Log
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/services/onLoan/include/callLog.jsp"%>
<!------------------------------------------------------------------------------
    GST Rebate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/services/onLoan/include/gstRebateList.jsp" %>
</section><!-- tap_wrap end -->