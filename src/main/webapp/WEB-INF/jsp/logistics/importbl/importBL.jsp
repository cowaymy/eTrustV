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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;

var rescolumnLayout=[
                             {dataField:"rnum" ,headerText:"rnum",width:120 ,height:30,editable:false, visible:false},
                             {dataField:"whLocId" ,headerText:"whLocId",width:120 ,height:30,editable:false, visible:false},
                             {dataField:"whLocCode" ,headerText:"whLocCode",width:120 ,height:30,editable:false, visible:false},
                             {dataField:"whLocDesc" ,headerText:"Port",width:250 ,height:30,editable:false},
                             {dataField:"plant" ,headerText:"plant",width:120 ,height:30,editable:false, visible:false},
                             {dataField:"blNo" ,headerText:"BL No.",width:200 ,height:30,editable:false},
                             {dataField:"itmSeq" ,headerText:"Seq.",width:120 ,height:30,editable:false},
                             {dataField:"stkid" ,headerText:"stkid",width:120 ,height:30,editable:false, visible:false},
                             {dataField:"matrlNo" ,headerText:"Material Cd.",width:120 ,height:30,editable:false},
                             {dataField:"stkTypeId" ,headerText:"stkTypeId",width:120 ,height:30,editable:false, visible:false},
                             {dataField:"stkdesc" ,headerText:"Material",width:250,height:30,editable:false},
                             {dataField:"uom" ,headerText:"uom",width:120 ,height:30,editable:false, visible:false},
                             {dataField:"uomnm" ,headerText:"UOM",width:120 ,height:30,editable:false},
                             {dataField:"typename" ,headerText:"Type",width:120 ,height:30,editable:false},
                             {dataField:"stkCtgryId" ,headerText:"stkCtgryId",width:120 ,height:30,editable:false, visible:false},
                             {dataField:"ctgryname" ,headerText:"Catagory",width:120 ,height:30,editable:false},
                             {dataField:"qty" ,headerText:"BL Qty",width:120 ,height:30,editable:false,dataType : "numeric",style:"aui-grid-user-custom-right"},
                             {dataField:"avrqty" ,headerText:"Remain Qty",width:120 ,height:30,editable:false ,dataType : "numeric",style:"aui-grid-user-custom-right"},
                             {dataField:"reqedQty" ,headerText:"Moved Qty",width:120 ,height:30,editable:false ,dataType : "numeric",style:"aui-grid-user-custom-right"},
                             {dataField:"shipDt", headerText:"Shipping Date", width:120, height:30, editable:false},
                             {dataField:"grDt", headerText:"GR Date", width:120, height:30, editable:false},
                             {dataField:"apCmplt", headerText:"AP Complete", width:120, height:30, editable:false},
                             {dataField:"grCmplt", headerText:"GR Complete", width:120, height:30, editable:false},
                             {dataField:"purDocNo", headerText:"PO No.", width:120, height:30, editable:false},
                             {dataField:"accNo", headerText:"Vendor No.", width:120, height:30, editable:false},
                             {dataField:"freeItem", headerText:"Free Item", width:120, height:30, editable:false},
                             {dataField:"invCrtDt", headerText:"Invoice Cr. Date", width:120, height:30, editable:false},
                             {dataField:"delFlag", headerText:"Deletion Flag", width :120, height:30, editable:false}
                            ];

var smoLayout=[
                        {dataField:"reqstNo" ,headerText:"Reqst No",width:200 ,height:30},
                        {dataField:"trnscType" ,headerText:"Trnsc Type",width:120 ,height:30},
                        {dataField:"trnscTypeDtl" ,headerText:"Trnsc Type Dtl",width:120 ,height:30},
                        {dataField:"pridicFrqncy" ,headerText:"pridicFrqncy",width:120 ,height:30, visible:false},
                        {dataField:"reqstCrtDt" ,headerText:"Reqst Crt Dt",width:120 ,height:30},
                        {dataField:"reqstRequireDt" ,headerText:"reqstRequireDt",width:120 ,height:30, visible:false},
                        {dataField:"refDocNo" ,headerText:"refDocNo",width:120 ,height:30, visible:false},
                        {dataField:"docHderTxt" ,headerText:"docHderTxt",width:120 ,height:30, visible:false},
                        {dataField:"goodsRcipt" ,headerText:"goodsRcipt",width:120 ,height:30, visible:false},
                        {dataField:"rcivCdcRdc" ,headerText:"rcivCdcRdc",width:120 ,height:30, visible:false},
                        {dataField:"rcivCdcRdc2" ,headerText:"From",width:200 ,height:30},
                        {dataField:"reqstCdcRdc" ,headerText:"reqstCdcRdc",width:120 ,height:30, visible:false},
                        {dataField:"reqstCdcRdc2" ,headerText:"To",width:200 ,height:30},
                        {dataField:"reqstRem" ,headerText:"reqstRem",width:120 ,height:30, visible:false},
                        {dataField:"retnDefectResn" ,headerText:"retnDefectResn",width:120 ,height:30, visible:false},
                        {dataField:"retnPrsnCtCody" ,headerText:"retnPrsnCtCody",width:120 ,height:30, visible:false},
                        {dataField:"crtUserId " ,headerText:"crtUserId ",width:120 ,height:30, visible:false},
                        {dataField:"crtDt" ,headerText:"crtDt",width:120 ,height:30, visible:false},
                        {dataField:"reqstStus" ,headerText:"reqstStus",width:120 ,height:30, visible:false},
                        {dataField:"reqstDel" ,headerText:"reqstDel",width:120 ,height:30, visible:false},
                        {dataField:"reqstType" ,headerText:"reqstType",width:120 ,height:30, visible:false},
                        {dataField:"reqstTypeDtl" ,headerText:"reqstTypeDtl",width:120 ,height:30, visible:false},
                        {dataField:"reqstNoItm" ,headerText:"Reqst No Itm",width:120 ,height:30},
                        {dataField:"itmCode" ,headerText:"Itm Code",width:120 ,height:30},
                        {dataField:"itmName" ,headerText:"Itm Name",width:120 ,height:30},
                        {dataField:"reqstQty" ,headerText:"Reqst Qty",width:120 ,height:30},
                        {dataField:"uom" ,headerText:"uom",width:120 ,height:30, visible:false},
                        {dataField:"uomname" ,headerText:"UOM",width:120 ,height:30},
                        {dataField:"itmTxt" ,headerText:"itmTxt",width:120 ,height:30, visible:false},
                        {dataField:"finalCmplt" ,headerText:"finalCmplt",width:120 ,height:30, visible:false},
                        {dataField:"crtUserId" ,headerText:"User Id",width:120 ,height:30},
                        {dataField:"crtDt" ,headerText:"crtDt",width:120 ,height:30, visible:false},
                        {dataField:"updUserId" ,headerText:"updUserId",width:120 ,height:30, visible:false},
                        {dataField:"updDt" ,headerText:"updDt",width:120 ,height:30, visible:false},
                        {dataField:"rciptQty" ,headerText:"rciptQty",width:120 ,height:30, visible:false},
                        {dataField:"blNo" ,headerText:"BL No",width:120 ,height:30}
                     ];
var reqop = {
                    showRowCheckColumn : true ,
                    editable : true,
                    usePaging : false ,
                    showStateColumn : false
                 };
var smoop = {
                    enableCellMerge : true,
                    editable : false,
                    usePaging : false ,
                    showStateColumn : false
                 };

$(document).ready(function(){
    
   doGetCombo('/logistics/importbl/ImportLocationList', 'port', '','location', 'S' , ''); 
   
   doGetCombo('/common/selectCodeList.do', '15', '', 'smattype', 'M' ,'f_multiCombos');
   doGetCombo('/common/selectCodeList.do', '11', '', 'smatcate', 'M' ,'f_multiCombos');
   
   listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, reqop);
   subGrid  = AUIGrid.create("#sub_grid_wrap", smoLayout, smoop);
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    });
    AUIGrid.bind(listGrid, "cellEditBegin", function (event){
          if (AUIGrid.getCellValue(listGrid, event.rowIndex, "avrqty") <= 0){
              Common.alert('Req Qty can not be greater than Available Qty.');
              return false;
          }
    });
    AUIGrid.bind(listGrid, "cellEditEnd", function( event ) {
          AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
          AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);               
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
        searchSMO(event.rowIndex);
        $("#sub_grid_wrap").show();
        AUIGrid.clearGridData(subGrid);
        AUIGrid.resize(subGrid); 
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
});
$(function(){
    $('#search').click(function() {
           var fromVal = $("#grsdt").val();
           var toVal = $("#gredt").val();
           var from =  new Date( $("#grsdt").datepicker("getDate"));
           var to =  new Date( $("#gredt").datepicker("getDate"));
           if("" != $("#grsdt").val() &&  "" == $("#gredt").val()){
                   Common.alert("Please Check GR To Date.")
                    $("#gredt").focus();   
                   return false;
           }else if("" == $("#grsdt").val() &&   "" != $("#gredt").val()){
                   Common.alert("Please Check GR From Date.")
                    $("#grsdt").focus();   
                   return false;
           }else if("" !=  $("#grsdt").val() && "" !=  $("#gredt").val() ){
               if(0>= to - from ){
                   Common.alert("Please Check GR Date.")
                   return false;
               }
               
           }
           fromVal = $("#blsdt").val();
           toVal = $("#bledt").val();
           from =  new Date( $("#blsdt").datepicker("getDate"));
           to =  new Date( $("#bledt").datepicker("getDate"));
           if("" != $("#blsdt").val() &&  "" == $("#bledt").val()){
                   Common.alert("Please Check B/L To Date.")
                    $("#bledt").focus();   
                   return false;
           }else if("" == $("#blsdt").val() &&   "" != $("#bledt").val()){
                   Common.alert("Please Check B/L From Date.")
                    $("#blsdt").focus();   
                   return false;
           }else if("" !=  $("#blsdt").val() && "" !=  $("#bledt").val() ){
               if(0>= to - from ){
                   Common.alert("Please Check B/L Date.")
                   return false;
               }
               
           }
        SearchListAjax();
    });
    $('#clear').click(function() {
       $('#invno').val('');
       $('#blno').val('');
       $('#location').val('');
       $('#grsdt').val('');
       $('#gredt').val('');
       $('#blsdt').val('');
       $('#bledt').val('');
    });
});
 
function f_multiCombos() {
    $(function() {
        $('#smattype').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */ 
        $('#smatcate').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */ 
    });
}

function SearchListAjax() {
    var url = "/logistics/importbl/ImportBLList.do";
    var param = $('#searchForm').serialize();
    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
    });
}

function searchSMO(index){
     var whLocId =AUIGrid.getCellValue(listGrid ,index ,'whLocId');
     var blNo =AUIGrid.getCellValue(listGrid ,index ,'blNo');
     var matrlNo =AUIGrid.getCellValue(listGrid ,index ,'matrlNo');
     var itmSeq =AUIGrid.getCellValue(listGrid ,index ,'itmSeq');
    var data = {
              whLocId:whLocId,
              blNo:blNo,
              matrlNo:matrlNo,
              itmSeq:itmSeq,
              };
    var url = "/logistics/importbl/searchSMO.do";
    Common.ajax("POST" , url , data , function(data){
         AUIGrid.setGridData(subGrid, data.dataList);
    });
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Import B/L</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Import B/L</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li> 
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">

        <!-- menu setting -->
        <input type="hidden" name="CURRENT_MENU_CODE" value="${param.CURRENT_MENU_CODE}"/>
        <input type="hidden" name="CURRENT_MENU_FULL_PATH_NAME" value="${param.CURRENT_MENU_FULL_PATH_NAME}"/>
        <!-- menu setting -->

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
                    <th scope="row">Invoice No</th>
                    <td>
                        <input type="text" class="w100p" id="invno" name="invno"> 
                    </td>
                    <th scope="row">B/L No</th>
                    <td>
                        <input type="text" class="w100p" id="blno" name="blno"> 
                    </td>
                    <th scope="row">Location</th>
                    <td>
                        <select class="w100p" id="location" name="location"></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">GR Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="grsdt" name="grsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> To </span>
                        <p><input id="gredt" name="gredt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">B/L Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="blsdt" name="blsdt" type="text" title="Create start Date"   placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> To </span>
                        <p><input id="bledt" name="bledt" type="text" title="Create End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                     </td>
                     <th scope="row">PO No</th>
                     <td>
                        <input type="text" class="w100p" id="pono" name="pono" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type="text" id="materialcode" name="materialcode" title="" placeholder="Material Code" class="w100p" />
                    </td>
                    <th scope="row">Material Type</th>
                    <td>
                        <select id="smattype" name="smattype" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                    <th scope="row">Material Category</th>
                    <td>
                        <select id="smatcate" name="smatcate" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                </tr>
                
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->
    <section class="search_result"><!-- search_result start -->
     
    <!-- search_result & data body start -->
    <section class="search_result"><!-- search_result start -->

        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>
        

    </section><!-- search_result end -->
    <section class="search_result" ><!-- search_result start -->
        <div id="sub_grid_wrap" class="mt10" style="height:300px; display: none;" ></div>
    </section><!-- search_result end -->
        
            
</section>
</section>
