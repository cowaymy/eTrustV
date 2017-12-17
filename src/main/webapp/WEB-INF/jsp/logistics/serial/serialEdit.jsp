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
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
/* 커스텀 셀 스타일 */
.my-cell-style {
    background:#FF007F;
    font-weight:bold;
    color:#fff;
}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var myGridID;
var detailGridID;
var popGridId;
var myGridIDExcel;
var myGridIDExcelHide;

var decedata = [{"code":"Y","codeName":"Y"},{"code":"N","codeName":"N"}];

var selectedItem; 
var columnLayout = [
								{dataField: "serialNo",headerText :"<spring:message code='log.head.serialnumber'/>" ,width:500 ,height:30},                         
								{dataField: "matnr",headerText :"<spring:message code='log.head.materialcode'/>"    ,width:120 ,height:30},                         
								{dataField: "stkDesc",headerText :"<spring:message code='log.head.materialname'/>"  ,width:200 ,height:30},                         
								{dataField: "stkCtgryNm",headerText :"<spring:message code='log.head.catagorytype'/>"   ,width:150 ,height:30},                         
								{dataField: "boxNo",headerText :"<spring:message code='log.head.materialtype'/>"    , width:150, height:30},                        
								{dataField: "lvorm",headerText :"<spring:message code='log.head.deletion'/>"    ,width:150 ,height:30},                         
								{dataField: "gltri",headerText :"<spring:message code='log.head.proddate'/>"    ,width:150 ,height:30},                         
								{dataField: "latransit",headerText :"<spring:message code='log.head.latransit'/>"   ,width:120 ,height:30, visible:false},                          
								//        {dataField:   "gltri",headerText :"<spring:message code='log.head.gltri'/>"   ,width:120 ,height:30},                         
								//        {dataField:   "lvorm",headerText :"<spring:message code='log.head.lvorm'/>"   ,width:120 ,height:30},                         
								{dataField: "crtDt",headerText :"<spring:message code='log.head.createdate'/>"  ,width:120 ,height:30},                         
								//       {dataField:    "crtUserId",headerText :"<spring:message code='log.head.createuser'/>"  ,width:120 ,height:30},                         
								{dataField: "crtUserName",headerText :"<spring:message code='log.head.createuser'/>"    ,width:120 ,height:30},                         
								{dataField: "usedSerialNo",headerText :"<spring:message code='log.head.usedserialno'/>" ,width:120 ,height:30, visible:false},                          
								{dataField: "usedMatnr",headerText :"<spring:message code='log.head.usedmatnr'/>"   ,width:120 ,height:30, visible:false},                          
								{dataField: "usedLocId",headerText :"<spring:message code='log.head.usedlocid'/>"   ,width:120 ,height:30, visible:false},                          
								{dataField: "usedGltri",headerText :"<spring:message code='log.head.usedgltri'/>"   ,width:120 ,height:30, visible:false},                          
								{dataField: "usedLwedt",headerText :"<spring:message code='log.head.usedlwedt'/>"   ,width:120 ,height:30, visible:false},                          
								{dataField: "usedSwaok",headerText :"<spring:message code='log.head.usedswaok'/>"   ,width:120 ,height:30, visible:false},                          
								{dataField: "usedCrtDt",headerText :"<spring:message code='log.head.usedcrtdt'/>"   ,width:120 ,height:30, visible:false},                          
								{dataField: "usedCrtUserId",headerText :"<spring:message code='log.head.usedcrtuserid'/>"   ,width:120 ,height:30, visible:false} 
                            ];
                            
var excelLayout2 = [
							{dataField: "serialNo",headerText :"<spring:message code='log.head.serialnumber'/>" ,width:500 ,height:30},                         
							{dataField: "matnr"  ,headerText:    "<spring:message code='log.head.matnr'/>"   ,width:120 ,height:30},                         
							{dataField: "gltri"  ,headerText:    "<spring:message code='log.head.gltri'/>"   ,width:120 ,height:30},                         
							{dataField: "exist"  ,headerText:    "<spring:message code='log.head.exist'/>"   ,width:120 ,height:30} 
		                   
		                   ];

var excelLayout = [
							{dataField: "serialNo",headerText :"<spring:message code='log.head.serial_number'/>"    ,width:500 ,height:30},                         
							{dataField: "matnr"  ,headerText:    "<spring:message code='log.head.matnr'/>"   ,width:120 ,height:30},                         
							{dataField: "gltri"  ,headerText:    "<spring:message code='log.head.gltri'/>"   ,width:120 ,height:30}                          
							];
                            
var detailLayout = [
							{dataField:  "rdcSerialNo",headerText :"<spring:message code='log.head.rdcserialno'/>"   ,width:120 ,height:30},                         
							{dataField: "rdcMatnr",headerText :"<spring:message code='log.head.rdcmatnr'/>" ,width:120 ,height:30},                         
							{dataField: "rdcLatransit",headerText :"<spring:message code='log.head.rdclatransit'/>" ,width:120 ,height:30},                         
							{dataField: "rdcGltri",headerText :"<spring:message code='log.head.rdcgltri'/>" ,width:120 ,height:30},                         
							{dataField: "rdcLvorm",headerText :"<spring:message code='log.head.rdclvorm'/>" ,width:120 ,height:30},                         
							{dataField: "rdcCrtDt",headerText :"<spring:message code='log.head.rdccrtdt'/>" ,width:120 ,height:30},                         
							{dataField: "rdcCrtUserId",headerText :"<spring:message code='log.head.rdccrtuserid'/>" ,width:120 ,height:30},     
							
							{dataField: "usedSerialNo",headerText :"<spring:message code='log.head.usedserialno'/>" ,width:120 ,height:30},                         
							{dataField: "usedDelvryNo",headerText :"<spring:message code='log.head.useddelvryno'/>" ,width:120 ,height:30},                         
							 {dataField: "usedPdelvryNoItm",headerText :"<spring:message code='log.head.usedpdelvrynoitm'/>" ,width:120 ,height:30},                         
							 {dataField: "usedTtype",headerText :"<spring:message code='log.head.usedttype'/>"   ,width:120 ,height:30},                         
							 {dataField: "usedCrtDt",headerText :"<spring:message code='log.head.usedcrtdt'/>"   ,width:120 ,height:30},                         
							 {dataField: "usedCrtUserId",headerText :"<spring:message code='log.head.usedcrtuserid'/>"   ,width:120 ,height:30},                         
							 {dataField: "usedSerialNo2",headerText :"<spring:message code='log.head.usedserialno2'/>"   ,width:120 ,height:30},                         
							 {dataField: "usedMatnr",headerText :"<spring:message code='log.head.usedmatnr'/>"   ,width:120 ,height:30},                         
							 {dataField: "usedLocId",headerText :"<spring:message code='log.head.usedlocid'/>"   ,width:120 ,height:30},                         
							 {dataField: "usedGltri",headerText :"<spring:message code='log.head.usedgltri'/>"   ,width:120 ,height:30},                         
							 {dataField:  "usedLwedt",headerText :"<spring:message code='log.head.usedlwedt'/>"   ,width:120 ,height:30},                         
							 {dataField: "usedSwaok",headerText :"<spring:message code='log.head.usedswaok'/>"   ,width:120 ,height:30},                         
							 {dataField: "usedCrtDt2",headerText :"<spring:message code='log.head.usedcrtdt2'/>" ,width:120 ,height:30},                         
							 {dataField: "usedCrtUserId2",headerText :"<spring:message code='log.head.usedcrtuserid2'/>" ,width:120 ,height:30},  
							
							 {dataField:"docMatrlDocNo",headerText :"<spring:message code='log.head.docmatrldocno'/>"   ,width:120 ,height:30},                         
							 {dataField:"docMatrlDocYear",headerText :"<spring:message code='log.head.docmatrldocyear'/>"   ,width:120 ,height:30},                         
							 {dataField:"docTrnscTypeCode",headerText :"<spring:message code='log.head.doctrnsctypecode'/>" ,width:120 ,height:30},                         
							 {dataField:"docDocDt",headerText :"<spring:message code='log.head.docdocdt'/>" ,width:120 ,height:30},                         
							 {dataField:"docUsnam",headerText :"<spring:message code='log.head.docusnam'/>" ,width:120 ,height:30},                         
							 {dataField:"docPgm",headerText :"<spring:message code='log.head.docpgm'/>" ,width:120 ,height:30},                         
							 {dataField:"docRefDocNo",headerText :"<spring:message code='log.head.docrefdocno'/>"   ,width:120 ,height:30},                         
							 {dataField:"docDocHderTxt",headerText :"<spring:message code='log.head.docdochdertxt'/>"   ,width:120 ,height:30},                         
							 {dataField:"docMainSalesOrdNo",headerText :"<spring:message code='log.head.docmainsalesordno'/>"   ,width:120 ,height:30},                         
							 {dataField:"docCrtUserId",headerText :"<spring:message code='log.head.doccrtuserid'/>" ,width:120 ,height:30},                         
							 {dataField:"docCrtDt",headerText :"<spring:message code='log.head.doccrtdt'/>" ,width:120 ,height:30},                         
							 {dataField:"docMatrlDocNo2",headerText :"<spring:message code='log.head.docmatrldocno2'/>" ,width:120 ,height:30},                         
							 {dataField:"docMatrlDocYear2",headerText :"<spring:message code='log.head.docmatrldocyear2'/>" ,width:120 ,height:30},                         
							 {dataField:"docMatrlDocItm",headerText :"<spring:message code='log.head.docmatrldocitm'/>" ,width:120 ,height:30},                         
							 {dataField:"docUniqIdntfcDocLne",headerText :"<spring:message code='log.head.docuniqidntfcdoclne'/>"   ,width:120 ,height:30},                         
							 {dataField:"docIdntfcImdatSupirLne",headerText :"<spring:message code='log.head.docidntfcimdatsupirlne'/>" ,width:120 ,height:30},                         
							 {dataField:"docInvntryMovType",headerText :"<spring:message code='log.head.docinvntrymovtype'/>"   ,width:120 ,height:30},                         
							 {dataField:"docAutoCrtItm",headerText :"<spring:message code='log.head.docautocrtitm'/>"   ,width:120 ,height:30},                         
							 {dataField:"docDebtCrditIndict",headerText :"<spring:message code='log.head.docdebtcrditindict'/>" ,width:120 ,height:30},                         
							 {dataField:"docMatrlNo",headerText :"<spring:message code='log.head.docmatrlno'/>" ,width:120 ,height:30},                         
							 {dataField:"docStorgLoc",headerText :"<spring:message code='log.head.docstorgloc'/>"   ,width:120 ,height:30},                         
							 {dataField:"docVendorAccNo",headerText :"<spring:message code='log.head.docvendoraccno'/>" ,width:120 ,height:30},                         
							 {dataField:"docCustAccNo",headerText :"<spring:message code='log.head.doccustaccno'/>" ,width:120 ,height:30},                         
							 {dataField:"docPurchsStckTrnsfrOrd",headerText :"<spring:message code='log.head.docpurchsstcktrnsfrord'/>" ,width:120 ,height:30},                         
							 {dataField:"docPurchsStckTrnsfrOrdItm",headerText :"<spring:message code='log.head.docpurchsstcktrnsfrorditm'/>"   ,width:120 ,height:30},                         
							 {dataField:"docSalesOrdNo",headerText :"<spring:message code='log.head.docsalesordno'/>"   ,width:120 ,height:30},                         
							 {dataField:"docSalesOrdInItm",headerText :"<spring:message code='log.head.docsalesordinitm'/>" ,width:120 ,height:30},                         
							 {dataField:"docDelvryNo",headerText :"<spring:message code='log.head.docdelvryno'/>"   ,width:120 ,height:30},                         
							 {dataField:"docDelvryItmNo",headerText :"<spring:message code='log.head.docdelvryitmno'/>" ,width:120 ,height:30},                         
							 {dataField:"docStckTrnsfrReq",headerText :"<spring:message code='log.head.docstcktrnsfrreq'/>" ,width:120 ,height:30},                         
							 {dataField:"docStckTrnsfrReqItmNo",headerText :"<spring:message code='log.head.docstcktrnsfrreqitmno'/>"   ,width:120 ,height:30},                         
							 {dataField:"docOtrGrReq",headerText :"<spring:message code='log.head.docotrgrreq'/>"   ,width:120 ,height:30},                         
							 {dataField:"docOtrGrReqItm",headerText :"<spring:message code='log.head.docotrgrreqitm'/>" ,width:120 ,height:30},                         
							 {dataField:"docResvtnHndStckReqNo",headerText :"<spring:message code='log.head.docresvtnhndstckreqno'/>"   ,width:120 ,height:30},                         
							 {dataField:"docResvtnHndStckReqNoItm",headerText :"<spring:message code='log.head.docresvtnhndstckreqnoitm'/>" ,width:120 ,height:30},                         
							 {dataField:"docPhysiclInvntryDoc",headerText :"<spring:message code='log.head.docphysiclinvntrydoc'/>" ,width:120 ,height:30},                         
							 {dataField:"docPhysiclInvntryDocLneNo",headerText :"<spring:message code='log.head.docphysiclinvntrydoclneno'/>"   ,width:120 ,height:30},                         
							 {dataField:"docQty",headerText :"<spring:message code='log.head.docqty'/>" ,width:120 ,height:30},                         
							 {dataField:"docMeasureBasUnit",headerText :"<spring:message code='log.head.docmeasurebasunit'/>"   ,width:120 ,height:30},                         
							 {dataField:"docMatrlDocOrgnYear",headerText :"<spring:message code='log.head.docmatrldocorgnyear'/>"   ,width:120 ,height:30},                         
							 {dataField:"docMatrlDocNoOrgn",headerText :"<spring:message code='log.head.docmatrldocnoorgn'/>"   ,width:120 ,height:30},                         
							 {dataField:"docMatrlDocItmOrgn",headerText :"<spring:message code='log.head.docmatrldocitmorgn'/>" ,width:120 ,height:30},                         
							 {dataField:"docItmTxt",headerText :"<spring:message code='log.head.docitmtxt'/>"   ,width:120 ,height:30},                         
							 {dataField:"docGoodsRciptShipToParty",headerText :"<spring:message code='log.head.docgoodsrciptshiptoparty'/>" ,width:120 ,height:30},                         
							 {dataField:"docRcivIssuMatrl",headerText :"<spring:message code='log.head.docrcivissumatrl'/>" ,width:120 ,height:30},                         
							 {dataField:"docRcivIssuStorgLoc",headerText :"<spring:message code='log.head.docrcivissustorgloc'/>"   ,width:120 ,height:30},                         
							 {dataField:"docTrnscEventType",headerText :"<spring:message code='log.head.doctrnsceventtype'/>"   ,width:120 ,height:30},                         
							 {dataField:"docDocPostngDt",headerText :"<spring:message code='log.head.docdocpostngdt'/>" ,width:120 ,height:30},                         
							 {dataField:"docRefDocNo2",headerText :"<spring:message code='log.head.docrefdocno2'/>" ,width:120 ,height:30},                         
							 {dataField:"docMainOrdNo",headerText :"<spring:message code='log.head.docmainordno'/>" ,width:120 ,height:30},                         
							 {dataField:"docTrnscCode",headerText :"<spring:message code='log.head.doctrnsccode'/>" ,width:120 ,height:30},                         
							 {dataField:"docCostCentr",headerText :"<spring:message code='log.head.doccostcentr'/>" ,width:120 ,height:30},                         
							 {dataField:"docPrjctNo",headerText :"<spring:message code='log.head.docprjctno'/>" ,width:120 ,height:30},                         
							 {dataField:"docOrdNo",headerText :"<spring:message code='log.head.docordno'/>" ,width:120 ,height:30},                         
							 {dataField:"docMainAssetNo",headerText :"<spring:message code='log.head.docmainassetno'/>" ,width:120 ,height:30},                         
							 {dataField:"docGlAccNo",headerText :"<spring:message code='log.head.docglaccno'/>" ,width:120 ,height:30},                         
							 {dataField:"docCrtUserId2",headerText :"<spring:message code='log.head.doccrtuserid2'/>"   ,width:120 ,height:30},                         
							 {dataField:"docCrtDt2",headerText :"<spring:message code='log.head.doccrtdt2'/>"   ,width:120 ,height:30}  
                            ];
var popLayout = [
			                 {dataField:    "serialNoPop",headerText :"<spring:message code='log.head.serialnumber'/>"  ,width:250 ,height:30, editable:true},                          
			                 {dataField:    "matnrPop",headerText :"<spring:message code='log.head.materialnumber'/>"   ,width:250 ,height:30 , editable:true},                         
			                 {dataField:    "latransitPop",headerText :"<spring:message code='log.head.location'/>" ,width:120 ,height:30 , editable:true, visible:false},                          
			                 {dataField:    "gltriPop",headerText :"<spring:message code='log.head.productfinisheddateinhq'/>"  ,width:206 ,height:30 , editable:true,      
								dataType : "date",
							    formatString : "dd/mm/yyyy",
							    editRenderer : {
							        type : "CalendarRenderer",
							        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
							        onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
							        showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
							    }
							},
							{dataField:  "lvormPop",headerText :"<spring:message code='log.head.deletionflagforserial'/>"    ,width:200 ,height:30 , editable:true   
								,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
		                            var retStr = "";
		                            for(var i=0,len=decedata.length; i<len; i++) {
		                                if(decedata[i]["code"] == value) {
		                                    retStr = decedata[i]["code"];
		                                    break;
		                                }
		                            }
		                            return retStr == "" ? value : retStr;
		                        },editRenderer : 
		                        {
		                           type : "ComboBoxRenderer",
		                           showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
		                           list : decedata,
		                           keyField : "code",
		                           valueField : "code"
		                        }
						    },
						    {dataField:  "crtDtPop",headerText :"<spring:message code='log.head.createdate'/>"   ,width:120 ,height:30 , editable:true, visible:false,   
							    dataType : "date",
                                formatString : "dd/mm/yyyy",
                                editRenderer : {
                                    type : "CalendarRenderer",
                                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                    onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                    showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                }	
							},
							{dataField:  "crtUserIdPop",headerText :"<spring:message code='log.head.createuser'/>"   ,width:120 ,height:30 , editable:true, visible:false}                       
							/*
							 {dataField:    "usedSerialNoPop",headerText :"<spring:message code='log.head.usedserialno'/>"  ,width:120 ,height:30 , editable:true},                         
							 {dataField:    "usedMatnrPop",headerText :"<spring:message code='log.head.usedmatnr'/>"    ,width:120 ,height:30 , editable:true} ,                        
							 {dataField:    "usedLocIdPop",headerText :"<spring:message code='log.head.usedlocid'/>"    ,width:120 ,height:30 , editable:true},                         
							 {dataField:    "usedGltriPop",headerText :"<spring:message code='log.head.usedgltri'/>"    ,width:120 ,height:30 , editable:true},                         
							 {dataField:    "usedLwedtPop",headerText :"<spring:message code='log.head.usedlwedt'/>"    ,width:120 ,height:30 , editable:true},                         
							 {dataField:    "usedSwaokPop",headerText :"<spring:message code='log.head.usedswaok'/>"    ,width:120 ,height:30 , editable:true},                         
							 {dataField:    "usedCrtDtPop",headerText :"<spring:message code='log.head.usedcrtdt'/>"    ,width:120 ,height:30 , editable:true},                         
							 {dataField:    "usedCrtUserIdPop",headerText :"<spring:message code='log.head.usedcrtuserid'/>"    ,width:120 ,height:30 , editable:true} 
                            */
							];

//그리드 속성 설정
var gridPros = {
    // 페이지 설정
    usePaging : false,                  
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
    exportURL : "/common/exportGrid.do"
};

var subgridPros = {
	    // 페이지 설정
	    usePaging : false,               
	    editable : true,                
	    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",                
	    groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />" ,             
	    softRemoveRowMode:false
	};

$(document).ready(function(){
	//createInitGrid();
    
    // IE10, 11은 readAsBinaryString 지원을 안함. 따라서 체크함.
    var rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";

    // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
    function checkHTML5Brower() {
        var isCompatible = false;
        if (window.File && window.FileReader && window.FileList && window.Blob) {
            isCompatible = true;
        }
        return isCompatible;
    };
	
	   myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridPros);
	   myGridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout ,"", gridPros);
	   //detailGridID = GridCommon.createAUIGrid("grid_wrap_2nd", detailLayout,"", gridPros);
	  popGridId  = GridCommon.createAUIGrid("popup_wrap_div", popLayout,"", subgridPros);
	   $("#popup_wrap").hide();
// 	   $("#grid_wrap_2nd_art").hide();
	
	   AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
		   console.log(event);
	   });
	   
	   AUIGrid.bind(popGridId, "cellEditBegin", function (event){
		   if(event.dataField == "matnrPop" && event.value == ""){
               $("#svalue").val(AUIGrid.getCellValue(popGridId, event.rowIndex, "matnrPop"));
               $("#sUrl").val("/logistics/material/materialcdsearch.do");
               Common.searchpopupWin("popupForm", "/common/searchPopList.do","stock");
           }
	   });
	   
	   AUIGrid.bind(popGridId, "cellEditEnd", function (event){
		   var serialNo = AUIGrid.getCellValue(popGridId, event.rowIndex, "serialNoPop");
		   if(event.dataField == "serialNoPop" ){
			   if(event.value == ""){
			      Common.alert('Please input Serial Number.');
			      return false;
			   }else{
				   fn_serialChck(serialNo);
			   }
		   }
	   });
	   
	
	$(function(){
		doGetCombo('/common/selectCodeList.do', '11', '','srchcatagorytype', 'M' , 'f_multiCombo'); 
		doGetCombo('/common/selectCodeList.do', '15', '','materialtype', 'M' , 'f_multiCombo');
		doDefCombo([{"codeId": "Y","codeName": "Y"},{"codeId": "N","codeName": "N"}], '' ,'delfg', 'S', '');
		$("#create").click(function(){
	        AUIGrid.clearGridData(popGridId);
	         //popGridId  = GridCommon.createAUIGrid("popup_wrap_div", popLayout,"", subgridPros);
			$("#popup_title").text("Create Serial Number");
			$("#popup_wrap").show();
			$("#add").show();
	        AUIGrid.resize(popGridId); 
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
			var fromVal = $("#srchcrtdtfrom").val();
			var toVal = $("#srchcrtdtto").val();
			var from =  new Date( $("#srchcrtdtfrom").datepicker("getDate"));
			var to =  new Date( $("#srchcrtdtto").datepicker("getDate"));
			if("" != $("#srchcrtdtfrom").val() &&  "" == $("#srchcrtdtto").val()){
					Common.alert("Please Check Create To Date.")
                     $("#srchcrtdtto").focus();   
					return false;
			}else if("" == $("#srchcrtdtfrom").val() &&   "" != $("#srchcrtdtto").val()){
					Common.alert("Please Check Create From Date.")
                     $("#srchcrtdtfrom").focus();   
					return false;
			}else if("" !=  $("#srchcrtdtfrom").val() && "" !=  $("#srchcrtdtto").val() ){
				if(0>= to - from ){
					Common.alert("Please Check Create Date.")
					return false;
				}
				
			}
			
			if ($("#srchmaterial").val() == "" && $("#srchserial").val() == "" && $("#srchcrtdtfrom").val() == "" && $("#srchcrtdtto").val() == ""
				&& $("#srchcatagorytype").val() == "" && $("#materialtype").val() == ""	&& $("#delfg").val() == ""   ){
				Common.alert('Please select at least one search condition.');
			}else{
			    searchAjax();
			}
		});
	    $("#clear").click(function(){
	        $("#searchForm")[0].reset();
	        doGetCombo('/common/selectCodeList.do', '11', '','srchcatagorytype', 'M' , 'f_multiCombo'); 
	        doGetCombo('/common/selectCodeList.do', '15', '','materialtype', 'M' , 'f_multiCombo');
	    });	
		$("#cancel").click(function(){
			$("#popup_wrap").hide();
		});
		$("#add").click(function(){
			  fn_newSerial();
		});
		$("#copy").click(function(){
            fn_newSerialCopy();
      });
	    $('#excelUp').click(function() {
	        //AUIGrid.clearGridData(myGridIDExcel);
	    	AUIGrid.destroy(myGridIDExcel)
	    	myGridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout ,"", gridPros);
	        $("#popup_wrap_excel_up").show();
	        createInitGrid();
	    });
	    $('#excelDown').click(function() {
	        // 그리드의 숨겨진 칼럼이 있는 경우, 내보내기 하면 엑셀에 아예 포함시키지 않습니다.
	        // 다음처럼 excelProps 에서 exceptColumnFields 을 지정하십시오.
	        var excelProps = {
	                
	            fileName     : "Sereial Excel Upload(Mass)",
	            //sheetName : $("#txtlocCode").text(),
	            
	            //exceptColumnFields : ["cntQty"], // 이름, 제품, 컬러는 아예 엑셀로 내보내기 안하기.
	            
	             //현재 그리드의 히든 처리된 칼럼의 dataField 들 얻어 똑같이 동기화 시키기
	           exceptColumnFields : AUIGrid.getHiddenColumnDataFields(myGridIDExcelHide) 
	        };
	        
	        //AUIGrid.exportToXlsx(myGridIDHide, excelProps);
	        //AUIGrid.exportToXlsx(myGridIDExcelHide, excelProps);
	        GridCommon.exportTo("grid_wrap", "xlsx", "Serial Number");
	    });
	    
	    $('#saveExcel').click(function() {
	        //giFunc();
	        fn_excelSave();
	        
	    });
	    $('#cancelExcel').click(function() {
	    	 $('.auto_file input[type=text]').val('');
	        AUIGrid.clearGridData(myGridIDExcel);
	        $("#popup_wrap_excel_up").hide();
	    });
	    $('#fileSelector').on('change', function(evt) {
	        if (!checkHTML5Brower()) {
	            //alert("브라우저가 HTML5 를 지원하지 않습니다.\r\n서버로 업로드해서 해결하십시오.");
	            alert("This Browse doesn't support HTML5 .");
	            return;
	        } else {
	            var data = null;
	            var file = evt.target.files[0];
	            if (typeof file == "undefined") {
	                Commom.alert("Please Select File.");
	                return;
	            }
	            var reader = new FileReader();

	            reader.onload = function(e) {
	                var data = e.target.result;

	                /* 엑셀 바이너리 읽기 */
	                
	                var workbook;

	                if(rABS) { // 일반적인 바이너리 지원하는 경우
	                    workbook = XLSX.read(data, {type: 'binary'});
	                } else { // IE 10, 11인 경우
	                    var arr = fixdata(data);
	                    workbook = XLSX.read(btoa(arr), {type: 'base64'});
	                }

	                var jsonObj = process_wb(workbook);
	                
	                createAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
	            };

	            if(rABS) reader.readAsBinaryString(file);
	            else reader.readAsArrayBuffer(file);
	            
	        }
	    });
	    $("#srchmaterial").keypress(function(event) {
            if (event.which == '13') {
            	$("#svalue").val($("#srchmaterial").val());
                $("#sUrl").val("/logistics/material/materialcdsearch.do");
                $("#searchtype").val("search");
                Common.searchpopupWin("popupForm", "/common/searchPopList.do","stock");
            }
        });
		
	});
	
});

function searchAjax() {
    var url = "/logistics/serial/searchSeialList.do";
    var param = $('#searchForm').serializeJSON();
    
    Common.ajax("POST" , url , param , function(data){
        
        AUIGrid.setGridData(myGridID, data.dataList);
    });
}       

function fn_detailSerialInfo(serialNo){
    var url = "/logistics/serial/selectSerialDetails.do";
    var param = "serialNo="+serialNo;
    Common.ajax("GET" , url , param , function(data){
    	
        AUIGrid.setGridData(detailGridID, data.dataList);
    });
// 	   $("#grid_wrap_2nd_art").show();
};

function fn_editSerial(index){
	var serialNo =AUIGrid.getCellValue(myGridID ,index,'serialNo');
	var url = "/logistics/serial/selectSerialOne.do";
    var param = "serialNo="+serialNo ;
    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(popGridId, data.dataList);
        $("#popup_title").text("Edit Serial Number");
        $("#popup_wrap").show();
        $("#add").hide();
//        AUIGrid.resize(popGridId,980,150); 
        AUIGrid.resize(popGridId); 
    });
};

function fn_popSave(index){
	//var serialNo =AUIGrid.getCellValue(myGridID ,index,'serialNo');
    var url = "/logistics/serial/modifySerialOne.do";
    var param = GridCommon.getEditData(popGridId) ;
    var bool = true;
    for (var i = 0 ; i < param.add.length ; i++){
    	var p = param.add[i];
    	if (selialValidationchk(p)){
    		return false;
    		break;
    	}
    }
    for (var i = 0 ; i < param.update.length ; i++){
    	var p = param.update[i];
        if (selialValidationchk(p)){
            return false;
            break;
        }
    }
    
    Common.ajax("POST" , url , param , function(data){
		$("#popup_wrap").hide();
// 	    searchAjax();
    });
	
};

function selialValidationchk(pm){
	if (pm.serialNoPop == ""){
        Common.alert('Please enter the serial number.');
        return true;
    }else if (pm.serialNoPop.length > 18){
    	Common.alert('The serial number is up to 18 digits.');
        return true;
    }
    if (pm.matnrPop == ""){
    	Common.alert('Please enter the Material Code.');
        return true;
    }
    if (pm.gltriPop =="" || pm.gltriPop == undefined){
    	Common.alert('Please enter the Product Finished Date in HQ.');
        return true;
    }
}

function fn_newSerial(){
	//AUIGrid.resize(popGridId,980,150); 
//     var item = { serialNoPop : "", matnrPop : ""};
//     AUIGrid.addRow(popGridId, item, "last");

	$("#svalue").val('');
    $("#sUrl").val("/logistics/material/materialcdsearch.do");
    Common.searchpopupWin("popupForm", "/common/searchPopList.do","stock");
};

function fn_newSerialCopy(){
	var selectedItem = AUIGrid.getSelectedItems(popGridId);
	console.log(selectedItem);
	
	if (selectedItem == undefined){
		Common.alert('Please select the data to be copied.');
		return false;
	}
	
	var rowPos = "first";
    var rowList = {
            serialNoPop : '' ,
            matnrPop : selectedItem[0].item.matnrPop,
            gltriPop : selectedItem[0].item.gltriPop
    };
    
    AUIGrid.addRow(popGridId, rowList, rowPos);
    
}

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
    
    var rtnVal = data[0].item;
    
    if ($("#searchtype").val() == "search"){
    	$("#srchmaterial").val(rtnVal.itemcode);
    	
    }else{
// 	    selectedItem = AUIGrid.getSelectedItems(popGridId);
// 	    console.log(AUIGrid.getCellValue(popGridId, selectedItem.rowIndex ,"matnrPop"));
// 	    AUIGrid.setCellValue(popGridId, selectedItem.rowIndex ,"matnrPop", rtnVal.itemcode);
// 	    //AUIGrid.updateRow(popGridId, { "matnrPop" : rtnVal.itemcode }, selectedItem.rowIndex);
        
    	var rowPos = "first";
        var rowList = {
        		serialNoPop : '' ,
        		matnrPop : rtnVal.itemcode
        };
        
        AUIGrid.addRow(popGridId, rowList, rowPos);
        
    }
    $("#searchtype").val('');
} 
   
   
   
   
   
function fn_excelSave(){
    var param  =  {};
    for (var i = 0 ; i < AUIGrid.getRowCount(myGridIDExcel) ; i++){
        if (AUIGrid.getCellValue(myGridIDExcel , i , "exist") == 'Y'){
            Common.alert("Please check the serial.")
            return false;
        }
	    var cnt =0;
	    for (var j = 0 ; j < AUIGrid.getRowCount(myGridIDExcel) ; j++){
	        if(AUIGrid.getCellValue(myGridIDExcel , i , "serialNo") ==  AUIGrid.getCellValue(myGridIDExcel , j , "serialNo"))
	        	   cnt++;
	       }
	    
	    if(cnt>1){
	    	  Common.alert("Same Serial Number exist :"+AUIGrid.getCellValue(myGridIDExcel , i , "serialNo"));
	    	  return false;
	    }
	    
    }
    param.add = AUIGrid.exportToObject("#popup_wrap_excel");
    
    Common.ajax("POST", "/logistics/serial/saveExcelGrid.do",param , function(result) {
    	 Common.alert(result.message);
    },  function(jqXHR, textStatus, errorThrown) {
        try {
              
        } catch (e) {
            
        }

        alert("Fail : " + jqXHR.responseJSON.message);
    });
    $("#popup_wrap_excel_up").hide();
    
}

//IE10, 11는 바이너리스트링 못읽기 때문에 ArrayBuffer 처리 하기 위함.
function fixdata(data) {
    var o = "", l = 0, w = 10240;
    for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
    o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
    return o;
};

// 파싱된 시트의 CDATA 제거 후 반환.
function process_wb(wb) {
    var output = "";
    output = JSON.stringify(to_json(wb));
    output = output.replace( /<!\[CDATA\[(.*?)\]\]>/g, '$1' );
    return JSON.parse(output);
};

// 엑셀 시트를 파싱하여 반환
function to_json(workbook) {
    var result = {};
    workbook.SheetNames.forEach(function(sheetName) {
        var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName],{defval:""});
        if(roa.length >= 0){
            result[sheetName] = roa;
        }
    });
    return result;
}

// 엑셀 파일 시트에서 파싱한 JSON 데이터 기반으로 그리드 동적 생성
function createAUIGrid(jsonData) {
    if(AUIGrid.isCreated(myGridIDExcel)) {
        AUIGrid.destroy(myGridIDExcel);
        myGridIDExcel = null;
    }
    // 그리드 생성
    myGridIDExcel = AUIGrid.create("#popup_wrap_excel", excelLayout2 );
     
     for(var i = 0; i<jsonData.length; i++){
    	var serialChck = jsonData[i].Serial_Number;
    	var matrChck = jsonData[i].Material_Code;
    	var glChck = jsonData[i].Producted_Date;
    	fn_serialExist(serialChck,matrChck,glChck);
    	
    	
    }

};
function fn_serialExist(serialChck,matrChck,glChck){
	var sortingInfo = [];
    // 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
    sortingInfo[0] = { dataField : "serialNo", sortType : 1 }; // 오름차순 1
    sortingInfo[1] = { dataField : "matnr", sortType : 1 }; // 오름차순 1
	var rowPos = "last";
	var rowList = [];
	   var param =
	    {
			   serialChck    : serialChck,
			   matrChck     : matrChck
	   };
 
	        Common.ajaxSync("GET", "/logistics/serial/selectSerialExist.do", param, function(result) {
	               
	               var data = result.dataList;
	               rowList ={
	            		   serialNo    : serialChck,
	            		   matnr       : matrChck,
	            		   gltri         : glChck
	              
	               }
				            if(data.length==0){
        			               $.extend(rowList,{'exist':'N'});
				            }else{
           	  		               $.extend(rowList,{'exist':'Y'});
				            }
	               AUIGrid.addRow(myGridIDExcel, rowList, rowPos);  
	    });
	               AUIGrid.setSorting(myGridIDExcel, sortingInfo);
	               
	               changeRowStyleFunction();
}
function changeRowStyleFunction() {
    // row Styling 함수를 다른 함수로 변경
    AUIGrid.setProp(myGridIDExcel, "rowStyleFunction", function(rowIndex, item) {
        if(item.exist == "Y") {
            return "my-row-style";
        }
        return "";
    });
    
    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
    AUIGrid.update(myGridIDExcel);
};

//최초 그리드 생성..
function createInitGrid() {

    // 실제로 #grid_wrap 에 그리드 생성
    myGridIDExcel = AUIGrid.create("#popup_wrap_excel", excelLayout, gridPros);
    
    // 그리드 최초에 빈 데이터 넣음.
    AUIGrid.setGridData(myGridIDExcel, []);
   // AUIGrid.resize(myGridIDExcel,1203);
    AUIGrid.resize(myGridIDExcel);
}

function f_multiCombo() {
    $(function() {
        $('#srchcatagorytype').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택 
            width : '80%'
        });
        $('#materialtype').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택 
            width : '80%'
        });
    });
}
</script>
        
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Logistics</li>
    <li>Serial Number</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Serial Number</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a id="create">New</a></p></li>
    <li><p class="btn_blue"><a id="edit">Edit</a></p></li>
    <!-- <li><p class="btn_blue"><a id="view">View</a></p></li> -->
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="searchForm" name="searchForm">
<input type="hidden" id="searchtype" name="searchtype"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Material Code</th>
    <td>
        <input type="text" id="srchmaterial" name="srchmaterial"  class="w100p" />
    </td>
    <th scope="row">Serial Number</th>
    <td>
        <input type="text" id="srchserial" name="srchserial"  class="w100p" />
    </td>
        <th scope="row">Create Date</th>
    <td>
	    <div class="date_set w100p"><!-- date_set start -->
		    <p>
		      <input id="srchcrtdtfrom" name="srchcrtdtfrom" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
		    </p>
	            <span>To</span>
		    <p>
		       <input id="srchcrtdtto" name="srchcrtdtto" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
		    </p>
	    </div><!-- date_set end -->
    </td>
</tr>
<tr>
   
    <th scope="row">Material Type</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="materialtype" name="materialtype[]"  /></select>
    </td>
     <th scope="row">Material Category</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="srchcatagorytype" name="srchcatagorytype[]" /></select>
    </td>
    <th scope="row">Deletion Flag</th>
    <td>
        <select class="w100p" id="delfg" name="delfg" /></select>
    </td>    
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="excelUp"><spring:message code='sys.btn.excel.up' /></a></p></li>
 <li><p class="btn_grid"><a id="excelDown"><spring:message code='sys.btn.excel.dw' /></a></p></li>
<!--     <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>  -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap" style="height:450px"></div>
        <div id="grid_wrap_hide" style="display: none;"></div>
</article><!-- grid_wrap end -->


<!-- <article class="grid_wrap" id="grid_wrap_2nd_art">grid_wrap start -->
<!-- <aside class="title_line">title_line start -->
<!-- <h3>Material Document Info</h3> -->
<!-- </aside>title_line end -->
<!-- 	<div id="grid_wrap_2nd"></div> -->
<!-- </article>grid_wrap end -->

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
    <li><p class="btn_blue"><a id="copy">Copy</a></p></li>
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

<div id="popup_wrap_excel_up" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title">Serial Number Excel Upload</h1>
<!-- <ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul> -->
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<ul class="right_btns">
    <!-- <li><p class="btn_blue"><a id="add">Add</a></p></li> -->
    
    <li><p class="btn_blue"><div class="auto_file"><!-- auto_file start -->
                                    <input type="file" id="fileSelector" title="file add" accept=".xlsx"/>
                                </div>
    </p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
       <div id="popup_wrap_excel"></div>
</article><!-- grid_wrap end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="saveExcel">SAVE</a></p></li>
                <li><p class="btn_blue2 big"><a id="cancelExcel">CANCEL</a></p></li>
            </ul>
</section><!-- pop_body end -->
</div>
 