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

	var movpathdata = [ {
		"codeId" : "02",
		"codeName" : "RDC to CT/Cody/DT/HT"
	}, {
		"codeId" : "CT",
		"codeName" : "CT/Cody/DT/HT to CT/Cody/DT/HT"
	}, {
		"codeId" : "CTOR",
		"codeName" : "CT/Cody/DT/HT to RDC/DT"
	} ];

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
		dataField : "stkid",
		headerText : "<spring:message code='log.head.itemcd'/>",
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
		dataField : "typeid",
		headerText : "<spring:message code='log.head.typeid'/>",
		width : 120,
		height : 30,
		visible : false
	}, {
		dataField : "typenm",
		headerText : "<spring:message code='log.head.type'/>",
		width : 120,
		height : 30,
		editable : false
	}, {
		dataField : "cateid",
		headerText : "<spring:message code='log.head.cateid'/>",
		width : 120,
		height : 30,
		visible : false
	}, {
		dataField : "catenm",
		headerText : "<spring:message code='log.head.category'/>",
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
    }, {
        dataField : "stkCatgry",
        headerText : "Stock Category",
        width : 120,
        height : 30,
        editable : false
    } ];

	var reqcolumnLayout;

	var resop = {
		rowIdField : "rnum",
		showRowCheckColumn : true,
		usePaging : true,
		useGroupingPanel : false,
		Editable : false
	};
	var reqop = {
		usePaging : true,
		useGroupingPanel : false,
		Editable : true
	};

	var uomlist = f_getTtype('42', '');
	var paramdata;

	$(document).ready(function() {
		/**********************************
		 * Header Setting
		 ***********************************/
		//paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:'UM'};
		paramdata = {
			groupCode : '306',
			orderValue : 'CRT_DT',
			notlike : 'US'
		};
		//doGetComboDataAndMandatory('/common/selectCodeList.do', paramdata, 'UM','sttype', 'S' , '');
		doGetComboData('/common/selectCodeList.do', paramdata, 'UM', 'sttype', 'S', 'transferTypeFunc');
		//     doGetCombo('/common/selectStockLocationList.do', '', '','tlocation', 'S' , '');
		//     doGetCombo('/common/selectStockLocationList.do', '', '','flocation', 'S' , '');
		doDefCombo(movpathdata, '1', 'movpath', 'S', '');
		doGetCombo('/common/selectCodeList.do', '15', '', 'cType', 'M', 'f_multiCombo');
		doGetCombo('/common/selectCodeList.do', '11', '', 'catetype', 'M', 'f_multiCombo'); //청구처 리스트 조회
		doSysdate(0, 'docdate');
		doSysdate(0, 'reqcrtdate');

		//$("#cancelTr").hide();
		/**********************************
		 * Header Setting End
		 ***********************************/

		reqcolumnLayout = [ {
			dataField : "itmid",
			headerText : "<spring:message code='log.head.itemid'/>",
			width : 120,
			height : 30,
			visible : false
		}, {
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
			dataField : "rqty",
			headerText : "<spring:message code='log.head.requestqty'/>",
			width : 120,
			height : 30
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
		}, {
			dataField : "itmserial",
			headerText : "<spring:message code='log.head.serial'/>",
			width : 120,
			height : 30,
			editable : false
		}, {
			dataField : "itmtype",
			headerText : "<spring:message code='log.head.type'/>",
			width : 120,
			height : 30,
			editable : true
		} , {
	        dataField : "stkCatgry",
	        headerText : "Stock Category",
	        width : 120,
	        height : 30,
	        editable : false
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

			if (event.dataField == "rqty") {
				if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty") > AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty")) {
					Common.alert('The requested quantity is up to ' + AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty") + '.');
					AUIGrid.setCellValue(reqGrid, event.rowIndex, "rqty", 0);
					return false;
				}
				if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty") < 0) {
					Common.alert('The requested quantity is less than zero.');
					AUIGrid.setCellValue(reqGrid, event.rowIndex, "rqty", 0);
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
			//if (f_validatation('search')){
			$("#slocation").val($("#tlocation").val());
			SearchListAjax();
			//}
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
			//alert("items.length :   "+ items.add.length);
			for (var i = 0; i < items.add.length; i++) {
				//console.log(items.add[i].typeid);
				//alert(items.add[i].itmtype);
				if (items.add[i].itmtype == '61') {
					Common.alert('Stock is not Request.');
					bool = false;
					break;
				}

				if (items.add[i].rqty == 0) {
					Common.alert('Request Qty is not [0].');
					bool = false;
					break;
				}
			}
			//     	if (addedItems.length <= 0){
			//     		Common.alert("Plese Check Request Item Grid Request Qty.");
			//     		return false;
			//        }else{
			//             for (var i = 0 ; i < addedItems.length ; i++){
			//             	alert("sadas??????"+addedItems[i]);
			//                 if(""==addedItems[i] || 0==addedItems[i] || null == addedItems[i] || "undefined"== addedItems[i]){
			//                     Common.alert("Plese Check Request Item Grid Request Qty.");
			//                     return false;
			//                 }
			//             }
			//         }
			if (bool && f_validatation('save')) {
				var dat = GridCommon.getEditData(reqGrid);
				dat.form = $("#headForm").serializeJSON();
				Common.ajax("POST", "/logistics/stockMovement/StockMovementAdd.do", dat, function(result) {
					if (result.code == '99') {
						AUIGrid.clearGridData(reqGrid);
						Common.alert(result.message, SearchListAjax);
					}
					else {
						Common.alert("" + result.message + "</br> Created : " + result.data, locationList);
						//Common.alert(result.message , locationList);
						AUIGrid.resetUpdatedItems(reqGrid, "all");
						//location.href = '/logistics/stockMovement/StockMovementList.do';
					}

				}, function(jqXHR, textStatus, errorThrown) {
					try {
					}
					catch (e) {
					}
					Common.alert("Fail : " + jqXHR.responseJSON.message);
				});
			}
		});
		$("#sttype").change(function() {
			paramdata = {
				groupCode : '308',
				orderValue : 'CODE_NAME',
				likeValue : $("#sttype").val()
			};
			doGetComboData('/common/selectCodeList.do', paramdata, '', 'smtype', 'S', '');
		});
		$("#smtype").change(function() {

		});
		$("#movpath").change(function() {
			var brnch = '${SESSION_INFO.userBranchId}';

			if ($("#movpath").val() == "") {
				doDefCombo([], '', 'tlocation', 'S', '');
				doDefCombo([], '', 'flocation', 'S', '');
			}
			else {
				/*   SMO 생성 시 창고  location 에도 Location Type = "05" 도 포함 해 주세요
				//var paramdata = { brnch : '${SESSION_INFO.userBranchId}' , locgb:$("#movpath").val()}; // session 정보 등록
				var paramdata = { locgb:$("#movpath").val(),  endlikeValue:$("#locationType").val()}; // session 정보 등록
				doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '','tlocation', 'S' , '');
				doDefCombo([], '' ,'flocation', 'S', '');
				 */
				if (($("#movpath").val() == 'CTOR')) {
					$("#smtype").val('UM93');
					if ((brnch != '42' && brnch != '0')) {
						var paramdata2 = {
							stoIn : '01,02,05,06,07',
							grade : $("#locationType").val()
						};
						doGetComboCodeId('/common/selectStockLocationList.do', paramdata2, '', 'flocation', 'S', 'fn_setDefaultSelection');

						var paramdata = {
							locgb : $("#movpath").val(),
							grade : $("#locationType").val(),
							brnch : brnch
						};
						doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'tlocation', 'S', '');
					}
					else {
						var paramdata = {
							locgb : $("#movpath").val(),
							endlikeValue : $("#locationType").val(),
							grade : $("#locationType").val()
						}; // session 정보 등록
						doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'tlocation', 'S', '');

						var paramdata2 = {
								stoIn : '02,05',
								endlikeValue : $("#locationType").val(),
								grade : $("#locationType").val()
							}; // session 정보 등록
							doGetComboCodeId('/common/selectStockLocationList.do', paramdata2, '', 'flocation', 'S', 'fn_setDefaultToSelection');

					}

				}
				else {
					$("#smtype").val('UM03');
					if ($("#movpath").val() == '02') {
						var paramdata = {
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
					}
					else {
						var paramdata = {
							locgb : $("#movpath").val(),
							endlikeValue : $("#locationType").val(),
							grade : $("#locationType").val()
						}; // session 정보 등록
						doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'tlocation', 'S', '');
					}
				}

			}
		});
		$("#tlocation").change(function() {
			if ($("#movpath").val() == "CT") {
				var paramdata = {
					ctloc : $("#tlocation").val(),
					locgb : 'CT'
				}; // session 정보 등록
				doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'flocation', 'S', '');
			}
			else {
				if ($("#movpath").val() != "CTOR") {
					var paramdata = {
						rdcloc : $("#tlocation").val(),
						locgb : 'CT'
					}; // session 정보 등록
					doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'flocation', 'S', '');
				}
			}
		});

		$("#flocation").change(function() {
			if ($("#movpath").val() == "CTOR") {
				var paramdata = {
					ctloc : $("#flocation").val(),
					locgb : 'CT'
				};
				doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'tlocation', 'S', '');
			}
		});
		$("#rightbtn").click(function() {
			checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);

			var reqitms = AUIGrid.getGridData(reqGrid);
			var maxItem = 40;

            if (reqitms.length + checkedItems.length > maxItem){
                Common.alert("Maximum " + maxItem + " Material Code per SMO request.");
                return false;
            }

			var bool = true;
			if (checkedItems.length > 0) {
				var rowPos = "first";
				var item = new Object();
				var rowList = [];

				var boolitem = true;
				var k = 0;
				for (var i = 0; i < checkedItems.length; i++) {

					for (var j = 0; j < reqitms.length; j++) {

						if (reqitms[j].itmid == checkedItems[i].stkid) {
							boolitem = false;
							break;
						}

						if (reqitms[j].stkCatgry != checkedItems[i].stkCatgry){
	                        boolitem = false;
	                        alert("Different Stock Category is not allowed in one SMO.");
	                        break;
	                    }
					}

					if(reqitms.length == 0 && checkedItems.length > 1){
	                    for (var m = i + 1 ; m < checkedItems.length ; m++){
	                        if (checkedItems[i].stkCatgry != checkedItems[m].stkCatgry){
	                            boolitem = false;
	                            alert("Different Stock Category is not allowed in one SMO.");
	                            break;
	                        }
	                        break;
	                    }
	                }

					if (boolitem) {
						rowList[k] = {
							itmid : checkedItems[i].stkid,
							itmcd : checkedItems[i].stkcd,
							itmname : checkedItems[i].stknm,
							aqty : checkedItems[i].qty,
							rqty : 0,
							uom : checkedItems[i].uom,
							itmserial : checkedItems[i].serialChk,
							itmtype : checkedItems[i].typeid,
							stkCatgry : checkedItems[i].stkCatgry
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

	function fn_changeLocation() {
		var paramdata = {
			locgb : $("#movpath").val(),
			endlikeValue : $("#locationType").val(),
			grade : $("#locationType").val()
		}; // session 정보 등록
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
			codeIn : 'UM03,UM93'
		};
		doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}', 'smtype', 'S', '');
	}

	function locationList() {
		$('#list').click();
	}
	function f_validatation(v) {
		if ($("#sttype").val() == null || $("#sttype").val() == undefined || $("#sttype").val() == "") {
			Common.alert("Please select one of Transaction Type.");
			return false;
		}
		if ($("#smtype").val() == null || $("#smtype").val() == undefined || $("#smtype").val() == "") {
			Common.alert("Please select one of Movement Type.");
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
				Common.alert("Please enter Document Date.");
				return false;
			}

			if ($("#dochdertxt").val().length > 50) {
				Common.alert("Header Text can be up to 50 digits.");
				return false;
			}

			//promp alert message when movement type does not correct.
			if((($("#movpath").val() == 'CTOR') && $("#smtype").val() != 'UM93') ||
					(($("#movpath").val() == '02' || $("#movpath").val() == 'CT') && $("#smtype").val() != 'UM03')){
				Common.alert("The Movement Type is incorrect.");
				return false;
			}

		}
		return true;

	}

	function SearchListAjax() {

		var url = "/logistics/stockMovement/StockMovementTolocationItemList.do";
		var param = $('#searchForm').serialize();

		console.log(param);

		//     Common.ajax("GET" , url , param , function(result){
		//         AUIGrid.setGridData(resGrid, result.data);
		//     });
		$.ajax({
			type : "GET",
			url : url + "?" + param,
			//url : "/stock/StockList.do",
			//data : param,
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
		<h2>SMO</h2>
	</aside>
	<!-- title_line end -->

	<aside class="title_line">
		<h3>Header Info</h3>
	</aside>
	<!-- search_table start -->
	<section class="search_table">
		<form id="headForm" name="headForm" method="post">
			<input type='hidden' id='pridic' name='pridic' value='M' /> <input
				type='hidden' id='headtitle' name='headtitle' value='SMO' />
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
							name="movpath"></select></td>
					</tr>
					<tr>
						<th scope="row">Transaction Type</th>
						<td colspan="3"><select class="w100p" id="sttype"
							name="sttype"></select></td>
						<th scope="row">Movement Type</th>
						<td colspan="3"><select class="w100p" id="smtype"
							name="smtype"><option>Movement Type Selected</option></select></td>
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
							name="locationType" onchange="fn_changeLocation()">
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
					</tr>
					<!-- <tr id="cancelTr"> -->
					<!--     <th scope="row">Defect Reason</th> -->
					<!--     <td> -->
					<!--     <select class="w100p"> -->
					<!--         <option value="">11</option> -->
					<!--         <option value="">22</option> -->
					<!--         <option value="">33</option> -->
					<!--     </select> -->
					<!--     </td> -->
					<!-- <!--     <th scope="row">CT/Cody</th> -->
					<!--     <td> -->
					<!--     <select class="w100p"> -->
					<!--         <option value="">11</option> -->
					<!--         <option value="">22</option> -->
					<!--         <option value="">33</option> -->
					<!--     </select> -->
					<!--     </td> -->
					<!--     <td> -->
					<!--     </td> -->
					<!--     <td> -->
					<!--     </td> -->
					<!-- </tr> -->
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
		<input type="hidden" id="sUrl" name="sUrl"> <input
			type="hidden" id="svalue" name="svalue">
	</form>
</section>
