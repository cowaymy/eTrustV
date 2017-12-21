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
    <th scope="row">Progress Status</th>
    <td><span>${orderDetail.logView.prgrs}</span></td>
    <th scope="row">Agreement No</th>
    <td><span>${orderDetail.agreementView.govAgItmBatchNo}</span></td>
    <th scope="row">Agreement Expiry</th>
    <td><span>${orderDetail.agreementView.govAgEndDt}</span></td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td>${orderDetail.basicInfo.ordNo}</td>
    <th scope="row">Order Date</th>
    <td>${orderDetail.basicInfo.ordDt}</td>
    <th scope="row">Status</th>
    <td>${orderDetail.basicInfo.ordStusName}</td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td>${orderDetail.basicInfo.appTypeDesc}</td>
    <th scope="row">Reference No</th>
    <td>${orderDetail.basicInfo.ordRefNo}</td>
    <th scope="row">Key At(By)</th>
    <td>${orderDetail.basicInfo.ordCrtUserId}</td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>${orderDetail.basicInfo.stockDesc}</td>
    <th scope="row">PO Number</th>
    <td>${orderDetail.basicInfo.ordPoNo}</td>
    <th scope="row">Key-inBranch</th>
    <td>(${orderDetail.basicInfo.keyinBrnchCode} )${orderDetail.basicInfo.keyinBrnchName}</td>
</tr>
<tr>
    <th scope="row">PV</th>
    <td>${orderDetail.basicInfo.ordPv}</td>
    <th scope="row">Normal Price/RPF</th>
    <td>${orderDetail.basicInfo.norAmt}</td>
    <th scope="row">Final Price/RPF</th>
    <td>${orderDetail.basicInfo.ordAmt}</td>
</tr>
<tr>
    <th scope="row">Discount Period</th>
    <td>${orderDetail.basicInfo.pormoPeriodType}</td>
    <th scope="row">Normal<br>Rental Fees</th>
    <td>${orderDetail.basicInfo.norRntFee}</td>
    <th scope="row">Final Rental Fee</th>
    <td>${orderDetail.basicInfo.mthRentalFees}</td>
</tr>
<tr>
    <th scope="row">Installment Duration</th>
    <td>${orderDetail.basicInfo.installmentDuration}</td>
    <th scope="row">PV Month</br>(Month/Year)</th>
    <td>${orderDetail.basicInfo.ordPvMonth}/${orderDetail.basicInfo.ordPvYear}</td>
    <th scope="row">Rental Status</th>
    <td>${orderDetail.basicInfo.rentalStatus}</td>
</tr>
<tr>
    <th scope="row">Promotion</th>
    <td colspan="3"><c:if test="${orderDetail.basicInfo.ordPromoId > 0}">(${orderDetail.basicInfo.ordPromoCode}) ${orderDetail.basicInfo.ordPromoDesc}</c:if></td>
    <th scope="row">Related No</th>
    <td>${orderDetail.basicInfo.ordPromoRelatedNo}</td>
</tr>
<tr>
    <th scope="row">Serial Number</th>
    <td>${orderDetail.installationInfo.lastInstallSerialNo}</td>
    <th scope="row">Sirim Number</th>
    <td>${orderDetail.installationInfo.lastInstallSirimNo}</td>
    <th scope="row">Update At(By)</th>
    <td>${orderDetail.basicInfo.updDt}( ${orderDetail.basicInfo.updUserId})</td>
</tr>
<tr>
    <th scope="row">Obligation Period</th>
    <td colspan="5">${orderDetail.basicInfo.obligtYear}</td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">${orderDetail.basicInfo.ordRem}</td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td colspan="5">${orderDetail.ccpFeedbackCode.code}-${orderDetail.ccpFeedbackCode.resnDesc}</td>
</tr>
<tr>
    <th scope="row">CCP Remark</th>
    <td colspan="5">${orderDetail.ccpInfo.ccpRem}</td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->