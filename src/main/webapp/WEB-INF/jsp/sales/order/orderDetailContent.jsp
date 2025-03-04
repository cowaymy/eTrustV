<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    $(document).ready(function(){
       $('#btnViewAirConCboOrdNo').click(function() {
            Common.popupDiv("/homecare/sales/hcAirCondBulkOrderSearchPop.do", {ordId:"${orderDetail.basicInfo.ordId}", pckBindingId: "${orderDetail.basicInfo.pckageBindingNo}"}, null, true);
        });
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
            case 'payInfo' :
                AUIGrid.resize(payGridID, 942, 380);
	            if(AUIGrid.getRowCount(payGridID) <= 0) {
                    fn_selectPaymentList();
                }
                break;
            case 'transInfo' :
                AUIGrid.resize(transGridID, 942, 380);
	            if(AUIGrid.getRowCount(transGridID) <= 0) {
                    fn_selectTransList();
                }
                break;
            case 'autoDebitInfo' :
                AUIGrid.resize(autoDebitGridID, 942, 380);
	            if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                    fn_selectAutoDebitList();
                }
                break;
            case 'ecashResult' :
                AUIGrid.resize(ecashGridID, 942, 380);
	            if(AUIGrid.getRowCount(ecashGridID) <= 0) {
                    fn_selectEcashList();
                }
                break;
            case 'discountInfo' :
                AUIGrid.resize(discountGridID, 942, 380);
	            if(AUIGrid.getRowCount(discountGridID) <= 0) {
                    fn_selectDiscountList();
                }
                break;
            case 'gstRebateInfo' :
                AUIGrid.resize(discountGridID, 942, 380);
	            if(AUIGrid.getRowCount(discountGridID) <= 0) {
	            	fn_selectGstRebateList();
                }
                break;
            case 'pvRebateInfo' :
                AUIGrid.resize(pvRebateGridID, 942, 380);
	            if(AUIGrid.getRowCount(pvRebateGridID) <= 0) {
	            	fn_selectPvRebateList();
                }
                break;
            case 'mcoRemark' :
                AUIGrid.resize(mcoRemarkGridID, 942, 380);
	            if(AUIGrid.getRowCount(mcoRemarkGridID) <= 0) {
	            	fn_selectMCORemarkList();
                }
                break;
            case 'fmcoEvoucher' :
                AUIGrid.resize(fmcoEvoucherGridID, 942, 380);
                if(AUIGrid.getRowCount(fmcoEvoucherGridID) <= 0) {
                	fn_selectMCORemarkList();
                }
                break;
            case 'renAgr' :
                AUIGrid.resize(fmcoEvoucherGridID, 942, 380);
                break;
            case 'ccpTicket':
            	AUIGrid.resize("logGrid", 942, 380);
                break;
            case 'comboRebateInfo' :
                AUIGrid.resize(discountGridID, 942, 380);
                if(AUIGrid.getRowCount(discountGridID) <= 0) {
                	fn_selectComboRebateList();
                }
                break;
            case 'mixAndMatch' :
                AUIGrid.resize(discountGridID, 942, 380);
                if(AUIGrid.getRowCount(discountGridID) <= 0) {
                	fn_selectMixAndMatchList();
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
	<li><a id="aTabMA" href="#"><spring:message code="sal.title.text.maillingInfo" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' || orderDetail.basicInfo.appTypeCode == 'PREREN' || orderDetail.basicInfo.appTypeCode == 'OUTPLS'}">
	<li><a  id="aTabPay" href="#"><spring:message code="sal.title.text.paymentChnnl" /></a></li>
</c:if>
	<li><a id="aTabMI" href="#" onClick="javascript:chgTab('memInfo');"><spring:message code="sal.title.text.memshipInfo" /></a></li>
	<li><a id="aTabDS" href="#" onClick="javascript:chgTab('docInfo');"><spring:message code="sal.title.text.docuSubmission" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('callLogInfo');"><spring:message code="sal.title.text.callLog" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('payInfo');"><spring:message code="sal.title.text.paymentListing" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('transInfo');"><spring:message code="sal.title.text.lastSixMonthTrnsaction" /></a></li>
	<li><a href="#"><spring:message code="sal.title.text.ordConfiguration" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('autoDebitInfo');"><spring:message code="sal.title.text.autoDebitResult" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('ecashResult');"><spring:message code="sal.title.text.ecashRslt" /></a></li>
	<li><a id="aTabGC"href="#"><spring:message code="sal.title.text.reliefCertificate" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('discountInfo');"><spring:message code="sal.title.text.discount" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('gstRebateInfo');"><spring:message code="sal.title.text.gstRebate" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('pvRebateInfo');">PV <spring:message code="sal.title.text.gstRebate" /></a></li>
	<li><a href="#" onClick="javascript:chgTab('mcoRemark');">MCO Remark</a></li>
	<li><a href="#" onClick="javascript:chgTab('fmcoEvoucher');">FMCO E-Voucher</a></li>
	<li><a href="#" onClick="javascript:chgTab('renAgr');">Rental Agreement</a></li>
	<li><a href="#" onClick="javascript:chgTab('comboRebateInfo');">Rebate 2</a></li>
	<li><a href="#" onClick="javascript:chgTab('mixAndMatch');">Mix and Match</a></li>
</ul>
<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfo.jsp" %>
<!------------------------------------------------------------------------------
    HP / Cody
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/hpCody.jsp" %>
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/custInfo.jsp" %>
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/installInfo.jsp" %>
<!------------------------------------------------------------------------------
    Mailling Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mailInfo.jsp" %>
<!------------------------------------------------------------------------------
    Payment Channel
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' || orderDetail.basicInfo.appTypeCode == 'PREREN' || orderDetail.basicInfo.appTypeCode == 'OUTPLS'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/payChannel.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Membership Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/membershipInfo.jsp" %>
<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------
    Call Log
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/callLog.jsp" %>
<!------------------------------------------------------------------------------
    Guarantee Info(2018.01.17 Remove Tab)
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Payment Listing
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/payList.jsp" %>
<!------------------------------------------------------------------------------
    Last 6 Months Transaction
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/last6Month.jsp" %>
<!------------------------------------------------------------------------------
    Order Configuration
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/orderConfig.jsp" %>
<!------------------------------------------------------------------------------
    Auto Debit Result
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/autoDebit.jsp" %>
<!------------------------------------------------------------------------------
    eCash Result
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/ecachResult.jsp" %>
<!------------------------------------------------------------------------------
    Relief Certificate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rliefCrtfcat.jsp" %>
<!------------------------------------------------------------------------------
    Discount
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/discountList.jsp" %>
<!------------------------------------------------------------------------------
    GST Rebate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/gstRebateList.jsp" %>
<!------------------------------------------------------------------------------
    PV Rebate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/pvRebateList.jsp" %>
<!------------------------------------------------------------------------------
    MCO Remark
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mcoRemark.jsp" %>
<!------------------------------------------------------------------------------
    MCO Remark
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/fmcoEvoucher.jsp" %>
<!------------------------------------------------------------------------------
    CCP Rental Agreement
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rentalAgrInfo.jsp" %>
<!------------------------------------------------------------------------------
    Rebate 2 - 18th Anniversary
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/comboRebateList.jsp" %>
<!------------------------------------------------------------------------------
    Mix and Match (Promo Group)
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mixAndMatch.jsp" %>
</section><!-- tap_wrap end -->

