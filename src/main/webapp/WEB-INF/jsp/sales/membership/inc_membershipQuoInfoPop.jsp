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
    <th scope="row">Quotation No</th>
    <td><span  id="inc_quotNo" >${quotInfo.quotNo}</span></td>
    <th scope="row">Validity Status</th>
    <td><span id="inc_validStus" >${quotInfo.validStus}</span></td>
    <th scope="row">Create Date</th>
    <td><span id="inc_crtDts" >${quotInfo.crtDt}</span></td>
</tr>
<tr>
    <th scope="row">Membership Sales</th>
    <td><span id="inc_cnvrMemNo">${quotInfo.cnvrMemNo} </span></td>
    <th scope="row">Valid Date</th>
    <td><span id="inc_validD" >${quotInfo.validDt}</span></td>
    <th scope="row">Creator</th>
    <td><span  id="inc_crtUserId" >${quotInfo.crtUserId}</span></td>
</tr>
<tr>
    <th scope="row">Duration</th>
    <td><span  id="inc_dur">  <c:if test="${not empty quotInfo.dur}">  ${quotInfo.dur} month(s) </c:if> </span></td>
    <th scope="row">Package</th>
    <td><span id="inc_pacDesc">${quotInfo.pacDesc}</span></td>
    <th scope="row">Deactivated by</th>
    <td><span id="inc_pacDeacby" ></span></td>
</tr>
<tr>
    <th scope="row">Total Amount</th>
    <td><span id="inc_totAmt" >${quotInfo.totAmt}</span></td>
    <th scope="row">Package Amount</th>
    <td><span id="inc_pacAmt" >${quotInfo.pacAmt}</span></td>
    <th scope="row">Filter Amount</th>
    <td><span  id="inc_filterAmt">${quotInfo.filterAmt}</span></td>
</tr>
<tr>
    <th scope="row">Package Promotion</th>
    <td colspan="5"><span id="inc_pacPromoDesc">${quotInfo.pacPromoDesc}  </span></td>
</tr>
<tr>
    <th scope="row">Filter Promotion</th>
    <td colspan="3"><span  id="inc_promeCode" >${quotInfo.promeCode}   ${quotInfo.promeDesc} </span></td>
    <th scope="row">BS Frequency</th>
    <td> <span  id="inc_bsFreq" > <c:if test="${not empty quotInfo.bsFreq}">  ${quotInfo.bsFreq} month(s)</c:if></span></td>
</tr>
<tr>
    <th scope="row">Sales Person Code</th>
    <td><span  id="inc_memCode">${quotInfo.memCode}  </span></td>
    <th scope="row">Sales Person Name</th>
    <td colspan="3"><span  id="inc_memName">${quotInfo.memName}</span></td>
</tr>
<tr>
    <th scope="row">Reference Number</th>
    <td colspan="5"><span id="inc_refNo">${quotInfo.refNo}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<script>


if('${quotInfo.validStus}' == 'ACT' ){
	
	$("#inc_validStus").html("<font color='green'> Ready to convert </font>");
	$("#inc_pacDeacby").html("-");
	
}else if('${quotInfo.validStus}' == 'CON'){
	
	$("#inc_validStus").html("<font color='orange'> Converted to sales </font>");
	$("#inc_pacDeacby").html("-");
	
}else if('${quotInfo.validStus}' == 'EXP'){
	
	$("#inc_validStus").html("<font color='red'> Expired </font>");
	$("#inc_pacDeacby").html("-");
	
}else if('${quotInfo.validStus}' == 'DEA'){
    $("#inc_validStus").html("<font color=brown'> Deactivated </font>");
    $("#inc_pacDeacby").html("${quotInfo.updUserId}");
}
		
		$("#inc_cntName").html("${quotInfo.cntName}");
		$("#inc_cntNric").html("${quotInfo.cntNric}");
		$("#inc_cntGender").html("${quotInfo.cntGender}");
		$("#inc_cntRace").html("${quotInfo.cntRace}");
		$("#inc_cntTelM").html("${quotInfo.cntTelMob}");
		$("#inc_cntTelR").html("${quotInfo.cntTelR}");
		$("#inc_cntTelO").html("${quotInfo.cntTelO}");
		$("#inc_cntTelF").html("${quotInfo.cntTelF}");
		$("#inc_cntEmail").html("${quotInfo.cntEmail}");
		
		
		$("#QUOT_ID").val('${quotInfo.quotId}');
        $("#QUOT_VAILD_STUS").val('${quotInfo.validStus}');

 
 </script>
