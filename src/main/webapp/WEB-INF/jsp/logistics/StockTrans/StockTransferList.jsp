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
var reqGrid;

var rescolumnLayout=[{dataField:"status"     ,headerText:"Status"          ,width:120    ,height:30 , visible:false},
                     {dataField:"reqstno"     ,headerText:"Stock Transfer Request"            ,width:120    ,height:30},
                     {dataField:"staname"    ,headerText:"Status"          ,width:120    ,height:30 },
                     {dataField:"reqitmno"     ,headerText:"Stock Transfer Request Item"          ,width:120    ,height:30},
                     {dataField:"ttype"     ,headerText:"Transaction Type"      ,width:120    ,height:30},
                     {dataField:"ttext"     ,headerText:"Transaction Type Text"      ,width:120    ,height:30},
                     {dataField:"mtype"     ,headerText:"Movement Type"      ,width:120    ,height:30},
                     {dataField:"mtext"     ,headerText:"Movement Text"      ,width:120    ,height:30},
                     {dataField:"froncy"    ,headerText:"Auto / Manual"      ,width:120    ,height:30},
                     {dataField:"crtdt"    ,headerText:"Request Create Date"      ,width:120    ,height:30},
                     {dataField:"reqdate"   ,headerText:"Request Required Date"      ,width:120    ,height:30},
                     {dataField:"rcvloc"   ,headerText:"From Location"      ,width:120    ,height:30},
                     {dataField:"rcvlocnm"   ,headerText:"From Location"      ,width:120    ,height:30},
                     {dataField:"rcvlocdesc"   ,headerText:"From Location"      ,width:120    ,height:30},
                     {dataField:"reqloc"     ,headerText:"To Location"      ,width:120    ,height:30},
                     {dataField:"reqlocnm"     ,headerText:"To Location"      ,width:120    ,height:30},
                     {dataField:"reqlocdesc"     ,headerText:"To Location"      ,width:120    ,height:30},
                     {dataField:"itmcode"     ,headerText:"Material Code"      ,width:120    ,height:30},
                     {dataField:"itmname"     ,headerText:"Material Name"      ,width:120    ,height:30},
                     {dataField:"reqstqty"     ,headerText:"Request Qty"      ,width:120    ,height:30},
                     {dataField:"delinote"     ,headerText:"Delivery Note"      ,width:120    ,height:30},
                     {dataField:"greceipt"     ,headerText:"Good Receipt"      ,width:120    ,height:30},
                     {dataField:"uom"     ,headerText:"Unit of Measure"      ,width:120    ,height:30},
                     {dataField:"uomnm"     ,headerText:"Unit of Measure"      ,width:120    ,height:30}];
var reqcolumnLayout;

//var resop = {usePaging : true,useGroupingPanel : true , groupingFields : ["reqstno"] ,displayTreeOpen : true, enableCellMerge : true, showBranchOnGrouping : false};
var resop = {// 그룹핑 패널 사용
        // 차례로 country, product, name 순으로 그룹핑을 합니다.
        // 즉, 각 나라별, 각 제품을 구매한 사용자로 그룹핑
        groupingFields : ["reqstno", "staname"],
        
        // 최초 보여질 때 모두 열린 상태로 출력 여부
        displayTreeOpen : true,
        
        // 셀병합 여부
        enableCellMerge : true,
        useContextMenu : false,
        showStateColumn : false,
        noDataMessage : gridMsg["sys.info.grid.noDataMessage"], //"출력할 데이터가 없습니다.",
        
        groupingMessage : gridMsg["sys.info.grid.groupingMessage"], // "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
        // 브랜치에 해당되는 행을 출력 여부
        showBranchOnGrouping : false};
var reqop = {usePaging : true,useGroupingPanel : false , Editable:true};

var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var uomlist = f_getTtype('42' , '');
var paramdata;
$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};
    doGetComboData('/common/selectCodeList.do', paramdata, '','sttype', 'S' , '');
    doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '','sstatus', 'S' , '');
    doGetCombo('/logistics/stocktransfer/selectStockTransferNo.do', '' , '','streq', 'S' , '');
    doGetCombo('/common/selectStockLocationList.do', '', '','tlocation', 'S' , '');
    doGetCombo('/common/selectStockLocationList.do', '', '','flocation', 'S' , '');
    doDefCombo(amdata, '' ,'sam', 'S', '');
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);//GridCommon.createAUIGrid("#main_grid_wrap", rescolumnLayout,"", resop);
    
    SearchListAjax();
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {});
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    	//var param = $('#searchForm').serialize();
//     	console.log(event.rowIndex);
//     	console.log(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
     	$("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
    	//$("#searchForm").attr('action','/logistics/stocktransfer/StocktransferView.do').submit();
    	document.searchForm.action = '/logistics/stocktransfer/StocktransferView.do';
    	document.searchForm.submit();
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {});
    
});

//btn clickevent
$(function(){
    $('#search').click(function() {
    	SearchListAjax();
    });
    $("#sttype").change(function(){
        paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
    });
});

function SearchListAjax() {

    var url = "/logistics/stocktransfer/StocktransferSearchList.do";
    var param = $('#searchForm').serializeJSON();
    console.log(param);
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
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Stock Transfer Request List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Stock Transfer Request List</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
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
                    <th scope="row">Stock Transfer Request</th>
                    <td>
                        <select class="w100p" id="streq" name="streq"></select>
                    </td>
                    <th scope="row">Stock Transfer Type</th>
                    <td>
                        <select class="w100p" id="sttype" name="sttype"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select class="w100p" id="smtype" name="smtype"><option value=''>Choose One</option></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">To Location</th>
                    <td>
                        <select class="w100p" id="tlocation" name="tlocation"></select>
                    </td>
                    <th scope="row">From Location</th>
                    <td >
                        <select class="w100p" id="flocation" name="flocation"></select>
                    </td>
                    <td colspan="2">&nbsp;</td>                
                </tr>
                
                <tr>
                    <th scope="row">Create Date</th>
                    <td>
                        <div class="date_set"><!-- date_set start -->
					    <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
					    <span> ~ </span>
					    <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
					    </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">Required Date</th>
                    <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="reqsdt" name="reqsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <td colspan="2">&nbsp;</td>                
                </tr>
                
                <tr>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="sstatus" name="sstatus"></select>
                    </td>
                    <th scope="row">Auto / Manual</th>
                    <td>
                        <select class="w100p" id="sam" name="sam"></select>
                    </td>
                    <td colspan="2">&nbsp;</td>              
                </tr>
            </tbody>
        </table><!-- table end -->

        <ul class="right_btns">
            <li><p class="btn_gray"><a id="clear"><span class="clear"></span>Clear</a></p></li>
            <li><p class="btn_gray"><a id="search"><span class="search"></span>Search</a></p></li>
        </ul>
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
            <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li>
            <li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
            <li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
            <li><p class="btn_grid"><a href="javascript:f_tabHide()"><span class="search"></span>ADD</a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:350px"></div>

    </section><!-- search_result end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>
