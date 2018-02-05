<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.instAddrDtl}</span></td>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
    <td><span>${orderDetail.installationInfo.instPostcode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.instStreet}</span></td>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span>${orderDetail.installationInfo.instCity}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.instArea}</span></td>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td><span>${orderDetail.installationInfo.instState}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.perferInstDate" /></th>
    <td><span>${orderDetail.installationInfo.preferInstDt}</span></td>
    <th scope="row"><spring:message code="sal.title.text.perferInstTime" /></th>
    <td><span>${orderDetail.installationInfo.preferInstTm}</span></td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td><span>${orderDetail.installationInfo.instCountry}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.instruct" /></th>
    <td colspan="5"><span>${orderDetail.installationInfo.instct}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.dscVerifiRem" /></th>
    <td colspan="5"><span>${orderDetail.installationInfo.vrifyRem}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
    <td colspan="3"><span>(${orderDetail.installationInfo.dscCode} )${orderDetail.installationInfo.dscName}</span></td>
    <th scope="row"><spring:message code="sal.text.instDt" /></th>
    <td><span>${orderDetail.installationInfo.firstInstallDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ctCd" /></th>
    <td><span>${orderDetail.installationInfo.lastInstallCtCode}</span></td>
    <th scope="row"><spring:message code="sal.text.ctNm" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.lastInstallCtName}</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactName" /></th>
    <td colspan="3"><span>${orderDetail.installationInfo.instCntName}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${orderDetail.installationInfo.instCntGender}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactNRIC" /></th>
    <td><span>${orderDetail.installationInfo.instCntNric}</span></td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><span>${orderDetail.installationInfo.instCntEmail}</span></td>
    <th scope="row"><spring:message code="sal.text.faxNo" /></th>
    <td><span>${orderDetail.installationInfo.instCntTelF}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.mobileNo" /></th>
    <td><span>${orderDetail.installationInfo.instCntTelM}</span></td>
    <th scope="row"><spring:message code="sal.text.officeNo" /></th>
    <td><span>${orderDetail.installationInfo.instCntTelO}</span></td>
    <th scope="row"><spring:message code="sal.title.text.houseNo" /></th>
    <td><span>${orderDetail.installationInfo.instCntTelR}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><span>${orderDetail.installationInfo.instCntPost}</span></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><span>${orderDetail.installationInfo.instCntDept}</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->