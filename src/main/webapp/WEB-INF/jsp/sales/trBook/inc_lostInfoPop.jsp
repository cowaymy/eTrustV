<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

$(document).ready(function(){  

	if("${dcfInfo}" != null && "${dcfInfo}" != ""){
		
		$("#savebt").hide();
		Common.alert("<b>This TR Book is under DCF [ ${dcfInfo.defReqNo} ].<br />No other action is allowed at this moment.</b>");
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
    <th scope="row">Lost Type</th>
    <td><span>Lost - Whole</span></td>
    <th scope="row">TR Book No</th>
    <td><span>${lostInfo.trBookNo }</span></td>
</tr>
<tr>
    <th scope="row">TR No</th>
    <td><span>${lostInfo.trBookNoStart } To ${lostInfo.trBookNoEnd }</span></td>
    <th scope="row">Total Page(s)</th>
    <td><span>${lostInfo.trBookPge }</span></td>
</tr>
<tr>
    <th scope="row">Holder Type</th>
    <td><span>${lostInfo.trHolderType }</span></td>
    <th scope="row">  Holder Code </th>
    <td><span>${memberInfo.memCode }</span></td>
</tr>
<tr>
    <th scope="row">Holder Name</th>
    <td><span>${memberInfo.name }</span></td>
    <th scope="row">Holder NRIC</th>
    <td><span>${memberInfo.nric }</span></td>
</tr>


</tbody>
</table><!-- table end     -->
</article><!-- tap_area end   MembershipInfo tab-->
