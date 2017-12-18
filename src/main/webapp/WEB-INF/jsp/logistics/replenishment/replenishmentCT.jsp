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
};

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var comboData1 = [{"codeId": "62","codeName": "Filter"},{"codeId": "63","codeName": "Spare Part"}];

var rescolumnLayout=[{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>",width:150    ,height:30 , visible:false},                         
                     {dataField: "period",headerText :"<spring:message code='log.head.period'/>"    ,dataType : "date"    ,formatString :     "mm/yyyy" ,width:140    ,height:30  , editable:false},        
                     {dataField: "ctNo",headerText :"<spring:message code='log.head.ctno'/>"                     ,width:140    ,height:30 , editable:false},                         
                     {dataField: "ctName",headerText :"<spring:message code='log.head.ctname'/>"                ,width:150    ,height:30 , editable:false},                          
                     {dataField: "itmcd",headerText :"<spring:message code='log.head.materialcode'/>"                   ,width:140    ,height:30 , editable:false},                          
                     {dataField: "itmnm",headerText :"<spring:message code='log.head.materialcodetext'/>"              ,width:154    ,height:30 , editable:false},                       
                     {dataField: "maxqty",headerText :"<spring:message code='log.head.maximumqty'/>"                  ,width:140    ,height:30 , editable:true},                         
                     {dataField: "reordqty",headerText :"<spring:message code='log.head.reorderqty'/>"                    ,width:140    ,height:30 , editable:true},                         
                     {dataField: "avgqty",headerText :"<spring:message code='log.head.averageqty'/>"                  ,width:140    ,height:30 , editable:false},                        
                     {dataField: "stkTypeName",headerText :"<spring:message code='log.head.type'/>"                   ,width:140    ,height:30 , editable:false}
                     ];
                     
// AUIGrid.showColumnByDataField(myGridID, "sftyqty"); 
// hideColumnByDataField
//var resop = {usePaging : true,useGroupingPanel : true , groupingFields : ["reqstno"] ,displayTreeOpen : true, enableCellMerge : true, showBranchOnGrouping : false};
var resop = {
        rowIdField : "rnum",            
        //editable : true,
        //groupingFields : ["reqstno", "staname"],
        displayTreeOpen : true,
        enableCellMerge : true,
        editable : true,
        //showStateColumn : false,
        showBranchOnGrouping : false
        };
var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var paramdata;
var rABS; 
var result;
$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
    $("#sftyqty").val(0);
    
       doDefCombo(comboData1, '' ,'searchType', 'S', '');
       doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiCombos'); 
       doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'searchlocgb', 'M','f_multiCombo'); 
       doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE'}, '', 'searchlocgrade', 'A','');
       
    rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";
    
    /**********************************
     * Header Setting End
     ***********************************/
     
     //createInitGrid();
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
    AUIGrid.bind(subGrid, "ready", function(event) {
    	
    });
    
});

//btn clickevent
$(function(){
    $('#search').click(function() {
    	result='S';
    	if(validationchk(result)){
        SearchListAjax();
    	}
    });
    $("#clear").click(function(){
        $('#searchMatCode').val('');
        $('#searchMatName').val('');
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
    $("#sttype").change(function(){
       
    });
    $('#add').click(function(){
    	$("#giopenwindow").show();
    	$("#popForm")[0].reset();
    });
    $('#edit').click(function(){
    	var updCnt = GridCommon.getEditData(listGrid).update.length;
    	var dat = GridCommon.getEditData(listGrid);

       if(updCnt <= 0) {
    		 Common.alert('Please Enter Maximum Qty or Reorder Qty Data.');
       }else{
        Common.ajax("POST", "/logistics/replenishment/relenishmentSave.do", dat, function(result) {
            Common.alert(result.message , SearchListAjax);
        },  function(jqXHR, textStatus, errorThrown) {
            try {
            } catch (e) {
            }
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });  
        }
    });
    
    $('#popsave').click(function(){
    	result='A';
        var param = $('#popForm').serializeJSON();
        
        if (validationchk(result)){
	        Common.ajax("POST", "/logistics/replenishment/relenishmentPopSave.do", param, function(result) {
	        	Common.alert(result.message , SearchListAjax);
	        	$("#giopenwindow").hide();
	        },  function(jqXHR, textStatus, errorThrown) {
	            try {
	            } catch (e) {
	            }
	
	            Common.alert("Fail : " + jqXHR.responseJSON.message);
	        });
        }else{
        	return false;
        }
    });

    $('#sloccode').change(function(){
    });
   
    $("#itmnm").keyup(function(e) {
    	if (event.which == '13') {
        	$("#sUrl").val("/logistics/material/materialcdsearch.do");
        	$("#svalue").val($("#itmnm").val());
            Common.searchpopupWin("popupForm", "/common/searchPopList.do","stock");
        }
    });
    $(".numberAmt").keyup(function(e) {
        //regex = /^[0-9]+(\.[0-9]+)?$/g;
        regex = /[^.0-9]/gi;

        v = $(this).val();
        if (regex.test(v)) {
            var nn = v.replace(regex, '');
            $(this).val(v.replace(regex, ''));
            $(this).focus();
            return;
        }
    });
});

function validationchk(result){
	
	if(result=='S'){
    if ($("#searchperiod").val() == ''){
	     Common.alert('Please enter a period.');
		  return false;
	    }
	}
	
	if(result=='A'){
	if ($("#period").val() == ''){
          Common.alert('Please enter a period.');
          return false;
    }
	if ($("#loccd").val() == ''){
		Common.alert('Please enter a CT No.');
        return false;
    }
	if ($("#itmcd").val() == ''){
		Common.alert('Please enter a Material.');
        return false;
    }
	if ($("#itmnm").val() == ''){
		Common.alert('Please enter a Material.');
        return false;
    }
	if ($("#maxqty").val() == ''){
		Common.alert('Please enter a Maxmum Qty.');
        return false;
    }
    if ($("#reordqty").val() == ''){
    	Common.alert('Please enter a Reorder Qty.');
        return false;
    }
  }   
	
    return true;
}

function fn_itempopList(d){
	
	if (d[0].item.itemcode != undefined && d[0].item.itemcode != "undefined" && d[0].item.itemcode != null){
		$("#itmcd").val(d[0].item.itemcode);
		$("#itmnm").val(d[0].item.itemname);
	}
	
	if (d[0].item.loccd != undefined && d[0].item.loccd != "undefined" && d[0].item.loccd != null){
        $("#loccd").val(d[0].item.loccd);
        $("#locnm").val(d[0].item.locdesc);
        
        if (d[0].item.locgb == '01' || d[0].item.locgb == '02' || d[0].item.locgb == '05'){
        	
        	$("#sftyqty").prop("disabled", false);
        }else{
        	$("#sftyqty").val(0);
        	$("#sftyqty").prop("disabled", true);
        }
    }
}


function checkHTML5Brower() {
    var isCompatible = false;
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        isCompatible = true;
    }
    return isCompatible;
}

function fn_detail(data){
	var period;
	var location;
	var itmcd;
	var rowList = [];
	var iCnt = 0;
	for (var i = 1 ; i <= data.length ; i++){
		Common.ajaxSync("GET" , "/logistics/replenishment/exceldata.do" , data[i-1] , function(data){
			
			if (data != null){
			rowList[iCnt] = {
		            period   : data.PERIOD,
		            locid    : data.LOCID,
		            loccd    : data.LOCCD,
                    locnm    : data.LOCNM,
                    itmcd    : data.ITMCD,
                    itmnm    : data.ITMNM,
                    maxqty   : data.MAXQTY,
                    reordqty : data.REORDQTY,
                    sftyqty  : data.SFTYQTY,
                    avrqty   : 0
		        }
				iCnt++;
			}
		});
	}

	AUIGrid.addRow(listGrid, rowList, "last");
}

function SearchListAjax() {
	   
    var url = "/logistics/replenishment/searchAutoCTList.do";
    var param = $('#searchForm').serializeJSON();
    
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
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

function f_multiCombos() {
    $(function() {
        $('#searchCtgry').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */ 
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Replenishment</li>
    <li>R.Mgmt Data</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>R.Mgmt Data(CT)</h2>
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
<!--  
                <tr>
                    <th scope="row">CT no</th>
                    <td >
                       <input type="text" class="w100p" id="searchCtNo" name="searchCtNo">
                    </td>
                    <th scope="row">Period<span style="color:red">*</span></th>
                    <td>
                        <input id="searchperiod" name="searchperiod" type="text" title="period" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
                    </td>
                </tr>
                <tr>
                     <th scope="row">Material Code</th>
                    <td>
                        <input type="text" class="w100p" id="searchMatCode" name="searchMatCode">
                    </td>
                    <th scope="row">type</th>
                    <td>
                        <select class="w100p" id="searchType" name="searchType"><option value=''>Choose One</option></select>
                    </td>
                </tr>
-->  
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
        <div id='filediv' style="display:none;"><input type="file" id="fileSelector" name="files" accept=".xlsx"></div>
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="re">Recalculate</a></p></li>
            <li><p class="btn_grid"><a id="add">Add</a></p></li>
            <li><p class="btn_grid"><a id="edit">Edit</a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:430px"></div>
        
        <div id="grid_wrap" class="mt10" style="display:none;"></div>
    </section><!-- search_result end -->
   <div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">Good Issue Posting Data</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
            <form id="popForm" name="popForm" method="POST">
            <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width:120px" />
                <col style="width:*" />
                <col style="width:120px" />
                <col style="width:*" />
                <col style="width:120px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Period</th>
                    <td ><input id="period" name="period" type="text" title="PERIOD" placeholder="MM/YYYY" class="j_date2" /></td>    
                    <th scope="row">CT No</th>
                    <td >
                         <input id="loccd" name="loccd" type="text" title="CtNo"  class="w100p"/>
                    </td>
                    <th scope="row">Meterial</th>
                    <td ><input id="itmcd" name="itmcd" type="hidden" title="Meterial"  class="w100p"/>
                         <input id="itmnm" name="itmnm" type="text" title="Meterial"  class="w100p"/>
                    </td>    
                </tr>
                <tr>
                    <th scope="row">Maximum Qty</th>
                    <td ><input id="maxqty"   name="maxqty" type="text"     title="Maximum Qty"  class="w100p numberAmt" /></td>    
                    <th scope="row">Reorder Qty</th>
                    <td ><input id="reordqty" name="reordqty" type="text"   title="Reorder Qty"  class="w100p numberAmt" /></td>
                    <th scope="row"></th>
                    <td ><input id="sftyqty"   name="sftyqty" type="hidden"   title="Safty Stock"  class="w100p numberAmt" />    </td>    
                </tr>
            </tbody>
            </table>
        
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="popsave">SAVE</a></p></li> 
            </ul>
            </form>
        
        </section>
    </div>
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>
