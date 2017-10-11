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
    <th scope="row">Address Detail</th>
    <td colspan="3"><span>${orderDetail.installationInfo.instAddrDtl}</span></td>
    <th scope="row">Postcode</th>
    <td><span>${orderDetail.installationInfo.instPostcode}</span></td>
</tr>
<tr>
    <th scope="row">Street</th>
    <td colspan="3"><span>${orderDetail.installationInfo.instStreet}</span></td>
    <th scope="row">City</th>
    <td><span>${orderDetail.installationInfo.instCity}</span></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td colspan="3"><span>${orderDetail.installationInfo.instArea}</span></td>
    <th scope="row">State</th>
    <td><span>${orderDetail.installationInfo.instState}</span></td>
</tr>
<tr>
    <th scope="row">Prefer Install Date</th>
    <td><span>${orderDetail.installationInfo.preferInstDt}</span></td>
    <th scope="row">Prefer Install Time</th>
    <td><span>${orderDetail.installationInfo.preferInstTm}</span></td>
    <th scope="row">Country</th>
    <td><span>${orderDetail.installationInfo.instCountry}</span></td>
</tr>
<tr>
    <th scope="row">Instruction</th>
    <td colspan="5"><span>${orderDetail.installationInfo.instct}</span></td>
</tr>
<tr>
    <th scope="row">DSC Verification Remark</th>
    <td colspan="5"><span>${orderDetail.installationInfo.vrifyRem}</span></td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td colspan="3"><span>(${orderDetail.installationInfo.dscCode} )${orderDetail.installationInfo.dscName}</span></td>
    <th scope="row">Installed Date</th>
    <td><span>${orderDetail.installationInfo.firstInstallDt}</span></td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td><span>${orderDetail.installationInfo.lastInstallCtCode}</span></td>
    <th scope="row">CT Name</th>
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
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>${orderDetail.installationInfo.instCntName}</span></td>
    <th scope="row">Gender</th>
    <td><span>${orderDetail.installationInfo.instCntGender}</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>${orderDetail.installationInfo.instCntNric}</span></td>
    <th scope="row">Email</th>
    <td><span>${orderDetail.installationInfo.instCntEmail}</span></td>
    <th scope="row">Fax No</th>
    <td><span>${orderDetail.installationInfo.instCntTelF}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${orderDetail.installationInfo.instCntTelM}</span></td>
    <th scope="row">Office No</th>
    <td><span>${orderDetail.installationInfo.instCntTelO}</span></td>
    <th scope="row">House No</th>
    <td><span>${orderDetail.installationInfo.instCntTelR}</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>${orderDetail.installationInfo.instCntPost}</span></td>
    <th scope="row">Department</th>
    <td><span>${orderDetail.installationInfo.instCntDept}</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->