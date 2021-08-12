<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

	.aui-grid-user-custom-left { text-align:left; }

	.mycustom-disable-color {color : #cccccc; }

	.aui-grid-body-panel table tr:hover { background:#D9E5FF; color:#000; }

	.aui-grid-main-panel .aui-grid-body-panel table tr td:hover { background:#D9E5FF; color:#000; }

</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

	var myGridID;
	var detailGridID;

    var columnMainLayout = [
                                                {dataField:"mainloc", headerText:"Storage Location", width:270, height:30},
                                                {dataField:"loccode", headerText:"Storage Location Code", width:120, height:30, visible:false},
                                                {dataField:"itmcode", headerText:"Mat. Code", width:110, height:30},
                                                {dataField:"itmdesc", headerText:"Mat. Name", width:300, height:30},
                                                {dataField:"baseqty", headerText:"Base Qty", width:90, height:30},
                                                {dataField:"currqty", headerText:"Current Qty", width:100, height:30},
                                                {dataField:"itmtype", headerText:"Mat. Type", width:110, height:30},
                                                {dataField:"itmctgry", headerText:"Mat. Category", width:120, height:30},
                                                {dataField:"uom", headerText:"UOM", width:70, height:30}
                                            ];

    var columnSubLayout = [
							                  {dataField:"reqststorg", headerText:"Storage Loc.", width:270, height:30},
							                  {dataField:"rcivstorg", headerText:"Receive Storage Loc.", width:270, height:30},
							                  {dataField:"transtype", headerText:"Trans. Type", width:120, height:30},
							                  {dataField:"movetype", headerText:"Movement Type", width:190, height:30},
							                  {dataField:"qty", headerText:"Qty", width:60, height:30},
							                  {dataField:"newqty", headerText:"nQty", width:60, height:30},
							                  {dataField:"docno", headerText:"Mat. Doc No.", width:150, height:30},
							                  {dataField:"docnoitm", headerText:"Doc Item", width:80, height:30},
							                  {dataField:"postingdt", headerText:"Posting Date", width:120, height:30},
							                  {dataField:"delvryno", headerText:"Delivery No.", width:120, height:30},
							                  {dataField:"refdocno", headerText:"Ref. Doc No.", width:120, height:30},
							                  {dataField:"reqstno", headerText:"Request No.", width:120, height:30},
							                  {dataField:"debitcrdt", headerText:"Debit/Credit", width:110, height:30}
							              ];


    var gridMainOptions = {
								            showStateColumn : false ,
								            editable : false,
								            usePaging : false,
								            useGroupingPanel : false
							            };

	var gridSubOptions = {
									       showStateColumn : false ,
										   editable : false,
										   usePaging : false,
										   useGroupingPanel : false
									   };

    var paramDataTrans;
    var paramDataMvt;

    var currentDate = new Date();
    var dd = currentDate.getDate();
    var mm = currentDate.getMonth() + 1;
    var yyyy = currentDate.getFullYear();

    if(dd < 10) { dd = '0' + dd; }

    if(mm < 10) { mm = '0' + mm; }

    $(document).ready(function() {

        myGridID = GridCommon.createAUIGrid("main_grid_wrap", columnMainLayout, "",  gridMainOptions);
        detailGridID = GridCommon.createAUIGrid("sub_grid_wrap", columnSubLayout, "",  gridSubOptions);

	    /**********************************
	                           Header Setting
	    **********************************/
	    $("#currmth").text('01' + '/' + mm + '/' + yyyy);

	    var prvDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1);
        var prvmm = prvDate.getMonth() + 1;
        var prvyyyy = prvDate.getFullYear();

        if(prvmm < 10) { prvmm = '0' + prvmm; }

        $("#prvmth").text('01' + '/' + prvmm + '/' + prvyyyy);

	    var baseDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1);
	    var baseMth = baseDate.getMonth() + 1;
	    var baseYear = baseDate.getFullYear();

	    if(baseMth < 10) { baseMth = '0' + baseMth; }

	    $("#currmth").val(baseYear.toString() + baseMth.toString());

	    var prvBaseDate = new Date(baseDate.getFullYear(), baseDate.getMonth() - 1);
        var prvBaseMth = prvBaseDate.getMonth() + 1;
        var prvBaseYear = prvBaseDate.getFullYear();

        if(prvBaseMth < 10) { prvBaseMth = '0' + prvBaseMth; }

        $("#prvmth").val(prvBaseYear.toString() + prvBaseMth.toString());

	    paramDataTrans = { groupCode: '306', orderValue: 'CRT_DT', likeValue: '' };
	    paramDataMvt = { groupCode: '308', orderValue: 'CODE_ID', likeValue: '' };

	    CommonCombo.make("searchTrcType", "/common/selectCodeList.do", paramDataTrans, "", {id: "code", name: "codeName", type: "M"});
	    CommonCombo.make("searchMoveType", "/common/selectCodeList.do", paramDataMvt, "", { id: "code", name: "codeName", type: "M"});

	    doGetComboData('/common/selectCodeList.do', { groupCode: 339, orderValue: 'CODE'}, '', 'loctype', 'M',  'f_loctype');
	    doGetComboData('/common/selectCodeList.do', { groupCode: 383, orderValue: 'CODE'}, '', 'locgrade', 'A', '');

	    doGetCombo('/common/selectCodeList.do', '15', '', 'smattype', 'M' ,'f_multiCombos');
	    doGetCombo('/common/selectCodeList.do', '11', '', 'smatcate', 'M' ,'f_multiCombos');

	    AUIGrid.bind(myGridID, "cellClick", function(event) { });

	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {

            if (event.rowIndex > -1)
            {
                fn_loadDetails(event.rowIndex, event.columnIndex);

                $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
            }
            else
            {
                Common.alert('Please select a row first.');
            }
	    });

	    AUIGrid.bind(myGridID, "ready", function(event) { });

    });


    $(function() {

        $("#postingdt").datepicker( {

            minDate: $("#basedt :selected").text(),
            maxDate: currentDate

        });

        $("#postingdt").datepicker("option", "dateFormat", "dd/mm/yy");

        $("#postingdt").val(dd + '/' + mm + '/' + yyyy);

	    $("#search").click(function() {

	        SearchListAjax();
	    });

	    $("#clear").click(function() {

	    });

	    $("#download").click(function() {

	        GridCommon.exportTo("main_grid_wrap", 'xlsx', "Stock Balance Card List");
	    });

	    $("#searchTrcType").change(function() {

	        CommonCombo.make("searchMoveType", "/logistics/materialDoc/selectTrntype.do", $("#modForm").serialize(), "",
										       { id: "code", name: "codeName", type: "M"});
        });

	    $("#searchMaterialCode").keypress(function(event) {

	    	if (event.which == '13')
	    	{
	            $("#stype").val('stock');
	            $("#svalue").val($('#searchMaterialCode').val());
	            $("#sUrl").val("/logistics/material/materialcdsearch.do");

	            Common.searchpopupWin("searchForm", "/common/searchPopList.do", "stock");
            }
        });

	    $('#locgrade').change(function() {

	        var searchlocgb = $('#loctype').val();

	        var locgbparam = "";
	        for (var i = 0; i < searchlocgb.length; i++)
	        {
	            if (locgbparam == "")
	            {
	                locgbparam = searchlocgb[i];
	            }
	            else
	            {
	                locgbparam = locgbparam +"∈"+ searchlocgb[i];
	            }
	        }

	        var param = { searchlocgb: locgbparam, grade: $('#locgrade').val() }

	        doGetComboData('/common/selectStockLocationList2.do', param , '', 'locname', 'M', 'f_multiComboType');

        });
    });

    function f_loctype()
    {
    	$(function() { $('#loctype').change(function() {

    	    if ($('#loctype').val() != null && $('#loctype').val() != "")
    	    {
    	        var searchlocgb = $('#loctype').val();

                var locgbparam = "";
                for (var i = 0 ; i < searchlocgb.length ; i++)
                {
                    if (locgbparam == "")
                    {
                        locgbparam = searchlocgb[i];
                    }
                    else
                    {
                        locgbparam = locgbparam +"∈"+ searchlocgb[i];
                    }
                }

                var param = { searchlocgb: locgbparam, grade: $('#locgrade').val() }

                doGetComboData('/common/selectStockLocationList2.do', param, '', 'locname', 'M', 'f_multiComboType');
            }
        }).multipleSelect( {selectAll: true });
        });
    }

    function f_multiComboType()
    {
        $(function() {

        	$('#locname').change(function() {
        	}).multipleSelect({ selectAll: true });

        });
    }

    function f_multiCombos()
    {
        $(function() {

	        $('#smattype').change(function() {
	        }).multipleSelect({ selectAll: true });

	        $('#smatcate').change(function() {
	        }).multipleSelect({ selectAll: true });

        });
    }

    function fn_itempopList(data)
    {
        var rtnVal = data[0].item;

        $("#searchMaterialCode").val(rtnVal.itemcode);

        $("#svalue").val('');
    }

    function fn_loadDetails(rowID, colID) {

        $("#detailStkCode").val(AUIGrid.getCellValue(myGridID, rowID, 'itmcode'));
        $("#detailLocCode").val(AUIGrid.getCellValue(myGridID, rowID, 'loccode'));
        $("#detailBaseQty").val(AUIGrid.getCellValue(myGridID, rowID, 'baseqty'));

        fn_searchDetails();

        $("#itmHeader").text("Material: " + $("#detailStkCode").val() + ' - ' + AUIGrid.getCellValue(myGridID, rowID, 'itmdesc'));

        $("#detailWindow").show();
        AUIGrid.resize(detailGridID);

    }

    function fn_searchDetails() {

        var url = "/logistics/stockbalance/selectStockBalanceDetailsList.do";
        var param = $('#modForm').serialize();

        Common.ajax("GET", url, param, function(data) {

            var gridData = data;

            AUIGrid.setGridData(detailGridID, gridData.data);



        });


    }

    function SearchListAjax()
    {

        var url = "/logistics/stockbalance/stockBalanceSearchList.do";
        var param = $('#searchForm').serialize();

        Common.ajax("GET", url, param, function(data) {

        	$("#detailBaseDt").val($("#basedt :selected").text())

            AUIGrid.setGridData(myGridID, data.data);
        });
    }

</script>

<section id="content">

	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Logistics</li>
	    <li>Report</li>
	    <li>Stock Balance List</li>
	</ul>

	<aside class="title_line">
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Stock Balance List</h2>
	</aside><!-- title_line end -->

	<aside class="title_line">

	    <ul class="right_btns">
	        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	        <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
	        </c:if>
	       <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
	    </ul>
	</aside>

    <section class="search_table">

        <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">

	        <input type="hidden" id="svalue" name="svalue"/>
	        <input type="hidden" id="sUrl"   name="sUrl"  />
	        <input type="hidden" id="stype"  name="stype" />

            <table summary="search table" class="type1">

	            <caption>search table</caption>

	            <colgroup>
	                <col style="width:150px" />
	                <col style="width:200px" />
	                <col style="width:150px" />
	                <col style="width:170px" />
	                <col style="width:150px" />
	                <col style="width:*" />
	            </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">From Posting Date</th>
                        <td>
                             <select id="basedt" name="basedt" class="w100p" >
                                <option id="currmth" selected></option>
                                <option id="prvmth"></option>
                             </select>
	                    </td>
	                </tr>
 	                <tr>
	                    <th scope="row">Location Type</th>
	                    <td>
	                        <select id="loctype" name="loctype" class="multy_select w100p" multiple="multiple"></select>
	                    </td>
	                    <th scope="row">Location Grade</th>
	                    <td>
	                        <select id="locgrade" name="locgrade" class="select w100p"></select>
	                    </td>
	                    <th scope="row">Location</th>
	                    <td>
	                        <select id="locname" name="locname" class="multy_select w100p" multiple="multiple"><option>Select Location Type First</option></select>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">Material Code</th>
	                    <td>
	                        <input type="text" id="searchMaterialCode" name="searchMaterialCode" title="" placeholder="Material Code" class="w100p" />
	                    </td>
	                    <th scope="row">Material Type</th>
	                    <td>
	                        <select id="smattype" name="smattype" class="multy_select w100p" multiple="multiple"></select>
	                    </td>
	                    <th scope="row">Material Category</th>
	                    <td>
	                        <select id="smatcate" name="smatcate" class="multy_select w100p" multiple="multiple"></select>
	                    </td>
	                </tr>
                </tbody>
            </table>
        </form>
    </section>


    <section class="search_result">

        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
            </c:if>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:400px"></div>

    </section>

    <div class="popup_wrap" id="detailWindow" style="display:none"><!-- popup_wrap start -->

        <header class="pop_header">

            <h1 id="itmHeader"></h1>
                <ul class="right_opt">
                    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
                </ul>

        </header>

        <section class="pop_body"><!-- pop_body start -->

            <form id="modForm" name="modForm" method="post" onsubmit="return false;">

                <input type="hidden" id="detailStkCode" name="detailStkCode">
                <input type="hidden" id="detailLocCode" name="detailLocCode">
                <input type="hidden" id="detailBaseDt" name="detailBaseDt">
                <input type="hidden" id="detailBaseQty" name="detailBaseQty">

                <table class="type1"><!-- table start -->

                    <caption>search table</caption>

                    <colgroup>
                    <col style="width:130px" />
                    <col style="width:110px" />
                    <col style="width:130px" />
                    <col style="width:170px" />
                    <col style="width:130px" />
                    <col style="width:290px" />
                    </colgroup>

                    <tbody>
                    <tr>
                        <th scope="row">To Posting Date</th>
                        <td>
                            <input id="postingdt"  name="postingdt" type="text" title="Posting Date" placeholder="DD/MM/YYYY" class="j_date">
                        </td>
                        <th scope="row">Transaction Type</th>
                        <td>
                            <select id="searchTrcType" name="searchTrcType" class="multy_select w100p" multiple="multiple"></select>
                        </td>
                        <th scope="row">Movement Type</th>
                        <td>
                            <select id="searchMoveType" name="searchMoveType" class="multy_select w100p" multiple="multiple"></select>
                        </td>
                        <td colspan="2">&nbsp;</td>
                     </tr>
                    </tbody>
                </table><!-- table end -->

                <ul class="center_btns">
                    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                    <li><p class="btn_blue2 big"><a onclick="javascript:fn_searchDetails();">Search</a></p></li>
                    </c:if>
                    <li></li>
                </ul>
                &nbsp;
                <div id="sub_grid_wrap" style="width:100%"></div>

            </form>
            <h3 id="TotalSum"></h3>
        </section>
    </div>
</section>