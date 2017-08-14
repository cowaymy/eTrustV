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
                     {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 , visible:false},
                     {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                     {dataField:"delyqty"      ,headerText:"Delivery Qty"                ,width:120    ,height:30 },
                     {dataField:"rciptqty"     ,headerText:"Good ReceiptQty"             ,width:120    ,height:30 , editalble:true},
                     {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                     {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                },
                     {dataField:"reqstno"      ,headerText:"Stock Transfer Request"      ,width:120    ,height:30}
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

var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var uomlist = f_getTtype('42' , '');
var paramdata;
$(document).ready(function(){
	/**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};
    doGetComboData('/common/selectCodeList.do', paramdata, '','sttype', 'S' , 'f_change');
    doGetCombo('/logistics/stocktransfer/selectStockTransferNo.do', '{groupCode:delivery}' , '','seldelno', 'S' , '');
    doGetCombo('/common/selectStockLocationList.do', '', '','tlocation', 'S' , '');
    doGetCombo('/common/selectStockLocationList.do', '', '','flocation', 'S' , 'SearchListAjax');
    doDefCombo(amdata, '' ,'sam', 'S', '');
    
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
        	console.log(rown);
        	for (var i = 0 ; i < rown.length ; i++){
        		AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
        	}
        }
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function( event ) {
        var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
        
        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
        	var rown = AUIGrid.getRowIndexesByValue(listGrid, "delyno" , delno);
            console.log(rown);
            for (var i = 0 ; i < rown.length ; i++){
                AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
            }
        }else{
        	AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
        }
    });
    
});
function f_change(){
	$("#sttype").change();
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
        	$("#gropenwindow").show();
        }
    });
});

function SearchListAjax() {
   
    var url = "/logistics/stocktransfer/StocktransferSearchDeliveryList.do";
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
function grFunc(){
	var data = {};
	var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
	var check     = AUIGrid.getCheckedRowItems(listGrid);
	
	data.check   = check;
	data.checked = check;
	data.form    = $("#grForm").serializeJSON();
	console.log(data);
	Common.ajax("POST", "/logistics/stocktransfer/StocktransferGoodIssue.do", data, function(result) {
        
        Common.alert(result.message.message);
//         AUIGrid.setGridData(listGrid, result.data);
        $("#giptdate").val("");
        $("#gipfdate").val("");
        $("#doctext" ).val("");
        $("#gropenwindow").hide();
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
    <li>Stock Transfer Good Issue List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Stock Transfer Good Issue List</h2>
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
        <input type="hidden" name="gtype"   id="gtype"  value="receipt" /> 
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
                    <th scope="row">To Location</th>
                    <td>
                        <select class="w100p" id="tlocation" name="tlocation"></select>
                    </td>
                    <th scope="row">From Location</th>
                    <td >
                        <select class="w100p" id="flocation" name="flocation"></select>
                    </td>
                    <th scope="row">Auto / Manual</th>
                    <td>
                        <select class="w100p" id="sam" name="sam"></select>
                    </td>                
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
            <li><p class="btn_grid"><a id="gissue"><span class="search"></span>Good Receipt</a></p></li>                        
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:350px"></div>

    </section><!-- search_result end -->
    
    <div class="popup_wrap" id="gropenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
		    <h1>Good Receipt Posting Data</h1>
		    <ul class="right_opt">
		        <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
		    </ul>
		</header><!-- pop_header end -->
		
		<section class="pop_body"><!-- pop_body start -->
		    <form id="grForm" name="grForm" method="POST">
		    <input type="hidden" name="gtype" id="gtype" value="GR"> 
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
                    <th scope="row">GR Proof Date</th>
                    <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                </tr>
                <tr>    
                    <th scope="row">Header Text</th>
		            <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
		        </tr>
		    </tbody>
		    </table>
		
		    <ul class="center_btns">
		        <li><p class="btn_blue2 big"><a onclick="javascript:grFunc();">SAVE</a></p></li> 
		    </ul>
		    </form>
		
		</section>
    </div>
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>

