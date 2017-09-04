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
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var mdcGrid;
var myGridID;
var detailGridID;

// AUIGrid 칼럼 설정                                                                            visible : false
var columnLayout = [{dataField:"matrlNo"      ,headerText:"Material Code"           ,width:"8%"  ,height:30 , visible:true},
                              {dataField:"stkDesc"      ,headerText:"Material Code Text"           ,width:"18%" ,height:30 , visible:true},
                              {dataField:"revStorgNm"      ,headerText:"Plant Text"           ,width:"22%"  ,height:30 , visible:true},
                              {dataField:"reqStorgNm"      ,headerText:"Sloc"           ,width:"23%" ,height:30 , visible:true},
                              {dataField:"invntryMovType"      ,headerText:"MvT"    ,width:"9%" ,height:30 , visible:true},
                              {dataField:"movtype"      ,headerText:"MvT Text"           ,width:"23%" ,height:30 , visible:true},
                              {dataField:"qty"      ,headerText:"Qty"    ,width:"8%" ,height:30 , visible:true},
                              {dataField:"matrlDocNo"      ,headerText:"Material Documents"    ,width:"13%" ,height:30 , visible:true},
                              {dataField:"matrlDocItm"      ,headerText:"Item"           ,width:"8%" ,height:30 , visible:true},
                              {dataField:"postingdate"      ,headerText:"Posting date"    ,width:"9%" ,height:30 , visible:true},
                              {dataField:""      ,headerText:""    ,width:"15%" ,height:30 , visible:false},
                              {dataField:""      ,headerText:""           ,width:"15%"  ,height:30 , visible:false},
                              {dataField:""      ,headerText:""           ,width:"15%"  ,height:30 , visible:false},
                   
                              {dataField:"dcfreqapproveremark"      ,headerText:"DCFReqApproveRemark"           ,width:"15%"  ,height:30 , visible:false},
                              {dataField:"dcfreqapproveby"      ,headerText:"DCFReqApproveBy"           ,width:"15%"  ,height:30 , visible:false},
                              {dataField:"reasondesc1"      ,headerText:"Reason (Approver Verified)"           ,width:"15%"  ,height:30 , visible:false},
                              {dataField:"c7"      ,headerText:"Approval Status"           ,width:"15%"  ,height:30 , visible:false},
                              {dataField:"c2"      ,headerText:"Approve At"           ,width:"15%"  ,height:30 , visible:false},
                              {dataField:"dcfreqstatusid"      ,headerText:"DCF_REQ_STUS_ID"           ,width:"15%"  ,height:30 , visible:false},
                                                                  
                           ];

/* var rescolumnLayout=[{dataField:"rnum"         ,headerText:"RowNum"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"status"       ,headerText:"Status"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"reqstno"      ,headerText:"Stock Movement Request"      ,width:120    ,height:30                },
                     {dataField:"staname"      ,headerText:"Status"                      ,width:120    ,height:30                },
                     {dataField:"reqitmno"     ,headerText:"Stock Movement Request Item" ,width:120    ,height:30 , visible:false},
                     {dataField:"ttype"        ,headerText:"Transaction Type"            ,width:120    ,height:30 , visible:false},
                     {dataField:"ttext"        ,headerText:"Transaction Type Text"       ,width:120    ,height:30                },
                     {dataField:"mtype"        ,headerText:"Movement Type"               ,width:120    ,height:30 , visible:false},
                     {dataField:"mtext"        ,headerText:"Movement Text"               ,width:120    ,height:30                },
                     {dataField:"froncy"       ,headerText:"Auto / Manual"               ,width:120    ,height:30                },
                     {dataField:"crtdt"        ,headerText:"Request Create Date"         ,width:120    ,height:30                },
                     {dataField:"reqdate"      ,headerText:"Request Required Date"       ,width:120    ,height:30                },
                     {dataField:"rcvloc"       ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocnm"     ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocdesc"   ,headerText:"From Location"               ,width:120    ,height:30                },
                     {dataField:"reqloc"       ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocnm"     ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocdesc"   ,headerText:"To Location"                 ,width:120    ,height:30                },
                     {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 , visible:false},
                     {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                     {dataField:"reqstqty"     ,headerText:"Request Qty"                 ,width:120    ,height:30                },
                     {dataField:"delvno"       ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"delyqty"      ,headerText:"Delivery Qty"                ,width:120    ,height:30 },
                     {dataField:"greceipt"     ,headerText:"Good Receipt"                ,width:120    ,height:30                },
                     {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                     {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                }];
                     
var reqcolumnLayout = [{dataField:"delyno"     ,headerText:"Delivery No"                   ,width:120    ,height:30                },
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
                       {dataField:"grdt"         ,headerText:"GR Date"                     ,width:120    ,height:30 },
                       {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 , visible:false},
                       {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                       {dataField:"delyqty"      ,headerText:"Delivery Qty"                ,width:120    ,height:30 },
                       {dataField:"rciptqty"        ,headerText:"Good ReceiptQty"             ,width:120    ,height:30                },
                       {dataField:"reqstno"      ,headerText:"Stock Movement Request"      ,width:120    ,height:30},
                       {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                       {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                }];

var mtrcolumnLayout = [
                        {dataField:"matrlDocNo", headerText:"" ,width:120    ,height:30},
                        {dataField:"matrlDocItm", headerText:"" ,width:120    ,height:30},
                        {dataField:"trnscTypeCode", headerText:"" ,width:120    ,height:30},
                        {dataField:"invntryMovType", headerText:"" ,width:120    ,height:30},
                        {dataField:"matrlDocYear", headerText:"" ,width:120    ,height:30},
                        {dataField:"autoCrtItm", headerText:"" ,width:120    ,height:30},
                        {dataField:"debtCrditIndict", headerText:"" ,width:120    ,height:30},
                        {dataField:"matrlNo", headerText:"" ,width:120    ,height:30},
                        {dataField:"itmName", headerText:"" ,width:120    ,height:30},
                        {dataField:"qty", headerText:"" ,width:120    ,height:30},
                        {dataField:"codeName", headerText:"" ,width:120    ,height:30},
                        {dataField:"rqloc", headerText:"" ,width:120    ,height:30},
                        {dataField:"rqlocid", headerText:"" ,width:120    ,height:30},
                        {dataField:"rqlocnm", headerText:"" ,width:120    ,height:30},
                        {dataField:"delvryNo", headerText:"" ,width:120    ,height:30},
                        {dataField:"itmCode", headerText:"" ,width:120    ,height:30},
                        {dataField:"stockTrnsfrReqst", headerText:"" ,width:120    ,height:30},
                        {dataField:"rcloc", headerText:"" ,width:120    ,height:30},
                        {dataField:"rclocid", headerText:"" ,width:120    ,height:30},
                        {dataField:"rclocnm", headerText:"" ,width:120    ,height:30},
                        {dataField:"uom", headerText:"" ,width:120    ,height:30},
                        {dataField:"uomnm", headerText:"" ,width:120    ,height:30}
           ]; */
//var resop = {usePaging : true,useGroupingPanel : true , groupingFields : ["reqstno"] ,displayTreeOpen : true, enableCellMerge : true, showBranchOnGrouping : false};
var resop = {
        rowIdField : "rnum",            
        //editable : true,
        groupingFields : ["reqstno", "staname"],
        displayTreeOpen : true,
        enableCellMerge : true,
        //showStateColumn : false,
        showBranchOnGrouping : false
        };
var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var paramdata;
$(document).ready(function(){
	
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("main_grid_wrap", columnLayout,"", gridoptions);
	
    /**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};
    doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.searchTrcType}','searchTrcType', 'S' , 'f_change');
    doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '${searchVal.sstatus}','sstatus', 'S' , '');
//     doGetCombo('/logistics/materialDoc/selectLocation.do', '', '','searchFromLoc', 'S' , '');//From Location 조회
//     doGetCombo('/logistics/materialDoc/selectLocation.do', '', '','searchToLoc', 'S' , '');//To Location 조회
    
    doGetCombo('/common/selectStockLocationList.do', '', '','searchFromLoc', 'S' , '');//From Location 조회
    doGetCombo('/common/selectStockLocationList.do', '', '','searchToLoc', 'S' , '');//To Location 조회
    //doGetComboData('/logistics/stocktransfer/selectStockTransferNo.do', {groupCode:'stock'} , '${searchVal.streq}','streq', 'S' , '');
    
    
    
    
    
//     paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:'UM'};
//     doGetComboDataAndMandatory('/common/selectCodeList.do', paramdata, '${searchVal.sttype}','sttype', 'S' , 'f_change');
//     doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '${searchVal.sstatus}','sstatus', 'S' , '');
//     doGetCombo('/logistics/stockMovement/selectStockMovementNo.do', {groupCode:'stock'} , '${searchVal.streq}','streq', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '${searchVal.tlocation}','tlocation', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '${searchVal.flocation}','flocation', 'S' , 'SearchListAjax');
//     //doDefCombo(amdata, '${searchVal.sam}' ,'sam', 'S', '');        
//     //doDefCombo(amdata, '${searchVal.smvpath}' ,'smvpath', 'S', '');
//     $("#crtsdt").val('${searchVal.crtsdt}');
//     $("#crtedt").val('${searchVal.crtedt}');
//     $("#reqsdt").val('${searchVal.reqsdt}');
//     $("#reqedt").val('${searchVal.reqedt}');
    
//     /**********************************
//      * Header Setting End
//      ***********************************/
    
//     listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
//     subGrid  = GridCommon.createAUIGrid("#sub_grid_wrap", reqcolumnLayout ,"", reqop);
//     mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", mtrcolumnLayout ,"", reqop);
//     $("#sub_grid_wrap").hide(); 
//     $("#mdc_grid").hide(); 
    
//     AUIGrid.bind(listGrid, "cellClick", function( event ) {
// //         $("#sub_grid_wrap").hide(); 
// //         $("#mdc_grid").hide(); 
// //         if (event.dataField == "reqstno"){
// //             SearchDeliveryListAjax(event.value)
// //         }
//     });
    
//     AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
// //         $("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
// //         document.searchForm.action = '/logistics/stockMovement/StockMovementView.do';
// //         document.searchForm.submit();
//     });
    
//     AUIGrid.bind(listGrid, "ready", function(event) {
//     });
    
});




$(function(){
    $("#search").click(function() {
        SearchListAjax();
    });
    
    $("#searchTrcType").change(function(){
        paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#searchTrcType").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','searchMoveType', 'S' , '');
    });
});

function f_change(){
    $("#searchTrcType").change();
}

// function f_change(){
//     $("#sttype").change();
// }
// //btn clickevent


function SearchListAjax() {
   
    var url = "/logistics/materialDoc/MaterialDocSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(myGridID, data.data);
        
    });
}

// function SearchDeliveryListAjax( reqno ) {
//     var url = "/logistics/stockMovement/StockMovementRequestDeliveryList.do";
//     var param = "reqstno="+reqno;
//     $("#sub_grid_wrap").show(); 
//     $("#mdc_grid").show(); 
    
//     Common.ajax("GET" , url , param , function(data){
//         AUIGrid.setGridData(subGrid, data.data);
//         //mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", reqcolumnLayout ,"", reqop);
//         AUIGrid.resize(mdcGrid,1620,150); 
//         AUIGrid.setGridData(mdcGrid, data.data2);
//         console.log(data.data2);
//     });
// }

// function f_getTtype(g , v){
//     var rData = new Array();
//     $.ajax({
//            type : "GET",
//            url : "/common/selectCodeList.do",
//            data : { groupCode : g , orderValue : 'CRT_DT' , likeValue:v},
//            dataType : "json",
//            contentType : "application/json;charset=UTF-8",
//            async:false,
//            success : function(data) {
//               $.each(data, function(index,value) {
//                   var list = new Object();
//                   list.code = data[index].code;
//                   list.codeId = data[index].codeId;
//                   list.codeName = data[index].codeName;
//                   rData.push(list);
//                 });
//            },
//            error: function(jqXHR, textStatus, errorThrown){
//                alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
//            },
//            complete: function(){
//            }
//        });
    
//     return rData;
// }
</script> 

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Stock Movement Request List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Material Document List</h2>

</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
      <li><p class="btn_gray"><a id="clear"><span class="clear"></span>Clear</a></p></li>
      <li><p class="btn_gray"><a id="search"><span class="search"></span>Search</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" name="rStcode" id="rStcode" />    
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
                    <th scope="row">CDC</th>
                    <td>
                        <select class="w100p" id="searchCdc" name="searchCdc"></select>
                    </td>
                    <th scope="row">RDC</th>
                    <td>
                        <select class="w100p" id="searchRdc" name="searchRdc"></select>
                    </td>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <th scope="row">From Location</th>
                    <td>
                        <select class="w100p" id="searchFromLoc" name="searchFromLoc"></select>
                    </td>
                    <th scope="row">To Location</th>
                    <td>
                        <select class="w100p" id="searchToLoc" name="searchToLoc"></select>
                    </td>
                     <td colspan="2">&nbsp;</td>
                </tr> 
                <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type="text" id="searchMaterialCode" name="searchMaterialCode" title="" placeholder="Material Code" class="w100p" />
                    </td>
                    <th scope="row">Stock Transaction Type</th>
                    <td>
                        <select class="w100p" id="searchTrcType" name="searchTrcType"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select class="w100p" id="searchMoveType" name="searchMoveType"><option value=''>Choose One</option></select>
                    </td>
                </tr>             
                <tr>
                    <th scope="row">Posting Date</th>
                    <td>
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="PostingDt1" name="PostingDt1" type="text" title="Posting start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="PostingDt2" name="PostingDt2" type="text" title="Posting End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">Create Date</th>
                    <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="CreateDt1" name="CreateDt1" type="text" title="Create start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="CreateDt2" name="CreateDt2" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row">Customer</th>
                    <td >
                        <input type="text" id="searchCustomer" name="searchCustomer" title="" placeholder="Customer" class="w100p" />
                    </td>              
                </tr>
                 <tr>
                    <th scope="row">Vendor</th>
                    <td>
                        <input type="text" id="searchVendor" name="searchVendor" title="" placeholder="Vendor" class="w100p" />
                    </td>
                    <th scope="row">Batch</th>
                    <td>
                        <input type="text" id="searchBatch" name="searchBatch" title="" placeholder="Batch" class="w100p" />
                    </td>
                    <th scope="row">User Name</th>
                     <td>
                        <input type="text" id="searchUserNm" name="searchUserNm" title="" placeholder="User Name" class="w100p" />
                    </td>
                </tr>      
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="insert"><span class="search"></span>INS</a></p></li>            
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:300px"></div>
        
    <!--    <div id="sub_grid_wrap" class="mt10" style="height:350px"></div>  -->

    </section><!-- search_result end -->
    
    
   <!--  <section class="tap_wrap">tap_wrap start
        <ul class="tap_type1">
            <li><a href="#" class="on">Register Order</a></li>
            <li><a href="#">Compliance Remark</a></li>
        </ul>
        
        <article class="tap_area">tap_area start
        
            <article class="grid_wrap">grid_wrap start
                  <div id="sub_grid_wrap" class="mt10" style="height:150px"></div>
            </article>grid_wrap end
        
        </article>tap_area end
            
        <article class="tap_area">tap_area start
            <article class="grid_wrap">grid_wrap start
                 <div id="mdc_grid"  class="mt10" ></div>
            </article>grid_wrap end
        </article>tap_area end
        
    </section>tap_wrap end
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
 -->



</section>

