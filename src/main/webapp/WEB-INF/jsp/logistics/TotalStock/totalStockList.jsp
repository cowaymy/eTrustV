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
var userCode;

                      
 var rescolumnLayout=[{dataField:"rnum"           ,headerText:"RowNum"            ,width:120    ,height:30 , visible:false},
                      {dataField:"stkCode"        ,headerText:"Material Code"     ,width:120    ,height:30 },
                      {dataField:"stkDesc"        ,headerText:"Material Name"     ,width:120    ,height:30                },
                      {dataField:"ctgryId"        ,headerText:"CategoryID"        ,width:120    ,height:30,visible:false  },
                      {dataField:"ctgryName"      ,headerText:"Category"          ,width:120    ,height:30                },
                      {dataField:"typeId"         ,headerText:"TypeID"            ,width:120    ,height:30,visible:false },
                      {dataField:"typeName"       ,headerText:"Type"              ,width:120    ,height:30 },
                      {dataField:"whLocCode"    ,headerText:"Location Code" ,width :120 ,height : 30},
                      {dataField:"locDesc"        ,headerText:"Location"          ,width:120    ,height:30 },
                      {dataField:"whlocgb"        ,headerText:"Location Grade"    ,width:120    ,height:30 },
                      {dataField:"qty"            ,headerText:"QTY"               ,width:120    ,height:30},
                      {dataField:"movQty"         ,headerText:"In-Transit QTY"    ,width:120    ,height:30                },
                      {dataField:"bookingQty"     ,headerText:"Booking QTY"       ,width:120    ,height:30                },
                      {dataField:"availableQty"   ,headerText:"Available Qty"     ,width:120    ,height:30                }
                      ];                     
                                    
//var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {
        showStateColumn : false , 
        editable : false, 
        useGroupingPanel : false
        };
        
var subgridpros = {
        // 페이지 설정
        usePaging : true,                
        pageRowCount : 20,                
        editable : false,                
        noDataMessage : "출력할 데이터가 없습니다.",
        enableSorting : true,
        //selectionMode : "multipleRows",
        //selectionMode : "multipleCells",
        useGroupingPanel : true,
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        // 전체 체크박스 표시 설정
        showRowAllCheckBox : true,
        //softRemoveRowMode:false
        };
var resop = {
        rowIdField : "rnum",            
        editable : true,
        fixedColumnCount : 6,
        groupingFields : ["reqstno"],
        displayTreeOpen : true,
        showRowCheckColumn : true ,
        enableCellMerge : true,
        showStateColumn : false,
        showRowAllCheckBox : true,
        showBranchOnGrouping : false
        };


        
var paramdata;

$(document).ready(function(){
    
    SearchSessionAjax();
    /**********************************
    * Header Setting
    **********************************/
    var LocData = {sLoc : userCode};
    //doGetComboCodeId('/common/selectStockLocationList.do',LocData, '','searchLoc', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '15', '', 'searchType', 'M','f_multiComboType');
    doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiCombos'); 
    doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'searchlocgb', 'M','f_multiCombo'); 
    doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE'}, '', 'searchlocgrade', 'A','');
    //
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, gridoptions);    
    
    
    //$("#sub_grid_wrap").hide(); 

    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {

    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){

    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
     
    
    
});


//btn clickevent
$(function(){
    $('#search').click(function() {
        if (f_validatation()){
            SearchListAjax();
        }
    });
    $('#clear').click(function() {
    	//$('#searchlocgb').val('');
    	$('#searchMatCode').val('');
    	$('#searchMatName').val('');
    	//$('#searchCtgry').val('');
    	//$('#searchType').val('');
    	  doGetCombo('/common/selectCodeList.do', '15', '', 'searchType', 'M','f_multiComboType');
    	    doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiCombos'); 
    	    doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'searchlocgb', 'M','f_multiCombo');    
    });
    
    $('#searchMatName').keypress(function(event) {
    	$('#searchMatCode').val('');
        if (event.which == '13') {
        	$("#stype").val('stock');
        	$("#svalue").val($('#searchMatName').val());
        	$("#sUrl").val("/logistics/material/materialcdsearch.do");
            Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
        }
    });
    $('#searchlocgrade').change(function(){
    	var searchlocgb = $('#searchlocgb').val();
    	
    	var locgbparam = "";
    	for (var i = 0 ; i < searchlocgb.length ; i++){
    		if (locgbparam == ""){
    			locgbparam = searchlocgb[i];
    		}else{
    			locgbparam = locgbparam +"∈"+searchlocgb[i]; 
    		}
    	}
    	
    	var param = {searchlocgb:locgbparam , grade:$('#searchlocgrade').val()}
    	doGetComboData('/common/selectStockLocationList2.do', param , '', 'searchLoc', 'M','f_multiComboType');
    });
});

function SearchSessionAjax() {
    var url = "/logistics/totalstock/SearchSessionInfo.do";
    Common.ajaxSync("GET" , url , '' , function(result){
        userCode=result.UserCode;
        $("#LocCode").val(userCode);
    });
}


function SearchListAjax() {
    var url = "/logistics/totalstock/totStockSearchList.do";
    var param = $('#searchForm').serialize();
    
    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}

function f_validatation(v){
             
             if ($("#searchlocgb").val() == null || $("#searchlocgb").val() == undefined || $("#searchlocgb").val() == ""){
                 Common.alert("Please Select Location Type.");
                 return false;
             }
             else {
            	 return true;
             }
}

function f_multiCombo() {
    $(function() {
        $('#searchlocgb').change(function() {
        	console.log('1');
        	if ($('#searchlocgb').val() != null && $('#searchlocgb').val() != "" ){
        	     var searchlocgb = $('#searchlocgb').val();
        	        
        	        var locgbparam = "";
        	        for (var i = 0 ; i < searchlocgb.length ; i++){
        	            if (locgbparam == ""){
        	                locgbparam = searchlocgb[i];
        	            }else{
        	                locgbparam = locgbparam +"∈"+searchlocgb[i]; 
        	            }
        	        }
        	        
        	        var param = {searchlocgb:locgbparam , grade:$('#searchlocgrade').val()}
        	        doGetComboData('/common/selectStockLocationList2.do', param , '', 'searchLoc', 'M','f_multiComboType');
        	  }
        }).multipleSelect({
            selectAll : true
        });        
    });
}
function f_multiComboType() {
    $(function() {
        $('#searchType').change(function() {
        }).multipleSelect({
            selectAll : true
        });  /* .multipleSelect("checkAll"); */
        $('#searchLoc').change(function() {
        }).multipleSelect({
            selectAll : true
        });
    });
}
function f_multiCombos() {
    $(function() {
        $('#searchCtgry').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */ 
    });
}

function fn_itempopList(data){
    
    var rtnVal = data[0].item;
    console.log(rtnVal);
    if ($("#stype").val() == "stock" ){
    	$("#searchMatCode").val(rtnVal.itemcode);
        $("#searchMatName").val(rtnVal.itemname);
    }else{
    	$("#searchLoc").val(rtnVal.locid);
        
    }
    
    $("#svalue").val();
} 

function searchlocationFunc(){
	console.log('111');
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Total Stock List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Total Stock List</h2>
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
        <input type="hidden" id="sUrl" name="sUrl">
        <INPUT type="hidden" id="svalue" name="svalue">
        <INPUT type="hidden" id="stype" name="stype">
        <input type="hidden" name="LocCode" id="LocCode" />    
        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                   <th scope="row">Location Type</th>
                   <td>
                        <select id="searchlocgb" name="searchlocgb" class="multy_select w100p"multiple="multiple"></select>                        
<!--                         <INPUT type="hidden" class="w100p" id="searchLoc" name="searchLoc"> -->
<!--                         <INPUT type="text"   class="w100p" id="searchLocNm" name="searchLocNm"> -->
                   </td> 
                   <th scope="row">Location Grade</th>
                   <td>
                        <select class="w100p" id="searchlocgrade" name="searchlocgrade"></select>
                   </td>
                   <th scope="row">Location</th>
                   <td>
                        <select class="w100p" id="searchLoc" name="searchLoc"><option value="">Choose One</option></select>
                   </td> 
                </tr>
                <tr>
                   <th scope="row">Material Code</th>
                   <td >
                      <input type="hidden" title="" placeholder=""  class="w100p" id="searchMatCode" name="searchMatCode"/>
                      <input type="text"   title="" placeholder=""  class="w100p" id="searchMatName" name="searchMatName"/>
                   </td> 
                    <th scope="row">Category</th>
                   <td>
                       <select class="w100p" id="searchCtgry"  name="searchCtgry"></select>
                   </td>
                   <th scope="row">Type</th>
                   <td>
                       <select class="w100p" id="searchType" name="searchType"></select>
                   </td>    
                </tr>
                             
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
    
        <ul class="right_btns">
<!--          <li><p class="btn_grid"><a id="insert">INS</a></p></li>             -->
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:500px"></div>
        

    </section><!-- search_result end -->

</section>

