<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

    .aui-grid-user-custom-left { text-align:left; }

    .mycustom-disable-color { color : #cccccc; }

    .aui-grid-body-panel table tr:hover { background:#D9E5FF; color:#000; }

    .aui-grid-main-panel .aui-grid-body-panel table tr td:hover { background:#D9E5FF; color:#000; }

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    var listGrid;

    var rescolumnLayout= [
	                             {dataField:"delno", headerText:"Delivery No.", width:170, height:30},
	                             {dataField:"delnoitm", headerText:"Item No.", width:90, height:30},
	                             {dataField:"itmcode", headerText:"Material Code", width:120, height:30},
                                 {dataField:"itmname", headerText:"Material Name", width:180, height:30},
	                             {dataField:"delqty", headerText:"Delivery Qty", width:120, height:30},
                                 {dataField:"giqty", headerText:"GI Qty", width:120, height:30},
                                 {dataField:"grqty", headerText:"GR Qty", width:120, height:30},
	                             {dataField:"reqstno", headerText:"STO/SMO", width:170, height:30},
			                     {dataField:"stktrans", headerText:"Stock Transaction", width:150, height:30},
			                     {dataField:"stkactivity", headerText:"MVT Type", width:180, height:30},
			                     {dataField:"frmloc", headerText:"From Location", width:220, height:30},
			                     {dataField:"toloc", headerText:"To Location", width:220, height:30},
			                     {dataField:"deldate", headerText:"Delivery Date", width:120, height:30},
			                     {dataField:"gidate", headerText:"GI Date", width:120, height:30},
			                     {dataField:"grdate", headerText:"GR Date", width:120, height:30},
			                     {dataField:"uom", headerText:"Unit of Measurement", width:130, height:30},
			                     {dataField:"status", headerText:"Status", width:120, height:30},
			                     {dataField:"stkqty", headerText:"STO/SMO Qty", width:120, height:30},
			                     {dataField:"gicom", headerText:"GI Completion", width:120, height:30},
			                     {dataField:"grcom", headerText:"GR Completion", width:120, height:30}
			                     ];

	var resop =
						{
						    rowIdField : "rnum",
						    editable : false,
						    fixedColumnCount : 3,
						    displayTreeOpen : true,
						    showRowCheckColumn : false,
						    enableCellMerge : true,
						    showStateColumn : false,
						    showBranchOnGrouping : false
						};

	var paramdataTransaction;
	var paramdataMovement;

	$(document).ready(function() {

		/**********************************
		*                      Header Setting
		**********************************/
		paramdataTransaction = { groupCode : '306', orderValue : 'CODE_ID', likeValue: 'U' };
		doGetComboData('/common/selectCodeList.do', paramdataTransaction, '', 'sttype', 'M', 'f_multiCombo');

		paramdataMovement = { groupCode : '308', orderValue : 'CODE_NAME', likeValue : 'U' };
		doGetComboData('/common/selectCodeList.do', paramdataMovement, '', 'smtype', 'M', 'f_multiCombo');

		doGetComboData('/logistics/stocktransfer/selectStockTransferNo.do', '{groupCode:delivery}', '', 'seldelno', 'S', '');
		/**********************************
		*                   Header Setting End
		***********************************/

	    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);

	    AUIGrid.bind(listGrid, "cellClick", function( event ) {});
	    AUIGrid.bind(listGrid, "cellDoubleClick", function(event) { });
	    AUIGrid.bind(listGrid, "ready", function(event) { });
	});

    /**********************************
     *                 Button Click Events
     **********************************/
	$(function(){

	    $('#search').click(function() {

	        SearchListAjax();

	    });

	    $("#download").click(function() {
	        GridCommon.exportTo("main_grid_wrap", 'xlsx', "Total Delivery No.");
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
	/**********************************
	 *             Button Click Events End
	 **********************************/

	function fn_itempopList(data) {

        var rtnVal = data[0].item;

	    if ($("#stype").val() == "flocation")
	    {
	        $("#flocation").val(rtnVal.locid);
	        $("#flocationnm").val(rtnVal.locdesc);
	    }
	    else
	    {
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

	    var url = "/logistics/TotalDelivery/SearchTotalDeliveryList.do";
	    var param = $('#searchForm').serializeJSON();

	    Common.ajax("POST" , url , param , function(data) {

	        AUIGrid.setGridData(listGrid, data.data);
	    });
	}

	function f_multiCombo() {
	    $(function() {
	        $('#sttype').change(function() {
	        }).multipleSelect({
	            selectAll : true,
	            width : '80%'
	        });
	        $('#smtype').change(function() {
	        }).multipleSelect({
	            selectAll : true,
	            width : '80%'
	        });
	    });
	}
</script>

<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Logistics</li>
	    <li>Report</li>
	    <li>Total Delivery No.</li>
	</ul>

<aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>Total Delivery No.</h2>
    <ul class="right_btns">
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
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
            <caption>Search Table</caption>

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
                    <td colspan="2">
                       <input type="text" class="w100p"  id="seldelno" name="seldelno">
                    </td>
                    <th scope="row">Stock Request Number</th>
                    <td colspan="2">
                       <input type="text" class="w100p"  id="stkreqstno" name="stkreqstno">
                    </td>
                </tr>
                <tr>
                    <th scope="row">MVT Type</th>
                    <td colspan="2">
                        <select id="smtype" name="smtype[]" class="w100p" /></select>
                    </td>
                    <th scope="row">Stock Transaction Type</th>
                    <td colspan="2">
                        <select id="sttype" name="sttype[]" class="w100p" /></select>
                    </td>
                </tr>

                <tr>
                    <th scope="row">From Location</th>
                    <td colspan="2">
                        <input type="hidden"  id="flocation" name="flocation">
                        <input type="text" class="w100p" id="flocationnm" name="flocationnm">

                    </td>
                    <th scope="row">To Location</th>
                    <td colspan="2">
                        <input type="hidden"  id="tlocation" name="tlocation">
                        <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                    </td>
                </tr>

                <tr>
                    <th scope="row">Delivery Date</th>
                    <td colspan="2">
                        <div class="date_set"><!-- date_set start -->
	                        <p><input id="crtsdt" name="crtsdt" type="text" title="Delivery Start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
	                        <span> To </span>
	                        <p><input id="crtedt" name="crtedt" type="text" title="Delivery End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row">Required Date</th>
                    <td colspan="2">
                        <div class="date_set"><!-- date_set start -->
	                        <p><input id="reqsdt" name="reqsdt" type="text" title="Required Start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
	                        <span> To </span>
	                        <p><input id="reqedt" name="reqedt" type="text" title="Required End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                </tr>

            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
        </ul>
        <div id="main_grid_wrap" class="mt10" style="height:430px"></div>

    </section><!-- search_result end -->

</section>

