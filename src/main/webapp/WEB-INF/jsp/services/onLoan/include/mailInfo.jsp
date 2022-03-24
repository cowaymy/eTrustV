<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
    <td colspan="3"><span>${orderDetail.mailingInfo.addrDtl}</span></td>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
    <td><span>${orderDetail.mailingInfo.mailPostCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /></th>
    <td colspan="3"><span>${orderDetail.mailingInfo.street}</span></td>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span>${orderDetail.mailingInfo.mailCity}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /></th>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailArea}</span></td>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td><span>${orderDetail.mailingInfo.mailState}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.billingGroup" /></th>
    <td><span>${orderDetail.mailingInfo.billGrpNo}</span></td>
    <th scope="row"><spring:message code="sal.text.billingType" /></th>
    <td>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billSms != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box"><spring:message code="sal.text.sms" /><i>${orderDetail.mailingInfo.mailCntTelM}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span><spring:message code="sal.text.sms" /></span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billPost != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box"><spring:message code="sal.text.post" /><i>${orderDetail.mailingInfo.fullAddress}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span><spring:message code="sal.text.post" /></span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billState != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box"><spring:message code="sal.text.eStatement" /><i>${orderDetail.mailingInfo.billStateEmail}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span><spring:message code="sal.text.eStatement" /></span>
    </c:otherwise>
  </c:choose>
     </label>
    </td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td><span>${orderDetail.mailingInfo.mailCnty}</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactName" /></th>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailCntName}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntGender}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactNRIC" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntNric}</span></td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntEmail}</span></td>
    <th scope="row"><spring:message code="sal.text.faxNo" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntTelF}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.mobileNo" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntTelM}</span></td>
    <th scope="row"><spring:message code="sal.text.officeNo" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntTelO}</span></td>
    <th scope="row"><spring:message code="sal.title.text.houseNo" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntTelR}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntPost}</span></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><span>${orderDetail.mailingInfo.mailCntDept}</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->