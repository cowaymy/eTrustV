<article class="tap_area"><!-- tap_area start -->

<section class="divine2"><!-- divine3 start -->

<article>
<h3><spring:message code="sal.title.text.salesmanInfo" /></h3>

<input id="salesmanMemTypeID" name="salesmanMemTypeID" type="hidden" value="${orderDetail.salesmanInfo.memType}">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row"><spring:message code="sal.title.text.ordMadeBy" /></th>
    <td><span class="txt_box">${orderDetail.salesmanInfo.orgCode} (<spring:message code="sal.title.text.orgCode" />)<i>(${orderDetail.salesmanInfo.memCode1}) ${orderDetail.salesmanInfo.name1} - ${orderDetail.salesmanInfo.telMobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.salesmanInfo.grpCode} (<spring:message code="sal.text.GroupCode" />)<i>(${orderDetail.salesmanInfo.memCode2}) ${orderDetail.salesmanInfo.name2} - ${orderDetail.salesmanInfo.telMobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.salesmanInfo.deptCode} (<spring:message code="sal.title.text.deptCode" />)<i>(${orderDetail.salesmanInfo.memCode3}) ${orderDetail.salesmanInfo.name3} - ${orderDetail.salesmanInfo.telMobile3}</i></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.salManCode" /></th>
    <td><span>${orderDetail.salesmanInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.salManName" /></th>
    <td><span>${orderDetail.salesmanInfo.name}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.salesmanNric" /></th>
    <td><span>${orderDetail.salesmanInfo.nric}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.mobileNo" /></th>
    <td><span>${orderDetail.salesmanInfo.telMobile}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.officeNo" /></th>
    <td><span>${orderDetail.salesmanInfo.telOffice}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.houseNo" /></th>
    <td><span>${orderDetail.salesmanInfo.telHuse}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

<article>
<h3><spring:message code="sal.title.text.codyInfo" /></h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row"><spring:message code="sal.title.text.svcBy" /></th>
    <td><span class="txt_box">${orderDetail.codyInfo.orgCode} (<spring:message code="sal.title.text.orgCode" />)<i>(${orderDetail.codyInfo.memCode1}) ${orderDetail.codyInfo.name1} - ${orderDetail.codyInfo.telMobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.codyInfo.grpCode} (<spring:message code="sal.text.GroupCode" />)<i>(${orderDetail.codyInfo.memCode2}) ${orderDetail.codyInfo.name2} - ${orderDetail.codyInfo.telMobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.codyInfo.deptCode} (<spring:message code="sal.title.text.deptCode" />)<i>(${orderDetail.codyInfo.memCode3}) ${orderDetail.codyInfo.name3} - ${orderDetail.codyInfo.telMobile3}</i></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.codyCode" /></th>
    <td><span>${orderDetail.codyInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.codyNm" /></th>
    <td><span>${orderDetail.codyInfo.name}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.codyNric" /></th>
    <td><span>${orderDetail.codyInfo.nric}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.mobileNo" /></th>
    <td><span>${orderDetail.codyInfo.telMobile}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.officeNo" /></th>
    <td><span>${orderDetail.codyInfo.telOffice}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.houseNo" /></th>
    <td><span>${orderDetail.codyInfo.telHuse}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

</section><!-- divine2 start -->


</article><!-- tap_area end -->