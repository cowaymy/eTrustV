<article class="tap_area"><!-- tap_area start -->

<h3>Salesman Info</h3>

<input id="salesmanMemTypeID" name="salesmanMemTypeID" type="hidden" value="${salesMan.memType}">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row"><spring:message code="sal.title.text.ordMadeBy" /></th>
    <td><span class="txt_box">${salesMan.orgCode} (<spring:message code="sal.title.text.orgCode" />)<i>(${salesMan.memcode1}) ${salesMan.name1} - ${salesMan.telmobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${salesMan.grpCode} (<spring:message code="sal.text.GroupCode" />)<i>(${salesMan.memcode2}) ${salesMan.name2} - ${salesMan.telmobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${salesMan.deptCode} (<spring:message code="sal.title.text.deptCode" />)<i>(${salesMan.memcode3}) ${salesMan.name3} - ${salesMan.telmobile3}</i></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.salManCode" /></th>
    <td><span>${salesMan.memCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.salManName" /></th>
    <td><span>${salesMan.name}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.salesmanNric" /></th>
    <td><span>${salesMan.nric}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.mobileNo" /></th>
    <td><span>${salesMan.telMobile}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.officeNo" /></th>
    <td><span>${salesMan.telOffice}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.houseNo" /></th>
    <td><span>${salesMan.telHuse}</span></td>
</tr>
</tbody>
</table><!-- table end -->


</article><!-- tap_area end -->