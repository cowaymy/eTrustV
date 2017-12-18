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

var rescolumnLayout=[{dataField:    "locid",headerText :"<spring:message code='log.head.location'/>"              ,width:120    ,height:30 ,visible:false},                         
                     {dataField: "stkid",headerText :"<spring:message code='log.head.itemcd'/>"             ,width:120    ,height:30 ,visible:false},                        
                     {dataField: "stkcd",headerText :"<spring:message code='log.head.itemcd'/>"             ,width:120    ,height:30,editable:false},                        
                     {dataField: "stknm",headerText :"<spring:message code='log.head.itemname'/>"             ,width:120    ,height:30,editable:false},                          
                     {dataField: "typeid",headerText :"<spring:message code='log.head.typeid'/>"            ,width:120    ,height:30,visible:false},                         
                     {dataField: "typenm",headerText :"<spring:message code='log.head.typename'/>"            ,width:120    ,height:30,editable:false},                          
                     {dataField: "cateid",headerText :"<spring:message code='log.head.cateid'/>"            ,width:120    ,height:30,visible:false},                         
                     {dataField: "catenm",headerText :"<spring:message code='log.head.category'/>"             ,width:120    ,height:30,editable:false},                         
                     {dataField: "qty",headerText :"<spring:message code='log.head.availableqty'/>"       ,width:120    ,height:30, editable:false} 
                    ];
var reqcolumnLayout;

// var resop = {showStateColumn : true , usePaging : true,useGroupingPanel : false , Editable:false};
// var reqop = {showStateColumn : true , usePaging : true,useGroupingPanel : false , Editable:true};
var resop = {showStateColumn : false , usePaging : true,useGroupingPanel : false , Editable:false};
var reqop = {showStateColumn : false , usePaging : true,useGroupingPanel : false , Editable:false};

var uomlist = f_getTtype('42' , '');
var paramdata;
$(document).ready(function(){
    /**********************************
    * Header Setting
    ***********************************/
    
    var hdData;
    
    mainSearchFunc();
    
    $("#cancelTr").hide();
    /**********************************
     * Header Setting End
     ***********************************/
    
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
    	if (event.dataField == "qty"){
    		var data = "toloc="+$("#tlocation").val()+"&itmcd="+AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd");
            Common.ajax("Get", "/logistics/stockMovement/StockMovementItemDeliveryQty.do", data, function(result) {
                if (result.iqty > 0){
                    
                }else{
                    Common.alert('No input data field');
                }
            });
    	}
    });
    
    AUIGrid.bind(resGrid, "cellClick", function( event ) {});
    AUIGrid.bind(reqGrid, "cellClick", function( event ) {});
    
    AUIGrid.bind(resGrid, "cellDoubleClick", function(event){});
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event){});
    
    AUIGrid.bind(resGrid, "ready", function(event) {});
    AUIGrid.bind(reqGrid, "ready", function(event) {});
    
    AUIGrid.bind(reqGrid, "cellEditBegin", function (event){
    	
    	if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "delyno") != null && AUIGrid.getCellValue(reqGrid, event.rowIndex, "delyno") != ""){
            Common.alert('You can not create a delivery note for the selected item.');
            return false;
        }
        /*if (event.dataField != "delyqty"){
            return false;
        }else{
            if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "delvno") != null && AUIGrid.getCellValue(reqGrid, event.rowIndex, "delvno") != ""){
                Common.alert('You can not create a delivery note for the selected item.');
                return false;
            }
        }*/
    });
    
});

//btn clickevent
$(function(){
    $('#search').click(function() {
    	if (f_validatation('search')){
    	    $("#slocation").val($("#tlocation").val());
    	}
    });
    $('#clear').click(function() {
    });
    $('#list').click(function() {
    	document.listForm.action = '/logistics/stockMovement/StockMovementList.do';
        document.listForm.submit();
    });
//     $('#delivery').click(function() {
//     	$("#smtype").attr("disabled" , false);
//     	var dat = GridCommon.getEditData(reqGrid);
//     	dat.form = $("#headForm").serializeJSON();
//     	Common.ajax("POST", "/logistics/stockMovement/StockMovementDelivery.do", dat, function(result) {
//             Common.alert(result.message);
//             AUIGrid.resetUpdatedItems(reqGrid, "all");
            
//         },  function(jqXHR, textStatus, errorThrown) {
//             try {
//             } catch (e) {
//             }

//             Common.alert("Fail : " + jqXHR.responseJSON.message);
//         });
//     	$("#smtype").attr("disabled" , true);
//     });
    $('#reqadd').click(function() {
    	f_AddRow();
    });
    $('#reqdel').click(function(){
    	
    	checkedItems = AUIGrid.getCheckedRowItems(reqGrid);
    	
        if (checkedItems.length > 0){
            for (var i = 0 ; i < checkedItems.length ; i++){
            	if (AUIGrid.getCellValue(reqGrid, checkedItems[i].rowIndex, "delyno") != null && AUIGrid.getCellValue(reqGrid, checkedItems[i].rowIndex, "delyno") !=""){
            		
            	}else{
            		   AUIGrid.removeRow(reqGrid, checkedItems[i].rowIndex);
            	}
            }
            //var removedRows = AUIGrid.getRemovedItems(myGridID, true);
            AUIGrid.removeSoftRows(reqGrid);
            
            var dat = GridCommon.getEditData(reqGrid);
            
            
            dat.form = $("#headForm").serializeJSON();
            Common.ajax("POST", "/logistics/stockMovement/StockMovementReqItemDelete.do", dat, function(result) {
                Common.alert(result.message);
                AUIGrid.resetUpdatedItems(reqGrid, "all");
                
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }
      
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
        }		  	
    });
    $('#reqsave').click(function() {
    	
    	var dat = GridCommon.getEditData(reqGrid);
    	dat.form = $("#headForm").serializeJSON();
    	Common.ajax("POST", "/logistics/stockMovement/StockMovementReqAdd.do", dat, function(result) {
    		
    		Common.alert(result.message.message);
    		AUIGrid.setGridData(reqGrid, result.data);
    		
        },  function(jqXHR, textStatus, errorThrown) {
            try {
            } catch (e) {
            }

            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    	
    });
    $("#sttype").change(function(){
    	paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
    });
    $("#smtype").change(function(){
        
    });
    $("#rightbtn").click(function(){
    	checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);
    	if (checkedItems.length > 0){
            var rowPos = "first";
            var item = new Object();
            var rowList = [];
            
            for (var i = 0 ; i < checkedItems.length ; i++){
                rowList[i] = {
                    itmid : checkedItems[i].stkid,
                    itmcd : checkedItems[i].stkcd,
                    itmname : checkedItems[i].stknm
                }
            }
            
            AUIGrid.addRow(reqGrid, rowList, rowPos);
        }
    });
});

function mainSearchFunc(){
	var param = "rStcode=${rStcode }";
	$.ajax({
        type : "GET",
        url : "/logistics/stockMovement/StockMovementDataDetail.do",
        data : param,
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        async:false,
        success : function(data) {
            hdData = data.hValue;
            headFunc(data.hValue);
            requestList(data.iValue);
            reciveList(data.itemto)
        },
        error: function(jqXHR, textStatus, errorThrown){
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        },
        complete: function(){
        }
    });
}
function headFunc(data){
	
	$("#reqno").val(data.reqno);
	$("#reqcrtdate").val(data.reqcrtdt);
	
	paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};
    doGetComboData('/common/selectCodeList.do', paramdata, data.trntype ,'sttype', 'S' , '');
    paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:data.trntype};
    doGetComboData('/common/selectCodeList.do', paramdata, data.trndtl,'smtype', 'S' , '');
    
    doGetCombo('/common/selectStockLocationList.do', '', data.rcivcr,'tlocation', 'S' , '');
    $("#tlocation").attr("disabled",true);
    doGetCombo('/common/selectStockLocationList.do', '', data.reqcr,'flocation', 'S' , '');
    
	$("#dochdertxt").val(data.doctxt);
	//$("#dochdertxt").prop("readonly","readonly");
	
	//$("#reqcrtdate").attr("disabled",true);
	$("#sttype").attr("disabled",true);
	$("#smtype").attr("disabled",true);
	$("#flocation").attr("disabled",true);
	$("#reqcrtdate").attr("disabled",true);
	$("#dochdertxt").attr("disabled",true);
	//$("#dochdertxt").prop("class","readonly w100p");
	$("#pridic").val(data.prifr);
	
	//$("#reqcrtdate").prop("class","readonly w100p");//class="j_date"
}

function requestList(data){
	 reqcolumnLayout=[{dataField:   "resnoitm",headerText :"<spring:message code='log.head.item_no'/>"          ,width:120    ,height:30 , visible:false},                          
	                  {dataField:    "delyno",headerText :"<spring:message code='log.head.delyno'/>"          ,width:120    ,height:30 , visible:false},                         
	                  {dataField:    "itmid",headerText :"<spring:message code='log.head.itemid'/>"          ,width:120    ,height:30 , visible:false},                          
	                  {dataField:    "itmcd",headerText :"<spring:message code='log.head.itemcd'/>"          ,width:120    ,height:30 , editable:false},                         
	                  {dataField:    "itmname",headerText :"<spring:message code='log.head.itemname'/>"        ,width:120    ,height:30 , editable:false},                       
	                  {dataField:    "rqty",headerText :"<spring:message code='log.head.requestqty'/>"       ,width:120    ,height:30,editable:false},                       
	                  {dataField:    "delyqty",headerText :"<spring:message code='log.head.deliveryqty'/>"      ,width:120    ,height:30 , editable:false},                          
	                  {dataField:    "uom",headerText :"<spring:message code='log.head.uom'/>"               ,width:120    ,height:30,editable:false 
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
   
    reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout,"", reqop);
	
    AUIGrid.setGridData(reqGrid, data);
}


function reciveList(data){
	resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout,"", resop);
	AUIGrid.setGridData(resGrid, data);
}

function SearchListAjax() {

    var url = "/logistics/organization/MaintainmovementList.do";
    var param = $('#searchForm').serialize();
    Common.ajax("GET" , url , param , function(data){
    	
    	
        //AUIGrid.setGridData(myGridID, data.data);
    });
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

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>View - Stock Movement</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>SMO</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="list"><span class="list"></span>List</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="headForm" name="headForm" method="post">
<input type='hidden' id='pridic' name='pridic' value='M'/>
<input type='hidden' id='headtitle' name='headtitle' value='STO'/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">SMO Number</th>
    <td><input id="reqno" name="reqno" type="text" title="" placeholder="Automatic billing" class="readonly w100p" readonly="readonly" /></td>
    <th scope="row">Document Date</th>
    <td><input id="reqcrtdate" name="reqcrtdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr>
    <th scope="row">Movement Type</th>
    <td>
    <select class="w100p" id="sttype" name="sttype"></select>
    </td>
    <th scope="row">Movement Type Detail</th>
    <td>
    <select class="w100p" id="smtype" name="smtype"><option>Movement Type Selected</option></select>
    </td>
</tr>
<tr>
    <th scope="row">To Location</th>
    <td colspan="3">
    <select class="w100p" id="tlocation" name="tlocation"></select>
    </td>
</tr>
<tr>
    <th scope="row">From Location</th>
    <td colspan="3">
    <select class="w100p" id="flocation" name="flocation"></select>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><input id="dochdertxt" name="dochdertxt" type="text" title="" placeholder="" class="w100p" /></td>
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

<!-- <aside class="title_line">title_line start -->
<!-- <h3>Item Info</h3> -->
<!-- </aside>title_line end -->

<!-- <section class="search_table">search_table start -->
<!-- <form id="searchFrom" method="post"> -->
<!-- <input type="hidden" id="slocation"> -->

<!-- <table class="type1">table start -->
<!-- <caption>table</caption> -->
<!-- <colgroup> -->
<!--     <col style="width:140px" /> -->
<!--     <col style="width:*" /> -->
<!--     <col style="width:100px" /> -->
<!--     <col style="width:*" /> -->
<!--     <col style="width:90px" /> -->
<!-- </colgroup> -->
<!-- <tbody> -->
<!-- <tr> -->
<!--     <th scope="row">Category</th> -->
<!--     <td> -->
<!--         <select class="w100p" id="catetype" name="catetype"></select> -->
<!--     </td> -->
<!--     <th scope="row">Type</th> -->
<!--     <td > -->
<!--     <select class="w100p" id="cType" name="cType"></select> -->
<!--     </td> -->
<!--     <td> -->
<!--     <ul class="left_btns"> -->
<!--         <li><p class="btn_blue2"><a id="search">Search</a></p></li> -->
<!--     </ul> -->
<!--     </td> -->
<!-- </tr> -->
<!-- </tbody> -->
<!-- </table>table end -->

<!-- </form> -->
<!-- </section>search_table end -->

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
</aside><!-- title_line end -->

<div class="border_box" style="height:340px;">


<article class="grid_wrap">
    <div id="req_grid_wrap" ></div>
</article>


</div>

</div><!-- 50% end -->

</div><!-- divine_auto end -->

<!-- <ul class="center_btns mt20"> -->
<!--     <li><p class="btn_blue2 big"><a id="save">Save</a></p></li> -->
<!-- </ul> -->

</section><!-- search_result end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
<form id="listForm" name="listForm" method="POST">
<input type="hidden" id="streq"     name="streq"     value="${searchVal.streq    }"/>
<input type="hidden" id="sttype"    name="sttype"    value="${searchVal.sttype   }"/>
<input type="hidden" id="smtype"    name="smtype"    value="${searchVal.smtype   }"/>
<input type="hidden" id="tlocation" name="tlocation" value="${searchVal.tlocation}"/>
<input type="hidden" id="flocation" name="flocation" value="${searchVal.flocation}"/>
<input type="hidden" id="crtsdt"    name="crtsdt"    value="${searchVal.crtsdt   }"/>
<input type="hidden" id="crtedt"    name="crtedt"    value="${searchVal.crtedt   }"/>
<input type="hidden" id="reqsdt"    name="reqsdt"    value="${searchVal.reqsdt   }"/>
<input type="hidden" id="reqedt"    name="reqedt"    value="${searchVal.reqedt   }"/>
<input type="hidden" id="sam"       name="sam"       value="${searchVal.sam      }"/>
<input type="hidden" id="sstatus"   name="sstatus"   value="${searchVal.sstatus  }"/>

</form>
</section>
