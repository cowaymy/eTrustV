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
    <th rowspan="3" scope="row">Mailing Address</th>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailAdd1}</span></td>
    <th scope="row">Country</th>
    <td><span>${orderDetail.mailingInfo.mailCnty}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailAdd2}</span></td>
    <th scope="row">State</th>
    <td><span>${orderDetail.mailingInfo.mailState}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailAdd3}</span></td>
    <th scope="row">Area</th>
    <td><span>${orderDetail.mailingInfo.mailArea}</span></td>
</tr>
<tr>
    <th scope="row">Billing Group</th>
    <td><span>${orderDetail.mailingInfo.billGrpNo}</span></td>
    <th scope="row">Billing Type</th>
    <td>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billSms != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">SMS<i>${orderDetail.mailingInfo.mailCntTelM}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>SMS</span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billPost != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">Post<i>${orderDetail.mailingInfo.fullAddress}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>Post</span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billState != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">E-statement><i>${orderDetail.mailingInfo.billStateEmail}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>E-statement</span>
    </c:otherwise>
  </c:choose>
     </label>
    </td>
    <th scope="row">Postcode</th>
    <td><span>${orderDetail.mailingInfo.mailPostCode}</span></td>
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
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailCntName}</span></td>
    <th scope="row">Gender</th>
    <td><span>${orderDetail.mailingInfo.mailCntGender}</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>${orderDetail.mailingInfo.mailCntNric}</span></td>
    <th scope="row">Email</th>
    <td><span>${orderDetail.mailingInfo.mailCntEmail}</span></td>
    <th scope="row">Fax No</th>
    <td><span>${orderDetail.mailingInfo.mailCntTelF}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${orderDetail.mailingInfo.mailCntTelM}</span></td>
    <th scope="row">Office No</th>
    <td><span>${orderDetail.mailingInfo.mailCntTelO}</span></td>
    <th scope="row">House No</th>
    <td><span>${orderDetail.mailingInfo.mailCntTelR}</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>${orderDetail.mailingInfo.mailCntPost}</span></td>
    <th scope="row">Departiment</th>
    <td><span>${orderDetail.mailingInfo.mailCntDept}</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->