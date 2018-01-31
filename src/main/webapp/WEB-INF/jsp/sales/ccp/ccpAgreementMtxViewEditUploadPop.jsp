<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

$(document).ready(function() {
	
	//input setting
	setInputFile2();
	
	
	//Upload
	$("#_fileUpBtn").click(function() {
	    
		var fileName = $("#_fileName").val();
		
		if(null == fileName || '' == fileName){
			
			Common.alert('<spring:message code="sal.alert.msg.selFile" />');
			return;
			
		}
		//Upload Start
		
		//$("#_fileName").val($("#_updMsgId").val());
		
		var formData = Common.getFormData("_uploadForm");
		formData.append("updMsgId", $("#_updMsgId").val());
		
		Common.ajaxFile("/sales/ccp/uploadCcpFile.do", formData, function(result){
			$("#_uploadCloseBtn").click();
			Common.setMsg("<spring:message code='sys.msg.success'/>");
			
		}, function (jqXHR, textStatus, errorThrown) {
            Common.alert("<spring:message code='sys.msg.fail'/>");
            Common.setMsg("<spring:message code='sys.msg.fail'/>");
        });
	});
	
});

function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Delete</a></span>");
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->



<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.attchFileUpload" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_uploadCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p><spring:message code="sal.page.subTitle.attachment" /></p></li>
</ul>
<form id="_uploadForm" method="post" enctype="multipart/form-data">
<input type="hidden" id="_updMsgId" name="updMsgId" value="${msgId}">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2"><spring:message code="sal.text.attachment" /></th>
    <td>
     <div class="auto_file2"><!-- auto_file start -->
        <input type="file" title="file add" style="width:300px" id="_fileName"/>
    </div><!-- auto_file end -->
    </td>
</tr>
<tr>
    <td colspan="2"><p><span class="red_text"><spring:message code="sal.text.fileExtension" /></span></p></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_fileUpBtn"><spring:message code="sal.btn.updAttachment" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->