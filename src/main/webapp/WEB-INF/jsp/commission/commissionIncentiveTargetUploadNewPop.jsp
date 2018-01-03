<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

/* 인풋 파일(멀티) start */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
}
setInputFile2();

/* $(document).on(//인풋파일 추가
    "click", ".auto_file2 a:contains('Add')", function(){
    
    $(".auto_file2:last-child").clone().insertAfter(".auto_file2:last-child");
    $(".auto_file2:last-child :file, .auto_file2:last-child :text").val("");
    return false;
}); */

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
			//Common.alert('No Sample to show for this upload type.');
		}else{
			if (val == "1062"){
				Common.popupDiv("/commission/calculation/incntivUploadSamplePop.do");
	        }else{
	        	Common.alert('<spring:message code="commission.alert.incentive.new.noSample"/>');
	        	//Common.alert('No Sample to show for this upload type.');
	        }
		};
	}

	//csv file upload save 
	function fn_uploadCsvFile(){
		if(fn_uploadValid()){
			Common.ajax("GET", "/commission/calculation/csvFileOverlapCnt", $("#newForm").serialize(), function(result) {
				if(result>0){
					Common.alert('<spring:message code="commission.alert.incentive.new.nonUpload"/>');
					//Common.alert('One active upload batch exist. New upload is disallowed.');
				}else{
					var formData = new FormData();
					formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
			        formData.append("type", $("#cmbType").val());
			        formData.append("memberType", $("#cmbMemberType").val());
			        
			        Common.ajaxFile("/commission/csv/upload", formData, function (result) {
			        	$("#search").click();
			        	document.newForm.reset();
			        	Common.alert('<spring:message code="commission.alert.incentive.new.success" arguments="'+result.data+'" htmlEscape="false"/>');
			        	//var cntId=result.data.uploadId;
			            //Common.alert("Your data has been posted.</br>Please confirm the batch for final setting.</br>Upload Batch ID : "+result);
			        });
				}
			});
		}
	}
	
	function fn_uploadValid(){
		if( $("#cmbType").val() == null || $("#cmbType").val() == ""){
			Common.alert('<spring:message code="sys.msg.first.Select" arguments="upload type" htmlEscape="false"/>');
			//Common.alert("Please select the upload type first.");
			return false;
		}
		if( $("#cmbMemberType").val() == null || $("#cmbMemberType").val() == ""){
			Common.alert('<spring:message code="commission.alert.incentive.new.noSample"/>');
			//Common.alert(" No Sample to show for this upload type");
            return false;
        }
		if( $("#uploadfile").val() == null || $("#uploadfile").val() == ""){
			Common.alert('<spring:message code="sys.alert.upload.csv"/>');
			//Common.alert("Please select your csv file.");
            return false;
        }
		return true;
	}
</script>
<div id="popup_wrap" class="popup_wrap size_mid">
	
	<header class="pop_header">
		<h1><spring:message code='commission.title.pop.head.incentiveNew'/></h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
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
						<select class="" name="cmbType" id="cmbType">
						   <option value=""></option>
							<option value="1062">Cody/HP Incentive</option>
							<option value="1063">Cody/HP Target</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
					<td>
						<select class="" name="cmbMemberType" id="cmbMemberType">
						   <option value=""></option>
							<c:forEach var="list" items="${memType }">
	                            <option value="${list.cdid}">${list.cdnm}(${list.cd})</option>
	                        </c:forEach> 
						</select>
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