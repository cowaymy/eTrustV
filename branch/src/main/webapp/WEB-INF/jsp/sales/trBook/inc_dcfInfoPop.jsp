<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

	$(document).ready(function(){  
	
	    CommonCombo.make("feedback", "/sales/trBook/selectFeedBackCode", null, null, {id:"resnId", name:"value", isShowChoose: true});
	    
    
    });

</script>
<article class="tap_area"><!-- tap_area start   DCF info tab -->

<table class="type1"><!-- table start   -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" /> 
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.type" /></th>
    <td><span><spring:message code="sal.text.dataChangeForm" /></span></td>
    <th scope="row"><spring:message code="sal.text.category" /></th>
    <td><span><spring:message code="sal.text.trBook" /></span></td>
    <th scope="row"><spring:message code="sal.text.subject" /></th>
    <td><span><spring:message code="sal.text.trBookLost" /></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.requester" /></th>
    <td><span>${SESSION_INFO.userName}</span></td>
    <th scope="row"><spring:message code="sal.text.recipient" /></th>
    <td><span></span><spring:message code="sal.text.ownApprover" /></td>
    <th scope="row"><spring:message code="sal.text.requestBranch" /></th>
    <td><span>${SESSION_INFO.code}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.requestOnBehalf" /></th>
    <td colspan="3"><input type="text"  title=""  placeholder="Request On Behalf" class="w100p" id=""  name="" readonly="readonly"/></td>
    <th scope="row"><spring:message code="sal.text.reason" /> <span class="must">*</span></th>
    <td>    
	    <select class="w100p"  id='feedback' name ='feedback' >
	    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.description" /> <span class="must">*</span></th>
    <td colspan="5"> <textarea cols="20" rows="5" id='description'  name='description' placeholder="Description" ></textarea></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /> </th>
    <td colspan="5"> <textarea cols="20" rows="5" id='remark'  name='remark' placeholder="Remark" ></textarea></td>
</tr>


</tbody>
</table><!-- table end     -->

</article><!-- tap_area end   MembershipInfo tab-->
