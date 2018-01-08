<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

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
    <col style="width:100px" />
    <col style="width:*" /> 
</colgroup>
<tbody>

<tr>
    <th scope="row"><spring:message code="sales.ContactPerson" /></th>
    <td colspan="7"><span  id="inc_cntName">${membershipInfoTab.cntName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.NRIC" /></th>
    <td colspan="3"><span  id="inc_cntNric">${membershipInfoTab.cntNric}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span  id="inc_cntGender">${membershipInfoTab.cntGender}</span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span id="inc_cntRace">${membershipInfoTab.cntRace}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><span><span  id="inc_cntTelM">${membershipInfoTab.cntTelM}</span></span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span  id="inc_cntTelR">${membershipInfoTab.cntTelR}</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span id="inc_cntTelO">${membershipInfoTab.cntTelO}</span></td>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><span id="inc_cntTelF">${membershipInfoTab.cntTelF}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td colspan="7" ><span id="inc_cntEmail" >${membershipInfoTab.cntEmail}</span></td>
</tr>

</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
 
<script>
 
 
</script>


