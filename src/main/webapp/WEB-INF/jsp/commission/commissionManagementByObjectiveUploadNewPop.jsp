<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

$(document).ready(function() {

	doGetCombo('/common/selectCodeList.do', '406', ''  ,'cmbType', 'S' , '');
	doGetCombo('/common/selectCodeList.do', '1', '2'  ,'cmbMemberType', 'S' , '');

});
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
	//sampleformet pop button
	function fn_sampleFormat(val){
		if(val == null || val ==""){
			Common.alert('<spring:message code="commission.alert.incentive.new.noSample"/>');
		}else{
			if (val == "1062"){
				Common.popupDiv("/commission/calculation/incntivUploadSamplePop.do");
	        }else{
	        	Common.alert('<spring:message code="commission.alert.incentive.new.noSample"/>');
	        }
		};
	}

	//csv file upload save
	function fn_uploadCsvFile(){
		if(fn_uploadValid()){
			Common.ajax("GET", "/commission/calculation/mboActiveUploadBatch", $("#newForm").serialize(), function(result) {
				if(result>0){
					Common.alert('<spring:message code="commission.alert.incentive.new.nonUpload"/>');
				}else{
					var formData = new FormData();
					formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
			        formData.append("type", $("#cmbType").val());
			        formData.append("memberType", $("#cmbMemberType").val());

			        Common.ajaxFile("/commission/csv/mboUpload", formData, function (result) {
			        	$("#search").click();
			        	document.newForm.reset();
			        	Common.alert('<spring:message code="commission.alert.incentive.new.success" arguments="'+result+'" htmlEscape="false"/>',$("#popClose").click());
			        });
				}
			});
		}
	}

	function fn_uploadValid(){
		if( $("#cmbType").val() == null || $("#cmbType").val() == ""){
			Common.alert('<spring:message code="sys.msg.first.Select" arguments="upload type" htmlEscape="false"/>');
			return false;
		}
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
		<h1><spring:message code='commission.title.pop.head.mboNew'/></h1>
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
				<tr>
					<th scope="row"><spring:message code='commission.text.search.type'/></th>
					<td>
						<select class="" name="cmbType" id="cmbType"></select>
					</td>
				</tr>
				<tr>
					<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
					<td>
						<select name="cmbMemberType" id="cmbMemberType" class="disabled" disabled></select>
						<input type="hidden" id="cmbMemberType" name="cmbMemberType" value="2" />
					</td>
				</tr>
				<tr>
					<th scope="row"><spring:message code='commission.text.search.file'/></th>
					<td>
	   					 <div class="auto_file attachment_file "><!-- auto_file start -->
	   					 <!-- <div class="auto_file"> --><!-- auto_file start -->
	       					<input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
	   					 </div>
					</td>
				</tr>
			</tbody>
		</table>
		</form>
		<ul class="center_btns">
			<li><p class="btn_blue"><a href="javascript:fn_uploadCsvFile();"><spring:message code='commission.button.uploadFile'/></a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_sampleFormat($('#cmbType').val());"><spring:message code='commission.button.sampleFormat'/></a></p></li>
			<li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/IncentiveTargetUploadFormat.csv"><spring:message code='commission.button.dwCsvFormat'/></a></p></li>
		</ul>

	</section>

</div>