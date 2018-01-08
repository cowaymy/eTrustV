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
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.quotationNo" /></th>
    <td><span  id="inc_quotNo" >${quotInfo.quotNo}</span></td>
    <th scope="row"><spring:message code="sal.text.validityStatus" /></th>
    <td><span id="inc_validStus" >${quotInfo.validStus}</span></td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td><span id="inc_crtDts" >${quotInfo.crtDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.memSales" /></th>
    <td><span id="inc_cnvrMemNo">${quotInfo.cnvrMemNo} </span></td>
    <th scope="row"><spring:message code="sal.text.validDate" /></th>
    <td><span id="inc_validD" >${quotInfo.validDt}</span></td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td><span  id="inc_crtUserId" >${quotInfo.crtUserId}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.Duration" /></th>
    <td><span  id="inc_dur">  <c:if test="${not empty quotInfo.dur}">  ${quotInfo.dur} month(s) </c:if> </span></td>
    <th scope="row"><spring:message code="sales.Package" /></th>
    <td><span id="inc_pacDesc">${quotInfo.pacDesc}</span></td>
    <th scope="row"><spring:message code="sal.text.deactivatedby" /></th>
    <td><span id="inc_pacDeacby" ></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.totAmt" /></th>
    <td><span id="inc_totAmt" >${quotInfo.totAmt}</span></td>
    <th scope="row"><spring:message code="sal.text.pacAmt" /></th>
    <td><span id="inc_pacAmt" >${quotInfo.pacAmt}</span></td>
    <th scope="row"><spring:message code="sal.text.filAmt" /></th>
    <td><span  id="inc_filterAmt">${quotInfo.filterAmt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.pakPro" /></th>
    <td colspan="5"><span id="inc_pacPromoDesc">${quotInfo.pacPromoDesc}  </span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.filterPro" /></th>
    <td colspan="3"><span  id="inc_promeCode" >${quotInfo.promeCode}   ${quotInfo.promeDesc} </span></td>
    <th scope="row"><spring:message code="sales.bsFre" /></th>
    <td> <span  id="inc_bsFreq" > <c:if test="${not empty quotInfo.bsFreq}">  ${quotInfo.bsFreq} month(s)</c:if></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.salPersonCode" /></th>
    <td><span  id="inc_memCode">${quotInfo.memCode}  </span></td>
    <th scope="row"><spring:message code="sal.text.salPersonName" /></th>
    <td colspan="3"><span  id="inc_memName">${quotInfo.memName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.refNum" /></th>
    <td colspan="5"><span id="inc_refNo">${quotInfo.refNo}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<script>

var msg;

if('${quotInfo.validStus}' == 'ACT' ){
	msg = "<spring:message code="sal.text.readyToConvert" />";
	
	$("#inc_validStus").html("<font color='green'>" +msg+ "</font>");
	$("#inc_pacDeacby").html("-");
	
}else if('${quotInfo.validStus}' == 'CON'){
	msg ="<spring:message code="sal.text.convertedTosales" />";
	
	$("#inc_validStus").html("<font color='orange'>"+msg+"</font>");
	$("#inc_pacDeacby").html("-");
	
}else if('${quotInfo.validStus}' == 'EXP'){
	msg ="<spring:message code="sal.text.expired" />";
	
	$("#inc_validStus").html("<font color='red'>"+msg+"</font>");
	$("#inc_pacDeacby").html("-");
	
}else if('${quotInfo.validStus}' == 'DEA'){
	msg ="<spring:message code="sal.text.deacivated" />";
	
    $("#inc_validStus").html("<font color=brown'>"+msg+"</font>");
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
