<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

$(document).ready(function(){  

	if("${dcfInfo}" != null && "${dcfInfo}" != ""){
		
		$("#savebt").hide();
		Common.alert("<b><spring:message code="sal.alert.msg.underDCF" /> [ ${dcfInfo.defReqNo} ].<br /><spring:message code="sal.alert.msg.noOtherAction" /></b>");
	}
    
    $("#saveTrHolderType").val("${lostInfo.trHolderType }");
    $("#saveMemCode").val("${memberInfo.memCode }");
    $("#saveTrBookNo").val("${lostInfo.trBookNo }");
    
});


</script>
<article class="tap_area"><!-- tap_area start   lost info tab -->

<table class="type1"><!-- table start   -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.lostType" /></th>
    <td><span><spring:message code="sal.text.lostWhole" /></span></td>
    <th scope="row"><spring:message code="sal.text.trBookNo" /></th>
    <td><span>${lostInfo.trBookNo }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.trNo" /></th>
    <td><span>${lostInfo.trBookNoStart } To ${lostInfo.trBookNoEnd }</span></td>
    <th scope="row"><spring:message code="sal.text.totalPages" /></th>
    <td><span>${lostInfo.trBookPge }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.holderType" /></th>
    <td><span>${lostInfo.trHolderType }</span></td>
    <th scope="row">  <spring:message code="sal.text.holderCode" /> </th>
    <td><span>${memberInfo.memCode }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.holderName" /></th>
    <td><span>${memberInfo.name }</span></td>
    <th scope="row"><spring:message code="sal.text.holderNric" /></th>
    <td><span>${memberInfo.nric }</span></td>
</tr>


</tbody>
</table><!-- table end     -->
</article><!-- tap_area end   MembershipInfo tab-->
