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
var resGrid;
var reqGrid;

var rescolumnLayout=[{dataField:    "rnum",headerText :"<spring:message code='log.head.rnum'/>"               ,width:120    ,height:30 ,visible:false},                         
                     {dataField: "locid",headerText :"<spring:message code='log.head.location'/>"              ,width:120    ,height:30 ,visible:false},                         
                     {dataField: "stkid",headerText :"<spring:message code='log.head.itemcd'/>"             ,width:120    ,height:30 ,visible:false},                        
                     {dataField: "stkcd",headerText :"<spring:message code='log.head.matcode'/>"            ,width:120    ,height:30,editable:false},                        
                     {dataField: "stknm",headerText :"<spring:message code='log.head.materialname'/>"             ,width:120    ,height:30,editable:false},                          
                     {dataField: "qty",headerText :"<spring:message code='log.head.availableqty'/>"       ,width:120    ,height:30, editable:false},                         
                     {dataField: "serialchck" ,headerText:    ""       ,width:120    ,height:30, editable:false},                         
                     {dataField: "typeid",headerText :"<spring:message code='log.head.typeid'/>"            ,width:120    ,height:30,visible:false},                         
                     {dataField: "typenm",headerText :"<spring:message code='log.head.type'/>"            ,width:120    ,height:30,editable:false},                          
                     {dataField: "cateid",headerText :"<spring:message code='log.head.cateid'/>"            ,width:120    ,height:30,visible:false},                         
                     {dataField: "catenm",headerText :"<spring:message code='log.head.category'/>"             ,width:120    ,height:30,editable:false},                         
                     {dataField: "uom",headerText :"<spring:message code='log.head.uom'/>"                  ,width:120    ,height:30, visible:false} 
                    ];
                    
var reqcolumnLayout;

var resop = {rowIdField : "rnum", showRowCheckColumn : true ,usePaging : true,useGroupingPanel : false , Editable:false};
var reqop = {usePaging : true,useGroupingPanel : false , Editable:true};

var uomlist = f_getTtype('42' , '');
var paramdata;


$(document).ready(function(){
    /**********************************
    * Header Setting
    ***********************************/
    doSysdate(0 , 'reqcrtdate');
    paramdata = { groupCode : '306' ,Codeval: 'US' , orderValue : 'CRT_DT' , likeValue:''};
    doGetComboData('/common/selectCodeList.do', paramdata, 'US','sttype', 'S' , 'transferTypeFunc');
    //paramdata = { brnch : '${SESSION_INFO.userBranchId}' , locgb:'01'}; // session 정보 등록 
   //2017-11-28 From Location : CDC , RDC, CDC & RDC 가 보일 수 있도록 처리 
    paramdata = {locgb:'010205', endlikeValue:$("#locationType").val() }; // session 정보 등록 
    doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '','tlocation', 'S' , 'tlocationFunc');
    doGetCombo('/common/selectCodeList.do', '11', '','catetype', 'M' , 'f_multiCombo'); 
    doGetCombo('/common/selectCodeList.do', '15', '', 'cType', 'M','f_multiCombo');
    
    $("#cancelTr").hide();
    /**********************************
     * Header Setting End
     ***********************************/
    
     reqcolumnLayout=[{dataField:    "itmid",headerText :"<spring:message code='log.head.itemid'/>"          ,width:120    ,height:30 , visible:false},                          
                      {dataField: "itmcd",headerText :"<spring:message code='log.head.matcode'/>"         ,width:120    ,height:30 , editable:false},                         
                      {dataField: "itmname",headerText :"<spring:message code='log.head.materialname'/>"        ,width:120    ,height:30 , editable:false},                       
                      {dataField: "aqty",headerText :"<spring:message code='log.head.availableqty'/>"     ,width:120    ,height:30 , editable:false},                         
                      {dataField: "rqty",headerText :"<spring:message code='log.head.requestqty'/>"       ,width:120    ,height:30},                          
                      {dataField: "uom",headerText :"<spring:message code='log.head.uom'/>"               ,width:120    ,height:30, editable:false 
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
    
    AUIGrid.bind(resGrid, "addRow", function(event){});
    AUIGrid.bind(reqGrid, "addRow", function(event){});
    
    AUIGrid.bind(resGrid, "cellEditBegin", function (event){});
    AUIGrid.bind(reqGrid, "cellEditBegin", function (event){
    	
    });
    
    AUIGrid.bind(resGrid, "cellEditEnd", function (event){});
    AUIGrid.bind(reqGrid, "cellEditEnd", function (event){
    	
    	if(event.dataField == "itmcd"){
    		$("#svalue").val(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd"));
    		$("#sUrl").val("/logistics/material/materialcdsearch.do");
    		Common.searchpopupWin("popupForm", "/common/searchPopList.do","stocklist");
    	}
    	
    	if(event.dataField == "rqty"){
            if(AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty") > AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty")){
            	Common.alert('The requested quantity is up to '+AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty")+'.');
            	AUIGrid.setCellValue(reqGrid, event.rowIndex, "rqty", 0);
            	return false;
            }
        }
    });
    
    AUIGrid.bind(resGrid, "cellClick", function( event ) {});
    AUIGrid.bind(reqGrid, "cellClick", function( event ) {});
    
    AUIGrid.bind(resGrid, "cellDoubleClick", function(event){});
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event){});
    
    AUIGrid.bind(resGrid, "ready", function(event) {});
    AUIGrid.bind(reqGrid, "ready", function(event) {});
    
});
function tlocationFunc(){
	doGetComboCodeId('/common/selectStockLocationList.do', { locgb : '02' , cdcloc:$("#tlocation").val(), endlikeValue:$("#locationType").val()}, '','flocation', 'S' , '');
}

function transferTypeFunc(){
	paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val(), codeIn:'US03,US93'};
    doGetComboData('/common/selectCodeList.do', paramdata, 'US03','smtype', 'S' , '');
}
//btn clickevent
$(function(){
    $('#search').click(function() {
    	//if (f_validatation('search')){
    		$("#slocation").val($("#tlocation").val());
    	    SearchListAjax();
    	//}
    });
    $('#clear').click(function() {
    });
    $('#reqadd').click(function() {
    	f_AddRow();
    });
    $('#reqdel').click(function(){
    	AUIGrid.removeRow(reqGrid, "selectedIndex");
        AUIGrid.removeSoftRows(reqGrid);
    });
    $('#list').click(function(){
    	document.searchForm.action = '/logistics/stocktransfer/StocktransferList.do';
        document.searchForm.submit();
    });
    $('#save').click(function() {
    	if (f_validatation('save')){
	    	var dat = GridCommon.getEditData(reqGrid);
	    	dat.form = $("#headForm").serializeJSON();
	    	
	    	Common.ajax("POST", "/logistics/stocktransfer/StocktransferAdd.do", dat, function(result) {
// 	    		Common.alert(result.message,locationList);
	    		Common.alert(""+result.message+"</br> Created : "+result.data, locationList);
	            AUIGrid.resetUpdatedItems(reqGrid, "all");
	        },  function(jqXHR, textStatus, errorThrown) {
	            try {
	            } catch (e) {
	            }
	
	            Common.alert("Fail : " + jqXHR.responseJSON.message);
	        });
    	}
    });
    $("#sttype").change(function(){
    	paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val(), codeIn:'US03,US93'};
        doGetComboData('/common/selectCodeList.do', paramdata, 'US03','smtype', 'S' , '');
    });
    $("#smtype").change(function(){
        
    });
    $("#rightbtn").click(function(){
        checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);
        var bool = true;
        if (checkedItems.length > 0){
	        var rowPos = "first";
	        var item = new Object();
	        var rowList = [];
	        
	        for (var i = 0 ; i < checkedItems.length ; i++){
	        	
	        	rowList[i] = {
                            itmid : checkedItems[i].stkid,
                            itmcd : checkedItems[i].stkcd,
                            itmname : checkedItems[i].stknm,
                            aqty : checkedItems[i].qty,
                            uom : checkedItems[i].uom
                        }
	        	
	            AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
	        }
	        
	        AUIGrid.addRow(reqGrid, rowList, rowPos);
        }
    });
    $("#tlocation").change(function(){
    	
    	tlocationFunc();
    });
});

function fn_changeLocation() {
	 paramdata = {locgb:'010205', endlikeValue:$("#locationType").val() }; // session 정보 등록 
	 doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '','tlocation', 'S' , 'tlocationFunc');
} 
function locationList(){
	$('#list').click();
}
function f_validatation(v){
	if ($("#sttype").val() == null || $("#sttype").val() == undefined || $("#sttype").val() == ""){
        Common.alert("Please select one of Transaction Type.");
        return false;
    }
    if ($("#smtype").val() == null || $("#smtype").val() == undefined || $("#smtype").val() == ""){
        Common.alert("Please select one of Transfer Type Detail.");
        return false;
    }
    if ($("#tlocation").val() == null || $("#tlocation").val() == undefined || $("#tlocation").val() == ""){
        Common.alert("Please select one of To Location.");
        return false;
    }
    if ($("#flocation").val() == null || $("#flocation").val() == undefined || $("#flocation").val() == ""){
        Common.alert("Please select one of From Location.");
        return false;
    }
    if (v == 'save'){
    	if ($("#reqcrtdate").val() == null || $("#reqcrtdate").val() == undefined || $("#reqcrtdate").val() == ""){
    		Common.alert("Please enter Document Date.");
    		return false;
    	}
    }
    return true;
    
}

function SearchListAjax() {
    
    var url = "/logistics/stocktransfer/stockTransferTolocationItemList.do";
    var param = $('#searchForm').serialize();
    
    Common.ajax("GET" , url , param , function(result){
    	AUIGrid.setGridData(resGrid, result.data);
    });
    /*Common.showLoader();
    $.ajax({
        type : "GET",
        url : url +"?"+ param,
        //url : "/stock/StockList.do",
        //data : param,
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var gridData = data;
            

            AUIGrid.setGridData(resGrid, gridData.data);
        },
        error : function(jqXHR, textStatus, errorThrown) {
        	Common.setMsg("Fail ........ ");
        },
        complete : function() {
        	Common.removeLoader();
        }
    });*/
}

function addRow() {
    var rowPos = "first";
       
    var item = new Object();
       
    AUIGrid.addRow(reqGrid, item, rowPos);
}

function fn_itempopList(data){
	
    var rowPos = "first";
    var rowList = [];
   	
    AUIGrid.removeRow(reqGrid, "selectedIndex");
   	AUIGrid.removeSoftRows(reqGrid);
   	for (var i = 0 ; i < data.length ; i++){
    	rowList[i] = {
	    	itmid : data[i].item.itemid,
	    	itmcd : data[i].item.itemcode,
	    	itmname : data[i].item.itemname
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
               alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
           },
           complete: function(){
           }
       });
    
    return rData;
}
function f_AddRow() {
    var rowPos = "first";
    
    var item = new Object();
        
    AUIGrid.addRow(reqGrid, item, rowPos);
}

function f_multiCombo() {
    $(function() {
    	$('#catetype').change(function() {

        }).multipleSelect({
            selectAll : true
        });//.multipleSelect("checkAll");
        $('#cType').change(function() {

        }).multipleSelect({
            selectAll : true
        });//.multipleSelect("checkAll");
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>STO</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="headForm" name="headForm" method="post">
<input type='hidden' id='pridic' name='pridic' value='M'/>
<input type='hidden' id='headtitle' name='headtitle' value='STO'/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">STO Number</th>
    <td colspan="3"><input id="reqno" name="reqno" type="text" title="" placeholder="Automatic billing" class="readonly w100p" readonly="readonly" /></td>
    <th scope="row">Document Date</th>
    <td colspan="3"><input id="reqcrtdate" name="reqcrtdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr>
    <th scope="row">Transfer Type</th>
    <td colspan="3">
    <select class="w100p" id="sttype" name="sttype"></select>
    </td>
    <th scope="row">Transfer Type Detail</th>
    <td colspan="3">
    <select class="w100p" id="smtype" name="smtype"><option>Transfer Type Selected</option></select>
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
    <th scope="row">From Location</th>
    <td colspan="2">
    <select class="w100p" id="tlocation" name="tlocation"></select>
    </td>
    <th scope="row">To Location</th>
    <td colspan="2">
    <select class="w100p" id="flocation" name="flocation"></select>
    </td>
</tr>
<tr>
    
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="7"><input id="dochdertxt" name="dochdertxt" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<!-- <tr id="cancelTr">
    <th scope="row">Defect Reason</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">CT/Cody</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr> -->
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Item Info</h3>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue2"><a id="search"><spring:message code='sys.btn.search' /></a></p></li>
</c:if>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" >
<input type="hidden" id="slocation" name="slocation">

<!-- menu setting -->
<input type="hidden" name="CURRENT_MENU_CODE" value="${param.CURRENT_MENU_CODE}"/>
<input type="hidden" name="CURRENT_MENU_FULL_PATH_NAME" value="${param.CURRENT_MENU_FULL_PATH_NAME}"/>
<!-- menu setting -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:100px" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td colspan="3">
    <select class="w100p" id="cType" name="cType"></select>
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
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
<!--     <li><p class="btn_grid"><a id="reqadd">ADD</a></p></li> -->
    <li><p class="btn_grid"><a id="reqdel">DELETE</a></p></li>
</c:if>
</ul>
</aside><!-- title_line end -->

<div class="border_box" style="height:340px;"><!-- border_box start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="req_grid_wrap" ></div>
</article><!-- grid_wrap end -->

<ul class="btns">
    <li><a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
<%--     <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li> --%>
</ul>

</div><!-- border_box end -->

</div><!-- 50% end -->

</div><!-- divine_auto end -->

<ul class="center_btns mt20">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue2 big"><a id="list">List</a></p></li>&nbsp;&nbsp;<li><p class="btn_blue2 big"><a id="save">Save</a></p></li>
</c:if>
</ul>

</section><!-- search_result end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>
