<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//TODO 미개발
    // popup 크기
    var option = {
            winName : "popup",
            width : "950px",   // 창 가로 크기
            height : "700px",    // 창 세로 크기
            resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
            scrollbars : "yes" // 스크롤바. (yes/no)(default : yes)
    };
    
function fn_goLedger1(){
    Common.popupWin('legderParam', "/sales/order/orderLedgerViewPop.do", option);
}
function fn_goLedger2(){
    Common.popupWin('legderParam', "/sales/order/orderLedger2ViewPop.do", option);
}
</script>
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns mb10">
        <li><p class="btn_blue2"><a href="#" onclick="javascript : fn_goLedger1()">View Ledger (1)</a></p></li>
        <li><p class="btn_blue2"><a href="#" onclick="javascript : fn_goLedger2()">View Ledger (2)</a></p></li>
</ul>
<form id="legderParam" name="legderParam" method="POST">
    <input type="hidden" id="ordId" name="ordId" value="${orderDetail.basicInfo.ordId }">
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.prgssStus" /></th>
    <td><span>${orderDetail.logView.prgrs}</span></td>
    <th scope="row"><spring:message code="sal.title.text.agrNo" /></th>
    <td><span>${orderDetail.agreementView.govAgItmBatchNo}</span></td>
    <th scope="row"><spring:message code="sal.title.text.agrExpiry" /></th>
    <td><span>${orderDetail.agreementView.govAgEndDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>${orderDetail.basicInfo.ordNo}</td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td>${fn:substring(orderDetail.basicInfo.ordDt, 0, 19)}</td>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td>${orderDetail.basicInfo.ordStusName}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>${orderDetail.basicInfo.appTypeDesc}</td>
    <th scope="row"><spring:message code="sal.text.refNo" /></th>
    <td>${orderDetail.basicInfo.ordRefNo}</td>
    <th scope="row"><spring:message code="sal.title.text.keyAtBy" /></th>
    <td>${orderDetail.basicInfo.ordCrtUserId}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.product" /></th>
    <td>${orderDetail.basicInfo.stockDesc}</td>
    <th scope="row"><spring:message code="sal.title.text.poNumber" /></th>
    <td>${orderDetail.basicInfo.ordPoNo}</td>
    <th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
    <td>(${orderDetail.basicInfo.keyinBrnchCode} )${orderDetail.basicInfo.keyinBrnchName}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.pv" /></th>
    <td>${orderDetail.basicInfo.ordPv}</td>
    <th scope="row"><spring:message code="sal.title.text.normalPrcRpf" /></th>
    <td>${orderDetail.basicInfo.norAmt}</td>
    <th scope="row"><spring:message code="sal.title.text.finalPrcRpf" /></th>
    <td>${orderDetail.basicInfo.ordAmt}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.promo.discPeriod" /></th>
    <td>${orderDetail.basicInfo.pormoPeriodType}</td>
    <th scope="row"><spring:message code="sal.title.text.normalRentalFees" /></th>
    <td>${orderDetail.basicInfo.norRntFee}</td>
    <th scope="row"><spring:message code="sal.title.text.finalRentalFees" /></th>
    <td>${orderDetail.basicInfo.mthRentalFees}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.instDuration" /></th>
    <td>${orderDetail.basicInfo.installmentDuration}</td>
    <th scope="row"><spring:message code="sal.title.text.pvMth" /></br>(<spring:message code="sal.title.text.mthYear" />)</th>
    <td>${orderDetail.basicInfo.ordPvMonth}/${orderDetail.basicInfo.ordPvYear}</td>
    <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
    <td>${orderDetail.basicInfo.rentalStatus}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.promo" /></th>
    <td colspan="3"><c:if test="${orderDetail.basicInfo.ordPromoId > 0}">(${orderDetail.basicInfo.ordPromoCode}) ${orderDetail.basicInfo.ordPromoDesc}</c:if></td>
    <th scope="row"><spring:message code="sal.title.text.relatedNo" /></th>
    <td>${orderDetail.basicInfo.ordPromoRelatedNo}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.SeriacNo" /></th>
    <td>${orderDetail.installationInfo.lastInstallSerialNo}</td>
    <th scope="row"><spring:message code="sales.SirimNo" /></th>
    <td>${orderDetail.installationInfo.lastInstallSirimNo}</td>
    <th scope="row"><spring:message code="sal.title.text.updAtBy" /></th>
    <td>${fn:substring(orderDetail.basicInfo.updDt, 0, 19)}<br>( ${orderDetail.basicInfo.updUserId})</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.obligationPeriod" /></th>
    <td colspan="5">${orderDetail.basicInfo.obligtYear}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="5">${orderDetail.basicInfo.ordRem}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ccpFeedbackCode" /></th>
    <td colspan="5">${orderDetail.ccpFeedbackCode.code}-${orderDetail.ccpFeedbackCode.resnDesc}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ccpRem" /></th>
    <td colspan="5">${orderDetail.ccpInfo.ccpRem}</td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->