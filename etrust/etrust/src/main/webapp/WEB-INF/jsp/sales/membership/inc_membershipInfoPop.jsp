<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<article class="tap_area"><!-- tap_area start   MembershipInfo tab -->

<table class="type1"><!-- table start   -->
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
    <th scope="row">Membership No</th>
    <td><span>${membershipInfoTab.mbrshNo}</span></td>
    <th scope="row">Bill No</th>
    <td><span>${membershipInfoTab.mbrshBillNo}</span></td>
    <th scope="row">Status</th>
    <td><span>${membershipInfoTab.mbrshStusName}</span></td>
</tr>
<tr>
    <th scope="row">Package Code</th>
    <td><span>${membershipInfoTab.pacCode}</span></td>
    <th scope="row">Package Name</th>
    <td colspan="3"><span>${membershipInfoTab.pacName}</span></td>
</tr>
<tr>
    <th scope="row">Start Date</th>
    <td><span>${membershipInfoTab.mbrshStartDt} </span></td>
    <th scope="row">Expire Date</th>
    <td><span>${membershipInfoTab.mbrshExprDt}</span></td>
    <th scope="row">Duration</th>
    <td><span>${membershipInfoTab.mbrshDur}</span></td>
</tr>
<tr>
    <th scope="row">Total Amount</th>
    <td><span>${membershipInfoTab.mbrshTotAmt}</span></td>
    <th scope="row">Package Amount</th>
    <td><span>${membershipInfoTab.mbrshPacAmt}</span></td>
    <th scope="row">Filter Amount</th>
    <td><span>${membershipInfoTab.mbrshFilterAmt}</span></td>
</tr>
<tr>
    <th scope="row">BS Frequency</th>
    <td><span>${membershipInfoTab.mbrshFreq}</span></td>
    <th scope="row">Outstanding</th>
    <td><span>${membershipInfoTab.mbrshOtstnd}</span></td>
    <th scope="row">Creator</th>
    <td><span>${membershipInfoTab.mbrshCrtUserId}</span></td>
</tr>
<tr>
    <th scope="row">Key-In Branch</th>
    <td colspan="3">
          <span>  ${membershipInfoTab.brnchCode} <c:if test="${not empty membershipInfoTab.brnchCode}"> -  ${membershipInfoTab.brnchName} </c:if> </span>
     </td>
    <th scope="row">Create Date</th>
    <td><span>${membershipInfoTab.mbrshCrtDt}  </span></td>
</tr>
<tr>
    <th scope="row">Package Promotion</th>
    <td colspan="5">
          <span>  ${membershipInfoTab.mbrshPacPromoCode} <c:if test="${not empty membershipInfoTab.mbrshPacPromoCode}"> -  ${membershipInfoTab.mbrshPacPromoName} </c:if> </span>
    
    </td>
</tr>
<tr>
    <th scope="row">Filter Promotion</th>
     <td colspan="5">
          <span>  ${membershipInfoTab.mbrshPromoCode} <c:if test="${not empty membershipInfoTab.mbrshPromoCode}"> -  ${membershipInfoTab.mbrshPromoName} </c:if> </span>
    
    </td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span> ${membershipInfoTab.mbrshSalesMemCode} </span></td>
    <th scope="row">Salesman Name</th>
    <td colspan="3"><span> ${membershipInfoTab.mbrshSalesMemName} </span></td>
</tr>
<tr>
    <th scope="row">Quotation No</th>
    <td><span id="quotNo"></span></td>
    <th scope="row">Create Date</th>
    <td><span id="crtDt"></span></td>
    <th scope="row">Creator</th>
    <td><span id="crtUserId"></span></td>
</tr>
</tbody>
</table><!-- table end     -->

</article><!-- tap_area end   MembershipInfo tab-->


<script>
  $("#QUOT_ID").val(${membershipInfoTab.quotId});
</script>
