<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reference No</th>
    <td><span>${orderDetail.gstCertInfo.eurcRefNo}</span></td>
    <th scope="row">Certificate Date</th>
    <td><span>${orderDetail.gstCertInfo.eurcRefDt}</span></td>
</tr>
<tr>
    <th scope="row">GST Registration No</th>
    <td colspan="3"><span>${orderDetail.gstCertInfo.eurcCustRgsNo}</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>${orderDetail.gstCertInfo.eurcRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->
