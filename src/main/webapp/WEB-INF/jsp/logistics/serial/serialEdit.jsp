<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var myGridID;
var detailGridID;
var popGridId;
var selectedItem; 
var columnLayout = [
							{dataField:"serialNo" ,headerText:"serialNo",width:120 ,height:30},
							{dataField:"matnr" ,headerText:"matnr",width:120 ,height:30},
							{dataField:"latransit" ,headerText:"latransit",width:120 ,height:30},
							{dataField:"gltri" ,headerText:"gltri",width:120 ,height:30},
							{dataField:"lvorm" ,headerText:"lvorm",width:120 ,height:30},
							{dataField:"crtDt" ,headerText:"crtDt",width:120 ,height:30},
							{dataField:"crtUserId" ,headerText:"crtUserId",width:120 ,height:30},
							{dataField:"usedSerialNo" ,headerText:"usedSerialNo",width:120 ,height:30},
							{dataField:"usedMatnr" ,headerText:"usedMatnr",width:120 ,height:30},
							{dataField:"usedLocId" ,headerText:"usedLocId",width:120 ,height:30},
							{dataField:"usedGltri" ,headerText:"usedGltri",width:120 ,height:30},
							{dataField:"usedLwedt" ,headerText:"usedLwedt",width:120 ,height:30},
							{dataField:"usedSwaok" ,headerText:"usedSwaok",width:120 ,height:30},
							{dataField:"usedCrtDt" ,headerText:"usedCrtDt",width:120 ,height:30},
							{dataField:"usedCrtUserId" ,headerText:"usedCrtUserId",width:120 ,height:30}
                            ];
var detailLayout = [
							{dataField:"rdcSerialNo" ,headerText:"rdcSerialNo",width:120 ,height:30},
							{dataField:"rdcMatnr" ,headerText:"rdcMatnr",width:120 ,height:30},
							{dataField:"rdcLatransit" ,headerText:"rdcLatransit",width:120 ,height:30},
							{dataField:"rdcGltri" ,headerText:"rdcGltri",width:120 ,height:30},
							{dataField:"rdcLvorm" ,headerText:"rdcLvorm",width:120 ,height:30},
							{dataField:"rdcCrtDt" ,headerText:"rdcCrtDt",width:120 ,height:30},
							{dataField:"rdcCrtUserId" ,headerText:"rdcCrtUserId",width:120 ,height:30},
							
							{dataField:"usedSerialNo" ,headerText:"usedSerialNo",width:120 ,height:30},
							{dataField:"usedDelvryNo" ,headerText:"usedDelvryNo",width:120 ,height:30},
							{dataField:"usedPdelvryNoItm" ,headerText:"usedPdelvryNoItm",width:120 ,height:30},
							{dataField:"usedTtype" ,headerText:"usedTtype",width:120 ,height:30},
							{dataField:"usedCrtDt" ,headerText:"usedCrtDt",width:120 ,height:30},
							{dataField:"usedCrtUserId" ,headerText:"usedCrtUserId",width:120 ,height:30},
							{dataField:"usedSerialNo2" ,headerText:"usedSerialNo2",width:120 ,height:30},
							{dataField:"usedMatnr" ,headerText:"usedMatnr",width:120 ,height:30},
							{dataField:"usedLocId" ,headerText:"usedLocId",width:120 ,height:30},
							{dataField:"usedGltri" ,headerText:"usedGltri",width:120 ,height:30},
							{dataField:"usedLwedt" ,headerText:"usedLwedt",width:120 ,height:30},
							{dataField:"usedSwaok" ,headerText:"usedSwaok",width:120 ,height:30},
							{dataField:"usedCrtDt2" ,headerText:"usedCrtDt2",width:120 ,height:30},
							{dataField:"usedCrtUserId2" ,headerText:"usedCrtUserId2",width:120 ,height:30},
							
							{dataField:"docMatrlDocNo" ,headerText:"docMatrlDocNo",width:120 ,height:30},
							{dataField:"docMatrlDocYear" ,headerText:"docMatrlDocYear",width:120 ,height:30},
							{dataField:"docTrnscTypeCode" ,headerText:"docTrnscTypeCode",width:120 ,height:30},
							{dataField:"docDocDt" ,headerText:"docDocDt",width:120 ,height:30},
							{dataField:"docUsnam" ,headerText:"docUsnam",width:120 ,height:30},
							{dataField:"docPgm" ,headerText:"docPgm",width:120 ,height:30},
							{dataField:"docRefDocNo" ,headerText:"docRefDocNo",width:120 ,height:30},
							{dataField:"docDocHderTxt" ,headerText:"docDocHderTxt",width:120 ,height:30},
							{dataField:"docMainSalesOrdNo" ,headerText:"docMainSalesOrdNo",width:120 ,height:30},
							{dataField:"docCrtUserId" ,headerText:"docCrtUserId",width:120 ,height:30},
							{dataField:"docCrtDt" ,headerText:"docCrtDt",width:120 ,height:30},
							{dataField:"docMatrlDocNo2" ,headerText:"docMatrlDocNo2",width:120 ,height:30},
							{dataField:"docMatrlDocYear2" ,headerText:"docMatrlDocYear2",width:120 ,height:30},
							{dataField:"docMatrlDocItm" ,headerText:"docMatrlDocItm",width:120 ,height:30},
							{dataField:"docUniqIdntfcDocLne" ,headerText:"docUniqIdntfcDocLne",width:120 ,height:30},
							{dataField:"docIdntfcImdatSupirLne" ,headerText:"docIdntfcImdatSupirLne",width:120 ,height:30},
							{dataField:"docInvntryMovType" ,headerText:"docInvntryMovType",width:120 ,height:30},
							{dataField:"docAutoCrtItm" ,headerText:"docAutoCrtItm",width:120 ,height:30},
							{dataField:"docDebtCrditIndict" ,headerText:"docDebtCrditIndict",width:120 ,height:30},
							{dataField:"docMatrlNo" ,headerText:"docMatrlNo",width:120 ,height:30},
							{dataField:"docStorgLoc" ,headerText:"docStorgLoc",width:120 ,height:30},
							{dataField:"docVendorAccNo" ,headerText:"docVendorAccNo",width:120 ,height:30},
							{dataField:"docCustAccNo" ,headerText:"docCustAccNo",width:120 ,height:30},
							{dataField:"docPurchsStckTrnsfrOrd" ,headerText:"docPurchsStckTrnsfrOrd",width:120 ,height:30},
							{dataField:"docPurchsStckTrnsfrOrdItm" ,headerText:"docPurchsStckTrnsfrOrdItm",width:120 ,height:30},
							{dataField:"docSalesOrdNo" ,headerText:"docSalesOrdNo",width:120 ,height:30},
							{dataField:"docSalesOrdInItm" ,headerText:"docSalesOrdInItm",width:120 ,height:30},
							{dataField:"docDelvryNo" ,headerText:"docDelvryNo",width:120 ,height:30},
							{dataField:"docDelvryItmNo" ,headerText:"docDelvryItmNo",width:120 ,height:30},
							{dataField:"docStckTrnsfrReq" ,headerText:"docStckTrnsfrReq",width:120 ,height:30},
							{dataField:"docStckTrnsfrReqItmNo" ,headerText:"docStckTrnsfrReqItmNo",width:120 ,height:30},
							{dataField:"docOtrGrReq" ,headerText:"docOtrGrReq",width:120 ,height:30},
							{dataField:"docOtrGrReqItm" ,headerText:"docOtrGrReqItm",width:120 ,height:30},
							{dataField:"docResvtnHndStckReqNo" ,headerText:"docResvtnHndStckReqNo",width:120 ,height:30},
							{dataField:"docResvtnHndStckReqNoItm" ,headerText:"docResvtnHndStckReqNoItm",width:120 ,height:30},
							{dataField:"docPhysiclInvntryDoc" ,headerText:"docPhysiclInvntryDoc",width:120 ,height:30},
							{dataField:"docPhysiclInvntryDocLneNo" ,headerText:"docPhysiclInvntryDocLneNo",width:120 ,height:30},
							{dataField:"docQty" ,headerText:"docQty",width:120 ,height:30},
							{dataField:"docMeasureBasUnit" ,headerText:"docMeasureBasUnit",width:120 ,height:30},
							{dataField:"docMatrlDocOrgnYear" ,headerText:"docMatrlDocOrgnYear",width:120 ,height:30},
							{dataField:"docMatrlDocNoOrgn" ,headerText:"docMatrlDocNoOrgn",width:120 ,height:30},
							{dataField:"docMatrlDocItmOrgn" ,headerText:"docMatrlDocItmOrgn",width:120 ,height:30},
							{dataField:"docItmTxt" ,headerText:"docItmTxt",width:120 ,height:30},
							{dataField:"docGoodsRciptShipToParty" ,headerText:"docGoodsRciptShipToParty",width:120 ,height:30},
							{dataField:"docRcivIssuMatrl" ,headerText:"docRcivIssuMatrl",width:120 ,height:30},
							{dataField:"docRcivIssuStorgLoc" ,headerText:"docRcivIssuStorgLoc",width:120 ,height:30},
							{dataField:"docTrnscEventType" ,headerText:"docTrnscEventType",width:120 ,height:30},
							{dataField:"docDocPostngDt" ,headerText:"docDocPostngDt",width:120 ,height:30},
							{dataField:"docRefDocNo2" ,headerText:"docRefDocNo2",width:120 ,height:30},
							{dataField:"docMainOrdNo" ,headerText:"docMainOrdNo",width:120 ,height:30},
							{dataField:"docTrnscCode" ,headerText:"docTrnscCode",width:120 ,height:30},
							{dataField:"docCostCentr" ,headerText:"docCostCentr",width:120 ,height:30},
							{dataField:"docPrjctNo" ,headerText:"docPrjctNo",width:120 ,height:30},
							{dataField:"docOrdNo" ,headerText:"docOrdNo",width:120 ,height:30},
							{dataField:"docMainAssetNo" ,headerText:"docMainAssetNo",width:120 ,height:30},
							{dataField:"docGlAccNo" ,headerText:"docGlAccNo",width:120 ,height:30},
							{dataField:"docCrtUserId2" ,headerText:"docCrtUserId2",width:120 ,height:30},
							{dataField:"docCrtDt2" ,headerText:"docCrtDt2",width:120 ,height:30}

                            ];
var popLayout = [
							{dataField:"serialNoPop" ,headerText:"Serial Number",width:120 ,height:30, editable:true},
							{dataField:"matnrPop" ,headerText:"Material Number",width:120 ,height:30 , editable:true},
							{dataField:"latransitPop" ,headerText:"Location",width:120 ,height:30 , editable:true},
							{dataField:"gltriPop" ,headerText:"Product Finished Date in HQ",width:120 ,height:30 , editable:true,
								dataType : "date",
							    formatString : "dd/mm/yyyy",
							    editRenderer : {
							        type : "CalendarRenderer",
							        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
							        onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
							        showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
							    }
							},
							{dataField:"lvormPop" ,headerText:"Deletion Flag for Serial",width:120 ,height:30 , editable:true},
							{dataField:"crtDtPop" ,headerText:"Create Date",width:120 ,height:30 , editable:true,
							    dataType : "date",
                                formatString : "dd/mm/yyyy",
                                editRenderer : {
                                    type : "CalendarRenderer",
                                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                    onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                    showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                }	
							},
							{dataField:"crtUserIdPop" ,headerText:"Create User",width:120 ,height:30 , editable:true}
							/*
							{dataField:"usedSerialNoPop" ,headerText:"usedSerialNo",width:120 ,height:30 , editable:true},
							{dataField:"usedMatnrPop" ,headerText:"usedMatnr",width:120 ,height:30 , editable:true} ,
							{dataField:"usedLocIdPop" ,headerText:"usedLocId",width:120 ,height:30 , editable:true},
							{dataField:"usedGltriPop" ,headerText:"usedGltri",width:120 ,height:30 , editable:true},
							{dataField:"usedLwedtPop" ,headerText:"usedLwedt",width:120 ,height:30 , editable:true},
							{dataField:"usedSwaokPop" ,headerText:"usedSwaok",width:120 ,height:30 , editable:true},
							{dataField:"usedCrtDtPop" ,headerText:"usedCrtDt",width:120 ,height:30 , editable:true},
							{dataField:"usedCrtUserIdPop" ,headerText:"usedCrtUserId",width:120 ,height:30 , editable:true}
                            */
							];

//그리드 속성 설정
var gridPros = {
    // 페이지 설정
    usePaging : true,               
    pageRowCount : 10,              
    //fixedColumnCount : 1,
    // 편집 가능 여부 (기본값 : false)
    editable : false,                
    // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
    enterKeyColumnBase : true,                
    // 셀 선택모드 (기본값: singleCell)
    //selectionMode : "multipleCells",                
    // 컨텍스트 메뉴 사용 여부 (기본값 : false)
    useContextMenu : true,                
    // 필터 사용 여부 (기본값 : false)
    enableFilter : true,            
    // 그룹핑 패널 사용
    //useGroupingPanel : true,                
    // 상태 칼럼 사용
    showStateColumn : true,                
    // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
    displayTreeOpen : true,                
    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",                
    groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",                
    //selectionMode : "multipleCells",
    //rowIdField : "stkid",
    enableSorting : true,
    //showRowCheckColumn : true,

};

var subgridPros = {
	    // 페이지 설정
	    usePaging : false,               
	   // pageRowCount : 1,              
	    //fixedColumnCount : 1,
	    // 편집 가능 여부 (기본값 : false)
	    editable : true,                
	    // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
	    //enterKeyColumnBase : true,                
	    // 셀 선택모드 (기본값: singleCell)
	    // 컨텍스트 메뉴 사용 여부 (기본값 : false)
	    //useContextMenu : true,                
	    // 필터 사용 여부 (기본값 : false)
	   // enableFilter : true,            
	    // 그룹핑 패널 사용
	    //useGroupingPanel : true,                
	    // 상태 칼럼 사용
	   // showStateColumn : true,                
	    // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
	   // displayTreeOpen : true,                
	    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",                
	    groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />" ,             
	    //selectionMode : "multipleCells",
	    //rowIdField : "stkid",
	    //enableSorting : true,
	    //showRowCheckColumn : true,'
	    	softRemoveRowMode:false

	};

$(document).ready(function(){
	   myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridPros);
	   detailGridID = GridCommon.createAUIGrid("grid_wrap_2nd", detailLayout,"", gridPros);
	   popGridId  = GridCommon.createAUIGrid("popup_wrap_div", popLayout,"", subgridPros);
	   $("#popup_wrap").hide();
	   $("#grid_wrap_2nd_art").hide();
	
	   AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
		   //TODO 상세그리드 함수 호출
	        if (event.dataField == "serialNo"){
			   fn_detailSerialInfo(event.value);
	        }
        });
	   AUIGrid.bind(popGridId, "cellEditEnd", function (event){
		   var serialNo = AUIGrid.getCellValue(popGridId, event.rowIndex, "serialNoPop");
		   //serial=serialNo.trim();
		   if(""==serialNo || null ==serialNo){
		          Common.alert('Please input Serial Number.');
		           return false;
		   }else{
			   fn_serialChck(serialNo);
		   }  
		   
	        if(event.dataField == "matnrPop"){
	            $("#svalue").val(AUIGrid.getCellValue(popGridId, event.rowIndex, "itmcd"));
	            $("#sUrl").val("/logistics/material/materialcdsearch.do");
	            Common.searchpopupWin("popupForm", "/common/searchPopList.do","stock");
	        }
	   });
	   
	
	$(function(){
		$("#create").click(function(){
	        AUIGrid.clearGridData(popGridId);
	         //popGridId  = GridCommon.createAUIGrid("popup_wrap_div", popLayout,"", subgridPros);
	        AUIGrid.resize(popGridId,980,150); 
			$("#popup_title").text("Create Serial Number");
			$("#popup_wrap").show();
			$("#add").show();
		});
		$("#edit").click(function(){
			AUIGrid.destroy(popGridId)
			popGridId  = GridCommon.createAUIGrid("popup_wrap_div", popLayout,"", subgridPros);
			selectedItem = AUIGrid.getSelectedIndex(myGridID);
		   
		    if(selectedItem[0] > -1){
			 fn_editSerial(selectedItem[0]);
			}else{
				 Common.alert('Choice Data please..');
			}
		
		});
		$("#save").click(function(){
	        selectedItem = AUIGrid.getSelectedIndex(myGridID);
			//$("#popup_wrap").hide();
			//fn_popSave(selectedItem[0]);
			fn_popSave();
		});
		$("#search").click(function(){
			$("#popup_wrap").hide();
			searchAjax();
		});
		$("#cancel").click(function(){
			$("#popup_wrap").hide();
		});
		$("#add").click(function(){
			  fn_newSerial();
		});
		
		
	});
	
});

function searchAjax() {
    var url = "/logistics/serial/searchSeialList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        //console.log(data);
        AUIGrid.setGridData(myGridID, data.dataList);
    });
}       

function fn_detailSerialInfo(serialNo){
    var url = "/logistics/serial/selectSerialDetails.do";
    var param = "serialNo="+serialNo;
    Common.ajax("GET" , url , param , function(data){
    	//console.log(data);
        AUIGrid.setGridData(detailGridID, data.dataList);
    });
	   $("#grid_wrap_2nd_art").show();
};

function fn_editSerial(index){
	var serialNo =AUIGrid.getCellValue(myGridID ,index,'serialNo');
	var url = "/logistics/serial/selectSerialOne.do";
    var param = "serialNo="+serialNo ;
    Common.ajax("GET" , url , param , function(data){
        AUIGrid.resize(popGridId,980,150); 
        AUIGrid.setGridData(popGridId, data.dataList);
        $("#popup_title").text("Edit Serial Number");
        $("#popup_wrap").show();
        $("#add").hide();
    });
};

function fn_popSave(index){
	//var serialNo =AUIGrid.getCellValue(myGridID ,index,'serialNo');
    var url = "/logistics/serial/modifySerialOne.do";
    var param = GridCommon.getEditData(popGridId) ;
    console.log("param");
    console.log(param);
    Common.ajax("POST" , url , param , function(data){
		$("#popup_wrap").hide();
        searchAjax();
    });
	
};

function fn_newSerial(){
	//AUIGrid.resize(popGridId,980,150); 
    var item = new Object();
    AUIGrid.addRow(popGridId, item, "last");
};

function fn_serialChck(str){
    var url = "/logistics/serial/newSerialCheck.do";
    var param = "serialNo="+str ;
    Common.ajax("GET" , url , param , function(data){
    	if(data.dataList.length > 0){
    		Common.alert("Input Serial Number does't exist.");
    		AUIGrid.restoreEditedRows(popGridId, "selectedIndex");
    	}
    });
}


function fn_itempopList(data){
    console.log(data);
    var rtnVal = data[0].item.itemcode;
    selectedItem = AUIGrid.getSelectedIndex(popGridId);
    var rowIndex=selectedItem[0];
    var columnIndex=selectedItem[1];
    AUIGrid.setCellValue(popGridId, rowIndex ,columnIndex-1, rtnVal);
   } 
</script>
        
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Logistics</li>
    <li>EDIT-Serial Number</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>EDIT-Serial Number</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a id="create">Create</a></p></li>
    <li><p class="btn_blue"><a id="edit">Edit</a></p></li>
    <!-- <li><p class="btn_blue"><a id="view">View</a></p></li> -->
    <li><p class="btn_blue"><a id="search">Search</a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="searchForm" name="searchForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Material Master</th>
    <td>
    <input type="text" id="srchmaterial" name="srchmaterial"  class="w100p" />
    <!-- date_set start -->
<!--     <div class="date_set">
    <p>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </p>
    <span>~</span>
    <p>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </p>
    </div> --><!-- date_set end -->

    </td>
    <th scope="row">Serial Number</th>
    <td>
    <input type="text" id="srchserial" name="srchserial"  class="w100p" />
<!--     <div class="date_set"> 
    <p>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </p>
    <span>~</span>
    <p>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </p>
    </div> --><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Location</th>
    <td>
    <input type="text" id="srchloc" name="srchloc"  class="w100p" />
    <!-- <div class="date_set"> 
    <p>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </p>
    <span>~</span>
    <p>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </p>
    </div> --><!-- date_set end -->

    </td>
    <th scope="row">GR Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p>
    <input id="srchgrdtfrom" name="srchgrdtfrom" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
    </p>
    <span>~</span>
    <p>
    <input id="srchgrdtto" name="srchgrdtto" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
    </p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Create Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p>
  <input id="srchcrtdtfrom" name="srchcrtdtfrom" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
    </p>
    <span>~</span>
    <p>
    <input id="srchcrtdtto" name="srchcrtdtto" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
    </p>
    </div><!-- date_set end -->

    </td>
    <th scope="row">GI Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p>
    <input id="srchcitdtfrom" name="srchcitdtfrom" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
    </p>
    <span>~</span>
    <p>
   <input id="srchcitdtto" name="srchcitdtto" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
    </p>
    </div><!-- date_set end -->

    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->


<article class="grid_wrap" id="grid_wrap_2nd_art"><!-- grid_wrap start -->
<aside class="title_line"><!-- title_line start -->
<h3>Material Document Info</h3>
</aside><!-- title_line end -->
	<div id="grid_wrap_2nd"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->

        
<hr />

<div id="popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title">Create Serial Number</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a id="add">Add</a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="popup_wrap_div"></div>
</article><!-- grid_wrap end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="save">SAVE</a></p></li>
                <li><p class="btn_blue2 big"><a id="cancel">CANCEL</a></p></li>
            </ul>
</section><!-- pop_body end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</div><!-- popup_wrap end -->

 