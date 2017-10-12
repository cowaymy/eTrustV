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
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
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
							{dataField:"serialNo" ,headerText:"Serial Number",width:500 ,height:30},
							{dataField:"matnr" ,headerText:"Material Code",width:120 ,height:30},
							{dataField:"stkDesc" ,headerText:"Material Name",width:200 ,height:30},
							{dataField:"stkCtgryNm" ,headerText:"Catagory Type",width:150 ,height:30},
							{dataField:"latransit" ,headerText:"latransit",width:120 ,height:30, visible:false},
							{dataField:"gltri" ,headerText:"gltri",width:120 ,height:30, visible:false},
							{dataField:"lvorm" ,headerText:"lvorm",width:120 ,height:30, visible:false},
							{dataField:"crtDt" ,headerText:"Create Date",width:120 ,height:30},
							{dataField:"crtUserId" ,headerText:"Create User",width:120 ,height:30},
							{dataField:"usedSerialNo" ,headerText:"usedSerialNo",width:120 ,height:30, visible:false},
							{dataField:"usedMatnr" ,headerText:"usedMatnr",width:120 ,height:30, visible:false},
							{dataField:"usedLocId" ,headerText:"usedLocId",width:120 ,height:30, visible:false},
							{dataField:"usedGltri" ,headerText:"usedGltri",width:120 ,height:30, visible:false},
							{dataField:"usedLwedt" ,headerText:"usedLwedt",width:120 ,height:30, visible:false},
							{dataField:"usedSwaok" ,headerText:"usedSwaok",width:120 ,height:30, visible:false},
							{dataField:"usedCrtDt" ,headerText:"usedCrtDt",width:120 ,height:30, visible:false},
							{dataField:"usedCrtUserId" ,headerText:"usedCrtUserId",width:120 ,height:30, visible:false}
                            ];
                            
var excelLayout2 = [
		                   {dataField:"serialNo" ,headerText:"Serial Number",width:500 ,height:30},
		                   {dataField:"matnr" ,headerText:"Material Code ",width:120 ,height:30},
		                   {dataField:"exist" ,headerText:"Exist Y/N ",width:120 ,height:30}
		                   ];

var excelLayout = [
							{dataField:"serialNo" ,headerText:"Serial_Number",width:500 ,height:30},
							{dataField:"matnr" ,headerText:"Material_Code ",width:120 ,height:30},
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
							{dataField:"serialNoPop"  ,headerText:"Serial Number",width:200 ,height:30, editable:true},
							{dataField:"matnrPop"     ,headerText:"Material Number",width:200 ,height:30 , editable:true},
							{dataField:"latransitPop" ,headerText:"Location",width:120 ,height:30 , editable:true, visible:false},
							{dataField:"gltriPop"     ,headerText:"Product Finished Date in HQ",width:200 ,height:30 , editable:true,
								dataType : "date",
							    formatString : "dd/mm/yyyy",
							    editRenderer : {
							        type : "CalendarRenderer",
							        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
							        onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
							        showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
							    }
							},
							{dataField:"lvormPop" ,headerText:"Deletion Flag for Serial",width:200 ,height:30 , editable:true
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
							{dataField:"crtDtPop" ,headerText:"Create Date",width:120 ,height:30 , editable:true, visible:false, 
							    dataType : "date",
                                formatString : "dd/mm/yyyy",
                                editRenderer : {
                                    type : "CalendarRenderer",
                                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                    onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                    showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                }	
							},
							{dataField:"crtUserIdPop" ,headerText:"Create User",width:120 ,height:30 , editable:true, visible:false}
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
	createInitGrid();
    
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
	        $('input[type=file]').val('');
	        AUIGrid.clearGridData(myGridIDExcel);
	        $("#popup_wrap_excel_up").show();
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
	        AUIGrid.exportToXlsx(myGridIDExcelHide, excelProps);
	        //GridCommon.exportTo("grid_wrap", "xlsx", "test");
	    });
	    $('#saveExcel').click(function() {
	        //giFunc();
	        fn_excelSave();
	        
	    });
	    $('#cancelExcel').click(function() {
	        AUIGrid.clearGridData(myGridIDExcel);
	        $("#popup_wrap_excel_up").hide();
	    });
	    $('#fileSelector').on('change', function(evt) {
	        if (!checkHTML5Brower()) {
	            alert("브라우저가 HTML5 를 지원하지 않습니다.\r\n서버로 업로드해서 해결하십시오.");
	            return;
	        } else {
	            var data = null;
	            var file = evt.target.files[0];
	            if (typeof file == "undefined") {
	                alert("파일 선택 시 오류 발생!!");
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
    if (pm.gltriPop ==""){
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
    	fn_serialExist(serialChck,matrChck);
    	
    	
    }

};
function fn_serialExist(serialChck,matrChck){
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
	            		   matnr     : matrChck
	              
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
    // 그리드 속성 설정
    var gridPros = {
        //noDataMessage : "로컬 PC의 엑셀 파일을 선택하십시오."
    };

    // 실제로 #grid_wrap 에 그리드 생성
    myGridIDExcel = AUIGrid.create("#popup_wrap_excel", excelLayout, gridPros);
    
    // 그리드 최초에 빈 데이터 넣음.
    AUIGrid.setGridData(myGridIDExcel, []);
    AUIGrid.resize(myGridIDExcel,1203);
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
</tr>
<tr>
    <th scope="row">Category Type</th>
    <td>
        <select class="multy_select" multiple="multiple" id="srchcatagorytype" name="srchcatagorytype[]" /></select>
    </td>
    <th scope="row">Material Type</th>
    <td>
        <select class="multy_select" multiple="multiple" id="materialtype" name="materialtype[]" /></select>
    </td>
    <th scope="row">Deletion Flag</th>
    <td>
        <select class="w100p" id="delfg" name="delfg" /></select>
    </td>    
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

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
        <div id="grid_wrap" style="height:430px"></div>
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

<div id="popup_wrap_excel_up" class="size_big popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title">Serial Number Excel Upload</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
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
 