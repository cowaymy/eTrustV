<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	var callLogAptID;
	$(document).ready(function() {
		callLogAptGrid();
		fn_getCallLogAppointmentList();
		f_multiCombo();
	});

	function callLogAptGrid() {
		var columnLayout = [ {
			dataField : "salesOrdNo",
			headerText : "Order No.",
			editable : false,
			width : 100
		}, {
			dataField : "custName",
			headerText : "Name",
			editable : false,
			width : 100
		}, {
			dataField : "telNo",
			headerText : "Tel No.",
			editable : false,
			width : 100
		}, {
			dataField : "productModel",
			headerText : "Product",
			editable : false,
			width : 100
		}, {
			dataField : "name",
			headerText : "Status",
			editable : false,
			width : 100
		}, {
			dataField : "crtDt",
			headerText : "Create Date",
			editable : false,
			width : 100
		}, {
			dataField : "remarks",
			headerText : "Remarks",
			editable : false,
			width : 100
		}, {
			dataField : "stusCodeId",
			visible : false
		}, {
			dataField : "id",
			visible : false
		} ];

		var gridPros = {
			showRowCheckColumn : true,
			usePaging : true,
			pageRowCount : 20,
			editable : false,
			headerHeight : 30
		};

		callLogAptID = AUIGrid.create("#grid_wrap_waList", columnLayout,
				gridPros);
	}

	function fn_getCallLogAppointmentList() {
		Common.ajax("GET", "/callCenter/getCallLogAppointmentList.do", $(
				"#searchForm").serialize(), function(result) {
			AUIGrid.setGridData(callLogAptID, result);
		});
	}

	function fn_submitReblast() {
		var selectedItems = AUIGrid.getCheckedRowItems(callLogAptID);

		if (selectedItems.length <= 0) {
			Common.alert("<spring:message code='service.msg.NoRcd'/> ");
			return;
		}

	    Common.confirm("Confirm to reblast appointments of the following selections?", fn_confirm);
	}

	function fn_confirm(){
		var ids = [];
		var selectedItems = AUIGrid.getCheckedRowItems(callLogAptID);
		for(var i = 0; i < selectedItems.length; i++){
			var id = selectedItems[i].item.id;
			ids.push(id);
		}

		if(ids.length > 0){
			Common.ajax("POST", "/callCenter/confirmBlastCallLogAppointment.do", {ids: ids.join()}, function(result) {
				if(result != null && result.code == "00") {
                    Common.alert("Appointment sent successfully");
                } else {
                    Common.alert(result.message);
                }
				fn_getCallLogAppointmentList();
			});
		}
	}

	function f_multiCombo() {
		$(function() {
			$('#status').change(function() {
			}).multipleSelect({
				selectAll : true,
				width : '80%'
			});
		});
	}
</script>
<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->
	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Whatsapp Appointment List</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#">CLOSE</a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->
	<section class="pop_body">

		<form id="searchForm" name="searchForm" method="post">
			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 150px" />
					<col style="width: *" />
					<col style="width: 120px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th>Date Create</th>
						<td>
							<div class="date_set">
								<!-- date_set start -->
								<p>
									<input type="text" title="Create start Date"
										placeholder="DD/MM/YYYY" class="j_date" id="crtDt"
										name="crtDt" />
								</p>
								<span>To</span>
								<p>
									<input type="text" title="Create end Date"
										placeholder="DD/MM/YYYY" class="j_date" id="endDt"
										name="endDt" />
								</p>
							</div>
							<!-- date_set end -->
						</td>
						<th>Status
						</th>
						<td><select class="multy_select w100p" id="status" name="status" multiple="multiple">
								<option value="1">Active</option>
								<option value="44">Pending</option>
								<option value="4">Complete</option>
								<option value="10">Cancelled</option>
								<option value="21">Failed</option>
								<option value="134">Incorrect</option>
						</select></td>
					</tr>
				</tbody>
			</table>
		</form>
		<ul class="right_btns">
			<li><p class="btn_blue2">
					<a href="#" onclick="javascript:fn_getCallLogAppointmentList()">Search</a>
				</p></li>
			<li><p class="btn_blue2">
					<a href="#" onclick="javascript:fn_submitReblast()">Submit</a>
				</p></li>
		</ul>
		<article class="grid_wrap mt20">
			<!-- grid_wrap start -->
			<div id="grid_wrap_waList"></div>
		</article>
	</section>
</div>