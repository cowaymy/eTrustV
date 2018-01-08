<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

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
    <th scope="row"><spring:message code="sales.MembershipNo" /></th>
    <td><span>${membershipInfoTab.mbrshNo}</span></td>
    <th scope="row"><spring:message code="sal.text.billNo" /></th>
    <td><span>${membershipInfoTab.mbrshBillNo}</span></td>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td><span>${membershipInfoTab.mbrshStusName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.pakCode" /></th>
    <td><span>${membershipInfoTab.pacCode}</span></td>
    <th scope="row"><spring:message code="sales.pakName" /></th>
    <td colspan="3"><span>${membershipInfoTab.pacName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.StartDate" /></th>
    <td><span>${membershipInfoTab.mbrshStartDt} </span></td>
    <th scope="row"><spring:message code="sales.ExpireDate" /></th>
    <td><span>${membershipInfoTab.mbrshExprDt}</span></td>
    <th scope="row"><spring:message code="sales.Duration" /></th>
    <td><span>${membershipInfoTab.mbrshDur}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.totAmt" /></th>
    <td><span>${membershipInfoTab.mbrshTotAmt}</span></td>
    <th scope="row"><spring:message code="sal.text.pacAmt" /></th>
    <td><span>${membershipInfoTab.mbrshPacAmt}</span></td>
    <th scope="row"><spring:message code="sal.text.filAmt" /></th>
    <td><span>${membershipInfoTab.mbrshFilterAmt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.bsFre" /></th>
    <td><span>${membershipInfoTab.mbrshFreq}</span></td>
    <th scope="row"><spring:message code="sales.Outstanding" /></th>
    <td><span>${membershipInfoTab.mbrshOtstnd}</span></td>
    <th scope="row"><spring:message code="sales.Creator" /></th>
    <td><span>${membershipInfoTab.mbrshCrtUserId}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
    <td colspan="3">
          <span>  ${membershipInfoTab.brnchCode} <c:if test="${not empty membershipInfoTab.brnchCode}"> -  ${membershipInfoTab.brnchName} </c:if> </span>
     </td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td><span>${membershipInfoTab.mbrshCrtDt}  </span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.pakPro" /></th>
    <td colspan="5">
          <span>  ${membershipInfoTab.mbrshPacPromoCode} <c:if test="${not empty membershipInfoTab.mbrshPacPromoCode}"> -  ${membershipInfoTab.mbrshPacPromoName} </c:if> </span>
    
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.filterPro" /></th>
     <td colspan="5">
          <span>  ${membershipInfoTab.mbrshPromoCode} <c:if test="${not empty membershipInfoTab.mbrshPromoCode}"> -  ${membershipInfoTab.mbrshPromoName} </c:if> </span>
    
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.salManCode" /></th>
    <td><span> ${membershipInfoTab.mbrshSalesMemCode} </span></td>
    <th scope="row"><spring:message code="sal.text.salManName" /></th>
    <td colspan="3"><span> ${membershipInfoTab.mbrshSalesMemName} </span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.quotationNo" /></th>
    <td><span id="quotNo"></span></td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td><span id="crtDt"></span></td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td><span id="crtUserId"></span></td>
</tr>
</tbody>
</table><!-- table end     -->

</article><!-- tap_area end   MembershipInfo tab-->


<script>
  $("#QUOT_ID").val(${membershipInfoTab.quotId});
</script>
