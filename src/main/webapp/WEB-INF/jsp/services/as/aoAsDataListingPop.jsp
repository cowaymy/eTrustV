<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE            BY         VERSION      REMARK
 ----------------------------------------------------------------
 25/01/2021    KV            1.0.4       - Add AOAS Data Listing- Ombak

 -->

<script type="text/javascript">
	$(document).ready(function() {

	});

	function fn_validation() {
		if ($("#reqStrDate").val() != '') {
			if ($("#reqEndDate").val() == '') {
				Common
						.alert("<spring:message code='sys.common.alert.validation' arguments='Request Date' htmlEscape='false'/>");
				return false;
			}
		}
		if ($("#reqEndDate").val() != '') {
			if ($("#reqStrDate").val() == '') {
				Common
						.alert("<spring:message code='sys.common.alert.validation' arguments='Request Date' htmlEscape='false'/>");
				return false;
			}
		}
		return true;
	}

	function fn_openGenerate()
	{
		var date = new Date();
		var month = date.getMonth() + 1;
		var day = date.getDate();
		if (date.getDate() < 10) {
			day = "0" + date.getDate();
		}
		if (fn_validation()) {
			var reqDateFrom = "1900-01-01";
			var reqDateTo = "1900-01-01";
			var branchID =  $("#cmbbranchId1").val();
            alert (branchID);
			if ($("#reqStrDate").val() != '' && $("#reqEndDate").val() != ''
					&& $("#reqStrDate").val() != null
					&& $("#reqEndDate").val() != null) {
				reqDateFrom = $("#reqStrDate").val().substring(6, 10) + '-'
				        + $("#reqStrDate").val().substring(3, 5)+ '-'
						+ $("#reqStrDate").val().substring(0, 2);
				reqDateTo = $("#reqEndDate").val().substring(6, 10)+ '-'
						+ $("#reqEndDate").val().substring(3, 5)+ '-'
						+ $("#reqEndDate").val().substring(0, 2);
			}
			/* if ($("#cmbbranchId1").val() != '' && $("#cmbbranchId1").val() != null) { */
				/* branchID = $("#cmbbranchId1").val(); */
		/* 	} */

			$("#aoASDataList #V_REQDATEFROM").val(reqDateFrom);
			$("#aoASDataList #V_REQDATETO").val(reqDateTo);
			$("#aoASDataList #V_CODYBRANCH").val(branchID);

			$("#aoASDataList #reportFileName").val(
					'/services/AOASDataListing.rpt');
			$("#aoASDataList #viewType").val("EXCEL");
			$("#aoASDataList #reportDownFileName").val(
					"AOASDataListing_" + day + month + date.getFullYear());

			var option = {
				isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
			};

			Common.report("aoASDataList", option);
		}
	}

	$.fn.clearForm = function() {
		return this.each(function() {
			var type = this.type, tag = this.tagName.toLowerCase();
			if (tag === 'form') {
				return $(':input', this).clearForm();
			}

			if (type === 'text' || type === 'password' || type === 'hidden'
					|| tag === 'textarea') {
				this.value = '';
			} else if (type === 'checkbox' || type === 'radio') {
				this.checked = false;
			} else if (tag === 'select') {
				this.selectedIndex = 0;
			}
		});
	};
</script>

<div id="popup_wrap" class="popup_wrap">

	<!-- popup_wrap start -->
	<header class="pop_header">
		<!-- pop_header start -->
		<h1>
			<spring:message code='service.btn.aoAsDataListOmbak' />
		</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code='sys.btn.close' /></a>
				</p></li>
		</ul>
	</header>

	<section class="pop_body">
		<!-- pop_body start -->

		<section class="search_table">
			<!-- search_table start -->
			<form action="#" id="aoASDataList">
				<input type="hidden" id="V_REQDATEFROM" name="V_REQDATEFROM" />
				<input type="hidden" id="V_REQDATETO" name="V_REQDATETO" />
				<input type="hidden" id="V_CODYBRANCH" name="V_CODYBRANCH" />
                <!--reportFileName,  viewType 모든 레포트 필수값 -->
				<input type="hidden" id="reportFileName" name="reportFileName" />
				<input type="hidden" id="viewType" name="viewType" />
				<input type="hidden" id="reportDownFileName" name="reportDownFileName"	value="DOWN_FILE_NAME" />

				<table class="type1">
				<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 190px" />
						<col style="width: *" />
						<!-- <col style="width: 130px" />
                        <col style="width: *" /> -->
					</colgroup>

					<tbody>
						<tr>
							<th scope="row"><spring:message code='service.grid.ReqstDt' /></th>
							<td>
								<div class="date_set">
									<!-- date_set start -->
									<p>
										<input type="text" title="Create start Date"
											placeholder="DD/MM/YYYY" class="j_date" id="reqStrDate"
											name="reqStrDate" />
									</p>
									<span>To</span>
									<p>
										<input type="text" title="Create end Date"
											placeholder="DD/MM/YYYY" class="j_date" id="reqEndDate"
											name="reqEndDate" />
									</p>
								</div> <!-- date_set end -->
							</td>
						</tr>
						<tr>
							<th scope="row"><spring:message
									code='service.title.CodyBranch' /> <span class='must'>
									*</span></th>
							<td><select id="cmbbranchId1" name="cmbbranchId1">
									<option value="0"><spring:message
											code='service.title.allCodyBranch' /></option>
									<c:forEach var="list" items="${branchList}" varStatus="status">
										<option value="${list.codeId}">${list.codeName}</option>
									</c:forEach>
							</select>
						</tr>
					</tbody>
				</table>
				<!-- table end -->
			</form>
		</section>
		<!-- search_table end -->

		<ul class="center_btns">
			<li><p class="btn_blue2 big">
					<a href="#" onclick="javascript:fn_openGenerate()"><spring:message
							code='service.btn.Generate' /></a>
				</p></li>
			<li><p class="btn_blue2 big">
					<a href="#" onclick="javascript:$('#aoASDataList').clearForm();"><spring:message
							code='service.btn.Clear' /></a>
				</p></li>
			</p>
			</li>
		</ul>
	</section>
	<!-- pop_body end -->
</div>
<!-- popup_wrap end -->