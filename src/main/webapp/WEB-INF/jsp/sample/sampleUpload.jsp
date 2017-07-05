<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>sample file upload</title>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-2.2.4.min.js"></script>

<!-- 
sample 소스의 브라우저 스팩은 IE10 부터 지원 합니다.
그 이하는 https://github.com/malsup/form/ 여기에서 jquery.form.js 을 다운받고 import 해야합니다.
그리고 다음과 같이 ajaxForm 로 전송해야합니다.
 -->

<script type="text/javaScript" language="javascript">

	function fn_uploadFile() {
		
		/* 개별 처리.
		var formData = new FormData();
		
		formData.append("fileObj", $("#file01")[0].files[0]);
		formData.append("fileObj2", $("#file02")[0].files[0]);
		formData.append("param01", $("#param01").val());
		 */

		 var form = $("#fileUploadForm")[0];
		 var formData = new FormData(form);
		 
		$.ajax({
			url : "/sample/sampleUpload.do",
			processData : false,
			contentType : false,
			data : formData,
			type : "POST",
			success : function(result) {
				alert("업로드 성공!!  => " + result[0].fileName);
				alert(result.length);
				alert(JSON.stringify(result));
				$("#subPath").val(result[0].serverSubPath);
				$("#fileName").val(result[0].physicalName);
				$("#orignlFileNm").val(result[0].fileName);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("실패하였습니다.");
			},
			complete : function() {
			}
		});
	}
	
	// 파일 다운로드는 db 설계에 따른 재 구현이 필요함.  현재는 단순 테스트용입니다.
	function fn_downFile(){
		var subPath = $("#subPath").val();
		var fileName = $("#fileName").val();
		var orignlFileNm = $("#orignlFileNm").val();
		
		/*
[{"fileName":"Chrysanthemum.jpg","contentType":"image/jpeg","serverSubPath":"20170623","physicalName":"AB9B6F6CB51740799ECCD3DFA73ECD17","size":879394}]

		*/
		
        window.open("<c:url value='/file/FileDown.do?subPath=" + subPath + "&fileName=" + fileName + "&orignlFileNm=" + orignlFileNm + "'/>");
    }
</script>

</head>

<body>
	<form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">
		<input type="file" id="file01" name="fileTest"/>
		<input type="file" id="file02" name="fileTest"/>
		<input type="text" id="param01" name="param01"/>
		<a class="" href="javascript:fn_uploadFile();">전송</a>
	</form>
	
	<form id="fileDownForm">
        <input type="text" id="subPath" name="subPath"/>
        <input type="text" id="fileName" name="fileName"/>
        <input type="text" id="orignlFileNm" name="orignlFileNm"/>
        
        <a href="javascript:fn_downFile()">다운로드(단순 테스트 용입니다.)</a>
    </form>
</body>
</html>