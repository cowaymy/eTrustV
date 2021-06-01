<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
	background: #9FC93C;
	font-weight: bold;
	color: #22741C;
}
</style>
<script type="text/javascript">
	function fn_uploadFile() {

		if ($("#uploadfile").val() == null || $("#uploadfile").val() == "") {
			Common.alert("File not found. Please upload the file.");
		} else {

			var formData = new FormData();
			//formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]) ;
			formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);

			Common.ajaxFile("/organization/groupCsvUpload", formData, function(
					result) {

				console.log(result);
				Common.alert(result.message);

				fn_closePop();

			});
		}
	}

	function fn_closePop() {
		$("#groupFileUploadClose").click();
	}

	$(document).ready(function() {

	});
</script>



<div id="popup_wrap" class="popup_wrap size_mid">
	<!-- popup_wrap start -->

	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Group Transfer - File Upload</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a id="groupFileUploadClose" href="#">CLOSE</a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->

	<section class="pop_body">
		<!-- pop_body start -->


		<aside class="title_line">
			<!-- title_line start -->
			<h2>Group Transfer File Upload</h2>
		</aside>
		<!-- title_line end -->




		<table class="type1">
			<!-- table start -->
			<caption>table</caption>
			<colgroup>
				<col style="width: 130px" />
				<col style="width: *" />
			</colgroup>
			<tbody>

				<tr>
					<th scope="row">File</th>
					<td>
						<div class="auto_file">
							<!-- auto_file start -->
							<form id="fileUploadForm" method="post"
								enctype="multipart/form-data" action="">

								<input title="file add" type="file" id="uploadfile"
									name="uploadfile"> <label><span
									class="label_text"><a id="txtFileInput" href="#">File</a></span><input
									class="input_text" type="text" readonly="readonly"></label>
							</form>
						</div>
						<!-- auto_file end -->

					</td>
				</tr>

				<tr>
					<th scope="row" colspan="6"><span class="must">* Only
							accept CSV format. Max file size only 20MB. </span></th>
				</tr>
			</tbody>
		</table>
		<!-- table end -->
		<!-- <article class="grid_wrap">grid_wrap start

        <div id="grid_wrap_hide" style="display: none;"></div>
</article> -->

		<ul class="center_btns mt20">
			<li><p class="btn_blue2 big">
					<a href="javascript:fn_uploadFile();"><spring:message
							code='pay.btn.uploadFile' /></a>
				</p></li>
			<li><p class="btn_blue2 big">
					<a
						href="${pageContext.request.contextPath}/resources/download/organization/MemberOrgBatchTrans_Template.csv">Template
						Download</a>
				</p></li>
		</ul>
	</section>
	<!-- pop_body end -->

</div>
<!-- popup_wrap end -->