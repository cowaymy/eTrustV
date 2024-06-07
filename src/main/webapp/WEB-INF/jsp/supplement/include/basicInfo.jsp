<article class="tap_area">
  <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row"><spring:message
            code="supplement.text.supplementReferenceProgressStage" /></th>
        <td colspan="5"><span>${orderInfo.supRefStg}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
        <td>${orderInfo.supRefNo}</td>
        <th scope="row"><spring:message code="supplement.text.eSOFno" /></th>
        <td>${orderInfo.sofNo}</td>
        <th scope="row"><spring:message code="supplement.text.submissionBranch" /></th>
        <td>${orderInfo.submBrch}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementReferenceStatus" /></th>
        <td>${orderInfo.supRefStus}</td>
        <!-- <th scope="row"><spring:message code="sal.text.appType" /></th>
        <td>${orderInfo.supApplTyp}</td> -->
        <th scope="row"><spring:message
            code="supplement.text.supplementTotalAmount" /></th>
        <td>${orderInfo.supTtlAmt}</td>
        <th scope="row"></th>
        <td></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.createDate" /></th>
        <td>${orderInfo.supRefDate}</td>
        <th scope="row"><spring:message
            code="supplement.text.submissionApproval" /></th>
        <td>${orderInfo.refCreateBy}</td>
        <th scope="row"><spring:message
            code="supplement.text.supplementSubmissionApprovalDate" /></th>
        <td>${orderInfo.refCreateDate}</td>
      </tr>
      <tr>
        <th scope="row" colspan="6"><span class="must">* The PV
            Year & Month is set to be 5 days after the Delivery Date.</span></th>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.title.text.pv" /></th>
        <td>${orderInfo.totPv}</td>
        <th scope="row"><spring:message code="sal.title.text.pvYear" /></th>
        <td>${orderInfo.pvYear}</td>
        <th scope="row"><spring:message code="service.title.PVMonth" /></th>
        <td>${orderInfo.pvMonth}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.parcelTrackingNo" /></th>
        <td>${orderInfo.parcelTrackNo}</td>
        <th scope="row"><spring:message code="supplement.text.supplementDeliveryStatus" /></th>
        <td>${orderInfo.supRefDelStus}</td>
        <th scope="row"><spring:message code="sys.scm.onTimeDelivery.deliveryDate" /></th>
        <td>${orderInfo.supRefDelDt}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementProductReturnConsigNo" /></th>
        <td>${orderInfo.supConsgNo}</td>
        <th></th>
        <td></td>
         <th></th>
        <td></td>
      </tr>
    </tbody>
    </br>
  </table>
</article>
