<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
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

.aui-grid-link-renderer1 {
  text-decoration:underline;
  color: #4374D9 !important;
  cursor: pointer;
  text-align: right;
}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var serialGrid;

var gradeGrid;

var gradeList = new Array();

var rescolumnLayout=[{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>",width:120    ,height:30 , visible:false},
                     {dataField: "delyno",headerText :"<spring:message code='log.head.deliveryno'/>"                  ,width:120    ,height:30                },
                     {dataField: "bndlNo",headerText :"Bundle No"        ,width:120    ,height:30                },
                     {dataField: "ordno",headerText :"Order No."        ,width:120    ,height:30                },
                     {dataField: "grcmplt",headerText :"<spring:message code='log.head.grcomplete'/>"                   ,width:120    ,height:30 },
                     {dataField: "rcvloc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30 , visible:false},
                     {dataField: "rcvlocnm",headerText :"<spring:message code='log.head.fromlocation'/>"                ,width:120    ,height:30 , visible:false},
                     {dataField: "rcvlocdesc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:220    ,height:30                },
                     {dataField: "reqloc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30 , visible:false},
                     {dataField: "reqlocnm",headerText :"<spring:message code='log.head.tolocation'/>"                    ,width:120    ,height:30 , visible:false},
                     {dataField: "reqlocdesc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:220    ,height:30                },
                     {dataField: "itmcd",headerText :"<spring:message code='log.head.matcode'/>"                   ,width:120    ,height:30},
                     {dataField: "itmname",headerText :"Mat. Name"                 ,width:120    ,height:30                },
                     {dataField: "ttype",headerText :"<spring:message code='log.head.transactiontype'/>"             ,width:120    ,height:30 , visible:false},
                     {dataField: "mtype",headerText :"<spring:message code='log.head.movementtype'/>"                   ,width:120    ,height:30 , visible:false},
                     {dataField: "delydt",headerText :"<spring:message code='log.head.deliverydate'/>"                  ,width:120    ,height:30 },
                     {dataField: "gidt",headerText :"<spring:message code='log.head.gidate'/>"                        ,width:120    ,height:30 },
                     {dataField: "grdt",headerText :"<spring:message code='log.head.grdate'/>"                        ,width:120    ,height:30 },
                     {dataField: "delyqty",headerText :"<spring:message code='log.head.deliveredqty'/>"                  ,width:120    ,height:30,  style: "aui-grid-user-custom-right",
                    	 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                    		 if( item != null ) {
	                    		 if(item.serialcheck == "Y" && item.serialRequireChkYn == "Y") {
	                                 return "aui-grid-link-renderer1";
	                             }
                    		 } else {
                                 return "";
                             }
                         }
                     },
                     {dataField: "rciptqty",headerText :"<spring:message code='log.head.grqty'/>"              ,width:120    ,height:30 , style: "aui-grid-user-custom-right", editalble:true},
                     {dataField: "docno",headerText :"<spring:message code='log.head.refdocno'/>"                 ,width:120    ,height:30                },
                     {dataField: "uom",headerText :"<spring:message code='log.head.unitofmeasure'/>"              ,width:120    ,height:30 , visible:false},
                     {dataField: "serialcheck",headerText :"Serial Check"              ,width:120    ,height:30 , visible:false},
                     {dataField: "uomnm",headerText :"UOM"                ,width:120    ,height:30                },
                     {dataField: "crtdt",headerText :"Reqst. Create Date"                ,width:120    ,height:30                },
                     {dataField: "reqdt",headerText :"Reqst. Required Date"                ,width:120    ,height:30                },
                     {dataField: "ttext",headerText :"Trans. Type"        ,width:120    ,height:30                },
                     {dataField: "mtext",headerText :"Movement Type"                   ,width:120    ,height:30                },
                     {dataField: "reqstno",headerText :"SMO No."        ,width:120    ,height:30},
                     {dataField: "serialRequireChkYn", headerText : "Serial Required Check Y/N", width : 200, height : 30},
                     {dataField: "delvryNoItm",headerText :"delvryNoItm" ,width:20    ,height:30, visible:false}
                     ];


var serialcolumnLayout =[
						{dataField: "delvryNo",headerText :"<spring:message code='log.head.deliveryno'/>"         ,width:   "20%"       ,height:30   ,cellMerge : true            },
						{dataField: "itmCode",headerText :"<spring:message code='log.head.materialcode'/>"        ,width:   "15%"       ,height:30   ,cellMerge : true            },
						{dataField: "itmName",headerText :"<spring:message code='log.head.materialname'/>"        ,width:   "30%"       ,height:30   ,cellMerge : true            },
						{dataField: "pdelvryNoItm",headerText :"<spring:message code='log.head.deliverynoitem'/>"         ,width:120    ,height:30   , visible:false           },
						{dataField: "ttype",headerText :"<spring:message code='log.head.transactiontype'/>"       ,width:120    ,height:30   , visible:false           },
						{dataField: "serialNo",headerText :"<spring:message code='log.head.serialno'/>"       ,width:   "20%"       ,height:30              },
						{dataField: "crtDt",headerText :"<spring:message code='log.head.createdate'/>"        ,width:   "13%"       ,height:30              },
						{dataField: "crtUserId",headerText :"<spring:message code='log.head.createuser'/>"        ,width:120   ,height:30   , visible:false          }

                        ];

var serialcolumnLayout2 =[
						{dataField: "delvryNo",headerText :"<spring:message code='log.head.deliveryno'/>"         ,width:   "15%"       ,height:30   ,cellMerge : true    ,editable : false         },
						{dataField: "itmCode",headerText :"<spring:message code='log.head.materialcode'/>"        ,width:   "15%"       ,height:30   ,cellMerge : true    ,editable : false         },
						{dataField: "itmName",headerText :"<spring:message code='log.head.materialname'/>"        ,width:   "25%"       ,height:30   ,cellMerge : true  ,editable : false          },
						{dataField: "pdelvryNoItm",headerText :"<spring:message code='log.head.deliverynoitem'/>"         ,width:120    ,height:30   , visible:false     ,editable : false       },
						{dataField: "ttype",headerText :"<spring:message code='log.head.transactiontype'/>"       ,width:120    ,height:30   , visible:false    ,editable : false       },
						{dataField: "serialNo",headerText :"<spring:message code='log.head.serialno'/>"       ,width:   "20%"       ,height:30             ,editable : false  },
						{dataField: "grade",headerText :"<spring:message code='log.head.grade'/>"         ,width:   "12%"       ,height:30
                        	,   labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
                                var retStr = "";
                                for (var i = 0, len = gradeList.length; i < len; i++) {
                                    if (gradeList[i]["code"] == value) {
                                        retStr = gradeList[i]["codeName"];
                                        break;
                                    }
                                }
                                return retStr == "" ? value : retStr;
                            },
                        	editRenderer : {
                                 type : "DropDownListRenderer",
                                 showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                               listFunction : function(rowIndex, columnIndex, item, dataField) {
                                     return gradeList ;
                                 },
                               //  list : gradeList,
                                 keyField : "code",
                                 valueField : "codeName"
                                             }
                         },
                         {dataField:    "crtDt",headerText :"<spring:message code='log.head.createdate'/>"        ,width:   "13%"       ,height:30    ,editable : false           },
                         {dataField:    "crtUserId",headerText :"<spring:message code='log.head.createuser'/>"        ,width:120   ,height:30   , visible:false      ,editable : false     },
                         {dataField:    "whLocBrnchId",headerText:"whLocBrnchId",width:0,visible:false}
                        ];



var resop = {
		rowIdField : "rnum",
		editable : false,
		//groupingFields : ["delyno"],
        displayTreeOpen : false,
        showRowCheckColumn : true ,
        showStateColumn : false,
        showBranchOnGrouping : false
        };

var serialop = {
        //rowIdField : "rnum",
        editable : true,
        displayTreeOpen : true,
        //showRowCheckColumn : true ,
        showStateColumn : false,
        showBranchOnGrouping : false
        };

var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var uomlist = f_getTtype('42' , '');
var paramdata;


/* Required Date 초기화 */
   var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1;
    var yyyy = today.getFullYear();

    if(dd<10) { dd='0'+dd; }

    if(mm<10) { mm='0'+mm; }

    today = (dd + '/' + mm + '/' + yyyy);

    var nextDate = new Date();
    nextDate.setDate(nextDate.getDate() +6);
    var dd2 = nextDate.getDate();
    var mm2 = nextDate.getMonth() + 1;
    var yyyy2 = nextDate.getFullYear();

    if(dd2 < 10) { dd2 = '0' + dd2; }

    if(mm2 < 10) { mm2 ='0' + mm2; }

    nextDate = (dd2 + '/' + mm2 + '/' + yyyy2);


$(document).ready(function(){
	/**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , Codeval:'UM'};
    //doGetComboData('/common/selectCodeList.do', paramdata, '','sttype', 'S' , 'f_change');
    doGetComboData('/common/selectCodeList.do', paramdata, ('${searchVal.sttype}'==''?'UM':'${searchVal.sttype}'),'sttype', 'S' , 'f_change');
    doGetCombo('/logistics/stockMovement/selectStockMovementNo.do', '{groupCode:delivery}' , '','seldelno', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','tlocation', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','flocation', 'S' , 'SearchListAjax');
    doDefCombo(amdata, '' ,'sam', 'S', '');

    /**********************************
     * Header Setting End
     ***********************************/

    $("#receiptcancel").hide();

    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumnLayout, serialop);
    gradeGrid = AUIGrid.create("#receipt_grid", serialcolumnLayout2, serialop);


    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    	var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
    	var delvryNoItm = AUIGrid.getCellValue(listGrid, event.rowIndex, "delvryNoItm");

    	var dataField = AUIGrid.getDataFieldByColumnIndex(listGrid, event.columnIndex);
    	var serialcheck = AUIGrid.getCellValue(listGrid, event.rowIndex, "serialcheck");
        var serialRequireChkYn = AUIGrid.getCellValue(listGrid, event.rowIndex, "serialRequireChkYn");

        // KR-OHK Serial Require Check
    	if(serialcheck == "Y" && serialRequireChkYn  == 'Y') {
    		if(dataField == "delyqty") {
    			$("#pDeliveryNo").val(delno);
                $("#pDeliveryItem").val(delvryNoItm);
                $("#pStatus").val("I");

                fn_scanSearchPop();
    		}
    	} else {
	    	AUIGrid.clearGridData(serialGrid);
	    	fn_ViewSerial(delno);
    	}
    });

    AUIGrid.bind(listGrid, "cellEditBegin", function (event){
    });

    AUIGrid.bind(listGrid, "cellEditEnd", function (event){
    });

    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    });

    AUIGrid.bind(listGrid, "ready", function(event) {
    });

    AUIGrid.bind(listGrid, "rowCheckClick", function( event ) {
    	var checklist = AUIGrid.getCheckedRowItemsAll(listGrid);
    	var checked = AUIGrid.getCheckedRowItems(listGrid);
	    var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
    	if(checked.length>1){
	        for(var i = 0 ; i < checked.length ; i++){
	        	if(checked[i].item.mtype !=event.item.mtype){
	                Common.alert("Please Check Movement Type.");
	                //AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
		        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
		        	for (var i = 0 ; i < rown.length ; i++){
		        		AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
		        	}
	                return false;
	        	}else if(event.item.mtype== "UM93"){
		        	if(checked[i].item.delyno !=event.item.delyno){
		                Common.alert("Please Check Movement Type.");
		                //AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
			        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
			        	for (var i = 0 ; i < rown.length ; i++){
			        		AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
			        	}
		                return false;
		        	}
	            }
	        	// KR-OHK Serial Require Check
	        	if(checked[i].item.serialRequireChkYn !=event.item.serialRequireChkYn){
                    Common.alert("Please Check Delivery No");
                    var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
                    for (var i = 0 ; i < rown.length ; i++){
                        AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
                    }
                    return false;
                }else if(event.item.serialRequireChkYn== "Y"){
	                 if(checked[i].item.delyno !=event.item.delyno){
	                     Common.alert("Please Check Delivery No");

	                     var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
	                     for (var i = 0 ; i < rown.length ; i++){
	                         AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
	                     }
	                     return false;
	                 }
	           }

		        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
		        	AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
		        }else{
		        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
		        	for (var i = 0 ; i < rown.length ; i++){
		        		AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
		        	}
		        }
	        }
    	}else{
    		var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");

    		if(event.item.mtype== "UM93"){
    			for(var i = 0 ; i < checked.length ; i++){
    			    if(checked[i].item.delyno !=event.item.delyno){
		                Common.alert("Please Check Movement Type.2");
		                //AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
			        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
			        	for (var i = 0 ; i < rown.length ; i++){
			        		AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
			        	}
			            return false;
			        }
		        }
    		}

            if(AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
                AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
            }else{
                var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
                for (var i = 0 ; i < rown.length ; i++){
                    AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
                }
            }
    	}
    });

    AUIGrid.bind(listGrid, "cellDoubleClick", function( event ) {
        var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");

        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
            for (var i = 0 ; i < rown.length ; i++){
                AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
            }
        }else{
        	AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
        }
    });
    $("#crtsdt").val(today);
    $("#crtedt").val(nextDate);
    //SearchListAjax();

});
function f_change(){
    paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val(),codeIn:'UM03,UM93'};
    doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
}
//btn clickevent
$(function(){
    $('#search').click(function() {
    	if(validation()) {
    	    SearchListAjax();
    	}
    });
    $("#clear").click(function(){
        $("#searchForm")[0].reset();
    });
    $("#sttype").change(function(){
        paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
    });

    $("#download").click(function() {
        GridCommon.exportTo("main_grid_wrap", "xlsx", "Movement In");
    });
    $("#gissue").click(function(){
    	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);

    	var serialRequireChkYn = false;

        if(checkedItems.length <= 0) {
        	Common.alert('No data selected.');
            return false;
        } else if(("${SESSION_INFO.roleId}" == "256" && ("${SESSION_INFO.userBranchId}" != checkedItems[0].whLocBrnchId)) ||(checkedItems[0].admincheck  == "N" && "${SESSION_INFO.roleId}" == "256")) {
            Common.alert('GR location under Cody.' +"<br>"+' Not allow to proceed.');
            return false;
            } else {
        	var checkedSmo = [];

        	for (var i = 0 ; i < checkedItems.length ; i++){
        		if(checkedItems[i].grcmplt == 'Y'){
        			Common.alert('Already processed.');
        			return false;
        			break;
        		}

       			// Added by Hui Ding to block SMO per DVR > 5
       			var currSmo = checkedItems[i].reqstno;
       			var currDelvryNo = checkedItems[i].delyno;
       	          if (!checkedSmo.includes(currSmo)){
       	        	  if (checkedSmo.length <= 5){
       	               checkedSmo.push(currSmo);
       	        	  } else {
       	        		  Common.alert('Exceeded maximum limit of SMO to be received. <br/>Maximum SMO# limit = 5.');
       	        		  AUIGrid.addUncheckedRowsByValue(listGrid, "delyno", currDelvryNo);
       	        		  return false;
       	        	  }
       	          }

        		// KR-OHK Serial Require Check
                if (checkedItems[i].serialRequireChkYn == 'Y') {
                  serialRequireChkYn = true;
                }
        	}
        	if(serialRequireChkYn) { // KR-OHK Serial Require Check

        		fn_smoIssuePop();

            } else {

	        	doSysdate(0 , 'giptdate');
	            doSysdate(0 , 'gipfdate');
	        	$('#grForm #gtype').val("GR");
	        	$("#dataTitle").text("Good Receipt Posting Data");
	        	$("#gropenwindow").show();

	        	if(checkedItems[0].mtype=="UM93"){
	        		fn_gradeSerial(checkedItems[0].delyno);
	        		var yn= false;
	                for (var i = 0 ; i < checkedItems.length ; i++){
	                    if(checkedItems[i].serialcheck == 'Y'){
	                    	yn=true;
	                    }
	                }
	                if(yn){

		        		$("#receipt_body").show();
		        	    fn_gradComb();
		        		AUIGrid.resize(gradeGrid);
	                }else{
	                    $("#receipt_body").hide();
	                    AUIGrid.clearGridData(gradeGrid);
	                }

	        	}else{
	        		$("#receipt_body").hide();
	        		   AUIGrid.clearGridData(gradeGrid);
	        	}
            }
        }
    });

    $("#gissueNew").click(function(){
    	fn_smoIssuePop();
    });


    $("#receiptcancel").click(function(){
        var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
        	for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].grcmplt == 'N'){
                    Common.alert('Can not cancel before wearing.');
                    return false;
                    break;
                }
            }
        	doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
        	$('#grForm #gtype').val("RC");
        	$("#dataTitle").text("Receipt Cancel Posting Data");
            $("#gropenwindow").show();
        }
    });

    $("#tlocationnm").keypress(function(event) {
        $('#tlocation').val('');
        if (event.which == '13') {
            $("#stype").val('tlocation');
            $("#svalue").val($('#tlocationnm').val());
            $("#sUrl").val("/logistics/organization/locationCdSearch.do");

            Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
        }
    });
    $("#flocationnm").keypress(function(event) {
        $('#flocation').val('');
        if (event.which == '13') {
            $("#stype").val('flocation');
            $("#svalue").val($('#flocationnm').val());
            $("#sUrl").val("/logistics/organization/locationCdSearch.do");

            Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
        }
    });

    $("#print").click(function(){
        var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);

        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else if(checkedItems.length == 1 ) {
            var itm = checkedItems[0];
            $("#V_DELVRYNO").val(itm.delyno);
            Common.report("printForm");
        }else{
            var tmpno = checkedItems[0].delyno;
            var delbool = true;
            for (var i = 0 ; i < checkedItems.length ; i++ ){
                var itm = checkedItems[i];

                if (tmpno != itm.delyno){
                    delbool = false;
                    break;
                }
            }


            if (delbool){
                $("#V_DELVRYNO").val(tmpno);
                Common.report("printForm");
            }else{
                Common.alert('Only the same [Delivery No] is possible.');
                return false;
            }
         }
     });

});

function fn_smoIssuePop(){
    var checkedItems = AUIGrid.getCheckedRowItems(listGrid);

    $("#zDelvryNo").val(checkedItems[0].item.delyno);
    $("#zReqstno").val(checkedItems[0].item.reqstno);
    $("#zRcvloc").val(checkedItems[0].item.rcvloc); // From Location
    $("#zReqloc").val(checkedItems[0].item.reqloc); // To Location

    if(Common.checkPlatformType() == "mobile") {
        popupObj = Common.popupWin("frmNew", "/logistics/stockMovement/smoIssueInPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    } else{
        Common.popupDiv("/logistics/stockMovement/smoIssueInPop.do", null, null, true, '_divSmoIssuePop');
    }
}

function fn_PopSmoIssueClose(){
    if(popupObj!=null) popupObj.close();
    SearchListAjax();
}

//Serial Search Pop
function fn_scanSearchPop(){
    if(Common.checkPlatformType() == "mobile") {
        popupObj = Common.popupWin("frmNew", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    } else{
        Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#frmNew").serializeJSON(), null, true, '_scanSearchPop');
    }
}

  function fn_itempopList(data){

    var rtnVal = data[0].item;

    if ($("#stype").val() == "flocation" ){
        $("#flocation").val(rtnVal.locid);
        $("#flocationnm").val(rtnVal.locdesc);
    }else{
        $("#tlocation").val(rtnVal.locid);
        $("#tlocationnm").val(rtnVal.locdesc);
    }

    $("#svalue").val();
}

function validation() {
    if($("#crtsdt").val() == "" || ($("#crtedt").val() == "")) {
        Common.alert('Please enter Dlvd.Req.Date');
        return false;
    } else {
        return true;
    }
}
function SearchListAjax() {

	   if ($("#flocationnm").val() == ""){
	        $("#flocation").val('');
	    }
	    if ($("#tlocationnm").val() == ""){
	        $("#tlocation").val('');
	    }

	    if ($("#flocation").val() == ""){
	        $("#flocation").val($("#flocationnm").val());
	    }
	    if ($("#tlocation").val() == ""){
	        $("#tlocation").val($("#tlocationnm").val());
	    }

    var url = "/logistics/stockMovement/StockMoveSearchDeliveryList.do";
    var param = $('#searchForm').serializeJSON();

    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
    });
}

function f_getTtype(g , v){
    var rData = new Array();
    $.ajax({
           type : "GET",
           url : "/common/selectCodeList.do",
           data : { groupCode : g , orderValue : 'CRT_DT' , likeValue:v},
           dataType : "json",
           contentType : "application/json;charset=UTF-8",
           async:false,
           success : function(data) {
              $.each(data, function(index,value) {
                  var list = new Object();
                  list.code = data[index].code;
                  list.codeId = data[index].codeId;
                  list.codeName = data[index].codeName;
                  rData.push(list);
                });
           },
           error: function(jqXHR, textStatus, errorThrown){
               alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
           },
           complete: function(){
           }
       });

    return rData;
}
function grFunc(){
	var data = {};
	var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
	var check     = AUIGrid.getCheckedRowItems(listGrid);
	var addedItems = AUIGrid.getColumnValues(gradeGrid,"grade");
	var getRow = AUIGrid.getRowCount(gradeGrid);

	var gradchk=false;
	var delychek = check[0].item.delyno;

      //alert("delychek    :      "+delychek);

	for(var i = 0 ; i < check.length ; i++){
		var docno  = check[i].item.docno;
		//alert("docno : "+docno);
		 if(docno !=null && docno != ""){
			docno = docno.substring(0, 3);
		 }
        //alert("docno after : "+docno);
        //if(check[i].item.mtype =="UM93" ){

        if(check[i].item.mtype =="UM93" && check[i].item.serialcheck=="Y" && docno =="RET" ){
        	gradchk=true;
        }

       if(delychek != check[i].item.delyno){
    	   Common.alert("Delivery No Is Different.");
    	   return false;
       }


   }
	var graddata;
	if(gradchk){
		if(addedItems.length<1){
                    Common.alert("Please select Grade.");
                    return false;
		}else{
			for(var i =0; i < getRow ; i++){

				if(""==addedItems[i] || null==addedItems[i]){
	                    Common.alert("Please select Grade.");
	                    return false;
				}
			}
		}
	graddata=GridCommon.getEditData(gradeGrid);
	}

    if ($("#giptdate").val() == "") {
        Common.alert("Please select the GI Posting Date.");
        $("#giptdate").focus();
        return false;
      }

      if ($("#giptdate").val() < today) {
          Common.alert("Cannot select back date.");
          $("#giptdate").focus();
          return false;
        }

      if ($("#giptdate").val() > today) {
          Common.alert("Cannot select future date.");
          $("#giptdate").focus();
          return false;
        }

      if ($("#gipfdate").val() == "") {
        Common.alert("Please select the GI Doc Date.");
        $("#gipfdate").focus();
        return false;
      }

      if ($("#gipfdate").val() < today) {
          Common.alert("Cannot select back date.");
          $("#gipfdate").focus();
          return false;
        }

      if ($("#gipfdate").val() > today) {
          Common.alert("Cannot select future date.");
          $("#gipfdate").focus();
          return false;
        }

	 for (var i = 0 ; i < checkdata.length ; i++){
	       if (checkdata[i].delydt == "" || checkdata[i].delydt == null){
	          Common.alert("Please check the Delivery Date.")
	          return false;
	      }
	   }

	 for (var i = 0 ; i < checkdata.length ; i++){
	     if (checkdata[i].gidt == "" || checkdata[i].gidt == null){
	        Common.alert("Please check the GI Date.")
	        return false;
	    }
	 }

	data.check   = check;
	data.checked = check;
	data.grade    = graddata;

	data.form    = $("#grForm").serializeJSON();

	Common.ajaxSync("POST", "/logistics/stockMovement/StockMovementGoodIssue.do", data, function(result) {

		if (result.message.code == '99'){
			Common.alert(result.message.message + "<br/> Already Processed.");
		}else{
			var reparam = (result.rdata).split("∈");
			if(reparam[0].trim() == '000'){
				if ($('#grForm #gtype').val() == "RC"){
					Common.ajaxSync("POST", "/logistics/stockMovement/StockMovementGoodIssue.do", data, function(result) {

						Common.alert(result.message.message + "<br/>MDN NO : "+reparam[1].trim());
		            },  function(jqXHR, textStatus, errorThrown) {
		                try {
		                } catch (e) {
		                }
		                Common.alert("Fail : " + jqXHR.responseJSON.message);
		            });
				}else{
					//Common.alert(result.message.message);
					Common.alert(result.message.message + "<br/>MDN NO : "+reparam[1].trim());
				}

			}else{
				if ($('#grForm #gtype').val() == "RC"){
					Common.alert('GoodRecipt Cancel Fail.');
				}else{
					Common.alert('GoodRecipt Fail.');
				}
			}

		}
		$("#giptdate").val("");
        $("#gipfdate").val("");
        $("#doctext" ).val("");
        $("#gropenwindow").hide();

        $('#search').click();
    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}

function fn_ViewSerial(str){

    var data = { delno : str };

    Common.ajax("GET", "/logistics/stockMovement/StockMovementDeliverySerialView.do",
    		data,
    		function(result) {
		        AUIGrid.setGridData(serialGrid, result.data);

		        $("#serialopenwindow").show();
		        AUIGrid.resize(serialGrid);

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}
function fn_gradeSerial(str){

    var data = { delno : str };

    Common.ajax("GET", "/logistics/stockMovement/StockMovementDeliverySerialView.do",
    		data,
    		function(result) {
		        AUIGrid.setGridData(gradeGrid, result.data);
		        fn_gradComb();

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}

function fn_gradComb(){
	var paramdata = { groupCode : '390' , orderValue : 'CODE_ID'};
    Common.ajaxSync("GET", "/common/selectCodeList.do", paramdata,
            function(result) {
                for (var i = 0; i < result.length; i++) {
                    var list = new Object();
                    list.code = result[i].code;
                    list.codeId = result[i].codeId;
                    list.codeName = result[i].codeName;
                    list.description = result[i].description;
                    gradeList.push(list);
                }
            });
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Movement-In</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Movement-In</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
<ul class="right_btns"><c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
</c:if>

            <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
        </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" name="gtype"   id="gtype"  value="receipt" />
        <input type="hidden" name="rStcode" id="rStcode" />
        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="sUrl"   name="sUrl"  />
        <input type="hidden" id="stype"  name="stype" />
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Delivery No</th>
                    <td>
                       <!--  <select class="w100p" id="seldelno" name="seldelno"></select> -->
                        <input type="text" class="w100p" id="seldelno" name="seldelno">
                    </td>
                    <th scope="row">Transfer Type</th>
                    <td>
                        <select class="w100p" id="sttype" name="sttype"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select class="w100p" id="smtype" name="smtype"><option value=''>Choose One</option></select>
                    </td>
                </tr>

                <tr>
                    <th scope="row">Auto / Manual</th>
                    <td>
                        <select class="w100p" id="sam" name="sam"></select>
                    </td>
                    <th scope="row">GR Status</th>
                    <td>
                        <select  id="status" name="status" class="w100p" >
                            <option value ="" selected>All</option>
                            <option value ="N">Open</option>
                            <option value ="Y">Completed</option>
                        </select>
                    </td>
                    <th scope="row">Ref Doc.No</th>
                     <td >
                         <input type="text" class="w100p" id="sdocno" name="sdocno">
                     </td>
                </tr>

                <tr>
                    <th scope="row">Dvld.Req.Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
					    <p><input id="crtsdt" name="crtsdt" type="text" title="Delivery Start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
					    <span> To </span>
					    <p><input id="crtedt" name="crtedt" type="text" title="Delivery End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
					    </div><!-- date_set end -->
                    </td>
                    <th scope="row">GI Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="reqsdt" name="reqsdt" type="text" title="GI Start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="GI End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row">GR Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="rcivsdt" name="rcivsdt" type="text" title="GR Start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="rcivedt" name="rcivedt" type="text" title="GR End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                </tr>

                <tr>
                    <th scope="row">From Location</th>
                    <td colspan="2">
                        <!-- <select class="w100p" id="tlocation" name="tlocation"></select> -->
                        <input type="hidden"  id="flocation" name="flocation">
                        <input type="text" class="w100p" id="flocationnm" name="flocationnm">
                    </td>
                    <th scope="row">To Location</th>
                    <td colspan="2">
                        <!-- <select class="w100p" id="flocation" name="flocation"></select> -->
                        <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                    </td>
                </tr>
					<tr>
						<th scope="row">Sales Order No.</th>
						<td><input type="text" class="w100p" id="ordno" name="ordno"></td>
						<th scope="row">Appointment Date</th>
						<td>
							<div class="date_set w100p">
								<!-- date_set start -->
								<p>
									<input id="appntsdt" name="appntsdt" type="text"
										title="Appointment Start Date" placeholder="DD/MM/YYYY"
										class="j_date">
								</p>
								<span> To </span>
								<p>
									<input id="appntedt" name="appntedt" type="text"
										title="Appointment End Date" placeholder="DD/MM/YYYY"
										class="j_date">
								</p>
							</div>
							<!-- date_set end -->
						</td>
						<th scope="row">Bundle No</th>
                        <td><input type="text" class="w100p" id="bndlNo" name="bndlNo" placeholder="Bundle No"></td>
					</tr>
				</tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="btn_grid"><a id="gissue">Goods Receipt</a></p></li>
</c:if>
            <li><p class="btn_grid"><a id="receiptcancel">Receipt Cancel</a></p></li>
            <li><p class="btn_grid"><a id="print"><spring:message code='sys.progmanagement.grid1.PRINT' /></a></p></li>
        </ul>
        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="main_grid_wrap" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->
    </section><!-- search_result end -->

    <div class="popup_wrap" id="gropenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
		    <h1 id="dataTitle">Good Receipt Posting Data</h1>
		    <ul class="right_opt">
		        <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
		    </ul>
		</header><!-- pop_header end -->

		<section class="pop_body"><!-- pop_body start -->
		    <form id="grForm" name="grForm" method="POST">
		    <input type="hidden" name="gtype" id="gtype" value="GR">
		    <!-- <input type="text" name="gtype" id="gtype" value="GR">  -->
		    <input type="hidden" name="prgnm"  id="prgnm" value="${param.CURRENT_MENU_CODE}"/>
		    <table class="type1">
		    <caption>search table</caption>
		    <colgroup>
		        <col style="width:150px" />
		        <col style="width:*" />
		        <col style="width:150px" />
		        <col style="width:*" />
		    </colgroup>
		    <tbody>
		        <tr>
		            <th scope="row">GR Posting Date</th>
                    <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
                    <th scope="row">GR Doc Date</th>
                    <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
                </tr>
                <tr>
                    <th scope="row">Header Text</th>
		            <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p" maxlength="50"/></td>
		        </tr>
		    </tbody>
		    </table>
            <article class="grid_wrap" id="receipt_body" style="display: none;"><!-- grid_wrap start -->
            <div id="receipt_grid" class="mt10" style="width:100%;"></div>
            </article><!-- grid_wrap end -->
		    <ul class="center_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
		        <li><p class="btn_blue2 big"><a onclick="javascript:grFunc();">SAVE</a></p></li>
</c:if>

		    </ul>
		    </form>

		</section>
    </div>
        <!-- Pop up: View Serial Of Delivery Number -->
       <div class="popup_wrap" id="serialopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">Good Receipt - Serial View</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        <form>
        <section class="pop_body"><!-- pop_body start -->
            <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div>
            </article><!-- grid_wrap end -->
        </section>
          </form>
    </div>

<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
<form id="printForm" name="printForm">
       <input type="hidden" id="viewType" name="viewType" value="PDF" />
       <input type="hidden" id="V_DELVRYNO" name="V_DELVRYNO" value="" />
       <input type="hidden" id="reportFileName" name="reportFileName" value="/logistics/Delivery_Note_for_GR.rpt" /><br />
    </form>
<form id="frmNew" name="frmNew" action="#" method="post">
    <input type="hidden" name="zDelvryNo" id="zDelvryNo"/>
    <input type="hidden" name="zReqstno" id="zReqstno" />
    <input type="hidden" name="zReqloc" id="zReqloc" />
    <input type="hidden" name="zRcvloc" id="zRcvloc" />
    <input type="hidden" name="pDeliveryNo" id="pDeliveryNo"/>
    <input type="hidden" name="pDeliveryItem"  id="pDeliveryItem"/>
    <input type="hidden" name="pStatus" id="pStatus"/>
</form>
</section>

