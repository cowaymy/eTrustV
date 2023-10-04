<article class="tap_area">
 <!-- tap_area start -->
 <table class="type1">
  <!-- table start -->
  <caption>table</caption>
  <colgroup>
   <col style="width: 150px" />
   <col style="width: *" />
   <col style="width: 140px" />
   <col style="width: *" />
   <col style="width: 150px" />
   <col style="width: *" />
  </colgroup>
  <tbody>
   <tr>
    <th scope="row"><spring:message code="sal.text.rentalPaymode" /></th>
    <td><span>${orderDetail.rentPaySetInf.rentPayModeDesc}</span></td>
    <th scope="row"><spring:message code="sal.text.ddMode" /></th>
    <td><span>${orderDetail.rentPaySetInf.clmDdMode}</span></td>
    <th scope="row"><spring:message code="sal.text.autoDebitMode" /></th>
    <td><span>${orderDetail.rentPaySetInf.clmLimit}</span></td>
   </tr>
   <tr>
    <th scope="row"><spring:message code="sal.text.ddcChnl" /></th>
    <td><span>${orderDetail.rentPaySetInf.ddtChnl}</span></span></td>
    <th scope="row"><spring:message code="sal.text.issueBank" /></th>
    <td><span>${orderDetail.rentPaySetInf.rentPayIssBank}</span></span></td>
    <th scope="row"><spring:message code="sal.text.cardType" /></th>
    <td><span>${orderDetail.rentPaySetInf.cardType} (${orderDetail.rentPaySetInf.visaType})</span></td>
   </tr>
   <tr>
    <th scope="row"><spring:message code="sal.text.claimBillDt" /></th>
    <td><span></span></td>
    <th scope="row"><spring:message code="sal.text.creditCardNo" /></th>
    <td><span>
        <choose>
        <when test="${orderDetail.rentPaySetInf.payModeId == 135}">
            ${orderDetail.rentPaySetInf.pnprpsCrcNo}
        </when>
        <otherwise>
            ${orderDetail.rentPaySetInf.rentPayCrcNo}
        </otherwise>
        </choose>
    </span></td>
    <th scope="row"><spring:message code="sal.text.nameOnCard" /></th>
    <td><span>${orderDetail.rentPaySetInf.rentPayCrOwner}</span></td>
   </tr>
   <tr>
    <th scope="row"><spring:message code="sal.text.expiryDate" /></th>
    <td><span>${orderDetail.rentPaySetInf.rentPayCrcExpr}</span></td>
    <th scope="row"><spring:message code="sal.text.bankAccNo" /></th>
    <td><span>${orderDetail.rentPaySetInf.rentPayAccNo}</span></td>
    <th scope="row"><spring:message code="sal.text.accName" /></th>
    <td><span>${orderDetail.rentPaySetInf.rentPayAccOwner}</span></td>
   </tr>
   <tr>
    <th scope="row">Issure NRIC</th>
    <td><span>${orderDetail.rentPaySetInf.issuNric}</span></td>
    <th scope="row">Apply Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayApplyDt}</span></td>
    <th scope="row">Submit Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPaySubmitDt}</span></td>
   </tr>
   <tr>
    <th scope="row">Start Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayStartDt}</span></td>
    <th scope="row">Reject Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayRejctDt}</span></td>
    <th scope="row">Reject Code</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayRejct}</span></td>
   </tr>
   <tr>
    <th scope="row">Payment Term</th>
    <td colspan="5"><span>${orderDetail.rentPaySetInf.payTrm}
      month(s)</span></td>
   </tr>
   <tr>
    <th scope="row">Pay By Third Party</th>
    <td><span>${orderDetail.rentPaySetInf.is3party}</span></td>
    <th scope="row">Third Party ID</th>
    <td><span>${orderDetail.thirdPartyInfo.customerid}</span></td>
    <th scope="row">Third Party Type</th>
    <td><span>${orderDetail.thirdPartyInfo.c7}</span></td>
   </tr>
   <tr>
    <th scope="row">Third Party Name</th>
    <td colspan="3"><span>${orderDetail.thirdPartyInfo.name}</span></td>
    <th scope="row">Third Party NRIC</th>
    <td><span>${orderDetail.thirdPartyInfo.nric}</span></td>
   </tr>
    <tr>
    <th scope="row">PAD Number</th>
    <td colspan="3"><span>${orderDetail.mobileAutoDebitPaymentInfo.padNo}</span></td>
    <th scope="row">Last Updated At (By)</th>
    <td><span></span>${orderDetail.mobileAutoDebitPaymentInfo.updator}</td>
   </tr>
  </tbody>
 </table>
 <!-- table end -->
</article>
<!-- tap_area end -->
