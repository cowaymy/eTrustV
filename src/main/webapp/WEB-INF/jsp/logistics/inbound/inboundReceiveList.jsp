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
var serialGrid;
var serialchk = false;
var rescolumnLayout=[{dataField:"rnum"         ,headerText:"rownum"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"delyno"       ,headerText:"Delivery No"                 ,width:120    ,height:30                },
                     {dataField:"ttype"        ,headerText:"Transaction Type"            ,width:120    ,height:30 , visible:false},
                     {dataField:"ttext"        ,headerText:"Transaction Type Text"       ,width:120    ,height:30                },
                     {dataField:"mtype"        ,headerText:"Movement Type"               ,width:120    ,height:30 , visible:false},
                     {dataField:"mtext"        ,headerText:"Movement Text"               ,width:120    ,height:30                },
                     {dataField:"rcvloc"       ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocnm"     ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocdesc"   ,headerText:"From Location"               ,width:120    ,height:30                },
                     {dataField:"reqloc"       ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocnm"     ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocdesc"   ,headerText:"To Location"                 ,width:120    ,height:30                },
                     {dataField:"delydt"       ,headerText:"Delivery Date"               ,width:120    ,height:30 },
                     {dataField:"gidt"         ,headerText:"GI Date"                     ,width:120    ,height:30 },
                     {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30},
                     {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                     {dataField:"delyqty"      ,headerText:"Delivered Qty"                ,width:120    ,height:30 },
                     {dataField:"rciptqty"     ,headerText:"Good Receipted Qty"             ,width:120    ,height:30 , editable:true},
                     {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                     {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                },
                     {dataField:"reqstno"      ,headerText:"Stock Movement Request"      ,width:120    ,height:30},
                     //{dataField:"grcmplt"      ,headerText:"GR COMPLET"                  ,width:120    ,height:30 , visible:false}
                     {dataField:"grcmplt"      ,headerText:"GR COMPLET"                  ,width:120    ,height:30 },
                     {dataField:"serialchk"      ,headerText:"Serial Y/N"                  ,width:120    ,height:30 }
                     ];
                     
                     
var serialcolumnLayout =[
                         {dataField:"delvryNo"           ,headerText:"Delivery No"      ,width:"20%"    ,height:30   ,cellMerge : true            },
                         {dataField:"itmCode"            ,headerText:"Material Code"      ,width:"15%"    ,height:30   ,cellMerge : true            },
                         {dataField:"itmName"            ,headerText:"Material Name"      ,width:"30%"    ,height:30   ,cellMerge : true            },
                         {dataField:"pdelvryNoItm"      ,headerText:"Delivery No. Item"      ,width:120    ,height:30   , visible:false           },
                         {dataField:"ttype"                ,headerText:"Transaction Type"      ,width:120    ,height:30   , visible:false           },
                         {dataField:"serialNo"             ,headerText:"Serial No."      ,width:"20%"    ,height:30              },
                         {dataField:"crtDt"                ,headerText:"Create Date"      ,width:"13%"    ,height:30              },
                         {dataField:"crtUserId"           ,headerText:"Create User"      ,width:120   ,height:30   , visible:false          },
                         
                        ];
                     
var serialcolumn       =[{dataField:"itmcd"        ,headerText:"Material Code"               ,width:"20%"    ,height:30 },
                         {dataField:"itmname"      ,headerText:"Material Name"               ,width:"25%"    ,height:30 },
                         {dataField:"serial"       ,headerText:"Serial"                      ,width:"30%"    ,height:30,editable:true },
                         {dataField:"cnt61"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"cnt62"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"cnt63"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"statustype"   ,headerText:"status"                      ,width:"30%"    ,height:30,visible:false }
                        ];                         
                     
var resop = {
        rowIdField : "rnum",            
        editable : true,
        groupingFields : ["delyno"],
        displayTreeOpen : true,
        showRowCheckColumn : true ,
        enableCellMerge : true,
        showStateColumn : false,
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


var paramdata;
$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , notlike:'US'};
    doGetComboData('/common/selectCodeList.do', paramdata, '','sttype', 'S' , 'f_change');
   //doGetCombo('/logistics/stockMovement/selectStockMovementNo.do', '{groupCode:delivery}' , '','seldelno', 'S' , '');
     doGetCombo('/logistics/inbound/InboundLocation', 'port', '','flocation', 'A' , ''); 
     doGetCombo('/logistics/inbound/InboundLocation', '', '','tlocation', 'A' , ''); 
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
//    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumnLayout, serialop);
    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);
    
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
        var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
        AUIGrid.clearGridData(serialGrid);
        AUIGrid.resize(serialGrid,980,380); 
        //fn_ViewSerial(delno);
        
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
         var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
        
        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
        	 var checklist = AUIGrid.getCheckedRowItemsAll(listGrid);
        	 var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
             for(var i = 0 ; i < checklist.length ; i++){
                 if (checklist[i].delyno != event.item.delyno){
                     Common.alert("Delivery number is different.");
                     AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
                     return false;
                 }
             }
            AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
        }else{
            AUIGrid.setCheckedRowsByValue(listGrid,  "delyno", []);
        }  
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function( event ) {
    });
    AUIGrid.bind(serialGrid, "cellEditEnd", function (event){
        var tvalue = true;
       var serial = AUIGrid.getCellValue(serialGrid, event.rowIndex, "serial");
       serial=serial.trim();
       if(""==serial || null ==serial){
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
});



function f_change(){
    paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
    doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
}
//btn clickevent
$(function(){
    $('#search').click(function() {
        SearchListAjax();
    });
    $('#clear').click(function() {
        $('#seldelno').val('');
        $('#flocation').val('');
        $('#tlocation').val('');
     });
    $("#sttype").change(function(){
        paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
    });
    
    $("#download").click(function() {
        GridCommon.exportTo("main_grid_wrap", 'xlsx', "InBound SMO Receipt List");
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
            var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
            var str = "";
            var rowItem;
            var serialchk=false; 
            for(var i=0, len = checkedItems.length; i<len; i++) {
                rowItem = checkedItems[i];
                if (rowItem.item.serialchk =='Y'){
                    serialchk = true;
                }
            }
            	$("#gropenwindow").show();
                $("#doctext").val("");
                doSysdate(0 , 'giptdate');
                doSysdate(0 , 'gipfdate');
                $('#grForm #gtype').val("GR");
                $("#dataTitle").text("InBound's Good Receipt Serials");
                AUIGrid.clearGridData(serialGrid);
                AUIGrid.resize(serialGrid,980,380); 
                if (serialchk){
                    //fn_itempopListSerial(checkedItems);
                    $("#serial_grid_wrap").show();
                    fn_itempopList_T(checkedItems);
                }else{
                    $("#serial_grid_wrap").hide();
                }
                
            }        	
    });
    
});


function SearchListAjax() {

    var url = "/logistics/inbound/ReceiptList.do";
    var param = $('#searchForm').serializeJSON();
    
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.dataList);
    });
}

function grFunc(){
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
    var check     = AUIGrid.getCheckedRowItems(listGrid);
    var serials   = AUIGrid.getAddedRowItems(serialGrid);
    
    if (serialchk){
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
    data.check   = check;
    data.checked = check;
    data.add = serials;
    data.form    = $("#grForm").serializeJSON();
    console.log(data);
    Common.ajax("POST", "/logistics/inbound/receipt.do", data, function(result) {
       
        Common.alert(result.message);
        $("#gropenwindow").hide();
        SearchListAjax()

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
        for (var i = 0 ; i < checkdata.length ; i++){
            AUIGrid.addUncheckedRowsByIds(listGrid, checkdata[i].rnum);
        }
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
             
             //if (result.data[0].L61CNT > 0 || result.data[0].L62CNT == 0 || result.data[0].L63CNT > 0){
             if (result.data[0].L62CNT == 0 || result.data[0].L63CNT > 0){ // 이동중인 serial 제외
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
function fn_itempopList_T(data){
    
    var itm_temp = "";
    var itm_qty  = 0;
    var itmdata = [];
    for (var i = 0 ; i < data.length ; i++){
    	if("Y"==data[i].item.serialchk){
           itm_qty = itm_qty + data[i].item.rciptqty;
    	}
        $("#reqstno").val(data[i].item.reqstno)
    }
    $("#serialqty").val(itm_qty);
    
    
    f_addrow();
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
     <li>InBound</li>
    <li>View - Receipt</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>InBound SMO Receipt</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3> </h3>
    <ul class="right_btns">
            <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
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
                    <th scope="row">Delivery Number</th>
                    <td>
                        <!-- <select class="w100p" id="seldelno" name="seldelno"></select> -->
                         <input type="text" class="w100p" id="seldelno" name="seldelno"> 
                    </td>
<!--                     <th scope="row">Transfer Type</th>
                    <td>
                        <select class="w100p" id="sttype" name="sttype"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select class="w100p" id="smtype" name="smtype"><option value=''>Choose One</option></select>
                    </td>
                </tr>
                <tr> -->
                    <th scope="row">From Location</th>
                    <td>
                         <select class="w100p" id="flocation" name="flocation"></select> 
                       <!--  <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm"> -->
                    </td>
                    <th scope="row">To Location</th>
                    <td >
                        <select class="w100p" id="tlocation" name="tlocation"></select>
                    <!--     <input type="hidden"  id="flocation" name="flocation">
                        <input type="text" class="w100p" id="flocationnm" name="flocationnm"> -->
                 <!--    </td>
                    <td colspan="2">
                    </td>  -->               
                </tr>
    <!--             
                <tr>
                    <th scope="row">Delivery Date</th>
                    <td>
                        <div class="date_set">date_set start
                        <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div>date_set end                        
                    </td>
                    <th scope="row">Required Date</th>
                    <td >
                        <div class="date_set">date_set start
                        <p><input id="reqsdt" name="reqsdt" type="text" title="Create start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="Create End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div>date_set end
                    </td>
                    <td colspan="2">&nbsp;</td>                
                </tr>                 -->
               
            </tbody>
        </table><!-- table end -->        
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
            <li><p class="btn_grid"><a id="gissue">Receipt</a></p></li>
            <!-- <li><p class="btn_grid"><a id="receiptcancel">Receipt Cancel</a></p></li> -->
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
                    <th scope="row">GR Posting Date</th>
                    <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                    <th scope="row">GR Doc Date</th>
                    <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                </tr>
<!--                 <tr>    
                    <th scope="row">Header Text</th>
                    <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
                </tr> -->
            </tbody>
            </table>
            <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div>
            </article><!-- grid_wrap end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a onclick="javascript:grFunc();">SAVE</a></p></li> 
            </ul>
            </form>
        
        </section>
    </div>
        <!-- Pop up: View Serial Of Delivery Number -->
<!--        <div class="popup_wrap" id="serialopenwindow" style="display:none">popup_wrap start
        <header class="pop_header">pop_header start
            <h1 id="dataTitle">Good Receipt - Serial View</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header>pop_header end
        <form>
        <section class="pop_body">pop_body start
            <article class="grid_wrap">grid_wrap start
            <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div>
            </article>grid_wrap end
        </section>
          </form>  
    </div>
     -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>

