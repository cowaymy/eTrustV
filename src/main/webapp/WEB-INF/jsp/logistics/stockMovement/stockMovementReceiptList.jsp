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
var serialGrid;

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
                     {dataField:"delyqty"      ,headerText:"Delivered Qty"                ,width:120    ,height:30 },
                     {dataField:"rciptqty"     ,headerText:"Good Receipted Qty"             ,width:120    ,height:30 , editalble:true},
                     {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                     {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                },
                     {dataField:"reqstno"      ,headerText:"Stock Movement Request"      ,width:120    ,height:30},
                     //{dataField:"grcmplt"      ,headerText:"GR COMPLET"                  ,width:120    ,height:30 , visible:false}
                     {dataField:"grcmplt"      ,headerText:"GR COMPLET"                  ,width:120    ,height:30 }
                     ];
                     
                     
var serialcolumnLayout =[
                         {dataField:"delvryNo"           ,headerText:"Delivery No"      ,width:"20%"    ,height:30   ,cellMerge : true            },
                         {dataField:"itmCode"            ,headerText:"Material Code"      ,width:"15%"    ,height:30   ,cellMerge : true            },
                         {dataField:"itmName"            ,headerText:"Material Name"      ,width:"30%"    ,height:30   ,cellMerge : true            },
                         {dataField:"pdelvryNoItm"      ,headerText:"Delivery No. Item"      ,width:120    ,height:30   , visible:false           },
                         {dataField:"ttype"                ,headerText:"Transaction Type"      ,width:120    ,height:30   , visible:false           },
                         {dataField:"serialNo"             ,headerText:"Serial No."      ,width:"20%"    ,height:30              },
                         {dataField:"crtDt"                ,headerText:"Create Date"      ,width:"13%"    ,height:30              },
                         {dataField:"crtUserId"           ,headerText:"Create User"      ,width:120   ,height:30   , visible:false          },
                         
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

var serialop = {
        //rowIdField : "rnum",            
        editable : false,
        displayTreeOpen : true,
        //showRowCheckColumn : true ,
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
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , notlike:'US'};
    doGetComboData('/common/selectCodeList.do', paramdata, '','sttype', 'S' , 'f_change');
    doGetCombo('/logistics/stockMovement/selectStockMovementNo.do', '{groupCode:delivery}' , '','seldelno', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','tlocation', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '','flocation', 'S' , 'SearchListAjax');
    doDefCombo(amdata, '' ,'sam', 'S', '');
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumnLayout, serialop);
    
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    	var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
        AUIGrid.clearGridData(serialGrid);
        AUIGrid.resize(serialGrid,980,380); 
    	fn_ViewSerial(delno);
    	
    });
    
    AUIGrid.bind(listGrid, "cellEditBegin", function (event){
    });
    
    AUIGrid.bind(listGrid, "cellEditEnd", function (event){
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
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
    $("#gissue").click(function(){
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
        	doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
        	$('#grForm #gtype').val("GR");
        	$("#dataTitle").text("Good Receipt Posting Data");
        	$("#gropenwindow").show();
        }
    });
    $("#receiptcancel").click(function(){
        var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
        	for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].grcmplt == 'N'){
                    Common.alert('Can not cancel before wearing.');
                    return false;
                    break;
                }
            }
        	$('#grForm #gtype').val("RC");
        	$("#dataTitle").text("Receipt Cancel Posting Data");
            $("#gropenwindow").show();
        }
    });
    
});

function SearchListAjax() {
   
    var url = "/logistics/stockMovement/StockMoveSearchDeliveryList.do";
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
function grFunc(){
	var data = {};
	var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
	var check     = AUIGrid.getCheckedRowItems(listGrid);
	
	data.check   = check;
	data.checked = check;
	
	data.form    = $("#grForm").serializeJSON();
	Common.ajaxSync("POST", "/logistics/stockMovement/StockMovementGoodIssue.do", data, function(result) {
		
		if (result.rdata == '000'){
			if ($('#grForm #gtype').val() == "RC"){
				Common.ajaxSync("POST", "/logistics/stockMovement/StockMovementGoodIssue.do", data, function(result) {
	                Common.alert(result.message.message);
	            },  function(jqXHR, textStatus, errorThrown) {
	                try {
	                } catch (e) {
	                }
	                Common.alert("Fail : " + jqXHR.responseJSON.message);
	            });
			}else{
				Common.alert(result.message.message);
			}
	        
		}else{
			if ($('#grForm #gtype').val() == "RC"){
				Common.alert('GoodRecipt Cancel Fail.');
			}else{
				Common.alert('GoodRecipt Fail.');
			}
		}
        
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

function fn_ViewSerial(str){
	
    var data = { delno : str };
    
    Common.ajax("GET", "/logistics/stockMovement/StockMovementDeliverySerialView.do",
    		data,
    		function(result) {
		        AUIGrid.setGridData(serialGrid, result.data);
			    
		        $("#serialopenwindow").show();
		  
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
    <li>Stock Movement Goods Receipt</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Stock Movement Goods Receipt</h2>
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
                    <th scope="row">From Location</th>
                    <td>
                        <select class="w100p" id="tlocation" name="tlocation"></select>
                    </td>
                    <th scope="row">To Location</th>
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
            <li><p class="btn_grid"><a id="gissue"><span class="search"></span>Goods Receipt</a></p></li>
            <li><p class="btn_grid"><a id="receiptcancel"><span class="search"></span>Receipt Cancel</a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:350px"></div>

    </section><!-- search_result end -->
    
    <div class="popup_wrap" id="gropenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
		    <h1 id="dataTitle">Good Receipt Posting Data</h1>
		    <ul class="right_opt">
		        <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
		    </ul>
		</header><!-- pop_header end -->
		
		<section class="pop_body"><!-- pop_body start -->
		    <form id="grForm" name="grForm" method="POST">
		    <input type="hidden" name="gtype" id="gtype" value="GR">
		    <!-- <input type="text" name="gtype" id="gtype" value="GR">  -->
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
                    <th scope="row">GR Doc Date</th>
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
        <!-- Pop up: View Serial Of Delivery Number -->
       <div class="popup_wrap" id="serialopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">Good Receipt - Serial View</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        <form>
        <section class="pop_body"><!-- pop_body start -->
            <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div>
            </article><!-- grid_wrap end -->
        </section>
          </form>  
    </div>
    
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>

