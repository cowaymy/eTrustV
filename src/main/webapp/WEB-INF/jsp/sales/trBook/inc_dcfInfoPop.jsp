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
    <th scope="row">Type</th>
    <td><span>Data Change Form (DCF)</span></td>
    <th scope="row">Category</th>
    <td><span>TR Book</span></td>
    <th scope="row">Subject</th>
    <td><span>TR Book Lost</span></td>
</tr>
<tr>
    <th scope="row">Requester</th>
    <td><span>${SESSION_INFO.userName}</span></td>
    <th scope="row">Recipient</th>
    <td><span></span>Own approver(s)</td>
    <th scope="row">Request Branch</th>
    <td><span>${SESSION_INFO.code}</span></td>
</tr>
<tr>
    <th scope="row">Request On Behalf</th>
    <td colspan="3"><input type="text"  title=""  placeholder="Request On Behalf" class="w100p" id=""  name="" readonly="readonly"/></td>
    <th scope="row">Reason <span class="must">*</span></th>
    <td>    
	    <select class="w100p"  id='feedback' name ='feedback' >
	    </select>
    </td>
</tr>
<tr>
    <th scope="row">Description <span class="must">*</span></th>
    <td colspan="5"> <textarea cols="20" rows="5" id='description'  name='description' placeholder="Description" ></textarea></td>
</tr>
<tr>
    <th scope="row">Remark </th>
    <td colspan="5"> <textarea cols="20" rows="5" id='remark'  name='remark' placeholder="Remark" ></textarea></td>
</tr>


</tbody>
</table><!-- table end     -->

</article><!-- tap_area end   MembershipInfo tab-->
