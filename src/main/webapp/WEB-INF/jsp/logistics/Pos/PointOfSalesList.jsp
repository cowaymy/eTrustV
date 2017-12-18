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

.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var serialChkfalg;
var decedata = [{"code":"H","codeName":"Credit"},{"code":"S","codeName":"Debit"}];
var comboDatas = [{"codeId": "OI","codeName": "OH_GI"},{"codeId": "OG","codeName": "OH_GR"}];
var otherType;
var rescolumnLayout=[{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>",width:120    ,height:30 , visible:false},                         
								{dataField: "status",headerText :"<spring:message code='log.head.status'/>",width:120    ,height:30 , visible:false},                       
								{dataField: "reqstno",headerText :"<spring:message code='log.head.othersrequestno'/>"         ,width:250    ,height:30                },                        
								{dataField: "ttext",headerText :"<spring:message code='log.head.transactiontypetext'/>"        ,width:120    ,height:30 , visible:false              },                         
								{dataField: "mtext",headerText :"<spring:message code='log.head.movementtype'/>"                   ,width:120    ,height:30                },                       
								{dataField: "staname",headerText :"<spring:message code='log.head.status'/>",width:120    ,height:30                },                          
								{dataField: "reqitmno",headerText :"<spring:message code='log.head.stockmovementrequestitem'/>"  ,width:120    ,height:30 , visible:false},
								{dataField: "ttype",headerText :"<spring:message code='log.head.transactiontype'/>"             ,width:120    ,height:30 , visible:false},                          
								{dataField: "mtype",headerText :"<spring:message code='log.head.movementtype'/>"                   ,width:120    ,height:30 , visible:false},                       
								{dataField: "froncy",headerText :"<spring:message code='log.head.auto/manual'/>"                   ,width:120    ,height:30,        visible:false},                         
								{dataField: "reqdate",headerText :"<spring:message code='log.head.requestrequireddate'/>"          ,width:120    ,height:30                },                       
								{dataField: "crtdt",headerText :"<spring:message code='log.head.requestcreatedate'/>"            ,width:120    ,height:30                },                         
								{dataField: "rcvloc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30 , visible:false},                       
								{dataField: "rcvlocnm",headerText :"<spring:message code='log.head.fromlocation'/>"                ,width:120    ,height:30 , visible:false},                       
								{dataField: "rcvlocdesc",headerText :"<spring:message code='log.head.fromlocation'/>"                  ,width:120    ,height:30 ,visible:false               },                         
								{dataField: "reqloc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30 , visible:false},                         
								{dataField: "reqlocnm",headerText :"<spring:message code='log.head.tolocation'/>"                    ,width:120    ,height:30 , visible:false},                         
								{dataField: "reqlocdesc",headerText :"<spring:message code='log.head.tolocation'/>"                  ,width:120    ,height:30 ,visible:false               },                       
								{dataField: "itmcd",headerText :"<spring:message code='log.head.materialcode'/>"                   ,width:130    ,height:30 , visible:true},                        
								{dataField: "itmname",headerText :"<spring:message code='log.head.materialname'/>"                 ,width:450    ,height:30                },                       
								{dataField: "reqstqty",headerText :"<spring:message code='log.head.gi/grreqqty'/>"                   ,width:120    ,height:30                },                         
								{dataField: "rciptqty",headerText :"<spring:message code='log.head.remainqty'/>"                     ,width:120    ,height:30                },                         
								{dataField: "delvno",headerText :"<spring:message code='log.head.delvno'/>",width:120    ,height:30 , visible:false},                       
								{dataField: "delyqty",headerText :"<spring:message code='log.head.delvno'/>",width:120    ,height:30 , visible:false},                          
								{dataField: "greceipt",headerText :"<spring:message code='log.head.goodreceipt'/>"                  ,width:120    ,height:30,  visible:false  },                        
								{dataField: "uom",headerText :"<spring:message code='log.head.unitofmeasure'/>"              ,width:120    ,height:30 , visible:false},                         
								{dataField: "serialChk",headerText :"<spring:message code='log.head.serialchk'/>"                ,width:120    ,height:30                },                         
								{dataField: "uomnm",headerText :"<spring:message code='log.head.unitofmeasure'/>"                ,width:120    ,height:30                }];    
                      
                      
     var mtrcolumnLayout = [
								{dataField:  "matrlDocNo",headerText :"<spring:message code='log.head.matrl_doc_no'/>"    ,width:200    ,height:30},                         
								{dataField: "matrlDocItm",headerText :"<spring:message code='log.head.matrldocitm'/>"    ,width:100    ,height:30},                         
								{dataField: "invntryMovType",headerText :"<spring:message code='log.head.move_type'/>"   ,width:100    ,height:30},                                             
								{dataField: "movtype",headerText :"<spring:message code='log.head.move_text'/>"  ,width:120    ,height:30},                                                     
								{dataField: "reqStorgNm",headerText :"<spring:message code='log.head.reqloc'/>"  ,width:150    ,height:30},                         
								{dataField: "matrlNo",headerText :"<spring:message code='log.head.matrl_code'/>"     ,width:120    ,height:30},                         
								{dataField: "stkDesc",headerText :"<spring:message code='log.head.matrlname'/>"  ,width:300    ,height:30},                         
								{dataField: "debtCrditIndict",headerText :"<spring:message code='log.head.debit/credit'/>"   ,width:120    ,height:30
                              ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
                                    
                                    var retStr = "";
  
                                    for(var i=0,len=decedata.length; i<len; i++) {

                                        if(decedata[i]["code"] == value) {
                                            retStr = decedata[i]["codeName"];
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
                            {dataField:    "autoCrtItm" ,headerText:    ""   ,width:100    ,height:30},                         
                            {dataField:    "qty",headerText :"<spring:message code='log.head.qty'/>"    ,width:120    ,height:30},                         
                            {dataField:    "trantype",headerText :"<spring:message code='log.head.tran_type'/>"     ,width:120    ,height:30},                         
                            {dataField:    "postingdate",headerText :"<spring:message code='log.head.postingdate'/>"    ,width:120    ,height:30},                                                     
                            {dataField:    "codeName",headerText :"<spring:message code='log.head.uom'/>"   ,width:120    ,height:30}          
               ];                   

     var serialcolumn=[{dataField:  "itmcd",headerText :"<spring:message code='log.head.materialcode'/>"                   ,width:  "20%"       ,height:30 },               
		                       {dataField:    "itmname",headerText :"<spring:message code='log.head.materialname'/>"                 ,width:  "25%"       ,height:30 },               
		                       {dataField:    "serial",headerText :"<spring:message code='log.head.serial'/>",width:  "30%"       ,height:30,editable:true },                 
		                       {dataField:    "cnt61",headerText :"<spring:message code='log.head.serial'/>",width:   "30%"       ,height:30,visible:false },                 
		                       {dataField:    "cnt62",headerText :"<spring:message code='log.head.serial'/>",width:   "30%"       ,height:30,visible:false },                 
		                       {dataField:    "cnt63",headerText :"<spring:message code='log.head.serial'/>",width:   "30%"       ,height:30,visible:false },                 
		                       {dataField:    "statustype",headerText :"<spring:message code='log.head.status'/>",width:  "30%"       ,height:30,visible:false }  
                      ];            
     
     
     
var options = {
        usePaging : false,
        editable : false,
        useGroupingPanel : false,
        showStateColumn : false 
        };
        
var resop = {
        rowIdField : "rnum",            
        editable : false,
        fixedColumnCount : 6,
       // groupingFields : ["reqstno"],
        displayTreeOpen : false,
        showRowCheckColumn : true ,
        showStateColumn : false,
        showRowAllCheckBox : true,
        showBranchOnGrouping : false
        };

var serialop = {
        //rowIdField : "rnum",          
        editable : true
        //displayTreeOpen : true,
        //showRowCheckColumn : true ,
        //enableCellMerge : true,
        //showStateColumn : false,
        //showBranchOnGrouping : false
        };

        
//var paramdata;

$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
       doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, 'O','searchStatus', 'S' , '');
       /* doGetCombo('/common/selectStockLocationList.do', '', '','searchLoc', 'S' , ''); */
//        var paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:'OH'};
//       doGetComboData('/logistics/pos/selectTypeList.do', paramdata, '','searchReqType', 'S' , '');     
      //doGetComboData('/common/selectCodeList.do', paramdata, '','searchReqType', 'S' , '');
      doDefCombo(comboDatas, '' ,'searchTransType', 'S', '');
      
      
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    //listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, subgridpros);
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);    
    mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", mtrcolumnLayout ,"", options);
    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);
    $("#mdc_grid").hide(); 

    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
     
        $("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
        document.searchForm.action = '/logistics/pos/PosView.do';
        document.searchForm.submit();
    });
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
        
        $("#mdc_grid").hide(); 

        if (event.dataField == "reqstno"){
            SearchMaterialDocListAjax(event.value)
        }
        

    });
    
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
    
    AUIGrid.bind(listGrid, "rowCheckClick", function( event ) {
        
        var reqno = AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno");
        
        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
            AUIGrid.addCheckedRowsByValue(listGrid, "reqstno" , reqno);
        }else{
            var rown = AUIGrid.getRowIndexesByValue(listGrid, "reqstno" , reqno);

            for (var i = 0 ; i < rown.length ; i++){
                AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
            }
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
//	    var serialstus=$("#serialstus").val();      
// 	   if($("#serialstus").val() =="Y"){
// 	      f_addrow();                  
// 	      }
	   }
	   
	}
	});
    

    
 });
    
    function test() {
    	alert($("#searchReqType").val());
    }
//btn clickevent
$(function(){
    $('#search').click(function() {
        if(valiedcheck('search')){
        SearchListAjax();
        }
    });
 
    $("#download").click(function() {
    	GridCommon.exportTo("main_grid_wrap", 'xlsx', "Other GI/GR Request List");
    });
    
    $('#insert').click(function(){
         document.searchForm.action = '/logistics/pos/PosOfSalesIns.do';
         document.searchForm.submit();
    });

    $("#goodIssue").click(function(){
     $("#giForm")[0].reset();
     var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
        	   otherType="GI";
              for (var i = 0 ; i < checkedItems.length ; i++){
                  if(checkedItems[i].item.status != 'O'){
                      Common.alert('Already processed.');
                      return false;
                      break;
                  }else if(checkedItems[i].item.status == 'C'){
                       Common.alert('Complete!');
                       return false;
                       break;
                  }             
              }
              
         for (var i = 0 ; i < checkedItems.length ; i++){
              
	           if (checkedItems[i].item.serialChk == 'Y'){
	        	   serialChkfalg="Y";
	               break;
	          }else{
	        	  serialChkfalg ="N";
	          } 
  
          } 
              
         
         if(serialChkfalg =="Y"){
        	   document.giForm.gitype.value="GI";
               $("#dataTitle").text("GI/GR");
               $("#giptdate").val("");
               $("#gipfdate").val("");
               $("#doctext").val("");
               doSysdate(0 , 'giptdate');
               doSysdate(0 , 'gipfdate');
               $("#giopenwindow").show();
             $("#serial_grid_wrap").show();
             AUIGrid.clearGridData(serialGrid);
             AUIGrid.resize(serialGrid);
             fn_itemSerialPopList(checkedItems);   
         }else{
        	 document.giForm.gitype.value="GI"
            $("#dataTitle").text("GI/GR");
             $("#giptdate").val("");
             $("#gipfdate").val("");
             $("#doctext").val("");
             doSysdate(0 , 'giptdate');
             doSysdate(0 , 'gipfdate');
             $("#giopenwindow").show();
            $("#serial_grid_wrap").hide();       
         }
               
//             document.giForm.gitype.value="GI";
//             $("#dataTitle").text("Good Issue Posting Data");
//             $("#giptdate").val("");
//             $("#gipfdate").val("");
//             $("#doctext").val("");
//             doSysdate(0 , 'giptdate');
//             doSysdate(0 , 'gipfdate');
//             $("#giopenwindow").show();
            
        }
    });

    
    $("#issueCancel").click(function(){
        var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
        	otherType="GC";
            for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].item.status == 'O'){
                    Common.alert('Status Cannot Issue Cancel.');
                    return false;
                    break;
                }
            }
            document.giForm.gitype.value="GC";
            $("#dataTitle").text("GI/GR Cancel");
            $("#giptdate").val("");
            $("#gipfdate").val("");
            $("#doctext").val("");
            doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
            $("#giopenwindow").show();
            AUIGrid.clearGridData(serialGrid);
            AUIGrid.resize(serialGrid);
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
    $("#clear").click(function(){
        doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, 'O','searchStatus', 'S' , '');
        /* doGetCombo('/common/selectStockLocationList.do', '', '','searchLoc', 'S' , ''); */
        var paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:'OH'};
        doGetComboData('/logistics/pos/selectTypeList.do', paramdata, '','searchReqType', 'S' , '');     
        $("#searchOthersReq1").val('');
        $("#tlocationnm").val('');
        $("#tlocation").val('');
        $("#flocationnm").val('');
        $("#flocation").val('');
        $("#crtsdt").val('');
        $("#crtedt").val('');
        $("#reqsdt").val('');
        $("#reqedt").val('');
        $("#searchReqType").val('');
    });
    
//     $("#flocationnm").keypress(function(event) {
//         $('#flocation').val('');
//         if (event.which == '13') {
//             $("#stype").val('flocation');
//             $("#svalue").val($('#flocationnm').val());
//             $("#sUrl").val("/logistics/organization/locationCdSearch.do");

//             Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
//         }
//     });
    
    $("#searchTransType").change(function(){
        var paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#searchTransType").val()};
        doGetComboData('/logistics/pos/selectTypeList.do', paramdata, '','searchReqType', 'S' , ''); 
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

function SearchListAjax() {
    
//     if ($("#flocationnm").val() == ""){
//          $("#flocation").val('');
//      }
        if ($("#tlocationnm").val() == ""){
            $("#tlocation").val('');
        }
        
//      if ($("#flocation").val() == ""){
//          $("#flocation").val($("#flocationnm").val());
//      }
        if ($("#tlocation").val() == ""){
            $("#tlocation").val($("#tlocationnm").val());
        }
    
    var url = "/logistics/pos/PosSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}

function GiSaveAjax() {
       
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItems(listGrid);
    data.checked = checkdata;
    data.form = $("#giForm").serializeJSON();
    var serials   = AUIGrid.getAddedRowItems(serialGrid);
    data.add = serials;
     
    if (serialChkfalg == 'Y' && otherType=='GI'){

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


    Common.ajaxSync("POST", "/logistics/pos/PosGiSave.do", data, function(result) {
        
        Common.alert(result.message + " <br/>"+ "MaterialDocumentNo : " + result.data);

        // AUIGrid.resetUpdatedItems(listGrid, "all");
        $("#giptdate").val("");
        $("#gipfdate").val("");
        $("#giopenwindow").hide();
         $('#search').click();

    }, function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
    
}


function giSave() {
    if(valiedcheck('save')){
    GiSaveAjax();
    }
}

 function valiedcheck(v) {
    var ReqType;
    var Location;
    var Status;
if(v=='search'){
	 if ($("#searchTransType").val() == "") {
		 Common.alert("Please select the Transaction Type.");
		 return false
	 }
//     if ($("#searchReqType").val() == "") {
//         ReqType = false;
//     }else{
//         ReqType = true;
//     }
//     if ($("#searchLoc").val() == "") {
//         Location = false;
//     }else{
//         Location = true;
//     } 
//     if ($("#searchStatus").val() == "") {
//         Status = false;
//     }else{
//         Status = true;
//     }   

//     if(ReqType == false && Location == false && Status == false){  
//         alert("Please select the Request Type. \nPlease select the Location.\nPlease key in the Status.");
//         return false;
//     }
//     if(ReqType == true || Location == true || Status == true){  
//           return true;
//     }
    
}else if(v=='save'){
    
      if ($("#giptdate").val() == "") {
          Common.alert("Please select the GI Posting Date.");
          $("#giptdate").focus();
          return false;
      }
      if ($("#gipfdate").val() == "") {
          Common.alert("Please select the GI Proof Date.");
          $("#gipfdate").focus();
          return false;
      }
      if ($("#doctext").val() == "") {
          Common.alert("Please enter the Header Text.");
          $("#doctext").focus();
          return false;
      }
}   
      return true;
        
} 


function SearchMaterialDocListAjax( reqno ) {
    var url = "/logistics/pos/MaterialDocumentList.do";
    var param = "reqstno="+reqno;
    $("#mdc_grid").show(); 
    
    Common.ajax("GET" , url , param , function(data){
        //AUIGrid.resize(mdcGrid,1620,150); 
        AUIGrid.resize(mdcGrid); 
        AUIGrid.setGridData(mdcGrid, data.data2);        
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


function fn_serialChck(rowindex , rowitem , str){
    var schk = true;
    var ichk = true;
    var slocid = '';//session.locid;
    var data = { serial : str , locid : slocid};
    Common.ajaxSync("GET", "/logistics/pos/PointOfSalesSerialCheck.do", data, function(result) {
        console.log(result);
    	
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
             
             if (result.data[0].L62CNT == 0 ){//63제외
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
          
          
          AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {

             $("#serialstus").val(item.statustype);
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

function fn_itemSerialPopList(data){
    
    //checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
    
    var rowPos = "first";
    var rowList = [];
    var reqQty;
    var item = new Object();
    var itm_qty  = 0;

    for (var i = 0 ; i < data.length ; i++){
        
        if (data[i].item.serialChk == 'Y'){
            reqQty =data[i].item.reqstqty;
            itm_qty +=parseInt(reqQty);
            $("#reqstno").val(data[i].item.reqstno)
        }       
    }
    $("#serialqty").val(itm_qty);
    
    f_addrow();
    
}

function f_addrow(){
    var rowPos = "last";
    var item = new Object();
    AUIGrid.addRow(serialGrid, item, rowPos);
    return false;
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Other GI/GR Mgmt</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Other GI/GR Mgmt</h2>
</aside><!-- title_line end -->



<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li> 
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" name="rStcode" id="rStcode" />
        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="sUrl"   name="sUrl"  />
        <input type="hidden" id="stype"  name="stype" />    
        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                <th scope="row">Others Request</th>
                   <td >
                      <input type="text" class="w100p" id="searchOthersReq1" name="searchOthersReq1" />  
                    </td> 
                    <th scope="row"></th>
                    <td>
                        <!-- <select class="w100p" id="searchReqType" name="searchReqType" onchange="test()"></select> -->
                    </td> 
                </tr>
                <tr>
                    <th scope="row">Transaction Type</th>
                    <td>
                        <select class="w100p" id="searchTransType" name="searchTransType"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select class="w100p" id="searchReqType" name="searchReqType"><option value=''>Choose One</option></select>
                    </td>         
                </tr>
                
                <tr>
                    <th scope="row">Location</th>
                    <td>
                        <!-- <select class="w100p" id="searchLoc" name="searchLoc"></select> -->
                        <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                    </td>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="searchStatus" name="searchStatus"></select>
                    </td>         
                </tr>
                
                <tr>
                    <th scope="row">Create Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> To </span>
                        <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">Required Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="reqsdt" name="reqsdt" type="text" title="Create start Date" value="${searchVal.reqsdt}" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> To </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="Create End Date" value="${searchVal.reqedt}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>              
                </tr>
                
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
    
        <ul class="right_btns">
         <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
         <li><p class="btn_grid"><a id="insert">New</a></p></li>            
         <li><p class="btn_grid"><a id="goodIssue">GI/GR</a></p></li>
         <li><p class="btn_grid"><a id="issueCancel">GI/GR Cancel</a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>
        

    </section><!-- search_result end -->
    
    <div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">GI/GR Posting Date</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
        <form id="giForm" name="giForm" method="POST">
            <input type="hidden" name="gitype" id="gitype" value="GI"/>
            <input type="hidden" name="prgnm"  id="prgnm" value="${param.CURRENT_MENU_CODE}"/> 
            <input type="hidden" name="serialqty" id="serialqty"/>
            <input type="hidden" name="reqstno" id="reqstno"/>
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
                    <th scope="row">GI/GR Posting Date</th>
                    <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                    <th scope="row">GI/GR Doc Date</th>
                    <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                </tr>
                <tr>    
                    <th scope="row">Header Text</th>
                    <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
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
            <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div>
            </article><!-- grid_wrap end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a onclick="javascript:giSave();">SAVE</a></p></li>
            </ul>
            </form>
        
        </section>
    </div>

    <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on">Compliance Remark</a></li>
        </ul>
        
        <article class="tap_area"><!-- tap_area start -->
        
            <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="mdc_grid" class="mt10" style="height:150px"></div>
            </article><!-- grid_wrap end -->
        
        </article><!-- tap_area end -->
            
        
    </section><!-- tap_wrap end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>