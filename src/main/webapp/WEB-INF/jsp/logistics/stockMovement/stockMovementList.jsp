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
var subGrid;
var mdcGrid;

var rescolumnLayout=[{dataField:"rnum"         ,headerText:"RowNum"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"status"       ,headerText:"Status"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"reqstno"      ,headerText:"Stock Movement Request"      ,width:120    ,height:30                },
                     {dataField:"staname"      ,headerText:"Status"                      ,width:120    ,height:30                },
                     {dataField:"rcvloc"       ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocnm"     ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocdesc"   ,headerText:"From Location"               ,width:120    ,height:30                },
                     {dataField:"reqloc"       ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocnm"     ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocdesc"   ,headerText:"To Location"                 ,width:120    ,height:30                },
                     {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 },
                     {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                     {dataField:"reqstqty"     ,headerText:"Requested Qty"                 ,width:120    ,height:30                },
                     {dataField:"delvno"       ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"delyqty"      ,headerText:"Delivered Qty"                ,width:120    ,height:30 },
                     {dataField:"greceipt"     ,headerText:"Good Receipted"                ,width:120    ,height:30              },
                     {dataField:"docno"        ,headerText:"Ref Doc.No"             ,width:120    ,height:30                },
                     {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                     {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                },
                     {dataField:"reqitmno"     ,headerText:"Stock Movement Request Item" ,width:120    ,height:30 , visible:false},
                     {dataField:"ttype"        ,headerText:"Transaction Type"            ,width:120    ,height:30 , visible:false},
                     {dataField:"ttext"        ,headerText:"Transaction Type Text"       ,width:120    ,height:30                },
                     {dataField:"mtype"        ,headerText:"Movement Type"               ,width:120    ,height:30 , visible:false},
                     {dataField:"mtext"        ,headerText:"Movement Text"               ,width:120    ,height:30                },
                     {dataField:"froncy"       ,headerText:"Auto / Manual"               ,width:120    ,height:30                },
                     {dataField:"crtdt"        ,headerText:"Request Create Date"         ,width:120    ,height:30                },
                     {dataField:"reqdate"      ,headerText:"Request Required Date"       ,width:120    ,height:30                }];
                     
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
                       {dataField:"delyqty"      ,headerText:"Delivered Qty"                ,width:120    ,height:30 },
                       {dataField:"rciptqty"        ,headerText:"Good Receipted Qty"             ,width:120    ,height:30                },
                       {dataField:"reqstno"      ,headerText:"Stock Movement Request"      ,width:120    ,height:30},
                       {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                       {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                }];

var mtrcolumnLayout = [
                       {dataField:"matrlDocNo", headerText:"Matrl Doc No" ,width:200    ,height:30},
                       {dataField:"matrlDocItm", headerText:"Matrl Doc Itm" ,width:120    ,height:30},
                       {dataField:"trnscTypeCode", headerText:"Transfer Type" ,width:120    ,height:30},
                       {dataField:"invntryMovType", headerText:"Transfer Type Dtl" ,width:120    ,height:30},
                       {dataField:"matrlDocYear", headerText:"Matrl Doc Year" ,width:120    ,height:30},
                       {dataField:"autoCrtItm", headerText:"Auto Crt " ,width:120    ,height:30},
                       {dataField:"debtCrditIndict", headerText:"Debt Crdit Indict" ,width:120    ,height:30},
                       {dataField:"matrlNo", headerText:"Matrl No" ,width:120    ,height:30},
                       {dataField:"itmName", headerText:"Matrl Name" ,width:200    ,height:30},
                       {dataField:"qty", headerText:"Qty" ,width:100    ,height:30},
                       {dataField:"codeName", headerText:" " ,width:120    ,height:30, visible:false},
                       {dataField:"rqloc", headerText:"" ,width:120    ,height:30, visible:false},
                       {dataField:"rqlocid", headerText:"" ,width:120    ,height:30, visible:false},
                       {dataField:"delvryNo", headerText:"Delivery No" ,width:200    ,height:30},
                       {dataField:"itmCode", headerText:"Itm Code" ,width:120    ,height:30},
                       {dataField:"stockTrnsfrReqst", headerText:"Req No" ,width:120    ,height:30},
                       {dataField:"rcloc", headerText:"" ,width:120    ,height:30, visible:false},
                       {dataField:"rclocid", headerText:"" ,width:120    ,height:30, visible:false},
                       {dataField:"rclocnm", headerText:"From" ,width:200   ,height:30},
                       {dataField:"rqlocnm", headerText:"To" ,width:200   ,height:30},
                       {dataField:"uom", headerText:"" ,width:120    ,height:30 , visible:false},
                       {dataField:"uomnm", headerText:"UOM" ,width:120    ,height:30}
           ];
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
var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var uomlist = f_getTtype('42' , '');
var paramdata;
$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
    var arrsttype = 'US,OH'.split(',');
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , Codeval:'UM'};
    //paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , notlike:'US'};
    
    //doGetComboDataAndMandatory('/common/selectCodeList.do', paramdata, '${searchVal.sttype}','sttype', 'S' , 'f_change');
    doGetComboData('/common/selectCodeList.do', paramdata, ('${searchVal.sttype}'==''?'UM':'${searchVal.sttype}'),'sttype', 'S' , 'f_change');
    doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '${searchVal.sstatus}','sstatus', 'S' , '');
    //doGetComboData('/logistics/stockMovement/selectStockMovementNo.do', {groupCode:'stock'} , '${searchVal.streq}','streq', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '${searchVal.tlocation}','tlocation', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '${searchVal.flocation}','flocation', 'S' , 'SearchListAjax');
    //doDefCombo(amdata, '${searchVal.sam}' ,'sam', 'S', '');        
    //doDefCombo(amdata, '${searchVal.smvpath}' ,'smvpath', 'S', '');
    $("#crtsdt").val('${searchVal.crtsdt}');
    $("#crtedt").val('${searchVal.crtedt}');
    $("#reqsdt").val('${searchVal.reqsdt}');
    $("#reqedt").val('${searchVal.reqedt}');
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    subGrid  = GridCommon.createAUIGrid("#sub_grid_wrap", reqcolumnLayout ,"", reqop);
    mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", mtrcolumnLayout ,"", reqop);
    $("#sub_grid_wrap").hide(); 
    $("#mdc_grid").hide(); 
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
        $("#sub_grid_wrap").hide(); 
        $("#mdc_grid").hide(); 
        if (event.dataField == "reqstno"){
            SearchDeliveryListAjax(event.value)
        }
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    	
        $("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
        document.searchForm.action = '/logistics/stockMovement/StockMovementView.do';
        document.searchForm.submit();
        
        
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    //SearchListAjax();
});
function f_change(){
    paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val(),codeIn:'UM03,UM93'};
    doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
}
//btn clickevent
$(function(){
    $('#search').click(function() {
        SearchListAjax();
    });
    $("#clear").click(function(){
        $("#searchForm")[0].reset();
    });
    $("#sttype").change(function(){
        paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
    });

    $("#download").click(function() {
        GridCommon.exportTo("main_grid_wrap", 'xlsx', "SMO List");
    });
    $('#insert').click(function(){
        document.searchForm.action = '/logistics/stockMovement/StockMovementIns.do';
        document.searchForm.submit();
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
	 
    //var url = "/logistics/stockMovement/StocktransferSearchList.do";
    var url = "/logistics/stockMovement/StockMovementSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}

function SearchDeliveryListAjax( reqno ) {
    var url = "/logistics/stockMovement/StockMovementRequestDeliveryList.do";
    var param = "reqstno="+reqno;
    $("#sub_grid_wrap").show(); 
    $("#mdc_grid").show(); 
    
    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(subGrid, data.data);
        //mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", reqcolumnLayout ,"", reqop);
        //AUIGrid.resize(mdcGrid,1620,150); 
        AUIGrid.resize(mdcGrid,1876,191); 
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

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Stock Movement Request List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Stock Movement Request List</h2>
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
        
        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="sUrl"   name="sUrl"  />
        <input type="hidden" id="stype"  name="stype" />
    
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
                    <th scope="row">Stock Movement Request</th>
                    <td>
                        <input type="text" class="w100p" id="streq" name="streq">
                    </td>
                    <th scope="row">Transaction Type</th>
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
                     <th scope="row">Ref Doc.No</th>
                     <td ><input type="text" class="w100p" id="sdocno" name="sdocno"></td>            
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
                    <td colspan="2">&nbsp;</td>                
                </tr>
                
                <tr>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="sstatus" name="sstatus"></select>
                    </td>
                    <th scope="row">Movement Path</th>
                    <td> 
                       <!--  <select class="w100p" id="smvpath" name="smvpath"></select> -->
                            <select class="w100p">
                                <option value=" "></option>
                                <option value="1">RDC to CT/Cody</option>
                                <option value="2">CT/Cody to CT/Cody</option>
                            </select>
                    </td>
                    <td colspan="2">&nbsp;</td>              
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
		    <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
		    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.ins' /></a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>
        
<!--         <div id="sub_grid_wrap" class="mt10" style="height:350px"></div> -->

    </section><!-- search_result end -->
    <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on">Delivery No Info</a></li>
            <li><a href="#">Material Document Info</a></li>
        </ul>
        
        <article class="tap_area"><!-- tap_area start -->
        
            <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="sub_grid_wrap" class="mt10" style="height:150px"></div>
            </article><!-- grid_wrap end -->
        
        </article><!-- tap_area end -->
            
        <article class="tap_area"><!-- tap_area start -->
            <article class="grid_wrap"><!-- grid_wrap start -->
                 <div id="mdc_grid"  class="mt10" ></div>
            </article><!-- grid_wrap end -->
        </article><!-- tap_area end -->
        
    </section><!-- tap_wrap end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>

