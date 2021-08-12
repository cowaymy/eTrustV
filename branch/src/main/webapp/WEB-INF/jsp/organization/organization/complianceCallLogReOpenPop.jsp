<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function(){
       doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1388, inputId : 1, separator : '-'}, '', 'comfup', 'S'); //Reason Code
       doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1389, inputId : 1, separator : '-'}, '', 'caseCategory', 'S'); //Reason Code
       doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1391, inputId : 1, separator : '-'}, '', 'finalAction', 'S'); //Reason Code
       doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1390, inputId : 1, separator : '-'}, '', 'docType', 'S'); //Reason Code
       
       
       $("#caseCategory").change(function(){
           if($("#caseCategory").val() == '2144' ){
               $("select[name=docType]").removeAttr("disabled");
               $("select[name=docType]").removeClass("w100p disabled");
               $("select[name=docType]").addClass("w100p");
            }else{
                 $("#docType").val("");
                 $("select[name=docType]").attr('disabled', 'disabled');
                 $("select[name=docType]").addClass("disabled");
                 //$("select[name=docType]").addClass("w100p");
            }   
       });
});

function fn_validation(){
    var msg = "";
    if($("#action").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Action' htmlEscape='false'/>");
        return false;
    }
    if($("#recevCaseDt").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='received date' htmlEscape='false'/>");
        return false;
    }
    if($("#caseCategory").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='case category' htmlEscape='false'/>");
        return false;
    }
    if($("#caseCategory").val() == '2144' && $("#docType").val() == '' ){
        msg += " - Plaese select a type of document. <br />"
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='type of document' htmlEscape='false'/>");
        return false;
    }
    if($("#complianceRem").val() == '' ){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Compliance remark' htmlEscape='false'/>");
        return false;
    }
    
    if($("#hidFileName").val() == '' ){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='attachment' htmlEscape='false'/>");
        return false;
    }
    
    
    return true;
}

function fn_saveReopen(){
	if(fn_validation()){
       Common.ajax("POST", "/organization/compliance/saveComplianceReopen.do", $("#complianceReopenForm").serializeJSON(), function(result) {
           console.log("성공.");
           Common.alert("Compliance call Log saved.<br /> Case No : "+result.data+"<br />");
       }); 
   }
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Re-Open Compliance Call Log</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form method="post" id="complianceReopenForm" action="#">
<input type="text" title="" placeholder="" class="" id="memberId" name="memberId"  value="${memberId}"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Case Status</th>
    <td colspan="3">
    <select class="w100p"  id="caseStatus" name="caseStatus">
        <option value="12">Reopen</option>
    </select>
    </td>
    <th scope="row">Case Category</th>
    <td>
    <select class="w100p" id="caseCategory" name="caseCategory">
    </select>
    </td>
    <th scope="row">Type of Document</th>
    <td>
    <select class="w100p disabled" disabled="disabled" id="docType" name="docType">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Action</th>
    <td colspan="3">
    <select class="" id="action" name="action">
        <option value="">Action</option>
        <option value="56">Call In</option>
        <option value="57">Call Out</option>
        <option value="58">Internal Feedback</option>
    </select>
    </td>
    <th scope="row">Finding</th>
    <td colspan="3">
    <label><input type="radio" name="finding" /><span>Genuine</span></label>
    <label><input type="radio" name="finding" /><span>Non Genuine </span></label>
    </td>
</tr>
<tr>
    <th scope="row">Compliance F/Up</th>
    <td colspan="3">
    <select class="w100p disabled" disabled="disabled" id="comfup" name="comfup">
    </select>
    </td>
    <th scope="row">Collection Amount</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="readonly" readonly="readonly" id="collAmount" name="collAmount"/>
    </td>
</tr>
<tr>
    <th scope="row">Case Received Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="recevCaseDt" name="recevCaseDt" />
    </td>
    <th scope="row">Case Closed Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date disabled"  disabled="disabled" id="recevCloDt" name="recevCloDt"/>
    </td>
    <th scope="row">Final Action</th>
    <td colspan="3">
    <select class="disabled" disabled="disabled"  id="finalAction" name="finalAction">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Person In Charge</th>
    <td colspan="3">
    <select class="w100p disabled"  id="changePerson" name="changePerson" disabled="disabled">
        <option value="18522">NICKY</option>
        <option value="32807">EUGENE</option>
        <option value="34026">OOI BENG EAN</option>
        <option value="56056">WONG WENG KIT</option>
        <option value="57202">KATE</option>
        <option value="59697">PAVITRA</option>
    </select>
    </td>
    <th scope="row"></th>
    <td colspan="3">
    </td>
</tr>
<tr>
    <th scope="row">Compliance Remark</th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="" id="complianceRem" name="complianceRem"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_saveReopen()">Save</a></p></li>
</ul>

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
