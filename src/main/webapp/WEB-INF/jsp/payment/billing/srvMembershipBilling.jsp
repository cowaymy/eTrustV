<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
	console.log("srvMembershipBilling");
	var myGridID;
	var myViewDetailGridID;
	var boolDiff = false; //Added by keyi

	//Grid Properties 설정
	var gridPros = {
		editable : false, // 편집 가능 여부 (기본값 : false)
		showStateColumn : false, // 상태 칼럼 사용
		// 사용자가 추가한 새행은 softRemoveRowMode 적용 안함.
		// 즉, 바로 삭제함.
		//softRemovePolicy : "exceptNew"
		softRemoveRowMode : false
	};

	var detailGridPros = {
		editable : false, // 편집 가능 여부 (기본값 : false)
		showStateColumn : false, // 상태 칼럼 사용
		usePaging : false,
		height : 200
	};

	//AUIGrid 칼럼 설정
	var columnLayout = [

	{
		dataField : "srvMemQuotId",
		headerText : "<spring:message code='pay.head.quotationId'/>",
		editable : false,
		visible : false
	}, {
		dataField : "srvMemQuotIdTxt",
		headerText : "<spring:message code='pay.head.salesOrderId'/>",
		editable : false,
		visible : false
	}, {
		dataField : "salesOrdId",
		headerText : "<spring:message code='pay.head.salesOrderId'/>",
		editable : false,
		visible : false
	}, {
		dataField : "appTypeId",
		headerText : "<spring:message code='pay.head.appTypeId'/>",
		editable : false,
		visible : false
	}, {
		dataField : "srvMemPacId",
		headerText : "<spring:message code='pay.head.membershipTypeId'/>",
		editable : false,
		visible : false
	}, {
		dataField : "srvQuotValId",
		headerText : "<spring:message code='pay.head.expiredDate'/>",
		editable : false,
		visible : false,
		dataType : "date",
		formatString : "dd-mm-yyyy"
	},

	{
		dataField : "salesOrdNo",
		headerText : "<spring:message code='pay.head.orderNo'/>",
		width : 100,
		editable : false
	}, {
		dataField : "srvMemQuotNo",
		headerText : "<spring:message code='pay.head.quotationNo'/>",
		width : 100,
		editable : false
	}, {
		dataField : "srvDur",
		headerText : "<spring:message code='pay.head.duration'/>",
		width : 70,
		editable : false
	}, {
		dataField : "srvFreq",
		headerText : "<spring:message code='pay.head.frequent'/>",
		width : 70,
		editable : false
	}, {
		dataField : "custId",
		headerText : "<spring:message code='pay.head.custId'/>",
		editable : false
	}, {
		dataField:"billGrpNo" ,
		headerText:"Bill Group No.",
		width: 100,
		editable : false
	}, {
		dataField : "custName",
		headerText : "<spring:message code='pay.head.customerName'/>",
		width : 200,
		editable : false
	}, {
		dataField : "stkDesc",
		headerText : "<spring:message code='pay.head.product'/>",
		width : 200,
		editable : false
	}, {
		dataField : "srvMemDesc",
		headerText : "<spring:message code='pay.head.type'/>",
		width : 180,
		editable : false
	}, {
		dataField : "srvMemPacAmt",
		headerText : "<spring:message code='pay.head.packageCharges'/>",
		width : 100,
		editable : false,
		dataType : "numeric",
		formatString : "#,##0.00",
		style : "aui-grid-user-custom-right"
	}, {
		dataField : "srvMemBsAmt",
		headerText : "<spring:message code='pay.head.filterCharges'/>",
		width : 100,
		editable : false,
		dataType : "numeric",
		formatString : "#,##0.00",
		style : "aui-grid-user-custom-right"
	}, {
		dataField : "totalAmt",
		headerText : "<spring:message code='pay.head.totalCharges'/>",
		width : 100,
		editable : false,
		dataType : "numeric",
		formatString : "#,##0.00",
		style : "aui-grid-user-custom-right"
	}, {
		dataField : "custType",
		headerText : "Customer Type",
		width : 100,
		editable : false,
		visible : false
	}, {
		dataField : "",
		headerText : "",
		width : 100,
		renderer : {
			type : "ButtonRenderer",
			labelText : "<spring:message code='pay.head.delete'/>",
			onclick : function(rowIndex, columnIndex, value, item) {
				//alert(rowIndex);
				AUIGrid.removeRow(myGridID, "selectedIndex");
				boolDiff = false;
			}
		}
	}

	];

	var viewDetailcolumnLayout = [ {
		dataField : "salesOrdNo",
		headerText : "<spring:message code='pay.head.orderNo'/>",
		editable : false
	}, {
		dataField : "srvMemQuotNo",
		headerText : "<spring:message code='pay.head.smqNo'/>",
		editable : false
	}, {
		dataField : "totalAmt",
		headerText : "<spring:message code='pay.head.amount'/>",
		editable : false,
		dataType : "numeric",
		formatString : "#,##0.00",
		style : "aui-grid-user-custom-right"
	}

	];

	$(document).ready(
			function() {
				// 그리드 생성
				myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,
						null, gridPros);
				myViewDetailGridID = GridCommon.createAUIGrid(
						"viewDetail_grid_wrap", viewDetailcolumnLayout, null,
						detailGridPros);
			});

	function fn_search() {
		Common.popupDiv('/sales/membership/initSrchMembershipQuotationPop.do',
				'', null, true, '_searchQuotation');
	}

	function _callBackQuotationPop(obj) {
		//팝업창 닫기
		$('#_searchQuotation').hide();
		$('#_searchQuotation').remove();

		//현재 그리드에서 Quotation ID 배열을 가져온다.
		var srvMemQuotIdTxtArray = AUIGrid.getColumnDistinctValues(myGridID,
				"srvMemQuotIdTxt");

		//추가하려는 객체의 Quotation ID값이 이미 존재하는지 체크
		if (srvMemQuotIdTxtArray.indexOf(obj.srvMemQuotIdTxt) > -1) {
			Common
					.alert("<spring:message code='pay.alert.selectedBillExistingList'/>");
			return;

		} else {
			// parameter
			// item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
			// rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
			AUIGrid.addRow(myGridID, obj, "last");

			$('#orderNo').val(obj.salesOrdNo);
			$('#quoNo').val(obj.srvMemQuotNo);
		}
	}

	//Layer close
	hideViewPopup = function(val) {
		$(val).hide();
	}

	//edit by keyi 20211101
	function fn_createBills() {
		var rowCount = AUIGrid.getRowCount(myGridID);

		if (rowCount < 1) {
			Common.alert("<spring:message code='pay.alert.noRecordsGridView'/>");
			return;
		} else if (rowCount == 1) {
			var custType = AUIGrid.getColumnValues(myGridID, "custType");
			if (custType == "IND") {
				Common.alert("Incorrect customer type.");
				return false;
			} else {
				fn_showRemark();
			}
		} else {
			if (rowCount > 1) {
				var custId = AUIGrid.getColumnValues(myGridID, "custId");
				var billGrpNo = AUIGrid.getColumnValues(myGridID, "billGrpNo");

				for (i = 0; i < custId.length - 1; i++) {
					if (custId[i] != custId[i + 1]) {
						boolDiff = true;
						break;
					} else {
						boolDiff = false;
					}

					// Check Customer Bill Group No.
					if (billGrpNo[i] != billGrpNo[i + 1]) {
						boolDiff = true;
						break;
					} else {
						boolDiff = false;
					}
				}
			} else {

			}
			fn_checkCustType();
		}
	}

	//edit by keyi 20211101
	function fn_checkCustType() {
		var custType = AUIGrid.getColumnValues(myGridID, "custType");

		if (custType.includes("IND")) {

			if (boolDiff == true) {
				console.log("start here");
			    Common.alert("Fail to proceed due to diffirent Cust Name /Cust ID");
				boolDiff = false;
			} else {
				Common.alert("Incorrect customer type.");
			}
			return false;
		} else {
			if (boolDiff == true) {
                Common.alert("Fail to proceed due to diffirent Cust Name /Cust ID / Cust Bill Group No");
                boolDiff = false;
            } else {
				$("#viewDetail_wrap").show();
				AUIGrid.resize(myViewDetailGridID);

				//그리드 복사
				AUIGrid.setGridData(myViewDetailGridID, AUIGrid
						.getGridData(myGridID));

				//Summary 값
				// edit by hakimin 20241203
                var amtArray = AUIGrid.getColumnValues(myGridID, "totalAmt");
                var sum = 0;

                // Calculate sum
                for (i = 0; i < amtArray.length; i++) {
                    sum += amtArray[i];
                }

                // Fix floating-point precision and update the view
                sum = Math.round((sum + Number.EPSILON) * 100) / 100;
                $('#view_count').text(AUIGrid.getRowCount(myGridID));
                $('#view_total').text('RM ' + sum.toFixed(2));

			}
		}
	}

	function fn_showRemark() {
		hideViewPopup('#viewDetail_wrap');
		$("#remark_wrap").show();
	}

	function fn_save() {
		//param data array
		var data = GridCommon.getGridData(myGridID);
		data.form = $("#remarkForm").serializeJSON();

		  if ($("#refNo").val() == "") {
             Common.alert("Please Enter Reference No.");
             return;
         }
		 else{
		//Ajax 호출
		Common.ajax(
						"POST",
						"/payment/saveSrvMembershipBilling.do",
						data,
						function(result) {
							var msg = '';

							if (result.message == -1) {
								Common
										.alert("Entered SVM No. had been used. Please try other SVM No.");
								return false;
							} else {
								if (result.message == 1) {
									msg = "<spring:message code='pay.alert.quotationSuccess'/>";
								} else if (result.message == 99) {
									msg = "<spring:message code='pay.alert.failedToInvoice'/>";
								} else if (result.message == 98) {
									msg = "<spring:message code='pay.alert.failedToConvert'/>";
								} else if (result.message == 97) {
									msg = "<spring:message code='pay.alert.failedToSave'/>";
								} else {
									msg = "<spring:message code='pay.alert.failedToSave'/>";
								}

								Common
										.alert(
												msg,
												function() {
													location.href = "/payment/initSrvMembershipBilling.do";
												});
							}
						});
		 }
	}
</script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
	text-align: left;
}

.aui-grid-user-custom-right {
	text-align: right;
}

/* 엑스트라 체크박스 사용자 선택 못하는 표시 스타일 */
.disable-check-style {
	color: #d3825c;
}
</style>
<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
	</ul>

	<!-- title_line start -->
	<aside class="title_line">
		<p class="fav">
			<a href="#" class="click_add_on"><spring:message
					code='pay.text.myMenu' /></a>
		</p>
		<h2>Membership</h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
				<li><p class="btn_blue">
						<a href="javascript:fn_createBills();"><spring:message
								code='pay.btn.createBills' /></a>
					</p></li>
			</c:if>
		</ul>

	</aside>
	<!-- title_line end -->

	<!-- search_table start -->
	<section class="search_table">
		<form name="searchForm" id="searchForm" method="post">
			<!-- table start -->
			<table class="type1 mt10">
				<caption>table</caption>
				<colgroup>
					<col style="width: 200px" />
					<col style="width: *" />
					<col style="width: 200px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Sales Order</th>
						<td><input type="text" id="orderNo" name="orderNo" title=""
							placeholder="" class="readonly" readonly="readonly" /></td>
						<th scope="row">Membership Quotation</th>
						<td><input type="text" id="quoNo" name="quoNo" title=""
							placeholder="" class="readonly" readonly="readonly" /> <c:if
								test="${PAGE_AUTH.funcView == 'Y'}">
								<p class="btn_sky">
									<a href="javascript:fn_search();"><spring:message
											code='sys.btn.search' /></a>
								</p>
							</c:if></td>
					</tr>
				</tbody>
			</table>
		</form>
		<!-- table end -->

		<!-- grid_wrap start -->
		<article id="grid_wrap" class="grid_wrap mt30"></article>
		<!-- grid_wrap end -->

	</section>
	<!-- search_table end -->
</section>
<!-- content end -->


<!---------------------------------------------------------------
    POP-UP (VIEW DETAIL)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="viewDetail_wrap" style="display: none;">
	<header class="pop_header" id="viewDetail_pop_header">
		<h1>VIEW DETAILS</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#" onclick="hideViewPopup('#viewDetail_wrap')"><spring:message
							code='sys.btn.close' /></a>
				</p></li>
		</ul>
	</header>

	<section class="pop_body">
		<section class="search_result">
			<!-- search_result start -->
			<article class="grid_wrap" id="viewDetail_grid_wrap"></article>
		</section>

		<section class="search_table">
			<!-- table start -->
			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 165px" />
					<col style="width: *" />
					<col style="width: 165px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Count</th>
						<td id="view_count"></td>
						<th scope="row">Total</th>
						<td id="view_total"></td>
					</tr>
				</tbody>
			</table>
		</section>

		<ul class="center_btns mt20">
			<b><h2>Do you want continue to proceed?</h2></b>
		</ul>
		<ul class="center_btns mt10">
			<li><p class="btn_blue2">
					<a href="javascript:fn_showRemark();"><spring:message
							code='pay.alert.manualBillingYes' /></a>
				</p></li>
			<li><p class="btn_blue2">
					<a href="javascript:hideViewPopup('#viewDetail_wrap');"><spring:message
							code='pay.alert.manualBillingNo' /></a>
				</p></li>
		</ul>
	</section>
</div>
<!-- popup_wrap end -->


<!---------------------------------------------------------------
    POP-UP (REMARK)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="remark_wrap" style="display: none;">
	<header class="pop_header" id="remark_pop_header">
		<h1>ADVANCE BILL REMARK</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#" onclick="hideViewPopup('#remark_wrap')"><spring:message
							code='sys.btn.close' /></a>
				</p></li>
		</ul>
	</header>

	<form name="remarkForm" id="remarkForm" method="post">
		<section class="pop_body">
			<section class="search_table">
				<!-- table start -->
				<table class="type1">
					<caption>table</caption>
					<colgroup>
						<col style="width: 165px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">PO/LO No.</th>
							<td><input type="text" id="poNo" name="poNo"
								title="Purchase Order Number"
								placeholder="Purchase Order Number" class="w100p" /></td>
						</tr>
						<!-- Added Reference No. By Hui Ding, 2021-08-01 -->
						<tr>
							<th scope="row">Reference No.<span name="m1" id="m1" class="must">*</span></th>
							<td><input type="text" id="refNo" name="refNo"
								title="Reference Number" placeholder="Reference Number"
								class="w100p" /></td>
						</tr>
						<tr>
							<th scope="row">Remark</th>
							<td><textarea cols="20" rows="5" id="remark" name="remark"
									title="Remark" placeholder="Remark"></textarea></td>
						</tr>
						<tr>
							<th scope="row">Invoice Remark</th>
							<td><textarea cols="20" rows="5" id="invcRemark"
									name="invcRemark" title="Invoice Remark"
									placeholder="Invoice Remark"></textarea></td>
						</tr>
					</tbody>
				</table>
			</section>

			<ul class="center_btns mt10">
				<li><p class="btn_blue2">
						<a href="javascript:fn_save();"><spring:message
								code='sys.btn.save' /></a>
					</p></li>
			</ul>
		</section>
	</form>
</div>
<!-- popup_wrap end -->