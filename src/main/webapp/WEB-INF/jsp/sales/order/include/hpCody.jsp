<article class="tap_area"><!-- tap_area start -->

<section class="divine2"><!-- divine3 start -->

<article>
<h3>Salesman Info</h3>

<input id="salesmanMemTypeID" name="salesmanMemTypeID" type="hidden" value="${orderDetail.salesmanInfo.memType}">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Order Made By</th>
    <td><span class="txt_box">${orderDetail.salesmanInfo.orgCode} (Organization Code)<i>(${orderDetail.salesmanInfo.memCode1}) ${orderDetail.salesmanInfo.name1} - ${orderDetail.salesmanInfo.telMobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.salesmanInfo.grpCode} (Group Code)<i>(${orderDetail.salesmanInfo.memCode2}) ${orderDetail.salesmanInfo.name2} - ${orderDetail.salesmanInfo.telMobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.salesmanInfo.deptCode} (Department Code)<i>(${orderDetail.salesmanInfo.memCode3}) ${orderDetail.salesmanInfo.name3} - ${orderDetail.salesmanInfo.telMobile3}</i></span></td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span>${orderDetail.salesmanInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td><span>${orderDetail.salesmanInfo.name}</span></td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td><span>${orderDetail.salesmanInfo.nric}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${orderDetail.salesmanInfo.telMobile}</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>${orderDetail.salesmanInfo.telOffice}</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>${orderDetail.salesmanInfo.telHuse}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

<article>
<h3>Cody Info</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Service By</th>
    <td><span class="txt_box">${orderDetail.codyInfo.orgCode} (Organization Code)<i>(${orderDetail.codyInfo.memCode1}) ${orderDetail.codyInfo.name1} - ${orderDetail.codyInfo.telMobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.codyInfo.grpCode} (Group Code)<i>(${orderDetail.codyInfo.memCode2}) ${orderDetail.codyInfo.name2} - ${orderDetail.codyInfo.telMobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.codyInfo.deptCode} (Department Code)<i>(${orderDetail.codyInfo.memCode3}) ${orderDetail.codyInfo.name3} - ${orderDetail.codyInfo.telMobile3}</i></span></td>
</tr>
<tr>
    <th scope="row">Cody Code</th>
    <td><span>${orderDetail.codyInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row">Cody Name</th>
    <td><span>${orderDetail.codyInfo.name}</span></td>
</tr>
<tr>
    <th scope="row">Cody NRIC</th>
    <td><span>${orderDetail.codyInfo.nric}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${orderDetail.codyInfo.telMobile}</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>${orderDetail.codyInfo.telOffice}</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>${orderDetail.codyInfo.telHuse}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

</section><!-- divine2 start -->


</article><!-- tap_area end -->