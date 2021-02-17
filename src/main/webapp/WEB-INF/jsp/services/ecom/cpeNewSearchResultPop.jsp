<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 0,
            showStateColumn     : true,
            displayTreeOpen     : false,
   //         selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

    $(document).ready(function() {

        //Reselect(Whole)
        $("#_reSelect").click(function() {
            //self.location.href = getContextPath()+"/sales/ccp/insertCcpAgreementSearch.do";
            $("#_cpeResultPopCloseBtn").click();
        });

        //Submit
        $("#_submitBtn").click(function() {
        	if (fn_checkApprovalRequired()) {
        	    fn_cpeReqstApproveLinePop();
        	}
        });

        doGetCombo("/services/ecom/selectRequestTypeJsonList", '', '', '_inputReqTypeSelect', 'S', '');

        $("#_inputReqTypeSelect").change(
                function() {
                  if ($("#_inputReqTypeSelect").val() == '') {
                    $("#_inputSubReqTypeSelect").val('');
                    $("#_inputSubReqTypeSelect").find("option").remove();
                  } else {
                    doGetCombo('/services/ecom/selectSubRequestTypeJsonList', $("#_inputReqTypeSelect").val(), '', '_inputSubReqTypeSelect', 'S', '');
                  }
              });

        fn_setKeyInDate();

        $("#_inputMainDeptSelect").change(function(){

            doGetCombo('/services/ecom/selectSubDept.do',  $("#_inputMainDeptSelect").val(), '','_inputSubDeptSelect', 'S' ,  '');

        });

    });//Doc Ready End

    ////////////////////////////////////////////////////////////////////////////////////

    function chgGridTab(tabNm) {
        switch(tabNm) {
            case 'custInfo' :
                AUIGrid.resize(custInfoGridID, 920, 300);
                break;
            case 'memInfo' :
                AUIGrid.resize(memInfoGridID, 920, 300);
                break;
            case 'docInfo' :
                AUIGrid.resize(docGridID, 920, 300);
                if(AUIGrid.getRowCount(docGridID) <= 0) {
                    fn_selectDocumentList();
                }
                break;
            case 'callLogInfo' :
                AUIGrid.resize(callLogGridID, 920, 300);
                if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                    fn_selectCallLogList();
                }
                break;
            case 'payInfo' :
                AUIGrid.resize(payGridID, 920, 300);
                if(AUIGrid.getRowCount(payGridID) <= 0) {
                    fn_selectPaymentList();
                }
                break;
            case 'transInfo' :
                AUIGrid.resize(transGridID, 920, 300);
                if(AUIGrid.getRowCount(transGridID) <= 0) {
                    fn_selectTransList();
                }
                break;
            case 'autoDebitInfo' :
                AUIGrid.resize(autoDebitGridID, 920, 300);
                if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                    fn_selectAutoDebitList();
                }
                break;
            case 'discountInfo' :
                AUIGrid.resize(discountGridID, 920, 300);
                if(AUIGrid.getRowCount(discountGridID) <= 0) {
                    fn_selectDiscountList();
                }
                break;
        };
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //Save Validation
    function fn_saveValidation(){

        //리마크 널체크
        if('' == $("#_agreementAgmRemark").val() || null == $("#_agreementAgmRemark").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyInTheRem" />');
            return false;
        }
        return true;
    }

    function fn_setKeyInDate() {
        var today = new Date();

        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();

        if(dd < 10) {
            dd = "0" + dd;
        }
        if(mm < 10){
            mm = "0" + mm
        }

        today = dd + "/" + mm + "/" + yyyy;
        $("#_inputRequestDate").val(today);
    }

    function fn_cpeReqstApproveLinePop() {
//        var checkResult = fn_checkEmpty2();

//        if(!checkResult){
//            return false;
//        }

        // tempSave를 하지 않고 바로 submit인 경우
//        if(FormUtil.isEmpty($("#clmNo").val())) {
            fn_saveNewCpeRequest();
//        } else {
            // 바로 submit 후에 appvLinePop을 닫고 재수정 대비
//            fn_saveUpdateRequest("");
//        }
        var cpeReqstNo =  $("#_cpeReqNo").val();
        Common.popupDiv("/services/ecom/cpeReqstApproveLinePop.do", {cpeReqNo:cpeReqstNo}, null, true, "cpeReqstApproveLinePop");
    }

    function fn_checkApprovalRequired() {
    	var reqSubType = $("#_inputSubReqTypeSelect").val();
    	if(reqSubType == "6212" || reqSubType == "6213") { // 6212 - Change Promotion Code, 6213 - Request Product Exchange
    		return true;
    	}
    	return false;
    }

    function fn_saveNewCpeRequest() {
        Common.ajax("POST", "/services/ecom/insertCpeReqst.do", $("#form_newReqst").serializeJSON(), function(result) {
            console.log(result);
            $("#_cpeReqNo").val(result.data.cpeReqNo);
        });
    }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.cpeNewSrch" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_cpeResultPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="_newOrderAddForm">
    <input id="_addOrdId" name="addOrdId" type="hidden" >
</form>

<form action="#" method="get" id="_searchForm">
<input id="salesOrderId" name="salesOrderId" type="hidden" value="${orderDetail.basicInfo.ordId}">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr id="_resultTr" >
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><input type="text" title="" placeholder="" class=""  value="${salesOrderNo}" readonly="readonly"/><p class="btn_sky"><a href="#" id="_reSelect"><spring:message code="sal.btn.reselect" /></a></p></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result" id="_searchResultSection" ><!-- search_result start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.ordInfo" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start --><!--###################################  -->

<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.hpCody" /></a></li>
    <li><a id="aTabCI" href="#" onClick="javascript:chgGridTab('custInfo');"><spring:message code="sal.title.text.custInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.installInfo" /></a></li>
    <li><a id="aTabMA" href="#"><spring:message code="sal.title.text.maillingInfo" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#"><spring:message code="sal.title.text.paymentChnnl" /></a></li>
</c:if>
    <li><a id="aTabMI" href="#" onClick="javascript:chgGridTab('memInfo');"><spring:message code="sal.title.text.memshipInfo" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('docInfo');"><spring:message code="sal.title.text.docuSubmission" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('callLogInfo');"><spring:message code="sal.title.text.callLog" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
    <li><a href="#"><spring:message code="sal.title.text.quaranteeInfo" /></a></li>
</c:if>
    <li><a href="#" onClick="javascript:chgGridTab('payInfo');"><spring:message code="sal.title.text.paymentListing" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('transInfo');"><spring:message code="sal.title.text.lastSixMonthTrnsaction" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.ordConfiguration" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('autoDebitInfo');"><spring:message code="sal.title.text.autoDebitResult" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.reliefCertificate" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('discountInfo');"><spring:message code="sal.title.text.discount" /></a></li>
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
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
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
    Quarantee Info
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/qrntInfo.jsp" %>
</c:if>
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
    Relief Certificate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rliefCrtfcat.jsp" %>
<!------------------------------------------------------------------------------
    Discount
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/discountList.jsp" %>

</section><!-- tap_wrap end -->

</article><!-- tap_area end --><!--###################################  -->

</section><!-- tap_wrap end -->


<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="cpe.title.helpdeskRequest" /></h3>
</aside><!-- title_line end -->
<form id="form_newReqst">
<input type="hidden" name="salesOrdId" id="_salesOrdId" value="${orderDetail.basicInfo.ordId}" />
<input type="hidden" name="reqStageId" id="_reqStageId" value="${orderDetail.basicInfo.ordStusId}" />
<input type="hidden" name="salesOrdNo" id="_salesOrdNo" value="${orderDetail.basicInfo.ordNo}" />
<input type="hidden" name="custId" id="_custId" value="${orderDetail.basicInfo.custId}" />
<input type="hidden" name="cpeReqNo" id="_cpeReqNo"' />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:260px" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.requestDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create Request Date" placeholder="DD/MM/YYYY" class="j_date"  name="inputRequestDate" id="_inputRequestDate" readonly="readonly"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="service.grid.mainDept" /><span class="must">*</span></th>
    <td colspan="3">
        <select class="w100p" name="inputMainDeptSelect" id="_inputMainDeptSelect">
            <option value="">Choose One</option>
            <c:forEach var="list" items="${mainDeptList}" varStatus="status">
                <option value="${list.codeId}">${list.codeName} </option>
            </c:forEach>
        </select></td>
</tr>
<tr>
    <th scope="row"><spring:message code="log.label.rqstTyp" /><span class="must">*</span></th>
    <td><select class="w100p" name="inputReqTypeSelect" id="_inputReqTypeSelect"></select></td>
    <th scope="row"><spring:message code="service.grid.subDept" /><span class="must">*</span></th>
    <td colspan="3"><select class="w100p" name="inputSubDeptSelect" id="_inputSubDeptSelect"></select></td>
</tr>
<tr>
    <th scope="row">Sub Request<span class="must">*</span></th>
    <td><select class="w100p" name="inputSubReqTypeSelect" id="_inputSubReqTypeSelect"></select></td>
    <th scope="row">AS No.</th>
    <td colspan="3"><input type="text" title="" placeholder="<spring:message code='service.grid.ASNo'/>"
        class="w100p" id="asNum" name="asNum" /></td>
</tr>
<tr>
    <th scope="row">Issue<span class="must">*</span></th>
    <td colspan="5"><select class="w100p" name="inputIssueSelect" id="_inputIssueSelect">
    <!-- TODO: DROP DOWN VALUES SHOULD BE BASED ON SUB REQUEST TYPE? TO BE CONFIGURED in CODE MGMT -->
        <option value="1">Entered wrong data</option>
        <option value="2">Customer provided wrong info</option>
        <option value="3">Others</option>
    </select></td>
</tr>
<tr>
    <th scope="row">Remark<span class="must">*</span></th>
    <td colspan="5"><textarea cols="20" rows="5" name="cpeRemark" id="_cpeRemark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_submitBtn"><spring:message code="sal.btn.submit" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_clearBtn"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</form>
</section><!-- search_result end -->

</section><!-- content end -->

</div>