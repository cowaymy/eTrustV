<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

$(document).ready(function(){  
    
         setInputFile2();
});


function fn_attachFile(){
	
	if($("#fileName").val() ==""){
		Common.alert('<spring:message code="sal.alert.selectFile" />');
		return;
	}else{
		var str = $("#fileName").val().split(".");

		if(str[str.length-1] != "zip"){
	        Common.alert('<spring:message code="sal.alert.notZip" />');
			return;
		}else{

		    var formData = Common.getFormData("attachTrForm");
		    formData.append("trAttItmId", $("#trAttItmId").val());
	        formData.append("trAttStusId", $("#trAttStusId").val());
	        
	        formData.append("trAttFeedback", $("#trAttFeedback").val());
	        formData.append("trAttTrNo", $("#trAttTrNo").val());
	        formData.append("trAttRemark", $("#trAttRemark").val());
	        formData.append("trAttBookId", $("#trAttBookId").val());
	        formData.append("trAttBookNo", $("#trAttBookNo").val());
			
			 Common.ajaxFile("/sales/trBook/updateReportLost", formData, function(result)    {
			       
			        console.log("성공." + JSON.stringify(result));
			        console.log("data : " + result.cnt);

			        Common.alert("Record Saved" + DEFAULT_DELIMITER + result.massage);

			        $("#fileUploadPop").remove();
			        fn_selectReBookListAjax(); 
			        
			     }
			     , function(jqXHR, textStatus, errorThrown){
			            try {
			                console.log("Fail Status : " + jqXHR.status);
			                console.log("code : "        + jqXHR.responseJSON.code);
			                console.log("message : "     + jqXHR.responseJSON.message);
			                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
			          }
			          catch (e)
			          {
			            console.log(e);
			          }
			          Common.alert('<spring:message code="sal.alert.title.error" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.trBookLost" />');
			    });
		}
	}
}

function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input id='fileName' name='fileName' type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
}
</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.fileUpload" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post" id="attachTrForm" name="attachTrForm" enctype="multipart/form-data">
	<input type="hidden" id="trAttItmId" name="trAttItmId" value="${trBookItmId }">
	<input type="hidden" id="trAttStusId" name="trAttStusId" value="${trStusId }">
	
	<input type="hidden" id="trAttFeedback" name="trAttFeedback" value="${trAttFeedback }">
	<input type="hidden" id="trAttTrNo" name="trAttTrNo" value="${trAttTrNo }">
	<input type="hidden" id="trAttRemark" name="trAttRemark" value="${trAttRemark }">
	<input type="hidden" id="trAttBookId" name="trAttBookId" value="${trAttBookId }">
	<input type="hidden" id="trAttBookNo" name="trAttBookNo" value="${trAttBookNo }">

<aside class="title_line"><!-- title_line start -->
<h2 class="fl_right"><spring:message code="sal.page.subTitle.attachment" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.attachment" /></th>
	<td>
	<div class="auto_file2">
	<input type="file" title="file add" style="width:100px" />
	</div>
		<!-- <div class="attach_fileNm"><span class="red_text">*</span> 20170720_162806.jpg <a href="#" class="remove">x</a></div> -->
	</td>
</tr>
<tr>
	<td scope="row" colspan="2"><span class="red_text"><spring:message code="sal.text.fileExtension" /></span></td>
</tr>
</tbody>
</table><!-- table end -->

</form>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" onclick="fn_attachFile();"><spring:message code="sal.btn.updAttachment" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->