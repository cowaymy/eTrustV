<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

$(document).ready(function() {


});

function fn_updateConfirm(){
var jsonObj = {
		eHPMemberID : $("#eHPMemberID").val(),
		eHPmemberCode : $("#eHPmemberCode").val(),
		eHPmemType : $("#eHPmemType").val(),
		eHPmemberNm : $("#eHPmemberNm").val(),
		eHPmemberNric : $("#eHPmemberNric").val(),
		eHPapplicationStatus : $("#eHPapplicationStatus").val(),
		eHPFailReasn : $("#eHPFailReasn").val(),
		eHPRemarkTxt : $("#eHPRemarkTxt").val()
};
console.log("-------------------------" + JSON.stringify(jsonObj));
    Common.ajax("POST", "/organization/eHPmemberStatusUpdate",  jsonObj, function(result) {
        console.log("message : " + result.message );
        Common.alert(result.message,fn_close);

        });
}

function fn_close() {
    $("#popup_wrap").remove();
}



</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eHP Member List - Update Status</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="eHPmemberUpdateForm" method="post">
<input type="hidden" id="eHPareaId" name="areaId" value="${memberView.areaId}">
<input type="hidden" id="eHPmemType" name="memType" value="${memberView.aplicntType}">
<input type="hidden"id="eHPMemberID" name="MemberID" value="${memberView.aplctnId}">
<input type="hidden"id="eHPdeptCode" name="deptCode" value="${deptCode}">
<input type="hidden"id="eHPUserDeptCode" name="UserDeptCode" value="${userDeptCode}">
<input type="hidden"id="eHPUserMemType" name="UserMemType" value="${userMemType}">
<input type="hidden" id="eHPcnfm" name="eHPconfirmation" value="${memberView.cnfm}">


<table class="type1"><!-- table start -->
<caption>table</caption>
<!-- <colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup> -->
<tbody>
<tr>
<th scope="row">HP Applicant Code<span class="must">*</span></th>
    <td>
    <input type="text" title="" id="eHPmemberCode" name="memberCode" placeholder="Member Code" class="w100p"  value="<c:out value="${memberView.memCode}"/>" disabled="disabled" />
    </td>
  </tr>
  <tr>
    <th scope="row">Member Name<span class="must">*</span></th>
    <td>
    <input type="text" title="" id="eHPmemberNm" name="memberNm" placeholder="Member Name" class="w100p"  value="<c:out value="${memberView.aplicntName}"/>" disabled="disabled" />
    </td>
</tr>
<tr>
    <th scope="row">NRIC<span class="must">*</span></th>
    <td>
 <input type="text" title="" id="eHPmemberNric" name="memberNric" placeholder="Member NRIC" class="w100p"  value="<c:out value="${memberView.aplicntNric}"/>" disabled="disabled" />
</td>
</tr>
<tr>
 <th scope="row">Action<span class="must">*</span></th>
    <td colspan="2">
    <select class="w100p" id= "eHPapplicationStatus">
        <option value="21">Failed</option>
        <option value="10">Cancelled</option>
    </select>
</tr>
<tr>
    <th scope="row" id = "eHPFailReasnLbl">Fail Reason<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="eHPFailReasn" id="eHPFailReasn" value="2312" /><span>Incomplete document</span></label>
    <label><input type="radio" name="eHPFailReasn" id="eHPFailReasn" value="2313"/><span>Incorrect Key-In</span></label>
    </td>
</tr>
<tr>
<th scope="row" id = "eHPRemarkLbl">Remark</th>
     <td colspan="3"><textarea id="eHPRemarkTxt" name="txtRemark"
          cols="20" rows="5"></textarea></td>
</tr>

</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_updateConfirm()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">Close</a></p></li>
</ul>

</form>
</section>

</div><!-- popup_wrap end -->

