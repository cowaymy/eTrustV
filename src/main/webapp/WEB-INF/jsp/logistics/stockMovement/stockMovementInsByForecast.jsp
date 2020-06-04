<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
	text-align: left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
	color: #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
	background: #D9E5FF;
	color: #000;
}

.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
	background: #D9E5FF;
	color: #000;
}
</style>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
	var resGrid;
	var reqGrid;

	var rescolumnLayout = [ {
		dataField : "rnum",
		headerText : "<spring:message code='log.head.rnum'/>",
		width : 120,
		height : 30,
		visible : false
	}, {
		dataField : "locid",
		headerText : "<spring:message code='log.head.location'/>",
		width : 120,
		height : 30,
		visible : false
	}, {
		dataField : "stkcd",
		headerText : "<spring:message code='log.head.matcode'/>",
		width : 120,
		height : 30,
		editable : false
	}, {
		dataField : "stknm",
		headerText : "Mat. Name",
		width : 120,
		height : 30,
		editable : false
	}, {
		dataField : "qty",
		headerText : "<spring:message code='log.head.availableqty'/>",
		width : 120,
		height : 30,
		editable : false
	}, {
		dataField : "fcastqty",
		headerText : "<spring:message code='log.head.fcastqty'/>",
		width : 120,
		height : 30,
		editable : false
	}, {
		dataField : "typenm",
		headerText : "<spring:message code='log.head.type'/>",
		width : 120,
		height : 30,
		editable : false
	}, {
		dataField : "catenm",
		headerText : "<spring:message code='log.head.category'/>",
		width : 120,
		height : 30,
		editable : false
	}, {
		dataField : "uom",
		headerText : "<spring:message code='log.head.uom'/>",
		width : 120,
		height : 30,
		visible : false
	}, {
		dataField : "serialChk",
		headerText : "<spring:message code='log.head.serial'/>",
		width : 120,
		height : 30,
		editable : false
	} ];

	var reqcolumnLayout;

	var resop = {
		//rowIdField : "rnum",
		showRowCheckColumn : true,
		usePaging : true,
		useGroupingPanel : false,
		Editable : true
	};
	var reqop = {
		usePaging : true,
		useGroupingPanel : false,
		Editable : true
	};

	var uomlist = f_getTtype('42', '');
	var paramdata;
	var brnch = '${SESSION_INFO.userBranchId}';

	$(document).ready(function() {
		/**********************************
		 * Set Combo Data
		 ***********************************/
		// Stock Type
		doGetCombo('/common/selectCodeList.do', '15', '62', 'cType', 'M', 'f_multiCombo');
		// Stock Category
		doGetCombo('/common/selectCodeList.do', '11', '', 'catetype', 'M', 'f_multiCombo');
		doSysdate(0, 'docdate');
		doSysdate(0, 'reqcrtdate');
		paramdata = {
			groupCode : '308',
			orderValue : 'CODE_NAME',
			likeValue : $("#sttype").val()
		};
		doGetComboData('/common/selectCodeList.do', paramdata, 'UM03', 'smtype', 'S', '');
		paramdata = {
			stoIn : '02,05',
			endlikeValue : $("#locationType").val(),
			grade : $("#locationType").val()
		}; // session 정보 등록
		doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'tlocation', 'S', 'fn_setDefaultToSelection');
		var paramdata2 = {
			brnch : brnch,
			locgb : 'CT'
		};
		doGetComboCodeId('/common/selectStockLocationList.do', paramdata2, '', 'flocation', 'S', '');

		//$("#cancelTr").hide();
		/**********************************
		 * Header Setting End
		 ***********************************/

		reqcolumnLayout = [ {
			dataField : "itmcd",
			headerText : "<spring:message code='log.head.matcode'/>",
			width : 120,
			height : 30,
			editable : false
		}, {
			dataField : "itmname",
			headerText : "Mat. Name",
			width : 120,
			height : 30,
			editable : false
		}, {
			dataField : "aqty",
			headerText : "<spring:message code='log.head.availableqty'/>",
			width : 120,
			height : 30,
			editable : false
		}, {
			dataField : "itmfcastqty",
			headerText : "<spring:message code='log.head.fcastqty'/>",
			width : 120,
			height : 30
		}, {
			dataField : "itmtype",
			headerText : "<spring:message code='log.head.type'/>",
			width : 120,
			height : 30,
			editable : true
		}, {
			dataField : "itmserial",
			headerText : "<spring:message code='log.head.serial'/>",
			width : 120,
			height : 30,
			editable : false
		}, {
			dataField : "uom",
			headerText : "<spring:message code='log.head.uom'/>",
			width : 120,
			height : 30,
			editable : false,
			labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
				var retStr = "";

				for (var i = 0, len = uomlist.length; i < len; i++) {
					if (uomlist[i]["codeId"] == value) {
						retStr = uomlist[i]["codeName"];
						break;
					}
				}
				return retStr == "" ? value : retStr;
			},
			editRenderer : {
				type : "ComboBoxRenderer",
				showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
				list : uomlist,
				keyField : "codeId",
				valueField : "codeName"
			}
		} ];

		resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout, "", resop);
		reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout, "", reqop);

		AUIGrid.bind(resGrid, "addRow", function(event) {
		});
		AUIGrid.bind(reqGrid, "addRow", function(event) {
		});

		AUIGrid.bind(resGrid, "cellEditBegin", function(event) {
		});
		AUIGrid.bind(reqGrid, "cellEditBegin", function(event) {

		});

		AUIGrid.bind(resGrid, "cellEditEnd", function(event) {
		});
		AUIGrid.bind(reqGrid, "cellEditEnd", function(event) {

			if (event.dataField == "itmcd") {
				$("#svalue").val(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd"));
				$("#sUrl").val("/logistics/material/materialcdsearch.do");
				Common.searchpopupWin("popupForm", "/common/searchPopList.do", "stocklist");
			}

			if (event.dataField == "itmfcastqty") {
				if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmfcastqty") > AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty")) {
					Common.alert('The requested forecast quantity is more than ' + AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty") + '.');
					AUIGrid.setCellValue(reqGrid, event.rowIndex, "rqty", 0);
					return false;
				}
				if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmfcastqty") < 0) {
					Common.alert('The requested forecast quantity is less than zero.');
					AUIGrid.setCellValue(reqGrid, event.rowIndex, "itmfcastqty", 0);
					return false;

				}
			}
		});

		AUIGrid.bind(resGrid, "cellClick", function(event) {
		});
		AUIGrid.bind(reqGrid, "cellClick", function(event) {
		});

		AUIGrid.bind(resGrid, "cellDoubleClick", function(event) {
		});
		AUIGrid.bind(reqGrid, "cellDoubleClick", function(event) {
		});

		AUIGrid.bind(resGrid, "ready", function(event) {
		});
		AUIGrid.bind(reqGrid, "ready", function(event) {
		});

	});

	//btn clickevent
	$(function() {
		$('#search').click(function() {
			$("#slocation").val($("#tlocation").val());
			$("#cdlocation").val($("#flocation").val());
			SearchListAjax();
		});
		$('#clear').click(function() {
		});
		$('#reqadd').click(function() {
			f_AddRow();
		});
		$('#reqdel').click(function() {
			AUIGrid.removeRow(reqGrid, "selectedIndex");
			AUIGrid.removeSoftRows(reqGrid);
		});
		$('#list').click(function() {
			document.location.href = '/logistics/stockMovement/StockMovementList.do';
		});
		$('#save').click(function() {
			var items = GridCommon.getEditData(reqGrid);
			var bool = true;
			if (items.add.length > 0){
				for (var i = 0; i < items.add.length; i++) {
					console.log(items.add[i].itmtype);
					if (items.add[i].itmtype == 'Stock') {
						Common.alert('Stock is not allow to Request.');
						bool = false;
						break;
					}

					if (items.add[i].itmfcastqty == 0) {
						Common.alert('Please enter the Request Forecast Qty.');
						bool = false;
						break;
					}
				}
				if (bool && f_validatation('save')) { //here to enable the select

					// Added by Hui Ding for auto process GI
	                var selectedToLocation = $("#tlocation option:selected").html();

	                if (selectedToLocation.indexOf("CDB") > 0){
	                	$("#isCody").val('Y');
	                	Common.confirm("Assignment to CODY will auto complete with GI process.", fn_save, null);
	                } else {
	                	fn_save();
	                }
	               }
			} else {
				Common.alert('Please select filter to be assigned.');
			}

		});
		$("#smtype").change(function() {

		});

		$("#tlocation").change(function() {
			if ($("#movpath").val() == "02") {
				var paramdata = {
					rdcloc : $("#tlocation").val(),
					locgb : 'CT'
				};
				doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'flocation', 'S', '');
			}

		});
		$("#rightbtn").click(function() {
			checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);

			var reqitms = AUIGrid.getGridData(reqGrid);

			var bool = true;
			if (checkedItems.length > 0) {
				var rowPos = "first";
				var item = new Object();
				var rowList = [];

				var boolitem = true;
				var k = 0;
				for (var i = 0; i < checkedItems.length; i++) {
					if (checkedItems[i].fcastqty > checkedItems[i].qty) {
						boolitem = false;
					}

					for (var j = 0; j < reqitms.length; j++) {

						if (reqitms[j].itmcd == checkedItems[i].stkcd) {
							boolitem = false;
							break;
						}
					}

					if (boolitem) {
						rowList[k] = {
							itmcd : checkedItems[i].stkcd,
							itmname : checkedItems[i].stknm,
							aqty : checkedItems[i].qty,
							itmfcastqty : checkedItems[i].fcastqty,
							itmtype : checkedItems[i].typenm,
							uom : checkedItems[i].uom,
							itmserial : checkedItems[i].serialChk
						}
						k++;
					}

					AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
					boolitem = true;
				}

				AUIGrid.addRow(reqGrid, rowList, rowPos);
			}
		});
	});

	function fn_save() {
		$("#sttype").prop("disabled" , false);
        $("#smtype").prop("disabled" , false);
        var dat = GridCommon.getEditData(reqGrid);
        dat.form = $("#headForm").serializeJSON();
        Common.ajax("POST", "/logistics/stockMovement/StockMovementAddbyForecast.do", dat, function(result) {
            if (result.code == '99') {
                AUIGrid.clearGridData(reqGrid);
                Common.alert(result.message, SearchListAjax);
            }
            else {
                Common.alert("" + result.message + "</br>" + result.data, locationList);
                AUIGrid.resetUpdatedItems(reqGrid, "all");
            }

        }, function(jqXHR, textStatus, errorThrown) {
            try {
            }
            catch (e) {
            }
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
	}

	function fn_changeLocation() {
		var paramdata = {
			locgb : $("#movpath").val(),
			endlikeValue : $("#locationType").val(),
			grade : $("#locationType").val()
		};
		doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'tlocation', 'S', '');
		doDefCombo([], '', 'flocation', 'S', '');
	}

	function transferTypeFunc() {
		//     paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
		//     doGetComboData('/common/selectCodeList.do', paramdata, 'UM03','smtype', 'S' , '');
		paramdata = {
			groupCode : '308',
			orderValue : 'CODE_ID',
			likeValue : $("#sttype").val(),
			codeIn : 'UM03'
		};
		doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}', 'smtype', 'S', '');
	}

	function locationList() {
		$('#list').click();
	}
	function f_validatation(v) {
		if ($("#sttype").val() == null || $("#sttype").val() == undefined || $("#sttype").val() == "") {
			Common.alert("Please select one of Movement Type.");
			return false;
		}
		if ($("#smtype").val() == null || $("#smtype").val() == undefined || $("#smtype").val() == "") {
			Common.alert("Please select one of Movement Type Detail.");
			return false;
		}
		if ($("#tlocation").val() == null || $("#tlocation").val() == undefined || $("#tlocation").val() == "") {
			Common.alert("Please select one of To Location.");
			return false;
		}
		if ($("#flocation").val() == null || $("#flocation").val() == undefined || $("#flocation").val() == "") {
			Common.alert("Please select one of From Location.");
			return false;
		}
		if (v == 'save') {
			if ($("#reqcrtdate").val() == null || $("#reqcrtdate").val() == undefined || $("#reqcrtdate").val() == "") {
				Common.alert("Please enter the Document Date.");
				return false;
			}

			if ($("#dochdertxt").val().length > 50) {
				Common.alert("Remark not allow to enter more than 50 characters.");
				return false;
			}

		}
		return true;

	}

	function SearchListAjax() {

		var url = "/logistics/stockMovement/SelectStockfromForecast.do";
		var param = $('#searchForm').serialize();

		console.log(param);

		$.ajax({
			type : "GET",
			url : url + "?" + param,
			dataType : "json",
			contentType : "application/json;charset=UTF-8",
			beforeSend : function(request) {
				Common.showLoader();
			},
			success : function(data) {
				var gridData = data;

				AUIGrid.setGridData(resGrid, gridData.data);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				Common.setMsg("Fail ........ ");
			},
			complete : function() {
				Common.removeLoader();
			}
		});
	}

	function addRow() {
		var rowPos = "first";

		var item = new Object();

		AUIGrid.addRow(reqGrid, item, rowPos);
	}

	function fn_itempopList(data) {

		var rowPos = "first";
		var rowList = [];

		AUIGrid.removeRow(reqGrid, "selectedIndex");
		AUIGrid.removeSoftRows(reqGrid);
		for (var i = 0; i < data.length; i++) {
			rowList[i] = {
				itmid : data[i].item.itemid,
				itmcd : data[i].item.itemcode,
				itmname : data[i].item.itemname
			}
		}

		AUIGrid.addRow(reqGrid, rowList, rowPos);

	}

	function f_getTtype(g, v) {
		var rData = new Array();
		$.ajax({
			type : "GET",
			url : "/common/selectCodeList.do",
			data : {
				groupCode : g,
				orderValue : 'CRT_DT',
				likeValue : v
			},
			dataType : "json",
			contentType : "application/json;charset=UTF-8",
			async : false,
			success : function(data) {
				$.each(data, function(index, value) {
					var list = new Object();
					list.code = data[index].code;
					list.codeId = data[index].codeId;
					list.codeName = data[index].codeName;
					rData.push(list);
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("Draw ComboBox['" + obj + "'] is failed. \n\n Please try again.");
			},
			complete : function() {
			}
		});

		return rData;
	}
	function f_AddRow() {
		var rowPos = "first";

		var item = new Object();

		AUIGrid.addRow(reqGrid, item, rowPos);
	}

	function f_multiCombo() {
		$(function() {
			$('#catetype').change(function() {

			}).multipleSelect({
				selectAll : true
			});
			$('#cType').change(function() {

			}).multipleSelect({
				selectAll : true
			});
		});
	}

	function fn_setDefaultSelection() {

		Common.ajax("GET", "/logistics/stockMovement/selectDefToLocation.do", '', function(result) {
			//console.log(result.data);
			if (result.data != null || result.data != "") {
				$("#flocation option[value='" + result.data + "']").attr("selected", true);

			}
			else {
				$("#flocation option[value='']").attr("selected", true);
			}
		});
	}

	function fn_setDefaultToSelection() {

		Common.ajax("GET", "/logistics/stockMovement/selectDefToLocation.do", '', function(result) {
			console.log(result.data);
			if (result.data != null || result.data != "") {
				$("#tlocation option[value='" + result.data + "']").attr("selected", true);

			}
			else {
				$("#tlocation option[value='']").attr("selected", true);
			}
		});
	}
</script>

<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>logistics</li>
		<li>Stock Movement request</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>SMO By Forecast Report</h2>
	</aside>
	<!-- title_line end -->

	<aside class="title_line">
		<h3>Header Info</h3>
	</aside>
	<!-- search_table start -->
	<section class="search_table">
		<form id="headForm" name="headForm" method="post">
			<input type='hidden' id='pridic' name='pridic' value='M' />
			<input type='hidden' id='headtitle' name='headtitle' value='SMO' />
			<input type="hidden" id="isCody" name="isCody" value="N"/>
			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 180px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">SMO No.</th>
						<td colspan="3"><input id="reqno" name="reqno" type="text"
							title="" placeholder="Automatic billing" class="readonly w100p"
							readonly="readonly" /></td>
						<th scope="row">Movement Path</th>
						<td colspan="3"><select class="w100p" id="movpath"
							name="movpath" disabled>
								<option value="02" selected>RDC to CT/Cody</option>
						</select></td>
					</tr>
					<tr>
						<th scope="row">Movement Type</th>
						<td colspan="3"><select class="w100p" id="sttype"
							name="sttype" disabled>
								<option value="UM" selected>Transfer</option>
						</select></td>
						<th scope="row">Movement Type</th>
						<td colspan="3"><select class="w100p" id="smtype"
							name="smtype" disabled><option>Movement Type
									Selected</option></select></td>
					</tr>
					<tr>
						<th scope="row">Document Date</th>
						<td colspan="3"><input id="docdate" name="docdate"
							type="text" title="Create start Date" placeholder="DD/MM/YYYY"
							class="j_date" /></td>
						<th scope="row">Delivery Required Date</th>
						<td colspan="3"><input id="reqcrtdate" name="reqcrtdate"
							type="text" title="Create start Date" placeholder="DD/MM/YYYY"
							class="j_date" /></td>
					</tr>
					<tr>
						<th scope="row">Location Type</th>
						<td><select class="w100p" id="locationType"
							name="locationType" onchange="fn_changeLocation()" disabled>
								<option value="">All</option>
								<option value="A" selected>A</option>
								<option value="B">B</option>
						</select></td>
						<th scope="row">From Location</th>
						<td colspan="2"><select class="w100p" id="tlocation"
							name="tlocation"></select></td>
						<th scope="row">To Location</th>
						<td colspan="2"><select class="w100p" id="flocation"
							name="flocation"></select></td>
					</tr>
					<tr>
						<th scope="row">Remark</th>
						<td colspan="7"><input id="dochdertxt" name="dochdertxt"
							type="text" title="" placeholder="" class="w100p" maxlength="50" /></td>
				</tbody>
			</table>
			<!-- table end -->

		</form>
	</section>
	<!-- search_table end -->

	<aside class="title_line">
		<!-- title_line start -->
		<h3>Item Info</h3>
		<ul class="right_btns">
			<c:out value="${PAGE_AUTH}"></c:out>
			<%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
			<li><p class="btn_blue2">
					<a id="search"><spring:message code='sys.btn.search' /></a>
				</p></li>
			<%-- </c:if> --%>
		</ul>
	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" name="searchForm">
			<input type="hidden" id="slocation" name="slocation">
			<input type="hidden" id="cdlocation" name="cdlocation">

			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 180px" />
					<col style="width: *" />
					<col style="width: 180px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Type</th>
						<td colspan="3"><select class="w100p" id="cType" name="cType"></select>
						</td>
						<th scope="row">Category</th>
						<td colspan="3"><select class="w100p" id="catetype"
							name="catetype"></select></td>

					</tr>
					<tr>
						<th scope="row">Material Code</th>
						<td colspan="3"><input type="text" class="w100p"
							id="materialCode" name="materialCode" /></td>
						<td colspan="4"></td>

					</tr>
				</tbody>
			</table>
			<!-- table end -->

		</form>
	</section>
	<!-- search_table end -->

	<section class="search_result">
		<!-- search_result start -->

		<div class="divine_auto type2">
			<!-- divine_auto start -->

			<div style="width: 50%">
				<!-- 50% start -->

				<aside class="title_line">
					<!-- title_line start -->
					<h3>Material Code</h3>
				</aside>
				<!-- title_line end -->

				<div class="border_box" style="height: 340px;">
					<!-- border_box start -->

					<article class="grid_wrap">
						<!-- grid_wrap start -->
						<div id="res_grid_wrap"></div>
					</article>
					<!-- grid_wrap end -->

				</div>
				<!-- border_box end -->

			</div>
			<!-- 50% end -->

			<div style="width: 50%">
				<!-- 50% start -->

				<aside class="title_line">
					<!-- title_line start -->
					<h3>Request Item</h3>
					<ul class="right_btns">
						<%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
						<!--     <li><p class="btn_grid"><a id="reqadd">ADD</a></p></li> -->
						<li><p class="btn_grid">
								<a id="reqdel">DELETE</a>
							</p></li>
						<%-- </c:if> --%>
					</ul>
				</aside>
				<!-- title_line end -->

				<div class="border_box" style="height: 340px;">
					<!-- border_box start -->

					<article class="grid_wrap">
						<!-- grid_wrap start -->
						<div id="req_grid_wrap"></div>
					</article>
					<!-- grid_wrap end -->

					<ul class="btns">
						<li><a id="rightbtn"><img
								src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"
								alt="right" /></a></li>
						<%--     <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li> --%>
					</ul>

				</div>
				<!-- border_box end -->

			</div>
			<!-- 50% end -->

		</div>
		<!-- divine_auto end -->

		<ul class="center_btns mt20">
			<li><p class="btn_blue2 big">
					<a id="list">List</a>
				</p></li>&nbsp;&nbsp;
			<%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
			<li><p class="btn_blue2 big">
					<a id="save">Save</a>
				</p></li>
			<%-- </c:if>				 --%>
		</ul>

	</section>
	<!-- search_result end -->
	<form id='popupForm'>
		<input type="hidden" id="sUrl" name="sUrl">
		<input type="hidden" id="svalue" name="svalue">
	</form>
</section>
