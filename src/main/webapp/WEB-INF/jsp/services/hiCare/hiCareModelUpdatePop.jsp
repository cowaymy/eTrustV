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
			if (val == "6465"){
				Common.popupDiv("/commission/calculation/nonIncntivUploadSamplePop.do");
	        }else{
	        	Common.alert('<spring:message code="commission.alert.incentive.new.noSample"/>');
	        	//Common.alert('No Sample to show for this upload type.');
	        }
		};
	}

	//csv file upload save
	function fn_uploadCsvFile(){
		if(fn_uploadValid()){

			var formData = new FormData();
            formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);

            console.log("upload 1");
            Common.ajaxFile("/services/hiCare/uploadModelCsv", formData, function (result) {
            	console.log("upload 2");
            	$("#search").click();
            	$('#modelUpdatePop').remove();
                //document.newForm.reset();
                Common.alert('Model Update Successfully.');
            });
		}
	}

	function fn_uploadValid(){
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
		<h1>Model Update</h1>
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
			<%-- <li><p class="btn_blue"><a href="javascript:fn_sampleFormat($('#cmbType').val());"><spring:message code='commission.button.sampleFormat'/></a></p></li> --%>
			<li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/service/HiCareModelUpdateUploadFormat.csv"><spring:message code='commission.button.dwCsvFormat'/></a></p></li>
		</ul>

	</section>

</div>