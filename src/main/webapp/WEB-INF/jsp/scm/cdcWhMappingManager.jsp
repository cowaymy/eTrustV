<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
	text-align:right;
}
.aui-grid-left-column {
	text-align:left;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align:right;
	margin-top:-20px;
}

/* 커스텀 칼럼 스타일 정의*/
.myLinkStyle {
	text-decoration: underline;
	color:#4374D9;
}
.myLinkStyle :hover{
	color:#FF0000;
}
</style>

<script type="text/javaScript">
var cdcCodeList	= new Array();

$(function() {
	//	set CDC
	fnSetGridComboList();
	fnSelectCDCComboList();
	fnSearchBtnList();
});


//search
function fnSearchBtnList() {
Common.ajax("GET"
			, "/scm/selectWHouseMappingSerch.do"
			, $("#MainForm").serialize()
			, function(result) {
				console.log("성공 fnSearchBtnList: " + result.selectCdcWareMappingListList.length);
				
				AUIGrid.setGridData(mapGridID, result.selectCdcWareMappingListList);
				AUIGrid.setGridData(unmapGridID, result.selectWhLocationMappingList);
				
				if ( null != result && 0 < result.selectWhLocationMappingList.length ) {
					console.log("success: " + result.selectWhLocationMappingList[0].whId);
				}
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : " + jqXHR.status);
					console.log("code : "        + jqXHR.responseJSON.code);
					console.log("message : "     + jqXHR.responseJSON.message);
					console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}

//	Add CDC
function fnAddCDC() {
	var popUpObj	= Common.popupDiv("/scm/cdcWhMappingAddPop.do"
			, $("#MainForm").serializeJSON()
			, null
			, false	//	when doble click, Not close
			, "cdcWhMappingAddPop"
	);
}

//	Save Unmap
function fnSaveUnmap() {
	if ( false == fnValidUnmap() ) {
		return	false;
	}
	
	Common.ajax("POST"
			, "/scm/saveUnmap.do"
			, GridCommon.getEditData(mapGridID)
			, function(result) {
				Common.alert(result.data + "<spring:message code='sys.msg.savedCnt'/>");
				fnSearchBtnList();
				
				console.log("Success : " + JSON.stringify(result));
				console.log("data : " + result.data);
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : " + jqXHR.status);
					console.log("code : " + jqXHR.responseJSON.code);
					console.log("message : " + jqXHR.responseJSON.message);
					console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				Common.alert("Faile : " + jqXHR.responseJSON.message);
			});
}

//	Save map
function fnSaveMap() {
	if ( false == fnValidMap() ) {
		return	false;
	}
	
	Common.ajax("POST"
			, "/scm/saveMap.do"
			, GridCommon.getEditData(unmapGridID)
			, function(result) {
				Common.alert(result.data + "<spring:message code='sys.msg.savedCnt'/>");
				fnSearchBtnList();
				
				console.log("Success : " + JSON.stringify(result));
				console.log("data : " + result.data);
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : " + jqXHR.status);
					console.log("code : " + jqXHR.responseJSON.code);
					console.log("message : " + jqXHR.responseJSON.message);
					console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				Common.alert("Faile : " + jqXHR.responseJSON.message);
			});
}

//	Validation SaveUnmap
function fnValidUnmap() {
	//var result	= true;
	var delList	= AUIGrid.getEditedRowItems(mapGridID);	//	we will delete checked item
	
	if ( 0 == delList.length ) {
		Common.alert("No Change");
		return false;
	}
	
	return	true;
}

//	Validation SaveMap
function fnValidMap() {
	var insList	= AUIGrid.getEditedRowItems(unmapGridID);	//	we will insert CDC selected item
	
	if ( 0 == insList.length ) {
		Common.alert("No Change");
		return false;
	}
	
	return	true;
}

function fnOnchanged(obj) {
	fnSearchBtnList();
}

function fnRefresh() {
	fnSearchBtnList();
}

//	행 삭제 메소드
function removeRow() {
	console.log("removeRow Method mapGridID ");
	AUIGrid.removeRow(mapGridID,"selectedIndex");
}

function fnSetGridComboList() {
	Common.ajaxSync("GET"
					, "/scm/selectComboSupplyCDC.do"
					, { codeMasterId: "349" }
					, function(result) {
						var cdcCnt	= cdcCodeList.length;
						if ( 0 < result.length ) {
							console.log("result : " + result.length);
							if ( 0 < cdcCodeList.length ) {
								console.log("cdcCodeList : " + cdcCodeList.length);
								for ( var i = 0 ; i < cdcCnt ; i++ ) {
									console.log("cdcCodeList : " + cdcCodeList);
									cdcCodeList.pop();
								}
							}
						}
						
						for ( var i = 0 ; i < result.length ; i++ ) {
							var list	= new Object();
							list.id		= result[i].code;
							list.value	= result[i].codeName;
							cdcCodeList.push(list);
						}
					});
	
	return	cdcCodeList;
}

function fnSelectCDCComboList() {
	CommonCombo.make("cdcCode"
					, "/scm/selectComboSupplyCDC.do"
					, { codeMasterId : "349" }
					, ""
					, {
						id  : "code",		//	use By query's parameter values
						name : "codeName",
						chooseMessage: "Select a CDC"
					}
					, "");
}

function fnSaveGridMap() {
	if ( false == fnValidationCheck(unmapGridID) ) {
		return	false;
	}
	
	Common.ajax("POST", "/scm/saveCdcWhMappingList.do"
				, GridCommon.getEditData(unmapGridID)
				, function(result) {
					Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
					fnSearchBtnList() ;
					
					console.log("성공." + JSON.stringify(result));
					console.log("data : " + result.data);
				}
				, function(jqXHR, textStatus, errorThrown) {
					try {
						console.log("Fail Status : " + jqXHR.status);
						console.log("code : "        + jqXHR.responseJSON.code);
						console.log("message : "     + jqXHR.responseJSON.message);
						console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
					} catch ( e ) {
						console.log(e);
					}
					Common.alert("Fail : " + jqXHR.responseJSON.message);
				});
}

function fnDelGridMap() {
	if ( false == fnValidationCheck(mapGridID) ) {
		return	false;
	}
	
	Common.ajax("POST", "/scm/saveCdcWhMappingList.do"
				, GridCommon.getEditData(mapGridID)
				, function(result) {
					Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
					fnSearchBtnList() ;
					
					console.log("성공." + JSON.stringify(result));
					console.log("data : " + result.data);
				}
				, function(jqXHR, textStatus, errorThrown) {
					try {
						console.log("Fail Status : " + jqXHR.status);
						console.log("code : "        + jqXHR.responseJSON.code);
						console.log("message : "     + jqXHR.responseJSON.message);
						console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
					} catch ( e ) {
						console.log(e);
					}
					Common.alert("Fail : " + jqXHR.responseJSON.message);
				});
}
/*
function fnUnmapped() {
	var mapCellIdx	= AUIGrid.getSelectedIndex(mapGridID);	//	get cell index from mapGridID
	var unmapCellIdx	= AUIGrid.getRowCount(unmapGridID);	//	get cell index from unmapGridID
	var item	= AUIGrid.getItemByRowIndex(mapGridID, mapCellIdx[0]);	//	행 인덱스의 행 아이템 얻기
	
	console.log("mapCellIdx : "  + mapCellIdx);
	console.log("unmapCellIdx : "  + unmapCellIdx);
	console.log("item : "  + item);
	
	if ( null == item ) {
		//	not selected from mapGridID
		return;
	} else {
		//	1. remove item from Mapped Warehouse grid(mapGridID)
		AUIGrid.removeRow(mapGridID, "selectedIndex");
		console.log("remove " + mapCellIdx + "th item");
		//	2. add item to Unmapped Warehouse grid(unmapGridID)
		AUIGrid.addRow(unmapGridID, item, unmapCellIdx + 1);
		console.log("add to " + unmapCellIdx + "th row");
	}
}
*/
//	excel export
function fnExcelExport(fileNm) {
	//	1. grid ID
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. exprot ExcelFileName  mapGridID, unmapGridID
	if ( "Mapped_Warehouses" == fileNm ) {
		GridCommon.exportTo("#MasterGridDiv", "xlsx", fileNm );
	} else {
		GridCommon.exportTo("#LocationGridDiv", "xlsx", fileNm );
	}
}


function auiCellEditignHandler(event) {
	if( "cellEditBegin" == event.type ) {
		console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	} else if ( "cellEditEnd" == event.type ) {
		console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
		
		if ( 2 == event.columnIndex && "SEQ NO" == event.headerText ) {
			//	SEQ NO
			if ( 1 > parseInt(event.value) ) {
				Common.alert("<spring:message code='sys.msg.mustMore' arguments='SEQ NO ; 0' htmlEscape='false' argumentSeparator=';' />");
				AUIGrid.restoreEditedCells(mapGridID, [event.rowIndex, "seqNo"] );
				return	false;
			}
		}
		
        if ( 1 == event.columnIndex && "CATEGORY NAME" == event.headerText ) {
			if ( 1 > parseInt(event.value) ) {
				Common.alert("<spring:message code='sys.msg.necessary' arguments='CATEGORY NAME' htmlEscape='false'/>");
				AUIGrid.restoreEditedCells(mapGridID, [event.rowIndex, "stusCtgryName"] );
				return	false;
			} else {
				AUIGrid.setCellValue(mapGridID, event.rowIndex, 2, AUIGrid.getCellValue(mapGridID, event.rowIndex, "stusCtgryName"));
			}
		}
	} else if ( "cellEditCancel" == event.type ) {
		console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	}
}

//	행 추가 이벤트 핸들러
function auiAddRowHandler(event) {
	console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
}

//	행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {
	console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

/*************************************
 **********  Grid-LayOut  ************
 *************************************/
var MstGridLayout	=
	[
	 	{
	 		dataField : "chk",
	 		//headerText : "<spring:message code='sys.scm.pomngment.chk'/>",
	 		headerText : "Sel",
	 		width : "10%",
	 		renderer :
	 			{
	 				type : "CheckBoxEditRenderer",
	 				//showLabel : true,
	 				editable : true,
	 				checkValue : "1",
	 				unCheckValue : "0",
	 				checkableFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	 					//	행 아이템의 charge가 anna라면 수정불가로 지정(기존값 유지)
	 					//if ( "KL" == item.cdc ) {
	 					//	return	false;
	 					//}
	 					return	true;
	 				}
	 			}
	 	},
		/*{
			dataField : "flag",
			headerText : "",
			style : "myLinkStyle",
			editable: false,
			
			//	LinkRenderer 를 활용하여 javascript 함수 호출로 사용하고자 하는 경우
			renderer :
				{
					type : "LinkRenderer",
					baseUrl : "javascript",
					//	baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
					jsCallback : function(rowIndex, columnIndex, value, item) {
						removeRow();
					}
				}
		},*/
		{
			dataField : "sysCode",
			//headerText : "<spring:message code='sys.scm.pomngment.cdc'/>",
			headerText : "SYS",
			width : "10%",
			editable : false,
			//visible : false,
		},
		{
			dataField : "cdcCode",
			//headerText : "<spring:message code='sys.scm.pomngment.cdcName'/>",
			headerText : "CDC",
			width : "10%",
			editable: false,
		},
		{
			dataField : "cdcName",
			//headerText : "<spring:message code='sys.scm.pomngment.cdcName'/>",
			headerText : "CDC Name",
			width : "20%",
			editable: false,
		},
		{
			dataField : "whLocId",
			headerText : "Warehouse Code",
			//width : "20%",
			editable : false,
			visible : false,
		},
		{
			dataField : "whLocCode",
			//headerText : "<spring:message code='sys.scm.whousemapping.whCode'/>",
			headerText : "Warehouse Code",
			width : "20%",
			editable : false,
		},
		{
			dataField : "whLocDesc",
			//headerText : "<spring:message code='sys.scm.whousemapping.whName'/>",
			headerText : "Warehouse Name",
			width : "30%",
			style : "aui-grid-left-column",
			editable : false,
		}
	];

var LocationGridLayout	=
	[
		{
			dataField : "cdc",
			//headerText : "<spring:message code='sys.scm.pomngment.cdc'/>",
			headerText : "CDC Name",
			width : "20%",
			renderer : {
				type : "DropDownListRenderer",
				showEditorBtnOver : true,
				listFunction : function(rowIndex, columnIndex, item, dataField) {
					return	cdcCodeList;
				},
				keyField : "id",
				valueField : "value",
			},
			labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
				var retStr	= value;
				var iCnt	= cdcCodeList.length;
				for ( var i = 0 ; i < iCnt ; i++ ) {
					if ( cdcCodeList[i]["id"] == value ) {
						retStr	= cdcCodeList[i]["value"];
						break;
					}
				}
				return	retStr;
			}
		},
		{
			dataField : "whId",
			headerText : "<spring:message code='sys.scm.whousemapping.whId'/>",
			//width : "20%",
			editable : false,
			visible : false,
		},
		{
			dataField : "whCode",
			headerText : "<spring:message code='sys.scm.whousemapping.whCode'/>",
			width : "20%",
			editable: false,
		},
		{
			dataField : "whName",
			headerText : "<spring:message code='sys.scm.whousemapping.whName'/>",
			width : "60%",
			style : "aui-grid-left-column",
			editable: false,
		}
	];

/****************************  Form Ready ******************************************/
var mapGridID, unmapGridID

$(document).ready(function() {
	var MstGridLayoutOptions	= {
			usePaging : true,
			//editable: false,
			useGroupingPanel : false,
			showRowNumColumn : false,	//	그리드 넘버링
			showStateColumn : true,		//	행 상태 칼럼 보이기
			enableRestore : true,
			softRemovePolicy : "exceptNew",	//	사용자추가한 행은 바로 삭제
	};
	
	//	masterGrid 그리드를 생성합니다.
	mapGridID	= GridCommon.createAUIGrid("MasterGridDiv", MstGridLayout,"", MstGridLayoutOptions);
	
	//	푸터 객체 세팅
	//AUIGrid.setFooter(mapGridID, footerObject);
	
	//	에디팅 시작 이벤트 바인딩
	AUIGrid.bind(mapGridID, "cellEditBegin", auiCellEditignHandler);
	
	//	에디팅 정상 종료 이벤트 바인딩
	AUIGrid.bind(mapGridID, "cellEditEnd", auiCellEditignHandler);
	
	//	에디팅 취소 이벤트 바인딩
	AUIGrid.bind(mapGridID, "cellEditCancel", auiCellEditignHandler);
	
	//	행 추가 이벤트 바인딩
	AUIGrid.bind(mapGridID, "addRow", auiAddRowHandler);
	
	//	행 삭제 이벤트 바인딩
	AUIGrid.bind(mapGridID, "removeRow", auiRemoveRowHandler);
	
	//	cellClick event.
	AUIGrid.bind(mapGridID, "cellClick", function( event ) {
		gSelRowIdx	= event.rowIndex;
		
		console.log("cellClick_Status: " + AUIGrid.isAddedById(mapGridID,AUIGrid.getCellValue(mapGridID, event.rowIndex, 0)) );
		console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );
	});
	
	//	셀 더블클릭 이벤트 바인딩
	AUIGrid.bind(mapGridID, "cellDoubleClick", function(event)
	{
		console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value + " total value : " );
	});


	/*****************************************
	 *********** Location Grid ***************
	******************************************/
	//	masterGrid 그리드를 생성합니다.
	unmapGridID	= GridCommon.createAUIGrid("LocationGridDiv", LocationGridLayout,"", MstGridLayoutOptions);
	//	AUIGrid 그리드를 생성합니다.
	
	//	푸터 객체 세팅
	//AUIGrid.setFooter(unmapGridID, footerObject);
	
	//	에디팅 시작 이벤트 바인딩
	AUIGrid.bind(unmapGridID, "cellEditBegin", auiCellEditignHandler);
	
	//	에디팅 정상 종료 이벤트 바인딩
	AUIGrid.bind(unmapGridID, "cellEditEnd", auiCellEditignHandler);
	
	//	에디팅 취소 이벤트 바인딩
	AUIGrid.bind(unmapGridID, "cellEditCancel", auiCellEditignHandler);
	
	//	행 추가 이벤트 바인딩
	AUIGrid.bind(unmapGridID, "addRow", auiAddRowHandler);
	
	//	행 삭제 이벤트 바인딩
	AUIGrid.bind(unmapGridID, "removeRow", auiRemoveRowHandler);
	
	//	cellClick event.
	AUIGrid.bind(unmapGridID, "cellClick", function( event ) {
		gSelRowIdx	= event.rowIndex;
		
		console.log("cellClick_Status: " + AUIGrid.isAddedById(unmapGridID,AUIGrid.getCellValue(unmapGridID, event.rowIndex, 0)) );
		console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );
	});
	
	//	셀 더블클릭 이벤트 바인딩
	AUIGrid.bind(unmapGridID, "cellDoubleClick", function(event) {
		console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
	});
});	//	$(document).ready
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
	<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
	<h2>CDC vs Warehouse Mapping</h2>
	<ul class="right_btns">
		<li><p class="btn_blue"><a onclick="fnSearchBtnList();"><span class="search"></span>Search</a></p></li>
	</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="" onsubmit="return false;">
	<input type ="hidden" id="planMasterId" name="planMasterId" value=""/>
	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
			<col style="width:130px" />
			<col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">CDC</th>
				<td>
					<select id="cdcCode" name="cdcCode" onChange="fnOnchanged(this);">
					</select>
				</td>
			</tr>
		</tbody>
	</table><!-- table end -->
	<div class="divine_auto mt30"><!-- divine_auto start -->
		<div style="width:50%;">
			<div class="border_box"><!-- border_box start -->
				<aside class="title_line"><!-- title_line start -->
					<h3 class="pt0">Mapped Warehouses</h3>
				</aside><!-- title_line end -->
				<ul class="right_btns">
					<!--<li><p class="btn_grid"><a onclick="fnDelGridMap();">Save Changes</a></p></li>-->
					<li><p class="btn_grid"><a onclick="fnAddCDC();">Add CDC</a></p></li>
					<li><p class="btn_grid"><a onclick="fnSaveUnmap();">Unmapping</a></p></li>
					<li><p class="btn_grid"><a onclick="fnExcelExport('Mapped_Warehouses');">EXCEL</a></p></li>
				</ul>
				<article class="grid_wrap"><!-- grid_wrap start -->
					<!-- 그리드 영역 1-->
					 <div id="MasterGridDiv" style="width:100%; height:350px; margin:0 auto;"></div>
				</article><!-- grid_wrap end -->
			</div><!-- border_box end -->
		</div>
<!-- 		<div style="width:10%;">
			<table style="width:100%; height:436px">
				<tr>
					<td style="width:100%; height:100%; vertical-align:middle; text-align:center;">
						<p class="btn_grid"><a onclick="fnUnmapped();">>></a></p>
						<br>
			 			<p class="btn_grid"><a onclick="fnMapped();"><<</a></p>
					</td>
				</tr>
			</table>
		</div> -->
		<div style="width:50%;">
			<div class="border_box"><!-- border_box start -->
				<aside class="title_line"><!-- title_line start -->
					<h3 class="pt0">Unmapped Warehouses</h3>
				</aside><!-- title_line end -->
				<ul class="right_btns">
					<!--<li><p class="btn_grid"><a onclick="fnSaveGridMap();">Save Changes</a></p></li>
					<li><p class="btn_grid"><a href="javascript:void(0);">Cancel Changes</a></p></li>
					<li><p class="btn_grid"><a onclick="fnRefresh();">Refresh</a></p></li>-->
					<li><p class="btn_grid"><a onclick="fnSaveMap();">Mapping</a></p></li>
				</ul>
				<article class="grid_wrap"><!-- grid_wrap start -->
					<!-- 그리드 영역 2-->
					 <div id="LocationGridDiv" style="width:100%; height:350px; margin:0 auto;"></div>
				</article><!-- grid_wrap end -->
			</div><!-- border_box end -->
		</div>
	</div><!-- divine_auto end -->
	<ul class="center_btns">
		<li>
			<p class="btn_blue2 big">
				<!-- <a href="javascript:void(0);">Download Raw Data</a> -->
			</p>
		</li>
	</ul>
	<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
		<p class="show_btn"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
		<dl class="link_list">
		<dt>Link</dt>
		<dd>
			<ul class="btns">
				<li><p class="link_btn"><a href="javascript:void(0);">menu1</a></p></li>
				<li><p class="link_btn"><a href="javascript:void(0);">menu2</a></p></li>
				<li><p class="link_btn"><a href="javascript:void(0);">menu3</a></p></li>
				<li><p class="link_btn"><a href="javascript:void(0);">menu4</a></p></li>
				<li><p class="link_btn"><a href="javascript:void(0);">Search Payment</a></p></li>
				<li><p class="link_btn"><a href="javascript:void(0);">menu6</a></p></li>
				<li><p class="link_btn"><a href="javascript:void(0);">menu7</a></p></li>
				<li><p class="link_btn"><a href="javascript:void(0);">menu8</a></p></li>
			</ul>
			<ul class="btns">
				<li><p class="link_btn type2"><a href="javascript:void(0);">menu1</a></p></li>
				<li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
				<li><p class="link_btn type2"><a href="javascript:void(0);">menu3</a></p></li>
				<li><p class="link_btn type2"><a href="javascript:void(0);">menu4</a></p></li>
				<li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
				<li><p class="link_btn type2"><a href="javascript:void(0);">menu6</a></p></li>
				<li><p class="link_btn type2"><a href="javascript:void(0);">menu7</a></p></li>
				<li><p class="link_btn type2"><a href="javascript:void(0);">menu8</a></p></li>
			</ul>
			<p class="hide_btn"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
		</dd>
		</dl>
	</aside><!-- link_btns_wrap end -->
</form>
</section><!-- search_table end -->
</section><!-- content end -->