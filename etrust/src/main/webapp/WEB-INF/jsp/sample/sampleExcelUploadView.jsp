<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!--
sample 소스의 브라우저 스팩은 IE10 부터 지원 합니다.
그 이하는 https://github.com/malsup/form/ 여기에서 jquery.form.js 을 다운받고 import 해야합니다.
그리고 다음과 같이 ajaxForm 로 전송해야합니다.
-->

<script type="text/javaScript" language="javascript">

    function fn_uploadFile() {

        var formData = new FormData();
        formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
        formData.append("param01", "param01");
        formData.append("param02", "param02");

        Common.ajaxFile("/commission/excel/upload", formData, function (result) {
            Common.alert("완료~")
        });
    }

    function fn_uploadCsvFile() {

        var formData = new FormData();
        formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
        formData.append("param01", "param01");
        formData.append("param02", "param02");

        Common.ajaxFile("/commission/csv/upload", formData, function (result) {
            Common.alert("완료~")
        });
    }

    // 파일 다운로드는 db 설계에 따른 재 구현이 필요함.  현재는 단순 테스트용입니다.
    function fn_downFile() {

        var fileName = $("#fileName").val();

        //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
        //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
        window.open("<c:url value='/sample/down/excel-xlsx-streaming.do?fileName=" + fileName + "'/>");
    }
</script>

<form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">
    <input type="file" id="uploadfile" name="uploadfile"/>
    <input type="text" id="param01" name="param01"/>
    <a class="" href="javascript:fn_uploadFile();">[엑셀 전송]</a>
    <a class="" href="javascript:fn_uploadCsvFile();">[CSV 전송]</a>
</form>

<form id="fileDownForm">
    <input type="text" id="fileName" name="fileName" value="excelDownName"/>

    <a href="javascript:fn_downFile()">엑셀  다운로드</a>
</form>