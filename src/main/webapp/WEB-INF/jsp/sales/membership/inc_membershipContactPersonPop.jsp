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
    <col style="width:100px" />
    <col style="width:*" /> 
</colgroup>
<tbody>

<tr>
    <th scope="row">Contact Person</th>
    <td colspan="7"><span  id="inc_cntName">${membershipInfoTab.cntName}</span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td colspan="3"><span  id="inc_cntNric">${membershipInfoTab.cntNric}</span></td>
    <th scope="row">Gender</th>
    <td><span  id="inc_cntGender">${membershipInfoTab.cntGender}</span></td>
    <th scope="row">Race</th>
    <td><span id="inc_cntRace">${membershipInfoTab.cntRace}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span><span  id="inc_cntTelM">${membershipInfoTab.cntTelM}</span></span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span  id="inc_cntTelR">${membershipInfoTab.cntTelR}</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span id="inc_cntTelO">${membershipInfoTab.cntTelO}</span></td>
    <th scope="row">Tel (Fax)</th>
    <td><span id="inc_cntTelF">${membershipInfoTab.cntTelF}</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td colspan="7" ><span id="inc_cntEmail" >${membershipInfoTab.cntEmail}</span></td>
</tr>

</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
 
<script>
 
 
</script>


