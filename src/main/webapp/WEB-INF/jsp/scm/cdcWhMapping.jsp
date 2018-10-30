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
	fnScmCdcCbBox();
	fnScmCdcGridCbBox();
	fnSearch();
});

//	Cdc
function fnScmCdcCbBox() {
	CommonCombo.make("scmCdcCbBox"
			, "/scm/selectScmCdc.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
			}
			, "");
}

//	cdc grid
function fnScmCdcGridCbBox() {
	Common.ajaxSync("GET"
			, "/scm/selectScmCdc.do"
			, ""
			, function(result) {
				var cdcCnt	= cdcCodeList.length;
				if ( 0 < result.length ) {
					if ( 0 < cdcCodeList.length ) {
						for ( var i = 0 ; i < cdcCnt ; i++ ) {
							cdcCodeList.pop();
						}
					}
				}
				for ( var i = 0 ; i < result.length ; i++ ) {
					var list	= new Object();
					list.id		= result[i].id;
					list.value	= result[i].name;
					cdcCodeList.push(list);
				}
			});
	
	return	cdcCodeList;
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

//	Add CDC
function fnAddCDC() {
	var popUpObj	= Common.popupDiv("/scm/cdcWhMappingPopupView.do"
			, $("#MainForm").serializeJSON()
			, null
			, false
			, "cdcWhMappingPopup"
	);
}

//	search
function fnSearch() {
	//	search parameters
	var params	= {
			scmCdcCbBox : $("#scmCdcCbBox").multipleSelect("getSelects")
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
		, "/scm/selectCdcWhList.do"
		, params
		, function(result) {
			console.log(result);
			AUIGrid.setGridData(mapGridID, result.selectCdcWhMappingList);
			AUIGrid.setGridData(unmapGridID, result.selectCdcWhUnmappingList);
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
				fnSearch();
				
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
				fnSearch();
				
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
			useGroupingPanel : false,
			showRowNumColumn : false,	//	그리드 넘버링
			showStateColumn : true,		//	행 상태 칼럼 보이기
			enableRestore : true,
			softRemovePolicy : "exceptNew",	//	사용자추가한 행은 바로 삭제
	};
	
	//	Mapped Grid
	mapGridID	= GridCommon.createAUIGrid("MasterGridDiv", MstGridLayout,"", MstGridLayoutOptions);
	//	Unmapped Grid
	unmapGridID	= GridCommon.createAUIGrid("LocationGridDiv", LocationGridLayout,"", MstGridLayoutOptions);
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
		<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
	</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="" onsubmit="return false;">
	<input type ="hidden" id="planMasterId" name="planMasterId" value=""/>
	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
			<col style="width:130px" />
			<col style="width:200px" />
			<col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">CDC</th>
				<td>
					<select class="w100p" id="scmCdcCbBox" name="scmCdcCbBox"></select>
				</td>
				<td></td>
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
					<li><p class="btn_grid"><a onclick="fnAddCDC();">Add CDC</a></p></li>
					<li><p class="btn_grid"><a onclick="fnSaveUnmap();">Unmapping</a></p></li>
					<li><p class="btn_grid"><a onclick="fnExcelExport('Mapped_Warehouses');">EXCEL</a></p></li>
				</ul>
				<article class="grid_wrap"><!-- grid_wrap start -->
					<!-- 그리드 영역 1-->
					 <div id="MasterGridDiv" style="width:100%; height:700px; margin:0 auto;"></div>
				</article><!-- grid_wrap end -->
			</div><!-- border_box end -->
		</div>
		<div style="width:50%;">
			<div class="border_box"><!-- border_box start -->
				<aside class="title_line"><!-- title_line start -->
					<h3 class="pt0">Unmapped Warehouses</h3>
				</aside><!-- title_line end -->
				<ul class="right_btns">
					<li><p class="btn_grid"><a onclick="fnSaveMap();">Mapping</a></p></li>
				</ul>
				<article class="grid_wrap"><!-- grid_wrap start -->
					<!-- 그리드 영역 2-->
					 <div id="LocationGridDiv" style="width:100%; height:700px; margin:0 auto;"></div>
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