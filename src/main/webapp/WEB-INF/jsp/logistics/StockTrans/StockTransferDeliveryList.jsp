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
                     {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 },
                     {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                     {dataField:"delyqty"      ,headerText:"Delivered Qty"               ,width:120    ,height:30 },
                     {dataField:"rciptqty"     ,headerText:"Good Receipted Qty"          ,width:120    ,height:30 , editalble:true},
                     {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                     {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                },
                     {dataField:"reqstno"      ,headerText:"STO"                         ,width:120    ,height:30},
                     {dataField:"gicmplt"      ,headerText:"GI COMPLET"                  ,width:120    ,height:30 , visible:true},
                     {dataField:"grcmplt"      ,headerText:"GR COMPLET"                  ,width:120    ,height:30 , visible:true}
                     ];
                     
var resop = {
		rowIdField : "rnum",			
		editable : true,
		fixedColumnCount : 6,
		groupingFields : ["delyno"],
        displayTreeOpen : true,
        showRowCheckColumn : true ,
        enableCellMerge : true,
        showStateColumn : false,
        showBranchOnGrouping : false
        };

var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var uomlist = f_getTtype('42' , '');
var paramdata;
$(document).ready(function(){
	
	/**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CODE_ID' , likeValue:'US'};
    doGetComboData('/common/selectCodeList.do', paramdata, ('${searchVal.sttype}'==''?'US':'${searchVal.sttype}'),'sttype', 'S' , 'f_change');
    doGetComboData('/logistics/stocktransfer/selectStockTransferNo.do', '{groupCode:delivery}' , '','seldelno', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','tlocation', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','flocation', 'S' , 'SearchListAjax');
    //doDefCombo(amdata, '' ,'sam', 'S', '');
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    //listGrid = GridCommon.createAUIGrid("#main_grid_wrap", rescolumnLayout,"", resop);
    
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {});
    
    AUIGrid.bind(listGrid, "cellEditBegin", function (event){
    	
    	if (event.dataField != "delyqty"){
    		return false;
    	}else{
    		if (AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno") != null && AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno") != ""){
    			Common.alert('You can not create a delivery note for the selected item.');
    			return false;
    		}
    	}
    });
    
    AUIGrid.bind(listGrid, "cellEditEnd", function (event){
        
        if (event.dataField != "delyqty"){
            return false;
        }else{
        	var del = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyqty");
        	if (del > 0){
	        	if (Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstqty")) < Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "delyqty"))){
	        		Common.alert('Delivery Qty can not be greater than Request Qty.');
	        		//AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstqty")
	        		AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
	        	}else{
	        		AUIGrid.addCheckedRowsByIds(listGrid, event.item.rnum);
	        	}
        	}else{
        		AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
        		AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);        		
        	}
        }
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
//      	$("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
//      	$("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
//     	document.searchForm.action = '/logistics/stocktransfer/StocktransferView.do';
//     	document.searchForm.submit();
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
    AUIGrid.bind(listGrid, "rowCheckClick", function( event ) {
        
        var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
        
        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
        	AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
        }else{
        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
        	
        	for (var i = 0 ; i < rown.length ; i++){
        		AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
        	}
        }
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function( event ) {
        var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
        
        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
            
            for (var i = 0 ; i < rown.length ; i++){
                AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
            }
        }else{
        	AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
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
    $("#sttype").change(function(){
        paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
    });
    $('#delivery').click(function(){
    	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
    	if(checkedItems.length <= 0) {
    		return false;
    	}else{
	    	var data = {};
	    	data.checked = checkedItems; 
	    	Common.ajax("POST", "/logistics/stocktransfer/StocktransferReqDelivery.do", data, function(result) {
	            Common.alert(result.message);
	            AUIGrid.resetUpdatedItems(listGrid, "all");            
	        },  function(jqXHR, textStatus, errorThrown) {
	            try {
	            } catch (e) {
	            }  
	            Common.alert("Fail : " + jqXHR.responseJSON.message);
	        });
	    	for (var i = 0 ; i < checkedItems.length ; i++){
	    		AUIGrid.addUncheckedRowsByIds(listGrid, checkedItems[i].rnum);
	    	}
    	}
    });
    $("#gissue").click(function(){
    	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
        if(checkedItems.length <= 0) {
        	Common.alert('No data selected.');
            return false;
        }else{
        	for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].gicmplt == 'Y'){
                    Common.alert('Already processed.');
                    return false;
                    break;
                }
            }
        	document.giForm.gtype.value="GI";
            $("#dataTitle").text("Good Issue Posting Data");
            doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
        	$("#giopenwindow").show();
        }
    });
    $("#gcissue").click(function(){
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
        	document.giForm.gtype.value="RC";
            $("#dataTitle").text("Issue Cancel Posting Data");
            doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
            $("#giopenwindow").show();
        }
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
    
    var url = "/logistics/stocktransfer/StocktransferSearchDeliveryList.do";
    var param = $('#searchForm').serializeJSON();
    
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
function giFunc(){
	var data = {};
	var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
	var check     = AUIGrid.getCheckedRowItems(listGrid);
	
	data.check   = check;
	data.checked = check;
	data.form    = $("#giForm").serializeJSON();
	
	Common.ajax("POST", "/logistics/stocktransfer/StocktransferGoodIssue.do", data, function(result) {
        
        Common.alert(result.message.message);
//         AUIGrid.setGridData(listGrid, result.data);
        $("#giptdate").val("");
        $("#gipfdate").val("");
        $("#doctext" ).val("");
        $("#giopenwindow").hide();
        $('#search').click();

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }

        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Stock Transfer Delivery List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Stock Transfer Delivery List</h2>
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
        <input type="hidden" name="gtype"   id="gtype"  value="gissue" />
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
                        <select class="w100p" id="seldelno" name="seldelno"></select>
                    </td>
                    <th scope="row">Transfer Type</th>
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
                        <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                    </td>
                    <th scope="row">To Location</th>
                    <td >
                        <input type="hidden"  id="flocation" name="flocation">
                        <input type="text" class="w100p" id="flocationnm" name="flocationnm">
                    </td>
                    <td colspan="2">&nbsp;</td>                
                </tr>
                
                <tr>
                    <th scope="row">Delivery Date</th>
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
                        <p><input id="reqsdt" name="reqsdt" type="text" title="Create start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="Create End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
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
            <li><p class="btn_grid"><a id="gissue"><span class="search"></span>Good Issue</a></p></li>
            <li><p class="btn_grid"><a id="gcissue"><span class="search"></span>Issue Cancel</a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:430px"></div>

    </section><!-- search_result end -->
    
    <div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
		    <h1 id="dataTitle">Good Issue Posting Data</h1>
		    <ul class="right_opt">
		        <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
		    </ul>
		</header><!-- pop_header end -->
		
		<section class="pop_body"><!-- pop_body start -->
		    <form id="giForm" name="giForm" method="POST">
		    <input type="hidden" name="gtype" id="gtype" value="GI">
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
		            <th scope="row">GI Posting Date</th>
                    <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                    <th scope="row">GI Doc Date</th>
                    <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                </tr>
                <tr>    
                    <th scope="row">Header Text</th>
		            <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
		        </tr>
		    </tbody>
		    </table>
		
		    <ul class="center_btns">
		        <li><p class="btn_blue2 big"><a onclick="javascript:giFunc();">SAVE</a></p></li> 
		    </ul>
		    </form>
		
		</section>
    </div>

</section>

