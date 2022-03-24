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
    <th scope="row"><spring:message code="service.grid.LoanNo" /></th>
    <td>${orderDetail.basicInfo.loanOrdNo}  <c:if test="${orderDetail.basicInfo.custNric == orderDetail.salesmanInfo.nric}">(${orderDetail.salesmanInfo.memCode})</c:if></td>
    <th scope="row"><spring:message code="service.grid.LoanDate" /></th>
    <td>${fn:substring(orderDetail.basicInfo.loanDt, 0, 19)}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td>${orderDetail.basicInfo.ordStusName}</td>
    <th scope="row"><spring:message code="sal.text.refNo" /></th>
    <td>${orderDetail.basicInfo.refNo}</td>
    <th scope="row"><spring:message code="sal.title.text.keyAtBy" /></th>
    <td>${orderDetail.basicInfo.crtUserName}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.product" /></th>
    <td>(${orderDetail.basicInfo.productCode}) ${orderDetail.basicInfo.productName}</td>
    <th scope="row"><spring:message code="sal.title.text.poNumber" /></th>
    <td>${orderDetail.basicInfo.custPoNo}</td>
    <th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
    <td>(${orderDetail.basicInfo.keyinBrnchCode} )${orderDetail.basicInfo.keyinBrnchName}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.SeriacNo" /></th>
    <td>${orderDetail.installationInfo.lastInstallSerialNo}</td>
    <th scope="row"><spring:message code="sales.SirimNo" /></th>
    <td>${orderDetail.installationInfo.lastInstallSirimNo}</td>
    <th scope="row"><spring:message code="sal.title.text.updAtBy" /></th>
    <td>${fn:substring(orderDetail.basicInfo.updDt, 0, 19)}<br>(${orderDetail.basicInfo.updUserName})</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3">${orderDetail.basicInfo.rem}</td>
    <th scope="row"><spring:message code="service.grid.loan.relatedOrdNo" /></th>
    <td>${orderDetail.basicInfo.relateOrdNo}</td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->