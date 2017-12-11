<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Rental Paymode</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayModeDesc}</span></td>
    <th scope="row">Direct Debit Mode</th>
    <td><span>${orderDetail.rentPaySetInf.clmDdMode}</span></td>
    <th scope="row">Auto Debit Limit</th>
    <td><span>${orderDetail.rentPaySetInf.clmLimit}</span></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayIssBank}</span></span></td>
    <th scope="row">Card Type</th>
    <td><span>${orderDetail.rentPaySetInf.cardType}</span></td>
    <th scope="row">Claim Bill Date</th>
    <td><span></span></td>
</tr>
<tr>
    <th scope="row">Credit Card No</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayCrcNo}</span></td>
    <th scope="row">Name On Card</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayCrOwner}</span></td>
    <th scope="row">Expiry Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayCrcExpr}</span></td>
</tr>
<tr>
    <th scope="row">Bank Account No</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayAccNo}</span></td>
    <th scope="row">Account Name</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayAccOwner}</span></td>
    <th scope="row">Issure NRIC</th>
    <td><span>${orderDetail.rentPaySetInf.issuNric}</span></td>
</tr>
<tr>
    <th scope="row">Apply Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayApplyDt}</span></td>
    <th scope="row">Submit Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPaySubmitDt}</span></td>
    <th scope="row">Start Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayStartDt}</span></td>
</tr>
<tr>
    <th scope="row">Reject Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayRejctDt}</span></td>
    <th scope="row">Reject Code</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayRejct}</span></td>
    <th scope="row">Payment Term</th>
    <td><span>${orderDetail.rentPaySetInf.payTrm} month(s)</span></td>
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
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->
