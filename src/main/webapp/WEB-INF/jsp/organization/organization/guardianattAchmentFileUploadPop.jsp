<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

$(document).ready(function(){  
    
         setInputFile2();
});


function fn_attachFile(){
	 
	if($("#fileName").val() ==""){
		alert("Please select a file.");
		return;
	}else{
		var str = $("#fileName").val().split(".");
		if(str[1] != "jpg"){
	        alert("Not a zip file.");
			return;
		}else{
		    
			var date = new Date();
			var day = date.getDate();
			if(date.getDate() < 10){
				day = "0"+date.getDate(); 
			}
		     var newName = day+(date.getMonth()+1)+date.getFullYear()+date.getHours()+date.getMinutes()+date.getSeconds();
		     
		     
		    var formData = Common.getFormData("attachTrForm");
		    formData.append("targetFolder", $("#targetFolder").val());
		    formData.append("fileName", newName);
			 Common.ajaxFile("/organization/compliance/updateGuardianFile", formData, function(result)    {
			       
			        console.log("성공." + JSON.stringify(result));
			        console.log("data : " + result.cnt);

			        Common.alert(result.message);
			        
			       $("#hidFileName").val("/WebShare/Guardian/Guardian/" + newName);
			       $("#fileUploadPop").remove();
			        
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
			          Common.alert("Failed to Upload. Please try again later.");
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
<h1>ATTACHEMENT FILE UPLOAD</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post" id="attachTrForm" name="attachTrForm" enctype="multipart/form-data">
	<input type="hidden" id="targetFolder" name="targetFolder" value="/WebShare/Guardian/">
	
<aside class="title_line"><!-- title_line start -->
<h2 class="fl_right">*** Attachment file will be replace if you re-upload the file.</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Attachment</th>
	<td>
	<div class="auto_file2">
	<input type="file" title="file add" style="width:100px" />
	</div>
		<!-- <div class="attach_fileNm"><span class="red_text">*</span> 20170720_162806.jpg <a href="#" class="remove">x</a></div> -->
	</td>
</tr>
<tr>
	<td scope="row" colspan="2"><span class="red_text">Allowed file extension : .jpg || Allowed file size : <= 6MB</span></td>
</tr>
</tbody>
</table><!-- table end -->

</form>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" onclick="fn_attachFile();">Upload Attachment</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->