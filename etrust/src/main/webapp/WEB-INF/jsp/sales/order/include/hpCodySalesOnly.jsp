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
    <th rowspan="3" scope="row">Order Made By</th>
    <td><span class="txt_box">${salesMan.orgCode} (Organization Code)<i>(${salesMan.memcode1}) ${salesMan.name1} - ${salesMan.telmobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${salesMan.grpCode} (Group Code)<i>(${salesMan.memcode2}) ${salesMan.name2} - ${salesMan.telmobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${salesMan.deptCode} (Department Code)<i>(${salesMan.memcode3}) ${salesMan.name3} - ${salesMan.telmobile3}</i></span></td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span>${salesMan.memCode}</span></td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td><span>${salesMan.name}</span></td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td><span>${salesMan.nric}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${salesMan.telMobile}</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>${salesMan.telOffice}</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>${salesMan.telHuse}</span></td>
</tr>
</tbody>
</table><!-- table end -->


</article><!-- tap_area end -->