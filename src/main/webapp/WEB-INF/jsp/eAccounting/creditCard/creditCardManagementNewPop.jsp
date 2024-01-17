<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
	var approveLineGridID;
	var selectRowIdx;
	/* 인풋 파일(멀티) */
	function setInputFile2() {//인풋파일 세팅하기
		$(".auto_file2")
				.append(
						"<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
	}

	function fn_saveNewMgmt() {
		var length = AUIGrid.getGridData(approveLineGridID).length;

		if(length == 0){
            Common.alert('Approval Line must have at least 1 record.');
           	return false;
		}

	    if(length >= 1) {
	        for(var i = 0; i < length; i++) {
	            if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
	                Common.alert('<spring:message code="approveLine.userId.msg" />' + (i +1) + ".");
	               	return false;
	                break;
	            }
	        }
	    }

 		if(fn_checkEmpty()) {
 			fn_checkIfFinalApproverExistInApprovalLine();
 		}
	}

	function fn_checkIfFinalApproverExistInApprovalLine(){
		Common.ajax("GET", "/eAccounting/creditCard/getFinalApprover.do", {clmType:"J3"}, function(result) {
			if(result.code == "00"){
				if(result.data != null && result.data.apprMemCode !="") {
					/*
					* Check final approver exist in approval line
					*/
					var finalAppvExist = false;
			        for(var i = 0; i < AUIGrid.getGridData(approveLineGridID).length; i++) {
			        	var appvLineMemCode = AUIGrid.getCellValue(approveLineGridID, i, "memCode");

			        	if(appvLineMemCode.toUpperCase() == result.data.apprMemCode.toUpperCase()){
			        		finalAppvExist  = true;
			        	}
			        }

			        if(finalAppvExist){
			    		Common.popupDiv("/eAccounting/creditCard/newRegistMsgPop.do", null,
								null, true, "registMsgPop");
			        }
			        else{
			            Common.alert('Final approver is not found in approval line.');
			            return false;
			        }
				}
				else{
		            Common.alert('Final approver is not found in system. Please contact IT.');
		            return false;
				}
			}
			else{
	            Common.alert('Final approver is not found in system. Please contact IT.');
	            return false;
			}
		});
	}

	/*
	 * Approval Line Code Section
	 */

	var approveLineColumnLayout = [
			{
				dataField : "approveNo",
				headerText : '<spring:message code="approveLine.approveNo" />',
				dataType : "numeric",
				expFunction : function(rowIndex, columnIndex, item, dataField) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
					// expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
					return rowIndex + 1;
				}
			},
			{
				dataField : "memCode",
				headerText : '<spring:message code="approveLine.userId" />',
				colSpan : 2
			},
			{
				dataField : "",
				headerText : '',
				width : 30,
				renderer : {
					type : "IconRenderer",
					iconTableRef : {
						"default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"// default
					},
					iconWidth : 24,
					iconHeight : 24,
					onclick : function(rowIndex, columnIndex, value, item) {
						console.log("selectRowIdx : " + selectRowIdx);
						selectRowIdx = rowIndex;
						fn_searchUserIdPopForApprovalLine();
					}
				},
				colSpan : -1
			},
			{
				dataField : "name",
				headerText : '<spring:message code="approveLine.name" />',
				style : "aui-grid-user-custom-left"
			},
			{
				dataField : "",
				headerText : '<spring:message code="approveLine.addition" />',
				renderer : {
					type : "IconRenderer",
					iconTableRef : {
						"default" : "${pageContext.request.contextPath}/resources/images/common/btn_plus.gif"// default
					},
					iconWidth : 12,
					iconHeight : 12,
					onclick : function(rowIndex, columnIndex, value, item) {
						var rowCount = AUIGrid.getRowCount(approveLineGridID);
						if (rowCount > 8) {
							Common
									.alert('Approval lines can be up to 9 levels.');
						} else {
							fn_appvLineGridAddRow();
						}

					}
				}
			} ];

	//그리드 속성 설정
	var approveLineGridPros = {
		// 페이징 사용
		usePaging : true,
		// 한 화면에 출력되는 행 개수 20(기본값:20)
		pageRowCount : 20,
		showStateColumn : true,
		// 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
		enableRestore : true,
		showRowNumColumn : false,
		softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
		softRemoveRowMode : false,
		// 셀 선택모드 (기본값: singleCell)
		selectionMode : "multipleCells"
	};

	function fn_appvLineGridAddRow() {
		var rowCount = AUIGrid.getRowCount(approveLineGridID);
		if (rowCount > 8) {
			Common
					.alert('Approval lines can be up to 9 levels.');
			return false;
		}

		AUIGrid.addRow(approveLineGridID, {}, "first");
	}

	function fn_appvLineGridDeleteRow() {
		if(selectRowIdx == null){
			Common.alert("Please select a record for deletion");
			return;
		}
		AUIGrid.removeRow(approveLineGridID, selectRowIdx);
		selectRowIdx = null;
	}

	function fn_searchUserIdPopForApprovalLine() {
		Common.popupDiv("/common/memberPop.do", {
			callPrgm : "APPROVAL_LINE",
		}, null, true);
	}

	function fn_loadOrderSalesmanApprovalLine(memId, memCode) {
		var result = true;
		var list = AUIGrid.getColumnValues(approveLineGridID, "memCode", true);

		if (list.length > 0) {
			for (var i = 0; i < list.length; i++) {
				if (memCode == list[i]) {
					result = false;
				}
			}
		}

		if (result) {
			Common
					.ajax(
							"GET",
							"/sales/order/selectMemberByMemberIDCode.do",
							{
								memId : memId,
								memCode : memCode
							},
							function(memInfo) {

								if (memInfo == null) {
									Common
											.alert('<b>Member not found.</br>Your input member code : '
													+ memCode + '</b>');
								} else {
									console.log(memInfo);
									AUIGrid.setCellValue(approveLineGridID,
											selectRowIdx, "memCode",
											memInfo.memCode);
									AUIGrid.setCellValue(approveLineGridID,
											selectRowIdx, "name", memInfo.name);
								}
							});
		} else {
			Common.alert('Not allowed to select same User ID in Approval Line');
		}
	}

	/*
	* Document Ready section
	*/
	$(document).ready(function() {
				        doGetComboOrder('/common/selectCodeList.do', '569', 'CODE_ID','', 'managementCardLvl','S',''); //Common Code
						setInputFile2();

						$("#holder_search_btn").click(function() {
							clickType = "newHolder";
							fn_searchUserIdPop();
						});
						$("#charge_search_btn").click(function() {
							clickType = "newCharge";
							fn_searchUserIdPop();
						});
						$("#costCenter_search_btn").click(
								fn_popCostCenterSearchPop);
						$("#save_btn").click(fn_saveNewMgmt);

						$("#crditCardNoTd").keydown(
								function(event) {

									var code = window.event.keyCode;

									if ((code > 34 && code < 41)
											|| (code > 47 && code < 58)
											|| (code > 95 && code < 106)
											|| code == 110 || code == 190
											|| code == 8 || code == 9
											|| code == 13 || code == 46) {
										window.event.returnValue = true;
										return;
									}
									window.event.returnValue = false;

								});

						$("#appvCrditLimit").keydown(
								function(event) {

									var code = window.event.keyCode;

									if ((code > 34 && code < 41)
											|| (code > 47 && code < 58)
											|| (code > 95 && code < 106)
											|| code == 110 || code == 190
											|| code == 8 || code == 9
											|| code == 13 || code == 46) {
										window.event.returnValue = true;
										return;
									}
									window.event.returnValue = false;

								});

						$("#appvCrditLimit").click(
								function() {
									var str = $("#appvCrditLimit").val()
											.replace(/,/gi, "");
									$("#appvCrditLimit").val(str);
								});
						$("#appvCrditLimit")
								.blur(
										function() {
											var str = $("#appvCrditLimit")
													.val()
													.replace(
															/(\d)(?=(?:\d{3})+(?!\d))/g,
															'$1,');
											$("#appvCrditLimit").val(str);
										});

						$("#appvCrditLimit")
								.change(
										function() {
											var str = ""
													+ Math.floor($(
															"#appvCrditLimit")
															.val() * 100) / 100;

											var str2 = str.split(".");

											if (str2.length == 1) {
												str2[1] = "00";
											}

											if (str2[0].length > 11) {
												Common
														.alert('<spring:message code="pettyCashNewCustdn.Amt.msg" />');
												str = "";
											} else {
												str = str2[0].substr(0, 11)
														+ "." + str2[1];
											}
											str = str
													.replace(
															/(\d)(?=(?:\d{3})+(?!\d))/g,
															'$1,');

											$("#appvCrditLimit").val(str);
										});

						CommonCombo.make("bankCode",
								"/eAccounting/creditCard/selectBankCode.do",
								null, "", {
									id : "code",
									name : "name",
									type : "S"
								});

						fn_setCostCenterEvent();

						/*
						* Approval Line
						*/
					    approveLineGridID = AUIGrid.create("#approveLine_grid_wrap", approveLineColumnLayout, approveLineGridPros);

					    AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
			    	        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
			    	        selectRowIdx = event.rowIndex;
			    	    });
					    fn_appvLineGridAddRow();
					    $("#appvAdd_btn").click(fn_appvLineGridAddRow);
					    $("#appvDel_btn").click(fn_appvLineGridDeleteRow);
					});
</script>

<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->

	<header class="pop_header">
		<!-- pop_header start -->
		<h1>
			<spring:message code="crditCardMgmt.newRgistration" />
		</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->

	<section class="pop_body">
		<!-- pop_body start -->

		<section class="search_table">
			<!-- search_table start -->
			<form action="#" method="post" enctype="multipart/form-data"
				id="form_newMgmt">
				<input type="hidden" id="newCrditCardUserId" name="crditCardUserId">
				<input type="hidden" id="newChrgUserId" name="chrgUserId"> <input
					type="hidden" id="newCostCenterText" name="costCentrName">

				<table class="type1">
					<!-- table start -->
					<caption>
						<spring:message code="webInvoice.table" />
					</caption>
					<colgroup>
						<col style="width: 190px" />
						<col style="width: *" />
						<col style="width: 150px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><spring:message
									code="crditCardMgmt.cardholderName" /></th>
							<td><input type="text" title="" placeholder=""
								class="readonly" readonly="readonly" id="newCrditCardUserName"
								name="crditCardUserName" /><a href="#" class="search_btn"
								id="holder_search_btn"><img
									src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
									alt="search" /></a></td>
							<th scope="row"><spring:message
									code="crditCardMgmt.crditCardNo" /></th>
							<td id="crditCardNoTd"><input type="text" title=""
								placeholder="" class="w23_5p" maxlength="4" id="crditCardNo1"
								name="crditCardNo1" /> <input type="password" title=""
								placeholder="" class="w23_5p" maxlength="4" id="crditCardNo2"
								name="crditCardNo2" /> <input type="password" title=""
								placeholder="" class="w23_5p" maxlength="4" id="crditCardNo3"
								name="crditCardNo3" /> <input type="text" title=""
								placeholder="" class="w23_5p" maxlength="4" id="crditCardNo4"
								name="crditCardNo4" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message
									code="crditCardMgmt.chargeName" /></th>
							<td><input type="text" title="" placeholder=""
								class="readonly" readonly="readonly" id="newChrgUserName"
								name="chrgUserName" /><a href="#" class="search_btn"
								id="charge_search_btn"><img
									src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
									alt="search" /></a></td>
							<th scope="row"><spring:message
									code="crditCardMgmt.chargeDepart" /></th>
							<td><input type="text" title="" placeholder="" class=""
								id="newCostCenter" name="costCentr" /><a href="#"
								class="search_btn" id="costCenter_search_btn"><img
									src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
									alt="search" /></a></td>
						</tr>
						<tr>
							<th scope="row"><spring:message
									code="crditCardNewMgmt.issueBank" /></th>
							<td><select class="multy_select" id="bankCode"
								name="bankCode"></select></td>
							<th scope="row"><spring:message
									code="crditCardNewMgmt.cardType" /></th>
							<td><select class="multy_select" id="crditCardType"
								name="crditCardType">
									<option value="CC"><spring:message
											code="crditCardNewMgmt.visa" /></option>
									<option value="DC"><spring:message
											code="crditCardNewMgmt.masterCard" /></option>
							</select></td>
						</tr>
						<tr>
							<th scope="row"><spring:message
									code="crditCardNewMgmt.appvCrditLimit" /></th>
							<td><input type="text" title="" placeholder="" class="w100p"
								id="appvCrditLimit" name="appvCrditLimit" /></td>
							<th scope="row"><spring:message
									code="crditCardNewMgmt.expiryDt" /></th>
							<td><input type="text" title="기준년월" placeholder="MM/YYYY"
								class="j_date2 w100p" id="crditCardExprDt"
								name="crditCardExprDt" /></td>
						</tr>
						<tr>
							<th scope="row">Management Level</th>
							<td>
								<select class="multy_select" id="managementCardLvl"
									name="managementCardLvl">
								</select>
							</td>
							<th>
							</th>
							<td></td>
						</tr>
						<tr>
							<th scope="row"><spring:message
									code="newWebInvoice.attachment" /></th>
							<td colspan="3">
								<div class="auto_file2">
									<!-- auto_file start -->
									<input type="file" title="file add" />
								</div>
								<!-- auto_file end -->
							</td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="newWebInvoice.remark" /></th>
							<td colspan="3"><textarea class="w100p" rows="2"
									style="height: auto" id="crditCardRem" name="crditCardRem"></textarea></td>
						</tr>
					</tbody>
				</table>
				<!-- table end -->

				<section>
					<ul class="right_btns">
						<li><p class="btn_grid"><a href="#" id="appvAdd_btn">Add</a></p></li>
						<li><p class="btn_grid"><a href="#" id="appvDel_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
					</ul>

					<article class="grid_wrap" id="approveLine_grid_wrap">
						<!-- grid_wrap start -->
					</article>
					<!-- grid_wrap end -->
				</section>

				<ul class="center_btns">
					<li><p class="btn_blue2">
							<a href="#" id="save_btn"><spring:message
									code="pettyCashNewCustdn.save" /></a>
						</p></li>
				</ul>

			</form>
		</section>
		<!-- search_table end -->

	</section>
	<!-- pop_body end -->

</div>
<!-- popup_wrap end -->