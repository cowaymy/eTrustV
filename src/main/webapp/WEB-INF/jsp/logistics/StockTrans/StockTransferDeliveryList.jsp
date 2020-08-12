<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

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

.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
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

var rescolumnLayout=[{dataField: "rnum",headerText :"<spring:message code='log.head.rownum'/>",width:120    ,height:30 , visible:false},
                     {dataField: "delyno",headerText :"<spring:message code='log.head.deliveryno'/>"                  ,width:160    ,height:30                },
                     {dataField: "reqloc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30 , visible:false},
                     {dataField: "reqlocnm",headerText :"<spring:message code='log.head.fromlocation'/>"                ,width:120    ,height:30 , visible:false},
                     {dataField: "rcvlocdesc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30                },
                     {dataField: "rcvloc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30 , visible:false},
                     {dataField: "rcvlocnm",headerText :"<spring:message code='log.head.tolocation'/>"                    ,width:120    ,height:30 , visible:false},
                     {dataField: "reqlocdesc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30                },
                     {dataField: "delydt",headerText :"<spring:message code='log.head.deliverydate'/>"                  ,width:120    ,height:30 },
                     {dataField: "gidt",headerText :"<spring:message code='log.head.gidate'/>"                        ,width:120    ,height:30 },
                     {dataField: "itmcd",headerText :"<spring:message code='log.head.matcode'/>"                   ,width:120    ,height:30 },
                     {dataField: "itmname",headerText :"Mat. Name" , width:280, height:30, style:"aui-grid-user-custom-left"},
                     {dataField: "delyqty",headerText :"<spring:message code='log.head.deliveredqty'/>", width:120, height:30
                    	 , style:"aui-grid-user-custom-right", dataType:"numeric", formatString:"#,##0"
                   		 , editRenderer : {
                                type : "InputEditRenderer",
                                showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
                                onlyNumeric : true, // 0~9만 입력가능
                                allowPoint : false, // 소수점( . ) 도 허용할지 여부
                                allowNegative : false, // 마이너스 부호(-) 허용 여부
                                textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                                autoThousandSeparator : false // 천단위 구분자 삽입 여부
                            }
                     },
                     {dataField: "rciptqty",headerText :"<spring:message code='log.head.giqty'/>", width:120    ,height:30 , editalble:true
                    	 , style:"aui-grid-user-custom-right", dataType:"numeric", formatString:"#,##0"

                   		 , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                                if(item.serialchk == "Y") {
                                    return "aui-grid-link-renderer1";
                                }
                                return "aui-grid-column-right";
                         }
                    	 /*
                    	 , renderer :{
                               type : "LinkRenderer",
                               baseUrl : "javascript", // 자바스크립 함수 호출로 사용하고자 하는 경우에 baseUrl 에 "javascript" 로 설정
                               // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
                               jsCallback : function(rowIndex, columnIndex, value, item){
                                   if(item.serialchk == "Y" && item.rcvSerialRequireChkYn == "Y"){
                                       fn_scanSearchPop(item);
                                   }
                               }
                        }
                        */
                     },
                     {dataField: "docno",headerText :"<spring:message code='log.head.refdocno'/>"              ,width:120    ,height:30                },
                     {dataField: "uom",headerText :"<spring:message code='log.head.unitofmeasure'/>"              ,width:120    ,height:30 , visible:false},
                     {dataField: "uomnm",headerText :"UOM"                ,width:120    ,height:30                },
                     {dataField: "reqstno",headerText :"STO No."                            ,width:130    ,height:30},
                     {dataField: "ttype",headerText :"<spring:message code='log.head.transactiontype'/>"             ,width:120    ,height:30 , visible:false},
                     {dataField: "ttext",headerText :"Trans. Type"        ,width:120    ,height:30                },
                     {dataField: "mtype",headerText :"<spring:message code='log.head.movementtype'/>"                   ,width:120    ,height:30 , visible:false},
                     {dataField: "mtext",headerText :"Movement Type"                   ,width:180    ,height:30                },
                     {dataField: "reqitmno",headerText :"STO Item No."                     ,width:120    ,height:30 , visible:true},
                     {dataField: "gicmplt",headerText :"GI Complt."                   ,width:120    ,height:30 , visible:true},
                     {dataField: "grcmplt",headerText :"GR Complt."                   ,width:120    ,height:30 , visible:true},
                     {dataField: "serialchk",headerText :"<spring:message code='log.head.serialcheck'/>" ,width:130, height:30 , visible:true},
                     {dataField: "rcvSerialRequireChkYn", headerText :"Serial Required Check Y/N", width:90, height:30, visible:true}
                     // Added for avoiding double process (duplicate GI/GR) issue. By Hui Ding, 2020-07-17
                     //{dataField: "rcdTms", headerText:"Record Timestamp", width:150, visible:true}
                     ];

var serialcolumn       =[{dataField:    "itmcd",headerText :"<spring:message code='log.head.materialcode'/>"                   ,width:  "20%"       ,height:30 },
                         {dataField: "itmname",headerText :"<spring:message code='log.head.materialname'/>"                 ,width:  "25%"       ,height:30 },
                         {dataField: "serial",headerText :"<spring:message code='log.head.serial'/>",width:  "30%"       ,height:30,editable:true },
                         {dataField: "cnt61",headerText :"<spring:message code='log.head.serial'/>",width:   "30%"       ,height:30,visible:false },
                         {dataField: "cnt62",headerText :"<spring:message code='log.head.serial'/>",width:   "30%"       ,height:30,visible:false },
                         {dataField: "cnt63",headerText :"<spring:message code='log.head.serial'/>",width:   "30%"       ,height:30,visible:false },
                         {dataField: "statustype",headerText :"<spring:message code='log.head.status'/>",width:  "30%"       ,height:30,visible:false }
];

var resop = {
		rowIdField : "rnum",
		editable : true,
		//fixedColumnCount : 6,
		//groupingFields : ["delyno"],
        displayTreeOpen : false,
        showRowCheckColumn : true ,
        showStateColumn : false,
        showBranchOnGrouping : false
        };

var serialop = {
     editable : true
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
    paramdata = { groupCode : '306' , orderValue : 'CODE_ID' , likeValue:'US'};
    doGetComboData('/common/selectCodeList.do', paramdata, ('${searchVal.sttype}'==''?'US':'${searchVal.sttype}'),'sttype', 'S' , 'f_change');
    doGetComboData('/logistics/stocktransfer/selectStockTransferNo.do', '{groupCode:delivery}' , '','seldelno', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','tlocation', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','flocation', 'S' , 'SearchListAjax');
    //doDefCombo(amdata, '' ,'sam', 'S', '');
    /**********************************
     * Header Setting End
     ***********************************/

    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    //listGrid = GridCommon.createAUIGrid("#main_grid_wrap", rescolumnLayout,"", resop);
    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);

    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    	// serial search Popup
        if(event.dataField == "rciptqty"){
            var item = event.item;
        	if(item.serialchk == "Y" && item.rcvSerialRequireChkYn == "Y"){
                fn_scanSearchList(item);
            }
        }
    });

    AUIGrid.bind(listGrid, "cellEditBegin", function (event){
    	if (event.dataField != "delyqty"){
    		return false;
    	}else{
    		if (AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno") != null && AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno") != ""){
    			Common.alert('You can not create a delivery note for the selected item.');
    			return false;
    		}
    	}
    });

    AUIGrid.bind(listGrid, "cellEditEnd", function (event){

        if (event.dataField != "delyqty"){
            return false;
        }else{
        	var del = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyqty");
        	if (del > 0){
	        	if (Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstqty")) < Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "delyqty"))){
	        		Common.alert('Delivery Qty can not be greater than Request Qty.');
	        		//AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstqty")
	        		AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
	        	}else{
	        		AUIGrid.addCheckedRowsByIds(listGrid, event.item.rnum);
	        	}
        	}else{
        		AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
        		AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
        	}
        }
    });

    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
//      	$("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
//      	$("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
//     	document.searchForm.action = '/logistics/stocktransfer/StocktransferView.do';
//     	document.searchForm.submit();
    });

    AUIGrid.bind(listGrid, "ready", function(event) {
    });

    AUIGrid.bind(listGrid, "rowCheckClick", function( event ) {

        var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");

        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
        	AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
        }else{
        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);

        	for (var i = 0 ; i < rown.length ; i++){
        		AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
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

    AUIGrid.bind(serialGrid, "cellEditEnd", function (event){
        var tvalue = true;
       var serial = AUIGrid.getCellValue(serialGrid, event.rowIndex, "serial");
       serial=serial.trim();
       if(""==serial || null ==serial){
          //alert(" ( " + event.rowIndex + ", " + event.columnIndex + ") : clicked!!");
          //AUIGrid.setSelectionByIndex(serialGrid,event.rowIndex, event.columnIndex);
           Common.alert('Please input Serial Number.');
           return false;
       }else{
           for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++){
               if (event.rowIndex != i){
                   if (serial == AUIGrid.getCellValue(serialGrid, i, "serial")){
                       tvalue = false;
                       break;
                   }
               }
           }

           if (tvalue){
               fn_serialChck(event.rowIndex ,event.item , serial)
           }else{
               AUIGrid.setCellValue(serialGrid , event.rowIndex , "statustype" , 'N' );
               AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {
                   if (item.statustype  == 'N'){
                       return "my-row-style";
                   }
               });
               AUIGrid.update(serialGrid);
           }

          if($("#serialqty").val() > AUIGrid.getRowCount(serialGrid)){
             f_addrow();
          }

       }
    });

    $("#crtsdt").val(today);
    $("#crtedt").val(nextDate);
});
function f_change(){
	paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val() , codeIn:'US03,US93'};
    doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
}
//btn clickevent
$(function(){
    $('#search').click(function() {
    	if(validation()) {
    	      SearchListAjax();
    	}
    });
    $('#clear').click(function() {
        $('#seldelno').val('');
        $('#tlocationnm').val('');
        $('#flocationnm').val('');
        $('#crtsdt').val('');
        $('#crtedt').val('');
        $('#reqsdt').val('');
        $('#reqedt').val('');
        $('#sstatus').val('');
        $('#sam').val('');
        $('#refdocno').val('');
        paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val(), codeIn:'US03,US93'};
        doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
    });
    $("#sttype").change(function(){
        paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val() , codeIn:'US03,US93'};
        doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
    });
    $('#delivery').click(function(){
    	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
    	if(checkedItems.length <= 0) {
    		return false;
    	}else{
	    	var data = {};
	    	data.checked = checkedItems;
	    	Common.ajax("POST", "/logistics/stocktransfer/StocktransferReqDelivery.do", data, function(result) {
	            Common.alert(result.message);
	            AUIGrid.resetUpdatedItems(listGrid, "all");
	        },  function(jqXHR, textStatus, errorThrown) {
	            try {
	            } catch (e) {
	            }
	            Common.alert("Fail : " + jqXHR.responseJSON.message);
	        });
	    	for (var i = 0 ; i < checkedItems.length ; i++){
	    		AUIGrid.addUncheckedRowsByIds(listGrid, checkedItems[i].rnum);
	    	}
    	}
    });

    $("#gissueNew").click(function(){
    	var checkedItems = AUIGrid.getCheckedRowItems(listGrid);

        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{

        	var delynoGroup = "", reqlocGroup = "", rcvlocGroup = "";

            for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].item.gicmplt == 'Y'){
                    Common.alert('Already processed.');
                    return false;
                    break;
                }

                if (checkedItems[i].item.delydt == "" || checkedItems[i].item.delydt == null){
                    Common.alert("Please check the Delivery Date.")
                    return false;
                }

                if (i == 0){
                	delynoGroup = checkedItems[i].item.delyno;
                	reqlocGroup = checkedItems[i].item.reqloc;
                	rcvlocGroup = checkedItems[i].item.rcvloc;
                }
               	if(checkedItems[i].item.delyno != delynoGroup){
               		Common.alert("Delivery No must be the same. <br />Please process one by one.");
               		return false;
               	}
               	if(checkedItems[i].item.reqloc != reqlocGroup){
               		Common.alert("From Location must be the same. <br />Please process one by one.");
                    return false;
                }if(checkedItems[i].item.rcvloc != rcvlocGroup){
                	Common.alert("To Location must be the same. <br />Please process one by one.");
                    return false;
                }

            }
        }

        if(checkedItems[0].item.delyno == null || checkedItems[0].item.delyno == ""){
        	Common.alert('Already processed.');
        	return false;
        }

        $("#zDelyno").val(checkedItems[0].item.delyno);
        $("#zReqloc").val(checkedItems[0].item.reqloc);
        $("#zRcvloc").val(checkedItems[0].item.rcvloc);

        // No Serial Logic ( Old version )
        if(checkedItems[0].item.rcvSerialRequireChkYn == "N"){
        	$("#gissue").click();
        }else{
        	// Serial Logic ( New version )
	        if(Common.checkPlatformType() == "mobile") {
	            popupObj = Common.popupWin("frmNew", "/logistics/stocktransfer/stoIssuePop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
	        } else{
	            Common.popupDiv("/logistics/stocktransfer/stoIssuePop.do", null, null, true, '_divStoIssuePop');
	        }
        }
    });

    $("#gissue").click(function(){
 //   	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
    	var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
    	var serialChkfalg;

        if(checkedItems.length <= 0) {
        	Common.alert('No data selected.');
            return false;
        }else{
        	for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].item.gicmplt == 'Y'){
                    Common.alert('Already processed.');
                    return false;
                    break;
                }
            }

         for (var i = 0 ; i < checkedItems.length ; i++){
         rowItem = checkedItems[i];
            if (rowItem.item.serialchk == 'Y'){
              serialChkfalg="Y";
                break;
           }else{
             serialChkfalg ="N";
           }
         }

      // 2018.01.01 김덕호 요청사항
         // serial check 강제 처리
         serialChkfalg ="N";

         if(serialChkfalg =="Y"){
             doSysdate(0 , 'giptdate');
             doSysdate(0 , 'gipfdate');
             $("#giopenwindow").show();
             $("#serial_grid_wrap").show();
             AUIGrid.clearGridData(serialGrid);
             AUIGrid.resize(serialGrid);
             fn_itempopList_T(checkedItems);
         }else{
        	document.giForm.gtype.value="GI";
            $("#dataTitle").text("Good Issue Posting Data");
            doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
        	$("#giopenwindow").show();
            $("#giptdate").val("");
            $("#gipfdate").val("");
            $("#doctext").val("");
            $("#serial_grid_wrap").hide();

         }

        }
    });
    $("#gcissue").click(function(){
        var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
        	for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].grcmplt == 'Y'){
                    Common.alert('Good Receipt already processed. Unable to Issue Cancel.');
                    return false;
                    break;
                }
                if(checkedItems[i].gicmplt != 'Y'){
                    Common.alert('Before Good issue processed.');
                    return false;
                    break;
                }
            }
        	document.giForm.gtype.value="RC";
            $("#dataTitle").text("Issue Cancel Posting Data");
            doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
            $("#giopenwindow").show();
            $("#serial_grid_wrap").hide();
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

    $("#download").click(function() {
        GridCommon.exportTo("main_grid_wrap", 'xlsx', "Transfer Out");
    });

    $("#deliverydelete").click(function(){
    	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
        console.log(checkedItems);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
            for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].gicmplt == 'Y'){
                    Common.alert('Good Issue already processed. Unable to Delete Delivery.');
                    return false;
                    break;
                }
            }
            var data = {};
            data.checked = checkedItems;
            Common.ajax("POST", "/logistics/stocktransfer/StocktransferDeliveryDelete.do", data, function(result) {
                Common.alert(result.message);
          //      AUIGrid.resetUpdatedItems(listGrid, "all");
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });

            $("#search").click();
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

function fn_PopStoIssueClose(){
	if(popupObj!=null) popupObj.close();
	$("#search").click();
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

    var url = "/logistics/stocktransfer/StocktransferSearchDeliveryList.do";
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
function giFunc(){
	var data = {};
	var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
	var check     = AUIGrid.getCheckedRowItems(listGrid);
    var serials   = AUIGrid.getAddedRowItems(serialGrid);
    var rowItem;

	 if (check[0].item.serialchk == 'Y'){
	        for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++){
	            if (AUIGrid.getCellValue(serialGrid , i , "statustype") == 'N'){
	                Common.alert("Please check the serial.")
	                return false;
	            }

	            if (AUIGrid.getCellValue(serialGrid , i , "serial") == undefined || AUIGrid.getCellValue(serialGrid , i , "serial") == "undefined"){
	                Common.alert("Please check the serial.")
	                return false;
	            }
	        }

	        if ($("#serialqty").val() != AUIGrid.getRowCount(serialGrid)){
	            Common.alert("Please check the serial.")
	            return false;
	        }
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

	data.check   = check;
	data.checked = check;
	data.add = serials;
	data.form    = $("#giForm").serializeJSON();

	Common.ajax("POST", "/logistics/stocktransfer/StocktransferGoodIssue.do", data, function(result) {

		var message =result.message;

		if("Already processed."== message){
		 Common.alert(result.message);
		}else{
		 Common.alert(result.message + " <br/>"+ "MaterialDocumentNo : " + result.data);
		}

//         AUIGrid.setGridData(listGrid, result.data);
        $("#giptdate").val("");
        $("#gipfdate").val("");
        $("#doctext" ).val("");
        $("#giopenwindow").hide();
        $('#search').click();

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }

        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}

function fn_itempopList_T(data){

    var itm_temp = "";
    var itm_qty  = 0;
    var itmdata = [];
    var reqQty;

    for (var i = 0 ; i < data.length ; i++){
         if (data[i].item.serialchk == 'Y'){
             reqQty =data[i].item.delyqty;
             itm_qty +=parseInt(reqQty);
             $("#reqstno").val(data[i].item.reqstno)
         }
    }

    $("#serialqty").val(itm_qty);


    f_addrow();
}

function fn_serialChck(rowindex , rowitem , str){
    var schk = true;
    var ichk = true;
    var slocid = '';//session.locid;
    var data = { serial : str , locid : slocid};
    Common.ajaxSync("GET", "/logistics/stockMovement/StockMovementSerialCheck.do", data, function(result) {
        if (result.data[0] == null){
            AUIGrid.setCellValue(serialGrid , rowindex , "itmcd" , "" );
            AUIGrid.setCellValue(serialGrid , rowindex , "itmname" , "" );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt61" , 0 );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt62" , 0 );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt63" , 0 );

            schk = false;
            ichk = false;

        }else{
             AUIGrid.setCellValue(serialGrid , rowindex , "itmcd" , result.data[0].STKCODE );
             AUIGrid.setCellValue(serialGrid , rowindex , "itmname" , result.data[0].STKDESC );
             AUIGrid.setCellValue(serialGrid , rowindex , "cnt61" , result.data[0].L61CNT );
             AUIGrid.setCellValue(serialGrid , rowindex , "cnt62" , result.data[0].L62CNT );
             AUIGrid.setCellValue(serialGrid , rowindex , "cnt63" , result.data[0].L63CNT );


             if (result.data[0].L61CNT > 0 || result.data[0].L62CNT == 0){
                 schk = false;
             }else{
                 schk = true;
             }

             var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);

             for (var i = 0 ; i < checkedItems.length ; i++){
                 if (result.data[0].STKCODE == checkedItems[i].itmcd){
                     //AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'Y' );
                     ichk = true;
                     break;
                 }else{
                     ichk = false;
                 }
             }
        }

         if (schk && ichk){
             AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'Y' );
         }else{
             AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'N' );
         }

          //Common.alert("Input Serial Number does't exist. <br /> Please inquire a person in charge. " , function(){AUIGrid.setSelectionByIndex(serialGrid, AUIGrid.getRowCount(serialGrid) - 1, 2);});
          AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {

              if (item.statustype  == 'N'){
                  return "my-row-style";
              }
          });
          AUIGrid.update(serialGrid);

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);

    });
}

function f_addrow(){
    var rowPos = "last";
    var item = new Object();
    AUIGrid.addRow(serialGrid, item, rowPos);
    return false;
}

//Serial Search Pop
function fn_scanSearchList(item){
	$("#pDeliveryNo").val(item.delyno);
    $("#pDeliveryItem").val(item.delvryNoItm);
    $("#pStatus").val("O");

    if(Common.checkPlatformType() == "mobile") {
        popupObj = Common.popupWin("frmSearchScan", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    } else{
        Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#frmSearchScan").serializeObject(), null, true, '_scanSearchPop');
    }

}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Transfer-Out</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Transfer-Out</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
</c:if>
            <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
        </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" name="gtype"   id="gtype"  value="gissue" />
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
                    <th scope="row">Delivery Number</th>
                    <td>
                        <!-- <select class="w100p" id="seldelno" name="seldelno"></select> -->
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
                    <th scope="row">From Location</th>
                    <td>
                        <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                    </td>
                    <th scope="row">To Location</th>
                    <td >
                        <input type="hidden"  id="flocation" name="flocation">
                        <input type="text" class="w100p" id="flocationnm" name="flocationnm">
                    </td>
                    <th scope="row">Ref Doc.No </th>
                    <td>
                        <input type="text" class="w100p" id="refdocno" name="refdocno">
                    </td>
                </tr>

                <tr>
                    <th scope="row">Dlvd.Req.Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
					    <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
					    <span> To </span>
					    <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
					    </div><!-- date_set end -->
                    </td>
                    <th scope="row">GI Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="reqsdt" name="reqsdt" type="text" title="Create start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="Create End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row">Status</th>
                    <td>
                        <select  id="outstatus" name="outstatus" class="w100p" >
                            <option value ="" selected>All</option>
                            <option value = "Y">Complete</option>
                            <option value="N"> Open</option>
                        </select>
                    </td>
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
            <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                <li><p class="btn_grid"><a id="deliverydelete">Delete Delivery</a></p></li>
            </c:if> --%>
            <li><p class="btn_grid"><a id="gissueNew">Good Issue</a></p></li>
            <li style="display:none;"><p class="btn_grid"><a id="gissue">Good Issue-Old</a></p></li>
            <li><p class="btn_grid"><a id="gcissue">Issue Cancel</a></p></li>
            <li><p class="btn_grid"><a id="print"><spring:message code='sys.progmanagement.grid1.PRINT' /></a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10 autoGridHeight" ></div>

    </section><!-- search_result end -->
    <form id="frmNew" name="frmNew" action="#" method="post">
        <input type="hidden" name="zDelyno" id="zDelyno" />
        <input type="hidden" name="zReqloc" id="zReqloc" />
        <input type="hidden" name="zRcvloc" id="zRcvloc" />
        <input type="hidden" name="zPrgnm"  id="zPrgnm" value="${param.CURRENT_MENU_CODE}"/>
    </form>

    <form id="frmSearchScan" name="frmSearchScan" method="POST">
        <input id="pDeliveryNo" name="pDeliveryNo" type="hidden" value="" />
        <input id="pDeliveryItem" name="pDeliveryItem" type="hidden" value="" />
        <input id="pRequestNo" name="pRequestNo" type="hidden" value="" />
        <input id="pRequestItem" name="pRequestItem" type="hidden" value="" />
        <input id="pStatus" name="pStatus" type="hidden" value="" />
        <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
    </form>


    <div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
		    <h1 id="dataTitle">Good Issue Posting Data</h1>
		    <ul class="right_opt">
		        <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
		    </ul>
		</header><!-- pop_header end -->

		<section class="pop_body"><!-- pop_body start -->
		    <form id="giForm" name="giForm" method="POST">
		    <input type="hidden" name="gtype" id="gtype" value="GI">
		    <input type="hidden" name="serialqty" id="serialqty"/>
            <input type="hidden" name="reqstno" id="reqstno"/>
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
		            <th scope="row">GI Posting Date</th>
                    <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
                    <th scope="row">GI Doc Date</th>
                    <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
                </tr>
                <tr>
                    <th scope="row">Header Text</th>
		            <td colspan='3'><input type="text" name="doctext" id="doctext" maxlength="50" class="w100p"/></td>
		        </tr>
		    </tbody>
		    </table>
		    <table class="type1">
            <caption>search table</caption>
            <colgroup id="serialcolgroup">
            </colgroup>
            <tbody id="dBody">
            </tbody>
            </table>
            <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="serial_grid_wrap" class="mt10" style="width:100%;" ></div>
            </article><!-- grid_wrap end  	  -->
		    <ul class="center_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
		        <li><p class="btn_blue2 big"><a onclick="javascript:giFunc();">SAVE</a></p></li>
</c:if>
		    </ul>
		    </form>

		</section>
    </div>
    <form id="printForm" name="printForm">
       <input type="hidden" id="viewType" name="viewType" value="PDF" />
       <input type="hidden" id="V_DELVRYNO" name="V_DELVRYNO" value="" />
       <input type="hidden" id="reportFileName" name="reportFileName" value="/logistics/Delivery_Note_for_Gl.rpt" /><br />
    </form>
</section>

