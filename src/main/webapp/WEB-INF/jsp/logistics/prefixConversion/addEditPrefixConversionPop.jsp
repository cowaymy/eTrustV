
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>

/* 커스텀 행 스타일 */
.my-row-style {
	background: #FFB2D9;
	font-weight: bold;
	color: #22741C;
}
</style>
<script type="text/javaScript" language="javascript">
	$(document).ready(
			function() {
						doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'prefixStkId', 'S', 'fn_setOptGrpClass');//product 생성
					    doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'prefixConvStkId', 'S', 'fn_setOptGrpClass');//product 생성


				type = "${viewType}";

				if(type == 2){
					$("#prefixConfigId").val('${prefixConfigInfo.prefixConfigId}');
					$("#prefixStkId").val('${prefixConfigInfo.prefixStkId}');
				    $("#prefixConvStkId").val('${prefixConfigInfo.prefixConvStkId}');
				    $("#useYn").val('${prefixConfigInfo.useYn}');
				}

			});

	function fn_save() {

		if ($("#prefixStkId").val() == "") {
			Common.alert("* Please select Material Code");
			return false;
		}

		if ($("#prefixConvStkId").val() == "") {
			Common.alert("* Please select Prefix Conversion Material Code");
			return false;
		}

		var prefixConversion = {
			viewType : '${viewType}',
			useYn : $("#useYn").val(),
			prefixConfigId : $("#prefixConfigId").val(),
			prefixStkId : $("#prefixStkId").val(),
			prefixConvStkId : $("#prefixConvStkId").val()

		}

		var saveForm = {
			"prefixConversion" : prefixConversion
		}

		Common.ajax("POST",
				"/logistics/prefixConversion/savePrefixConversion.do",
				saveForm, function(result) {
					Common.alert(result.message, fn_close);
					$("#popup_wrap").remove();
					fn_selectListAjax();
				});
	}

	function fn_close() {
		$("#popup_wrap").remove();
	}

	function fn_setOptGrpClass() {
	    $("optgroup").attr("class" , "optgroup_text")
	}
</script>


<div id="popup_wrap" class="popup_wrap ">
	<!-- popup_wrap start -->

	<header class="pop_header">
		<!-- pop_header start -->
		<h1>
			<c:if test="${viewType eq  '1' }"> Add Prefix Conversion</c:if>
			<c:if test="${viewType eq  '2' }"> Edit Prefix Conversion</c:if>
		</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#" id="btnClose"><spring:message code="sal.btn.close" /></a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->

	<section class="pop_body" style="height: 200px">
		<!-- pop_body start -->

		<form action="#" id="saveForm" name="saveForm" method="post"
			onsubmit="return false;">
			<input type="hidden" id="prefixConfigId" name="prefixConfigId" value="">

			<section class="search_table">
				<!-- search_table start -->
				<form action="#" method="post" id='addEditPrefixForm'
					name='addEditPrefixForm'>
					<div style="display: none"></div>
					<table class="type1">
						<!-- table start -->
						<caption>table</caption>
						<tbody>
							<tr>
								<th scope="row">Material Code</th>
								<td><select class="w100p" id="prefixStkId"
									name="prefixStkId"></select></td>
							</tr>
							<tr>
								<th scope="row">Prefix Conversion Material Code</th>
								<td><select class="w100p" id="prefixConvStkId"
									name="prefixConvStkId"></select></td>
							</tr>
							<tr>
								<th scope="row">Use (Y/N)</th>
								<td><select class="w100p" id="useYn" name="useYn">
										<option selected value="Y">Y</option>
										<option value="N">N</option>
								</select></td>
							</tr>

						</tbody>
					</table>
					<!-- table end -->
				</form>
			</section>
			<!-- search_table end -->


			<ul class="center_btns">
				<li><p class="btn_blue2">
						<a href="#" id="btn_save" onclick="javascript:fn_save()"><spring:message
								code="sal.btn.save" /></a>
					</p></li>
			</ul>
		</form>

	</section>

</div>
