<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" /> 
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><span>${orderInfoTab.ordNo}</span></td>
    <th scope="row">Order Date</th>
    <td><span>${orderInfoTab.ordDt}</span></td>
    <th scope="row">Order Status</th>
    <td><span>${orderInfoTab.ordStusName}</span></td>
</tr>
<tr>
    <th scope="row">Product Category</th>
    <td colspan="3"><span>${orderInfoTab.codeName}</span></td>
    <th scope="row">Application Type</th>
    <td><span>${orderInfoTab.appTypeCode}</span></td>
</tr>
<tr>
    <th scope="row">Product Code</th>
    <td><span id="inc_stockCode">${orderInfoTab.stockCode}</span></td>
    <th scope="row">Product Name</th>
    <td colspan="3"  id="inc_stockDesc" ><span>${orderInfoTab.stockDesc}</span></td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>${orderInfoTab.custId}</span></td>
    <th scope="row">NRIC/Company No</th>
    <td colspan="3"><span>${orderInfoTab.custNric}</span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="5"><span>${orderInfoTab.custName}</span></td>
</tr>


<tr id="last_div" >
    <th scope="row">Last Membership</th>
    <td colspan="3"><span id='last_membership_text'>&nbsp;</span></td> 
    <th scope="row">Expire Date</th>
    <td><span id='expire_date_text'></span></td>
</tr>

<tr>
    <th scope="row">Install Address</th>
    <td colspan="5"><span id="ins_full_address">${contactInfoTab.instAddr1}&nbsp;${contactInfoTab.instAddr2}&nbsp; ${contactInfoTab.instAddr3}&nbsp;
                            ${contactInfoTab.instPostCode}&nbsp;${contactInfoTab.instArea}&nbsp;${contactInfoTab.instState}&nbsp;${contactInfoTab.instCnty}&nbsp;
     </span></td>
</tr>
</tbody>
</table><!-- table end -->


</article><!-- tap_area end -->