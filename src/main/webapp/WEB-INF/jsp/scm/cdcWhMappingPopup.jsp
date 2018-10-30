<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
	text-align:left;
}
</style>

<script type="text/javaScript">
$(function() {
	fnSearch();
});
function fnClose() {
	$("#cdcWhMappingPopup").remove();
}

function fnSearch() {
	Common.ajax("GET"
			, "/general/selectDetailCodeList.do"
			, $("#PopForm").serialize()
			, function(result) {
				AUIGrid.setGridData(CdcGridId, result);
			});
}

//	add
function fnAddCdc() {
	var item	= new Object();
	
	item.detailcodeid	= "";
	item.detailcode		= "";
	item.detailcdename	= "";
	item.detailcodedesc	= "";
	item.detaildisabled	= "N";
	item.codeMasterId	= 349;	//	We use only 349 CODE_MASTER_ID
	
	AUIGrid.addRow(CdcGridId, item, "last");
}

//	save
function fnSaveCdc() {
	if ( false == fnValidationCdcCheck() ) {
		return	false;
	}
	
	Common.ajax("POST"
			, "/general/saveDetailCommCode.do"
			, GridCommon.getEditData(CdcGridId)
			, function(result) {
				Common.alert(result.data + "<spring:message code='sys.msg.saveCnt' />");
				fnSearch();
				fnClose();
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
				
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}

function fnValidationCdcCheck() {
	var result	= true;
	var insList	= AUIGrid.getAddedRowItems(CdcGridId);
	var updList	= AUIGrid.getEditedRowItems(CdcGridId);
	var delList	= AUIGrid.getRemovedItems(CdcGridId);
	
	if ( 0 == insList.length && 0 == updList.length && 0 == delList.length ) {
		Common.alert("No Change");
		return	false;
	}
	
	for ( var i = 0 ; i < insList.length ; i++ ) {
		var detCode	= insList[i].detailcode;
		var codeMstId	= insList[i].codeMasterId;
		var detCodeName	= insList[i].detailcodename;
		
		if ( "" == detCode || 0 == detCode.length ) {
			result	= false;
			//	{0} is required.
			Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail Code' htmlEscape='false'/>");
			break;
		}
		if ( "" == codeMstId || 0 == codeMstId.length ) {
			result	= false;
			//	{0} is required.
			Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail Code Master' htmlEscape='false'/>");
			break;
		}
		if ( "" == detCodeName || 0 == detCodeName.length ) {
			result	= false;
			//	{0} is required.
			Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail Code Name' htmlEscape='false'/>");
			break;
		}
	}
	
	for ( var i = 0 ; i < updList.length ; i++ ) {
		var codeMstId	= updList[i].codeMasterId;
		var detCode		= updList[i].detailcode;
		
		if ( "" == detCode || 0 == detCode.length ) {
			result	= false;
			//	{0} is required.
			Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail Code' htmlEscape='false'/>");
			break;
		}
		if ( "" == codeMstId || 0 == codeMstId.length ) {
			result	= false;
			//	{0} is required.
			Common.alert("<spring:message code='sys.msg.necessary' arguments='Detail Code Master' htmlEscape='false'/>");
			break;
		}
	}
	
	return	result;
}

/***************************************************[ Main GRID] ***************************************************/
var CdcGridId;
var CdcGridLayout	=
	[
	 	{
	 		dataField : "detailcodeid",
	 		//headerText : "<spring:message code='sys.generalCode.grid1.CODE_ID' />",
	 		headerText : "CODE ID' />",
	 		//width : "12%",
	 		visible : false,
	 	},
	 	{
	 		dataField : "detailcode",
	 		//headerText : "<spring:message code='sys.generalCode.grid1.CODE' />",
	 		headerText : "SYS CODE",
	 		width : "15%",
	 		visible : true,
	 	},
	 	{
	 		dataField : "detailcodedesc",
	 		//headerText : "<spring:message code='sys.generalCode.grid1.DESCRIPTION' />",
	 		headerText : "CODE",
	 		style : "aui-grid-center-column",
	 		width : "15%%",
	 	},
	 	{
	 		dataField : "detailcodename",
	 		headerText : "<spring:message code='sys.generalCode.grid1.NAME' />",
	 		style : "aui-grid-left-column",
	 		width : "50%",
	 	},
	 	{
	 		dataField : "detaildisabled",
	 		headerText : "<spring:message code='sys.generalCode.grid1.DISABLED' />",
	 		width : "20%",
	 		editRenderer : {
	 			type : "ComboBoxRenderer",
	 			showEditorBtnOver : true,
	 			listFunction : function(rowIndex, columnIndex, item, dataField) {
	 				var list	= ["N", "Y"];
	 				return	list;
	 			},
	 			keyField : "id"
	 		}
	 	},
	 	{
	 		dataField : "codeMasterId",
	 		headerText : "<spring:message code='sys.generalCode.grid1.CODE_MASTER_ID' />",
	 		//width : "8%",
	 		editable : false,
	 		visible : false
	 	}
	 ];
var MainGridOptions	=
{
	usePaging : true,
	//pagingMode : "simple",	//	페이징을 간단한 유형으로 나오도록 설정
	useGroupingPanel : false,
	editable : true,
	showStateColumn : true,		//	행 상태 칼럼 보이기
	showRowNumColumn : false	//	그리드 넘버링
};

$(document).ready(function() {
	//	Create AUIGrid
	CdcGridId	= GridCommon.createAUIGrid("CdcGridDiv", CdcGridLayout, "", MainGridOptions);
	
	//	Event Block
	//	Cell Click event
	AUIGrid.bind(CdcGridId, "cellClick", function(event) {
		$("#cdcCode").val(AUIGrid.getCellValue(CdcGridId, event.rowIndex, "cdcCode"));
	});
	
	//	Cell Double Click event
	AUIGrid.bind(CdcGridId, "cellDoubleClick", function(event) {
		console.log("cellDoubleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
	});
	
	//	Begin Cell editing
	AUIGrid.bind(CdcGridId, "cellEditBegin", function(event) {
		//	
		if ( "N" == event.item.edit ) {
			if ( "cdcCode" == event.dataField ) {
				return	false;
			}
		}
		return	true;
	});
});	//$(document).ready
</script>

<body>
	<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>CDC Master Add</h1>
		<ul class="right_opt">
			<!-- <li><p class="btn_blue2"><a onclick="fnClose();">CLOSE</a></p></li>  -->
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body" style="height:346px;"><!-- pop_body start -->
		<form id="PopForm" method="get" action="" onsubmit="return false;">
			<input type ="hidden" id="mstCdId" name="mstCdId" value="349"/>
			<aside class="title_line"><!-- title_line start -->
				<ul class="right_btns">
					<li>
						<span>Disabled</span>
						<select id="dtailDisabled" name="dtailDisabled">
							<option value="" selected>All</option>
							<option value="1">Y</option>
							<option value="0">N</option>
						</select>   
					</li>
					<li><p class="btn_grid"><a onclick="fnSaveCdc();">Save</a></p></li>
					<li><p class="btn_grid"><a onclick="fnAddCdc();">Add</a></p></li>   
				</ul>
			</aside><!-- title_line end -->
			<article class="grid_wrap" style="height:100px;"><!-- grid_wrap start -->
				<!--  그리드 영역2  -->
				<div id="CdcGridDiv"></div> 
				<ul class="center_btns">
					<li><p class="btn_blue2 big"><a onclick="fnClose();">Close</a></p></li>
				</ul>
			</article><!-- grid_wrap end -->
		</form>
	</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
</body>
</html>