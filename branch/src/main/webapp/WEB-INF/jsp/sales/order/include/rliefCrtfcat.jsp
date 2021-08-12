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
    <th scope="row"><spring:message code="sal.text.refNo" /></th>
    <td><span>${orderDetail.gstCertInfo.eurcRefNo}</span></td>
    <th scope="row"><spring:message code="sal.title.text.certificateDate" /></th>
    <td><span>${orderDetail.gstCertInfo.eurcRefDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
    <td colspan="3"><span>${orderDetail.gstCertInfo.eurcCustRgsNo}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><span>${orderDetail.gstCertInfo.eurcRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->
