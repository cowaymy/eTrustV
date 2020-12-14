<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
#neContent{
    height: 300px;
    width: 100%;
}
</style>
<script type="text/javaScript">
$(document).ready(function() {
	  doGetCombo('/common/selectCodeList.do','458', '', 'nreasonCat', 'S', '');
});

function fn_winClose(){
	//$("#newClose").click();
	$("#popup_wrap_new").remove();
	fn_searchList();
}

function fn_saveHasratCody() {

     if (validRequiredField()){
       Common.ajax("GET","/organization/saveHasratCody", $("#newHForm").serialize(), function(result){
           console.log(result);
           Common.alert("Record successfully saved.",fn_winClose);
       });
   }

}

function validRequiredField() {
	if($("#ncodyEmail").val() == ''){
		Common.alert("Cody Email is required.");
		return false;
	}

	if($("#ncodyName").val() == ''){
        Common.alert("Cody Name is required.");
        return false;
    }

	if($("#ncodyCode").val() == ''){
        Common.alert("Cody Code is required.");
        return false;
    }

	if($("#nbranchCode").val() == ''){
        Common.alert("Branch Code is required.");
        return false;
    }

	if($("#ncontactNumber").val() == ''){
        Common.alert("Contact Number is required.");
        return false;
    }

	if($("#nreasonCat").val() == ''){
        Common.alert("Please select reason category.");
        return false;
    }

	//debugger;
	if($("#neContent").val() == ''){
        Common.alert("Content is required.");
        return false;
    } else {
    	var oriContent = $("#neContent").val();
    	$("#neContent").val(oriContent.replace(/\r\n|\r|\n/g,"<br />"));
    }

	var mailformat = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

	if (mailformat.test($("#ncodyEmail").val()))
	{
	    return true;
	} else {
		Common.alert("You have entered an invalid email address");
	    return false;
	}

	return false;
}
</script>
<div id="popup_wrap_new" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>New Hasrat Cody Record</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="newClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<ul class="right_btns">
    <li><p class="red_text"><spring:message code="sal.title.text.compulsoryField" /></p></li>
</ul>

<form id="newHForm" name="newHForm">
<input type="hidden" name="ncodyId" id="ncodyId" value="${userInfo.defaultUserId }"/>
<input type="hidden" name="ncmCode" id="ncmCode" value="${userInfo.defaultCmCode}"/>
<input type="hidden" name="nscmCode" id="nscmCode" value="${userInfo.defaultScmCode}"/>
<input type="hidden" name="ngcmCode" id="ngcmCode" value="'${userInfo.defaultGcmCode}"/>
<input type="hidden" name="nbranchId" id="nbranchId" value="${userInfo.defaultBranchId}"/>

<table class="type1">
<caption>New Record</caption>
<colgroup>
    <col style="width:250px" />
    <col style="width:*" />
</colgroup>
<tbody>
	<tr>
	    <th scope="row">Cody Email<span class="must">*</span></th>
	    <td><input type="text" name="ncodyEmail" id="ncodyEmail" maxlength="100" class="w100p" /></td>
	</tr>
	<tr>
	    <th scope="row">Cody Name<span class="must">*</span></th>
	    <td><input type="text" name="ncodyName" id="ncodyName" class="w100p" value="${userInfo.defaultName}"/></td>
	</tr>
	<tr>
        <th scope="row">Cody Code<span class="must">*</span></th>
        <td>
            <input type="text" name="ncodyCode" id="ncodyCode" class="w100p" value="${userInfo.defaultUserCode}" readonly/>
        </td>
    </tr>
	<tr>
        <th scope="row">Branch Code<span class="must">*</span></th>
        <td>
            <input type="text" name="nbranchCode" id="nbranchCode" class="w100p" value="${userInfo.defaultBranch}" readonly/>
        </td>
    </tr>
	<tr>
        <th scope="row">Contact Number<span class="must">*</span></th>
        <td><input type="text" name="ncontactNumber" id="ncontactNumber" class="w100p" value="${userInfo.defaultContact}"/></td>
    </tr>
	<tr>
        <th scope="row">Please Select One Reason<span class="must">*</span></th>
        <td><select id="nreasonCat" name='nreasonCat' class="w100p"></select></td>
    </tr>
	<tr>
        <th scope="row">Content<span class="must">*</span></th>
        <td>
        <textarea cols="20" rows="10" id="neContent" name="neContent" placeholder="Email Content"></textarea>
        </td>
    </tr>
</tbody>
</table>
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="javascript:fn_saveHasratCody();" >SAVE</a></p></li>
</ul>
</section><!-- pop_body end -->
</div> <!-- popup_wrap end -->
