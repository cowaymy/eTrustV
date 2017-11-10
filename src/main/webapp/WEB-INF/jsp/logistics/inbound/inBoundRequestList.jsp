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
var subGrid;

var rescolumnLayout=[
 /*                    
							{dataField:"impNo" ,headerText:"impNo",width:120 ,height:30,editable:false},
							{dataField:"invNo" ,headerText:"invNo",width:120 ,height:30,editable:false},
							{dataField:"blNo" ,headerText:"blNo",width:120 ,height:30,editable:false},
							{dataField:"plant" ,headerText:"plant",width:120 ,height:30,editable:false},
							{dataField:"accNo" ,headerText:"accNo",width:120 ,height:30,editable:false},
							{dataField:"invCrtDt" ,headerText:"invCrtDt",width:120 ,height:30,editable:false},
							{dataField:"shipDt" ,headerText:"shipDt",width:120 ,height:30,editable:false},
							{dataField:"grDt" ,headerText:"grDt",width:120 ,height:30,editable:false},
							{dataField:"apCmplt" ,headerText:"apCmplt",width:120 ,height:30,editable:false},
							{dataField:"grCmplt" ,headerText:"grCmplt",width:120 ,height:30,editable:false},
							{dataField:"delFlag" ,headerText:"delFlag",width:120 ,height:30,editable:false},
							//{dataField:"blNo" ,headerText:"blNo",width:120 ,height:30,editable:false},
							//{dataField:"invNo" ,headerText:"invNo",width:120 ,height:30,editable:false},
							{dataField:"itmSeq" ,headerText:"itmSeq",width:120 ,height:30,editable:false},
							{dataField:"purDocNo" ,headerText:"purDocNo",width:120 ,height:30,editable:false},
							{dataField:"purItmQty" ,headerText:"purItmQty",width:120 ,height:30,editable:false},
							{dataField:"reqQty" ,headerText:"Req Qty",width:120 ,height:30},
							{dataField:"matrlNo" ,headerText:"matrlNo",width:120 ,height:30,editable:false},
							{dataField:"freeItm" ,headerText:"freeItm",width:120 ,height:30,editable:false},
							{dataField:"importCd" ,headerText:"importCd",width:120 ,height:30,editable:false},
							{dataField:"wty" ,headerText:"wty",width:120 ,height:30,editable:false},
							{dataField:"uom" ,headerText:"uom",width:120 ,height:30,editable:false},
							{dataField:"delFlagD" ,headerText:"delFlagD",width:120 ,height:30,editable:false}
*/
							 {dataField:"whLocId" ,headerText:"whLocId",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"whLocCode" ,headerText:"whLocCode",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"whLocDesc" ,headerText:"whLocDesc",width:120 ,height:30,editable:false
                              ,cellMerge : true  },
							 {dataField:"plant" ,headerText:"plant",width:120 ,height:30,editable:false},
							 {dataField:"blNo" ,headerText:"blNo",width:120 ,height:30,editable:false,
                              cellMerge : true,
                              mergeRef : "whLocDesc", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                              mergePolicy : "restrict"     },
							 {dataField:"itmSeq" ,headerText:"itmSeq",width:120 ,height:30,editable:false},
							 {dataField:"stkid" ,headerText:"stkid",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"matrlNo" ,headerText:"matrlNo",width:120 ,height:30,editable:false},
							 {dataField:"stkTypeId" ,headerText:"stkTypeId",width:120 ,height:30,editable:false},
							 {dataField:"typename" ,headerText:"typename",width:120 ,height:30,editable:false},
							 {dataField:"stkCtgryId" ,headerText:"stkCtgryId",width:120 ,height:30,editable:false},
							 {dataField:"ctgryname" ,headerText:"ctgryname",width:120 ,height:30,editable:false},
							 {dataField:"stkdesc" ,headerText:"stkdesc",width:120 ,height:30,editable:false},
							 {dataField:"uom" ,headerText:"uom",width:120 ,height:30,editable:false, visible:false},
							 {dataField:"uomnm" ,headerText:"UOM",width:120 ,height:30,editable:false},
							 {dataField:"qty" ,headerText:"qty",width:120 ,height:30,editable:false},
							 {dataField:"reqedQty" ,headerText:"reqedQty",width:120 ,height:30,editable:false},
							 {dataField:"avrqty" ,headerText:"avrqty",width:120 ,height:30,editable:false},
							 {dataField:"reqQty" ,headerText:"Req Qty",width:120 ,height:30}
							];


var reqop = {
		            enableCellMerge : true,
					showRowCheckColumn : true ,
					editable : true,
					usePaging : false ,
					showStateColumn : false
		         };

$(document).ready(function(){
    
   //doGetComboData('/logistics/inbound/InboundLocationPort', '', '','location', 'A' , '');
   doGetCombo('/logistics/inbound/InboundLocation', 'port', '','location', 'S' , ''); 
   listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, reqop);
   subGrid  = AUIGrid.create("#sub_grid_wrap", rescolumnLayout, reqop);
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
    
});
$(function(){
    $('#search').click(function() {
        SearchListAjax();
    });
    $('#insert').click(function(){
        setToCdc();
    });
    $('#save').click(function(){
        createSMO();
    });
});
 
    
function SearchListAjax() {
    var url = "/logistics/inbound/InBoundList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
    	console.log(data);
        AUIGrid.setGridData(listGrid, data.dataList);
    });
}

function setToCdc(){
    var selectedItem = AUIGrid.getSelectedIndex(listGrid);
    var whLocId =AUIGrid.getCellValue(listGrid ,selectedItem[0] ,'whLocId');
	doGetCombo('/logistics/inbound/InboundLocation', 'port', whLocId,'flocation', 'S' , ''); 
	doGetCombo('/logistics/inbound/InboundLocation', '', '','tlocation', 'S' , ''); 
	$("#popup_wrap").show();
}
function createSMO(){
	var data = {};
	var check   = AUIGrid.getCheckedRowItems(listGrid);
	data.checked = check;
	data.form    = $("#giForm").serializeJSON();
    var url = "/logistics/inbound/reqSMO.do";
    console.log(data);
    Common.ajax("POST" , url , data , function(data){
        //console.log(data);
        //AUIGrid.setGridData(listGrid, data.dataList);
    /*     Common.alert(result.message , SearchListAjax);
        AUIGrid.resetUpdatedItems(listGrid, "all");    
    $("#giopenwindow").hide();
    $('#search').click(); */
	    console.log(data);
    	Common.alert("Created : "+data.data);
        $("#popup_wrap").hide();
    });
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>InBound</li>
    <li>View - Request</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>InBound's SMO Request List</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3></h3>
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
                        <select class="w100p" id="location" name="location"><option value=''>Choose One</option></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">GR Date</th>
                    <td>
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="grsdt" name="grsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="gredt" name="gredt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">B/L Date</th>
                    <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="blsdt" name="blsdt" type="text" title="Create start Date"   placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="bledt" name="bledt" type="text" title="Create End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="status" name="status">
                           <option value="N"  selected="selected">Not Yet</option>
                           <option value="D">Done</option>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="insert"><span class="search"></span>Create SMO</a></p></li>            
        </ul>

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <div id="main_grid_wrap" class="mt10" style="height:300px"></div>
        

    </section><!-- search_result end -->
    <section class="search_result"><!-- search_result start -->
        <div id="sub_grid_wrap" class="mt10" style="height:300px"></div>
    </section><!-- search_result end -->
        
            
</section>
</section>


<div id="popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title">Create SMO</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form id="giForm" name="giForm" method="POST">
            <input type="hidden" name="gtype" id="gtype" value="GI"/>
            <input type="hidden" name="serialqty" id="serialqty"/>
            <input type="hidden" name="reqstno" id="reqstno"/>
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
                    <th scope="row">From Location</th>
                    <td>
                         <select class="w100p" id="flocation" name="flocation"></select> 
                    </td>
                    <th scope="row">To Location</th>
                    <td >
                        <select class="w100p" id="tlocation" name="tlocation"></select>
                    </td>
                </tr>
            </tbody>
            </table>
            </form>
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="save">SAVE</a></p></li>
                <!-- <li><p class="btn_blue2 big"><a id="cancel">CANCEL</a></p></li> -->
            </ul>
</section><!-- pop_body end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</div><!-- popup_wrap end -->