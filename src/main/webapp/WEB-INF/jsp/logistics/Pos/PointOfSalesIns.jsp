<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/combodraw.js"></script>
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

/* .my-row-style { */
/*     background:#9FC93C; */
/*     font-weight:bold; */
/*     color:#22741C; */
/* } */

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var resGrid;
var reqGrid;
var userCode;
var UserBranchId;
var checkedItems;
var itm_qty  = 0;
var searchReqType;

var rescolumnLayout=[{dataField:"rnum"      ,headerText:"rnum"              ,width:120    ,height:30 ,visible:false},
                     {dataField:"codeName"     ,headerText:"Material Type"          ,width:120    ,height:30 ,visible:true},
                    {dataField:"stkCode"     ,headerText:"Material Code"           ,width:120    ,height:30,visible:true},
                     {dataField:"stkDesc"     ,headerText:"Text"         ,width:120    ,height:30,visible:true},
                     {dataField:"qty"    ,headerText:"Available Qty"           ,width:120    ,height:30,visible:true},
                     {dataField:"serialChk"    ,headerText:"Serial"         ,width:120    ,height:30,visible:true},
                     {dataField:"uom"    ,headerText:"UOM"         ,width:120    ,height:30,visible:false},
                    ];
 

var serialcolumn=[{dataField:"itmcd"        ,headerText:"Material Code"               ,width:"20%"    ,height:30 },
                         {dataField:"itmname"      ,headerText:"Material Name"               ,width:"25%"    ,height:30 },
                         {dataField:"serial"       ,headerText:"Serial"                      ,width:"30%"    ,height:30,editable:true },
                         {dataField:"cnt61"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"cnt62"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"cnt63"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"statustype"   ,headerText:"status"                      ,width:"30%"    ,height:30,visible:false }
                        ];                         
                    
                  
                    
var reqcolumnLayout;

 var resop = {
         rowIdField : "rnum", 
         // 페이지 설정
         usePaging : true,                
         pageRowCount : 20,                
         editable : false,                
         noDataMessage : gridMsg["sys.info.grid.noDataMessage"],
         //enableSorting : true,
         //selectionMode : "multipleRows",
         //selectionMode : "multipleCells",
        //  useGroupingPanel : true,
         // 체크박스 표시 설정
         showRowCheckColumn : true,
         // 전체 체크박스 표시 설정
         showRowAllCheckBox : true,
         softRemoveRowMode:false
         };
 var reqop = {
            rowIdField : "itmrnum",
            editable : true,
            softRemoveRowMode : false,
             // 체크박스 표시 설정
             showRowCheckColumn : true,
             // 전체 체크박스 표시 설정
             //showRowAllCheckBox : true,
            //displayTreeOpen : true,
            //showRowCheckColumn : true ,
            //enableCellMerge : true,
            //showStateColumn : false,
            //showBranchOnGrouping : false
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
 
 //var uomlist = f_getTtype('42' , '');
 var uomlist = [{code: "EA", codeId: 71, codeName: "Each"},{code: "PCS", codeId: 72, codeName: "Piece"},{code: "OTH", codeId: 75, codeName: "Others"},{code: "SET", codeId: 74, codeName: "Set"},{code: "PKT", codeId: 73, codeName: "Packet"}];
var comboDatas = [{"codeId": "OI","codeName": "OH_GI"},{"codeId": "OG","codeName": "OH_GR"}];
// var paramdata;


 $(document).ready(function(){
//     /**********************************
//     * Header Setting
//     ***********************************/
SearchSessionAjax();
$('#reqadd').hide();

// var paramdatas = { groupCode : '306' ,Codeval: 'OH' , orderValue : 'CODE' , likeValue:''};
// doGetComboData('/common/selectCodeList.do', paramdatas, '','smtype', 'S' , '');

//var paramdata = { groupCode : '308' , orderValue : 'CODE' , likeValue:'OH'};
var LocData = {sLoc : UserCode};
var LocData2 = {brnch : UserBranchId};
var paramdata2 = {endlikeValue:$("#locationType").val()};
//     doGetComboData('/common/selectCodeList.do', paramdata, '','insReqType', 'S' , '');
     //doGetComboCodeId('/common/selectStockLocationList.do',LocData, '','insReqLoc', 'S' , 'f_LocMultiCombo');
     //doGetComboCodeId('/common/selectStockLocationList.do',LocData2, '','insReqLoc', 'S' , 'f_LocMultiCombo');
     doGetComboCodeId('/common/selectStockLocationList.do',paramdata2, '','insReqLoc', 'S' , 'f_LocMultiCombo');
      doGetCombo('/common/selectCodeList.do', '15', '', 'PosItemType', 'M','f_multiCombo');
      doGetCombo('/common/selectCodeList.do', '11', '','catetype', 'M' , 'f_multiCombos'); 
      doSysdate(0 , 'insReqDate');
      doDefCombo(comboDatas, '' ,'insTransType', 'S', '');
//      $("#giopenwindow").hide();
//     /**********************************
//      * Header Setting End
//      ***********************************/
    
    reqcolumnLayout=[{dataField:"itmrnum"      ,headerText:"rnum"              ,width:120    ,height:30 ,visible:false},
                      {dataField:"itmcode"     ,headerText:"Code"        ,width:120    ,height:30 , editable:false},
                      {dataField:"itmdesc"     ,headerText:"Text"        ,width:120    ,height:30 , editable:false},
                      {dataField:"itemqty"   ,headerText:"Available Qty"      ,width:120    ,height:30 , editable:false},
                      /* {dataField:"rqty"      ,headerText:"Request Qty"    ,width:120    ,height:30 }, */
                      {dataField:"rqty"      ,headerText:"Request Qty"                ,width:120    ,height:30 , editable:true 
                          ,dataType : "numeric" ,editRenderer : {
                              type : "InputEditRenderer",
                              onlyNumeric : true, // 0~9 까지만 허용
                              allowPoint : false // onlyNumeric 인 경우 소수점(.) 도 허용
                        }
                      },
                      {dataField:"itemserialChk"       ,headerText:"Serial"            ,width:120    ,height:30,editable:false},
                      {dataField:"itemuom"       ,headerText:"UOM"            ,width:120    ,height:30,editable:false
                          ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                              var retStr = "";
                              for(var i=0,len=uomlist.length; i<len; i++) {
                                  if(uomlist[i]["codeId"] == value) {
                                      retStr = uomlist[i]["codeName"];
                                      break;
                                  }
                              }
                              return retStr == "" ? value : retStr;
                          },editRenderer : 
                          {
                             type : "ComboBoxRenderer",
                             showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                             list : uomlist,
                             keyField : "codeId",
                             valueField : "codeName"
                          }
                      }
                     ];
  
     resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout,"", resop);
     reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout,"", reqop);
//     serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);

    
    AUIGrid.bind(resGrid, "cellEditEnd", function (event){});
    AUIGrid.bind(reqGrid, "cellEditEnd", function (event){
        
 
        if(event.dataField == "rqty"){
            if(AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty") > AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemqty")){
                Common.alert('The requested quantity is up to '+AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemqty")+'.');
                return false;
            }
        }
        
          if(event.dataField == "itmcode"){
              $("#svalue").val(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd"));
              $("#sUrl").val("/logistics/material/materialcdsearch.do");
              Common.searchpopupWin("popupForm", "/common/searchPopList.do","stocklist");
          }
    
    });
    
    
    
    AUIGrid.bind(reqGrid, "cellEditEnd", function (event){
        
        var serialChkFlag = AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemserialChk"); 
        if (event.dataField != "rqty"){
            return false;
        }else{
            
            var del = AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty");
            if (del > 0){
                if ((Number(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemqty")) < Number(AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty"))) 
                    ||(Number(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemqty")) < Number(AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty")))){
                    Common.alert('Available Qty can not be greater than Request Qty.');
                    //AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstqty")
                    AUIGrid.restoreEditedRows(reqGrid, "selectedIndex");
                }else{

                       AUIGrid.addCheckedRowsByIds(reqGrid, event.item.itmrnum);                   
             
                }
            }else{
                AUIGrid.restoreEditedRows(reqGrid, "selectedIndex");
                AUIGrid.addUncheckedRowsByIds(reqGrid, event.item.rqty);               
            }
                
        }
    });
    
    
//     AUIGrid.bind(serialGrid, "cellEditEnd", function (event){
//         var tvalue = true;
//        var serial = AUIGrid.getCellValue(serialGrid, event.rowIndex, "serial");
//        serial=serial.trim();
//        if(""==serial || null ==serial){
//           //alert(" ( " + event.rowIndex + ", " + event.columnIndex + ") : clicked!!");
//           //AUIGrid.setSelectionByIndex(serialGrid,event.rowIndex, event.columnIndex);
//            Common.alert('Please input Serial Number.');
//            return false;
//        }else{
//            for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++){
//                if (event.rowIndex != i){
//                    if (serial == AUIGrid.getCellValue(serialGrid, i, "serial")){
//                        tvalue = false;
//                        break;
//                    }
//                }
//            }
           
//            if (tvalue){
//                fn_serialChck(event.rowIndex ,event.item , serial)
//            }else{
//                AUIGrid.setCellValue(serialGrid , event.rowIndex , "statustype" , 'N' );
//                AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {
//                    if (item.statustype  == 'N'){
//                        return "my-row-style";
//                    }
//                });
//                AUIGrid.update(serialGrid);
//            }
//           if($("#serialqty").val() > AUIGrid.getRowCount(serialGrid)){
//            var serialstus=$("#serialstus").val();      
//           if($("#serialstus").val() =="Y"){
//              f_addrow();                  
//              }
//           }
          
//        }
//     });
    
    
    
    
    AUIGrid.bind(resGrid, "cellClick", function( event ) {});
    AUIGrid.bind(reqGrid, "cellClick", function( event ) {});
    
    AUIGrid.bind(resGrid, "cellDoubleClick", function(event){});
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event){});
    
    AUIGrid.bind(resGrid, "ready", function(event) {});
    AUIGrid.bind(reqGrid, "ready", function(event) {});
    
});

// //btn clickevent
$(function(){
    $('#search').click(function() {
        if (searchReqType != 'OH03'){
        
            if (f_validatation('search')){
    //          $("#slocation").val($("#tlocation").val());
                SearchListAjax();
            }
        }else{
            Common.alert("Click The ADD Button");
        }
    });
    
    
    $('#insReqType').change(function() {
        searchReqType = $('#insReqType').val();
        //alert("searchReqType :  "+searchReqType);
        if (searchReqType == 'OH03'){
            $('#lirightBtn').hide();
            $('#reqadd').show();
            AUIGrid.setGridData(resGrid, []);
            AUIGrid.clearGridData(reqGrid);
        }else{
            $('#lirightBtn').show();
            $('#reqadd').hide();
        }   
    });
        
        $('#reqadd').click(function(){
            $("#svalue").val('');
            $("#sUrl").val("/logistics/material/materialcdsearch.do");
            Common.searchpopupWin("popupForm", "/common/searchPopList.do","stocklist");
       });
        

    $('#clear').click(function() {
    });
 
    
 $('#save').click(function() {
   var chkfalg;
   var checkDelqty= false; 
   var checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
//   for (var i = 0 ; i < checkedItems.length ; i++){
           
//         if (checkedItems[i].itemserialChk == 'Y'){
//             chkfalg="Y";
//             break;
//        }else{
//            chkfalg ="N";
//        } 
          
//     } 
   
//   if(chkfalg =="Y") {   

//          var checkedItems = AUIGrid.getCheckedRowItems(reqGrid);
//          var str = "";
//          var rowItem;
//          for(var i=0, len = checkedItems.length; i<len; i++) {
//              rowItem = checkedItems[i];
//              if(rowItem.item.rqty==0){
//              str += "Please Check Delivery Qty of  " + rowItem.item.itmcode   + ", " + rowItem.item.itmdesc + "<br />";
//              checkDelqty= true;
//              }
//          }
//          if(checkDelqty){
//              var option = {
//                  content : str,
//                  isBig:true
//              };
//              Common.alertBase(option); 
//          }else{
//           $("#giopenwindow").show();
//              AUIGrid.clearGridData(serialGrid);
//              AUIGrid.resize(serialGrid); 
//              fn_itemSerialPopList(checkedItems);
//              //fn_itempopList_T(checkedItems);
//          } 
         
//      }else{
       if (f_validatation('save')){
              insPosInfo();           
         }      
//     }     
   });

 
    $('#reqdel').click(function(){
        AUIGrid.removeCheckedRows(reqGrid);
//      AUIGrid.removeRow(reqGrid, "selectedIndex");
//        AUIGrid.removeSoftRows(reqGrid);
    });
    $('#list').click(function(){
        document.location.href = '/logistics/pos/PointOfSalesList.do';
    });

    
    $("#rightbtn").click(function(){

       checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);
        var bool = true;
        
        if (checkedItems.length > 0){
            
            var rowPos = "first";
            var item = new Object();
            var rowList = [];
            
            for (var i = 0 ; i < checkedItems.length ; i++){

                rowList[i] = {itmrnum : checkedItems[i].rnum,
                            itmtype : checkedItems[i].codeName,
                            itmcode : checkedItems[i].stkCode,
                            itmdesc : checkedItems[i].stkDesc,
                            itemqty : checkedItems[i].qty,
                            itemserialChk : checkedItems[i].serialChk,
                            itemuom : checkedItems[i].uom,
                            rqty:0
                        }
                
                AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
         
            } 
            
            AUIGrid.addRow(reqGrid, rowList, rowPos);
    }           
    });
    
     $("#insTransType").change(function(){
        var paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#insTransType").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '','insReqType', 'S' , '');
    });
});


function fn_serialChck(rowindex , rowitem , str){
    var schk = true;
    var ichk = true;
    var slocid = '';//session.locid;
    var data = { serial : str , locid : slocid};
    Common.ajaxSync("GET", "/logistics/pos/PointOfSalesSerialCheck.do", data, function(result) {

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
             
             if (result.data[0].L62CNT == 0 || result.data[0].L63CNT > 0){
                 schk = false;
             }else{
                 schk = true;
             }
             
             var checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);

             for (var i = 0 ; i < checkedItems.length ; i++){
                 if (result.data[0].STKCODE == checkedItems[i].itmcode){

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



function f_validatation(v){
    
    if (v == 'search'){
            if ($("#PosItemType").val() == null || $("#PosItemType").val() == undefined || $("#PosItemType").val() == ""){
                Common.alert("Please Select PosItemType.");
                return false;
            }
            
            if ($("#insReqLoc").val() == null || $("#insReqLoc").val() == undefined || $("#insReqLoc").val() == ""){
                Common.alert("Please Select Request Location.");
                return false;
            }   
        }
    if(v == 'save'){
        
        if ($("#insReqType").val() == "") {
            Common.alert("Please select the insReqType.");
            $("#insReqType").focus();
            return false;
        }
        if ($("#insReqDate").val() == "") {
            Common.alert("Please select the insReqDate.");
            $("#insReqDate").focus();
            return false;
        }
        if ($("#insRequestor").val() == "") {
            Common.alert("Please select the insRequestor.");
            $("#insRequestor").focus();
            return false;
        }
//         if ($("#insSmo").val() == "") {
//             Common.alert("Please enter the Stock Movement No.");
//             $("#insSmo").focus();
//             return false;
//         }
        if ($("#insReqLoc").val() == "") {
            Common.alert("Please select the insReqLoc.");
            $("#insReqLoc").focus();
            return false;
        }
        if ($("#insRemark").val() == "") {
            Common.alert("Please select the insRemark.");
            $("#insRemark").focus();
            return false;
        }
    }
    
    if (v == 'save'){
        var checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid); 
        var reqRowCnt = AUIGrid.getRowCount(reqGrid);
        var checkedRowCnt =checkedItems.length;
        var uncheckedRowCnt = reqRowCnt - checkedRowCnt;
        if (uncheckedRowCnt > 0  || reqRowCnt==0){
            Common.alert("Please enter Request Qty");
            return false;
        }
         for (var i = 0 ; i < checkedItems.length ; i++){
           if (checkedItems[i].itemuom =="" || checkedItems[i].itemuom == undefined){
               Common.alert("Please enter UOM");
               return false;
           }
         }
    }
    
//     if (v == 'saveSerial'){  
//     var serialRowCnt = AUIGrid.getRowCount(serialGrid);
//     var reqcheckedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
//     var serialcheckedItems = AUIGrid.getCheckedRowItemsAll(serialGrid);
    
    
// //     if(serialRowCnt != itm_qty){
// //       Common.alert("The quantity is not equal Request Qty");
// //       return false;
// //       }
//      for (var j = 0 ; j < reqcheckedItems.length ; j++){
//       var bool = false;
//       if (reqcheckedItems[j].itemserialChk == 'Y'){
//           for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++){
                    
// //                       alert(reqcheckedItems[i].itmcode);

//               if(reqcheckedItems[j].itmcode == AUIGrid.getCellValue(serialGrid , i , "itmcd")){
//                   bool = true;
//                   break;
//               }
//           }  
//           if(!bool){
//                  Common.alert("The Material Code No Same");   
//                  return false;
//                 }      
//         }
//      } 
//   } 

    return true;  
}

function SearchListAjax() {

    var url = "/logistics/pos/PosItemList.do";
    var param = $('#searchForm').serialize();

    Common.ajax("GET" , url , param , function(result){
     AUIGrid.setGridData(resGrid, result.data);
    });
}


function SearchSessionAjax() {
    var url = "/logistics/pos/SearchSessionInfo.do";
    Common.ajaxSync("GET" , url , '' , function(result){

        UserCode=result.UserCode;
        UserBranchId=result.UserBranchId;
        $("#insRequestor").val(result.UserName);
    });
}

function f_multiCombo() {
    $(function() {
        $('#PosItemType').change(function() {
        }).multipleSelect({
            selectAll : true,
            width: '100%'
        })      
    });
}
function f_multiCombos() {
    $(function() {
        $('#catetype').change(function() {
        }).multipleSelect({
            selectAll : true,
            width: '100%'
        })
    });
}

function f_LocMultiCombo() {
    $(function() {
        $('#insReqLoc').change(function() {
            $("#reqLoc").val($("#insReqLoc").val());
        });
    });
}


function fn_itemSerialPopList(data){
    
    checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
    
    var rowPos = "first";
    var rowList = [];
    var reqQty;
    var item = new Object();
    var itm_qty  = 0;

    for (var i = 0 ; i < data.length ; i++){
        
        if (data[i].item.itemserialChk == 'Y'){
            reqQty =data[i].item.rqty;
            itm_qty +=parseInt(reqQty)
        }       
    }
    $("#serialqty").val(itm_qty);
    
    f_addrow();
    
}


function fn_itempopList(data){
    
    var rowPos = "first";
    var rowList = [];
    
    AUIGrid.removeRow(reqGrid, "selectedIndex");
    AUIGrid.removeSoftRows(reqGrid);
    for (var i = 0 ; i < data.length ; i++){
        rowList[i] = {
            //itmid : data[i].item.itemid,
            itmcode : data[i].item.itemcode,
            itmdesc : data[i].item.itemname,
            itemserialChk : data[i].item.serialchk,
            itemuom       : data[i].item.uom
        }
    }
    
    AUIGrid.addRow(reqGrid, rowList, rowPos);
    
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
               Common.alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
           },
           complete: function(){
           }
       });
    
    return rData;
}



function fn_itempopList_T(data){
    
    var itm_temp = "";
    var itm_qty  = 0;
    var itmdata = [];
    for (var i = 0 ; i < data.length ; i++){
        itm_qty = itm_qty + data[i].item.rqty;
       // $("#reqstno").val(data[i].item.reqstno)
    }

    $("#serialqty").val(itm_qty);
    
   
}

function f_addrow(){
    var rowPos = "last";
    var item = new Object();
    AUIGrid.addRow(serialGrid, item, rowPos);
    return false;
}


function insPosInfo(){
    
        var data = {};
        var checkdata = AUIGrid.getCheckedRowItemsAll(reqGrid);
//      var serials = AUIGrid.getAddedRowItems(serialGrid);
//      console.log(serials);
//      data.add = serials;
        data.checked = checkdata;
        data.form = $("#headForm").serializeJSON();

        Common.ajaxSync("POST", "/logistics/pos/insertPosInfo.do", data, function(result) {
            Common.alert(""+result.message+"</br> Created : "+result.data, locationList);
            //Common.alert(result.message);
            $("#giopenwindow").hide();

        }, function(jqXHR, textStatus, errorThrown) {
            try {
            } catch (e) {
            }
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
        for (var i = 0; i < checkdata.length; i++) {
            AUIGrid.addUncheckedRowsByIds(reqGrid, checkdata[i].itmrnum);
        }
            
            
    }
    
function saveSerialInfo(){

       //if(f_validatation("save") && f_validatation("saveSerial")){
       if(f_validatation("save")){     
           insPosInfo();
        }   
    $("#giopenwindow").hide();
    
}

function locationList(){
    $('#list').click();
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Other Request</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Other Request</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="headForm" name="headForm" method="post">
<input type='hidden' id='pridic' name='pridic' value='M'/>
<input type='hidden' id='headtitle' name='headtitle' value='SOH'/>
<!--<input type='hidden' id='trnscType' name='trnscType' value='OH'/> -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Others Request</th>
    <td colspan="3"><input id="insOthersReq" name="insOthersReq" type="text" title="" placeholder="Automatic billing" class="readonly w100p" readonly="readonly" /></td>
    <th scope="row">Request Date</th>
    <td colspan="3">
    <input id="insReqDate" name="insReqDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
    </td>
</tr>
<tr>    
  <th scope="row">Transaction Type</th>
    <td colspan="3"><select class="w100p" id="insTransType" name="insTransType"></select></td>
    <th scope="row">Request Type</th>
    <td colspan="3"><select class="w100p" id="insReqType" name="insReqType"><option value=''>Choose One</option></select></td>  

</tr>
<tr>
    <th scope="row">Requestor</th>
    <td colspan="3">
    <input id="insRequestor" name="insRequestor" type="text" title="" placeholder=""  class="readonly w100p" readonly="readonly" />
    </td>
    <th scope="row">Stock Movement No</th>
     <td colspan="3">
    <input id="insSmo" name="insSmo" type="text" title="" placeholder="" class="w100p" />
    </td> 
</tr>
<tr>
    <th scope="row">Location Type </th>
    <td>
      <select class="w100p" id="locationType" name="locationType" onchange="fn_changeLocation()">
        <option> All </option>
        <option selected> A </option>
        <option> B </option>
    </select></td>
    <th scope="row">Request Location</th>
    <td colspan="5">
    <select class="w100p" id="insReqLoc" name="insReqLoc"></select>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="7"><input id="insRemark" name="insRemark" type="text" title="" placeholder="" class="w100p" /></td>
</tr>

</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Item Info</h3>

<ul class="right_btns">
        <li><p class="btn_blue2"><a id="search"><spring:message code='sys.btn.search' /></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" >
<input type="hidden" id="slocation" name="slocation">
<input type="hidden" id="reqLoc" name="reqLoc">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td colspan="3">
    <select class="w100p" id="PosItemType" name="PosItemType"></select>
    </td>
    <th scope="row">Category</th>
    <td colspan="3">
    <select class="w100p" id="catetype" name="catetype"></select>
    </td>
</tr>
<tr>
    <th scope="row">Material Code</th>
    <td colspan="3">
    <input type="text" class="w100p" id="materialCode" name="materialCode" />
    </td>
    <td colspan="4">
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto type2"><!-- divine_auto start -->

<div style="width:50%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Material Code</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:340px;"><!-- border_box start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="res_grid_wrap"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div><!-- 50% end -->

<div style="width:50%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Request Item</h3>

<ul class="right_btns">
            <li><p class="btn_blue2"><a id="attachment">Filter Attachment</a></p></li>
</ul>
</aside><!-- title_line end -->

<div class="border_box" style="height:340px;"><!-- border_box start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="reqadd">ADD</a></p></li>
    <li><p class="btn_grid"><a id="reqdel">DELETE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="req_grid_wrap" ></div>
</article><!-- grid_wrap end -->

<ul class="btns">
    <li id="lirightBtn"><a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
    <%-- <li><a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li> --%>
<%--     <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li> --%>
</ul>

</div><!-- border_box end -->

</div><!-- 50% end -->

</div><!-- divine_auto end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="list">List</a></p></li>&nbsp;&nbsp;
    <li><p class="btn_blue2 big"><a id="save">SAVE</a></p></li>
    <!-- <li><p class="btn_blue2 big"><a id="list">List</a></p></li>&nbsp;&nbsp;<li><p class="btn_blue2 big"><a onclick="javascript:insPosInfo();">SAVE</a></p></li> -->
</ul>



<div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1>Serial Check</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
            <form id="giForm" name="giForm" method="POST">
            <input type="hidden" name="gtype" id="gtype" value="GI"/>
            <input type="hidden" name="serialqty" id="serialqty"/>
            <input type="hidden" name="serialno" id="serialno"/>
            <input type="hidden" name="serialstus" id="serialstus"/>
<!--            <input type="hidden" name="ttype" id="ttype" value="OH"/>   -->
            <!-- <input type="hidden" id="posReqSeq" name="posReqSeq"> -->
            <table class="type1">
            <caption>search table</caption>
            <colgroup id="serialcolgroup">
            </colgroup>
            <tbody id="dBody">
            </tbody>
            </table>
<!--             <article class="grid_wrap">grid_wrap start -->
<!--             <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div> -->
<!--             </article>grid_wrap end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a onclick="javascript:saveSerialInfo();">SAVE</a></p></li>
            </ul>
            </form>
        
        </section>
    </div>


</section><!-- search_result end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>