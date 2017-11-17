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
var myGridID;
var detailGridID;

// AUIGrid 칼럼 설정                                                                            visible : false
var columnLayout = [{dataField:"matrlNo"             ,headerText:"Material Code"              ,width:120    ,height:30 , visible:true},
                    {dataField:"stkDesc"             ,headerText:"Material Code Text"         ,width:120    ,height:30 , visible:true},
                    {dataField:"revStorgNm"          ,headerText:"From Sloc"                  ,width:120    ,height:30 , visible:true},
                    {dataField:"reqStorgNm"          ,headerText:"To Sloc"                    ,width:120    ,height:30 , visible:true},
                    {dataField:"trantype"            ,headerText:"Transaction Type Text"      ,width:120    ,height:30 , visible:true},
                    {dataField:"invntryMovType"      ,headerText:"Movemen type"               ,width:120    ,height:30 , visible:true},
                    {dataField:"movtype"             ,headerText:"Movement Text"              ,width:120    ,height:30 , visible:true},
                    {dataField:"qty"                 ,headerText:"Qty"                        ,width:"8%"   ,height:30 , visible:true},
                    {dataField:"matrlDocNo"          ,headerText:"Material Documents"         ,width:120    ,height:30 , visible:true},
                    {dataField:"matrlDocItm"         ,headerText:"Item"                       ,width:120    ,height:30 , visible:true},
                    {dataField:"postingdate"         ,headerText:"Posting date"               ,width:120    ,height:30 , visible:true},
                    {dataField:"delvryNo"            ,headerText:"Delivery No"                ,width:120    ,height:30 , visible:true},
                    {dataField:"debtCrditIndict"     ,headerText:"Debit/Credit"               ,width:120    ,height:30 , visible:true},
                    {dataField:"autoCrtItm"          ,headerText:"Auto/Manual"                ,width:120    ,height:30 , visible:true},
                    {dataField:"codeName"            ,headerText:"Unit of Measure"            ,width:"15%"  ,height:30 , visible:true},
                    {dataField:""                    ,headerText:""                           ,width:"15%"  ,height:30 , visible:false},
                    {dataField:"dcfreqapproveremark" ,headerText:"DCFReqApproveRemark"        ,width:"15%"  ,height:30 , visible:false},
                    {dataField:"dcfreqapproveby"     ,headerText:"DCFReqApproveBy"            ,width:"15%"  ,height:30 , visible:false},
                    {dataField:"reasondesc1"         ,headerText:"Reason (Approver Verified)" ,width:"15%"  ,height:30 , visible:false},
                    {dataField:"c7"                  ,headerText:"Approval Status"            ,width:"15%"  ,height:30 , visible:false},
                    {dataField:"c2"                  ,headerText:"Approve At"                 ,width:"15%"  ,height:30 , visible:false},
                    {dataField:"dcfreqstatusid"      ,headerText:"DCF_REQ_STUS_ID"            ,width:"15%"  ,height:30 , visible:false},
                   ];

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
var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var paramdata;
$(document).ready(function(){
	
    // masterGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("main_grid_wrap", columnLayout,"", gridoptions);
	
    /**********************************
    * Header Setting
    **********************************/
    paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};
    doGetComboData('/common/selectCodeList.do', paramdata, '','searchTrcType', 'S' , 'f_change');
    doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '','sstatus', 'S' , ''); 
//     doGetCombo('/common/selectStockLocationList.do', '', '','searchFromLoc', 'S' , 'SearchListAjax');//From Location 조회
//     doGetCombo('/common/selectStockLocationList.do', '', '','searchToLoc', 'S' , '');//To Location 조회

    
    AUIGrid.bind(myGridID, "cellClick", function( event ) {

    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){

    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
});




$(function(){
    $("#search").click(function() {
        SearchListAjax();
    });
    $("#clear").click(function() {
    	$('#searchCdc').val('');
    	$('#searchRdc').val('');
    	
    	$('#tlocationnm').val('');
    	$('#flocationnm').val('');
    	$('#searchMaterialCode').val('');
    	$('#searchTrcType').val('');
    	$('#searchMoveType').val('');
    	$('#PostingDt1').val('');
    	$('#PostingDt2').val('');
    	$('#CreateDt1').val('');
    	$('#CreateDt2').val('');
    	$('#searchCustomer').val('');
    	$('#searchVendor').val('');
    	$('#searchBatch').val('');
    	$('#searchUserNm').val('');
    });
    
    $("#searchTrcType").change(function(){
        paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#searchTrcType").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','searchMoveType', 'S' , '');
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


	function fn_itempopList(data) {

		var rtnVal = data[0].item;

		if ($("#stype").val() == "flocation") {
			$("#flocation").val(rtnVal.locid);
			$("#flocationnm").val(rtnVal.locdesc);
		} else {
			$("#tlocation").val(rtnVal.locid);
			$("#tlocationnm").val(rtnVal.locdesc);
		}

		$("#svalue").val();
	}

	function f_change() {
		$("#searchTrcType").change();
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

		var url = "/logistics/materialDoc/MaterialDocSearchList.do";
		var param = $('#searchForm').serializeJSON();
		Common.ajax("POST", url, param, function(data) {
			AUIGrid.setGridData(myGridID, data.data);

		});
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
<h2>New-Material Document List</h2>

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
                    <th scope="row">CDC</th>
                    <td>
                        <select class="w100p" id="searchCdc" name="searchCdc"></select>
                    </td>
                    <th scope="row">RDC</th>
                    <td>
                        <select class="w100p" id="searchRdc" name="searchRdc"></select>
                    </td>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <th scope="row">From Location</th>
                    <td>
                        <!-- <select class="w100p" id="searchFromLoc" name="searchFromLoc"></select> -->
                        <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                    </td>
                    <th scope="row">To Location</th>
                    <td>
                        <!-- <select class="w100p" id="searchToLoc" name="searchToLoc"></select> -->
                        <input type="hidden"  id="flocation" name="flocation">
                        <input type="text" class="w100p" id="flocationnm" name="flocationnm">
                    </td>
                     <td colspan="2">&nbsp;</td>
                </tr> 
                <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type="text" id="searchMaterialCode" name="searchMaterialCode" title="" placeholder="Material Code" class="w100p" />
                    </td>
                    <th scope="row">Stock Transaction Type</th>
                    <td>
                        <select class="w100p" id="searchTrcType" name="searchTrcType"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select class="w100p" id="searchMoveType" name="searchMoveType"><option value=''>Choose One</option></select>
                    </td>
                </tr>             
                <tr>
                    <th scope="row">Posting Date</th>
                    <td>
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="PostingDt1" name="PostingDt1" type="text" title="Posting start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="PostingDt2" name="PostingDt2" type="text" title="Posting End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">Create Date</th>
                    <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="CreateDt1" name="CreateDt1" type="text" title="Create start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="CreateDt2" name="CreateDt2" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row">Customer</th>
                    <td >
                        <input type="text" id="searchCustomer" name="searchCustomer" title="" placeholder="Customer" class="w100p" />
                    </td>              
                </tr>
                 <tr>
                    <th scope="row">Vendor</th>
                    <td>
                        <input type="text" id="searchVendor" name="searchVendor" title="" placeholder="Vendor" class="w100p" />
                    </td>
                    <th scope="row">Batch</th>
                    <td>
                        <input type="text" id="searchBatch" name="searchBatch" title="" placeholder="Batch" class="w100p" />
                    </td>
                    <th scope="row">User Name</th>
                     <td>
                        <input type="text" id="searchUserNm" name="searchUserNm" title="" placeholder="User Name" class="w100p" />
                    </td>
                </tr>      
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <!-- <li><p class="btn_grid"><a id="insert">INS</a></p></li> -->            
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:300px"></div>
        
    <!--    <div id="sub_grid_wrap" class="mt10" style="height:350px"></div>  -->

    </section><!-- search_result end -->
    
</section>

