<article class="tap_area"><!-- tap_area start -->

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
    <td><span>${orderDetail.basicInfo.ordNo} </span>
       <c:if test="${orderDetail.basicInfo.custNric == orderDetail.salesmanInfo.nric}">(${orderDetail.salesmanInfo.memCode})</c:if>
   <!--<c:if test="${(orderDetail.basicInfo.pckageBindingId.length() > 0 || empty orderDetail.basicInfo.pckageBindingId) && orderDetail.basicInfo.ordCtgryCd == 'ACI' && orderDetail.basicInfo.isAciCombo == 'TRUE'}">
          <a id="btnViewAirConCboOrdNo" style="float:right; margin-right: 75px;"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
       </c:if>  -->
    </td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td>${fn:substring(orderDetail.basicInfo.ordDt, 0, 19)}</td>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td>${orderDetail.basicInfo.ordStusName}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.evoucher" /></th>
    <td>${orderDetail.basicInfo.voucher}</td>
    <th scope="row"><spring:message code="sal.text.evoucher.hs"/></th>
    <td>
        <c:choose>
	        <c:when test="${orderDetail.basicInfo.redeemHs > 0}">
	            <input type="checkbox" onClick="return false" checked/>
	            <c:if test="${orderDetail.basicInfo.redeemMth > 0 && orderDetail.basicInfo.redeemYear > 0}">
	                   <span>&nbsp;(${orderDetail.basicInfo.redeemMth}-${orderDetail.basicInfo.redeemYear})</span>
	            </c:if>
	        </c:when>
		    <c:otherwise>
		       <input type="checkbox" disabled/>
		    </c:otherwise>
		</c:choose>
    </td>
    <th scope="row"><spring:message code="sal.text.evoucher.ext.warr"/></th>
    <td>
        <c:choose>
	        <c:when test="${orderDetail.basicInfo.redeemWarranty > 0}">
	               <input type="checkbox" onClick="return false" checked/>
	        </c:when>
	        <c:otherwise>
               <input type="checkbox" disabled/>
            </c:otherwise>
	    </c:choose>
    </td>
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
    <th scope="row"><spring:message code="sal.title.text.relatedNo" /></th>
    <td>${orderDetail.basicInfo.ordPromoRelatedNo}</td>
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
	<th></th><td></td>
	<th scope="row"><spring:message code="sal.title.text.pv" /></th>
    <td>${orderDetail.basicInfo.ordPv}</td>
    <th scope="row"><spring:message code="sal.title.text.finalPv" /></th>
    <td>${orderDetail.basicInfo.ordPvFinal}</td>
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
    <th></th><td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.eligiAdvDisc" /></th>
    <td colspan="1">
        <c:if test="${orderDetail.basicInfo.advDisc == 1}">Yes</c:if>
        <c:if test="${orderDetail.basicInfo.advDisc == 0}">No</c:if>
    </td>
    <th scope="row">Key-In Month</th>
    <td colspan="1">${orderDetail.basicInfo.keyInMonth}</td>
    <th scope="row">Product Return</th>
    <td colspan="1">
        <c:if test="${orderDetail.basicInfo.exTradePr == 1}">Yes</c:if>
        <c:if test="${orderDetail.basicInfo.exTradePr == null}"></c:if>
        <c:if test="${orderDetail.basicInfo.exTradePr == 0}">No</c:if>
    </td>
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
    <td colspan="1">${orderDetail.basicInfo.obligtYear}</td>
    <th scope="row"><spring:message code="sal.text.AddCmpt" /></th>
    <td colspan="1">${orderDetail.basicInfo.addCmpt}</td>
    <th scope="row"><spring:message code="sal.title.text.cboBindOrdNo" /></th>
    <td colspan="1"><p class="w100p">

     <c:choose>
      <c:when test="${orderDetail.basicInfo.pckageBindingId.length() > 0 }">
       <span style="float:left">${orderDetail.basicInfo.pckageBindingId}</span>
       <!-- <span style="float:right" onclick='if ("${orderDetail.basicInfo.pckageBindingId}" != "") { Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : ${orderDetail.basicInfo.pckageBindingNo} }, null, true, "_divIdOrdDt2"); } '>
        <img id="cboTagComboOrdNo" name="cboTagComboOrdNo" src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search"/>
       </span> -->
      </c:when>
      <c:otherwise>
       <span></span>
      </c:otherwise>
    </c:choose>
    </p></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ekeyCrtUser" /></th>
    <td colspan="1">${orderDetail.basicInfo.ekeyCrtUser}</td>
    <th scope="row"><spring:message code="sal.text.ekeyBrnchName" /></th>
    <td colspan="1">${orderDetail.basicInfo.ekeyBrnchName}</td>
    <th scope="row"><spring:message code="sal.text.voucherCode" /></th>
    <c:if test="${orderDetail.basicInfo.voucherCode != null}">
		<td colspan="1">${orderDetail.basicInfo.voucherCode}</td>
    </c:if>
    <c:if test="${orderDetail.basicInfo.voucherCode == null}">
		<td colspan="1"></td>
    </c:if>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3">${orderDetail.basicInfo.ordRem}</td>
    <th scope="row">Pre-Booking Period</th>
    <td>${orderDetail.basicInfo.prebookingPeriod}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ccpFeedbackCode" /></th>
    <td colspan="5">${orderDetail.ccpFeedbackCode.code}-${orderDetail.ccpFeedbackCode.resnDesc}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ccpRem" /></th>
    <td colspan="5">${orderDetail.ccpInfo.ccpRem}</td>
</tr>
<tr>
    <th scope="row">SST Type</th>
    <td colspan="1">${orderDetail.basicInfo.corpCustType}</td>
    <th scope="row">Agreement Type</th>
    <td colspan="1">${orderDetail.basicInfo.agreementType}</td>
    <th scope="row">Product Usage Month</th>
    <td colspan="1">${orderDetail.prodUsgMthInfo.productUsageMonth}</td>
</tr>
<tr>
    <th scope="row">PWP Binding No</th>
    <td colspan="1">${orderDetail.basicInfo.mainPwpOrdNo}</td>
    <th scope="row">Ele. Acc. No.</th>
    <td colspan="1">${orderDetail.basicInfo.tnbAccNo}</td>
    <th scope="row">Rebate Binding No</th>
    <td colspan="1">${orderDetail.basicInfo.mainRebateOrdNo}</td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->