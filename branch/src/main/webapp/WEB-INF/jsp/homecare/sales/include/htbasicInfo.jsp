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
    <th scope="row">Service No</th>
    <td>${orderDetail.basicInfo.ordNo}</td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td>${fn:substring(orderDetail.basicInfo.ordDt, 0, 19)}</td>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td>${orderDetail.basicInfo.ordStusCode}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>${orderDetail.basicInfo.appTypeName}</td>
    <th scope="row"><spring:message code="sal.text.refNo" /></th>
    <td>${orderDetail.basicInfo.ordRefNo}</td>
    <th scope="row"><spring:message code="sal.title.text.keyAtBy" /></th>
    <td>${orderDetail.basicInfo.crtUserId}</td>
</tr>
<tr>
    <th scope="row">Product Size</th>
    <td>${orderDetail.basicInfo.productName}</td>
    <th scope="row"><spring:message code="sal.title.text.poNumber" /></th>
    <td>${orderDetail.basicInfo.ordPoNo}</td>
    <th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
    <td>${orderDetail.basicInfo.keyinBrnchName}</td>
</tr>
<tr>
     <th scope="row">Brand</th>
     <td>${orderDetail.basicInfo.brand}</td>
    <th scope="row">Total Amount</th>
    <td>${orderDetail.basicInfo.totAmt}</td>
        <th scope="row"><spring:message code="sal.title.text.pvMth" /></br>(<spring:message code="sal.title.text.mthYear" />)</th>
    <td>${orderDetail.basicInfo.pvMonth}/${orderDetail.basicInfo.pvYear}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.promo" /></th>
    <td colspan="3"><c:if test="${orderDetail.basicInfo.promoId > 0}">(${orderDetail.basicInfo.promoCode}) ${orderDetail.basicInfo.promoDesc}</c:if></td>
    <th scope="row"><spring:message code="sal.title.text.relatedNo" /></th>
    <td>${orderDetail.basicInfo.relatedNo}</td>
</tr>
<tr>
     <th scope="row"><spring:message code="sal.title.text.updAtBy" /></th>
    <td>${fn:substring(orderDetail.basicInfo.updDt, 0, 19)}<br>( ${orderDetail.basicInfo.updUserId})</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="5">${orderDetail.basicInfo.ordRem}</td>
</tr>


</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->