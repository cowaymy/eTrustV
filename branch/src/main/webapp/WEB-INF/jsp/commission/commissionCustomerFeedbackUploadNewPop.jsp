<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

/* 인풋 파일(멀티) start */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
}
setInputFile2();

$(document).on(//인풋파일 삭제
    "click", ".auto_file a:contains('Delete')", function(){
    var fileNum=$(".auto_file").length;

    if(fileNum <= 1){

    }else{
        $(this).parents(".auto_file1").remove();
    }
    return false;
});
/* 인풋 파일(멀티) end */

	//csv file upload save
	function fn_uploadCsvFile(){
		if(fn_uploadValid()){
			Common.ajax("GET", "/commission/calculation/cffActiveUploadBatch", $("#newForm").serialize(), function(result) {
				if(result>0){
					Common.alert('<spring:message code="commission.alert.incentive.new.nonUpload"/>');
				}else{
					var formData = new FormData();
					formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
			        formData.append("memberType", $("#cmbMemberType").val());

			        Common.ajaxFile("/commission/csv/cffUpload", formData, function (result) {
			        	$("#search").click();
			        	document.newForm.reset();
			        	Common.alert('<spring:message code="commission.alert.incentive.new.success" arguments="'+result+'" htmlEscape="false"/>',$("#popClose").click());
			        });
				}
			});
		}
	}

	function fn_uploadValid(){
		if( $("#cmbMemberType").val() == null || $("#cmbMemberType").val() == ""){
			Common.alert('<spring:message code="commission.alert.incentive.new.noSample"/>');
            return false;
        }
		if( $("#uploadfile").val() == null || $("#uploadfile").val() == ""){
			Common.alert('<spring:message code="sys.alert.upload.csv"/>');
            return false;
        }
		return true;
	}
</script>
<div id="popup_wrap" class="popup_wrap size_mid">

	<header class="pop_header">
		<h1><spring:message code='commission.title.pop.head.cffNew'/></h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
	</header>

	<section class="pop_body">

		<form id="newForm" name="newForm">
		<table class="type1 mt10">
			<caption>table</caption>
			<colgroup>
				<col style="width:150px" />
				<col style="width:*" />
			</colgroup>
			<tbody>
				<%-- <tr>
					<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
					<td>
						<select name="cmbMemberType" id="cmbMemberType" class="disabled" disabled></select>
					</td>
				</tr> --%>
				<tr>
					<th scope="row"><spring:message code='commission.text.search.file'/></th>
					<td>
	   					 <div class="auto_file attachment_file "><!-- auto_file start -->
	   					 <!-- <div class="auto_file"> --><!-- auto_file start -->
	   					 <input type="hidden" id="cmbMemberType" name="cmbMemberType" value="2" />
	       					<input type="file" title="file add"  id="uploadfile" name="uploadfile"/>

	   					 </div>
					</td>
				</tr>
			</tbody>
		</table>
		</form>
		<ul class="center_btns">
			<li><p class="btn_blue"><a href="javascript:fn_uploadCsvFile();"><spring:message code='commission.button.uploadFile'/></a></p></li>
			<li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/CFF_UploadFormat.csv"><spring:message code='commission.button.dwCsvFormat'/></a></p></li>
		</ul>

	</section>

</div>