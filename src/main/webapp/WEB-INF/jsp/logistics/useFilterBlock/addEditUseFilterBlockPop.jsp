
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
var prdCat = [
              {"codeId" : "54","codeName":"Water Purifier"},
              {"codeId" : "55","codeName":"Air Purifier"}
          ];

var prdType = [
              {"codeId" : "62","codeName":"Filter"},
              {"codeId" : "63","codeName":"Spare Part"}
          ];

var prdStatus = [
               {"codeId" : "1","codeName":"Active"},
               {"codeId" : "8","codeName":"Inactive"}
           ];


	$(document).ready(
			function() {
				doDefCombo(prdCat, '', '_stkCategory', 'S' , 'fn_setOptGrpClass');
				doDefCombo(prdType, '', '_stkType', 'S' , 'fn_setOptGrpClass');
				doDefCombo(prdStatus, '', '_status', 'S' , 'fn_setOptGrpClass');

				type = "${viewType}";

				if(type == 2){
					$("#_stkCategory").val('${useFilterBlockInfo.stkCategoryId}');
					$("#_stkType").val('${useFilterBlockInfo.stkTypeId}');
					//$("#_stkId").val('${useFilterBlockInfo.stkId}');
				    $("#_status").val('${useFilterBlockInfo.defectStatus}');

					doGetComboData('/common/selectFilterList.do', {stkTypeId: $("#_stkType").val(), stkCtgryId:$('#_stkCategory').val()}, '${useFilterBlockInfo.stkId}' , '_stkId', 'S', '');//product 생성

					$("#_stkCategory").prop("disabled", true);
					$("#_stkType").prop("disabled", true);
					$("#_stkId").prop("disabled", true);
				}

			});

	function fn_save() {

		if ($("#_stkCategory").val() == "") {
			Common.alert("* Please select Category");
			return false;
		}

		if ($("#_stkType").val() == "") {
			Common.alert("* Please select Type");
			return false;
		}

		if ($("#_stkId").val() == "") {
			Common.alert("* Please select Material Code");
			return false;
		}

		if ($("#_status").val() == "") {
			Common.alert("* Please select Status");
			return false;
		}

		var useFilterBlock = {
			viewType : '${viewType}',
			stkId : $("#_stkId").val(),
			status : $("#_status").val()
		}

		var saveForm = {
			"useFilterBlock" : useFilterBlock
		}

		Common.ajax("POST",
				"/logistics/useFilterBlock/saveUseFilterBlock.do",
				saveForm, function(result) {
					Common.alert(result.message, fn_close);
					$("#popup_wrap").remove();
					fn_selectListAjax();
				});
	}

	$(function() {
		$("#_stkType").change(function() {
			fn_setFilterList();
		});
		$("#_stkCategory").change(function() {
			fn_setFilterList();
		});


	});

	function fn_setFilterList(){
		doGetComboData('/common/selectFilterList.do', {stkTypeId: $("#_stkType").val(), stkCtgryId:$('#_stkCategory').val()}, '' , '_stkId', 'S', '');//product 생성

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
			<c:if test="${viewType eq  '1' }"> Add Used Filter Block</c:if>
			<c:if test="${viewType eq  '2' }"> Edit Used Filter Block</c:if>
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
			<section class="search_table">
				<!-- search_table start -->
				<form action="#" method="post" id='addEditUseFilterBlockForm'
					name='addEditUseFilterBlockForm'>
					<div style="display: none"></div>
					<table class="type1">
						<!-- table start -->
						<caption>table</caption>
						<tbody>
							<tr>
								<th scope="row">Category</th>
								<td><select class="w100p" id="_stkCategory" name="_stkCategory"></select></td>
							</tr>
							<tr>
								<th scope="row">Type</th>
								<td><select class="w100p" id="_stkType" name="_stkType"></select></td>
							</tr>
							<tr>
								<th scope="row">Material Code</th>
								<td><select class="w100p" id="_stkId" name="_stkId">
								</select></td>
							</tr>
							<tr>
								<th scope="row">Status</th>
								<td><select class="w100p" id="_status" name="_status">
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
