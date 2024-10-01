<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
	var myGridID;
	var gridViewData = null;

	//Grid에서 선택된 RowID
	var selectedGridValue;

	$(document).ready(function()
			{
			var gridPros = {
					editable : false,
					showStateColumn : false,
					pageRowCount : 25
					};

			 var columnLayout = [ {
			        dataField : "custId",
			        headerText : "<spring:message code='pay.head.customerId'/>",
			        editable : false
			    }, {
			        dataField : "noOfBillingGroup",
			        headerText : "<spring:message code='pay.head.noOfBillingGroup'/>",
			        editable : false
			    }, {
			        dataField : "noOfOrderNo",
			        headerText : "<spring:message code='pay.head.noOfOrderNo'/>",
			        editable : false
			    }
			     ];

			    // Order 정보 (Master Grid) 그리드 생성
			    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

			    // Master Grid 셀 클릭시 이벤트
			    AUIGrid.bind(myGridID, "cellClick", function( event ){
			        selectedGridValue = event.rowIndex;
			    });

			});

	function fn_InvRefDt(field) {
		$("#" + field + "").val("");
	}

	function fn_clear() {
		$("#searchForm")[0].reset();
		gridViewData = null;
		AUIGrid.clearGridData(myGridID);
	}

	function fn_getSummaryAccountListAjax() {

		if (FormUtil.isEmpty($("#custID").val())
				&& FormUtil.isEmpty($("#custName").val())) {
			Common.alert("<spring:message code='pay.msg.feildsRequired3' />");
			return;

		}

		else if ($("#custID").val() != "" || $("#custName").val() != "") {
			if (FormUtil.isEmpty($("#invoiceRefDate").val())) {
				Common
						.alert("<spring:message code='pay.msg.feildsRequired2' />");
				return;
			}

			else {
				Common.ajax("GET", "/payment/selectSummaryAccountList.do", $(
						"#searchForm").serialize(), function(result) {
					gridViewData = result;
					console.log('CustId!=empty: ',result);
					AUIGrid.setGridData(myGridID, result);
				});
			}
		} else {
			Common.ajax("GET", "/payment/selectSummaryAccountList.do", $(
					"#searchForm").serialize(), function(result) {
				console.log("----------------------------");
				console.log(result);
				gridViewData = result;
				console.log('gridViewData', gridViewData);
				if (result == null && result.length == 0) {
					gridViewData = null;
				}
				AUIGrid.setGridData(myGridID, result);
			});
		}
	}

	//Generate pdf report button
	function fn_generateInvoice() {
		var selectedItem = AUIGrid.getSelectedIndex(myGridID);
		console.log(myGridID);
	    if (selectedItem[0] > -1){
	        //report form에 parameter 세팅
	        $("#reportPDFForm #V_CUSTID").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "custId"));

	        var custId = AUIGrid.getCellValue(myGridID,selectedGridValue, "custId");
	        var V_MMYYYY =  $("#invoiceRefDate").val();
            console.log("----------------------------");
            console.log($("#invoiceRefDate").val());

            $("#reportPDFForm #V_MMYYYY").val(V_MMYYYY);
	        var reportDownFileName = "";

	        reportDownFileName = 'PUBLIC_SummaryOfAccount_' + custId + '_' + V_MMYYYY;
	        $("#reportPDFForm #reportDownFileName").val(reportDownFileName);

	        //report 호출
	        var option = {
	                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	        };

	        Common.report("reportPDFForm", option);

	    }else{
	        Common.alert("<spring:message code='pay.alert.noPrintType'/>");
	    }
	}


</script>

<div id="popup_wrap" class="popup_wrap size_large">
	<!-- popup_wrap start -->

	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Summary of Account</h1>

		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>

	</header>
	<!-- pop_header end -->

	<section class="pop_body" style="min-height: auto;">
		<!-- pop_body start -->
		<ul class="right_btns">
			<li><p class="btn_blue">
					<a href="javascript:fn_generateInvoice();"><spring:message
							code='pay.btn.generate' /></a>
				</p></li>
			<li><p class="btn_blue">
					<a href="javascript:fn_getSummaryAccountListAjax();"><span
						class="search"></span> <spring:message code='sys.btn.search' /></a>
				</p></li>
			<li><p class="btn_blue">
					<a href="javascript:fn_clear();"><span class="clear"></span> <spring:message
							code='sys.btn.clear' /></a>
				</p></li>
		</ul>

		<!-- search_table start -->
		<section class="search_table">
			<form name="searchForm" id="searchForm" method="post">
				<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 200px" />
						<col style="width: *" />
						<col style="width: 200px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Customer ID</th>
							<td colspan="3"><input id="custID" name="custID"
								 placeholder="Customer ID (Number Only)" type="text" class="w100p" /></td>
						</tr>
						<tr>
                            <th scope="row">Customer Name </th>
                            <td colspan="3"><input id="custName" name="custName" type="text"
                                  placeholder="Customer Name"  class="w100p" /></td>
                        </tr>
						<tr>
							<th scope="row">Period</th>
							<td colspan="3"><p style="width: 70%">
									<input id="invoiceRefDate" name="invoiceRefDate" type="text"
										title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p"
										readonly />
								</p>
								<p class="btn_gray">
									<a href="#" onclick="fn_InvRefDt('invoiceRefDate')">Clear</a>
								</p></td>
						</tr>
					</tbody>
				</table>
			</form>
		</section>

		<!-- search_result start -->
		<section class="search_result">
			<!-- grid_wrap start -->
			<article id="grid_wrap" class="grid_wrap"></article>
			<!-- grid_wrap end -->
		</section>
	</section>
	</section>

<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/SummaryofAccount.rpt" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_CUSTID" name="V_CUSTID" />
    <input type="hidden" id="V_MMYYYY" name="V_MMYYYY" />
</form>

</div>
<!-- popup_wrap end -->