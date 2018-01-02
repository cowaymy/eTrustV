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

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var serialGrid;

var gradeGrid;

var gradeList = new Array();

var rescolumnLayout=[{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>",width:120    ,height:30 , visible:false},                         
                     {dataField: "delyno",headerText :"<spring:message code='log.head.deliveryno'/>"                  ,width:120    ,height:30                },                         
                     {dataField: "grcmplt",headerText :"<spring:message code='log.head.grcomplet'/>"                   ,width:120    ,height:30 },                       
                     {dataField: "rcvloc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30 , visible:false},                       
                     {dataField: "rcvlocnm",headerText :"<spring:message code='log.head.fromlocation'/>"                ,width:120    ,height:30 , visible:false},                       
                     {dataField: "rcvlocdesc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30                },                       
                     {dataField: "reqloc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30 , visible:false},                         
                     {dataField: "reqlocnm",headerText :"<spring:message code='log.head.tolocation'/>"                    ,width:120    ,height:30 , visible:false},                         
                     {dataField: "reqlocdesc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30                },                         
                     {dataField: "itmcd",headerText :"<spring:message code='log.head.materialcode'/>"                   ,width:120    ,height:30 , visible:false},                       
                     {dataField: "itmname",headerText :"<spring:message code='log.head.materialname'/>"                 ,width:120    ,height:30                },                       
                     {dataField: "ttype",headerText :"<spring:message code='log.head.transactiontype'/>"             ,width:120    ,height:30 , visible:false},                          
                     {dataField: "mtype",headerText :"<spring:message code='log.head.movementtype'/>"                   ,width:120    ,height:30 , visible:false},                       
                     {dataField: "delydt",headerText :"<spring:message code='log.head.deliverydate'/>"                  ,width:120    ,height:30 },                          
                     {dataField: "gidt",headerText :"<spring:message code='log.head.gidate'/>"                        ,width:120    ,height:30 },                        
                     {dataField: "delyqty",headerText :"<spring:message code='log.head.deliveredqty'/>"                  ,width:120    ,height:30 },                         
                     {dataField: "rciptqty",headerText :"<spring:message code='log.head.goodreceiptedqty'/>"              ,width:120    ,height:30 , editalble:true},                        
                     {dataField: "docno",headerText :"<spring:message code='log.head.refdocno'/>"                 ,width:120    ,height:30                },                         
                     {dataField: "uom",headerText :"<spring:message code='log.head.unitofmeasure'/>"              ,width:120    ,height:30 , visible:false},                         
                     {dataField: "uomnm",headerText :"<spring:message code='log.head.unitofmeasure'/>"                ,width:120    ,height:30                },                         
                     {dataField: "ttext",headerText :"<spring:message code='log.head.transactiontypetext'/>"        ,width:120    ,height:30                },                       
                     {dataField: "mtext",headerText :"<spring:message code='log.head.movementtext'/>"                   ,width:120    ,height:30                },                       
                     {dataField: "reqstno",headerText :"<spring:message code='log.head.stockmovementrequest'/>"        ,width:120    ,height:30}
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
                         {dataField:    "crtUserId",headerText :"<spring:message code='log.head.createuser'/>"        ,width:120   ,height:30   , visible:false      ,editable : false     }
                         
                        ];
                     
                     
                     
var resop = {
		rowIdField : "rnum",			
		editable : true,
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
var date = new Date();
var getdate = date.getDate();
var datemonth = date.getMonth() + 1;
if(getdate < 10) {
    getdate = '0'+date.getDate();
} 
if(datemonth < 10) {
    datemonth = '0' + datemonth;
}
today = getdate + '/' + datemonth + '/' + date.getFullYear();

var nextdate = date.setDate(date.getDate()+6);
var nextmonth = date.getMonth() + 1;
if(date.getDate() < 10) {
    getdate = '0'+date.getDate();
}
if(nextmonth < 10) {
    nextmonth = '0' + nextmonth;
}
nextdate = getdate + '/' + nextmonth + '/' + date.getFullYear();

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
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumnLayout, serialop);
    gradeGrid = AUIGrid.create("#receipt_grid", serialcolumnLayout2, serialop);
    
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    	var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
        AUIGrid.clearGridData(serialGrid);
    	fn_ViewSerial(delno);
    	
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
              
              if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
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
    $("#crtedt").val(nextdate);
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
        if(checkedItems.length <= 0) {
        	Common.alert('No data selected.');
            return false;
        }else{
        	for (var i = 0 ; i < checkedItems.length ; i++){
        		if(checkedItems[i].grcmplt == 'Y'){
        			Common.alert('Already processed.');
        			return false;
        			break;
        		}
        	}
        	doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
        	$('#grForm #gtype').val("GR");
        	$("#dataTitle").text("Good Receipt Posting Data");
        	$("#gropenwindow").show();
        	
        	if(checkedItems[0].mtype=="UM93"){
        		fn_gradeSerial(checkedItems[0].delyno);
        		$("#receipt_body").show();
        	    //fn_gradComb();    
        		AUIGrid.resize(gradeGrid); 
        	        
        	}else{
        		$("#receipt_body").hide();
        		   AUIGrid.clearGridData(gradeGrid);
        	}
        }
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
        console.log(checkedItems)
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
                console.log(itm);
                console.log(tmpno  + ' :::: ' + itm.delyno);
                if (tmpno != itm.delyno){
                    delbool = false;
                    break;
                }               
            }
            console.log(delbool);
            
            if (delbool){
                $("#V_DELVRYNO").val(tmpno);
                Common.report("printForm");
            }else{
                Common.alert('Only the same [Delivery No] is possible.');
            }
         }
     });
    
});

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
	console.log(addedItems);
	console.log(getRow);
	var gradchk=false;
	for(var i = 0 ; i < check.length ; i++){
        if(check[i].item.mtype =="UM93"){
        	gradchk=true;
        }
   }
	var graddata;
	if(gradchk){
		if(addedItems.length<1){
                    Common.alert("Please select Grade.");
                    return false;
		}else{
			for(var i =0; i < getRow ; i++){
					console.log(addedItems[i]);
				if(""==addedItems[i] || null==addedItems[i]){
	                    Common.alert("Please select Grade.");
	                    return false;
				}
			}
		}
	graddata=GridCommon.getEditData(gradeGrid);
	}
	
	data.check   = check;
	data.checked = check;
	data.grade    = graddata;
	
	data.form    = $("#grForm").serializeJSON();
	
	console.log(data);
	
	Common.ajaxSync("POST", "/logistics/stockMovement/StockMovementGoodIssue.do", data, function(result) {
		var reparam = (result.rdata).split("∈");
		console.log(reparam.length);
		console.log(result.rdata);
		//if (result.rdata == '000'){
		console.log(reparam[0]);
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
                    <th scope="row">From Location</th>
                    <td>
                        <!-- <select class="w100p" id="tlocation" name="tlocation"></select> -->
                        <input type="hidden"  id="flocation" name="flocation">
                        <input type="text" class="w100p" id="flocationnm" name="flocationnm">
                    </td>
                    <th scope="row">To Location</th>
                    <td >
                        <!-- <select class="w100p" id="flocation" name="flocation"></select> -->
                        <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                    </td>
                    <th scope="row">Auto / Manual</th>
                    <td>
                        <select class="w100p" id="sam" name="sam"></select>
                    </td>                
                </tr>
                
                <tr>
                    <th scope="row">Dvld.Req.Date</th>
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
                    <th scope="row">Ref Doc.No</th>
                     <td ><input type="text" class="w100p" id="sdocno" name="sdocno"></td>                    
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
            <li><p class="btn_grid"><a id="gissue">Goods Receipt</a></p></li>
            <li><p class="btn_grid"><a id="receiptcancel">Receipt Cancel</a></p></li>
            <li><p class="btn_grid"><a id="print"><spring:message code='sys.progmanagement.grid1.PRINT' /></a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>

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
		            <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
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
       <input type="hidden" id="viewType" name="viewType" value="WINDOW" />
       <input type="hidden" id="V_DELVRYNO" name="V_DELVRYNO" value="" />
       <input type="hidden" id="reportFileName" name="reportFileName" value="/logistics/Delivery_Note_for_GR.rpt" /><br />
    </form>
</section>

