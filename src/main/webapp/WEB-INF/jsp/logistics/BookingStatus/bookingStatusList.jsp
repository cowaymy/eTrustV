<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

	.aui-grid-user-custom-left { text-align:left; }

	.aui-grid-user-custom-right { text-align:right;}

	.mycustom-disable-color { color : #cccccc; }

	.aui-grid-body-panel table tr:hover { background:#D9E5FF; color:#000; }

	.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {background:#D9E5FF; color:#000;}

</style>

<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>

<script type="text/javaScript" language="javascript">

	var myGridID;

    var columnLayout = [
	                            {dataField:"reqstno" ,headerText:"Request No.",width:240 ,height:30},
	                            {dataField:"seq" ,headerText:"Item No.",width:90 ,height:30},
	                            {dataField:"stkactivity" ,headerText:"Stock Activity",width:180 ,height:30},
	                            {dataField:"reqstdate" ,headerText:"Request Date",width:130 ,height:30},
                                {dataField:"frmloc", headerText:"From Location", width:230, height:30},
                                {dataField:"toloc", headerText:"To Location", width:230, height:30},
                                {dataField:"itmcode", headerText:"Material Code", width:120, height:30},
                                {dataField:"itmname", headerText:"Material Name", width:220, height:30},
                                {dataField:"reqstqty", headerText:"Request Qty", width:100, height:30},
	                            {dataField:"status" ,headerText:"Status",width:90 ,height:30},
	                            ];

    var gridPros =
                           {
							   editable : false,
							   displayTreeOpen : true,
							   showRowCheckColumn : false,
							   showStateColumn : false,
							   showBranchOnGrouping : false
						   };

    var paramdataMovement;

    $(document).ready(function() {

        paramdataMovement = { groupCode : '308', orderValue : 'CODE_NAME', likeValue : '' };
        doGetComboData('/common/selectCodeList.do', paramdataMovement, '', 'smtype', 'M', 'f_multiCombo');

        myGridID = AUIGrid.create("#main_grid_wrap", columnLayout, gridPros);

        AUIGrid.bind(myGridID, "cellClick", function( event ) {});
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) { });
        AUIGrid.bind(myGridID, "ready", function(event) { });

    });

    $(function() {

        doDefCombo([{"codeId": "Y","codeName": "Y"},{"codeId": "N","codeName": "N"}], '' ,'status', 'S', '');

        $("#search").click(function() {

            searchAjax();

        });

        $("#srchmaterial").keypress(function(event) {

        	$('#itmCode').val('');

            if (event.which == '13')
            {
                $("#stype").val('search');
                $("#svalue").val($("#srchmaterial").val());
                $("#sUrl").val("/logistics/material/materialcdsearch.do");

                Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
            }
        });

        $("#tlocationnm").keypress(function(event) {

            $('#tlocation').val('');

            if (event.which == '13')
            {
                $("#stype").val('tlocation');
                $("#svalue").val($('#tlocationnm').val());
                $("#sUrl").val("/logistics/organization/locationCdSearch.do");

                Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
            }
        });

        $("#flocationnm").keypress(function(event) {

            $('#flocation').val('');

            if (event.which == '13')
            {
                $("#stype").val('flocation');
                $("#svalue").val($('#flocationnm').val());
                $("#sUrl").val("/logistics/organization/locationCdSearch.do");

                Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
            }
        });

    });

    function fn_itempopList(data) {

        var rtnVal = data[0].item;

        if ($("#stype").val() == "search")
        {
        	$("#itmCode").val(rtnVal.itemcode);
            $("#srchmaterial").val(rtnVal.itemcode + ' - ' + rtnVal.itemname);
        }
        else if ($("#stype").val() == "flocation")
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

    function searchAjax() {

        if ($("#flocationnm").val() == "")
        {
            $("#flocation").val('');
        }
        if ($("#tlocationnm").val() == "")
        {
            $("#tlocation").val('');
        }
        if ($("#srchmaterial").val() == "")
        {
            $("#itmCode").val('');
        }


        if ($("#flocation").val() == "")
        {
            $("#flocation").val($("#flocationnm").val());
        }
        if ($("#tlocation").val() == "")
        {
            $("#tlocation").val($("#tlocationnm").val());
        }
        if ($("#itmCode").val() == "")
        {
            $("#itmCode").val($("#srchmaterial").val());
        }

	    var url = "/logistics/BookingStatus/searchBookingStatusList.do";
	    var param = $('#searchForm').serializeJSON();

	    Common.ajax("POST", url, param, function(data) {

	        AUIGrid.setGridData(myGridID, data.dataList);
	    });
	}

    function f_multiCombo() {
        $(function() {
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
	    <li>Booking Status</li>
	</ul>

	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Booking Status</h2>
	</aside><!-- title_line end -->

	<aside class="title_line"><!-- title_line start -->
    <ul class="right_btns">
            <li><p class="btn_blue2 big"><a id="search"><span class="search"></span>Search</a></p></li>
    </ul>
	</aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->

        <form id="searchForm" name="searchForm">

	        <input type="hidden" id="svalue" name="svalue"/>
	        <input type="hidden" id="sUrl"   name="sUrl"  />
	        <input type="hidden" id="stype"  name="stype" />
            <input type="hidden" id="searchtype" name="searchtype"/>

            <table summary="search table" class="type1"><!-- table start -->
				<caption>table</caption>

				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:140px" />
				    <col style="width:*" />
				</colgroup>

				<tbody>
					<tr>
					    <th scope="row">Material Code</th>
					    <td colspan="3">
					        <input type="hidden"  id="itmCode" name="itmCode">
					        <input type="text" placeholder="Press 'Enter' to Search" id="srchmaterial" name="srchmaterial"  class="w100p" />
					    </td>

                        <th scope="row">Stock Request No.</th>
                        <td colspan="3">
                            <input type="text" id="stkreqstno" name="stkreqstno"  class="w100p" />
                        </td>
					</tr>
                    <tr>
                        <th scope="row">From Location</th>
                        <td colspan="3">
                            <input type="hidden"  id="flocation" name="flocation">
                            <input type="text" placeholder="Press 'Enter' to Search" class="w100p" id="flocationnm" name="flocationnm">
                        </td>

                        <th scope="row">To Location</th>
                        <td colspan="3">
                            <input type="hidden"  id="tlocation" name="tlocation">
                            <input type="text" placeholder="Press 'Enter' to Search" class="w100p" id="tlocationnm" name="tlocationnm">
                        </td>
                    </tr>
					<tr>
					    <th scope="row">Stock Activity Type</th>
                        <td colspan="2">
                            <select class="multy_select" multiple="multiple" id="smtype" name="smtype[]" class="w100p" /></select>
                        </td>

                        <th scope="row">Request Date</th>
                        <td colspan="2">
                            <div class="date_set"><!-- date_set start -->
                                <p>
                                  <input id="srchcrtdtfrom" name="srchcrtdtfrom" type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                                    <span>~</span>
                                <p>
                                   <input id="srchcrtdtto" name="srchcrtdtto" type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                            </div><!-- date_set end -->
                        </td>

                        <th scope="row">Completion Status</th>
                        <td>
                            <select  id="status" name="status" class="w100p" ></select>
                        </td>
				    </tr>
			    </tbody>

			</table><!-- table end -->

        </form>

	</section><!-- search_table end -->

	<section class="search_result"><!-- search_result start -->

	    <div id="main_grid_wrap" class="mt10" style="height:400px"></div>

	</section><!-- search_result end -->

</section><!-- content end -->
