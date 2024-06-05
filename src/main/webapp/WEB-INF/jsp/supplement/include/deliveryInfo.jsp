<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Address Line 1</th>
    <td colspan="5"><span>${orderInfo.addressLine1}</span></td>
</tr>
<tr>
    <th scope="row">Address Line 2</th>
    <td colspan="5"><span>${orderInfo.addressLine2}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.Area" /></th>
    <td><span>${orderInfo.area}</span></td>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span>${orderInfo.city}</span></td>
    <th scope="row"><spring:message code="sys.title.postcode" /></th>
    <td><span>${orderInfo.postcode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.State" /></th>
    <td><span>${orderInfo.state}</span></td>
    <th scope="row"><spring:message code="sys.country"/></th>
    <td><span>${orderInfo.country}</span></td>
    <th </th>
    <td>
    </td>
</tr>

</tbody>

</table><!-- table end -->

</article><!-- tap_area end -->